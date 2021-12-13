"Control Flow Graph (CFG)"
struct CFG
    mi::MethodInstance
    """
    Graph where nodes represent basic blocks, and edges represent branches.
    """
    graph::DeltaGraph
    """
    Mapping from node index to instructions.
    """
    instructions::Vector{Vector{Any}}
    indices::Vector{Int}
    code::CodeInfo
end

@forward CFG.mi (cache_lowered!, cache_inferred!)

struct CodeCache
    dict::Dictionary{MethodInstance,CodeInfo}
end
CodeCache() = CodeCache(Dictionary())

@forward CodeCache.dict (Base.haskey, Base.get, Base.insert!, Base.getindex)

const LOWERED_CODE_CACHE = CodeCache()
const INFERRED_CODE_CACHE = CodeCache()

function CFG(@nospecialize(f), argtypes::Type = Tuple{}; inferred = false)
    mis = method_instances(f, argtypes)
    if length(mis) > 1
        error("More than one method matches signature ($f, $argtypes).")
    elseif iszero(length(mis))
        error("No method matching the signature ($f, $argtypes).")
    end
    CFG(only(mis); inferred)
end

function CFG(mi::MethodInstance; inferred = false)
    code = get(INFERRED_CODE_CACHE, mi, nothing)
    inferred && error("Could not get inferred code from cache.")
    code = @something(code, get(LOWERED_CODE_CACHE, mi, nothing), lowered_code(mi))
    CFG(mi, code)
end

lowered_code(mi::MethodInstance) = uncompressed_ir(mi.def::Method)

function CFG(mi::MethodInstance, code::CodeInfo)
    stmts = code.code
    bbs = compute_basic_blocks(stmts)

    g = DeltaGraph(length(bbs.blocks))
    for (i, block) in enumerate(bbs.blocks)
        for pred in block.preds
            add_edge!(g, pred, i)
        end
        for succ in block.succs
            add_edge!(g, i, succ)
        end
    end

    indices = [1; bbs.index]
    insts = map(1:length(indices)-1) do i
        stmts[indices[i]:indices[i+1]-1]
    end

    CFG(mi, g, insts, indices, code)
end

function CodeInfoTools.verify(cfg::CFG)
    verify(cfg.code)
end

exit_blocks(cfg::CFG) = BasicBlock.(sinks(cfg.graph))

cache_lowered!(mi::MethodInstance, code::CodeInfo) = insert!(LOWERED_CODE_CACHE, mi, code)
cache_inferred!(mi::MethodInstance, code::CodeInfo) = insert!(INFERRED_CODE_CACHE, mi, code)

"Run type inference on the given `MethodInstance`."
function infer!(mi::MethodInstance)
    haskey(INFERRED_CODE_CACHE, mi) && return INFERRED_CODE_CACHE[mi]
    interp = Core.Compiler.NativeInterpreter()
    result = InferenceResult(mi)
    src = get(LOWERED_CODE_CACHE, mi, nothing)
    src = !isnothing(src) ? copy(src) : retrieve_code_info(result.linfo)
    frame = InferenceState(result, src, :global, interp)
    lock_mi_inference(interp, result.linfo)
    typeinf(interp, frame)
    cache_inferred!(mi, src)
    src
end

"""
Run type inference on the provided CFG and wrap inferred code with a new CFG.

The internal `MethodInstance` of the original CFG gets mutated in the process.
"""
function infer!(cfg::CFG)
    code = infer!(cfg.mi)
    CFG(cfg.mi, code)
end

inferred_code(cfg::CFG) = inferred_code(cfg.mi)
inferred_code(mi::MethodInstance) = Core.Compiler._uncompressed_ir(mi.cache, mi.cache.inferred)

function Base.show(io::IO, cfg::CFG)
    print(io, "CFG ($(nv(cfg.graph)) nodes, $(ne(cfg.graph)) edges, $(sum(length, cfg.instructions)) instructions)")
end

function block_ranges(cfg::CFG)
    map(Base.splat(UnitRange), zip(cfg.indices[1:end-1], cfg.indices[2:end] .- 1))
end
