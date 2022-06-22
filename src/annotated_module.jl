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

  seekstart(c)
  annotated
end

annotate(mod::Module) = AnnotatedModule(mod)
cursor(amod::AnnotatedModule) = amod.c
