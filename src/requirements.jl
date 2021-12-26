struct FeatureRequirements
    extensions::Set{String}
    capabilities::Set{Capability}
end

function FeatureRequirements(mod::Module)
    required_exts = Set{String}()
    required_caps = Set{Capability}()
    for inst in mod
        inst_info = info(inst)
        union!(required_exts, inst_info.extensions)
        union!(required_caps, inst_info.capabilities)
        for (arg, op_info) in zip(inst.arguments, inst_info.operands)
            cap = @trymatch inst.opcode begin
                &OpTypeFloat => @trymatch Int(arg) begin
                        16 => CapabilityFloat16
                        64 => CapabilityFloat64
                    end
                &OpTypeInt => @trymatch Int(arg) begin
                        8  => CapabilityInt8
                        64 => CapabilityInt64
                    end
            end
            !isnothing(cap) && push!(required_caps, cap)
            category = kind_to_category[op_info.kind]
            @tryswitch category begin
                @case "ValueEnum"
                    enum_info = enum_infos[arg]
                    union!(required_exts, enum_info.extensions)
                    union!(required_caps, enum_info.capabilities)
                @case "BitEnum"
                    # TODO: support combinations of BitEnums
                    enum_info = enum_infos[arg]
                    union!(required_exts, enum_info.extensions)
                    union!(required_caps, enum_info.capabilities)
            end
        end
    end
    implicitly_declared = Set{Capability}()
    for cap in required_caps
        enum_info = enum_infos[cap]
        union!(implicitly_declared, enum_info.capabilities)
    end
    FeatureRequirements(required_exts, setdiff(required_caps, implicitly_declared))
end

FeatureRequirements(ir::IR) = FeatureRequirements(Module(ir))

"""
Add all required extension and capabilities declarations to the IR.

All implicitly declared capabilities will be stripped from the IR.
"""
function satisfy_requirements!(ir::IR)
    reqs = FeatureRequirements(ir)
    union!(empty!(ir.capabilities), reqs.capabilities)
    union!(empty!(ir.extensions), reqs.extensions)
    ir
end
