function renumber_ssa(mod::Module)
  renumber_ssa(annotate(mod)).mod
end

function renumber_ssa(amod::AnnotatedModule)
  counter = IDCounter()
  swaps = ResultDict{ResultID}()
  new_insts = Instruction[]

  for inst in instructions(amod, first(amod.capabilities):(first(amod.functions) - 1))
    push!(new_insts, swap_result_id!(swaps, counter, inst))
  end

  for af in amod.annotated_functions
    cfg = ControlFlowGraph(amod, af)
    for inst in instructions(amod, first(af.range):last(af.parameters))
      push!(new_insts, swap_result_id!(swaps, counter, inst))
    end
    for block in af.blocks[traverse(cfg)]
      for inst in instructions(amod, block)
        push!(new_insts, swap_result_id!(swaps, counter, inst))
      end
    end
    push!(new_insts, @inst OpFunctionEnd())
  end

  for (i, inst) in enumerate(new_insts)
    for (j, arg) in enumerate(inst.arguments)
      isa(arg, ResultID) && (inst.arguments[j] = swaps[arg])
    end
    if isa(inst.type_id, ResultID)
      new_insts[i] = @set inst.type_id = swaps[inst.type_id]
    end
  end

  annotate(Module(amod.mod.meta, new_insts))
end

function swap_result_id!(swaps::ResultDict{ResultID}, counter::IDCounter, inst::Instruction)
  isnothing(inst.result_id) && return @set inst.arguments = copy(inst.arguments)
  id = next!(counter)
  insert!(swaps, inst.result_id, id)
  @set inst.result_id = id
end
