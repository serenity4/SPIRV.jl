using SPIRV, Test

function f_straightcode(x)
  y = x + 1
  z = 3y
  z^2
end

function f_extinst(x)
  y = exp(x)
  z = 1 + 3sin(x)
  log(z) + y
end

@testset "Compilation to SPIR-V" begin
  include("intrinsics.jl")
  include("cache.jl")
  include("codegen.jl")

  # WIP
  # cfg = @cfg f_extinst(3f0)
  # @compile f_extinst(3f0)
  # SPIRV.@code_typed exp(1)
  # SPIRV.@code_typed exp(3f0)
end
