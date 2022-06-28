struct StackFrame
  callsite::Int
  function_index::Int
end

struct StackTrace
  frames::Vector{StackFrame}
end
StackTrace() = StackTrace(StackFrame[])

@forward StackTrace.frames (Base.push!, Base.pop!, Base.isempty, Base.getindex, Base.lastindex)

Base.getindex(stacktrace::StackTrace, range::UnitRange) = StackTrace(stacktrace.frames[range])

mutable struct AbstractInterpretation
  "Indicates whether the abstract interpretation has converged locally on a block."
  converged::Bool
  "Indicates whether the abstract interpretation should be stopped."
  stop::Bool
  stop_block::Bool
  stop_function::Bool
  cfgs::Dictionary{AnnotatedFunction, SimpleDiGraph{Int}}
end
AbstractInterpretation() = AbstractInterpretation(false, false, false, false, Dictionary())

struct InterpretationFrame
  amod::AnnotatedModule
  af::AnnotatedFunction
  cfg::SimpleDiGraph{Int}
  stacktrace::StackTrace
  block::Int
end

function InterpretationFrame(interpret::AbstractInterpretation, amod::AnnotatedModule, af::AnnotatedFunction)
  cfg = control_flow_graph!(interpret, amod, af)
  InterpretationFrame(amod, af, cfg, StackTrace(), entry_node(cfg))
end

"Memoize the control flow graph inside the abstract interpretation state."
function control_flow_graph!(interpret::AbstractInterpretation, amod::AnnotatedModule, af::AnnotatedFunction)
  cfg = get(interpret.cfgs, af, nothing)
  !isnothing(cfg) && return cfg
  cfg = control_flow_graph(amod, af)
  insert!(interpret.cfgs, af, cfg)
  cfg
end

interpret(args...) = AbstractInterpretation()(args...)

(interpret::AbstractInterpretation)(f, amod::AnnotatedModule, af::AnnotatedFunction) = interpret(f, InterpretationFrame(interpret, amod, af))

function (interpret::AbstractInterpretation)(f, frame::InterpretationFrame)
  interpret_block(f, interpret, frame) === true || return interpret
  flow_through(frame.cfg, frame.block) do e
    block = dst(e)
    new_frame = @set frame.block = block
    interpret_block(f, interpret, frame)
    interpret.stop_function && return nothing
    !interpret.converged
  end
  interpret
end

function interpret_block(f, interpret::AbstractInterpretation, frame::InterpretationFrame)
  (; amod) = frame
  interpret.converged = false
  interpret.stop_block = false

  f(interpret, frame)
  block = frame.af.blocks[frame.block]
  for (i, inst) in enumerate(instructions(amod, block))
    f(interpret, frame, inst)
    (interpret.stop_block || interpret.stop_function || interpret.stop || interpret.converged) && return false
    if opcode(inst) == OpFunctionCall
      # Recurse into function call.
      # Self-recursive functions are not authorized in SPIR-V,
      # so valid SPIR-V code should not induce any related stack overflows.
      fid = first(inst.arguments)::SSAValue
      findex = find_function(amod, fid)
      push!(frame.stacktrace, StackFrame(block[i], findex))
      interpret(f, amod, amod.annotated_functions[findex])
      pop!(frame.stacktrace)
      # Restore function-local state.
      interpret.stop_block = false
      interpret.stop_function = false
      interpret.converged = false
    end
  end
end
