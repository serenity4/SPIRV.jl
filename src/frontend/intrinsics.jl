@MethodTable INTRINSICS_METHOD_TABLE

"""
Declare a new method as part of the intrinsics method table.

This new method declaration should override a method from `Base`,
typically one that would call core intrinsics. Its body typically
consists of one or more calls to declared intrinsic functions (see [`@intrinsic`](@ref)).

The method will always be inlined.
"""
macro override(ex)
  esc(:($SPIRV.@overlay $SPIRV.INTRINSICS_METHOD_TABLE @inline $ex))
end

using Base:
  IEEEFloat,
  BitSigned, BitSigned_types,
  BitUnsigned, BitUnsigned_types,
  BitInteger, BitInteger_types

const IEEEFloat_types = (Float16, Float32, Float64)

const SmallFloat = Union{Float16,Float32}

# Definition of intrinsics and redirection (overrides) of Base methods to use these intrinsics.
# Intrinsic definitions need not be applicable only to supported types. Any signature
# incompatible with SPIR-V semantics should not be redirected to any of these intrinsics.

@override reinterpret(::Type{T}, x) where {T} = Bitcast(T, x)
@override reinterpret(::Type{T}, x::T) where {T} = x
@noinline Bitcast(T, x) = Base.bitcast(T, x)

# Floats.

## Arithmetic operations.

@override (-)(x::IEEEFloat)                     = FNegate(x)
@noinline FNegate(x::T) where {T<:IEEEFloat}    = Base.neg_float(x)
@override (+)(x::T, y::T) where {T<:IEEEFloat}  = FAdd(x, y)
@noinline FAdd(x::T, y::T) where {T<:IEEEFloat} = Base.add_float(x, y)
@override (*)(x::T, y::T) where {T<:IEEEFloat}  = FMul(x, y)
@noinline FMul(x::T, y::T) where {T<:IEEEFloat} = Base.mul_float(x, y)
@override (-)(x::T, y::T) where {T<:IEEEFloat}  = FSub(x, y)
@noinline FSub(x::T, y::T) where {T<:IEEEFloat} = Base.sub_float(x, y)
@override (/)(x::T, y::T) where {T<:IEEEFloat}  = FDiv(x, y)
@noinline FDiv(x::T, y::T) where {T<:IEEEFloat} = Base.div_float(x, y)
@override rem(x::T, y::T) where {T<:IEEEFloat}  = FRem(x, y)
@noinline FRem(x::T, y::T) where {T<:IEEEFloat} = @static if VERSION < v"1.10.0-DEV.101"
  Base.rem_float(x, y)::T
else
  copysign(Base.rem_internal(abs(x), abs(y)), x)::T
end

@override mod(x::T, y::T) where {T<:IEEEFloat}  = FMod(x, y)
@noinline function FMod(x::T, y::T) where {T<:IEEEFloat}
  r = rem(x, y)
  if r == 0
    copysign(r, y)
  elseif (r > 0) ⊻ (y > 0)
    r + y
  else
    r
  end
end

@override muladd(x::T, y::T, z::T) where {T<:IEEEFloat} = FAdd(FMul(x, y), z)

## Comparisons.

@override (==)(x::T, y::T) where {T<:IEEEFloat}              = FOrdEqual(x, y)
@noinline FOrdEqual(x::T, y::T) where {T<:IEEEFloat}         = Base.eq_float(x, y)
@override (!=)(x::T, y::T) where {T<:IEEEFloat}              = FUnordNotEqual(x, y)
@noinline FUnordNotEqual(x::T, y::T) where {T<:IEEEFloat}    = Base.ne_float(x, y)
@override (<)(x::T, y::T) where {T<:IEEEFloat}               = FOrdLessThan(x, y)
@noinline FOrdLessThan(x::T, y::T) where {T<:IEEEFloat}      = Base.lt_float(x, y)
@override (<=)(x::T, y::T) where {T<:IEEEFloat}              = FOrdLessThanEqual(x, y)
@noinline FOrdLessThanEqual(x::T, y::T) where {T<:IEEEFloat} = Base.le_float(x, y)

