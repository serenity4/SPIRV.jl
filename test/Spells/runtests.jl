using SPIRV, Test
using Graphs

spirv_file(filename) = joinpath(@__DIR__, "resources", filename * ".spv")

@testset "Spells" begin
    include("deltagraph.jl")
    include("reflection.jl")
    include("restructuring.jl")
end
