using JSON3
using MacroTools
using JuliaFormatter: format_text, format_file

import SPIRV_Headers_jll

include_dir = joinpath(SPIRV_Headers_jll.artifact_dir, "include", "spirv", "unified1")

include("formatting.jl")
include("grammar.jl")
