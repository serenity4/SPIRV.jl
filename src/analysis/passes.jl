function renumber_ssa(mod::Module)
  counter = SSACounter()
  swaps = SSADict{SSAValue}()
  new_insts = Instruction[]

  amod = AnnotatedModule(mod)
  c = cursor(amod)

  while position(c) < amod.functions
    push!(new_insts, swap_result_id!(swaps, counter, read(c)))
  end

  while !eof(c)
    push!(new_insts, swap_result_id!(swaps, counter, read(c)))

    blocks = read(c, Vector{Block})
    cfg = control_flow_graph(blocks)
    for block in blocks[traverse(cfg)]
      push!(new_insts, swap_result_id!(swaps, counter, @inst block.id = OpLabel()))
      for inst in block
        push!(new_insts, swap_result_id!(swaps, counter, inst))
      end
    end
  end

  for (i, inst) in enumerate(new_insts)
    for (j, arg) in enumerate(inst.arguments)
      if isa(arg, SSAValue)
        replacement = get(swaps, arg, nothing)
        if !isnothing(replacement)
          inst.arguments[j] = replacement
        end
      end
    end
    if isa(inst.type_id, SSAValue)
      new_insts[i] = @set inst.type_id = swaps[inst.type_id]
    end
  end

  Module(mod.meta, new_insts)
end

function swap_result_id!(swaps::SSADict{SSAValue}, counter::SSACounter, inst::Instruction)
  isnothing(inst.result_id) && return inst
  ssa = next!(counter)
  insert!(swaps, inst.result_id, ssa)
  @set inst.result_id = ssa
end
