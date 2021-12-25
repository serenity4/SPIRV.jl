@MethodTable INTRINSICS_METHOD_TABLE

"""
Declare a new method as part of the intrinsics method table.

This new method declaration should override a method from `Base`,
typically one that would call core intrinsics. Its body typically
consists of one or more calls to declared intrinsic functions (see [`@intrinsic`](@ref)).

The method will always be inlined.
"""
macro override(ex)

  esc(:(@overlay SPIRV.INTRINSICS_METHOD_TABLE @inline $ex))
end

strip_typedecl(arg) = @match arg begin
  ::Symbol => arg
  :($arg::$type) => arg
  _ => error("Cannot extract argument name from $arg")
end

function intrinsic_impl(ex)
  @match ex begin
    :($f($(args...))::$T where $typedecl) => begin
        f = esc(f); sigargs = esc.(args); args = esc.(strip_typedecl.(args)); T = esc(T); typedecl = esc(typedecl)
        :($f($(sigargs...)) where $typedecl = $(esc(:placeholder))($(args...))::$T)
      end
    :($f($(args...))::$T) => begin
        f = esc(f); sigargs = esc.(args); args = esc.(strip_typedecl.(args)); T = esc(T)
        :($f($(sigargs...)) = $(esc(:placeholder))($(args...))::$T)
      end
    _ => error("Expected type asserted function call, got $(repr(ex))")
  end
end

"""
Declare a new intrinsic.

`ex` must be a type asserted function call, which will define a new method whose
return type is hinted to be that of the asserted type. The implementation itself
is opaque, similar to core intrinsic functions.
"""
macro intrinsic(ex)
  intrinsic_impl(ex)
end

using Base: IEEEFloat,
            BitSigned, BitSigned_types,
            BitUnsigned, BitUnsigned_types,
            BitInteger, BitInteger_types

const IEEEFloat_types = (Float16, Float32, Float64)

# Definition of intrinsics and redirection (overrides) of Base methods to use these intrinsics.
# Intrinsic definitions need not be applicable only to supported types. Any signature
# incompatible with SPIR-V semantics should not be redirected to any of these intrinsics.

@override (-)(x::IEEEFloat) = FNegate(x)
@intrinsic FNegate(x::T)::T where {T<:IEEEFloat}

@override (+)(x::T, y::T) where {T<:IEEEFloat} = FAdd(x, y)
@intrinsic FAdd(x::T, y::T)::T where {T<:IEEEFloat}
@override (*)(x::T, y::T) where {T<:IEEEFloat} = FMul(x, y)
@intrinsic FMul(x::T, y::T)::T where {T<:IEEEFloat}
@override (-)(x::T, y::T) where {T<:IEEEFloat} = FSub(x, y)
@intrinsic FSub(x::T, y::T)::T where {T<:IEEEFloat}
@override (/)(x::T, y::T) where {T<:IEEEFloat} = FDiv(x, y)
@intrinsic FDiv(x::T, y::T)::T where {T<:IEEEFloat}
@override muladd(x::T, y::T, z::T) where {T<:IEEEFloat} = FAdd(x, FMul(y, z))

for to in IEEEFloat_types, from in IEEEFloat_types
  if to.size ≠ from.size
    @eval @override $to(x::$from) = FConvert(to, x)
  end
end
@intrinsic FConvert(to::Type{T}, x::IEEEFloat)::T where {T<:IEEEFloat}

#TODO: add override
@intrinsic QuantizeToF16(x::Float32)::Float32

@override unsafe_trunc(::Type{T}, x::IEEEFloat) where {T<:BitSigned} = ConvertFtoS(T, x)
@intrinsic ConvertFtoS(to::Type{T}, x::IEEEFloat)::T where {T<:BitSigned}

@override unsafe_trunc(::Type{T}, x::IEEEFloat) where {T<:BitUnsigned} = ConvertFtoU(T, x)
@intrinsic ConvertFtoU(to::Type{T}, x::IEEEFloat)::T where {T<:BitUnsigned}

for T in IEEEFloat_types
  @eval @override $T(x::BitSigned) = ConvertSToF($T, x)
  @eval @override $T(x::BitUnsigned) = ConvertUToF($T, x)
end
@intrinsic ConvertStoF(to::Type{T}, x::BitSigned)::T where {T<:IEEEFloat}
@intrinsic ConvertUtoF(to::Type{T}, x::BitUnsigned)::T where {T<:IEEEFloat}


# Integers.

## Integer conversions.

