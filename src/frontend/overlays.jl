const FloatScalarOrVec = Union{IEEEFloat, Vec{<:Any,IEEEFloat}}

@MethodTable INTRINSICS_METHOD_TABLE
@MethodTable INTRINSICS_GLSL_METHOD_TABLE

"""
Declare a new method as part of the intrinsics method table.

This new method declaration should override a method from `Base`,
typically one that would call core intrinsics. Its body typically
consists of one or more calls to declared intrinsic functions (see [`@intrinsic`](@ref)).

The method will always be inlined.
"""
macro override(ex)
  esc(:($SPIRV.@overlay $SPIRV.INTRINSICS_METHOD_TABLE @inline $ex))
end

macro override_glsl(ex)
  esc(:($SPIRV.@overlay $SPIRV.INTRINSICS_GLSL_METHOD_TABLE @inline $ex))
end

##### Core SPIR-V intrinsics.

@override reinterpret(::Type{T}, x) where {T} = Bitcast(T, x)
@override reinterpret(::Type{T}, x::T) where {T} = x

@override (-)(x::FloatScalarOrVec)                     = FNegate(x)
@override (+)(x::T, y::T) where {T<:FloatScalarOrVec}  = FAdd(x, y)
@override (*)(x::T, y::T) where {T<:FloatScalarOrVec}  = FMul(x, y)
@override (-)(x::T, y::T) where {T<:FloatScalarOrVec}  = FSub(x, y)
@override (/)(x::T, y::T) where {T<:FloatScalarOrVec}  = FDiv(x, y)
@override rem(x::T, y::T) where {T<:FloatScalarOrVec}  = FRem(x, y)
@override mod(x::T, y::T) where {T<:FloatScalarOrVec} = FMod(x, y)
@override muladd(x::T, y::T, z::T) where {T<:IEEEFloat} = FAdd(FMul(x, y), z)
@override (==)(x::T, y::T) where {T<:IEEEFloat}              = FOrdEqual(x, y)
@override (!=)(x::T, y::T) where {T<:IEEEFloat}              = FUnordNotEqual(x, y)
@override (<)(x::T, y::T) where {T<:IEEEFloat}               = FOrdLessThan(x, y)
@override (<=)(x::T, y::T) where {T<:IEEEFloat}              = FOrdLessThanEqual(x, y)

@override function isequal(x::T, y::T) where {T<:IEEEFloat}
  IT = Base.inttype(T)
  xi = reinterpret(IT, x)
  yi = reinterpret(IT, y)
  FUnordEqual(x, x) & FUnordEqual(y, y) | IEqual(xi, yi)
end

@override isnan(x::IEEEFloat)    = IsNan(x)
@override isinf(x::IEEEFloat) = IsInf(x)
@override isfinite(x::IEEEFloat) = !isinf(x)

@override Float16(x::Float32) = FConvert(Float16, x)
@override Float16(x::Float64) = FConvert(Float16, x)
@override Float32(x::Float16) = FConvert(Float32, x)
@override Float32(x::Float64) = FConvert(Float32, x)
@override Float64(x::Float16) = FConvert(Float64, x)
@override Float64(x::Float32) = FConvert(Float64, x)

@override unsafe_trunc(::Type{T}, x::IEEEFloat) where {T<:BitSigned} = ConvertFToS(T, x)
@override unsafe_trunc(::Type{T}, x::IEEEFloat) where {T<:BitUnsigned} = ConvertFToU(T, x)
@override (::Type{T})(x::BitSigned) where {T<:IEEEFloat} = ConvertSToF(T, x)
@override (::Type{T})(x::BitUnsigned) where {T<:IEEEFloat} = ConvertUToF(T, x)
@override (::Type{T})(x::Bool) where {T<:IEEEFloat} = ifelse(x, one(T), zero(T))
@override trunc(::Type{T}, x::IEEEFloat) where {T<:BitInteger} = unsafe_trunc(T, x)
@override (::Type{T})(x::IEEEFloat) where {T<:BitInteger} = unsafe_trunc(T, x)
@override trunc(x::IEEEFloat) = round(x, RoundToZero)

# Integers.

## Integer conversions.

