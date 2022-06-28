using SPIRV, Test
using SPIRV: AnnotatedFunction

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
    @test unwrap(validate(mod))

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

  @testset "Annotated module" begin
    mod = SPIRV.Module(resource("vert.spv"))
    amod = annotate(mod)
    @test amod.capabilities == 1:1
    @test amod.extensions == 2:1
    @test amod.extended_instruction_sets == 2:2
    @test amod.memory_model == 3
    @test amod.entry_points == 4:4
    @test amod.execution_modes == 5:4
    @test amod.debug == 5:21
    @test amod.annotations == 22:41
    @test amod.globals == 42:66
    @test amod.functions == 67:78

    @test only(amod.annotated_functions) == AnnotatedFunction(67:78, 68:67, [68:77])
  end
end;
