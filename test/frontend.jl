using SPIRV, Test

@testset "Front-end" begin
  include("frontend/definitions.jl");
  include("frontend/cfg.jl");
  include("frontend/restructuring.jl");
  include("frontend/cache.jl");
  include("frontend/types.jl");
  include("frontend/method_table.jl");
  include("frontend/codegen_julia.jl");
  include("frontend/codegen_spirv.jl");
  include("frontend/shader.jl");
end;
