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

@testset "Supported features" begin
  instance = Vk.Instance([], [])
  physical_devices = unwrap(Vk.enumerate_physical_devices(instance))
  for physical_device in physical_devices
    device_properties = Vk.get_physical_device_properties_2(physical_device)
    device_features = Vk.get_physical_device_features_2(physical_device)
    extensions = unwrap(Vk.enumerate_device_extension_properties(physical_device))
    features = SupportedFeatures(physical_device, device_properties.properties.api_version, getproperty.(extensions, :extension_name), device_features)
    @test !isempty(features.capabilities)
    @test !isempty(features.extensions)
    @test in(SPIRV.CapabilityShader, features.capabilities)
    @test !in(SPIRV.CapabilityImageReadWriteLodAMD, features.capabilities)
    @test in("SPV_EXT_descriptor_indexing", features.extensions)
    @test !in("SPV_AMD_gcn_shader", features.extensions)
  end
end;
