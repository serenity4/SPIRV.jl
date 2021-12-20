struct BijectiveMapping{T1,T2}
    forward::Dictionary{T1,T2}
    backward::Dictionary{T2,T1}
end

BijectiveMapping{T1,T2}() where {T1,T2} = BijectiveMapping{T1,T2}(Dictionary(), Dictionary())
BijectiveMapping() = BijectiveMapping{Any,Any}()

function Base.convert(::Type{BijectiveMapping{T1,T2}}, bmap::BijectiveMapping{T3,T4}) where {T1,T2,T3,T4}
    BijectiveMapping(convert(Dictionary{T1,T2}, bmap.forward), convert(Dictionary{T2,T1}, bmap.backward))
end
Base.convert(::Type{BijectiveMapping{T1,T2}}, bmap::BijectiveMapping{T1,T2}) where {T1,T2} = bmap

function Base.insert!(bmap::BijectiveMapping{T1,T2}, key::T1, val::T2) where {T1,T2}
    insert!(bmap.forward, key, val)
    insert!(bmap.backward, val, key)
end

function Base.insert!(bmap::BijectiveMapping{T1,T2}, key::T2, val::T1) where {T1,T2}
    insert!(bmap.forward, val, key)
    insert!(bmap.backward, key, val)
end

Base.getindex(bmap::BijectiveMapping{T1}, key::T1) where {T1} = bmap.forward[key]
Base.getindex(bmap::BijectiveMapping{T1,T2}, key::T2) where {T1,T2} = bmap.backward[key]

@forward BijectiveMapping.forward (Base.pairs, Base.iterate)
