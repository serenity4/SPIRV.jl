using SPIRV, Test, Graphs, AbstractTrees, AutoHashEquals
using AbstractTrees: parent
using SPIRV: traverse, postdominator, DominatorTree, common_ancestor, dominated_nodes, dominator

@testset "Function analysis" begin
  @testset "Static call graph traversal" begin
    ir = IR(SPIRV.Module(resource("comp.spv")); satisfy_requirements = false)
    fdefs = dependent_functions(ir, SSAValue(4)) # main

    @test Set(fdefs) == Set(ir.fdefs)

    plane_intersect = ir.fdefs[SSAValue(46)]
    fdefs = dependent_functions(ir, SSAValue(46)) # planeIntersect
    @test fdefs == [ir.fdefs[SSAValue(46)]]

    fdefs = dependent_functions(ir, SSAValue(71)) # renderScene
    @test length(fdefs) == 10
    main = ir.fdefs[SSAValue(4)]
    @test !in(main, fdefs)
  end

  @testset "Control flow graph" begin
    @testset "Dominance relationships" begin
      @testset "Tree utilities" begin
        @auto_hash_equals struct Tree1
          val::Int
          parent::Union{Tree1,Nothing}
          children::Vector{Tree1}
        end
        Tree1(val, parent = nothing) = Tree1(val, parent, [])
        AbstractTrees.parent(tree::Tree1) = tree.parent
        AbstractTrees.children(tree::Tree1) = tree.children
        AbstractTrees.nodevalue(tree::Tree1) = tree.val
        AbstractTrees.ChildIndexing(::Type{Tree1}) = IndexedChildren()
        Base.getindex(tree::Tree1, idx::Integer) = children(tree)[idx]
        Base.show(io::IO, tree::Tree1) = print(io, Tree1, '(', tree.val, ", ", tree.children, ')')
        Base.show(io::IO, ::MIME"text/plain", tree::Tree1) = print_tree(io, tree)

        tree_1 = Tree1(0)
        push!(tree_1.children, Tree1(1, tree_1), Tree1(2, tree_1))
        @test common_ancestor(tree_1.children) == tree_1

        (a, b) = tree_1.children
        push!(a.children, Tree1(3, a), Tree1(4, a), Tree1(5, a))
        push!(b.children, Tree1(6, b), Tree1(7, b))
        @test common_ancestor((a, b)) == tree_1
        @test common_ancestor((b[1], a[2], a[3])) == tree_1
        @test common_ancestor((tree_1, b[1], a[2], a[3])) == tree_1
      end

      function test_traversal(g)
        visited = Int[]
        scc = strongly_connected_components(g)
        for v in traverse(g)
          push!(visited, v)
          @test all(x -> in(x, visited) || begin
            idx = findfirst(v in c for c in scc)
            !isnothing(idx) && x in scc[idx]
          end, inneighbors(g, v))
        end
      end

      function test_completeness(tree, g)
        @test nodevalue(tree) == 1 && isroot(tree) && Set(nodevalue.(collect(PostOrderDFS(tree)))) == Set(1:nv(g))
        pdom = postdominator(g, 1)
        @test isnothing(pdom) || in(pdom, dominated_nodes(tree))

        dominated = Int[]
        for node in PostOrderDFS(tree)
          node == tree && continue
          push!(dominated, nodevalue(node))
        end
        @test sort(dominated) == 2:nv(g)
      end

      # All the following graphs are rooted in 1.

      # Symmetric diverge/merge point.
      g = DeltaGraph(4, 1 => 2, 1 => 3, 2 => 4, 3 => 4)
      tree = DominatorTree(g)
      test_completeness(tree, g)
      @test all(isempty ∘ children, children(tree)) && dominated_nodes(tree) == [2, 3, 4]
      @test postdominator(g, 1) == 4
      test_traversal(g)

      # No merge point, two sinks.
      g = DeltaGraph(4, 1 => 2, 1 => 3, 3 => 4)
      tree = DominatorTree(g)
      test_completeness(tree, g)
      @test dominated_nodes(tree) == [2, 3]
      @test dominated_nodes(tree[2]) == [4]
      @test isnothing(postdominator(g, 1))
      test_traversal(g)

      # Graph with a merge point that is the target of both a primary and a secondary branching construct (nested within the primary).
      g = DeltaGraph(6, 1 => 2, 1 => 3, 2 => 4, 2 => 5, 4 => 6, 5 => 6, 3 => 6)
      tree = DominatorTree(g)
      test_completeness(tree, g)
      @test dominated_nodes(tree) == [2, 3, 6]
      @test dominated_nodes(tree[1]) == [4, 5]
      @test postdominator(g, 1) == 6
      test_traversal(g)

      # Graph with a merge point dominated by a cycle.
      g = DeltaGraph(8, 1 => 2, 1 => 3, 2 => 4, 4 => 5, 4 => 7, 5 => 6, 6 => 4, 7 => 8, 3 => 8)
      tree = DominatorTree(g)
      test_completeness(tree, g)
      @test dominated_nodes(tree) == [2, 3, 8]
      @test dominated_nodes(tree[1]) == [4]
      @test dominated_nodes(tree[1][1]) == [5, 7]
      @test dominated_nodes(tree[1][1][1]) == [6]
      @test postdominator(g, 1) == 8
      test_traversal(g)

      # Graph with three sinks and a merge point dominated by branching construct wherein one branch is a sink.
      g = DeltaGraph(8, 1 => 2, 2 => 3, 2 => 4, 4 => 6, 1 => 5, 5 => 6, 6 => 7, 6 => 8)
      @test postdominator(g, 1) == 6
      @test postdominator(g, 2) == nothing
    end
  end
end;
