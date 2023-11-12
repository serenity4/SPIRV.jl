abstract type GPUVector{N,T<:Scalar} <: AbstractSPIRVArray{T,1} end

mutable struct Vec{N,T} <: GPUVector{N,T}
  data::NTuple{N,T}
  Vec{N,T}(components::T...) where {N,T} = CompositeConstruct(Vec{N,T}, components...)
end

Vec{N,T}(data::Tuple) where {N,T} = Vec{N,T}(data...)
Vec{N,T}(data::AbstractVector) where {N,T} = Vec{N,T}(data...)
Vec{N,T}(components...) where {N,T} = Vec{N,T}(convert.(T, components)...)
Vec(components::Scalar...) = Vec(promote(components...)...)
Vec(components::T...) where {T<:Scalar} = Vec{length(components),T}(components...)
Vec(components::Tuple) = Vec(components...)
Vec{T}(components...) where {T<:Scalar} = Vec{length(components),T}(convert.(T, components)...)

const Vec2 = Vec{2,Float32}
const Vec3 = Vec{3,Float32}
const Vec4 = Vec{4,Float32}

@noinline (@generated function CompositeConstruct(::Type{Vec{N,T}}, data::T...) where {N,T}
  2 ≤ N ≤ 4 || throw(ArgumentError("SPIR-V vectors must have between 2 and 4 components."))
  Expr(:new, Vec{N,T}, :data)
end)

Base.length(::Type{<:Vec{N}}) where {N} = N
Base.size(T::Type{<:Vec}) = (length(T),)
Base.axes(T::Type{<:Vec}) = (Base.OneTo(length(T)),)
Base.zero(T::Type{<:Vec}) = T(ntuple(Returns(zero(eltype(T))), length(T)))
Base.one(T::Type{<:Vec}) = T(ntuple(Returns(one(eltype(T))), length(T)))
Base.promote_rule(::Type{Vec{N,T1}}, ::Type{Vec{N,T2}}) where {N,T1,T2} = Vec{N,promote_type(T1, T2)}
Base.promote_rule(S::Type{<:Scalar}, ::Type{Vec{N,T}}) where {N,T} = Vec{N,promote_type(T, S)}
Base.convert(::Type{Vec{N,T1}}, v::Vec{N,T2}) where {N,T1,T2} = Vec{N,T1}(ntuple_uint32(i -> convert(T1, @inbounds v[i]), N)...)
Base.convert(::Type{Vec{N,T}}, v::Vec{N,T}) where {N,T} = v
Base.convert(T::Type{<:Vec}, x::Scalar) = T(ntuple(Returns(x), length(T)))
Base.convert(T::Type{<:Vec}, t::Tuple) = T(t)
# For some reason, the default display on `AbstractArray` really wants to treat one-dimensional vectors as two-dimensional...
Base.getindex(v::Vec, index::Int64, other_index::Int64) = v[index]

@noinline CompositeExtract(v::Vec, index::UInt32) = v.data[index + 1]

Base.copyto!(dst::Vec{N}, src::Vec{N}) where {N} = (setindex!(dst, src); dst)

