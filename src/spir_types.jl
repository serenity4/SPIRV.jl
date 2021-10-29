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

struct ImageType <: SPIRType
    sampled_type::SPIRType
    dim::Dim
    format::ImageFormat
    arrayed::Int
    multisampled::Bool
    depth::Optional{Bool}
    access_qualifier::Optional{AccessQualifier}
    sampled::Optional{Bool}
    function ImageType(sampled_type::SPIRType, dim::Dim, format::ImageFormat, arrayed::Int, multisampled::Bool, depth::Optional{Bool}, sampled::Optional{Bool}, access_qualifier::Optional{AccessQualifier})
        if dim == DimSubpassData
            !sampled || error("Subpass image cannot be sampled")
            format == ImageFormatUnknown || error("Subpass image format must be unknown")
        end
        new(sampled_type, dim, format, arrayed, multisampled, depth, access_qualifier)
    end
    function ImageType(sampled_type, dim, format, arrayed, multisampled, depth, sampled, access_qualifier)
        ImageType(convert(SPIRType, sampled_type), convert(Dim, dim), convert(ImageFormat, format), convert(Int, arrayed), convert(Bool, multisampled), convert(Optional{Bool}, depth), convert(Optional{Bool}, sampled), convert(Optional{AccessQualifier}, access_qualifier))
    end
end

function ImageType(inst::Instruction, sampled_type::SPIRType)
    @assert inst.opcode == OpTypeImage
    (sampled_type_id, dim, depth, arrayed, multisampled, sampled, format) = inst.arguments[1:7]
    access_qualifier = length(inst.arguments) > 7 ? last(inst.arguments) : nothing
    sampled = sampled == 0 ? nothing : Bool(sampled - 1)
    if depth == 2
        depth = nothing
    end
    ImageType(sampled_type, dim, format, arrayed, multisampled, depth, sampled, access_qualifier)
end

struct SamplerType <: SPIRType end

struct SampledImageType <: SPIRType
    image_type::ImageType
end

struct ArrayType <: SPIRType
    eltype::SPIRType
    "Constant expression giving the size of the array, if determined at compile-time. SPIR-V runtime arrays will have this field set to `nothing`."
    size::Optional{Instruction}
end

struct OpaqueType <: SPIRType
    name::Symbol
end

struct StructType <: SPIRType
    members::Vector{SPIRType}
end

struct PointerType <: SPIRType
    storage_class::StorageClass
    type::SPIRType
end

PointerType(inst::Instruction, type::SPIRType) = PointerType(first(inst.arguments), type)

struct Constant
    value::Any
    is_spec_const::Bool
end

struct FunctionType <: SPIRType
    rettype::SSAValue
    argtypes::Vector{SSAValue}
end

function parse_type(inst::Instruction, types::SSADict{SPIRType}, results::SSADict{Any})::SPIRType
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
        &OpTypeArray => ArrayType(types[first(inst.arguments)], results[last(inst.arguments)])
        &OpTypeRuntimeArray => ArrayType(types[inst.arguments[]], nothing)
        &OpTypeStruct => StructType([types[id] for id in inst.arguments[]])
        &OpTypeOpaque => OpaqueType(Symbol(inst.arguments[]))
        &OpTypePointer => PointerType(inst, types[last(inst.arguments)])
        _ => error("$op does not represent a SPIR-V type or the corresponding type is not implemented.")
    end
end
