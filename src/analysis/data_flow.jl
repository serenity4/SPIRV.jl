function control_flow_graph(c::InstructionCursor, af::AnnotatedFunction)
  seek(c, af.start)
  control_flow_graph(c)
end

@auto_hash_equals struct UseDefChain
  use::Instruction
  defs::Vector{UseDefChain}
end

UseDefChain(use::Instruction) = UseDefChain(use, UseDefChain[])

struct StackFrame
  callsite::Int
  function_index::Int
end

struct StackTrace
  frames::Vector{StackFrame}
end

function expand_chains!(scan, target_defs::Vector{Pair{SSAValue,UseDefChain}})
  any_expanded = false

  scan() do inst
    (; result_id, arguments) = inst
    if opcode(inst) == OpStore
      # OpVariable instructions will be seen after their stored value. We need to
      # mark stores as definitions even before we encounter the OpVariable instruction.
      # If we stumble upon an OpVariable definition instruction, the dependency will be
      # with that of the initializer (if any) or an implicit value (e.g. an interface variable filled externally).
      result_id = first(inst.arguments)::SSAValue
      arguments = inst.arguments[2:end]
    end
    if isa(result_id, SSAValue)
      for (target, prev_chain) in target_defs
        if target == result_id
          any_expanded = true
          chain = UseDefChain(result_id)
          push!(prev_chain.defs, chain)
          for arg in arguments
            isa(arg, SSAValue) && push!(target_defs, (arg, chain))
          end
        end
      end
      filter!(≠(result_id) ∘ first, target_defs)
    end
  end

  any_expanded
end

function expand_chains_from_caller!(target_defs::Vector{Pair{SSAValue,UseDefChain}}, amod::AnnotatedModule, af::AnnotatedFunction, stacktrace::StackTrace)
  isempty(stacktrace) && return
  stackframe = pop!(stacktrace)
  arg_indices = Dictionary{SSAValue,Int}()
  i = 0
  scan_parameters(amod, af) do inst
    assert_opcode(inst, OpFunctionParameter)
    insert!(arg_indices, inst.result_id, (i += 1))
  end
  c = cursor(amod)
  seek(c, stackframe.callsite)
  call = read_prev(c)
  for (i, (target, chain)) in enumerate(target_defs)
    if target in keys(arg_indices)
      target_defs[i] = call.arguments[arg_indices[target]]::SSAValue => chain
    end
  end
  expand_chains!(target_defs, amod, amod.functions[stackframe.function_index], stacktrace)
end

function expand_chains!(target_defs::Vector{Pair{SSAValue,UseDefChain}}, amod::AnnotatedModule, af::AnnotatedFunction, stacktrace::StackTrace, cfg::AbstractGraph = control_flow_graph(cursor(amod), af))
  c = cursor(amod)
  scan_function_body(has_result_id(use), amod, af)
  block = find_block(af, position(c))
  expand_chains!(x -> scan_block(x, amod, af, block; rev = true, start = position(c)), target_defs)

  flow_through(reverse(cfg), block) do e
    expand_chains!(x -> scan_block(x, amod, af, dst(e); rev = true), target_defs)
  end

  expand_chains_from_caller!(target_defs, amod, stacktrace)
end

function UseDefChain(amod::AnnotatedModule, af::AnnotatedFunction, use::SSAValue, stacktrace::StackTrace; warn_unresolved = true)
  chain = UseDefChain(use)
  target_defs = [use => chain]
  expand_chains!(target_defs, amod, af, stacktrace)
  expand_chains!(x -> scan_globals(x, amod; rev = true), target_defs)
  !isempty(target_defs) && warn_unresolved && @warn "Some use-def chains were not completely resolved."
  chain
end

has_result_id(inst::Instruction, id::SSAValue) = inst.result_id === id
has_result_id(id::SSAValue) = Base.Fix2(has_result_id, id)

function find_block(af::AnnotatedFunction, index::Integer)
  index < af.start && error("Index ", index, " is not inside the provided function")
  index < first(af.blocks) && error("Index ", index, " points to an instruction occurring before any block definition")
  found = findlast(≤(index), af.blocks)
  isnothing(found) && error("Index ", index, " points to an instruction occurring after the function body")
  found
end

function scan_parameters(f, amod::AnnotatedModule, af::AnnotatedFunction; rev = false)
  scan(f, cursor(amod), (af.start + 1):(af.start + af.nparameters); rev)
end

function scan_block(f, amod::AnnotatedModule, af::AnnotatedFunction, block::Integer; rev = false, start = nothing)
  start = af.blocks[block]
  stop = block == lastindex(af.blocks) ? af.stop : af.blocks[block + 1] - 1
  scan(f, cursor(amod), something(start, af.blocks[block]):stop; rev)
end

function scan_globals(f, amod::AnnotatedModule; rev = false)
  scan(f, cursor(amod), amod.globals:(amod.functions - 1); rev)
end

function scan_function_body(f, amod::AnnotatedModule, af::AnnotatedFunction; rev = false)
  scan(f, cursor(amod), af.start:af.stop; rev)
end
