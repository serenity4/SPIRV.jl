using SPIRV
using Graphs
using Test

function test_module(mod::SPIRV.Module)
  @test validate(mod)
  ir = IR(mod)
  @test validate(ir)
  @test SPIRV.Module(ir) ≈ mod
  pmod = PhysicalModule(mod)
  @test validate(pmod)
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
