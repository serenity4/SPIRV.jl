module SPIRVStaticArraysExt

using Base: IEEEFloat, BitInteger, BitSigned, BitUnsigned
using SPIRV
using SPIRV: @override, unsigned_index, ntuple_uint32
import SPIRV: remap_type,
             Arr, Vec, Mat,
             coltype,
             CompositeExtract, CompositeConstruct,
             FAdd, FSub, FMul, FDiv, FRem, FMod,
             IAdd, ISub, IMul, IDiv, IRem, IMod,
             FConvert, SConvert, ConvertFToS, ConvertFToU, ConvertSToF, ConvertUToF,
             Ceil, Exp, FNegate
using SPIRV.MathFunctions
import LinearAlgebra: norm, normalize, cross, dot
using StaticArrays

for (VT, MT) in zip((:SVector, :MVector), (:SMatrix, :MMatrix))
  # Remap StaticArrays types into SPIR-V types.
  for N in 2:4
    @eval remap_type(::Type{$VT{$N,T}}) where {T} = Vec{$N,T}
    for M in 2:4
      @eval remap_type(::Type{<:$MT{$N,$M,T}}) where {T} = Mat{$N,$M,T}
      @eval coltype(::Type{<:$MT{$N,$M,T}}) where {T} = $VT{$N,T}
    end
  end

  @eval remap_type(::Type{$VT{N,T}}) where {N,T} = Arr{N,T}

  # Define pseudo-intrinsics for conversions between StaticArrays types and SPIR-V types.
  # XXX: Also define SVector <-> MVector (no-op) conversions.

  for N in 2:4
    @eval Base.convert(CT::Type{Vec{$N,T}}, x::$VT{$N}) where {T} = convert_native(CT, x)
    @eval Base.convert(CT::Type{$VT{$N,T}}, x::Vec{$N}) where {T} = convert_native(CT, x)
    @eval Base.convert(CT::Type{Vec{$N}}, x::$VT{$N}) = convert_native(CT, x)
    @eval Base.convert(CT::Type{<:$VT{$N}}, x::Vec{$N}) = convert_native(CT, x)
    for M in 2:4
      @eval Base.convert(CT::Type{Mat{$N,$M,T}}, x::$MT{$N,$M}) where {T} = convert_native(CT, x)
      @eval Base.convert(CT::Type{<:$MT{$N,$M,T}}, x::Mat{$N,$M}) where {T} = convert_native(CT, x)
      @eval Base.convert(CT::Type{Mat{$N,$M}}, x::$MT{$N,$M}) = convert_native(CT, x)
      @eval Base.convert(CT::Type{<:$MT{$N,$M}}, x::Mat{$N,$M}) = convert_native(CT, x)
    end
  end

  @eval Base.convert(CT::Type{Arr{N,T}}, x::$VT{N}) where {N,T} = convert_native(CT, x)
  @eval Base.convert(CT::Type{$VT{N,T}}, x::Arr{N}) where {N,T} = convert_native(CT, x)
  @eval Base.convert(CT::Type{Arr{N}}, x::$VT{N}) where {N} = convert_native(CT, x)
  @eval Base.convert(CT::Type{<:$VT{N}}, x::Arr{N}) where {N} = convert_native(CT, x)

  @eval Base.convert(::Type{Vec}, v::$VT{N,T}) where {N,T} = convert(Vec{N,T}, v)
  @eval Base.convert(::Type{Arr}, v::$VT{N,T}) where {N,T} = convert(Arr{N,T}, v)
  @eval convert_spirv(v::$VT{N}) where {N} = 2 ≤ N ≤ 4 ? convert(Vec, v) : convert(Arr, v)
  @eval Base.convert(::Type{$VT}, v::Vec{N,T}) where {N,T} = convert($VT{N,T}, v)
  @eval Base.convert(::Type{$VT}, v::Arr{N,T}) where {N,T} = convert($VT{N,T}, v)

  @eval Vec(v::$VT) = convert(Vec, v)
  @eval Arr(v::$VT) = convert(Arr, v)
  @eval StaticArrays.$VT(v::Vec) = convert($VT, v)
  @eval StaticArrays.$VT(arr::Arr) = convert($VT, arr)

  ## Implement conversion CPU fallbacks for pseudo-intrinsics. Those definitions are meant for CPU execution.

  for N in 2:4
    @eval @noinline convert_native(::Type{Vec{$N,T}}, x::$VT{$N}) where {T} = Vec{$N,T}(x.data)
    @eval @noinline convert_native(::Type{$VT{$N,T}}, x::Vec{$N}) where {T} = $VT{$N,T}(ntuple(i -> x[i], $N))
    @eval @noinline convert_native(::Type{Vec{$N}}, x::$VT{$N}) = Vec(x.data)
    @eval @noinline convert_native(::Type{<:$VT{$N}}, x::Vec{$N}) = $VT{$N}(ntuple(i -> x[i], $N))
    for M in 2:4
      @eval @noinline convert_native(::Type{Mat{$N,$M,T}}, x::$MT{$N,$M}) where {T} = Mat{$N,$M,T}(Vec{$N,T}.(ntuple(i -> x.data[1 + (i-1)*$N:i*$N], $M))...)
      @eval @noinline convert_native(::Type{<:$MT{$N,$M,T}}, x::Mat{$N,$M}) where {T} = $MT{$N,$M,T}(x.data)
      @eval @noinline convert_native(::Type{Mat{$N,$M}}, x::$MT{$N,$M}) = Mat(Vec.(ntuple(i -> x.data[1 + (i-1)*$N:i*$N], $M))...)
      @eval @noinline convert_native(::Type{<:$MT{$N,$M}}, x::Mat{$N,$M}) = $MT{$N,$M}(x.data)
    end
  end

  @eval @noinline convert_native(::Type{Arr{N,T}}, x::$VT{N}) where {N,T} = Arr{N,T}(x.data)
  @eval @noinline convert_native(::Type{<:$VT{N,T}}, x::Arr{N}) where {N,T} = $VT{N,T}(x.data)
  @eval @noinline convert_native(::Type{Arr{N}}, x::$VT{N}) where {N} = Arr(x.data)
  @eval @noinline convert_native(::Type{<:$VT{N}}, x::Arr{N}) where {N} = $VT{N}(x.data)

  ## Conversions between static vectors of different element type.

  @eval @noinline FConvert(::Type{$VT{N,T}}, v::$VT{N}) where {N,T} = convert_vec($VT{N,T}, v)
  @eval @noinline SConvert(::Type{$VT{N,T}}, v::$VT{N}) where {N,T} = convert_vec($VT{N,T}, v)
  @eval @noinline UConvert(::Type{$VT{N,T}}, v::$VT{N}) where {N,T} = convert_vec($VT{N,T}, v)
  @eval @noinline ConvertSToF(::Type{$VT{N,T}}, v::$VT{N}) where {N,T} = convert_vec($VT{N,T}, v)
  @eval @noinline ConvertUToF(::Type{$VT{N,T}}, v::$VT{N}) where {N,T} = convert_vec($VT{N,T}, v)
  @eval @noinline ConvertFToS(::Type{$VT{N,T}}, v::$VT{N}) where {N,T} = convert_vec($VT{N,T}, v)
  @eval @noinline ConvertFToU(::Type{$VT{N,T}}, v::$VT{N}) where {N,T} = convert_vec($VT{N,T}, v)
  @eval convert_vec(::Type{$VT{N,T}}, v::$VT{N}) where {N,T} = $VT{N,T}(ntuple_uint32(i -> convert(T, @inbounds v[i]), N)...)

  @eval Base.convert(::Type{$VT{N,T}}, v::$VT{N,<:IEEEFloat}) where {N,T<:IEEEFloat} = FConvert($VT{N,T}, v)
  @eval Base.convert(::Type{$VT{N,T}}, v::$VT{N,<:BitSigned}) where {N,T<:BitSigned} = SConvert($VT{N,T}, v)
  @eval Base.convert(::Type{$VT{N,T}}, v::$VT{N,<:BitUnsigned}) where {N,T<:BitUnsigned} = UConvert($VT{N,T}, v)
  @eval Base.convert(::Type{$VT{N,T}}, v::$VT{N,<:BitSigned}) where {N,T<:IEEEFloat} = ConvertSToF($VT{N,T}, v)
  @eval Base.convert(::Type{$VT{N,T}}, v::$VT{N,<:BitUnsigned}) where {N,T<:IEEEFloat} = ConvertUToF($VT{N,T}, v)
  @eval Base.convert(::Type{$VT{N,T}}, v::$VT{N,<:IEEEFloat}) where {N,T<:BitSigned} = ConvertFToS($VT{N,T}, v)
  @eval Base.convert(::Type{$VT{N,T}}, v::$VT{N,<:IEEEFloat}) where {N,T<:BitUnsigned} = ConvertFToU($VT{N,T}, v)
  @eval Base.convert(::Type{$VT{N,T1}}, v::$VT{N,T2}) where {N,T1,T2} = $VT{N,T1}(ntuple_uint32(i -> convert(T1, @inbounds v[i]), N)...)

  ### No-op conversions.
  @eval Base.convert(::Type{$VT{N,T}}, v::$VT{N,T}) where {N,T} = v
  @eval Base.convert(::Type{$VT{N,T}}, v::$VT{N,T}) where {N,T<:Union{IEEEFloat}} = v
  @eval Base.convert(::Type{$VT{N,T}}, v::$VT{N,T}) where {N,T<:Union{BitSigned}} = v
  @eval Base.convert(::Type{$VT{N,T}}, v::$VT{N,T}) where {N,T<:Union{BitUnsigned}} = v

  # Add pseudo-intrinsics for vector access.

  @eval @override Base.getindex(v::$VT, i::Integer) = CompositeExtract(v, unsigned_index(i))
  @eval @override Base.getindex(v::$VT, i::Int) = CompositeExtract(v, UInt32(i))
  @eval @noinline CompositeExtract(v::$VT, index::UInt32) = v.data[index]

  @eval @override $VT{N,T}(components::NTuple{N,T}) where {N,T} = CompositeConstruct($VT{N,T}, components...)
  @eval @noinline (@generated function CompositeConstruct(::Type{$VT{N,T}}, data::T...) where {N,T}
    Expr(:new, $VT{N,T}, :data)
  end)

  ## Work around direct `.data` field access for `SVector`/`MVector` in favor of indexed access.

  @eval @override function Base.getproperty(v::$VT, name::Symbol)
    name === :x && return v[1]
    name === :y && return v[2]
    name === :z && return v[3]
    name === :w && return v[4]
    getfield(v, name)
  end

  # Add vector math pseudo-intrinsics for static arrays.
  for N in 2:4
    for (f, op) in zip((:+, :-, :*, :/, :rem, :mod, :^, :atan), (:Add, :Sub, :Mul, :Div, :Rem, :Mod, :Pow, :Atan2))

      @eval @override Base.$f(x::$VT{$N}, y::$VT{$N}) = $f(promote(x, y)...)
      @eval Base.$f(v1::$VT{$N}, v2::Vec{$N}) = $f(promote(v1, v2)...)
      @eval Base.$f(v1::Vec{$N}, v2::$VT{$N}) = $f(promote(v1, v2)...)
      @eval Base.$f(v1::$VT{$N}, v2::Arr{$N}) = $f(promote(v1, v2)...)
      @eval Base.$f(v1::Arr{$N}, v2::$VT{$N}) = $f(promote(v1, v2)...)

      ops, XTs = if in(op, (:Pow, :Atan2))
        @eval @override Base.$f(x::$VT{$N,T}, y::$VT{$N,T}) where {T<:IEEEFloat} = $op(x, y)
        (op,), (:IEEEFloat,)
      else
        opF, opI = Symbol.((:F, :I), op)
        # Define FAdd, IMul, etc. for vectors of matching type.
        @eval @override Base.$f(x::$VT{$N,T}, y::$VT{$N,T}) where {T<:IEEEFloat} = $opF(x, y)
        @eval @override Base.$f(x::$VT{$N,T}, y::$VT{$N,T}) where {T<:BitInteger} = $opI(x, y)

        (opF, opI), (:IEEEFloat, :BitInteger)
      end

      for (opX, XT) in zip(ops, XTs)
        @eval @override Base.$f(x::$VT{$N,<:$XT}, y::$VT{$N,<:$XT}) = $opX(x, y)

        @eval @noinline $opX(v1::T, v2::T) where {T<:$VT{$N,<:$XT}} = vectorize($f, v1, v2)

        # Allow usage of promotion rules for these operations.
        @eval $opX(v1::$VT{$N,<:$XT}, v2::$VT{$N,<:$XT}) = $opX(promote(v1, v2)...)

        # Define broadcasting rules so that broadcasting eagerly uses the vector instruction when applicable.
        @eval Base.broadcasted(::typeof($f), v1::T, v2::T) where {T<:$VT{$N,<:$XT}} = $opX(v1, v2)
      end
    end

    # Linear algebra operations.
    for (f, op, code) in zip((:dot,), (:Dot,), (:(sum(v1 * v2)),))
      @eval @override $f(v1::$VT{$N,T}, v2::$VT{$N,T}) where {T<:IEEEFloat} = $op(promote(v1, v2)...)
      @eval $f(v1::$VT{$N}, v2::Vec{$N}) = $f(promote(v1, v2)...)
      @eval $f(v1::Vec{$N}, v2::$VT{$N}) = $f(promote(v1, v2)...)
      @eval @noinline $op(v1::T, v2::T) where {T<:$VT{$N,<:IEEEFloat}} = $code

      # Allow usage of promotion rules for these operations.
      @eval $op(v1::$VT{$N,<:$IEEEFloat}, v2::$VT{$N,<:$IEEEFloat}) = $op(promote(v1, v2)...)
    end
  end

  ## Unary vector operations.
  for (f, op) in zip((:ceil, :exp, :-), (:Ceil, :Exp, :FNegate))
    @eval @noinline $op(v::$VT) = vectorize($f, v)
    @eval @override Base.broadcasted(::typeof($f), v::$VT) = $op(v)
    @eval @override Base.$f(v::$VT) = $op(v)
  end

  ## CPU implementation for instructions that directly operate on vectors.
  @eval vectorize(op, v1::T, v2::T) where {T<:$VT} = $VT(op.(v1.data, v2.data))
  @eval vectorize(op, v::T, x::Scalar) where {T<:$VT} = $VT(op.(v.data, x))
  @eval vectorize(op, v::T) where {T<:$VT} = $VT(op.(v.data))
