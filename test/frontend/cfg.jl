using SPIRV, Test

function test_traversal(g)
  visited = Int[]
  scc = strongly_connected_components(g)
  for v in SPIRV.traverse(g)
    push!(visited, v)
    @test all(x -> in(x, visited) || begin
      idx = findfirst(v in c for c in scc)
      !isnothing(idx) && x in scc[idx]
    end, inneighbors(g, v))
  end
end

@testset "Control flow" begin
  g = DeltaGraph(4, 1 => 2, 1 => 3, 2 => 4, 3 => 4)
  @test SPIRV.postdominator(g, 1) == 4
  test_traversal(g)

  g = DeltaGraph(4, 1 => 2, 1 => 3, 3 => 4)
  @test isnothing(SPIRV.postdominator(g, 1))
  test_traversal(g)

  g = DeltaGraph(6, 1 => 2, 1 => 3, 2 => 4, 2 => 5, 4 => 6, 5 => 6, 3 => 6)
  @test SPIRV.postdominator(g, 1) == 6
  test_traversal(g)

  g = DeltaGraph(8, 1 => 2, 1 => 3, 2 => 4, 4 => 5, 4 => 7, 5 => 6, 6 => 4, 7 => 8, 3 => 8)
  @test SPIRV.postdominator(g, 1) == 8
  test_traversal(g)
end
