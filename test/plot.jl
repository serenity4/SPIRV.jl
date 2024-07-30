# For prototyping; not used during actual tests.
using SPIRV: SPIRV, IR, ControlFlowGraph, DeltaGraph
using Graphs: Graphs, SimpleDiGraph
using Plots: plot
import GraphRecipes

function edgecolors(cfg::ControlFlowGraph)
  colors = Dict{Tuple{Int, Int},Any}()
  insert!(dict, key, value) = haskey(dict, key) ? error("Key already exists: $key") : (dict[key] = value)
  classification = cfg.ec
  for edge in edges(cfg)
    key = (src(edge), dst(edge))
    in(edge, classification.retreating_edges) && insert!(colors, key, :green)
    in(edge, classification.tree_edges) && insert!(colors, key, :gray)
    in(edge, classification.forward_edges) && insert!(colors, key, "#55aaaa")
    in(edge, classification.cross_edges) && insert!(colors, key, :red)
    haskey(colors, key) || error("Unclassified edge: $edge")
  end
  colors
end

plotcfg(g; names = Graphs.vertices(g), nodesize = 0.3, size = (1000, 1000), nodeshape = :circle, nodecolor = "#ffbb00", background_color = "rgb(10, 10, 12)", edgecolor=:gray, kwargs...) = plot(g; names, nodesize, size, nodeshape, nodecolor, background_color, edgecolor, kwargs...)
plotcfg(g::DeltaGraph; kwargs...) = plotcfg(SimpleDiGraph(g); kwargs...)
plotcfg(tgt::SPIRV.SPIRVTarget; kwargs...) = plotcfg(tgt.cfg; kwargs...)
plotcfg(cfg::ControlFlowGraph; kwargs...) = plotcfg(cfg.g; edgecolor=edgecolors(cfg), kwargs...)
plotcfg(mod::SPIRV.Module; kwargs...) = plotcfg(IR(mod); kwargs...)
plotcfg(ir::IR; kwargs...) = plotcfg(only(ir); kwargs...)
plotcfg(shader::SPIRV.Shader; kwargs...) = plotcfg(shader.ir; kwargs...)
function plotcfg(fdef::SPIRV.FunctionDefinition; ssa_indices = true, kwargs...)
  isa(fdef, Integer) && (fdef = collect(ir.fdefs)[fdef])
  if ssa_indices
    names = fdef.block_ids
    plotcfg(ControlFlowGraph(fdef); names, nodesize = 0.2, kwargs...)
  else
    plotcfg(ControlFlowGraph(fdef); kwargs...)
  end
end
