using JSON3
using MacroTools
using JuliaFormatter

import SPIRV_Headers_jll

include_dir = joinpath(SPIRV_Headers_jll.artifact_dir, "include", "spirv", "unified1")

include("grammar.jl")
