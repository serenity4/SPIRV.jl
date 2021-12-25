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

function CFG(@nospecialize(f), argtypes::Type = Tuple{}; inferred = false)
    mis = method_instances(f, argtypes)
    if length(mis) > 1
        error("""
            More than one method matches signature ($f, $argtypes):

            Matching method instances:
            $(join(string.(" └─ ", mis), "\n"))
            """)
    elseif iszero(length(mis))
        error("No method matching the signature ($f, $argtypes).")
    end
    CFG(only(mis); inferred)
end

function CFG(mi::MethodInstance; inferred = false)
    if inferred
        code = get(GLOBAL_CI_CACHE, mi, nothing)
        if isnothing(code)
            # Run type inference on lowered code.
            cfg = CFG(mi)
            infer(cfg)
        else
            CFG(mi, code)
        end
    else
        CFG(mi, lowered_code(mi))
    end
end

lowered_code(mi::MethodInstance) = uncompressed_ir(mi.def::Method)
inferred_code(ci::CodeInstance) = Core.Compiler._uncompressed_ir(ci, ci.inferred)

CFG(mi::MethodInstance, ci::CodeInstance) = CFG(mi, inferred_code(ci))
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

"Run type inference on the given `MethodInstance`."
function infer(mi::MethodInstance)
    haskey(GLOBAL_CI_CACHE, mi) && return false
    interp = SPIRVInterpreter()
    src = Core.Compiler.typeinf_ext_toplevel(interp, mi)
    haskey(GLOBAL_CI_CACHE, mi) || error("Could not get inferred code from cache.")
    true
end

"""
Run type inference on the provided CFG and wrap inferred code with a new CFG.

The internal `MethodInstance` of the original CFG gets mutated in the process.
"""
function infer(cfg::CFG)
    infer(cfg.mi)
    CFG(cfg.mi, inferred = true)
end

function Base.show(io::IO, cfg::CFG)
    print(io, "CFG ($(nv(cfg.graph)) nodes, $(ne(cfg.graph)) edges, $(sum(length, cfg.instructions)) instructions)")
end

function block_ranges(cfg::CFG)
    map(Base.splat(UnitRange), zip(cfg.indices[1:end-1], cfg.indices[2:end] .- 1))
end

get_signature(f::Symbol) = (f,)
argtype(arg) = isa(arg, DataType) ? Type{arg} : typeof(arg)
function get_signature(ex::Expr)
    @match ex begin
        :($f($(args...))) => (f, :(Tuple{$argtype.($(eval.(args)))...}))
        _ => error("Malformed expression: $ex")
    end
end

macro cfg(ex)
    cfg_args = map(esc, get_signature(ex))
    :(CFG($(cfg_args...); inferred = true))
end
