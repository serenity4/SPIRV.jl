entry_node(g::AbstractGraph) = only(sources(g))

sinks(g::AbstractGraph) = vertices(g)[findall(isempty ∘ Base.Fix1(outneighbors, g), vertices(g))]
sources(g::AbstractGraph) = vertices(g)[findall(isempty ∘ Base.Fix1(inneighbors, g), vertices(g))]

struct SimpleTree{T}
  data::T
  parent::Optional{SimpleTree{T}}
  children::Vector{SimpleTree{T}}
end
SimpleTree(data::T) where {T} = SimpleTree(data, nothing, T[])

AbstractTrees.HasNodeType(::Type{SimpleTree}) = true
AbstractTrees.NodeType(::Type{SimpleTree{T}}) where {T} = T
AbstractTrees.nodevalue(tree::SimpleTree) = tree.data
AbstractTrees.ChildIndexing(::Type{SimpleTree}) = IndexedChildren()

AbstractTrees.ParentLinks(::Type{SimpleTree}) = StoredParents()
AbstractTrees.parent(tree::SimpleTree) = tree.parent

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
  # visited[v] && continue
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

struct ControlFlowGraph{E<:AbstractEdge,G<:AbstractGraph}
  g::G
  dfst::SpanningTreeDFS{G}
  ec::EdgeClassification{E}
  is_reducible::Bool
  is_structured::Bool
  ControlFlowGraph(g::G, dfst::SpanningTreeDFS{G}, ec::EdgeClassification{E}, is_reducible::Bool, is_structured::Bool) where {G<:AbstractGraph, E<:AbstractEdge} = new{E,G}(g, dfst, ec, is_reducible, is_structured)
end

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

control_flow_graph(fdef::FunctionDefinition) = control_flow_graph(collect(fdef.blocks))

function control_flow_graph(amod::AnnotatedModule, af::AnnotatedFunction)
  cfg = SimpleDiGraph(length(af.blocks))

  for (i, block) in enumerate(af.blocks)
    for inst in instructions(amod, block)
      (; arguments) = inst
      @tryswitch opcode(inst) begin
        @case &OpBranch
        dst = arguments[1]::SSAValue
        add_edge!(cfg, i, find_block(amod, af, dst))
        @case &OpBranchConditional
        dst1, dst2 = arguments[2]::SSAValue, arguments[3]::SSAValue
        add_edge!(cfg, i, find_block(amod, af, dst1))
        add_edge!(cfg, i, find_block(amod, af, dst2))
        @case &OpSwitch
        for dst in arguments[2:end]
          add_edge!(cfg, i, find_block(amod, af, dst::SSAValue))
        end
      end
    end
  end
  cfg
end

function find_block(amod::AnnotatedModule, af::AnnotatedFunction, id::SSAValue)
  for (i, block) in enumerate(af.blocks)
    has_result_id(amod[block.start], id) && return i
  end
end

@forward ControlFlowGraph.g (dominators,)

function dominators(g::AbstractGraph{T}) where {T}
  doms = Set{T}[Set{T}() for _ in 1:nv(g)]
  source = entry_node(g)
  push!(doms[source], source)
  vs = filter(≠(source), vertices(g))
  for v in vs
    union!(doms[v], vertices(g))
  end

  converged = false
  while !converged
    converged = true
    for v in vs
      h = hash(doms[v])
      set = intersect((doms[u] for u in inneighbors(g, v))...)
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

function backedges(g::AbstractGraph, ec::EdgeClassification = EdgeClassification(g))
  doms = dominators(g)
  filter(ec.retreating_edges) do e
    in(dst(e), doms[src(e)])
  end
end

function remove_backedges(cfg::ControlFlowGraph)
  g = deepcopy(cfg.g)
  rem_edges!(g, backedges(cfg))
  ControlFlowGraph(g)
end

traverse(cfg::ControlFlowGraph) = reverse(post_ordering(cfg.dfst))

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
  next = [Edge(v, v2) for v2 in outneighbors(cfg.g, v)]
  bedges = backedges(cfg)
  while !isempty(next)
    edge = popfirst!(next)
    ret = f(edge)
    isnothing(ret) && return
    in(edge, bedges) && !ret && continue

    stop_at isa Edge{Int} && edge === stop_at && continue
    stop_at isa Int && dst(edge) === stop_at && continue

    # Push all new edges to the end of the worklist.
    new_edges = [Edge(dst(edge), v) for v in outneighbors(cfg.g, dst(edge))]
    filter!(e -> !in(e, new_edges), next)
    append!(next, new_edges)
  end
end

