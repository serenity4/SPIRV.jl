using SPIRV, Test

@testset "CFG restructuring" begin
  include("restructuring/deltagraph.jl")
  include("restructuring/reflection.jl")
  include("restructuring/passes.jl")
end;
