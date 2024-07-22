@struct_hash_equal struct FeatureRequirements
  extensions::Vector{String}
  capabilities::Vector{Capability}
end

"""
Abstract type expressing SPIR-V which capabilities and extensions are supported.
"""
abstract type FeatureSupport end

"""
Extensions and capabilities supported by a client API.
"""
@struct_hash_equal struct SupportedFeatures <: FeatureSupport
  extensions::Set{String}
  capabilities::Set{Capability}
  "SPIR-V version assumed for the client API."
  version::VersionNumber
  function SupportedFeatures(extensions, capabilities, version)
    capabilities = convert(Set{Capability}, capabilities)
    new(extensions, union(capabilities, implicitly_declared_capabilities(capabilities)), version)
  end
end

SupportedFeatures(extensions::AbstractVector, capabilities::AbstractVector, version) = SupportedFeatures(Set(extensions), Set(capabilities), version)
SupportedFeatures(extensions, capabilities) = SupportedFeatures(extensions, capabilities, SPIRV_VERSION)

supports_extension(supported::SupportedFeatures, ext) = in(ext, supported.extensions)
supports_capability(supported::SupportedFeatures, cap) = in(cap, supported.capabilities)
assume_version(supported::SupportedFeatures) = supported.version

Base.union!(x::SupportedFeatures, y::SupportedFeatures) = SupportedFeatures(union(x.extensions, y.extensions), union(x.capabilities, y.capabilities))
Base.union(x::SupportedFeatures, y::SupportedFeatures) = foldl(union!, (x, y); init = SupportedFeatures([], []))

struct AllSupported <: FeatureSupport end

supports_extension(::AllSupported, ext) = true
supports_capability(::AllSupported, cap) = true
assume_version(::AllSupported) = typemax(VersionNumber)

function find_extension(supported::FeatureSupport, extensions::AbstractVector, required_by; required = true)
  i = findfirst(x -> supports_extension(supported, x), extensions)
  if isnothing(i)
    !required && return missing
    error("At least one of the following extensions is required for `$required_by`: $extensions")
  end
  extensions[i]
end

function find_capability(supported::FeatureSupport, capabilities::AbstractVector, required_by; required = true)
  i = findfirst(x -> supports_capability(supported, x), capabilities)
  if isnothing(i)
    !required && return missing
    error("At least one of the following capabilities is required for `$required_by`: $capabilities")
  end
  capabilities[i]
end

function find_supported(supported::FeatureSupport, extensions, capabilities, required_by; required = true)
  extension = isnothing(extensions) ? nothing : find_extension(supported, extensions, required_by; required)
  capability = isnothing(capabilities) ? nothing : find_capability(supported, capabilities, required_by; required)
  (extension, capability)
end

function find_supported(supported::FeatureSupport, support::RequiredSupport, @nospecialize(required_by); required = true)
  version = assume_version(supported)
  if !in(version, support.version)
    required && error("SPIR-V version requirements could not be satisfied for $version (required: $(support.version)) for `$required_by`")
    return nothing
  end
  find_supported(supported, support.extensions, support.capabilities, required_by; required)
end

function find_supported(supported::FeatureSupport, requirements::AbstractVector{RequiredSupport}, @nospecialize(required_by))
  for required in reverse(requirements) # try the last ones first, as they should have lower extension/capability requirements.
    found = find_supported(supported, required, required_by; required = false)
    !isnothing(found) && all(!ismissing, found) && return found
  end
  # Get the requirements for the latest version to trigger the error.
  version = assume_version(supported)
  i = findfirst(x -> in(version, x.version), requirements)
  isnothing(i) && error("The provided SPIR-V version is not supported by `$required_by` (version: $version, support for versions: $(join(map(x -> x.version), ", ")))")
  required = requirements[i]
  find_supported(supported, required, required_by; required = true)
end

function add_requirements!(required_exts, required_caps, supported::FeatureSupport, requirements, @nospecialize(required_by))
  extension, capability = find_supported(supported, requirements, required_by)
  !isnothing(extension) && push!(required_exts, extension)
  !isnothing(capability) && push!(required_caps, capability)
end

