scalar_alignment(::BooleanType) = 0
scalar_alignment(T::Union{IntegerType,FloatType}) = T.width ÷ 8
scalar_alignment(T::ArrayType) = scalar_alignment(T.eltype)
scalar_alignment(T::Union{VectorType,MatrixType,ArrayType}) = scalar_alignment(T.eltype)
scalar_alignment(T::StructType) = maximum(scalar_alignment, T.members)

base_alignment(T::ScalarType) = scalar_alignment(T)
base_alignment(T::VectorType) = 2 * div(1 + T.n, 2) * scalar_alignment(T.eltype)
base_alignment(T::ArrayType) = scalar_alignment(T)
function base_alignment(T::StructType)
  if isempty(T.members)
    # Requires knowing the smallest scalar type permitted
    # by the storage class & module capabilities.
    error("Not implemented.")
  else
    maximum(base_alignment, T.members)
  end
end
base_alignment(T::MatrixType) = error("Not implemented.") # Requires knowing whether T is row- or column- major.

extended_alignment(T::SPIRType) = base_alignment(T)
extended_alignment(T::Union{ArrayType,StructType}) = 16 * cld(base_alignment(T), 16)

abstract type AlignmentStrategy end

Base.@kwdef struct VulkanAlignment <: AlignmentStrategy
  scalar_block_layout::Bool = false
  uniform_buffer_standard_layout::Bool = false
end

Base.size(T::ArrayType) = scalar_alignment(T) * prod((T.size::Constant).value...)
Base.size(T::VectorType) = base_alignment(T)
Base.size(T::ScalarType) = scalar_alignment(T)

function (align::VulkanAlignment)(T::DataType, t::SPIRType, current_offset, member_decs::DecorationData, parent_decs::DecorationData, storage_classes)
  @match t begin
    ::VectorType => scalar_alignment(t)
    if align.scalar_block_layout && !isempty(intersect(storage_classes, [StorageClassUniform, StorageClassStorageBuffer,
      StorageClassPhysicalStorageBuffer, StorageClassPushConstant])) end => scalar_alignment(t)
    if !align.uniform_buffer_standard_layout && StorageClassUniform in storage_classes && haskey(parent_decs, DecorationBlock) end => extended_alignment(t)
    _ => base_alignment(t)
  end
end

function add_field_offsets!(ir::IR, align::AlignmentStrategy)
  for (T, t) in pairs(ir.typerefs)
    !isa(t, StructType) && continue
    parent_decs = get(DecorationData, ir.decorations, ir.types[t])
    storage_classes = Set(type.storage_class for type in ir.types if isa(type, PointerType) && type.type == t)
    current_offset = 0
    for (i, name, subT) in zip(1:fieldcount(T), fieldnames(T), fieldtypes(T))
      subt = (t::StructType).members[i]
      member_decs = get!(DecorationData, t.member_decorations, i)
      alignment = align(subT, subt, current_offset, member_decs, parent_decs, storage_classes)
      current_offset = alignment * cld(current_offset, alignment)
      insert!(member_decs, DecorationOffset, [UInt32(current_offset)])
      current_offset += size(subT, ir, align)
    end
  end
end

function Base.size(T::DataType, ir::IR, align::AlignmentStrategy)
  res = 0
  t = ir.typerefs[T]
  parent_decs = get(DecorationData, ir.decorations, ir.types[t])
  storage_classes = Set(type.storage_class for type in ir.types if isa(type, PointerType) && type.type == t)
  n = fieldcount(T)
  !isa(t, StructType) && return size(t)
  for (i, name, subT) in zip(1:n, fieldnames(T), fieldtypes(T))
    member_decs = get(DecorationData, t.member_decorations, i)
    subt = (t::StructType).members[i]

    if i ≠ 1
      alignment = align(subT, subt, res, member_decs, parent_decs, storage_classes)
      res = alignment * cld(res, alignment)
    end
    res += size(subT, ir, align)
  end
  res
end
