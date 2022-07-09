@enum RegionType begin
  REGION_BLOCK
  REGION_IF_THEN
  REGION_IF_THEN_ELSE
  REGION_CASE
  REGION_TERMINATION
  REGION_PROPER
  REGION_SELF_LOOP
  REGION_WHILE_LOOP
  REGION_NATURAL_LOOP
  REGION_IMPROPER
end

"Sequence of blocks `u` ─→ [`v`, `vs...`] ─→ `w`"
REGION_BLOCK
"Conditional with one branch `u` ─→ `v` and one merge block reachable by `u` ─→ `w` or `v` ─→ `w`."
REGION_IF_THEN
"Conditional with two symmetric branches `u` ─→ `v` and `u` ─→ `w` and a single merge block reachable by `v` ─→ x or `w` ─→ x."
REGION_IF_THEN_ELSE
"Conditional with any number of symmetric branches [`u` ─→ `vᵢ`, `u` ─→ `vᵢ₊₁`, ...] and a single merge block reachable by [`vᵢ` ─→ `w`, `vᵢ₊₁` ─→ `w`, ...]."
REGION_CASE
"""
Acyclic region which contains a block `v` with multiple branches, including one or multiple branches to blocks `wᵢ` which end with a function termination instruction.
The region is composed of `v` and all the `wᵢ`.
"""
REGION_TERMINATION
"Acyclic region which does not match any other acyclic patterns."
REGION_PROPER
"Region consisting of only one node which has a self-loop."
REGION_SELF_LOOP
"Simple cycling region made of a condition block `u`, a loop body block `v` and a merge block `w` such that `v` ⇆ `u` ─→ `w`."
REGION_WHILE_LOOP
"Single-entry cyclic region with varying complexity such that the entry point dominates all nodes in the cyclic structure."
REGION_NATURAL_LOOP
"Single-entry cyclic region with varying complexity where the entry point does not dominate all nodes in the cyclic structure."
REGION_IMPROPER

# Define active patterns for use in pattern matching with MLStyle.

@active block_region(args) begin
  @when (g, v) = args begin
    start = v
    # Look ahead for a chain.
    vs = [start]
    while length(outneighbors(g, v)) == 1
      v = only(outneighbors(g, v))
      length(inneighbors(g, v)) == 1 || break
      in(v, vs) && break
      push!(vs, v)
    end
    # Look behind for a chain.
    v = start
    while length(inneighbors(g, v)) == 1
      v = only(inneighbors(g, v))
      length(outneighbors(g, v)) == 1 || break
      in(v, vs) && break
      pushfirst!(vs, v)
    end
    length(vs) == 1 && return
    Some(vs)
  end
end

@active self_loop(args) begin
  @when (g, v) = args begin
    in(v, outneighbors(g, v))
  end
end

@active if_then_region(args) begin
  @when (g, v) = args begin
    if length(outneighbors(g, v)) == 2
      b, c = outneighbors(g, v)
      if is_single_entry_single_exit(g, b)
        only(outneighbors(g, b)) == c && return (v, b, c)
      elseif is_single_entry_single_exit(g, c)
        only(outneighbors(g, c)) == b && return (v, b, c)
      end
    end
  end
end

@active if_then_else_region(args) begin
  @when (g, v) = args begin
    if length(outneighbors(g, v)) == 2
      b, c = outneighbors(g, v)
      if is_single_entry_single_exit(g, b) && is_single_entry_single_exit(g, c)
        d = only(outneighbors(g, b))
        d == v && return
        d == only(outneighbors(g, c)) && return (v, b, c, d)
      end
    end
  end
end

@active case_region(args) begin
  @when (g, v) = args begin
    candidate = nothing
    isempty(outneighbors(g, v)) && return
    for w in outneighbors(g, v)
      !is_single_entry_single_exit(g, w) && return
      isnothing(candidate) && (candidate = only(outneighbors(g, w)))
      candidate == v && return
      only(outneighbors(g, w)) ≠ candidate && return
    end
    (outneighbors(g, v), candidate)
  end
end

@active termination_region(args) begin
  @when (g, v) = args begin
    length(outneighbors(g, v)) ≥ 2 || return
    termination_blocks = filter(isempty ∘ Fix1(outneighbors, g), outneighbors(g, v))
    isempty(termination_blocks) && return
    Some(termination_blocks)
  end
end

function acyclic_region(g, v, ec, doms, domtrees, backedges)
  ret = @trymatch (g, v) begin
    block_region(vs) => (REGION_BLOCK, vs)
    if_then_region(v, t, m) => (REGION_IF_THEN, [v, t])
    if_then_else_region(v, t, e, m) => (REGION_IF_THEN_ELSE, [v, t, e])
    case_region(branches, target) => (REGION_CASE, [v; branches; target])
    termination_region(termination_blocks) => (REGION_TERMINATION, [v; termination_blocks])
  end
  !isnothing(ret) && return ret
  # Possibly a proper region
  # Test that we don't have a loop or improper region.
  any(u -> in(Edge(u, v), backedges), inneighbors(g, v)) && return
  domtree = domtrees[v]
  pdom_indices = findall(children(domtree)) do tree
    w = nodevalue(tree)
    in(w, vertices(g)) && !in(w, outneighbors(g, nodevalue(domtree)))
  end
  length(pdom_indices) == 1 || return
  pdom = domtree[only(pdom_indices)]
  vs = vertices_between(v, nodevalue(pdom))
  delete!(vs, v)
  delete!(vs, nodevalue(pdom))
  (REGION_PROPER, vs)
