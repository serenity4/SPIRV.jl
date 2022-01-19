mutable struct Arr{N,T} <: AbstractSPIRVArray{T,1}
  data::NTuple{N,T}
end

Arr(components...) = Arr(promote(components...)...)
Arr(components::T...) where {T} = Arr{length(components),T}(components...)
Arr{N,T}(components::T...) where {N, T} = CompositeConstruct(Arr{N,T}, components...)
@noinline (@generated CompositeConstruct(::Type{Arr{N,T}}, data::T...) where {N,T} = Expr(:new, Arr{N,T}, :data))

Base.length(::Type{<:Arr{N}}) where {N} = N
Base.size(T::Type{<:Arr}) = (length(T),)
Base.zero(T::Type{<:Arr}) = T(ntuple(Returns(zero(eltype(T))), length(T)))
Base.one(T::Type{<:Arr}) = T(ntuple(Returns(one(eltype(T))), length(T)))
Base.promote_rule(::Type{Arr{N,T1}}, ::Type{Arr{N,T2}}) where {N,T1,T2} = Arr{N,promote_type(T1, T2)}
Base.convert(::Type{Arr{N,T1}}, v::Arr{N,T2}) where {N,T1,T2} = Arr{N,T1}(convert(NTuple{N,T1}, v.data))
Base.getindex(arr::Arr, index::UInt32, other_index::UInt32, other_indices::UInt32...) = arr[index]

@noinline CompositeExtract(arr::Arr, index::UInt32) = arr.data[index + 1]
