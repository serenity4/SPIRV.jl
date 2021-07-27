function f(x, sampler)
    intensity = sampler[x] * 2
    if intensity < 0. || sqrt(intensity) < 1.
        return 3.
    end
    clamp(intensity, 0., 1.)
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
        3.
    else
        4.
    end
end

f(::String) = "ho"

@testset "Reflection" begin
    g = DeltaGraph(1)
    add_edge!(g, 1, 1)
    @test is_single_entry_single_exit(g)
    @test is_tail_structured(g)

    g = DeltaGraph(2)
    add_edge!(g, 1, 2)
    @test is_single_entry_single_exit(g)
    @test is_tail_structured(g)

    g = DeltaGraph(3)
    add_edge!(g, 1, 2)
    add_edge!(g, 2, 3)
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

    g = DeltaGraph(4)
    add_edge!(g, 1, 2)
    add_edge!(g, 1, 3)
    add_edge!(g, 2, 4)
    add_edge!(g, 3, 4)
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
end