function Base.getproperty(v::Vec, prop::Symbol)
  prop === :data && return getfield(v, :data)

  # Generated by ./generator.jl
  (prop === :x || prop === :r) && return CompositeExtract(v, 0U)
  (prop === :xy || prop === :rg) && return VectorShuffle(v, v, 0U, 1U)
  (prop === :xyz || prop === :rgb) && return VectorShuffle(v, v, 0U, 1U, 2U)
  (prop === :xyzw || prop === :rgba) && return VectorShuffle(v, v, 0U, 1U, 2U, 3U)
  (prop === :xyw || prop === :rga) && return VectorShuffle(v, v, 0U, 1U, 3U)
  (prop === :xywz || prop === :rgab) && return VectorShuffle(v, v, 0U, 1U, 3U, 2U)
  (prop === :xz || prop === :rb) && return VectorShuffle(v, v, 0U, 2U)
  (prop === :xzy || prop === :rbg) && return VectorShuffle(v, v, 0U, 2U, 1U)
  (prop === :xzyw || prop === :rbga) && return VectorShuffle(v, v, 0U, 2U, 1U, 3U)
  (prop === :xzw || prop === :rba) && return VectorShuffle(v, v, 0U, 2U, 3U)
  (prop === :xzwy || prop === :rbag) && return VectorShuffle(v, v, 0U, 2U, 3U, 1U)
  (prop === :xw || prop === :ra) && return VectorShuffle(v, v, 0U, 3U)
  (prop === :xwy || prop === :rag) && return VectorShuffle(v, v, 0U, 3U, 1U)
  (prop === :xwyz || prop === :ragb) && return VectorShuffle(v, v, 0U, 3U, 1U, 2U)
  (prop === :xwz || prop === :rab) && return VectorShuffle(v, v, 0U, 3U, 2U)
  (prop === :xwzy || prop === :rabg) && return VectorShuffle(v, v, 0U, 3U, 2U, 1U)
  (prop === :y || prop === :g) && return CompositeExtract(v, 1U)
  (prop === :yx || prop === :gr) && return VectorShuffle(v, v, 1U, 0U)
  (prop === :yxz || prop === :grb) && return VectorShuffle(v, v, 1U, 0U, 2U)
  (prop === :yxzw || prop === :grba) && return VectorShuffle(v, v, 1U, 0U, 2U, 3U)
  (prop === :yxw || prop === :gra) && return VectorShuffle(v, v, 1U, 0U, 3U)
  (prop === :yxwz || prop === :grab) && return VectorShuffle(v, v, 1U, 0U, 3U, 2U)
  (prop === :yz || prop === :gb) && return VectorShuffle(v, v, 1U, 2U)
  (prop === :yzx || prop === :gbr) && return VectorShuffle(v, v, 1U, 2U, 0U)
  (prop === :yzxw || prop === :gbra) && return VectorShuffle(v, v, 1U, 2U, 0U, 3U)
  (prop === :yzw || prop === :gba) && return VectorShuffle(v, v, 1U, 2U, 3U)
  (prop === :yzwx || prop === :gbar) && return VectorShuffle(v, v, 1U, 2U, 3U, 0U)
  (prop === :yw || prop === :ga) && return VectorShuffle(v, v, 1U, 3U)
  (prop === :ywx || prop === :gar) && return VectorShuffle(v, v, 1U, 3U, 0U)
  (prop === :ywxz || prop === :garb) && return VectorShuffle(v, v, 1U, 3U, 0U, 2U)
  (prop === :ywz || prop === :gab) && return VectorShuffle(v, v, 1U, 3U, 2U)
  (prop === :ywzx || prop === :gabr) && return VectorShuffle(v, v, 1U, 3U, 2U, 0U)
  (prop === :z || prop === :b) && return CompositeExtract(v, 2U)
  (prop === :zx || prop === :br) && return VectorShuffle(v, v, 2U, 0U)
  (prop === :zxy || prop === :brg) && return VectorShuffle(v, v, 2U, 0U, 1U)
  (prop === :zxyw || prop === :brga) && return VectorShuffle(v, v, 2U, 0U, 1U, 3U)
  (prop === :zxw || prop === :bra) && return VectorShuffle(v, v, 2U, 0U, 3U)
  (prop === :zxwy || prop === :brag) && return VectorShuffle(v, v, 2U, 0U, 3U, 1U)
  (prop === :zy || prop === :bg) && return VectorShuffle(v, v, 2U, 1U)
  (prop === :zyx || prop === :bgr) && return VectorShuffle(v, v, 2U, 1U, 0U)
  (prop === :zyxw || prop === :bgra) && return VectorShuffle(v, v, 2U, 1U, 0U, 3U)
  (prop === :zyw || prop === :bga) && return VectorShuffle(v, v, 2U, 1U, 3U)
  (prop === :zywx || prop === :bgar) && return VectorShuffle(v, v, 2U, 1U, 3U, 0U)
  (prop === :zw || prop === :ba) && return VectorShuffle(v, v, 2U, 3U)
  (prop === :zwx || prop === :bar) && return VectorShuffle(v, v, 2U, 3U, 0U)
  (prop === :zwxy || prop === :barg) && return VectorShuffle(v, v, 2U, 3U, 0U, 1U)
  (prop === :zwy || prop === :bag) && return VectorShuffle(v, v, 2U, 3U, 1U)
  (prop === :zwyx || prop === :bagr) && return VectorShuffle(v, v, 2U, 3U, 1U, 0U)
  (prop === :w || prop === :a) && return CompositeExtract(v, 3U)
  (prop === :wx || prop === :ar) && return VectorShuffle(v, v, 3U, 0U)
  (prop === :wxy || prop === :arg) && return VectorShuffle(v, v, 3U, 0U, 1U)
  (prop === :wxyz || prop === :argb) && return VectorShuffle(v, v, 3U, 0U, 1U, 2U)
  (prop === :wxz || prop === :arb) && return VectorShuffle(v, v, 3U, 0U, 2U)
  (prop === :wxzy || prop === :arbg) && return VectorShuffle(v, v, 3U, 0U, 2U, 1U)
  (prop === :wy || prop === :ag) && return VectorShuffle(v, v, 3U, 1U)
  (prop === :wyx || prop === :agr) && return VectorShuffle(v, v, 3U, 1U, 0U)
  (prop === :wyxz || prop === :agrb) && return VectorShuffle(v, v, 3U, 1U, 0U, 2U)
  (prop === :wyz || prop === :agb) && return VectorShuffle(v, v, 3U, 1U, 2U)
  (prop === :wyzx || prop === :agbr) && return VectorShuffle(v, v, 3U, 1U, 2U, 0U)
  (prop === :wz || prop === :ab) && return VectorShuffle(v, v, 3U, 2U)
  (prop === :wzx || prop === :abr) && return VectorShuffle(v, v, 3U, 2U, 0U)
  (prop === :wzxy || prop === :abrg) && return VectorShuffle(v, v, 3U, 2U, 0U, 1U)
  (prop === :wzy || prop === :abg) && return VectorShuffle(v, v, 3U, 2U, 1U)
  (prop === :wzyx || prop === :abgr) && return VectorShuffle(v, v, 3U, 2U, 1U, 0U)

  error("type $(typeof(v)) has no field $prop")
