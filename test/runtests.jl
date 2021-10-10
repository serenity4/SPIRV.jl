using SPIRV
using LightGraphs
using Test

resource(filename) = joinpath(@__DIR__, "resources", filename)

modules = [
    "vert.spv",
    "frag.spv",
    "comp.spv",
    "decorations.spv",
]

@testset "SPIRV.jl" begin
    @testset "Testing SPIR-V module $file" for file in modules
        r = resource(file)
        pmod = PhysicalModule(r)
        mod = SPIRV.Module(pmod)

        @testset "Assembly/disassembly isomorphisms" begin
            pmod_reconstructed = PhysicalModule(mod)
            @test pmod == pmod_reconstructed

            @test sizeof(assemble(pmod)) == stat(r).size
            @test assemble(pmod) == assemble(mod)

            tmp = IOBuffer()
            write(tmp, pmod_reconstructed)
            seekstart(tmp)
            @test PhysicalModule(tmp) == pmod_reconstructed
        end
    end

    @testset "Intermediate Representation" begin
        mod = SPIRV.Module(resource("vert.spv"))
        ir = IR(mod)
        f = ir.fdefs[4]
        @test length(f.cfg.blocks) == nv(f.cfg.graph) == count(==(SPIRV.OpLabel), map(x -> x.opcode, SPIRV.body(f)))
        mod2 = SPIRV.Module(ir)

        mod = SPIRV.Module(resource("comp.spv"))
        ir = IR(mod)
        f = ir.fdefs[52]
        @test length(f.cfg.blocks) == nv(f.cfg.graph) == count(==(SPIRV.OpLabel), map(x -> x.opcode, SPIRV.body(f)))
        mod2 = SPIRV.Module(ir)
    end
end