function postdominator(cfg::ControlFlowGraph, source)
  cfg = remove_backedges(cfg)
  root_tree = DominatorTree(cfg)
  tree = nothing
  for subtree in PreOrderDFS(root_tree)
    if nodevalue(subtree) == source
      tree = subtree
    end
  end
  pdoms = findall(!in(nodevalue(subtree), outneighbors(cfg.g, nodevalue(tree))) for subtree in children(tree))
  @assert length(pdoms) ≤ 1 "Found $(length(pdoms)) postdominator(s)"
  isempty(pdoms) ? nothing : nodevalue(children(tree)[first(pdoms)])
end

struct DominatorTree
  node::Int
  immediate_dominator::Optional{DominatorTree}
  immediate_post_dominators::Vector{DominatorTree}
end

AbstractTrees.nodevalue(tree::DominatorTree) = tree.node
AbstractTrees.ParentLinks(::Type{DominatorTree}) = StoredParents()
AbstractTrees.parent(tree::DominatorTree) = tree.immediate_dominator
AbstractTrees.ChildIndexing(::Type{DominatorTree}) = IndexedChildren()
AbstractTrees.children(tree::DominatorTree) = tree.immediate_post_dominators
AbstractTrees.childrentype(::Type{DominatorTree}) = DominatorTree
AbstractTrees.NodeType(::Type{<:DominatorTree}) = HasNodeType()
AbstractTrees.nodetype(::Type{T}) where {T<:DominatorTree} = T

@forward DominatorTree.immediate_post_dominators (Base.getindex,)

dominated_nodes(tree::DominatorTree) = nodevalue.(children(tree))
dominator(tree::DominatorTree) = nodevalue(parent(tree))

DominatorTree(node, immediate_dominator = nothing) = DominatorTree(node, immediate_dominator, [])
DominatorTree(fdef::FunctionDefinition) = DominatorTree(control_flow_graph(fdef))

Base.show(io::IO, tree::DominatorTree) = print(io, DominatorTree, '(', nodevalue(tree), ", ", children(tree), ')')
function Base.show(io::IO, ::MIME"text/plain", tree::DominatorTree)
  print(io, DominatorTree, " (node: ", nodevalue(tree))
  print(io, ", ", isroot(tree) ? "no dominator" : "dominator: $(nodevalue(parent(tree)))")
  print(io, ", ", isempty(children(tree)) ? "no dominated nodes" : "dominated nodes: $(nodevalue.(children(tree)))")
  print(io, ')')
end

function DominatorTree(cfg::ControlFlowGraph)
  g = remove_backedges(cfg).g

  # 0: unvisited
  # 1: visited
  # 2: in tree
  vcolors = zeros(UInt8, nv(g))
  root = DominatorTree(entry_node(g))
  next_trees = [root]

  while !isempty(next_trees)
    tree = pop!(next_trees)
    # The tree shouldn't have been filled with post-dominators yet.
    @assert isempty(tree.immediate_post_dominators)
    for next in outneighbors(g, tree.node)
      # Ignore vertices that have already been associated with a dominator tree.
      vcolors[next] == 2 && continue
      sources = inneighbors(g, next)
      if sources == [tree.node]
        @assert iszero(vcolors[next])
        new_tree = DominatorTree(next, tree)
        push!(tree.immediate_post_dominators, new_tree)
        push!(next_trees, new_tree)
        vcolors[next] = 2
      elseif all(vcolors[source] == 2 for source in sources)
        new_tree = DominatorTree(next, tree)
        ancestor = common_ancestor(begin
            v = source
            prev_sources = inneighbors(g, v)
            while length(prev_sources) == 1
              v = first(prev_sources)
              prev_sources = inneighbors(g, v)
            end
            find_parent(x -> nodevalue(x) == v, tree)
          end for source in sources)
        push!(ancestor.immediate_post_dominators, new_tree)
        push!(next_trees, new_tree)
        vcolors[next] = 2
      else
        vcolors[next] = 1
      end
    end
  end
  root
end

common_ancestor(trees) = common_ancestor(Iterators.peel(trees)...)
function common_ancestor(tree, trees)
  common_ancestor = tree
  parent_chain = parents(common_ancestor)
  for candidate in trees
    common_ancestor = find_parent(in(parent_chain), candidate)
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
  while true
    f(tree) === true && return tree
    isroot(tree) && break
    tree = parent(tree)
  end
end

traverse_cfg(fdef::FunctionDefinition) = (keys(fdef.blocks)[nodevalue(tree)] for tree in PreOrderDFS(dominance_tree(fdef)))
