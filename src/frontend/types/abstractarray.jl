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

unsigned_index(x::UInt32) = x
unsigned_index(x::Signed) = x*U - 1U

Base.getindex(arr::AbstractSPIRVArray, indices::Integer...) = Load(AccessChain(arr, unsigned_index.(indices)...))
Base.setindex!(arr::AbstractSPIRVArray, value, indices...) = setindex!(arr, convert(eltype(arr), value), indices...)
Base.setindex!(arr::AbstractSPIRVArray{T}, value::T, indices::Integer...) where {T} = Store(AccessChain(arr, unsigned_index.(indices)...), value)
Base.setindex!(arr1::AbstractSPIRVArray, arr2::AbstractSPIRVArray) = Store(arr1, convert(typeof(arr1), arr2))

@override getindex(v::Vector, index::Integer) = AccessChain(v, unsigned_index(index))[]
@override setindex!(v::Vector{T}, value::T, index::Integer) where {T} = Store(AccessChain(v, unsigned_index(index)), value)

Base.eltype(::Type{<:AbstractSPIRVArray{T}}) where {T} = T
Base.firstindex(T::Type{<:AbstractSPIRVArray}, d = 1) = 0U
Base.lastindex(T::Type{<:AbstractSPIRVArray}, d) = unsigned_index(size(T)[d])
Base.lastindex(T::Type{<:AbstractSPIRVArray}) = unsigned_index(prod(size(T)))
Base.eachindex(T::Type{<:AbstractSPIRVArray}) = firstindex(T):lastindex(T)

Base.similar(T::Type{<:AbstractSPIRVArray}, element_type, dims) = zero(T)
Base.similar(T::Type{<:AbstractSPIRVArray}) = similar(T, eltype(T), size(T))

for f in (:length, :eltype, :size, :firstindex, :lastindex, :zero, :one, :similar, :eachindex, :axes)
  @eval Base.$f(v::AbstractSPIRVArray) = $f(typeof(v))
end

@noinline function Store(v::T, x::T) where {T<:AbstractSPIRVArray}
  obj_ptr = pointer_from_objref(v)
  ptr = Pointer(Base.unsafe_convert(Ptr{T}, obj_ptr), v)
  Store(ptr, x)
end

@generated Base.foldl(f::F, xs::AbstractSPIRVArray) where {F<:Function} = foldl((x, y) -> Expr(:call, :f, x, :(xs[$y])), eachindex(xs)[2:end]; init = :(xs[$(firstindex(xs))]))
@generated Base.foldr(f::F, xs::AbstractSPIRVArray) where {F<:Function} = foldr((x, y) -> Expr(:call, :f, :(xs[$x]), y), eachindex(xs)[1:(end - 1)]; init = :(xs[$(lastindex(xs))]))
Base.any(f::F, xs::AbstractSPIRVArray) where {F<:Function} = foldl((x, y) -> f(x) | f(y), xs)
Base.all(f::F, xs::AbstractSPIRVArray) where {F<:Function} = foldl((x, y) -> f(x) & f(y), xs)
@generated Base.sum(f::F, xs::AbstractSPIRVArray) where {F<:Function} = Expr(:call, :+, (:(f(xs[$i])) for i in eachindex(xs))...)
@generated Base.prod(f::F, xs::AbstractSPIRVArray) where {F<:Function} = Expr(:call, :*, (:(f(xs[$i])) for i in eachindex(xs))...)
Base.sum(xs::AbstractSPIRVArray) = sum(identity, xs)
Base.prod(xs::AbstractSPIRVArray) = prod(identity, xs)

# Extracted from Base.
"""
Similar to `ntuple`, except that `f` is provided with a 0-based `UInt32` index instead of a 1-based `Int64` index.
"""
@inline function ntuple_uint32(f::F, n::Integer) where F
  t = n == 0  ? () :
      n == 1  ? (f(0U),) :
      n == 2  ? (f(0U), f(1U)) :
      n == 3  ? (f(0U), f(1U), f(2U)) :
      n == 4  ? (f(0U), f(1U), f(2U), f(3U)) :
      n == 5  ? (f(0U), f(1U), f(2U), f(3U), f(4U)) :
      n == 6  ? (f(0U), f(1U), f(2U), f(3U), f(4U), f(5U)) :
      n == 7  ? (f(0U), f(1U), f(2U), f(3U), f(4U), f(5U), f(6U)) :
      n == 8  ? (f(0U), f(1U), f(2U), f(3U), f(4U), f(5U), f(6U), f(7U)) :
      n == 9  ? (f(0U), f(1U), f(2U), f(3U), f(4U), f(5U), f(6U), f(7U), f(8U)) :
      n == 10 ? (f(0U), f(1U), f(2U), f(3U), f(4U), f(5U), f(6U), f(7U), f(8U), f(9U)) :
      _ntuple_uint32(f, n)
  return t
end

@noinline function _ntuple_uint32(f::F, n) where F
  (n >= 0) || throw(ArgumentError(LazyString("tuple length should be ≥ 0, got ", n)))
  ([f(unsigned_index(i)) for i in 1:n]...,)
end
