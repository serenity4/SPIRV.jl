function SPIRV.SupportedFeatures(physical_device::Vk.PhysicalDevice, api_version::VersionNumber, device_extensions::AbstractVector{<:AbstractString}, device_features::Vk.PhysicalDeviceFeatures2)
  properties = Vk.get_physical_device_properties_2(physical_device, get_required_property_types(api_version)...)

  # Retrieve supported extensions.
  extensions = String[]
  for spec in Vk.SPIRV_EXTENSIONS
    if !isnothing(spec.promoted_to) && spec.promoted_to ≤ api_version || any(ext in device_extensions for ext in spec.enabling_extensions)
      push!(extensions, spec.name)
    end
  end

  # Retrieve supported capabilities.
  capabilities = SPIRV.Capability[]
  feature_dict = dictionary(nameof(typeof(f)) => f for f in Vk.unchain(device_features))
  property_dict = dictionary(nameof(typeof(p)) => p for p in Vk.unchain(properties))
  for spec in Vk.SPIRV_CAPABILITIES
    if !isnothing(spec.promoted_to) && spec.promoted_to ≤ api_version ||
       any(ext in device_extensions for ext in spec.enabling_extensions) ||
       any(has_feature(feature_dict, f, api_version) for f in spec.enabling_features) ||
       any(has_property(property_dict, p, api_version) for p in spec.enabling_properties)

      push!(capabilities, SPIRV.Capability(spec))
    end
  end

  SPIRV.SupportedFeatures(extensions, capabilities)
end

SPIRV.Capability(spec::Vk.SpecCapabilitySPIRV) = getproperty(SPIRV, Symbol(:Capability, spec.name))

function has_feature(features, condition::Vk.FeatureCondition, api_version::VersionNumber)
  isnothing(condition.core_version) || api_version ≥ condition.core_version || return false
  haskey(features, condition.type) && getproperty(features[condition.type], condition.member)
end

function has_property(properties, condition::Vk.PropertyCondition, api_version::VersionNumber)
  isnothing(condition.core_version) || api_version ≥ condition.core_version || return false
  haskey(properties, condition.type) && begin
    property = getproperty(properties[condition.type], condition.member)
    property isa Bool ? property : getproperty(Vk, condition.bit) in property
  end
end

function get_required_property_types(api_version::VersionNumber)
  properties = Vk.PropertyCondition[]
  for capability in Vk.SPIRV_CAPABILITIES
    for property in capability.enabling_properties
      if isnothing(property.core_version) || api_version ≥ property.core_version
        push!(properties, property)
      end
    end
  end
  property_types = DataType[]
  for property in unique(properties)
    push!(property_types, getproperty(Vk, property.type))
  end
  property_types
end
