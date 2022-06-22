using SPIRV, Test, Graphs

@testset "Intermediate Representation" begin
  @testset "Annotated module" begin
    mod = SPIRV.Module(resource("vert.spv"))
    amod = annotate(mod)
    @test amod.capabilities == 1
    @test amod.extensions == 2
    @test amod.extended_instruction_sets == 2
    @test amod.memory_model == 3
    @test amod.entry_points == 4
    @test amod.execution_modes == 5
    @test amod.debug == 5
    @test amod.annotations == 22
    @test amod.globals == 42
    @test amod.functions == 67
  end

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
    @test unwrap(validate(ir))

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
    @test unwrap(validate(ir))
  end

  @testset "Printing" begin
    ir = IR(SPIRV.Module(PhysicalModule(resource("vert.spv"))))
    # Simply make sure it does not error.
    @test !isempty(sprint(show, MIME"text/plain"(), ir))
  end
end;
