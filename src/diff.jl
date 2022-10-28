"""
Data structure meant to record and store modifications to be applied to SPIR-V modules at a later stage.

This is especially useful to design algorithms which can therefore process a given SPIR-V module without worrying
about past analyses being outdated while recording changes to apply as the result of the processing.
"""
struct Diff
  mod::Module
  ssacounter::SSACounter
  insertions::Vector{Pair{Int,Instruction}}
  modifications::Vector{Pair{Int,Instruction}}
  deletions::Vector{Int}
end

Diff(mod::Module) = Diff(mod, SSACounter(mod.bound), [], [], [])
Diff(x) = Diff(Module(x))

next!(diff::Diff) = next!(diff.ssacounter)

function apply!(diff::Diff)
  (; mod) = diff
  (; instructions) = mod
  for (line, inst) in diff.modifications
    instructions[line] = inst
  end
  insertion_order = sort(diff.insertions, by = first)
  deletion_order = sort(diff.deletions)
  n = lastindex(instructions)
  @assert (isempty(insertion_order) || n ≥ first(first(insertion_order))) && n ≥ get(deletion_order, 1, 0)
  insert_i = lastindex(insertion_order)
  delete_i = lastindex(deletion_order)
  for i in reverse(eachindex(instructions))
    insert_i == delete_i && error("Cannot delete and insert at the same location. Use explicit modifications instead.")
    if get(deletion_order, delete_i, 0) == i
      deleteat!(instructions, i)
      delete_i = prevind(deletion_order, delete_i)
    elseif firstindex(insertion_order) ≤ insert_i ≤ lastindex(insertion_order) && first(insertion_order[insert_i]) == i
      insert!(instructions, i, last(insertion_order[insert_i]))
      insert_i = prevind(insertion_order, insert_i)
    end
  end
  mod
end

function update!(diff::Diff, insts)
  for pair in insts
    update!(diff, pair)
  end
  diff
end

function update!(diff::Diff, pair::Pair{<:Integer,Instruction})
  push!(diff.modifications, pair)
  diff
end

function Base.insert!(diff::Diff, pair::Pair{<:Integer, Instruction})
  push!(diff.insertions, pair)
  diff
end

function Base.insert!(diff::Diff, insts)
  for pair in insts
    insert!(diff, pair)
  end
  diff
end
