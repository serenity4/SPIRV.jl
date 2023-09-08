using SPIRV, Test

@testset "N-Overlay method tables" begin
  interp = SPIRVInterpreter()
  result = Core.Compiler.findall(Tuple{typeof(+), Int64, Int64}, interp.method_table)
  m = first(result.matches)
  @test m.fully_covers
  @test m.method.module === SPIRV
  result = Core.Compiler.findall(Tuple{typeof(print), UInt32}, interp.method_table)
  m = first(result.matches)
  @test m.fully_covers
  @test m.method.module === Base
end;
