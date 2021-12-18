using SPIRV
using Graphs
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
        @test validate(mod)

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
        f1 = ir.fdefs[4]
        @test length(f1.cfg.blocks) == nv(f1.cfg.graph) == count(==(SPIRV.OpLabel), map(x -> x.opcode, SPIRV.body(f1)))
        mod2 = SPIRV.Module(ir)
        pmod2 = PhysicalModule(mod2)
        @test SPIRV.Module(pmod2) == mod2
        @test validate(ir)

        mod = SPIRV.Module(resource("comp.spv"))
        ir = IR(mod)
        f2 = ir.fdefs[52]
        @test length(f2.cfg.blocks) == nv(f2.cfg.graph) == count(==(SPIRV.OpLabel), map(x -> x.opcode, SPIRV.body(f2)))
        mod2 = SPIRV.Module(ir)
        pmod2 = PhysicalModule(mod2)
        @test SPIRV.Module(pmod2) == mod2
        # error: line 312: Block 617[%617] appears in the binary before its dominator 619[%619]
        @test_broken validate(ir)
    end
end

include("Spells/runtests.jl")
