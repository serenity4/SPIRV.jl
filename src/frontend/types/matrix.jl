mutable struct Mat{N,M,T} <: AbstractSPIRVArray{T,2}
  cols::NTuple{M,NTuple{N,T}}
  Mat{N,M,T}(cols::Vec{N,T}...) where {N,M,T} = CompositeConstruct(Mat{N,M,T}, cols...)
end

Mat(cols::Vec...) = Mat(promote(cols...)...)
Mat(cols::T...) where {T<:Vec} = Mat{length(T),length(cols),eltype(T)}(cols...)

const Mat2 = Mat{2,2,Float32}
const Mat3 = Mat{3,3,Float32}
const Mat4 = Mat{4,4,Float32}

@noinline (@generated function CompositeConstruct(::Type{Mat{N,M,T}}, cols::Vec{N,T}...) where {N,M,T}
  2 ≤ N ≤ 4 || throw(ArgumentError("SPIR-V vectors must have between 2 and 4 components."))
  Expr(:new, Mat{N,M,T}, :(getproperty.(cols, :data)))
end)

macro mat(ex)
  n = length(ex.args)
  args = []
  args = [:(Vec($(esc.(getindex.(getproperty.(ex.args, :args), i))...))) for i in 1:n]
  :(Mat($(args...)))
end

nrows(::Type{<:Mat{N}}) where {N} = N
ncols(::Type{<:Mat{N,M}}) where {N,M} = M
coltype(::Type{Mat{N,M,T}}) where {N,M,T} = Vec{N,T}

for f in (:nrows, :ncols)
  @eval $f(m::Mat) = $f(typeof(m))
end

Base.length(::Type{<:Mat{N,M}}) where {N,M} = N * M
Base.size(T::Type{<:Mat{N,M}}) where {N,M} = (N, M)
Base.zero(T::Type{<:Mat}) = T(ntuple(Returns(zero(coltype(T))), ncols(T))...)
Base.one(T::Type{<:Mat}) = T(ntuple(Returns(one(eltype(T))), length(T))...)

@noinline CompositeExtract(m::Mat, i::UInt32, j::UInt32) = m.cols[j + 1][i + 1]
@noinline AccessChain(m::Mat, index::UInt32, second_index::UInt32) = AccessChain(m, index + second_index * UInt32(ncols(m)))
