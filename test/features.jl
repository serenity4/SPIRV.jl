using SPIRV, Test

@testset "Feature requirements" begin
  inst = @inst SPIRV.OpImageSampleImplicitLod(SSAValue(1), SSAValue(2), SPIRV.ImageOperandsOffset | SPIRV.ImageOperandsMinLod, SSAValue(4), SSAValue(5))::SSAValue(3)
  reqs = FeatureRequirements([inst], AllSupported())
  @test reqs == FeatureRequirements(
    [],
      [
      SPIRV.CapabilityImageGatherExtended,
      SPIRV.CapabilityMinLod,
    ],
  )
end
