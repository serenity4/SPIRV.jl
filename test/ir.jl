using SPIRV, Test

@testset "Intermediate Representation" begin
  @testset "Initialization & mode-setting" begin
    ir = IR(memory_model = SPIRV.MemoryModelVulkan)
    @test !in("SPV_KHR_vulkan_memory_model", ir.extensions)
    @test !in(SPIRV.CapabilityVulkanMemoryModel, ir.capabilities)

    SPIRV.satisfy_requirements!(ir, AllSupported())
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
