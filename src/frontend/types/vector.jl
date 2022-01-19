mutable struct Vec{N,T<:Scalar} <: AbstractSPIRVArray{T,1}
  data::NTuple{N,T}
end

Vec(components::Scalar...) = Vec(promote(components...)...)
Vec(components::T...) where {T<:Scalar} = Vec{length(components),T}(components...)
Vec{N,T}(components::T...) where {N, T} = CompositeConstruct(Vec{N,T}, components...)
@noinline (@generated CompositeConstruct(::Type{Vec{N,T}}, data::T...) where {N,T} = Expr(:new, Vec{N,T}, :data))

Base.length(::Type{<:Vec{N}}) where {N} = N
Base.size(T::Type{<:Vec}) = (length(T),)
Base.zero(T::Type{<:Vec}) = T(ntuple(Returns(zero(eltype(T))), length(T)))
Base.one(T::Type{<:Vec}) = T(ntuple(Returns(one(eltype(T))), length(T)))
Base.promote_rule(::Type{Vec{N,T1}}, ::Type{Vec{N,T2}}) where {N,T1,T2} = Vec{N,promote_type(T1, T2)}
Base.convert(::Type{Vec{N,T1}}, v::Vec{N,T2}) where {N,T1,T2} = Vec{N,T1}(convert(NTuple{N,T1}, v.data))
Base.getindex(v::Vec, index::UInt32, other_index::UInt32, other_indices::UInt32...) = v[index]

@noinline CompositeExtract(v::Vec, index::UInt32) = v.data[index + 1]

function Base.getproperty(v::Vec, prop::Symbol)
  i = to_index(prop)
  isnothing(i) ? getfield(v, prop) : v[i]
end

function to_index(prop::Symbol)
  (prop === :x || prop === :r) && return UInt32(0)
  (prop === :y || prop === :g) && return UInt32(1)
  (prop === :z || prop === :b) && return UInt32(2)
  (prop === :w || prop === :a) && return UInt32(3)
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
