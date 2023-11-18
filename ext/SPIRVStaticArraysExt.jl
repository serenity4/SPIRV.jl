module SPIRVStaticArraysExt

using Base: IEEEFloat, BitInteger, BitSigned, BitUnsigned
using SPIRV
using SPIRV: @override
using SPIRV.MathFunctions
import LinearAlgebra: norm, normalize
using StaticArrays

# Remap StaticArrays types into SPIR-V types.

for N in 2:4
  @eval SPIRV.remap_type(::Type{SVector{$N,T}}) where {T} = Vec{$N,T}
  for M in 2:4
    @eval SPIRV.remap_type(::Type{<:SMatrix{$N,$M,T}}) where {T} = Mat{$N,$M,T}
  end
end

@eval SPIRV.remap_type(::Type{SVector{N,T}}) where {N,T} = Arr{N,T}

# Define pseudo-intrinsics for conversions between StaticArrays types and SPIR-V types.

for N in 2:4
  @eval Base.convert(CT::Type{Vec{$N,T}}, x::SVector{$N}) where {T} = convert_native(CT, x)
  @eval Base.convert(CT::Type{SVector{$N,T}}, x::Vec{$N}) where {T} = convert_native(CT, x)
  @eval Base.convert(CT::Type{Vec{$N}}, x::SVector{$N}) = convert_native(CT, x)
  @eval Base.convert(CT::Type{<:SVector{$N}}, x::Vec{$N}) = convert_native(CT, x)
  for M in 2:4
    @eval Base.convert(CT::Type{Mat{$N,$M,T}}, x::SMatrix{$N,$M}) where {T} = convert_native(CT, x)
    @eval Base.convert(CT::Type{<:SMatrix{$N,$M,T}}, x::Mat{$N,$M}) where {T} = convert_native(CT, x)
    @eval Base.convert(CT::Type{Mat{$N,$M}}, x::SMatrix{$N,$M}) = convert_native(CT, x)
    @eval Base.convert(CT::Type{<:SMatrix{$N,$M}}, x::Mat{$N,$M}) = convert_native(CT, x)
  end
end

Base.convert(CT::Type{Arr{N,T}}, x::SVector{N}) where {N,T} = convert_native(CT, x)
Base.convert(CT::Type{SVector{N,T}}, x::Arr{N}) where {N,T} = convert_native(CT, x)
Base.convert(CT::Type{Arr{N}}, x::SVector{N}) where {N} = convert_native(CT, x)
Base.convert(CT::Type{<:SVector{N}}, x::Arr{N}) where {N} = convert_native(CT, x)

Base.convert(::Type{Vec}, v::SVector{N,T}) where {N,T} = convert(Vec{N,T}, v)
Base.convert(::Type{Arr}, v::SVector{N,T}) where {N,T} = convert(Arr{N,T}, v)
convert_spirv(v::SVector{N}) where {N} = 2 ≤ N ≤ 4 ? convert(Vec, v) : convert(Arr, v)
Base.convert(::Type{SVector}, v::Vec{N,T}) where {N,T} = convert(SVector{N,T}, v)
Base.convert(::Type{SVector}, v::Arr{N,T}) where {N,T} = convert(SVector{N,T}, v)

SPIRV.Vec(v::SVector) = convert(Vec, v)
SPIRV.Arr(v::SVector) = convert(Arr, v)
StaticArrays.SVector(v::Vec) = convert(SVector, v)
StaticArrays.SVector(arr::Arr) = convert(SVector, arr)

## Implement conversion CPU fallbacks for pseudo-intrinsics. Those definitions are meant for CPU execution.

