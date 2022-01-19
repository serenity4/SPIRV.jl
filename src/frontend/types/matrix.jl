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
