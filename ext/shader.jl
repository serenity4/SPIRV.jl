Vk.ShaderStageFlag(source::SPIRV.ShaderSource) = Vk.ShaderStageFlag(source.info.interface.execution_model)

function Vk.ShaderStageFlag(execution_model::SPIRV.ExecutionModel)
  @match execution_model begin
    &SPIRV.ExecutionModelVertex                 => Vk.SHADER_STAGE_VERTEX_BIT
    &SPIRV.ExecutionModelTessellationControl    => Vk.SHADER_STAGE_TESSELLATION_CONTROL_BIT
    &SPIRV.ExecutionModelTessellationEvaluation => Vk.SHADER_STAGE_TESSELLATION_EVALUATION_BIT
    &SPIRV.ExecutionModelGeometry               => Vk.SHADER_STAGE_GEOMETRY_BIT
    &SPIRV.ExecutionModelFragment               => Vk.SHADER_STAGE_FRAGMENT_BIT
    &SPIRV.ExecutionModelGLCompute              => Vk.SHADER_STAGE_COMPUTE_BIT
    &SPIRV.ExecutionModelTaskNV                 => Vk.SHADER_STAGE_TASK_BIT_NV
    &SPIRV.ExecutionModelMeshNV                 => Vk.SHADER_STAGE_MESH_BIT_NV
    &SPIRV.ExecutionModelRayGenerationKHR       => Vk.SHADER_STAGE_RAYGEN_BIT_KHR
    &SPIRV.ExecutionModelIntersectionKHR        => Vk.SHADER_STAGE_INTERSECTION_BIT_KHR
    &SPIRV.ExecutionModelAnyHitKHR              => Vk.SHADER_STAGE_ANY_HIT_BIT_KHR
    &SPIRV.ExecutionModelClosestHitKHR          => Vk.SHADER_STAGE_CLOSEST_HIT_BIT_KHR
    &SPIRV.ExecutionModelMissKHR                => Vk.SHADER_STAGE_MISS_BIT_KHR
    &SPIRV.ExecutionModelCallableKHR            => Vk.SHADER_STAGE_CALLABLE_BIT_KHR
  end
end

function Vk.ShaderModule(device, source::SPIRV.ShaderSource)
  length(source.code) % 4 == 0 || pad_shader_code!(source.code)
  Vk.ShaderModule(device, length(source.code), reinterpret(UInt32, source.code))
end

function pad_shader_code!(code::Vector{UInt8})
  size = cld(length(code), 4)
  rem = size * 4 - length(code)
  if rem ≠ 0
    resize!(code, size * 4)
    code[(end - rem + 1):end] .= 0
  end
  @assert length(code) % 4 == 0
  code
end
