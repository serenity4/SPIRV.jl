using SPIRV, Test

@testset "Array operations" begin
  @testset "GenericVector" begin
    v = SVec(1.0, 3.0, 1.0)
    @test v[2] == 3.0
    v[3] = 4
    @test v[3] == last(v) == 4
    @test first(v) == 1.0
    @test v.x == v.r == 1.0
    @test v.y == v.g == 3.0
    @test v.z == v.b == 4.0
    v2 = similar(v)
    @test all(iszero, v2)
  end
end
