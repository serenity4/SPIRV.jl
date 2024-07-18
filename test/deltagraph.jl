using SPIRV, Test, Graphs

@testset "DeltaGraph" begin
  @testset "Construction" begin
    g = DeltaGraph()
    add_vertices!(g, 5)
    @test vertices(g) == collect(1:5)
    @test g == DeltaGraph(5)
    rem_vertex!(g, 3)
    @test vertices(g) == [1, 2, 4, 5]
    add_vertex!(g)
    @test vertices(g) == collect(1:5)
    add_edge!(g, 1, 2)
    add_edge!(g, 1, 2)
    @test edges(g) == [Edge(1, 2)]
    rem_edge!(g, Edge(1, 2))
    @test edges(g) == []

    g = DeltaGraph(5)
    add_edge!(g, 4, 2)
    add_edge!(g, 2, 4)
    add_edge!(g, 3, 5)
    add_edge!(g, 1, 2)
    add_edge!(g, 2, 4)
    @test g == DeltaGraph(5, 4 => 2, 2 => 4, 3 => 5, 1 => 2, 2 => 4)
    rem_vertex!(g, 3)
    @test has_edge(g, 2, 4)
    @test has_edge(g, 4, 2)
    @test !has_edge(g, 3, 5)
  end

  @testset "Compaction" begin
    g = DeltaGraph(5, 1 => 2, 2 => 4)
    rem_vertex!(g, 3)

    g = compact(g)
    @test vertices(g) == [1, 2, 3, 4]
    @test edges(g) == [Edge(1, 2), Edge(2, 3)]
  end

  @testset "Graph manipulations" begin
    g = DeltaGraph(5, 1 => 2, 2 => 3)
    merge_vertices!(g, 1, 2, 3)
    @test nv(g) == 3
    @test edges(g) == [Edge(1, 1)]
    @test ne(g) == 1

    add_edge!(g, 1, 4)
    merge_vertices!(g, 4, 5)
    @test edges(g) == [Edge(1, 1), Edge(1, 4)]
    @test ne(g) == 2
  end
end;
