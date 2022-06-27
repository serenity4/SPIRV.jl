struct AnnotatedFunction
  start::Int
  nparameters::Int
  blocks::Vector{Int}
  stop::Int
end

function annotate_function(c::InstructionCursor)
  start = position(c)
  assert_opcode(OpFunction, read(c))

  nparameters = 0
  while opcode(peek(c)) == OpFunctionParameter
    nparameters += 1
    skip(c, 1)
  end

  blocks = Int[]
  while opcode(peek(c)) ≠ OpFunctionEnd
    opcode(read(c)) == OpLabel && push!(blocks, position(c) - 1)
  end

  f = AnnotatedFunction(start, nparameters, blocks, position(c))
  skip(c, 1)
  f
end

mutable struct AnnotatedModule
  mod::Module
  c::InstructionCursor

  # Sections.
  capabilities::Int
  extensions::Int
  extended_instruction_sets::Int
  memory_model::Int
  entry_points::Int
  execution_modes::Int
  debug::Int
  annotations::Int
  globals::Int
  functions::Int
  annotated_functions::Vector{AnnotatedFunction}

  AnnotatedModule(mod::Module, c::InstructionCursor) = new(mod, c)
end

function AnnotatedModule(mod::Module)
  c = InstructionCursor(mod.instructions)
  annotated = AnnotatedModule(mod, c)

  annotated.capabilities = position(c)
  skip_until(≠(OpCapability) ∘ opcode ∘ peek, c)
  annotated.extensions = position(c)
  skip_until(≠(OpExtension) ∘ opcode ∘ peek, c)
  annotated.extended_instruction_sets = position(c)
  skip_until(≠(OpExtInstImport) ∘ opcode ∘ peek, c)
  annotated.memory_model = position(c)
  skip_until(≠(OpMemoryModel) ∘ opcode ∘ peek, c)
  annotated.entry_points = position(c)
  skip_until(≠(OpEntryPoint) ∘ opcode ∘ peek, c)
  annotated.execution_modes = position(c)
  skip_until(!in((OpExecutionMode, OpExecutionModeId)) ∘ opcode ∘ peek, c)
  annotated.debug = position(c)
  skip_until(!in((OpString, OpSourceExtension, OpSource, OpSourceContinued, OpName, OpMemberName, OpModuleProcessed)) ∘ opcode ∘ peek, c)
  annotated.annotations = position(c)
  skip_until(x -> info(peek(x)).class ≠ "Annotation", c)
  annotated.globals = position(c)
  skip_until(==(OpFunction) ∘ opcode ∘ peek, c)
  annotated.functions = position(c)

  annotated.annotated_functions = AnnotatedFunction[]
  while !eof(c)
    push!(annotated.annotated_functions, annotate_function(c))
  end

  seekstart(c)
  annotated
end

annotate(mod::Module) = AnnotatedModule(mod)
cursor(amod::AnnotatedModule) = amod.c
