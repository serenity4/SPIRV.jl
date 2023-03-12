# For prototyping; not used during actual tests.
using SPIRV: SPIRV, IR, ControlFlowGraph
using Graphs: Graphs
using Plots: plot
import GraphRecipes

plotcfg(g; names = Graphs.vertices(g), nodesize = 0.3, kwargs...) = plot(g; names, nodesize, kwargs...)
plotcfg(tgt::SPIRV.SPIRVTarget; kwargs...) = plotcfg(tgt.cfg; kwargs...)
plotcfg(cfg::ControlFlowGraph; kwargs...) = plotcfg(cfg.g; kwargs...)
plotcfg(shader::SPIRV.Shader, args...; kwargs...) = plotcfg(SPIRV.Module(shader), args...; kwargs...)
plotcfg(mod::SPIRV.Module, args...; kwargs...) = plotcfg(IR(mod), args...; kwargs...)
function plotcfg(ir::IR, fdef = 1; ssa_indices = true, kwargs...)
  isa(fdef, Integer) && (fdef = collect(ir.fdefs)[fdef])
  if ssa_indices
    names = fdef.block_ids
    plotcfg(ControlFlowGraph(fdef); names, nodesize = 0.2, kwargs...)
  else
    plotcfg(ControlFlowGraph(fdef); kwargs...)
  end
end