@override function isequal(x::T, y::T) where {T<:IEEEFloat}
  IT = Base.inttype(T)
  xi = reinterpret(IT, x)
  yi = reinterpret(IT, y)
  FUnordEqual(x, x) & FUnordEqual(y, y) | IEqual(xi, yi)
end
@inline function FUnordEqual(x::T, y::T) where {T<:IEEEFloat}
  isnan(x) & isnan(y) | x == y
end
@override isnan(x::IEEEFloat)    = IsNan(x)
@noinline IsNan(x::IEEEFloat)    = invoke(isnan, Tuple{AbstractFloat}, x)
@override isinf(x::IEEEFloat) = IsInf(x)
@noinline IsInf(x::IEEEFloat)    = !invoke(isfinite, Tuple{AbstractFloat}, x)
@override isfinite(x::IEEEFloat) = !isinf(x)

have_fma(T) = false

## Conversions.

for to in IEEEFloat_types, from in IEEEFloat_types
  if sizeof(to) ≠ sizeof(from)
    @eval @override $to(x::$from) = FConvert($to, x)
    if sizeof(to) < sizeof(from)
      @eval @noinline (FConvert(::Type{$to}, x::$from) = Base.fptrunc($to, x))
    else
      @eval @noinline (FConvert(::Type{$to}, x::$from) = Base.fpext($to, x))
    end
  end
end


for Ti in (Int8, Int16, Int32, Int64)
  for Tf in (Float16, Float32, Float64)
    @eval @inline @override unsafe_trunc(::Type{$Ti}, x::$Tf) = ConvertFToS($Ti, x)
    @eval @inline @override trunc(::Type{$Ti}, x::$Tf) = ConvertFToS($Ti, x)
    @eval @inline @override $Ti(x::$Tf) = ConvertFToS($Ti, x)
  end
end
for Ti in (UInt8, UInt16, UInt32, UInt64)
  for Tf in (Float16, Float32, Float64)
    @eval @inline @override unsafe_trunc(::Type{$Ti}, x::$Tf) = ConvertFToU($Ti, x)
    @eval @inline @override trunc(::Type{$Ti}, x::$Tf) = ConvertFToU($Ti, x)
    @eval @inline @override $Ti(x::$Tf) = ConvertFToU($Ti, x)
  end
end
@noinline ConvertFToS(::Type{T}, x::IEEEFloat) where {T<:BitSigned} = Base.fptosi(T, x)
@noinline ConvertFToU(::Type{T}, x::IEEEFloat) where {T<:BitUnsigned} = Base.fptoui(T, x)

for t1 in (Float16, Float32, Float64)
  for st in (Int8, Int16, Int32, Int64)
    @eval @override (::Type{$t1})(x::$st) = ConvertSToF($t1, x)
  end
  for ut in (Bool, UInt8, UInt16, UInt32, UInt64)
    @eval @override (::Type{$t1})(x::$ut) = ConvertUToF($t1, x)
  end
end
@noinline ConvertSToF(to::Type{T}, x::BitSigned) where {T<:IEEEFloat} = Base.sitofp(to, x)
@noinline ConvertUToF(to::Type{T}, x::BitUnsigned) where {T<:IEEEFloat} = Base.uitofp(to, x)

### There is no possibility to throw errors in SPIR-V, so replace safe operations with unsafe ones.
@override trunc(::Type{T}, x::IEEEFloat) where {T<:BitInteger} = unsafe_trunc(T, x)
@override (::Type{T})(x::IEEEFloat) where {T<:BitInteger} = unsafe_trunc(T, x)
@override trunc(x::IEEEFloat) = round(x, RoundToZero)

# Integers.

## Integer conversions.

for to in BitInteger_types
  constructor = GlobalRef(Core, Symbol(:to, nameof(to))) # toUInt16, toInt64, etc.
  for from in BitInteger_types
    convert = to <: Signed ? :SConvert : :UConvert
    rem_f = sizeof(to) == sizeof(from) ? :reinterpret : convert
    if sizeof(to) ≠ sizeof(from)
      @eval @inline @override ($constructor(x::$from) = rem(x, $to))
      @eval @override (rem(x::$from, ::Type{$to}) = $convert($to, x))
      if sizeof(to) < sizeof(from)
        @eval @noinline ($convert(::Type{$to}, x::$from) = Base.trunc_int($to, x))
      else # sizeof(to) > sizeof(from)
        convert = to <: Signed ? :SConvert : :UConvert
        method = to <: Signed ? :sext_int : :zext_int
        @eval @noinline ($convert(::Type{$to}, x::$from) = Base.$method($to, x))
      end
    end
  end
