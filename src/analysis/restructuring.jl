function add_merge_headers!(ir::IR)
  for fdef in ir.fdefs
    add_merge_headers!(fdef)
  end
  ir
end

function add_merge_headers!(fdef::FunctionDefinition)
  cfg = ControlFlowGraph(fdef)
  ctree_global = ControlTree(cfg)
  back_edges = backedges(cfg)
  traversed = BitVector(undef, nv(cfg))
  for ctree in PreOrderDFS(ctree_global)
    is_block(ctree) && continue
    v = node_index(ctree)
    traversed[v] && continue
    traversed[v] = true
    blk = fdef[v]

    @switch ctree begin
      @case GuardBy(is_loop)
      local_back_edges = filter!(in(back_edges), [Edge(u, v) for u in inneighbors(cfg, v)])
      length(local_back_edges) > 1 && throw_compilation_error("there is more than one backedge to a loop")
      vcont = src(only(local_back_edges))

      vmerge = merge_candidate(ctree, cfg)
      header = @ex OpLoopMerge(fdef[vmerge].id, fdef[vcont].id, LoopControlNone)
      insert!(blk, lastindex(blk), header)

      @case GuardBy(is_selection)
      vmerge = merge_candidate(ctree, cfg)
      header = @ex OpSelectionMerge(fdef[vmerge].id, SelectionControlNone)
      insert!(blk, lastindex(blk), header)
    end
  end
end

function is_breaking_node(ctree::ControlTree, cfg::AbstractGraph)
  parent_loop = find_parent(is_loop, ctree)
  isnothing(parent_loop) && return false
  loop_nodes = node_index.(Leaves(parent_loop))
  any(!in(loop_nodes), outneighbors(cfg, node_index(ctree)))
end

function is_last_in_block(p::ControlTree, ctree::ControlTree)
  while !isempty(p.children) && is_block(p)
    ctree === last(p) && return true
    p = last(p)
  end
  false
end

function merge_candidate(ctree::ControlTree, cfg::AbstractGraph)
  is_loop(ctree) && return merge_candidate_loop(ctree, cfg)
  is_selection(ctree) && return merge_candidate_selection(ctree, cfg)
  error("A loop or selection node is expected.")
end

function merge_candidate_selection(ctree::ControlTree, cfg::AbstractGraph)
  is_selection(ctree) || error("Cannot determine merge candidate for a node that is not a selection construct.")
  p = find_parent(p -> is_selection(p) || is_loop(p) || is_block(p) && !is_last_in_block(p, ctree), ctree)
  # If the selection is a top-level construct, we can choose an arbitrary children, but we still need to provide a merge header.
  isnothing(p) && return node_index(last(ctree))
  is_selection(p) && return merge_candidate(p, cfg)
  i = findfirst(c -> !isnothing(find_subtree(==(node_index(ctree)) ∘ node_index, c)), p.children)
  if i == lastindex(p.children)
    is_loop(p) || error("A selection construct must not be the last block unless its parent is a loop.")
    is_breaking_node(ctree, cfg) && return nothing
    candidates = merge_candidates(p, cfg)
    length(candidates) == 1 || error("Expected exactly one merge candidate for the parent loop, got ", length(candidates))
    return candidates[1]
  end
  node_index(p[i + 1])
end

function merge_candidate_loop(ctree::ControlTree, cfg::AbstractGraph)
  is_loop(ctree) || error("Cannot determine merge candidates for a node that is not a loop.")
  scc = node_index.(Leaves(ctree))
  set = Set(scc)
  for v in scc
    for w in outneighbors(cfg, v)
      !in(w, set) && return w
    end
  end
end

function restructure_merge_blocks!(ir::IR)
  for fdef in ir.fdefs
    restructure_merge_blocks!(fdef, ir.idcounter)
  end
  ir
end

