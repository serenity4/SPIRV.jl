"""
Compact reducible basic blocks.

1 -> 2 -> 3 becomes 1
"""
function compact_reducible_bbs!(g, v)
    outs = outneighbors(g, v)
    if length(outs) == 1
        v′ = first(outs)
        ins = inneighbors(g, v′)
        if length(ins) == 1
            compact_reducible_bbs!(g, v′)
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
        merge_vertices!(g, [v; branch_candidates; merge_v])
        rem_edge!(g, v, v)
    end
end

is_single_entry_single_exit(cfg::CFG) = is_single_entry_single_exit(cfg.graph)

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
    isempty(edges(g)) && nv(g) == 1
end
