using SPIRV, Test, Dictionaries
using SPIRV: nesting_levels, find_merge_blocks, conflicted_merge_blocks, restructure_merge_blocks!, add_merge_headers!, Diff, apply!

"""
Generate a minimal SPIR-V IR or module which contains dummy blocks realizing the provided control-flow graph.

Blocks that terminate will return a constant in line with its block index, e.g. `c23f0 = 23f0` for the block corresponding to the node 23.
Blocks that branch to more than one target will either branch with a `BranchConditional` (2 targets exactly) or a `Switch` (3 targets or more).
The selectors for conditionals or switches are exposed as function arguments. Note that the argument will be a `Bool` for conditionals and `Int32`
for switches.
"""
function module_from_cfg(cfg; ir = false)
  global_decls = quote
    Bool = TypeBool()
    Float32 = TypeFloat(32)
  end

  label(v) = Symbol(:b, v)
  constant(v) = Symbol(:c, v, :f0)
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
      for w in outneighbors(cfg, v)
        push!(insts, Expr(:call, :Switch, condition(v), label(first(out)), Iterators.flatten([Int32(w) => label(w) for w in out])...))
      end
    end
  end

  func = :(@function f($(args...))::Float32 begin
    $(foldl(append!, blocks; init = Expr[])...)
  end)

  ex = Expr(:block, global_decls.args..., func)
  ir ? load_ir(ex) : load_module(ex)
end

@testset "Restructuring utilities" begin
  ir = module_from_cfg(g11(); ir = true)
  @test unwrap(validate(ir))

  # Starting module: two conditionals sharing the same merge block.
  original_mod = module_from_cfg(g11())
  amod = annotate(original_mod)

  # Restructure merge blocks.
  diff = restructure_merge_blocks!(Diff(amod), amod)
  @test length(diff.insertions) == 2 && length(diff.modifications) == 2
  mod = apply!(diff)
  @test mod.bound == original_mod.bound + 1
  @test unwrap(validate(IR(mod)))

  # Add merge headers.
  amod = annotate(mod)
  diff = add_merge_headers!(Diff(amod), amod)
  @test length(diff.insertions) == 2
  mod = apply!(diff)
  amod = annotate(mod)
  af = only(amod.annotated_functions)
  @test length(find_merge_blocks(amod, af)) == 2
  @test isempty(conflicted_merge_blocks(amod, af))

  ctree = ControlTree(g11())
  nesting = nesting_levels(ctree)
  @test [last(nesting[index]) for index in 1:6] == [1, 2, 3, 3, 1, 2]
end;
