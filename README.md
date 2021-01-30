# SPIRV

![tests](https://github.com/serenity4/SPIRV.jl/workflows/Run%20tests/badge.svg) [![](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip) [![](https://img.shields.io/badge/docs-stable-blue.svg)](https://serenity4.github.io/SPIRV.jl/stable) [![](https://img.shields.io/badge/docs-dev-blue.svg)](https://serenity4.github.io/SPIRV.jl/dev)

Collection of tools for processing [SPIR-V](https://www.khronos.org/spir/) binaries. It intends to provide some features of [SPIR-V Tools](https://github.com/KhronosGroup/SPIRV-Tools) and [SPIR-V Cross](https://github.com/KhronosGroup/SPIRV-Cross), rewritten in Julia to allow for a user-friendlier API than potential wrapped versions through C.

This is currently a work in progress. A basic disassembler is currently available, and it is planned to add reflection utilities to inspect shaders, in particular shader resources. It is intended to be used with Vulkan through [VulkanCore.jl](https://github.com/JuliaGPU/VulkanCore.jl). See also a (fork of the) higher-layer [Vulkan.jl](https://github.com/serenity4/Vulkan.jl) (under active development).

## Generate package files

A portion of this package relies on static code generation. To re-generate the files, execute `gen/generator.jl` in the environment specified in `gen`:

```
julia --color=yes --project=gen -e 'using Pkg; Pkg.instantiate(); include("gen/generator.jl")'
```
