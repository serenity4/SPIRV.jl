@auto_hash_equals struct AnnotatedFunction
  range::UnitRange{Int}
  parameters::UnitRange{Int}
  blocks::Vector{UnitRange{Int}}
end

function annotate_function(c::InstructionCursor)
  start = position(c)
  assert_opcode(OpFunction, read(c))

  p = position(c)
  skip_until(≠(OpFunctionParameter) ∘ opcode ∘ peek, c)
  parameters = p:(position(c) - 1)

  blocks = UnitRange{Int}[]
  block_start = block_end = 0

  while opcode(peek(c)) ≠ OpFunctionEnd
    if opcode(read(c)) == OpLabel
      if !iszero(block_start)
        block_end = position(c) - 2
        push!(blocks, block_start:block_end)
      end
      block_start = position(c) - 1
    end
  end
  stop = position(c)
  !iszero(block_start) || error("Expected at least one block (OpLabel) declaration in the function body.")
  push!(blocks, block_start:(stop - 1))

  f = AnnotatedFunction(start:stop, parameters, blocks)
  skip(c, 1)
  f
end

"""
Module annotated with instruction ranges for each logical SPIR-V section, suitable for read-only operations and analyses.

Any desired modifications of annotated modules should be staged and applied via a [`Diff`](@ref).

!!! warn
    This module *should not* be modified, and in particular *must not* have its structure affected in any way by the insertion or removal of instructions.
    Modifications can cause the annotations to become out of sync with the updated state of the module, yielding undefined behavior.
"""
@refbroadcast mutable struct AnnotatedModule
  mod::Module
  c::InstructionCursor

  # Sections.
  capabilities::UnitRange{Int}
  extensions::UnitRange{Int}
  extended_instruction_sets::UnitRange{Int}
  memory_model::Int
  entry_points::UnitRange{Int}
  execution_modes::UnitRange{Int}
  debug::UnitRange{Int}
  annotations::UnitRange{Int}
  globals::UnitRange{Int}
  functions::UnitRange{Int}
  annotated_functions::Vector{AnnotatedFunction}

  AnnotatedModule(mod::Module, c::InstructionCursor) = new(mod, c)
end

@forward AnnotatedModule.mod (Base.getindex, Base.lastindex, Base.view)

Module(amod::AnnotatedModule) = amod.mod

function AnnotatedModule(mod::Module)
  c = InstructionCursor(mod.instructions)
  annotated = AnnotatedModule(mod, c)
  
  p = position(c)
  skip_until(≠(OpCapability) ∘ opcode ∘ peek, c)
  annotated.capabilities = p:(position(c) - 1)

  p = position(c)
  skip_until(≠(OpExtension) ∘ opcode ∘ peek, c)
  annotated.extensions = p:(position(c) - 1)

  p = position(c)
  skip_until(≠(OpExtInstImport) ∘ opcode ∘ peek, c)
  annotated.extended_instruction_sets = p:(position(c) - 1)

  skip_until(≠(OpMemoryModel) ∘ opcode ∘ peek, c)
  annotated.memory_model = position(c) - 1
  
  p = position(c)
  skip_until(≠(OpEntryPoint) ∘ opcode ∘ peek, c)
  annotated.entry_points = p:(position(c) - 1)

  p = position(c)
  skip_until(!in((OpExecutionMode, OpExecutionModeId)) ∘ opcode ∘ peek, c)
  annotated.execution_modes = p:(position(c) - 1)

  p = position(c)
  skip_until(!in((OpString, OpSourceExtension, OpSource, OpSourceContinued, OpName, OpMemberName, OpModuleProcessed)) ∘ opcode ∘ peek, c)
  annotated.debug = p:(position(c) - 1)

  p = position(c)
  skip_until(x -> info(peek(x)).class ≠ "Annotation", c)
  annotated.annotations = p:(position(c) - 1)

  p = position(c)
  skip_until(==(OpFunction) ∘ opcode ∘ peek, c)
  annotated.globals = p:(position(c) - 1)

  p = position(c)
  annotated.annotated_functions = AnnotatedFunction[]
  while !eof(c)
    push!(annotated.annotated_functions, annotate_function(c))
  end
  annotated.functions = p:(position(c) - 1)

  annotated
end

annotate(mod::Module) = AnnotatedModule(mod)

instructions(amod::AnnotatedModule, indices) = @view amod[indices]
instructions(amod::AnnotatedModule, af::AnnotatedFunction) = instructions(amod, af.range)
instructions(amod::AnnotatedModule, af::AnnotatedFunction, block::Integer) = instructions(amod, af.blocks[block])

const termination_instructions = Set([
  OpBranch, OpBranchConditional,
  OpReturn, OpReturnValue,
  OpUnreachable,
  OpKill, OpTerminateInvocation,
])

is_termination_instruction(inst::AbstractInstruction) = in(opcode(inst), termination_instructions)
is_merge_instruction(inst::AbstractInstruction) = in(opcode(inst), (OpSelectionMerge, OpLoopMerge))
is_label_instruction(inst::AbstractInstruction) = opcode(inst) == OpLabel
is_phi_instruction(inst::AbstractInstruction) = opcode(inst) == OpPhi

function termination_instruction(blk::Block)
  ex = blk[end]
  @assert is_termination_instruction(ex)
  ex
end

function merge_header(blk::Block)
  ex = blk[end]
  @assert is_merge_instruction(ex)
  ex
end

function phi_expressions(blk::Block)
  exs = Expression[]
  for ex in blk
    if ex.op == OpPhi
      push!(exs, ex)
    end
  end
  exs
end

"Find the function index which contains the instruction with result ID `fid`."
function find_function(amod::AnnotatedModule, fid::ResultID)
  for (i, af) in enumerate(amod.annotated_functions)
    inst = amod[first(af.range)]
    has_result_id(inst, fid) && return i
  end
end

"Find the function index of the function which contains the instruction located at `index`."
function find_function(amod::AnnotatedModule, index::Integer)
  for (i, af) in enumerate(amod.annotated_functions)
    in(index, af.range) && return i
  end
end

"Find the block index of the block which contains the instruction located at `index`."
function find_block(af::AnnotatedFunction, index::Integer)
  index < first(af.range) && error("Index ", index, " is not inside the provided function")
  index < first(first(af.blocks)) && error("Index ", index, " points to an instruction occurring before any block definition")
  found = findlast(≤(index) ∘ first, af.blocks)
  isnothing(found) && error("Index ", index, " points to an instruction occurring after the function body")
  found
end

function find_block(amod::AnnotatedModule, af::AnnotatedFunction, id::ResultID)
  for (i, block) in enumerate(af.blocks)
    has_result_id(amod[block.start], id) && return i
  end
end

function add_capabilities!(diff::Diff, amod::AnnotatedModule, capabilities)
  insert!(diff, last(amod.capabilities) + 1, [(@inst OpCapability(cap)) for cap in capabilities])
end

function add_extensions!(diff::Diff, amod::AnnotatedModule, extensions)
  insert!(diff, last(amod.extensions) + 1, [(@inst OpExtension(ext)) for ext in extensions])
end
