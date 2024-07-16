struct MemoryResource
  address::ResultID
  type::ResultID
end

@struct_hash_equal struct Shader
  ir::IR
  entry_point::ResultID
  info::ShaderInfo
  specializations::Dictionary{Symbol, Vector{ResultID}}
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

function Shader(info::ShaderInfo)
  target = SPIRVTarget(info.mi, info.interp)
  specializations = Dictionary{Symbol, Vector{ResultID}}()
  ir = IR(target, info.interface, specializations)
  merge_layout!(info.layout, ir)
  main = entry_point(ir, :main).func
  satisfy_requirements!(ir, info.interface.features)

  add_type_layouts!(ir, info.layout)
  add_align_operands!(ir, ir.fdefs[main], info.layout)

  Shader(ir, main, info, specializations)
end

function Base.show(io::IO, mime::MIME"text/plain", shader::Shader)
  n = sum(fdef -> sum(length, fdef), shader.ir)
  ep = shader.ir.entry_points[shader.entry_point]
  model = replace(sprintc(printstyled, ep.model; color = ENUM_COLOR), "ExecutionModel" => "")
  print(io, typeof(shader), " ($model, $n function instructions)")
  if n < 100
    code = sprintc(show, mime, shader.ir)
    sep = sprintc(printstyled, '│'; color = :cyan)
    code = join("  $sep  " .* split(code, '\n'), '\n')
    print(io, ":\n  $sep\n", code)
  end
end

function ShaderSource(shader::Shader; validate::Bool = true)
  if validate
    ret = @__MODULE__().validate(shader)
    if iserror(ret)
      show_debug_spirv_code(stdout, shader.ir)
      err = unwrap_error(ret)
      throw(err)
    end
  end
  ShaderSource(reinterpret(UInt8, assemble(shader)), shader.info, shader.specializations)
end

"""
    compile_shader_ex(ex, __module__, execution_mode; options = nothing, features = nothing, cache = nothing, assemble = nothing, layout = nothing, interpreter = nothing)

Extract shader interface information from `ex` and other arguments, then return a call to [`compile_shader`](@ref).

This function is intended for macro creation, exposing the underlying expression generation.

`__module__` is used to evaluate expressions interpolated with `\$`.

For the documentation of the remaining arguments, see [`compile_shader`](@ref).

$DOCSTRING_SYNTAX_REFERENCE
"""
function compile_shader_ex(ex::Expr, __module__, execution_model::ExecutionModel; options = nothing, features = nothing, cache = nothing, assemble = nothing, layout = nothing, interpreter = nothing)
  f, args = @match ex begin
    :($f($(args...))) => (f, args)
  end

  argtypes, storage_classes, variable_decorations = shader_decorations(ex, __module__)

  interface = :($ShaderInterface($execution_model;
    storage_classes = $(copy(storage_classes)),
    variable_decorations = $(deepcopy(variable_decorations)),
    features = something($features, $AllSupported()),
  ))
  !isnothing(options) && push!(interface.args[2].args, :(execution_options = $options))
  compile_shader_ex(f, :($Tuple{$(argtypes...)}), interface; cache, assemble, layout, interpreter)
end

function tryeval(__module__, ex)
  try
    Base.eval(__module__, ex)
  catch
    @error "An error occurred while evaluating the following user-provided expression in module `$(nameof(__module__))`:\n\n    $ex"
    rethrow()
  end
end

