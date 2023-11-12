using SPIRV, Test, Graphs, AbstractTrees, MetaGraphs
using AbstractTrees: parent, nodevalue, Leaves
using SPIRV: traverse, postdominator, DominatorTree, common_ancestor, flow_through, AbstractInterpretation, InterpretationFrame, interpret, instructions, StackTrace, StackFrame, UseDefChain, EdgeClassification, backedges, dominators, node_index, cyclic_region, acyclic_region
using SPIRV: REGION_BLOCK, REGION_IF_THEN, REGION_IF_THEN_ELSE, REGION_CASE, REGION_TERMINATION, REGION_PROPER, REGION_SELF_LOOP, REGION_WHILE_LOOP, REGION_NATURAL_LOOP, REGION_IMPROPER

# All the following graphs are rooted in 1.

"Symmetric diverge/merge point."
g1() = DeltaGraph(1 => 2, 1 => 3, 2 => 4, 3 => 4)
"No merge point, two sinks."
g2() = DeltaGraph(1 => 2, 1 => 3, 3 => 4)
"Graph with a merge point that is the target of both a primary and a secondary branching construct (nested within the primary)."
g3() = DeltaGraph(1 => 2, 1 => 3, 2 => 4, 2 => 5, 4 => 6, 5 => 6, 3 => 6)
"Graph with a merge point dominated by a cycle."
g4() = DeltaGraph(1 => 2, 1 => 3, 2 => 4, 4 => 5, 4 => 7, 5 => 6, 6 => 4, 7 => 8, 3 => 8)
"Graph with three sinks and a merge point dominated by a branching construct wherein one branch is a sink."
g5() = DeltaGraph(1 => 2, 2 => 3, 2 => 4, 4 => 6, 1 => 5, 5 => 6, 6 => 7, 6 => 8)
"Graph with a simple source, a central vertex and a simple sink. The central vertex contains two separate loops with one having a symmetric branching construct inside."
g6() = DeltaGraph(1 => 2, 2 => 3, 3 => 4, 4 => 2, 2 => 5, 5 => 6, 5 => 7, 6 => 8, 7 => 8, 8 => 2, 2 => 9)
"Basic irreducible CFG."
g7() = DeltaGraph(1 => 2, 1 => 3, 2 => 3, 3 => 2, 2 => 4, 3 => 5)
"CFG from https://www.sable.mcgill.ca/~hendren/621/ControlFlowAnalysis_Handouts.pdf"
g8() = DeltaGraph(1 => 2, 2 => 3, 2 => 4, 3 => 4, 4 => 5, 5 => 4, 5 => 6, 5 => 7, 6 => 8, 7 => 8, 8 => 5, 8 => 9, 9 => 11, 11 => 8, 9 => 10, 10 => 2, 9 => 4)
"Entry node leading to a pure cycle between three nodes."
g9() = DeltaGraph(1 => 2, 2 => 3, 3 => 4, 4 => 2)
"CFG with a branch between a loop and a termination node from a node dominating a loop, with that loop otherwise dominating the termination node."
g10() = DeltaGraph(1 => 2, 1 => 4, 2 => 3, 3 => 2, 3 => 4)
"CFG with two nested `if-else` constructs pointing to a single common merge block."
g11() = DeltaGraph(1 => 2, 2 => 3, 2 => 4, 3 => 5, 4 => 5, 1 => 6, 6 => 5)
"CFG with a conditional which multiple block regions before the header."
g12() = DeltaGraph(1 => 2, 2 => 3, 3 => 4, 4 => 5, 4 => 6, 5 => 7, 6 => 7)
"CFG with a loop which contains multiple block regions before the header."
g13() = DeltaGraph(1 => 2, 2 => 3, 3 => 4, 4 => 5, 5 => 6, 6 => 4, 6 => 7)
"CFG with a loop and a selection both nested at the same level with the same merge points inside a selection."
g14() = DeltaGraph(1 => 5, 5 => 2, 5 => 6, 1 => 3, 2 => 4, 4 => 2, 2 => 3)
"CFG with an `if-else` statement comprising two nested `if-else` statements, all three sharing the same merge block."
g15() = DeltaGraph(1 => 2, 1 => 3, 2 => 4, 2 => 5, 3 => 6, 3 => 7, 4 => 8, 5 => 8, 6 => 8, 7 => 8)
"CFG with three nested `if-else` statements sharing the same merge block."
g16() = DeltaGraph(1 => 2, 1 => 8, 2 => 3, 2 => 4, 3 => 5, 3 => 6, 5 => 7, 6 => 7, 4 => 7, 8 => 7)
"Straight CFG with a loop in the middle, where the loop merge is reachable from the loop header. Used to make sure that we don't create a termination region involving the loop header and that we don't treat the loop as the final element of the CFG."
g17() = DeltaGraph(1 => 2, 2 => 3, 3 => 4, 4 => 2, 2 => 5, 5 => 6)
"CFG with a loop whose header branches to two blocks that are not the continue target or merge block."
g18() = DeltaGraph(1 => 2, 2 => 3, 2 => 4, 3 => 5, 4 => 5, 5 => 6, 5 => 2)

