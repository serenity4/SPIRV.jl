using SPIRV, Vulkan
using SPIRV: @compute

debug_callback_c = @cfunction(default_debug_callback, UInt32, (DebugUtilsMessageSeverityFlagEXT, DebugUtilsMessageTypeFlagEXT, Ptr{VkCore.VkDebugUtilsMessengerCallbackDataEXT}, Ptr{Cvoid}))

function create_device()
  layers = String[]
  # Validation layers seem to crash when `Bool` is returned.
  # layers = String["VK_LAYER_KHRONOS_validation"]
  extensions = String["VK_EXT_debug_utils"]
  instance = Instance(layers, extensions; application_info = ApplicationInfo(v"0.1", v"0.1", v"1.3"))
  messenger = DebugUtilsMessengerEXT(instance, debug_callback_c)
  physical_device = first(unwrap(enumerate_physical_devices(instance)))
  device_features_1_2 = PhysicalDeviceVulkan12Features(:buffer_device_address, :vulkan_memory_model)
  device_features_1_3 = PhysicalDeviceVulkan13Features(:synchronization2, :dynamic_rendering; next = device_features_1_2)
  device_features = PhysicalDeviceFeatures2(PhysicalDeviceFeatures(:shader_float_64, :shader_int_64); next = device_features_1_3)
  device_extensions = String[]
  queue_family_index = find_queue_family(physical_device, QUEUE_GRAPHICS_BIT | QUEUE_COMPUTE_BIT)
  device = Device(
    physical_device,
    [DeviceQueueCreateInfo(queue_family_index, [1.0])],
    [], device_extensions; next = device_features
  )
  supported_features = SupportedFeatures(physical_device, v"1.3", device_extensions, device_features)
  (; device, queue_family_index, supported_features)
end

(; device, queue_family_index, supported_features) = create_device()

function find_memory_type(physical_device::PhysicalDevice, type, properties::MemoryPropertyFlag)
  memory_properties = get_physical_device_memory_properties(physical_device)
  memory_types = memory_properties.memory_types[1:(memory_properties.memory_type_count)]
  candidate_indices = findall(i -> type & (1 << i) ≠ 0, 0:(memory_properties.memory_type_count - 1))
  index = findfirst(i -> in(MEMORY_PROPERTY_HOST_COHERENT_BIT, memory_types[i].property_flags), candidate_indices)
  index - 1
end

"""
Execute a shader on the provided device and return the result, which **must** be of type `T`.
"""
function execute(source::ShaderSource, device::Device, T::Type)
  @assert isconcretetype(T)
  stage = ShaderStageFlag(source.info.interface.execution_model)
  @assert stage == SHADER_STAGE_COMPUTE_BIT

  shader = ShaderModule(device, source)

  buffer = Buffer(device, sizeof(T), BUFFER_USAGE_SHADER_DEVICE_ADDRESS_BIT, SHARING_MODE_EXCLUSIVE, [queue_family_index])
  memory_requirements = get_buffer_memory_requirements(device, buffer)
  memory_index = find_memory_type(device.physical_device, memory_requirements.memory_type_bits, MEMORY_PROPERTY_HOST_VISIBLE_BIT | MEMORY_PROPERTY_HOST_COHERENT_BIT)
  memory = DeviceMemory(device, memory_requirements.size, memory_index; next = Vk.MemoryAllocateFlagsInfo(0; flags = MEMORY_ALLOCATE_DEVICE_ADDRESS_BIT))
  unwrap(bind_buffer_memory(device, buffer, memory, 0))
  out_host_ptr = unwrap(map_memory(device, memory, 0, sizeof(T)))
  out_device_ptr = get_buffer_device_address(device, BufferDeviceAddressInfo(buffer))

  push_constant_range = PushConstantRange(stage, 0, sizeof(DeviceAddressBlock))
  pipeline_layout = PipelineLayout(device, [], [push_constant_range])
  pipeline_info = ComputePipelineCreateInfo(PipelineShaderStageCreateInfo(stage, shader, "main"), pipeline_layout, 0)
  ((pipeline, _...), _) = unwrap(create_compute_pipelines(device, [pipeline_info]))
  command_pool = CommandPool(device, queue_family_index)
  (command_buffer, _...) = unwrap(allocate_command_buffers(device, CommandBufferAllocateInfo(command_pool, COMMAND_BUFFER_LEVEL_PRIMARY, 1)))
  begin_command_buffer(command_buffer, CommandBufferBeginInfo())
  cmd_bind_pipeline(command_buffer, PIPELINE_BIND_POINT_COMPUTE, pipeline)
  data_address = Ref(DeviceAddressBlock(UInt64(out_device_ptr)))
  data_address_ptr = Base.unsafe_convert(Ptr{Cvoid}, data_address)
  cmd_push_constants(command_buffer, pipeline_layout, push_constant_range.stage_flags, push_constant_range.offset, push_constant_range.size, data_address_ptr)
  cmd_dispatch(command_buffer, 1, 1, 1)
  end_command_buffer(command_buffer)
  queue = get_device_queue(device, queue_family_index, 0)
  unwrap(queue_submit(queue, [SubmitInfo([], [], [command_buffer], [])]))
  GC.@preserve buffer memory pipeline_layout pipeline command_pool command_buffer data_address queue begin
    unwrap(queue_wait_idle(queue))
    out = unsafe_load(Ptr{T}(out_host_ptr))
    free_command_buffers(device, command_pool, [command_buffer])
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
  source = @eval @compute supported_features VulkanAlignment() assemble = true (function (out)
    @store out::$T = $ex
  end)(::DeviceAddressBlock::PushConstant) options = ComputeExecutionOptions(local_size = (1, 1, 1))
  execute(source, device, T)
end
