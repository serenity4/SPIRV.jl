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
        pmod = SPIRV.PhysicalModule(resource("vert.spv"))
        mod = SPIRV.Module(pmod)
        ir = IR(mod)
        f1 = ir.fdefs[4]
        cfg = control_flow_graph(f1)
        @test nv(cfg) == length(f1.blocks) == count(==(SPIRV.OpLabel), map(x -> x.opcode, SPIRV.body(f1)))
        mod2 = SPIRV.Module(ir)
        @test mod ≈ mod2
        pmod2 = PhysicalModule(mod2)
        @test SPIRV.Module(pmod2) == mod2
        @test pmod ≈ pmod2
        @test validate(ir)

        pmod = SPIRV.PhysicalModule(resource("comp.spv"))
        mod = SPIRV.Module(pmod)
        ir = IR(mod)
        f2 = ir.fdefs[52]
        cfg = control_flow_graph(f2)
        @test nv(cfg) == length(f2.blocks) == count(==(SPIRV.OpLabel), map(x -> x.opcode, SPIRV.body(f2)))
        mod2 = SPIRV.Module(ir)
        @test mod ≈ mod2
        pmod2 = PhysicalModule(mod2)
        @test SPIRV.Module(pmod2) == mod2
        @test pmod ≈ pmod2
        @test validate(ir)
    end

    @testset "Front-end" begin
        include("frontend/deltagraph.jl")
        include("frontend/reflection.jl")
        include("frontend/restructuring.jl")
        include("frontend/compile.jl")
    end
end