function restructure_merge_blocks!(fdef::FunctionDefinition, idcounter::IDCounter)
  cfg = ControlFlowGraph(fdef)
  ctree_global = ControlTree(cfg)

  for ctree in PostOrderDFS(ctree_global)
    is_selection(ctree) || is_loop(ctree) || continue
    outer_construct = find_parent(p -> is_selection(p) || is_loop(p), ctree)
    isnothing(outer_construct) && continue
    merge_inner, merge_outer = merge_candidate.((ctree, outer_construct), cfg)
    merge_inner ≠ merge_outer && continue
    merge_blk = fdef[merge_inner]

    # We will in general have only one branching block for selection constructs
    # and possibly multiple ones for loops (as break statements are allowed).
    # TODO: Optimize this by using the property above to avoid traversing all leaves.
    branching_blks = Block[fdef[node_index(tree)] for tree in Leaves(ctree) if in(merge_inner, outneighbors(cfg, node_index(tree)))]
    new = new_block!(fdef, next!(idcounter))

    # Adjust branching instructions from branching blocks so that they branch to the new node instead.
    redirect_branches!(branching_blks, merge_blk.id, new.id)

    # Intercept OpPhi instructions in the original merge block by the new block.
    intercept_phi_instructions!!(idcounter, branching_blks, new, merge_blk)

    push!(new, @ex OpBranch(merge_blk.id))
  end
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

function redirect_branches!(branching_blks::AbstractVector{Block}, dst::ResultID, new::ResultID)
  for blk in branching_blks
    ex = termination_instruction(blk)
    @switch ex.op begin
      @case &OpBranch
      ex[1] = new

      @case &OpBranchConditional
      index = findfirst(==(dst), ex)
      ex[index] = new

      @case &OpSwitch
      indices = findall(==(dst), ex)
      ex[indices] .= new
    end
  end

  diff
end

"""
Intercept `OpPhi` instructions coming from branching blocks to the provided target and put them in an intercepting block.

As a given `OpPhi` instruction on the target may not be covered fully by the branching blocks (i.e. without further assumptions it may depend on other
branching blocks), they are not deleted. Instead, the `%value => %branching_block` pairs are replaced by `%new_value => %intercepting_block` where
`%new_value` is the result ID of the relevant `OpPhi` instruction in the intercepting block. Should a given `OpPhi` instruction on the
target be fully covered by the branching blocks, it will be transformed into a single-branch `%result = OpPhi(%new_value => %intercepting_block)`.

Noting that the target block may have several `OpPhi` instructions involving all or part of the branching blocks, the intercepting block will end up
with possibly more than one corresponding `OpPhi` instructions.
"""
function intercept_phi_instructions!!(idcounter::IDCounter, from::AbstractVector{Block}, intercepter::Block, target::Block)
  exs = phi_expressions(target)

  # Mapping from original Phi instructions to Phi instructions in the intercepter.
  intercepts = IdDict{Expression,Expression}()

  for blk in from
    for ex in exs
      i = findfirst(==(blk.id), ex)
      if !isnothing(i)
        # A phi instruction from the target block used <block>. This will trigger the use of a dummy variable
        # in the intercepting block, along with an update for that phi instruction to use the dummy variable instead.
        new_ex = get!(intercepts, ex) do
          intercept = @ex next!(idcounter) = Phi()::ex.type
          push!(intercepter, intercept)
          intercept
        end
        push!(new_ex, ex[i - 1], blk.id)
        ex[i] = intercepter.id
        ex[i - 1] = new_ex.result::ResultID
      end
    end
  end

  for ex in exs
    remove_phi_duplicates!(ex)
  end
end

"Remove duplicates of the form `%val1 => %parent1`, `%val1 => %parent1`."
function remove_phi_duplicates!(ex::Expression)
  @assert is_phi_instruction(ex)
  pairs = Set{Pair{ResultID, ResultID}}()
  for (i, (value, parent)) in enumerate(Iterators.partition(ex, 2))
    if in(value => parent, pairs)
      ex[2i - 1] = nothing
      ex[2i] = nothing
    else
      push!(pairs, value => parent)
    end
  end
  filter!(!isnothing, ex.args)
end

conflicted_merge_blocks(fdef::FunctionDefinition) = filter!(>(1) ∘ length, merge_blocks(fdef))

"Find blocks that are the target of merge headers, along with the list of nodes that declared it with as a merge header."
function merge_blocks(fdef::FunctionDefinition)
  merge_blks = Dictionary{ResultID,Vector{ResultID}}()
  for blk in fdef
    for ex in @view blk[end-1:end]
      is_merge_instruction(ex) || continue
      merge_blk = fdef[ex[1]::ResultID]
      push!(get!(Vector{ResultID}, merge_blks, merge_blk.id), blk.id)
      break
    end
  end
  merge_blks
end
