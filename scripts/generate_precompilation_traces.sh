#!/bin/bash

# Make sure to uncomment the inclusion of `precompiled.jl` from `src/SPIRV.jl`,
# otherwise we'll be missing a lot of precompile directives.

tmp=/tmp/__SPIRV_compiled.jl
dst="src/precompilation_traces.jl"

echo "Running tests with --trace-compile=$tmp"
# julia --color=yes --project --startup-file=no --trace-compile=$tmp test/runtests.jl

echo "Writing precompile statements at $dst"
julia --color=yes -e "str = read(\"$tmp\", String); open(\"$dst\", \"w+\") do io; for line in split(str, '\n'); contains(line, \"SPIRV\") && !contains(line, \"Main\") && println(io, line); end; end"
