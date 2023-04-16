const DeltaCFG = ControlFlowGraph{Edge{Int}, Int, DeltaGraph{Int}}

"SPIR-V target for compilation through the Julia frontend."
struct SPIRVTarget
  mi::MethodInstance
  """
  Graph where nodes represent basic blocks, and edges represent branches.
  """
  cfg::DeltaCFG
  """
  Mapping from node index to instructions.
  """
  instructions::Vector{Vector{Any}}
  indices::Vector{Int}
  code::CodeInfo
  interp::SPIRVInterpreter
end

function method_instance(@nospecialize(f), argtypes::Type = Tuple{}, interp::SPIRVInterpreter = SPIRVInterpreter())
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
  mis[1]
end

function SPIRVTarget(@nospecialize(f), argtypes::Type = Tuple{}; inferred = false, interp::SPIRVInterpreter = SPIRVInterpreter())
  reset_world!(interp)
  SPIRVTarget(method_instance(f, argtypes, interp), interp; inferred)
end

function method_instances(@nospecialize(f), @nospecialize(t), interp::SPIRVInterpreter)
  sig = Base.signature_type(f, t)
  ret = Core.Compiler.findall(sig, interp.method_table, limit = -1)
  (; matches) = method_lookup_result(ret)
  map(Core.Compiler.specialize_method, matches)
end

function SPIRVTarget(mi::MethodInstance, interp::AbstractInterpreter; inferred = false)
  if inferred
    code = get(interp.global_cache, mi, nothing)
    if isnothing(code)
      # Run type inference on lowered code.
      target = SPIRVTarget(mi, interp; inferred = false)
      infer(target)
    else
      SPIRVTarget(mi, code, interp)
    end
  else
    SPIRVTarget(mi, lowered_code(mi), interp)
  end
end

function lowered_code(mi::MethodInstance)
  !Base.hasgenerator(mi) && return uncompressed_ir(mi.def::Method)
  Base.may_invoke_generator(mi) || error("cannot call @generated function `", mi, "` ")
  (@ccall jl_code_for_staged(mi::Any)::Any)::CodeInfo
end
inferred_code(ci::CodeInstance) = isa(ci.inferred, CodeInfo) ? ci.inferred : Core.Compiler._uncompressed_ir(ci, ci.inferred)

function delete_blocks!(code::CodeInfo, block_ranges, g, to_delete)
  for deleted in sort(to_delete; rev = true)
    range = block_ranges[deleted]
    splice!(code.code, range)
    splice!(code.ssavaluetypes, range)
    splice!(code.ssaflags, range)
    splice!(code.codelocs, range)
  end
  splice!(block_ranges, to_delete)
  rem_vertices!(g, to_delete)
  recompute_ranges!(block_ranges)
end

function recompute_ranges!(block_ranges)
  prev = 0
  for (i, range) in enumerate(block_ranges)
    nmissing = first(range) - (prev + 1)
    !iszero(nmissing) && (block_ranges[i] = range .- nmissing)
    prev = last(block_ranges[i])
  end
end

function remove_nothing_entry_nodes!(code::CodeInfo, block_ranges, g, cfg::Core.Compiler.CFG)
  to_delete = Int[]
  for (i, range) in enumerate(block_ranges)
    length(range) == 1 || continue
    inst = code.code[range[1]]
    inst === nothing && isempty(cfg.blocks[i].preds) && push!(to_delete, i)
  end
  isempty(to_delete) && return
  delete_blocks!(code, block_ranges, g, to_delete)
end

function construct_cfg(cfg::Core.Compiler.CFG)
  g = DeltaGraph(length(cfg.blocks))
  for (i, block) in enumerate(cfg.blocks)
    for pred in block.preds
      add_edge!(g, pred, i)
    end
    for succ in block.succs
      add_edge!(g, i, succ)
    end
  end
  g
end

