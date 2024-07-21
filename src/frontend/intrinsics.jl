@noinline Bitcast(T, x) = Base.bitcast(T, x)

# Floats.

## Arithmetic operations.

@noinline FNegate(x::T) where {T<:IEEEFloat}    = Base.neg_float(x)
@noinline FAdd(x::T, y::T) where {T<:IEEEFloat} = Base.add_float(x, y)
@noinline FMul(x::T, y::T) where {T<:IEEEFloat} = Base.mul_float(x, y)
@noinline FSub(x::T, y::T) where {T<:IEEEFloat} = Base.sub_float(x, y)
@noinline FDiv(x::T, y::T) where {T<:IEEEFloat} = Base.div_float(x, y)
@noinline FRem(x::T, y::T) where {T<:IEEEFloat} = @static if VERSION < v"1.10.0-DEV.101"
  Base.rem_float(x, y)::T
else
  copysign(Base.rem_internal(abs(x), abs(y)), x)::T
end

@noinline function FMod(x::T, y::T) where {T<:IEEEFloat}
  r = rem(x, y)
  if r == 0
    copysign(r, y)
  elseif (r > 0) ⊻ (y > 0)
    r + y
  else
    r
  end
end

## Comparisons.

@noinline FOrdEqual(x::T, y::T) where {T<:IEEEFloat}         = Base.eq_float(x, y)
@noinline FUnordNotEqual(x::T, y::T) where {T<:IEEEFloat}    = Base.ne_float(x, y)
@noinline FOrdLessThan(x::T, y::T) where {T<:IEEEFloat}      = Base.lt_float(x, y)
@noinline FOrdLessThanEqual(x::T, y::T) where {T<:IEEEFloat} = Base.le_float(x, y)

@inline function FUnordEqual(x::T, y::T) where {T<:IEEEFloat}
  isnan(x) & isnan(y) | x == y
end
@noinline IsNan(x::IEEEFloat)    = invoke(isnan, Tuple{AbstractFloat}, x)
@noinline IsInf(x::IEEEFloat)    = !invoke(isfinite, Tuple{AbstractFloat}, x)

have_fma(T) = false

## Conversions.

@noinline FConvert(::Type{Float16}, x::Float32) = Base.fptrunc(Float16, x)
@noinline FConvert(::Type{Float16}, x::Float64) = Base.fptrunc(Float16, x)
@noinline FConvert(::Type{Float32}, x::Float64) = Base.fptrunc(Float32, x)
@noinline FConvert(::Type{Float32}, x::Float16) = Base.fpext(Float32, x)
@noinline FConvert(::Type{Float64}, x::Float16) = Base.fpext(Float64, x)
@noinline FConvert(::Type{Float64}, x::Float32) = Base.fpext(Float64, x)

@noinline ConvertFToS(::Type{T}, x::IEEEFloat) where {T<:BitSigned} = Base.fptosi(T, x)
@noinline ConvertFToU(::Type{T}, x::IEEEFloat) where {T<:BitUnsigned} = Base.fptoui(T, x)
@noinline ConvertSToF(to::Type{T}, x::BitSigned) where {T<:IEEEFloat} = Base.sitofp(to, x)
@noinline ConvertUToF(to::Type{T}, x::BitUnsigned) where {T<:IEEEFloat} = Base.uitofp(to, x)

### There is no possibility to throw errors in SPIR-V, so replace safe operations with unsafe ones.

