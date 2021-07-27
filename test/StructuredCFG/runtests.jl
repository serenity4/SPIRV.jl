using Test
using SPIRV.StructuredCFG
using LightGraphs

@testset "StructuredCFG" begin
    include("deltagraph.jl")
    include("reflection.jl")
end