end

@noinline function VectorShuffle(x::T, y::T, coords...) where {T<:Vec}
  v = zero(Vec{length(coords),eltype(T)})
  nx = length(x)
  for (i, coord) in enumerate(coords)
    coord < nx ? v[i] = x[coord] : v[i - nx] = y[coord]
  end
  v
end

function setslice!(v::Vec, value, indices...)
  ntuple(i -> setindex!(v, value[i], indices[i]), length(indices))
  value
end

function Base.setproperty!(v::Vec, prop::Symbol, val)
  (prop === :x || prop === :r) && return setindex!(v, val, 0U)
  (prop === :xy || prop === :rg) && return setslice!(v, val, 0U, 1U)
  (prop === :xyz || prop === :rgb) && return setslice!(v, val, 0U, 1U, 2U)
  (prop === :xyzw || prop === :rgba) && return setslice!(v, val, 0U, 1U, 2U, 3U)
  (prop === :xyw || prop === :rga) && return setslice!(v, val, 0U, 1U, 3U)
  (prop === :xywz || prop === :rgab) && return setslice!(v, val, 0U, 1U, 3U, 2U)
  (prop === :xz || prop === :rb) && return setslice!(v, val, 0U, 2U)
  (prop === :xzy || prop === :rbg) && return setslice!(v, val, 0U, 2U, 1U)
  (prop === :xzyw || prop === :rbga) && return setslice!(v, val, 0U, 2U, 1U, 3U)
  (prop === :xzw || prop === :rba) && return setslice!(v, val, 0U, 2U, 3U)
  (prop === :xzwy || prop === :rbag) && return setslice!(v, val, 0U, 2U, 3U, 1U)
  (prop === :xw || prop === :ra) && return setslice!(v, val, 0U, 3U)
  (prop === :xwy || prop === :rag) && return setslice!(v, val, 0U, 3U, 1U)
  (prop === :xwyz || prop === :ragb) && return setslice!(v, val, 0U, 3U, 1U, 2U)
  (prop === :xwz || prop === :rab) && return setslice!(v, val, 0U, 3U, 2U)
  (prop === :xwzy || prop === :rabg) && return setslice!(v, val, 0U, 3U, 2U, 1U)
  (prop === :y || prop === :g) && return setindex!(v, val, 1U)
  (prop === :yx || prop === :gr) && return setslice!(v, val, 1U, 0U)
  (prop === :yxz || prop === :grb) && return setslice!(v, val, 1U, 0U, 2U)
  (prop === :yxzw || prop === :grba) && return setslice!(v, val, 1U, 0U, 2U, 3U)
  (prop === :yxw || prop === :gra) && return setslice!(v, val, 1U, 0U, 3U)
  (prop === :yxwz || prop === :grab) && return setslice!(v, val, 1U, 0U, 3U, 2U)
  (prop === :yz || prop === :gb) && return setslice!(v, val, 1U, 2U)
  (prop === :yzx || prop === :gbr) && return setslice!(v, val, 1U, 2U, 0U)
  (prop === :yzxw || prop === :gbra) && return setslice!(v, val, 1U, 2U, 0U, 3U)
  (prop === :yzw || prop === :gba) && return setslice!(v, val, 1U, 2U, 3U)
  (prop === :yzwx || prop === :gbar) && return setslice!(v, val, 1U, 2U, 3U, 0U)
  (prop === :yw || prop === :ga) && return setslice!(v, val, 1U, 3U)
  (prop === :ywx || prop === :gar) && return setslice!(v, val, 1U, 3U, 0U)
  (prop === :ywxz || prop === :garb) && return setslice!(v, val, 1U, 3U, 0U, 2U)
  (prop === :ywz || prop === :gab) && return setslice!(v, val, 1U, 3U, 2U)
  (prop === :ywzx || prop === :gabr) && return setslice!(v, val, 1U, 3U, 2U, 0U)
  (prop === :z || prop === :b) && return setindex!(v, val, 2U)
  (prop === :zx || prop === :br) && return setslice!(v, val, 2U, 0U)
  (prop === :zxy || prop === :brg) && return setslice!(v, val, 2U, 0U, 1U)
  (prop === :zxyw || prop === :brga) && return setslice!(v, val, 2U, 0U, 1U, 3U)
  (prop === :zxw || prop === :bra) && return setslice!(v, val, 2U, 0U, 3U)
  (prop === :zxwy || prop === :brag) && return setslice!(v, val, 2U, 0U, 3U, 1U)
  (prop === :zy || prop === :bg) && return setslice!(v, val, 2U, 1U)
  (prop === :zyx || prop === :bgr) && return setslice!(v, val, 2U, 1U, 0U)
  (prop === :zyxw || prop === :bgra) && return setslice!(v, val, 2U, 1U, 0U, 3U)
  (prop === :zyw || prop === :bga) && return setslice!(v, val, 2U, 1U, 3U)
  (prop === :zywx || prop === :bgar) && return setslice!(v, val, 2U, 1U, 3U, 0U)
  (prop === :zw || prop === :ba) && return setslice!(v, val, 2U, 3U)
  (prop === :zwx || prop === :bar) && return setslice!(v, val, 2U, 3U, 0U)
  (prop === :zwxy || prop === :barg) && return setslice!(v, val, 2U, 3U, 0U, 1U)
  (prop === :zwy || prop === :bag) && return setslice!(v, val, 2U, 3U, 1U)
  (prop === :zwyx || prop === :bagr) && return setslice!(v, val, 2U, 3U, 1U, 0U)
  (prop === :w || prop === :a) && return setindex!(v, val, 3U)
  (prop === :wx || prop === :ar) && return setslice!(v, val, 3U, 0U)
  (prop === :wxy || prop === :arg) && return setslice!(v, val, 3U, 0U, 1U)
  (prop === :wxyz || prop === :argb) && return setslice!(v, val, 3U, 0U, 1U, 2U)
  (prop === :wxz || prop === :arb) && return setslice!(v, val, 3U, 0U, 2U)
  (prop === :wxzy || prop === :arbg) && return setslice!(v, val, 3U, 0U, 2U, 1U)
  (prop === :wy || prop === :ag) && return setslice!(v, val, 3U, 1U)
  (prop === :wyx || prop === :agr) && return setslice!(v, val, 3U, 1U, 0U)
  (prop === :wyxz || prop === :agrb) && return setslice!(v, val, 3U, 1U, 0U, 2U)
  (prop === :wyz || prop === :agb) && return setslice!(v, val, 3U, 1U, 2U)
  (prop === :wyzx || prop === :agbr) && return setslice!(v, val, 3U, 1U, 2U, 0U)
  (prop === :wz || prop === :ab) && return setslice!(v, val, 3U, 2U)
  (prop === :wzx || prop === :abr) && return setslice!(v, val, 3U, 2U, 0U)
  (prop === :wzxy || prop === :abrg) && return setslice!(v, val, 3U, 2U, 0U, 1U)
  (prop === :wzy || prop === :abg) && return setslice!(v, val, 3U, 2U, 1U)
  (prop === :wzyx || prop === :abgr) && return setslice!(v, val, 3U, 2U, 1U, 0U)
  error("type $(typeof(v)) has no field $prop")
