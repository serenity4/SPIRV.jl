"""
Layout strategy used to compute alignments, offsets and strides.
"""
@refbroadcast abstract type LayoutStrategy end

"""
    alignment(layout, T)

Memory alignment which must be respected when allocating a value of the given type.

This refers to an *external* alignment, i.e. this value is of interest when allocating a value of type `T` within a struct or array. In particular, this value *does not* indicate what should be the alignment of any struct member or the stride of any array element contained in `T`, if `T` is a struct or an array.
"""
function alignment end

"""
    padding(layout, T, i) # padding before struct member `i` of `T`
    padding(layout, T) # padding between elements of array type `T`

Required space between elements of an array (two-argument form) or between members of a structure (three-argument form).
"""
function padding end

"""
    element_stride(layout, T)

Minimum array stride required by an element of type `T` if it were to be part of an array.

The stride of an array must be a multiple of this element stride, and thus may be greater.
"""
function element_stride end

"""
    datasize(layout, T)

This is the total space occupied by a value of type `T`, including padding between struct elements and array strides.
"""
function datasize end

element_stride(layout::LayoutStrategy, t, array_sizes...) = align(datasize(layout, t, array_sizes...), alignment(layout, t, array_sizes...))

function padding(layout::LayoutStrategy, ::Type{T}, i) where {T}
  i == 1 && return 0
  offset = dataoffset(layout, T, i)
  last = dataoffset(layout, T, i - 1) + datasize(layout, fieldtype(T, i - 1))
  offset - last
end

padding(layout::LayoutStrategy, x::VecOrMat) = padding(layout, typeof(x))
padding(layout::LayoutStrategy, ::Type{T}) where {T} = error("Padding not defined for `$(typeof(layout))` with type `$T`")
padding(layout::LayoutStrategy, x::VecOrMat{<:VecOrMat}) = padding(layout, typeof(x), size(x[1]))
function padding(layout::LayoutStrategy, A::Type{<:VecOrMat{T}}, sizes...) where {T}
  s = stride(layout, Vector{T}, sizes...)
  s - datasize(layout, T, sizes...)
end

align(offset::Integer, alignment::Integer) = alignment * cld(offset, alignment)

datasize(layout::LayoutStrategy, ::Type{T}, size) where {T<:VecOrMat} = stride(layout, T) * prod(size; init = 1)
datasize(layout::LayoutStrategy, ::Type{T}, size_outer, size_inner) where {T<:VecOrMat{<:VecOrMat}} = stride(layout, T, size_inner) * prod(size_outer; init = 1)
datasize(layout::LayoutStrategy, x::VecOrMat) = datasize(layout, typeof(x), size(x))
datasize(layout::LayoutStrategy, x::VecOrMat{<:VecOrMat}) = datasize(layout, typeof(x), size(x), size(x[1]))
datasize(layout::LayoutStrategy, x) = datasize(layout, typeof(x))

Base.stride(layout::LayoutStrategy, ::Type{T}) where {ET,T<:VecOrMat{ET}} = element_stride(layout, ET)
Base.stride(layout::LayoutStrategy, ::Type{<:VecOrMat{T}}, size_inner) where {T<:VecOrMat} = datasize(layout, T, size_inner)

""""
Julia layout, with a special handling of mutable fields for composite types.

Mutable fields are stored as 8-byte pointers in Julia, but in SPIR-V there is no such concept of pointer.
Therefore, we treat mutable fields as if they were fully inlined - that imposes a few restrictions on the
behavior of such mutable objects, but is necessary to keep some form of compatibility with GPU representations.
The alternative would be to completely disallow structs which contain mutable fields.
"""
struct NativeLayout <: LayoutStrategy end

datasize(layout::NativeLayout, ::Type{<:VecOrMat}) = error("Array dimensions must be provided to know the size of a vector or a matrix. If you intend to get the size of a vector of vectors or a vector of matrices, you must not use a tuple and must either provide a value or extra dimension arguments.")

Base.@assume_effects :foldable Base.@constprop :aggressive @inline function datasize(layout::NativeLayout, ::Type{T}) where {T}
  isbitstype(T) && return sizeof(T)
  isconcretetype(T) || error("A concrete type is required.")
  @assert isstructtype(T)
  n = fieldcount(T)
  offsets = ntuple(i -> dataoffset(layout, T, i), n)
  sizes = ntuple(i -> datasize(layout, fieldtype(T, i)), n)
  total_padding = sum(offsets[2:n] .- (offsets[1:(n - 1)] .+ sizes[1:(n - 1)]); init = 0)
  sum(sizes; init = 0) + total_padding
