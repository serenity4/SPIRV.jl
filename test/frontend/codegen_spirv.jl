using SPIRV, Test

base_capabilities = """
  Capability(VulkanMemoryModel)
"""
shader_capabilities = """
  $base_capabilities
  Capability(Shader)
"""
base_extensions = """
"""
memory_model = "OpMemoryModel(Logical, Vulkan)"

interp = SPIRVInterpreter()

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

@testset "SPIR-V code generation" begin
  @test_throws SPIRV.CompilationError @compile (x -> unknown(x))(::Int)
  @test_throws "[1]" @compile (x -> unknown(x))(::Int)

  @testset "Composite SPIR-V types" begin
    function unicolor(position)
      Vec(position.x, position.y, 1F, 1F)
    end

    ir = @compile unicolor(::Vec{4, Float32})
    @test unwrap(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
        """
        $base_capabilities
        $base_extensions
        $memory_model
   %1 = TypeFloat(0x00000020)
   %2 = TypeVector(%1, 0x00000004)
   %3 = TypeFunction(%2, %2)
   %9 = Constant(0x3f800000)::%1
   %4 = Function(None, %3)::%2
   %5 = FunctionParameter()::%2
   %6 = Label()
   %7 = CompositeExtract(%5, 0x00000000)::%1
   %8 = CompositeExtract(%5, 0x00000001)::%1
  %10 = CompositeConstruct(%7, %8, %9, %9)::%2
        ReturnValue(%10)
        FunctionEnd()
      """
    )

    struct StructWithBool
      x::Bool
      y::Int32
    end

    ir = @compile StructWithBool(::Bool, ::Int32)
    @test unwrap(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
        """
        $base_capabilities
        $base_extensions
        $memory_model
   %1 = TypeBool()
   %2 = TypeInt(0x00000020, 0x00000001)
   %3 = TypeStruct(%1, %2)
   %4 = TypeFunction(%3, %1, %2)
   %5 = Function(None, %4)::%3
   %6 = FunctionParameter()::%1
   %7 = FunctionParameter()::%2
   %8 = Label()
   %9 = CompositeConstruct(%6, %7)::%3
        ReturnValue(%9)
        FunctionEnd()
      """
    )

    struct StructWithMat
      x::Bool
      mat::Mat4
    end

    ir = @compile StructWithMat(::Bool, ::Mat4)
    @test unwrap(validate(ir))
  end

  @testset "Images & textures" begin
    function sample(sampled_image::SampledImage)
      sampled_image(3f0, 4f0)
    end

    ir = @compile sample(::SampledImage{IT})
    @test unwrap(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
        """
        $shader_capabilities
        $base_extensions
        $memory_model
   %1 = TypeFloat(0x00000020)
   %2 = TypeVector(%1, 0x00000004)
   %3 = TypeImage(%1, 2D, 0x00000000, 0x00000000, 0x00000000, 0x00000001, Rgba16f)
   %4 = TypeSampledImage(%3)
   %5 = TypeFunction(%2, %4)
   %9 = Constant(0x40400000)::%1
  %10 = Constant(0x40800000)::%1
  %11 = TypeVector(%1, 0x00000002)
  %12 = ConstantComposite(%9, %10)::%11
   %6 = Function(None, %5)::%2
   %7 = FunctionParameter()::%4
   %8 = Label()
  %13 = ImageSampleImplicitLod(%7, %12)::%2
        ReturnValue(%13)
        FunctionEnd()
      """
    )

    function sample(image, sampler)
      sampled = combine(image, sampler)
      sampled(3f0, 4f0)
    end

    ir = @compile sample(::IT, ::Sampler)
    @test unwrap(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
        """
        $shader_capabilities
        $base_extensions
        $memory_model
   %1 = TypeFloat(0x00000020)
   %2 = TypeVector(%1, 0x00000004)
   %3 = TypeImage(%1, 2D, 0x00000000, 0x00000000, 0x00000000, 0x00000001, Rgba16f)
   %4 = TypeSampler()
   %5 = TypeFunction(%2, %3, %4)
  %11 = Constant(0x40400000)::%1
  %12 = Constant(0x40800000)::%1
  %13 = TypeVector(%1, 0x00000002)
  %14 = ConstantComposite(%11, %12)::%13
  %16 = TypeSampledImage(%3)
   %6 = Function(None, %5)::%2
   %7 = FunctionParameter()::%3
   %8 = FunctionParameter()::%4
   %9 = Label()
  %10 = SampledImage(%7, %8)::%16
  %15 = ImageSampleImplicitLod(%10, %14)::%2
        ReturnValue(%15)
        FunctionEnd()
      """
    )
  end

  @testset "Intrinsics" begin
    ir = @compile clamp(::Float64, ::Float64, ::Float64)
    @test unwrap(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
        """
        $base_capabilities
        Capability(Float64)
        $base_extensions
   %8 = ExtInstImport("GLSL.std.450")
        $memory_model
   %1 = TypeFloat(0x00000040)
   %2 = TypeFunction(%1, %1, %1, %1)
   %3 = Function(None, %2)::%1
   %4 = FunctionParameter()::%1
   %5 = FunctionParameter()::%1
   %6 = FunctionParameter()::%1
   %7 = Label()
   %9 = ExtInst(%8, FClamp, %4, %5, %6)::%1
        ReturnValue(%9)
        FunctionEnd()
    """,
    )

    ir = @compile f_extinst(::Float32)
    @test unwrap(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
        """
        $base_capabilities
        $base_extensions
   %6 = ExtInstImport("GLSL.std.450")
        $memory_model
   %1 = TypeFloat(0x00000020)
   %2 = TypeFunction(%1, %1)
   %9 = Constant(0x40400000)::%1
  %11 = Constant(0x3f800000)::%1
   %3 = Function(None, %2)::%1
   %4 = FunctionParameter()::%1
   %5 = Label()
   %7 = ExtInst(%6, Exp, %4)::%1
   %8 = ExtInst(%6, Sin, %4)::%1
  %10 = FMul(%9, %8)::%1
  %12 = FAdd(%11, %10)::%1
  %13 = ExtInst(%6, Log, %12)::%1
  %14 = FAdd(%13, %7)::%1
        ReturnValue(%14)
        FunctionEnd()
    """,
    )
  end

  @testset "Broadcasting" begin
    broadcast_test(v, arr, image) = image(Vec2(1, 2)) .* v .* arr[1U] .* 2f0

    v = Vec4(1, 2, 3, 4)
    image = SampledImage(IT(zeros(32, 32)))
    arr = Arr(0f0)
    @test broadcast_test(v, arr, image) == zero(Vec4)

    ir = @compile broadcast_test(::Vec4, ::Arr{1, Float32}, ::SampledImage{IT})
    @test unwrap(validate(ir))
  end

  @testset "Control flow" begin
    @testset "Straight code functions" begin
      ir = @compile f_straightcode(::Float32)
      @test unwrap(validate(ir))
      @test ir ≈ parse(
        SPIRV.Module,
          """
          $base_capabilities
          $base_extensions
          $memory_model
     %1 = TypeFloat(0x00000020)
     %2 = TypeFunction(%1, %1)
     %6 = Constant(0x3f800000)::%1
     # Constant literals are not interpreted as floating point values.
     # Doing so would require the knowledge of types, expressed in the IR.
     %8 = Constant(0x40400000)::%1
     %3 = Function(None, %2)::%1
     %4 = FunctionParameter()::%1
     %5 = Label()
     %7 = FAdd(%4, %6)::%1
     %9 = FMul(%8, %7)::%1
    %10 = FMul(%9, %9)::%1
            OpReturnValue(%10)
            OpFunctionEnd()
    """,
      )
    end

    @testset "Conditionals" begin
      f_branch(x) = x > 0F ? x + 1F : x - 1F
      ir = @compile f_branch(::Float32)
      @test unwrap(validate(ir))

      @test ir ≈ parse(
        SPIRV.Module,
          """
          $base_capabilities
          $base_extensions
          $memory_model
     %1 = TypeFloat(0x00000020)
     %2 = TypeFunction(%1, %1)
     %8 = Constant(0x00000000)::%1
    %10 = Constant(0x3f800000)::%1
    %13 = TypeBool()
     %3 = Function(None, %2)::%1
     %4 = FunctionParameter()::%1
     %5 = Label()
     %9 = FOrdLessThan(%8, %4)::%13
          BranchConditional(%9, %6, %7)
     %6 = Label()
    %11 = FAdd(%4, %10)::%1
          ReturnValue(%11)
     %7 = Label()
    %12 = FSub(%4, %10)::%1
          ReturnValue(%12)
          FunctionEnd()
        """,
      )
      function f_branches(x)
        y = clamp(x, 0F, 1F)
        if iszero(y)
          z = x^2
          z > 1F && return z
          x += z
        else
          x -= 1F
        end
        x < 0F && return y
        x + y
      end

      ir = @compile f_branches(::Float32)
      @test unwrap(validate(ir))
      @test ir ≈ parse(
        SPIRV.Module,
          """
          $base_capabilities
          $base_extensions
    %13 = ExtInstImport("GLSL.std.450")
          $memory_model
     %1 = TypeFloat(0x00000020)
     %2 = TypeFunction(%1, %1)
    %14 = Constant(0x00000000)::%1
    %15 = Constant(0x3f800000)::%1
    %25 = TypeBool()
     %3 = Function(None, %2)::%1
     %4 = FunctionParameter()::%1
     %5 = Label()
    %16 = ExtInst(%13, FClamp, %4, %14, %15)::%1
    %17 = FOrdEqual(%16, %14)::%25
          BranchConditional(%17, %6, %9)
     %6 = Label()
    %18 = FMul(%4, %4)::%1
    %19 = FOrdLessThan(%15, %18)::%25
          BranchConditional(%19, %7, %8)
     %7 = Label()
          ReturnValue(%18)
     %8 = Label()
    %20 = FAdd(%4, %18)::%1
          Branch(%10)
     %9 = Label()
    %21 = FSub(%4, %15)::%1
          Branch(%10)
    %10 = Label()
    %22 = Phi(%20 => %8, %21 => %9)::%1
    %23 = FOrdLessThan(%22, %14)::%25
          BranchConditional(%23, %11, %12)
    %11 = Label()
          ReturnValue(%16)
    %12 = Label()
    %24 = FAdd(%22, %16)::%1
          ReturnValue(%24)
          FunctionEnd()
        """
      )
    end

    @testset "Loops" begin
      ir = @compile SUPPORTED_FEATURES interp compute_blur(::GaussianBlur, ::SampledImage{IT}, ::UInt32, ::Vec2)
      # Unfortunately, the Khronos validator seems to disallow loops without merge header,
      # even for generic SPIR-V modules that don't require structured control-flow.
      # So we only test for validation rules until that one.
      @test_throws "can only be formed between a block and a loop header" unwrap(validate(ir))

      ir = @compile SUPPORTED_FEATURES interp compute_blur_2(::GaussianBlur, ::SampledImage{IT}, ::Vec2)
      @test_throws "can only be formed between a block and a loop header" unwrap(validate(ir))
    end
  end

  @testset "Coverage of intrinsics and Base functions" begin
    @test unwrap(validate(@compile (x -> UInt32(ceil(x)))(::Float32)))
    @test unwrap(validate(@compile (x -> exp(sin(acos(x))))(::Float32)))
    @test unwrap(validate(@compile (x -> round(x, RoundNearest))(::Float32)))
    @test unwrap(validate(@compile trunc(::Float32)))
    @test unwrap(validate(@compile (x -> trunc(UInt32, x))(::Float32)))
    @test_throws "Memory accesses with PhysicalStorageBuffer must use Aligned" unwrap(validate(@compile (x -> @store x::Int32 = Int32(0))(::UInt64)))
  end

  @testset "(===) support" begin
    egal(x, y) = x === y
    ir = @compile egal(::Float32, ::Float32)
    expected = @spv_ir begin
      Bool = TypeBool()
      Float32 = TypeFloat(32)
      @function (===)(x::Float32, y::Float32)::Bool begin
        _ = Label()
        same = FOrdEqual(x, y)::Bool
        ReturnValue(same)
      end
    end
    @test unwrap(validate(expected))
    @test ir ≈ expected

    ir = @compile egal(::Tuple{Float32}, ::Tuple{Float32})
    expected = @spv_ir begin
      Bool = TypeBool()
      Float32 = TypeFloat(32)
      TupleF32 = TypeStruct(Float32)
      @function (===)(x::TupleF32, y::TupleF32)::Bool begin
        _ = Label()
        _x = CompositeExtract(x, 0U)::Float32
        _y = CompositeExtract(y, 0U)::Float32
        same = FOrdEqual(_x, _y)::Bool
        ReturnValue(same)
      end
    end
    @test unwrap(validate(expected))
    @test ir ≈ expected renumber = true

    ir = @compile egal(::GaussianBlur, ::GaussianBlur)
    expected = @spv_ir begin
      Bool = TypeBool()
      Float32 = TypeFloat(32)
      GaussianBlur = TypeStruct(Float32, Float32)
      @function (===)(x::GaussianBlur, y::GaussianBlur)::Bool begin
        _ = Label()
        scale_x = CompositeExtract(x, 0U)::Float32
        scale_y = CompositeExtract(y, 0U)::Float32
        same_scale = FOrdEqual(scale_x, scale_y)::Bool
        strength_x = CompositeExtract(x, 1U)::Float32
        strength_y = CompositeExtract(y, 1U)::Float32
        same_strength = FOrdEqual(strength_x, strength_y)::Bool
        result = LogicalAnd(same_scale, same_strength)::Bool
        ReturnValue(result)
      end
    end
    @test unwrap(validate(expected))
    @test ir ≈ expected renumber = true

    ir = @compile egal(::_BoidAgent, ::_BoidAgent)
    expected = @spv_ir begin
      Bool = TypeBool()
      Float32 = TypeFloat(32)
      Vec2 = TypeVector(Float32, 2U)
      BoidAgent = TypeStruct(Vec2, Vec2, Float32)
      # XXX: The Vec2B type is inserted after the function definition,
      # which is impossible to express given the current DSL. That should be addressed some time.
      FType = TypeFunction(Bool, BoidAgent, BoidAgent)
      Vec2B = TypeVector(Bool, 2U)
      (===) = Function(SPIRV.FunctionControlNone, FType)::Bool
      x = FunctionParameter()::BoidAgent
      y = FunctionParameter()::BoidAgent
      _ = Label()
      position_x = CompositeExtract(x, 0U)::Vec2
      position_y = CompositeExtract(y, 0U)::Vec2
      same_positions = FOrdEqual(position_x, position_y)::Vec2B
      same_position = All(same_positions)::Bool
      velocity_x = CompositeExtract(x, 1U)::Vec2
      velocity_y = CompositeExtract(y, 1U)::Vec2
      same_velocities = FOrdEqual(velocity_x, velocity_y)::Vec2B
      same_velocity = All(same_velocities)::Bool
      mass_x = CompositeExtract(x, 2U)::Float32
      mass_y = CompositeExtract(y, 2U)::Float32
      same_mass = FOrdEqual(mass_x, mass_y)::Bool
      result_1 = LogicalAnd(same_position, same_velocity)::Bool
      result_2 = LogicalAnd(result_1, same_mass)::Bool
      ReturnValue(result_2)
      FunctionEnd()
    end
    @test unwrap(validate(expected))
    @test ir ≈ expected renumber = true

    ir = @compile egal(::SMatrix{3,2,Float32,4}, ::SMatrix{3,2,Float32,4})
    expected = @spv_ir begin
      Bool = TypeBool()
      Float32 = TypeFloat(32)
      Vec3 = TypeVector(Float32, 3)
      Mat3x2 = TypeMatrix(Vec3, 2)
      # XXX: The Vec3B type is inserted after the function definition,
      # which is impossible to express given the current DSL. That should be addressed some time.
      FType = TypeFunction(Bool, Mat3x2, Mat3x2)
      Vec3B = TypeVector(Bool, 3)
      (===) = Function(SPIRV.FunctionControlNone, FType)::Bool
      x = FunctionParameter()::Mat3x2
      y = FunctionParameter()::Mat3x2
      _ = Label()
      col1x = CompositeExtract(x, 0U)::Vec3
      col1y = CompositeExtract(y, 0U)::Vec3
      same_col1s = FOrdEqual(col1x, col1y)::Vec3B
      same_col1 = All(same_col1s)::Bool
      col2x = CompositeExtract(x, 1U)::Vec3
      col2y = CompositeExtract(y, 1U)::Vec3
      same_col2s = FOrdEqual(col2x, col2y)::Vec3B
      same_col2 = All(same_col2s)::Bool
      result = LogicalAnd(same_col1, same_col2)::Bool
      ReturnValue(result)
      FunctionEnd()
    end
    @test unwrap(validate(expected))
    @test ir ≈ expected renumber = true
  end

  @testset "Mesh shaders" begin
    struct MeshOutput
      position::SPIRV.Vec4
      point_size::Float32
      clip_distance::Arr{1,Float32}
      cull_distance::Arr{1,Float32}
    end

    function mesh_shader!(mesh_output::Mutable{Arr{3,MeshOutput}}, triangle_indices::Mutable{Arr{2,SPIRV.Vec3U}})
      mesh_output[1] = MeshOutput(
        SPIRV.Vec4(-1,-1,0, 1.f0),
        1f0,
        @arr([1f0]),
        @arr([1f0]),
      )
      mesh_output[2] = MeshOutput(
        SPIRV.Vec4(0,1,0, 1.f0),
        1f0,
        @arr([1f0]),
        @arr([1f0]),
      )
      mesh_output[3] = MeshOutput(
        SPIRV.Vec4(1,-1,0, 1.f0),
        1f0,
        @arr([1f0]),
        @arr([1f0]),
      )
      triangle_indices[1] = SPIRV.Vec3U(0,1,2)
    end

    shader = @mesh mesh_shader!(::Mutable{Arr{3,MeshOutput}}::Output{MeshPerVertex}, ::Mutable{Arr{2,SPIRV.Vec3U}}::Output{PrimitiveTriangleIndicesEXT}) options=SPIRV.MeshExecutionOptions(output=:triangles, max_vertices=8, max_primitives=2)

    @test unwrap(validate(shader))
  end
end;
