"""
Layout strategy used to compute alignments, offsets and strides.
"""
@refbroadcast abstract type LayoutStrategy end

""""
Julia layout, with a special handling of mutable fields for composite types.

Mutable fields are stored as 8-byte pointers in Julia, but in SPIR-V there is no such concept of pointer.
Therefore, we treat mutable fields as if they were fully inlined - that imposes a few restrictions on the
behavior of such mutable objects, but is necessary to keep some form of compatibility with GPU representations.
The alternative would be to completely disallow structs which contain mutable fields.
"""
struct NativeLayout <: LayoutStrategy end

stride(layout::NativeLayout, T::Type) = ismutabletype(T) ? datasize(layout, T) : Base.elsize(Vector{T})
function datasize(layout::NativeLayout, T::DataType)
  isbitstype(T) && return sizeof(T)
  isconcretetype(T) || error("A concrete type is required.")
  @assert isstructtype(T)
  total_padding = sum(fieldoffset(T, i) - (fieldoffset(T, i - 1) + field_sizeof(fieldtype(T, i - 1))) for i in 2:fieldcount(T); init = 0)
  sum(sizeof, fieldtypes(T); init = 0) + total_padding
end
datasize(layout::NativeLayout, V::Type{Vector{T}}) where {T} = length(V) * stride(layout, T) - (stride(layout, T) - datasize(layout, T))
function dataoffset(layout::NativeLayout, T::DataType, i::Int)
  i == 1 && return fieldoffset(T, 1)
  Tprev = fieldtype(T, i - 1)
  # Account for any padding that might have been inserted between the current and previous members.
  padding = fieldoffset(T, i) - (fieldoffset(T, i - 1) + field_sizeof(Tprev))
  computed_offset = dataoffset(layout, T, i - 1) + datasize(layout, Tprev)
  padding + computed_offset
end
field_sizeof(T::Type) = ismutabletype(T) ? 8 : sizeof(T)
alignment(::NativeLayout, T::Type) = Base.datatype_alignment(T)

struct NoPadding <: LayoutStrategy end

stride(layout::NoPadding, T::Type) = datasize(layout, T)
datasize(layout::NoPadding, T::Type) = isprimitivetype(T) ? sizeof(T) : sum(ntuple(i -> datasize(layout, fieldtype(T, i)), fieldcount(T)); init = 0)
dataoffset(layout::NoPadding, T::Type, i::Integer) = sum(datasize(layout, xT) for xT in fieldtypes(T)[1:(i - 1)]; init = 0)
alignment(::NoPadding, ::Type) = 0

struct LayoutInfo
  stride::Int
  datasize::Int
  alignment::Int
  dataoffsets::Optional{Vector{Int}}
end

LayoutInfo(layout::LayoutStrategy, T::Type) = LayoutInfo(stride(layout, T), datasize(layout, T), alignment(layout, T), isstructtype(T) ? dataoffset.(layout, T, 1:fieldcount(T)) : nothing)

struct ExplicitLayout <: LayoutStrategy
  d::IdDict{DataType,LayoutInfo}
end

stride(layout::ExplicitLayout, T::Type) = layout.d[T].stride
datasize(layout::ExplicitLayout, T::Type) = layout.d[T].datasize
dataoffset(layout::ExplicitLayout, T::Type, i::Integer) = (layout.d[T].dataoffsets::Vector{Int})[i]
alignment(layout::ExplicitLayout, T::Type) = layout.d[T].alignment

function extract_layouts!(d::IdDict{DataType,LayoutInfo}, layout::LayoutStrategy, T::DataType)
  haskey(d, T) && return
  d[T] = LayoutInfo(layout, T)
  isstructtype(T) || return
  for subT in fieldtypes(T)
    extract_layouts!(d, layout, subT)
  end
end

function ExplicitLayout(layout::LayoutStrategy, types)
  d = IdDict{DataType,LayoutInfo}()
  for T in types
    extract_layouts!(d, layout, T)
  end
  ExplicitLayout(d)
end

