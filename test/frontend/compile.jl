using SPIRV, Test
using SPIRV: OpFMul, OpFAdd, emit_intrinsic

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

cfg = infer!(CFG(f_straightcode, Tuple{Float64}))

@testset "Compilation to SPIR-V" begin
  @testset "Intrinsics" begin
    @test emit_intrinsic(cfg.instructions[1][1], Core.SSAValue(1), SSAValue(100)) == @inst SSAValue(1) = OpFAdd(Core.Argument(2), 1.0)::SSAValue(100)
    @test emit_intrinsic(cfg.instructions[1][2], Core.SSAValue(2), SSAValue(100)) == @inst SSAValue(2) = OpFMul(3.0, Core.SSAValue(1))::SSAValue(100)
    @test emit_intrinsic(cfg.instructions[1][3], Core.SSAValue(3), SSAValue(100)) == @inst SSAValue(3) = OpFMul(Core.SSAValue(2), Core.SSAValue(2))::SSAValue(100)
  end
end