test_coverage(g::AbstractGraph, ctree::ControlTree) = Set([node_index(c) for c in Leaves(ctree)]) == Set(vertices(g))

function test_traversal(cfg::ControlFlowGraph)
  visited = Int[]
  scc = strongly_connected_components(cfg)
  for v in traverse(cfg)
    push!(visited, v)
    @test all(x -> in(x, visited) || begin
      idx = findfirst(v in c for c in scc)
      !isnothing(idx) && x in scc[idx]
    end, inneighbors(cfg, v))
  end
end

function test_completeness(tree::DominatorTree, cfg::ControlFlowGraph)
  @test node_index(tree) == 1 && isroot(tree) && Set(node_index.(collect(PostOrderDFS(tree)))) == Set(1:nv(cfg))
  pdom = postdominator(cfg, 1)
  @test isnothing(pdom) || in(pdom, immediate_postdominators(tree))

  dominated = Int[]
  for dom in PostOrderDFS(tree)
    dom == tree && continue
    @test !isnothing(parent(dom))
    push!(dominated, node_index(dom))
  end
  @test sort(dominated) == 2:nv(cfg)
end

@testset "Function analysis" begin
  @testset "Static call graph traversal" begin
    ir = IR(SPIRV.Module(resource("comp.spv")); satisfy_requirements = false)
    fdefs = dependent_functions(ir, ResultID(4)) # main

    @test Set(fdefs) == Set(ir.fdefs)

    plane_intersect = ir.fdefs[ResultID(46)]
    fdefs = dependent_functions(ir, ResultID(46)) # planeIntersect
    @test fdefs == [ir.fdefs[ResultID(46)]]

    fdefs = dependent_functions(ir, ResultID(71)) # renderScene
    @test length(fdefs) == 10
    main = ir.fdefs[ResultID(4)]
    @test !in(main, fdefs)
  end

  @testset "Control flow graph" begin
    @testset "Tree utilities" begin
      struct Tree1
        val::Int
        parent::Union{Tree1,Nothing}
        children::Vector{Tree1}
      end
      Base.:(==)(a::Tree1, b::Tree1) = a.val == b.val && a.children == b.children && a.parent === b.parent
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

    @testset "Edge classification" begin
      ec = EdgeClassification(g1())
      @test isempty(ec.retreating_edges)
      @test isempty(ec.forward_edges)
      @test length(ec.cross_edges) == 1
      @test length(ec.tree_edges) == 3
      
      ec = EdgeClassification(g2())
      @test isempty(ec.retreating_edges)
      @test isempty(ec.forward_edges)
      @test isempty(ec.cross_edges)
      @test length(ec.tree_edges) == 3

      ec = EdgeClassification(g3())
      @test isempty(ec.retreating_edges)
      @test isempty(ec.forward_edges)
      @test length(ec.cross_edges) == 2
      @test length(ec.tree_edges) == 5

      ec = EdgeClassification(g4())
      @test ec.retreating_edges == Set([Edge(6 => 4)])
      @test isempty(ec.forward_edges)
      @test length(ec.cross_edges) == 1
      @test length(ec.tree_edges) == 7

      ec = EdgeClassification(g5())
      @test isempty(ec.retreating_edges)
      @test isempty(ec.forward_edges)
      @test length(ec.cross_edges) == 1
      @test length(ec.tree_edges) == 7

      ec = EdgeClassification(g6())
      @test ec.retreating_edges == Set(Edge.([4 => 2, 8 => 2]))
      @test isempty(ec.forward_edges)
      @test length(ec.cross_edges) == 1
      @test length(ec.tree_edges) == 8

      ec = EdgeClassification(g7())
      @test length(ec.retreating_edges) == 1
      @test length(ec.forward_edges) == 1
      @test length(ec.cross_edges) == 0
      @test length(ec.tree_edges) == 4

      ec = EdgeClassification(g8())
      @test length(ec.retreating_edges) == 5
      @test length(ec.forward_edges) == 1
      @test length(ec.cross_edges) == 1
      @test length(ec.tree_edges) == 10
    end

    @testset "Dominators" begin
      @test dominators(g8()) == [
        Set([1]),
        Set([1, 2]),
        Set([1, 2, 3]),
        Set([1, 2, 4]),
        Set([1, 2, 4, 5]),
        Set([1, 2, 4, 5, 6]),
        Set([1, 2, 4, 5, 7]),
        Set([1, 2, 4, 5, 8]),
        Set([1, 2, 4, 5, 8, 9]),
        Set([1, 2, 4, 5, 8, 9, 10]),
        Set([1, 2, 4, 5, 8, 9, 11]),
      ]
    end

    @testset "Back-edges" begin
      @test Set(SPIRV.backedges(g8())) == Set(Edge.([
        10 => 2,
        5 => 4,
        9 => 4,
        8 => 5,
        11 => 8,
      ]))
    end

    @testset "Structural analysis" begin
      @testset "Regions" begin
        g = DeltaGraph(2, 1 => 2)
        @test acyclic_region(g, 2) == (REGION_BLOCK, [1, 2])
        g = DeltaGraph(3, 1 => 2, 2 => 3)
        @test acyclic_region(g, 2) == (REGION_BLOCK, [1, 2, 3])

        g = DeltaGraph(3, 1 => 3, 1 => 2, 2 => 3)
        @test acyclic_region(g, 1) == (REGION_IF_THEN, [1, 2])

        g = DeltaGraph(4, 1 => 2, 1 => 3, 2 => 4, 3 => 4)
        @test acyclic_region(g, 1) == (REGION_IF_THEN_ELSE, [1, 2, 3])

        g = DeltaGraph(5, 1 => 2, 1 => 3, 1 => 4, 2 => 5, 3 => 5, 4 => 5)
        @test acyclic_region(g, 1) == (REGION_CASE, [1, 2, 3, 4, 5])

        g = DeltaGraph(3, 1 => 2, 1 => 3)
        @test acyclic_region(g, 1) == (REGION_TERMINATION, [1, 2, 3])

        g = DeltaGraph(4, 1 => 2, 1 => 3, 1 => 4)
        @test acyclic_region(g, 1) == (REGION_TERMINATION, [1, 2, 3, 4])

        g = DeltaGraph(4, 1 => 2, 2 => 3, 2 => 4, 3 => 2)
        @test cyclic_region(g, 2) == (REGION_WHILE_LOOP, [2, 3])

        g = DeltaGraph(5, 1 => 2, 2 => 3, 3 => 4, 4 => 2, 2 => 5)
        @test acyclic_region(g, 2) == (REGION_TERMINATION, [2, 5])
        @test cyclic_region(g, 2) == (REGION_NATURAL_LOOP, [2, 3, 4])
        @test acyclic_region(g, 3) == (REGION_BLOCK, [3, 4])
      end

      @testset "Control trees" begin
        g = g1()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_IF_THEN_ELSE, [
            ControlTree(1, REGION_BLOCK),
            ControlTree(2, REGION_BLOCK),
            ControlTree(3, REGION_BLOCK),
          ]),
          ControlTree(4, REGION_BLOCK),
        ])

        g = g2()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_TERMINATION, (
          ControlTree(1, REGION_BLOCK),
          ControlTree(2, REGION_BLOCK),
          ControlTree(3, REGION_BLOCK, [
            ControlTree(3, REGION_BLOCK),
            ControlTree(4, REGION_BLOCK),
          ]),
        ))

        g = g3()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_IF_THEN_ELSE, [
            ControlTree(1, REGION_BLOCK),
            ControlTree(2, REGION_IF_THEN_ELSE, [
              ControlTree(2, REGION_BLOCK),
              ControlTree(4, REGION_BLOCK),
              ControlTree(5, REGION_BLOCK),
            ]),
            ControlTree(3, REGION_BLOCK),
          ]),
          ControlTree(6, REGION_BLOCK),
        ])

        g = g4()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_IF_THEN_ELSE, [
            ControlTree(1, REGION_BLOCK),
            ControlTree(2, REGION_BLOCK, [
              ControlTree(2, REGION_BLOCK),
              ControlTree(4, REGION_WHILE_LOOP, [
                ControlTree(4, REGION_BLOCK),
                ControlTree(5, REGION_BLOCK, [
                  ControlTree(5, REGION_BLOCK),
                  ControlTree(6, REGION_BLOCK),
                ]),
              ]),
              ControlTree(7, REGION_BLOCK),
            ]),
            ControlTree(3, REGION_BLOCK),
          ]),
          ControlTree(8, REGION_BLOCK),
        ])

        g = g5()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_IF_THEN_ELSE, [
            ControlTree(1, REGION_BLOCK),
            ControlTree(2, REGION_BLOCK, [
              ControlTree(2, REGION_TERMINATION, [
                ControlTree(2, REGION_BLOCK),
                ControlTree(3, REGION_BLOCK),
              ]),
              ControlTree(4, REGION_BLOCK)
            ]),
            ControlTree(5, REGION_BLOCK),
          ]),
          ControlTree(6, REGION_TERMINATION, [
            ControlTree(6, REGION_BLOCK),
            ControlTree(7, REGION_BLOCK),
            ControlTree(8, REGION_BLOCK),
          ]),
        ])

        g = g6()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_BLOCK),
          ControlTree(2, REGION_NATURAL_LOOP, [
            ControlTree(2, REGION_TERMINATION, [
              ControlTree(2, REGION_BLOCK),
              ControlTree(9, REGION_BLOCK),
            ]),
            ControlTree(3, REGION_BLOCK, [
              ControlTree(3, REGION_BLOCK),
              ControlTree(4, REGION_BLOCK),
            ]),
            ControlTree(5, REGION_BLOCK, [
              ControlTree(5, REGION_IF_THEN_ELSE, [
                ControlTree(5, REGION_BLOCK),
                ControlTree(6, REGION_BLOCK),
                ControlTree(7, REGION_BLOCK),
              ]),
              ControlTree(8, REGION_BLOCK),
            ]),
          ]),
        ])

        g = g7()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_IMPROPER, [
          ControlTree(1, REGION_BLOCK),
          ControlTree(2, REGION_TERMINATION, [
            ControlTree(2, REGION_BLOCK),
            ControlTree(4, REGION_BLOCK),
          ]),
          ControlTree(3, REGION_TERMINATION, [
            ControlTree(3, REGION_BLOCK),
            ControlTree(5, REGION_BLOCK),
          ]),
        ])

        g = g8()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_BLOCK),
          ControlTree(2, REGION_NATURAL_LOOP, [
            ControlTree(2, REGION_IF_THEN, [
              ControlTree(2, REGION_BLOCK),
              ControlTree(3, REGION_BLOCK),
            ]),
            ControlTree(4, REGION_NATURAL_LOOP, [
              ControlTree(4, REGION_BLOCK),
              ControlTree(5, REGION_NATURAL_LOOP, [
                ControlTree(5, REGION_BLOCK),
                ControlTree(6, REGION_BLOCK),
                ControlTree(7, REGION_BLOCK),
                ControlTree(8, REGION_NATURAL_LOOP, [
                  ControlTree(8, REGION_BLOCK),
                  ControlTree(9, REGION_BLOCK),
                  ControlTree(11, REGION_BLOCK),
                ]),
              ]),
            ]),
            ControlTree(10, REGION_BLOCK),
          ]),
        ])

        g = g9()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_BLOCK),
          ControlTree(2, REGION_NATURAL_LOOP, [
            ControlTree(2, REGION_BLOCK),
            ControlTree(3, REGION_BLOCK, [
              ControlTree(3, REGION_BLOCK),
              ControlTree(4, REGION_BLOCK),
            ]),
          ]),
        ])

        g = g10()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_IF_THEN, [
            ControlTree(1, REGION_BLOCK),
            ControlTree(2, REGION_NATURAL_LOOP, [
              ControlTree(2, REGION_BLOCK),
              ControlTree(3, REGION_BLOCK),
            ]),
          ]),
          ControlTree(4, REGION_BLOCK),
        ])

        g = g11()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_IF_THEN_ELSE, [
            ControlTree(1, REGION_BLOCK),
            ControlTree(2, REGION_IF_THEN_ELSE, [
              ControlTree(2, REGION_BLOCK),
              ControlTree(3, REGION_BLOCK),
              ControlTree(4, REGION_BLOCK),
            ]),
            ControlTree(6, REGION_BLOCK),
          ]),
          ControlTree(5, REGION_BLOCK),
        ])

        g = g11()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_IF_THEN_ELSE, [
            ControlTree(1, REGION_BLOCK),
            ControlTree(2, REGION_IF_THEN_ELSE, [
              ControlTree(2, REGION_BLOCK),
              ControlTree(3, REGION_BLOCK),
              ControlTree(4, REGION_BLOCK),
            ]),
            ControlTree(6, REGION_BLOCK),
          ]),
          ControlTree(5, REGION_BLOCK),
        ])

        g = g12()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_BLOCK),
          ControlTree(2, REGION_BLOCK),
          ControlTree(3, REGION_BLOCK),
          ControlTree(4, REGION_IF_THEN_ELSE, [
            ControlTree(4, REGION_BLOCK),
            ControlTree(5, REGION_BLOCK),
            ControlTree(6, REGION_BLOCK),
          ]),
          ControlTree(7, REGION_BLOCK),
        ])

        g = g13()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_BLOCK),
          ControlTree(2, REGION_BLOCK),
          ControlTree(3, REGION_BLOCK),
          ControlTree(4, REGION_NATURAL_LOOP, [
            ControlTree(4, REGION_BLOCK),
            ControlTree(5, REGION_BLOCK),
            ControlTree(6, REGION_BLOCK),
          ]),
          ControlTree(7, REGION_BLOCK),
        ])

        g = g15()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_IF_THEN_ELSE, [
            ControlTree(1, REGION_BLOCK),
            ControlTree(2, REGION_IF_THEN_ELSE, [
              ControlTree(2, REGION_BLOCK),
              ControlTree(4, REGION_BLOCK),
              ControlTree(5, REGION_BLOCK),
            ]),
            ControlTree(3, REGION_IF_THEN_ELSE, [
              ControlTree(3, REGION_BLOCK),
              ControlTree(6, REGION_BLOCK),
              ControlTree(7, REGION_BLOCK),
            ]),
          ]),
          ControlTree(8, REGION_BLOCK),
        ])

        g = g16()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_IF_THEN_ELSE, [
            ControlTree(1, REGION_BLOCK),
            ControlTree(2, REGION_IF_THEN_ELSE, [
              ControlTree(2, REGION_BLOCK),
              ControlTree(3, REGION_IF_THEN_ELSE, [
                ControlTree(3, REGION_BLOCK),
                ControlTree(5, REGION_BLOCK),
                ControlTree(6, REGION_BLOCK),
              ]),
              ControlTree(4, REGION_BLOCK),
            ]),
            ControlTree(8, REGION_BLOCK),
          ]),
          ControlTree(7, REGION_BLOCK),
        ])

        g = g17()
        ctree = ControlTree(g)
        test_coverage(g, ctree)
        @test_broken ctree == ControlTree(1, REGION_BLOCK, [
          ControlTree(1, REGION_BLOCK),
          ControlTree(2, REGION_NATURAL_LOOP, [
            ControlTree(2, REGION_BLOCK),
            ControlTree(3, REGION_BLOCK),
            ControlTree(4, REGION_BLOCK),
            ]),
          ControlTree(5, REGION_BLOCK),
          ControlTree(6, REGION_BLOCK),
        ])
      end
    end

    cfg = ControlFlowGraph(g1())
    @test cfg.is_reducible
    @test cfg.is_structured
    tree = DominatorTree(cfg)
    test_completeness(tree, cfg)
    @test all(isempty ∘ children, children(tree)) && immediate_postdominators(tree) == [2, 3, 4]
    @test postdominator(cfg, 1) == 4
    test_traversal(cfg)

    cfg = ControlFlowGraph(g2())
    @test cfg.is_reducible
    @test cfg.is_structured
    tree = DominatorTree(cfg)
    test_completeness(tree, cfg)
    @test immediate_postdominators(tree) == [2, 3]
    @test immediate_postdominators(tree[2]) == [4]
    @test isnothing(postdominator(cfg, 1))
    test_traversal(cfg)

    cfg = ControlFlowGraph(g3())
    @test cfg.is_reducible
    @test cfg.is_structured
    tree = DominatorTree(cfg)
    test_completeness(tree, cfg)
    @test immediate_postdominators(tree) == [2, 3, 6]
    @test immediate_postdominators(tree[1]) == [4, 5]
    @test postdominator(cfg, 1) == 6
    test_traversal(cfg)

    cfg = ControlFlowGraph(g4())
    @test cfg.is_reducible
    @test cfg.is_structured
    tree = DominatorTree(cfg)
    test_completeness(tree, cfg)
    @test immediate_postdominators(tree) == [2, 3, 8]
    @test immediate_postdominators(tree[1]) == [4]
    @test immediate_postdominators(tree[1][1]) == [5, 7]
    @test immediate_postdominators(tree[1][1][1]) == [6]
    @test postdominator(cfg, 1) == 8
    test_traversal(cfg)

    cfg = ControlFlowGraph(g5())
    @test cfg.is_reducible
    @test cfg.is_structured
    @test postdominator(cfg, 1) == 6
    @test isnothing(postdominator(cfg, 2))

    cfg = ControlFlowGraph(g6())
    tree = DominatorTree(cfg)
    test_completeness(tree, cfg)
    @test cfg.is_reducible
    @test cfg.is_structured

    cfg = ControlFlowGraph(g7())
    tree = DominatorTree(cfg)
    test_completeness(tree, cfg)
    @test !cfg.is_reducible

    for i in 8:13
      f = getproperty(@__MODULE__, Symbol(:g, i))
      cfg = ControlFlowGraph(f())
      tree = DominatorTree(cfg)
      test_completeness(tree, cfg)
      @test cfg.is_reducible
    end
  end

  @testset "Flow analysis" begin
    "Record traversed edges, annotating them with the number of times they were traversed."
    function make_analyze_f1(g, mapping)
      function analyze_f1(e)
        for v in (src(e), dst(e))
          !haskey(mapping, v) || continue
          add_vertex!(g) && (mapping[v] = nv(g))
        end
        e = Edge(mapping[src(e)], mapping[dst(e)])
        if has_edge(g, e)
          get_prop(g, e, :count) < 3 || return false
          set_prop!(g, e, :count, get_prop(g, e, :count) + 1)
        else
          add_edge!(g, e)
          set_prop!(g, e, :count, 1)
          true
        end
      end
    end

    mapping = Dict()
    mg = MetaDiGraph()
    cfg = ControlFlowGraph(g1())
    flow_through(make_analyze_f1(mg, mapping), cfg, 1)
    @test all(k == v for (k, v) in mapping)
    @test !is_cyclic(cfg) && all(get_prop(mg, e, :count) == 1 for e in edges(mg))

    mapping = Dict()
    mg = MetaDiGraph()
    cfg = ControlFlowGraph(g2())
    flow_through(make_analyze_f1(mg, mapping), cfg, 1)
    @test all(k == v for (k, v) in mapping)
    @test !is_cyclic(cfg) && all(get_prop(mg, e, :count) == 1 for e in edges(mg))

    mapping = Dict()
    mg = MetaDiGraph()
    cfg = ControlFlowGraph(g3())
    flow_through(make_analyze_f1(mg, mapping), cfg, 1)
    @test all(k == v for (k, v) in mapping)
    @test !is_cyclic(cfg) && all(get_prop(mg, e, :count) == 1 for e in edges(mg))

    mapping = Dict()
    mg = MetaDiGraph()
    cfg = ControlFlowGraph(g4())
    flow_through(make_analyze_f1(mg, mapping), cfg, 1)
    @test Set(keys(mapping)) == Set(values(mapping)) == Set(1:nv(cfg))
    edges_nocycle = [Edge(mapping[src(e)], mapping[dst(e)]) for e in Edge.([1 => 2, 1 => 3, 2 => 4, 3 => 8])]
    @test all(get_prop(mg, e, :count) == 1 for e in edges_nocycle)
    edges_cycle = filter(!in(edges_nocycle), collect(edges(mg)))
    @test all(get_prop(mg, e, :count) == 3 for e in edges_cycle)

    mapping = Dict()
    mg = MetaDiGraph()
    cfg = ControlFlowGraph(g5())
    flow_through(make_analyze_f1(mg, mapping), cfg, 1)
    @test Set(keys(mapping)) == Set(values(mapping)) == Set(1:nv(cfg))
    @test !is_cyclic(cfg) && all(get_prop(mg, e, :count) == 1 for e in edges(mg))

    mapping = Dict()
    mg = MetaDiGraph()
    cfg = ControlFlowGraph(g6())
    flow_through(make_analyze_f1(mg, mapping), cfg, 1)
    @test Set(keys(mapping)) == Set(values(mapping)) == Set(1:nv(cfg))
    edges_nocycle = [Edge(mapping[src(e)], mapping[dst(e)]) for e in Edge.([1 => 2])]
    @test all(get_prop(mg, e, :count) == 1 for e in edges_nocycle)
    edges_cycle = filter(!in(edges_nocycle), collect(edges(mg)))
    @test all(get_prop(mg, e, :count) == 3 for e in edges_cycle)
  end

  @testset "Abstract interpretation" begin
    recorded = Instruction[]
    observe_instructions(interpret::AbstractInterpretation, frame::InterpretationFrame) = nothing
    function observe_instructions(interpret::AbstractInterpretation, frame::InterpretationFrame, inst::Instruction)
      interpret.stop = in(inst, recorded)
      push!(recorded, inst)
    end
    amod = annotate(load_module("single_block"))
    af = only(amod.annotated_functions)
    interpret(observe_instructions, amod, af)
    @test recorded == instructions(amod, only(af.blocks))

    empty!(recorded)
    amod = annotate(load_module("function_call"))
    af1, af2 = amod.annotated_functions
    interpret(observe_instructions, amod, af1)
    block_start, block_end = extrema(only(af1.blocks))
    @test recorded == [instructions(amod, block_start:(block_start + 2)); instructions(amod, only(af2.blocks)); instructions(amod, (block_start + 3):block_end)]
  end

  @testset "Use-def chains" begin
    amod = annotate(load_module("single_block"))
    iadd = ResultID(9)
    st = StackTrace()
    chain = UseDefChain(amod, only(amod.annotated_functions), iadd, st)
    @test chain.use == amod[iadd]
    @test nodevalue.(chain.defs) == getindex.(amod, [ResultID(6), ResultID(7)])
    fadd = ResultID(11)
    chain = UseDefChain(amod, only(amod.annotated_functions), fadd, st)
    @test nodevalue.(chain.defs) == getindex.(amod, [ResultID(10), ResultID(3)])
    @test nodevalue.(Leaves(chain)) == getindex.(amod, [ResultID(6), ResultID(7), ResultID(3)])

    amod = annotate(load_module("function_call"))
    isub = ResultID(18)
    st = StackTrace([StackFrame(amod, ResultID(11))])
    chain = UseDefChain(amod, amod.annotated_functions[2], isub, st)
    @test chain.use == amod[isub]
    @test nodevalue.(chain.defs) == getindex.(amod, [ResultID(7), ResultID(8)])

    amod = annotate(load_module("simple_conditional"))
    fadd = ResultID(16)
    st = StackTrace()
    # chain = UseDefChain(amod, only(amod.annotated_functions), fadd, st)
    # @test nodevalue.(Leaves(chain)) == getindex.(amod, [ResultID(8), ResultID(9), ResultID(4)])
    # @test nodevalue.(chain.defs) == getindex.(amod, [ResultID(15), ResultID(4)])

    # FIXME: back-edges for `reverse(control_flow_graph(amod, only(amod.annotated_functions)))` seem off.
    # We get that almost all edges (or all) are back-edges, which should not be the case even for a reverse CFG.
    # amod = annotate(load_module("simple_loop.jl"))
    # iadd = ResultID(30)
    # st = StackTrace()
    # g = reverse(ControlFlowGraph(amod, only(amod.annotated_functions)).g)
    # plotgraph(g)
    # SPIRV.backedges(g, 3)

    # chain = UseDefChain(amod, only(amod.annotated_functions), iadd, st)
    # @test nodevalue.(Leaves(chain)) == getindex.(amod, [ResultID(8), ResultID(9), ResultID(4)])
    # @test nodevalue.(chain.defs) == getindex.(amod, [ResultID(15), ResultID(4)])
  end
end;
