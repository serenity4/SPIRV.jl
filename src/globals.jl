"""
Variable(type, initializer = nothing)

Construct a variable that wraps a value of type `type` as a pointer.
If `type` is already a `PointerType`, then its storage class is propagated
to the variable; if not, then a specific storage class can be specified
with the form `Variable(type, storage_class = StorageClassFunction, initializer = nothing)`.
"""
mutable struct Variable
  type::PointerType
  storage_class::StorageClass
  initializer::Optional{ResultID}
  Variable(type::PointerType, initializer::Optional{ResultID} = nothing) = new(type, type.storage_class, initializer)
end
Variable(type::SPIRType, storage_class::StorageClass = StorageClassFunction, initializer::Optional{ResultID} = nothing) =
Variable(PointerType(storage_class, type), initializer)
Variable(type::PointerType, ::StorageClass, initializer::Optional{ResultID} = nothing) = Variable(type, initializer)

function Variable(inst::Instruction, type::PointerType)
  storage_class = inst.arguments[1]::StorageClass
  initializer = length(inst.arguments) == 2 ? SSAValue(inst.arguments[2]::UInt32) : nothing
  Variable(type, initializer)
end

struct GlobalsInfo
  types::BijectiveMapping{ResultID,SPIRType}
  constants::BijectiveMapping{ResultID,Constant}
  global_vars::BijectiveMapping{ResultID,Variable}
end

GlobalsInfo() = GlobalsInfo(BijectiveMapping(), BijectiveMapping(), BijectiveMapping())

Instruction(inst::Instruction, id::ResultID, ::GlobalsInfo) = @set inst.result_id = id
Instruction(::VoidType, id::ResultID, ::GlobalsInfo) = @inst id = OpTypeVoid()
Instruction(::BooleanType, id::ResultID, ::GlobalsInfo) = @inst id = OpTypeBool()
Instruction(t::IntegerType, id::ResultID, ::GlobalsInfo) = @inst id = OpTypeInt(UInt32(t.width), UInt32(t.signed))
Instruction(t::FloatType, id::ResultID, ::GlobalsInfo) = @inst id = OpTypeFloat(UInt32(t.width))
Instruction(t::VectorType, id::ResultID, globals::GlobalsInfo) = @inst id = OpTypeVector(globals.types[t.eltype], UInt32(t.n))
Instruction(t::MatrixType, id::ResultID, globals::GlobalsInfo) = @inst id = OpTypeMatrix(globals.types[t.eltype], UInt32(t.n))
function Instruction(t::ImageType, id::ResultID, globals::GlobalsInfo)
  inst = @inst id = OpTypeImage(
    globals.types[t.sampled_type],
    t.dim,
    UInt32(something(t.depth, 2)),
    UInt32(t.arrayed),
    UInt32(t.multisampled),
    UInt32(2 - something(t.sampled, 2)),
    t.format,
  )
  !isnothing(t.access_qualifier) && push!(inst.arguments, t.access_qualifier)
  inst
end
Instruction(t::SamplerType, id::ResultID, ::GlobalsInfo) = @inst id = OpTypeSampler()
Instruction(t::SampledImageType, id::ResultID, globals::GlobalsInfo) = @inst id = OpTypeSampledImage(globals.types[t.image_type])
function Instruction(t::ArrayType, id::ResultID, globals::GlobalsInfo)
  if isnothing(t.size)
    @inst id = OpTypeRuntimeArray(globals.types[t.eltype])
  else
    @inst id = OpTypeArray(globals.types[t.eltype], globals.constants[t.size::Constant])
  end
end
function Instruction(t::StructType, id::ResultID, globals::GlobalsInfo)
  inst = @inst id = OpTypeStruct()
  append!(inst.arguments, globals.types[member] for member in t.members)
  inst
end
Instruction(t::OpaqueType, id::ResultID, ::GlobalsInfo) = @inst id = OpTypeOpaque(t.name)
Instruction(t::PointerType, id::ResultID, globals::GlobalsInfo) = @inst id = OpTypePointer(t.storage_class, globals.types[t.type])
function Instruction(t::FunctionType, id::ResultID, globals::GlobalsInfo)
  inst = @inst id = OpTypeFunction(globals.types[t.rettype])
  append!(inst.arguments, globals.types[argtype] for argtype in t.argtypes)
  inst
end
function Instruction(c::Constant, id::ResultID, globals::GlobalsInfo)
  @match (c.value, c.is_spec_const) begin
    ((::Nothing, type), false) => @inst id = OpConstantNull()::globals.types[type]
    (true, false) => @inst id = OpConstantTrue()::globals.types[BooleanType()]
    (true, true) => @inst id = OpSpecConstantTrue()::globals.types[BooleanType()]
    (false, false) => @inst id = OpConstantFalse()::globals.types[BooleanType()]
    (false, true) => @inst id = OpSpecConstantFalse()::globals.types[BooleanType()]
    ((ids::Vector{ResultID}, type), false) => @inst id = OpConstantComposite(ids...)::globals.types[type]
    ((ids::Vector{ResultID}, type), true) => @inst id = OpSpecConstantComposite(ids...)::globals.types[type]
    (val, false) => begin
      if isa(val, UInt64) || isa(val, Int64) || isa(val, Float64)
        # `val` is a 64-bit literal, and so takes two words.
        @inst id = OpConstant(reinterpret(UInt32, [val])...)::globals.types[spir_type(typeof(val))]
      else
        @inst id = OpConstant(reinterpret(UInt32, val))::globals.types[spir_type(typeof(val))]
      end
    end
  end
end

function append_functions!(insts, fdefs, globals::GlobalsInfo)
  for (id, fdef) in pairs(fdefs)
    append!(insts, instructions(fdef, id, globals))
  end
end

function instructions(fdef::FunctionDefinition, id::ResultID, globals::GlobalsInfo)
  insts = Instruction[]
  (; type) = fdef
  push!(insts, @inst id = OpFunction(fdef.control, globals.types[type])::globals.types[type.rettype])
  append!(insts, @inst(id = OpFunctionParameter()::globals.types[argtype]) for (id, argtype) in zip(fdef.args, type.argtypes))
  fbody = body(fdef)
  if !isempty(fbody)
    label = first(fbody)
    @assert label.opcode == OpLabel
    push!(insts, label)
    append!(insts, fdef.local_vars)
    append!(insts, fbody[2:end])
  end
  push!(insts, @inst OpFunctionEnd())
  insts
end

function append_globals!(insts, globals::GlobalsInfo)
  all_globals = merge_unique!(BijectiveMapping{ResultID,Any}(), globals.types, globals.constants, globals.global_vars)
  sortkeys!(all_globals)
  append!(insts, Instruction(val, id, globals) for (id, val) in pairs(all_globals))
end

function Instruction(var::Variable, id::ResultID, globals::GlobalsInfo)
  inst = @inst id = OpVariable(var.storage_class)::globals.types[var.type]
  !isnothing(var.initializer) && push!(inst.arguments, var.initializer)
  inst
end