@inline @override Core.toUInt8(x::BitInteger) = rem(x, UInt8)
@inline @override Core.toUInt16(x::BitInteger) = rem(x, UInt16)
@inline @override Core.toUInt32(x::BitInteger) = rem(x, UInt32)
@inline @override Core.toUInt64(x::BitInteger) = rem(x, UInt64)
@inline @override Core.toInt8(x::BitInteger) = rem(x, Int8)
@inline @override Core.toInt16(x::BitInteger) = rem(x, Int16)
@inline @override Core.toInt32(x::BitInteger) = rem(x, Int32)
@inline @override Core.toInt64(x::BitInteger) = rem(x, Int64)

@override rem(x::UInt8,  ::Type{UInt16}) = UConvert(UInt16, x)
@override rem(x::UInt8,  ::Type{UInt32}) = UConvert(UInt32, x)
@override rem(x::UInt8,  ::Type{UInt64}) = UConvert(UInt64, x)
@override rem(x::UInt16, ::Type{UInt8})  = UConvert(UInt8, x)
@override rem(x::UInt16, ::Type{UInt32}) = UConvert(UInt32, x)
@override rem(x::UInt16, ::Type{UInt64}) = UConvert(UInt64, x)
@override rem(x::UInt32, ::Type{UInt8})  = UConvert(UInt8, x)
@override rem(x::UInt32, ::Type{UInt16}) = UConvert(UInt16, x)
@override rem(x::UInt32, ::Type{UInt64}) = UConvert(UInt64, x)
@override rem(x::UInt64, ::Type{UInt8})  = UConvert(UInt8, x)
@override rem(x::UInt64, ::Type{UInt16}) = UConvert(UInt16, x)
@override rem(x::UInt64, ::Type{UInt32}) = UConvert(UInt32, x)

@override rem(x::Int8,  ::Type{Int16}) = SConvert(Int16, x)
@override rem(x::Int8,  ::Type{Int32}) = SConvert(Int32, x)
@override rem(x::Int8,  ::Type{Int64}) = SConvert(Int64, x)
@override rem(x::Int16, ::Type{Int8})  = SConvert(Int8, x)
@override rem(x::Int16, ::Type{Int32}) = SConvert(Int32, x)
@override rem(x::Int16, ::Type{Int64}) = SConvert(Int64, x)
@override rem(x::Int32, ::Type{Int8})  = SConvert(Int8, x)
@override rem(x::Int32, ::Type{Int16}) = SConvert(Int16, x)
@override rem(x::Int32, ::Type{Int64}) = SConvert(Int64, x)
@override rem(x::Int64, ::Type{Int8})  = SConvert(Int8, x)
@override rem(x::Int64, ::Type{Int16}) = SConvert(Int16, x)
@override rem(x::Int64, ::Type{Int32}) = SConvert(Int32, x)


@override rem(x::Int8,  ::Type{UInt16}) = UConvert(UInt16, x)
@override rem(x::Int8,  ::Type{UInt32}) = UConvert(UInt32, x)
@override rem(x::Int8,  ::Type{UInt64}) = UConvert(UInt64, x)
@override rem(x::Int16, ::Type{UInt8})  = UConvert(UInt8, x)
@override rem(x::Int16, ::Type{UInt32}) = UConvert(UInt32, x)
@override rem(x::Int16, ::Type{UInt64}) = UConvert(UInt64, x)
@override rem(x::Int32, ::Type{UInt8})  = UConvert(UInt8, x)
@override rem(x::Int32, ::Type{UInt16}) = UConvert(UInt16, x)
@override rem(x::Int32, ::Type{UInt64}) = UConvert(UInt64, x)
@override rem(x::Int64, ::Type{UInt8})  = UConvert(UInt8, x)
@override rem(x::Int64, ::Type{UInt16}) = UConvert(UInt16, x)
@override rem(x::Int64, ::Type{UInt32}) = UConvert(UInt32, x)

@override rem(x::UInt8,  ::Type{Int16}) = SConvert(Int16, x)
@override rem(x::UInt8,  ::Type{Int32}) = SConvert(Int32, x)
@override rem(x::UInt8,  ::Type{Int64}) = SConvert(Int64, x)
@override rem(x::UInt16, ::Type{Int8})  = SConvert(Int8, x)
@override rem(x::UInt16, ::Type{Int32}) = SConvert(Int32, x)
@override rem(x::UInt16, ::Type{Int64}) = SConvert(Int64, x)
@override rem(x::UInt32, ::Type{Int8})  = SConvert(Int8, x)
@override rem(x::UInt32, ::Type{Int16}) = SConvert(Int16, x)
@override rem(x::UInt32, ::Type{Int64}) = SConvert(Int64, x)
@override rem(x::UInt64, ::Type{Int8})  = SConvert(Int8, x)
@override rem(x::UInt64, ::Type{Int16}) = SConvert(Int16, x)
@override rem(x::UInt64, ::Type{Int32}) = SConvert(Int32, x)

