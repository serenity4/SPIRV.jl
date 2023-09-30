const execution_models = dictionary([
  :vertex => ExecutionModelVertex,
  :geometry => ExecutionModelGeometry,
  :tessellation_control => ExecutionModelTessellationControl,
  :tessellation_evaluation => ExecutionModelTessellationEvaluation,
  :fragment => ExecutionModelFragment,
  :compute => ExecutionModelGLCompute,
  :ray_generation => ExecutionModelRayGenerationKHR,
  :intersection => ExecutionModelIntersectionKHR,
  :closest_hit => ExecutionModelClosestHitKHR,
  :any_hit => ExecutionModelAnyHitKHR,
  :miss => ExecutionModelMissKHR,
  :callable => ExecutionModelCallableKHR,
  :task => ExecutionModelTaskEXT,
  :mesh => ExecutionModelMeshEXT,
])

macro shader(model::QuoteNode, features, layout, args...)
  (ex, options, cache, assemble, interpreter) = parse_shader_args(args)
  propagate_source(__source__, esc(shader(ex, execution_models[model.value::Symbol], options, features, layout, cache; assemble, interpreter)))
end

function parse_shader_args(args)
  ex = options = cache = assemble = interpreter = nothing
  for arg in args
    @match arg begin
      Expr(:(=), :options, value) || :options && Do(value = :options) => (options = value)
      Expr(:(=), :cache, value) || :cache && Do(value = :cache) => (cache = value)
      Expr(:(=), :assemble, value) || :assemble && Do(value = :assemble) => (assemble = value)
      Expr(:(=), :interpreter, value) || :interpreter && Do(value = :interpreter) => (interpreter = value)
      Expr(:(=), parameter, value) => throw(ArgumentError("Received unknown parameter `$parameter` with value $value"))
      ::Expr => (ex = arg)
      _ => throw(ArgumentError("Expected parameter or expression as argument, got $arg"))
    end
  end
  !isnothing(ex) || throw(ArgumentError("Expected expression as positional argument"))
  (ex, options, cache, assemble, interpreter)
end

for (name, model) in pairs(execution_models)
  @eval macro $name(features, layout, args...)
    (ex, options, cache, assemble, interpreter) = parse_shader_args(args)
    propagate_source(__source__, esc(shader(ex, $model, options, features, layout, cache; assemble, interpreter)))
  end
end