function check_required_capabilities(capabilities, supported::FeatureSupport)
  if !all(supports_capability(supported, capability) for capability in capabilities)
    missing_caps = [styled"""{red,underline:$(replace(string(capability), r"^Capability" => ""))}""" for capability in capabilities if !supports_capability(supported, capability)]
    error(styled"""The following capabilities are required by SPIRV.jl but are not supported: $(join(missing_caps, ", "))""")
  end
end

function check_required_extensions(extensions, supported::FeatureSupport)
  if !all(supports_extension(supported, extension) for extension in extensions)
    missing_exts = [styled"{red,underline:$extension}" for extension in extensions if !supports_extension(supported, extension)]
    error(styled"""The following extensions are required by SPIRV.jl but are not supported: $(join(missing_exts, ", "))""")
  end
end

function FeatureRequirements(instructions, supported::FeatureSupport)
  required_exts = String[]
  required_caps = Capability[]
  variables = Set{ResultID}()
  variable_pointers_spotted = false
  for inst in instructions
    inst.opcode == OpVariable && !variable_pointers_spotted && push!(variables, inst.result_id)
    inst_info = info(inst)
    add_requirements!(required_exts, required_caps, supported, inst_info.required, inst)
    !variable_pointers_spotted && @when &OpPhi = inst.opcode begin
      for arg in @view inst.arguments[1:2:end]
        if in(arg::ResultID, variables)
          push!(required_caps, CapabilityVariablePointers)
          variable_pointers_spotted = true
          break
        end
      end
    end
    for (arg, op_info) in zip(inst.arguments, inst_info.operands)
      cap = @trymatch inst.opcode begin
        &OpTypeFloat => @trymatch Int(arg) begin
          16 => CapabilityFloat16
          64 => CapabilityFloat64
        end
        &OpTypeInt => @trymatch Int(arg) begin
          8  => CapabilityInt8
          16 => CapabilityInt16
          64 => CapabilityInt64
        end
      end
      !isnothing(cap) && push!(required_caps, cap)
      category = kind_to_category[op_info.kind]
      @tryswitch category begin
        @case "ValueEnum"
        enum_info = enum_infos[arg]
        add_requirements!(required_exts, required_caps, supported, enum_info.required, arg)

        @case "BitEnum"
        for flag in enabled_flags(arg)
          enum_info = enum_infos[flag]
          add_requirements!(required_exts, required_caps, supported, enum_info.required, flag)
        end
      end
    end
  end
  # Add any extensions that are not linked to capabilities but required by them.
  # XXX: Investigate why this information is not automatically derived.
  for cap in required_caps
    cap == SPIRV.CapabilityMeshShadingEXT && push!(required_exts, "SPV_EXT_mesh_shader")
  end
  FeatureRequirements(required_exts, setdiff(required_caps, implicitly_declared_capabilities(required_caps)))
end

function implicitly_declared_capabilities(capabilities)
  implicitly_declared = Capability[]
  for capability in capabilities
    enum_info = enum_infos[capability]
    for required in enum_info.required
      !isnothing(required.capabilities) && union!(implicitly_declared, required.capabilities)
    end
  end
  implicitly_declared
end

FeatureRequirements(ir::IR, features::FeatureSupport) = FeatureRequirements(Module(ir), features)

function check_compiler_feature_requirements(supported::FeatureSupport)
  # We'll almost always need this when compiling Julia code to SPIR-V.
  required_caps = Capability[CapabilityVariablePointers]
  required_exts = String[]
  check_required_capabilities(required_caps, supported)
  check_required_extensions(required_exts, supported)
end

"""
Add all required extension and capabilities declarations to the IR.

All implicitly declared capabilities will be stripped from the IR.
"""
function satisfy_requirements!(ir::IR, features::FeatureSupport)
  reqs = FeatureRequirements(ir, features)
  union!(empty!(ir.capabilities), reqs.capabilities)
  union!(empty!(ir.extensions), reqs.extensions)
  if CapabilityPhysicalStorageBufferAddresses in ir.capabilities
    ir.addressing_model = AddressingModelPhysicalStorageBuffer64
  end
  ir
end

function satisfy_requirements!(diff::Diff, amod::AnnotatedModule, features::FeatureSupport)
  reqs = FeatureRequirements(Module(amod), features)
  add_capabilities!(diff, amod, reqs.capabilities)
  add_extensions!(diff, amod, reqs.extensions)
end
