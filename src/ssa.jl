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

Base.parse(::Type{SSAValue}, id) = SSAValue(parse(UInt32, id))
Base.show(io::IO, val::SSAValue) = print(io, string('%', val.id))

const SSADict{T} = Dictionary{SSAValue,T}
