function entry_node(g::AbstractGraph)
  vs = sources(g)
  isempty(vs) && error("No entry node was found.")
  length(vs) > 1 && error("Multiple entry nodes were found.")
  first(vs)
end

sinks(g::AbstractGraph) = vertices(g)[findall(isempty ∘ Fix1(outneighbors, g), vertices(g))]
sources(g::AbstractGraph) = vertices(g)[findall(isempty ∘ Fix1(inneighbors, g), vertices(g))]

mutable struct SimpleTree{T}
  data::T
  parent::Optional{SimpleTree{T}}
  children::Vector{SimpleTree{T}}
  function SimpleTree{T}(data::T, parent, children) where {T}
    tree = new{T}(data, parent, SimpleTree{T}[])
    # Make sure that all the children mark this new tree as parent.
    for c in children
      push!(tree.children, @set c.parent = tree)
    end
    tree
  end
end
SimpleTree{T}(data::T, children = SimpleTree{T}[]) where {T} = SimpleTree{T}(data, nothing, children)
SimpleTree(data::T, parent, children) where {T} = SimpleTree{T}(data, parent, children)
SimpleTree(data::T, children = SimpleTree{T}[]) where {T} = SimpleTree{T}(data, children)

Base.:(==)(x::SimpleTree, y::SimpleTree) = nodetype(x) == nodetype(y) && x.parent == y.parent && length(x.children) == length(y.children) && all(xx == yy for (xx, yy) in zip(x.children, y.children))

"""
Equality is defined for `SimpleTree`s over data and children. The equality of
parents is not tested to avoid infinite recursion, and only the presence of
parents is tested instead.
"""
Base.:(==)(x::SimpleTree{T}, y::SimpleTree{T}) where {T} = x.data == y.data && x.children == y.children && isnothing(x.parent) == isnothing(y.parent)

Base.show(io::IO, ::MIME"text/plain", tree::SimpleTree) = isempty(children(tree)) ? print(io, typeof(tree), "(", tree.data, ", [])") : print(io, chomp(sprintc(print_tree, tree; maxdepth = 10)))
Base.show(io::IO, tree::SimpleTree) = print(io, typeof(tree), "(", nodevalue(tree), isroot(tree) ? "" : string(", parent = ", nodevalue(parent(tree))), ", children = [", join(nodevalue.(children(tree)), ", "), "])")

Base.getindex(tree::SimpleTree, index) = children(tree)[index]
Base.firstindex(tree::SimpleTree) = firstindex(children(tree))
Base.lastindex(tree::SimpleTree) = lastindex(children(tree))

AbstractTrees.nodetype(T::Type{<:SimpleTree}) = T
AbstractTrees.NodeType(::Type{SimpleTree{T}}) where {T} = HasNodeType()
AbstractTrees.nodevalue(tree::SimpleTree) = tree.data
AbstractTrees.ChildIndexing(::Type{<:SimpleTree}) = IndexedChildren()

AbstractTrees.ParentLinks(::Type{<:SimpleTree}) = StoredParents()
AbstractTrees.parent(tree::SimpleTree) = tree.parent
Base.parent(tree::SimpleTree) = tree.parent

AbstractTrees.children(tree::SimpleTree) = tree.children
AbstractTrees.childrentype(::Type{T}) where {T<:SimpleTree} = T

struct SpanningTreeDFS{G<:AbstractGraph}
  tree::G
  discovery_times::Vector{Int}
  finish_times::Vector{Int}
end

function SpanningTreeDFS(g::AbstractGraph{T}, source = 1) where {T}
  tree = typeof(g)(nv(g))
  dfst = SpanningTreeDFS(tree, zeros(Int, nv(g)), zeros(Int, nv(g)))
  build!(dfst, [source], zeros(Bool, nv(g)), g)
  dfst
end

function build!(dfst::SpanningTreeDFS, next, visited, g::AbstractGraph, time = 0)
  v = pop!(next)
  visited[v] = true
  dfst.discovery_times[v] = (time += 1)
  for w in outneighbors(g, v)
    if !visited[w]
      add_edge!(dfst.tree, v, w)
      push!(next, w)
      time = build!(dfst, next, visited, g, time)
    end
  end
  dfst.finish_times[v] = (time += 1)

  time
