using SPIRV, Test
using SPIRV: OpFMul, OpFAdd

@testset "SPIR-V code generation" begin
  ir = @compile f_straightcode(3.0f0)
  fdef = only(values(ir.fdefs))
  block = only(fdef.blocks)
  @test block[2] == @inst SSAValue(8) = OpFAdd(SSAValue(5), SSAValue(7))::SSAValue(2)
  @test block[3] == @inst SSAValue(10) = OpFMul(SSAValue(9), SSAValue(8))::SSAValue(2)
  @test block[4] == @inst SSAValue(11) = OpFMul(SSAValue(10), SSAValue(10))::SSAValue(2)
  mod = SPIRV.Module(ir)
  @test mod == parse(
    SPIRV.Module,
    """
      OpCapability(VulkanMemoryModel)
      OpExtension("SPV_KHR_vulkan_memory_model")
      OpMemoryModel(Logical, Vulkan)
      OpName(%4, "f_straightcode_Tuple{Float32}")
      OpName(%5, "x")
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
  @test !iserror(validate(ir))

  function my_clamp(x, lo, hi)
    x_lo = ifelse(x < lo, lo, x)
    ifelse(x_lo < hi, x_lo, hi)
  end

  ir = @compile my_clamp(1.2, 0.0, 0.7)
  mod = SPIRV.Module(ir)
  @test mod == parse(
    SPIRV.Module,
    """
      OpCapability(VulkanMemoryModel)
      OpCapability(Float64)
      OpExtension("SPV_KHR_vulkan_memory_model")
      OpMemoryModel(Logical, Vulkan)
      OpName(%4, "my_clamp_Tuple{Float64,Float64,Float64}")
      OpName(%5, "x")
      OpName(%6, "lo")
      OpName(%7, "hi")
 %2 = OpTypeFloat(64)
 %3 = OpTypeFunction(%2, %2, %2, %2)
%10 = OpTypeBool()
 %4 = OpFunction(None, %3)::%2
 %5 = OpFunctionParameter()::%2
 %6 = OpFunctionParameter()::%2
 %7 = OpFunctionParameter()::%2
 %8 = OpLabel()
%11 = OpFOrdLessThan(%5, %6)::%10
%12 = OpSelect(%11, %6, %5)::%2
%13 = OpFOrdLessThan(%12, %7)::%10
%14 = OpSelect(%13, %12, %7)::%2
      OpReturnValue(%14)
      OpFunctionEnd()
  """,
  )
  @test !iserror(validate(ir))

  ir = @compile f_extinst(3.0f0)
  mod = SPIRV.Module(ir)
  @test mod == parse(
    SPIRV.Module,
    """
      OpCapability(VulkanMemoryModel)
      OpExtension("SPV_KHR_vulkan_memory_model")
 %7 = OpExtInstImport("GLSL.std.450")
      OpMemoryModel(Logical, Vulkan)
      OpName(%4, "f_extinst_Tuple{Float32}")
      OpName(%5, "x")
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
  @test !iserror(validate(ir))

  f_branch(x) = x > 0 ? x + 1 : x - 1
  ir = @compile f_branch(1.0f0)
  @test !iserror(validate(ir))

  function f_branches(x)
    y = clamp(x, 0, 1)
    if iszero(y)
      z = x^2
      z > 1 && return z
      x += z
    else
      x -= 1
    end
    x < 0 && return y
    x + y
  end

  ir = @compile f_branches(4.0f0)
  @test !iserror(validate(ir))

  function unicolor(position)
    Vec(position.x, position.y, 1.0f0, 1.0f0)
  end

  ir = @compile unicolor(Vec(1.0f0, 2.0f0, 3.0f0, 4.0f0))
  @test !iserror(validate(ir))

  function store_ref(ref, x)
    ref[] += x
  end

  ir = @compile store_ref(Ref(0.0f0), 3.0f0)
  # Loading from function pointer arguments is illegal in logical addressing mode.
  @test contains(unwrap_error(validate(ir)).msg, "is not a logical pointer")
  @test iserror(validate(ir))

  struct StructWithBool
    x::Bool
    y::Int32
  end

  ir = @compile StructWithBool(::Bool, ::Int32)
  @test !iserror(validate(ir))
end
