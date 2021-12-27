using SPIRV
using Graphs
using Test

resource(filename) = joinpath(@__DIR__, "resources", filename)
spvasm(basename) = joinpath(@__DIR__, "spvasm", basename * ".spvasm")

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
        @testset "Initialization & mode-setting" begin
            ir = IR(memory_model = SPIRV.MemoryModelVulkan)
            @test !in("SPV_KHR_vulkan_memory_model", ir.extensions)
            @test !in(SPIRV.CapabilityVulkanMemoryModel, ir.capabilities)

            SPIRV.satisfy_requirements!(ir)
            @test in("SPV_KHR_vulkan_memory_model", ir.extensions)
            @test in(SPIRV.CapabilityVulkanMemoryModel, ir.capabilities)
        end

        @testset "Conversion between modules and IR" begin
            pmod = SPIRV.PhysicalModule(resource("vert.spv"))
            mod = SPIRV.Module(pmod)
            ir = IR(mod; satisfy_requirements = false)
            f1 = SPIRV.FunctionDefinition(ir, :main)
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
            ir = IR(mod; satisfy_requirements = false)
            f2 = SPIRV.FunctionDefinition(ir, :main)
            cfg = control_flow_graph(f2)
            @test nv(cfg) == length(f2.blocks) == count(==(SPIRV.OpLabel), map(x -> x.opcode, SPIRV.body(f2)))
            mod2 = SPIRV.Module(ir)
            @test mod ≈ mod2
            pmod2 = PhysicalModule(mod2)
            @test SPIRV.Module(pmod2) == mod2
            @test pmod ≈ pmod2
            @test validate(ir)
        end
    end

    @testset "Parsing human-readable SPIR-V assembly (.spvasm)" begin
        mod = read(SPIRV.Module, spvasm("simple"))
        @test validate(mod)
        ir = IR(mod)
        @test SPIRV.Module(ir) ≈ mod

        # Support for fancier (Julia style) .spvasm
        mod2 = read(SPIRV.Module, spvasm("simple_fancy"))
        @test mod2 == mod
    end

    @testset "Front-end" begin
        include("frontend/deltagraph.jl")
        include("frontend/reflection.jl")
        include("frontend/restructuring.jl")
        include("frontend/compile.jl")
        include("frontend/shader.jl")
    end
end;
