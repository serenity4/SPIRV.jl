struct BasicBlock
    n::Int
end

BasicBlock(cfg::CFG, v::Variable) = BasicBlock(findfirst(Base.Fix1(in, v.id), block_ranges(cfg.indices)))
