using SPIRV, Test

@testset "Cache invalidation" begin
  interp = SPIRVInterpreter()
  invalidate_all!(interp)
  (; global_cache) = interp
  tinfer = @elapsed @cfg interp f_straightcode(::Float32)
  tcached = @elapsed @cfg interp f_straightcode(::Float32)
  @test tinfer > tcached
  @test tinfer / tcached > 5
  cfg_old = @cfg infer = false interp f_straightcode(::Float32)

  @eval function f_straightcode(x)
    y = x + 1
    z = 3y
    z^2
  end

  cfg = @cfg infer = false interp f_straightcode(::Float32)
  @test !haskey(global_cache, cfg.mi)
  tinvalidated = @elapsed @cfg interp f_straightcode(::Float32)
  @test tinvalidated > tcached
  @test tinvalidated / tcached > 5
  @test haskey(global_cache, cfg.mi)
  @test !haskey(global_cache, cfg_old.mi)
  # Artifically increase the current world age.
  @eval some_function() = something()
  # Make sure world age bumps don't have any effect when there is no invalidation.
  @test haskey(global_cache, cfg.mi)
end
