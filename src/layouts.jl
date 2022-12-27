"""
Type metadata meant to be analyzed and modified to generate appropriate decorations.
"""
struct TypeMetadata
  tmap::TypeMap
  d::Dictionary{SPIRType, Metadata}
end

TypeMetadata(tmap = TypeMap()) = TypeMetadata(tmap, Dictionary())

function TypeMetadata(ir::IR)
  tmeta = TypeMetadata(ir.tmap)
  for t in ir.tmap
    tid = get(ir.types, t, nothing)
    isnothing(tid) && !isa(t, PointerType) && error("Expected type $t to have a corresponding type ID")
    meta = get(ir.metadata, tid, nothing)
    isnothing(meta) && continue
    insert!(tmeta.d, t, meta)
  end
  tmeta
end

@forward TypeMetadata.d (metadata!, has_decoration, decorate!, decorations)

function Base.merge!(ir::IR, tmeta::TypeMetadata)
  for (t, meta) in pairs(tmeta.d)
    tid = ir.types[t]
    merge_metadata!(ir, tid, meta)
  end
end

scalar_alignment(::BooleanType) = 0
scalar_alignment(t::Union{IntegerType,FloatType}) = t.width ÷ 8
scalar_alignment(t::Union{VectorType,MatrixType,ArrayType}) = scalar_alignment(t.eltype)
scalar_alignment(t::StructType) = maximum(scalar_alignment, t.members)

base_alignment(t::ScalarType) = scalar_alignment(t)
base_alignment(t::VectorType) = (t.n == 2 ? 2 : 4) * scalar_alignment(t.eltype)
base_alignment(t::ArrayType) = base_alignment(t.eltype)
function base_alignment(t::StructType)
  if isempty(t.members)
    # Requires knowing the smallest scalar type permitted
    # by the storage class & module capabilities.
    error("Not implemented.")
  else
    maximum(base_alignment, t.members)
  end
end
base_alignment(t::MatrixType) = t.is_column_major ? base_alignment(t.eltype) : base_alignment(VectorType(t.eltype.eltype, t.n))

extended_alignment(t::SPIRType) = base_alignment(t)
extended_alignment(t::Union{ArrayType,StructType}) = 16 * cld(base_alignment(t), 16)
extended_alignment(t::MatrixType) = t.is_column_major ? extended_alignment(t.eltype) : extended_alignment(VectorType(t.eltype.eltype, t.n))

function extract_size(t::ArrayType)
  (; size) = t
  !isnothing(size) || throw(ArgumentError("Array types must be sized to extract their size."))
  !size.is_spec_const || error("Arrays with a size provided by a specialization constants are not supported for size calculations yet.")
  isa(size.value, Integer) || error("Expected an integer array size, got ", size.value)
  size.value
end

payload_size(t::ScalarType) = scalar_alignment(t)
payload_size(t::Union{VectorType,MatrixType}) = t.n * payload_size(t.eltype)
payload_size(t::ArrayType) = extract_size(t) * payload_size(t.eltype)
payload_size(t::StructType) = sum(payload_size, t.members)

payload_size(T::DataType) = is_composite_type(T) ? sum(payload_sizes(T)) : sizeof(T)
payload_size(x::AbstractVector) = payload_size(eltype(x)) * length(x)
payload_size(x) = payload_size(typeof(x))

"""
Layout strategy used to compute alignments, offsets and strides.
"""
abstract type LayoutStrategy end

"""
Vulkan-compatible layout strategy.
"""
Base.@kwdef struct VulkanLayout <: LayoutStrategy
  scalar_block_layout::Bool = false
  uniform_buffer_standard_layout::Bool = false
end

function alignment(layout::VulkanLayout, t::SPIRType, storage_classes, is_interface::Bool)
  @match t begin
    ::VectorType => scalar_alignment(t)
    if layout.scalar_block_layout &&
       !isempty(
      intersect(storage_classes, [StorageClassUniform, StorageClassStorageBuffer,
        StorageClassPhysicalStorageBuffer, StorageClassPushConstant]),
    )
    end => scalar_alignment(t)
    if !layout.uniform_buffer_standard_layout && StorageClassUniform in storage_classes && is_interface
    end => @match t begin
      ::MatrixType => extended_alignment(t)
      _ => extended_alignment(t)
    end
    ::MatrixType => base_alignment(t)
    _ => base_alignment(t)
  end
end

function storage_classes(types, t::SPIRType)
  Set{StorageClass}(type.storage_class for type in types if isa(type, PointerType) && type.type == t)
