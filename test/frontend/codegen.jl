using SPIRV, Test
using SPIRV: OpFMul, OpFAdd

@testset "SPIR-V code generation" begin
  ir = @compile f_straightcode(3f0)
  fdef = only(values(ir.fdefs))
  block = only(fdef.blocks)
  @test block[2] == @inst SSAValue(8) = OpFAdd(SSAValue(5), SSAValue(7))::SSAValue(2)
  @test block[3] == @inst SSAValue(10) = OpFMul(SSAValue(9), SSAValue(8))::SSAValue(2)
  @test block[4] == @inst SSAValue(11) = OpFMul(SSAValue(10), SSAValue(10))::SSAValue(2)
  mod = SPIRV.Module(ir)
  @test mod == parse(SPIRV.Module, """
        OpCapability(VulkanMemoryModel)
        OpExtension("SPV_KHR_vulkan_memory_model")
        OpMemoryModel(Logical, Vulkan)
   %2 = OpTypeFloat(32)
   %3 = OpTypeFunction(%2, %2)
   # Constant literals are not interpreted as floating point values.
   # Doing so would require the knowledge of types, expressed in the IR.
   %7 = OpConstant(0x3f800000)::%2
   %9 = OpConstant(0x40400000)::%2
   %4 = OpFunction(None, %3)::%2
   %5 = OpFunctionParameter()::%2
   %6 = OpLabel()
   %8 = OpFAdd(%5, %7)::%2
  %10 = OpFMul(%9, %8)::%2
  %11 = OpFMul(%10, %10)::%2
        OpReturnValue(%11)
        OpFunctionEnd()
  """)
  @test_throws SPIRV.ValidationError("""
    error: line 0: No OpEntryPoint instruction was found. This is only allowed if the Linkage capability is being used.
    """) validate(ir)
  @test validate(ir; check_entrypoint = false)

  ir = @compile clamp(1.2, 0., 0.7)
  mod = SPIRV.Module(ir)
  @test mod == parse(SPIRV.Module, """
        OpCapability(VulkanMemoryModel)
        OpCapability(Float64)
        OpExtension("SPV_KHR_vulkan_memory_model")
        OpMemoryModel(Logical, Vulkan)
   %2 = OpTypeFloat(64)
   %3 = OpTypeFunction(%2, %2, %2, %2)
  %10 = OpTypeBool()
   %4 = OpFunction(None, %3)::%2
   %5 = OpFunctionParameter()::%2
   %6 = OpFunctionParameter()::%2
   %7 = OpFunctionParameter()::%2
   %8 = OpLabel()
  %11 = OpFOrdLessThan(%7, %5)::%10
  %12 = OpFOrdLessThan(%5, %6)::%10
  %13 = OpSelect(%12, %6, %5)::%2
  %14 = OpSelect(%11, %7, %13)::%2
        OpReturnValue(%14)
        OpFunctionEnd()
    """)
  @test validate(ir; check_entrypoint = false)

  ir = @compile f_extinst(3f0)
  mod = SPIRV.Module(ir)
  @test mod == parse(SPIRV.Module, """
        OpCapability(VulkanMemoryModel)
        OpExtension("SPV_KHR_vulkan_memory_model")
   %7 = OpExtInstImport("GLSL.std.450")
        OpMemoryModel(Logical, Vulkan)
   %2 = OpTypeFloat(0x00000020)
   %3 = OpTypeFunction(%2, %2)
  %10 = OpConstant(0x40400000)::%2
  %12 = OpConstant(0x3f800000)::%2
   %4 = OpFunction(None, %3)::%2
   %5 = OpFunctionParameter()::%2
   %6 = OpLabel()
   %8 = OpExtInst(%7, Exp, %5)::%2
   %9 = OpExtInst(%7, Sin, %5)::%2
  %11 = OpFMul(%10, %9)::%2
  %13 = OpFAdd(%12, %11)::%2
  %14 = OpExtInst(%7, Log, %13)::%2
  %15 = OpFAdd(%14, %8)::%2
        OpReturnValue(%15)
        OpFunctionEnd()
    """)
    @test validate(ir; check_entrypoint = false)
end
