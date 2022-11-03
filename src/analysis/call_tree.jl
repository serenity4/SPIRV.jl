struct StaticCallTree
  ir::IR
  root::ResultID
end

AbstractTrees.ChildIndexing(::Type{StaticCallTree}) = IndexedChildren()
AbstractTrees.rootindex(call_tree::StaticCallTree) = call_tree.root

Base.getindex(call_tree::StaticCallTree, index::ResultID) = call_tree.ir.fdefs[index]

function AbstractTrees.childindices(call_tree::StaticCallTree, index::ResultID)
  children = Set{ResultID}()
  fdef = call_tree[index]
  for blk in fdef
    for ex in blk
      if ex.op == OpFunctionCall
        fid = ex[1]::ResultID
        if haskey(call_tree.ir.fdefs, fid)
          push!(children, fid)
        else
          # For a valid module, the called function must have been imported from another SPIR-V module.
          error("Not implemented")
        end
      end
    end
  end
  children
end

function dependent_functions(ir::IR, fid::ResultID)
  haskey(ir.fdefs, fid) || error("No function known for function id ", fid)
  unique(nodevalue(node) for node in PreOrderDFS(IndexNode(StaticCallTree(ir, fid))))
end

struct Frame
  ir::IR
  fid::ResultID
  block::ResultID
  instruction_index::Int
  parent_frames::Vector{Frame}
end

Frame(ir::IR, fid::ResultID, parent_frames = Frame[]) = Frame(ir, fid, first(keys(ir.fdefs[fid])), 1, parent_frames)

AbstractTrees.NodeType(::Type{Frame}) = Frame
AbstractTrees.ChildIndexing(::Type{Frame}) = IndexedChildren()

function AbstractTrees.children(frame::Frame)
  fdef = frame.ir.fdefs[frame.fid]
  ex = fdef[frame.block][frame.instruction_index]
  parent_frames = [frame.parent_frames; frame]

  # traverse_cfg(fdef)
  # if ex.op == OpFunctionCall
  #   (Frame(frame.ir, ex[1]::ResultID, parent_frames))
  # end
end
