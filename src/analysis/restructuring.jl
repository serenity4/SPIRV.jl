function add_merge_headers!(diff::Diff, amod::AnnotatedModule)
  for af in amod.annotated_functions
    add_merge_headers!(diff, amod, af)
  end
  diff
end

function add_merge_headers!(diff::Diff, amod::AnnotatedModule, af::AnnotatedFunction)
  cfg = ControlFlowGraph(amod, af)
  ctree_global = ControlTree(cfg)
  back_edges = backedges(cfg)
  traversed = BitVector(undef, nv(cfg))
  for ctree in PreOrderDFS(ctree_global)
    is_block(ctree) && continue
    v = node_index(ctree)
    traversed[v] && continue
    traversed[v] = true

    @switch ctree begin
      @case GuardBy(is_loop)
      local_back_edges = filter!(in(back_edges), [Edge(u, v) for u in inneighbors(cfg, v)])
      if length(local_back_edges) > 1
        throw(CompilationError("There is more than one backedge to a loop."))
      end
      vcont = src(only(local_back_edges))
      vmerge = nothing
      cyclic_nodes = node_index.(Leaves(ctree))
      cfg_edges = collect(edges(cfg))
      vmerge_edge_indices = findall(e -> !in(dst(e), cyclic_nodes) && in(src(e), cyclic_nodes), cfg_edges)
      vmerge_candidates = Set(dst(e) for e in cfg_edges[vmerge_edge_indices])
      @switch length(vmerge_candidates) begin
        @case 0
        throw(CompilationError("No merge candidate found for a loop."))
        @case 1
        vmerge = only(vmerge_candidates)
        @case GuardBy(>(1))
        throw(CompilationError("More than one candidates found for a loop."))
      end
      header = @inst OpLoopMerge(ResultID(amod, af, vmerge), ResultID(amod, af, vcont), LoopControlNone)
      insert!(diff, last(af.blocks[v]), header)

      @case GuardBy(is_selection)
      # We're branching.
      vmerge = postdominator(cfg, v)
      if isnothing(vmerge)
        # All target blocks return or loop back to the current node.

        # If there is a loop back to the current node, the branch
        # statement is a loop break. In this case, no header is required.
        is_breaking_node(ctree, cfg) && continue

        @tryswitch region_type(ctree) begin
          @case &REGION_TERMINATION
          vmerge = node_index(ctree.children[findfirst(≠(v) ∘ node_index, ctree.children)])

          @case &REGION_BLOCK
          c = first(ctree.children)
          if node_index(c) == v && region_type(c) == REGION_TERMINATION
            # We have a branch to one or more termination nodes.
            # Simply get the branch that does not terminate.
            vmerge = node_index(ctree.children[2])
          end
        end

        if isnothing(vmerge)
          # Take any target that is not part of the current structure.
          local_leaf_nodes = node_index.(Leaves(ctree))
          outs = outneighbors(cfg, v)
          vmerge_index = findfirst(!in(local_leaf_nodes), outs)
          !isnothing(vmerge_index) && (vmerge = outs[vmerge_index])
          if isnothing(vmerge)
            # Otherwise, take any target that is a termination node.
            ctree_parent = parent(ctree)
            isnothing(ctree_parent) && (ctree_parent = ctree)

            if region_type(ctree_parent) ≠ REGION_BLOCK
              error("Selection construct expected to have a block parent; control-flow may be unstructured")
            end

            vmerge_index = findfirst(==(v) ∘ node_index, ctree_parent.children)::Int + 1
            vmerge = node_index(ctree_parent.children[vmerge_index])
          end
        end

        @debug "No postdominator available on node $v to get a merge candidate, picking one with custom heuristics: $vmerge"
      end
      header = @inst OpSelectionMerge(ResultID(amod, af, vmerge), SelectionControlNone)
      insert!(diff, last(af.blocks[v]), header)
    end
  end
end

function is_breaking_node(ctree::ControlTree, cfg::AbstractGraph)
  parent_loop = find_parent(is_loop, ctree)
  isnothing(parent_loop) && return false
  loop_nodes = node_index.(Leaves(parent_loop))
  any(!in(loop_nodes), outneighbors(cfg, node_index(ctree)))
end

function restructure_merge_blocks!(diff::Diff, amod::AnnotatedModule)
  for af in amod.annotated_functions
    restructure_merge_blocks!(diff, amod, af)
  end
  diff
end

