using SPIRV
using Test

include("execute.jl")

@testset "GPU execution" begin
  @testset "Checking basic execution" begin
    @test execute(Float32, :(3F + 6F)) === 9F
    @test execute(Float64, :(3.0 + 12.0)) === 15.0
    @test execute(Int64, :(3 + 11)) === 14
    @test execute(Float32, :(exp(10f0))) === exp(10f0)
    @test execute(Float32, :(cos(10f0))) === cos(10f0)
  end
end;
