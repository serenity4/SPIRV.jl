abstract type StaticallySizedArray{T,N} <: AbstractVector{T} end

"""
Statically sized mutable vector.
"""
mutable struct GenericVector{T,N} <: StaticallySizedArray{T,N}
  data::NTuple{N,T}
end
GenericVector{T,N}(data::NTuple{N,T}) where {N,T} = CompositeConstruct(GenericVector{T,N}, data...)
@noinline (@generated CompositeConstruct(::Type{T}, data...) where {T<:GenericVector} = Expr(:new, T, :data))
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


const Vec = ScalarVector
Vec(data::NTuple{N,T}) where {N,T<:Scalar} = GenericVector{T,N}(data)
const Mat = ScalarMatrix
MVec(data::NTuple{N,T}) where {N,T<:Vec} = GenericVector{T,N}(data)

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
Base.zeros(T::Type{<:GenericVector}) = similar(T)

for f in (:length, :eltype, :size, :lastindex, :firstindex, :zero, :one, :similar)
  @eval Base.$f(v::GenericVector) = $f(typeof(v))
end

Base.getindex(v::GenericVector, i) = AccessChain(v, i)[]
Base.setindex!(v::T, x::T) where {T<:GenericVector} = Store(v, x)
Base.setindex!(v::GenericVector{T}, x::T, i) where {T} = Store(AccessChain(v, i), x)
Base.setindex!(v::GenericVector, x, i) = setindex!(v, convert(eltype(v), x), i)

"""
Pointer that keeps its parent around to make sure it stays valid.

Used to represent the mutability of data structures in the type domain.
"""
struct Pointer{T}
  addr::Ptr{T}
  parent
end

function Pointer(ref::Ref{T}) where {T}
  Pointer(Base.unsafe_convert(Ptr{T}, ref), ref)
end

Base.:(==)(ptr1::Pointer, ptr2::Pointer) = PtrEqual(ptr1, ptr2)
@noinline PtrEqual(ptr1, ptr2) = ptr1.addr == ptr2.addr
Base.:(≠)(ptr1::Pointer, ptr2::Pointer) = PtrNotEqual(ptr1, ptr2)
@noinline PtrNotEqual(ptr1, ptr2) = ptr1.addr ≠ ptr2.addr

Base.setindex!(ptr::Pointer{T}, x::T) where {T} = (Store(ptr, x); x)
Base.setindex!(ptr::Pointer{T}, x) where {T} = Store(ptr, convert(T, x))
Base.eltype(::Type{Pointer{T}}) where {T} = T
Base.getindex(ptr::Pointer) = Load(ptr)
Base.getindex(ptr::Pointer, i::Integer, indices::Integer...) = Load(AccessChain(ptr, i, indices...))

@noinline Load(ptr::Pointer) = GC.@preserve ptr Base.unsafe_load(ptr.addr)

"""
    AccessChain(v, index)

Get a [`Pointer`](@ref) to `v` using an indexing scheme that depends on the signedness of `index`:
- An unsigned index will use 0-based indexing.
- A signed index will use 1-based indexing, but will be explicitly converted to an 0-based unsigned index.

"""
function AccessChain end

@inline AccessChain(v, i::Unsigned) = AccessChain(v, convert(UInt32, i))
@inline AccessChain(v, i::Signed, indices::Signed...) = AccessChain(v, UInt32(i - 1), UInt32.(indices .- 1)...)

@noinline function AccessChain(v::AbstractVector, i::UInt32)
  T = eltype(v)
  # Make sure `isbitstype(T)` holds if executing that on the CPU.
  # @assert isbitstype(T)
  @boundscheck 0 ≤ i ≤ length(v) - 1 || throw(BoundsError(v, i))
  GC.@preserve v begin
    addr = Base.unsafe_convert(Ptr{T}, pointer_from_objref(v))
    Pointer(addr + i * sizeof(T), v)
  end
end

@noinline function AccessChain(ptr::Pointer{T}, index::UInt32) where {T}
  new_addr = ptr.addr + index * sizeof(eltype(T))
  Pointer{eltype(T)}(new_addr, ptr.parent)
end

@noinline function AccessChain(ptr::Pointer{Tuple{T}}, i::UInt32, j::UInt32) where {T<:Vector}
  @assert i == 0
  AccessChain(Pointer{T}(ptr.addr, only(ptr.parent)), j)
end

@noinline function Store(ptr::Pointer{T}, x::T) where {T}
  GC.@preserve ptr Base.unsafe_store!(ptr.addr, x)
  nothing
end

@noinline function Store(v::T, x::T) where {T<:GenericVector}
  obj_ptr = pointer_from_objref(v)
  ptr = Pointer(Base.unsafe_convert(Ptr{T}, obj_ptr), v)
  Store(ptr, x)
end

Base.convert(::Type{Pointer{T}}, x::BitUnsigned) where {T} = ConvertUToPtr(x)
@noinline ConvertUToPtr(T::Type, x) = Pointer{T}(Base.reinterpret(Ptr{T}, x), x)
Pointer{T}(x::BitUnsigned) where {T} = ConvertUToPtr(T, x)
Pointer(T::Type, x::BitUnsigned) = Pointer{T}(x)

@override setindex!(v::Vector{T}, x::T, i::Integer) where {T} = Store(AccessChain(v, i), x)
@override getindex(v::Vector, i::Integer) = AccessChain(v, i)[]

Base.:(+)(v1::ScalarVector{T}, v2::ScalarVector{T}) where {T<:IEEEFloat} = FAdd(v1, v2)
@noinline FAdd(v1, v2) = vectorize(+, v1, v2)
Base.:(-)(v1::ScalarVector{T}, v2::ScalarVector{T}) where {T<:IEEEFloat} = FSub(v1, v2)
@noinline FSub(v1, v2) = vectorize(-, v1, v2)
Base.:(*)(v1::ScalarVector{T}, v2::ScalarVector{T}) where {T<:IEEEFloat} = FMul(v1, v2)
@noinline FMul(v1, v2) = vectorize(*, v1, v2)
vectorize(op, v1::T, v2::T) where {T<:GenericVector} = T(op.(v1.data, v2.data))

function Base.getproperty(x::GenericVector, prop::Symbol)
  i = to_index(prop)
  isnothing(i) ? getfield(x, prop) : x[i]
end

function to_index(prop::Symbol)
  (prop === :x || prop === :r) && return UInt32(0)
  (prop === :y || prop === :g) && return UInt32(1)
  (prop === :z || prop === :b) && return UInt32(2)
  (prop === :w || prop === :a) && return UInt32(3)
  nothing
end

function Base.setproperty!(x::GenericVector, prop::Symbol, val)
  i = to_index(prop)
  isnothing(i) ? setfield!(x, prop, val) : setindex!(x, val, i)
end
