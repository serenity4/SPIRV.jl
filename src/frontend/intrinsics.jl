function emit!(ir::IR, irmap::IRMapping, ex::Expr, jtype::Type)
  type = SPIRType(jtype)
  inst = @match ex begin
    :(Base.fptrunc(Base.Float32, $arg)) => @inst id = OpFConvert(arg)::type
    :(Base.fptrunc(Base.Float16, $arg)) => @inst id = OpQuantizeToF16(arg)::type
    :(Core.bitcast(Float16, $arg)) => @inst id = OpBitcast(arg)::type
    :($f($(args...))) => begin
      @switch f begin
        @case ::GlobalRef && if f.mod == Base end
          f.name in (:mul_float, :mul_add, :add_float) && (f = :($Core.Intrinsics.$(f.name)))
        @case _
          nothing
      end
      opcode = @match f begin
        :($Core.Intrinsics.$_f) => begin
          @match _f begin
            :fptoui => OpConvertFToU
            :fptosi => OpConvertFToS
            :sitofp => OpConvertSToF
            :uitofp => OpConvertUToF
            :trunc_int => OpUConvert
            :sext_int => OpSConvert
            :neg_int => OpSNegate
            :add_int => OpIAdd
            :neg_float => OpFNegate
            :add_float => OpFAdd
            :sub_int => OpISub
            :sub_float => OpFSub
            :mul_int => OpIMul
            :mul_float => OpFMul
            :udiv_int => OpUDiv
            :sdiv_int => OpSDiv
            :div_float => OpFDiv
            :urem_int => OpUMod
            :srem_int => OpSRem
            # missing: OpSMod
            :rem_float => OpFRem
            # missing: from OpFMod to OpSMulExtended
            :lshr_int => OpShiftRightLogical
            :ashr_int => OpShiftRightArithmetic
            :shl_int => OpShiftLeftLogical
            :or_int => OpBitwiseOr
            :xor_int => OpBitwiseXor
            :and_int => OpBitwiseAnd
            :not_int => OpNot
            # missing: from OpBitFieldInsert to OpBitReverse
            :ctpop_int => OpBitCount
            # missing: from OpAny to OpSelect
            :eq_int => OpIEqual
            :ne_int => OpINotEqual
            # Julia uses '<' for '>' operations
            # missing: OpUGreaterThan
            # missing: OpSGreaterThan
            # missing: OpUGreaterThanEqual
            # missing: OpSGreaterThanEqual
            :ult_int => OpULessThan
            :slt_int => OpSLessThan
            :ule_int => OpULessThanEqual
            :sle_int => OpSLessThanEqual
            # Julia does not emit special instructions
            # for ordered/unordered comparisons
            :eq_float => OpFOrdEqual
            :ne_float => OpFOrdNotEqual
            :lt_float => OpFOrdLessThan
            # missing: OpFOrdGreaterThan
            :le_float => OpFOrdLessThanEqual
            # missing: OpFOrdGreaterThanEqual
            _ => error("Unmapped core intrinsic $_f")
          end
        end
        _ => error("Unknown function $f")
      end
      type_id = emit!(ir, irmap, type)
      @switch opcode begin
        @case &OpFConvert
          args = (args[2],)
        @case _
          nothing
      end
      args = map(args) do arg
        isa(arg, Core.Argument) && return irmap.args[arg]
        isa(arg, Core.SSAValue) && return irmap.ssavals[arg]
        (isa(arg, AbstractFloat) || isa(arg, Integer)) && return emit!(ir, irmap, Constant(arg))
        arg
      end
      @inst next!(ir.ssacounter) = opcode(args...)::type_id
    end
    _ => error("Expected call, got $ex")
  end
end