end
storage_classes(tmeta::TypeMetadata, t::SPIRType) = storage_classes(keys(tmeta.d), t)

function add_type_layouts!(ir::IR, layout::LayoutStrategy)
  tmeta = TypeMetadata(ir.tmap, Dictionary())
  add_type_layouts!(tmeta, layout)
  merge!(ir, tmeta)
end

function add_type_layouts!(tmeta::TypeMetadata, layout::LayoutStrategy)
  for t in tmeta.tmap
    @tryswitch t begin
      @case ::ArrayType && if !isa(t.eltype, SampledImageType) && !isa(t.eltype, ImageType) && !isa(t.eltype, SamplerType)
      end
      add_array_stride!(tmeta, t, layout)

      @case ::StructType
      add_offsets!(tmeta, t, layout)
      add_matrix_layouts!(tmeta, t, layout)
    end
  end
  tmeta
end

function add_array_stride!(tmeta::TypeMetadata, t::ArrayType, layout::LayoutStrategy)
  # Array of shader resources. Must not be decorated.
  isa(t.eltype, StructType) && has_decoration(tmeta, t.eltype, DecorationBlock) && return
  stride = compute_stride(t.eltype, tmeta, layout)
  isa(t, ArrayType) ? decorate!(tmeta, t, DecorationArrayStride, stride) : decorate!(tmeta, t, DecorationMatrixStride, stride)
  decorate!(tmeta, t, DecorationArrayStride, stride)
end

function add_matrix_layouts!(tmeta::TypeMetadata, t::StructType, layout::LayoutStrategy)
  for (i, subt) in enumerate(t.members)
    if isa(subt, MatrixType)
      add_matrix_stride!(tmeta, t, i, subt, layout)
      add_matrix_layout!(tmeta, t, i, subt)
    end
  end
end

function add_matrix_stride!(tmeta::TypeMetadata, t::StructType, i, subt::MatrixType, layout::LayoutStrategy)
  stride = compute_stride(subt.eltype.eltype, tmeta, layout)
  decorate!(tmeta, t, i, DecorationMatrixStride, stride)
end

"Follow Julia's column major layout by default, consistently with the `Mat` frontend type."
add_matrix_layout!(tmeta::TypeMetadata, t::StructType, i, subt::MatrixType) = decorate!(tmeta, t, i, subt.is_column_major ? DecorationColMajor : DecorationRowMajor)

add_offsets!(tmeta::TypeMetadata, T::DataType, layout::LayoutStrategy) = add_offsets!(tmeta, tmeta.tmap[T], layout)
isinterface(tmeta::TypeMetadata, t::SPIRType) = has_decoration(tmeta, t, DecorationBlock)
isinterface(tmeta::TypeMetadata) = t -> isinterface(tmeta, t)
function add_offsets!(tmeta::TypeMetadata, t::StructType, layout::LayoutStrategy)
  scs = storage_classes(tmeta, t)
  current_offset = 0
  n = length(t.members)
  for (i, subt) in enumerate(t.members)
    alignmt = alignment(layout, subt, scs, isinterface(tmeta, t))
    current_offset = alignmt * cld(current_offset, alignmt)
    decorate!(tmeta, t, i, DecorationOffset, current_offset)
    i ≠ n && (current_offset += compute_minimal_size(subt, tmeta, layout))
  end
end

function member_offsets(isinterface, t::StructType, layout::LayoutStrategy, storage_classes::Dictionary{SPIRType, Set{StorageClass}})
  offsets = UInt32[]
  base = 0U
  for (i, subt) in enumerate(t.members)
    alignmt = alignment(layout, subt, get(Set{StorageClass}, storage_classes, subt), isinterface(subt))
    base = alignmt * cld(base, alignmt)
    push!(offsets, base)
    isa(subt, ArrayType) && isnothing(subt.size) && i == lastindex(t.members) && break
    base += compute_minimal_size(subt, t -> get(Set{StorageClass}, storage_classes, t), isinterface, layout)
  end
  offsets
end

"""
    compute_minimal_size(T, storage_classes::Callable, is_interface::Callable, layout::LayoutStrategy)

Compute the minimal size that a type `T` should have, using the alignments computed by the provided layout strategy.
"""
function compute_minimal_size end

