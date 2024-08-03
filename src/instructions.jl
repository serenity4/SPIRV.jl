const Word = UInt32

"""
SPIR-V instruction. Must contain an opcode, and optionally a type id and a result id.
"""
@refbroadcast abstract type AbstractInstruction end

opcode(inst::AbstractInstruction) = inst.opcode
result_id(inst::AbstractInstruction) = inst.result_id

"""
SPIR-V instruction in binary format.
"""
@struct_hash_equal struct PhysicalInstruction <: AbstractInstruction
  word_count::UInt16
  opcode::UInt16
  type_id::Optional{Word}
  result_id::Optional{Word}
  operands::Vector{Word}
end

"""
Parsed SPIR-V instruction. It represents an instruction of the form `%result_id = %opcode(%arguments...)::%type_id`.
"""
@struct_hash_equal struct Instruction <: AbstractInstruction
  opcode::OpCode
  type_id::Optional{ResultID}
  result_id::Optional{ResultID}
  arguments::Vector{Any}
  Instruction(opcode, type_id, result_id, arguments::AbstractVector) = new(opcode, type_id, result_id, arguments)
end
Instruction(opcode, type_id, result_id, arguments...) = Instruction(opcode, type_id, result_id, collect(arguments))

const InstructionCursor = ArrayCursor{Instruction}

assert_opcode(op, inst) = op == opcode(inst) || error("Expected $op instruction, got ", sprintc(emit, inst))

has_result_id(inst::AbstractInstruction, id::ResultID) = result_id(inst) === id
has_result_id(id::ResultID) = Fix2(has_result_id, id)
