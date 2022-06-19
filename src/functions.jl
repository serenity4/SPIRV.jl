@refbroadcast struct Block
  id::SSAValue
  insts::Vector{Instruction}
end

Block(id::SSAValue) = Block(id, [])

@forward Block.insts (Base.getindex, Base.iterate, Base.length, Base.push!, Base.pushfirst!, Base.pop!, Base.popfirst!, Base.firstindex, Base.lastindex)

@auto_hash_equals struct FunctionDefinition
  type::FunctionType
  control::FunctionControl
  "Function arguments, after promoting non-local pointer arguments to global variables. Argument types match the function `type`."
  args::Vector{SSAValue}
  "Declaration of variables which hold function-local pointers."
  local_vars::Vector{Instruction}
  blocks::SSADict{Block}
  "Arguments promoted to global variables."
  global_vars::Vector{SSAValue}
end

@forward FunctionDefinition.blocks (Base.getindex, Base.keys)

function FunctionDefinition(type::FunctionType, control::FunctionControl = FunctionControlNone)
  FunctionDefinition(type, control, [], [], SSADict(), [])
end

function body(fdef::FunctionDefinition)
  foldl(append!, map(x -> x.insts, values(fdef.blocks)); init = Instruction[])
end

function new_block!(fdef::FunctionDefinition, id::SSAValue)
  blk = Block(id, [@inst id = OpLabel()])
  insert!(fdef.blocks, id, blk)
  blk
end

ninsts(fdef::FunctionDefinition) = sum(length, fdef.blocks)

function Base.show(io::IO, fdef::FunctionDefinition)
  print(io, "FunctionDefinition (")
  fdef.control ≠ FunctionControlNone && print(io, fdef.control, ", ")
  print(io, length(fdef.args), " argument", length(fdef.args) == 1 ? "" : "s" , ", ", length(fdef.blocks), " block", length(fdef.blocks) == 1 ? "" : "s", ", ", ninsts(fdef), " instructions)")
end