compute_minimal_size(T::DataType, tmeta::TypeMetadata, layout::LayoutStrategy) = compute_minimal_size(tmeta.tmap[T], tmeta, layout)
compute_minimal_size(t::SPIRType, tmeta::TypeMetadata, layout::LayoutStrategy) = compute_minimal_size(t, Base.Fix1(storage_classes, tmeta), isinterface(tmeta), layout)
compute_minimal_size(t::ScalarType, storage_classes, is_interface, layout::LayoutStrategy) = scalar_alignment(t)
compute_minimal_size(t::Union{VectorType, MatrixType}, storage_classes, is_interface, layout::LayoutStrategy) = t.n * compute_minimal_size(t.eltype, storage_classes, is_interface, layout)
compute_minimal_size(t::ArrayType, storage_classes, is_interface, layout::LayoutStrategy) = extract_size(t) * compute_minimal_size(t.eltype, storage_classes, is_interface, layout)

function compute_minimal_size(t::StructType, storage_classes, is_interface, layout::LayoutStrategy)
  res = 0
  scs = storage_classes(t)
  for (i, subt) in enumerate(t.members)
    if i ≠ 1
      alignmt = alignment(layout, subt, scs, is_interface(t))
      res = alignmt * cld(res, alignmt)
    end
    res += compute_minimal_size(subt, storage_classes, is_interface, layout)
  end
  res
end

"""
    compute_stride(T, tmap::TypeMap, layout::LayoutStrategy)

Compute the stride that an array containing `T` should have, using module member offset declarations and with an extra padding at the end corresponding to the alignment of `T`.
"""
function compute_stride end

compute_stride(T::DataType, tmeta::TypeMetadata, layout::LayoutStrategy) = compute_stride(tmeta.tmap[T], tmeta, layout)
compute_stride(t::SPIRType, tmeta::TypeMetadata, layout::LayoutStrategy) = compute_stride(t, Base.Fix1(storage_classes, tmeta), isinterface(tmeta), Base.Fix1(getoffsets, tmeta), layout)
compute_stride(t::ScalarType, storage_classes, is_interface, getoffsets, layout::LayoutStrategy) = scalar_alignment(t)
compute_stride(t::Union{VectorType, MatrixType}, storage_classes, is_interface, getoffsets, layout::LayoutStrategy) = t.n * compute_stride(t.eltype, storage_classes, is_interface, getoffsets, layout)
compute_stride(t::ArrayType, storage_classes, is_interface, getoffsets, layout::LayoutStrategy) = extract_size(t) * compute_stride(t.eltype, storage_classes, is_interface, getoffsets, layout)

function compute_stride(t::StructType, storage_classes, is_interface, getoffsets, layout::LayoutStrategy)
  offsets = getoffsets(t)
  size = last(offsets) + payload_size(last_member(t))
  alignmt = alignment(layout, t, storage_classes(t), is_interface(t))
  alignmt * cld(size, alignmt)
end

last_member(t::SPIRType) = t
last_member(t::StructType) = last_member(last(t.members))

function payload_sizes!(sizes, T)
  !is_composite_type(T) && return push!(sizes, payload_size(T))
  for subT in member_types(T)
    payload_sizes!(sizes, subT)
  end
  sizes
end
payload_sizes(T) = payload_sizes!(Int[], T)

"""
Extract bytes from a Julia value, with strictly no alignment.
"""
function extract_bytes(data::T) where {T}
  isstructtype(T) || return collect(reinterpret(UInt8, [data]))
  bytes = UInt8[]
  for field in fieldnames(T)
    append!(bytes, extract_bytes(getproperty(data, field)))
  end
  bytes
end

extract_bytes(data::Vector{UInt8}) = data
extract_bytes(data::AbstractVector) = reduce(vcat, extract_bytes.(data); init = UInt8[])
extract_bytes(data::AbstractSPIRVArray) = Base.@invoke extract_bytes(data::T where T)
extract_bytes(data1, data2, data...) = reduce(vcat, vcat(extract_bytes(data2), extract_bytes.(data)...); init = extract_bytes(data1))

function getoffset(tmeta::TypeMetadata, t, i)
  decs = decorations(tmeta, t, i)
  isnothing(decs) && error("Missing decorations on member ", i, " of the aggregate type ", t)
  has_decoration(decs, DecorationOffset) || error("Missing offset declaration for member ", i, " on ", t)
  decs.offset
end

is_composite_type(t::SPIRType) = isa(t, StructType)
is_composite_type(T::DataType) = isstructtype(T) && !(T <: Vector) && !(T <: Vec) && !(T <: Mat) 
member_types(t::StructType) = t.members
member_types(T::DataType) = fieldtypes(T)