@noinline UConvert(::Type{UInt16}, x::UInt8)  = Base.zext_int(UInt16, x)
@noinline UConvert(::Type{UInt32}, x::UInt8)  = Base.zext_int(UInt32, x)
@noinline UConvert(::Type{UInt64}, x::UInt8)  = Base.zext_int(UInt64, x)
@noinline UConvert(::Type{UInt8},  x::UInt16) = Base.trunc_int(UInt8, x)
@noinline UConvert(::Type{UInt32}, x::UInt16) = Base.zext_int(UInt32, x)
@noinline UConvert(::Type{UInt64}, x::UInt16) = Base.zext_int(UInt64, x)
@noinline UConvert(::Type{UInt8},  x::UInt32) = Base.trunc_int(UInt8, x)
@noinline UConvert(::Type{UInt16}, x::UInt32) = Base.trunc_int(UInt16, x)
@noinline UConvert(::Type{UInt64}, x::UInt32) = Base.zext_int(UInt64, x)
@noinline UConvert(::Type{UInt8},  x::UInt64) = Base.trunc_int(UInt8, x)
@noinline UConvert(::Type{UInt16}, x::UInt64) = Base.trunc_int(UInt16, x)
@noinline UConvert(::Type{UInt32}, x::UInt64) = Base.trunc_int(UInt32, x)

@noinline SConvert(::Type{Int16}, x::Int8)  = Base.sext_int(Int16, x)
@noinline SConvert(::Type{Int32}, x::Int8)  = Base.sext_int(Int32, x)
@noinline SConvert(::Type{Int64}, x::Int8)  = Base.sext_int(Int64, x)
@noinline SConvert(::Type{Int8},  x::Int16) = Base.trunc_int(Int8, x)
@noinline SConvert(::Type{Int32}, x::Int16) = Base.sext_int(Int32, x)
@noinline SConvert(::Type{Int64}, x::Int16) = Base.sext_int(Int64, x)
@noinline SConvert(::Type{Int8},  x::Int32) = Base.trunc_int(Int8, x)
@noinline SConvert(::Type{Int16}, x::Int32) = Base.trunc_int(Int16, x)
@noinline SConvert(::Type{Int64}, x::Int32) = Base.sext_int(Int64, x)
@noinline SConvert(::Type{Int8},  x::Int64) = Base.trunc_int(Int8, x)
@noinline SConvert(::Type{Int16}, x::Int64) = Base.trunc_int(Int16, x)
@noinline SConvert(::Type{Int32}, x::Int64) = Base.trunc_int(Int32, x)

@noinline UConvert(::Type{UInt16}, x::Int8)  = Base.zext_int(UInt16, x)
@noinline UConvert(::Type{UInt32}, x::Int8)  = Base.zext_int(UInt32, x)
@noinline UConvert(::Type{UInt64}, x::Int8)  = Base.zext_int(UInt64, x)
@noinline UConvert(::Type{UInt8},  x::Int16) = Base.trunc_int(UInt8, x)
@noinline UConvert(::Type{UInt32}, x::Int16) = Base.zext_int(UInt32, x)
@noinline UConvert(::Type{UInt64}, x::Int16) = Base.zext_int(UInt64, x)
@noinline UConvert(::Type{UInt8},  x::Int32) = Base.trunc_int(UInt8, x)
@noinline UConvert(::Type{UInt16}, x::Int32) = Base.trunc_int(UInt16, x)
@noinline UConvert(::Type{UInt64}, x::Int32) = Base.zext_int(UInt64, x)
@noinline UConvert(::Type{UInt8},  x::Int64) = Base.trunc_int(UInt8, x)
@noinline UConvert(::Type{UInt16}, x::Int64) = Base.trunc_int(UInt16, x)
@noinline UConvert(::Type{UInt32}, x::Int64) = Base.trunc_int(UInt32, x)

