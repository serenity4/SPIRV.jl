using .Broadcast: Broadcasted, BroadcastStyle, AbstractArrayStyle, Style, ArrayStyle

# We want a fused broadcasting logic, so no eager overloading of `broadcasted(::StyleOverride, ::typeof(f), ...)`.
# Dimensions checks should be done at compile-time, as the array sizes are static.

abstract type StyleOverride <: BroadcastStyle end

struct VecStyle{N} <: StyleOverride end
struct ArrStyle{N} <: StyleOverride end
struct MatStyle{N,M} <: StyleOverride end

Base.BroadcastStyle(::Type{<:Vec{N}}) where {N} = VecStyle{N}()
Base.BroadcastStyle(::Type{<:Arr{N}}) where {N} = ArrStyle{N}()
Base.BroadcastStyle(::Type{<:Mat{N,M}}) where {N,M} = MatStyle{N,M}()

Base.BroadcastStyle(style::StyleOverride, ::AbstractArrayStyle{0}) = style
Base.BroadcastStyle(style::StyleOverride, ::Style{Tuple}) = style
Base.BroadcastStyle(style::AbstractArrayStyle{1}, ::StyleOverride) = style

# Shape broadcasting rules.

Base.BroadcastStyle(style::S, ::S) where {S<:Union{ArrStyle,VecStyle,MatStyle}} = style

Base.BroadcastStyle(style::ArrStyle{N1}, ::ArrStyle{N2}) where {N1,N2} = error("Array lengths do not match in broadcasting operation: ($N1 ≠ $N2)")
Base.BroadcastStyle(style::VecStyle{N1}, ::VecStyle{N2}) where {N1,N2} = error("Vector lengths do not match in broadcasting operation: ($N1 ≠ $N2)")
Base.BroadcastStyle(style::ArrStyle{N}, ::VecStyle{N}) where {N} = style

Base.BroadcastStyle(style::MatStyle{N,M}, ::Union{ArrStyle{N},VecStyle{N}}) where {N,M} = style
Base.BroadcastStyle(style::MatStyle{N,M}, ::Union{ArrStyle{M},VecStyle{M}}) where {N,M} = style
Base.BroadcastStyle(style::MatStyle{N,M}, ::MatStyle{1,<:Any}) where {N,M} = style
Base.BroadcastStyle(style::MatStyle{N,M}, ::MatStyle{<:Any,1}) where {N,M} = style
Base.BroadcastStyle(style::MatStyle{N1,M1}, ::MatStyle{N2,M2}) where {N1,M1,N2,M2} = error("Matrix shapes do not match in broadcasting operation: ($((N1, M1)) ≠ $((N2, M2)))")

# Computing the result of the broadcast.

result_type(::Type{VecStyle{N}}, ::Type{T}) where {N,T} = Vec{N,T}
result_type(::Type{ArrStyle{N}}, ::Type{T}) where {N,T} = Arr{N,T}
result_type(::Type{MatStyle{N,M}}, ::Type{T}) where {N,M,T} = Mat{N,M,T}

# TODO: Use these when using a for loop to implement `Base.copy` (typically for types with a large number of elements where full unrolling is not desirable)
# Base.similar(bc::Broadcasted{<:VecStyle{N}}, ::Type{T}) where {N,T} = zero(Vec{N,T})
# Base.similar(bc::Broadcasted{<:ArrStyle{N}}, ::Type{T}) where {N,T} = zero(Arr{N,T})
# Base.similar(bc::Broadcasted{<:MatStyle{N,M}}, ::Type{T}) where {N,M,T} = zero(Mat{N,M,T})

function Base.copy(bc::Broadcasted{S}) where {S<:StyleOverride} # = copyto!(similar(bc, Broadcast.combine_eltypes(bc.f, bc.args)), bc)
  T = Broadcast.combine_eltypes(bc.f, bc.args)
  T === Any && error("Failed to infer a proper eltype for the broadcast operation")
  RT = result_type(S, T)
  bc′ = Broadcast.flatten(bc)
  RT(compute_broadcast(bc′)...)
end

function compute_broadcast(bc::Broadcasted{<:Union{VecStyle{N},ArrStyle{N}}}) where {N}
  new_args = ntuple(length(bc.args)) do i
    arg = bc.args[i]
    (isa(arg, Vec) || isa(arg, Arr)) && return getcomponents(arg)
    isa(arg, NTuple{N}) && return arg
    isa(arg, Base.RefValue) && return (arg[],)
    (arg,)
  end
  bc.f.(new_args...)
end

@inline Base.copyto!(v::AbstractSPIRVArray, bc::Broadcasted{<:StyleOverride}) = copyto!(v, copy(bc))

const VecOrArr{N} = Union{Vec{N},Arr{N}}
getcomponents(v::VecOrArr{N}) where {N} = ntuple_uint32(i -> v[i], N)
