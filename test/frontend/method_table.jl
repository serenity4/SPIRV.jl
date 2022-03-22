using SPIRV, Test

@testset "N-Overlay method tables" begin
  interp = SPIRVInterpreter()
  (result, overlayed) = Core.Compiler.findall(Tuple{typeof(+), Int64, Int64}, interp.method_table)
  m = first(result.matches)
  @test m.fully_covers
  @test m.method.module === SPIRV
end
