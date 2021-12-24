@MethodTable(SPIRV_METHOD_TABLE)

@overlay SPIRV_METHOD_TABLE @inline function Base.:(+)(x::T, y::T) where {T<:Union{Float16,Float32,Float64}}
    FAdd(x, y)
end

@overlay SPIRV_METHOD_TABLE @inline function Base.:(*)(x::T, y::T) where {T<:Union{Float16,Float32,Float64}}
    FMul(x, y)
end