@noinline SConvert(::Type{Int16}, x::UInt8)  = Base.sext_int(Int16, x)
@noinline SConvert(::Type{Int32}, x::UInt8)  = Base.sext_int(Int32, x)
@noinline SConvert(::Type{Int64}, x::UInt8)  = Base.sext_int(Int64, x)
@noinline SConvert(::Type{Int8},  x::UInt16) = Base.trunc_int(Int8, x)
@noinline SConvert(::Type{Int32}, x::UInt16) = Base.sext_int(Int32, x)
@noinline SConvert(::Type{Int64}, x::UInt16) = Base.sext_int(Int64, x)
@noinline SConvert(::Type{Int8},  x::UInt32) = Base.trunc_int(Int8, x)
@noinline SConvert(::Type{Int16}, x::UInt32) = Base.trunc_int(Int16, x)
@noinline SConvert(::Type{Int64}, x::UInt32) = Base.sext_int(Int64, x)
@noinline SConvert(::Type{Int8},  x::UInt64) = Base.trunc_int(Int8, x)
@noinline SConvert(::Type{Int16}, x::UInt64) = Base.trunc_int(Int16, x)
@noinline SConvert(::Type{Int32}, x::UInt64) = Base.trunc_int(Int32, x)

@noinline SRem(x::T, y::T) where {T<:BitSigned} = Base.checked_srem_int(x, y)
# SPIR-V does not have URem but it looks like SRem can work with unsigned ints.
@noinline SRem(x::T, y::T) where {T<:BitUnsigned} = Base.checked_urem_int(x, y)

## Comparisons.

@noinline SLessThan(x::BitInteger, y::BitInteger) = Base.slt_int(x, y)
@noinline SLessThanEqual(x::BitInteger, y::BitInteger) = Base.sle_int(x, y)
@noinline ULessThan(x::BitInteger, y::BitInteger) = Base.ult_int(x, y)
@noinline ULessThanEqual(x::BitInteger, y::BitInteger) = Base.ule_int(x, y)

## Logical operators.

@noinline IEqual(x::T, y::T) where {T<:BitInteger}     = Base.eq_int(x, y)
@noinline INotEqual(x::T, y::T) where {T<:BitInteger}  = Base.ne_int(x, y)
@noinline Not(x::BitInteger)                           = Base.not_int(x)
@noinline BitwiseAnd(x::T, y::T) where {T<:BitInteger} = Base.and_int(x, y)
@noinline BitwiseOr(x::T, y::T) where {T<:BitInteger}  = Base.or_int(x, y)
@noinline BitwiseXor(x::T, y::T) where {T<:BitInteger} = Base.xor_int(x, y)

## Integer shifts.

@noinline ShiftRightArithmetic(x::BitSigned, y::BitUnsigned) = Base.ashr_int(x, y)
@noinline ShiftRightLogical(x::BitInteger, y::BitInteger) = Base.lshr_int(x, y)
@noinline ShiftLeftLogical(x::BitInteger, y::BitInteger) = Base.shl_int(x, y)

## Arithmetic operations.

@noinline SNegate(x::T) where {T<:BitInteger} = Base.neg_int(x)

for (intr, core_intr) in zip((:IAdd, :ISub, :IMul), (:add_int, :sub_int, :mul_int))
  @eval @noinline ($intr(x::T, y::T) where {T<:BitSigned} = Base.$core_intr(x, y))
  @eval @noinline ($intr(x::T, y::T) where {T<:BitUnsigned} = Base.$core_intr(x, y))
  @eval @noinline ($intr(x::BitUnsigned, y::I) where {I<:BitSigned} = Base.$core_intr(x, y))
  @eval @noinline ($intr(x::I, y::BitUnsigned) where {I<:BitSigned} = Base.$core_intr(x, y))
end

@noinline UDiv(x::T, y::T) where {T<:BitUnsigned} = Base.udiv_int(x, y)
@noinline SDiv(x::T, y::T) where {T<:BitSigned} = Base.sdiv_int(x, y)

# Not SPIR-V operations, but handy to define to abstract over unsigned/signed integers.
IRem(x::T, y::T) where {T<:Union{BitSigned,BitUnsigned}} = SRem(x, y)
IMod(x::T, y::T) where {T<:BitSigned} = SMod(x, y)
IMod(x::T, y::T) where {T<:BitUnsigned} = UMod(x, y)
IDiv(x::T, y::T) where {T<:BitSigned} = SDiv(x, y)
IDiv(x::T, y::T) where {T<:BitUnsigned} = UDiv(x, y)

