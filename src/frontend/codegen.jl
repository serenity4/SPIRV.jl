function emit!(ir::IR, irmap::IRMapping, ex::Expr, jtype::Type)
  check_isvalid(jtype)
  type = SPIRType(jtype)
  extinst = nothing
  (opcode, args) = @match ex begin
    :($f($(args...))) => begin
        @match f begin
          ::GlobalRef => begin
              func = getfield(f.mod, f.name)
              isa(func, Core.IntrinsicFunction) && error("Reached unexpected core intrinsic function '$func'.")
              isa(func, Function) && error("Dynamic dispatch detected for function $func. All call sites must be resolved at compile time.")
            end
          _ => error("Call to unknown function $f")
        end
      end
    Expr(:invoke, mi, f, args...) => begin
        @assert isa(f, GlobalRef)
        @match (f.mod, f.name) begin
          (&SPIRV, :FMul) => (OpFMul, args)
          (&SPIRV, :FAdd) => (OpFAdd, args)
          _ => begin
            cfg = infer(CFG(mi))
            fid = emit!(ir, cfg)
            args = (fid, args...)
            (OpFunctionCall, args)
          end
        end
      end
    _ => error("Expected call or invoke expression, got $(repr(ex))")
  end

  !isempty(args) && isa(first(args), DataType) && (args = args[2:end])
  @tryswitch opcode begin
    @case &OpExtInst
      extinst_import_id = @match extinst begin
          ::OpCodeGLSL => emit_extinst!(ir, "GLSL.std.450")
          _ => error("Unrecognized extended instruction set for instruction $extinst")
        end
      args = (extinst_import_id, args...)
  end

  args = map(args) do arg
    isa(arg, Core.Argument) && return irmap.args[arg]
    isa(arg, Core.SSAValue) && return irmap.ssavals[arg]
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
    else
      error("Found unknown type $jtype.")
    end
  end
end
