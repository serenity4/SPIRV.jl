abstract type SPIRType end

struct VoidType <: SPIRType end

abstract type ScalarType <: SPIRType end

struct IntegerType <: ScalarType
  width::Int
  signed::Bool
end

function IntegerType(inst::Instruction)
  (width, signed) = inst.arguments
  IntegerType(width, signed)
end

struct FloatType <: ScalarType
  width::Int
end

FloatType(inst::Instruction) = FloatType(inst.arguments[])

struct BooleanType <: ScalarType end

struct VectorType <: SPIRType
  eltype::ScalarType
  n::Int
end

function VectorType(inst::Instruction, eltype::ScalarType)
  VectorType(eltype, last(inst.arguments))
end

struct MatrixType <: SPIRType
  eltype::VectorType
  n::Int
end

function MatrixType(inst::Instruction, eltype::VectorType)
  MatrixType(eltype, last(inst.arguments))
end

@auto_hash_equals struct ImageType <: SPIRType
  sampled_type::SPIRType
  dim::Dim
  depth::Optional{Bool}
  arrayed::Bool
  multisampled::Bool
  sampled::Optional{Bool}
  format::ImageFormat
  access_qualifier::Optional{AccessQualifier}
end

function ImageType(inst::Instruction, sampled_type::SPIRType)
  @assert inst.opcode == OpTypeImage
  (sampled_type_id, dim, depth, arrayed, multisampled, sampled, format) = inst.arguments[1:7]
  access_qualifier = length(inst.arguments) > 7 ? last(inst.arguments) : nothing
  sampled = sampled == 0 ? nothing : Bool(2 - sampled)
  if depth == 2
    depth = nothing
  end
  ImageType(sampled_type, dim, depth, arrayed, multisampled, sampled, format, access_qualifier)
end

struct SamplerType <: SPIRType end

struct SampledImageType <: SPIRType
  image_type::ImageType
end

struct Constant
  value::Any
  is_spec_const::Bool
end
Constant(value) = Constant(value, false)
Constant(node::QuoteNode) = Constant(node.value)

struct ArrayType <: SPIRType
  eltype::SPIRType
  "Constant expression giving the size of the array, if determined at compile-time. SPIR-V runtime arrays will have this field set to `nothing`."
  size::Optional{Constant}
end

struct OpaqueType <: SPIRType
  name::Symbol
end

const DecorationData = Dictionary{Decoration,Vector{Any}}

"""
SPIR-V aggregate type.

Equality is defined in terms of identity, since different aggregate
types have in principle different semantics.
"""
mutable struct StructType <: SPIRType
  members::Vector{SPIRType}
  member_decorations::Dictionary{Int,DecorationData}
  member_names::Dictionary{Int,Symbol}
end

StructType(members::AbstractVector) = StructType(members, Dictionary(), Dictionary())

struct PointerType <: SPIRType
  storage_class::StorageClass
  type::SPIRType
end

PointerType(inst::Instruction, type::SPIRType) = PointerType(first(inst.arguments), type)

@auto_hash_equals struct FunctionType <: SPIRType
  rettype::SPIRType
  argtypes::Vector{SPIRType}
end

function Base.parse(::Type{SPIRType}, inst::Instruction, types::BijectiveMapping, constants::BijectiveMapping)
  @match op = inst.opcode begin
    &OpTypeVoid => VoidType()
    &OpTypeInt => IntegerType(inst)
    &OpTypeFloat => FloatType(inst)
    &OpTypeBool => BooleanType()
    &OpTypeVector => VectorType(inst, types[first(inst.arguments)])
    &OpTypeMatrix => MatrixType(inst, types[first(inst.arguments)])
    &OpTypeImage => ImageType(inst, types[first(inst.arguments)])
    &OpTypeSampler => SamplerType()
    &OpTypeSampledImage => SampledImageType(types[inst.arguments[]])
    &OpTypeArray => ArrayType(types[first(inst.arguments)], constants[last(inst.arguments)])
    &OpTypeRuntimeArray => ArrayType(types[inst.arguments[]], nothing)
    &OpTypeStruct => StructType([types[id] for id in inst.arguments])
    &OpTypeOpaque => OpaqueType(Symbol(inst.arguments[]))
    &OpTypePointer => PointerType(inst, types[last(inst.arguments)])
    _ => error("$op does not represent a SPIR-V type or the corresponding type is not implemented.")
  end
end
