is_function_macro(x) = Meta.isexpr(x, :macrocall) && x.args[1] == Symbol("@function")

struct Bindings
  dict::Dictionary{Symbol,SSAValue}
end

function Base.getindex(bindings::Bindings, x::Symbol)
  (; dict) = bindings
  val = get(dict, x, nothing)
  !isnothing(val) && return val
  throw(UndefVarError(x))
end

Bindings() = Bindings(Dictionary())

@forward Bindings.dict (Base.insert!, Base.setindex!, Dictionaries.set!, Base.pairs)

Base.merge(x::Bindings, y::Bindings) = Bindings(merge(x.dict, y.dict))

"""
Generate SPIR-V [`IR`](@ref) based on a DSL made for manually building modules.

This is largely intended for testing, and is not the main target of this library.

`ex` must be a block expression which first lists global definitions and then lists function definitions.

Functions are defined with expressions of the form

```julia
@function f(x::T, y::T, ...)::RT begin
  ... # statements
end
```

where arguments must be typed, as well as the function return type. With this information, a proper `OpFunctionType` type declaration and `OpFunction` instructions will be inserted, along with `OpFunctionParameter`s and `OpFunctionEnd`. The types, just like for any other instruction, are either SSA values or bindings to global variables.

Except for function definitions, all statements are parsed the same way as with [`@inst`](@ref), with the additional feature that symbols are allowed instead of raw SSA values. These symbols will be referred to as bindings.

SSA values will be computed for each defined binding (that is, a binding on a LHS of an expression), which will be substituted by the computed ID. Every binding must be unique, except in function scope where shadowing of global bindings is allowed. One reason for this simple design is that in presence of arbitrary CFG structures, including very messy ones, more elaborate scoping rules would be very hard to come up with. The same is true for re-assignments, which typically need to insert `OpPhi` nodes after analysis of the CFG; since the goal is to provide code that is in close correspondence with the generated SPIR-V code, we prefer to avoid such nontrivial and opaque modifications.
"""
function generate_ir(ex::Expr)
  ex = deepcopy(ex)
  statements = @match ex begin
    Expr(:block, args...) => collect(args)
    _ => error("Expected block expression")
  end
  c = ArrayCursor(statements)

  p = position(c)
  skip_until(is_function_macro ∘ peek, c)
  globals = p:(position(c) - 1)
  functions = position(c):lastindex(statements)

  global_bindings = Set{Symbol}()

  # Extract global bindings.
  for st in statements[globals]
    @tryswitch st begin
      @case :($(x::Symbol) = $inst)
      !in(x, global_bindings) || throw(ArgumentError("Invalid redefinition of binding '$x'"))
      push!(global_bindings, x)
    end
  end

  local_bindings = Dictionary{Symbol,Set{Symbol}}()

  # Extract function bindings and local bindings.
  for f_st in statements[functions]
    isline(f_st) && continue
    @switch f_st begin
      @case :(@function $_ $(f::Symbol)($(args...))::$_ $block)
      !in(f, global_bindings) || throw(ArgumentError("Invalid redefinition of function '$f'"))
      push!(global_bindings, f)
      insert!(local_bindings, f, Set{Symbol}())
      Meta.isexpr(block, :block) || throw(ArgumentError("Expected block expression as function body."))
      for arg in args
        @switch arg begin
          @case :($x::$T)
          !in(x, local_bindings[f]) || throw(ArgumentError("Non-unique argument name detected for '$x'"))
          push!(local_bindings[f], x)
          @case _
          throw(ArgumentError("Expected typed argument declaration of the form 'x::T', got $arg"))
        end
      end
      for st in block.args
        isline(st) && continue
        @tryswitch st begin
          @case :($(x::Symbol) = $inst)
          !in(x, local_bindings[f]) || throw(ArgumentError("Invalid redefinition of local binding '$x'"))
          push!(local_bindings[f], x)
        end
      end
      @case _
      throw(ArgumentError("Expected function definition of the form `@function f(args...) begin ... end`"))
    end
  end

  # Assign SSA values for each binding.
  counter = SSACounter()
  global_ids = Bindings()
  local_ids = Dictionary{Symbol,Bindings}()
  for binding in global_bindings
    insert!(global_ids, binding, next!(counter))
  end
  for (f, bindings) in pairs(local_bindings)
    insert!(local_ids, f, Bindings())
    for binding in bindings
      insert!(local_ids[f], binding, next!(counter))
    end
  end

  # Replace all bindings with their SSA value.
  for (i, st) in enumerate(statements[globals])
    isline(st) && continue
    @tryswitch st begin
      @case :($(x::Symbol) = $f($(args...))::$T)
      new_args = map(x -> isa(x, Symbol) ? global_ids[x] : x, args)
      statements[i] = :($(global_ids[x]) = $f($(new_args...))::$(global_ids[T]))

      @case :($(x::Symbol) = $f($(args...)))
      new_args = map(x -> isa(x, Symbol) ? global_ids[x] : x, args)
      statements[i] = :($(global_ids[x]) = $f($(new_args...)))

      @case :($f($(args...))::$T)
      new_args = map(x -> isa(x, Symbol) ? global_ids[x] : x, args)
      statements[i] = :($f($(new_args...))::$(global_ids[T]))

      @case :($f($(args...)))
      new_args = map(x -> isa(x, Symbol) ? global_ids[x] : x, args)
      statements[i] = :($f($(new_args...)))
    end
  end
  for (i, f_st) in enumerate(statements[functions])
    isline(f_st) && continue
    @switch f_st begin
      @case :(@function $_ $(f::Symbol)($(args...))::$T $block)
      scoped_ids = merge(global_ids, local_ids[f])
      new_args = map(args) do arg
        @match arg begin
          :($x::$T) => Expr(:(::), scoped_ids[x], global_ids[T])
        end
      end
      f_st.args[3] = :($(global_ids[f])($(new_args...))::$(global_ids[T]))
      for (j, st) in enumerate(block.args)
        isline(st) && continue
        @tryswitch st begin
          @case :($(x::Symbol) = $f($(args...))::$T)
          new_args = map(x -> isa(x, Symbol) ? scoped_ids[x] : x, args)
          block.args[j] = :($(scoped_ids[x]) = $f($(new_args...))::$(global_ids[T]))

          @case :($(x::Symbol) = $f($(args...)))
          new_args = map(x -> isa(x, Symbol) ? scoped_ids[x] : x, args)
          block.args[j] = :($(scoped_ids[x]) = $f($(new_args...)))

          @case :($f($(args...))::$T)
          new_args = map(x -> isa(x, Symbol) ? scoped_ids[x] : x, args)
          block.args[j] = :($f($(new_args...))::$(global_ids[T]))

          @case :($f($(args...)))
          new_args = map(x -> isa(x, Symbol) ? scoped_ids[x] : x, args)
          block.args[j] = :($f($(new_args...)))
        end
      end
    end
  end

  ftypes = Dictionary{Expr, SSAValue}()
  # Gather `OpTypeFunction` statements.
  for (i, f_st) in enumerate(statements[functions])
    isline(f_st) && continue
    @switch f_st begin
      @case :(@function $_ $(f::SSAValue)($(args...))::$T $_)
      argtypes = [arg.args[2]::SSAValue for arg in args]
      rhs = :(TypeFunction($T, $(argtypes...)))
      id = next!(counter)
      insert!(ftypes, rhs, id)
    end
  end
  t_sts = Expr[:($id = $rhs) for (rhs, id) in pairs(ftypes)]
  nft = length(t_sts)

  # Insert `OpTypeFunction` statements, updating ranges for globals and functions.
  statements = [statements[globals]; t_sts; statements[functions]]
  globals = first(globals):(last(globals) + nft)
  functions = (first(functions) + nft):lastindex(statements)

  finsts = Union{LineNumberNode,Expr}[]
  # Flatten function definitions into a series of unparsed instructions.
  for (i, f_st) in enumerate(statements[functions])
    if isline(f_st)
      push!(finsts, f_st)
      continue
    end
    @switch f_st begin
      @case :(@function $_ $(f::SSAValue)($(args...))::$T $block)
      argids = SSAValue[]
      argtypes = SSAValue[]
      for arg in args
        @switch arg begin
          @case :($(x::SSAValue)::$(AT::SSAValue))
          push!(argids, x)
          push!(argtypes, AT)
        end
      end
      rhs = :(TypeFunction($T, $(argtypes...)))
      ft_id = ftypes[rhs]
      push!(finsts, :($f = Function(FunctionControlNone, $ft_id)::$T))
      append!(finsts, :($id = FunctionParameter()::$T) for (id, T) in zip(argids, argtypes))
      for st in block.args
        push!(finsts, st)
      end
      push!(finsts, :(FunctionEnd()))
    end
  end

  debug_names = Expr[]
  for d in (global_ids, values(local_ids)...)
    for (name, id) in pairs(d)
      push!(debug_names, :(Name($id, $(string(name)))))
    end
  end
  insts = Expr(:block, debug_names..., statements[globals]..., finsts...)
  quote
    mod_insts = @block $insts
    mod = Module(ModuleMetadata(), mod_insts)
    # Renumbering is necessary to make sure IDs are recomputed properly according to control-flow.
    mod = renumber_ssa(mod)
    IR(mod)
  end
end

macro spv_ir(ex)
  generate_ir(ex)
end

function generate_module(ex)
  quote
    ir = $(generate_ir(ex))
    Module(ir)
  end
end

macro spv_module(ex)
  generate_module(ex)
end
