# Serialization always implicitly uses a `NativeLayout` as source.
# Deserialization always implicitly uses a `NativeLayout` as target.

concrete_datasize(layout, data) = datasize(layout, typeof(data))
concrete_datasize(layout, data::Vector{T}) where {T} = length(data) * stride(layout, T) - (stride(layout, T) - datasize(layout, T))

function serialize(data, layout::LayoutStrategy)
  bytes = UInt8[]
  sizehint!(bytes, concrete_datasize(layout, data))
  serialize!(bytes, data, layout)
  bytes
end

function serialize(data::Union{T,Vector{T}}, layout::NativeLayout) where {T}
  if isbitstype(T)
    arr = isa(data, T) ? [data] : data
    GC.@preserve arr begin
      ptr = pointer(arr)
      return unsafe_wrap(Array{UInt8}, Ptr{UInt8}(ptr), Base.elsize(Vector{T}) * length(arr))
    end
  end
  @invoke serialize(data, layout::LayoutStrategy)
end

function serialize!(bytes, data::T, layout::LayoutStrategy) where {T}
  isprimitivetype(T) && return serialize_primitive!(bytes, data)
  for i in 1:fieldcount(T)
    # Add padding, if necessary.
    pad!(bytes, padding(layout, T, i))
    # Recursively serialize fields.
    serialize!(bytes, getfield(data, i), layout)
  end
end

fast_append!(bytes, x::UInt8) = push!(bytes, x)
fast_append!(bytes, x::UInt16) = push!(bytes, x % UInt8, x >> 8 % UInt8)
function fast_append!(bytes, x::UInt32)
  fast_append!(bytes, x % UInt16)
  fast_append!(bytes, x >> 16 % UInt16)
end
function fast_append!(bytes, x::UInt64)
  fast_append!(bytes, x % UInt32)
  fast_append!(bytes, x >> 32 % UInt32)
end
function databytes(data::T) where {T}
  s = sizeof(T)
  s == 0 && return
  s == 1 ? reinterpret(UInt8, data) : s == 2 ? reinterpret(UInt16, data) : s == 4 ? reinterpret(UInt32, data) : s == 8 ? reinterpret(UInt64, data) : s == 16 ? reinterpret(UInt128, data) : error("Expected size of 8, 16, 32 or 64")
end

serialize_primitive!(bytes, data) = fast_append!(bytes, databytes(data))

function pad!(bytes, amount)
  for _ in 1:amount
    push!(bytes, 0x00)
  end
  bytes
end

serialize!(bytes, data::Vector{UInt8}, ::LayoutStrategy) = append!(bytes, data)
function serialize!(bytes, data::Vector{T}, layout::LayoutStrategy) where {T}
  pad = padding(layout, typeof(data))
  iszero(pad) && isprimitivetype(data) && return append!(bytes, reinterpret(UInt8, data))
  for x in data
    serialize!(bytes, x, layout)
    pad!(bytes, pad)
  end
end

# VulkanLayout-specific serialization rules.
# This is mostly to work around the fact that array/vector/matrix types
# are composite types and we do not support looking into their (only) tuple component.
function serialize!(bytes, data::T, layout::VulkanLayout) where {T<:Mat}
  t = layout[T]::MatrixType
  vectype = eltype_major(t)
  payload = data.cols
  if !t.is_column_major
    payload = reinterpret(NTuple{nrows(T), NTuple{ncols(T), eltype(T)}}, [payload])[]
  end
  s = stride(layout, vectype)
  padding = s - datasize(layout, vectype)
  for row_or_col in payload
    serialize!(bytes, row_or_col, NoPadding())
    pad!(bytes, padding)
  end
end
serialize!(bytes, data::Vec, layout::VulkanLayout) = serialize!(bytes, data.data, NoPadding())
function serialize!(bytes, data::T, layout::VulkanLayout) where {T<:Arr}
  t = layout[T]::ArrayType
  s = stride(layout, t.eltype)
  padding = s - datasize(layout, t.eltype)
  for el in data
    serialize!(bytes, el, layout)
    pad!(bytes, padding)
  end
end

function deserialize(::Type{T}, bytes, from::LayoutStrategy) where {T}
  isprimitivetype(T) && return reinterpret(T, bytes)[]
  ismutabletype(T) && return deserialize_mutable(T, bytes, from)
  isstructtype(T) && return deserialize_immutable(T, bytes, from)
  error("Expected one of primitive, mutable or composite type, got $T")
end
function deserialize(::Type{Vector{T}}, bytes, from::LayoutStrategy) where {T}
  res = T[]
  i = 0
  s = stride(from, T)
  size = datasize(from, T)
  while i * s + size ≤ length(bytes)
    elbytes = @view bytes[(1 + i * s):(i * s + size)]
    push!(res, deserialize(T, elbytes, from))
    i += 1
  end
  res
end
function deserialize_mutable(::Type{T}, bytes, from::LayoutStrategy) where {T}
  x = ccall(:jl_new_struct_uninit, Any, (Any,), T)
  for (i, subT) in enumerate(fieldtypes(T))
    xx = deserialize(subT, field_bytes(T, i, bytes, from), from)
    ccall(:jl_set_nth_field, Cvoid, (Any, Csize_t, Any), x, i - 1, xx)
  end
  x::T
end
function deserialize_immutable(::Type{T}, bytes, from::LayoutStrategy) where {T}
  fields = Any[deserialize(subT, field_bytes(T, i, bytes, from), from) for (i, subT) in enumerate(fieldtypes(T))]
  ccall(:jl_new_structv, Any, (Any, Ptr{Any}, UInt32), T, fields, fieldcount(T))::T
end
function field_bytes(::Type{T}, i, bytes, layout::LayoutStrategy) where {T}
  offset = dataoffset(layout, T, i)
  @view(bytes[(1 + offset):(datasize(layout, fieldtype(T, i)) + offset)])
end

deserialize(::Type{T}, bytes, from::VulkanLayout) where {T<:Vec} = deserialize(T, bytes, NoPadding())
function deserialize(T::Type{Arr{N,AT}}, bytes, from::VulkanLayout) where {N,AT}
  t = from[T]::ArrayType
  s = stride(from, t.eltype)
  size = datasize(from, AT)
  T(ntuple(i -> deserialize(AT, @view(bytes[(1 + (i - 1) * s):((i - 1) * s + size)]), from), N))
end
function deserialize(T::Type{Mat{N,M,MT}}, bytes, from::VulkanLayout) where {N,M,MT}
  t = from[T]::MatrixType
  vectype = eltype_major(t)
  s = stride(from, vectype)
  size = datasize(from, vectype)

  t.is_column_major && return @force_construct T ntuple(i -> deserialize(NTuple{N,MT}, @view(bytes[1 + (i - 1) * s:(i - 1) * s + size]), NoPadding()), M)
  tuple = ntuple(i -> deserialize(NTuple{M,MT}, @view(bytes[1 + (i - 1) * s:(i - 1) * s + size]), NoPadding()), N)
  @force_construct T reinterpret(NTuple{M, NTuple{N, MT}}, [tuple])[]
end