end

pre_ordering(dfst::SpanningTreeDFS) = sortperm(dfst.discovery_times)
post_ordering(dfst::SpanningTreeDFS) = sortperm(dfst.finish_times)

struct EdgeClassification{E<:AbstractEdge}
  tree_edges::Set{E}
  forward_edges::Set{E}
  retreating_edges::Set{E}
  cross_edges::Set{E}
end

EdgeClassification{E}() where {E} = EdgeClassification(Set{E}(), Set{E}(), Set{E}(), Set{E}())

function SimpleTree(dfst::SpanningTreeDFS, parent::Union{Nothing, SimpleTree{T}}, v::T) where {T}
  tree = SimpleTree(v, parent, SimpleTree{T}[])
  for w in outneighbors(dfst.tree, v)
    push!(tree.children, SimpleTree(dfst, tree, w))
  end
  tree
end

SimpleTree(dfst::SpanningTreeDFS) = SimpleTree(dfst, nothing, entry_node(dfst.tree))

EdgeClassification(g::AbstractGraph, dfst::SpanningTreeDFS = SpanningTreeDFS(g)) = EdgeClassification(g, SimpleTree(dfst))

function EdgeClassification(g::AbstractGraph{T}, tree::SimpleTree{T}) where {T}
  E = edgetype(g)
  ec = EdgeClassification{E}()
  for subtree in PreOrderDFS(tree)
    # Traverse the tree and classify edges based on ancestor information.
    # Outgoing edges are used to find retreating edges (if pointing to an ancestor).
    # Incoming edges are used to find tree edges (if coming from parent) and forward edges (if pointing to an ancestor that is not the parent).
    # Other edges are cross-edges.
    v = nodevalue(subtree)

    for u in inneighbors(g, v)
      e = E(u, v)
      nodevalue(parent(subtree))
      if u == nodevalue(parent(subtree))
        push!(ec.tree_edges, e)
      elseif !isnothing(find_parent(==(u) ∘ nodevalue, subtree))
        push!(ec.forward_edges, e)
      end
    end

    for w in outneighbors(g, v)
      e = E(v, w)
      !isnothing(find_parent(==(w) ∘ nodevalue, subtree)) && push!(ec.retreating_edges, e)
    end
  end

  for e in edges(g)
    !in(e, ec.tree_edges) && !in(e, ec.forward_edges) && !in(e, ec.retreating_edges) && push!(ec.cross_edges, e)
  end

  ec
end

@refbroadcast struct ControlFlowGraph{E<:AbstractEdge,T,G<:AbstractGraph{T}} <: AbstractGraph{T}
  g::G
  dfst::SpanningTreeDFS{G}
  ec::EdgeClassification{E}
  is_reducible::Bool
  is_structured::Bool
  ControlFlowGraph(g::G, dfst::SpanningTreeDFS{G}, ec::EdgeClassification{E}, is_reducible::Bool, is_structured::Bool) where {T, G<:AbstractGraph{T}, E<:AbstractEdge} = new{E,T,G}(g, dfst, ec, is_reducible, is_structured)
end

@forward_methods ControlFlowGraph field = :g Graphs.vertices Graphs.edges Graphs.add_edge!(_, e) Base.eltype Graphs.edgetype Graphs.add_vertex!(_, v) Graphs.rem_edge!(_, e) Graphs.rem_vertex!(_, v) Graphs.rem_vertices!(_, vs) Graphs.inneighbors(_, v) Graphs.outneighbors(_, v) Graphs.nv Graphs.ne dominators

Graphs.is_directed(::Type{<:ControlFlowGraph}) = true

Base.reverse(cfg::ControlFlowGraph) = ControlFlowGraph(reverse(cfg.g))

is_reducible(cfg::ControlFlowGraph) = cfg.is_reducible
is_structured(cfg::ControlFlowGraph) = cfg.is_structured

ControlFlowGraph(args...) = ControlFlowGraph(control_flow_graph(args...))

function ControlFlowGraph(cfg::AbstractGraph)
  dfst = SpanningTreeDFS(cfg)
  ec = EdgeClassification(cfg, dfst)

  analysis_cfg = deepcopy(cfg)
  rem_edges!(analysis_cfg, backedges(cfg, ec))
  is_reducible = !is_cyclic(analysis_cfg)

  # TODO: actually test whether CFG is structured or not.
  is_structured = is_reducible
  ControlFlowGraph(cfg, dfst, ec, is_reducible, is_structured)
