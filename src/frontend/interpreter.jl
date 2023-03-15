struct DebugFrame
  mi::MethodInstance
  code::CodeInfo
end

struct InterpDebugInfo
  stacktrace::Vector{DebugFrame}
end

mutable struct SPIRVInterpreter <: AbstractInterpreter
  "Global cache used for memoizing the results of type inference."
  global_cache::CodeInstanceCache
  """
  Custom method table to redirect Julia builtin functions to SPIR-V builtins.
  Can also be used to redirect certain function calls to use extended instruction sets instead.
  """
  method_table::NOverlayMethodTable
  "Cache used locally within a particular type inference run."
  local_cache::Vector{InferenceResult}
  "Maximum world in which functions can be used in."
  world::UInt
  inf_params::InferenceParams
  opt_params::OptimizationParams
  debug::InterpDebugInfo
end

# Avoid copying the interpreter in deep copies.
Base.deepcopy_internal(interp::SPIRVInterpreter, ::IdDict) = interp

function cap_world(world, max_world)
  if world == typemax(UInt)
    # Sometimes the caller is lazy and passes typemax(UInt).
    # We cap it to the current world age.
    max_world
  else
    world ≤ max_world || error("The provided world is too new ($world), expected world ≤ $max_world")
    world
  end
end

# Constructor adapted from Julia's `NativeInterpreter`.
function SPIRVInterpreter(
  world::UInt = get_world_counter();
  inf_params = (@static if VERSION ≥ v"1.9"
     InferenceParams(
      aggressive_constant_propagation = false, # XXX: this prevents `Base.getproperty(::Vec{2, Float64}, ::Symbol)` from being inlined for some reason.
      assume_bindings_static = true,
    )
  else
    InferenceParams()
  end),
  opt_params = OptimizationParams(inlining = true, inline_cost_threshold = 10000, trust_inference = true),
  method_tables = [INTRINSICS_GLSL_METHOD_TABLE, INTRINSICS_METHOD_TABLE],
  global_cache = DEFAULT_CI_CACHE)
  SPIRVInterpreter(
    global_cache,
    NOverlayMethodTable(world, method_tables),
    InferenceResult[],
    cap_world(world, get_world_counter()),
    inf_params,
    opt_params,
    InterpDebugInfo(DebugFrame[]),
  )
end

SPIRVInterpreter(method_tables::Vector{Core.MethodTable}; world::UInt = get_world_counter(), kwargs...) =
  SPIRVInterpreter(world; method_tables, kwargs...)

function invalidate_all!(interp::SPIRVInterpreter = SPIRVInterpreter())
  invalidate_all(interp.global_cache, interp.world)
  nothing
end

function reset_world!(interp::SPIRVInterpreter)
  interp.world = get_world_counter()
  interp.method_table = NOverlayMethodTable(interp.world, interp.method_table.tables)
  nothing
end

#=

Integration with the compiler through the `AbstractInterpreter` interface.

Custom caches and a custom method table are used.
Everything else is similar to the `NativeInterpreter`.

=#

Core.Compiler.InferenceParams(si::SPIRVInterpreter) = si.inf_params
Core.Compiler.OptimizationParams(si::SPIRVInterpreter) = si.opt_params
Core.Compiler.get_world_counter(si::SPIRVInterpreter) = si.world
Core.Compiler.get_inference_cache(si::SPIRVInterpreter) = si.local_cache
Core.Compiler.code_cache(si::SPIRVInterpreter) = WorldView(si.global_cache, si.world)
if VERSION ≥ v"1.8.0-beta2" # initially from 1.9.0-DEV.120 but has then been backported.
  Core.Compiler.method_table(si::SPIRVInterpreter) = si.method_table
else
  Core.Compiler.method_table(si::SPIRVInterpreter, sv::InferenceState) = si.method_table
end

@static if VERSION < v"1.9.0-DEV.1054"
  is_inlineable(src) = ccall(:jl_ir_flag_inlineable, Bool, (Any,), src)
else
  using Core.Compiler: is_inlineable
end

# XXX: Can we remove this?
function Core.Compiler.inlining_policy(si::SPIRVInterpreter, @nospecialize(src), stmt_flag::UInt8,
  mi::MethodInstance, argtypes::Vector{Any})
  if isa(src, CodeInfo) || isa(src, Vector{UInt8})
    src_inferred = ccall(:jl_ir_flag_inferred, Bool, (Any,), src)
    src_inlineable = Core.Compiler.is_stmt_inline(stmt_flag) || is_inlineable(src)
    return src_inferred && src_inlineable ? src : nothing
  elseif src === nothing && Core.Compiler.is_stmt_inline(stmt_flag)
    # if this statement is forced to be inlined, make an additional effort to find the
    # inferred source in the local cache
    # we still won't find a source for recursive call because the "single-level" inlining
    # seems to be more trouble and complex than it's worth
    inf_result = Core.Compiler.cache_lookup(mi, argtypes, Core.Compiler.get_inference_cache(si))
    inf_result === nothing && return nothing
    src = inf_result.src
    if isa(src, CodeInfo)
      src_inferred = ccall(:jl_ir_flag_inferred, Bool, (Any,), src)
      return src_inferred ? src : nothing
    end
  end
end

function Base.show(io::IO, interp::SPIRVInterpreter)
  print(io, SPIRVInterpreter, '(', interp.inf_params, ", ", interp.opt_params, ')')
end