end

Base.@assume_effects :foldable Base.@constprop :aggressive function dataoffset(layout::NativeLayout, ::Type{T}, i::Int) where {T}
  i == 1 && return fieldoffset(T, 1)
  Tprev = fieldtype(T, i - 1)
  # Account for any padding that might have been inserted between the current and previous members.
  padding = fieldoffset(T, i) - (fieldoffset(T, i - 1) + field_sizeof(Tprev))
  computed_offset = dataoffset(layout, T, i - 1) + datasize(layout, Tprev)
  padding + computed_offset
end

field_sizeof(::Type{T}) where {T} = ismutabletype(T) ? UInt(8) : UInt(sizeof(T))
alignment(::NativeLayout, ::Type{T}) where {T} = Base.datatype_alignment(T)

"""
Layout strategy which assumes no padding is required at all.
This might be useful for maximally packing data when serialized, reducing size;
or to improve performance by avoiding padding when not needed, e.g. if you already
pad your structures manually upfront (only do that if you know what you're doing).
"""
struct NoPadding <: LayoutStrategy end

Base.stride(layout::NoPadding, ::Type{<:VecOrMat{T}}) where {T} = element_stride(layout, T)
element_stride(layout::NoPadding, T) = datasize(layout, T)
datasize(layout::NoPadding, ::Type{T}) where {T} = isprimitivetype(T) ? sizeof(T) : sum(ntuple(i -> datasize(layout, fieldtype(T, i)), fieldcount(T)); init = 0)::Int
dataoffset(layout::NoPadding, ::Type{T}, i::Integer) where {T} = sum(ntuple(i -> datasize(layout, fieldtype(T, i)), i - 1); init = 0)::Int
alignment(::NoPadding, ::Type{T}) where {T} = 1

padding(::NoPadding, ::Type{T}, i::Integer) where {T} = 0
padding(::NoPadding, ::Type{Vector{T}}) where {T} = 0

@struct_hash_equal struct LayoutInfo
  stride::Int
  datasize::Int
  alignment::Int
  dataoffsets::Optional{Vector{Int}}
end

LayoutInfo(layout::LayoutStrategy, ::Type{T}) where {T} = LayoutInfo(stride_or_element_stride(layout, T), datasize(layout, T), alignment(layout, T), isstructtype(T) ? dataoffset.(layout, T, 1:fieldcount(T)) : nothing)

stride_or_element_stride(layout::LayoutStrategy, ::Type{T}) where {T} = element_stride(layout, T)
stride_or_element_stride(layout::LayoutStrategy, T::Type{<:Vector}) = stride(layout, T)

@struct_hash_equal struct ExplicitLayout <: LayoutStrategy
  d::IdDict{DataType,LayoutInfo}
end

Base.stride(layout::ExplicitLayout, ::Type{T}) where {ET,T<:VecOrMat{ET}} = layout.d[T].stride
Base.stride(layout::ExplicitLayout, ::Type{T}) where {T} = layout.d[T].stride
element_stride(layout::ExplicitLayout, ::Type{T}) where {T} = layout.d[T].stride
datasize(layout::ExplicitLayout, ::Type{T}) where {T} = layout.d[T].datasize
dataoffset(layout::ExplicitLayout, ::Type{T}, i::Integer) where {T} = (layout.d[T].dataoffsets::Vector{Int})[i]
alignment(layout::ExplicitLayout, ::Type{T}) where {T} = layout.d[T].alignment

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

function scalar_alignment(type::SPIRType)
  @match type.typename begin
    &SPIR_TYPE_BOOLEAN => 0
    &SPIR_TYPE_INTEGER => type.integer.width ÷ 8
    &SPIR_TYPE_FLOAT => type.float.width ÷ 8
    &SPIR_TYPE_VECTOR => scalar_alignment(type.vector.eltype)
    &SPIR_TYPE_MATRIX => scalar_alignment(type.matrix.eltype)
    &SPIR_TYPE_ARRAY => scalar_alignment(type.array.eltype)
    &SPIR_TYPE_STRUCT => maximum(scalar_alignment, type.struct.members; init = 0)
  end
end

