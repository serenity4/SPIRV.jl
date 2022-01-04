using SPIRV, Test, Dictionaries

@testset "Shader interface" begin
  function vert_shader!(out_color)
    out_color.a = 1f0
  end

  cfg = @cfg vert_shader!(similar(SVec{Float32,4}))
  ir = @compile vert_shader!(similar(SVec{Float32,4}))
  @test validate(ir)
  ir = SPIRV.make_shader(cfg; storage_classes = dictionary([1 => SPIRV.StorageClassOutput]))
  mod = SPIRV.Module(ir)
  #FIXME: The conversion of operands from strings to concrete values
  # requires getting operand infos, which themselves rely
  # on arguments to determine if there are extra parameters.
  # The error is currently triggered on OpDecorate instructions.
  @test_broken mod == parse(SPIRV.Module, """
        OpCapability(VulkanMemoryModel)
        OpCapability(Shader)
        OpExtension("SPV_KHR_vulkan_memory_model")
        OpMemoryModel(Logical, Vulkan)
        OpEntryPoint(Vertex, %15, "main", %17, %21)
        OpName(%5, "f_straightcode_Tuple{Float32}")
        OpName(%4, "x")
        OpDecorate(%17, Location, 0x00000000)
        OpDecorate(%21, Location, 0x00000000)
   %2 = OpTypeFloat(0x00000020)
   %3 = OpTypeFunction(%2, %2)
   %7 = OpConstant(0x3f800000)::%2
   %9 = OpConstant(0x40400000)::%2
  %13 = OpTypeVoid()
  %14 = OpTypeFunction(%13)
  %16 = OpTypePointer(Input, %2)
  %17 = OpVariable(Input)::%16
  %20 = OpTypePointer(Output, %2)
  %21 = OpVariable(Output)::%20
   %5 = OpFunction(None, %3)::%2
   %4 = OpFunctionParameter()::%2
   %6 = OpLabel()
   %8 = OpFAdd(%4, %7)::%2
  %10 = OpFMul(%9, %8)::%2
  %11 = OpFMul(%10, %10)::%2
        OpReturnValue(%11)
        OpFunctionEnd()
  %15 = OpFunction(None, %14)::%13
  %18 = OpLabel()
  %19 = OpLoad(%17)::%2
  %22 = OpFunctionCall(%5, %19)::%2
        OpStore(%21, %22)
        OpReturn()
        OpFunctionEnd()
  """)
  @test_broken validate_shader(ir)
end