@noinline Select(cond::Bool, x::T, y::T) where {T} = Core.ifelse(cond, x, y)

## Counting operations.
## These have to be emulated, as they don't exist in SPIR-V.
## XXX: The emulations are simple but slow.
## Another approach using global tables may prove more efficient.
## See "Software emulation" section of https://en.wikipedia.org/wiki/Find_first_set.
## XXX: Can we remove the wrapping into `Int`? 64-bit operations are slow on the GPU.

function trailing_zeros_emulated(x::Integer) # alias `cttz`
  iszero(x) && return 8sizeof(x) % typeof(x)
  t = one(x)
  r = zero(x)
  while iszero(x & t)
    t <<= one(t)
    r += one(r)
  end
  r
end

function leading_zeros_emulated(x::Integer) # alias `ctlz`
  w = sizeof(x) % typeof(x)
  iszero(x) && return w
  t = one(x) << (w - one(w))
  r = zero(x)
  while iszero(x & t)
    t >>= one(t)
    r += one(r)
  end
  r
end

# Booleans.

@noinline LogicalNot(x)          = Base.not_int(x)
@noinline LogicalAnd(x, y)       = Base.and_int(x, y)
@noinline LogicalOr(x, y)        = Base.or_int(x, y)
@noinline BitwiseXor(x, y)       = Base.xor_int(x, y)
@noinline LogicalEqual(x, y)     = Base.eq_int(x, y)
@noinline LogicalNotEqual(x, y)  = Base.ne_int(x, y)

# Copy.

@noinline function CopyObject(@nospecialize(x))
  isbitstype(typeof(x)) && return x
  return Base.deepcopy_internal(x, IdDict())::typeof(x)
end

# Barriers.

@noinline ControlBarrier(execution::Scope, scope::Scope, memory_semantics::MemorySemantics) = invokelatest(Returns(nothing))::Nothing
@noinline MemoryBarrier(scope::Scope, memory_semantics::MemorySemantics) = invokelatest(Returns(nothing))::Nothing

# Vectors/matrices/arrays/pointers.

@noinline IEqual(x::Vec, y::Vec) = x .== y
@noinline FOrdEqual(x::Vec, y::Vec) = x .== y
@noinline Any(x::Vec{<:Any,Bool}) = any(x.data)
@noinline All(x::Vec{<:Any,Bool}) = all(x.data)

@noinline FConvert(::Type{Vec{N,T}}, v::Vec{N}) where {N,T} = convert_vec(Vec{N,T}, v)
@noinline SConvert(::Type{Vec{N,T}}, v::Vec{N}) where {N,T} = convert_vec(Vec{N,T}, v)
@noinline UConvert(::Type{Vec{N,T}}, v::Vec{N}) where {N,T} = convert_vec(Vec{N,T}, v)
@noinline ConvertSToF(::Type{Vec{N,T}}, v::Vec{N}) where {N,T} = convert_vec(Vec{N,T}, v)
@noinline ConvertUToF(::Type{Vec{N,T}}, v::Vec{N}) where {N,T} = convert_vec(Vec{N,T}, v)
@noinline ConvertFToS(::Type{Vec{N,T}}, v::Vec{N}) where {N,T} = convert_vec(Vec{N,T}, v)
@noinline ConvertFToU(::Type{Vec{N,T}}, v::Vec{N}) where {N,T} = convert_vec(Vec{N,T}, v)
convert_vec(::Type{Vec{N,T}}, v::Vec{N}) where {N,T} = Vec{N,T}(ntuple_uint32(i -> convert(T, @inbounds v[i]), N)...)

@noinline CompositeExtract(v::SVector, index::UInt32) = v.data[index]

@noinline function CompositeConstruct(::Type{SVector{N,T}}, values::T...) where {N,T}
  @force_construct SVector{N,T} values
end

@noinline function CompositeInsert(value::T, v::SVector{N,T}, i::UInt32) where {N,T}
  SVector(T[ifelse(i == j, value, v[j]) for j in eachindex(v)])