end

function control_flow_graph(fdef::FunctionDefinition)
  cfg = SimpleDiGraph(length(fdef))

  for (i, block) in enumerate(fdef)
    for ex in block
      @tryswitch ex.op begin
        @case &OpBranch
        dst = ex[1]::ResultID
        add_edge!(cfg, i, block_index(fdef, fdef[dst]))
        @case &OpBranchConditional
        dst1, dst2 = ex[2]::ResultID, ex[3]::ResultID
        add_edge!(cfg, i, block_index(fdef, fdef[dst1]))
        add_edge!(cfg, i, block_index(fdef, fdef[dst2]))
        @case &OpSwitch
        for dst::ResultID in ex[4:2:end]
          add_edge!(cfg, i, block_index(fdef, fdef[dst]))
        end
      end
    end
  end
  cfg
end

function control_flow_graph(amod::AnnotatedModule, af::AnnotatedFunction)
  cfg = SimpleDiGraph(length(af.blocks))

  for (i, block) in enumerate(af.blocks)
    for inst in instructions(amod, block)
      (; arguments) = inst
      @tryswitch opcode(inst) begin
        @case &OpBranch
        dst = arguments[1]::ResultID
        add_edge!(cfg, i, find_block(amod, af, dst))
        @case &OpBranchConditional
        dst1, dst2 = arguments[2]::ResultID, arguments[3]::ResultID
        add_edge!(cfg, i, find_block(amod, af, dst1))
        add_edge!(cfg, i, find_block(amod, af, dst2))
        @case &OpSwitch
        for dst in arguments[4:2:end]
          add_edge!(cfg, i, find_block(amod, af, dst::ResultID))
        end
      end
    end
  end
  cfg
end

dominators(g::AbstractGraph{T}) where {T} = dominators(g, vertices(g), entry_node(g))
function dominators(g::AbstractGraph{T}, vs, source) where {T}
  doms = dictionary(v => Set{T}() for v in vs)
  push!(doms[source], source)
  vs_excluding_source = filter(≠(source), vs)
  for v in vs_excluding_source
    union!(doms[v], vs)
  end
  vs_set = Set(vs)

  converged = false
  while !converged
    converged = true
    for v in vs_excluding_source
      h = hash(doms[v])
      set = intersect((doms[u] for u in inneighbors(g, v) if in(u, vs_set))...)
      doms[v] = set
      push!(set, v)
      h ≠ hash(set) && (converged &= false)
    end
  end

  doms
end

function backedges(cfg::ControlFlowGraph)
  is_reducible(cfg) && return copy(cfg.ec.retreating_edges)
  backedges(cfg.g, cfg.ec)
end

function backedges(g::AbstractGraph{T}, ec::EdgeClassification = EdgeClassification(g), domsets::Dictionary{T,Set{T}} = dominators(g)) where {T}
  filter(ec.retreating_edges) do e
    in(dst(e), domsets[src(e)])
  end
end

function remove_backedges(cfg::ControlFlowGraph)
  g = deepcopy(cfg.g)
  rem_edges!(g, backedges(cfg))
  ControlFlowGraph(g)
end

traverse(cfg::ControlFlowGraph) = reverse(post_ordering(cfg.dfst))
traverse(cfg::AbstractGraph) = reverse(post_ordering(SpanningTreeDFS(cfg)))

