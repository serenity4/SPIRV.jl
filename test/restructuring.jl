using SPIRV, Test, Dictionaries
using Graphs
using SPIRV: nesting_levels, merge_blocks, conflicted_merge_blocks, restructure_proper_regions!, restructure_merge_blocks!, add_merge_headers!, restructure_loop_header_conditionals!, id_bound, nexs, opcode

"""
Generate a minimal SPIR-V IR or module which contains dummy blocks realizing the provided control-flow graph.

Blocks that terminate will return a constant in line with its block index, e.g. `c23f0 = 23f0` for the block corresponding to the node 23.
Blocks that branch to more than one target will either branch with a `BranchConditional` (2 targets exactly) or a `Switch` (3 targets or more).
The selectors for conditionals or switches are exposed as function arguments. Note that the argument will be a `Bool` for conditionals and `Int32`
for switches.
"""
function ir_from_cfg(cfg; structured = false, phi = false)
  global_decls = quote
    Bool = TypeBool()
    Float32 = TypeFloat(32)
    Int32 = TypeInt(32, 1)
  end

  label(v) = Symbol(:b, v)
  constant(v) = Symbol(:c, v, :f0)
  constant_int(v) = Symbol(:c, v, :i32)
  condition(v) = Symbol(:x, v)

  append!(global_decls.args, :($(constant(v)) = Constant($(v * 1f0))::Float32) for v in sinks(cfg))

  args = [Expr(:(::), condition(v), length(outneighbors(cfg, v)) > 2 ? :Int32 : :Bool) for v in vertices(cfg) if length(outneighbors(cfg, v)) > 1]

  phi_counter = 0

  blocks = map(vertices(cfg)) do v
    insts = [:($(label(v)) = OpLabel())]
    if phi
      ins = inneighbors(cfg, v)
      if length(ins) ≥ 2
        identifier = Symbol(:phi_, v)
        arguments = []
        for u in ins
          phi_counter += 1
          x = Symbol(identifier, :_, u)
          push!(global_decls.args, :($x = Constant($(Int32(phi_counter)))::Int32))
          push!(arguments, x, label(u))
        end
        inst = :($identifier = Phi($(arguments...))::Int32)
        push!(insts, inst)
      end
    end
    out = outneighbors(cfg, v)
    if length(out) == 0
      push!(insts, :(ReturnValue($(constant(v)))))
    elseif length(out) == 1
      push!(insts, :(Branch($(label(only(out))))))
    elseif length(out) == 2
      push!(insts, :(BranchConditional($(condition(v)), $(label(out[1])), $(label(out[2])))))
    else
      inst = Expr(:call, :Switch, condition(v), label(first(out)))
      for w in out
        push!(global_decls.args, :($(constant_int(w)) = Constant($(Int32(w)))::Int32))
        push!(inst.args, constant_int(w), label(w))
      end
      push!(insts, inst)
    end
  end

  func = :(@function f($(args...))::Float32 begin
    $(foldl(append!, blocks; init = Expr[])...)
  end)

  ex = Expr(:block, global_decls.args..., func)
  ir = load_ir(ex)
  !structured && return ir
  push!(empty!(ir.capabilities), SPIRV.CapabilityShader)
  # For some reason, we need the GLSL memory model to trigger CFG validation errors.
  ir.memory_model = SPIRV.MemoryModelGLSL450
  ir
end

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
  ctree = ControlTree(ControlFlowGraph(ir[1]))
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

  ir = ir_from_cfg(g23(); structured = true, phi = true)
  # FIXME: Switch regions are not recognized by the structural analysis.
  @test_broken begin
    restructure_proper_regions!(ir)
    restructure_merge_blocks!(ir)
    add_merge_headers!(ir)
    @test unwrap(validate(ir))
  end

  # ir = IR(read(SPIRV.Module, "issue.spvasm"))
  # ir = IR(read(SPIRV.Module, "issue2.spvasm"))
  # # ctree = ControlTree(g21())
  # restructure_merge_blocks!(ir)
  # plotcfg(ir[1])
end;
