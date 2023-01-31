"""
Add `Aligned` memory access operands to `Load` instructions that use a pointer associated with a physical storage buffer.
Which alignment will be used will depend on the provided `LayoutStrategy`.
"""
function add_align_operands!(ir::IR, fdef::FunctionDefinition, layout::LayoutStrategy)
  exs = body(fdef)
  for ex in exs
    @tryswitch opcode(ex) begin
      @case &OpLoad || &OpStore
      pointer_id = ex[1]::ResultID
      # Arguments will never be physical buffers.
      in(pointer_id, fdef.args) && continue
      def = @something(
        get(ir.global_vars, pointer_id, nothing),
        find_definition(pointer_id, fdef.local_vars),
        find_definition(pointer_id, exs),
        Some(nothing),
      )
      isnothing(def) && error("Could not retrieve definition for $pointer_id")
      pointer = def.type
      (; type, storage_class) = pointer
      if storage_class == StorageClassPhysicalStorageBuffer
        # We assume that no other storage class uses the pointer.
        push!(ex, MemoryAccessAligned, UInt32(alignment(layout, type)))
      end
      @case &OpFunctionCall
      # Recurse into function calls.
      callee = ir.fdefs[ex[1]::ResultID]
      add_align_operands!(ir, callee, layout)
    end
  end
  ir
end

function find_definition(id::ResultID, insts)
  idx = findfirst(has_result_id(id), insts)
  if !isnothing(idx)
    insts[idx]
  end
end

function enforce_calling_convention!(ir::IR, fdef::FunctionDefinition)
  exs = body(fdef)
  called = FunctionDefinition[]
  for ex in exs
    opcode(ex) == OpFunctionCall || continue
    callee = ir.fdefs[ex[1]::ResultID]
    !in(callee, called) && push!(called, callee)
    @assert length(ex) == length(argtypes(callee)) + 1
    for (arg, t) in zip(@view(ex[2:end]), argtypes(callee))
      arg.t::SPIRType == t && continue
      arg.t ≈ t || error("Types don't match between a function call and its defining function type: $(arg.t) ≉ $t")
      storage_class()
    end
  end
  for fdef in called
    # Recurse into function calls (but not more than once).
    enforce_calling_convention!(ir, called)
  end
  ir
end

argtypes(fdef::FunctionDefinition) = fdef.type.argtypes

"""
SPIR-V requires all branching nodes to give a result, while Julia does not if the Phi instructions
will never get used if coming from branches that are not covered.
We can make use of OpUndef to provide a value, producing it in the incoming nodes
just before branching to the node which defines an phi instructions.
"""
function fill_phi_branches!(ir::IR)
  for fdef in ir.fdefs
    cfg = ControlFlowGraph(fdef)
    for v in traverse(cfg)
      blk = fdef[v]
      exs = phi_expressions(blk)
      for ex in exs
        length(ex) == 2length(inneighbors(cfg, v)) && continue
        missing_branches = filter(u -> !in(fdef.block_ids[u], @view ex[2:2:end]), inneighbors(cfg, v))
        for u in missing_branches
          blkin = fdef[u]
          id = next!(ir.idcounter)
          insert!(blkin, lastindex(blkin), @ex id = OpUndef()::ex.type)
          push!(ex, id, fdef.block_ids[u])
        end
      end
    end
  end
  ir
end
