@testset "Restructuring utilities" begin
  for i in 1:13
    # Skip a few tricky cases for now.
    in(i, (6, 8)) && continue
    ir = ir_from_cfg(getproperty(@__MODULE__, Symbol(:g, i))())
    @test unwrap(validate(ir))
    @test isa(SPIRV.sprintc_mime(show, ir), String)
  end

  # Starting module: two conditionals sharing the same merge block.
  ir = ir_from_cfg(g11())
  # Restructure merge blocks.
  fdef = only(ir)
  n = nexs(fdef)
  bound = id_bound(ir)
  restructure_merge_blocks!(ir)
  # A new dummy block needs to be inserted (2 instructions), and 2 branching blocks needed to be updated to branch to the new block.
  @test nexs(fdef) == n + 2
  @test id_bound(ir) == ResultID(UInt32(bound) + 1)
  @test unwrap(validate(ir))

  # Add merge headers.
  add_merge_headers!(ir)
  @test nexs(fdef) == n + 4
  @test length(merge_blocks(fdef)) == 2
  @test isempty(conflicted_merge_blocks(fdef))
  @test unwrap(validate(ir))

  # Starting module: A conditional and a loop sharing the same merge block, with the loop inside the conditional.
  ir = ir_from_cfg(g10())
  fdef = only(ir)
  n = nexs(fdef)
  bound = id_bound(ir)
  restructure_merge_blocks!(ir)
  # There is only one update to make to the branching node 3.
  @test nexs(fdef) == n + 2
  @test id_bound(ir) == ResultID(UInt32(bound) + 1)
  @test unwrap(validate(ir))

  # Add merge headers.
  add_merge_headers!(ir)
  @test nexs(fdef) == n + 4
  @test length(merge_blocks(fdef)) == 2
  @test isempty(conflicted_merge_blocks(fdef))
  @test unwrap(validate(ir))

  ctree = ControlTree(g11())
  nesting = nesting_levels(ctree)
  @test [last(nesting[index]) for index in 1:6] == [1, 2, 3, 3, 1, 2]

  ir = ir_from_cfg(g12())
  add_merge_headers!(ir)
  fdef = only(ir)
  (merge_blk, (header_blk,)) = only(pairs(merge_blocks(fdef)))
  @test opcode(last(fdef[header_blk])) == SPIRV.OpBranchConditional

  ir = @spv_ir begin
    Bool = TypeBool()
    no = ConstantFalse()::Bool
    Float32 = TypeFloat(32)
    x0f0 = Constant(0f0)::Float32
    x1f0 = Constant(1f0)::Float32
    x2f0 = Constant(2f0)::Float32
    x3f0 = Constant(3f0)::Float32
    x4f0 = Constant(4f0)::Float32
    @function f()::Float32 begin
      b1 = Label()
      BranchConditional(no, b2, b3)
      b2 = Label()
      BranchConditional(no, b4, b5)
      b3 = Label()
      Branch(b5)
      b4 = Label()
      Branch(b5)
      b5 = Label()
      x = Phi(x0f0, b2, x1f0, b3, x2f0, b4)::Float32
      y = Phi(x2f0, b2, x3f0, b3, x4f0, b4)::Float32
      ret = FAdd(x, y)::Float32
      ReturnValue(ret)
    end
  end
  @test unwrap(validate(ir))
  restructure_merge_blocks!(ir)
  @test unwrap(validate(ir))
  @test SPIRV.Module(ir) == SPIRV.Module(restructure_merge_blocks!(deepcopy(ir)))

  ir = ir_from_cfg(g14())
  fdef = only(ir)
  @test unwrap(validate(ir))
  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  @test isempty(conflicted_merge_blocks(fdef))
  @test unwrap(validate(ir))

  ir = ir_from_cfg(g15())
  fdef = only(ir)
  @test unwrap(validate(ir))
  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  @test isempty(conflicted_merge_blocks(fdef))
  @test unwrap(validate(ir))

  ir = ir_from_cfg(g16())
  fdef = only(ir)
  @test unwrap(validate(ir))
  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  @test isempty(conflicted_merge_blocks(fdef))
  @test unwrap(validate(ir))

  ir = ir_from_cfg(g17())
  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  @test unwrap(validate(ir))

  ir = ir_from_cfg(g18(); structured = true)
  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  @test_throws "Selection must be structured" unwrap(validate(ir))
  restructure_loop_header_conditionals!(ir)
  @test unwrap(validate(ir))

  ir = ir_from_cfg(g20(); structured = true)
  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  restructure_loop_header_conditionals!(ir)
  @test unwrap(validate(ir))

  ir = ir_from_cfg(g24(); structured = true, phi = true)
  ctree = ControlTree(ControlFlowGraph(ir[1]))
  @test ctree == ControlTree(1, REGION_BLOCK, [
    ControlTree(1, REGION_BLOCK),
    ControlTree(2, REGION_PROPER, [
      ControlTree(2, REGION_BLOCK),
      ControlTree(3, REGION_BLOCK),
      ControlTree(4, REGION_BLOCK),
      ControlTree(5, REGION_BLOCK),
      ControlTree(6, REGION_BLOCK),
    ]),
  ])
  restructure_proper_regions!(ir)
  fdef = ir[1]
  ctree = ControlTree(ControlFlowGraph(fdef))
  @test ctree == ControlTree(1, REGION_BLOCK, [
    ControlTree(1, REGION_BLOCK),
    ControlTree(2, REGION_IF_THEN, [
      ControlTree(2, REGION_BLOCK),
      ControlTree(3, REGION_IF_THEN, [
        ControlTree(3, REGION_BLOCK),
        ControlTree(4, REGION_BLOCK),
      ]),
    ]),
    ControlTree(7, REGION_IF_THEN, [
      ControlTree(7, REGION_BLOCK),
      ControlTree(5, REGION_BLOCK),
      ]),
    ControlTree(6, REGION_BLOCK),
  ])
  phi_values(ex) = [haskey(ir.constants, id) ? ir.constants[id].value : id for id in @view ex[1:2:end]]
  node(i) = fdef[i].id
  phi_pairs(exs) = map((x, y) -> x .=> y, phi_sources.(exs), phi_values.(exs))

  phis = phi_expressions.(fdef)
  @test all(==([]), phis[1:4])

  @test length(phis[7]) == 3
  exs7 = phis[7]
  possibilities = phi_pairs(exs7)
  @test issubset([node(2) => 1, node(3) => 2], possibilities[1])
  @test issubset([node(4) => 4], possibilities[2])
  @test issubset([node(2) => 5, node(3) => 5, node(4) => 6], possibilities[3])

  @test length(phis[5]) == 1
  exs5 = phis[5]
  possibilities = phi_pairs(exs5)
  @test issubset([node(7) => exs7[1].result], possibilities[1])

  @test length(phis[6]) == 1
  exs6 = phis[6]
  possibilities = phi_pairs(exs6)
  @test issubset([node(7) => exs7[2].result, node(5) => 3], possibilities[1])

  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  @test unwrap(validate(ir))

  ir = ir_from_cfg(g21(); structured = true, phi = true)
  restructure_proper_regions!(ir)
  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  @test unwrap(validate(ir))

  ir = ir_from_cfg(g22(); structured = true, phi = true)
  restructure_proper_regions!(ir)
  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  @test unwrap(validate(ir))

  ir = ir_from_cfg(g24(); structured = true, phi = true)
  restructure_proper_regions!(ir)
  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  @test unwrap(validate(ir))

  ir = ir_from_cfg(g28(); structured = true, phi = true)
  restructure_proper_regions!(ir)
  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  @test unwrap(validate(ir))

  ir = ir_from_cfg(g29(); structured = true, phi = true)
  restructure_proper_regions!(ir)
  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  @test unwrap(validate(ir))

  ir = ir_from_cfg(g30(); structured = true, phi = true)
  @test_broken begin
    restructure_proper_regions!(ir)
    restructure_merge_blocks!(ir)
    add_merge_headers!(ir)
    @test unwrap(validate(ir))
  end
end;