end

Base.propertynames(::Type{<:Vec{1}}) = (:x,)
Base.propertynames(::Type{<:Vec{2}}) = (:x,:y)
Base.propertynames(::Type{<:Vec{3}}) = (:x,:y,:z)
Base.propertynames(::Type{<:Vec{4}}) = (:x,:y,:z,:w)

# Define binary vector operations.
for (f, op) in zip((:+, :-, :*, :/, :rem, :mod), (:Add, :Sub, :Mul, :Div, :Rem, :Mod))
  # Define FAdd, IMul, etc. for vectors of matching type.
  opF, opI = Symbol.((:F, :I), op)

  for (opX, XT) in zip((opF, opI), (:IEEEFloat, :BitInteger))
    @eval @noinline $opX(v1::T, v2::T) where {T<:Vec{<:Any,<:$XT}} = vectorize($f, v1, v2)

    # Allow usage of promotion rules for these operations.
    @eval @noinline $opX(v1::Vec{N,<:$XT}, v2::Vec{N,<:$XT}) where {N} = $opX(promote(v1, v2)...)

    # Define broadcasting rules so that broadcasting eagerly uses the vector instruction when applicable.
    @eval Base.broadcasted(::typeof($f), v1::T, v2::T) where {T<:Vec{<:Any,<:$XT}} = $opX(v1, v2)
  end
