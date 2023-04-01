using SnoopCompile
# Make sure to uncomment the inclusion of `precompiled_generated.jl` from `src/SPIRV.jl`,
# otherwise we'll be missing a lot of precompile directives after snooping.
@time_imports using SPIRV

tinf = @snoopi_deep @eval module __anonymous__; include("../test/runtests.jl"); end;
ttot, pcs = SnoopCompile.parcel(tinf);
tmp = tempname()
SnoopCompile.write(tmp, pcs; has_bodyfunction = true)
file = joinpath(pkgdir(SPIRV), "src", "precompilation_traces_2.jl")

open(file, "w+") do io
  for line in split(read(joinpath(tmp, "precompile_SPIRV.jl"), String), '\n')[3:end-2]
    contains(line, "__anonymous__") && continue
    # contains(line, "SPIRV") || continue
    println(io, line)
  end
end
