struct StackFrame
  callsite::Int
  function_index::Int
end

function StackFrame(amod::AnnotatedModule, caller::ResultID)
  callsite = findfirst(has_result_id(caller), amod.mod.instructions)
  findex = find_function(amod, callsite)
  StackFrame(callsite, findex)
end

struct StackTrace
  frames::Vector{StackFrame}
end
StackTrace() = StackTrace(StackFrame[])

@forward_methods StackTrace field = :frames Base.push!(_, args...) Base.pop!(_, item) Base.isempty Base.getindex(_, key) Base.lastindex
push(stacktrace::StackTrace, frame::StackFrame) = StackTrace([stacktrace.frames; frame])

Base.getindex(stacktrace::StackTrace, range::UnitRange) = StackTrace(stacktrace.frames[range])

const SimpleCFG = ControlFlowGraph{Edge{Int}, Int, SimpleDiGraph{Int}}

"""
State of an abstract interpretation being run.

This state is meant to be modified by the provided user function during interpretation.
Notably, setting the field `converged` to `true` when no modification occurs at a particular
basic block is required to ensure termination of the interpretation process.
"""
mutable struct AbstractInterpretation{CFG<:ControlFlowGraph}
  """
  If `true`, indicates that the abstract interpretation has converged locally on a block.

  This directly impacts whether or not to continue processing children blocks *after* the current block is done processing.
  """
  converged::Bool
  "If `true`, indicates that the abstract interpretation should be stopped."
  stop::Bool
  "If `true`, indicates that the current block should not continue processing."
  stop_block::Bool
  """
  If `true`, indicate that the current block and function must not be processed further.

  If the function is a top-level call, abstract interpretation will be stopped; otherwise,
  the current function will return and interpretation will continue in the caller.
  """
  stop_function::Bool
  "Cache for control-flow graphs to avoid computing them more than once for every function."
  cfgs::Dictionary{AnnotatedFunction, CFG}
end
AbstractInterpretation() = AbstractInterpretation{SimpleCFG}(false, false, false, false, Dictionary())

"""
Frame of interpretation which contains information about the current program point.
"""
struct InterpretationFrame{CFG<:ControlFlowGraph}
  "SPIR-V module that the interpretation is carried on."
  amod::AnnotatedModule
  "SPIR-V function being currently interpreted."
  af::AnnotatedFunction
  "Control-flow graph of the current function."
  cfg::CFG
  "Stacktrace indicating the program's execution path."
  stacktrace::StackTrace
  "Basic block currently being processed. Has a direct correspondence with `cfg` nodes."
  block::Int
end

function InterpretationFrame(interpret::AbstractInterpretation, amod::AnnotatedModule, af::AnnotatedFunction, stacktrace::StackTrace = StackTrace())
  cfg = control_flow_graph!(interpret, amod, af)
  InterpretationFrame(amod, af, cfg, stacktrace, entry_node(cfg.g))
end

"Memoize the control flow graph inside the abstract interpretation state."
function control_flow_graph!(interpret::AbstractInterpretation, amod::AnnotatedModule, af::AnnotatedFunction)
  cfg = get(interpret.cfgs, af, nothing)
  !isnothing(cfg) && return cfg
  cfg = ControlFlowGraph(amod, af)
  insert!(interpret.cfgs, af, cfg)
  cfg
end

"""
    interpret(f, amod::AnnotatedModule, af::AnnotatedFunction)

Perform abstract interpretation on the module `amod` starting with the function `af`.

`f` will be called on each encountered block and each encountered instruction. `f` must
therefore implement two methods:
- `f(interpret::AbstractInterpretation, frame::InterpretationFrame)`
- `f(interpret::AbstractInterpretation, frame::InterpretationFrame, inst::Instruction)`

`f` should set the field `interpret.converged` to `true` if no change occurred while executing `f` on a block to indicate local convergence.
If this is never performed, any looping construct in the CFG will continue interpreting forever assuming that convergence has not been reached.

`f(interpret::AbstractInterpretation, frame::InterpretationFrame)` will be called when reaching a basic block, before seeing instructions.

# Extended help

`f(interpret::AbstractInterpretation, frame::InterpretationFrame)` can be used to set `interpret.converged` to `true` while
setting it back to `false` should any processed instruction within that block cause any state changes.

You can also set convergence to `false` by default and set it to `true` if you see instructions coming back (likely meaning we've reached a cycle and are iterating a second time over a block).
"""
interpret(args...) = AbstractInterpretation()(args...)

(interpret::AbstractInterpretation)(f, amod::AnnotatedModule, af::AnnotatedFunction) = interpret(f, InterpretationFrame(interpret, amod, af))

function (interpret::AbstractInterpretation)(f, frame::InterpretationFrame)
  interpret.converged = false
  interpret.stop_block = false
  interpret.stop_function = false

  interpret_block(f, interpret, frame)
  !interpret.stop || !interpret.stop_function || return interpret
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

  f(interpret, frame)
  block = frame.af.blocks[frame.block]
  for (i, inst) in enumerate(instructions(amod, block))
    f(interpret, frame, inst)
    (interpret.stop_block || interpret.stop_function || interpret.stop) && return
    if opcode(inst) == OpFunctionCall
      # Recurse into function call.
      # Self-recursive functions are not authorized in SPIR-V,
      # so valid SPIR-V code should not induce any related stack overflows.
      fid = inst.arguments[1]::ResultID
      findex = find_function(amod, fid)
      callee_frame = InterpretationFrame(interpret, amod, amod.annotated_functions[findex], push(frame.stacktrace, StackFrame(block[i], findex)))
      caller_converged = interpret.converged
      interpret(f, callee_frame)
      # Restore function-local state.
      interpret.stop_block = false
      interpret.stop_function = false
      interpret.converged = caller_converged
    end
  end
end
