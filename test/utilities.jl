using SPIRV, Test

@testset "SPIR-V utilities" begin
  @testset "Generating instructions with `@inst`" begin
    x = SSAValue(6)
    inst1 = @inst SSAValue(5) = SPIRV.OpIAdd(x, SSAValue(7))::SSAValue(2)
    inst2 = @inst $5 = SPIRV.OpIAdd($6, $7)::$2
    inst3 = @inst $5 = IAdd($6, $7)::$2
    @test inst1 == inst2 == inst3 == Instruction(SPIRV.OpIAdd, SSAValue(2), SSAValue(5), SSAValue.([6, 7]))

    block = @block begin
      $5 = IAdd($6, $7)::$2
      $8 = IAdd($5, $5)::$2
    end

    @test block == [
      @inst($5 = IAdd($6, $7)::$2),
      @inst($8 = IAdd($5, $5)::$2),
    ]
  end
end;
