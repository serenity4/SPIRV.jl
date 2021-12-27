function emit!(ir::IR, irmap::IRMapping, ex::Expr, jtype::Type)
  check_isvalid(jtype)
  type = SPIRType(jtype)
  extinst = nothing
  (opcode, args) = @match ex begin
    :($f($(args...))) => begin
        @match f begin
          ::GlobalRef => begin
              func = getfield(f.mod, f.name)
              isa(func, Core.IntrinsicFunction) && error("Reached illegal core intrinsic function '$func'.")
              isa(func, Function) && error("Dynamic dispatch detected for function $func. All call sites must be resolved at compile time.")
            end
          _ => error("Call to unknown function $f")
        end
      end
    Expr(:invoke, mi, f, args...) => begin
        @assert isa(f, GlobalRef)
        if f.mod == @__MODULE__
          opcode = @when let op::OpCode = try_getopcode(f.name)
              op
            @when op::OpCodeGLSL = try_getopcode(f.name, :GLSL)
              op
            end
          if !isnothing(opcode)
            !isempty(args) && isa(first(args), DataType) && (args = args[2:end])
            @switch opcode begin
              @case ::OpCode
                (opcode, args)
              @case ::OpCodeGLSL
                args = (emit_extinst!(ir, "GLSL.std.450"), opcode, args...)
                (OpExtInst, args)
            end
          else
            (OpFunctionCall, (emit_new!(ir, mi), args...))
          end
        else
          (OpFunctionCall, (emit_new!(ir, mi), args...))
        end
      end
    _ => error("Expected call or invoke expression, got $(repr(ex))")
  end

  args = map(args) do arg
    (isa(arg, Core.Argument) || isa(arg, Core.SSAValue)) && return SSAValue(arg, irmap)
    (isa(arg, AbstractFloat) || isa(arg, Integer)) && return emit!(ir, irmap, Constant(arg))
    arg
  end

  type_id = emit!(ir, irmap, type)
  @inst next!(ir.ssacounter) = opcode(args...)::type_id
end

function check_isvalid(jtype::Type)
  if !in(jtype, spirv_types)
    if isabstracttype(jtype)
      error("Found abstract type '$jtype' after type inference. All types must be concrete.")
    elseif !isconcretetype(jtype)
      error("Found non-concrete type '$jtype' after type inference. All types must be concrete.")
    end
  end
end

function try_getopcode(name, prefix = "")
  maybe_opname = Symbol(:Op, prefix, name)
  isdefined(@__MODULE__, maybe_opname) ? getproperty(@__MODULE__, maybe_opname) : nothing
end

emit_new!(ir::IR, mi::MethodInstance) = emit!(ir, CFG(mi; inferred = true))