end

@override rem(x::T, y::T) where {T<:BitSigned} = SRem(x, y)
@noinline SRem(x::T, y::T) where {T<:BitSigned} = Base.srem_int(x, y)
# SPIR-V does not have URem but it looks like SRem can work with unsigned ints.
@override rem(x::T, y::T) where {T<:BitUnsigned} = SRem(x, y)
@noinline SRem(x::T, y::T) where {T<:BitUnsigned} = Base.urem_int(x, y)

@override Int(x::Ptr) = reinterpret(Int, x)
@override UInt(x::Ptr) = reinterpret(UInt, x)

## Comparisons.

@override (<)(x::T, y::T) where {T<:BitSigned} = SLessThan(x, y)
@override (<=)(x::T, y::T) where {T<:BitSigned} = SLessThanEqual(x, y)
@override (<)(x::T, y::T) where {T<:BitUnsigned} = ULessThan(x, y)
@override (<=)(x::T, y::T) where {T<:BitUnsigned} = ULessThanEqual(x, y)

for (intr, core_intr) in zip((:SLessThan, :SLessThanEqual, :ULessThan, :ULessThanEqual), (:slt_int, :sle_int, :ult_int, :ule_int))
  @eval @noinline ($intr(x::BitInteger, y::BitInteger) = Base.$core_intr(x, y))
end

## Logical operators.

@override (==)(x::T, y::T) where {T<:BitInteger}       = IEqual(x, y)
@override (==)(x::BitInteger, y::BitInteger)           = ==(promote(x, y)...)
@override (==)(x::BitSigned, y::BitUnsigned)           = ==(promote(x, y)...)
@override (==)(x::BitUnsigned, y::BitSigned)           = ==(promote(x, y)...)
@noinline IEqual(x::T, y::T) where {T<:BitInteger}     = Base.eq_int(x, y)
@override (!=)(x::T, y::T) where {T<:BitInteger}       = INotEqual(x, y)
@override (!=)(x::BitInteger, y::BitInteger)           = !=(promote(x, y)...)
@noinline INotEqual(x::T, y::T) where {T<:BitInteger}  = Base.ne_int(x, y)
@override (~)(x::BitInteger)                           = Not(x)
@noinline Not(x::BitInteger)                           = Base.not_int(x)
@override (&)(x::T, y::T) where {T<:BitInteger}        = BitwiseAnd(x, y)
@noinline BitwiseAnd(x::T, y::T) where {T<:BitInteger} = Base.and_int(x, y)
@override (|)(x::T, y::T) where {T<:BitInteger}        = BitwiseOr(x, y)
@noinline BitwiseOr(x::T, y::T) where {T<:BitInteger}  = Base.or_int(x, y)
@override xor(x::T, y::T) where {T<:BitInteger}        = BitwiseXor(x, y)
@noinline BitwiseXor(x::T, y::T) where {T<:BitInteger} = Base.xor_int(x, y)

## Integer shifts.

@override (>>)(x::BitSigned, y::BitUnsigned) = ShiftRightArithmetic(x, y)
@noinline ShiftRightArithmetic(x::BitSigned, y::BitUnsigned) = Base.ashr_int(x, y)

@override (>>)(x::BitUnsigned, y::BitUnsigned) = ShiftRightLogical(x, y)
@override (>>>)(x::BitInteger, y::BitUnsigned) = ShiftRightLogical(x, y)
@noinline ShiftRightLogical(x::BitInteger, y::BitInteger) = Base.lshr_int(x, y)

@override (<<)(x::BitInteger, y::BitUnsigned) = ShiftLeftLogical(x, y)
@noinline ShiftLeftLogical(x::BitInteger, y::BitInteger) = Base.shl_int(x, y)

## Arithmetic operations.

@override (-)(x::BitInteger) = SNegate(x)
@noinline SNegate(x::T) where {T<:BitInteger} = Base.neg_int(x)