end

@noinline FAdd(x::V, y::V)  where {V<:Vec{<:Any,<:IEEEFloat}}  = vectorize(+, x, y)
@noinline IAdd(x::V, y::V)  where {V<:Vec{<:Any,<:BitInteger}} = vectorize(+, x, y)
@noinline FSub(x::V, y::V)  where {V<:Vec{<:Any,<:IEEEFloat}}  = vectorize(-, x, y)
@noinline ISub(x::V, y::V)  where {V<:Vec{<:Any,<:BitInteger}} = vectorize(-, x, y)
@noinline FMul(x::V, y::V)  where {V<:Vec{<:Any,<:IEEEFloat}}  = vectorize(*, x, y)
@noinline IMul(x::V, y::V)  where {V<:Vec{<:Any,<:BitInteger}} = vectorize(*, x, y)
@noinline FDiv(x::V, y::V)  where {V<:Vec{<:Any,<:IEEEFloat}}  = vectorize(/, x, y)
@noinline IDiv(x::V, y::V)  where {V<:Vec{<:Any,<:BitInteger}} = vectorize(/, x, y)
@noinline FRem(x::V, y::V)  where {V<:Vec{<:Any,<:IEEEFloat}}  = vectorize(rem, x, y)
@noinline IRem(x::V, y::V)  where {V<:Vec{<:Any,<:BitInteger}} = vectorize(rem, x, y)
@noinline FMod(x::V, y::V)  where {V<:Vec{<:Any,<:IEEEFloat}}  = vectorize(mod, x, y)
@noinline IMod(x::V, y::V)  where {V<:Vec{<:Any,<:BitInteger}} = vectorize(mod, x, y)
@noinline Pow(x::V, y::V)   where {V<:Vec{<:Any,<:IEEEFloat}}  = vectorize(^, x, y)
@noinline Atan2(x::V, y::V) where {V<:Vec{<:Any,<:IEEEFloat}}  = vectorize(atan, x, y)

@noinline Dot(x::Vec{N}, y::Vec{N})   where {N} = sum(x .* y)
@noinline UDot(x::Vec{N}, y::Vec{N})  where {N} = sum(x .* y)
@noinline SDot(x::Vec{N}, y::Vec{N})  where {N} = sum(x .* y)
@noinline SUDot(x::Vec{N}, y::Vec{N}) where {N} = sum(x .* y)

@noinline Ceil(x::Vec) = vectorize(ceil, x)
@noinline Exp(x::Vec) = vectorize(exp, x)
@noinline FNegate(x::Vec) = vectorize(-, x)

## CPU implementation for instructions that directly operate on vectors.
vectorize(op, v1::T, v2::T) where {T<:Vec} = Vec(op.(v1.data, v2.data))
vectorize(op, v::T, x::Scalar) where {T<:Vec} = Vec(op.(v.data, x))
vectorize(op, v::T) where {T<:Vec} = Vec(op.(v.data))

@noinline (@generated function CompositeConstruct(::Type{Mat{N,M,T,L}}, cols::Vec{N,T}...) where {N,M,T,L}
  2 ≤ N ≤ 4 || throw(ArgumentError("SPIR-V matrices must have between 2 and 4 rows."))
  2 ≤ M ≤ 4 || throw(ArgumentError("SPIR-V matrices must have between 2 and 4 columns."))
  values = Expr[]
  for i in 1:N
    for j in 1:M
      push!(values, :(cols[$j][$i]))
    end
  end
  ex = Expr(:new, Mat{N,M,T,L})
  append!(ex.args, values)
  ex
end)

@noinline CompositeExtract(m::Mat, i::UInt32, j::UInt32) = m.data[i + (j - 1)nrows(m)]
@noinline CompositeExtract(m::Mat{N,M,T}, i::UInt32) where {N,M,T} = Vec{N,T}(ntuple(j -> m.data[j + (i - 1)N], N))
