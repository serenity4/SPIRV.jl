"""
SSA value used in a SPIR-V context.

Differs from `Core.SSAValue` in that all SPIR-V constructs will
use this `SSAValue` type to differentiate with Julia SSA values.
"""
struct SSAValue
  id::UInt32
end

Base.isless(val1::SSAValue, val2::SSAValue) = isless(id(val1), id(val2))

Base.convert(::Type{T}, val::SSAValue) where {T<:Integer} = convert(T, val.id)
Base.convert(::Type{Core.SSAValue}, val::SSAValue) where {T<:Integer} = Core.SSAValue(val.id)
Base.convert(::Type{SSAValue}, val::Core.SSAValue) where {T<:Integer} = SSAValue(val.id)
Base.convert(::Type{SSAValue}, id::Integer) = SSAValue(id)

id(val::SSAValue) = val.id

Base.tryparse(::Type{SSAValue}, id::AbstractString) = !isempty(id) && return SSAValue(parse(UInt32, id[2:end]))
Base.parse(::Type{SSAValue}, id::AbstractString) = tryparse(SSAValue, id)::SSAValue

Base.show(io::IO, val::SSAValue) = print(io, string('%', val.id))

const SSADict{T} = Dictionary{SSAValue,T}

mutable struct SSACounter
  val::SSAValue
end

Base.convert(::Type{SSAValue}, counter::SSACounter) = SSAValue(counter)
SSAValue(counter::SSACounter) = counter.val
function next!(counter::SSACounter)
  counter.val = SSAValue(id(counter.val) + 1)
end

max_id(x) = id(max_ssa(x))
