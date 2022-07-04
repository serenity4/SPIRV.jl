"""
Compact reducible basic blocks.

1 -> 2 -> 3 becomes 1
"""
function compact_reducible_bbs!(g, v)
  outs = outneighbors(g, v)
  if length(outs) == 1
    v′ = only(outs)
    v′ ≠ v || return
    ins = inneighbors(g, v′)
    if length(ins) == 1
      rem_edge!(g, v, v′)
      merge_vertices!(g, v, v′)
    end
  end
end

"Remove head-controlled recursion."
function rem_head_recursion!(g, v)
  outs = outneighbors(g, v)
  if v in outs && length(outs) == 2
    rem_edge!(g, v, v)
  end
end

"Merge mutually recursive blocks into caller."
function merge_mutually_recursive!(g, v)
  for v′ in outneighbors(g, v)
    v ≠ v′ || continue
    if outneighbors(g, v′) == [v]
      rem_vertex!(g, v′)
    end
  end
end

function compact_structured_branches!(g, v)
  out = outneighbors(g, v)
  merge_v = nothing
  branch_candidates = Int[]
  for v′ in out
    if length(outneighbors(g, v′)) == length(inneighbors(g, v′)) == 1
      push!(branch_candidates, v′)
    else
      isnothing(merge_v) || return
      merge_v = v′
    end
  end
  if isnothing(merge_v) && !isempty(branch_candidates)
    intermediate = first(branch_candidates)
    merge_v = first(outneighbors(g, intermediate))
  end
  !isnothing(merge_v) || return
  merge_incoming = Set(inneighbors(g, merge_v))
  if merge_incoming == Set([branch_candidates; v]) || merge_incoming == Set(branch_candidates)
    merge_vertices!(g, unique!([v; branch_candidates; merge_v]))
    rem_edge!(g, v, v)
  end
end

is_single_entry_single_exit(target::SPIRVTarget) = is_single_entry_single_exit(target.cfg)

function is_single_entry_single_exit(g)
  g = deepcopy(g)
  old_g = nothing
  while isnothing(old_g) || g ≠ old_g
    old_g = deepcopy(g)
    for v in vertices(g)
      compact_reducible_bbs!(g, v)
      compact_structured_branches!(g, v)
      rem_head_recursion!(g, v)
      merge_mutually_recursive!(g, v)
    end
  end
  is_single_node(g)
end

is_tail_structured(target::SPIRVTarget) = is_tail_structured(target.cfg)

function is_tail_structured(g)
  # same as `is_single_entry_single_exit`, without
  # the fourth step `merge_mutually_recursive`.
  g = deepcopy(g)
  old_g = nothing
  while isnothing(old_g) || g ≠ old_g
    old_g = deepcopy(g)
    for v in vertices(g)
      compact_reducible_bbs!(g, v)
      compact_structured_branches!(g, v)
      rem_head_recursion!(g, v)
    end
  end
  is_single_node(g)
end
