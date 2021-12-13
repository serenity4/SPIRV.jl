using SPIRV, Test
using .Spells: emit_intrinsic
using SPIRV: OpFMul, OpFAdd

function compute(x)
  y = exp(x)
  z = 1 + 3sin(x)
  log(z)
end

cfg = compile(compute, Tuple{Float64})

@testset "Compilation to SPIR-V" begin
  @testset "Intrinsics" begin
    @test emit_intrinsic(cfg.instructions[1][3], Core.SSAValue(3), SSAValue(10)) == @inst SSAValue(3) = OpFMul(3.0, Core.SSAValue(2))::SSAValue(10)
    @test emit_intrinsic(cfg.instructions[1][4], Core.SSAValue(4), SSAValue(10)) == @inst SSAValue(4) = OpFAdd(1.0, Core.SSAValue(3))::SSAValue(10)
  end
end
