using Test
using SPIRV.StructuredCFG
using LightGraphs

function f(x, sampler)
    intensity = sampler[x] * 2
    if intensity < 0. || sqrt(intensity) < 1.
        return 3.
    end
    clamp(intensity, 0., 1.)
end

cfg = CFG(f, Tuple{Int,Vector{Float64}})

strongly_connected_components(cfg.graph)

@testset "StructuredCFG" begin
    include("deltagraph.jl")
end
