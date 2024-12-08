"""
Variable(type, initializer = nothing)

Construct a variable that wraps a value of type `type` as a pointer.
If `type` is already a pointer type, then its storage class is propagated
to the variable; if not, then a specific storage class can be specified.
"""
mutable struct Variable
  type::SPIRType
  storage_class::StorageClass
  initializer::Optional{ResultID}
  function Variable(type::SPIRType, initializer::Optional{ResultID})
    assert_type(type, SPIR_TYPE_POINTER)
    new(type, type.pointer.storage_class, initializer)
  end
end
function Variable(type::SPIRType)
  !istype(type, SPIR_TYPE_POINTER) && return Variable(type, StorageClassFunction)
  Variable(type, nothing)
end
Variable(type::SPIRType, storage_class::StorageClass, initializer::Optional{ResultID} = nothing) = Variable(pointer_type(storage_class, type), initializer)

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

function Instruction(type::SPIRType, id::ResultID, globals::GlobalsInfo)
  @match type.typename begin
    &SPIR_TYPE_VOID => @inst id = TypeVoid()
    &SPIR_TYPE_BOOLEAN => @inst id = TypeBool()
    &SPIR_TYPE_INTEGER => begin
      (; width, signed) = type.integer
      @inst id = TypeInt(UInt32(width), UInt32(signed)) 
    end
    &SPIR_TYPE_FLOAT => @inst id = TypeFloat(UInt32(type.float.width)) 
    &SPIR_TYPE_VECTOR => begin
      (; eltype, n) = type.vector
      @inst id = TypeVector(globals.types[eltype], UInt32(n))
    end
    &SPIR_TYPE_MATRIX => begin
      (; eltype, n) = type.matrix
      @inst id = TypeMatrix(globals.types[eltype], UInt32(n))
    end
    &SPIR_TYPE_IMAGE => begin
      (; image) = type
      inst = @inst id = TypeImage(
        globals.types[image.sampled_type],
        image.dim,
        UInt32(something(image.depth, 2)),
        UInt32(image.arrayed),
        UInt32(image.multisampled),
        UInt32(2 - something(image.sampled, 2)),
        image.format,
      )
      !isnothing(image.access_qualifier) && push!(inst.arguments, image.access_qualifier)
      inst
    end
    &SPIR_TYPE_SAMPLER => @inst id = TypeSampler()
    &SPIR_TYPE_SAMPLED_IMAGE => @inst id = TypeSampledImage(globals.types[type.image_type])
    &SPIR_TYPE_ARRAY => begin
      (; eltype, size) = type.array
      if isnothing(size)
        @inst id = TypeRuntimeArray(globals.types[eltype])
      else
        @inst id = TypeArray(globals.types[eltype], globals.constants[size])
      end
    end
    &SPIR_TYPE_STRUCT => begin
      inst = @inst id = TypeStruct()
      for member in type.struct.members
        push!(inst.arguments, globals.types[member])
      end
      inst
    end
    &SPIR_TYPE_OPAQUE => @inst id = TypeOpaque(type.opaque.name)
    &SPIR_TYPE_POINTER => begin
      (; pointer) = type
      @inst id = TypePointer(pointer.storage_class, globals.types[pointer.type])
    end
    &SPIR_TYPE_FUNCTION => begin
      (; rettype, argtypes) = type.function
      inst = @inst id = TypeFunction(globals.types[rettype])
      for argtype in argtypes
        push!(inst.arguments, globals.types[argtype])
      end
      inst
    end
  end
end

function Expression(c::Constant, id::ResultID)
  (; type) = c
  (; value) = c
  if istype(type, SPIR_TYPE_INTEGER) || istype(type, SPIR_TYPE_FLOAT)
    width = istype(type, SPIR_TYPE_INTEGER) ? type.integer.width : type.float.width
    if width < 32
      value =
        width == 8 ? UInt32(reinterpret(UInt8, c.value)) :
        width == 16 ? UInt32(reinterpret(UInt16, c.value)) :
        error("Expected width to be a power of two starting from 8, got a width of $width")
    end
  end
  @match (c.value, c.is_spec_const[]) begin
    (::Nothing, _) => @ex id = ConstantNull()::type
    (true, false) => @ex id = ConstantTrue()::type
    (true, true) => @ex id = SpecConstantTrue()::type
    (false, false) => @ex id = ConstantFalse()::type
    (false, true) => @ex id = SpecConstantFalse()::type
    (ids::Vector{ResultID}, false) => @ex id = ConstantComposite(ids...)::type
    (ids::Vector{ResultID}, true) => @ex id = SpecConstantComposite(ids...)::type
    (GuardBy(isprimitivetype ∘ typeof), false) => @ex id = Constant(reinterpret(UInt32, [value]))::type
    (GuardBy(isprimitivetype ∘ typeof), true) => @ex id = SpecConstant(reinterpret(UInt32, [value]))::type
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
  (; rettype, argtypes) = fdef.type.function
  push!(exs, @ex id = Function(fdef.control, fdef.type)::rettype)
  append!(exs, @ex(id = FunctionParameter()::argtype) for (id, argtype) in zip(fdef.args, argtypes))
  fbody = body(fdef)
  if !isempty(fbody)
    label = first(fbody)
    @assert label.op == OpLabel
    push!(exs, label)
    append!(exs, fdef.local_vars)
    append!(exs, fbody[2:end])
  end
  push!(exs, @ex FunctionEnd())
  exs
end

function append_globals!(insts, globals::GlobalsInfo)
  all_globals = merge_unique!(BijectiveMapping{ResultID,Union{SPIRType, Constant, Variable}}(), globals.types, globals.constants, globals.global_vars)
  sortkeys!(all_globals)
  append!(insts, Instruction(val, id, globals) for (id, val) in pairs(all_globals))
end

function Expression(var::Variable, id::ResultID)
  ex = @ex id = Variable(var.storage_class)::var.type
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

function emit_type!(types, counter::IDCounter, constants, tmap::TypeMap, type::SPIRType)
  haskey(types, type) && return types[type]
  (; typename) = type
  @switch typename begin
    @case &SPIR_TYPE_POINTER
    emit_type!(types, counter, constants, tmap, type.pointer.type)
    @case &SPIR_TYPE_VECTOR
    emit_type!(types, counter, constants, tmap, type.vector.eltype)
    @case &SPIR_TYPE_MATRIX
    emit_type!(types, counter, constants, tmap, type.matrix.eltype)
    @case &SPIR_TYPE_ARRAY
    (; size, eltype) = type.array
    emit_type!(types, counter, constants, tmap, eltype)
    !isnothing(size) && emit_constant!(constants, counter, types, tmap, size)
    @case &SPIR_TYPE_STRUCT
    for t in type.struct.members
      emit_type!(types, counter, constants, tmap, t)
    end
    @case &SPIR_TYPE_IMAGE
    emit_type!(types, counter, constants, tmap, type.image.sampled_type)
    @case &SPIR_TYPE_SAMPLED_IMAGE
    emit_type!(types, counter, constants, tmap, type.image_type)
    @case &SPIR_TYPE_VOID || &SPIR_TYPE_INTEGER || &SPIR_TYPE_FLOAT || &SPIR_TYPE_BOOLEAN || &SPIR_TYPE_OPAQUE || &SPIR_TYPE_SAMPLER
    nothing
    @case &SPIR_TYPE_FUNCTION
    (; rettype, argtypes) = type.function
    emit_type!(types, counter, constants, tmap, rettype)
    for t in argtypes
      emit_type!(types, counter, constants, tmap, t)
    end
  end

  id = next!(counter)
  insert!(types, type, id)
  id
end
