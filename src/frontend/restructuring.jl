function restructure_merge_blocks!(diff::Diff, amod::AnnotatedModule, af::AnnotatedFunction)
  cfg = control_flow_graph(amod, af)
  merge_blocks = conflicted_merge_blocks(amod, af, cfg)
  isempty(merge_blocks) && return nothing

  global_ctree = ControlTree(cfg)
  for (merge_block, sources) in pairs(merge_blocks)
    nested_sources = sort_blocks_by_nesting(global_ctree, sources)

    # Use a new merge block for all structured constructs except the outer one,
    # which gets to win over the others for the conflicting merge block.
    for ctree in reverse(@view nested_sources[2:end])
      # Create a new node and insert it appropriately into the CFG without changing semantics.

      _, merge_block_inst = block_instruction(amod, af, merge_block)
      branching_blocks = [node(tree) for tree in Leaves(ctree) if in(merge_block, outneighbors(cfg, node(tree)))]

      new = @inst next!(diff) = Label()
      new_instructions = [new]

      # Adjust branching instructions from branching blocks so that they branch to the new node instead.
      redirect_branches!(diff, amod, af, branching_blocks, merge_block_inst.result_id, new.result_id)

      # Update merge header.
      (i, merge_inst) = merge_header(amod, af, node(ctree))
      update!(diff, i => update_merge_block(merge_inst, new.result_id))

      # Intercept OpPhi instructions on the original merge block by the new block.
      updated_phi_insts, new_phi_insts = intercept_phi_instructions!(diff.ssacounter, amod, af, branching_blocks, merge_block)
      append!(new_instructions, new_phi_insts)
      update!(diff, pairs(updated_phi_insts))

      push!(new_instructions, @inst Branch(merge_block_inst.result_id))
      insert!(diff, i => inst for (i, new_inst) in zip(merge_block_index:length(new_instructions), new_instructions))
    end
  end

  diff
end

function sort_blocks_by_nesting(ctree::ControlTree, blocks)
  trees = ControlTree[]

  # TODO

  trees
end

function redirect_branches!(diff::Diff, amod::AnnotatedModule, af::AnnotatedFunction, branching_blocks, from::SSAValue, to::SSAValue)
  for block in branching_blocks
    (i, terminst) = termination_instruction(amod, af, block)
    @switch terminst.opcode begin
      @case &OpBranch
      update!(diff, i => @set terminst.arguments[1] = to)

      @case &OpBranchConditional || &OpSwitch
      index = findfirst(==(from), terminst.arguments)
      update!(diff, i => @set terminst.arguments[index] = to)
    end
  end

  diff
end

"""
Return dictionaries of updated and new instructions required to intercept `OpPhi` instructions coming from branching blocks to the provided target into an intercepting block.

New instructions are returned such that the intercepting block can incorporate these new `OpPhi` instructions into its body, at the start
of the block. The keys of the relevant dictionary should be ignored.

As a given `OpPhi` instruction on the target may not be covered fully by the branching blocks (i.e. without further assumptions it may depend on other
branching blocks), they are not deleted. Instead, the `%value => %branching_block` pairs are replaced by `%new_value => %intercepting_block` where
`%new_value` is the SSA value of the result of the relevant `OpPhi` instruction in the intercepting block. Should a given `OpPhi` instruction on the
target be fully covered by the branching blocks, it will be transformed into a single-branch `%result = OpPhi(%new_value => %intercepting_block)`.

Noting that the target block may have several `OpPhi` instructions involving all or part of the branching blocks, the intercepting block will end up
with possibly more than one corresponding `OpPhi` instructions.
"""
function intercept_phi_instructions!(counter::SSACounter, amod::AnnotatedModule, af::AnnotatedFunction, branching_blocks, target::Integer)
  (phi_indices, phi_insts) = phi_instructions(amod, af, target)

  updated_phi_insts = Ditionary{Int,Instruction}()
  new_phi_insts = Dictionary{Int,Instruction}()

  for block in branching_blocks
    _, block_inst = block_instruction(amod, af, block)
    for (i, phi_inst) in zip(phi_indices, phi_insts)
      j = findfirst(==(block_inst.result_id), phi_inst.arguments)
      if !isnothing(j)
        # A phi instruction from the target block used <block>. This will trigger the use of a dummy variable
        # in the factorizing block, along with an update for that phi instruction to use the dummy variable instead.
        new_phi_inst = get!(() -> @inst(next!(counter) = Phi()::phi_inst.result_id), new_phi_insts, i)
        push!(new_phi_insts.arguments, phi_inst.arguments[j + 1], block_inst.result_id)
        updated_phi_inst = get!(updated_phi_insts, i, phi_inst)
        updated_phi_insts[i] = @set updated_phi_inst.arguments[j] = new_phi_inst.var
      end
    end
  end

  updated_phi_insts .= remove_phi_duplicates.(updated_phi_insts)

  updated_phi_insts, new_phi_insts
end

"Remove duplicates of the form `%val1 => %parent1`, `%val1 => %parent1`."
function remove_phi_duplicates(inst::Instruction)
  @assert is_phi_instruction(inst)
  unique_pairs = unique!([value => parent for (value, parent) in Iterators.partition(inst.arguments, 2)])
  @set inst.arguments = collect(Iterators.flatten(unique_pairs))
end

function conflicted_merge_blocks(amod::AnnotatedModule, af::AnnotatedFunction, cfg::ControlFlowGraph)
  merge_blocks = find_merge_blocks(amod, af, cfg)
  filter!(>(1) ∘ length, merge_blocks)
end

"Find blocks that are the target of merge headers, along with the list of nodes that declared it with as a merge header."
function find_merge_blocks(amod::AnnotatedModule, af::AnnotatedFunction, cfg::ControlFlowGraph)
  merge_blocks = Dictionary{Int,Vector{Int}}()
  for (i, block) in enumerate(af.blocks)
    for inst in instructions(amod, block[end-1:end])
      is_merge_instruction(inst) || continue
      merge_block = first(inst.arguments)
      push!(get!(Vector{Int}, merge_blocks, merge_block), i)
      break
    end
  end
  merge_blocks
end

"Get the [`Instruction`](@ref) declaring the block at provided block index in the control-flow graph."
function block_instruction(amod::AnnotatedModule, af::AnnotatedFunction, block_index::Integer)
  i = first(af.blocks[block_index])
  inst = instruction(amod, i)
  @assert is_label_instruction(inst)
  i, inst
end

is_merge_instruction(inst::Instruction) = in(inst.opcode, (OpSelectionMerge, OpLoopMerge))
is_label_instruction(inst::Instruction) = inst.opcode == OpLabel
is_phi_instruction(inst::Instruction) = inst.opcode == OpPhi

function merge_header(amod::AnnotatedModule, af::AnnotatedFunction, block_index::Integer)
  i = af.blocks[block_index][end - 1]
  inst = instruction(amod, i)
  @assert is_merge_instruction(inst)
  i, inst
end

function update_merge_block(inst::Instruction, new_merge_block::SSAValue)
  @assert is_merge_instruction(inst)
  @set inst.arguments[1] = new_merge_block
end
