using SPIRV
using Test

const spv = SPIRV

resource(filename) = joinpath(@__DIR__, "resources", filename)

modules = SPIRModule.(resource.(["vert.spv", "frag.spv"]))

for mod ∈ modules
    disassemble(mod)
    ir = IR(mod)
    println.(ir.variables)
end
