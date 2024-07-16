struct BijectiveMapping{T1,T2}
  forward::Dictionary{T1,T2}
  backward::Dictionary{T2,T1}
end

BijectiveMapping(d::Dictionary{T1,T2}) where {T1,T2} = BijectiveMapping{T1,T2}(d, dictionary(v => k for (k, v) in pairs(d)))
BijectiveMapping{T1,T2}() where {T1,T2} = BijectiveMapping{T1,T2}(Dictionary(), Dictionary())
BijectiveMapping() = BijectiveMapping{Any,Any}()

function Base.merge!(bmap::BijectiveMapping{T1,T2}, d::Union{Dictionary{T1,T2},Dictionary{T2,T1}}) where {T1,T2}
  for (key, val) in pairs(d)
    insert!(bmap, val, key)
  end
end

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
Base.get(bmap::BijectiveMapping, key, default) = haskey(bmap, key) ? bmap[key] : default
function Base.get!(f, bmap::BijectiveMapping, key)
  haskey(bmap, key) && return bmap[key]
  value = f()
  insert!(bmap, key, value)
  value
end
Base.haskey(bmap::BijectiveMapping{T1}, key::T1) where {T1} = haskey(bmap.forward, key)
Base.haskey(bmap::BijectiveMapping{T1,T2}, key::T2) where {T1,T2} = haskey(bmap.backward, key)

function Dictionaries.sortkeys!(bmap::BijectiveMapping)
  sortkeys!(bmap.forward)
  sort!(bmap.backward)
end

function Base.delete!(bmap::BijectiveMapping{T1}, key::T1) where {T1}
  value = bmap[key]
  delete!(bmap.forward, key)
  delete!(bmap.backward, value)
  bmap
end

function Base.setindex!(bmap::BijectiveMapping{T1,T2}, value::T2, key::T1) where {T1, T2}
  old = bmap[key]
  delete!(bmap.backward, old)
  bmap.forward[key] = value
  insert!(bmap.backward, value, key)
  bmap
end

@forward_methods BijectiveMapping field = :forward Base.pairs Base.iterate(_, args...) Base.keys Base.length

function Base.show(io::IO, ::MIME"text/plain", bmap::BijectiveMapping)
  isempty(bmap) && return print(io, BijectiveMapping, "({})")
  print(io, BijectiveMapping, " with ", length(bmap), " elements:")
  dpheight = displaysize(io)[2]
  keyvals = []
  for (i, (key, val)) in enumerate(pairs(bmap.forward))
    i < dpheight || break
    push!(keyvals, string("  ", key) => string(val))
  end
  max_keylength = maximum(length ∘ first, keyvals)
  for (key, val) in keyvals
    print(io, '\n', lpad(key, max_keylength), " <=> ", val)
  end
end

function merge_unique!(dict, ds...)
  for d in ds
    for (k, v) in pairs(d)
      insert!(dict, k, v)
    end
  end
  dict
end
