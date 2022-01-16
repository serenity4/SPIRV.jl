const Word = UInt32

"""
SPIR-V instruction. Must contain an opcode, and optionally a type id and a result id.
"""
@refbroadcast abstract type AbstractInstruction end


"""
SPIR-V instruction in binary format.
"""
@auto_hash_equals struct PhysicalInstruction <: AbstractInstruction
    word_count::UInt16
    opcode::UInt16
    type_id::Optional{Word}
    result_id::Optional{Word}
    operands::Vector{Word}
end

"""
Parsed SPIR-V instruction. It represents an instruction of the form `%result_id = %opcode(%arguments...)::%type_id`.
"""
@auto_hash_equals struct Instruction <: AbstractInstruction
    opcode::OpCode
    type_id::Optional{SSAValue}
    result_id::Optional{SSAValue}
    arguments::Vector{Any}
    Instruction(opcode, type_id, result_id, arguments::AbstractVector) = new(opcode, type_id, result_id, arguments)
end
Instruction(opcode, type_id, result_id, arguments...) = Instruction(opcode, type_id, result_id, collect(arguments))