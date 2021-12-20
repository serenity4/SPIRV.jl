function control_flow_graph(f::FunctionDefinition)
    cfg = SimpleDiGraph(length(f.blocks))
    for (i, block) in enumerate(f.blocks)
        for inst in block.insts
            (; opcode, arguments) = inst
            @tryswitch opcode begin
                @case &OpBranch
                    dst = arguments[1]
                    add_edge!(cfg, i, block_index(f, dst))
                @case &OpBranchConditional
                    cond, dst1, dst2, weights... = arguments
                    add_edge!(cfg, i, block_index(f, dst1))
                    add_edge!(cfg, i, block_index(f, dst2))
                @case &OpSwitch
                    val, dsts... = arguments
                    for dst in dsts
                        add_edge!(cfg, i, block_index(f, dst))
                    end
            end
        end
    end
    cfg
end

block_index(f::FunctionDefinition, id::SSAValue) = findfirst(==(id), collect(keys(f.blocks)))
