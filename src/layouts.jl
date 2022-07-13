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
base_alignment(t::MatrixType, is_column_major::Bool) = is_column_major ? base_alignment(t.eltype) : base_alignment(VectorType(t.eltype.eltype, t.n))

extended_alignment(t::SPIRType) = base_alignment(t)
extended_alignment(t::Union{ArrayType,StructType}) = 16 * cld(base_alignment(t), 16)
extended_alignment(t::MatrixType, is_column_major::Bool) = is_column_major ? extended_alignment(t.eltype) : extended_alignment(VectorType(t.eltype.eltype, t.n))

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
      # TODO: Look up matrix layout from the IR.
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
  for t in ir.typerefs
    @tryswitch t begin
      @case ::ArrayType && if !isa(t.eltype, SampledImageType) && !isa(t.eltype, ImageType) && !isa(t.eltype, SamplerType)
      end
      add_stride!(ir, t, layout)

      @case ::MatrixType
      add_stride!(ir, t, layout)
      add_matrix_layout!(ir, t)

      @case ::StructType
      add_offsets!(ir, t, layout)
    end
  end
end

function add_stride!(ir::IR, t::ArrayType, layout::LayoutStrategy)
  # Array of shader resources. Must not be decorated.
  isa(t.eltype, StructType) && has_decoration(ir, t.eltype, DecorationBlock) && return
  stride = compute_stride(t.eltype, ir, layout)
  isa(t, ArrayType) ? decorate!(ir, t, DecorationArrayStride, stride) : decorate!(ir, t, DecorationMatrixStride, stride)
  decorate!(ir, t, DecorationArrayStride, stride)
end

function add_stride!(ir::IR, t::MatrixType, layout::LayoutStrategy)
  stride = compute_stride(t.eltype.eltype, ir, layout)
  decorate!(ir, t, DecorationMatrixStride, stride)
end

"Follow Julia's column major layout by default, consistently with the `Mat` frontend type."
function add_matrix_layout!(ir::IR, t::MatrixType)
  !has_decoration(ir, t, DecorationRowMajor) && decorate!(ir, t, DecorationColMajor)
end

add_offsets!(ir::IR, T::DataType, layout::LayoutStrategy) = add_offsets!(ir, ir.typerefs[T], layout)
function add_offsets!(ir::IR, t::StructType, layout::LayoutStrategy)
  scs = storage_classes(ir, t)
  current_offset = 0
  n = length(t.members)
  for (i, subt) in enumerate(t.members)
    alignmt = alignment(layout, subt, scs, has_decoration(ir, t, DecorationBlock))
    current_offset = alignmt * cld(current_offset, alignmt)
    decorate!(ir, t, i, DecorationOffset, current_offset)
    i ≠ n && (current_offset += compute_minimal_size(subt, ir, layout))
  end
end

"""
    compute_minimal_size(T, ir::IR, layout::LayoutStrategy)

Compute the minimal size that a type `T` should have, using the alignments computed by the provided layout strategy.
"""
function compute_minimal_size end

compute_minimal_size(T::DataType, ir::IR, layout::LayoutStrategy) = compute_minimal_size(ir.typerefs[T], ir, layout)
compute_minimal_size(t::ScalarType, ir::IR, layout::LayoutStrategy) = scalar_alignment(t)
compute_minimal_size(t::Union{VectorType, MatrixType}, ir::IR, layout::LayoutStrategy) = t.n * compute_minimal_size(t.eltype, ir, layout)
compute_minimal_size(t::ArrayType, ir::IR, layout::LayoutStrategy) = extract_size(t) * compute_minimal_size(t.eltype, ir, layout)

function compute_minimal_size(t::StructType, ir::IR, layout::LayoutStrategy)
  res = 0
  scs = storage_classes(ir, t)
  for (i, subt) in enumerate(t.members)
    if i ≠ 1
      alignmt = alignment(layout, subt, scs, has_decoration(ir, t, DecorationBlock))
      res = alignmt * cld(res, alignmt)
    end
    res += compute_minimal_size(subt, ir, layout)
  end
  res
end

"""
    compute_stride(T, ir::IR, layout::LayoutStrategy)

Compute the stride that an array containing `T` should have, using module member offset declarations and with an extra padding at the end corresponding to the alignment of `T`.
"""
function compute_stride end

compute_stride(T::DataType, ir::IR, layout::LayoutStrategy) = compute_stride(ir.typerefs[T], ir, layout)
compute_stride(t::ScalarType, ir::IR, layout::LayoutStrategy) = scalar_alignment(t)
compute_stride(t::Union{VectorType, MatrixType}, ir::IR, layout::LayoutStrategy) = t.n * compute_stride(t.eltype, ir, layout)
compute_stride(t::ArrayType, ir::IR, layout::LayoutStrategy) = extract_size(t) * compute_stride(t.eltype, ir, layout)

function compute_stride(t::StructType, ir::IR, layout::LayoutStrategy)
  offsets = getoffsets(ir, t)
  size = last(offsets) + payload_size(last_member(t))
  alignmt = alignment(layout, t, storage_classes(ir, t), has_decoration(ir, t, DecorationBlock))
  alignmt * cld(size, alignmt)
end

last_member(t::SPIRType) = t
last_member(t::StructType) = last_member(last(t.members))

function payload_sizes!(sizes, t::StructType)
  for subt in t.members
    payload_sizes!(sizes, subt)
  end
end
payload_sizes!(sizes, t::SPIRType) = push!(sizes, payload_size(t))
function payload_sizes(t::SPIRType)
  sizes = Int[]
  payload_sizes!(sizes, t)
  sizes
end

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

function getoffsets!(offsets, base, ir::IR, t::StructType)
  for (i, subt) in enumerate(t.members)
    decs = decorations(ir, t, i)
    isnothing(decs) && error("Missing decorations on member ", i, " of the aggregate type ", t)
    has_decoration(decs, DecorationOffset) || error("Missing offset declaration for member ", i, " on ", t)
    new_offset = base + decs.offset
    isa(subt, StructType) ? getoffsets!(offsets, new_offset, ir, subt) : push!(offsets, new_offset)
  end
  offsets
end
getoffsets!(offsets, base, ir::IR, t::SPIRType) = offsets
getoffsets(ir::IR, t::SPIRType) = getoffsets!(UInt32[], 0U, ir, t)
getoffsets(ir::IR, T::DataType) = getoffsets(ir, ir.typerefs[T])

"""
Return a vector of bytes where every logical piece of data (delimited via the provided `sizes`)
has been aligned according to the provided offsets.
"""
function align(data::Vector{UInt8}, sizes::AbstractVector{<:Integer}, offsets::AbstractVector{<:Integer})
  isempty(offsets) && return data
  aligned_size = last(offsets) + last(sizes)
  aligned = zeros(UInt8, aligned_size)
  total = sum(sizes)
  total == length(data) || error("Size mismatch between the provided data (", length(data), " bytes) and the corresponding SPIR-V type (", total, " bytes)")
  data_byte = 1
  for (offset, size) in zip(offsets, sizes)
    aligned[(offset + 1):(offset + size)] .= data[data_byte:(data_byte + size - 1)]
    data_byte += size
  end
  aligned
end

align(data::Vector{UInt8}, t::StructType, offsets::AbstractVector{<:Integer}) = align(data, payload_sizes(t), offsets)
align(data::Vector{UInt8}, t::StructType, ir::IR) = align(data, t, getoffsets(ir, t))
align(data::Vector{UInt8}, T::DataType, ir::IR) = align(data, ir.typerefs[T], ir)