"""
    shader_decorations(ex, __module__ = @__MODULE__)

Extract built-in and decoration annotations from an `Expr` following the pattern

$DOCSTRING_SIGNATURE_PATTERN

`Location` decorations will be automatically generated for `Input` and `Output`s, and must not be user-provided.
"""
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
    is_user_defined_specialization_constant = true
    @switch arg begin
      @case :(::$T::$C)
      if C == :(Input{WorkgroupSize})
        C = :(Constant{local_size = $(one(Vec3U))})
        is_user_defined_specialization_constant = false
      end
      name, decs = @match C begin
        Expr(:curly, sc, decs...) => (sc, collect(decs))
        C => (C, [])
      end
      sc = get_storage_class(name, decs)
      has_decorations = !isempty(decs)
      isnothing(sc) && throw(ArgumentError("Unknown storage class provided in $(repr(arg))"))
      push!(storage_classes, sc)
      if in(sc, (StorageClassInput, StorageClassOutput)) && has_decorations
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
      if represents_constant(sc)
        length(decs) == 1 || throw(ArgumentError("In `Constant`, expected a single parameter, got $(length(decs)) parameters"))
        dec = decs[1]
        if sc === StorageClassSpecConstantINTERNAL
          @match dec begin
            :($lhs = $rhs) => begin
              value = Base.eval(__module__, rhs)
              isa(lhs, Symbol) || throw(ArgumentError("Expected `Symbol` as specialization constant name in `$ex`, got `$name`"))
              is_user_defined_specialization_constant && is_builtin_specialization_constant(lhs) && throw(ArgumentError("Specialization constant `$lhs` is a reserved built-in; use another name."))
              get!(Decorations, variable_decorations, i).decorate!(DecorationInternal, lhs => value)
            end
            _ => throw(ArgumentError("`name = value` expression expected as specialization constant parameter, got `$dec`"))
          end
        elseif sc === StorageClassConstantINTERNAL
          value = tryeval(__module__, dec)
          get!(Decorations, variable_decorations, i).decorate!(DecorationInternal, value)
        end
      else
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

represents_constant(sc::StorageClass) = in(sc, (StorageClassConstantINTERNAL, StorageClassSpecConstantINTERNAL))

get_builtin(dec) = get_enum_if_defined(dec, BuiltIn)
function get_storage_class(name, decs)
  name !== :Constant && return get_enum_if_defined(name, StorageClass)
  Meta.isexpr(decs[1], :(=), 2) && return StorageClassSpecConstantINTERNAL
  StorageClassConstantINTERNAL
end
get_decoration(dec) = get_enum_if_defined(dec, Decoration)

const HAS_WARNED_ABOUT_CACHE = Threads.Atomic{Bool}(false)

"""
    compile_shader(f, args, interface; cache = nothing, assemble = nothing, layout = nothing, interpreter = nothing)

Compile a shader corresponding to the signature `f(args...)` with the specified [`ShaderInterface`](@ref).

A cache may be provided as a [`ShaderCompilationCache`](@ref), caching the resulting [`ShaderSource`](@ref) if `assemble` is set to `true`. By default, no caching is performed.

A custom layout and interpreter may be provided. If using a custom interpreter and providing a cache at the same time, make sure that cache entries were created with the same interpreter.
"""
function compile_shader(f, args, interface::ShaderInterface; cache::Optional{ShaderCompilationCache} = nothing, assemble::Optional{Bool} = nothing, layout::Optional{VulkanLayout} = nothing, interpreter::Optional{SPIRVInterpreter} = nothing)
  layout = @something(layout, VulkanLayout())
  interpreter = @something(interpreter, SPIRVInterpreter())
  assemble = something(assemble, false)
  if !assemble && !isnothing(cache) && !HAS_WARNED_ABOUT_CACHE[]
    HAS_WARNED_ABOUT_CACHE[] = true
    @warn "A cache was provided, but the `assemble` option has not been set to `true`; the shader will not be cached."
  end
  info = ShaderInfo(f, args, interface; interp = interpreter, layout)
  !assemble && return Shader(info)
  ShaderSource(cache, info)
end

function compile_shader_ex(f, args, interface; cache = nothing, assemble = nothing, layout = nothing, interpreter = nothing)
  :($compile_shader($f, $args, $interface; cache = $cache, assemble = $assemble, layout = $layout, interpreter = $interpreter))
end
