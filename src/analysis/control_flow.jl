entry_node(g::AbstractGraph) = only(sources(g))

control_flow_graph(fdef::FunctionDefinition) = control_flow_graph(collect(fdef.blocks))

function control_flow_graph(c::InstructionCursor)
  inst = read(c)
  assert_opcode(OpFunction, inst)
  cfg = control_flow_graph(read(c, Vector{Block}))
  assert_opcode(OpFunctionEnd, read(c, 1))
  cfg
end

function Base.read(c::InstructionCursor, ::Type{Block})
  inst = read(c)
  assert_opcode(OpLabel, inst)
  block = Block(inst.result_id)
  while !eof(c) && !in(opcode(peek(c)), (OpLabel, OpFunctionEnd))
    push!(block, read(c))
  end
  block
end

function Base.read(c::InstructionCursor, ::Type{Vector{Block}})
  blocks = Block[]
  while opcode(peek(c)) == OpLabel
    push!(blocks, read(c, Block))
  end
  blocks
end

function control_flow_graph(blocks::AbstractVector{Block})
  cfg = SimpleDiGraph(length(blocks))
  for (i, block) in enumerate(blocks)
    for inst in block
      (; arguments) = inst
      @tryswitch opcode(inst) begin
        @case &OpBranch
        dst = arguments[1]::SSAValue
        add_edge!(cfg, i, block_index(blocks, dst))
        @case &OpBranchConditional
        cond, dst1, dst2 = arguments[1]::SSAValue, arguments[2]::SSAValue, arguments[3]::SSAValue
        add_edge!(cfg, i, block_index(blocks, dst1))
        add_edge!(cfg, i, block_index(blocks, dst2))
        @case &OpSwitch
        val = arguments[1]::SSAValue
        for dst in arguments[2:end]
          add_edge!(cfg, i, block_index(blocks, dst::SSAValue))
        end
      end
    end
  end
  cfg
end

block_index(blocks::AbstractVector{Block}, id::SSAValue) = findfirst(==(id) ∘ Base.Fix2(getproperty, :id), blocks)

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
