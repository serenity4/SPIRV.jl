using SPIRV, Test

@testset "Feature requirements" begin
  inst = @inst SPIRV.OpImageSampleImplicitLod(ResultID(1), ResultID(2), SPIRV.ImageOperandsOffset | SPIRV.ImageOperandsMinLod, ResultID(4), ResultID(5))::ResultID(3)
  reqs = FeatureRequirements([inst], AllSupported())
  @test reqs == FeatureRequirements(
    [],
      [
      SPIRV.CapabilityImageGatherExtended,
      SPIRV.CapabilityMinLod,
    ],
  )
end