@override rem(x::T, y::T) where {T<:BitSigned} = SRem(x, y)
@override rem(x::T, y::T) where {T<:BitUnsigned} = SRem(x, y)
@override Int(x::Ptr) = reinterpret(Int, x)
@override UInt(x::Ptr) = reinterpret(UInt, x)

@override (<)(x::T, y::T) where {T<:BitSigned} = SLessThan(x, y)
@override (<=)(x::T, y::T) where {T<:BitSigned} = SLessThanEqual(x, y)
@override (<)(x::T, y::T) where {T<:BitUnsigned} = ULessThan(x, y)
@override (<=)(x::T, y::T) where {T<:BitUnsigned} = ULessThanEqual(x, y)
@override (==)(x::T, y::T) where {T<:BitInteger}       = IEqual(x, y)
@override (==)(x::BitInteger, y::BitInteger)           = ==(promote(x, y)...)
@override (!=)(x::T, y::T) where {T<:BitInteger}       = INotEqual(x, y)
@override (!=)(x::BitInteger, y::BitInteger)           = !=(promote(x, y)...)
@override (~)(x::BitInteger)                           = Not(x)
@override (&)(x::T, y::T) where {T<:BitInteger}        = BitwiseAnd(x, y)
@override (|)(x::T, y::T) where {T<:BitInteger}        = BitwiseOr(x, y)
@override xor(x::T, y::T) where {T<:BitInteger}        = BitwiseXor(x, y)
@override (>>)(x::BitSigned, y::BitUnsigned) = ShiftRightArithmetic(x, y)
@override (>>)(x::BitUnsigned, y::BitUnsigned) = ShiftRightLogical(x, y)
@override (>>>)(x::BitInteger, y::BitUnsigned) = ShiftRightLogical(x, y)
@override (<<)(x::BitInteger, y::BitUnsigned) = ShiftLeftLogical(x, y)
@override (-)(x::BitInteger) = SNegate(x)
@override (+)(x::T, y::T) where {T<:BitInteger} = IAdd(x, y)
@override (-)(x::T, y::T) where {T<:BitInteger} = ISub(x, y)
@override (*)(x::T, y::T) where {T<:BitInteger} = IMul(x, y)
@override div(x::T, y::T) where {T<:BitUnsigned} = UDiv(x, y)

@override ifelse(cond::Bool, x, y) = Select(cond, x, y)

@override flipsign(x::T, y::T) where {T<:BitSigned} = Select(y ≥ 0, x, -x)
@override flipsign(x::BitSigned, y::BitSigned) = flipsign(promote(x, y)...) % typeof(x)

@override trailing_zeros(x::Integer) = Int(trailing_zeros_emulated(x))
@override leading_zeros(x::Integer) = Int(leading_zeros_emulated(x))

@override (!)(x::Bool)           = LogicalNot(x)
@override (&)(x::Bool, y::Bool)  = LogicalAnd(x, y)
@override (|)(x::Bool, y::Bool)  = LogicalOr(x, y)
@override xor(x::Bool, y::Bool)  = BitwiseXor(x, y)
@override (==)(x::Bool, y::Bool) = LogicalEqual(x, y)
@override (!=)(x::Bool, y::Bool) = LogicalNotEqual(x, y)

# Copying.

## Deep copying and shallow copying should be defined identically here, because of how
## mutable objects are treated in SPIR-V (as pointers to immutable objects).

# Deepcopy has only one implementation and relies on `deepcopy_internal` with consistent semantics.
@override deepcopy(x) = CopyObject(x)
# XXX: This overrides all definitions of `copy` for the purpose of method lookup and therefore breaks a few things.
# @override copy(x) = CopyObject(x)

@override copysign(x::T, y::T) where {T <: Union{Float32, Float64}} = ifelse(y < 0, -x, x)

# Reduce the complexity of Julia IR by emitting simpler definitions.