end

@active while_loop(args) begin
  @when (g, v) = args begin
    length(inneighbors(g, v)) ≠ 2 && return
    length(outneighbors(g, v)) ≠ 2 && return
    a, b = outneighbors(g, v)
    perm = if is_single_entry_single_exit(g, a) && only(inneighbors(g, a)) == only(outneighbors(g, a)) == v
      false
    elseif is_single_entry_single_exit(g, b) && only(inneighbors(g, b)) == only(outneighbors(g, b)) == v
      true
    end
    isnothing(perm) && return
    # The returned result is of the form (loop condition, loop body, loop merge)
    perm ? (v, b, a) : (v, a, b)
  end
end

function cyclic_region(g, v, ec, doms, domtrees, backedges, scc)
  length(scc) == 1 && return

  # Natural loop.
  if any(u -> in(Edge(u, v), backedges), inneighbors(g, v))
    entry_edges = filter(e -> in(dst(e), scc) && ≠(dst(e), v), edges(g))
    isempty(entry_edges) && return (REGION_NATURAL_LOOP, scc)
  end

  # Improper region.
  entry_edges = filter(e -> in(dst(e), scc) && !in(src(e), scc), edges(g))
  isempty(entry_edges) && return
  entry_points = unique!(src.(entry_edges))
  entry = common_ancestor(domtrees[v], [domtrees[ep] for ep in entry_points])
  @assert !isnothing(entry) "Multiple-entry cyclic region encountered with no single dominator"
  entry_node = node(entry)
  vs = [entry_node]
  exclude_vertices = [entry_node]
  mec_entries = unique!(dst.(entry_edges))
  for v in vertices(g)
    v == entry_node && continue
    !has_path(g, entry_node, v) && continue
    any(has_path(g, v, ep; exclude_vertices) for ep in mec_entries) && push!(vs, v)
  end
  (REGION_IMPROPER, vs)
end

struct ControlNode
  index::Int
  region_type::RegionType
end

"""
Control tree.

The leaves are labeled as [`REGION_BLOCK`](@ref) regions, with the distinguishing property that they no children.

Children nodes of any given subtree are in reverse postorder according to the
original control-flow graph.
"""
const ControlTree = SimpleTree{ControlNode}

# Structures are constructed via pattern matching on the graph.

is_single_entry_single_exit(g::AbstractGraph, v) = length(inneighbors(g, v)) == 1 && length(outneighbors(g, v)) == 1
is_single_entry_single_exit(g::AbstractGraph) = is_weakly_connected(g) && length(sinks(g)) == length(sources(g)) == 1

function ControlTree(cfg::AbstractGraph{T}) where {T}
  dfst = SpanningTreeDFS(cfg)
  abstract_graph = DeltaGraph(cfg)
  ec = EdgeClassification(cfg, dfst)
  doms = dominators(cfg)
  bedges = backedges(cfg, ec, doms)
  domtree = DominatorTree(doms)
  domtrees = sort(collect(PostOrderDFS(domtree)); by = x -> node(x))
  sccs = strongly_connected_components(cfg)

  control_trees = Dictionary{T, ControlTree}(1:nv(cfg), ControlTree.(ControlNode.(1:nv(cfg), REGION_BLOCK)))
  next = post_ordering(dfst)

  while !isempty(next)
    start = popfirst!(next)
    haskey(control_trees, start) || continue
    # `v` can change if we follow a chain of blocks in a block region which starts before `v`, or if we need to find a dominator to an improper region.
    v = start
    ret = acyclic_region(abstract_graph, v, ec, doms, domtrees, bedges)
    ret = if !isnothing(ret)
      (region_type, (v, ws...)) = ret
      (region_type, ws)
    else
      @trymatch (abstract_graph, v) begin
        self_loop() => (REGION_SELF_LOOP, T[])
        while_loop(cond, body, merge) => (REGION_WHILE_LOOP, [body, merge])
        _ => begin
          scc = sccs[findfirst(Fix1(in, v), sccs)]
          filter!(in(vertices(abstract_graph)), scc)
          ret = cyclic_region(abstract_graph, v, ec, doms, domtrees, bedges, scc)
          if !isnothing(ret)
            (region_type, vs) = ret
            if region_type == REGION_IMPROPER
              v, vs... = vs
            end
            (region_type, vs)
          end
        end
      end
    end
    isnothing(ret) && continue

    # `ws` must be in reverse post-order.
    (region_type, ws) = ret
    region = SimpleTree(ControlNode(v, region_type))

    # Add the new region and merge region vertices.
    push!(children(region), control_trees[v])
    control_trees[v] = region
    if region_type ≠ REGION_SELF_LOOP
      for w in ws
        tree = control_trees[w]
        tree = @set tree.parent = region
        push!(children(region), tree)
        delete!(control_trees, w)

        # Adjust back-edges.
        for w′ in outneighbors(abstract_graph, w)
          e = Edge(w, w′)
          if in(e, bedges)
            delete!(bedges, e)
            push!(bedges, Edge(v, dst(e)))
          end
        end

        merge_vertices!(abstract_graph, v, w)
        rem_edge!(abstract_graph, v, v)
      end
    else
      rem_edge!(abstract_graph, v, v)
    end

    # Process transformed node next for eventual successive transformations.
    pushfirst!(next, v)
  end

  @assert nv(abstract_graph) == 1
  only(control_trees)
end
