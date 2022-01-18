@MethodTable INTRINSICS_GLSL_METHOD_TABLE

const SmallFloat = Union{Float16,Float32}

macro override_glsl(ex)
  esc(:(@overlay SPIRV.INTRINSICS_GLSL_METHOD_TABLE @inline $ex))
end

@override_glsl muladd(x::T, y::T, z::T) where {T<:IEEEFloat} = Fma(x, y, z)
@override_glsl fma(x::T, y::T, z::T) where {T<:IEEEFloat}    = Fma(x, y, z)
@noinline Fma(x, y, z)                                       = Base.fma_float(x, y, z)

@override_glsl exp(x::SmallFloat)  = Exp(x)
@noinline Exp(x)                   = Base.Math.exp_impl(x, Val(:ℯ))
@override_glsl exp2(x::SmallFloat) = Exp2(x)
@noinline Exp2(x)                  = Base.Math.exp_impl(x, Val(2))
@override_glsl log(x::SmallFloat)  = Log(x)
@noinline Log(x)                   = Base.Math._log(x, Val(:ℯ), :log)
@override_glsl log2(x::SmallFloat) = Log2(x)
@noinline Log2(x)                  = Base.Math._log(x, Val(2), :log2)

for func in (:sin, :cos, :tan, :asin, :acos, :atan, :cosh, :tanh, :asinh, :acosh, :atanh)
  op = Symbol(uppercasefirst(string(func)))
  @eval (@override_glsl $func(x::SmallFloat) = $op(x))
  @eval (@noinline $op(x::T) where {T<:SmallFloat} = T($func(Float64(x))))
end

@override_glsl sqrt(x::IEEEFloat) = Sqrt(x)
@noinline Sqrt(x)                 = Base.sqrt_llvm(x)

@override_glsl trunc(x::IEEEFloat, r::RoundingMode{:ToZero})  = Trunc(x)
@noinline Trunc(x)                                            = Base.trunc_llvm(x)
@override_glsl round(x::IEEEFloat, r::RoundingMode{:Down})    = Floor(x)
@noinline Floor(x)                                            = Base.floor_llvm(x)
@override_glsl round(x::IEEEFloat, r::RoundingMode{:Up})      = Ceil(x)
@noinline Ceil(x)                                             = Base.ceil_llvm(x)
@override_glsl round(x::IEEEFloat, r::RoundingMode{:Nearest}) = Round(x)
@noinline Round(x)                                            = Base.rint_llvm(x)

@override_glsl abs(x::BitSigned)  = SAbs(x)
@noinline SAbs(x)                 = flipsign(x, x)
@override_glsl abs(x::IEEEFloat)  = FAbs(x)
@noinline FAbs(x)                 = Base.abs_float(x)
@override_glsl sign(x::IEEEFloat) = FSign(x)
@noinline FSign(x)                = invoke(sign, Tuple{Number}, x)
@override_glsl sign(x::BitSigned) = SSign(x)
@noinline SSign(x)                = ifelse(iszero(x), zero(x), x / abs(x))

# Min/max/clamp operations

@override_glsl min(x::T, y::T) where {T<:IEEEFloat}   = FMin(x, y)
@noinline FMin(x, y)                                  = ifelse(isless(x, y), x, y)
@override_glsl min(x::T, y::T) where {T<:BitSigned}   = SMin(x, y)
@noinline SMin(x, y)                                  = ifelse(isless(x, y), x, y)
@override_glsl min(x::T, y::T) where {T<:BitUnsigned} = UMin(x, y)
@noinline UMin(x, y)                                  = ifelse(isless(x, y), x, y)

@override_glsl max(x::T, y::T) where {T<:IEEEFloat}   = FMax(x, y)
@noinline FMax(x, y)                                  = ifelse(isless(y, x), x, y)
@override_glsl max(x::T, y::T) where {T<:BitSigned}   = SMax(x, y)
@noinline SMax(x, y)                                  = ifelse(isless(y, x), x, y)
@override_glsl max(x::T, y::T) where {T<:BitUnsigned} = UMax(x, y)
@noinline UMax(x, y)                                  = ifelse(isless(y, x), x, y)

@override_glsl clamp(x::T, lo::T, hi::T) where {T<:IEEEFloat}   = FClamp(x, lo, hi)
@noinline FClamp(x, lo, hi)                                     = min(max(x, lo), hi)
@override_glsl clamp(x::T, lo::T, hi::T) where {T<:BitSigned}   = SClamp(x, lo, hi)
@noinline SClamp(x, lo, hi)                                     = min(max(x, lo), hi)
@override_glsl clamp(x::T, lo::T, hi::T) where {T<:BitUnsigned} = UClamp(x, lo, hi)
@noinline UClamp(x, lo, hi)                                     = min(max(x, lo), hi)
