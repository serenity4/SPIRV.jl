using SPIRV, Test
using SPIRV: OpFMul, OpFAdd

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

@testset "Compilation to SPIR-V" begin
  cfg = infer!(CFG(f_straightcode, Tuple{Float32}))
  ir = IR(cfg)
  @testset "Intrinsics" begin
    @test only(only(values(ir.fdefs)).blocks)[2] == @inst SSAValue(8) = OpFAdd(SSAValue(5), SSAValue(7))::SSAValue(2)
    @test only(only(values(ir.fdefs)).blocks)[3] == @inst SSAValue(10) = OpFMul(SSAValue(9), SSAValue(8))::SSAValue(2)
    @test only(only(values(ir.fdefs)).blocks)[4] == @inst SSAValue(11) = OpFMul(SSAValue(10), SSAValue(10))::SSAValue(2)
  end
  pmod = compile(f_straightcode, Tuple{Float32})
  @test isa(pmod, PhysicalModule)
  @test SPIRV.Module(pmod) == SPIRV.Module(ir)
end
