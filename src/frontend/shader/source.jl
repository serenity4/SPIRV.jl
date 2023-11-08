struct ShaderInfo
  mi::MethodInstance
  interface::ShaderInterface
  interp::SPIRVInterpreter
  layout::LayoutStrategy
end

"""
SPIR-V shader code, with stage and entry point information.
"""
struct ShaderSource
  code::Vector{UInt8}
  info::ShaderInfo
end

function Base.show(io::IO, source::ShaderSource)
  print(io, typeof(source), '(', source.info.interface.execution_model, ", ", length(source.code), " bytes)")
end

@struct_hash_equal struct ShaderSpec
  mi::MethodInstance
  interface::ShaderInterface
end
ShaderSpec(f, argtypes::Type, interface::ShaderInterface) = ShaderSpec(method_instance(f, argtypes), interface)

Shader(spec::ShaderSpec, layout::Union{VulkanAlignment, LayoutStrategy}, interp::SPIRVInterpreter = SPIRVInterpreter()) = Shader(spec.mi, spec.interface, interp, layout)

function ShaderSource(spec::ShaderSpec, layout::Union{VulkanAlignment, LayoutStrategy}, interp::SPIRVInterpreter = SPIRVInterpreter())
  shader = Shader(spec, layout, interp)
  ShaderSource(shader, ShaderInfo(spec.mi, spec.interface, interp, shader.layout))
end

function ShaderSource(shader::Shader, info::ShaderInfo)
  ret = validate(shader)
  if iserror(ret)
    show_debug_spirv_code(stdout, shader.ir)
    err = unwrap_error(ret)
    throw(err)
  end
  ShaderSource(reinterpret(UInt8, assemble(shader)), info)
end