SPIRVTarget(mi::MethodInstance, ci::CodeInstance, interp::AbstractInterpreter) = SPIRVTarget(mi, inferred_code(ci), interp)
function SPIRVTarget(mi::MethodInstance, code::CodeInfo, interp::AbstractInterpreter)
  code = copy(code)
  code.code = deepcopy(code.code)
  code.codelocs = deepcopy(code.codelocs)
  code.ssavaluetypes = deepcopy(code.ssavaluetypes)
  code.ssaflags = deepcopy(code.ssaflags)
  bbs = compute_basic_blocks(code.code)
  indices = [1; bbs.index]
  block_ranges = [indices[i]:(indices[i + 1] - 1) for i in 1:(length(indices) - 1)]
  g = construct_cfg(bbs)
  remove_nothing_entry_nodes!(code, block_ranges, g, bbs)
  g = compact(g)
  insts = [code.code[range] for range in block_ranges]

  # Strip remaining meta expressions if any.
  if !isempty(last(insts)) && all(Meta.isexpr(st, :meta) for st in last(insts))
    pop!(insts)
    deleteat!(code.code, pop!(indices) - 1)
    rem_vertex!(g, nv(g))
  end

  # Try to validate the code upon failure to report more helpful errors.
  local cfg
  try
    cfg = ControlFlowGraph(g)
  catch
    ret = validate(code)
    iserror(ret) && throw(unwrap_error(ret))
    rethrow()
  end

  SPIRVTarget(mi, cfg, insts, indices, code, interp)
end

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
    @static if VERSION ≥ v"1.9.0-DEV.1115"
      @atomic ci.inferred = src
    else
      ci.inferred = src
    end
  end
  haskey(global_cache, mi) || error("Could not get inferred code from cache.")
  true
end

"""
Run type inference on the provided target.

The internal `MethodInstance` of the original target gets mutated in the process.
"""
function infer(target::SPIRVTarget)
  infer(target.mi, target.interp)
  SPIRVTarget(target.mi, target.interp, inferred = true)
end

function Base.show(io::IO, target::SPIRVTarget)
  print(io, "SPIRVTarget ($(nv(target.cfg)) nodes, $(ne(target.cfg)) edges, $(sum(length, target.instructions)) instructions)")
end

function block_ranges(target::SPIRVTarget)
  map(Base.splat(UnitRange), zip(target.indices[1:(end - 1)], target.indices[2:end] .- 1))
end

@forward SPIRVTarget.cfg (traverse, postdminator)

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
          :(::$T) || :($_::$T) => T
          _ => :($argtype($arg))
        end
      end
      (f, :(Tuple{$(atypes...)}))
    end
    _ => error("Malformed expression: $ex")
  end
end

macro target(infer, interp, ex)
  cfg_args = get_signature(ex)
  infer = @match infer begin
    :(infer = $val) && if isa(val, Bool)
    end => val
    _ => error("Invalid `infer` option, expected infer=<val> where <val> can be either true or false.")
  end
  :(SPIRVTarget($(esc.(cfg_args)...); inferred = $infer, interp = $(esc(interp))))
end

macro target(interp, ex)
  :($(esc(:($(@__MODULE__).@target infer = true $interp $ex))))
end
macro target(ex)
  :($(esc(:($(@__MODULE__).@target $(SPIRVInterpreter()) $ex))))
end

macro code_typed(debuginfo, interp, ex)
  debuginfo = @match debuginfo begin
    :(debuginfo = $val) => val
    _ => error("Expected 'debuginfo = <value>' where <value> is one of (:source, :none)")
  end
  ex = quote
    target = $(esc(:(SPIRV.@target $interp $ex)))
    code = target.code
    $debuginfo == :none && Base.remove_linenums!(code)
    code
  end
end

macro code_typed(debuginfo, ex)
  esc(:($(@__MODULE__).@code_typed $debuginfo $(SPIRVInterpreter()) $ex))
end
macro code_typed(ex)
  esc(:($(@__MODULE__).@code_typed debuginfo=:none $ex))
end

macro which(ex, interp)
  f, argtypes = map(esc, get_signature(ex))
  quote
    mis = method_instances($f, $argtypes, $(esc(interp)))
    for mi in mis
      print(mi)
      printstyled(" at ", mi.def.file, ':', mi.def.line, " @ "; color = :light_black)
      printstyled(mi.def.module, color = :magenta)
      println()
    end
    println()
    length(mis) == 1 ? mis[1] : mis
  end
end
macro which(ex)
  esc(:($(@__MODULE__).@which $ex $(SPIRVInterpreter())))
end