for N in 2:4
  @eval @noinline convert_native(::Type{Vec{$N,T}}, x::SVector{$N}) where {T} = Vec{$N,T}(x.data)
  @eval @noinline convert_native(::Type{SVector{$N,T}}, x::Vec{$N}) where {T} = SVector{$N,T}(ntuple(i -> x[i], $N))
  @eval @noinline convert_native(::Type{Vec{$N}}, x::SVector{$N}) = Vec(x.data)
  @eval @noinline convert_native(::Type{<:SVector{$N}}, x::Vec{$N}) = SVector{$N}(ntuple(i -> x[i], $N))
  for M in 2:4
    @eval @noinline convert_native(::Type{Mat{$N,$M,T}}, x::SMatrix{$N,$M}) where {T} = Mat{$N,$M,T}(Vec{$N,T}.(ntuple(i -> x.data[1 + (i-1)*$N:i*$N], $M))...)
    @eval @noinline convert_native(::Type{<:SMatrix{$N,$M,T}}, x::Mat{$N,$M}) where {T} = SMatrix{$N,$M,T}(x.data)
    @eval @noinline convert_native(::Type{Mat{$N,$M}}, x::SMatrix{$N,$M}) = Mat(Vec.(ntuple(i -> x.data[1 + (i-1)*$N:i*$N], $M))...)
    @eval @noinline convert_native(::Type{<:SMatrix{$N,$M}}, x::Mat{$N,$M}) = SMatrix{$N,$M}(x.data)
  end
end

@noinline convert_native(::Type{Arr{N,T}}, x::SVector{N}) where {N,T} = Arr{N,T}(x.data)
@noinline convert_native(::Type{<:SVector{N,T}}, x::Arr{N}) where {N,T} = SVector{N,T}(x.data)
@noinline convert_native(::Type{Arr{N}}, x::SVector{N}) where {N} = Arr(x.data)
@noinline convert_native(::Type{<:SVector{N}}, x::Arr{N}) where {N} = SVector{N}(x.data)

## Conversions between static vectors of different element type.

@noinline SPIRV.FConvert(::Type{SVector{N,T}}, v::SVector{N}) where {N,T} = convert_vec(SVector{N,T}, v)
@noinline SPIRV.SConvert(::Type{SVector{N,T}}, v::SVector{N}) where {N,T} = convert_vec(SVector{N,T}, v)
@noinline SPIRV.UConvert(::Type{SVector{N,T}}, v::SVector{N}) where {N,T} = convert_vec(SVector{N,T}, v)
@noinline SPIRV.ConvertSToF(::Type{SVector{N,T}}, v::SVector{N}) where {N,T} = convert_vec(SVector{N,T}, v)
@noinline SPIRV.ConvertUToF(::Type{SVector{N,T}}, v::SVector{N}) where {N,T} = convert_vec(SVector{N,T}, v)
@noinline SPIRV.ConvertFToS(::Type{SVector{N,T}}, v::SVector{N}) where {N,T} = convert_vec(SVector{N,T}, v)
@noinline SPIRV.ConvertFToU(::Type{SVector{N,T}}, v::SVector{N}) where {N,T} = convert_vec(SVector{N,T}, v)
convert_vec(::Type{SVector{N,T}}, v::SVector{N}) where {N,T} = SVector{N,T}(SPIRV.ntuple_uint32(i -> convert(T, @inbounds v[i]), N)...)

Base.convert(::Type{SVector{N,T}}, v::SVector{N,<:IEEEFloat}) where {N,T<:IEEEFloat} = SPIRV.FConvert(SVector{N,T}, v)
Base.convert(::Type{SVector{N,T}}, v::SVector{N,<:BitSigned}) where {N,T<:BitSigned} = SPIRV.SConvert(SVector{N,T}, v)
Base.convert(::Type{SVector{N,T}}, v::SVector{N,<:BitUnsigned}) where {N,T<:BitUnsigned} = SPIRV.UConvert(SVector{N,T}, v)
Base.convert(::Type{SVector{N,T}}, v::SVector{N,<:BitSigned}) where {N,T<:IEEEFloat} = SPIRV.ConvertSToF(SVector{N,T}, v)
Base.convert(::Type{SVector{N,T}}, v::SVector{N,<:BitUnsigned}) where {N,T<:IEEEFloat} = SPIRV.ConvertUToF(SVector{N,T}, v)
Base.convert(::Type{SVector{N,T}}, v::SVector{N,<:IEEEFloat}) where {N,T<:BitSigned} = SPIRV.ConvertFToS(SVector{N,T}, v)
Base.convert(::Type{SVector{N,T}}, v::SVector{N,<:IEEEFloat}) where {N,T<:BitUnsigned} = SPIRV.ConvertFToU(SVector{N,T}, v)
Base.convert(::Type{SVector{N,T1}}, v::SVector{N,T2}) where {N,T1,T2} = SVector{N,T1}(ntuple_uint32(i -> convert(T1, @inbounds v[i]), N)...)

