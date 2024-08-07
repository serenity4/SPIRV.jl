@refbroadcast @struct_hash_equal struct ShaderInfo
  mi::MethodInstance
  interface::ShaderInterface
  interp::SPIRVInterpreter
  layout::VulkanLayout
end

function ShaderInfo(mi::MethodInstance,
                    interface::ShaderInterface;
                    interp::SPIRVInterpreter = SPIRVInterpreter(),
                    layout::VulkanLayout = VulkanLayout())
  ShaderInfo(mi, interface, interp, layout)
end

function ShaderInfo(f, argtypes::Type,
                    interface::ShaderInterface;
                    interp::SPIRVInterpreter = SPIRVInterpreter(),
                    layout::VulkanLayout = VulkanLayout())
  ShaderInfo(method_instance(f, argtypes, interp), interface, interp, layout)
end

"""
SPIR-V shader code, with stage and entry point information.
"""
@refbroadcast struct ShaderSource
  code::Vector{UInt8}
  info::ShaderInfo
  specializations::Dictionary{Symbol, Vector{ResultID}}
end

function Base.show(io::IO, source::ShaderSource)
  print(io, typeof(source), '(', source.info.interface.execution_model, ", ", length(source.code), " bytes, ", length(source.specializations), " specialization constants)")
end

ShaderSource(info::ShaderInfo; validate::Bool = true, optimize::Bool = false) = ShaderSource(Shader(info); validate, optimize)
