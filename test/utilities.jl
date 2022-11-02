using SPIRV, Test

@testset "SPIR-V utilities" begin
  @testset "Generating instructions with `@inst` and `@block`" begin
    x = ResultID(6)
    inst1 = @inst ResultID(5) = SPIRV.OpIAdd(x, ResultID(7))::ResultID(2)
    inst2 = @inst &5 = SPIRV.OpIAdd(&6, &7)::&2
    inst3 = @inst &5 = IAdd(&6, &7)::&2
    @test inst1 == inst2 == inst3 == Instruction(SPIRV.OpIAdd, ResultID(2), ResultID(5), ResultID.([6, 7]))

    block = @block begin
      &5 = IAdd(&6, &7)::&2
      &8 = IAdd(&5, &5)::&2
    end

    @test block == [
      @inst(&5 = IAdd(&6, &7)::&2),
      @inst(&8 = IAdd(&5, &5)::&2),
    ]
  end
end;
