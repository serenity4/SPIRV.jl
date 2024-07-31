struct AddMergeHeaders <: FunctionPass end

add_merge_headers!(ir::IR) = AddMergeHeaders()(ir)

function (::AddMergeHeaders)(fdef::FunctionDefinition)
  cfg = ControlFlowGraph(fdef)
  ctree_global = ControlTree(cfg)
  back_edges = backedges(cfg)
  traversed = falses(nv(cfg))
  merge_blocks = Set{ResultID}()
  continue_targets = Set{ResultID}()
  node_to_id(node) = fdef[node].id
  for ctree in PreOrderDFS(ctree_global)
    is_block(ctree) && continue
    v = node_index(ctree)
    traversed[v] && continue
    traversed[v] = true
    blk = fdef[v]

    @switch ctree begin
      @case GuardBy(is_loop)
      has_merge_header(blk) && continue
      local_back_edges = filter!(in(back_edges), [Edge(u, v) for u in inneighbors(cfg, v)])
      length(local_back_edges) > 1 && throw_compilation_error("there is more than one backedge to a loop")
      ncont = node_to_id(src(only(local_back_edges)))

      nmerge = node_to_id(merge_candidate(ctree, cfg))
      header = @ex OpLoopMerge(nmerge, ncont, LoopControlNone)
      push!(merge_blocks, nmerge)
      push!(continue_targets, ncont)
      insert!(blk, lastindex(blk), header)

      @case GuardBy(is_selection)
      has_merge_header(blk) && continue
      bs = node_to_id.(node_index.(@view ctree.children[2:end]))
      if all(!in(b, merge_blocks) && !in(b, continue_targets) for b in bs)
        vmerge = merge_candidate(ctree, cfg)
        header = @ex OpSelectionMerge(fdef[vmerge].id, SelectionControlNone)
        insert!(blk, lastindex(blk), header)
      end
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
    return merge_candidate(p, cfg)
  end
  node_index(p[i + 1])
end

function merge_candidate_loop(ctree::ControlTree, cfg::AbstractGraph)
  is_loop(ctree) || error("Cannot determine merge candidates for a node that is not a loop.")
  node = node_index(ctree)
  # TODO: Leverage the control tree when we figure out how to deal with embedded termination regions (which are not part of the SCC).
  # scc = node_index.(Leaves(ctree))
  scc = minimal_cyclic_component(cfg, node, backedges(cfg))
  set = Set(scc)
  for v in scc
    for w in outneighbors(cfg, v)
      !in(w, set) && return w
    end
  end
  i = findfirst(!in(scc), outneighbors(cfg, node))
  isnothing(i) && error("Infinite loop detected; no merge candidate could be found.")
  outneighbors(cfg, node)[i]
end

struct RestructureProperRegions <: FunctionPass end
RestructureProperRegions() = RestructureProperRegions()

restructure_proper_regions!(ir::IR) = RestructureProperRegions()(ir)

