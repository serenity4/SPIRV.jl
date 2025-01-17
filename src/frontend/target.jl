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

function SPIRVTarget(@nospecialize(f), argtypes::Type = Tuple{}; interp::SPIRVInterpreter = SPIRVInterpreter())
  SPIRVTarget(method_instance(f, argtypes, interp), interp)
end

function method_instances(@nospecialize(f), @nospecialize(t), interp::SPIRVInterpreter)
  sig = Base.signature_type(f, t)
  ret = Core.Compiler.findall(sig, interp.method_table, limit = -1)
  (; matches) = ret
  map(Core.Compiler.specialize_method, matches)
end

function SPIRVTarget(mi::MethodInstance, interp::SPIRVInterpreter)
  cache = code_instance_cache(interp)
  code_instance = CC.get(cache, mi, nothing)
  # If no inferred source is available, pretend we don't have a code instance
  # to run inference again.
  !isnothing(code_instance) && !isnothing(code_instance.inferred) && return SPIRVTarget(mi, code_instance, interp)
  # Run type inference on lowered code.
  code_instance = infer(mi, interp)
  SPIRVTarget(mi, code_instance, interp)
end

function simplify_cfg!(code::CodeInfo)
  mi = code.parent::MethodInstance
  isnothing(code.slottypes) && (code.slottypes = collect(mi.specTypes.types))
  ir = CC.inflate_ir!(code, mi)
  @static if VERSION ≥ v"1.12-DEV"
    ir.debuginfo.def = mi
  end
  ir = CC.compact!(CC.cfg_simplify!(CC.copy(ir)))
  code = CC.ir_to_codeinf!(code, ir)
  ir, code
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

SPIRVTarget(mi::MethodInstance, ci::CodeInstance, interp::AbstractInterpreter) = SPIRVTarget(mi, inferred_code(ci), interp)
function SPIRVTarget(mi::MethodInstance, code::CodeInfo, interp::AbstractInterpreter)
  ir, code = simplify_cfg!(code)
  g = construct_cfg(ir.cfg)
  ranges = block_ranges(ir.cfg, code)
  insts = [code.code[range] for range in ranges]

  # Try to validate the code upon failure to report more helpful errors.
  local cfg
  try
    cfg = ControlFlowGraph(g)
  catch
    ret = validate(code)
    if iserror(ret)
      @error "A validation error occured for the following CodeInfo:"
      show_debug_native_code(stdout, code)
      throw(unwrap_error(ret))
    end
    rethrow()
  end

  SPIRVTarget(mi, cfg, insts, ranges, code, interp)
end

function dump_to_file(code; color = true, ext = nothing)
  output = color ? sprintc_mime(show, code) : sprint_mime(show, code)
  file = tempname() * something(ext, "")
  open(file, "w+") do io
    println(io, output)
  end
  file
end

function show_debug_native_code(io::IO, code::CodeInfo)
  if length(code.code) > 400
    file_color = dump_to_file(code)
    file_no_color = dump_to_file(code; color = false)
    println(io, "The contents of the associated `CodeInfo` are available at $file_no_color (colored version: $file_color)")
  else
    println(io, "Showing the associated `CodeInfo`:\n\n", sprint_mime(show, code; context = IOContext(io)))
  end
  println(io)
end

function show_debug_spirv_code(io::IO, ir::IR)
  output = sprint_mime(show, ir; context = IOContext(io))
  if count(==('\n'), output) > 400
    file_color = dump_to_file(ir; ext = ".spvasm")
    file_no_color = dump_to_file(ir; color = false, ext = ".spvasm")
    println(io, "The contents of the associated SPIR-V module are available at $file_no_color (colored version: $file_color)")
  else
    println(io, "Showing the associated SPIR-V module:\n\n$output")
  end
  println(io)
end

function disable_code_coverage()
  old = JLOptions().code_coverage
  offset = fieldoffset(JLOptions, findfirst(==(:code_coverage), fieldnames(JLOptions)))
  ptr = reinterpret(Ptr{UInt8}, cglobal(:jl_options, JLOptions))
  unsafe_store!(ptr, 0x00, offset + 1)
  old
end

function restore_code_coverage(value)
  offset = fieldoffset(JLOptions, findfirst(==(:code_coverage), fieldnames(JLOptions)))
  ptr = reinterpret(Ptr{UInt8}, cglobal(:jl_options, JLOptions))
  unsafe_store!(ptr, value, offset + 1)
end

"Run type inference on the given `MethodInstance`."
function infer(mi::MethodInstance, interp::AbstractInterpreter)
  # Reset interpreter state.
  empty!(interp.local_cache)
  old = disable_code_coverage()
  local ci
  try
    @static if VERSION ≥ v"1.12-DEV"
      inferred_ci = CC.typeinf_ext_toplevel(interp, mi, CC.SOURCE_MODE_FORCE_SOURCE)
    else
      inferred_ci = CC.typeinf_ext_toplevel(interp, mi)
    end
    cache = code_instance_cache(interp)
    ci = CC.get(cache, mi, nothing)
    !isnothing(ci) || error("Could not get inferred code from the cache for $mi.\n\nThis may be caused by a @generated function body that failed to produce an output.")

    # If src is rettyp_const, the `CodeInfo` is dicarded after type inference
    # (because it is normally not supposed to be used ever again).
    # To avoid the need to re-infer to get the code, store it manually.
    @static if VERSION ≥ v"1.12-DEV"
      if ci.inferred === nothing && isdefined(ci, :rettype_const)
        CC.setindex!(cache, inferred_ci, mi)
        ci = CC.getindex(cache, mi)
      end
    else
      if ci.inferred === nothing
        @atomic ci.inferred = inferred_ci
      end
    end
  finally
    restore_code_coverage(old)
  end
  ci
end

function Base.show(io::IO, target::SPIRVTarget)
  print(io, "SPIRVTarget ($(nv(target.cfg)) nodes, $(ne(target.cfg)) edges, $(sum(length, target.instructions)) instructions)")
end

function block_ranges(cfg::Core.Compiler.CFG, code::CodeInfo)
  indices = [1; cfg.index; 1 + length(code.code)]
  ranges = map(Base.splat(UnitRange), zip(indices[1:(end - 1)], indices[2:end] .- 1))
end
block_ranges(target::SPIRVTarget) = target.block_ranges
block_index(cfg::Core.Compiler.CFG, i::Integer) = findfirst(>(i), cfg.index)
basic_block(cfg::Core.Compiler.CFG, i::Integer) = cfg.blocks[block_index(cfg, i)]

@forward_methods SPIRVTarget field = :cfg traverse

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

macro target(interp, ex)
  f, args = get_signature(ex)
  quote
    f, args = $(esc(f)), $(esc(args))
    interp = $(esc(interp))
    $SPIRVTarget(f, args; interp)
  end
end

macro target(ex)
  :($(esc(:($(@__MODULE__).@target $SPIRVInterpreter() $ex))))
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
  esc(:($(@__MODULE__).@code_typed $debuginfo $SPIRVInterpreter() $ex))
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
  esc(:($(@__MODULE__).@which $ex $SPIRVInterpreter()))
end
