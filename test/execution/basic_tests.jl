@testset "Checking basic execution" begin
  # XXX: It's possible most of these are already optimized away before SPIR-V codegen.
  # If that is the case, we could prevent that by using opaque arguments (e.g. provided via buffers).
  @test execute(:(3F + 6F)) === 9F
  @test execute(:(3.0 + 12.0)) === 15.0
  @test execute(:(3 + 11)) === 14
  @test execute(:(3.2^11.4)) === 3.2^11.4
  @test execute(:(exp(10f0))) === exp(10f0)
  @test execute(:(cos(10f0))) === cos(10f0)
  @test execute(:(one(Vec3) == one(Vec3))) === true
  @test execute(:(one(Vec3) != one(Vec3))) === false
  @test execute(:(convert(Float32, true))) === 1f0
  @test execute(:(zero(SVector{3,Float32}))) === zero(SVector{3,Float32})
end;
