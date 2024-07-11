# Targeting SPIR-V via LLVM

As described in the [introduction](@ref Introduction), SPIR-V and LLVM IR are both formats to describe programs; but behind the apparent similarity lies a substantial difference between the two. Most importantly, the flavor of SPIR-V relevant for graphics workloads is in its current state incompatible with LLVM IR.

There exists a [SPIR-V to LLVM bidirectional translator](https://github.com/KhronosGroup/SPIRV-LLVM), but the project title omits one thing: only the OpenCL subset of SPIR-V is supported. Adding support for the graphics subset would be a tedious task; see [this issue comment](https://github.com/KhronosGroup/SPIRV-LLVM/issues/202#issuecomment-278367134) for more details about a few of the challenges involved.

Therefore, this package cannot rely on LLVM tooling to generate SPIR-V from Julia code, and has to think about other ways. One promising approach so far is to [target SPIR-V from Julia IR](@ref compiler) using the `AbstractInterpreter` interface.