function (pass!::RestructureProperRegions)(ir::IR, fdef::FunctionDefinition)
  (; idcounter) = ir
  cfg = ControlFlowGraph(fdef)
  ctree_global = ControlTree(cfg)
  T = eltype(cfg)
  for ctree in PostOrderDFS(ctree_global)
    is_proper_region(ctree) || continue
    U32 = IntegerType(32, false)
    v = node_index(ctree)
    region = node_index.(Leaves(ctree))
    continuation_edges = Edge{T}[]
    domsets = dominators(cfg, region, v)
    domtree = DominatorTree(domsets)
    for w in outneighbors(cfg, v)
      edge = Edge(v, w)
      if length(inneighbors(cfg, w)) > 1 && count(u -> !in(Edge(u, w), cfg.ec.retreating_edges), inneighbors(cfg, w)) > 1
        # The branch edge doesn't dominate anything.
        push!(continuation_edges, edge)
        continue
      end
      immediate_pdoms = children(domtree)
      index = findfirst(x -> node_index(x) == w, immediate_pdoms)
      domsubtree = immediate_pdoms[index]
      subgraph = node_index.(PreOrderDFS(domsubtree))
      for w′ in subgraph
        for c in outneighbors(cfg, w′)
          in(c, subgraph) && continue
          in(c, region) || continue
          continuation_edge = Edge(w′, c)
          push!(continuation_edges, continuation_edge)
        end
      end
    end
    tail = unique!(dst.(continuation_edges))
    @assert length(tail) > 1 "A proper region has a tail consisting of only one node; this region appears to be already structured"

    new = new_block!(fdef, next!(idcounter))
    us = unique!(src.(continuation_edges))
    from = [fdef[u] for u in us]
    to = [fdef[w] for w in tail]

    redirect_branches!(from, to, new)
    intercept_phi_instructions!!(idcounter, from, new, to)
    fill_phi_branches!(new, ir, fdef, us)

    # Setup `Switch` target.
    branch = @ex Switch()
    selection = @ex next!(idcounter) = Phi()::U32
    push!(branch, selection.result)
    default = to[1].id
    push!(branch, default)
    for (w, blk) in zip(tail, to)
      push!(branch, (w)U, blk.id)
    end

    # Generate Phi selector arguments.
    for (u, blk) in zip(us, from)
      ws = outneighbors(cfg, u)
      selection_value = nothing
      if length(ws) == 1
        a = ws[1]
        selection_value = emit_constant!(ir, Constant((a)U))
      elseif length(ws) == 2
        a, b = ws
        if in(a, tail) && in(b, tail)
          select_ex = @ex next!(idcounter) = OpSelect(emit_constant!.(ir, Constant.(((a)U, (b)U)))...)::U32
          blk[end] = select_ex
          selection_value = select_ex.result
          push!(blk, @ex Branch(new.id))
        elseif in(a, tail) || in(b, tail)
          c = ifelse(in(a, tail), a, b)
          selection_value = emit_constant!(ir, Constant((c)U))
        else
          error("A node that is part of a continuation edge actually has no edge to a continuation vertex.")
        end
      else
        error("Switch constructs not yet supported for proper region restructuring.")
      end
      push!(selection, selection_value::ResultID, blk.id)
    end

    push!(new, selection)
    push!(new, branch)

    # Continue until no proper regions are left.
    return pass!(ir, fdef)
  end
end

struct RestructureMergeBlocks <: FunctionPass
  restructured::Set{Int}
  idcounter::IDCounter
end
RestructureMergeBlocks(ir::IR) = RestructureMergeBlocks(Set{Int}(), ir.idcounter)
new_function!(pass!::RestructureMergeBlocks, fdef::FunctionDefinition) = empty!(pass!.restructured)

restructure_merge_blocks!(ir::IR) = RestructureMergeBlocks(ir)(ir)

