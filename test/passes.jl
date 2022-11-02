using SPIRV, Test, Accessors
using SPIRV: renumber_ssa, compute_id_bound, id_bound

@testset "SSA renumbering" begin
  mod = SPIRV.Module(PhysicalModule(resource("vert.spv")))
  composite_extract = mod[end - 8]
  mod[end - 8] = @set composite_extract.result_id = ResultID(57)
  mod[end - 6].arguments[1] = ResultID(57)
  renumbered = renumber_ssa(mod)
  @test renumbered ≠ mod
  @test unwrap(validate(renumbered))
  @test length(mod) == length(renumbered)
  @test renumbered[end - 8].result_id ≠ ResultID(57)
  @test id_bound(renumbered) == compute_id_bound(renumbered.instructions) == id_bound(mod)

  mod = SPIRV.Module(PhysicalModule(resource("comp.spv")))
  renumbered = renumber_ssa(mod)
  @test unwrap(validate(renumbered))
end;
