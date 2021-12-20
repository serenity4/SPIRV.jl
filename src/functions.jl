@broadcastref struct Block
    id::SSAValue
    insts::Vector{Instruction}
end

struct FunctionDefinition
    type::FunctionType
    control::FunctionControl
    args::Vector{SSAValue}
    blocks::SSADict{Block}
end

body(fdef::FunctionDefinition) = foldl(append!, map(x -> x.insts, values(fdef.blocks)); init=Instruction[])