function base_alignment(type::SPIRType)
  is_scalar(type) && return scalar_alignment(type)
  @match type.typename begin
    &SPIR_TYPE_VECTOR => begin
      (; eltype, n) = type.vector
      ifelse(n == 2, 2, 4) * scalar_alignment(eltype)
    end
    &SPIR_TYPE_MATRIX => base_alignment(eltype_major(type))
    &SPIR_TYPE_ARRAY => base_alignment(type.array.eltype)
    &SPIR_TYPE_STRUCT => begin
      (; members) = type.struct
      # XXX: To lower this would require knowing the smallest scalar type permitted
      # by the storage class & module capabilities.
      # E.g. 8-bit and 16-bit alignments are allowed by capabilities
      # StoragePushConstant8/StoragePushConstant16 and similarly for other storage classes.
      isempty(members) && return 4
      # Equivalent to `maximum(base_alignment, members; init = 0)`, but avoids dyamic dispatch in `mapreduce`.
      alignment = 0
      for member in members
        alignment = max(alignment, base_alignment(member))
      end
      alignment
    end
  end
end

function extended_alignment(type::SPIRType)
  @match type.typename begin
    &SPIR_TYPE_MATRIX => extended_alignment(eltype_major(type))
    &SPIR_TYPE_ARRAY || &SPIR_TYPE_STRUCT => align(base_alignment(type), 16)
    _ => base_alignment(type)
  end
end

"""
Vulkan-compatible layout strategy.
"""
@struct_hash_equal struct VulkanLayout <: LayoutStrategy
  alignment::VulkanAlignment
  tmap::TypeMap
  storage_classes::Dict{SPIRType,Vector{StorageClass}}
  interfaces::Vector{SPIRType}
end

Base.getindex(layout::VulkanLayout, T::DataType) = getindex(layout.tmap, T)

storage_classes(layout::VulkanLayout, type::SPIRType) = get!(Vector{StorageClass}, layout.storage_classes, type)
isinterface(layout::VulkanLayout, type::SPIRType) = istype(type, SPIR_TYPE_STRUCT) && in(type, layout.interfaces)

alignment(layout::VulkanLayout, type::SPIRType) = alignment(layout, layout.alignment, type)

function alignment(layout::VulkanLayout, vulkan::VulkanAlignment, type::SPIRType)
  istype(type, SPIR_TYPE_VECTOR) && return scalar_alignment(type)
  istype(type, SPIR_TYPE_STRUCT) || return base_alignment(type)
  # XXX: Compute storage classes at construction/metadata merging,
  # to avoid recomputing them here every time.
  storage_classes = SPIRV.storage_classes(layout, type)
  isinterface = SPIRV.isinterface(layout, type)
  if vulkan.scalar_block_layout && any(in(storage_classes), (StorageClassUniform, StorageClassStorageBuffer, StorageClassPhysicalStorageBuffer, StorageClassPushConstant))
    scalar_alignment(type)
  elseif !vulkan.uniform_buffer_standard_layout && in(StorageClassUniform, storage_classes) && isinterface
    extended_alignment(type)
  else
    base_alignment(type)
  end
end

Base.stride(layout::VulkanLayout, ::Type{T}) where {T} = stride(layout, layout[T])::Int
Base.stride(layout::VulkanLayout, ::Type{T}) where {ET,T<:VecOrMat{ET}} = stride(layout, layout[T])
element_stride(layout::VulkanLayout, ::Type{T}) where {T} = element_stride(layout, layout[T])::Int
datasize(layout::VulkanLayout, ::Type{T}) where {T} = datasize(layout, layout[T])::Int
datasize(layout::VulkanLayout, data::Matrix{T}) where {T} = element_stride(layout, T) * length(data)
dataoffset(layout::VulkanLayout, ::Type{T}, i::Integer) where {T} = dataoffset(layout, layout[T], i)::Int
alignment(layout::VulkanLayout, ::Type{T}) where {T} = alignment(layout, layout[T])::Int

function Base.stride(layout::VulkanLayout, type::SPIRType)
  @match type.typename begin
    &SPIR_TYPE_ARRAY => align(element_stride(layout, type.array.eltype)::Int, alignment(layout, type))
    &SPIR_TYPE_MATRIX => align(element_stride(layout, eltype_major(type)), alignment(layout, type))
  end
end

function element_stride(layout::VulkanLayout, type::SPIRType)
  is_scalar(type) && return scalar_alignment(type)
  @match type.typename begin
    &SPIR_TYPE_VECTOR => begin
      (; eltype, n) = type.vector
      n * element_stride(layout, eltype)::Int
    end
    &SPIR_TYPE_MATRIX => begin
      (; eltype, n) = type.matrix
      n * element_stride(layout, eltype)::Int
    end
    &SPIR_TYPE_ARRAY => extract_size(type) * element_stride(layout, type.array.eltype)
    &SPIR_TYPE_STRUCT => align(datasize(layout, type), alignment(layout, type))
  end
