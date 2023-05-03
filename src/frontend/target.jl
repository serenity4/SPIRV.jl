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
  block_ranges::Vector{UnitRange{Int}}
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

function SPIRVTarget(@nospecialize(f), argtypes::Type = Tuple{}; inferred = true, interp::SPIRVInterpreter = SPIRVInterpreter())
  reset_world!(interp)
  SPIRVTarget(method_instance(f, argtypes, interp), interp; inferred)
end

function method_instances(@nospecialize(f), @nospecialize(t), interp::SPIRVInterpreter)
  sig = Base.signature_type(f, t)
  ret = Core.Compiler.findall(sig, interp.method_table, limit = -1)
  (; matches) = method_lookup_result(ret)
  map(Core.Compiler.specialize_method, matches)
end

function SPIRVTarget(mi::MethodInstance, interp::AbstractInterpreter; inferred = true)
  if inferred
    code_instance = get(interp.global_cache, mi, nothing)
    if isnothing(code_instance)
      # Run type inference on lowered code.
      infer(mi, interp)
      SPIRVTarget(mi, interp; inferred = true)
    else
      SPIRVTarget(mi, code_instance, interp)
    end
  else
    SPIRVTarget(mi, lowered_code(mi), interp, inferred)
  end
end

function lowered_code(mi::MethodInstance)
  !Base.hasgenerator(mi) && return uncompressed_ir(mi.def::Method)
  Base.may_invoke_generator(mi) || error("cannot call @generated function `", mi, "` ")
  (@ccall jl_code_for_staged(mi::Any)::Any)::CodeInfo
end
inferred_code(ci::CodeInstance) = isa(ci.inferred, CodeInfo) ? ci.inferred : Core.Compiler._uncompressed_ir(ci, ci.inferred)

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

SPIRVTarget(mi::MethodInstance, ci::CodeInstance, interp::AbstractInterpreter) = SPIRVTarget(mi, inferred_code(ci), interp, true)
function SPIRVTarget(mi::MethodInstance, code::CodeInfo, interp::AbstractInterpreter, inferred::Bool)
  inferred && (code = apply_passes(code))
  cfg_core = compute_basic_blocks(code.code)
  g = construct_cfg(cfg_core)
  ranges = block_ranges(cfg_core)
  insts = [code.code[range] for range in ranges]

  # Try to validate the code upon failure to report more helpful errors.
  local cfg
  try
    cfg = ControlFlowGraph(g)
  catch
    ret = validate(code)
    iserror(ret) && throw(unwrap_error(ret))
    rethrow()
  end

  SPIRVTarget(mi, cfg, insts, ranges, code, interp)
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

function Base.show(io::IO, target::SPIRVTarget)
  print(io, "SPIRVTarget ($(nv(target.cfg)) nodes, $(ne(target.cfg)) edges, $(sum(length, target.instructions)) instructions)")
end

function block_ranges(cfg::Core.Compiler.CFG)
  indices = [1; cfg.index]
  map(Base.splat(UnitRange), zip(indices[1:(end - 1)], indices[2:end] .- 1))
end
block_ranges(target::SPIRVTarget) = target.block_ranges
block_index(cfg::Core.Compiler.CFG, i::Integer) = findfirst(>(i), cfg.index)
basic_block(cfg::Core.Compiler.CFG, i::Integer) = cfg.blocks[block_index(cfg, i)]

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
