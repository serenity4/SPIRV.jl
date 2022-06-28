using SPIRV, Test

function test_module(mod::SPIRV.Module)
  @test unwrap(validate(mod))

  ir = IR(mod)
  @test unwrap(validate(ir))

  @test SPIRV.Module(ir) ≈ mod

  pmod = PhysicalModule(mod)
  @test unwrap(validate(pmod))

  io = IOBuffer()
  write(io, pmod)
  seekstart(io)
  @test read(io, PhysicalModule) == pmod

  @test SPIRV.Module(pmod) == mod
end

@testset "SPIRV.jl" begin
  include("modules.jl");
  include("metadata.jl");
  include("ir.jl");
  include("spvasm.jl");
  include("layouts.jl");
  if VERSION > v"1.9.0-DEV"
    include("frontend.jl");
    include("analysis.jl");
    include("passes.jl");
  end;
end;
