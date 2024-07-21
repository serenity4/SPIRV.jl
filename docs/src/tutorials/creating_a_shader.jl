#=

# [Creating a shader](@id tutorial-creating-a-shader)

This tutorial will show you how to create a SPIR-V shader using the experimental [Julia → SPIR-V compiler](@ref compiler).

When creating a shader, the corresponding method will typically mutate some built-in output variables, and may interact with GPU memory. Let's for example define a fragment shader that colors all pixels with the same color.

=#

using SPIRV: Vec3, Vec4, Mutable

struct FragmentData
  color::Vec3
  alpha::Float32
end

function fragment_shader!(color::Mutable{Vec4}, data)
  color[] = Vec4(data.color..., data.alpha)
end

#=

This is a regular Julia function, which we may even test on the CPU to make sure it does what we want.

=#

color = Mutable(Vec4(0, 0, 0, 0))
white = Vec3(1, 1, 1)
data = FragmentData(white, 1)
fragment_shader!(color, data)
@assert color[1:3] == data.color
@assert color[4] == data.alpha

#=

Let's compile this shader now. We'll also need to specify where the arguments will come from at the time of execution, as we can't provide it with values as we would a Julia function.

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

... Well, we can't, actually; or at least, not with SPIRV.jl alone. SPIR-V is an IR used by graphics APIs, so you will need a graphics API to run anything. And, as you probably know, we'll also need a vertex shader to run a fragment shader. This will be covered by another tutorial.

For fun, let's now generate a compute shader. We'll try to make it less trivial than our previous fragment shader. This time, we'll exponentiate a whole buffer across invocations.

We could setup a storage buffer, but for simplicity, we'll work with a memory address and a size instead, C-style, using the [`@load`](@ref) and [`@store`](@ref) utilities provided by SPIRV.jl.

=#

using SPIRV: @load, @store, @vec, U
using StaticArrays
using SPIRV.MathFunctions: linear_index

struct ComputeData
  buffer::UInt64 # memory address of a buffer
  size::UInt32 # buffer size
end

function compute_shader!((; buffer, size)::ComputeData, global_id)
  # `global_id` is zero-based, coming from Vulkan; but we're now in Julia,
  # where everything is one-based.
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

We'll also specify the workgroup size (or local invocation size, in SPIR-V terms, from the `LocalSize` [execution mode](https://registry.khronos.org/SPIR-V/specs/unified1/SPIRV.html#_execution_mode)). Let's set it to 64 x 1 x 1, and rely on it being later invoked with at least 4 workgroups to cover all 256 array elements. We could also go with a two-dimensional pattern, such as 8 x 8 x 1, but then we'd need to do extra math in our shader to derive a linear index from a two-dimensional index, needlessly complicating things.

=#

using SPIRV: @compute, ComputeExecutionOptions

shader = @compute compute_shader!(
  ::ComputeData::PushConstant,
  ::Vec3U::Input{GlobalInvocationId},
) options = ComputeExecutionOptions(local_size = (64, 1, 1))

#-

validate(shader)

# Et voilà! Notice the `LocalSizeId` execution mode pointing to the constants `(64, 1, 1)` in the corresponding IR.
