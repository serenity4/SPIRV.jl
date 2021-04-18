module SPIRV

using CEnum
using Crayons
using MLStyle
using MLStyle.AbstractPatterns: literal

include_gen_file(x::String...) = include(joinpath(@__DIR__, "generated", x...))

const magic_number = 0x07230203

include_gen_file("enums.jl")
include_gen_file("instructions.jl")

for enum ∈ [:OpCode, :Decoration]
    @eval begin
        MLStyle.is_enum(::$enum) = true
        MLStyle.pattern_uncall(e::$enum, _, _, _, _) = literal(e)
    end
end

include("parser.jl")
include("disassemble.jl")
include("ir.jl")
include("resources.jl")

export
        # parser
        InstructionChunk,
        GenericInstruction,
        parse_spirv,
        SPIRModule,
        disassemble,

        # IR
        IR,
        Variable
end
