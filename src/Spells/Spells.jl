"""
Compile Julia code to SPIR-V.
"""
module Spells

using Graphs
using Core.Compiler: CodeInfo, IRCode, compute_basic_blocks, uncompressed_ir, method_instances, MethodInstance, InferenceResult, typeinf, InferenceState, retrieve_code_info, lock_mi_inference, AbstractInterpreter
using CodeInfoTools
using AutoHashEquals
using MLStyle
using Dictionaries
using ..SPIRV
using ..SPIRV: @forward
using Accessors: @set, setproperties

const Optional{T} = Union{Nothing, T}
const magic_number = 0x12349876

include("deltagraph.jl")
include("interpreter.jl")
include("cfg.jl")
include("basicblocks.jl")
include("reflection.jl")
include("restructuring.jl")
include("intrinsics.jl")
include("compile.jl")

export
        Context,
        Func,
        PrimitiveType,
        CompositeType,

        CFG,
        is_single_entry_single_exit,
        is_tail_structured,
        is_single_node,
        rem_head_recursion!,
        compact_reducible_bbs!,
        compact_structured_branches!,
        merge_mutually_recursive!,
        merge_return_blocks,
        compact,
        sinks,
        sources,

        replace_code!,
        infer!,
        lowered_code,
        inferred_code,

        verify,
        compile

end
