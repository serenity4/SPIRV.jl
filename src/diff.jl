"""
Data structure meant to record and store modifications to be applied to SPIR-V modules at a later stage.

This is especially useful to design algorithms which can therefore process a given SPIR-V module without worrying
about past analyses being outdated while recording changes to apply as the result of the processing.
"""
struct Diff
  mod::Module
  idcounter::IDCounter
  insertions::Vector{Pair{Int,Instruction}}
  modifications::Vector{Pair{Int,Instruction}}
  deletions::Vector{Int}
end

Diff(mod::Module) = Diff(mod, IDCounter(mod.bound - 1), [], [], [])
Diff(x) = Diff(Module(x))

next!(diff::Diff) = next!(diff.idcounter)

function apply!(diff::Diff)
  (; mod, insertions, deletions) = diff
  (; instructions) = mod
  for (line, inst) in diff.modifications
    instructions[line] = inst
  end

  sort!(insertions, by = first)
  sort!(deletions)

  while !isempty(insertions) || !isempty(deletions)
    next_insertion = isempty(insertions) ? typemin(Int) : first(last(insertions))
    next_deletion = isempty(deletions) ? typemin(Int) : last(deletions)
    next_insertion == next_deletion && error("Cannot delete and insert at the same location. Use explicit modifications instead.")
    if next_insertion > next_deletion
      (i, instruction) = pop!(insertions)
      insert!(instructions, i, instruction)
    else
      i = pop!(deletions)
      deleteat!(instructions, i)
    end
  end
  @set mod.bound = UInt32(ResultID(diff.idcounter)) + 1
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

Base.insert!(diff::Diff, i::Integer, inst::Instruction) = insert!(diff, i => inst)

function Base.insert!(diff::Diff, pair::Pair{<:Integer, Instruction})
  push!(diff.insertions, pair)
  diff
end

"Record all insertion independently. Must not be used for chunks, or all insertions must have the chunk start location as index."
function Base.insert!(diff::Diff, insertions)
  for pair in insertions
    insert!(diff, pair)
  end
  diff
end

"Insert instructions as part of the same chunk."
function Base.insert!(diff::Diff, i::Integer, insts)
  for inst in insts
    insert!(diff, i => inst)
  end
  diff
end

function Base.show(io::IO, ::MIME"text/plain", diff::Diff)
  print(io, Diff, '(', diff.mod, ", ", diff.idcounter, ", ", length(diff.insertions), " insertions, ", length(diff.deletions), " deletions and ", length(diff.modifications), " modifications)")
end