reinterpret_type(T::Type) = T
reinterpret_type(::Type{Vec{N,T}}) where {N,T} = NTuple{N,T}
reinterpret_type(::Type{Arr{N,T}}) where {N,T} = NTuple{N,reinterpret_type(T)}
reinterpret_type(::Type{Mat{N,M,T}}) where {N,M,T} = NTuple{M,NTuple{N,T}}

reinterpreted(::Type{Vec{N,T}}, arr) where {N,T} = Vec{N,T}(Tuple(arr))
reinterpreted(::Type{Arr{N,T}}, arr) where {N,T} = Arr{N,T}(reinterpreted.(T, arr))
reinterpreted(::Type{Mat{N,M,T}}, arr) where {N,M,T} = error("Not supported yet.")
reinterpreted(T::Type, arr) = arr

function reinterpret_spirv(T::Type, x::AbstractArray{UInt8})
  RT = reinterpret_type(T)
  T === RT && return only(reinterpret(T, x))
  reinterpreted(T, only(reinterpret(RT, x)))
end

function reinterpret_spirv(V::Type{Vector{T}}, x::AbstractArray{UInt8}) where {T}
  RT = reinterpret_type(T)
  T === RT && return collect(reinterpret(T, x))
  [reinterpreted(T, el) for el in reinterpret(RT, x)]
end

function getoffsets!(offsets, base, getoffset, T)
  !is_composite_type(T) && return offsets
  for (i, subT) in enumerate(member_types(T))
    new_offset = base + getoffset(T, i)
    is_composite_type(subT) ? getoffsets!(offsets, new_offset, getoffset, subT) : push!(offsets, new_offset)
  end
  offsets
end

getoffsets(getoffset, t::SPIRType) = getoffsets!(UInt32[], 0U, getoffset, t)
getoffsets(T::DataType) = getoffsets!(UInt32[], 0U, fieldoffset, T)
getoffsets(tmeta::TypeMetadata, t::SPIRType) = getoffsets((t, i) -> getoffset(tmeta, t, i), t)

function validate_offsets(offsets)
  allunique(offsets) || error("Non-unique offsets detected. They must be unique, or otherwise data will be overwritten.")
  sortperm(offsets) == eachindex(offsets) || error("Non-monotonous offsets detected.")
  true
end

"""
Return a vector of bytes where every logical piece of data (delimited via the provided `sizes`)
has been aligned according to the provided offsets.
"""
function align(data::AbstractVector{UInt8}, sizes::AbstractVector{<:Integer}, offsets::AbstractVector{<:Integer}; callback = nothing)
  isempty(offsets) && return data
  aligned_size = last(offsets) + last(sizes)
  aligned = zeros(UInt8, aligned_size)
  total = sum(sizes)
  total == length(data) || error("Size mismatch between the provided data (", length(data), " bytes) and the corresponding SPIR-V type (", total, " bytes)")
  data_byte = 1
  @assert length(sizes) == length(offsets) "Size mismatch between the list of sizes and the list of offsets"
  @assert validate_offsets(offsets)
  for (offset, size) in zip(offsets, sizes)
    from = data_byte:(data_byte + size - 1)
    to = (offset + 1):(offset + size)
    aligned[to] .= data[from]
    !isnothing(callback) && callback(from, to)
    data_byte += size
  end
  aligned
end

align(data::AbstractVector{UInt8}, t::StructType, offsets::AbstractVector{<:Integer}; callback = nothing) = align(data, payload_sizes(t), offsets; callback)

"""
Type information used for associating Julia-level data types with SPIR-V types and
for applying offsets to pad payload bytes extracted from Julia values.

Meant to be used in a read-only fashion only.
"""
@auto_hash_equals struct TypeInfo
  tmap::TypeMap
  offsets::Dictionary{StructType,Vector{UInt32}}
  strides::Dictionary{ArrayType,UInt32}
end

TypeInfo(tmap::TypeMap = TypeMap()) = TypeInfo(tmap, Dictionary(), Dictionary())