function restructure_merge_blocks!(diff::Diff, amod::AnnotatedModule, af::AnnotatedFunction)
  cfg = ControlFlowGraph(amod, af)
  ctree_global = ControlTree(cfg)

  for ctree in PreOrderDFS(ctree_global)
    is_selection(ctree) || is_loop(ctree) || continue
    v = node_index(ctree)
    for inner in ctree.children
      node_index(inner) == v && continue
      is_selection(inner) || is_loop(inner) || continue

      # We have a selection or loop construct nested directly inside another selection or loop construct.
      # If we had a properly nested construct, with its merge block strictly contained in the outer construct,
      # then we would have a block region consisting of the inner construct + the inner merge block.
      # To restructure this inner construct, we first identify such structured construct on the outside to know
      # which block we impliticly treated as merge block for our inner construct.
      p = find_parent(is_block, ctree)
      isnothing(p) && error("Expected at least one parent that is a block region.")
      i = findfirst(==(v) ∘ node_index, p.children)::Int
      merge_block = node_index(p[i + 1])
      merge_block_inst_index, merge_block_inst = block_instruction(amod, af, merge_block)

      # We will in general have only one branching block for selection constructs
      # and possibly multiple ones for loops (as break statements are allowed).
      # TODO: Optimize this by using the property above to avoid traversing all leaves.
      branching_blocks = [node_index(tree) for tree in Leaves(inner) if in(merge_block, outneighbors(cfg, node_index(tree)))]

      new = @inst next!(diff) = OpLabel()
      new_instructions = [new]

      # Adjust branching instructions from branching blocks so that they branch to the new node instead.
      redirect_branches!(diff, amod, af, branching_blocks, merge_block_inst.result_id, new.result_id)

      # Intercept OpPhi instructions on the original merge block by the new block.
      updated_phi_insts, new_phi_insts = intercept_phi_instructions!(diff.idcounter, amod, af, branching_blocks, merge_block)
      append!(new_instructions, new_phi_insts)
      update!(diff, pairs(updated_phi_insts))

      push!(new_instructions, @inst OpBranch(merge_block_inst.result_id))
      # Insert just after the merge block.
      insert!(diff, last(af.blocks[merge_block]) + 1, new_instructions)
    end
  end

  diff
end

nesting_levels(ctree::ControlTree) = nesting_levels!(Dictionary{Int,Pair{ControlTree,Int}}(), ctree, 1)

function nesting_levels!(nesting_levels, ctree::ControlTree, level::Integer)
  i = node_index(ctree)
  if !haskey(nesting_levels, i) && (region_type(ctree) ≠ REGION_BLOCK || isempty(children(ctree)))
    insert!(nesting_levels, i, ctree => level)
  end
  next_level = region_type(ctree) == REGION_BLOCK ? level : level + 1
  for tree in children(ctree)
    nesting_levels!(nesting_levels, tree, next_level)
  end
  nesting_levels
end

function redirect_branches!(diff::Diff, amod::AnnotatedModule, af::AnnotatedFunction, branching_blocks, from::ResultID, to::ResultID)
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
`%new_value` is the result ID of the relevant `OpPhi` instruction in the intercepting block. Should a given `OpPhi` instruction on the
target be fully covered by the branching blocks, it will be transformed into a single-branch `%result = OpPhi(%new_value => %intercepting_block)`.

Noting that the target block may have several `OpPhi` instructions involving all or part of the branching blocks, the intercepting block will end up
with possibly more than one corresponding `OpPhi` instructions.
"""
function intercept_phi_instructions!(counter::IDCounter, amod::AnnotatedModule, af::AnnotatedFunction, branching_blocks, target::Integer)
  (phi_indices, phi_insts) = phi_instructions(amod, af, target)

  updated_phi_insts = Dictionary{Int,Instruction}()
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

function conflicted_merge_blocks(amod::AnnotatedModule, af::AnnotatedFunction)
  merge_blocks = find_merge_blocks(amod, af)
  filter!(>(1) ∘ length, merge_blocks)
end

"Find blocks that are the target of merge headers, along with the list of nodes that declared it with as a merge header."
function find_merge_blocks(amod::AnnotatedModule, af::AnnotatedFunction)
  merge_blocks = Dictionary{Int,Vector{Int}}()
  for (i, block) in enumerate(af.blocks)
    for inst in instructions(amod, block[end-1:end])
      is_merge_instruction(inst) || continue
      merge_block = first(inst.arguments)
      push!(get!(Vector{Int}, merge_blocks, UInt32(merge_block)), i)
      break
    end
  end
  merge_blocks
end

function update_merge_block(inst::Instruction, new_merge_block::ResultID)
  @assert is_merge_instruction(inst)
  @set inst.arguments[1] = new_merge_block
end
