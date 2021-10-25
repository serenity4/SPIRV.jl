"""
Something that is SSA-indexable.
"""
abstract type SSAIndexable end

struct SSADict{T}
    dict::Dictionary{ID,T}
    SSADict{T}() where {T} = new{T}(Dictionary{ID,T}())
    SSADict(pairs::AbstractVector{Pair{ID,T}}) where {T} = new{T}(Dictionary(pairs...))
    SSADict{T}(dict::Dictionary{ID,T}) where {T} = new{T}(dict)
    SSADict(dict::Dictionary{ID,T}) where {T} = SSADict{T}(dict)
end

SSADict(args::AbstractVector{<:SSAIndexable}) = SSADict(ID.(args) .=> args)
SSADict(args::Vararg) = SSADict(collect(args))
SSADict() = SSADict{Any}()

Base.convert(::Type{SSADict{T}}, dict::SSADict) where {T} = SSADict{T}(convert(Dictionary{ID,T}, dict.dict))

@forward SSADict.dict Base.getindex, Base.insert!, Dictionaries.set!, Base.get!, Base.get, Base.setindex!, Base.pop!, Base.first, Base.last, Base.broadcastable, Base.length, Base.iterate, Base.keys, Base.values, Base.haskey

Base.merge!(vec::SSADict, others::SSADict...) = merge!(vec.dict, getproperty.(others, :dict)...)
