using SPIRV, Test
using SPIRV: OpFMul, OpFAdd

function f_straightcode(x)
  y = x + 1
  z = 3y
  z^2
end

function f_extinst(x)
  y = exp(x)
  z = 1 + 3sin(x)
  log(z)
end

@testset "Compilation to SPIR-V" begin
  ir = compile(f_straightcode, Tuple{Float32})
  @testset "Intrinsics" begin
    @test only(only(values(ir.fdefs)).blocks)[2] == @inst SSAValue(8) = OpFAdd(SSAValue(5), SSAValue(7))::SSAValue(2)
    @test only(only(values(ir.fdefs)).blocks)[3] == @inst SSAValue(10) = OpFMul(SSAValue(9), SSAValue(8))::SSAValue(2)
    @test only(only(values(ir.fdefs)).blocks)[4] == @inst SSAValue(11) = OpFMul(SSAValue(10), SSAValue(10))::SSAValue(2)
  end
  mod = SPIRV.Module(ir)
  @test mod == parse(SPIRV.Module, """
         OpCapability(VulkanMemoryModel)
         OpExtension("SPV_KHR_vulkan_memory_model")
         OpMemoryModel(Logical, Vulkan)
    %2 = OpTypeFloat(32)
    %3 = OpTypeFunction(%2, %2)
    # Constant literals are not interpreted as floating point values.
    # Doing so would require the knowledge of types, expressed in the IR.
    %7 = OpConstant(1065353216)::%2
    %9 = OpConstant(1077936128)::%2
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
end
