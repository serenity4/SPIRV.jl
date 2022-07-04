using SPIRV, Test, Graphs

@testset "Reflection" begin
  @testset "SESE rules" begin
    # Rule 1
    g = DeltaGraph(3, 1 => 2, 2 => 3)
    compact_reducible_bbs!(g, 1)
    expected = DeltaGraph(2, 1 => 2)
    @test compact(g) == expected
    compact_reducible_bbs!(g, 1)
    @test compact(g) == DeltaGraph(1)

    # Rule 2
    g = DeltaGraph(4, 1 => 2, 1 => 3, 2 => 4, 3 => 4)
    compact_structured_branches!(g, 1)
    @test compact(g) == DeltaGraph(1)

    g = DeltaGraph(4, 1 => 2, 1 => 3, 2 => 4, 3 => 4, 1 => 4)
    compact_structured_branches!(g, 1)
    @test compact(g) == DeltaGraph(1)

    # Rule 3
    g = DeltaGraph(3, 1 => 2, 2 => 2, 2 => 3)
    rem_head_recursion!(g, 2)
    expected = DeltaGraph(3, 1 => 2, 2 => 3)
    @test compact(g) == expected

    # Rule 4
    g = DeltaGraph(4, 1 => 2, 2 => 3, 3 => 2, 2 => 4)
    merge_mutually_recursive!(g, 2)
    expected = DeltaGraph(3, 1 => 2, 2 => 3)
    @test compact(g) == expected
  end

  g = DeltaGraph(1, 1 => 1)
  @test is_single_entry_single_exit(g)
  @test is_tail_structured(g)

  g = DeltaGraph(2, 1 => 2)
  @test is_single_entry_single_exit(g)
  @test is_tail_structured(g)

  g = DeltaGraph(3, 1 => 2, 2 => 3)
  @test is_single_entry_single_exit(g)
  @test is_tail_structured(g)

  add_edge!(g, 1, 1)
  @test is_single_entry_single_exit(g)
  @test is_tail_structured(g)

  add_edge!(g, 2, 1)
  @test is_single_entry_single_exit(g)
  @test is_tail_structured(g)

  add_vertex!(g)
  add_edge!(g, 2, 4)
  @test !is_single_entry_single_exit(g)
  @test !is_tail_structured(g)

  rem_edge!(g, 2, 4)
  add_edge!(g, 1, 4)
  add_edge!(g, 4, 2)
  @test !is_single_entry_single_exit(g)
  @test !is_tail_structured(g)

  g = DeltaGraph(4, 1 => 2, 1 => 3, 2 => 4, 3 => 4)
  @test is_single_entry_single_exit(g)
  @test is_tail_structured(g)
  add_edge!(g, 1, 4)
  @test is_single_entry_single_exit(g)
  @test is_tail_structured(g)
end;
