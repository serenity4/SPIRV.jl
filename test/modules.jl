using SPIRV, Test

resource(filename) = joinpath(@__DIR__, "resources", filename)

modules = [
  "vert.spv",
  "frag.spv",
  "comp.spv",
  "decorations.spv",
]

@testset "SPIR-V modules" begin
  @testset "Testing SPIR-V module $file" for file in modules
    r = resource(file)
    pmod = PhysicalModule(r)
    mod = SPIRV.Module(pmod)
    @test !iserror(validate(mod))

    # Make sure it does not error when displayed.
    @test !isempty(sprint(show, MIME"text/plain"(), mod))

    @testset "Assembly/disassembly isomorphisms" begin
      pmod_reconstructed = PhysicalModule(mod)
      @test pmod == pmod_reconstructed

      @test sizeof(assemble(pmod)) == stat(r).size
      @test assemble(pmod) == assemble(mod)

      tmp = IOBuffer()
      write(tmp, pmod_reconstructed)
      seekstart(tmp)
      @test read(tmp, PhysicalModule) == pmod_reconstructed
    end
  end
end;
