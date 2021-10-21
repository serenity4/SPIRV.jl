@broadcastref struct Block
    id::ID
    insts::Vector{Instruction}
end

struct ControlFlowGraph
    blocks::Vector{Block}
    graph::SimpleDiGraph
end

ControlFlowGraph() = ControlFlowGraph([], SimpleDiGraph())

function get_vertex!(cfg::ControlFlowGraph, block::Block)
    i = findfirst(==(block), cfg.blocks)
    if isnothing(i)
        push!(cfg.blocks, block)
        add_vertex!(cfg.graph)
        nv(cfg.graph)
    else
        i
    end
end

Graphs.add_edge!(cfg::ControlFlowGraph, src::Block, dst::Block) = add_edge!(cfg.graph, get_vertex!(cfg, src), get_vertex!(cfg, dst))

struct FunctionDefinition
    type::ID
    control::FunctionControl
    args::Vector{ID}
    cfg::ControlFlowGraph
end

body(fdef::FunctionDefinition) = foldl(append!, map(x -> x.insts, fdef.cfg.blocks); init=Instruction[])
