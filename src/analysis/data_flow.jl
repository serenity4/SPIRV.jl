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

function control_flow_graph(c::InstructionCursor, f::AnnotatedFunction)
  seek(c, f.start)
  control_flow_graph(c)
end

@auto_hash_equals struct UseDefChain
  use::Instruction
  defs::Vector{UseDefChain}
end

UseDefChain(use::Instruction) = UseDefChain(use, UseDefChain[])

function expand_chains!(scan, target_defs::Dictionary{SSAValue,UseDefChain})
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
      if haskey(targets_defs, result_id)
        any_expanded = true
        chain = UseDefChain(result_id)
        prev_chain = target_defs[result_id]
        push!(prev_chain.defs, chain)
        delete!(target_defs, result_id)
        for arg in arguments
          # TODO: Handle chains that depend on a common definition.
          isa(arg, SSAValue) && insert!(target_defs, arg, chain)
        end
      end
    end
  end

  any_expanded
end

function UseDefChain(amod::AnnotatedModule, f::AnnotatedFunction, use::SSAValue, cfg::AbstractGraph = control_flow_graph(cursor(amod), f))
  c = cursor(amod)
  search_for = UseDefChain[]
  seek_definition(c, use)
  inst = peek(c)
  chain = UseDefChain(use)

  target_defs = Dictionary{SSAValue,UseDefChain}([use], [chain])

  block = find_block(f, position(c))
  expand_chains!(x -> scan_block(x, c, f, block; rev = true), target_defs)

  # This should not involve any nested flow analysis.
  # Maybe prefer a flat way of keeping track of uses.
  # It can be a list of definitions yets unreached paired with their to-be use-def chain.
  # The thing is we don't want to have to do a separate flow analysis. And if we pass
  # a given block, no definition will require re-processing it, unless reached by a back-edge.
  # This should be effectively some abstract interpretation where we execute all block statements,
  # but instead of inferring a particular quantity or value for each statement we just mutate
  # use-def chains.

  # @case &OpVariable
  # Follow store operations in control-flow order until the use.
  # This may yield multiple possible use-def chains, e.g. if the variable
  # has been stored to multiple times depending on control flow.
  # Stores that are overriden during program execution until the use should be ignored.
  # The OpVariable instruction should therefore be discarded in favor of the last live
  # value that it was assigned to.
  # TODO
  flow_through(reverse(cfg), block) do e
    # TODO: Target definitions must be duplicated at diverging program points.
    # Otherwise, they will be resolved to the first block that provides them with a value.
    # This is especially relevant for variables and (possibly) for OpPhi instructions.
    expand_chains!(x -> scan_block(x, c, f, dst(e); rev = true), target_defs)
  end
  
  expand_chains!(x -> scan_globals(x, amod; rev = true), target_defs)
  # Expand the analysis to the caller function.
  # Impossible to do without having a back-edge to the caller.
  # TODO
  expand_chains!(x -> scan_parameters(x, c, f; rev = true), target_defs)

  !isempty(target_defs) && @warn "Some use-def chains were not completely resolved."

  chain
end

function seek_definition(c::InstructionCursor, id::SSAValue)
  mark(c)
  while !eof(c)
    inst = read(c)
    opcode(inst) == OpFunctionEnd && break
    isa(inst.result_id, SSAValue) && id == inst.result_id && return seek(position(c) - 1)
  end
  reset(c)
  error("Could not find definition for SSA ID ", id, " starting from cursor position ", position(c))
end

function seek_global(amod::AnnotatedModule, id::SSAValue)
  c = cursor(amod)
  mark(c)
  seek(c, amod.globals)
  while position(c) < amod.functions
    inst = read(c)
    if inst.result_id === id
      unmark(c)
      return seek(position(c) - 1)
    end
  end
  reset(c)
  nothing
end

function find_block(f::AnnotatedFunction, index::Integer)
  index < f.start && error("Index ", index, " is not inside the provided function")
  index < first(f.blocks) && error("Index ", index, " points to an instruction occurring before any block definition")
  found = findlast(≤(index), f.blocks)
  isnothing(found) && error("Index ", index, " points to an instruction occurring after the function body")
  found
end

function scan_block(f, c::InstructionCursor, af::AnnotatedFunction, block::Integer; rev = false)
  mark(c)
  stop_at = block == lastindex(af.blocks) ? af.stop : af.blocks[block + 1] - 1
  if rev
    seek(c, stop_at)
    while f(read_prev(c)) !== false && position(c) ≥ af.blocks[block] end
  else
    seek(c, af.blocks[block])
    while f(read(c)) !== false && position(c) ≤ stop_at end
  end
  reset(c)
end