## Skip boundscheck to avoid leaving dead nodes and branches in the CFG.

@override getindex(x::Number, i::Integer) = x

# Miscellaneous Base methods which use intrinsics that don't map well to SPIR-V.

# Math functions using intrinsics directly.

@override function Base.Math.two_mul(x::Float64, y::Float64)
  if have_fma(Float64)
      xy = x*y
      xy, fma(x, y, -xy)
  end
  Base.twomul(x,y)
end

# Vectors/arrays/matrices/pointers.

@override getindex(v::Vector, index::Integer) = AccessChain(v, unsigned_index(index))[]
@override setindex!(v::Vector{T}, value::T, index::Integer) where {T} = Store(AccessChain(v, unsigned_index(index)), value)

@override Base.:(==)(x::T, y::T) where {VT<:IEEEFloat,T<:Vec{<:Any,VT}} = All(FOrdEqual(x, y))
@override Base.:(==)(x::T, y::T) where {VT<:BitInteger,T<:Vec{<:Any,VT}} = All(IEqual(x, y))
@override Base.:(==)(x::Vec{N}, y::Vec{N}) where {N} = (==)(promote(x, y)...)
@override Base.:(==)(::Vec, ::Vec) = false
@override Base.:(==)(x::Vec, y::AbstractVector) = (==)(promote(x, y)...)
@override Base.:(==)(x::AbstractVector, y::Vec) = (==)(promote(x, y)...)
@override Base.any(x::Vec{<:Any,Bool}) = Any(x)
@override Base.all(x::Vec{<:Any,Bool}) = All(x)

@override Tuple(x::Vec) = ntuple_uint32(i -> x[i], length(x))
@override Base.convert(::Type{Vec{N,T}}, v::Vec{N,<:IEEEFloat}) where {N,T<:IEEEFloat} = FConvert(Vec{N,T}, v)
@override Base.convert(::Type{Vec{N,T}}, v::Vec{N,<:BitSigned}) where {N,T<:BitSigned} = SConvert(Vec{N,T}, v)
@override Base.convert(::Type{Vec{N,T}}, v::Vec{N,<:BitUnsigned}) where {N,T<:BitUnsigned} = UConvert(Vec{N,T}, v)
@override Base.convert(::Type{Vec{N,T}}, v::Vec{N,<:BitSigned}) where {N,T<:IEEEFloat} = ConvertSToF(Vec{N,T}, v)
@override Base.convert(::Type{Vec{N,T}}, v::Vec{N,<:BitUnsigned}) where {N,T<:IEEEFloat} = ConvertUToF(Vec{N,T}, v)
@override Base.convert(::Type{Vec{N,T}}, v::Vec{N,<:IEEEFloat}) where {N,T<:BitSigned} = ConvertFToS(Vec{N,T}, v)
@override Base.convert(::Type{Vec{N,T}}, v::Vec{N,<:IEEEFloat}) where {N,T<:BitUnsigned} = ConvertFToU(Vec{N,T}, v)
@override Base.convert(::Type{Vec{N,T1}}, v::Vec{N,T2}) where {N,T1,T2} = Vec{N,T1}(ntuple_uint32(i -> convert(T1, @inbounds v[i]), N)...)
@override Base.convert(::Type{Vec{N,T}}, v::Vec{N,T}) where {N,T} = v
@override Base.convert(::Type{Vec{N,T}}, v::Vec{N,T}) where {N,T<:Union{IEEEFloat}} = v
@override Base.convert(::Type{Vec{N,T}}, v::Vec{N,T}) where {N,T<:Union{BitSigned}} = v
@override Base.convert(::Type{Vec{N,T}}, v::Vec{N,T}) where {N,T<:Union{BitUnsigned}} = v

@override Base.getindex(v::Vec, i::Integer) = CompositeExtract(v, unsigned_index(i))
@override Base.getindex(v::Vec, i::Int) = CompositeExtract(v, UInt32(i))
@override Vec{N,T}(components::NTuple{N,T}) where {N,T} = CompositeConstruct(Vec{N,T}, components...)

@override function Base.getproperty(v::Vec, name::Symbol)
  name === :x && return v[1]
  name === :y && return v[2]
  name === :z && return v[3]
  name === :w && return v[4]
  getfield(v, name)
end

