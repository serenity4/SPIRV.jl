# Features

## Reading, introspecting into and writing SPIR-V modules

SPIR-V can be read in its binary format (usually ending in `.spv`), or can be parsed as a human-understandable format (usually ending in `.spvasm`).

A SPIR-V module can be disassembled to an `IO` to print a human-understandable output.

It can also be assembled to a binary format, usually to be saved on disk or to be used by a consumer of SPIR-V code (e.g. Vulkan).

An `IR` structure is also available to reason about a given SPIR-V module globally, and not just as a stream of instructions.
This form is suited for introspection and modification. It can then be converted back to a SPIR-V module. Note that a module converted to an IR which is converted back to a module will not be identical, even if no modification was made to the IR; the ordering of certain instructions (such as debugging instructions) may not be the same, although there will be no change of semantics.
