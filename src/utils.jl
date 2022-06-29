macro forward(ex, fs)
  Meta.isexpr(ex, :., 2) || error("Invalid expression $ex, expected <Type>.<prop>")
  T, prop = ex.args[1], ex.args[2].value

  fs = Meta.isexpr(fs, :tuple) ? fs.args : [fs]

  defs = map(fs) do f
    esc(:($f(x::$T, args...; kwargs...) = $f(x.$prop, args...; kwargs...)))
  end

  Expr(:block, defs...)
end

macro inst(ex)
  inst_expr(ex)
end

function inst_expr(ex)
  Base.remove_linenums!(ex)
  result_id, inst = @match ex begin
    :($result_id = $inst) => (result_id, inst)
    _ => (nothing, ex)
  end
  Meta.isexpr(inst, :block) && (inst = only(inst.args))

  type_id, call = @match inst begin
    :($call::$T) => (T, call)
    _ => (nothing, inst)
  end

  opcode, args = @match call begin
    :($opcode($(args...))) => (opcode, args)
    _ => error("Invalid call $call")
  end

  if isa(opcode, Symbol) && isdefined(SPIRV, Symbol(:Op, opcode))
    maybe_op = getproperty(SPIRV, Symbol(:Op, opcode))
    maybe_op isa Union{OpCode, OpCodeGLSL} && (opcode = maybe_op)
  else
    opcode = esc(opcode)
  end

  res = :(Instruction($opcode, $(esc(type_id)), $(esc(result_id)), $(esc.(args)...)))

  # Substitute arguments of the form $1, $2, $n... to SSAValue(1), SSAValue(2), ...
  for (i, arg) in enumerate(res.args)
    Meta.isexpr(arg, :escape) || continue
    arg = arg.args[1]
    Meta.isexpr(arg, :$) && (res.args[i] = SSAValue(only(arg.args)))
  end
  res
end

macro block(ex)
  res = :(Instruction[])
  Meta.isexpr(ex, :block) || error("Expected a block expression `begin ... end`.")
  for subex in ex.args
    !isa(subex, LineNumberNode) && push!(res.args, inst_expr(subex))
  end
  res
end

isline(x) = false
isline(x::LineNumberNode) = true

function rmlines(ex)
  @match ex begin
    Expr(:macrocall, m, _...) => Expr(:macrocall, m, nothing, filter(x -> !isline(x), ex.args[3:end])...)
    ::Expr                    => Expr(ex.head, filter(!isline, ex.args)...)
    a                         => a
  end
end

macro refbroadcast(ex)
  T = @match ex begin
    :(struct $T
      $(fields...)
    end) => T
    :(mutable struct $T
      $(fields...)
    end) => T
    :(abstract type $T end) => T
  end

  T = @match T begin
    :($T <: $AT) => T
    _ => T
  end

  T = @match T begin
    ::Symbol => T
    :($T{$(_...)}) => T
  end

  quote
    Base.@__doc__ $(esc(ex))
    Base.broadcastable(x::$(esc(T))) = Ref(x)
  end
end

function source_version(language::SourceLanguage, version::Integer)
  @match language begin
    &SourceLanguageGLSL => begin
      major = version ÷ 100
      minor = (version - 100 * major) ÷ 10
      VersionNumber(major, minor)
    end
  end
end

function source_version(language::SourceLanguage, version::VersionNumber)::UInt32
  @match language begin
    &SourceLanguageGLSL => begin
      (; major, minor) = version
      10 * minor + 100 * major
    end
  end
end
