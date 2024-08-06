#=

# [Creating a shader](@id tutorial-creating-a-shader)

This tutorial will show you how to:
- Create a SPIR-V shader using the experimental [Julia → SPIR-V compiler](@ref compiler).
- Execute it using [Vulkan.jl](https://github.com/JuliaGPU/Vulkan.jl).

## [Compiling a shader](@id tutorial-compiling-a-shader)

To create a shader, a method is to be defined that will typically mutate some built-in output variables, and may interact with GPU memory.

We will first quickly show how to compile a simplistic fragment shader, then move on to compiling a compute shader that we will execute in the second part of this tutorial.

Let's for example define a fragment shader that colors all pixels with the same color. We'll be using [Swizzles.jl](https://github.com/serenity4/Swizzles.jl), which allows us to conveniently use color-related property names and store to various subparts of a vector efficiently.

=#

using SPIRV: Vec3, Vec4, Mutable
using Swizzles: @swizzle

struct FragmentData
  color::Vec3
  alpha::Float32
end

function fragment_shader!(color::Mutable{Vec4}, data::FragmentData)
  @swizzle color.rgb = data.color
  @swizzle color.a = data.alpha
end

#=

This is a regular Julia function, which we may quickly test on the CPU first.

=#

color = Mutable(Vec4(0, 0, 0, 0))
white = Vec3(1, 1, 1)
data = FragmentData(white, 1)
fragment_shader!(color, data)
@assert color[1:3] == data.color
@assert color[4] == data.alpha

#=

Let's compile this shader. We'll also need to specify where the arguments will come from at the time of execution, as we can't provide it with values as we would a Julia function.

In Vulkan, the value of the current pixel [is encoded as a variable in the `Output` storage class](https://registry.khronos.org/vulkan/specs/1.3-extensions/html/chap15.html#interfaces-fragmentoutput), assuming we want to write to the first (and usually the only one) color attachment of the render pass that this shader will be executed within.

As for the `FragmentData`, there are a couple of possibilities; we can for example put that into a push constant, though a uniform buffer would have worked just as well.

We will specify this information using the [`@fragment`](@ref) macro, which accepts a handy syntax to annotate these arguments:

=#

using SPIRV: @fragment

shader = @fragment fragment_shader!(
  ::Mutable{Vec4}::Output,
  ::FragmentData::PushConstant
);

#=

There are multiple parameters to `@fragment`, but we'll stick with the defaults for now. Normally, we would at least provide a `features` parameter, which defines the set of features and extensions supported by our GPU for SPIR-V. The default assumes any feature or extension is allowed. We'll be able to accurately specify our GPU feature support when we query it via a graphics API, e.g. Vulkan.

Let's take a look at what we got!

=#

shader

#-

using SPIRV: validate

validate(shader)

#=

Neat! How should we execute it on the GPU now?

... Well, we can't, actually; or at least, not with SPIRV.jl alone. SPIR-V is an IR used by graphics APIs, so you will need a graphics API to run anything. And, as you probably know, we'll also need a vertex shader to run a fragment shader.

Let's now define our compute shdaer. We'll try to make it less trivial than our previous fragment shader. This time, we'll exponentiate a buffer where each invocation mutates a specific entry in that buffer.

We could setup a storage buffer, but for simplicity, we'll work with a memory address and a size instead, C-style, using the [`@load`](@ref) and [`@store`](@ref) utilities provided by SPIRV.jl.

=#

using SPIRV: @load, @store, @vec, U, Vec3U
using StaticArrays
using SPIRV.MathFunctions: linear_index

struct ComputeData
  buffer::UInt64 # memory address of a buffer
  size::UInt32 # buffer size
end

function compute_shader!((; buffer, size)::ComputeData, global_id::Vec3U)
  ## `global_id` is zero-based, coming from Vulkan; but we're now in Julia,
  ## where everything is one-based.
  index = global_id.x + 1U
  value = @load buffer[index]::Float32
  result = exp(value)
  1U ≤ index ≤ size && @store result buffer[index]::Float32
  nothing
end

#=

For the index into our vector of values, we'll rely on using one-dimensional workgroups to then use the current index among all dispatched invocations. SPIR-V provides the `GlobalInvocationId` built-in, which will be fed with this value.

You may notice that we use `1U`, which is simply some sugar syntax for `UInt32(1)`. We don't use the plain literal `1`. because we don't want `index` to widen to an `Int64`. See [Integer and float bit widths](@ref) for more details.

We can run this shader on the CPU to test it first, but it's a bit more hacky this time since we chose to work with a memory address.

Nonetheless, it's completely valid to take a pointer from an array and convert it to a `UInt64`, we can therefore proceed!

=#

array = ones(Float32, 256)

GC.@preserve array begin
  ptr = pointer(array)
  address = UInt64(ptr)
  data = ComputeData(address, length(array))
  compute_shader!(data, @vec UInt32[0, 0, 0])
  compute_shader!(data, @vec UInt32[5, 0, 0])
end

array

#=

All good! Let's now turn it into a SPIR-V shader. Same as before, let's assume we'll provide the `ComputeData` with a push constant.

We'll also specify the workgroup size (or local invocation size, in SPIR-V terms, from the `LocalSize` [execution mode](https://registry.khronos.org/SPIR-V/specs/unified1/SPIRV.html#_execution_mode)). Let's set it to 64 x 1 x 1, and rely on it being later invoked with at least 4 workgroups to cover all 256 array elements. We could also go with a two-dimensional pattern, such as 8 x 8 x 1, but then we'd need to do extra math in our shader to derive a linear index from a two-dimensional index, unnecessarily complicating things.

=#

using SPIRV: @compute, ComputeExecutionOptions

shader = @compute compute_shader!(
  ::ComputeData::PushConstant,
  ::Vec3U::Input{GlobalInvocationId},
) options = ComputeExecutionOptions(local_size = (64, 1, 1))

#-

validate(shader)

#=

Et voilà! Notice the `LocalSizeId` execution mode pointing to the constants `(64, 1, 1)` in the corresponding IR.

# Executing a shader with Vulkan

After [compiling a shader](@ref tutorial-compiling-a-shader), the next logical step is to execute it. This requires the help of a graphics API that uses SPIR-V, such as Vulkan or OpenGL (with the [corresponding SPIR-V extension](https://registry.khronos.org/OpenGL/extensions/ARB/ARB_gl_spirv.txt)). We will use Vulkan via [Vulkan.jl](https://github.com/JuliaGPU/Vulkan.jl).

As Vulkan usage falls out of scope of this documentation, we will not detail nor comment the steps used to setup everything, beyond inline code comments. Furthermore, note that the code shown is designed to execute this specific compute shader. For resources about Vulkan API usage, please consult the [Vulkan.jl documentation](https://juliagpu.github.io/Vulkan.jl/dev/) as well as other Vulkan tutorials out there.

To proceed, we will need to interface with the Vulkan loader with a `Vk.Instance`, and pick a device on which to execute our shader.

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

Great. We'll take the one from the previous tutorial, which we already know how to compile.

However, this time we'll create a [`SPIRV.ShaderSource`](@ref), which represents a [`SPIRV.Shader`](@ref) assembled into a word vector, using the macro parameter `assemble = true`. We'll also fill in the `features` parameter, such that we are guaranteed that the Julia → SPIR-V compiler returns a shader that is compatible with our Vulkan API usage.

=#

source = @compute features = supported_features assemble = true compute_shader!(
  ::ComputeData::PushConstant,
  ::Vec3U::Input{GlobalInvocationId},
  ) options = ComputeExecutionOptions(local_size = (64, 1, 1))

#=

Here comes the hard part. To submit our shader for execution, we need to:
- Provide Vulkan with our shader.
- Construct a buffer on the device that holds our `Vector` data, then get its memory address.
- Build a command buffer and submit the appropriate commands to invoke our compute shader.
- Wait for the computation to finish and copy the results into our original `Vector`.

This is all quite verbose, but with Vulkan, this is expected.

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

  ## Get its device address.
  ## Note that this is a device address, not a host address; it should only be used from a shader executing on `device`.
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
  ## to bother with flushing and invalidating memory.
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
- The data layout matches exactly with the data layout declared in the shader.

Even if we assume that we do not have mutable data, data layouts may not match.

To better take a look at it, we'll use [About.jl](https://github.com/tecosaur/About.jl), to display the layout of the Julia structure:

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

## Note: this snippet uses internals for demonstration purposes.
using SPIRV: SPIRV

amod = SPIRV.annotate(SPIRV.Module(shader.ir))
amod[amod.annotations]

#=

The `MemberDecorate(..., ..., Offset, ...)` decorations provide offset information for each field of a structure (here, the only structure present in the shader is the one that represents our `ComputeData`).

We have:
- An offset of 0 bytes for the `UInt64` whose size is 8 bytes.
- An offset of 8 bytes for the `UInt32` whose size is 4 bytes.
- In absence of remaining layout information, we may conclude that the total size equals 12 bytes.

In this case, the data offsets are identical, therefore memory accesses won't be problematic. But there are cases (notably with non-default layout parameters) where offsets differ, and it is good to be aware of that. To avoid relying on chance, it is advised to [`serialize`](@ref) the data using the appropriate layout.

=#
