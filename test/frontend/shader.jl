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
    SPIRV.CapabilityVariablePointers,
    SPIRV.CapabilityStorageImageExtendedFormats,
    SPIRV.CapabilityImageQuery,
  ],
)

interp_novulkan = SPIRVInterpreter([INTRINSICS_GLSL_METHOD_TABLE, INTRINSICS_METHOD_TABLE]);

@testset "Shader interface" begin
  function vert_shader!(out_color)
    out_color.a = 1F
  end

  target = @target vert_shader!(::Vec4)
  ir = compile(target, AllSupported())
  @test unwrap(validate(ir))
  shader = Shader(target, ShaderInterface(SPIRV.ExecutionModelVertex, [SPIRV.StorageClassOutput]))
  mod = SPIRV.Module(shader)
  @test mod == parse(
    SPIRV.Module,
      """
      OpCapability(PhysicalStorageBufferAddresses)
      OpCapability(VulkanMemoryModel)
      OpExtension("SPV_EXT_physical_storage_buffer")
      OpExtension("SPV_KHR_vulkan_memory_model")
      OpMemoryModel(PhysicalStorageBuffer64, Vulkan)
      OpEntryPoint(Vertex, %15, "main", %4)
      OpName(%12, "vert_shader!_Tuple{Vec4}")
      OpName(%4, "out_color")
 %1 = OpTypeFloat(0x00000020)
 %2 = OpTypeVector(%1, 0x00000004)
 %3 = OpTypePointer(Output, %2)
 %4 = OpVariable(Output)::%3
 %5 = OpTypeFunction(%1)
 %6 = OpTypeInt(0x00000020, 0x00000000)
 %7 = OpConstant(0x00000003)::%6
 %8 = OpConstant(0x3f800000)::%1
 %9 = OpTypeVoid()
%10 = OpTypeFunction(%9)
%11 = OpTypePointer(Output, %1)
%12 = OpFunction(None, %5)::%1
%13 = OpLabel()
%14 = OpAccessChain(%4, %7)::%11
      OpStore(%14, %8)
      OpReturnValue(%8)
      OpFunctionEnd()
%15 = OpFunction(None, %10)::%9
%16 = OpLabel()
%17 = OpFunctionCall(%12)::%1
      OpReturn()
      OpFunctionEnd()
""",
  )
  # Make sure the absence of Location decoration raises an error.
  @test iserror(validate(shader))

  function vert_shader_2!(out_color)
    out_color[] = Vec(0.1F, 0.1F, 0.1F, 1F)
  end

  target = @target vert_shader_2!(::Vec4)
  ir = compile(target, AllSupported())
  @test unwrap(validate(ir))
  interface = ShaderInterface(SPIRV.ExecutionModelVertex, [SPIRV.StorageClassOutput], dictionary([1 => Decorations(SPIRV.DecorationLocation, 0)]))
  shader = Shader(target, interface)
  @test unwrap(validate(shader))

  struct Point
    x::Float32
    y::Float32
  end

  function vert_shader_3!(out_pos, point)
    out_pos.x = point.x
    out_pos.y = point.y
  end

  target = @target vert_shader_3!(::Vec4, ::Point)
  ir = compile(target, AllSupported())
  @test unwrap(validate(ir))
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

  shader = Shader(target, interface)
  @test unwrap(validate(shader))

  # Let SPIRV figure out member offsets automatically.
  interface = @set interface.type_metadata = dictionary([Point => Metadata().decorate!(SPIRV.DecorationBlock)])
  shader = Shader(target, interface)
  @test unwrap(validate(shader))

  # Test built-in logic.
  function vert_shader_4!(frag_color, index, position)
    frag_color.x = index
    position.x = index
  end

  target = @target vert_shader_4!(::Vec4, ::UInt32, ::Vec4)
  ir = compile(target, AllSupported())
  @test unwrap(validate(ir))
  interface = ShaderInterface(SPIRV.ExecutionModelVertex,
    [SPIRV.StorageClassOutput, SPIRV.StorageClassInput, SPIRV.StorageClassOutput],
    dictionary([
      1 => Decorations(SPIRV.DecorationLocation, 0),
      2 => Decorations(SPIRV.DecorationBuiltIn, SPIRV.BuiltInVertexIndex),
      3 => Decorations(SPIRV.DecorationBuiltIn, SPIRV.BuiltInPosition),
    ]),
  )
  shader = Shader(target, interface)
  @test unwrap(validate(shader))

  struct DrawData
    camera::UInt64
    vbuffer::UInt64
    material::UInt64
  end

  struct VertexData
    pos::Vec2
    color::NTuple{3,Float32}
  end

  function vert_shader_5!(frag_color, position, index, dd)
    vd = @load dd.vbuffer[index]::VertexData
    (; pos, color) = vd
    position[] = Vec(pos.x, pos.y, 0F, 1F)
    frag_color[] = Vec(color[1U], color[2U], color[3U], 1F)
  end

  # Non-Vulkan interpreter
  target = @target interp_novulkan vert_shader_5!(::Vec4, ::Vec4, ::UInt32, ::DrawData)
  ir = compile(target, AllSupported())
  # Access to PhysicalStorageBuffer must use Aligned.
  @test iserror(validate(ir))

  # Default Vulkan interpreter
  target = @target vert_shader_5!(::Vec4, ::Vec4, ::UInt32, ::DrawData)
  ir = compile(target, AllSupported())
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
  shader = Shader(target, interface)
  @test unwrap(validate(shader))

  # Test that `Block` decorations are inserted properly for the push constant.
  interface = @set interface.type_metadata = Dictionary()
  shader = Shader(target, interface)
  @test unwrap(validate(shader))

  # WIP
  # ir = IR()
  # t = SPIRV.spir_type(Float32, ir; storage_class = SPIRV.StorageClassPushConstant)
  # @test isa(t, SPIRV.StructType)

  function frag_shader!(out_color, frag_color)
    out_color[] = frag_color
  end

  target = @target frag_shader!(::Vec4, ::Vec4)
  interface = ShaderInterface(
    execution_model = SPIRV.ExecutionModelFragment,
    storage_classes = [SPIRV.StorageClassOutput, SPIRV.StorageClassInput],
    variable_decorations = dictionary([
      1 => Decorations(SPIRV.DecorationLocation, 0),
      2 => Decorations(SPIRV.DecorationLocation, 0),
    ]),
  )
  shader = Shader(target, interface)
  @test unwrap(validate(shader))

  @testset "Structured control-flow" begin
    function vert_branch!(out, x)
      y = x > 0F ? x + 1F : x - 1F
      out.x = y
    end

    target = @target vert_branch!(::Vec4, ::Float32)
    ir = compile(target, AllSupported())
    @test unwrap(validate(ir))
    interface = ShaderInterface(SPIRV.ExecutionModelVertex,
      [SPIRV.StorageClassOutput, SPIRV.StorageClassInput],
      dictionary([
        1 => Decorations(SPIRV.DecorationLocation, 0),
        2 => Decorations(SPIRV.DecorationLocation, 0),
      ]),
    )
    shader = Shader(target, interface)
    @test unwrap(validate(shader))


    function compute_blur!(res::Vec3, blur::GaussianBlur, reference, direction, uv)
      res[] = compute_blur(blur, reference, direction, uv)
    end

    target = @target compute_blur!(::Vec3, ::GaussianBlur, ::SPIRV.SampledImage{SPIRV.image_type(SPIRV.ImageFormatR16f,SPIRV.Dim2D,0,false,false,1)}, ::UInt32, ::Vec2)
    interface = ShaderInterface(;
      execution_model = SPIRV.ExecutionModelFragment,
      storage_classes = [SPIRV.StorageClassOutput, SPIRV.StorageClassInput, SPIRV.StorageClassUniformConstant, SPIRV.StorageClassInput, SPIRV.StorageClassInput],
      variable_decorations = dictionary([
        1 => Decorations(SPIRV.DecorationLocation, 0),
        2 => Decorations(SPIRV.DecorationLocation, 0),
        3 => Decorations(SPIRV.DecorationDescriptorSet, 0).decorate!(SPIRV.DecorationBinding, 0),
        4 => Decorations(SPIRV.DecorationLocation, 2),
        5 => Decorations(SPIRV.DecorationLocation, 3),
      ]),
      features = SUPPORTED_FEATURES,
    )
    shader = Shader(target, interface)
    @test unwrap(validate(shader))

    function compute_blur_2!(res::Vec3, blur::GaussianBlur, reference, uv)
      res[] = compute_blur_2(blur, reference, uv)
    end

    target = @target compute_blur_2!(::Vec3, ::GaussianBlur, ::SPIRV.SampledImage{SPIRV.image_type(SPIRV.ImageFormatR16f,SPIRV.Dim2D,0,false,false,1)}, ::Vec2)
    interface = ShaderInterface(;
      execution_model = SPIRV.ExecutionModelFragment,
      storage_classes = [SPIRV.StorageClassOutput, SPIRV.StorageClassInput, SPIRV.StorageClassUniformConstant, SPIRV.StorageClassInput],
      variable_decorations = dictionary([
        1 => Decorations(SPIRV.DecorationLocation, 0),
        2 => Decorations(SPIRV.DecorationLocation, 0),
        3 => Decorations(SPIRV.DecorationDescriptorSet, 0).decorate!(SPIRV.DecorationBinding, 0),
        4 => Decorations(SPIRV.DecorationLocation, 2),
      ]),
      features = SUPPORTED_FEATURES,
    )
    shader = Shader(target, interface)
    @test unwrap(validate(shader))
  end
end;
