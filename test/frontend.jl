using SPIRV, Test

@testset "Front-end" begin
  include("frontend/definitions.jl")
  include("frontend/restructuring.jl")
  include("frontend/cache.jl")
  include("frontend/pointer.jl")
  include("frontend/array.jl")
  include("frontend/codegen_julia.jl")
  include("frontend/codegen_spirv.jl")
  include("frontend/shader.jl")
end;
