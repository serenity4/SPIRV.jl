"""
Layout strategy used to compute alignments, offsets and strides.
"""
@refbroadcast abstract type LayoutStrategy end

function padding(layout, T, i)
  i == 1 && return 0
  offset = dataoffset(layout, T, i)
  last = dataoffset(layout, T, i - 1) + datasize(layout, fieldtype(T, i - 1))
  offset - last
end

function padding(layout, ::Type{<:Array{T}}) where {T}
  s = stride(layout, T)
  s - datasize(layout, T)
end

""""
Julia layout, with a special handling of mutable fields for composite types.

Mutable fields are stored as 8-byte pointers in Julia, but in SPIR-V there is no such concept of pointer.
Therefore, we treat mutable fields as if they were fully inlined - that imposes a few restrictions on the
behavior of such mutable objects, but is necessary to keep some form of compatibility with GPU representations.
The alternative would be to completely disallow structs which contain mutable fields.
"""
struct NativeLayout <: LayoutStrategy end

Base.stride(layout::NativeLayout, T::Type) = ismutabletype(T) ? datasize(layout, T) : Base.elsize(Vector{T})
function datasize(layout::NativeLayout, T::DataType)
  isbitstype(T) && return sizeof(T)
  isconcretetype(T) || error("A concrete type is required.")
  @assert isstructtype(T)
  total_padding = sum(dataoffset(layout, T, i) - (dataoffset(layout, T, i - 1) + datasize(layout, fieldtype(T, i - 1))) for i in 2:fieldcount(T); init = 0)
  sum(datasize(layout, subT) for subT in fieldtypes(T); init = 0) + total_padding
end
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

"""
Layout strategy which assumes no padding is required at all.
This might be useful for maximally packing data when serialized, reducing size;
or to improve performance by avoiding padding when not needed, e.g. if you already
pad your structures manually upfront (only do that if you know what you're doing).
"""
struct NoPadding <: LayoutStrategy end

Base.stride(layout::NoPadding, ::Type{T}) where {T} = datasize(layout, T)
datasize(layout::NoPadding, ::Type{T}) where {T} = isprimitivetype(T) ? sizeof(T) : sum(ntuple(i -> datasize(layout, fieldtype(T, i)), fieldcount(T)); init = 0)::Int64
dataoffset(layout::NoPadding, ::Type{T}, i::Integer) where {T} = sum(ntuple(i -> datasize(layout, fieldtype(T, i)), i - 1); init = 0)::Int64
alignment(::NoPadding, ::Type) = 0

padding(::NoPadding, T, i) = 0
padding(::NoPadding, ::Type{Vector{T}}) where {T} = 0

@struct_hash_equal struct LayoutInfo
  stride::Int
  datasize::Int
  alignment::Int
  dataoffsets::Optional{Vector{Int}}
end

LayoutInfo(layout::LayoutStrategy, T::Type) = LayoutInfo(stride(layout, T), datasize(layout, T), alignment(layout, T), isstructtype(T) ? dataoffset.(layout, T, 1:fieldcount(T)) : nothing)

@struct_hash_equal struct ExplicitLayout <: LayoutStrategy
  d::IdDict{DataType,LayoutInfo}
end

Base.stride(layout::ExplicitLayout, T::Type) = layout.d[T].stride
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
@struct_hash_equal struct VulkanLayout <: LayoutStrategy
  alignment::VulkanAlignment
  tmap::TypeMap
  storage_classes::Dict{SPIRType,Set{StorageClass}}
  interfaces::Set{StructType}
end

Base.getindex(layout::VulkanLayout, T::DataType) = getindex(layout.tmap, T)

storage_classes(layout::VulkanLayout, t::SPIRType) = get!(Set{StorageClass}, layout.storage_classes, t)
isinterface(layout::VulkanLayout, t::StructType) = in(t, layout.interfaces)
isinterface(layout::VulkanLayout, ::SPIRType) = false

Base.stride(layout::VulkanLayout, T::Type) = stride(layout, layout[T])
datasize(layout::VulkanLayout, T::Type) = datasize(layout, layout[T])
dataoffset(layout::VulkanLayout, T::Type, i::Integer) = dataoffset(layout, layout[T], i)
alignment(layout::VulkanLayout, T::Type) = alignment(layout, layout[T])

Base.stride(::VulkanLayout, t::ScalarType) = scalar_alignment(t)
Base.stride(layout::VulkanLayout, t::Union{VectorType, MatrixType}) = t.n * stride(layout, t.eltype)
Base.stride(layout::VulkanLayout, t::ArrayType) = extract_size(t) * stride(layout, t.eltype)
function Base.stride(layout::VulkanLayout, t::StructType)
  req_alignment = alignment(layout, t)
  req_alignment * cld(datasize(layout, t), req_alignment)
end
datasize(layout::LayoutStrategy, t::ScalarType) = scalar_alignment(t)
datasize(layout::LayoutStrategy, t::Union{VectorType,MatrixType}) = t.n * datasize(layout, t.eltype)
datasize(layout::LayoutStrategy, t::ArrayType) = extract_size(t) * stride(layout, t.eltype)
datasize(layout::LayoutStrategy, t::StructType) = dataoffset(layout, t, length(t.members)) + datasize(layout, t.members[end])
dataoffset(layout::VulkanLayout, t::SPIRType, i::Integer) = 0
dataoffset(layout::VulkanLayout, t::ArrayType, i::Integer) = (i - 1) * stride(layout, t.eltype)
function dataoffset(layout::VulkanLayout, t::StructType, i::Integer)
  i == 1 && return 0
  subt = t.members[i]
  req_alignment = alignment(layout, subt)
  prevloc = dataoffset(layout, t, i - 1) + datasize(layout, t.members[i - 1])
  offset = req_alignment * cld(prevloc, req_alignment)
  !isa(subt, VectorType) && return offset
  # Prevent vectors from straddling improperly, as defined per the specification.
  n = datasize(layout, subt)
  n > 16 && return 16cld(offset, 16)
  offset % 16 + n > 16 && return 16cld(offset, 16)
  offset
