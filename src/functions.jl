@broadcastref struct Block
    id::SSAValue
    insts::Vector{Instruction}
end

Block(id::SSAValue) = Block(id, [])

@forward Block.insts (Base.getindex,)

struct FunctionDefinition
    type::FunctionType
    control::FunctionControl
    args::Vector{SSAValue}
    blocks::SSADict{Block}
end

body(fdef::FunctionDefinition) = foldl(append!, map(x -> x.insts, values(fdef.blocks)); init=Instruction[])
