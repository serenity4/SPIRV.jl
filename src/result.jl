"""
Result ID used in a SPIR-V context, following single static assignment rules for valid modules.
"""
primitive type ResultID 32 end

ResultID(id::UInt32) = reinterpret(ResultID, id)
ResultID(id::Integer) = ResultID(UInt32(id))

Base.isless(id1::ResultID, id2::ResultID) = isless(UInt32(id1), UInt32(id2))

Base.convert(::Type{T}, id::ResultID) where {T<:Integer} = convert(T, UInt32(id))
Base.convert(::Type{Core.SSAValue}, id::ResultID) = Core.SSAValue(UInt32(id))
Base.convert(::Type{ResultID}, val::Core.SSAValue) = ResultID(val.id)
Base.convert(::Type{ResultID}, id::Integer) = ResultID(id)

Base.zero(::Type{ResultID}) = ResultID(zero(UInt32))

UInt32(id::ResultID) = reinterpret(UInt32, id)

Base.tryparse(::Type{ResultID}, id::AbstractString) = !isempty(id) && return ResultID(parse(UInt32, id[2:end]))
Base.parse(::Type{ResultID}, id::AbstractString) = tryparse(ResultID, id)::ResultID

Base.show(io::IO, id::ResultID) = print(io, string('%', UInt32(id)))

const ResultDict{T} = Dictionary{ResultID,T}

mutable struct IDCounter
  current_id::ResultID
end

Dictionaries.set!(counter::IDCounter, id::ResultID) = (counter.current_id = id)

IDCounter() = IDCounter(zero(ResultID))

Base.convert(::Type{ResultID}, counter::IDCounter) = ResultID(counter)
ResultID(counter::IDCounter) = counter.current_id

function next!(counter::IDCounter)
  counter.current_id = ResultID(UInt32(counter.current_id) + 1)
end
