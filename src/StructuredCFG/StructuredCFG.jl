module StructuredCFG

using LightGraphs
using Core.Compiler: CodeInfo, IRCode, compute_basic_blocks

include("graph.jl")
include("cfg.jl")
include("reflection.jl")

export
        CFG,
        is_single_entry_single_exit,
        is_tail_structured,
        is_single_node,
        rem_head_recursion!,
        compact_reducible_bbs!,
        compact_structured_branches!,
        merge_mutually_recursive!

end # module
