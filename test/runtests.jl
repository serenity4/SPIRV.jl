using SPIRV
using Test

const spv = SPIRV

resource(filename) = joinpath(@__DIR__, "resources", filename)

for r in resource.(["vert.spv", "frag.spv"])
    pmod = PhysicalModule(r)
    mod = SPIRModule(pmod)
    disassemble(mod)
    ir = IR(mod)
    println.(ir.variables)
end
