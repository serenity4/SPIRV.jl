using SPIRV
using Vulkan: Vk, VkCore, unwrap
using SPIRV: @compute

debug_callback_c = @cfunction(Vk.default_debug_callback, UInt32, (Vk.DebugUtilsMessageSeverityFlagEXT, Vk.DebugUtilsMessageTypeFlagEXT, Ptr{VkCore.VkDebugUtilsMessengerCallbackDataEXT}, Ptr{Cvoid}))

function create_device()
  layers = String[]
  # Validation layers seem to crash when `Bool` is returned.
  # layers = String["VK_LAYER_KHRONOS_validation"]
  extensions = String["VK_EXT_debug_utils"]
  instance = Vk.Instance(layers, extensions; application_info = Vk.ApplicationInfo(v"0.1", v"0.1", v"1.3"))
  debug_messenger = Vk.DebugUtilsMessengerEXT(instance, debug_callback_c)
  physical_device = first(unwrap(Vk.enumerate_physical_devices(instance)))
  device_features_1_1 = Vk.PhysicalDeviceVulkan11Features(:variable_pointers, :variable_pointers_storage_buffer)
  device_features_1_2 = Vk.PhysicalDeviceVulkan12Features(:buffer_device_address, :vulkan_memory_model; next = device_features_1_1)
  device_features_1_3 = Vk.PhysicalDeviceVulkan13Features(:synchronization2, :dynamic_rendering; next = device_features_1_2)
  device_features = Vk.PhysicalDeviceFeatures2(Vk.PhysicalDeviceFeatures(:shader_float_64, :shader_int_64); next = device_features_1_3)
  device_extensions = String[]
  queue_family_index = Vk.find_queue_family(physical_device, Vk.QUEUE_GRAPHICS_BIT | Vk.QUEUE_COMPUTE_BIT)
  device = Vk.Device(
    physical_device,
    [Vk.DeviceQueueCreateInfo(queue_family_index, [1.0])],
    [], device_extensions; next = device_features
  )
  supported_features = SupportedFeatures(physical_device, v"1.3", device_extensions, device_features)
  check_compiler_feature_requirements(supported_features)
  (; debug_messenger, device, queue_family_index, supported_features)
end

(; debug_messenger, device, queue_family_index, supported_features) = create_device()

function find_memory_type(physical_device::Vk.PhysicalDevice, type, properties::Vk.MemoryPropertyFlag)
  memory_properties = Vk.get_physical_device_memory_properties(physical_device)
  memory_types = memory_properties.memory_types[1:(memory_properties.memory_type_count)]
  candidate_indices = findall(i -> type & (1 << i) ≠ 0, 0:(memory_properties.memory_type_count - 1))
  index = findfirst(i -> in(Vk.MEMORY_PROPERTY_HOST_COHERENT_BIT, memory_types[i].property_flags), candidate_indices)
  index - 1
end

"""
Execute a shader on the provided device and return the result, which **must** be of type `T`.
"""
function execute(source::ShaderSource, device::Vk.Device, T::Type; specializations = nothing)
  @assert isconcretetype(T)
  stage = Vk.ShaderStageFlag(source.info.interface.execution_model)
  @assert stage == Vk.SHADER_STAGE_COMPUTE_BIT

  shader = Vk.ShaderModule(device, source)

  buffer = Vk.Buffer(device, sizeof(T), Vk.BUFFER_USAGE_SHADER_DEVICE_ADDRESS_BIT, Vk.SHARING_MODE_EXCLUSIVE, [queue_family_index])
  memory_requirements = Vk.get_buffer_memory_requirements(device, buffer)
  memory_index = find_memory_type(device.physical_device, memory_requirements.memory_type_bits, Vk.MEMORY_PROPERTY_HOST_VISIBLE_BIT | Vk.MEMORY_PROPERTY_HOST_COHERENT_BIT)
  memory = Vk.DeviceMemory(device, memory_requirements.size, memory_index; next = Vk.MemoryAllocateFlagsInfo(0; flags = Vk.MEMORY_ALLOCATE_DEVICE_ADDRESS_BIT))
  unwrap(Vk.bind_buffer_memory(device, buffer, memory, 0))
  out_host_ptr = unwrap(Vk.map_memory(device, memory, 0, sizeof(T)))
  out_device_ptr = Vk.get_buffer_device_address(device, Vk.BufferDeviceAddressInfo(buffer))

  push_constant_range = Vk.PushConstantRange(stage, 0, sizeof(DeviceAddressBlock))
  pipeline_layout = Vk.PipelineLayout(device, [], [push_constant_range])
  specialization_info = specialize_shader(source, specializations)
  pipeline_info = Vk.ComputePipelineCreateInfo(Vk.PipelineShaderStageCreateInfo(stage, shader, "main"; specialization_info), pipeline_layout, 0)
  ((pipeline, _...), _) = unwrap(Vk.create_compute_pipelines(device, [pipeline_info]))
  command_pool = Vk.CommandPool(device, queue_family_index)
  (command_buffer, _...) = unwrap(Vk.allocate_command_buffers(device, Vk.CommandBufferAllocateInfo(command_pool, Vk.COMMAND_BUFFER_LEVEL_PRIMARY, 1)))
  Vk.begin_command_buffer(command_buffer, Vk.CommandBufferBeginInfo())
  Vk.cmd_bind_pipeline(command_buffer, Vk.PIPELINE_BIND_POINT_COMPUTE, pipeline)
  data_address = Ref(DeviceAddressBlock(UInt64(out_device_ptr)))
  data_address_ptr = Base.unsafe_convert(Ptr{Cvoid}, data_address)
  Vk.cmd_push_constants(command_buffer, pipeline_layout, push_constant_range.stage_flags, push_constant_range.offset, push_constant_range.size, data_address_ptr)
  Vk.cmd_dispatch(command_buffer, 1, 1, 1)
  Vk.end_command_buffer(command_buffer)
  queue = Vk.get_device_queue(device, queue_family_index, 0)
  unwrap(Vk.queue_submit(queue, [Vk.SubmitInfo([], [], [command_buffer], [])]))
  GC.@preserve buffer memory pipeline_layout pipeline command_pool command_buffer data_address specialization_info queue begin
    unwrap(Vk.queue_wait_idle(queue))
    out = unsafe_load(Ptr{T}(out_host_ptr))
    Vk.free_command_buffers(device, command_pool, [command_buffer])
  end
  out
end

"""
Interface structure holding a device address as its single field.

This structure is necessary until SPIRV.jl can work around the requirement of
having interface block types be composite types.
"""
struct DeviceAddressBlock
  addr::UInt64
end

SPIRV.Pointer{T}(addr::DeviceAddressBlock) where {T} = SPIRV.Pointer{T}(addr.addr)

function execute(ex::Expr, T = nothing)
  T = @something(T, begin
    code = @eval SPIRV.@code_typed (() -> $ex)()
    code.parent.cache.rettype
  end)
  source = @eval @compute features = supported_features assemble = true (function (out)
    @store out::$T = $ex
  end)(::DeviceAddressBlock::PushConstant) options = ComputeExecutionOptions(local_size = (1, 1, 1))
  execute(source, device, T)
end
