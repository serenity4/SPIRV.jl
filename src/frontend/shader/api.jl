function parse_shader_kwargs(kwargs)
  ex = options = features = cache = assemble = layout = interpreter = validate = optimize = nothing
  for kwarg in kwargs
    @match kwarg begin
      Expr(:(=), :options, value) || :options && Do(value = :options) => (options = value)
      Expr(:(=), :features, value) || :features && Do(value = :features) => (features = value)
      Expr(:(=), :cache, value) || :cache && Do(value = :cache) => (cache = value)
      Expr(:(=), :assemble, value) || :assemble && Do(value = :assemble) => (assemble = value)
      Expr(:(=), :layout, value) || :layout && Do(value = :layout) => (layout = value)
      Expr(:(=), :interpreter, value) || :interpreter && Do(value = :interpreter) => (interpreter = value)
      Expr(:(=), :validate, value) || :validate && Do(value = :validate) => (validate = value)
      Expr(:(=), :optimize, value) || :optimize && Do(value = :optimize) => (optimize = value)
      Expr(:(=), parameter, value) => throw(ArgumentError("Received unknown parameter `$parameter` with value $value"))
      ::Expr => begin
        isnothing(ex) || throw(ArgumentError("Only one non-keyword expression is allowed, but multiple were provided: $ex, $kwarg"))
        ex = kwarg
      end
      _ => throw(ArgumentError("Expected parameter or expression as argument, got $kwarg"))
    end
  end
  !isnothing(ex) || throw(ArgumentError("Expected expression as positional argument"))
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize)
end

Core.@doc macro_docstring(:vertex) macro vertex(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelVertex; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end

Core.@doc macro_docstring(:geometry) macro geometry(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelGeometry; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end

Core.@doc macro_docstring(:tessellation_control) macro tessellation_control(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelTessellationControl; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end

Core.@doc macro_docstring(:tessellation_evaluation) macro tessellation_evaluation(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelTessellationEvaluation; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end

Core.@doc macro_docstring(:fragment) macro fragment(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelFragment; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end

Core.@doc macro_docstring(:compute) macro compute(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelGLCompute; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end

Core.@doc macro_docstring(:ray_generation) macro ray_generation(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelRayGenerationKHR; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end

Core.@doc macro_docstring(:intersection) macro intersection(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelIntersectionKHR; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end

Core.@doc macro_docstring(:closest_hit) macro closest_hit(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelClosestHitKHR; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end

Core.@doc macro_docstring(:any_hit) macro any_hit(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelAnyHitKHR; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end

Core.@doc macro_docstring(:miss) macro miss(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelMissKHR; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end

Core.@doc macro_docstring(:callable) macro callable(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelCallableKHR; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end

Core.@doc macro_docstring(:task) macro task(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelTaskEXT; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end

Core.@doc macro_docstring(:mesh) macro mesh(kwargs...)
  (ex, options, features, cache, assemble, layout, interpreter, validate, optimize) = parse_shader_kwargs(kwargs)
  propagate_source(__source__, esc(compile_shader_ex(ex, __module__, ExecutionModelMeshEXT; options, features, cache, assemble, layout, interpreter, validate, optimize)))
end
