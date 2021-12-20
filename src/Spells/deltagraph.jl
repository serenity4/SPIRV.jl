import Graphs: edges, edgetype, add_edge!, add_vertex!, rem_edge!, rem_vertex!, rem_vertices!, has_edge, has_vertex, inneighbors, outneighbors, ne, nv, vertices, is_directed, SimpleDiGraph, merge_vertices!

export DeltaGraph, compact

"""
Graph whose vertices and edges remain identical after deletion of other vertices.
"""
@auto_hash_equals struct DeltaGraph{T} <: AbstractGraph{T}
    vertices::Vector{T}
    fadjlist::Vector{Vector{T}}
    badjlist::Vector{Vector{T}}
end

Base.broadcastable(dg::DeltaGraph) = Ref(dg)

DeltaGraph{T}() where {T} = DeltaGraph{T}([], [], [])
DeltaGraph(n::T = 0) where {T<:Integer} = DeltaGraph{T}(n)
function DeltaGraph(n::Integer, edges::AbstractVector)
    dg = DeltaGraph(n)
    for e in edges
        e isa Pair && (e = Edge(e...))
        add_edge!(dg, e)
    end
    dg
end
DeltaGraph(n::Integer, edges...) = DeltaGraph(n, collect(edges))
function DeltaGraph{T}(n::Integer) where {T}
    dg = DeltaGraph{T}()
    add_vertices!(dg, n)
    dg
end

function vertex_index(dg::DeltaGraph, v)
    idx = findfirst(==(v), dg.vertices)
    if isnothing(idx)
        error("Vertex $v not found in $dg.")
    end
    idx
end

Base.eltype(dg::DeltaGraph{T}) where {T} = T
Base.zero(dg::DeltaGraph) = zero(typeof(dg))
Base.zero(T::Type{DeltaGraph}) = T()
edgetype(dg::DeltaGraph) = Edge{eltype(dg)}
has_vertex(dg::DeltaGraph, v) = v in vertices(dg)
vertices(dg::DeltaGraph) = dg.vertices

function Base.empty!(dg::DeltaGraph)
    empty!(dg.vertices)
    empty!(dg.badjlist)
    empty!(dg.fadjlist)
    dg
end

is_single_node(dg::DeltaGraph) = isempty(edges(dg)) && nv(dg) == 1

Base.isempty(dg::DeltaGraph) = isempty(dg.vertices)

is_directed(dg::DeltaGraph) = is_directed(typeof(dg))
is_directed(::Type{<:DeltaGraph}) = true

has_edge(dg::DeltaGraph, e::Edge) = has_edge(dg, e.src, e.dst)
has_edge(dg::DeltaGraph, src, dst) = has_vertex(dg, src) && has_vertex(dg, dst) && dst in _outneighbors(dg, src)

function edges(dg::DeltaGraph)
    edge_lists = map(enumerate(dg.fadjlist)) do (i, fadj)
        Edge.(dg.vertices[i], fadj)
    end
    edgetype(dg)[edge_lists...;]
end

_inneighbors(dg::DeltaGraph, v) = dg.badjlist[vertex_index(dg, v)]
_outneighbors(dg::DeltaGraph, v) = dg.fadjlist[vertex_index(dg, v)]
inneighbors(dg::DeltaGraph, v) = copy(_inneighbors(dg, v))
outneighbors(dg::DeltaGraph, v) = copy(_outneighbors(dg, v))

ne(dg::DeltaGraph) = sum(length, dg.fadjlist[vertices(dg)])
nv(dg::DeltaGraph) = length(vertices(dg))

function add_vertex!(dg::DeltaGraph; fill_holes = true)
    idx = fill_holes ? findfirst(((i, x),) -> i ≠ x, collect(enumerate(dg.vertices))) : length(dg.vertices) + 1
    idx = something(idx, length(dg.vertices) + 1)
    T = eltype(dg)
    insert!(dg.vertices, idx, idx)
    insert!(dg.fadjlist, idx, T[])
    insert!(dg.badjlist, idx, T[])
    idx
