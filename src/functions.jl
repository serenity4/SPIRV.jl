@refbroadcast struct Block
  id::ResultID
  exs::Vector{Expression}
end

Block(id::ResultID) = Block(id, Expression[])

@forward Block.exs (Base.getindex, Base.iterate, Base.length, Base.push!, Base.pushfirst!, Base.pop!, Base.popfirst!, Base.firstindex, Base.lastindex)

@auto_hash_equals struct FunctionDefinition
  type::FunctionType
  control::FunctionControl
  "Function arguments, after promoting non-local pointer arguments to global variables. Argument types match the function `type`."
  args::Vector{ResultID}
  "Declaration of variables which hold function-local pointers."
  local_vars::Vector{Expression}
  blocks::ResultDict{Block}
  "Arguments promoted to global variables."
  global_vars::Vector{ResultID}
end

@forward FunctionDefinition.blocks (Base.getindex, Base.keys)

function FunctionDefinition(type::FunctionType, control::FunctionControl = FunctionControlNone)
  FunctionDefinition(type, control, [], [], ResultDict(), [])
end

function body(fdef::FunctionDefinition)
  foldl(append!, map(x -> x.exs, values(fdef.blocks)); init = Expression[])
end

function new_block!(fdef::FunctionDefinition, id::ResultID)
  blk = Block(id, [@ex id = Label()])
  insert!(fdef.blocks, id, blk)
  blk
end

nexs(fdef::FunctionDefinition) = sum(length, fdef.blocks)

function Base.show(io::IO, fdef::FunctionDefinition)
  print(io, "FunctionDefinition (")
  fdef.control ≠ FunctionControlNone && print(io, fdef.control, ", ")
  print(io, length(fdef.args), " argument", length(fdef.args) == 1 ? "" : "s" , ", ", length(fdef.blocks), " block", length(fdef.blocks) == 1 ? "" : "s", ", ", nexs(fdef), " expressions)")
end
