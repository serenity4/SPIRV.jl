# Known bugs

Here is a collection of bugs that have occurred in the past related to SPIR-V code generation, to hopefully help debug any driver hangs or crashes. Most SPIR-V violations are caught with the SPIR-V validator, but sometimes others go unnoticed because they come from unusual but legal SPIR-V that drivers may have a hard time with. We will only list possible driver bugs that arise with legal SPIR-V, as validation bugs are easy to catch.

This page should not be useful to most users, unless you are actively trying to debug a crash that is known to emanate from a specific SPIR-V module.

## Vulkan

Bugs triggered using the Vulkan API.

### Hangs during pipeline creation

The final compilation of shaders into machine code occurs at pipeline creation, i.e. `vkCreateGraphicsPipelines`, `vkCreateComputePipelines` and similar functions for more advanced pipelines such as ray-tracing pipelines.

- **Writing large arrays of images to a `Variable` with storage class `Function`**: Most shader code compiled with GLSL or HLSL will most likely only ever index into global variables for arrays of descriptors. However, using SPIRV.jl we currently may end up with such arrays that are non-global in certain situations. We try to eventually update any use of local descriptor arrays in the `CompositeExtractToAccessChainLoad` pass to use the corresponding global variable. Possibly any descriptor array would exhibit a similar bug. Only tested with NVIDIA proprietary drivers.
