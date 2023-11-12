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
  (VT, rows) = @match ex begin
    Expr(:typed_vcat, T, rows...) => (esc(T), rows)
    Expr(:vcat, rows...) => (nothing, rows)
    _ => error("Expected list concatenation expression, got $(repr(ex))")
  end
  nrows = length(rows)
  ncols = length(first(rows).args)
  cols = [[rows[i].args[j] for i in 1:nrows] for j in 1:ncols]
  V = isnothing(VT) ? :Vec : :(Vec{$nrows, $VT})
  column_vectors = [:($V($(esc.(col)...))) for col in cols]
  M = isnothing(VT) ? :Mat : :(Mat{$nrows, $ncols, $VT})
  :($M($(column_vectors...)))
end

nrows(::Type{<:Mat{N}}) where {N} = N
ncols(::Type{<:Mat{N,M}}) where {N,M} = M
coltype(::Type{Mat{N,M,T}}) where {N,M,T} = Vec{N,T}

@forward_methods Mat field = typeof(_) nrows ncols coltype

column(mat::Mat, i::Integer) = CompositeExtract(mat, unsigned_index(i))
@noinline CompositeExtract(mat::Mat, i::UInt32) = coltype(mat)(mat.cols[i + 1]...)
columns(mat::Mat) = ntuple_uint32(i -> column(mat, i), ncols(mat))

Base.length(::Type{<:Mat{N,M}}) where {N,M} = N * M
Base.size(T::Type{<:Mat{N,M}}) where {N,M} = (N, M)
Base.zero(T::Type{<:Mat}) = T(ntuple(Returns(zero(coltype(T))), ncols(T))...)
Base.one(T::Type{<:Mat}) = T(ntuple(Returns(one(coltype(T))), ncols(T))...)

@noinline CompositeExtract(m::Mat, i::UInt32, j::UInt32) = m.cols[j + 1][i + 1]
@noinline AccessChain(m::Mat, index::UInt32, second_index::UInt32) = AccessChain(m, index + second_index * UInt32(nrows(m)))

Base.copyto!(dst::Mat{N,M}, src::Mat{N,M}) where {N,M} = (setindex!(dst, src); dst)

# Other utilities

Base.rand(rng::AbstractRNG, sampler::Random.SamplerType{Mat{N,M,T}}) where {N,M,T} = @force_construct Mat{N,M,T} rand(rng, NTuple{M,NTuple{N,T}})
Base.rand(rng::AbstractRNG, sampler::Random.SamplerType{Mat{N,M}}) where {N,M} = rand(rng, Mat{N,M,Float32})
Base.rand(rng::AbstractRNG, sampler::Random.SamplerType{Mat{N}}) where {N} = rand(rng, Mat{N,N})
