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
  interp::SPIRVInterpreter
end

function CFG(@nospecialize(f), argtypes::Type = Tuple{}; inferred = false, interp = SPIRVInterpreter())
  reset_world!(interp)

  mis = method_instances(f, argtypes, interp)
  if length(mis) > 1
    error("""
        More than one method matches signature ($f, $argtypes):

        Matching method instances:
        $(join(string.(" └─ ", mis), "\n"))
        """)
  elseif iszero(length(mis))
    error("No method matching the signature ($f, $argtypes).")
  end
  CFG(only(mis), interp; inferred)
end

function method_instances(@nospecialize(f), @nospecialize(t), interp::AbstractInterpreter)
  sig = Base.signature_type(f, t)
  (; matches) = Core.Compiler.findall(sig, interp.method_table, limit = -1)
  map(Core.Compiler.specialize_method, matches)
end

function CFG(mi::MethodInstance, interp::AbstractInterpreter; inferred = false)
  if inferred
    code = get(interp.global_cache, mi, nothing)
    if isnothing(code)
      # Run type inference on lowered code.
      cfg = CFG(mi, interp; inferred = false)
      infer(cfg)
    else
      CFG(mi, code, interp)
    end
  else
    CFG(mi, lowered_code(mi), interp)
  end
end

lowered_code(mi::MethodInstance) = uncompressed_ir(mi.def::Method)
inferred_code(ci::CodeInstance) = isa(ci.inferred, CodeInfo) ? ci.inferred : Core.Compiler._uncompressed_ir(ci, ci.inferred)

CFG(mi::MethodInstance, ci::CodeInstance, interp::AbstractInterpreter) = CFG(mi, inferred_code(ci), interp)
function CFG(mi::MethodInstance, code::CodeInfo, interp::AbstractInterpreter)
  stmts = copy(code.code)
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
  insts = map(1:(length(indices) - 1)) do i
    stmts[indices[i]:(indices[i + 1] - 1)]
  end

  # Strip remaining meta expressions if any.
  if !isempty(last(insts)) && all(Meta.isexpr(st, :meta) for st in last(insts))
    pop!(insts)
    deleteat!(code.code, pop!(indices) - 1)
    rem_vertex!(g, nv(g))
  end

  CFG(mi, g, insts, indices, code, interp)
end

function CodeInfoTools.verify(cfg::CFG)
  verify(cfg.code)
end

exit_blocks(cfg::CFG) = BasicBlock.(sinks(cfg.graph))

"Run type inference on the given `MethodInstance`."
function infer(mi::MethodInstance, interp::AbstractInterpreter)
  (; global_cache) = interp
  haskey(global_cache, mi) && return false

  # Reset interpreter state.
  empty!(interp.local_cache)

  src = Core.Compiler.typeinf_ext_toplevel(interp, mi)

  # If src is rettyp_const, the `CodeInfo` is dicarded after type inference
  # (because it is normally not supposed to be used ever again).
  # To avoid the need to re-infer to get the code, store it manually.
  ci = get(global_cache, mi, nothing)
  if ci !== nothing && ci.inferred === nothing
    ci.inferred = src
  end
  haskey(global_cache, mi) || error("Could not get inferred code from cache.")
  true
end

"""
Run type inference on the provided CFG and wrap inferred code with a new CFG.

The internal `MethodInstance` of the original CFG gets mutated in the process.
"""
function infer(cfg::CFG)
  infer(cfg.mi, cfg.interp)
  CFG(cfg.mi, cfg.interp, inferred = true)
end

function Base.show(io::IO, cfg::CFG)
  print(io, "CFG ($(nv(cfg.graph)) nodes, $(ne(cfg.graph)) edges, $(sum(length, cfg.instructions)) instructions)")
end

function block_ranges(cfg::CFG)
  map(Base.splat(UnitRange), zip(cfg.indices[1:(end - 1)], cfg.indices[2:end] .- 1))
end

get_signature(f::Symbol) = (f,)
function argtype(arg)
  @match arg begin
    ::DataType => Type{arg}
    _ => typeof(arg)
  end
end
function get_signature(ex::Expr)
  @match ex begin
    :($f($(args...))) => begin
      atypes = map(args) do arg
        @match arg begin
          :(::$T) => T
          _ => :($argtype($arg))
        end
      end
      (f, :(Tuple{$(atypes...)}))
    end
    _ => error("Malformed expression: $ex")
  end
end

macro cfg(infer, interp, ex)
  cfg_args = get_signature(ex)
  infer = @match infer begin
    :(infer = $val) && if isa(val, Bool)
    end => val
    _ => error("Invalid `infer` option, expected infer=<val> where <val> can be either true or false.")
  end
  :(CFG($(esc.(cfg_args)...); inferred = $infer, interp = $(esc(interp))))
end

macro cfg(interp, ex)
  :($(esc(:($(@__MODULE__).@cfg infer = true $interp $ex))))
end
macro cfg(ex)
  :($(esc(:($(@__MODULE__).@cfg $(SPIRVInterpreter()) $ex))))
end

macro code_typed(debuginfo, interp, ex)
  debuginfo = @match debuginfo begin
    :(debuginfo = $val) => val
    _ => error("Expected 'debuginfo = <value>' where <value> is one of (:source, :none)")
  end
  ex = quote
    cfg = $(esc(:(@cfg $interp $ex)))
    code = cfg.code
    $debuginfo == :none && Base.remove_linenums!(code)
    code
  end
end

macro code_typed(interp, ex)
  esc(:($(@__MODULE__).@code_typed debuginfo = :source $interp $ex))
end
macro code_typed(ex)
  esc(:($(@__MODULE__).@code_typed $(SPIRVInterpreter()) $ex))
end
