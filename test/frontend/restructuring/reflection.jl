using SPIRV, Test

function f(x, sampler)
  intensity = sampler[x] * 2
  if intensity < 0.0 || sqrt(intensity) < 1.0
    return 3.0
  end
  clamp(intensity, 0.0, 1.0)
end

function f(x::Integer)
  if x == 2
    x = 3
    println(3)
  else
    x = 4
    println(3)
  end
  x
end

function f(x::AbstractFloat)
  if x == 2 || x == 3
    3.0
  else
    4.0
  end
end

f(::String) = "ho"

function f()
  for x in randn(100)
    println(x)
    x < 0.5 && continue
    x > 1.2 && break
    println(x / 2)
    continue
  end
end

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

  cfg = CFG(f, Tuple{Int,Vector{Float64}})
  @test !is_single_entry_single_exit(cfg)
  @test !is_tail_structured(cfg)

  cfg = CFG(f, Tuple{String})
  @test is_single_entry_single_exit(cfg)
  @test is_tail_structured(cfg)

  cfg = CFG(f, Tuple{Int})
  @test is_single_entry_single_exit(cfg)
  @test is_tail_structured(cfg)

  cfg = CFG(f, Tuple{Float64})
  @test !is_single_entry_single_exit(cfg)
  @test !is_tail_structured(cfg)

  cfg = CFG(f, Tuple{})
  @test !is_single_entry_single_exit(cfg)
  @test !is_tail_structured(cfg)
end
