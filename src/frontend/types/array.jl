mutable struct Arr{N,T} <: AbstractSPIRVArray{T,1}
  data::NTuple{N,T}
  Arr{N,T}(components::T...) where {N, T} = CompositeConstruct(Arr{N,T}, components...)
end

Arr{N,T}(components::Tuple) where {N,T} = Arr{N,T}(components...)
Arr{N,T}(data::AbstractVector) where {N,T} = Arr{N,T}(ntuple(i -> data[i], N))
Arr{N,T}(components...) where {N,T} = Arr{N,T}(convert.(T, components)...)
Arr(components...) = Arr(promote(components...)...)
Arr(components::T...) where {T} = Arr{length(components),T}(components...)
Arr(components::Tuple) = Arr(components...)
Arr{T}(components...) where {T} = Arr{length(components),T}(convert.(T, components)...)
Arr(arr::Arr) = arr

@noinline (@generated CompositeConstruct(::Type{Arr{N,T}}, data::T...) where {N,T} = Expr(:new, Arr{N,T}, :data))

Base.length(::Type{<:Arr{N}}) where {N} = N
Base.size(T::Type{<:Arr}) = (length(T),)
Base.zero(AT::Type{Arr{N,T}}) where {N,T} = AT(ntuple(_ -> zero(T), N))
Base.one(AT::Type{Arr{N,T}}) where {N,T} = AT(ntuple(_ -> one(T), N))
Base.promote_rule(::Type{Arr{N,T1}}, ::Type{Arr{N,T2}}) where {N,T1,T2} = Arr{N,promote_type(T1, T2)}
Base.promote_rule(S::Type{<:Scalar}, ::Type{Arr{N,T}}) where {N,T} = Arr{N,promote_type(T, S)}
Base.convert(::Type{Arr{N,T1}}, v::Arr{N,T2}) where {N,T1,T2} = Arr{N,T1}(ntuple_uint32(i -> convert(T1, @inbounds v[i]), N)...)
Base.convert(::Type{T}, v::T) where {T<:Arr} = v
Base.convert(T::Type{<:Arr}, x::Scalar) = T(ntuple(Returns(x), length(T)))
Base.convert(T::Type{<:Arr}, t::Tuple) = T(t)
Base.getindex(arr::Arr, index::Int64, other_index::Int64) = arr[index]

@noinline CompositeExtract(arr::Arr, index::UInt32) = arr.data[index]

Base.copyto!(dst::Arr{N}, src::Arr{N}) where {N} = (setindex!(dst, src); dst)

# Other utilities

Base.rand(rng::AbstractRNG, sampler::Random.SamplerType{Arr{N,T}}) where {N,T} = Arr{N,T}(rand(rng, NTuple{N,T}))
Base.rand(rng::AbstractRNG, sampler::Random.SamplerType{Arr{N}}) where {N} = rand(rng, Arr{N,Float32})
