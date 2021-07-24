module StructuredCFG

using LightGraphs
using Core.Compiler: CodeInfo, IRCode, compute_basic_blocks

include("graph.jl")
# include("operations.jl")

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

"""
Return an operation that compacts reducible basic blocks.

1 -> 2 -> 3 => 1
"""
function compact_reducible_bb(g, origin)
    outs = outneighbors(g, n)
    if length(outs) == 1
        n′ = first(outs)
        ins = inneighbors(g, n′)
        if length(ins) == 1
            compact_reducible_bb!(g, n′)
            rem_edge!(g, n, n′)
            merge_vertices!(g, [n, n′])
            return true
        end
    end
    false
end

function is_single_entry_single_exit(cfg::CFG)
    g = deepcopy(cfg.graph)
    haschanged = true
    while haschanged
        haschanged = false
        for n in vertices(g)
            outs = outneighbors(g, n)
            # case 1: reduce CFG
            if length(outs) == 1
                n′ = first(outs)
                ins = inneighbors(g, n′)
                if length(ins) == 1
                    rem_edge!(g, n, n′)
                    merge_vertices!(g, [n, n′])
                    haschanged = true
                    break
                end
            end
            # case 2: compress structured branches
            # TODO

            # case 3: remove head-controlled recursion
            if n in outs && length(outs) == 2
                rem_edge!(g, n, n)
                haschanged = true
                break
            end

            # case 4: merge mutually recursive blocks into caller
            for n′ in outs
                if outneighbors(n′) == [n]
                    rem_edge!(n, n′)
                    rem_edge!(n′, n)
                    rem_vertex!(g, n′)
                end
                haschanged = true
                break
            end
            haschanged && break
        end
    end
end

export CFG

end # module
