@override getindex(r::Union{StepRangeLen,LinRange}, i::Integer) = unsafe_getindex(r, i)
@override getindex(v::Base.OneTo{T}, i::Integer) where {T} = convert(T, i)
@override getindex(v::UnitRange{T}, i::Integer) where {T} = (v.start + (i - oneunit(i))) % T
