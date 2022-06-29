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
Module annotated with instruction ranges for each logical SPIR-V section.
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

@forward AnnotatedModule.mod (Base.getindex, Base.lastindex)

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
instructions(amod::AnnotatedModule, indices) = @view amod.mod.instructions[indices]

function find_function(amod::AnnotatedModule, fid::SSAValue)
  for (i, af) in enumerate(amod.annotated_functions)
    inst = amod[first(af.range)]
    has_result_id(inst, fid) && return i
  end
end

function find_function(amod::AnnotatedModule, index::Integer)
  for (i, af) in enumerate(amod.annotated_functions)
    in(index, af.range) && return i
  end
end

function find_block(af::AnnotatedFunction, index::Integer)
  index < first(af.range) && error("Index ", index, " is not inside the provided function")
  index < first(first(af.blocks)) && error("Index ", index, " points to an instruction occurring before any block definition")
  found = findlast(≤(index) ∘ first, af.blocks)
  isnothing(found) && error("Index ", index, " points to an instruction occurring after the function body")
  found
end
