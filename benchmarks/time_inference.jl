using SnoopCompile
@time_imports using SPIRV

tinf = @snoopi_deep include("../test/runtests.jl");
fl = flatten(tinf)
summary = last(accumulate_by_source(fl), 10)
accumulate_by_source(fl)
itrigs = inference_triggers(tinf)
filtermod(SPIRV, itrigs)
fg = flamegraph(tinf)
# ProfileView has not been updated to FlameGraphs 1.0, and therefore is still stuck at AbstractTrees 0.3 and will not work with SPIRV.
