struct MemoryResource
  address::ResultID
  type::ResultID
end

@struct_hash_equal struct Shader
  ir::IR
  entry_point::ResultID
  layout::VulkanLayout
  memory_resources::ResultDict{MemoryResource}
end

@forward_methods Shader field = :ir Module assemble

function validate(shader::Shader)
  flags = String[]
  (; layout) = Shader
  if isa(layout, VulkanLayout)
    layout.alignment.scalar_block_layout && push!(flags, "--scalar-block-layout")
    layout.alignment.uniform_buffer_standard_layout && push!(flags, "--uniform-buffer-standard-layout")
  end
  validate_shader(shader.ir; flags)
end

function Shader(target::SPIRVTarget, interface::ShaderInterface, layout::VulkanLayout = VulkanLayout())
  ir = IR(target, interface)
  merge_layout!(layout, ir)
  main = entry_point(ir, :main).func
  satisfy_requirements!(ir, interface.features)

  add_type_layouts!(ir, layout)
  add_align_operands!(ir, ir.fdefs[main], layout)

  Shader(ir, main, layout, memory_resources(ir, main))
end
Shader(mi::MethodInstance, interface::ShaderInterface, interp::SPIRVInterpreter, layout::VulkanLayout = VulkanLayout()) = Shader(SPIRVTarget(mi, interp), interface, layout)

function Base.show(io::IO, mime::MIME"text/plain", shader::Shader)
  n = sum(fdef -> sum(length, fdef), shader.ir)
  ep = shader.ir.entry_points[shader.entry_point]
  model = replace(sprintc(printstyled, ep.model; color = ENUM_COLOR), "ExecutionModel" => "")
  print(io, typeof(shader), " ($model, $n code instructions)")
  if n < 100
    code = sprintc(show, mime, shader.ir)
    sep = sprintc(printstyled, '│'; color = :cyan)
    code = join("  $sep  " .* split(code, '\n'), '\n')
    print(io, ":\n  $sep\n", code)
  end
end

function shader(ex::Expr, __module__, execution_model::ExecutionModel, options, features, cache; assemble = nothing, layout = nothing, interpreter = nothing)
  f, args = @match ex begin
    :($f($(args...))) => (f, args)
  end

  argtypes, storage_classes, variable_decorations = shader_decorations(ex, __module__)

  interface = :($ShaderInterface($execution_model;
    storage_classes = $(copy(storage_classes)),
    variable_decorations = $(deepcopy(variable_decorations)),
    features = $features,
  ))
  !isnothing(options) && push!(interface.args[2].args, :(execution_options = $options))
  call = Expr(:call, f, Expr.(:(::), argtypes)...)
  shader(call, interface, cache; assemble, layout, interpreter)
end

function shader_decorations(ex::Expr, __module__ = @__MODULE__)
  f, args = @match ex begin
    :($f($(args...))) => (f, args)
  end

  argtypes = []
  storage_classes = StorageClass[]
  variable_decorations = Dictionary{Int,Decorations}()
  input_location = -1
  output_location = -1
  i = firstindex(args)
  for arg in args
    @switch arg begin
      @case :(::$T::$C)
      sc, decs = @match C begin
        Expr(:curly, sc, decs...) => (get_storage_class(sc), collect(decs))
        C => (get_storage_class(C), [])
      end
      has_decorations = !isempty(decs)
      isnothing(sc) && throw(ArgumentError("Unknown storage class provided in $(repr(arg))"))
      push!(storage_classes, sc)
      if sc in (StorageClassInput, StorageClassOutput) && has_decorations
        # Look if there are any decorations which declare the argument as a built-in variable.
        # We assume that there must be only one such declaration at maximum.
        for (j, dec) in enumerate(decs)
          isa(dec, Symbol) || continue
          builtin = get_builtin(dec)
          isnothing(builtin) && throw(ArgumentError("Unknown built-in decoration $dec in $(repr(arg))"))
          get!(Decorations, variable_decorations, i).decorate!(DecorationBuiltIn, builtin)
          deleteat!(decs, j)
          other_builtins = filter(!isnothing ∘ get_builtin, decs)
          !isempty(other_builtins) && throw(ArgumentError("More than one built-in decoration provided: $(join([builtin; other_builtins], ", "))"))
        end
      end
      for dec in decs
        (name, args) = @match dec begin
          Expr(:macrocall, name, source, args...) => (Symbol(string(name)[2:end]), collect(args))
          _ => error("Expected macrocall (e.g. `@DescriptorSet(1)`), got $dec")
        end
        concrete_dec = get_decoration(name)
        isnothing(concrete_dec) && throw(ArgumentError("Unknown decoration $name in $(repr(arg))"))
        for (k, arg) in enumerate(args)
          Meta.isexpr(arg, :$, 1) && (args[k] = Base.eval(__module__, arg.args[1]))
        end
        get!(Decorations, variable_decorations, i).decorate!(concrete_dec, args...)
      end
      if sc in (StorageClassInput, StorageClassOutput) && (!has_decorations || begin
            list = variable_decorations[i]
            !has_decoration(list, DecorationBuiltIn) && !has_decoration(variable_decorations[i], DecorationLocation)
        end)
        location = sc == StorageClassInput ? (input_location += 1) : (output_location += 1)
        get!(Decorations, variable_decorations, i).decorate!(DecorationLocation, UInt32(location))
      end
      push!(argtypes, T)
      i += 1
      @case :(::Type{$_})
      # Pass `Type` arguments through (they will be not be provided as actual arguments but are fine for compile-time computations).
      push!(argtypes, arg.args[1])
      @case _
      error("Expected argument type to be in the form `::<Type>::<Class>` for argument number $i (got $(repr(arg)))")
    end
  end

  argtypes, storage_classes, variable_decorations
end

function get_enum_if_defined(dec, ::Type{T}) where {T}
  isa(dec, Symbol) || return nothing
  prop = Symbol(nameof(T), dec)
  isdefined(SPIRV, prop) || return nothing
  value = getproperty(SPIRV, prop)
  isa(value, T) || return nothing
  value::T
end

get_builtin(dec) = get_enum_if_defined(dec, BuiltIn)
get_storage_class(dec) = get_enum_if_defined(dec, StorageClass)
get_decoration(dec) = get_enum_if_defined(dec, Decoration)

const HAS_WARNED_ABOUT_CACHE = Ref(false)

function shader(ex::Expr, interface, cache = nothing; assemble = nothing, layout = nothing, interpreter = nothing)
  args = get_signature(ex)
  _cache, _interpreter, _layout, _assemble, _info = gensym.((:cache, :interpreter, :layout, :assemble, :info))
  quote
    $_cache = $cache
    $_layout = @something($layout, $VulkanLayout())::$LayoutStrategy
    $_interpreter = @something($interpreter, $SPIRVInterpreter())::$SPIRVInterpreter
    isa($_cache, Union{Nothing, $ShaderCompilationCache}) || throw(ArgumentError(string("`Union{Nothing, ", $ShaderCompilationCache, "}` expected as cache argument, got a value of type `", typeof($_cache), '`')))
    $_assemble = something($assemble, false)::Bool
    if !$_assemble && !isnothing($_cache) && !$HAS_WARNED_ABOUT_CACHE[]
      $HAS_WARNED_ABOUT_CACHE[] = true
      @warn "A cache was provided, but the `assemble` option has not been set to `true`; the shader will not be cached."
    end
    $_info = $ShaderInfo($(args...), $interface; interp = $_interpreter, layout = $_layout)
    $_assemble ? $ShaderSource($_cache, $_info) : $Shader($_info)
  end
end
