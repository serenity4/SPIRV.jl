function parse_shader_kwargs(kwargs)
  ex = options = cache = assemble = layout = interpreter = nothing
  for kwarg in kwargs
    @match kwarg begin
      Expr(:(=), :options, value) || :options && Do(value = :options) => (options = value)
      Expr(:(=), :cache, value) || :cache && Do(value = :cache) => (cache = value)
      Expr(:(=), :assemble, value) || :assemble && Do(value = :assemble) => (assemble = value)
      Expr(:(=), :interpreter, value) || :interpreter && Do(value = :interpreter) => (interpreter = value)
      Expr(:(=), :layout, value) || :layout && Do(value = :layout) => (layout = value)
      Expr(:(=), parameter, value) => throw(ArgumentError("Received unknown parameter `$parameter` with value $value"))
      ::Expr => (ex = kwarg)
      _ => throw(ArgumentError("Expected parameter or expression as argument, got $kwarg"))
    end
  end
  !isnothing(ex) || throw(ArgumentError("Expected expression as positional argument"))
  (ex, options, cache, assemble, layout, interpreter)
end

for (stage, model) in pairs(EXECUTION_MODELS)
  @eval Core.@doc $(macro_docstring(stage)) macro $stage(features, kwargs...)
    (ex, options, cache, assemble, layout, interpreter) = parse_shader_kwargs(kwargs)
    propagate_source(__source__, esc(compile_shader_ex(ex, __module__, $model, options, features; cache, assemble, layout, interpreter)))
  end
end
