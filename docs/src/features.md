# Features

## Reading, introspecting into and writing SPIR-V modules

SPIR-V can be read in its binary format (usually ending in `.spv`), or can be parsed as a human-understandable format (usually ending in `.spvasm`).

A SPIR-V module can be disassembled to an `IO` to print a human-understandable output.

It can also be assembled to a binary format, usually to be saved on disk or to be used by a consumer of SPIR-V code (e.g. Vulkan).

An `IR` structure is also available to reason about a given SPIR-V module globally, and not just as a stream of instructions.
This form is suited for introspection and modification. It can then be converted back to a SPIR-V module. Note that a module converted to an IR which is converted back to a module will not be identical, even if no modification was made to the IR; the ordering of certain instructions (such as debugging instructions) may not be the same, although there will be no change of semantics.

## Julia to SPIR-V compiler

This library contains an experimental Julia to SPIR-V compiler, which only supports Vulkan-flavored SPIR-V. From a SPIR-V perspective, this is a Julia frontend, and from a Julia perspective, this is a SPIR-V backend (as opposed to the traditional LLVM backend used to execute CPU code).

!!! warning
    This functionality requires Julia 1.9 or higher.

This compiler supports:
- Basic SPIR-V instructions, requiring special types (`Arr`, `Vec`, `Mat`).
- GLSL intrinsics (can be disabled).
- Automatic computation of layout requirements according to an [`LayoutStrategy`](@ref).
- Automatic declaration of SPIR-V capabilities and extensions based on a user-provided [`FeatureSupport`](@ref) (see [`SupportedFeatures`](@ref) to manually specify features).

Current outstanding limitations are:
- No support for any kind of loops.
- Only supports a subset of all possible SPIR-V instructions.
- No real-world testing yet.

Furthermore, this compiler will never support:
- Calls to any runtime logic (including dynamic dispatch and `isa` calls, used e.g. in union splitting). SPIR-V does not allow for calling external libraries.
- Arbitrary Julia code. Any code used by SPIR-V should be written expressly for that purpose, or at least with a conscious effort to support compilation to SPIR-V.

However, any Julia program that you can write in perspective of being compiled to SPIR-V *should* be executable on the CPU directly, unless they rely on specific features from the SPIR-V execution environment (such as external shader resources).

With that in mind, one should note that code that is expected to compile will likely have to be hand-written. Do not expect to compile arbitrary functions.

Please understand that this compiler is brittle and immature at the moment.
