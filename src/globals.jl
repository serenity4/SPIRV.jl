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
Variable(type::SPIRType, storage_class::StorageClass = StorageClassFunction, initializer::Optional{ResultID} = nothing) = Variable(PointerType(storage_class, type), initializer)
Variable(type::PointerType, ::StorageClass, initializer::Optional{ResultID} = nothing) = Variable(type, initializer)

function Variable(ex::Expression)
  storage_class = ex[1]::StorageClass
  initializer = length(ex) == 2 ? ResultID(ex[2]::UInt32) : nothing
  Variable(ex.type, initializer)
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
function Expression(c::Constant, id::ResultID)
  (; type) = c
  (; value) = c
  if (isa(type, IntegerType) || isa(type, FloatType)) && type.width < 32
    value =
      type.width == 8 ? UInt32(reinterpret(UInt8, c.value)) :
      type.width == 16 ? UInt32(reinterpret(UInt16, c.value)) :
      error("Expected width to be a power of two starting from 8, got a width of $(type.width)")
  end
  @match (c.value, c.is_spec_const[]) begin
    (::Nothing, _) => @ex id = OpConstantNull()::type
    (true, false) => @ex id = OpConstantTrue()::type
    (true, true) => @ex id = OpSpecConstantTrue()::type
    (false, false) => @ex id = OpConstantFalse()::type
    (false, true) => @ex id = OpSpecConstantFalse()::type
    (ids::Vector{ResultID}, false) => @ex id = OpConstantComposite(ids...)::type
    (ids::Vector{ResultID}, true) => @ex id = OpSpecConstantComposite(ids...)::type
    (GuardBy(isprimitivetype ∘ typeof), false) => @ex id = OpConstant(reinterpret(UInt32, [value]))::type
    (GuardBy(isprimitivetype ∘ typeof), true) => @ex id = OpSpecConstant(reinterpret(UInt32, [value]))::type
    _ => error("Unexpected value $(c.value) with type $type for constant expression")
  end
end
Instruction(c::Constant, id::ResultID, globals::GlobalsInfo) = Instruction(Expression(c, id), globals.types)

function append_functions!(insts, fdefs, globals::GlobalsInfo)
  for (id, fdef) in pairs(fdefs)
    append!(insts, Instruction(ex, globals.types) for ex in expressions(fdef, id))
  end
end

function expressions(fdef::FunctionDefinition, id::ResultID)
  exs = Expression[]
  (; type) = fdef
  push!(exs, @ex id = OpFunction(fdef.control, type)::type.rettype)
  append!(exs, @ex(id = OpFunctionParameter()::argtype) for (id, argtype) in zip(fdef.args, type.argtypes))
  fbody = body(fdef)
  if !isempty(fbody)
    label = first(fbody)
    @assert label.op == OpLabel
    push!(exs, label)
    append!(exs, fdef.local_vars)
    append!(exs, fbody[2:end])
  end
  push!(exs, @ex OpFunctionEnd())
  exs
end

function append_globals!(insts, globals::GlobalsInfo)
  all_globals = merge_unique!(BijectiveMapping{ResultID,Union{SPIRType, Constant, Variable}}(), globals.types, globals.constants, globals.global_vars)
  sortkeys!(all_globals)
  append!(insts, Instruction(val, id, globals) for (id, val) in pairs(all_globals))
end

function Expression(var::Variable, id::ResultID)
  ex = @ex id = OpVariable(var.storage_class)::var.type
  !isnothing(var.initializer) && push!(ex, var.initializer)
  ex
end

Instruction(var::Variable, id::ResultID, globals::GlobalsInfo) = Instruction(Expression(var, id), globals.types)

function emit_constant!(constants, counter::IDCounter, types, tmap::TypeMap, c::Constant)
  haskey(constants, c) && return constants[c]
  emit_type!(types, counter, constants, tmap, c.type)
  id = next!(counter)
  insert!(constants, c, id)
  id
end

function emit_type!(types, counter::IDCounter, constants, tmap::TypeMap, @nospecialize(type::SPIRType))
  haskey(types, type) && return types[type]
  @switch type begin
    @case ::PointerType
    emit_type!(types, counter, constants, tmap, type.type)
    @case (::ArrayType && GuardBy(isnothing ∘ Fix2(getproperty, :size))) || ::VectorType || ::MatrixType
    emit_type!(types, counter, constants, tmap, type.eltype)
    @case ::ArrayType
    emit_type!(types, counter, constants, tmap, type.eltype)
    emit_constant!(constants, counter, types, tmap, type.size)
    @case ::StructType
    for t in type.members
      emit_type!(types, counter, constants, tmap, t)
    end
    @case ::ImageType
    emit_type!(types, counter, constants, tmap, type.sampled_type)
    @case ::SampledImageType
    emit_type!(types, counter, constants, tmap, type.image_type)
    @case ::VoidType || ::IntegerType || ::FloatType || ::BooleanType || ::OpaqueType || ::SamplerType
    nothing
    @case ::FunctionType
    emit_type!(types, counter, constants, tmap, type.rettype)
    for t in type.argtypes
      emit_type!(types, counter, constants, tmap, t)
    end
  end

  id = next!(counter)
  insert!(types, type, id)
  id
end
