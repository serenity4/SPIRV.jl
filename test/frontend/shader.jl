using SPIRV, Test, Dictionaries, Accessors

SUPPORTED_FEATURES = SupportedFeatures(
  [
    "SPV_KHR_vulkan_memory_model",
    "SPV_EXT_physical_storage_buffer"
  ],
  [
    SPIRV.CapabilityVulkanMemoryModel,
    SPIRV.CapabilityShader,
    SPIRV.CapabilityInt64,
    SPIRV.CapabilityPhysicalStorageBufferAddresses
  ]
)

interp_novulkan = SPIRVInterpreter([INTRINSICS_GLSL_METHOD_TABLE, INTRINSICS_METHOD_TABLE])

@testset "Shader interface" begin
  function vert_shader!(out_color)
    out_color.a = 1f0
  end

  cfg = @cfg vert_shader!(::SVec{Float32,4})
  ir = compile(cfg, AllSupported())
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

  function vert_shader_2!(out_color)
    out_color[] = SVec(0.1f0, 0.1f0, 0.1f0, 1f0)
  end

  cfg = @cfg vert_shader_2!(::SVec{Float32,4})
  ir = compile(cfg, AllSupported())
  @test validate(ir)
  interface = ShaderInterface(SPIRV.ExecutionModelVertex, [SPIRV.StorageClassOutput], dictionary([1 => dictionary([SPIRV.DecorationLocation => [UInt32(0)]])]))
  ir = make_shader(cfg, interface)
  @test validate_shader(ir)

  struct Point
    x::Float32
    y::Float32
  end

  function vert_shader_3!(out_pos, point)
    out_pos.x = point.x
    out_pos.y = point.y
  end

  cfg = @cfg vert_shader_3!(::SVec{Float32,4}, ::Point)
  ir = compile(cfg, AllSupported())
  @test validate(ir)
  interface = ShaderInterface(SPIRV.ExecutionModelVertex,
    [SPIRV.StorageClassOutput, SPIRV.StorageClassUniform],
    dictionary([
      1 => dictionary([SPIRV.DecorationLocation => UInt32[0]]),
      2 => dictionary([SPIRV.DecorationUniform => [], SPIRV.DecorationDescriptorSet => UInt32[0], SPIRV.DecorationBinding => UInt32[0]]),
    ]),
    dictionary([
      Point => dictionary([SPIRV.DecorationBlock => []]),
      (Point => :x) => dictionary([SPIRV.DecorationOffset => UInt32[0]]),
      (Point => :y) => dictionary([SPIRV.DecorationOffset => UInt32[4]]),
    ])
  )

  ir = make_shader(cfg, interface)
  @test validate_shader(ir)

  # Let SPIRV figure out member offsets automatically.
  interface = @set interface.type_decorations = dictionary([Point => dictionary([SPIRV.DecorationBlock => []])])
  ir = make_shader(cfg, interface)
  @test validate_shader(ir)

  # Test built-in logic.
  function vert_shader_4!(frag_color, index, position)
    frag_color.x = index
    position.x = index
  end

  cfg = @cfg vert_shader_4!(::SVec{Float32, 4}, ::UInt32, ::SVec{Float32, 4})
  SPIRV.@code_typed vert_shader_4!(::SVec{Float32, 4}, ::UInt32, ::SVec{Float32, 4})
  ir = compile(cfg, AllSupported())
  @test validate(ir)
  interface = ShaderInterface(SPIRV.ExecutionModelVertex,
    [SPIRV.StorageClassOutput, SPIRV.StorageClassInput, SPIRV.StorageClassOutput],
    dictionary([
      1 => dictionary([SPIRV.DecorationLocation => UInt32[0]]),
      2 => dictionary([SPIRV.DecorationBuiltIn => [SPIRV.BuiltInVertexIndex]]),
      3 => dictionary([SPIRV.DecorationBuiltIn => [SPIRV.BuiltInPosition]]),
    ]),
  )
  ir = make_shader(cfg, interface)
  @test validate_shader(ir)

  struct DrawData
    camera::UInt64
    vbuffer::UInt64
    material::UInt64
  end

  struct VertexData
    pos::SVec{Float32,2}
    color::NTuple{3,Float32}
  end

  function vert_shader_5!(frag_color, position, index, dd)
    vd = Pointer{Vector{VertexData}}(dd.vbuffer)[index]
    (; pos, color) = vd
    position[] = SVec(pos.x, pos.y, 0f0, 1f0)
    frag_color[] = SVec(color[1], color[2], color[3], 1f0)
  end

  # Non-Vulkan interpreter
  cfg = @cfg interp_novulkan vert_shader_5!(::SVec{Float32, 4}, ::SVec{Float32, 4}, ::UInt32, ::DrawData)
  ir = compile(cfg, AllSupported())
  # Access to PhysicalStorageBuffer must use Aligned.
  @test_throws SPIRV.ValidationError validate(ir)

  # Default Vulkan interpreter
  cfg = @cfg vert_shader_5!(::SVec{Float32, 4}, ::SVec{Float32, 4}, ::UInt32, ::DrawData)
  ir = compile(cfg, AllSupported())
  # Access to PhysicalStorageBuffer must use Aligned.
  @test_throws SPIRV.ValidationError validate(ir)

  interface = ShaderInterface(
    storage_classes = [SPIRV.StorageClassOutput, SPIRV.StorageClassOutput, SPIRV.StorageClassInput, SPIRV.StorageClassPushConstant],
    variable_decorations = dictionary([
      1 => dictionary([SPIRV.DecorationLocation => UInt32[0]]),
      2 => dictionary([SPIRV.DecorationBuiltIn => [SPIRV.BuiltInPosition]]),
      3 => dictionary([SPIRV.DecorationBuiltIn => [SPIRV.BuiltInVertexIndex]]),
    ]),
    type_decorations = dictionary([
      DrawData => dictionary([SPIRV.DecorationBlock => []]),
    ]),
    features = SUPPORTED_FEATURES,
  )
  ir = make_shader(cfg, interface)
  @test validate_shader(ir)
end
