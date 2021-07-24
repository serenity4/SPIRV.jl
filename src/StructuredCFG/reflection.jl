"""
Return an operation that compacts reducible basic blocks.

1 -> 2 -> 3 => 1
"""
function compact_reducible_bb(g, origin)
    outs = outneighbors(g, n)
    if length(outs) == 1
        n′ = first(outs)
        ins = inneighbors(g, n′)
        if length(ins) == 1
            compact_reducible_bb!(g, n′)
            rem_edge!(g, n, n′)
            merge_vertices!(g, n, n′)
            return true
        end
    end
    false
end

function is_single_entry_single_exit(cfg::CFG)
    g = deepcopy(cfg.graph)
    haschanged = true
    while haschanged
        haschanged = false
        for n in vertices(g)
            outs = outneighbors(g, n)
            # case 1: reduce CFG
            if length(outs) == 1
                n′ = first(outs)
                ins = inneighbors(g, n′)
                if length(ins) == 1
                    rem_edge!(g, n, n′)
                    merge_vertices!(g, [n, n′])
                    haschanged = true
                    break
                end
            end
            # case 2: compress structured branches
            # TODO

            # case 3: remove head-controlled recursion
            if n in outs && length(outs) == 2
                rem_edge!(g, n, n)
                haschanged = true
                break
            end

            # case 4: merge mutually recursive blocks into caller
            for n′ in outs
                if outneighbors(n′) == [n]
                    rem_edge!(n, n′)
                    rem_edge!(n′, n)
                    rem_vertex!(g, n′)
                end
                haschanged = true
                break
            end
            haschanged && break
        end
    end
end
