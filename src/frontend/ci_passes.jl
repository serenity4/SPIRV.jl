struct NewCodeInfo
  from::CodeInfo
  insts::Vector{Any}
  from_ssavalues::Vector{Bool}
end
NewCodeInfo(from::CodeInfo) = NewCodeInfo(from, Any[], Int[])

function should_remove_instruction(inst, i, cfg)
  # Strip any `:meta` expression, as we don't read anything from them.
  Meta.isexpr(inst, :meta) && return true
  # Remove basic blocks consisting of a lone `nothing` statement.
  if inst === nothing
    bb = basic_block(cfg, i)
    isempty(bb.preds) && length(bb.stmts) == 1 && return true
  end
  false
end

function apply_passes(code::CodeInfo)
  new_code = NewCodeInfo(code)
  cfg = compute_basic_blocks(code.code)
  for (i, inst) in enumerate(code.code)
    if should_remove_instruction(inst, i, cfg)
      push!(new_code.from_ssavalues, false)
    else
      push!(new_code.from_ssavalues, true)
      push!(new_code.insts, inst)
    end
  end
  adjust_ssa_values!(new_code)
  code_info(new_code)
end

function new_ssa_value(new::NewCodeInfo, old::Signed)
  ispreserved = new.from_ssavalues[old]
  ispreserved || error("SSA value $old has been discarded but is required as an argument to another instruction.")
  count(@view new.from_ssavalues[1:old])
end

new_ssa_value(new::NewCodeInfo, old::Core.SSAValue) = Core.SSAValue(new_ssa_value(new, old.id))
new_ssa_value(new::NewCodeInfo, old) = old

function adjust_ssa_values!(new::NewCodeInfo)
  replace(old) = new_ssa_value(new, old)
  replace_ssa(old) = isa(old, Core.SSAValue) ? new_ssa_value(new, old) : old
  for (i, inst) in enumerate(new.insts)
    adjusted = @match inst begin
      ::Core.GotoNode => Core.GotoNode(replace(inst.label))
      ::Core.GotoIfNot => Core.GotoIfNot(replace.((inst.cond, inst.dest))...)
      ::Core.PhiNode => Core.PhiNode(Int32[replace(e) for e in inst.edges], Any[replace_ssa(v) for v in inst.values])
      ::Core.ReturnNode && if isdefined(inst, :val) end => Core.ReturnNode(replace_ssa(inst.val))
      ::Expr && if any(isa(arg, Core.SSAValue) && new.from_ssavalues[arg.id] for arg in inst.args) end => begin
          ex = Expr(inst.head)
          append!(ex.args, replace_ssa.(inst.args))
          ex
        end
      _ => nothing
    end
    !isnothing(adjusted) && (new.insts[i] = adjusted)
  end
  new
end

@eval _CodeInfo(args...) = $(Expr(:splatnew, CodeInfo, :args))

function code_info(code::NewCodeInfo)
  (; from) = code
  # Must be updated if new instructions may be added.
  # XXX: Consider editing code locations to reflect modifications.
  codelocs = from.codelocs[code.from_ssavalues]
  ssavaluetypes = isa(from.ssavaluetypes, Vector{Any}) ? from.ssavaluetypes[code.from_ssavalues] : from.ssavaluetypes
  ssaflags = from.ssaflags[code.from_ssavalues]

  @static if VERSION < v"1.10-DEV"
    new_code = _CodeInfo(
      code.insts,
      codelocs,
      ssavaluetypes,
      ssaflags,
      from.method_for_inference_limit_heuristics,
      from.linetable,
      from.slotnames,
      from.slotflags,
      from.slottypes,
      from.rettype,
      from.parent,
      from.edges,
      from.min_world,
      from.max_world,
      from.inferred,
      from.inlining_cost,
      from.propagate_inbounds,
      from.pure,
      from.has_fcall,
      from.constprop,
      from.purity,
    )
  else
    new_code = _CodeInfo(
      code.insts,
      codelocs,
      ssavaluetypes,
      ssaflags,
      from.method_for_inference_limit_heuristics,
      from.linetable,
      from.slotnames,
      from.slotflags,
      from.slottypes,
      from.rettype,
      from.parent,
      from.edges,
      from.min_world,
      from.max_world,
      from.inferred,
      from.propagate_inbounds,
      from.has_fcall,
      from.nospecializeinfer,
      from.inlining,
      from.constprop,
      from.purity,
      from.inlining_cost,
    )
  end
  verify(new_code)
  new_code
end

function verify(new_ci::CodeInfo)
  errors = Core.Compiler.validate_code(new_ci)
  isempty(errors) || error("Errors were detected in CodeInfo: $(join(errors, ", "))")
end
