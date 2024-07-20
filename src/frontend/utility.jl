### Utility functions.

const Scalar = Union{Bool,BitInteger,IEEEFloat}

eachindex_uint32(x) = firstindex_uint32(x):lastindex_uint32(x)
firstindex_uint32(x) = UInt32(firstindex(x))
lastindex_uint32(x) = UInt32(lastindex(x))
firstindex_uint32(::Type{<:SVector}) = 1U
lastindex_uint32(::Type{<:SVector{N}}) where {N} = UInt32(N)

unsigned_index(x::Integer) = convert(UInt32, x)

# Extracted from Base.
"""
Similar to `ntuple`, except that `f` is provided with a 0-based `UInt32` index instead of a 1-based `Int64` index.
"""
@inline function ntuple_uint32(f::F, n::Integer) where F
  t = n == 0  ? () :
      n == 1  ? (f(1U),) :
      n == 2  ? (f(1U), f(2U)) :
      n == 3  ? (f(1U), f(2U), f(3U)) :
      n == 4  ? (f(1U), f(2U), f(3U), f(4U)) :
      n == 5  ? (f(1U), f(2U), f(3U), f(4U), f(5U)) :
      n == 6  ? (f(1U), f(2U), f(3U), f(4U), f(5U), f(6U)) :
      n == 7  ? (f(1U), f(2U), f(3U), f(4U), f(5U), f(6U), f(7U)) :
      n == 8  ? (f(1U), f(2U), f(3U), f(4U), f(5U), f(6U), f(7U), f(8U)) :
      n == 9  ? (f(1U), f(2U), f(3U), f(4U), f(5U), f(6U), f(7U), f(8U), f(9U)) :
      n == 10 ? (f(1U), f(2U), f(3U), f(4U), f(5U), f(6U), f(7U), f(8U), f(9U), f(10U)) :
      _ntuple_uint32(f, n)
  return t
end

@noinline function _ntuple_uint32(f::F, n) where F
  (n >= 0) || throw(ArgumentError(LazyString("tuple length should be ≥ 0, got ", n)))
  ([f(unsigned_index(i)) for i in 1:n]...,)
end
