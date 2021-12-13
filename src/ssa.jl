"""
SSA value used in a SPIR-V context.

Differs from `Core.SSAValue` in that all SPIR-V constructs will
use this `SSAValue` type to differentiate with Julia SSA values.
"""
struct SSAValue
    id::UInt32
end

Base.convert(::Type{T}, val::SSAValue) where {T<:Integer} = val.id
Base.convert(::Type{Core.SSAValue}, val::SSAValue) where {T<:Integer} = Core.SSAValue(val.id)
Base.convert(::Type{SSAValue}, val::Core.SSAValue) where {T<:Integer} = SSAValue(val.id)
Base.convert(::Type{SSAValue}, id::Integer) = SSAValue(id)

id(val::SSAValue) = val.id

Base.parse(::Type{SSAValue}, id) = SSAValue(parse(UInt32, id))
Base.show(io::IO, val::SSAValue) = print(io, string('%', val.id))

struct SSADict{T}
    dict::Dictionary{SSAValue,T}
    SSADict{T}() where {T} = new{T}(Dictionary{SSAValue,T}())
    SSADict(pairs::AbstractVector{Pair{SSAValue,T}}) where {T} = new{T}(Dictionary(pairs...))
    SSADict{T}(dict::Dictionary{SSAValue,T}) where {T} = new{T}(dict)
    SSADict(dict::Dictionary{SSAValue,T}) where {T} = SSADict{T}(dict)
end

SSADict(args::Vararg) = SSADict(collect(args))
SSADict() = SSADict{Any}()

Base.convert(::Type{SSADict{T}}, dict::SSADict) where {T} = SSADict{T}(convert(Dictionary{SSAValue,T}, dict.dict))

@forward SSADict.dict Base.getindex, Base.insert!, Dictionaries.set!, Base.get!, Base.get, Base.setindex!, Base.pop!, Base.first, Base.last, Base.broadcastable, Base.length, Base.iterate, Base.keys, Base.values, Base.haskey

Base.merge!(vec::SSADict, others::SSADict...) = merge!(vec.dict, getproperty.(others, :dict)...)
