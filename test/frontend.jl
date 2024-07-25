using SPIRV, Test

@testset "Front-end" begin
  include("frontend/utility.jl")
  include("frontend/math.jl");
  include("frontend/definitions.jl");
  include("frontend/method_table.jl");
  include("frontend/codegen_julia.jl");
  include("frontend/codegen_spirv.jl");
  include("frontend/shader.jl");
end;
