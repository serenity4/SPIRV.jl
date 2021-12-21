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

struct Constant
    value::Any
    is_spec_const::Bool
end
Constant(value) = Constant(value, false)

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

Instruction(inst::Instruction, id::SSAValue, ::BijectiveMapping) = @set inst.result_id = id
Instruction(::VoidType, id::SSAValue, ::BijectiveMapping) = @inst id = OpTypeVoid()
Instruction(::BooleanType, id::SSAValue, ::BijectiveMapping) = @inst id = OpTypeBool()
Instruction(t::IntegerType, id::SSAValue, ::BijectiveMapping) = @inst id = OpTypeInt(UInt32(t.width), UInt32(t.signed))
Instruction(t::FloatType, id::SSAValue, ::BijectiveMapping) = @inst id = OpTypeFloat(UInt32(t.width))
Instruction(t::VectorType, id::SSAValue, globals::BijectiveMapping) = @inst id = OpTypeVector(globals[t.eltype], UInt32(t.n))
Instruction(t::MatrixType, id::SSAValue, globals::BijectiveMapping) = @inst id = OpTypeMatrix(globals[t.eltype], UInt32(t.n))
function Instruction(t::ImageType, id::SSAValue, globals::BijectiveMapping)
    inst = @inst id = OpTypeImage(globals[t.sampled_type], t.dim, UInt32(something(t.depth, 2)), UInt32(t.arrayed), UInt32(t.multisampled), UInt32(something(t.sampled, 2)), t.format)
    !isnothing(t.access_qualifier) && push!(inst.arguments, t.access_qualifier)
    inst
end
Instruction(t::SamplerType, id::SSAValue, ::BijectiveMapping) = @inst id = OpTypeSampler()
Instruction(t::SampledImageType, id::SSAValue, globals::BijectiveMapping) = @inst id = OpTypeSampledImage(globals[t.image_type])
function Instruction(t::ArrayType, id::SSAValue, globals::BijectiveMapping)
    if isnothing(t.size)
        @inst id = OpTypeRuntimeArray(globals[t.eltype])
    else
        @inst id = OpTypeArray(globals[t.eltype], globals[t.size::Constant])
    end
end
function Instruction(t::StructType, id::SSAValue, globals::BijectiveMapping)
    inst = @inst id = OpTypeStruct()
    append!(inst.arguments, globals[member] for member in t.members)
    inst
end
Instruction(t::OpaqueType, id::SSAValue, ::BijectiveMapping) = @inst id = OpTypeOpaque(t.name)
Instruction(t::PointerType, id::SSAValue, globals::BijectiveMapping) = @inst id = OpTypePointer(t.storage_class, globals[t.type])
function Instruction(t::FunctionType, id::SSAValue, globals::BijectiveMapping)
    inst = @inst id = OpTypeFunction(globals[t.rettype])
    append!(inst.arguments, globals[argtype] for argtype in t.argtypes)
    inst
end
function Instruction(c::Constant, id::SSAValue, globals::BijectiveMapping)
    @match (c.value, c.is_spec_const) begin
        ((::Nothing, type), false) => @inst id = OpConstantNull()::globals[type]
        (true, false) => @inst id = OpConstantTrue()::globals[BooleanType()]
        (true, true) => @inst id = OpSpecConstantTrue()::globals[BooleanType()]
        (false, false) => @inst id = OpConstantFalse()::globals[BooleanType()]
        (false, true) => @inst id = OpSpecConstantFalse()::globals[BooleanType()]
        ((ids::Vector{SSAValue}, type), false) => @inst id = OpConstantComposite(ids...)::globals[type]
        ((ids::Vector{SSAValue}, type), false) => @inst id = OpSpecConstantComposite(ids...)::globals[type]
        (val, false) => @inst id = OpConstant(reinterpret(UInt32, val))::globals[SPIRType(typeof(val))]
    end
end

function julia_type(@nospecialize(t::SPIRType), ir::IR)
    @match t begin
        &(IntegerType(8, false)) => UInt8
        &(IntegerType(16, false)) => UInt16
        &(IntegerType(32, false)) => UInt32
        &(IntegerType(64, false)) => UInt64
        &(IntegerType(8, true)) => Int8
        &(IntegerType(16, true)) => Int16
        &(IntegerType(32, true)) => Int32
        &(IntegerType(64, true)) => Int64
        &(FloatType(16)) => Float16
        &(FloatType(32)) => Float32
        &(FloatType(64)) => Float64
    end
end
