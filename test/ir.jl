using SPIRV, Test, Graphs

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
    mod2 = SPIRV.Module(ir)
    @test mod ≈ mod2
    pmod2 = PhysicalModule(mod2)
    @test SPIRV.Module(pmod2) == mod2
    @test pmod ≈ pmod2
    @test unwrap(validate(ir))

    pmod = SPIRV.PhysicalModule(resource("comp.spv"))
    mod = SPIRV.Module(pmod)
    ir = IR(mod; satisfy_requirements = false)
    mod2 = SPIRV.Module(ir)
    @test mod ≈ mod2
    pmod2 = PhysicalModule(mod2)
    @test SPIRV.Module(pmod2) == mod2
    @test pmod ≈ pmod2
    @test unwrap(validate(ir))
  end

  @testset "Printing" begin
    ir = IR(SPIRV.Module(PhysicalModule(resource("vert.spv"))))
    # Simply make sure it does not error.
    @test !isempty(sprint(show, MIME"text/plain"(), ir))
  end
end;