"""
Extract a [`TypeInfo`](@ref) from the existing type mapping.

!!! warn
    The type mapping is not copied for performance reasons.
    It must not be modified or correctness issues may appear.
"""
function TypeInfo(tmeta::TypeMetadata, layout::LayoutStrategy)
  (; tmap) = tmeta
  info = TypeInfo(tmap)
  scs = dictionary([t => storage_classes(tmeta, t) for t in tmap])
  for t in tmap
    isa(t, StructType) && insert!(info.offsets, t, member_offsets(isinterface(tmeta), t, layout, scs))
    if isa(t, ArrayType)
      decs = decorations(tmeta, t)
      !isnothing(decs) && has_decoration(decs, DecorationArrayStride) && insert!(info.strides, t, decs.array_stride)
    end
  end
  info
end

"""
Construct a `TypeInfo` from the provided Julia types, generating the corresponding
SPIR-V types and appropriate offset and stride information using the provided layout strategy.

This is primarily intended for testing purposes.
"""
function TypeInfo(Ts::AbstractVector{DataType}, layout::LayoutStrategy)
  info = TypeInfo()
  storage_classes = Dictionary{SPIRType,Set{StorageClass}}()
  isinterface = Returns(false)
  worklist = SPIRType[]
  for T in Ts
    t = spir_type(T)
    insert!(info.tmap, T, t)
    push!(worklist, t)
  end

  array_types = ArrayType[]
  while !isempty(worklist)
    t = pop!(worklist)
    if isa(t, Union{ArrayType,MatrixType})
      push!(array_types, t)
      push!(worklist, t.eltype)
    end
    isa(t, StructType) || continue
    insert!(info.offsets, t, member_offsets(isinterface, t, layout, storage_classes))
    for subt in t.members
      isa(subt, StructType) || continue
      insert!(info.offsets, subt, member_offsets(isinterface, subt, layout, storage_classes))
    end
  end

  for t in array_types
    stride = compute_stride(t.eltype, t -> get(Set{StorageClass}, storage_classes, t), isinterface, Base.Fix1(getoffsets, info), layout)
    insert!(info.strides, t, stride)
  end

  info
end

TypeInfo(ir::IR, layout::LayoutStrategy) = TypeInfo(TypeMetadata(ir), layout)

getoffsets(tinfo::TypeInfo, t::SPIRType) = getoffsets((t, i) -> tinfo.offsets[t][i], t)
getoffsets(tdata::Union{TypeMetadata,TypeInfo}, T::DataType) = getoffsets(tdata, tdata.tmap[T])

align(data::AbstractVector{UInt8}, t::StructType, tdata::Union{TypeMetadata,TypeInfo}; callback = nothing) = align(data, t, getoffsets(tdata, t); callback)
align(data::AbstractVector{UInt8}, t::ArrayType, tdata::Union{TypeMetadata,TypeInfo}; callback = nothing) = align(data, t, getstride(tdata, t), getoffsets(tdata, t.eltype); callback)
align(data::AbstractVector{UInt8}, t::SPIRType, tdata::Union{TypeMetadata,TypeInfo}; callback = nothing) = t
align(data::AbstractVector{UInt8}, T::DataType, tdata::Union{TypeMetadata,TypeInfo}) = align(data, tdata.tmap[T], tdata)

getstride(tinfo::TypeInfo, t::ArrayType) = tinfo.strides[t]
getstride(tmeta::TypeMetadata, t::ArrayType) = decorations(tmeta, t).array_stride

"""
Return a new vector of bytes which correspond to the `data` array payload after each element being
aligned and spaced with `stride`. The array stride must not be lesser than the aligned element size.
"""
function align(data::AbstractVector{UInt8}, t::ArrayType, stride::Integer, eloffsets::AbstractVector{<:Integer}; callback = nothing)
  elsizes = payload_sizes(t.eltype)
  elsize = sum(elsizes)
  aligned_elsize = (isempty(eloffsets) ? 0 : last(eloffsets)) + last(elsizes)
  aligned_elsize ≤ stride || error("Array stride $stride is lower than the actual array element size $aligned_elsize after alignment.")
  effective_length = Int(length(data) / elsize)
  !isnothing(t.size) && !t.size.is_spec_const && isa(t.size.value, Integer) && effective_length ≠ t.size.value && error("Array size mismatch between the provided payload ($effective_length elements) and its constant declared value ($(t.size.value))")
  aligned = zeros(UInt8, stride * (effective_length - 1) + aligned_elsize)
  for i in 1:effective_length
    start_aligned = 1 + (i - 1) * stride
    aligned[start_aligned:start_aligned + aligned_elsize - 1] .= align(@view(data[1 + (i - 1) * elsize:i * elsize]), elsizes, eloffsets; callback)
  end
  aligned
end

getstride(T::DataType) = Base.elsize(T)