### No-op conversions.
Base.convert(::Type{SVector{N,T}}, v::SVector{N,T}) where {N,T} = v
Base.convert(::Type{SVector{N,T}}, v::SVector{N,T}) where {N,T<:Union{IEEEFloat}} = v
Base.convert(::Type{SVector{N,T}}, v::SVector{N,T}) where {N,T<:Union{BitSigned}} = v
Base.convert(::Type{SVector{N,T}}, v::SVector{N,T}) where {N,T<:Union{BitUnsigned}} = v

# Add pseudo-intrinsics for vector access.

for V in (:SVector, :MVector)
  @eval @override Base.getindex(v::$V, i::Integer) = SPIRV.CompositeExtract(v, SPIRV.unsigned_index(i))
  @eval @override Base.getindex(v::$V, i::Int) = SPIRV.CompositeExtract(v, UInt32(i))
  @eval @noinline SPIRV.CompositeExtract(v::$V, index::UInt32) = v.data[index]
end

# Add vector math pseudo-intrinsics for static arrays.

for N in 2:4
  for (f, op) in zip((:+, :-, :*, :/, :rem, :mod), (:Add, :Sub, :Mul, :Div, :Rem, :Mod))
    # Define FAdd, IMul, etc. for vectors of matching type.
    opF, opI = Symbol.((:F, :I), op)

    @eval @override Base.$f(x::SVector{$N,T}, y::SVector{$N,T}) where {T<:IEEEFloat} = SPIRV.$opF(x, y)
    @eval @override Base.$f(x::SVector{$N,T}, y::SVector{$N,T}) where {T<:BitInteger} = SPIRV.$opI(x, y)
    @eval @override Base.$f(x::SVector{$N}, y::SVector{$N}) = $f(promote(x, y)...)

    for (opX, XT) in zip((opF, opI), (:IEEEFloat, :BitInteger))
      @eval @override Base.$f(x::SVector{$N,<:$XT}, y::SVector{$N,<:$XT}) = SPIRV.$opX(x, y)

      @eval @noinline SPIRV.$opX(v1::T, v2::T) where {T<:SVector{$N,<:$XT}} = vectorize($f, v1, v2)

      # Allow usage of promotion rules for these operations.
      @eval SPIRV.$opX(v1::SVector{$N,<:$XT}, v2::SVector{$N,<:$XT}) = SPIRV.$opX(promote(v1, v2)...)

      # Define broadcasting rules so that broadcasting eagerly uses the vector instruction when applicable.
      @eval Base.broadcasted(::typeof($f), v1::T, v2::T) where {T<:SVector{$N,<:$XT}} = SPIRV.$opX(v1, v2)
    end
  end
end

## CPU implementation for instructions that directly operate on vectors.
vectorize(op, v1::T, v2::T) where {T<:SVector} = SVector(op.(v1.data, v2.data))
vectorize(op, v::T, x::Scalar) where {T<:SVector} = SVector(op.(v.data, x))
vectorize(op, v::T) where {T<:SVector} = Vec(op.(v.data))

# Forward methods to `Vec`/`Arr` instances.

@override normalize(x::StaticVector) = SVector(normalize(convert_spirv(x)))
@override norm(x::StaticVector) = norm(convert_spirv(x))
@override Base.:(==)(x::StaticVector, y::StaticVector) = convert_spirv(x) == convert_spirv(y)
@override Base.any(x::SVector{<:Any,Bool}) = any(convert_spirv(x))
@override Base.all(x::SVector{<:Any,Bool}) = all(convert_spirv(x))

Base.promote_rule(::Type{Vec{N,T1}}, ::Type{SVector{N,T2}}) where {N,T1,T2} = SVector{N,promote_type(T1,T2)}
Base.promote_rule(::Type{Vec{N,T1}}, ::Type{MVector{N,T2}}) where {N,T1,T2} = Vec{N,promote_type(T1,T2)}

end
