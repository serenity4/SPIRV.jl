# SPIRV

![tests](https://github.com/serenity4/SPIRV.jl/workflows/Run%20tests/badge.svg) [![](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip) [![](https://img.shields.io/badge/docs-stable-blue.svg)](https://serenity4.github.io/SPIRV.jl/stable) [![](https://img.shields.io/badge/docs-dev-blue.svg)](https://serenity4.github.io/SPIRV.jl/dev)

Collection of tools for processing [SPIR-V](https://www.khronos.org/spir/) binaries. It intends to provide some features of [SPIR-V Tools](https://github.com/KhronosGroup/SPIRV-Tools) and [SPIR-V Cross](https://github.com/KhronosGroup/SPIRV-Cross), rewritten in Julia.

This is currently a work in progress. The [current documentation](https://serenity4.github.io/SPIRV.jl/dev) may contain some information, but is still lacking. Potential users are encouraged to look at the tests and at the source code for more information.

This library contains a very experimental Julia to SPIR-V compiler, built as an alternative SPIR-V backend to the Julia compilation pipeline. Some of the internal code used for integrating with the compilation pipeline was inspired from [GPUCompiler.jl](https://github.com/JuliaGPU/GPUCompiler.jl), but we do not rely on LLVM.