end

@eval @noinline Atan2(v1::T, v2::T) where {T<:Vec} = vectorize(atan, v1, v2)
@eval Atan2(v1::Vec{N}, v2::Vec{N}) where {N} = Atan2(promote(v1, v2)...)
@eval Base.broadcasted(::typeof(atan), v1::T, v2::T) where {T<:Vec{<:Any,<:SmallFloat}} = Atan2(v1, v2)

# Define arithmetic operations on vectors.
for f in (:+, :-)
  @eval Base.$f(v1::Vec{N}, v2::Vec{N}) where {N} = broadcast($f, v1, v2)
end

# Define unary vector operations.
for (f, op) in zip((:ceil, :exp), (:Ceil, :Exp))
  @eval @noinline $op(v::Vec) = vectorize($f, v)
  @eval Base.broadcasted(::typeof($f), v::Vec) = $op(v)
end

# CPU implementation for instructions that directly operate on vectors.
vectorize(op, v1::T, v2::T) where {T<:Vec} = Vec(op.(v1.data, v2.data))
vectorize(op, v::T, x::Scalar) where {T<:Vec} = Vec(op.(v.data, x))
vectorize(op, v::T) where {T<:Vec} = Vec(op.(v.data))

Base.:(==)(x::T, y::T) where {T<:Vec} = all(x .== y)
Base.:(==)(x::Vec{N}, y::Vec{N}) where {N} = (==)(promote(x, y)...)
Base.:(==)(x::Vec, y::Vec) = false

Base.any(x::Vec{<:Any,Bool}) = Any(x)
@noinline Any(x::Vec{<:Any,Bool}) = any(x.data)
Base.all(x::Vec{<:Any,Bool}) = All(x)
@noinline All(x::Vec{<:Any,Bool}) = all(x.data)

# Mathematical operators.

import LinearAlgebra: cross

cross(x::Vec{2}, y::Vec{2}) = x.x * y.y - x.y * y.x

# Other utilities

Base.rand(rng::AbstractRNG, sampler::Random.SamplerType{Vec{N,T}}) where {N,T} = Vec{N,T}(rand(rng, NTuple{N,T}))
Base.rand(rng::AbstractRNG, sampler::Random.SamplerType{Vec{N}}) where {N} = rand(rng, Vec{N,Float32})
