@MethodTable INTRINSICS_GLSL_METHOD_TABLE

const SmallFloat = Union{Float16,Float32}

macro override_glsl(ex)
  esc(:(@overlay SPIRV.INTRINSICS_GLSL_METHOD_TABLE @inline $ex))
end

@override_glsl muladd(x::T, y::T, z::T) where {T<:IEEEFloat} = Fma(x, y, z)
@noinline      Fma(x, y, z)                                  = Base.fma_float(x, y, z)

@override_glsl exp(x::SmallFloat)              = Exp(x)
@noinline      Exp(x)                          = Base.Math.exp_impl(x, Val(:ℯ))
@override_glsl log(x::SmallFloat)              = Log(x)
@noinline      Log(x)                          = Base.Math._log(x, Val(:ℯ), :log)
@override_glsl sin(x::SmallFloat)              = Sin(x)
@noinline      Sin(x::T) where {T<:SmallFloat} = T(sin(Float64(x)))

@override_glsl trunc(x::IEEEFloat, r::RoundingMode{:ToZero}) = Trunc(x)
@noinline Trunc(x) = Base.trunc_llvm(x)
@override_glsl round(x::IEEEFloat, r::RoundingMode{:Down})    = Floor(x)
@noinline Floor(x) = Base.floor_llvm(x)
@override_glsl round(x::IEEEFloat, r::RoundingMode{:Up}) = Ceil(x)
@noinline Ceil(x) = Base.ceil_llvm(x)
@override_glsl round(x::IEEEFloat, r::RoundingMode{:Nearest}) = Round(x)
@noinline Round(x) = Base.rint_llvm(x)
