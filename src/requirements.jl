@auto_hash_equals struct FeatureRequirements
  extensions::Vector{String}
  capabilities::Vector{Capability}
end

abstract type FeatureSupport end

"""
Extensions and capabilities supported by a client API.
"""
@auto_hash_equals struct SupportedFeatures <: FeatureSupport
  extensions::Vector{String}
  capabilities::Vector{Capability}
end

supports_extension(supported::SupportedFeatures, ext) = ext in supported.extensions
supports_capability(supported::SupportedFeatures, cap) = cap in supported.capabilities

struct AllSupported <: FeatureSupport end

supports_extension(::AllSupported, ext) = true
supports_capability(::AllSupported, cap) = true

function find_supported(extensions, capabilities, supported::FeatureSupport)
  i_ext = findfirst(x -> supports_extension(supported, x), extensions)
  i_cap = findfirst(x -> supports_capability(supported, x), capabilities)
  if isnothing(i_ext) && !isempty(extensions)
    error("At least one of the following extensions is required: $extensions")
  end
  if isnothing(i_cap) && !isempty(capabilities)
    error("At least one of the following capabilities is required: $capabilities")
  end
  (isnothing(i_ext) ? nothing : extensions[i_ext], isnothing(i_cap) ? nothing : capabilities[i_cap])
end

function add_requirements!(required_exts, required_caps, supported::FeatureSupport, exts, caps)
  ext, cap = find_supported(exts, caps, supported)
  !isnothing(ext) && push!(required_exts, ext)
  !isnothing(cap) && push!(required_caps, cap)
end

function FeatureRequirements(instructions, supported::FeatureSupport)
  required_exts = String[]
  required_caps = Capability[]
  all(supports_capability(supported, cap) for cap in required_caps) || error("Certain base capabilities are not supported.")
  for inst in instructions
    inst_info = info(inst)
    add_requirements!(required_exts, required_caps, supported, inst_info.extensions, inst_info.capabilities)
    for (arg, op_info) in zip(inst.arguments, inst_info.operands)
      cap = @trymatch inst.opcode begin
        &OpTypeFloat => @trymatch Int(arg) begin
          16 => CapabilityFloat16
          64 => CapabilityFloat64
        end
        &OpTypeInt => @trymatch Int(arg) begin
          8  => CapabilityInt8
          16  => CapabilityInt16
          64 => CapabilityInt64
        end
      end
      !isnothing(cap) && push!(required_caps, cap)
      category = kind_to_category[op_info.kind]
      @tryswitch category begin
        @case "ValueEnum"
        enum_info = enum_infos[arg]
        add_requirements!(required_exts, required_caps, supported, enum_info.extensions, enum_info.capabilities)

        @case "BitEnum"
        for flag in enabled_flags(arg)
          enum_info = enum_infos[flag]
          add_requirements!(required_exts, required_caps, supported, enum_info.extensions, enum_info.capabilities)
        end
      end
    end
  end
  implicitly_declared = Capability[]
  for cap in required_caps
    enum_info = enum_infos[cap]
    union!(implicitly_declared, enum_info.capabilities)
  end
  FeatureRequirements(required_exts, setdiff(required_caps, implicitly_declared))
end

FeatureRequirements(ir::IR, features::FeatureSupport) = FeatureRequirements(Module(ir), features)

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
