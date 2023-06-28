"""
A more semantically meaningful kind of instruction, where type information is fully available within the instruction itself.

Semantically, `Expression`s do not express type declarations.
"""
@auto_hash_equals struct Expression <: AbstractInstruction
  op::OpCode
  type::Optional{SPIRType}
  result::Optional{ResultID}
  args::Vector{Any}
  Expression(op::OpCode, type::Optional{SPIRType}, result::Optional{ResultID}, args::AbstractVector) = new(op, type, result, args)
  Expression(op::OpCode, type::Optional{SPIRType}, result::Optional{ResultID}, args...) = Expression(op, type, result, collect(args))
end

@forward_interface Expression field = :args interface = [iteration, indexing]
@forward_methods Expression field = :args Base.view(_, range) Base.push!(_, args...) Base.keys

opcode(ex::Expression) = ex.op
result_id(ex::Expression) = ex.result

function Instruction(ex::Expression, types #= SPIRType => ResultID =#)
  (; args) = ex
  if ex.op == OpFunction
    if isa(ex[end], FunctionType)
      @reset args[end] = types[ex[end]]
    end
  end
  type_id = nothing
  if !isnothing(ex.type)
    type_id = get(types, ex.type, nothing)
    isnothing(type_id) && error("No type ID available for SPIR-V type ", ex.type)
  end
  Instruction(ex.op, type_id, ex.result, args)
end

function Expression(inst::Instruction, types #= ResultID => SPIRType =#)
  type = nothing
  if !isnothing(inst.type_id)
    type = get(types, inst.type_id, nothing)
    isnothing(type) && error("No type known for type ID ", inst.type_id)
  end
  Expression(inst.opcode, type, inst.result_id, inst.arguments)
end
