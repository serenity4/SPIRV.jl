using SPIRV, Test, Graphs, AbstractTrees, AutoHashEquals, MetaGraphs
using AbstractTrees: parent, nodevalue, Leaves
using SPIRV: traverse, postdominator, DominatorTree, common_ancestor, dominated_nodes, dominator, flow_through, AbstractInterpretation, InterpretationFrame, interpret, instructions, StackTrace, StackFrame, UseDefChain

function program_1(x)
  @noinline 2U * x
end

function program_2(x)
  z = @noinline 2U + x - 1U
  @noinline program_1(z)
end

function program_3(x)
  if x > 3U
    x = 45U
  end
  x + 2U
end

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

  # All the following graphs are rooted in 1.

  # Symmetric diverge/merge point.
  g1() = DeltaGraph(4, 1 => 2, 1 => 3, 2 => 4, 3 => 4)
  # No merge point, two sinks.
  g2() = DeltaGraph(4, 1 => 2, 1 => 3, 3 => 4)
  # Graph with a merge point that is the target of both a primary and a secondary branching construct (nested within the primary).
  g3() = DeltaGraph(6, 1 => 2, 1 => 3, 2 => 4, 2 => 5, 4 => 6, 5 => 6, 3 => 6)
  # Graph with a merge point dominated by a cycle.
  g4() = DeltaGraph(8, 1 => 2, 1 => 3, 2 => 4, 4 => 5, 4 => 7, 5 => 6, 6 => 4, 7 => 8, 3 => 8)
  # Graph with three sinks and a merge point dominated by a branching construct wherein one branch is a sink.
  g5() = DeltaGraph(8, 1 => 2, 2 => 3, 2 => 4, 4 => 6, 1 => 5, 5 => 6, 6 => 7, 6 => 8)
  # Graph with a simple source, a central vertex and a simple sink. The central vertex contains two separate loops with one having a symmetric branching construct inside.
  g6() = DeltaGraph(9, 1 => 2, 2 => 3, 3 => 4, 4 => 2, 2 => 5, 5 => 6, 5 => 7, 6 => 8, 7 => 8, 8 => 2, 2 => 9)

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

      g = g1()
      tree = DominatorTree(g)
      test_completeness(tree, g)
      @test all(isempty ∘ children, children(tree)) && dominated_nodes(tree) == [2, 3, 4]
      @test postdominator(g, 1) == 4
      test_traversal(g)

      g = g2()
      tree = DominatorTree(g)
      test_completeness(tree, g)
      @test dominated_nodes(tree) == [2, 3]
      @test dominated_nodes(tree[2]) == [4]
      @test isnothing(postdominator(g, 1))
      test_traversal(g)

      g = g3()
      tree = DominatorTree(g)
      test_completeness(tree, g)
      @test dominated_nodes(tree) == [2, 3, 6]
      @test dominated_nodes(tree[1]) == [4, 5]
      @test postdominator(g, 1) == 6
      test_traversal(g)

      g = g4()
      tree = DominatorTree(g)
      test_completeness(tree, g)
      @test dominated_nodes(tree) == [2, 3, 8]
      @test dominated_nodes(tree[1]) == [4]
      @test dominated_nodes(tree[1][1]) == [5, 7]
      @test dominated_nodes(tree[1][1][1]) == [6]
      @test postdominator(g, 1) == 8
      test_traversal(g)

      g = g5()
      @test postdominator(g, 1) == 6
      @test postdominator(g, 2) == nothing
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
    g = g1()
    flow_through(make_analyze_f1(mg, mapping), g, 1)
    @test all(k == v for (k, v) in mapping)
    @test !is_cyclic(g) && all(get_prop(mg, e, :count) == 1 for e in edges(mg))

    mapping = Dict()
    mg = MetaDiGraph()
    g = g2()
    flow_through(make_analyze_f1(mg, mapping), g, 1)
    @test all(k == v for (k, v) in mapping)
    @test !is_cyclic(g) && all(get_prop(mg, e, :count) == 1 for e in edges(mg))

    mapping = Dict()
    mg = MetaDiGraph()
    g = g3()
    flow_through(make_analyze_f1(mg, mapping), g, 1)
    @test all(k == v for (k, v) in mapping)
    @test !is_cyclic(g) && all(get_prop(mg, e, :count) == 1 for e in edges(mg))

    mapping = Dict()
    mg = MetaDiGraph()
    g = g4()
    flow_through(make_analyze_f1(mg, mapping), g, 1)
    @test Set(keys(mapping)) == Set(values(mapping)) == Set(1:nv(g))
    edges_nocycle = [Edge(mapping[src(e)], mapping[dst(e)]) for e in Edge.([1 => 2, 1 => 3, 2 => 4, 3 => 8])]
    @test all(get_prop(mg, e, :count) == 1 for e in edges_nocycle)
    edges_cycle = filter(!in(edges_nocycle), collect(edges(mg)))
    @test all(get_prop(mg, e, :count) == 3 for e in edges_cycle)

    mapping = Dict()
    mg = MetaDiGraph()
    g = g5()
    flow_through(make_analyze_f1(mg, mapping), g, 1)
    @test Set(keys(mapping)) == Set(values(mapping)) == Set(1:nv(g))
    @test !is_cyclic(g) && all(get_prop(mg, e, :count) == 1 for e in edges(mg))

    mapping = Dict()
    mg = MetaDiGraph()
    g = g6()
    flow_through(make_analyze_f1(mg, mapping), g, 1)
    @test Set(keys(mapping)) == Set(values(mapping)) == Set(1:nv(g))
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
    mod = SPIRV.Module(resource("vert.spv"))
    amod = annotate(mod)
    af = only(amod.annotated_functions)
    interpret(observe_instructions, amod, af)
    @test recorded == instructions(amod, only(af.blocks))

    empty!(recorded)
    ir = @compile program_1(::UInt32)
    mod = SPIRV.Module(ir)
    amod = annotate(mod)
    af1, af2 = amod.annotated_functions
    interpret(observe_instructions, amod, af1)
    @test SPIRV.opcode.(recorded) == [SPIRV.OpLabel, SPIRV.OpFunctionCall, SPIRV.OpLabel, SPIRV.OpIMul, SPIRV.OpReturnValue, SPIRV.OpReturnValue]
  end

  @testset "Use-def chains" begin
    ir = @compile +(::UInt32, ::UInt32)
    amod = annotate(SPIRV.Module(ir))
    iadd = SSAValue(7)
    st = StackTrace()
    chain = UseDefChain(amod, only(amod.annotated_functions), iadd, st)
    @test chain.use == amod[iadd]
    @test nodevalue.(chain.defs) == getindex.(amod, [SSAValue(4), SSAValue(5)])

    ir = @compile program_1(::UInt32)
    amod = annotate(SPIRV.Module(ir))
    imul = SSAValue(11)
    st = StackTrace([StackFrame(16, 1)])
    chain = UseDefChain(amod, amod.annotated_functions[2], imul, st)
    @test chain.use == amod[imul]
    @test nodevalue.(chain.defs) == getindex.(amod, [SSAValue(4), SSAValue(12)])

    ir = @compile program_2(::UInt32)
    amod = annotate(SPIRV.Module(ir))
    imul = SSAValue(28)
    st = StackTrace([StackFrame(27, 1), StackFrame(47, lastindex(amod.annotated_functions) - 1)])
    chain = UseDefChain(amod, last(amod.annotated_functions), imul, st)
    @test chain.use == amod[imul]
    @test Set(nodevalue.(Leaves(chain))) == Set([
      @inst(SSAValue(19) = SPIRV.OpConstant(1U)::SSAValue(1)),
      @inst(SSAValue(12) = SPIRV.OpConstant(2U)::SSAValue(1)),
      @inst(SSAValue(4) = SPIRV.OpFunctionParameter()::SSAValue(1)),
    ])

    # TODO: Test with functions that exhibit a nontrivial control-flow.
  end
end;
