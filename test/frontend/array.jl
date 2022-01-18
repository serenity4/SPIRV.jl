using SPIRV, Test

@testset "Array operations" begin
  @testset "GenericVector" begin
    v = SVec(1., 3., 1.)
    @test v[2] == 3.
    v[3] = 4
    @test v[3] == last(v) == 4
    @test first(v) == 1.
    @test v.x == v.r == 1.
    @test v.y == v.g == 3.
    @test v.z == v.b == 4.
    v2 = similar(v)
    @test all(iszero, v2)
  end
end
