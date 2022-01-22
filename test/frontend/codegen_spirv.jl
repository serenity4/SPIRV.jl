using SPIRV, Test

@testset "SPIR-V code generation" begin
  @testset "Straight code functions" begin
    ir = @compile f_straightcode(3.0f0)
    @test !iserror(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
      """
        OpCapability(VulkanMemoryModel)
        OpExtension("SPV_KHR_vulkan_memory_model")
        OpMemoryModel(Logical, Vulkan)
   %2 = OpTypeFloat(32)
   %3 = OpTypeFunction(%2, %2)
   # Constant literals are not interpreted as floating point values.
   # Doing so would require the knowledge of types, expressed in the IR.
   %7 = OpConstant(0x3f800000)::%2
   %9 = OpConstant(0x40400000)::%2
   %4 = OpFunction(None, %3)::%2
   %5 = OpFunctionParameter()::%2
   %6 = OpLabel()
   %8 = OpFAdd(%5, %7)::%2
  %10 = OpFMul(%9, %8)::%2
  %11 = OpFMul(%10, %10)::%2
        OpReturnValue(%11)
        OpFunctionEnd()
  """,
    )

    ir = @compile SPIRVInterpreter([INTRINSICS_METHOD_TABLE]) clamp(1.2, 0.0, 0.7)
    @test !iserror(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
      """
        OpCapability(VulkanMemoryModel)
        OpCapability(Float64)
        OpExtension("SPV_KHR_vulkan_memory_model")
        OpMemoryModel(Logical, Vulkan)
   %2 = OpTypeFloat(64)
   %3 = OpTypeFunction(%2, %2, %2, %2)
  %10 = OpTypeBool()
   %4 = OpFunction(None, %3)::%2
   %5 = OpFunctionParameter()::%2
   %6 = OpFunctionParameter()::%2
   %7 = OpFunctionParameter()::%2
   %8 = OpLabel()
  %11 = OpFOrdLessThan(%7, %5)::%10
  %12 = OpFOrdLessThan(%5, %6)::%10
  %13 = OpSelect(%12, %6, %5)::%2
  %14 = OpSelect(%11, %7, %13)::%2
        OpReturnValue(%14)
        OpFunctionEnd()
    """,
    )
  end

  @testset "Intrinsics" begin
    ir = @compile clamp(1.2, 0.0, 0.7)
    @test !iserror(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
      """
        OpCapability(VulkanMemoryModel)
        OpCapability(Float64)
        OpExtension("SPV_KHR_vulkan_memory_model")
   %9 = OpExtInstImport("GLSL.std.450")
        OpMemoryModel(Logical, Vulkan)
   %2 = OpTypeFloat(64)
   %3 = OpTypeFunction(%2, %2, %2, %2)
   %4 = OpFunction(None, %3)::%2
   %5 = OpFunctionParameter()::%2
   %6 = OpFunctionParameter()::%2
   %7 = OpFunctionParameter()::%2
   %8 = OpLabel()
  %10 = OpExtInst(%9, FClamp, %5, %6, %7)::%2
        OpReturnValue(%10)
        OpFunctionEnd()
    """,
    )

    ir = @compile f_extinst(3.0f0)
    @test !iserror(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
      """
        OpCapability(VulkanMemoryModel)
        OpExtension("SPV_KHR_vulkan_memory_model")
   %7 = OpExtInstImport("GLSL.std.450")
        OpMemoryModel(Logical, Vulkan)
   %2 = OpTypeFloat(0x00000020)
   %3 = OpTypeFunction(%2, %2)
  %10 = OpConstant(0x40400000)::%2
  %12 = OpConstant(0x3f800000)::%2
   %4 = OpFunction(None, %3)::%2
   %5 = OpFunctionParameter()::%2
   %6 = OpLabel()
   %8 = OpExtInst(%7, Exp, %5)::%2
   %9 = OpExtInst(%7, Sin, %5)::%2
  %11 = OpFMul(%10, %9)::%2
  %13 = OpFAdd(%12, %11)::%2
  %14 = OpExtInst(%7, Log, %13)::%2
  %15 = OpFAdd(%14, %8)::%2
        OpReturnValue(%15)
        OpFunctionEnd()
    """,
    )
  end

  @testset "Control flow" begin
    @testset "Branches" begin
      f_branch(x) = x > 0f0 ? x + 1f0 : x - 1f0
      ir = @compile f_branch(1.0f0)
      @test !iserror(validate(ir))

      @test ir ≈ parse(
        SPIRV.Module,
        """
        OpCapability(VulkanMemoryModel)
        OpExtension("SPV_KHR_vulkan_memory_model")
        OpMemoryModel(Logical, Vulkan)
   %2 = OpTypeFloat(0x00000020)
   %3 = OpTypeFunction(%2, %2)
   %9 = OpConstant(0x00000000)::%2
  %11 = OpTypeBool()
  %13 = OpConstant(0x3f800000)::%2
   %4 = OpFunction(None, %3)::%2
   %5 = OpFunctionParameter()::%2
   %6 = OpLabel()
  %12 = OpFOrdLessThan(%9, %5)::%11
        OpBranchConditional(%12, %8, %7)
   %7 = OpLabel()
  %14 = OpFSub(%5, %13)::%2
        OpReturnValue(%14)
   %8 = OpLabel()
  %15 = OpFAdd(%5, %13)::%2
        OpReturnValue(%15)
        OpFunctionEnd()
        """
        )
      function f_branches(x)
        y = clamp(x, 0f0, 1f0)
        if iszero(y)
          z = x^2
          z > 1f0 && return z
          x += z
        else
          x -= 1f0
        end
        x < 0f0 && return y
        x + y
      end

      ir = @compile f_branches(4.0f0)
      @test !iserror(validate(ir))
      @test ir ≈ parse(
        SPIRV.Module,
        """
        OpCapability(VulkanMemoryModel)
        OpExtension("SPV_KHR_vulkan_memory_model")
  %14 = OpExtInstImport("GLSL.std.450")
        OpMemoryModel(Logical, Vulkan)
   %2 = OpTypeFloat(0x00000020)
   %3 = OpTypeFunction(%2, %2)
  %15 = OpConstant(0x00000000)::%2
  %16 = OpConstant(0x3f800000)::%2
  %19 = OpTypeBool()
   %4 = OpFunction(None, %3)::%2
   %5 = OpFunctionParameter()::%2
   %6 = OpLabel()
  %17 = OpExtInst(%14, FClamp, %5, %15, %16)::%2
  %20 = OpFOrdEqual(%17, %15)::%19
        OpBranchConditional(%20, %11, %7)
   %7 = OpLabel()
  %21 = OpFSub(%5, %16)::%2
        OpBranch(%8)
   %8 = OpLabel()
  %22 = OpPhi(%27 => %12, %21 => %7)::%2
  %23 = OpFOrdLessThan(%22, %15)::%19
        OpBranchConditional(%23, %10, %9)
   %9 = OpLabel()
  %24 = OpFAdd(%22, %17)::%2
        OpReturnValue(%24)
  %10 = OpLabel()
        OpReturnValue(%17)
  %11 = OpLabel()
  %25 = OpFMul(%5, %5)::%2
  %26 = OpFOrdLessThan(%16, %25)::%19
        OpBranchConditional(%26, %13, %12)
  %12 = OpLabel()
  %27 = OpFAdd(%5, %25)::%2
        OpBranch(%8)
  %13 = OpLabel()
        OpReturnValue(%25)
        OpFunctionEnd()
        """
      )
    end
  end

  @testset "Composite SPIR-V types" begin
    function unicolor(position)
      Vec(position.x, position.y, 1.0f0, 1.0f0)
    end

    ir = @compile unicolor(Vec(1.0f0, 2.0f0, 3.0f0, 4.0f0))
    @test !iserror(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
      """
      OpCapability(VulkanMemoryModel)
      OpExtension("SPV_KHR_vulkan_memory_model")
      OpMemoryModel(Logical, Vulkan)
 %2 = OpTypeFloat(0x00000020)
 %3 = OpTypeVector(%2, 0x00000004)
 %4 = OpTypePointer(Function, %3)
 %5 = OpTypeFunction(%3, %4)
%14 = OpConstant(0x3f800000)::%2
 %6 = OpFunction(None, %5)::%3
 %7 = OpFunctionParameter()::%4
 %8 = OpLabel()
%13 = OpVariable(Function)::%4
 %9 = OpLoad(%7)::%3
%10 = OpCompositeExtract(%9, 0x00000000)::%2
%11 = OpLoad(%7)::%3
%12 = OpCompositeExtract(%11, 0x00000001)::%2
%15 = OpCompositeConstruct(%10, %12, %14, %14)::%3
      OpStore(%13, %15)
%16 = OpLoad(%13)::%3
      OpReturnValue(%16)
      OpFunctionEnd()
      """
    )

    struct StructWithBool
      x::Bool
      y::Int32
    end

    ir = @compile StructWithBool(::Bool, ::Int32)
    @test !iserror(validate(ir))
    @test ir ≈ parse(
      SPIRV.Module,
      """
      OpCapability(VulkanMemoryModel)
      OpExtension("SPV_KHR_vulkan_memory_model")
      OpMemoryModel(Logical, Vulkan)
 %2 = OpTypeBool()
 %4 = OpTypeInt(0x00000020, 0x00000001)
 %5 = OpTypeStruct(%2, %4)
 %6 = OpTypeFunction(%5, %2, %4)
 %7 = OpFunction(None, %6)::%5
 %8 = OpFunctionParameter()::%2
 %9 = OpFunctionParameter()::%4
%10 = OpLabel()
%11 = OpCompositeConstruct(%8, %9)::%5
      OpReturnValue(%11)
      OpFunctionEnd()
      """
    )
  end
end
