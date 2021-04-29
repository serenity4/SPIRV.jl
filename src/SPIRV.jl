module SPIRV

using CEnum
using MLStyle

import Base: convert, write, show, showerror, ==

const magic_number = 0x07230203

# generated SPIR-V wrapper
include("generated/enums.jl")
include("generated/instructions.jl")

for enum ∈ [:OpCode, :Decoration]
    @eval begin
        MLStyle.is_enum(::$enum) = true
        MLStyle.pattern_uncall(e::$enum, _, _, _, _) = MLStyle.AbstractPatterns.literal(e)
    end
end

include("parse.jl")
include("disassemble.jl")
include("ir.jl")
include("assemble.jl")
include("reflection.jl")

export
        # parse
        PhysicalInstruction, PhysicalModule,
        Instruction,

        # disassemble
        disassemble,

        # assemble
        assemble,

        # IR
        IR,
        Variable,

        # reflection
        bindings,
        descriptor_sets
end
