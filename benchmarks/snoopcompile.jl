using SnoopCompile

invalidations = @snoop_invalidations using SPIRV
@show length(uinvalidated(invalidations))
trees = invalidation_trees(invalidations)

using ProfileView
@time_imports using SPIRV

tinf = @snoop_inference include("../test/runtests.jl");
fg = flamegraph(tinf)
ProfileView.view(fg)

fl = flatten(tinf)
summary = last(accumulate_by_source(fl), 10)
accumulate_by_source(fl)
itrigs = inference_triggers(tinf)
filtermod(SPIRV, itrigs)
