#=

# Executing a shader

After [creating and compiling shaders](@ref tutorial-creating-a-shader), the next logical step is executing them. Thsi requires the help of a graphics API that uses SPIR-V, such as Vulkan or OpenGL (with the [corresponding SPIR-V extension](https://registry.khronos.org/OpenGL/extensions/ARB/ARB_gl_spirv.txt)). We will use Vulkan through Vulkan.jl.

As Vulkan usage falls out of scope of this documentation, we will not detail nor comment the steps used to setup everything, beyond inline code comments. For resources about Vulkan API usage, please consult the [Vulkan.jl documentation](https://juliagpu.github.io/Vulkan.jl/dev/).

First, we need to interface with the Vulkan loader with a `Vk.Instance`, and pick a device for shader execution.

=#

using SPIRV: SupportedFeatures, check_compiler_feature_requirements
using Vulkan: Vk, VkCore, unwrap

# Create callback for logging and error reporting.
debug_callback_c = @cfunction(Vk.default_debug_callback, UInt32, (Vk.DebugUtilsMessageSeverityFlagEXT, Vk.DebugUtilsMessageTypeFlagEXT, Ptr{VkCore.VkDebugUtilsMessengerCallbackDataEXT}, Ptr{Cvoid}))

function create_device()
  ## Use the validation layers.
  layers = String["VK_LAYER_KHRONOS_validation"]
  ## Enable logging.
  extensions = String["VK_EXT_debug_utils"]
  instance = Vk.Instance(layers, extensions; application_info = Vk.ApplicationInfo(v"0.1", v"0.1", v"1.3"))
  debug_messenger = Vk.DebugUtilsMessengerEXT(instance, debug_callback_c)

  ## Pick the first physical device that we find.
  physical_device = first(unwrap(Vk.enumerate_physical_devices(instance)))
  @info "Selected $(Vk.get_physical_device_properties(physical_device))"

  ## Request Vulkan API features necessary for the usage with SPIRV.jl
  device_features_1_1 = Vk.PhysicalDeviceVulkan11Features(:variable_pointers, :variable_pointers_storage_buffer)
  device_features_1_2 = Vk.PhysicalDeviceVulkan12Features(:buffer_device_address, :vulkan_memory_model; next = device_features_1_1)
  device_features_1_3 = Vk.PhysicalDeviceVulkan13Features(:synchronization2, :dynamic_rendering, :shader_integer_dot_product, :maintenance4; next = device_features_1_2)
  device_features = Vk.PhysicalDeviceFeatures2(Vk.PhysicalDeviceFeatures(:shader_float_64, :shader_int_64); next = device_features_1_3)

  ## Create the device requesting a queue that supports graphics and compute operations.
  device_extensions = String[]
  queue_family_index = Vk.find_queue_family(physical_device, Vk.QUEUE_GRAPHICS_BIT | Vk.QUEUE_COMPUTE_BIT)
  device = Vk.Device(
    physical_device,
    [Vk.DeviceQueueCreateInfo(queue_family_index, [1.0])],
    [], device_extensions; next = device_features
  )

  ## Query all of the supported SPIR-V features, to be communicated to the Julia → SPIR-V compiler.
  supported_features = SupportedFeatures(physical_device, v"1.3", device_extensions, device_features)
  ## Check that we have the basic features that the compiler will require.
  check_compiler_feature_requirements(supported_features)

  (; debug_messenger, device, queue_family_index, supported_features)
end

(; debug_messenger, device, queue_family_index, supported_features) = create_device();

#=

Great. Now, we need to think about what we're going to do. We will first execute a compute shader, taking the one from the previous tutorial.

This time, we'll create a [`SPIRV.ShaderSource`](@ref), which represents a [`SPIRV.Shader`](@ref) assembled into a word vector, using the macro parameter `assemble = true`. We'll also fill in the `features` parameter, such that we are guaranteed that the Julia → SPIR-V compiler returns a shader that is compatible with our Vulkan API usage.

=#

source = @compute features = supported_features assemble = true compute_shader!(
  ::ComputeData::PushConstant,
  ::Vec3U::Input{GlobalInvocationId},
  ) options = ComputeExecutionOptions(local_size = (64, 1, 1))

#=

To submit our shader for execution, we first need to:
- Provide Vulkan with our shader.
- Construct a buffer on the device that holds our `Vector` data, then get its memory address.
- Build a command buffer and submit the appropriate commands to invoke our compute shader.
- Wait for the computation to finish and copy the results into our original `Vector`.

This is all quite verbose, but with Vulkan, this is normal.

=#

using SPIRV: ShaderSource, serialize

"""
Execute a shader on the provided device and return the result, which **must** be of type `T`.
"""
function execute_shader(source::ShaderSource, device::Vk.Device, queue_family_index, array::Vector{Float32})
  ## Provide Vulkan with our shader.
  stage = Vk.ShaderStageFlag(source.info.interface.execution_model)
  @assert stage == Vk.SHADER_STAGE_COMPUTE_BIT
  shader = Vk.ShaderModule(device, source)

  ## Construct a buffer on the device.
  buffer = Vk.Buffer(device, sizeof(array), Vk.BUFFER_USAGE_SHADER_DEVICE_ADDRESS_BIT, Vk.SHARING_MODE_EXCLUSIVE, [queue_family_index])
  ## Allocate memory for it, selecting a memory that is host-visible and host-coherent.
  memory_requirements = Vk.get_buffer_memory_requirements(device, buffer)
  memory_index = find_memory_type(device.physical_device, memory_requirements.memory_type_bits, Vk.MEMORY_PROPERTY_HOST_VISIBLE_BIT | Vk.MEMORY_PROPERTY_HOST_COHERENT_BIT)
  memory = Vk.DeviceMemory(device, memory_requirements.size, memory_index; next = Vk.MemoryAllocateFlagsInfo(0; flags = Vk.MEMORY_ALLOCATE_DEVICE_ADDRESS_BIT))
  unwrap(Vk.bind_buffer_memory(device, buffer, memory, 0))

  ## Get a pointer to this memory, so we can write to it.
  memory_ptr = unwrap(Vk.map_memory(device, memory, 0, sizeof(array)))
  GC.@preserve array begin
    data_ptr = pointer(array)
    unsafe_copyto!(Ptr{Float32}(memory_ptr), data_ptr, length(array))
  end

  ## Get its device address while we're at it.
  ## Note that this is a device address, not a host address; it should only be used inside a shader.
  buffer_address = Vk.get_buffer_device_address(device, Vk.BufferDeviceAddressInfo(buffer))

  ## Create the compute pipeline our shader will be executed with.
  push_constant_range = Vk.PushConstantRange(stage, 0, 12)
  pipeline_layout = Vk.PipelineLayout(device, [], [push_constant_range])
  ## Note: the name of the entry point of any shader compiled with SPIRV.jl will always be "main".
  pipeline_info = Vk.ComputePipelineCreateInfo(Vk.PipelineShaderStageCreateInfo(stage, shader, "main"), pipeline_layout, 0)
  ((pipeline, _...), _) = unwrap(Vk.create_compute_pipelines(device, [pipeline_info]))

  ## Build the command buffer and record the appropriate commands to invoke our compute shader.
  command_pool = Vk.CommandPool(device, queue_family_index)
  (command_buffer, _...) = unwrap(Vk.allocate_command_buffers(device, Vk.CommandBufferAllocateInfo(command_pool, Vk.COMMAND_BUFFER_LEVEL_PRIMARY, 1)))
  Vk.begin_command_buffer(command_buffer, Vk.CommandBufferBeginInfo())
  Vk.cmd_bind_pipeline(command_buffer, Vk.PIPELINE_BIND_POINT_COMPUTE, pipeline)
  ## --> This is where we provide our `ComputeData` argument.
  push_constant = serialize(ComputeData(buffer_address, length(array)), source.info.layout)
  push_constant_ptr = pointer(push_constant)
  Vk.cmd_push_constants(command_buffer, pipeline_layout, push_constant_range.stage_flags, push_constant_range.offset, push_constant_range.size, Ptr{Cvoid}(push_constant_ptr))
  ## --------------------------------------------------------
  ## Dispatch as many workgroups as necessary to cover all array elements.
  workgroup_invocations = prod(source.info.interface.execution_options.local_size)
  Vk.cmd_dispatch(command_buffer, cld(length(array), workgroup_invocations), 1, 1)
  Vk.end_command_buffer(command_buffer)

  ## Get a queue for submission, then submit the command buffer.
  queue = Vk.get_device_queue(device, queue_family_index, 0)
  unwrap(Vk.queue_submit(queue, [Vk.SubmitInfo([], [], [command_buffer], [])]))

  ## Wait for all operations to finish, making sure none of the
  ## required resources are cleaned up by the GC before then.
  ## Finally, retrieve the data.
  GC.@preserve array buffer memory pipeline_layout pipeline command_pool command_buffer push_constant queue begin
    unwrap(Vk.queue_wait_idle(queue))
    data_ptr = pointer(array)
    unsafe_copyto!(data_ptr, Ptr{Float32}(memory_ptr), length(array))
    Vk.free_command_buffers(device, command_pool, [command_buffer])
    Vk.unmap_memory(device, memory)
  end
  array
end

## Utility function to find a memory that satisfies all our requirements.
function find_memory_type(physical_device::Vk.PhysicalDevice, type, properties::Vk.MemoryPropertyFlag)
  memory_properties = Vk.get_physical_device_memory_properties(physical_device)
  memory_types = memory_properties.memory_types[1:(memory_properties.memory_type_count)]
  candidate_indices = findall(i -> type & (1 << i) ≠ 0, 0:(memory_properties.memory_type_count - 1))
  ## Make sure we get a host-coherent memory, because we don't want
  ##  to bother with flushing and invalidating memory.
  index = findfirst(i -> in(Vk.MEMORY_PROPERTY_HOST_COHERENT_BIT, memory_types[i].property_flags), candidate_indices)
  index - 1
end

array .= range(0.0, 1.0, length(array))

execute_shader(source, device, queue_family_index, array)

#=

I'd like to draw attention to something *extremely* important. This concerns the following piece of code in `execute_shader`:

```julia
push_constant = serialize(ComputeData(buffer_address, length(data)), source.info.layout)
```

One may have thought instead to construct a `Ref` to the push constant, and then convert the `Ref` into a pointer. That would actually work, in the case where:
- No mutable data is stored inside (as Julia stores pointers to these objects, not their data, for mutable struct fields).
- Data alignments match exactly with the alignments present in the shader.

Even if we assume that we do not have mutable data, data alignments may not match.

Let's take a look at all that. Using [About.jl](https://github.com/tecosaur/About.jl), we can see the layout of the Julia structure:

=#

using About: about

about(ComputeData)

#=

We have:
- 8 bytes for the `UInt64`
- 4 bytes for the `UInt32`
- 4 extra bytes of padding.

Totalling a size of 16 bytes.

The shader we compiled has the following decorations:

=#

using SPIRV: SPIRV # hide

amod = SPIRV.annotate(SPIRV.Module(shader.ir)) # hide
display(amod[amod.annotations]); # hide

#=

The `MemberDecorate(..., ..., Offset, ...)` decorations provide offset information for each field of a structure (here, the only structure present in the shader is the one that represents our `ComputeData`).

We have:
- An offset of 0 bytes for the `UInt64` whose size is 8 bytes.
- An offset of 8 bytes for the `UInt32` whose size is 4 bytes.
- In absence of remaining layout information, we may conclude that the total size equals 12 bytes.

In this case, the data offsets are identical, therefore memory accesses won't be problematic. But there are cases (notably with non-default layout parameters) where offsets differ, and it is good to be aware of that. To avoid relying on chance, it is advised to [`serialize`](@ref) the data using the appropriate layout.

=#
