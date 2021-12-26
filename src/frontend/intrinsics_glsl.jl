@MethodTable INTRINSICS_GLSL_METHOD_TABLE

macro override_glsl(ex)
  esc(:(@overlay SPIRV.INTRINSICS_GLSL_METHOD_TABLE @inline $ex))
end

@override_glsl exp(x::Union{Float16,Float32}) = Exp(x)
@noinline Exp(x::T) where {T<:Union{Float16,Float32}} = T(exp(Float64(x)))
