module SPIRV

using CEnum

include_gen_file(x::String...) = include(joinpath(@__DIR__, "generated", x...))

include_gen_file("enums.jl")
include_gen_file("instructions.jl")

end
