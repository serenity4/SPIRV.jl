module SPIRV

using CEnum
using Crayons

include_gen_file(x::String...) = include(joinpath(@__DIR__, "generated", x...))

const magic_number = 0x07230203

include_gen_file("enums.jl")
include_gen_file("instructions.jl")

include("parser.jl")

export
        InstructionChunk,
        GenericInstruction,
        parse_spirv,
        SPIRModule,
        disassemble

end
