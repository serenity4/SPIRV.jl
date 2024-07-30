using SPIRV, Test

spvasm(basename) = joinpath(@__DIR__, "spvasm", basename * ".spvasm")

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

@testset "Parsing human-readable SPIR-V assembly (.spvasm)" begin
  mod1 = read(SPIRV.Module, spvasm("test1"))
  test_module(mod1)

  # Support for fancier (Julia style) .spvasm
  mod1_fancy = read(SPIRV.Module, spvasm("test1_fancy"))
  @test mod1_fancy == mod1

  mod2 = read(SPIRV.Module, spvasm("test2"))
  test_module(mod2)
end;
