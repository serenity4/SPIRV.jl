@refbroadcast @struct_hash_equal struct ShaderInfo
  mi::MethodInstance
  interface::ShaderInterface
  interp::SPIRVInterpreter
  layout::LayoutStrategy
end

function ShaderInfo(mi::MethodInstance,
                    interface::ShaderInterface;
                    interp::SPIRVInterpreter = SPIRVInterpreter(),
                    layout::LayoutStrategy = VulkanLayout())
  ShaderInfo(mi, interface, interp, layout)
end

function ShaderInfo(f, argtypes::Type,
                    interface::ShaderInterface;
                    interp::SPIRVInterpreter = SPIRVInterpreter(),
                    layout::LayoutStrategy = VulkanLayout())
  ShaderInfo(method_instance(f, argtypes, interp), interface, interp, layout)
end

Shader(info::ShaderInfo) = Shader(info.mi, info.interface, info.interp, info.layout)

"""
SPIR-V shader code, with stage and entry point information.
"""
@refbroadcast struct ShaderSource
  code::Vector{UInt8}
  info::ShaderInfo
end

function Base.show(io::IO, source::ShaderSource)
  print(io, typeof(source), '(', source.info.interface.execution_model, ", ", length(source.code), " bytes)")
end

ShaderSource(info::ShaderInfo; validate::Bool = true) = ShaderSource(Shader(info), info; validate)

function ShaderSource(shader::Shader, info::ShaderInfo; validate::Bool = true)
  ret = @__MODULE__().validate(shader)
  if iserror(ret)
    show_debug_spirv_code(stdout, shader.ir)
    err = unwrap_error(ret)
    throw(err)
  end
  ShaderSource(reinterpret(UInt8, assemble(shader)), info)
end