end

function datasize(layout::LayoutStrategy, type::SPIRType)
  is_scalar(type) && return scalar_alignment(type)
  value = @match type.typename begin
    &SPIR_TYPE_VECTOR => begin
      (; eltype, n) = type.vector
      n * datasize(layout, eltype)
    end
    &SPIR_TYPE_MATRIX => begin
      (; eltype, n) = type.matrix
      n * datasize(layout, eltype)
    end
    &SPIR_TYPE_ARRAY => extract_size(type) * stride(layout, type)
    &SPIR_TYPE_STRUCT => begin
      (; members) = type.struct
      isempty(members) && return 0
      dataoffset(layout, type, lastindex(members)) + datasize(layout, members[end])
    end
  end
  value::Int
end

function dataoffset(layout::VulkanLayout, type::SPIRType, i::Integer)
  @match type.typename begin
    &SPIR_TYPE_ARRAY => (i - 1) * stride(layout, type)
    &SPIR_TYPE_STRUCT => begin
      i == 1 && return 0
      (; members) = type.struct
      member_type = members[i]
      req_alignment = alignment(layout, member_type)
      prevloc = dataoffset(layout, type, i - 1) + datasize(layout, members[i - 1])
      offset = align(prevloc, req_alignment)
      if istype(member_type, SPIR_TYPE_VECTOR)
        # Prevent vectors from straddling improperly, as defined per the specification.
        n = datasize(layout, member_type)
        if n > 16 || offset % 16 + n > 16
          offset = align(offset, 16)
        end
      end
      prev_member_type = members[i - 1]
      @match prev_member_type.typename begin
        # Advance an offset to have some padding in accordance with the specification:
        #   The `Offset` decoration of a member must not place it between the end of a structure,
        #   an array or a matrix and the next multiple of the alignment of that structure, array or matrix.
        # https://registry.khronos.org/vulkan/specs/1.3-extensions/html/chap15.html#interfaces-resources-layout
        &SPIR_TYPE_MATRIX || &SPIR_TYPE_ARRAY || &SPIR_TYPE_STRUCT => align(offset, alignment(layout, prev_member_type))
        _ => offset
      end
    end
    _ => 0
  end
end

function extract_size(type::SPIRType)
  assert_type(type, SPIR_TYPE_ARRAY)
  (; size) = type.array
  isnothing(size) && throw(ArgumentError("Array types must be sized to extract their size."))
  !size.is_spec_const[] || error("Arrays with a size provided by a specialization constants are not supported for size calculations.")
  Int(size.value::Union{UInt32, Int})
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
  for type in ir.tmap
    tid = get(ir.types, type, nothing)
    isnothing(tid) && continue
    meta = get(ir.metadata, tid, nothing)
    isnothing(meta) && continue
    insert!(tmeta.d, type, meta)
  end
  tmeta
end

function TypeMetadata(Ts; storage_classes = Dict(), interfaces = [])
  tmeta = TypeMetadata()
  for T in Ts
    type = spir_type(T, tmeta.tmap)
    for sc in get(Vector{StorageClass}, storage_classes, T)
      metadata!(tmeta, pointer_type(sc, type))
    end
    in(T, interfaces) || continue
    assert_type(type, SPIR_TYPE_STRUCT)
    decorate!(tmeta, type, DecorationBlock)
  end
  tmeta
end

function storage_classes(types, type::SPIRType)
  result = StorageClass[]
  for t in types
    istype(t, SPIR_TYPE_POINTER) || continue
    t.pointer.type == type || continue
    !in(t.pointer.storage_class, result) && push!(result, t.pointer.storage_class)
  end
  result
end
storage_classes(tmeta::TypeMetadata, type::SPIRType) = storage_classes(keys(tmeta.d), type)

isinterface(tmeta::TypeMetadata, type::SPIRType) = istype(type, SPIR_TYPE_STRUCT) && has_decoration(tmeta, type, DecorationBlock)

VulkanLayout(alignment::VulkanAlignment) = VulkanLayout(alignment, TypeMap(), Dict{SPIRType, Set{StorageClass}}(), SPIRType[])
VulkanLayout(; scalar_block_layout::Bool = false, uniform_buffer_standard_layout::Bool = false) = VulkanLayout(VulkanAlignment(scalar_block_layout, uniform_buffer_standard_layout))