@override (+)(x::T, y::T) where {T<:BitInteger} = IAdd(x, y)
@override (-)(x::T, y::T) where {T<:BitInteger} = ISub(x, y)
@override (*)(x::T, y::T) where {T<:BitInteger} = IMul(x, y)

for (intr, core_intr) in zip((:IAdd, :ISub, :IMul), (:add_int, :sub_int, :mul_int))
  @eval @noinline ($intr(x::T, y::T) where {T<:BitSigned} = Base.$core_intr(x, y))
  @eval @noinline ($intr(x::T, y::T) where {T<:BitUnsigned} = Base.$core_intr(x, y))
  @eval @noinline ($intr(x::BitUnsigned, y::I) where {I<:BitSigned} = Base.$core_intr(x, y))
  @eval @noinline ($intr(x::I, y::BitUnsigned) where {I<:BitSigned} = Base.$core_intr(x, y))
end

@override div(x::T, y::T) where {T<:BitUnsigned} = UDiv(x, y)
@noinline UDiv(x::T, y::T) where {T<:BitUnsigned} = Base.udiv_int(x, y)
@noinline SDiv(x::T, y::T) where {T<:BitSigned} = Base.sdiv_int(x, y)

# Not SPIR-V operations, but handy to define to abstract over unsigned/signed integers.
IRem(x::T, y::T) where {T<:Union{BitSigned,BitUnsigned}} = SRem(x, y)
IMod(x::T, y::T) where {T<:BitSigned} = SMod(x, y)
IMod(x::T, y::T) where {T<:BitUnsigned} = UMod(x, y)
IDiv(x::T, y::T) where {T<:BitSigned} = SDiv(x, y)
IDiv(x::T, y::T) where {T<:BitUnsigned} = UDiv(x, y)

@override ifelse(cond::Bool, x, y) = Select(cond, x, y)
@noinline Select(cond::Bool, x::T, y::T) where {T} = Core.ifelse(cond, x, y)

@override flipsign(x::T, y::T) where {T<:BitSigned} = Select(y ≥ 0, x, -x)
@override flipsign(x::BitSigned, y::BitSigned) = flipsign(promote(x, y)...) % typeof(x)

# Booleans.

@override (!)(x::Bool)           = LogicalNot(x)
@noinline LogicalNot(x)          = Base.not_int(x)
@override (&)(x::Bool, y::Bool)  = LogicalAnd(x, y)
@noinline LogicalAnd(x, y)       = Base.and_int(x, y)
@override (|)(x::Bool, y::Bool)  = LogicalOr(x, y)
@noinline LogicalOr(x, y)        = Base.or_int(x, y)
@override xor(x::Bool, y::Bool)  = BitwiseXor(x, y)
@noinline BitwiseXor(x, y)       = Base.xor_int(x, y)
@override (==)(x::Bool, y::Bool) = LogicalEqual(x, y)
@noinline LogicalEqual(x, y)     = Base.eq_int(x, y)
@override (!=)(x::Bool, y::Bool) = LogicalNotEqual(x, y)
@noinline LogicalNotEqual(x, y)  = Base.ne_int(x, y)

# Copying.

## Deep copying and shallow copying should be defined identically here, because of how
## mutable objects are treated in SPIR-V (as pointers to immutable objects).
## That would change if we expect to have pointers in object fields and expect
# their contents to be recursively copied as well.

# Deepcopy has only one implementation and relies on `deepcopy_internal` with consistent semantics.
@override deepcopy(x) = CopyObject(x)
# XXX: This overrides all definitions of `copy` for the purpose of method lookup and therefore breaks a few things.
# @override copy(x) = CopyObject(x)
@noinline function CopyObject(@nospecialize(x))
  isbitstype(typeof(x)) && return x
  return Base.deepcopy_internal(x, IdDict())::typeof(x)
end

# Miscellaneous Base methods which use intrinsics that don't map well to SPIR-V.

@override copysign(x::T, y::T) where {T <: Union{Float32, Float64}} = ifelse(y < 0, -x, x)

# Math functions using intrinsics directly.

@override function Base.Math.two_mul(x::Float64, y::Float64)
  if have_fma(Float64)
      xy = x*y
      xy, fma(x, y, -xy)
  end
  Base.twomul(x,y)
end
