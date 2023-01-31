# Serialization always implicitly uses a `NativeLayout` as source.
# Deserialization always implicitly uses a `NativeLayout` as target.

function serialize(data, layout::LayoutStrategy)
  bytes = UInt8[]
  serialize!(bytes, data, layout)
  bytes
end

function serialize!(bytes, data::T, layout::LayoutStrategy) where {T}
  isprimitivetype(T) && return append!(bytes, reinterpret(UInt8, [data]))
  current_offset = 0
  for (i, subt) in enumerate(fieldtypes(T))
    # Add padding, if necessary.
    offset = dataoffset(layout, T, i)
    if offset != current_offset
      @assert current_offset < offset
      Δoffset = offset - current_offset
      pad!(bytes, Δoffset)
      current_offset += Δoffset
    end
    # Recursively serialize fields.
    serialize!(bytes, getfield(data, i), layout)
    current_offset += datasize(layout, subt)
  end
end

# function serialize!(bytes, data::T, layout::NoPadding) where {T}
#   isprimitivetype(T) && return append!(bytes, reinterpret(UInt8, [data]))
#   for field in fieldnames(T)
#     serialize!(bytes, getproperty(data, field), layout)
#   end
# end

function pad!(bytes, amount)
  @assert amount ≥ 0
  for _ in 1:amount
    push!(bytes, 0x00)
  end
  bytes
end

serialize!(bytes, data::Vector{UInt8}, ::LayoutStrategy) = append!(bytes, data)
function serialize!(bytes, data::Vector{T}, layout::LayoutStrategy) where {T}
  @assert isconcretetype(T)
  s = stride(layout, T)
  padding = s - datasize(layout, T)
  for x in data
    serialize!(bytes, x, layout)
    pad!(bytes, padding)
  end
end
function serialize!(bytes, data::T, layout::VulkanLayout) where {T<:Mat}
  t = layout.tmap[T]::MatrixType
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
  t = layout.tmap[T]::ArrayType
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
  t = from.tmap[T]::ArrayType
  s = stride(from, t.eltype)
  size = datasize(from, AT)
  T(ntuple(i -> deserialize(AT, @view(bytes[(1 + (i - 1) * s):((i - 1) * s + size)]), from), N))
end
function deserialize(T::Type{Mat{N,M,MT}}, bytes, from::VulkanLayout) where {N,M,MT}
  t = from.tmap[T]::MatrixType
  vectype = eltype_major(t)
  s = stride(from, vectype)
  size = datasize(from, vectype)

  t.is_column_major && return @force_construct T ntuple(i -> deserialize(NTuple{N,MT}, @view(bytes[1 + (i - 1) * s:(i - 1) * s + size]), NoPadding()), M)
  tuple = ntuple(i -> deserialize(NTuple{M,MT}, @view(bytes[1 + (i - 1) * s:(i - 1) * s + size]), NoPadding()), N)
  @force_construct T reinterpret(NTuple{M, NTuple{N, MT}}, [tuple])[]
end
