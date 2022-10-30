using SPIRV, Test, Dictionaries
using SPIRV: nesting_levels, conflicted_merge_blocks

@testset "Restructuring utilities" begin
  cfg = ControlFlowGraph(g11())
  ctree = ControlTree(g11())
  nesting = nesting_levels(ctree)
  @test [last(nesting[index]) for index in 1:6] == [1, 2, 3, 3, 1, 2]
end
