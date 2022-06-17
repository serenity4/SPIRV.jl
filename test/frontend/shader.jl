using SPIRV, Test, Dictionaries, Accessors

SUPPORTED_FEATURES = SupportedFeatures(
  [
    "SPV_KHR_vulkan_memory_model",
    "SPV_EXT_physical_storage_buffer",
  ],
  [
    SPIRV.CapabilityVulkanMemoryModel,
    SPIRV.CapabilityShader,
    SPIRV.CapabilityInt64,
    SPIRV.CapabilityPhysicalStorageBufferAddresses,
  ],
)

interp_novulkan = SPIRVInterpreter([INTRINSICS_GLSL_METHOD_TABLE, INTRINSICS_METHOD_TABLE]);

@testset "Shader interface" begin
  function vert_shader!(out_color)
    out_color.a = 1F
  end

  cfg = @cfg vert_shader!(::Vec{4,Float32})
  SPIRV.@code_typed vert_shader!(::Vec{4,Float32})
  ir = compile(cfg, AllSupported())
  @test !iserror(validate(ir))
  ir = make_shader(cfg, ShaderInterface(SPIRV.ExecutionModelVertex, [SPIRV.StorageClassOutput]))
  mod = SPIRV.Module(ir)
  @test mod == parse(
    SPIRV.Module,
    """
  OpCapability(VulkanMemoryModel)
  OpCapability(Shader)
  OpExtension("SPV_KHR_vulkan_memory_model")
  OpMemoryModel(Logical, Vulkan)
  OpEntryPoint(Vertex, %18, "main", %5)
  OpName(%7, "vert_shader!_Tuple{Vec{4,Float32}}")
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
""",
  )
  # Make sure the absence of Location decoration raises an error.
  @test iserror(validate_shader(ir))

  function vert_shader_2!(out_color)
    out_color[] = Vec(0.1F, 0.1F, 0.1F, 1F)
  end

  cfg = @cfg vert_shader_2!(::Vec{4,Float32})
  ir = compile(cfg, AllSupported())
  @test !iserror(validate(ir))
  interface = ShaderInterface(SPIRV.ExecutionModelVertex, [SPIRV.StorageClassOutput], dictionary([1 => Decorations(SPIRV.DecorationLocation, 0)]))
  ir = make_shader(cfg, interface)
  @test !iserror(validate_shader(ir))

  struct Point
    x::Float32
    y::Float32
  end

  function vert_shader_3!(out_pos, point)
    out_pos.x = point.x
    out_pos.y = point.y
  end

  cfg = @cfg vert_shader_3!(::Vec{4,Float32}, ::Point)
  ir = compile(cfg, AllSupported())
  @test !iserror(validate(ir))
  interface = ShaderInterface(SPIRV.ExecutionModelVertex,
    [SPIRV.StorageClassOutput, SPIRV.StorageClassUniform],
    dictionary([
      1 => Decorations(SPIRV.DecorationLocation, 0),
      2 => Decorations(SPIRV.DecorationUniform).
        decorate!(SPIRV.DecorationDescriptorSet, 0).
        decorate!(SPIRV.DecorationBinding, 0),
    ]),
    dictionary([
      Point => Metadata().
        decorate!(SPIRV.DecorationBlock).
        decorate!(1, SPIRV.DecorationOffset, 0).
        decorate!(2, SPIRV.DecorationOffset, 4)
    ]),
  )

  ir = make_shader(cfg, interface)
  @test !iserror(validate_shader(ir))

  # Let SPIRV figure out member offsets automatically.
  interface = @set interface.type_metadata = dictionary([Point => Metadata().decorate!(SPIRV.DecorationBlock)])
  ir = make_shader(cfg, interface)
  @test !iserror(validate_shader(ir))

  # Test built-in logic.
  function vert_shader_4!(frag_color, index, position)
    frag_color.x = index
    position.x = index
  end

  cfg = @cfg vert_shader_4!(::Vec{4,Float32}, ::UInt32, ::Vec{4,Float32})
  SPIRV.@code_typed vert_shader_4!(::Vec{4,Float32}, ::UInt32, ::Vec{4,Float32})
  ir = compile(cfg, AllSupported())
  @test !iserror(validate(ir))
  interface = ShaderInterface(SPIRV.ExecutionModelVertex,
    [SPIRV.StorageClassOutput, SPIRV.StorageClassInput, SPIRV.StorageClassOutput],
    dictionary([
      1 => Decorations(SPIRV.DecorationLocation, 0),
      2 => Decorations(SPIRV.DecorationBuiltIn, SPIRV.BuiltInVertexIndex),
      3 => Decorations(SPIRV.DecorationBuiltIn, SPIRV.BuiltInPosition),
    ]),
  )
  ir = make_shader(cfg, interface)
  @test !iserror(validate_shader(ir))

  struct DrawData
    camera::UInt64
    vbuffer::UInt64
    material::UInt64
  end

  struct VertexData
    pos::Vec{2,Float32}
    color::NTuple{3,Float32}
  end

  function vert_shader_5!(frag_color, position, index, dd)
    vd = Pointer{Vector{VertexData}}(dd.vbuffer)[index]
    (; pos, color) = vd
    position[] = Vec(pos.x, pos.y, 0F, 1F)
    frag_color[] = Vec(color[1U], color[2U], color[3U], 1F)
  end

  # Non-Vulkan interpreter
  cfg = @cfg interp_novulkan vert_shader_5!(::Vec{4,Float32}, ::Vec{4,Float32}, ::UInt32, ::DrawData)
  ir = compile(cfg, AllSupported())
  # Access to PhysicalStorageBuffer must use Aligned.
  @test iserror(validate(ir))

  # Default Vulkan interpreter
  cfg = @cfg vert_shader_5!(::Vec{4,Float32}, ::Vec{4,Float32}, ::UInt32, ::DrawData)
  ir = compile(cfg, AllSupported())
  # Access to PhysicalStorageBuffer must use Aligned.
  @test iserror(validate(ir))

  interface = ShaderInterface(
    storage_classes = [SPIRV.StorageClassOutput, SPIRV.StorageClassOutput, SPIRV.StorageClassInput, SPIRV.StorageClassPushConstant],
    variable_decorations = dictionary([
      1 => Decorations(SPIRV.DecorationLocation, 0),
      2 => Decorations(SPIRV.DecorationBuiltIn, SPIRV.BuiltInPosition),
      3 => Decorations(SPIRV.DecorationBuiltIn, SPIRV.BuiltInVertexIndex),
    ]),
    type_metadata = dictionary([
      DrawData => Metadata().decorate!(SPIRV.DecorationBlock),
    ]),
    features = SUPPORTED_FEATURES,
  )
  ir = make_shader(cfg, interface)
  @test !iserror(validate_shader(ir))

  # Test that `Block` decorations are inserted properly for the push constant.
  interface = @set interface.type_metadata = Dictionary()
  ir = make_shader(cfg, interface)
  @test !iserror(validate_shader(ir))

  # WIP
  # ir = IR()
  # t = SPIRV.spir_type(Float32, ir; storage_class = SPIRV.StorageClassPushConstant)
  # @test isa(t, SPIRV.StructType)

  function frag_shader!(out_color, frag_color)
    out_color[] = frag_color
  end

  cfg = @cfg frag_shader!(::Vec{4,Float32}, ::Vec{4,Float32})
  interface = ShaderInterface(
    execution_model = SPIRV.ExecutionModelFragment,
    storage_classes = [SPIRV.StorageClassOutput, SPIRV.StorageClassInput],
    variable_decorations = dictionary([
      1 => Decorations(SPIRV.DecorationLocation, 0),
      2 => Decorations(SPIRV.DecorationLocation, 0),
    ]),
  )
  ir = make_shader(cfg, interface)
  @test !iserror(validate_shader(ir))
end
