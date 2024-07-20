struct DebugFrame
  mi::MethodInstance
  code::CodeInfo
  line::Optional{LineInfoNode}
end
DebugFrame(mi, code) = DebugFrame(mi, code, nothing)

struct InterpDebugInfo
  stacktrace::Vector{DebugFrame}
end

# Care is required for anything that impacts:
# - method_tables
# - inference_parameters
# - optimization_parameters
# The token is compared with `===`.

"Token used for the internal `CodeInstance` caching mechanism."
struct SPIRVToken
  method_tables::Vector{Core.MethodTable}
  inference_parameters::InferenceParams
  optimization_parameters::OptimizationParams
end

const METHOD_TABLES = ScopedValue([INTRINSICS_GLSL_METHOD_TABLE, INTRINSICS_METHOD_TABLE])
NOverlayMethodTable(world) = NOverlayMethodTable(world, METHOD_TABLES[])

SPIRVToken() = SPIRVToken(METHOD_TABLES[])

struct SPIRVInterpreter <: AbstractInterpreter
  global_cache_token::SPIRVToken
  """
  Custom method table to redirect Julia builtin functions to SPIR-V builtins.
  Can also be used to redirect certain function calls to use extended instruction sets instead.
  """
  method_table::NOverlayMethodTable
  "Cache used locally within a particular type inference run."
  local_cache::Vector{InferenceResult}
  "Maximum world in which functions can be used in."
  world::UInt
  inference_parameters::InferenceParams
  optimization_parameters::OptimizationParams
  debug::InterpDebugInfo
end

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
  inference_parameters = InferenceParams(
    # XXX: this prevents `Base.getproperty(::Vec{2, Float64}, ::Symbol)` from being inlined for some reason.
    aggressive_constant_propagation = false,
    assume_bindings_static = true,
  ),
  optimization_parameters = OptimizationParams(inlining = true, inline_cost_threshold = 10000)
)
  method_table = NOverlayMethodTable(world)
  SPIRVInterpreter(
    SPIRVToken(method_table.tables, inference_parameters, optimization_parameters),
    method_table,
    InferenceResult[],
    cap_world(world, get_world_counter()),
    inference_parameters,
    optimization_parameters,
    InterpDebugInfo(DebugFrame[]),
  )
end

code_instance_cache(interp::SPIRVInterpreter) = WorldView(CC.code_cache(interp), WorldRange(interp.world))
retrieve_code_instance(interp::SPIRVInterpreter, mi::MethodInstance) = CC.getindex(code_instance_cache(interp), mi)

#=

Integration with the compiler through the `AbstractInterpreter` interface.

Custom caches and a custom method table are used.
Everything else is similar to the `NativeInterpreter`.

=#

Core.Compiler.InferenceParams(si::SPIRVInterpreter) = si.inference_parameters
Core.Compiler.OptimizationParams(si::SPIRVInterpreter) = si.optimization_parameters
Core.Compiler.get_world_counter(si::SPIRVInterpreter) = si.world
Core.Compiler.get_inference_cache(si::SPIRVInterpreter) = si.local_cache
Core.Compiler.get_inference_world(si::SPIRVInterpreter) = si.world
Core.Compiler.cache_owner(interp::SPIRVInterpreter) = interp.global_cache_token
Core.Compiler.method_table(si::SPIRVInterpreter) = si.method_table

function Base.show(io::IO, interp::SPIRVInterpreter)
  print(io, SPIRVInterpreter, '(', interp.inference_parameters, ", ", interp.optimization_parameters, ')')
end

function CC.concrete_eval_eligible(interp::SPIRVInterpreter, @nospecialize(f), result::CC.MethodCallResult, arginfo::CC.ArgInfo, sv::CC.InferenceState)
  # XXX: We are currently lying to the compiler.
  # TODO: Use the `:consistent_overlay` introduced in https://github.com/JuliaLang/julia/pull/54322.
  nonoverlayed = @static VERSION ≥ v"1.12.0-DEV.745" ? CC.ALWAYS_TRUE : true
  neweffects = CC.Effects(result.effects; nonoverlayed)
  result = CC.MethodCallResult(result.rt, result.exct, result.edgecycle, result.edgelimited, result.edge, neweffects)
  @invoke CC.concrete_eval_eligible(interp::CC.AbstractInterpreter, f::Any, result::CC.MethodCallResult, arginfo::CC.ArgInfo, sv::CC.InferenceState)
end
