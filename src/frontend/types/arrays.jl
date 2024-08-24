const VecEltype = Union{Bool, UInt8, UInt16, UInt32, UInt64, Int8, Int16, Int32, Int64, Float16, Float32, Float64}

const Vec{N,T<:VecEltype} = SVector{N,T}

const Vec2 = SVector{2,Float32}
const Vec3 = SVector{3,Float32}
const Vec4 = SVector{4,Float32}

const Vec2U = SVector{2,UInt32}
const Vec3U = SVector{3,UInt32}
const Vec4U = SVector{4,UInt32}

const Vec2I = SVector{2,Int32}
const Vec3I = SVector{3,Int32}
const Vec4I = SVector{4,Int32}

@noinline VectorExtractDynamic(v::Vec{<:Any,T}, index::UInt32) where {T} = v.data[index]::T

macro vec(ex)
  esc(macroexpand(StaticArrays, :(@SVector $ex)))
end

is_spirv_vector(::Type{Vec{N,T}}) where {N,T} = 2 ≤ N ≤ 4 && T <: VecEltype

# @noinline function VectorShuffle(x::T, y::T, coords...) where {T<:Vec}
#   v = zero(Vec{length(coords),eltype(T)})
#   nx = length(x)
#   for (i, coord) in enumerate(coords)
#     coord < nx ? v[i] = x[coord] : v[i - nx] = y[coord]
#   end
#   v
# end

# function setslice!(v::Vec, value, indices...)
#   ntuple(i -> setindex!(v, value[i], indices[i]), length(indices))
#   value
# end

const Arr{N,T} = SVector{N,T}

macro arr(ex)
  esc(macroexpand(StaticArrays, :(@SVector $ex)))
end

const Mat{N,M,T<:VecEltype,L} = SMatrix{N,M,T,L}

const Mat2 = Mat{2,2,Float32,4}
const Mat3 = Mat{3,3,Float32,9}
const Mat4 = Mat{4,4,Float32,16}
const Mat23 = Mat{2,3,Float32,6}
const Mat32 = Mat{3,2,Float32,6}
const Mat24 = Mat{2,4,Float32,8}
const Mat42 = Mat{4,2,Float32,8}
const Mat34 = Mat{3,4,Float32,12}
const Mat43 = Mat{4,3,Float32,12}

const Mat2U = Mat{2,2,UInt32,4}
const Mat3U = Mat{3,3,UInt32,9}
const Mat4U = Mat{4,4,UInt32,16}
const Mat23U = Mat{2,3,UInt32,6}
const Mat32U = Mat{3,2,UInt32,6}
const Mat24U = Mat{2,4,UInt32,8}
const Mat42U = Mat{4,2,UInt32,8}
const Mat34U = Mat{3,4,UInt32,12}
const Mat43U = Mat{4,3,UInt32,12}

const Mat2I = Mat{2,2,UInt32,4}
const Mat3I = Mat{3,3,UInt32,9}
const Mat4I = Mat{4,4,UInt32,16}
const Mat23I = Mat{2,3,UInt32,6}
const Mat32I = Mat{3,2,UInt32,6}
const Mat24I = Mat{2,4,UInt32,8}
const Mat42I = Mat{4,2,UInt32,8}
const Mat34I = Mat{3,4,UInt32,12}
const Mat43I = Mat{4,3,UInt32,12}

macro mat(ex)
  esc(macroexpand(StaticArrays, :(@SMatrix $ex)))
end

nrows(::Type{<:Mat{N}}) where {N} = N
ncols(::Type{<:Mat{N,M}}) where {N,M} = M
coltype(::Type{<:Mat{N,M,T}}) where {N,M,T} = Vec{N,T}

@forward_methods Mat field = typeof(_) nrows ncols coltype

column(mat::Mat, i::Integer) = CompositeExtract(mat, unsigned_index(i))
columns(mat::Mat) = ntuple_uint32(i -> column(mat, i), ncols(mat))

is_spirv_matrix(::Type{<:Mat{N,M,T}}) where {N,M,T} = 2 ≤ N ≤ 4 && 2 ≤ M ≤ 4 && T <: Union{UInt8, UInt16, UInt32, UInt64, Int8, Int16, Int32, Int64, Float16, Float32, Float64}
