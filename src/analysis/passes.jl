function renumber_ssa(mod::Module)
  renumber_ssa(annotate(mod)).mod
end

function renumber_ssa(amod::AnnotatedModule)
  counter = IDCounter()
  swaps = ResultDict{ResultID}()
  new_insts = Instruction[]

  for inst in instructions(amod, first(amod.capabilities):(last(amod.globals)))
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
      if isa(arg, ResultID)
        if !haskey(swaps, arg)
          @warn "A reference to $arg was made in $(sprintc_mime(show, inst)), but no instruction defines this ID in the original module. Leaving it untouched."
        else
          inst.arguments[j] = swaps[arg]
        end
      end
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

"""
Remove all annotations (including debug annotations and decorations)
such as `Name`, `Decorate`, etc. if referenced IDs are greater than the bound
declared by the module.
"""
function remove_obsolete_annotations!(amod::AnnotatedModule)
  diff = Diff(amod)
  bound = ResultID(amod.mod.bound)
  for i in amod.debug
    inst = amod[i]
    any(x -> isa(x, ResultID) && x ≥ bound, inst.arguments) && delete!(diff, i)
  end
  apply!(amod, diff)
end

remove_obsolete_annotations!(mod::Module) = remove_obsolete_annotations!(annotate(mod))