@override (+)(x::Vec{N}, y::Vec{N})  where {N} = (+)(promote(x, y)...)
@override (-)(x::Vec{N}, y::Vec{N})  where {N} = (-)(promote(x, y)...)
@override (*)(x::Vec{N}, y::Vec{N})  where {N} = (*)(promote(x, y)...)
@override (/)(x::Vec{N}, y::Vec{N})  where {N} = (/)(promote(x, y)...)
@override rem(x::Vec{N}, y::Vec{N})  where {N} = rem(promote(x, y)...)
@override mod(x::Vec{N}, y::Vec{N})  where {N} = mod(promote(x, y)...)
@override ^(x::Vec{N}, y::Vec{N})    where {N} = ^(promote(x, y)...)
@override atan(x::Vec{N}, y::Vec{N}) where {N} = atan(promote(x, y)...)

@override (+)(x::V, y::V)  where {V<:Vec{<:Any,<:IEEEFloat}} = FAdd(x, y)
@override (+)(x::V, y::V)  where {V<:Vec{<:Any,<:BitInteger}} = IAdd(x, y)
@override (-)(x::V, y::V)  where {V<:Vec{<:Any,<:IEEEFloat}} = FSub(x, y)
@override (-)(x::V, y::V)  where {V<:Vec{<:Any,<:BitInteger}} = ISub(x, y)
@override (*)(x::V, y::V)  where {V<:Vec{<:Any,<:IEEEFloat}} = FMul(x, y)
@override (*)(x::V, y::V)  where {V<:Vec{<:Any,<:BitInteger}} = IMul(x, y)
@override (/)(x::V, y::V)  where {V<:Vec{<:Any,<:IEEEFloat}} = FDiv(x, y)
@override (/)(x::V, y::V)  where {V<:Vec{<:Any,<:BitInteger}} = IDiv(x, y)
@override rem(x::V, y::V)  where {V<:Vec{<:Any,<:IEEEFloat}} = FRem(x, y)
@override rem(x::V, y::V)  where {V<:Vec{<:Any,<:BitInteger}} = IRem(x, y)
@override mod(x::V, y::V)  where {V<:Vec{<:Any,<:IEEEFloat}} = FMod(x, y)
@override mod(x::V, y::V)  where {V<:Vec{<:Any,<:BitInteger}} = IMod(x, y)
@override ^(x::V, y::V)    where {V<:Vec{<:Any,<:IEEEFloat}} = Pow(x, y)
@override atan(x::V, y::V) where {V<:Vec{<:Any,<:IEEEFloat}} = Atan2(x, y)

@override ceil(x::Vec) = Ceil(x)
@override exp(x::Vec) = Exp(x)
@override (-)(x::Vec) = FNegate(x)

