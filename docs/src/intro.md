# Introduction

[SPIR-V](https://www.khronos.org/registry/spir-v/specs/unified1/SPIRV.html) defines a binary format for GPU code. It is an intermediate representation (IR), similar in surface to LLVM IR for CPUs. It contains two major subsets, one being used by compute APIs (such as OpenCL and OneAPI), the other being used by graphics APIs (Vulkan and OpenGL, mostly). The two are incompatible with each other, but have enough overlap that they are expressed within the same format.

While most GPUs models expose a common vendor-specific assembly-like IR for compute APIs (such as PTX for NVIDIA and GCN for AMD), shaders used by graphics APIs rarely map to any clearly-defined assembly language. Notably, the way graphics shaders are run on the GPU is very often GPU-specific, not only specific to vendors but also to GPU models and architectures.

In the world of graphics, SPIR-V is the closest that one can get to an assembly language for most GPUs. This is partly owed to the fact that graphics shaders come with a lot of state, and a shader can in most cases be thought of a program *and* an execution environment bundled together. As a consequence, SPIR-V defines a format for specifying both the program and its execution environment through the use of features and special intrinsics.

This disparity between compute IRs and the lack of proper graphics IRs make it so that SPIR-V maps well to LLVM IR only for its compute subset. To understand that, graphics rendering relies a lot on shader-specific notions at the hardware level, such as uniform buffers, textures, attachments, push constants, and more. This is difficult to properly express with LLVM IR, because those notions are only related to graphics processing; in fact, they are relevant mainly to speed up graphics rendering by expressing semantics that map to specialized hardware features.

This library currently targets the Vulkan-flavored version of SPIR-V, aimed at manipulating shaders. However, this library also contains general functionality such as assembling/disassembling SPIR-V, independent of the SPIR-V subset used.
