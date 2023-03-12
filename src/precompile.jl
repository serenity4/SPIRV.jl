# These precompile directives should be regenerated regularly
# using `/scripts/generate_precompile.jl`.
@precompile_all_calls begin
  exs = Meta.parse("""quote $(read(joinpath(@__DIR__, "precompile_generated.jl"), String)) end""").args[1].args
  succeeded = 0
  failed = 0
  for ex in exs
    isa(ex, LineNumberNode) && continue
    try
      eval(ex)
      succeeded += 1
    catch
      failed += 1
    end
  end
  if !iszero(failed)
    @debug "Precompilation failed for $failed out of $(failed + succeeded) precompile directives."
  end
end
