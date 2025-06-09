# [Julia → SPIR-V compiler](@id compiler)

SPIRV.jl defines a Julia → SPIR-V compiler, built via the `AbstractInterpreter` interface. While standard compilation of Julia code emits LLVM IR to be turned into CPU machine code, this SPIR-V compiler emits SPIR-V IR aimed at consumption with a graphics API such as Vulkan. This compiler may be described equivalently as a Julia frontend for SPIR-V, or a SPIR-V backend for Julia.

!!! note
    This compiler only supports the Vulkan subset of SPIR-V. The OpenCL subset of SPIR-V is not a focus of this package at the moment.

!!! note
    This functionality requires Julia 1.11 or higher.

!!! warning
    This compiler is largely experimental at the moment, and lacks real-world testing. Expect bugs and instabilities across Julia versions.

The shaders are to be provided as regular Julia methods, but with restrictions: only a subset of Julia is supported (see [Language support](@ref) below), excluding exceptions, arrays, strings, and more.

## Language support

The limitations imposed on Julia programs for SPIR-V compilation are the following:
- Special types are required to interface with the corresponding SPIR-V array, vector, matrix and image types (`Arr`, `Vec`, `Mat`, `Image`, `SampledImage`).
- `String`s and `Symbol`s are not supported, lacking SPIR-V counterparts.
- Dynamic runtime features are not supported. This includes dynamic dispatch, `isa` type checks (unless elided by compile-time optimizations), `invokelatest`, tasks, and so on.
- `Union` types are not supported, though there may be ways to support them in the future with some overhead.
- Exceptions are not supported by SPIR-V.
- Calling external libraries via FFI is not supported by SPIR-V.
- Recursive functions are not supported by SPIR-V.
- Arrays with an unspecified size are only allowed in restricted situations; see [the conditions for such runtime arrays to be valid in Vulkan](https://registry.khronos.org/vulkan/specs/1.3-extensions/html/chap52.html#VUID-StandaloneSpirv-OpTypeRuntimeArray-04680). However, if the `PhysicalStorageBufferAddresses` capability is enabled, you may use pointers and offsets instead (see [`@load`](@ref) and [`@store`](@ref) for this usage).
- `Ptr` is not supported, but you may use [`@load`](@ref) and [`@store`](@ref) with `UInt64` which use the internal [`SPIRV.Pointer`](@ref) type.
- Structs cannot access their fields dynamically, i.e. with a runtime index into their fields, even if they are all of the same type.

A few additional limitations exist currently that may be removed in the future:
- Keyword arguments are not supported.
- Mutable objects can't be mutated, but a [`Mutable`](@ref) object may be constructed which then supports `setindex!` (acting like a `Ref`, but with special support for SPIR-V mutation semantics). This limitation stems from the fact that SPIR-V expresses mutability in a fundamentally different way than Julia, which can't be reliably supported.
- Callable objects cannot be compiled, or only if the resulting code does not access any of its fields. For this reason, prefer `blur(x::GaussianBlur, ...) = compute_blur(x.strength, ...)` to `(x::GaussianBlur)(...) = compute_blur(x.strength, ...)`. For this reason, closures (which are callable objects in disguise) should always be [inlined](https://docs.julialang.org/en/v1/base/base/#Base.@inline) so that these intermediate objects may be optimized away.
- `Base.ctlz` and `Base.cttz` intrinsics to count leading and trailing zeroes are not supported, having no SPIR-V counterpart.
- `Expr(:throw_undef_if_not, ...)` is not supported, forbidding programs that access a variable that may or may not have been defined depending on prior control-flow.

Due to these limitations, arbitrary Julia code is unlikely to compile successfully out of the box without a conscious effort to only operate within the compatible Julia language subset.

Regarding support for the SPIR-V language:
- Most basic SPIR-V instructions are covered.
- A few SPIR-V instructions are not covered yet, especially those related to advanced uses; if you need one that is missing, please file an issue or contact the developers directly. We aim to have all shader-related SPIR-V instructions added eventually.
- GLSL intrinsics are available via a corresponding method table overlay (which can be disabled).
- Data layouts are automatically computed according to a [`LayoutStrategy`](@ref).
- SPIR-V capabilities and extensions are automatically declared in shaders based on a user-provided [`FeatureSupport`](@ref) (see [`SupportedFeatures`](@ref) to specify the exact set of features supported by a given driver).
- Vulkan features and extensions are automatically translated to SPIR-V capabilities and features, provided by a [Vulkan.jl](https://github.com/JuliaGPU/Vulkan.jl) package extension that adds a constructor to [`SupportedFeatures`](@ref).

Any Julia program that you can write in perspective of being compiled to SPIR-V should be executable on the CPU, unless they rely on specific configurations of the SPIR-V execution environment. For instance, filtered [image operations](https://registry.khronos.org/SPIR-V/specs/unified1/SPIRV.html#_image_instructions) are not supported for CPU execution, nor are [derivative operations](https://registry.khronos.org/SPIR-V/specs/unified1/SPIRV.html#Derivative) or [group operations](https://registry.khronos.org/SPIR-V/specs/unified1/SPIRV.html#_group_and_subgroup_instructions), to cite a few.

## Targeting SPIR-V via LLVM

As described in the [introduction](@ref Introduction), SPIR-V and LLVM IR are both formats to describe programs; but behind the apparent similarity lie fundamental differences between the two. Most importantly, the SPIR-V subset relevant for graphics workloads is in its current state incompatible with LLVM IR.

There exists a [SPIR-V to LLVM bidirectional translator](https://github.com/KhronosGroup/SPIRV-LLVM), but the project title omits one thing: only the OpenCL subset of SPIR-V is supported. Adding support for the graphics subset would be a tedious task; see [this issue comment](https://github.com/KhronosGroup/SPIRV-LLVM/issues/202#issuecomment-278367134) for more details about a few of the challenges involved.

Therefore, we cannot rely on LLVM tooling to generate SPIR-V from Julia code; that is unfortunate, as we otherwise might have been able to use the [GPUCompiler.jl](https://github.com/JuliaGPU/GPUCompiler.jl) infrastructure. The approach so far that has been promising is to [target SPIR-V from Julia IR](@ref compiler) using the `AbstractInterpreter` interface, hooking into Julia's compilation pipeline in a way that is similar to [GPUCompiler.jl](https://github.com/JuliaGPU/GPUCompiler.jl) until we bifurcate to emit SPIR-V IR instead of LLVM IR.
