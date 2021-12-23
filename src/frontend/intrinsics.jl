const direct_translations = dictionary([
  :fptoui => OpConvertFToU,
  :fptosi => OpConvertFToS,
  :sitofp => OpConvertSToF,
  :uitofp => OpConvertUToF,
  :trunc_int => OpUConvert,
  :sext_int => OpSConvert,
  :neg_int => OpSNegate,
  :add_int => OpIAdd,
  :neg_float => OpFNegate,
  :add_float => OpFAdd,
  :sub_int => OpISub,
  :sub_float => OpFSub,
  :mul_int => OpIMul,
  :mul_float => OpFMul,
  :udiv_int => OpUDiv,
  :sdiv_int => OpSDiv,
  :div_float => OpFDiv,
  :urem_int => OpUMod,
  :srem_int => OpSRem,
  # missing: OpSMod
  :rem_float => OpFRem,
  # missing: from OpFMod to OpSMulExtended
  :lshr_int => OpShiftRightLogical,
  :ashr_int => OpShiftRightArithmetic,
  :shl_int => OpShiftLeftLogical,
  :or_int => OpBitwiseOr,
  :xor_int => OpBitwiseXor,
  :and_int => OpBitwiseAnd,
  :not_int => OpNot,
  # missing: from OpBitFieldInsert to OpBitReverse
  :ctpop_int => OpBitCount,
  # missing: from OpAny to OpSelect
  :eq_int => OpIEqual,
  :ne_int => OpINotEqual,
  # Julia uses '<' for '>' operations
  # missing: OpUGreaterThan
  # missing: OpSGreaterThan
  # missing: OpUGreaterThanEqual
  # missing: OpSGreaterThanEqual
  :ult_int => OpULessThan,
  :slt_int => OpSLessThan,
  :ule_int => OpULessThanEqual,
  :sle_int => OpSLessThanEqual,
  # Julia does not emit special instructions
  # for ordered/unordered comparisons
  :eq_float => OpFOrdEqual,
  :ne_float => OpFOrdNotEqual,
  :lt_float => OpFOrdLessThan,
  # missing: OpFOrdGreaterThan
  :le_float => OpFOrdLessThanEqual,
  # missing: OpFOrdGreaterThanEqual
])

function emit!(ir::IR, irmap::IRMapping, ex::Expr, jtype::Type)
  type = SPIRType(jtype)
  (opcode, args) = @match ex begin
    :($f($(args...))) => begin
      @match ex begin
        :(Base.fptrunc(Float32, $arg)) => (OpFConvert, [arg])
        :(Base.fptrunc(Float16, $arg)) => (OpQuantizeToF16, [arg])
        :(Core.bitcast(Float16, $arg)) => (OpBitcast, [arg])
        _ => begin
          @tryswitch f begin
            @case ::GlobalRef && if f.mod == Base end
              f.name in (:mul_float, :mul_add, :add_float, :rint_llvm, :fptosi, :muladd_float) && (f = :(Core.Intrinsics.$(f.name)))
          end
          opcode = nothing
          extinst = nothing
          @switch f begin
            @case :($Core.Intrinsics.$_f)
              opcode = @match _f begin
                if haskey(direct_translations, _f) end => direct_translations[_f]
                _ => begin
                  extinst = @switch _f begin
                    @case :rint_llvm
                      OpGLSLRound
                    @case _
                      error("Unmapped core instrinsic $_f")
                    end
                  OpExtInst
                end
              end
            @case _
              error("Unknown function $f")
          end

          @tryswitch opcode begin
            @case &OpFConvert
              args = (args[2],)
            @case &OpExtInst
              args = (emit_extinst!(ir, "GLSL.std.450"), args...)
          end
          (opcode, args)
        end
      end
    end
    Expr(:invoke, mi, f, args...) => begin
      cfg = infer!(CFG(mi))
      fid = emit!(ir, cfg)
      (OpFunctionCall, [fid; args])
    end
    _ => error("Expected call or invoke expression, got $ex")
  end

  type_id = emit!(ir, irmap, type)
  args = map(args) do arg
    isa(arg, Core.Argument) && return irmap.args[arg]
    isa(arg, Core.SSAValue) && return irmap.ssavals[arg]
    (isa(arg, AbstractFloat) || isa(arg, Integer)) && return emit!(ir, irmap, Constant(arg))
    arg
  end
  @inst next!(ir.ssacounter) = opcode(args...)::type_id
end
