module StructuredCFG

using LightGraphs
using Core.Compiler: CodeInfo, IRCode, compute_basic_blocks
using CodeInfoTools
using MLStyle

include("graph.jl")
include("cfg.jl")
include("basicblocks.jl")
include("reflection.jl")
include("restructuring.jl")

export
        CFG,
        is_single_entry_single_exit,
        is_tail_structured,
        is_single_node,
        rem_head_recursion!,
        compact_reducible_bbs!,
        compact_structured_branches!,
        merge_mutually_recursive!,
        merge_return_blocks,

        verify

end # module