# Define broadcasting rules so that broadcasting eagerly uses the vector instruction when applicable.
@override Broadcast.broadcasted(::typeof(+), x::V, y::V)   where {V<:Vec{<:Any,IEEEFloat}} = FAdd(x, y)
@override Broadcast.broadcasted(::typeof(+), x::V, y::V)   where {V<:Vec{<:Any,BitInteger}} = IAdd(x, y)
@override Broadcast.broadcasted(::typeof(+), x::Vec{N,<:BitInteger}, y::Vec{N,<:BitInteger}) where {N} = IAdd(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(+), x::Vec{N,<:IEEEFloat}, y::Vec{N,<:IEEEFloat})   where {N} = FAdd(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(-), x::V, y::V)   where {V<:Vec{<:Any,IEEEFloat}} = FSub(x, y)
@override Broadcast.broadcasted(::typeof(-), x::V, y::V)   where {V<:Vec{<:Any,BitInteger}} = ISub(x, y)
@override Broadcast.broadcasted(::typeof(-), x::Vec{N,<:BitInteger}, y::Vec{N,<:BitInteger}) where {N} = ISub(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(-), x::Vec{N,<:IEEEFloat}, y::Vec{N,<:IEEEFloat})   where {N} = FSub(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(*), x::V, y::V)   where {V<:Vec{<:Any,IEEEFloat}} = FMul(x, y)
@override Broadcast.broadcasted(::typeof(*), x::V, y::V)   where {V<:Vec{<:Any,BitInteger}} = IMul(x, y)
@override Broadcast.broadcasted(::typeof(*), x::Vec{N,<:BitInteger}, y::Vec{N,<:BitInteger}) where {N} = IMul(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(*), x::Vec{N,<:IEEEFloat}, y::Vec{N,<:IEEEFloat})   where {N} = FMul(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(/), x::V, y::V)   where {V<:Vec{<:Any,IEEEFloat}} = FDiv(x, y)
@override Broadcast.broadcasted(::typeof(/), x::V, y::V)   where {V<:Vec{<:Any,BitInteger}} = IDiv(x, y)
@override Broadcast.broadcasted(::typeof(/), x::Vec{N,<:BitInteger}, y::Vec{N,<:BitInteger}) where {N} = IDiv(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(/), x::Vec{N,<:IEEEFloat}, y::Vec{N,<:IEEEFloat})   where {N} = FDiv(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(rem), x::V, y::V)  where {V<:Vec{<:Any,IEEEFloat}} = FRem(x, y)
@override Broadcast.broadcasted(::typeof(rem), x::V, y::V)  where {V<:Vec{<:Any,BitInteger}} = IRem(x, y)
@override Broadcast.broadcasted(::typeof(rem), x::Vec{N,<:BitInteger}, y::Vec{N,<:BitInteger}) where {N} = IRem(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(rem), x::Vec{N,<:IEEEFloat}, y::Vec{N,<:IEEEFloat})   where {N} = FRem(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(mod), x::V, y::V)  where {V<:Vec{<:Any,IEEEFloat}} = FMod(x, y)
@override Broadcast.broadcasted(::typeof(mod), x::V, y::V)  where {V<:Vec{<:Any,BitInteger}} = IMod(x, y)
@override Broadcast.broadcasted(::typeof(mod), x::Vec{N,<:BitInteger}, y::Vec{N,<:BitInteger}) where {N} = IMod(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(mod), x::Vec{N,<:IEEEFloat}, y::Vec{N,<:IEEEFloat})   where {N} = FMod(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(^), x::V, y::V)   where {V<:Vec{<:Any,IEEEFloat}} = Pow(x, y)
@override Broadcast.broadcasted(::typeof(^), x::Vec{N,<:IEEEFloat}, y::Vec{N,<:IEEEFloat})     where {N} = Pow(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(atan), x::V, y::V) where {V<:Vec{<:Any,IEEEFloat}} = Atan2(x, y)
@override Broadcast.broadcasted(::typeof(atan), x::Vec{N,<:IEEEFloat}, y::Vec{N,<:IEEEFloat})  where {N} = Atan2(promote(x, y)...)
@override Broadcast.broadcasted(::typeof(ceil), x::Vec) = vectorize(ceil, x)
@override Broadcast.broadcasted(::typeof(exp), x::Vec) = vectorize(exp, x)
@override Broadcast.broadcasted(::typeof(-), x::Vec) = vectorize(-, x)

@override dot(x::T, y::T) where {T<:Vec{<:Any,<:IEEEFloat}} = Dot(x, y)
@override dot(x::T, y::T) where {T<:Vec{<:Any,<:BitUnsigned}} = UDot(x, y)
@override dot(x::T, y::T) where {T<:Vec{<:Any,<:BitSigned}} = SDot(x, y)
@override dot(x::Vec{N,<:BitSigned}, y::Vec{N,<:BitUnsigned}) where {N} = SUDot(x, y)

@override @generated foldl(f::F, xs::Vec) where {F<:Function} =
  foldl((x, y) -> Expr(:call, :f, x, :(xs[$y])), eachindex_uint32(xs)[2:end]; init = :(xs[$(firstindex_uint32(xs))]))
@override @generated foldl(f::F, xs::Vec, init) where {F <: Function} =
  foldl((x, y) -> Expr(:call, :f, x, :(xs[$y])), eachindex_uint32(xs); init = :init)
@override @generated foldr(f::F, xs::Vec) where {F<:Function} =
  foldr((x, y) -> Expr(:call, :f, :(xs[$x]), y), eachindex_uint32(xs)[1:(end - 1)]; init = :(xs[$(lastindex_uint32(xs))]))
@override @generated foldr(f::F, xs::Vec, init) where {F <: Function} =
  foldr((x, y) -> Expr(:call, :f, :(xs[$x]), y), eachindex_uint32(xs); init = :init)
