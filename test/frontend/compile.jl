using SPIRV, Test, MLStyle
using SPIRV: OpFMul, OpFAdd, invalidate_all

function f_straightcode(x)
  y = x + 1
  z = 3y
  z^2
end

function f_extinst(x)
  y = exp(x)
  z = 1 + 3sin(x)
  log(z)
end

function operation(ex::Expr)
  @match ex begin
    Expr(:invoke, _, f, args...) => @match f begin
      ::GlobalRef => f.mod == SPIRV ? f.name : nothing
      _ => nothing
    end
    _ => nothing
  end
end

@testset "Compilation to SPIR-V" begin
  @testset "Intrinsics" begin
    # Test that SPIR-V intrinsics are picked up and infer correctly.
    cfg = @cfg f_straightcode(3f0)
    (; code, ssavaluetypes) = cfg.code
    fadd = code[1]
    @test Meta.isexpr(fadd, :invoke)
    @test fadd.args[2] == GlobalRef(SPIRV, :FAdd)
    @test ssavaluetypes[1] == Float32

    cfg = @cfg f_straightcode(UInt64(0))
    (; code, ssavaluetypes) = cfg.code
    @test operation(code[1]) == :IAdd
    @test ssavaluetypes[1] == UInt64
    @test all(==(:IMul), operation.(code[2:3]))
    @test all(==(UInt64), ssavaluetypes[2:3])

    cfg = @cfg f_straightcode(UInt32(0))
    (; code, ssavaluetypes) = cfg.code
    # Skip return node.
    code = code[1:end-1]; ssavaluetypes = ssavaluetypes[1:end-1]
    ops = [:SConvert, :IAdd, :IMul, :IMul]
    types = fill(Int64, 4)
    @test operation.(code) == ops
    @test ssavaluetypes == types
  end

  @testset "SPIR-V code generation" begin
    ir = @compile f_straightcode(3f0)
    fdef = only(values(ir.fdefs))
    block = only(fdef.blocks)
    @test block[2] == @inst SSAValue(8) = OpFAdd(SSAValue(5), SSAValue(7))::SSAValue(2)
    @test block[3] == @inst SSAValue(10) = OpFMul(SSAValue(9), SSAValue(8))::SSAValue(2)
    @test block[4] == @inst SSAValue(11) = OpFMul(SSAValue(10), SSAValue(10))::SSAValue(2)
    mod = SPIRV.Module(ir)
    @test mod == parse(SPIRV.Module, """
           OpCapability(VulkanMemoryModel)
           OpExtension("SPV_KHR_vulkan_memory_model")
           OpMemoryModel(Logical, Vulkan)
      %2 = OpTypeFloat(32)
      %3 = OpTypeFunction(%2, %2)
      # Constant literals are not interpreted as floating point values.
      # Doing so would require the knowledge of types, expressed in the IR.
      %7 = OpConstant(1065353216)::%2
      %9 = OpConstant(1077936128)::%2
      %4 = OpFunction(None, %3)::%2
      %5 = OpFunctionParameter()::%2
      %6 = OpLabel()
      %8 = OpFAdd(%5, %7)::%2
     %10 = OpFMul(%9, %8)::%2
     %11 = OpFMul(%10, %10)::%2
           OpReturnValue(%11)
           OpFunctionEnd()
    """)
    @test_throws SPIRV.ValidationError("""
      error: line 0: No OpEntryPoint instruction was found. This is only allowed if the Linkage capability is being used.
      """) validate(ir)
  end

  @testset "Cache invalidation" begin
    invalidate_all()
    tinfer = @elapsed @cfg f_straightcode(3f0)
    tcached = @elapsed @cfg f_straightcode(3f0)
    @test tinfer > tcached
    @test tinfer/tcached > 5
    cfg_old = CFG(f_straightcode, Tuple{Float32})

    @eval function f_straightcode(x)
      y = x + 1
      z = 3y
      z^2
    end
    cfg = CFG(f_straightcode, Tuple{Float32})
    @test !haskey(SPIRV.GLOBAL_CI_CACHE, cfg.mi)
    tinvalidated = @elapsed @cfg f_straightcode(3f0)
    @test tinvalidated > tcached
    @test tinvalidated/tcached > 5
    @test haskey(SPIRV.GLOBAL_CI_CACHE, cfg.mi)
    @test !haskey(SPIRV.GLOBAL_CI_CACHE, cfg_old.mi)
    # Artifically increase the current world age.
    @eval some_function() = something()
    # Make sure world age bumps don't have any effect when there is no invalidation.
    @test haskey(SPIRV.GLOBAL_CI_CACHE, cfg.mi)
  end

  # WIP
  # cfg = @cfg f_extinst(3f0)
  # SPIRV.@code_typed exp(1)
  # SPIRV.@code_typed exp(3f0)
end