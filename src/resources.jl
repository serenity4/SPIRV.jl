bindings(v::Variable) = map(last(filter(x -> first(x) == DecorationBinding, v.decorations)))
descriptor_sets(v::Variable) = map(last(filter(x -> first(x) == DecorationDescriptorSet, v.decorations)))
