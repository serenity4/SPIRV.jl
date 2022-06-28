entry_node(g::AbstractGraph) = only(sources(g))

sinks(g::AbstractGraph) = vertices(g)[findall(isempty ∘ Base.Fix1(outneighbors, g), vertices(g))]
sources(g::AbstractGraph) = vertices(g)[findall(isempty ∘ Base.Fix1(inneighbors, g), vertices(g))]

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
        cond, dst1, dst2 = arguments[1]::SSAValue, arguments[2]::SSAValue, arguments[3]::SSAValue
        add_edge!(cfg, i, find_block(amod, af, dst1))
        add_edge!(cfg, i, find_block(amod, af, dst2))
        @case &OpSwitch
        val = arguments[1]::SSAValue
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

function backedges(g::AbstractGraph, source = 1)
  dfs = dfs_tree(g, source)
  visited = zeros(Bool, nv(dfs))
  backedges = Edge{Int}[]
  for v in 1:nv(dfs)
    visited[v] = true
    for dst in outneighbors(g, v)
      if visited[dst]
        push!(backedges, Edge(v, dst))
      end
    end
  end
  backedges
end

function remove_backedges!(g::AbstractGraph, source = 1)
  for e in backedges(g, source)
    rem_edge!(g, e)
  end
  g
end
remove_backedges(g::AbstractGraph, source = 1) = remove_backedges!(deepcopy(g), source)

function traverse(g::AbstractGraph, source = 1; has_backedges = true)
  has_backedges && (g = remove_backedges(g, source))
  topological_sort_by_dfs(g)
end

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
function flow_through(f, g::AbstractGraph, v; stop_at::Optional{Union{Int, Edge{Int}}} = nothing)
  next = [Edge(v, v2) for v2 in outneighbors(g, v)]
  while !isempty(next)
    edge = popfirst!(next)
    ret = f(edge)
    ret === nothing && return
    ret || continue

    stop_at isa Edge{Int} && edge === stop_at && continue
    stop_at isa Int && dst(edge) === stop_at && continue

    # Push all new edges to the end of the worklist.
    new_edges = [Edge(dst(edge), v) for v in outneighbors(g, dst(edge))]
    filter!(e -> !in(e, new_edges), next)
    append!(next, new_edges)
  end
end

function postdominator(g::AbstractGraph, source)
  g = remove_backedges(g)
  root_tree = DominatorTree(g)
  tree = nothing
  for subtree in PreOrderDFS(root_tree)
    if nodevalue(subtree) == source
      tree = subtree
    end
  end
  pdoms = findall(!in(nodevalue(subtree), outneighbors(g, nodevalue(tree))) for subtree in children(tree))
  @assert length(pdoms) ≤ 1 "Found $(length(pdoms)) postdominator(s)"
  isempty(pdoms) ? nothing : nodevalue(children(tree)[first(pdoms)])
end

struct DominatorTree
  node::Int
  immediate_dominator::Optional{DominatorTree}
  immediate_post_dominators::Vector{DominatorTree}
end

AbstractTrees.nodevalue(tree::DominatorTree) = tree.node
AbstractTrees.ParentLinks(tree::DominatorTree) = StoredParents()
AbstractTrees.parent(tree::DominatorTree) = tree.immediate_dominator
AbstractTrees.ChildIndexing(tree::DominatorTree) = IndexedChildren()
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

function DominatorTree(cfg::AbstractGraph)
  g = remove_backedges(cfg)

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
