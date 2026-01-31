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

shader!(position) = (position[] = Vec(1f0, 1f0, 1f0, 1f0))
shader2!(color) = @swizzle color.a = 1F

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
    target = @target shader2!(::Mutable{Vec4})
    ir = compile(target, AllSupported())
    @test unwrap(validate(ir))
    interface = ShaderInterface(SPIRV.ExecutionModelVertex; storage_classes = [SPIRV.StorageClassOutput])
    shader = Shader(ShaderInfo(target.mi, interface))
    mod = SPIRV.Module(shader)
    @test mod == parse(
      SPIRV.Module,
        """
        Capability(VulkanMemoryModel)
        Capability(Shader)
        MemoryModel(Logical, Vulkan)
        EntryPoint(Vertex, %13, "main", %4)
        Name(%6, "$(SPIRV.function_name(target.mi))")
        Name(%4, "color")
   %1 = TypeFloat(0x00000020)
   %2 = TypeVector(%1, 0x00000004)
   %3 = TypePointer(Output, %2)
   %4 = Variable(Output)::%3
   %5 = TypeFunction(%2)
   %9 = Constant(0x3f800000)::%1
  %11 = TypeVoid()
  %12 = TypeFunction(%11)
   %6 = Function(None, %5)::%2
   %7 = Label()
   %8 = Load(%4)::%2
  %10 = CompositeInsert(%9, %8, 0x00000003)::%2
        Store(%4, %10)
        ReturnValue(%10)
        FunctionEnd()
  %13 = Function(None, %12)::%11
  %14 = Label()
  %15 = FunctionCall(%6)::%2
        Return()
        FunctionEnd()
  """,
    )
    # Make sure the absence of Location decoration raises an error.
    @test_throws "must be decorated with a location" unwrap(validate(shader))

    set!(interface.variable_decorations, 1, Decorations(SPIRV.DecorationLocation, 0))
    shader = Shader(ShaderInfo(target.mi, interface))
    @test unwrap(validate(shader))

    shader = @vertex (color -> color[] = Vec(0.1F, 0.1F, 0.1F, 1F))(::Mutable{Vec4}::Output)
    @test unwrap(validate(shader))
  end

  @testset "Shader macro API" begin
    @test_throws "More than one built-in" @eval @fragment any_shader(::UInt32::Input{VertexIndex, InstanceIndex})
    @test_throws "Expected macrocall" @eval @fragment any_shader(::UInt32::Input{VertexIndex, DescriptorSet = 1})
    @test_throws "Unknown storage class" @eval @fragment any_shader(::UInt32::Typo{VertexIndex, DescriptorSet = 1})
    @test_throws "Unknown decoration" @eval @fragment any_shader(::UInt32::Input{VertexIndex, @Typo(1)})
    @test_throws "Only one non-keyword expression" @eval @fragment VulkanLayout() any_shader(::UInt32::Input{VertexIndex, @Typo(1)})

    prelude, argtypes, scs, vardecs, type_metadata = shader_decorations(:(any_shader(::Vec4::Uniform{@DescriptorSet(1)})))
    @test argtypes == [:Vec4]
    @test scs == [SPIRV.StorageClassUniform]
    @test vardecs == dictionary([1 => Decorations(SPIRV.DecorationDescriptorSet, 1)])

    prelude, argtypes, scs, vardecs, type_metadata = shader_decorations(:(any_shader(::UInt32::Input{@Flat})))
    @test argtypes == [:UInt32]
    @test scs == [SPIRV.StorageClassInput]
    @test vardecs == dictionary([1 => Decorations(SPIRV.DecorationFlat).decorate!(SPIRV.DecorationLocation, 0)])

    prelude, argtypes, scs, vardecs, type_metadata = shader_decorations(:(any_shader(::UInt32::Input{@Flat}, ::Vec4::Input{Position}, ::Vec4::Input)))
    @test argtypes == [:UInt32, :Vec4, :Vec4]
    @test scs == [SPIRV.StorageClassInput, SPIRV.StorageClassInput, SPIRV.StorageClassInput]
    @test vardecs == dictionary([
      1 => Decorations(SPIRV.DecorationFlat).decorate!(SPIRV.DecorationLocation, 0),
      2 => Decorations(SPIRV.DecorationBuiltIn, SPIRV.BuiltInPosition),
      3 => Decorations(SPIRV.DecorationLocation, 1),
    ])

    prelude, argtypes, scs, vardecs, type_metadata = shader_decorations(:(any_shader(::Mutable{Vec3}::Output, ::GaussianBlur::Input, ::UInt32::Input{@Flat}, ::Vec2::Input)))
    @test argtypes == [:(Mutable{Vec3}), :GaussianBlur, :UInt32, :Vec2]
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

    frag_shader = @fragment features = SUPPORTED_FEATURES shader!(::Mutable{Vec4}::Output)
    @test isa(frag_shader, Shader)

    any_hit_shader = @with SPIRV.METHOD_TABLES => [INTRINSICS_GLSL_METHOD_TABLE, INTRINSICS_METHOD_TABLE] @any_hit features = RAY_TRAYCING_FEATURES shader!(::Mutable{Vec4}::Output)
    @test isa(any_hit_shader, Shader)

    compute_shader = @compute features = SUPPORTED_FEATURES assemble = true Returns(nothing)()
    @test isa(compute_shader, ShaderSource)
    @test Vk.ShaderStageFlag(compute_shader) == Vk.SHADER_STAGE_COMPUTE_BIT

    prelude, argtypes, scs, vardecs, type_metadata = shader_decorations(:(any_shader(::Arr{128, Float32}::Workgroup, ::Vec3::Input{GlobalInvocationId})))
    @test argtypes == [:(Arr{128, Float32}), :Vec3]
    @test scs == [SPIRV.StorageClassWorkgroup, SPIRV.StorageClassInput]

    prelude, argtypes, scs, vardecs, type_metadata = shader_decorations(:(any_shader(::Vec3U::Input{WorkgroupSize}, ::UInt32::Constant{1U}, ::Vec2::Constant{uv = zero(Vec2)})))

    @test argtypes == [:Vec3U, :UInt32, :Vec2]
    @test scs == [SPIRV.StorageClassSpecConstantINTERNAL, SPIRV.StorageClassConstantINTERNAL, SPIRV.StorageClassSpecConstantINTERNAL]
    @test vardecs == dictionary([
      1 => Decorations(SPIRV.DecorationInternal, :local_size => Vec3U(1, 1, 1)),
      2 => Decorations(SPIRV.DecorationInternal, 1U),
      3 => Decorations(SPIRV.DecorationInternal, :uv => zero(Vec2)),
    ])

    @testset "Shader cache" begin
      cache = ShaderCompilationCache()
      @test cache.diagnostics.misses == cache.diagnostics.hits == 0
      SPIRV.HAS_WARNED_ABOUT_CACHE[] = false
      @test_logs (:warn, r"will not be cached") @fragment cache shader!(::Mutable{Vec4}::Output)
      @test_logs @fragment cache shader!(::Mutable{Vec4}::Output)

      @fragment cache assemble = true shader!(::Mutable{Vec4}::Output)
      @test cache.diagnostics.hits == 0
      @test cache.diagnostics.misses == 1
      @test !isempty(cache)

      @fragment cache assemble = true shader!(::Mutable{Vec4}::Output)
      @test cache.diagnostics.hits == 1
      @test cache.diagnostics.misses == 1
      @test length(cache) == 1

      @fragment cache assemble = true shader!(::Mutable{Vec{4,Float64}}::Output)
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
    shader = @vertex (function (out_pos, point)
        out_pos.x = point.x
        out_pos.y = point.y
      end)(::Mutable{Vec4}::Output, ::Point::Uniform{@DescriptorSet(0), @Binding(0)})
    @test unwrap(validate(shader))

    # With built-ins.
    shader = @vertex (function (frag_color, index, position)
        frag_color.x = index
        position.x = index
      end)(::Mutable{Vec4}::Output, ::UInt32::Input{VertexIndex}, ::Mutable{Vec4}::Output{Position})
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
    shader = @vertex features = SUPPORTED_FEATURES (function (frag_color, position, index, dd)
        vd = @load dd.vbuffer[index]::VertexData
        (; pos, color) = vd
        position[] = Vec(pos.x, pos.y, 0F, 1F)
        frag_color[] = Vec(color[1U], color[2U], color[3U], 1F)
      end)(::Mutable{Vec4}::Output, ::Mutable{Vec4}::Output{Position}, ::UInt32::Input{VertexIndex}, ::DrawData::PushConstant)
    @test unwrap(validate(shader))

    shader = @fragment features = SUPPORTED_FEATURES ((out_color, frag_color) -> out_color[] = frag_color)(::Mutable{Vec4}::Output, ::Vec4::Input)
    @test unwrap(validate(shader))

    shader = @compute features = SUPPORTED_FEATURES (function (buffer, index)
        buffer[index] = buffer[index] + 1U
      end)(::Mutable{Arr{128, Float32}}::Workgroup, ::UInt32::Input{LocalInvocationIndex})
    @test unwrap(validate(shader))

    shader = @compute features = SUPPORTED_FEATURES ((size, val, uv) -> nothing)(::Vec3U::Input{WorkgroupSize}, ::UInt32::Constant{8U}, ::Vec2::Constant{uv = zero(Vec2)}) options = ComputeExecutionOptions(local_size = (3, 5, 10))
    @test unwrap(validate(shader))
    m = SPIRV.Module(shader)
    @test count(inst -> inst.opcode == SPIRV.OpSpecConstant && inst.arguments[1] ≠ 0U, m) == 3
    source = ShaderSource(shader)
    @test length(source.specializations[:local_size]) == 3
    @test length(source.specializations[:uv]) == 2

    @testset "Barrier instructions" begin
      shader = @compute features = SUPPORTED_FEATURES (function ()
        SPIRV.ControlBarrier(SPIRV.ScopeWorkgroup, SPIRV.ScopeWorkgroup, SPIRV.MemorySemanticsNone)
        SPIRV.MemoryBarrier(SPIRV.ScopeWorkgroup, SPIRV.MemorySemanticsWorkgroupMemory | SPIRV.MemorySemanticsAcquireRelease)
      end)()
      @test unwrap(validate(shader))
    end

    @testset "Structured control-flow" begin
      shader = @vertex features = SUPPORTED_FEATURES (function (out, x)
          y = x > 0F ? x + 1F : x - 1F
          out.x = y
        end)(::Mutable{Vec4}::Output, ::Float32::Input)
      @test unwrap(validate(shader))

      IT = SampledImage{SPIRV.image_type(SPIRV.ImageFormatRgba16f,SPIRV.Dim2D,0,false,false,1)}

      shader = @fragment features = SUPPORTED_FEATURES ((res, blur, reference, direction, uv) -> res[] =
        compute_blur(blur, reference, direction, uv))(::Mutable{Vec4}::Output, ::GaussianBlur::PushConstant, ::IT::UniformConstant{@DescriptorSet(0), @Binding(0)}, ::UInt32::Input{@Flat}, ::Vec2::Input)
      @test unwrap(validate(shader))
      optimized = unwrap(optimize(shader))
      @test unwrap(validate(optimized))
      @test length(assemble(optimized)) < length(assemble(shader))

      shader = @fragment features = SUPPORTED_FEATURES ((res, blur, reference, uv) -> res[] =
        compute_blur_2(blur, reference, uv))(::Mutable{Vec4}::Output, ::GaussianBlur::PushConstant, ::IT::UniformConstant{@DescriptorSet(0), @Binding(0)}, ::Vec2::Input)
      @test unwrap(validate(shader))

      shader = @compute features = SUPPORTED_FEATURES step_euler(::BoidAgent::PushConstant, ::Vec2::Input, ::Float32::Input)
      @test unwrap(validate(shader))
    end
  end
end;
