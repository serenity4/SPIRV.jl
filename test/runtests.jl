using SPIRV
using Test

const spv = SPIRV

resource(filename) = joinpath(@__DIR__, "resources", filename)

modules = SPIRModule.(resource.(["vert.spv", "frag.spv"]))

disassemble.(modules)