function (pass!::RestructureMergeBlocks)(fdef::FunctionDefinition)
  cfg = ControlFlowGraph(fdef)
  ctree_global = ControlTree(cfg)
  back_edges = backedges(cfg)
  # Control-flow structures become outdated as the function is modified.
  # Instead of reconstructing the CFG and control trees after every modification
  # (which is done here by re-applying the pass), we only do it when it is really needed.
  # Currently, we re-apply the pass when an outer construct had one of its inner constructs
  # restructured and then becomes an inner construct itself.
  reapply_on = Set{Int}()

  for ctree in PostOrderDFS(ctree_global)
    in(node_index(ctree), pass!.restructured) && continue
    is_selection(ctree) || is_loop(ctree) || continue
    outer_construct = find_parent(p -> is_selection(p) || is_loop(p), ctree)
    isnothing(outer_construct) && continue
    merge_inner, merge_outer = merge_candidate.((ctree, outer_construct), cfg)
    if merge_inner ≠ merge_outer
      is_loop(outer_construct) || continue
      # If `merge_inner` is the continue target of the outer loop,
      # we also need to introduce a new block right before that continue block.
      o = node_index(outer_construct)
      local_back_edges = filter!(in(back_edges), [Edge(u, o) for u in inneighbors(cfg, o)])
      length(local_back_edges) > 1 && throw_compilation_error("there is more than one backedge to a loop")
      continue_target = src(only(local_back_edges))
      merge_inner ≠ continue_target && continue
    end
    in(node_index(ctree), reapply_on) && return pass!(fdef)
    merge_blk = fdef[merge_inner]

    # We will in general have only one branching block for selection constructs
    # and possibly multiple ones for loops (as break statements are allowed).
    # TODO: Optimize this by using the property above to avoid traversing all leaves.
    # We don't use `inneighbors` here because the CFG may have changed. Using control tree leaves
    # is more robust and will prevent us from having to rebuild the CFG in that case.
    branching_blks = branching_blocks(fdef, ctree) do tree
      v = node_index(tree)
      in(merge_inner, outneighbors(cfg, v))
    end
    new = new_block!(fdef, next!(pass!.idcounter))

    redirect_branches!(branching_blks, merge_blk, new)

    # Intercept OpPhi instructions in the original merge block by the new block.
    intercept_phi_instructions!!(pass!.idcounter, branching_blks, new, merge_blk)

    push!(new, @ex OpBranch(merge_blk.id))
    push!(pass!.restructured, node_index(ctree))
    push!(reapply_on, node_index(outer_construct))
  end
end

function branching_blocks(condition::Function, fdef::FunctionDefinition, ctree::ControlTree)
  blks = Block[]
  for tree in Leaves(ctree)
    if condition(tree)
      v = node_index(tree)
      blk = fdef[v]
      push!(blks, blk)
    end
  end
  blks
end

branching_blocks(fdef::FunctionDefinition, ctree::ControlTree) = branching_blocks(Returns(true), fdef, ctree)

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

function redirect_branches!(from::AbstractVector{Block}, to::Block, new::Block)
  for blk in from
    redirect_branches!(blk, to, new)
  end
end

function redirect_branches!(from::AbstractVector{Block}, to::AbstractVector{Block}, new::Block)
  for blk in to
    redirect_branches!(from, blk, new)
  end
end

"Modify the branching instruction of `from` such that any branches to `to` are remapped to target `new` instead."
function redirect_branches!(from::Block, to::Block, new::Block)
  ex = termination_expression(from)
  @tryswitch ex.op begin
    @case &OpBranch
    ex[1] == to.id || return
    ex[1] = new.id

    @case &OpBranchConditional
    index = findfirst(==(to.id), ex)
    !isnothing(index) || return
    ex[index] = new.id

    @case &OpSwitch
    indices = findall(==(to.id), ex)
    !isempty(indices) || return
    ex[indices] .= new.id
  end
end

function intercept_phi_instructions!!(idcounter::IDCounter, from::AbstractVector{Block}, intercepter::Block, to::AbstractVector{Block})
  exs = foldl((x, block) -> append!(x, phi_expressions(block)), to; init = Expression[])
  intercepts = IdDict{Expression,Expression}()

  for blk in from
    intercept_phi_instructions!!(idcounter, blk, intercepter, exs, intercepts)
  end

  foreach(remove_phi_duplicates!, exs)
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
function intercept_phi_instructions!!(idcounter::IDCounter, from::AbstractVector{Block}, intercepter::Block, to::Block, intercepts = nothing)
  remove_duplicates = isnothing(intercepts)
  intercepts = @something(intercepts, IdDict{Expression,Expression}())
  exs = phi_expressions(to)

  for blk in from
    intercept_phi_instructions!!(idcounter, blk, intercepter, exs, intercepts)
  end

  remove_duplicates && foreach(remove_phi_duplicates!, exs)
end