merge_layout!(layout::VulkanLayout, ir::IR) = merge_layout!(layout, TypeMetadata(ir))
function merge_layout!(layout::VulkanLayout, tmeta::TypeMetadata)
  merge!(layout.tmap, tmeta.tmap)
  for type in layout.tmap
    layout.storage_classes[type] = storage_classes(tmeta, type)
    istype(type, SPIR_TYPE_STRUCT) && isinterface(tmeta, type) || continue
    !in(type, layout.interfaces) && push!(layout.interfaces, type)
  end
  layout
end

function VulkanLayout(tmeta::TypeMetadata, alignment::VulkanAlignment)
  merge_layout!(VulkanLayout(alignment), tmeta)
end

VulkanLayout(ir::IR, alignment::VulkanAlignment) = VulkanLayout(TypeMetadata(ir), alignment)

function TypeMetadata(layout::VulkanLayout)
  tmeta = TypeMetadata(layout.tmap)
  for (type, scs) in layout.storage_classes
    for sc in scs
      metadata!(tmeta, pointer_type(sc, type))
    end
  end
  for type in layout.interfaces
    assert_type(type, SPIR_TYPE_STRUCT)
    decorate!(tmeta, type, DecorationBlock)
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

# XXX: This probably doesn't work.
element_stride(layout::ShaderLayout, ::Type{T}) where {T} = element_stride(layout, layout[T])::Int
Base.stride(layout::ShaderLayout, ::Type{T}) where {T} = stride(layout, layout[T])
datasize(layout::ShaderLayout, ::Type{T}) where {T} = datasize(layout, layout[T])
dataoffset(layout::ShaderLayout, ::Type{T}, i::Integer) where {T} = dataoffset(layout, layout[T], i)
alignment(layout::ShaderLayout, ::Type{T}) where {T} = alignment(layout, layout[T])

dataoffset(layout::ShaderLayout, type::SPIRType, i::Integer) = dataoffset(layout.tmeta, type, i)

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
  for type in tmeta.tmap
    @tryswitch type.typename begin
      @case &SPIR_TYPE_ARRAY
      (; eltype) = type.array
      if !in(eltype.typename, (SPIR_TYPE_SAMPLED_IMAGE, SPIR_TYPE_IMAGE, SPIR_TYPE_SAMPLER))
        add_array_stride!(tmeta, type, layout)
      end

      @case &SPIR_TYPE_STRUCT
      add_offsets!(tmeta, type, layout)
      add_matrix_layouts!(tmeta, type, layout)
    end
  end
  tmeta
end

function add_array_stride!(tmeta::TypeMetadata, type::SPIRType, layout::LayoutStrategy)
  assert_type(type, SPIR_TYPE_ARRAY)
  (; eltype) = type.array
  # Array of shader resources. Must not be decorated.
  istype(eltype, SPIR_TYPE_STRUCT) && has_decoration(tmeta, eltype, DecorationBlock) && return
  decorate!(tmeta, type, DecorationArrayStride, stride(layout, type))
end

function add_matrix_layouts!(tmeta::TypeMetadata, type::SPIRType, layout::LayoutStrategy)
  for (i, member_type) in enumerate(type.struct.members)
    istype(member_type, SPIR_TYPE_MATRIX) || continue
    add_matrix_stride!(tmeta, type, i, member_type, layout)
    add_matrix_layout!(tmeta, type, i, member_type)
  end
end

function add_matrix_stride!(tmeta::TypeMetadata, type::SPIRType, i, member_type::SPIRType, layout::LayoutStrategy)
  decorate!(tmeta, type, i, DecorationMatrixStride, stride(layout, member_type))
end

"Follow Julia's column major layout by default, consistently with the `Mat` frontend type."
add_matrix_layout!(tmeta::TypeMetadata, type::SPIRType, i, member_type::SPIRType) = decorate!(tmeta, type, i, member_type.matrix.is_column_major ? DecorationColMajor : DecorationRowMajor)

function add_offsets!(tmeta::TypeMetadata, type::SPIRType, layout::VulkanLayout)
  for (i, member_type) in enumerate(type.struct.members)
    decorate!(tmeta, type, i, DecorationOffset, dataoffset(layout, type, i))
  end
end

function dataoffset(tmeta::TypeMetadata, type::SPIRType, i)
  decs = decorations(tmeta, type, i)
  isnothing(decs) && error("Missing decorations on member ", i, " of the aggregate type ", t)
  has_decoration(decs, DecorationOffset) || error("Missing offset declaration for member ", i, " on ", t)
  decs.offset
end
