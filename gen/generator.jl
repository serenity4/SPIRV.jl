using JSON3
using MacroTools
using JuliaFormatter: format_text, format_file

import SPIRV_Headers_jll

const include_dir = joinpath(SPIRV_Headers_jll.artifact_dir, "include", "spirv", "unified1")

includet("formatting.jl")
includet("grammar.jl")

mkpath(src_dir("generated"))

generate() && format()
