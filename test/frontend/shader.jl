using SPIRV, Test, Dictionaries

@testset "Shader interface" begin
  function vert_shader!(out_color)
    out_color.a = 1f0
  end

  cfg = @cfg vert_shader!(zeros(SVec{Float32,4}))
  ir = @compile vert_shader!(zeros(SVec{Float32,4}))
  @test validate(ir)
  ir = make_shader(cfg, ShaderInterface(SPIRV.ExecutionModelVertex, [SPIRV.StorageClassOutput]))
  mod = SPIRV.Module(ir)
  #FIXME: The conversion of operands from strings to concrete values
  # requires getting operand infos, which themselves rely
  # on arguments to determine if there are extra parameters.
  # The error is currently triggered on OpDecorate instructions.
  @test mod == parse(SPIRV.Module, """
    OpCapability(VulkanMemoryModel)
    OpCapability(Shader)
    OpExtension("SPV_KHR_vulkan_memory_model")
    OpMemoryModel(Logical, Vulkan)
    OpEntryPoint(Vertex, %18, "main", %5)
    OpName(%7, "vert_shader!_Tuple{GenericVector{Float32,4}}")
    OpName(%5, "out_color")
  %2 = OpTypeFloat(0x00000020)
  %3 = OpTypeVector(%2, 0x00000004)
  %4 = OpTypePointer(Output, %3)
  %5 = OpVariable(Output)::%4
  %6 = OpTypeFunction(%2)
  %10 = OpTypeInt(0x00000020, 0x00000000)
  %11 = OpConstant(0x00000003)::%10
  %12 = OpTypePointer(Output, %2)
  %14 = OpConstant(0x3f800000)::%2
  %16 = OpTypeVoid()
  %17 = OpTypeFunction(%16)
  %7 = OpFunction(None, %6)::%2
  %8 = OpLabel()
  %13 = OpAccessChain(%5, %11)::%12
    OpStore(%13, %14)
    OpReturnValue(%14)
    OpFunctionEnd()
  %18 = OpFunction(None, %17)::%16
  %19 = OpLabel()
  %20 = OpFunctionCall(%7)::%2
    OpReturn()
    OpFunctionEnd()
  """)
  # Make sure the absence of Location decoration raises an error.
  @test_throws SPIRV.ValidationError validate_shader(ir)

  ir = make_shader(cfg, ShaderInterface(SPIRV.ExecutionModelVertex, [SPIRV.StorageClassOutput], dictionary([1 => dictionary([SPIRV.DecorationLocation => [UInt32(0)]])])))
  @test validate_shader(ir)
end
