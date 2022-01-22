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
base_alignment(T::MatrixType, is_column_major::Bool) = is_column_major ? base_alignment(T.eltype) : base_alignment(VectorType(T.eltype.eltype, T.n))

extended_alignment(T::SPIRType) = base_alignment(T)
extended_alignment(T::Union{ArrayType,StructType}) = 16 * cld(base_alignment(T), 16)

abstract type LayoutStrategy end

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
      @case ::ArrayType
      add_stride!(ir, t, T, layout)

      @case ::MatrixType
      add_stride!(ir, t, T, layout)
      add_matrix_layout!(ir, t)

      @case ::StructType
      # add_type_layouts!(ir, fieldtypes(T), layout)
      add_offsets!(ir, T, t, layout)
    end
  end
end

function add_stride!(ir, t::Union{ArrayType, MatrixType}, T, layout)
  decs = get!(DecorationData, ir.decorations, ir.types[t])
  if isa(t.eltype, StructType) && haskey(get(DecorationData, ir.decorations, ir.types[t.eltype]), DecorationBlock)
    # Array of shader resources. Must not be decorated.
    return
  end
  dec = isa(t, ArrayType) ? DecorationArrayStride : DecorationMatrixStride
  set!(decs, dec, [UInt32(size(eltype(T), ir, layout))])
end

function add_matrix_layout!(ir, t::MatrixType)
  decs = get!(DecorationData, ir.decorations, ir.types[t])
  # The matrix must have come from `Mat` which is column-major.
  set!(decs, DecorationColMajor, [])
end

function add_offsets!(ir, T, t, layout)
  parent_decs = get(DecorationData, ir.decorations, ir.types[t])
  scs = storage_classes(ir, t)
  current_offset = 0
  n = fieldcount(T)
  for (i, name, subT) in zip(1:n, fieldnames(T), fieldtypes(T))
    subt = (t::StructType).members[i]
    member_decs = get!(DecorationData, t.member_decorations, i)
    alignmt = alignment(layout, subt, scs, haskey(parent_decs, DecorationBlock))
    current_offset = alignmt * cld(current_offset, alignmt)
    insert!(member_decs, DecorationOffset, [UInt32(current_offset)])
    i ≠ n && (current_offset += size(subT, ir, layout))
  end
end

function Base.size(T::DataType, ir::IR, layout::LayoutStrategy)
  res = 0
  t = ir.typerefs[T]
  parent_decs = get(DecorationData, ir.decorations, ir.types[t])
  scs = storage_classes(ir, t)
  n = fieldcount(T)
  !isa(t, StructType) && return size(t)
  for (i, name, subT) in zip(1:n, fieldnames(T), fieldtypes(T))
    subt = (t::StructType).members[i]
    if i ≠ 1
      alignmt = alignment(layout, subt, scs, haskey(parent_decs, DecorationBlock))
      res = alignmt * cld(res, alignmt)
    end
    res += size(subT, ir, layout)
  end
  res
end
