using SPIRV
using Test

const spv = SPIRV

resource(filename) = joinpath(@__DIR__, "resources", filename)

println(SPIRModule(resource("vert.spv")))
println(SPIRModule(resource("frag.spv")))
