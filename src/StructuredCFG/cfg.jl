"Control Flow Graph (CFG)"
struct CFG
    """
    Graph where nodes represent basic blocks, and edges represent branches.
    """
    graph::DeltaGraph
    """
    Mapping from node index to instructions.
    """
    instructions::Vector{Vector{Any}}
    code::Union{CodeInfo,IRCode}
    CFG(graph::DeltaGraph, instructions::Vector{Vector{Any}}, code::Union{CodeInfo,IRCode}) = new(graph, instructions, code)
end

function CFG(code::Union{CodeInfo,IRCode})
    stmts = if code isa CodeInfo
        code.code
    else
        code.stmts
    end
    bbs = compute_basic_blocks(stmts)
    indices = [1; bbs.index]
    insts = map(1:length(indices)-1) do i
        stmts[indices[i]:indices[i+1]-1]
    end
    g = DeltaGraph(length(bbs.blocks))
    for (i, block) in enumerate(bbs.blocks)
        for pred in block.preds
            add_edge!(g, pred, i)
        end
        for succ in block.succs
            add_edge!(g, i, succ)
        end
    end
    CFG(g, insts, code)
end

function CFG(@nospecialize(f), @nospecialize(argtypes))
    codes = code_typed(f, argtypes)
    if length(codes) > 1
        error("More than one method matches signature ($f, $argtypes).")
    end
    code = first(first(codes))
    CFG(code)
end

function Base.show(io::IO, cfg::CFG)
    print(io, "CFG($(nv(cfg.graph)) nodes, $(ne(cfg.graph)) edges, $(length(cfg.instructions)) instructions)")
end
