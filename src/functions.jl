@refbroadcast struct Block
  id::ResultID
  exs::Vector{Expression}
end

Block(id::ResultID) = Block(id, Expression[])

@forward_interface Block field = :exs interface = [iteration, indexing]
@forward_methods Block field = :exs Base.insert!(_, args...) Base.push!(_, ex::Expression) Base.view(_, range)

function termination_instruction(blk::Block)
  ex = blk[end]
  @assert is_termination_instruction(ex)
  ex
end

function merge_header(blk::Block)
  ex = blk[end - 1]
  @assert is_merge_instruction(ex)
  ex
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

function directly_reachable_blocks(blk::Block)
  inst = termination_instruction(blk)
  @match opcode(inst) begin
    &OpBranch => ResultID[inst[end]]
    &OpBranchConditional => collect(ResultID, inst[end-1:end])
    &OpSwitch => collect(ResultID, inst[4:2:end])
  end
end

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

nexs(fdef::FunctionDefinition) = sum(length, fdef.blocks)

function Base.show(io::IO, fdef::FunctionDefinition)
  print(io, "FunctionDefinition (")
  fdef.control ≠ FunctionControlNone && print(io, fdef.control, ", ")
  print(io, length(fdef.args), " argument", length(fdef.args) == 1 ? "" : "s" , ", ", length(fdef.blocks), " block", length(fdef.blocks) == 1 ? "" : "s", ", ", nexs(fdef), " expressions)")
end
