@broadcastref struct Block
    id::SSAValue
    insts::Vector{Instruction}
end

Block(id::SSAValue) = Block(id, [])

@forward Block.insts (Base.getindex,)

@auto_hash_equals struct FunctionDefinition
    type::FunctionType
    control::FunctionControl
    args::Vector{SSAValue}
    blocks::SSADict{Block}
end

body(fdef::FunctionDefinition) = foldl(append!, map(x -> x.insts, values(fdef.blocks)); init=Instruction[])

function new_block!(fdef::FunctionDefinition, id::SSAValue)
    blk = Block(id, [@inst id = OpLabel()])
    insert!(fdef.blocks, id, blk)
    blk
end