function intercept_phi_instructions!!(idcounter::IDCounter, from::Block, intercepter::Block, exs, intercepts = nothing)
  remove_duplicates = isnothing(intercepts)
  # Mapping from original Phi instructions to Phi instructions in the intercepter.
  intercepts = @something(intercepts, IdDict{Expression,Expression}())
  for ex in exs
    i = findfirst(==(from.id), ex)
    if !isnothing(i)
      # A phi instruction from the target block used <block>. This will trigger the use of a dummy variable
      # in the intercepting block, along with an update for that phi instruction to use the dummy variable instead.
      new_ex = get!(intercepts, ex) do
        intercept = @ex next!(idcounter) = Phi()::ex.type
        push!(intercepter, intercept)
        intercept
      end
      push!(new_ex, ex[i - 1], from.id)
      ex[i] = intercepter.id
      ex[i - 1] = new_ex.result::ResultID
    end
  end
  remove_duplicates && foreach(remove_phi_duplicates!, exs)
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

"Find blocks that are the target of merge headers, along with the list of nodes that declared it as a merge header."
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

"""
Apply the following SPIR-V rule to loop headers:
> An OpSelectionMerge instruction is required to precede an OpBranchConditional instruction that has different True Label and False Label operands where neither are declared merge blocks or Continue Targets.

This is done by turning a conditional branch in a loop header that does not target either the continue target or merge block into a simple branch to a new block which will make the original branching. Using a new block ensures that there is the possibility of adding an OpSelectionMerge header as the loop header already has an OpLoopMerge.
"""
struct RestructureLoopHeaderConditionals <: FunctionPass
  idcounter::IDCounter
end
RestructureLoopHeaderConditionals(ir::IR) = RestructureLoopHeaderConditionals(ir.idcounter)

restructure_loop_header_conditionals!(ir::IR) = RestructureLoopHeaderConditionals(ir)(ir)

function (pass!::RestructureLoopHeaderConditionals)(fdef::FunctionDefinition)
  cfg = ControlFlowGraph(fdef)
  ctree_global = ControlTree(cfg)

  for ctree in PostOrderDFS(ctree_global)
    is_loop(ctree) || continue
    header = ctree[1]
    is_selection(header) || continue
    v = node_index(header)
    blk = fdef[v]
    merge_header_inst = merge_header(blk)
    @assert opcode(merge_header_inst) === OpLoopMerge "Expected OpLoopMerge, got $(opcode(merge_header_inst))"
    merge = merge_header_inst[1]::ResultID
    cont = merge_header_inst[2]::ResultID
    any(in(fdef.block_ids[w], (merge, cont)) for w in outneighbors(cfg, v)) && continue
    new = new_block!(fdef, next!(pass!.idcounter))
    remap_phi_sources!(Block[fdef[w] for w in outneighbors(cfg, v)], blk => new)
    vmerge = merge_candidate(header, cfg)::Int
    merge_blk = fdef[vmerge]

    if merge_blk.id == cont
      # A continue target cannot be a merge point for a selection construct.
      branching_blks = Block[fdef[u] for u in inneighbors(cfg, vmerge)]
      new2 = new_block!(fdef, next!(pass!.idcounter))

      redirect_branches!(branching_blks, merge_blk, new2)

      # Intercept OpPhi instructions in the original merge block by the new block.
      intercept_phi_instructions!!(pass!.idcounter, branching_blks, new2, merge_blk)

      branch!(new2, merge_blk)
      push!(new, @ex OpSelectionMerge(new2.id, SelectionControlNone))
    else
      push!(new, @ex OpSelectionMerge(merge_blk.id, SelectionControlNone))
    end

    push!(new, blk[end])
    blk[end] = @ex OpBranch(new.id)
  end
end

function remap_phi_sources!(blks::AbstractVector{Block}, (from, to)::Pair{ResultID, ResultID})
  for blk in blks
    for ex in phi_expressions(blk)
      i = findfirst(==(from), ex)
      !isnothing(i) && (ex[i] = to)
    end
  end
end

remap_phi_sources!(blks::AbstractVector{Block}, (from, to)::Pair{Block, Block}) = remap_phi_sources!(blks, from.id => to.id)
