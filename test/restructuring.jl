using SPIRV, Test, Dictionaries
using SPIRV: nesting_levels, merge_blocks, conflicted_merge_blocks, restructure_merge_blocks!, add_merge_headers!, id_bound, nexs, opcode

"""
Generate a minimal SPIR-V IR or module which contains dummy blocks realizing the provided control-flow graph.

Blocks that terminate will return a constant in line with its block index, e.g. `c23f0 = 23f0` for the block corresponding to the node 23.
Blocks that branch to more than one target will either branch with a `BranchConditional` (2 targets exactly) or a `Switch` (3 targets or more).
The selectors for conditionals or switches are exposed as function arguments. Note that the argument will be a `Bool` for conditionals and `Int32`
for switches.
"""
function ir_from_cfg(cfg)
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

  blocks = map(vertices(cfg)) do v
    insts = [:($(label(v)) = OpLabel())]
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
  load_ir(ex)
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
end;
