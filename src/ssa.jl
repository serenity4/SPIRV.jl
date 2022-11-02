"""
SSA value used in a SPIR-V context.

Differs from `Core.SSAValue` in that all SPIR-V constructs will
use this `SSAValue` type to differentiate with Julia SSA values.
"""
primitive type SSAValue 32 end

SSAValue(id::UInt32) = reinterpret(SSAValue, id)
SSAValue(id::Integer) = SSAValue(UInt32(id))

Base.isless(val1::SSAValue, val2::SSAValue) = isless(id(val1), id(val2))

Base.convert(::Type{T}, val::SSAValue) where {T<:Integer} = convert(T, id(val))
Base.convert(::Type{Core.SSAValue}, val::SSAValue) = Core.SSAValue(id(val))
Base.convert(::Type{SSAValue}, val::Core.SSAValue) = SSAValue(id(val))
Base.convert(::Type{SSAValue}, id::Integer) = SSAValue(id)

Base.zero(::Type{SSAValue}) = SSAValue(zero(UInt32))

id(val::SSAValue) = reinterpret(UInt32, val)

Base.tryparse(::Type{SSAValue}, id::AbstractString) = !isempty(id) && return SSAValue(parse(UInt32, id[2:end]))
Base.parse(::Type{SSAValue}, id::AbstractString) = tryparse(SSAValue, id)::SSAValue

Base.show(io::IO, val::SSAValue) = print(io, string('%', id(val)))

const SSADict{T} = Dictionary{SSAValue,T}

mutable struct SSACounter
  val::SSAValue
end

SSACounter() = SSACounter(zero(SSAValue))

Base.convert(::Type{SSAValue}, counter::SSACounter) = SSAValue(counter)
SSAValue(counter::SSACounter) = counter.val

function next!(counter::SSACounter)
  counter.val = SSAValue(id(counter.val) + 1)
end
