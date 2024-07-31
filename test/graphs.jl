using SPIRV: DeltaGraph
using SPIRV: REGION_BLOCK, REGION_IF_THEN, REGION_IF_THEN_ELSE, REGION_SWITCH, REGION_TERMINATION, REGION_PROPER, REGION_SELF_LOOP, REGION_WHILE_LOOP, REGION_NATURAL_LOOP, REGION_IMPROPER

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
"CFG with a loop and a merge block consisting of multiple sub-blocks."
g19() = DeltaGraph(1 => 2, 2 => 3, 3 => 2, 2 => 4, 4 => 5, 5 => 6)
"CFG with two loops, the inner merging at the continue target of the outer one."
g20() = DeltaGraph(1 => 2, 2 => 3, 2 => 4, 4 => 5, 5 => 6, 6 => 5, 5 => 7, 7 => 2)
"CFG with a proper region."
g21() = DeltaGraph(1 => 2, 2 => 3, 3 => 4, 4 => 5, 2 => 6, 4 => 6, 5 => 7, 6 => 7)
"Another CFG with a lattice-like proper region."
g22() = DeltaGraph(1 => 2, 2 => 3, 3 => 4, 3 => 5, 4 => 6, 5 => 6, 2 => 5)
"Large CFG with two large and nested proper regions."
g23() = DeltaGraph(1 => 2, 2 => 3, 2 => 4, 3 => 8, 3 => 6, 4 => 5, 4 => 6, 5 => 7, 6 => 7, 7 => 8, 8 => 9, 8 => 10, 9 => 19, 10 => 11, 10 => 12, 11 => 16, 12 => 13, 12 => 14, 13 => 15, 14 => 15, 15 => 16, 16 => 17, 16 => 18, 17 => 19, 18 => 20, 19 => 20)
"CFG with a proper region made of unstructured selections."
g24() = DeltaGraph(1 => 2, 2 => 3, 2 => 4, 3 => 4, 3 => 5, 4 => 6, 5 => 6)
