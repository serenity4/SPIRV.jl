"""
SPIR-V array or vector.

SPIR-V vectors are semantically different than one-dimensional arrays,
in that they can store only scalars, must be statically sized and may have up to 4 components.
The same applies for SPIR-V matrices.

SPIR-V arrays do not require their element type to be scalar.
They are mostly sized, though unsized arrays are allowed in specific cases.
Vulkan, for example, requires unsized arrays to be the last member of a struct
that is used as a storage buffer.
"""
abstract type AbstractSPIRVArray{T,D} <: AbstractArray{T,D} end

const Scalar = Union{Bool,BitInteger,IEEEFloat}

Base.getindex(arr::AbstractSPIRVArray, indices::Signed...) = getindex(arr, (UInt32.(indices) .- UInt32(1))...)
Base.getindex(arr::AbstractSPIRVArray, indices::UInt32...) = CompositeExtract(arr, indices...)
Base.setindex!(arr::AbstractSPIRVArray, value, indices::Signed...) = setindex!(arr, convert(eltype(arr), value), (UInt32.(indices) .- UInt32(1))...)
Base.setindex!(arr::AbstractSPIRVArray{T}, value::T, indices::UInt32...) where {T} = Store(AccessChain(arr, indices...), value)
Base.setindex!(arr1::AbstractSPIRVArray, arr2::AbstractSPIRVArray) = Store(arr1, convert(typeof(arr1), arr2))

@override getindex(v::Vector, i::Signed) = getindex(v, UInt32(i) - UInt32(i - 1))
@override getindex(v::Vector, i::UInt32) = AccessChain(v, i)[]

Base.eltype(::Type{<:AbstractSPIRVArray{T}}) where {T} = T
Base.firstindex(T::Type{<:AbstractSPIRVArray}, d = 1) = 1
Base.lastindex(T::Type{<:AbstractSPIRVArray}, d) = size(T)[d]
Base.lastindex(T::Type{<:AbstractSPIRVArray}) = prod(size(T))

Base.similar(T::Type{<:AbstractSPIRVArray}, element_type, dims) = zero(T)
Base.similar(T::Type{<:AbstractSPIRVArray}) = similar(T, eltype(T), size(T))

for f in (:length, :eltype, :size, :firstindex, :lastindex, :zero, :one, :similar)
  @eval Base.$f(v::AbstractSPIRVArray) = $f(typeof(v))
end

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

mutable struct Mat{N,M,T} <: AbstractSPIRVArray{T,2}
  cols::NTuple{M,NTuple{N,T}}
end

# Mat(cols::Vec...) = Mat(promote(cols...)...)
Mat(cols::Vec{N,T}...) where {N,T} = CompositeConstruct(Mat{N,length(cols),T}, cols...)
@noinline function CompositeConstruct(::Type{Mat{N,M,T}}, cols::Vec{N,T}...) where {N,M,T}
  Mat{N,M,T}(getproperty.(cols, :data))
end

macro mat(ex)
  n = length(ex.args)
  args = []
  args = [:(Vec($(esc.(getindex.(getproperty.(ex.args, :args), i))...))) for i in 1:n]
  :(Mat($(args...)))
end

nrows(::Type{<:Mat{N}}) where {N} = N
ncols(::Type{<:Mat{N,M}}) where {N,M} = M

for f in (:nrows, :ncols)
  @eval $f(m::Mat) = $f(typeof(m))
end

Base.length(::Type{<:Mat{N,M}}) where {N,M} = N * M
Base.size(T::Type{<:Mat{N,M}}) where {N,M} = (N, M)
Base.zero(T::Type{<:Mat}) = T(ntuple(Returns(ntuple(Returns(zero(eltype(T))), nrows(T))), ncols(T)))
Base.one(T::Type{<:Mat}) = T(ntuple(Returns(one(eltype(T))), length(T)))
Base.setindex!(m::Mat{N,M,T}, value::T, index::UInt32, second_index::UInt32) where {N,M,T} = Store(AccessChain(m, (index + UInt32(1)) * UInt32(M) - UInt32(1), second_index), value)

@noinline CompositeExtract(m::Mat, i::UInt32, j::UInt32) = m.cols[j + 1][i + 1]

"""
    AccessChain(v, index)

Get a [`Pointer`](@ref) to `v` using an indexing scheme that depends on the signedness of `index`:
- An unsigned index will use 0-based indexing.
- A signed index will use 1-based indexing, but will be explicitly converted to an 0-based unsigned index.

"""
function AccessChain end

@noinline function AccessChain(mut, index::UInt32)
  @assert ismutable(mut)
  T = eltype(mut)
  # Make sure `isbitstype(T)` holds if executing that on the CPU.
  # @assert isbitstype(T)
  @boundscheck 0 ≤ index ≤ length(mut) - 1 || throw(BoundsError(mut, index))
  GC.@preserve mut begin
    addr = Base.unsafe_convert(Ptr{T}, pointer_from_objref(mut))
    Pointer(addr + index * sizeof(T), mut)
  end
end

AccessChain(v::AbstractVector, index::Signed) = AccessChain(v, UInt32(index) - UInt32(1))
AccessChain(x, index::Integer, second_index::Integer) = AccessChain(AccessChain(x, index), second_index)
AccessChain(x, index::Integer, second_index::Integer, other_indices::Integer...) = AccessChain(AccessChain(x, index, second_index), other_indices...)

@noinline function Store(v::T, x::T) where {T<:AbstractSPIRVArray}
  obj_ptr = pointer_from_objref(v)
  ptr = Pointer(Base.unsafe_convert(Ptr{T}, obj_ptr), v)
  Store(ptr, x)
end

Base.:(+)(v1::T, v2::T) where {T<:Vec{<:Any,<:IEEEFloat}} = FAdd(v1, v2)
@noinline FAdd(v1, v2) = vectorize(+, v1, v2)
Base.:(-)(v1::T, v2::T) where {T<:Vec{<:Any,<:IEEEFloat}} = FSub(v1, v2)
@noinline FSub(v1, v2) = vectorize(-, v1, v2)
Base.:(*)(v1::T, v2::T) where {T<:Vec{<:Any,<:IEEEFloat}} = FMul(v1, v2)
@noinline FMul(v1, v2) = vectorize(*, v1, v2)
vectorize(op, v1::T, v2::T) where {T<:Vec{<:Any,<:IEEEFloat}} = T(op.(v1.data, v2.data))
