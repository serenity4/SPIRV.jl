@MethodTable INTRINSICS_GLSL_METHOD_TABLE

macro override_glsl(ex)
  esc(:(@overlay SPIRV.INTRINSICS_GLSL_METHOD_TABLE @inline $ex))
end

@override_glsl exp(x::Union{Float16,Float32}) = Exp(x)
@noinline Exp(x::T) where {T<:Union{Float16,Float32}} = Base.Math.exp_impl(x, Val(:ℯ))

@override_glsl muladd(x::T, y::T, z::T) where {T<:IEEEFloat} = Fma(x, y, z)
@noinline Fma(x, y, z) = Base.fma_float(x, y, z)
