"""
Statically sized mutable vector.
"""
mutable struct GenericVector{T,N} <: AbstractVector{T}
  data::NTuple{N,T}
end
GenericVector{T,N}(data::NTuple{N,T}) where {N,T} = CompositeConstruct(GenericVector{T,N}, data...)
@noinline @generated CompositeConstruct(::Type{T}, data...) where {T<:GenericVector} = Expr(:new, T, :data)
GenericVector(args::Vararg{T}) where {T} = GenericVector{T,length(args)}(args)

const Scalar = Union{Bool,Integer,AbstractFloat}

"Statically sized vector with scalar values only."
const ScalarVector{T<:Scalar,N} = GenericVector{T,N}
ScalarVector(args::Vararg{T}) where {T<:Scalar} = GenericVector(args...)

"""
Statically sized scalar-valued matrix represented as a vector of column vectors.
"""
const ScalarMatrix{T<:Scalar,N,M} = GenericVector{ScalarVector{T,N},M}

"Statically sized 1D array, whose element type can be anything, including scalars and structs."
const SizedArray = GenericVector


const SVec = ScalarVector
SVec(data::NTuple{N,T}) where {N,T<:Scalar} = GenericVector{T,N}(data)
const SMat = ScalarMatrix
MVec(data::NTuple{N,T}) where {N,T<:SVec} = GenericVector{T,N}(data)

Base.length(::Type{GenericVector{T,N}}) where {T,N} = N
Base.eltype(::Type{<:GenericVector{T}}) where {T} = T
Base.size(T::Type{<:GenericVector{<:Scalar}}) = (length(T),)
Base.size(T::Type{<:GenericVector{<:GenericVector}}) = (length(T), length(eltype(T)))
Base.lastindex(T::Type{<:GenericVector}) = length(T)
Base.firstindex(T::Type{<:GenericVector}) = 1
Base.zero(T::Type{<:GenericVector}) = zero(eltype(T))
Base.one(T::Type{<:GenericVector}) = one(eltype(T))
Base.similar(::Type{<:GenericVector}, element_type, dims) = GenericVector(ntuple(Returns(zero(element_type)), first(dims)))
Base.similar(::Type{<:ScalarMatrix}, element_type, dims) = GenericVector(ntuple(x -> similar(ScalarVector, element_type, first(dims)), last(dims)))
Base.similar(T::Type{<:GenericVector}) = similar(T, eltype(T), size(T))

for f in (:length, :eltype, :size, :lastindex, :firstindex, :zero, :one, :similar)
  @eval Base.$f(v::GenericVector) = $f(typeof(v))
end

"""
Pointer that keeps its parent around to make sure it stays valid.
"""
struct Pointer{T}
  addr::Ptr{T}
  parent
end

Base.setindex!(ptr::Pointer{T}, x::T) where {T} = Store(ptr, x)
Base.setindex!(ptr::Pointer{T}, x) where {T} = Store(ptr, convert(T, x))
Base.eltype(::Type{Pointer{T}}) where {T} = T
Base.getindex(v::GenericVector, i) = Load(AccessChain(v, i))
Base.setindex!(v::GenericVector{T}, x::T, i) where {T} = Store(AccessChain(v, i), x)
Base.setindex!(v::GenericVector, x, i) = setindex!(v, convert(eltype(v), x), i)

@noinline function AccessChain(v::AbstractVector, i::UInt32)
  T = eltype(v)
  @assert isbitstype(T)
  @boundscheck 0 ≤ i ≤ length(v) - 1 || throw(BoundsError(v, i))
  GC.@preserve v begin
    addr = Base.unsafe_convert(Ptr{T}, pointer_from_objref(v))
    Pointer(addr + i * sizeof(T), v)
  end
end

"""
    AccessChain(v, index)

Get a [`Pointer`](@ref) to `v` using an indexing scheme that depends on the signedness of `index`:
- An unsigned index will use 0-based indexing.
- A signed index will use 1-based indexing, but will be explicitly converted to an 0-based unsigned index.

"""
function AccessChain end

@inline AccessChain(v::AbstractVector, i::Unsigned) = AccessChain(v, convert(UInt32, i))
@inline AccessChain(v::AbstractVector, i::Signed = 1) = AccessChain(v, UInt32(i - 1))

@noinline Load(ptr::Pointer) = GC.@preserve ptr Base.unsafe_load(ptr.addr)

@noinline function Store(ptr::Pointer{T}, x::T) where {T}
  GC.@preserve ptr Base.unsafe_store!(ptr.addr, x)
  nothing
end

@override setindex!(v::Vector{T}, x::T, i::Integer) where {T} = Store(AccessChain(v, i), x)
@override getindex(v::Vector, i::Integer) = Load(AccessChain(v, i))

Base.:(+)(v1::ScalarVector{T}, v2::ScalarVector{T}) where {T<:IEEEFloat} = FAdd(v1, v2)
@noinline FAdd(v1, v2) = vectorize(+, v1, v2)
Base.:(-)(v1::ScalarVector{T}, v2::ScalarVector{T}) where {T<:IEEEFloat} = FSub(v1, v2)
@noinline FSub(v1, v2) = vectorize(-, v1, v2)
Base.:(*)(v1::ScalarVector{T}, v2::ScalarVector{T}) where {T<:IEEEFloat} = FMul(v1, v2)
@noinline FMul(v1, v2) = vectorize(*, v1, v2)
vectorize(op, v1::T, v2::T) where {T<:GenericVector} = T(op.(v1.data, v2.data))

function Base.getproperty(x::GenericVector, prop::Symbol)
  (prop === :x || prop === :r) && return x[UInt32(0)]
  (prop === :y || prop === :g) && return x[UInt32(1)]
  (prop === :z || prop === :b) && return x[UInt32(2)]
  (prop === :w || prop === :a) && return x[UInt32(3)]
  getfield(x, prop)
end

Base.convert(::Type{Pointer{T}}, x::BitUnsigned) where {T} = UConvertToPtr(x)
Pointer(T::Type, x::BitUnsigned) = Pointer(Base.reinterpret(Ptr{T}, x), nothing)
@noinline ConvertUToPtr(T::Type, x) = Pointer(T, x)

struct PerVertex
  position::SVec{Float32,4}
  point_size::Float32
  clip_distance::SizedArray{Float32,1}
  cull_distance::SizedArray{Float32,1}
end