Base.@kwdef struct VulkanAlignment
  scalar_block_layout::Bool = false
  uniform_buffer_standard_layout::Bool = false
end

function alignment(vulkan::VulkanAlignment, t::SPIRType, storage_classes, is_interface::Bool)
  @match t begin
    ::VectorType => scalar_alignment(t)
    if vulkan.scalar_block_layout &&
       !isempty(
      intersect(storage_classes, [StorageClassUniform, StorageClassStorageBuffer,
        StorageClassPhysicalStorageBuffer, StorageClassPushConstant]),
    )
    end => scalar_alignment(t)
    if !vulkan.uniform_buffer_standard_layout && StorageClassUniform in storage_classes && is_interface
    end => extended_alignment(t)
    _ => base_alignment(t)
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

"""
Vulkan-compatible layout strategy.
"""
struct VulkanLayout <: LayoutStrategy
  alignment::VulkanAlignment
  tmap::TypeMap
  storage_classes::Dict{SPIRType,Set{StorageClass}}
  interfaces::Set{SPIRType}
end

storage_classes(layout::VulkanLayout, t::SPIRType) = get!(Set{StorageClass}, layout.storage_classes, t)
isinterface(layout::VulkanLayout, t::SPIRType) = in(t, layout.interfaces)

stride(layout::VulkanLayout, T::Type) = stride(layout, layout.tmap[T])
datasize(layout::VulkanLayout, T::Type) = datasize(layout, layout.tmap[T])
dataoffset(layout::VulkanLayout, T::Type, i::Integer) = dataoffset(layout, layout.tmap[T], i)
alignment(layout::VulkanLayout, T::Type) = alignment(layout, layout.tmap[T])

stride(::VulkanLayout, t::ScalarType) = scalar_alignment(t)
stride(layout::VulkanLayout, t::Union{VectorType, MatrixType}) = t.n * stride(layout, t.eltype)
stride(layout::VulkanLayout, t::ArrayType) = extract_size(t) * stride(layout, t.eltype)
function stride(layout::VulkanLayout, t::StructType)
  req_alignment = alignment(layout, t)
  req_alignment * cld(datasize(layout, t), req_alignment)
end
datasize(layout::LayoutStrategy, t::ScalarType) = scalar_alignment(t)
datasize(layout::LayoutStrategy, t::Union{VectorType,MatrixType}) = t.n * datasize(layout, t.eltype)
datasize(layout::LayoutStrategy, t::ArrayType) = extract_size(t) * stride(layout, t.eltype)
datasize(layout::LayoutStrategy, t::StructType) = dataoffset(layout, t, length(t.members)) + datasize(layout, t.members[end])
dataoffset(layout::VulkanLayout, t::SPIRType, i::Integer) = 0
function dataoffset(layout::VulkanLayout, t::StructType, i::Integer)
  i == 1 && return 0
  subt = t.members[i]
  req_alignment = alignment(layout, subt)
  prevloc = dataoffset(layout, t, i - 1) + datasize(layout, t.members[i - 1])
  req_alignment * cld(prevloc, req_alignment)
end
alignment(layout::VulkanLayout, t::SPIRType) = alignment(layout.alignment, t, storage_classes(layout, t), isinterface(layout, t))

function extract_size(t::ArrayType)
  (; size) = t
  !isnothing(size) || throw(ArgumentError("Array types must be sized to extract their size."))
  !size.is_spec_const || error("Arrays with a size provided by a specialization constants are not supported for size calculations yet.")
  isa(size.value, Integer) || error("Expected an integer array size, got ", size.value)
  size.value
end


"""
Type metadata meant to be analyzed and modified to generate appropriate decorations.
"""
struct TypeMetadata
  tmap::TypeMap
  d::Dictionary{SPIRType, Metadata}
end

TypeMetadata(tmap = TypeMap()) = TypeMetadata(tmap, Dictionary())

@forward TypeMetadata.d (metadata!, has_decoration, decorate!, decorations)

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

function storage_classes(types, t::SPIRType)
  Set{StorageClass}(type.storage_class for type in types if isa(type, PointerType) && type.type == t)
