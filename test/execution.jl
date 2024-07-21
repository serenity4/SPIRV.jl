using SPIRV
using StaticArrays
using Test

include("execution/execute.jl")

@testset "GPU execution of SPIR-V compute shaders" begin
  include("execution/basic_tests.jl")
end;