end
alignment(layout::VulkanLayout, t::SPIRType) = alignment(layout.alignment, t, storage_classes(layout, t), isinterface(layout, t))

function extract_size(t::ArrayType)
  (; size) = t
  !isnothing(size) || throw(ArgumentError("Array types must be sized to extract their size."))
  !size.is_spec_const || error("Arrays with a size provided by a specialization constants are not supported for size calculations yet.")
  isa(size.value, Integer) || error("Expected an integer array size, got ", size.value)
  size.value
end

function Base.merge!(x::VulkanLayout, y::VulkanLayout)
  x.alignment == y.alignment || error("Cannot merge `VulkanLayout`s with different alignment specifications.")
  merge!(x.tmap, y.tmap)
  merge!(x.storage_classes, y.storage_classes)
  union!(x.interfaces, y.interfaces)
  x
end

"""
Type metadata meant to be analyzed and modified to generate appropriate decorations.
"""
@struct_hash_equal struct TypeMetadata
  tmap::TypeMap
  d::Dictionary{SPIRType, Metadata}
end

TypeMetadata(tmap::TypeMap = TypeMap()) = TypeMetadata(tmap, Dictionary())

@forward_methods TypeMetadata field = :d metadata!(_, args...) has_decoration(_, args...) decorate!(_, args...) decorations(_, args...)
@forward_methods TypeMetadata field = :tmap Base.getindex(_, T::DataType)

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

function TypeMetadata(Ts; storage_classes = Dict(), interfaces = [])
  tmeta = TypeMetadata()
  for T in Ts
    type = spir_type(T, tmeta.tmap)
    for sc in get(Vector{StorageClass}, storage_classes, T)
      metadata!(tmeta, PointerType(sc, type))
    end
    in(T, interfaces) && decorate!(tmeta, type::StructType, DecorationBlock)
  end
  tmeta
end

function storage_classes(types, t::SPIRType)
  Set{StorageClass}(type.storage_class for type in types if isa(type, PointerType) && type.type == t)
end
storage_classes(tmeta::TypeMetadata, t::SPIRType) = storage_classes(keys(tmeta.d), t)

isinterface(tmeta::TypeMetadata, t::StructType) = has_decoration(tmeta, t, DecorationBlock)
isinterface(tmeta::TypeMetadata, ::SPIRType) = false

VulkanLayout(alignment::VulkanAlignment) = VulkanLayout(alignment, TypeMap(), Dict{SPIRType, Set{StorageClass}}(), Set{StructType}())

function VulkanLayout(tmeta::TypeMetadata, alignment::VulkanAlignment)
  (; tmap) = tmeta
  VulkanLayout(alignment, tmap, Dict(t => storage_classes(tmeta, t) for t in tmap), Set(StructType[t for t in tmap if isa(t, StructType) && isinterface(tmeta, t)]))
end

VulkanLayout(ir::IR, alignment::VulkanAlignment) = VulkanLayout(TypeMetadata(ir), alignment)

function TypeMetadata(layout::VulkanLayout)
  tmeta = TypeMetadata(layout.tmap)
  for (t, scs) in layout.storage_classes
    for sc in scs
      metadata!(tmeta, PointerType(sc, t))
    end
  end
  for t in layout.interfaces
    decorate!(tmeta, t::StructType, DecorationBlock)
  end
  tmeta
end

VulkanLayout(Ts; alignment = VulkanAlignment(), storage_classes = Dict(), interfaces = []) = VulkanLayout(TypeMetadata(Ts; storage_classes, interfaces), alignment)

"""
Shader-compatible layout strategy, where layout information is strictly read from shader decorations.
"""
@struct_hash_equal struct ShaderLayout <: LayoutStrategy
  tmeta::TypeMetadata
end

Base.getindex(layout::ShaderLayout, T::DataType) = getindex(layout.tmeta, T)

Base.stride(layout::ShaderLayout, T::Type) = stride(layout, layout[T])
datasize(layout::ShaderLayout, T::Type) = datasize(layout, layout[T])
dataoffset(layout::ShaderLayout, T::Type, i::Integer) = dataoffset(layout, layout[T], i)
alignment(layout::ShaderLayout, T::Type) = alignment(layout, layout[T])

dataoffset(layout::ShaderLayout, t::StructType, i::Integer) = dataoffset(layout.tmeta, t, i)

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
  s = stride(layout, eltype_major(subt))
  decorate!(tmeta, t, i, DecorationMatrixStride, s)
end

"Follow Julia's column major layout by default, consistently with the `Mat` frontend type."
add_matrix_layout!(tmeta::TypeMetadata, t::StructType, i, subt::MatrixType) = decorate!(tmeta, t, i, subt.is_column_major ? DecorationColMajor : DecorationRowMajor)

function add_offsets!(tmeta::TypeMetadata, t::StructType, layout::VulkanLayout)
  for (i, subt) in enumerate(t.members)
    decorate!(tmeta, t, i, DecorationOffset, dataoffset(layout, t, i))
  end
end

function dataoffset(tmeta::TypeMetadata, t, i)
  decs = decorations(tmeta, t, i)
  isnothing(decs) && error("Missing decorations on member ", i, " of the aggregate type ", t)
  has_decoration(decs, DecorationOffset) || error("Missing offset declaration for member ", i, " on ", t)
  decs.offset
end