end
storage_classes(tmeta::TypeMetadata, t::SPIRType) = storage_classes(keys(tmeta.d), t)

isinterface(tmeta::TypeMetadata, t::SPIRType) = has_decoration(tmeta, t, DecorationBlock)
isinterface(tmeta::TypeMetadata) = t -> isinterface(tmeta, t)

function VulkanLayout(tmeta::TypeMetadata, alignment::VulkanAlignment)
  (; tmap) = tmeta
  VulkanLayout(alignment, tmap, Dict(t => storage_classes(tmeta, t) for t in tmap), Set(filter!(t -> isinterface(tmeta, t), collect(tmap))))
end

VulkanLayout(ir::IR, alignment::VulkanAlignment) = VulkanLayout(TypeMetadata(ir), alignment)

"""
Shader-compatible layout strategy, where layout information is strictly read from shader decorations.
"""
struct ShaderLayout <: LayoutStrategy
  tmeta::TypeMetadata
end

stride(layout::ShaderLayout, T::Type) = stride(layout, layout.tmeta.tmap[T])
datasize(layout::ShaderLayout, T::Type) = datasize(layout, layout.tmeta.tmap[T])
dataoffset(layout::ShaderLayout, T::Type, i::Integer) = dataoffset(layout, layout.tmeta.tmap[T], i)
alignment(layout::ShaderLayout, T::Type) = alignment(layout, layout.tmeta.tmap[T])

dataoffset(layout::ShaderLayout, t::StructType, i::Integer) = getoffset(layout.tmeta, t, i)

function Base.merge!(ir::IR, tmeta::TypeMetadata)
  for (t, meta) in pairs(tmeta.d)
    tid = ir.types[t]
    merge_metadata!(ir, tid, meta)
  end
end

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
  s = stride(layout, t.eltype)
  decorate!(tmeta, t, DecorationArrayStride, s)
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
  s = stride(layout, subt.eltype.eltype)
  decorate!(tmeta, t, i, DecorationMatrixStride, s)
end

"Follow Julia's column major layout by default, consistently with the `Mat` frontend type."
add_matrix_layout!(tmeta::TypeMetadata, t::StructType, i, subt::MatrixType) = decorate!(tmeta, t, i, subt.is_column_major ? DecorationColMajor : DecorationRowMajor)

function add_offsets!(tmeta::TypeMetadata, t::StructType, layout::VulkanLayout)
  for (i, subt) in enumerate(t.members)
    decorate!(tmeta, t, i, DecorationOffset, dataoffset(layout, t, i))
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

function getoffset(tmeta::TypeMetadata, t, i)
  decs = decorations(tmeta, t, i)
  isnothing(decs) && error("Missing decorations on member ", i, " of the aggregate type ", t)
  has_decoration(decs, DecorationOffset) || error("Missing offset declaration for member ", i, " on ", t)
  decs.offset
end

function payload_sizes!(sizes, T)
  !is_composite_type(T) && return push!(sizes, payload_size(T))
  for subT in member_types(T)
    payload_sizes!(sizes, subT)
  end
  sizes
end
payload_sizes(T) = payload_sizes!(Int[], T)

is_composite_type(t::SPIRType) = isa(t, StructType)
is_composite_type(T::DataType) = isstructtype(T) && !(T <: Vector) && !(T <: Vec) && !(T <: Mat)
member_types(t::StructType) = t.members
member_types(T::DataType) = fieldtypes(T)

function getoffsets!(offsets, base, getoffset, T)
  !is_composite_type(T) && return offsets
  for (i, subT) in enumerate(member_types(T))
    new_offset = base + getoffset(T, i)
    is_composite_type(subT) ? getoffsets!(offsets, new_offset, getoffset, subT) : push!(offsets, new_offset)
  end
  offsets
end

getoffsets(getoffset, t::SPIRType) = getoffsets!(UInt32[], 0U, getoffset, t)
getoffsets(T::DataType) = getoffsets!(UInt32[], 0U, getoffset_julia, T)
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
