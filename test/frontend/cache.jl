using SPIRV, Test
using SPIRV: GLOBAL_CI_CACHE

@testset "Cache invalidation" begin
  invalidate_all()
  tinfer = @elapsed @cfg f_straightcode(3f0)
  tcached = @elapsed @cfg f_straightcode(3f0)
  @test tinfer > tcached
  @test tinfer/tcached > 5
  cfg_old = @cfg infer = false f_straightcode(3f0)

  @eval function f_straightcode(x)
    y = x + 1
    z = 3y
    z^2
  end

  cfg = @cfg infer = false f_straightcode(3f0)
  @test !haskey(GLOBAL_CI_CACHE, cfg.mi)
  tinvalidated = @elapsed @cfg f_straightcode(3f0)
  @test tinvalidated > tcached
  @test tinvalidated/tcached > 5
  @test haskey(GLOBAL_CI_CACHE, cfg.mi)
  @test !haskey(GLOBAL_CI_CACHE, cfg_old.mi)
  # Artifically increase the current world age.
  @eval some_function() = something()
  # Make sure world age bumps don't have any effect when there is no invalidation.
  @test haskey(GLOBAL_CI_CACHE, cfg.mi)
end
