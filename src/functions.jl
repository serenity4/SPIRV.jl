@refbroadcast struct Block
  id::ResultID
  exs::Vector{Expression}
end

Block(id::ResultID) = Block(id, Expression[])

@forward_interface Block field = :exs interface = [iteration, indexing]
@forward_methods Block field = :exs Base.insert!(_, args...) Base.push!(_, ex::Expression) Base.append!(_, exs) Base.view(_, range) Base.deleteat!(_, i) Base.keys(_) Base.splice!(_, args...)

function termination_expression(blk::Block)
  ex = blk[end]
  @assert is_termination_instruction(ex)
  ex
end

has_merge_header(blk::Block) = length(blk) ≥ 2 && is_merge_instruction(blk[end - 1])

function merge_header(blk::Block)
  @assert has_merge_header(blk)
  blk[end - 1]
end

function phi_expressions(blk::Block)
  exs = Expression[]
  for ex in blk
    if ex.op == OpPhi
      push!(exs, ex)
    end
  end
  exs
end

function Base.insert!(blk::Block, index::Int, exs::AbstractVector{Expression})
  for ex in reverse(exs)
    insert!(blk.exs, index, ex)
  end
  blk
end

function Base.replace!(blk::Block, index::Int, by::Union{Expression, AbstractVector{Expression}})
  deleteat!(blk, index)
  insert!(blk, index, by)
end

"Indices of arguments which represent target block IDs in a branching instruction."
function branch_target_indices(ex::Expression)
  @match ex.op begin
    &OpBranch => 1:1
    &OpBranchConditional => 2:3
    &OpSwitch => 4:2:lastindex(ex)
    &OpReturn || &OpReturnValue || &OpUnreachable || &OpKill || &OpTerminateInvocation => 1:0
  end
end

function targets(blk::Block)
  ex = termination_expression(blk)
  indices = branch_target_indices(ex)
  collect(ResultID, @view ex[indices])
end

branch!(from::Block, to::Block) = push!(from, @ex Branch(to.id))
branch!(from::Block, cond::ResultID, yes::Block, no::Block) = push!(from, @ex BranchConditional(cond, yes.id, no.id))

@struct_hash_equal struct FunctionDefinition
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

@forward_interface FunctionDefinition field = :blocks interface = [indexing, iteration]
@forward_methods FunctionDefinition field = :blocks Base.push!(_, ex::Expression)

Base.getindex(fdef::FunctionDefinition, id::ResultID) = fdef.blocks[id]
Base.getindex(fdef::FunctionDefinition, idx::Integer) = fdef[fdef.block_ids[idx]]

function FunctionDefinition(type::FunctionType, control::FunctionControl = FunctionControlNone)
  FunctionDefinition(type, control, [], [], ResultDict(), [], [])
end

block_index(fdef::FunctionDefinition, blk::Block) = findfirst(==(blk.id), fdef.block_ids)::Int

function body(fdef::FunctionDefinition)
  block_order = traverse(control_flow_graph(fdef))
  foldl(append!, [fdef[v] for v in block_order]; init = Expression[])
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

function Base.delete!(fdef::FunctionDefinition, block_indices::AbstractVector{<:Integer})
  block_ids = splice!(fdef.block_ids, block_indices)
  for id in block_ids
    delete!(fdef.blocks, id)
  end
  fdef
end

nexs(fdef::FunctionDefinition) = sum(length, fdef.blocks)

function Base.show(io::IO, fdef::FunctionDefinition)
  print(io, "FunctionDefinition (")
  fdef.control ≠ FunctionControlNone && print(io, fdef.control, ", ")
  print(io, length(fdef.args), " argument", length(fdef.args) == 1 ? "" : "s" , ", ", length(fdef.blocks), " block", length(fdef.blocks) == 1 ? "" : "s", ", ", nexs(fdef), " expressions)")
end

targets(blk::Block, fdef::FunctionDefinition) = Block[fdef[target] for target in targets(blk)]
