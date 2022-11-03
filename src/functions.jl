@refbroadcast struct Block
  id::ResultID
  exs::Vector{Expression}
end

Block(id::ResultID) = Block(id, Expression[])

@forward Block.exs (Base.getindex, Base.iterate, Base.length, Base.keys, Base.push!, Base.pushfirst!, Base.pop!, Base.popfirst!, Base.firstindex, Base.lastindex, Base.insert!, Base.view)

@auto_hash_equals struct FunctionDefinition
  type::FunctionType
  control::FunctionControl
  "Function arguments, after promoting non-local pointer arguments to global variables. Argument types match the function `type`."
  args::Vector{ResultID}
  "Declaration of variables which hold function-local pointers."
  local_vars::Vector{Expression}
  blocks::ResultDict{Block}
  block_ids::Vector{ResultID}
  "Arguments promoted to global variables."
  global_vars::Vector{ResultID}
end

@forward FunctionDefinition.blocks (Base.iterate, Base.length, Base.keys, Base.firstindex, Base.lastindex)

Base.getindex(fdef::FunctionDefinition, id::ResultID) = fdef.blocks[id]
Base.getindex(fdef::FunctionDefinition, idx::Integer) = fdef[fdef.block_ids[idx]]

function FunctionDefinition(type::FunctionType, control::FunctionControl = FunctionControlNone)
  FunctionDefinition(type, control, [], [], ResultDict(), [], [])
end

block_index(fdef::FunctionDefinition, blk::Block) = findfirst(==(blk.id), fdef.block_ids)::Int

function body(fdef::FunctionDefinition)
  foldl(append!, map(x -> x.exs, values(fdef.blocks)); init = Expression[])
end

function new_block!(fdef::FunctionDefinition, id::ResultID)
  blk = Block(id, [@ex id = Label()])
  push!(fdef, blk)
  blk
end

function Base.push!(fdef::FunctionDefinition, blk::Block)
  insert!(fdef.blocks, blk.id, blk)
  push!(fdef.block_ids, blk.id)
  fdef
end

nexs(fdef::FunctionDefinition) = sum(length, fdef.blocks)

function Base.show(io::IO, fdef::FunctionDefinition)
  print(io, "FunctionDefinition (")
  fdef.control ≠ FunctionControlNone && print(io, fdef.control, ", ")
  print(io, length(fdef.args), " argument", length(fdef.args) == 1 ? "" : "s" , ", ", length(fdef.blocks), " block", length(fdef.blocks) == 1 ? "" : "s", ", ", nexs(fdef), " expressions)")
end
