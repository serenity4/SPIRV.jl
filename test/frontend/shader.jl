using SPIRV, Test, Dictionaries, Accessors
using SPIRV: validate, EntryPoint, add_options!, shader_decorations
using Vulkan: Vk

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
RAY_TRAYCING_FEATURES = union(SUPPORTED_FEATURES, SupportedFeatures(["SPV_KHR_ray_tracing"], [SPIRV.CapabilityRayTracingKHR]))

interp_novulkan = SPIRVInterpreter([INTRINSICS_GLSL_METHOD_TABLE, INTRINSICS_METHOD_TABLE]);

@testset "Shaders" begin
  @testset "Shader execution options" begin
    for execution_model in [SPIRV.ExecutionModelVertex, SPIRV.ExecutionModelFragment, SPIRV.ExecutionModelGLCompute, SPIRV.ExecutionModelGeometry, SPIRV.ExecutionModelTessellationControl, SPIRV.ExecutionModelTessellationEvaluation, SPIRV.ExecutionModelMeshNV, SPIRV.ExecutionModelAnyHitKHR]
      opts = ShaderExecutionOptions(execution_model)
      @test validate(opts, execution_model)
      ep = EntryPoint(:main, ResultID(1), execution_model)
      add_options!(ep, opts)
      @test allunique(ep.modes)
    end
    opts = FragmentExecutionOptions(origin = :upper_right)
    @test_throws "Invalid value `:upper_right`" validate(opts)
  end

  @testset "Basic construction" begin
    shader! = color -> color.a = 1F
    target = @target shader!(::Vec4)
    ir = compile(target, AllSupported())
    @test unwrap(validate(ir))
    interface = ShaderInterface(SPIRV.ExecutionModelVertex; storage_classes = [SPIRV.StorageClassOutput])
    shader = Shader(target, interface, VulkanAlignment())
    mod = SPIRV.Module(shader)
    @test mod == parse(
      SPIRV.Module,
        """
        OpCapability(PhysicalStorageBufferAddresses)
        OpCapability(VulkanMemoryModel)
        OpExtension("SPV_EXT_physical_storage_buffer")
        OpMemoryModel(PhysicalStorageBuffer64, Vulkan)
        OpEntryPoint(Vertex, %14, "main", %4)
        OpName(%6, "$(shader!)_Tuple{Vec4}")
        OpName(%4, "color")
   %1 = OpTypeFloat(0x00000020)
   %2 = OpTypeVector(%1, 0x00000004)
   %3 = OpTypePointer(Output, %2)
   %4 = OpVariable(Output)::%3
   %5 = OpTypeFunction(%1)
   %8 = OpTypeInt(0x00000020, 0x00000000)
   %9 = OpConstant(0x00000003)::%8
  %11 = OpConstant(0x3f800000)::%1
  %12 = OpTypeVoid()
  %13 = OpTypeFunction(%12)
  %17 = OpTypePointer(Output, %1)
   %6 = OpFunction(None, %5)::%1
   %7 = OpLabel()
  %10 = OpAccessChain(%4, %9)::%17
        OpStore(%10, %11)
        OpReturnValue(%11)
        OpFunctionEnd()
  %14 = OpFunction(None, %13)::%12
  %15 = OpLabel()
  %16 = OpFunctionCall(%6)::%1
        OpReturn()
        OpFunctionEnd()
  """,
    )
    # Make sure the absence of Location decoration raises an error.
    @test_throws "must be decorated with a location" unwrap(validate(shader))

    set!(interface.variable_decorations, 1, Decorations(SPIRV.DecorationLocation, 0))
    shader = Shader(target, interface, VulkanAlignment())
    @test unwrap(validate(shader))

    shader = @vertex AllSupported() VulkanAlignment() (color -> color[] = Vec(0.1F, 0.1F, 0.1F, 1F))(::Vec4::Output)
    @test unwrap(validate(shader))
  end

  @testset "`@shader` macro" begin
    shader! = position -> position[] = Vec(1f0, 1f0, 1f0, 1f0)

    @test_throws r"LayoutStrategy.* expected" @eval @fragment SUPPORTED_FEATURES "" shader!(::Vec4::Output)
    @test_throws r"ShaderCompilationCache.* expected" @eval @fragment SUPPORTED_FEATURES VulkanAlignment() cache = "" shader!(::Vec4::Output) 
    @test_throws "More than one built-in" @eval @fragment SUPPORTED_FEATURES VulkanAlignment() any_shader(::UInt32::Input{VertexIndex, InstanceIndex})
    @test_throws "Expected macrocall" @eval @fragment SUPPORTED_FEATURES VulkanAlignment() any_shader(::UInt32::Input{VertexIndex, DescriptorSet = 1})
    @test_throws "Unknown storage class" @eval @fragment SUPPORTED_FEATURES VulkanAlignment() any_shader(::UInt32::Typo{VertexIndex, DescriptorSet = 1})
    @test_throws "Unknown decoration" @eval @fragment SUPPORTED_FEATURES VulkanAlignment() any_shader(::UInt32::Input{VertexIndex, @Typo(1)})

    argtypes, scs, vardecs = shader_decorations(:(any_shader(::Vec4::Uniform{@DescriptorSet(1)})))
    @test argtypes == [:Vec4]
    @test scs == [SPIRV.StorageClassUniform]
    @test vardecs == dictionary([1 => Decorations(SPIRV.DecorationDescriptorSet, 1)])

    argtypes, scs, vardecs = shader_decorations(:(any_shader(::UInt32::Input{@Flat})))
    @test argtypes == [:UInt32]
    @test scs == [SPIRV.StorageClassInput]
    @test vardecs == dictionary([1 => Decorations(SPIRV.DecorationFlat).decorate!(SPIRV.DecorationLocation, 0)])

    argtypes, scs, vardecs = shader_decorations(:(any_shader(::UInt32::Input{@Flat}, ::Vec4::Input{Position}, ::Vec4::Input)))
    @test argtypes == [:UInt32, :Vec4, :Vec4]
    @test scs == [SPIRV.StorageClassInput, SPIRV.StorageClassInput, SPIRV.StorageClassInput]
    @test vardecs == dictionary([
      1 => Decorations(SPIRV.DecorationFlat).decorate!(SPIRV.DecorationLocation, 0),
      2 => Decorations(SPIRV.DecorationBuiltIn, SPIRV.BuiltInPosition),
      3 => Decorations(SPIRV.DecorationLocation, 1),
    ])

    argtypes, scs, vardecs = shader_decorations(:(any_shader(::Vec3::Output, ::GaussianBlur::Input, ::UInt32::Input{@Flat}, ::Vec2::Input)))
    @test argtypes == [:Vec3, :GaussianBlur, :UInt32, :Vec2]
    @test scs == [SPIRV.StorageClassOutput, SPIRV.StorageClassInput, SPIRV.StorageClassInput, SPIRV.StorageClassInput]
    # XXX: Implement a more clever `Location` assignment strategy, currently we just bump by 1 after assignment.
    # Here we need the first bump to be by 2.
    # See https://registry.khronos.org/vulkan/specs/1.3-extensions/html/chap15.html#interfaces-iointerfaces-locations
    @test_broken vardecs == dictionary([
      3 => Decorations(SPIRV.DecorationLocation, 0),
      4 => Decorations(SPIRV.DecorationLocation, 0),
      1 => Decorations(SPIRV.DecorationFlat).decorate!(SPIRV.DecorationLocation, 2),
      2 => Decorations(SPIRV.DecorationLocation, 3),
    ])

    frag_shader = @fragment SUPPORTED_FEATURES VulkanAlignment() shader!(::Vec4::Output)
    @test isa(frag_shader, Shader)

    @test frag_shader == @shader :fragment SUPPORTED_FEATURES VulkanAlignment() shader!(::Vec4::Output)

    any_hit_shader = @any_hit RAY_TRAYCING_FEATURES VulkanAlignment() interpreter = interp_novulkan shader!(::Vec4::Output)
    @test isa(any_hit_shader, Shader)

    compute_shader = @compute SUPPORTED_FEATURES VulkanAlignment() assemble = true Returns(nothing)()
    @test isa(compute_shader, ShaderSource)
    @test Vk.ShaderStageFlag(compute_shader) == Vk.SHADER_STAGE_COMPUTE_BIT

    @testset "Shader cache" begin
      cache = ShaderCompilationCache()
      @test cache.diagnostics.misses == cache.diagnostics.hits == 0
      SPIRV.HAS_WARNED_ABOUT_CACHE[] = false
      @test_logs (:warn, r"will not be cached") @fragment AllSupported() VulkanAlignment() cache shader!(::Vec4::Output)
      @test_logs @fragment AllSupported() VulkanAlignment() cache shader!(::Vec4::Output)

      @fragment AllSupported() VulkanAlignment() cache assemble = true shader!(::Vec4::Output)
      @test cache.diagnostics.hits == 0
      @test cache.diagnostics.misses == 1
      @test !isempty(cache)

      @fragment AllSupported() VulkanAlignment() cache assemble = true shader!(::Vec4::Output)
      @test cache.diagnostics.hits == 1
      @test cache.diagnostics.misses == 1
      @test length(cache) == 1

      @fragment AllSupported() VulkanAlignment() cache assemble = true shader!(::Vec{4,Float64}::Output)
      @test cache.diagnostics.hits == 1
      @test cache.diagnostics.misses == 2
      @test length(cache) == 2

      empty!(cache)
      @test isempty(cache)
    end
  end;

  @testset "Shader compilation" begin
    # With custom decorations.
    struct Point
      x::Float32
      y::Float32
    end
    shader = @vertex AllSupported() VulkanAlignment() (function (out_pos, point)
        out_pos.x = point.x
        out_pos.y = point.y
      end)(::Vec4::Output, ::Point::Uniform{@DescriptorSet(0), @Binding(0)})
    @test unwrap(validate(shader))

    # With built-ins.
    shader = @vertex AllSupported() VulkanAlignment() (function (frag_color, index, position)
        frag_color.x = index
        position.x = index
      end)(::Vec4::Output, ::UInt32::Input{VertexIndex}, ::Vec4::Output{Position})
    @test unwrap(validate(shader))

    # Loading data from phyiscal storage buffers.
    struct DrawData
      camera::UInt64
      vbuffer::UInt64
      material::UInt64
    end
    struct VertexData
      pos::Vec2
      color::NTuple{3,Float32}
    end
    shader = @vertex SUPPORTED_FEATURES VulkanAlignment() (function (frag_color, position, index, dd)
        vd = @load dd.vbuffer[index]::VertexData
        (; pos, color) = vd
        position[] = Vec(pos.x, pos.y, 0F, 1F)
        frag_color[] = Vec(color[1U], color[2U], color[3U], 1F)
      end)(::Vec4::Output, ::Vec4::Output{Position}, ::UInt32::Input{VertexIndex}, ::DrawData::PushConstant)
    @test unwrap(validate(shader))

    shader = @fragment SUPPORTED_FEATURES VulkanAlignment() ((out_color, frag_color) -> out_color[] = frag_color)(::Vec4::Output, ::Vec4::Input)
    @test unwrap(validate(shader))

    @testset "Structured control-flow" begin
      shader = @vertex SUPPORTED_FEATURES VulkanAlignment() (function (out, x)
          y = x > 0F ? x + 1F : x - 1F
          out.x = y
        end)(::Vec4::Output, ::Float32::Input)
      @test unwrap(validate(shader))

      IT = SampledImage{SPIRV.image_type(SPIRV.ImageFormatR16f,SPIRV.Dim2D,0,false,false,1)}

      shader = @fragment SUPPORTED_FEATURES VulkanAlignment() ((res, blur, reference, direction, uv) -> res[] =
        compute_blur(blur, reference, direction, uv))(::Vec3::Output, ::GaussianBlur::PushConstant, ::IT::UniformConstant{@DescriptorSet(0), @Binding(0)}, ::UInt32::Input{@Flat}, ::Vec2::Input)
      @test unwrap(validate(shader))

      shader = @fragment SUPPORTED_FEATURES VulkanAlignment() ((res, blur, reference, uv) -> res[] =
        compute_blur_2(blur, reference, uv))(::Vec3::Output, ::GaussianBlur::PushConstant, ::IT::UniformConstant{@DescriptorSet(0), @Binding(0)}, ::Vec2::Input)
      @test unwrap(validate(shader))

      shader = @compute SUPPORTED_FEATURES VulkanAlignment() step_euler(::BoidAgent::PushConstant, ::Vec2::Input, ::Float32::Input)
      @test unwrap(validate(shader))
    end
  end
end;
