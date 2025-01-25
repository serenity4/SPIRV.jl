# Serialization always implicitly uses a `NativeLayout` as source.
# Deserialization always implicitly uses a `NativeLayout` as target.

function serialize(data, layout::LayoutStrategy)
  bytes = UInt8[]
  sizehint!(bytes, datasize(layout, data))
  serialize!(bytes, data, layout)
  bytes
end

function serialize(data::Union{T,Array{T}}, layout::NativeLayout) where {T}
  if isbitstype(T)
    arr = isa(data, T) ? [data] : data
    GC.@preserve arr begin
      ptr = pointer(arr)
      return unsafe_wrap(Array{UInt8}, Ptr{UInt8}(ptr), datasize(layout, data))
    end
  end
  Base.@invoke serialize(data, layout::LayoutStrategy)
end

function serialize!(bytes, data::T, layout::LayoutStrategy) where {T}
  isprimitivetype(T) && return serialize_primitive!(bytes, data)
  n = fieldcount(T)
  iszero(n) && return bytes
  nb = length(bytes)

  for i in 1:n
    # Add padding, if necessary.
    pad!(bytes, padding(layout, T, i))
    # Recursively serialize fields.
    serialize!(bytes, getfield(data, i), layout)
  end
  pad!(bytes, datasize(layout, T) - (length(bytes) - nb))
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
function serialize_array!(bytes, data::AbstractVecOrMat, layout::LayoutStrategy, padding)
  for x in data
    serialize!(bytes, x, layout)
    pad!(bytes, padding)
  end
end

function serialize!(bytes, data::Vector, layout::LayoutStrategy)
  T = typeof(data)
  isbitstype(eltype(data)) &&
    stride(NativeLayout(), T) == stride(layout, T) &&
    return append!(bytes, reinterpret(UInt8, data))
  serialize_array!(bytes, data, layout, padding(layout, data))
end

function serialize!(bytes, data::Matrix, layout::LayoutStrategy)
  pad = padding(layout, data)
  iszero(pad) && isbitstype(eltype(data)) && return append!(bytes, reinterpret(UInt8, data))
  serialize_array!(bytes, data, layout, pad)
end

# VulkanLayout-specific serialization rules.
# This is mostly to work around the fact that array/vector/matrix types
# are composite types and we do not support looking into their (only) tuple component.
function serialize!(bytes, data::T, layout::VulkanLayout) where {T<:Mat}
  type = layout[T]
  istype(type, SPIR_TYPE_MATRIX) || return @invoke serialize!(bytes, data::T, layout::LayoutStrategy)
  vectype = eltype_major(type)
  payload = columns(data)
  if !type.matrix.is_column_major
    payload = reinterpret(NTuple{nrows(T), NTuple{ncols(T), eltype(T)}}, [payload])[]
  end
  s = stride(layout, type)
  padding = s - datasize(layout, vectype)
  for row_or_col in payload
    serialize!(bytes, row_or_col, NoPadding())
    pad!(bytes, padding)
  end
end
serialize!(bytes, data::Vec, layout::VulkanLayout) = serialize!(bytes, data.data, NoPadding())
function serialize!(bytes, data::T, layout::VulkanLayout) where {T<:Arr}
  type = layout[T]
  assert_type(type, SPIR_TYPE_ARRAY)
  s = stride(layout, type)
  padding = s - datasize(layout, type.array.eltype)
  for el in data
    n = length(bytes)
    serialize!(bytes, el, layout)
    pad!(bytes, padding)
  end
end

# It is assumed that types are `isbits` in this context.
same_layout(::NativeLayout, ::NativeLayout, ::DataType) = true
same_layout(l1::NoPadding, l2::NativeLayout, T::DataType) = datasize(l1, T) == datasize(l2, T)
same_layout(::LayoutStrategy, ::NativeLayout, ::DataType) = false # do not make assumptions for now

function deserialize(::Type{T}, bytes, from::LayoutStrategy) where {T}
  (isprimitivetype(T) || isbitstype(T) && same_layout(from, NativeLayout(), T)) && return reinterpret(T, bytes)[]
  ismutabletype(T) && return deserialize_mutable(T, bytes, from)
  isstructtype(T) && return deserialize_immutable(T, bytes, from)
  error("Expected one of primitive, mutable or composite type, got $T")
end
function deserialize(::Type{Vector{T}}, bytes, from::LayoutStrategy, dims = nothing) where {T}
  i = 0
  s = stride(from, Vector{T})
  size = datasize(from, T)
  n = length(bytes) ÷ s
  !isnothing(dims) && (dims == n || error("The provided vector dimensions differ from the inferred vector size: $dims ≠ $n"))
  @assert iszero(length(bytes) % s) "Inferred vector size is not an integer"
  res = Vector{T}(undef, n)
  for i in 1:n
    offset = (i - 1) * s
    elbytes = @view bytes[1 + offset:offset + size]
    res[i] = deserialize(T, elbytes, from)
  end
  res
end
deserialize(::Type{<:Matrix}, bytes, from::LayoutStrategy) = error("Matrix dimensions `(nrows, ncols)` must be provided as an extra argument.")
function deserialize(::Type{Matrix{T}}, bytes, from::LayoutStrategy, (n, m), column_padding = 0) where {T}
  s = stride(from, Vector{T})
  size = datasize(from, T)
  res = Matrix{T}(undef, n, m)
  for j in 1:m
    for i in 1:n
      offset = (j - 1) * (s * n + column_padding) + (i - 1) * s
      elbytes = @view bytes[1 + offset:offset + size]
      res[i, j] = deserialize(T, elbytes, from)
    end
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
  type = from[T]
  assert_type(type, SPIR_TYPE_ARRAY)
  s = stride(from, type)
  size = datasize(from, AT)
  T(ntuple(i -> deserialize(AT, @view(bytes[(1 + (i - 1) * s):((i - 1) * s + size)]), from), N))
end
function deserialize(T::Type{<:SMatrix{N,M,MT}}, bytes, from::VulkanLayout) where {N,M,MT}
  type = from[T]
  istype(type, SPIR_TYPE_MATRIX) || return @invoke deserialize(T, bytes, from::LayoutStrategy)
  vectype = eltype_major(type)
  s = stride(from, type)
  size = datasize(from, vectype)

  values = MT[]
  if type.matrix.is_column_major
    for i in 1:M
      tuple = deserialize(NTuple{N,MT}, @view(bytes[1 + (i - 1) * s:(i - 1) * s + size]), NoPadding())
      append!(values, tuple)
    end
  else
    for j in 1:N
      tuple = deserialize(NTuple{M,MT}, @view(bytes[1 + (i - 1) * s:(i - 1) * s + size]), NoPadding())
      append!(values, tuple)
    end
  end
  T(values)
end
