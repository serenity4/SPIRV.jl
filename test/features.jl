@testset "Feature requirements" begin
  inst = @inst SPIRV.OpImageSampleImplicitLod(ResultID(1), ResultID(2), SPIRV.ImageOperandsOffset | SPIRV.ImageOperandsMinLod, ResultID(4), ResultID(5))::ResultID(3)
  expected = FeatureRequirements([], [SPIRV.CapabilityImageGatherExtended, SPIRV.CapabilityMinLod])
  reqs = FeatureRequirements([inst], AllSupported())
  @test reqs == expected

  features = SupportedFeatures([], [SPIRV.CapabilityImageGatherExtended], v"1.6.0")
  @test in(SPIRV.CapabilityShader, features.capabilities)
  @test_throws r"At least one of the following capabilities .*CapabilityMinLod.*" FeatureRequirements([inst], features)
  features = SupportedFeatures([], [SPIRV.CapabilityMinLod, SPIRV.CapabilityImageGatherExtended], v"1.6.0")
  @test FeatureRequirements([inst], features) == expected

  # SPV_GOOGLE_hlsl_functionality1 is required only for versions [v"0.0" - v"1.4")
  inst = @inst SPIRV.OpDecorate(ResultID(1), SPIRV.DecorationUserSemantic)
  reqs = FeatureRequirements([inst], AllSupported())
  @test isempty(reqs.extensions) && isempty(reqs.capabilities)
  features = SupportedFeatures([], [], v"1.5.0")
  reqs = FeatureRequirements([inst], features)
  @test isempty(reqs.extensions) && isempty(reqs.capabilities)
  features = SupportedFeatures([], [], v"1.4.0")
  reqs = FeatureRequirements([inst], features)
  @test isempty(reqs.extensions) && isempty(reqs.capabilities)
  features = SupportedFeatures([], [], v"1.3.0")
  @test_throws r"At least one of the following extensions .*SPV_GOOGLE_hlsl_functionality1.*" FeatureRequirements([inst], features)
  features = SupportedFeatures(["SPV_GOOGLE_hlsl_functionality1"], [], v"1.3.0")
  reqs = FeatureRequirements([inst], features)
  @test reqs.extensions == ["SPV_GOOGLE_hlsl_functionality1"] && isempty(reqs.capabilities)

  inst = @inst SPIRV.OpMemoryModel(SPIRV.AddressingModelPhysicalStorageBuffer64, SPIRV.MemoryModelVulkan)
  features = SupportedFeatures(["SPV_KHR_physical_storage_buffer"], [SPIRV.CapabilityVulkanMemoryModel, SPIRV.CapabilityPhysicalStorageBufferAddresses], v"1.6.0")
  reqs = FeatureRequirements([inst], features)
  @test length(reqs.extensions) == 1 && length(reqs.capabilities) == 2
  @test issubset(reqs.extensions, features.extensions) && issubset(reqs.capabilities, features.capabilities)
end

global debug_messenger::Vk.DebugUtilsMessengerEXT

@testset "Supported features" begin
  layers = String["VK_LAYER_KHRONOS_validation"]
  extensions = String["VK_EXT_debug_utils"]
  instance = Vk.Instance(layers, extensions; application_info = Vk.ApplicationInfo(v"0.1", v"0.1", v"1.3"))
  debug_messenger = Vk.DebugUtilsMessengerEXT(instance, debug_callback_c; min_severity = Vk.DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT)
  physical_devices = unwrap(Vk.enumerate_physical_devices(instance))
  for physical_device in physical_devices
    device_properties = Vk.get_physical_device_properties_2(physical_device)
    device_features = Vk.get_physical_device_features_2(physical_device)
    extensions = unwrap(Vk.enumerate_device_extension_properties(physical_device))
    features = SupportedFeatures(physical_device, device_properties.properties.api_version, getproperty.(extensions, :extension_name), device_features)
    @test !isempty(features.capabilities)
    @test !isempty(features.extensions)
    @test in(SPIRV.CapabilityShader, features.capabilities)
    @test !in(SPIRV.CapabilityImageReadWriteLodAMD, features.capabilities) || !in(SPIRV.GroupNonUniformPartitionedNV, features.capabilities)
    @test in("SPV_EXT_descriptor_indexing", features.extensions)
    @test !in("SPV_AMD_gcn_shader", features.extensions) || !in("SPV_NV_stereo_view_rendering", features.extensions)
  end
end;
