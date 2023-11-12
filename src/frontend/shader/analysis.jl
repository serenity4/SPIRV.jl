struct MemoryResourceExtraction
  conversions::ResultDict{Instruction}
  loaded_addresses::ResultDict{InterpretationFrame}
  resources::ResultDict{MemoryResource}
end

MemoryResourceExtraction() = MemoryResourceExtraction(ResultDict(), Set(), ResultDict())

function (extract::MemoryResourceExtraction)(interpret::AbstractInterpretation, frame::InterpretationFrame)
  nothing
end

function (extract::MemoryResourceExtraction)(interpret::AbstractInterpretation, frame::InterpretationFrame, inst::Instruction)
  @tryswitch opcode(inst) begin
    @case &OpConvertUToPtr
    if !in(inst, extract.conversions)
      insert!(extract.conversions, inst.result_id, inst)
    else
      interpret.converged = true
    end

    @case &OpLoad || &OpAccessChain
    # TODO: Use a def-use chain to make it more robust.
    # For example, one may pass the pointer to a function call
    # and a different ID (associated with an `OpFunctionParameter`) would be used as operand.
    loaded = inst.arguments[1]::ResultID
    c = get(extract.conversions, loaded, nothing)
    !isnothing(c) && insert!(extract.loaded_addresses, c.arguments[1]::ResultID, frame)
  end
end

function memory_resources(ir::IR, fid::ResultID)
  memory_resources = ResultDict{MemoryResource}()
  return memory_resources
  fdef = ir.fdefs[fid]

  #=

  Query:

  Find all defining variables for loaded pointers originating from a conversion from an unsigned integer.

  1. Find pointers that:
    - Are the target of `OpLoad` or `OpAccessChain` instructions.
    - Are traceable to the result of a conversion converted from an unsigned integer.
  2. Iterate through their root variable, by propagating through (standard) pointer instructions and unsigned integer operations that involve constant arguments besides the defining variable.

  =#

  extract = MemoryResourceExtraction()
  interpret(extract, amod, af)
  chains = UseDefChain[]
  for (address, frame) in enumerate(extract.loaded_addresses)
    chain = UseDefChain(amod, frame.af, address, frame.stacktrace)
    for leaf in Leaves(chain)
      inst = nodevalue(leaf)
      opcode(inst) == OpConstant && continue
      insert!(memory_resources, address, MemoryResource(inst.result_id::ResultID, inst.type_id::ResultID))
    end
  end
end