for to in BitInteger_types, from in BitInteger_types
  if to.size ≠ from.size
    if from <: Signed
      @eval @override rem(x::$from, ::Type{$to}) = SConvert(to, from)
    elseif to <: Unsigned
      @eval @override rem(x::$from, ::Type{$to}) = UConvert(to, from)
    end
  end
end
@intrinsic SConvert(to::Type{T}, x::BitSigned)::T where {T<:BitInteger}
@intrinsic UConvert(to::Type{T}, x::BitUnsigned)::T where {T<:BitUnsigned}

## Integer comparisons.

@override (<)(x::T, y::T) where {T<:BitSigned} = SLessThan(x, y)
@override (<=)(x::T, y::T) where {T<:BitSigned} = SLessThanEqual(x, y)
@override (<)(x::T, y::T) where {T<:BitUnsigned} = ULessThan(x, y)
@override (<=)(x::T, y::T) where {T<:BitUnsigned} = ULessThanEqual(x, y)

for intr in (:SLessThan, :SLessThanEqual, :ULessThan, :ULessThanEqual)
  @eval @intrinsic $intr(x::BitInteger, y::BitInteger)::Bool
end

## Logical operators.

@override (~)(x::BitInteger) = Not(x)
@intrinsic Not(x::T)::T where {T<:BitInteger}

@override (&)(x::T, y::T) where {T<:BitInteger} = BitwiseAnd(x, y)
@intrinsic BitwiseAnd(x::T, y::T)::T where {T<:BitInteger}

@override (|)(x::T, y::T) where {T<:BitInteger} = BitwiseOr(x, y)
@intrinsic BitwiseOr(x::T, y::T)::T where {T<:BitInteger}

@override xor(x::T, y::T) where {T<:BitInteger} = BitwiseXor(x, y)
@intrinsic BitwiseXor(x::T, y::T)::T where {T<:BitInteger}

## Integer shifts.

@override (>>)(x::BitSigned,   y::BitUnsigned) = ShiftRightArithmetic(x, y)
@intrinsic ShiftRightArithmetic(x::T, y::BitUnsigned)::T where {T<:BitSigned}

@override (>>)(x::BitUnsigned, y::BitUnsigned) = ShiftRightLogical(x, y)
@override (>>>)(x::BitInteger, y::BitUnsigned) = ShiftRightLogical(x, y)
@intrinsic ShiftRightLogical(x::T, y::BitUnsigned)::T where {T<:BitInteger}

@override (<<)(x::BitInteger,  y::BitUnsigned) = ShiftLeft(x, y)
@intrinsic ShiftLeft(x::T, y::BitUnsigned)::T where {T<:BitUnsigned}

@override (-)(x::BitInteger) = SNegate(x)
@intrinsic SNegate(x::T)::T where {T<:BitInteger}

@override (+)(x::T, y::T) where {T<:BitInteger} = IAdd(x, y)
@override (-)(x::T, y::T) where {T<:BitInteger} = ISub(x, y)
@override (*)(x::T, y::T) where {T<:BitInteger} = IMul(x, y)

for intr in (:IAdd, :ISub, :IMul)
  @eval @intrinsic $intr(x::T, y::T)::T where {T<:BitSigned}
  @eval @intrinsic $intr(x::T, y::T)::T where {T<:BitUnsigned}
  @eval @intrinsic $intr(x::BitUnsigned, y::I)::I where {I<:BitSigned}
  @eval @intrinsic $intr(x::I, y::BitUnsigned)::I where {I<:BitSigned}
end

@override div(x::T, y::T) where {T<:BitUnsigned} = UDiv(x, y)
@intrinsic UDiv(x::T, y::T)::T where {T<:BitUnsigned}

for TX in BitInteger_types, TY in BitInteger_types
  if TX.size == TY.size
    #TODO: check this override
    # @eval @override div(x::$TX, y::$TY) = SDiv(x, y)
  end
end

@override ifelse(cond::Bool, x, y) = Select(cond, x, y)
@intrinsic Select(cond::Bool, x::T, y::T)::T where {T}

@override flipsign(x::T, y::T) where {T<:BitSigned} = Select(y ≥ 0, x, -x)
@override flipsign(x::BitSigned, y::BitSigned) = flipsign(promote(x, y)...) % typeof(x)

#=

Indicative mapping of core intrinsics.

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

:(Base.fptrunc($T, $arg)) => OpFConvert
:(Base.fptrunc(Float16, $arg)) => OpQuantizeToF16
:(Core.bitcast($T, $arg)) => OpBitcast

=#
