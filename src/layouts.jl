scalar_alignment(::BooleanType) = 0
scalar_alignment(T::Union{IntegerType,FloatType}) = T.width ÷ 8
scalar_alignment(T::Union{VectorType,MatrixType,ArrayType}) = scalar_alignment(T.eltype)
scalar_alignment(T::StructType) = maximum(scalar_alignment, T.members)

base_alignment(T::ScalarType) = scalar_alignment(T)
base_alignment(T::VectorType) = (T.n == 2 ? 2 : 4) * scalar_alignment(T.eltype)
base_alignment(T::ArrayType) = base_alignment(T.eltype)
function base_alignment(T::StructType)
  if isempty(T.members)
    # Requires knowing the smallest scalar type permitted
    # by the storage class & module capabilities.
    error("Not implemented.")
  else
    maximum(base_alignment, T.members)
  end
end
base_alignment(T::MatrixType, is_column_major::Bool) = is_column_major ? base_alignment(T.eltype) : base_alignment(VectorType(T.eltype.eltype, T.n))

extended_alignment(T::SPIRType) = base_alignment(T)
extended_alignment(T::Union{ArrayType,StructType}) = 16 * cld(base_alignment(T), 16)
extended_alignment(T::MatrixType, is_column_major::Bool) = is_column_major ? extended_alignment(T.eltype) : extended_alignment(VectorType(T.eltype.eltype, T.n))

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

Base.size(T::ArrayType) = scalar_alignment(T) * prod((T.size::Constant).value...)
Base.size(T::VectorType) = base_alignment(T)
Base.size(T::ScalarType) = scalar_alignment(T)

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
      ::MatrixType => extended_alignment(t, true)
      _ => extended_alignment(t)
    end
    ::MatrixType => base_alignment(t, true)
    _ => base_alignment(t)
  end
end

function storage_classes(ir::IR, t::SPIRType)
  Set(type.storage_class for type in ir.types if isa(type, PointerType) && type.type == t)
end

function add_type_layouts!(ir::IR, layout::LayoutStrategy)
  for (T, t) in pairs(ir.typerefs)
    @tryswitch t begin
      @case ::ArrayType && if !isa(t.eltype, SampledImageType) && !isa(t.eltype, ImageType) && !isa(t.eltype, SamplerType)
      end
      add_stride!(ir, t, T, layout)

      @case ::MatrixType
      add_stride!(ir, t, T, layout)
      add_matrix_layout!(ir, t)

      @case ::StructType
      add_offsets!(ir, T, t, layout)
    end
  end
end

function add_stride!(ir, t::Union{ArrayType,MatrixType}, T, layout)
  # Array of shader resources. Must not be decorated.
  isa(t.eltype, StructType) && has_decoration(ir, t.eltype, DecorationBlock) && return
  stride = size(eltype(T), ir, layout)
  isa(t, ArrayType) ? decorate!(ir, t, DecorationArrayStride, stride) : decorate!(ir, t, DecorationMatrixStride, stride)
end

function add_matrix_layout!(ir, t::MatrixType)
  # The matrix must have come from `Mat` which is column-major.
  decorate!(ir, t, DecorationColMajor)
end

function add_offsets!(ir, T, t, layout)
  scs = storage_classes(ir, t)
  current_offset = 0
  n = fieldcount(T)
  for (i, subT) in enumerate(fieldtypes(T))
    subt = (t::StructType).members[i]
    alignmt = alignment(layout, subt, scs, has_decoration(ir, t, DecorationBlock))
    current_offset = alignmt * cld(current_offset, alignmt)
    decorate!(ir, t, i, DecorationOffset, current_offset)
    i ≠ n && (current_offset += size(subT, ir, layout))
  end
end

function Base.size(T::DataType, ir::IR, layout::LayoutStrategy)
  res = 0
  t = ir.typerefs[T]
  scs = storage_classes(ir, t)
  n = fieldcount(T)
  !isa(t, StructType) && return size(t)
  for (i, subT) in enumerate(fieldtypes(T))
    subt = (t::StructType).members[i]
    if i ≠ 1
      alignmt = alignment(layout, subt, scs, has_decoration(ir, t, DecorationBlock))
      res = alignmt * cld(res, alignmt)
    end
    res += size(subT, ir, layout)
  end
  res
end
