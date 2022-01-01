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
    variables::Vector{Instruction}
    blocks::SSADict{Block}
end

function FunctionDefinition(type::FunctionType, control::FunctionControl = FunctionControlNone)
    FunctionDefinition(type, control, [], [], SSADict())
end

function body(fdef::FunctionDefinition)
    foldl(append!, map(x -> x.insts, values(fdef.blocks)); init=Instruction[])
end

function new_block!(fdef::FunctionDefinition, id::SSAValue)
    blk = Block(id, [@inst id = OpLabel()])
    insert!(fdef.blocks, id, blk)
    blk
end