end


# Forward methods to `Vec`/`Arr` instances.
# XXX: Don't do that, and instead support methods on static arrays to avoid pointless conversions between mutable/non-mutable objects.

@override normalize(x::StaticVector) = SVector(normalize(convert_spirv(x)))
@override norm(x::StaticVector) = norm(convert_spirv(x))
@override Base.:(==)(x::StaticVector, y::StaticVector) = convert_spirv(x) == convert_spirv(y)
@override Base.any(x::SVector{<:Any,Bool}) = any(convert_spirv(x))
@override Base.all(x::SVector{<:Any,Bool}) = all(convert_spirv(x))

Base.promote_rule(::Type{Vec{N,T1}}, ::Type{SVector{N,T2}}) where {N,T1,T2} = SVector{N,promote_type(T1,T2)}
Base.promote_rule(::Type{Vec{N,T1}}, ::Type{MVector{N,T2}}) where {N,T1,T2} = Vec{N,promote_type(T1,T2)}
Base.promote_rule(::Type{Arr{N,T1}}, ::Type{SVector{N,T2}}) where {N,T1,T2} = SVector{N,promote_type(T1,T2)}
Base.promote_rule(::Type{Arr{N,T1}}, ::Type{MVector{N,T2}}) where {N,T1,T2} = Arr{N,promote_type(T1,T2)}

end
