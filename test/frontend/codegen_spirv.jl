using SPIRV, Test

@testset "SPIR-V code generation" begin
  @testset "Straight code functions" begin
    ir = @compile f_straightcode(::Float32)
    @test unwrap(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
        """
        OpCapability(VulkanMemoryModel)
        OpExtension("SPV_KHR_vulkan_memory_model")
        OpMemoryModel(Logical, Vulkan)
   %1 = OpTypeFloat(0x00000020)
   %2 = OpTypeFunction(%1, %1)
   %6 = OpConstant(0x3f800000)::%1
   # Constant literals are not interpreted as floating point values.
   # Doing so would require the knowledge of types, expressed in the IR.
   %8 = OpConstant(0x40400000)::%1
   %3 = OpFunction(None, %2)::%1
   %4 = OpFunctionParameter()::%1
   %5 = OpLabel()
   %7 = OpFAdd(%4, %6)::%1
   %9 = OpFMul(%8, %7)::%1
  %10 = OpFMul(%9, %9)::%1
          OpReturnValue(%10)
          OpFunctionEnd()
  """,
    )

    ir = @compile SPIRVInterpreter([INTRINSICS_METHOD_TABLE]) clamp(::Float64, ::Float64, ::Float64)
    @test unwrap(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
        """
        OpCapability(VulkanMemoryModel)
        OpCapability(Float64)
        OpExtension("SPV_KHR_vulkan_memory_model")
        OpMemoryModel(Logical, Vulkan)
   %1 = OpTypeFloat(0x00000040)
   %2 = OpTypeFunction(%1, %1, %1, %1)
   %8 = OpTypeBool()
   %3 = OpFunction(None, %2)::%1
   %4 = OpFunctionParameter()::%1
   %5 = OpFunctionParameter()::%1
   %6 = OpFunctionParameter()::%1
   %7 = OpLabel()
   %9 = OpFOrdLessThan(%6, %4)::%8
  %10 = OpFOrdLessThan(%4, %5)::%8
  %11 = OpSelect(%10, %5, %4)::%1
  %12 = OpSelect(%9, %6, %11)::%1
        OpReturnValue(%12)
        OpFunctionEnd()
    """,
    )
  end

  @testset "Intrinsics" begin
    ir = @compile clamp(::Float64, ::Float64, ::Float64)
    @test unwrap(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
        """
        OpCapability(VulkanMemoryModel)
        OpCapability(Float64)
        OpExtension("SPV_KHR_vulkan_memory_model")
   %8 = OpExtInstImport("GLSL.std.450")
        OpMemoryModel(Logical, Vulkan)
   %1 = OpTypeFloat(0x00000040)
   %2 = OpTypeFunction(%1, %1, %1, %1)
   %3 = OpFunction(None, %2)::%1
   %4 = OpFunctionParameter()::%1
   %5 = OpFunctionParameter()::%1
   %6 = OpFunctionParameter()::%1
   %7 = OpLabel()
   %9 = OpExtInst(%8, FClamp, %4, %5, %6)::%1
        OpReturnValue(%9)
        OpFunctionEnd()
    """,
    )

    ir = @compile f_extinst(::Float32)
    @test unwrap(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
        """
        OpCapability(VulkanMemoryModel)
        OpExtension("SPV_KHR_vulkan_memory_model")
   %6 = OpExtInstImport("GLSL.std.450")
        OpMemoryModel(Logical, Vulkan)
   %1 = OpTypeFloat(0x00000020)
   %2 = OpTypeFunction(%1, %1)
   %9 = OpConstant(0x40400000)::%1
  %11 = OpConstant(0x3f800000)::%1
   %3 = OpFunction(None, %2)::%1
   %4 = OpFunctionParameter()::%1
   %5 = OpLabel()
   %7 = OpExtInst(%6, Exp, %4)::%1
   %8 = OpExtInst(%6, Sin, %4)::%1
  %10 = OpFMul(%9, %8)::%1
  %12 = OpFAdd(%11, %10)::%1
  %13 = OpExtInst(%6, Log, %12)::%1
  %14 = OpFAdd(%13, %7)::%1
        OpReturnValue(%14)
        OpFunctionEnd()
    """,
    )
  end

  @testset "Control flow" begin
    @testset "Branches" begin
      f_branch(x) = x > 0F ? x + 1F : x - 1F
      ir = @compile f_branch(::Float32)
      @test unwrap(validate(ir))

      @test ir ≈ parse(
        SPIRV.Module,
          """
          OpCapability(VulkanMemoryModel)
          OpExtension("SPV_KHR_vulkan_memory_model")
          OpMemoryModel(Logical, Vulkan)
     %1 = OpTypeFloat(0x00000020)
     %2 = OpTypeFunction(%1, %1)
     %8 = OpConstant(0x00000000)::%1
     %9 = OpTypeBool()
    %11 = OpConstant(0x3f800000)::%1
     %3 = OpFunction(None, %2)::%1
     %4 = OpFunctionParameter()::%1
     %5 = OpLabel()
    %10 = OpFOrdLessThan(%8, %4)::%9
          OpSelectionMerge(%6, None)
          OpBranchConditional(%10, %6, %7)
     %6 = OpLabel()
    %12 = OpFAdd(%4, %11)::%1
          OpReturnValue(%12)
     %7 = OpLabel()
    %13 = OpFSub(%4, %11)::%1
          OpReturnValue(%13)
          OpFunctionEnd()
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
          OpCapability(VulkanMemoryModel)
          OpExtension("SPV_KHR_vulkan_memory_model")
    %13 = OpExtInstImport("GLSL.std.450")
          OpMemoryModel(Logical, Vulkan)
     %1 = OpTypeFloat(0x00000020)
     %2 = OpTypeFunction(%1, %1)
    %14 = OpConstant(0x00000000)::%1
    %15 = OpConstant(0x3f800000)::%1
    %17 = OpTypeBool()
     %3 = OpFunction(None, %2)::%1
     %4 = OpFunctionParameter()::%1
     %5 = OpLabel()
    %16 = OpExtInst(%13, FClamp, %4, %14, %15)::%1
    %18 = OpFOrdEqual(%16, %14)::%17
          OpSelectionMerge(%10, None)
          OpBranchConditional(%18, %6, %9)
     %6 = OpLabel()
    %19 = OpFMul(%4, %4)::%1
    %20 = OpFOrdLessThan(%15, %19)::%17
          OpSelectionMerge(%7, None)
          OpBranchConditional(%20, %7, %8)
     %7 = OpLabel()
          OpReturnValue(%19)
     %8 = OpLabel()
    %21 = OpFAdd(%4, %19)::%1
          OpBranch(%10)
     %9 = OpLabel()
    %22 = OpFSub(%4, %15)::%1
          OpBranch(%10)
    %10 = OpLabel()
    %23 = OpPhi(%21 => %8, %22 => %9)::%1
    %24 = OpFOrdLessThan(%23, %14)::%17
          OpSelectionMerge(%11, None)
          OpBranchConditional(%24, %11, %12)
    %11 = OpLabel()
          OpReturnValue(%16)
    %12 = OpLabel()
    %25 = OpFAdd(%23, %16)::%1
          OpReturnValue(%25)
          OpFunctionEnd()
        """
      )
    end
  end

  @testset "Composite SPIR-V types" begin
    function unicolor(position)
      Vec(position.x, position.y, 1F, 1F)
    end

    ir = @compile unicolor(::Vec{4, Float32})
    @test unwrap(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
        """
        OpCapability(VulkanMemoryModel)
        OpExtension("SPV_KHR_vulkan_memory_model")
        OpMemoryModel(Logical, Vulkan)
   %1 = OpTypeFloat(0x00000020)
   %2 = OpTypeVector(%1, 0x00000004)
   %3 = OpTypePointer(Function, %2)
   %4 = OpTypeFunction(%2, %3)
  %13 = OpConstant(0x3f800000)::%1
   %5 = OpFunction(None, %4)::%2
   %6 = OpFunctionParameter()::%3
   %7 = OpLabel()
  %12 = OpVariable(Function)::%3
   %8 = OpLoad(%6)::%2
   %9 = OpCompositeExtract(%8, 0x00000000)::%1
  %10 = OpLoad(%6)::%2
  %11 = OpCompositeExtract(%10, 0x00000001)::%1
  %14 = OpCompositeConstruct(%9, %11, %13, %13)::%2
        OpStore(%12, %14)
  %15 = OpLoad(%12)::%2
        OpReturnValue(%15)
        OpFunctionEnd()
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
        OpCapability(VulkanMemoryModel)
        OpExtension("SPV_KHR_vulkan_memory_model")
        OpMemoryModel(Logical, Vulkan)
   %1 = OpTypeBool()
   %2 = OpTypeInt(0x00000020, 0x00000001)
   %3 = OpTypeStruct(%1, %2)
   %4 = OpTypeFunction(%3, %1, %2)
   %5 = OpFunction(None, %4)::%3
   %6 = OpFunctionParameter()::%1
   %7 = OpFunctionParameter()::%2
   %8 = OpLabel()
   %9 = OpCompositeConstruct(%6, %7)::%3
        OpReturnValue(%9)
        OpFunctionEnd()
      """
    )
  end

  @testset "Images & textures" begin
    function sample(sampled_image::SampledImage)
      sampled_image(3f0, 4f0)
    end

    ir = @compile sample(::SampledImage{Image{Float32,SPIRV.Dim2D,0,false,false,1,SPIRV.ImageFormatRgba16f}})
    @test unwrap(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
        """
        OpCapability(VulkanMemoryModel)
        OpCapability(Shader)
        OpExtension("SPV_KHR_vulkan_memory_model")
        OpMemoryModel(Logical, Vulkan)
   %1 = OpTypeFloat(0x00000020)
   %2 = OpTypeVector(%1, 0x00000004)
   %3 = OpTypeImage(%1, 2D, 0x00000000, 0x00000000, 0x00000000, 0x00000001, Rgba16f)
   %4 = OpTypeSampledImage(%3)
   %5 = OpTypeFunction(%2, %4)
  %10 = OpTypeVector(%1, 0x00000002)
  %11 = OpTypePointer(Function, %10)
  %12 = OpConstant(0x40400000)::%1
  %13 = OpConstant(0x40800000)::%1
  %16 = OpTypePointer(Function, %2)
   %6 = OpFunction(None, %5)::%2
   %7 = OpFunctionParameter()::%4
   %8 = OpLabel()
   %9 = OpVariable(Function)::%11
  %15 = OpVariable(Function)::%16
  %14 = OpCompositeConstruct(%12, %13)::%10
        OpStore(%9, %14)
  %17 = OpLoad(%9)::%10
  %18 = OpImageSampleImplicitLod(%7, %17)::%2
        OpStore(%15, %18)
  %19 = OpLoad(%15)::%2
        OpReturnValue(%19)
        OpFunctionEnd()
      """
    )

    function sample(image, sampler)
      sampled = combine(image, sampler)
      sampled(3f0, 4f0)
    end

    ir = @compile sample(::Image{Float32,SPIRV.Dim2D,0,false,false,1,SPIRV.ImageFormatRgba16f}, ::Sampler)
    @test unwrap(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
        """
        OpCapability(VulkanMemoryModel)
        OpCapability(Shader)
        OpExtension("SPV_KHR_vulkan_memory_model")
        OpMemoryModel(Logical, Vulkan)
   %1 = OpTypeFloat(0x00000020)
   %2 = OpTypeVector(%1, 0x00000004)
   %3 = OpTypeImage(%1, 2D, 0x00000000, 0x00000000, 0x00000000, 0x00000001, Rgba16f)
   %4 = OpTypeSampler()
   %5 = OpTypeFunction(%2, %3, %4)
  %10 = OpTypeSampledImage(%3)
  %13 = OpTypeVector(%1, 0x00000002)
  %14 = OpTypePointer(Function, %13)
  %15 = OpConstant(0x40400000)::%1
  %16 = OpConstant(0x40800000)::%1
  %19 = OpTypePointer(Function, %2)
   %6 = OpFunction(None, %5)::%2
   %7 = OpFunctionParameter()::%3
   %8 = OpFunctionParameter()::%4
   %9 = OpLabel()
  %12 = OpVariable(Function)::%14
  %18 = OpVariable(Function)::%19
  %11 = OpSampledImage(%7, %8)::%10
  %17 = OpCompositeConstruct(%15, %16)::%13
        OpStore(%12, %17)
  %20 = OpLoad(%12)::%13
  %21 = OpImageSampleImplicitLod(%11, %20)::%2
        OpStore(%18, %21)
  %22 = OpLoad(%18)::%2
        OpReturnValue(%22)
        OpFunctionEnd()
      """
    )
  end

  @testset "Broadcasting" begin
    broadcast_test!(v, arr, image) = v .= image(Vec2(1, 2)).rgb .* v .* arr[0U] .* 2f0

    v = Vec3(1, 2, 3)
    image = SampledImage(Image{Float32,SPIRV.Dim2D,0,false,false,1,SPIRV.ImageFormatRgba16f}(zeros(512, 512)))
    arr = Arr(0f0)
    @test broadcast_test!(v, arr, image) == zero(Vec3)

    ir = @compile broadcast_test!(::Vec3, ::Arr{1, Float32}, ::SampledImage{Image{Float32, SPIRV.Dim2D, 0, false, false, 1, SPIRV.ImageFormatRgba16f}})
    @test unwrap(validate(ir))
  end

  @testset "Loops" begin
    struct GaussianBlur
      scale::Float32
      strength::Float32
    end
    
    function compute_blur(blur::GaussianBlur, reference, direction, uv)
      weights = Arr{Float32}(0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216)
      # TODO: Implement broadcasting.
      tex_offset = 1.0 ./ size(Image(reference), 0) .* blur.scale
      res = zero(Vec3)
      for i in eachindex(weights)
        vec = direction == 1 ? Vec2(tex_offset.x * i, 0.0) : Vec2(0.0, tex_offset.y * i)
        res .+= reference(uv .+ vec).rgb .* weights[i] .* blur.strength
        res .+= reference(uv .- vec).rgb .* weights[i] .* blur.strength
      end
      res
    end

    image = SampledImage(Image{Float32,SPIRV.Dim2D,0,false,false,1,SPIRV.ImageFormatRgba16f}(zeros(512, 512)))
    blur = GaussianBlur(1.0, 1.0)
    @test compute_blur(blur, image, 1U, zero(Vec2)) == zero(Vec3)

    # Loops not supported yet.
    @test_throws "merge candidate" @compile compute_blur(::GaussianBlur, ::SampledImage{Image{Float32, SPIRV.Dim2D, 0, false, false, 1, SPIRV.ImageFormatRgba16f}}, ::UInt32, ::Vec2)
  end
end;
