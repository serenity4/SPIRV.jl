bindings(v::Variable)::Vector{UInt32} = map(last, filter(x -> first(x) == DecorationBinding, v.decorations))
descriptor_sets(v::Variable)::Vector{UInt32} = map(last, filter(x -> first(x) == DecorationDescriptorSet, v.decorations))
