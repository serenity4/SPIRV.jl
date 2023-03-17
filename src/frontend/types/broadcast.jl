using .Broadcast: Broadcasted, BroadcastStyle, DefaultArrayStyle, Style

struct BroadcastStyleSPIRV{T} <: BroadcastStyle end

Base.BroadcastStyle(T::Type{<:Vec}) = BroadcastStyleSPIRV{T}()
Base.BroadcastStyle(::BroadcastStyleSPIRV{T1}, ::BroadcastStyleSPIRV{T2}) where {T1,T2} = BroadcastStyleSPIRV{promote_type(T1,T2)}()
Base.BroadcastStyle(::DefaultArrayStyle{0}, style::BroadcastStyleSPIRV) = style
Base.similar(bc::Broadcasted{BroadcastStyleSPIRV{T}}, ::Type) where {T} = zero(T)
@inline Broadcast.instantiate(bc::Broadcasted{BroadcastStyleSPIRV{T}}) where {T<:Vec} = bc
@inline Base.materialize!(v::T, bc::Broadcasted{BroadcastStyleSPIRV{T}}) where {T<:Vec} = copyto!(v, only(bc.args))

@inline Base.broadcasted(f::F, v::Vec) where {F} = Vec(f.(getcomponents(v)))
@inline Base.broadcasted(f::F, v::Arr) where {F} = Arr(f.(getcomponents(v)))
@inline Base.broadcasted(f::F, v1::T, v2::T...) where {F,T<:Vec} = Vec(f.((getcomponents(v) for v in (v1, v2...))...))
@inline Base.broadcasted(f::F, v1::T, v2::T...) where {F,T<:Arr} = Arr(f.((getcomponents(v) for v in (v1, v2...))...))
@inline Base.broadcasted(f::F, v1::AbstractSPIRVArray, v2::AbstractSPIRVArray...) where {F} = Base.broadcasted(f, promote(v1, v2...)...)
@inline Base.broadcasted(f::F, x::AbstractSPIRVArray, y::Scalar, vs::AbstractSPIRVArray...) where {F} = Base.broadcasted(f, promote(x, y, vs...)...)
@inline Base.broadcasted(f::F, x::Scalar, y::AbstractSPIRVArray, vs::AbstractSPIRVArray...) where {F} = Base.broadcasted(f, promote(x, y, vs...)...)

const VecOrArr{N} = Union{Vec{N},Arr{N}}
getcomponents(v::VecOrArr{N}) where {N} = ntuple_uint32(i -> v[i], N)
