@testset "MathFunctions" begin
  @test lerp(0.1, 0.9, 0.5) == 0.5
  @test lerp(0.1, 1.2, 0.5) == 0.65

  x = Vec2(1, 0)
  y = Vec2(0, 1)
  @test norm(x) == norm(y) == 1
  @test distance2(x, y) == 2
  @test distance(x, y) ≈ sqrt(2)
  @test slerp_2d(x, y, 0.5) ≈ normalize(Vec2(1, 1))
  @test slerp_2d(x, y, 1.0) == normalize(y)
  @test slerp_2d(x, y, 0.0) == normalize(x)
  x = Vec2(1, 0)
  @test rotate_2d(x, pi/4) ≈ Vec2(sqrt(2)/2, sqrt(2)/2)
  for f in (linearstep, smoothstep, smootherstep)
    @test 0 < f(-40, 10, -35) < 1
    @test f(500, 600, 500) == 0
    @test f(0, 800, 800) == 1
  end
end;
