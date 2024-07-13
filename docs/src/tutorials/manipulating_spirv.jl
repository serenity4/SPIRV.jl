#=

# Manipulating SPIR-V binaries

SPIR-V is a binary format. One implication is that introspecting into SPIR-V code requires specialized tools to read and make sense of the data.

In this package, we provide ways to read binaries from files or `IO` streams. Depending on how much you want your SPIR-V binaries to be analyzed, we provide a few data structures:
- [`PhysicalModule`](@ref), which is a thin wrapper over the general SPIR-V format. Instructions are parsed into [`PhysicalInstruction`](@ref)s, which encode the [most basic structure](https://registry.khronos.org/SPIR-V/specs/unified1/SPIRV.html#_physical_layout_of_a_spir_v_module_and_instruction) of a SPIR-V instruction. This data structure is used exclusively for serialization/deserialization purposes, and little can be done with it beyond that.
- [`SPIRV.Module`](@ref), which preserves the general layout of a SPIR-V module and adds more information about its [logical layout](https://registry.khronos.org/SPIR-V/specs/unified1/SPIRV.html#_logical_layout_of_a_module). Notably, instructions use the [`Instruction`](@ref) data structure which encodes logical information about their semantics ([`SPIRV.OpCode`](@ref)), type and result identifiers ([`ResultID`](@ref)), and any arguments parsed into Julia types (`Float32`, `Float64`, etc). Pretty-printing is provided for [`SPIRV.Module`](@ref)s, which will show the SPIR-V module in colored human-readable text to `MIME"text/plain"` outputs.
- [`IR`](@ref), which splits a SPIR-V module into many secondary associative data structures, grouped by semantics. This is the best form to inspect logical sections of SPIR-V modules such as functions, types, or constants. It may be constructed by hand or from a [`SPIRV.Module`](@ref), and is convertible to a [`SPIRV.Module`](@ref) by aggregating all of the logical sections and serializing them into an instruction stream.

Let's first start by looking at the first data structure, [`PhysicalModule`](@ref). We will use a tiny vertex shader in SPIR-V form as our binary file.

=#

using SPIRV, Test

bytes = read(joinpath(@__DIR__, "vert.spv"))

#-

pmod = PhysicalModule(bytes)
pmod.instructions

# There isn't much to look at here. We can assemble this module back into a sequence of words:

words = assemble(pmod)

# which is identical to the sequence of bytes we originally had:

@test reinterpret(UInt8, words) == bytes

# To see better into our SPIR-V binary, let's parse it into a [`SPIRV.Module`](@ref) and pretty-print its contents:

mod = SPIRV.Module(bytes)

# Contents still remain unchanged. Let's prove that:

@test assemble(mod) == words

# Now, let's go all the way and do some work to understand the contents of this SPIR-V module:

ir = IR(bytes)

#=

The IR is still printed as an instruction stream, but that is only for pretty-printing; the data structure itself loses the sequential layout of the module. Pretty-printing first transforms the IR into a [`SPIRV.Module`](@ref), then uses some of the information stored in the IR to enhance the display. Notice how certain previously numbered variable names were substituted with actual variable names, such as `%frag_color`.

**This IR data structure is not public**, in the sense that we do not commit to a stable semantically versioned implementation; it has notably been designed in context of the [Julia to SPIR-V compiler](@ref compiler), which is still experimental. However, if you want to explore a given SPIR-V module, you can try to make sense of its contents:

=#

ir.fdefs

#-

ir.constants

#-

ir.types

#-

ir.capabilities

# Let's now assemble it into a sequence of words. Note how the regenerated module slightly differs from the original module.

mod_regenerated = SPIRV.Module(ir)

setdiff(mod, mod_regenerated)

#-

setdiff(mod_regenerated, mod)
