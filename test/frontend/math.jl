@testset "MathFunctions" begin
  @test lerp(0.1, 0.9, 0.5) == 0.5
  @test lerp(0.1, 1.2, 0.5) == 0.65

  x = Vec2(1, 0)
  y = Vec2(0, 1)
  @test norm(x) == norm(y) == 1
  @test slerp_2d(x, y, 0.5) ≈ normalize(Vec2(1, 1))
  @test slerp_2d(x, y, 1.0) == normalize(y)
  @test slerp_2d(x, y, 0.0) == normalize(x)
  x = Vec2(1, 0)
  @test rotate_2d(x, pi/4) ≈ Vec2(sqrt(2)/2, sqrt(2)/2)
  @test remap(1, 0.5, 2, 6, 9) == 7
  @test remap(1, 0.5, 2, 10, 10) == 10
  @test remap(1, 10, 10, 4, 5) == 1
  for f in (linearstep, smoothstep, smootherstep)
    @test 0 < f(-40, 10, -35) < 1
    @test f(500, 600, 500) == 0
    @test f(0, 800, 800) == 1
  end

  @testset "Index computation" begin
    @test linear_index((0, 0, 0), (8, 8, 1)) == 0
    @test linear_index((1, 0, 0), (8, 8, 1)) == 1
    @test linear_index((1, 1, 0), (8, 8, 1)) == 64 + 1
    @test linear_index((7, 7, 0), (8, 8, 1)) == 7 + 7*8*8
    @test linear_index((256, 0, 0), (8, 8, 1)) == 256
    @test linear_index((256, 0, 0), (1, 8, 1)) == 256
    @test linear_index((0, 256, 0), (1, 8, 1)) == 8*256
    @test linear_index((24, 32, 2), (4, 8, 2)) == 24 + 32*(4*8*2) + 2*(4*8*2)^2

    @test image_index(0, (20, 10)) == (0, 0)
    @test image_index(13, (20, 10)) == (13, 0)
    @test image_index(184, (20, 10)) == (4, 9)
    @test image_index((0, 23, 0), (1, 8, 1), (20, 10)) == (4, 9)
  end;
end;
