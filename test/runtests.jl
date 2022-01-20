using SPIRV, Test

function test_module(mod::SPIRV.Module)
  @test !iserror(validate(mod))

  ir = IR(mod)
  @test !iserror(validate(ir))

  @test SPIRV.Module(ir) ≈ mod

  pmod = PhysicalModule(mod)
  @test !iserror(validate(pmod))

  io = IOBuffer()
  write(io, pmod)
  seekstart(io)
  @test PhysicalModule(io) == pmod

  @test SPIRV.Module(pmod) == mod
end

@testset "SPIRV.jl" begin
  include("modules.jl")
  include("ir.jl")
  include("spvasm.jl")
  include("alignment.jl")
  include("frontend.jl")
end;
