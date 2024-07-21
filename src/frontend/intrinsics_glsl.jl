@noinline Fma(x, y, z)                                       = Base.fma_float(x, y, z)

@noinline Exp(x::SmallFloat)                   = Base.Math.exp_impl(x, Val(:ℯ))
@noinline Exp2(x::SmallFloat)                  = Base.Math.exp_impl(x, Val(2))
@noinline Log(x::SmallFloat)                   = Base.Math._log(x, Val(:ℯ), :log)
@noinline Log2(x::SmallFloat)                  = Base.Math._log(x, Val(2), :log2)

@noinline Sin(x::T) where {T<:SmallFloat} = T(sin(Float64(x)))
@noinline Cos(x::T) where {T<:SmallFloat} = T(cos(Float64(x)))
@noinline Tan(x::T) where {T<:SmallFloat} = T(tan(Float64(x)))
@noinline Asin(x::T) where {T<:SmallFloat} = T(asin(Float64(x)))
@noinline Acos(x::T) where {T<:SmallFloat} = T(acos(Float64(x)))
@noinline Atan(x::T) where {T<:SmallFloat} = T(atan(Float64(x)))
@noinline Cosh(x::T) where {T<:SmallFloat} = T(cosh(Float64(x)))
@noinline Tanh(x::T) where {T<:SmallFloat} = T(tanh(Float64(x)))
@noinline Asinh(x::T) where {T<:SmallFloat} = T(asinh(Float64(x)))
@noinline Acosh(x::T) where {T<:SmallFloat} = T(acosh(Float64(x)))
@noinline Atanh(x::T) where {T<:SmallFloat} = T(atanh(Float64(x)))

@noinline Atan2(y::Float32, x::Float32) = Base.invoke(atan, Tuple{T, T} where {T <: Union{Float32,Float64}}, y, x)::Float32
# XXX: # `@noinline` does not seem to get applied in SPIRV.@code_typed atan(::Float16, ::Float16), we still go through conversions.
@noinline Atan2(y::Float16, x::Float16) = Float16(Atan2(Float32(y), Float32(x)))

@noinline Sqrt(x)                 = Base.sqrt_llvm(x)

@noinline Trunc(x)                                            = Base.trunc_llvm(x)
@noinline Floor(x)                                            = Base.floor_llvm(x)
@noinline Ceil(x)                                             = Base.ceil_llvm(x)
@noinline Round(x)                                            = Base.rint_llvm(x)

@noinline SAbs(x)                 = flipsign(x, x)
@noinline FAbs(x)                 = Base.abs_float(x)
@noinline FSign(x)                = invoke(sign, Tuple{Number}, x)
@noinline SSign(x)                = ifelse(iszero(x), zero(x), x / abs(x))

# Extracted from Base.Math: ^(::Float64, ::Float64).
# @constprop aggressive to help the compiler see the switch between the integer and float
# variants for callers with constant `y`.
@noinline Base.@constprop :aggressive function Pow(x::Float64, y::Float64)
    xu = reinterpret(UInt64, x)
    xu == reinterpret(UInt64, 1.0) && return 1.0
    # Exponents greater than this will always overflow or underflow.
    # Note that NaN can pass through this, but that will end up fine.
    if !(abs(y)<0x1.8p62)
        isnan(y) && return y
        y = sign(y)*0x1.8p62
    end
    yint = unsafe_trunc(Int64, y) # This is actually safe since julia freezes the result
    yisint = y == yint
    if yisint
        yint == 0 && return 1.0
        use_power_by_squaring(yint) && return @noinline Base.Math.pow_body(x, yint)
    end
    2*xu==0 && return abs(y)*Inf*(!(y>0)) # if x === +0.0 or -0.0 (Inf * false === 0.0)
    s = 1
    if x < 0
        !yisint && throw_exp_domainerror(x) # y isn't an integer
        s = ifelse(isodd(yint), -1, 1)
    end
    !isfinite(x) && return copysign(x,s)*(y>0 || isnan(x))           # x is inf or NaN
    return copysign(Base.Math.pow_body(abs(x), y), s)
end

# Extracted from Base.Math: ^(::T, ::T) where {T<:Union{Float16, Float32}}.
@noinline Base.@constprop :aggressive function Pow(x::T, y::T) where T <: Union{Float16, Float32}
    x == 1 && return one(T)
    # Exponents greater than this will always overflow or underflow.
    # Note that NaN can pass through this, but that will end up fine.
    max_exp = T == Float16 ? T(3<<14) : T(0x1.Ap30)
    if !(abs(y)<max_exp)
        isnan(y) && return y
        y = sign(y)*max_exp
    end
    yint = unsafe_trunc(Int32, y) # This is actually safe since julia freezes the result
    y == yint && return x^yint
    x < 0 && Base.Math.throw_exp_domainerror(x)
    !isfinite(x) && return x*(y>0 || isnan(x))
    x==0 && return abs(y)*T(Inf)*(!(y>0))
    return Base.Math.pow_body(x, y)
end

# Min/max/clamp operations

@noinline SMin(x, y)        = ifelse(isless(x, y), x, y)
@noinline FMin(x, y)        = ifelse(isless(x, y), x, y)
@noinline UMin(x, y)        = ifelse(isless(x, y), x, y)
@noinline FMax(x, y)        = ifelse(isless(y, x), x, y)
@noinline SMax(x, y)        = ifelse(isless(y, x), x, y)
@noinline UMax(x, y)        = ifelse(isless(y, x), x, y)
@noinline FClamp(x, lo, hi) = min(max(x, lo), hi)
@noinline SClamp(x, lo, hi) = min(max(x, lo), hi)
@noinline UClamp(x, lo, hi) = min(max(x, lo), hi)

@noinline Normalize(x) = x ./ Length(x)
@noinline Length(x) = sqrt(sum(e -> e^2, x))
