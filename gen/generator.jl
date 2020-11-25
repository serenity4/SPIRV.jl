using Clang
import SPIRV_Headers_jll

include_dir = joinpath(SPIRV_Headers_jll.artifact_dir, "include", "spirv", "unified1")
headers = joinpath.(Ref(include_dir), ["spirv.h"])

# Set up include paths
clang_includes = [include_dir]

# Clang arguments
clang_extraargs = ["-v"]

# Test if a header should be wrapped
function wrap_header(top_hdr, cursor_header)
    any(startswith.(Ref(dirname(cursor_header)), clang_includes))
end

wc = init(;
            headers,
            output_file="", # nothing written here
            common_file=joinpath(@__DIR__, "spirv.jl"),
            clang_includes,
            clang_args=clang_extraargs,
            header_wrapped=wrap_header,
            clang_diagnostics=true,
)

run(wc)
