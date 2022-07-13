mutable struct Vec{N,T<:Scalar} <: AbstractSPIRVArray{T,1}
  data::NTuple{N,T}
  Vec{N,T}(components::T...) where {N,T} = CompositeConstruct(Vec{N,T}, components...)
end

Vec{N,T}(data::NTuple) where {N,T} = Vec{N,T}(data...)
Vec{N,T}(components...) where {N,T} = Vec{N,T}(convert.(T, components)...)
Vec(components::Scalar...) = Vec(promote(components...)...)
Vec(components::T...) where {T<:Scalar} = Vec{length(components),T}(components...)
Vec{T}(components...) where {T<:Scalar} = Vec{length(components),T}(convert.(T, components)...)

const Vec2 = Vec{2,Float32}
const Vec3 = Vec{3,Float32}
const Vec4 = Vec{4,Float32}

@noinline (@generated function CompositeConstruct(::Type{Vec{N,T}}, data::T...) where {N,T}
  2 ≤ N ≤ 4 || throw(ArgumentError("SPIR-V vectors must have between 2 and 4 components."))
  Expr(:new, Vec{N,T}, :data)
end)

Base.length(::Type{<:Vec{N}}) where {N} = N
Base.size(T::Type{<:Vec}) = (length(T),)
Base.zero(T::Type{<:Vec}) = T(ntuple(Returns(zero(eltype(T))), length(T)))
Base.one(T::Type{<:Vec}) = T(ntuple(Returns(one(eltype(T))), length(T)))
Base.promote_rule(::Type{Vec{N,T1}}, ::Type{Vec{N,T2}}) where {N,T1,T2} = Vec{N,promote_type(T1, T2)}
Base.convert(::Type{Vec{N,T1}}, v::Vec{N,T2}) where {N,T1,T2} = Vec{N,T1}(ntuple(i -> convert(T1, v[i]), N)...)
Base.convert(::Type{Vec{N,T}}, v::Vec{N,T}) where {N,T} = v
Base.getindex(v::Vec, index::UInt32, other_index::UInt32, other_indices::UInt32...) = v[index]

@noinline CompositeExtract(v::Vec, index::UInt32) = v.data[index + 1]

function Base.getproperty(v::Vec, prop::Symbol)
  i = to_index(prop)
  isnothing(i) ? getfield(v, prop) : CompositeExtract(v, i)
end

function to_index(prop::Symbol)
  (prop === :x || prop === :r) && return 0U
  (prop === :y || prop === :g) && return 1U
  (prop === :z || prop === :b) && return 2U
  (prop === :w || prop === :a) && return 3U
  nothing
end

function Base.setproperty!(v::Vec, prop::Symbol, val)
  i = to_index(prop)
  isnothing(i) ? setfield!(v, prop, val) : setindex!(v, val, i)
end

Base.:(+)(v1::T, v2::T) where {T<:Vec{<:Any,<:IEEEFloat}} = FAdd(v1, v2)
@noinline FAdd(v1, v2) = vectorize(+, v1, v2)
Base.:(-)(v1::T, v2::T) where {T<:Vec{<:Any,<:IEEEFloat}} = FSub(v1, v2)
@noinline FSub(v1, v2) = vectorize(-, v1, v2)
Base.:(*)(v1::T, v2::T) where {T<:Vec{<:Any,<:IEEEFloat}} = FMul(v1, v2)
@noinline FMul(v1, v2) = vectorize(*, v1, v2)
vectorize(op, v1::T, v2::T) where {T<:Vec{<:Any,<:IEEEFloat}} = T(op.(v1.data, v2.data))
