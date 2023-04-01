# These precompile directives should be regenerated regularly
# using `/scripts/generate_precompile.sh`.
@precompile_all_calls begin
  @compile_traces verbose = false joinpath(@__DIR__, "precompilation_traces.jl")
end
