using SPIRV, Test
import Core.Compiler as CC

@testset "Passes on `CodeInfo`" begin
  @testset "Removing lone `nothing` statements" begin
    creates_a_first_nothing_statement = function (x, y)
      i = 0
      while x < 1 (x += 1) end
    end
    target = @target creates_a_first_nothing_statement(::Int64, ::Int64)
    # Make sure that statement is preserved.
    @test target.code.code[1] === nothing
    @test target.code.code[2] isa CC.PhiNode # new basic block

    # XXX: If there is an easy example where a lone `nothing` appears, put it here.
  end
end;
