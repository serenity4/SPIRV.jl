@broadcastref struct Block
    id::SSAValue
    insts::Vector{Instruction}
end

Block(id::SSAValue) = Block(id, [])

@forward Block.insts (Base.getindex,)

@auto_hash_equals struct FunctionDefinition
    type::FunctionType
    control::FunctionControl
    "Function arguments, after promoting non-local pointer arguments to global variables. Argument types match the function `type`."
    args::Vector{SSAValue}
    "Declaration of variables which hold function-local pointers."
    local_vars::Vector{Instruction}
    blocks::SSADict{Block}
    "Arguments promoted to global variables."
    global_vars::Vector{SSAValue}
end

function FunctionDefinition(type::FunctionType, control::FunctionControl = FunctionControlNone)
    FunctionDefinition(type, control, [], [], SSADict(), [])
end

function body(fdef::FunctionDefinition)
    foldl(append!, map(x -> x.insts, values(fdef.blocks)); init=Instruction[])
end

function new_block!(fdef::FunctionDefinition, id::SSAValue)
    blk = Block(id, [@inst id = OpLabel()])
    insert!(fdef.blocks, id, blk)
    blk
end
