using SPIRV.MathFunctions

@testset "Checking basic execution" begin
  # XXX: It's possible some of these are already optimized away before SPIR-V codegen.
  # If that is the case, we could prevent that by using opaque arguments (e.g. provided via buffers).
  @test execute(:(3F + 6F)) === 9F
  @test execute(:(3.0 + 12.0)) === 15.0
  @test execute(:(3 + 11)) === 14
  @test execute(:((3.2F) ^ 11.4F)) === (3.2F) ^ 11.4F
  @test execute(:(norm(@vec(Float32[1, 1]),    1F))) === 2F
  @test execute(:(norm(@vec(Float32[1, 1])       ))) === sqrt(2F)
  @test execute(:(norm(@vec(Float32[1, 1]), Inf32))) === 1F
  @test execute(:(exp(10f0))) === exp(10f0)
  @test execute(:(cos(10f0))) === cos(10f0)
  @test execute(:(@vec(Float32[1, 2, 3]) == @vec(Float32[1, 2, 3]))) === true
  @test execute(:(@vec(Float32[1, 2, 3]) != @vec(Float32[1, 2, 3]))) === false
  @test execute(:(convert(Float32, true))) === 1f0
  @test execute(:(zero(SVector{3,Float32}))) === zero(SVector{3,Float32})

  @testset "Setting constants and specialization constants" begin
    shader = @compute features = supported_features (function (out, value::T) where {T}
      @store out::T = value
    end)(::DeviceAddressBlock::PushConstant, ::UInt32::Constant{5U})
    @test execute(ShaderSource(shader), device, UInt32) === 5U

    shader = @compute features = supported_features (function (out, value::T) where {T}
      @store out::T = value
    end)(::DeviceAddressBlock::PushConstant, ::UInt32::Constant{value = 5U})
    @test execute(ShaderSource(shader), device, UInt32) === 5U
    @test execute(ShaderSource(shader), device, UInt32; specializations = (; value = 10U)) === 10U
  end

  @testset "Setting the workgroup size" begin
    shader = @compute features = supported_features (function (out, value::T) where {T}
      @store out::T = value
    end)(::DeviceAddressBlock::PushConstant, ::Vec3U::Input{WorkgroupSize})
    @test execute(ShaderSource(shader), device, Vec3U) == Vec3U(shader.info.interface.execution_options.local_size)

    shader = @compute features = supported_features (function (out, value::T) where {T}
      @store out::T = value
    end)(::DeviceAddressBlock::PushConstant, ::Vec3U::Input{WorkgroupSize}) options = ComputeExecutionOptions(local_size = (1, 1, 1))
    @test execute(ShaderSource(shader), device, Vec3U) == Vec3U(shader.info.interface.execution_options.local_size)
    @test execute(ShaderSource(shader), device, Vec3U; specializations = (; local_size = Vec3U(16, 16, 2))) == Vec3U(16, 16, 2)
  end
end;