@override any(f::F, xs::Vec) where {F<:Function} = foldl((x, y) -> x | f(y), xs, false)
@override all(f::F, xs::Vec) where {F<:Function} = foldl((x, y) -> x & f(y), xs, true)
@override @generated sum(f::F, xs::Vec) where {F<:Function} = Expr(:call, :+, (:(f(xs[$i])) for i in eachindex_uint32(xs))...)
@override @generated prod(f::F, xs::Vec) where {F<:Function} = Expr(:call, :*, (:(f(xs[$i])) for i in eachindex_uint32(xs))...)
@override sum(xs::Vec) = sum(identity, xs)
@override prod(xs::Vec) = prod(identity, xs)

# Ranges.

@override getindex(r::Union{StepRangeLen,LinRange}, i::Integer) = unsafe_getindex(r, i)
@override getindex(v::Base.OneTo{T}, i::Integer) where {T} = convert(T, i)
@override getindex(v::UnitRange{T}, i::Integer) where {T} = (v.start + (i - oneunit(i))) % T

##### GLSL intrinsics.

@override_glsl have_fma(::Type{<:IEEEFloat}) = true
@override_glsl muladd(x::T, y::T, z::T) where {T<:IEEEFloat} = Fma(x, y, z)
@override_glsl fma(x::T, y::T, z::T) where {T<:IEEEFloat}    = Fma(x, y, z)
@override_glsl exp(x::SmallFloat)  = Exp(x)
@override_glsl exp2(x::SmallFloat) = Exp2(x)
@override_glsl log(x::SmallFloat)  = Log(x)
@override_glsl log2(x::SmallFloat) = Log2(x)

@override_glsl sin(x::SmallFloat) = Sin(x)
@override_glsl cos(x::SmallFloat) = Cos(x)
@override_glsl tan(x::SmallFloat) = Tan(x)
@override_glsl asin(x::SmallFloat) = Asin(x)
@override_glsl acos(x::SmallFloat) = Acos(x)
@override_glsl atan(x::SmallFloat) = Atan(x)
@override_glsl cosh(x::SmallFloat) = Cosh(x)
@override_glsl tanh(x::SmallFloat) = Tanh(x)
@override_glsl asinh(x::SmallFloat) = Asinh(x)
@override_glsl acosh(x::SmallFloat) = Acosh(x)
@override_glsl atanh(x::SmallFloat) = Atanh(x)
@override_glsl sincos(x::SmallFloat) = (sin(x), cos(x))
@override_glsl atan(y::T, x::T) where {T<:SmallFloat} = Atan2(y, x)
@override_glsl atan(y::Float32, x::Float32) = Atan2(y, x)

@override_glsl sqrt(x::IEEEFloat) = Sqrt(x)
@override_glsl round(x::IEEEFloat, r::RoundingMode{:ToZero})  = Trunc(x)
@override_glsl round(x::IEEEFloat, r::RoundingMode{:Down})    = Floor(x)
@override_glsl round(x::IEEEFloat, r::RoundingMode{:Up})      = Ceil(x)
@override_glsl round(x::IEEEFloat, r::RoundingMode{:Nearest}) = Round(x)
@override_glsl abs(x::BitSigned)  = SAbs(x)
@override_glsl abs(x::IEEEFloat)  = FAbs(x)
@override_glsl sign(x::IEEEFloat) = FSign(x)
@override_glsl sign(x::BitSigned) = SSign(x)
@override_glsl ^(x::T, y::T) where {T<:IEEEFloat} = Pow(x, y)

@override_glsl min(x::T, y::T) where {T<:IEEEFloat}   = FMin(x, y)
@override_glsl min(x::T, y::T) where {T<:BitSigned}   = SMin(x, y)
@override_glsl min(x::T, y::T) where {T<:BitUnsigned} = UMin(x, y)
@override_glsl max(x::T, y::T) where {T<:IEEEFloat}   = FMax(x, y)
@override_glsl max(x::T, y::T) where {T<:BitSigned}   = SMax(x, y)
@override_glsl max(x::T, y::T) where {T<:BitUnsigned} = UMax(x, y)
@override_glsl clamp(x::T, lo::T, hi::T) where {T<:IEEEFloat}   = FClamp(x, lo, hi)
@override_glsl clamp(x::T, lo::T, hi::T) where {T<:BitSigned}   = SClamp(x, lo, hi)
@override_glsl clamp(x::T, lo::T, hi::T) where {T<:BitUnsigned} = UClamp(x, lo, hi)
