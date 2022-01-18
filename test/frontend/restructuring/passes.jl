using SPIRV, Test

@testset "Merge return nodes" begin
  cfg = CFG(f, Tuple{Float64})
  @test !is_single_entry_single_exit(cfg)
  @test length(sources(cfg.graph)) == 1
  @test length(sinks(cfg.graph)) == 2
  restructured = merge_return_blocks(cfg)
  @test length(sources(restructured.graph)) == 1
  @test length(sinks(restructured.graph)) == 1
  verify(restructured)
end
