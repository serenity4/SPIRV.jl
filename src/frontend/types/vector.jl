const Vec = SVector

const Vec2 = SVector{2,Float32}
const Vec3 = SVector{3,Float32}
const Vec4 = SVector{4,Float32}

const Vec2U = SVector{2,UInt32}
const Vec3U = SVector{3,UInt32}
const Vec4U = SVector{4,UInt32}

const Vec2I = SVector{2,Int32}
const Vec3I = SVector{3,Int32}
const Vec4I = SVector{4,Int32}

const MVec = MVector

const MVec2 = MVector{2,Float32}
const MVec3 = MVector{3,Float32}
const MVec4 = MVector{4,Float32}

const MVec2U = MVector{2,UInt32}
const MVec3U = MVector{3,UInt32}
const MVec4U = MVector{4,UInt32}

const MVec2I = MVector{2,Int32}
const MVec3I = MVector{3,Int32}
const MVec4I = MVector{4,Int32}

@noinline VectorExtractDynamic(v::Vec{<:Any,T}, index::UInt32) where {T} = v.data[index]::T

macro Vec(ex)
  static_vector_gen(SVector, ex, __module__)
end

# let VT = :SVector
#   # Add vector math pseudo-intrinsics for static arrays.
#   for N in 2:4
#     for (f, op) in zip((:+, :-, :*, :/, :rem, :mod, :^, :atan), (:Add, :Sub, :Mul, :Div, :Rem, :Mod, :Pow, :Atan2))

#       ops, XTs = if in(op, (:Pow, :Atan2))
#         (op,), (:IEEEFloat,)
#       else
#         opF, opI = Symbol.((:F, :I), op)
#         (opF, opI), (:IEEEFloat, :BitInteger)
#       end

#       for (opX, XT) in zip(ops, XTs)
#         @eval @override Base.$f(x::$VT{$N,<:$XT}, y::$VT{$N,<:$XT}) = $opX(x, y)

#         # Allow usage of promotion rules for these operations.
#         @eval $opX(v1::$VT{$N,<:$XT}, v2::$VT{$N,<:$XT}) = $opX(promote(v1, v2)...)

#         @eval Base.broadcasted(::typeof($f), v1::T, v2::T) where {T<:$VT{$N,<:$XT}} = $opX(v1, v2)
#       end
#     end
#   end
# end

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
