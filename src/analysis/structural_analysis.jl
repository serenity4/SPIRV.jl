@enum RegionType begin
  REGION_BLOCK
  REGION_IF_THEN
  REGION_IF_THEN_ELSE
  REGION_CASE
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
    vs = nothing
    # Look ahead for a chain.
    while length(outneighbors(g, v)) == 1
      v = only(outneighbors(g, v))
      length(inneighbors(g, v)) == 1 || break
      isnothing(vs) && (vs = [start])
      in(v, vs) && break
      push!(vs, v)
    end
    # Look behind for a chain.
    v = start
    while length(inneighbors(g, v)) == 1
      v = only(inneighbors(g, v))
      length(outneighbors(g, v)) == 1 || break
      isnothing(vs) && (vs = [start])
      in(v, vs) && break
      pushfirst!(vs, v)
    end
    isnothing(vs) && return
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
      only(outneighbors(g, w)) ≠ candidate && return
    end
    Some(outneighbors(g, v))
  end
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

@active natural_loop(args) begin
  @when (ec, g, v) = args begin
  end
end

@active improper_loop(args) begin
  @when (ec, g, v) = args begin
  end
end

struct ControlNode
  index::Int
  region_type::RegionType
end

const ControlTree = SimpleTree{ControlNode}

# Structures are constructed via pattern matching on the graph.

is_single_entry_single_exit(g::AbstractGraph, v) = length(inneighbors(g, v)) == 1 && length(outneighbors(g, v)) == 1
is_single_entry_single_exit(g::AbstractGraph) = is_weakly_connected(g) && length(sinks(g)) == length(sources(g)) == 1

function ControlTree(cfg::AbstractGraph{T}) where {T}
  is_single_entry_single_exit(cfg) || error("Control trees require single-entry single-exit control-flow graphs.")
  dfst = SpanningTreeDFS(cfg)
  abstract_graph = DeltaGraph(cfg)
  ec = EdgeClassification(cfg, dfst)

  control_trees = Dictionary{Int, ControlTree}(1:nv(cfg), ControlTree.(ControlNode.(1:nv(cfg), REGION_BLOCK)))
  next = post_ordering(dfst)

  #=
  Issues of the moment:
  1. The correspondence with the DFST and the original flow graph is not maintained, such that dominators, edge classifications and post-order iteration seem hard to reuse.
  2. There does not seem to be any clear heuristic regarding which nodes to iterate (maybe solved by the append logic at the end of the loop, TBC)

  For 1., we know already that by constructing structures with a single entry point (even for improper regions) we preserve dominators from that entry point to any other node or structure. Regarding post-order iteration, we can keep the original one and simply ignore vertices that have been merged.

  =#

  while !isempty(next)
    start = popfirst!(next)
    # `v` can change if we follow a chain of blocks in a block region which starts before `v`.
    v = start
    ret = @trymatch (abstract_graph, v) begin
      block_region(vs) && Do(v = first(vs)) => (REGION_BLOCK, @view vs[2:end])
      if_then_region(v, t, m) => (REGION_IF_THEN, [t])
      if_then_else_region(v, t, e, m) => (REGION_IF_THEN_ELSE, [t, e])
      case_region(branches) => (REGION_CASE, branches)
      self_loop() => (REGION_SELF_LOOP, T[])
      while_loop(cond, body, merge) => (REGION_WHILE_LOOP, [body, merge])
      # _ => @trymatch (ec, abstract_graph, v) begin
      #   while_loop(cond, body, merge) => (REGION_WHILE_LOOP, [body, merge])
      #   natural_loop(vs) => (REGION_NATURAL_LOOP, vs)
      #   improper_loop(vs) && Do(v = first(vs)) => (REGION_IMPROPER, @view vs[2:end])
      # end
    end
    if !isnothing(ret)
      (region_type, ws) = ret
      region = SimpleTree(ControlNode(v, region_type))

      # Add the new region and merge region vertices.
      push!(children(region), control_trees[v])
      set!(control_trees, v, region)
      if region_type == REGION_SELF_LOOP
        rem_edge!(abstract_graph, v, v)
      else
        for w in ws
          tree = control_trees[w]
          tree = @set tree.parent = region
          push!(children(region), tree)
          delete!(control_trees, w)
          merge_vertices!(abstract_graph, v, w)
          rem_edge!(abstract_graph, v, v)
        end
        filter!(w -> !in(w, (v, start)) && !in(w, ws) && !in(w, inneighbors(abstract_graph, v)), next)
      end

      # Add vertices which might show new patterns due to the merge of this region.
      append!(next, inneighbors(abstract_graph, v))
      push!(next, v)
    end
  end

  while length(control_trees) > 1
    @warn "Merging control trees under an improper region."
    # There are improper structures or natural loops.
    region = ControlTree(ControlNode(1, REGION_IMPROPER), nothing, collect(values(control_trees)))
    control_trees = dictionary([1 => region])
    merge_vertices!(abstract_graph, vertices(abstract_graph)...)
    set!(control_trees, 1, region)
  end

  @assert nv(abstract_graph) == 1
  only(control_trees)
end
