@struct_hash_equal struct UseDefChain
  use::Instruction
  defs::Vector{UseDefChain}
end

UseDefChain(use::Instruction) = UseDefChain(use, UseDefChain[])

AbstractTrees.nodevalue(chain::UseDefChain) = chain.use
AbstractTrees.children(chain::UseDefChain) = chain.defs
AbstractTrees.printnode(io::IO, chain::UseDefChain) = show(io, MIME"text/plain"(), nodevalue(chain))
Base.show(io::IO, ::MIME"text/plain", chain::UseDefChain) = print(io, chomp(sprintc(print_tree, chain)))

function expand_chains!(target_defs::Vector{Pair{ResultID,UseDefChain}}, insts)
  any_expanded = false

  for inst in insts
    (; result_id) = inst
    if opcode(inst) == OpStore
      # OpVariable instructions will be seen after their stored value. We need to
      # mark stores as definitions even before we encounter the OpVariable instruction.
      # If we stumble upon an OpVariable definition instruction, the dependency will be
      # with that of the initializer (if any) or an implicit value (e.g. an interface variable filled externally).
      result_id = first(inst.arguments)::ResultID
    end
    if isa(result_id, ResultID)
      for (target, prev_chain) in target_defs
        if target == result_id
          any_expanded = true
          chain = UseDefChain(inst)
          push!(prev_chain.defs, chain)
          add_targets!(target_defs, inst, chain)
        end
      end
      filter!(≠(result_id) ∘ first, target_defs)
    end
  end

  any_expanded
end

function add_targets!(target_defs, args, chain)
  for arg in args
    isa(arg, ResultID) && push!(target_defs, arg => chain)
  end
end

function add_targets!(target_defs, inst::Instruction, chain)
  @switch opcode(inst) begin
    @case &OpStore || &OpFunctionCall
    add_targets!(target_defs, @view(inst.arguments[2:end]), chain)
    @case &OpPhi
    add_targets!(target_defs, @view(inst.arguments[2:2:end]), chain)
    @case _
    add_targets!(target_defs, inst.arguments, chain)
  end
end

function expand_chains_from_caller!(target_defs::Vector{Pair{ResultID,UseDefChain}}, amod::AnnotatedModule, af::AnnotatedFunction, stacktrace::StackTrace)
  stackframe = last(stacktrace)

  # Remap OpFunctionParameter instructions to the caller arguments.
  arg_indices = Dictionary{ResultID,Int}()
  i = 0
  for inst in instructions(amod, af.parameters)
    insert!(arg_indices, inst.result_id, (i += 1))
  end
  call = amod[stackframe.callsite]
  for (i, (target, chain)) in enumerate(target_defs)
    if target in keys(arg_indices)
      target_defs[i] = call.arguments[1 + arg_indices[target]]::ResultID => chain
    end
  end

  af_caller = amod.annotated_functions[stackframe.function_index]
  expand_chains!(target_defs, amod, af_caller, find_block(af_caller, stackframe.callsite), stacktrace[1:end-1])
end

function expand_chains!(target_defs::Vector{Pair{ResultID,UseDefChain}}, amod::AnnotatedModule, af::AnnotatedFunction, block::Integer, stacktrace::StackTrace, cfg::ControlFlowGraph = ControlFlowGraph(amod, af))
  expand_chains!(target_defs, instructions(amod, reverse(af.blocks[block])))

  flow_through(reverse(cfg), block) do e
    expand_chains!(target_defs, instructions(amod, reverse(af.blocks[dst(e)])))
  end

  if isempty(stacktrace)
    expand_chains!(target_defs, instructions(amod, af.parameters))
  else
    expand_chains_from_caller!(target_defs, amod, af, stacktrace)
  end
end

function UseDefChain(amod::AnnotatedModule, af::AnnotatedFunction, use::ResultID, stacktrace::StackTrace; warn_unresolved = true)
  local_index = findfirst(has_result_id(use), instructions(amod, af))
  !isnothing(local_index) || error("No result ID corresponding to $use was found within the provided function.")
  use_index = first(af.range) + local_index - 1
  inst = amod[use_index]

  chain = UseDefChain(inst)
  target_defs = Pair{ResultID,UseDefChain}[]
  add_targets!(target_defs, inst, chain)

  expand_chains!(target_defs, amod, af, find_block(af, use_index), stacktrace)
  expand_chains!(target_defs, instructions(amod, reverse(amod.globals)))
  !isempty(target_defs) && warn_unresolved && @warn "The use-def chain for the instruction $(sprintc_mime(show, inst)) was not fully resolved (missing ids: $(join([sprintc(printstyled, id; color = :red) for id in first.(target_defs)], ", ")))."
  chain
end