end

function add_vertices!(dg::DeltaGraph, n)
    [add_vertex!(dg, fill_holes = n < 1000) for _ in 1:n]
    nothing
end

add_edge!(dg::DeltaGraph, e::Edge) = add_edge!(dg, e.src, e.dst)
function add_edge!(dg::DeltaGraph, src, dst)
    src_idx = vertex_index(dg, src)
    if dst ∉ dg.fadjlist[src_idx]
        push!(dg.fadjlist[src_idx], dst)
    end
    dst_idx = vertex_index(dg, dst)
    if src ∉ dg.badjlist[dst_idx]
        push!(dg.badjlist[dst_idx], src)
    end
    nothing
end

"""
Remove all edges from or to vertex `v`.
"""
function rem_edges!(dg::DeltaGraph, v::Int)
    for i in _outneighbors(dg, v)
        rem_edge!(dg, v, i)
    end
    for i in _inneighbors(dg, v)
        rem_edge!(dg, i, v)
    end
end

function rem_vertex!(dg::DeltaGraph, i)
    idx = vertex_index(dg, i)
    rem_edges!(dg, i)
    deleteat!(dg.vertices, idx)
    deleteat!(dg.fadjlist, idx)
    deleteat!(dg.badjlist, idx)
    nothing
end

rem_vertices!(dg::DeltaGraph, vs...) = foreach(Base.Fix1(rem_vertex!, dg), vs)

rem_edge!(dg::DeltaGraph, e::Edge) = rem_edge!(dg, e.src, e.dst)

function rem_edge!(dg::DeltaGraph, src, dst)
    if has_edge(dg, src, dst)
        outs = _outneighbors(dg, src)
        deleteat!(outs, findfirst(==(dst), outs))
        ins = _inneighbors(dg, dst)
        deleteat!(ins, findfirst(==(src), ins))
    end
    nothing
end

"""
Merge vertices `vs` into the first one.
"""
merge_vertices!(dg::DeltaGraph, vs::AbstractVector) = foldl((x, y) -> merge_vertices!(dg, x, y), vs)
merge_vertices!(dg::DeltaGraph, origin, merged...) = merge_vertices!(dg, [origin; collect(merged)])

function merge_vertices!(dg::DeltaGraph, origin, merged)
    copy_edges!(dg, merged, origin)
    rem_vertex!(dg, merged)
    origin
end

function copy_edges!(dg::DeltaGraph, from, to)
    for i in outneighbors(dg, from)
        add_edge!(dg, to, i)
    end
    for i in inneighbors(dg, from)
        add_edge!(dg, i, to)
    end
end

function compact(dg::DeltaGraph)
    g = SimpleDiGraph(dg)
    dg = typeof(dg)()
    append!(dg.vertices, 1:nv(g))
    append!(dg.badjlist, g.badjlist)
    append!(dg.fadjlist, g.fadjlist)
    dg
end

function SimpleDiGraph(dg::DeltaGraph)
    perm = sortperm(dg.vertices)
    verts_sorted = dg.vertices[perm]
    fadjs = dg.fadjlist[perm]
    badjs = dg.badjlist[perm]
    g = SimpleDiGraph{eltype(dg)}(length(dg.vertices))
    for (v, (fadj, badj)) in enumerate(zip(fadjs, badjs))
        for i in fadj
            add_edge!(g, v, findfirst(==(i), verts_sorted))
        end
        for i in badj
            add_edge!(g, findfirst(==(i), verts_sorted), v)
        end
    end
    g
end

sinks(dg::DeltaGraph) = vertices(dg)[findall(isempty ∘ Base.Fix1(outneighbors, dg), vertices(dg))]
sources(dg::DeltaGraph) = vertices(dg)[findall(isempty ∘ Base.Fix1(inneighbors, dg), vertices(dg))]
