module StructuredCFG

using LightGraphs
using Core.Compiler: CodeInfo, IRCode, compute_basic_blocks

include("graph.jl")
include("cfg.jl")
include("reflection.jl")

export CFG, is_single_entry_single_exit

end # module
