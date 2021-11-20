using SPIRV
using .Spells: Context, If, Loop, emit, Func
using Test

spirv_file(filename) = joinpath(@__DIR__, "resources", filename * ".spv")

@testset "Spells.jl" begin
    ir = IR(SPIRV.Module(spirv_file("unicolor.vert")))
    ctx = Context()
end
