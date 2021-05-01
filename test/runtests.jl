using SPIRV
using Test

resource(filename) = joinpath(@__DIR__, "resources", filename)

modules = [
    "vert.spv",
    "frag.spv",
]

@testset "SPIRV.jl" begin
    @testset "Testing SPIR-V module $file" for file in modules
        r = resource(file)
        pmod = PhysicalModule(r)
        mod = SPIRV.Module(pmod)
        disassemble(mod)

        @testset "Assembly/disassembly isomorphisms" begin
            pmod_reconstructed::PhysicalModule = mod
            @test pmod == pmod_reconstructed

            @test sizeof(assemble(pmod)) == stat(r).size
            @test assemble(pmod) == assemble(mod)

            tmp = tempname()
            open(tmp, "w+") do io
                write(io, pmod_reconstructed)
            end
            @test PhysicalModule(tmp) == pmod_reconstructed
        end
    end

    @testset "Intermediate Representation" begin
        mod = SPIRV.Module(resource("vert.spv"))
        ir = IR(mod)
        convert(SPIRV.Module, ir)
        println(ir.variables)
    end
end