"""
Iterate through the graph `g` applying `f` until its application on the graph vertices
reaches a fixed point.

`f` must return a `Bool` value indicating whether a next iteration should be performed.
If `false`, then the iteration will not be continued on outgoing nodes.

# Flow Analysis

- Nodes that are not part of a cyclic structure (i.e. have no back-edges and don't have a path from a node which has a back-edge) need only be traversed once.
- Cyclic structures must be iterated on until convergence. On reducible control-flow graphs, it might be sufficient to iterate a given loop structure locally until convergence before iterating through nodes that are further apart in the cyclic structure. This optimization is not currently implemented.
- Flow analysis should provide a framework suited for both abstract interpretation and data-flow algorithms.
"""
function flow_through(f, cfg::ControlFlowGraph, v; stop_at::Optional{Union{Int, Edge{Int}}} = nothing)
  next = [Edge(v, v2) for v2 in outneighbors(cfg, v)]
  bedges = backedges(cfg)
  while !isempty(next)
    edge = popfirst!(next)
    ret = f(edge)
    isnothing(ret) && return
    in(edge, bedges) && !ret && continue

    stop_at isa Edge{Int} && edge === stop_at && continue
    stop_at isa Int && dst(edge) === stop_at && continue

    # Push all new edges to the end of the worklist.
    new_edges = [Edge(dst(edge), v) for v in outneighbors(cfg, dst(edge))]
    filter!(e -> !in(e, new_edges), next)
    append!(next, new_edges)
  end
end

function postdominator(cfg::ControlFlowGraph, source)
  cfg = remove_backedges(cfg)
  root_tree = DominatorTree(cfg)
  tree = nothing
  for subtree in PreOrderDFS(root_tree)
    if node_index(subtree) == source
      tree = subtree
    end
  end
  pdoms = findall(!in(v, outneighbors(cfg, node_index(tree))) for v in immediate_postdominators(tree))
  @assert length(pdoms) ≤ 1 "Found $(length(pdoms)) postdominator(s), expected one or none"
  isempty(pdoms) ? nothing : node_index(tree[only(pdoms)])
end

struct DominatorNode
  index::Int
end

const DominatorTree = SimpleTree{DominatorNode}

node_index(tree::DominatorTree) = nodevalue(tree).index

immediate_postdominators(tree::DominatorTree) = node_index.(children(tree))
immediate_dominator(tree::DominatorTree) = node_index(@something(parent(tree), return))

DominatorTree(fdef::FunctionDefinition) = DominatorTree(control_flow_graph(fdef))
DominatorTree(cfg::AbstractGraph) = DominatorTree(dominators(cfg))

DominatorTree(node::Integer, children = DominatorNode[]) = DominatorTree(DominatorNode(node), children)

function DominatorTree(domsets::Dictionary{T,Set{T}}) where {T}
  root = nothing
  idoms = Dictionary{T, T}()

  # Compute immediate dominators from the dominator sets.
  # One node's only immediate dominator is going to be its parent
  # in the tree representation.
  for (v, domset) in pairs(domsets)
    if length(domset) == 1
      isnothing(root) || error("Found multiple root dominators.")
      root = v
      continue
    end

    candidates = copy(domset)
    delete!(candidates, v)
    for p in candidates
      for dom in domsets[p]
        dom == p && continue
        in(dom, candidates) && delete!(candidates, dom)
      end
    end
    idom = only(candidates)
    insert!(idoms, v, idom)
  end

  # Attach all the subtrees together and to the root tree.
  root_tree = DominatorTree(DominatorNode(root))
  trees = dictionary([v => DominatorTree(DominatorNode(v)) for v in keys(idoms)])
  for (v, tree) in pairs(trees)
    # Skip trees which have already been attached.
    isroot(tree) || continue
    idom = idoms[v]
    p = get(trees, idom, root_tree)
    tree.parent = p
    push!(p.children, tree)
  end
  root_tree
end

common_ancestor(trees) = common_ancestor(Iterators.peel(trees)...)
function common_ancestor(tree, trees)
  common_ancestor = tree
  parent_chain = parents(common_ancestor)
  for candidate in trees
    common_ancestor = in(candidate, parent_chain) ? candidate : find_parent(in(parent_chain), candidate)
    parent_chain = parents(common_ancestor)
    isnothing(common_ancestor) && return nothing
  end
  common_ancestor
end

is_ancestor(candidate, tree) = !isnothing(find_parent(==(candidate), tree))

function parents(tree)
  res = [tree]
  while true
    isroot(tree) && break
    tree = parent(tree)
    push!(res, tree)
  end
  res
end

function find_parent(f, tree)
  original = tree
  while true
    f(tree) === true && tree !== original && return tree
    isroot(tree) && break
    tree = parent(tree)
  end
end

function find_subtree(f, tree::SimpleTree)
  original = tree
  for tree in PreOrderDFS(tree)
    f(tree) === true && tree !== original && return tree
  end
  nothing
end
