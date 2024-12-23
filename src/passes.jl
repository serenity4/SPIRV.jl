abstract type FunctionPass end

function (pass!::FunctionPass)(ir::IR)
  for fdef in ir.fdefs
    new_function!(pass!, fdef)
    pass!(ir, fdef)
  end
  ir
end

new_function!(pass::FunctionPass, fdef::FunctionDefinition) = pass
(pass!::FunctionPass)(ir::IR, fdef::FunctionDefinition) = pass!(fdef)

"""
Add `Aligned` memory access operands to `Load` instructions that use a pointer associated with a physical storage buffer.
Which alignment will be used will depend on the provided `LayoutStrategy`.
"""
function add_align_operands!(ir::IR, fdef::FunctionDefinition, layout::LayoutStrategy)
  exs = body(fdef)
  for ex in exs
    @tryswitch opcode(ex) begin
      @case &OpLoad || &OpStore
      pointer_id = ex[1]::ResultID
      # Arguments will never be physical buffers.
      in(pointer_id, fdef.args) && continue
      def = @something(
        get(ir.global_vars, pointer_id, nothing),
        find_definition(pointer_id, fdef.local_vars),
        find_definition(pointer_id, exs),
        Some(nothing),
      )
      isnothing(def) && error("Could not retrieve definition for $pointer_id")
      (; type, storage_class) = def.type.pointer
      if storage_class == StorageClassPhysicalStorageBuffer
        # We assume that no other storage class uses the pointer.
        push!(ex, MemoryAccessAligned, UInt32(alignment(layout, type)))
      end
      @case &OpFunctionCall
      # Recurse into function calls.
      callee = ir.fdefs[ex[1]::ResultID]
      add_align_operands!(ir, callee, layout)
    end
  end
  ir
end

function find_definition(id::ResultID, insts)
  idx = findfirst(has_result_id(id), insts)
  if !isnothing(idx)
    insts[idx]
  end
end

struct FillPhiBranches <: FunctionPass end

fill_phi_branches!(ir::IR) = FillPhiBranches()(ir)

"""
SPIR-V requires all branching nodes to give a result, while Julia does not if the Phi instructions
will never get used if coming from branches that are not covered.
We can make use of OpUndef to provide a value, producing it in the incoming nodes
just before branching to the node which defines a Phi instruction.
"""
function (::FillPhiBranches)(ir::IR, fdef::FunctionDefinition)
  cfg = ControlFlowGraph(fdef)
  for v in traverse(cfg)
    blk = fdef[v]
    fill_phi_branches!(blk, ir, fdef, inneighbors(cfg, v))
  end
end

function fill_phi_branches!(blk::Block, ir::IR, fdef::FunctionDefinition, from)
  exs = phi_expressions(blk)
  for ex in exs
    length(ex) == 2length(from) && continue
    sources = phi_sources(ex)
    for u in from
      blkin = fdef[u]
      in(blkin.id, sources) && continue
      id = next!(ir.idcounter)
      insert!(blkin, lastindex(blkin), @ex id = OpUndef()::ex.type)
      push!(ex, id, blkin.id)
    end
  end
end

"""
Remap indices from 1-based to 0-based for indexing instructions.

Indexing instructions include those whose opcode is:
- `VectorExtractDynamic`
- `AccessChain`
- `InBoundsAccessChain`
- `CompositeExtract`
"""
struct RemapDynamic1BasedIndices <: FunctionPass end

remap_dynamic_1based_indices!(ir::IR) = RemapDynamic1BasedIndices()(ir)

function index_arguments(ex::Expression)
  n = lastindex(ex)
  @match ex.op begin
    &OpCompositeExtract || &OpVectorExtractDynamic || &OpAccessChain || &OpInBoundsAccessChain || &OpPtrAccessChain || &OpInBoundsPtrAccessChain => 2:n
    &OpImageRead || &OpImageWrite || &OpImageFetch || &OpImageSparseFetch || &OpImageSparseRead => 2:2
    &OpImageTexelPointer => 2:3
    _ => 1:0
  end
end

function (::RemapDynamic1BasedIndices)(ir::IR, fdef::FunctionDefinition)
  for blk in fdef
    insert = Pair{Int,Expression}[]
    for ex in blk
      in(ex.op, (OpCompositeExtract, OpVectorExtractDynamic, OpAccessChain, OpInBoundsAccessChain, OpImageRead, OpImageSparseRead, OpImageWrite, OpImageFetch, OpImageSparseFetch)) || continue
      if ex.op == OpImageRead
        (; image) = retrieve_type(ex[1], fdef, ir)
        # For subpass data, coordinates are relative, i.e. they should be zero-based offsets.
        image.dim == DimSubpassData && continue
      end
      indices = index_arguments(ex)
      isempty(indices) && continue
      for i in indices
        arg = ex[i]
        isa(arg, ResultID) || continue
        type = retrieve_type(arg, fdef, ir)
        T = builtin_type(ir, type)
        one = Constant(1U, integer_type(32, false))
        one_id = emit_constant!(ir, one)
        c = @match T begin
          &UInt32 => one
          &Vec2U => Constant(fill(one_id, 2), type)
          &Vec3U => Constant(fill(one_id, 3), type)
        end
        cid = emit_constant!(ir, c)
        ret = next!(ir.idcounter)
        decrement = @ex ret = ISub(arg, cid)::type
        j = findfirst(x -> x === ex, blk)
        push!(insert, j => decrement)
        ex[i] = ret
      end
    end
    for (i, ex) in reverse(insert)
      insert!(blk.exs, i, ex)
    end
  end
end

"""
Turn `CompositeExtract(%x, %index)` into `VectorExtractDynamic(%x, %index)` for vector types.
"""
struct CompositeExtractToVectorExtractDynamic <: FunctionPass end

composite_extract_to_vector_extract_dynamic!(ir::IR) = CompositeExtractToVectorExtractDynamic()(ir)

function (::CompositeExtractToVectorExtractDynamic)(ir::IR, fdef::FunctionDefinition)
  for blk in fdef
    for (i, ex) in enumerate(blk)
      if ex.op === OpCompositeExtract
        length(ex) == 2 || continue
        x = ex[1]::ResultID
        type = retrieve_type(x, fdef, ir)
        istype(type, SPIR_TYPE_VECTOR) || continue
        index = ex[2]::Union{UInt32, ResultID}
        isa(index, ResultID) || continue
        blk[i] = @set ex.op = OpVectorExtractDynamic
      end
    end
  end
  ir
end

"""
Turn `CompositeExtract(%x, %index, %indices...)` into `CompositeExtract(%x, <literal>, <literals...>)`
assuming that indices are either already literals or [`ResultID`](@ref)s of constant 32-bit unsigned integers.
"""
struct CompositeExtractDynamicToLiteral <: FunctionPass end

composite_extract_dynamic_to_literal!(ir::IR) = CompositeExtractDynamicToLiteral()(ir)

function (::CompositeExtractDynamicToLiteral)(ir::IR, fdef::FunctionDefinition)
  for blk in fdef
    for ex in blk
      if ex.op == OpCompositeExtract
        for i in 2:length(ex)
          index = ex[2]::Union{UInt32, ResultID}
          if isa(index, ResultID)
            c = get(ir.constants, index, nothing)
            isnothing(c) && break
            c.type == integer_type(32, false) || throw_compilation_error("Expected 32-bit unsigned integer type for index constant, got $(c.type)")
            ex[2] = c.value
          end
        end
      end
    end
  end
  ir
end

struct ConstantPropatation <: FunctionPass end

propagate_constants!(ir::IR) = ConstantPropatation()(ir)

function (::ConstantPropatation)(ir::IR, fdef::FunctionDefinition)
  replacements = Dictionary{ResultID, ResultID}()
  for blk in fdef
    for ex in blk
      if is_constprop_eligible(ex, ir, replacements)
        args = map(ex.args) do x
          !isa(x, ResultID) && return x
          c = ir.constants[get(replacements, x, x)]
          c.value
        end
        f = intrinsic_function(ex, ir)
        ret = f(args...)
        result = Constant(ret)
        get!(() -> next!(ir.idcounter), ir.types, result.type)
        insert!(replacements, ex.result, get!(() -> next!(ir.idcounter), ir.constants, result))
      end
    end
  end
  replace_results!(ir, fdef, replacements)
end

function replace_results!(ir::IR, fdef::FunctionDefinition, replacements::Dictionary{ResultID,ResultID})
  for blk in fdef
    block_deletions = Int[]
    for (i, ex) in enumerate(blk)
      for (j, arg) in enumerate(ex)
        isa(arg, ResultID) || continue
        replacement = get(replacements, arg, nothing)
        isnothing(replacement) && continue
        ex[j] = replacement
      end
      isnothing(ex.result) && continue
      haskey(replacements, ex.result) && push!(block_deletions, i)
    end
    for (; result) in blk[block_deletions]
      haskey(ir.debug.names, result) && delete!(ir.debug.names, result)
      haskey(ir.metadata, result) && delete!(ir.metadata, result)
    end
    splice!(blk.exs, block_deletions)
  end
  fdef
end

PROPAGATED_INTRINSICS = Set([
  OpISub,
  OpUConvert,
])

function intrinsic_function(opcode::OpCode)
  opname = last(split(repr(opcode), '.'))
  fname = Symbol(replace(opname, r"^(?:Op|OpGLSL)" => ""))
  !isdefined(@__MODULE__, fname) && return nothing
  f = getproperty(@__MODULE__, fname)
end

function intrinsic_function(ex::Expression, ir::IR)
  f = intrinsic_function(ex.op)
  @match ex.op begin
    &OpUConvert || &OpSConvert || &OpFConvert => begin
      T = builtin_type(ir, ex.type)
      x -> f(T, x)
    end
    _ => f
  end
end

function is_constprop_eligible(ex::Expression, ir::IR, replacements)
  !in(ex.op, PROPAGATED_INTRINSICS::Set{OpCode}) && return false
  isnothing(ex.result) && return false
  all(x -> !isa(x, ResultID) || haskey(ir.constants, get(replacements, x, x)), ex)
end


error_no_builtin_type_known(t) = error("No built-in Julia type is known for `$t`")

function builtin_type(ir::IR, type::SPIRType)
  is_scalar(type) && return scalar_julia_type(type)
  @match type.typename begin
    &SPIR_TYPE_VECTOR => begin
      (; eltype, n) = type.vector
      Vec{n, builtin_type(ir, eltype)}
    end
    &SPIR_TYPE_MATRIX => begin
      (; eltype, n, is_column_major) = type.matrix
      m = eltype.vector.n
      is_column_major && return Mat{m, n, builtin_type(eltype)}
      Mat{n, m, builtin_type(ir, eltype)}
    end
    &SPIR_TYPE_ARRAY => begin
      (; eltype, size) = type.array
      isnothing(size) && return Vector{builtlin_type(ir, eltype)}
      Arr{size, builtin_type(ir, eltype)}
    end
    &SPIR_TYPE_STRUCT => begin
      # XXX: Use a bidirectional map if this becomes too slow at scale.
      for (T, other) in pairs(ir.tmap.d)
        other == type && return T
      end
      error_no_builtin_type_known(type)
    end
    &SPIR_TYPE_POINTER => Pointer{builtin_type(ir, type.pointer.type)}
  end
end

"""
Replace `Nop`s by their operands, making it act either as:
- An identity operation, for instructions of the form `y = Nop(x)`
- A meaningless instruction, as originally intended by the SPIR-V specification, for instructions of the form `x = Nop()`. In such a case, the result ID `x` should not be used elsewhere.
"""
struct RemoveOpNop <: FunctionPass end

remove_op_nops!(ir::IR) = RemoveOpNop()(ir)

function (::RemoveOpNop)(fdef::FunctionDefinition)
  replacements = Dictionary{ResultID,ResultID}()
  for blk in fdef
    to_remove = Int64[]
    for (i, ex) in enumerate(blk)
      if ex.op === OpNop
        push!(to_remove, i)
        if !isempty(ex)
          @assert length(ex) == 1
          value = ex[1]::ResultID
          insert!(replacements, ex.result, value)
        end
      end
      for (j, arg) in enumerate(ex)
        isa(arg, ResultID) || continue
        replacement = get(replacements, arg, nothing)
        isnothing(replacement) && continue
        while true
          further_replacement = get(replacements, replacement, nothing)
          isnothing(further_replacement) && break
          replacement = further_replacement
        end
        ex[j] = replacement
      end
    end
    splice!(blk.exs, to_remove)
  end
end

struct CompositeExtractToAccessChainLoad <: FunctionPass end

composite_extract_to_access_chain_load!(ir::IR) = CompositeExtractToAccessChainLoad()(ir)

function (::CompositeExtractToAccessChainLoad)(ir::IR, fdef::FunctionDefinition)
  for blk in fdef
    for (i, ex) in enumerate(blk)
      ex.op == OpCompositeExtract || continue
      length(ex) == 2 || continue
      composite, index = ex
      isa(index, ResultID) || continue
      composite_t = retrieve_type(composite, fdef, ir)
      istype(composite_t, SPIR_TYPE_ARRAY) || continue

      patch = Expression[]
      # 1. Create a Variable if `composite` does not result from a load instruction.
      def = definition(composite, fdef, ir)
      def_id = @match def begin
        ::ResultID => def
        ::Constant => ir.constants[def]
        ::Variable => ir.global_vars[def]
        ::Expression => def.result
      end
      storage_class, ptr_id = if isa(def, Variable)
        def.storage_class, composite
      elseif isa(def, Expression) && def.op == OpLoad
        from = def[1]::ResultID
        if haskey(ir.global_vars, from)
          var = definition(from, fdef, ir)::Variable
          var.storage_class, from
        else
          j = findfirst(ex -> ex.result === from, fdef.local_vars)
          @assert !isnothing(j) "Loading from a non-variable pointer, which is not supported for this pass"
          var_ex = fdef.local_vars[j]
          var_ex[1], from
        end
      else
        var = Variable(composite_t)
        allocation = create_variable!(ir, fdef, var, next!(ir.idcounter))
        # Store to Variable.
        push!(patch, @ex Store(allocation.result, def_id))
        var.storage_class, allocation.result
      end
      # 2. Construct AccessChain pointer.
      access_chain_type = pointer_type(storage_class, ex.type)
      access_chain = @ex next!(ir.idcounter) = AccessChain(ptr_id, index)::access_chain_type
      push!(patch, access_chain)
      # 3. Load through the pointer.
      load = @ex ex.result = Load(access_chain.result)::ex.type
      push!(patch, load)
      ex[2] = load.result
      deleteat!(blk, i)
      insert!(blk, i, patch)
    end
  end
end

function definition(id::ResultID, fdef::FunctionDefinition, ir::IR)
  @something definition(id, fdef) definition(id, ir) Some(nothing)
end

function definition(id::ResultID, fdef::FunctionDefinition)
  i = findfirst(==(id), fdef.args)
  !isnothing(i) && return fdef.args[i]
  i = findfirst(==(id), fdef.block_ids)
  !isnothing(i) && return fdef.blocks[fdef.block_ids[i]]
  for blk in fdef
    for ex in blk
      ex.result === id && return ex
    end
  end
end

function definition(id::ResultID, ir::IR)
  var = get(ir.global_vars, id, nothing)
  !isnothing(var) && return var
  c = get(ir.constants, id, nothing)
  !isnothing(c) && return c
  fdef = get(ir.fdefs, id, nothing)
  !isnothing(fdef) && return fdef
  nothing
end

function type_definition(id::ResultID, ir::IR)
  t = get(ir.constants, id, nothing)
  !isnothing(t) && return t
  x = definition(id, ir)::Union{Constant, Variable, FunctionDefinition}
  x.type
end

function retrieve_type(id::ResultID, fdef::FunctionDefinition, ir::IR)
  def = definition(id, fdef, ir)
  @match def begin
    ::Expression => def.type
    ::Variable => def.type.pointer.type
    ::Constant => def.type
    ::ResultID => begin
      # The definition comes from a function argument.
      # We need to extract the type from the function signature.
      i = findfirst(==(def), fdef.args)::Int
      fdef.type.function.argtypes[i]
    end
    ::Block => throw(ArgumentError("Blocks don't have types"))
  end
end

struct EgalToRecursiveEqual <: FunctionPass end

egal_to_recursive_equal!(ir::IR) = EgalToRecursiveEqual()(ir)

function (::EgalToRecursiveEqual)(ir::IR, fdef::FunctionDefinition)
  (; idcounter) = ir
  for blk in fdef
    i = firstindex(blk)
    while i ≤ lastindex(blk)
      original_blk = blk
      ex = blk[i]
      ex.op == OpEgal || ((i += 1) & continue)
      exs = splice!(blk, i:lastindex(blk))
      popfirst!(exs)
      tx = retrieve_type(ex[1], fdef, ir)
      ty = retrieve_type(ex[2], fdef, ir)
      @assert tx === ty
      current_blk = Ref(blk)
      emit_recursive_equal!(current_blk, ir, fdef, blk, ex[1], ex[2], tx)
      blk = current_blk[]
      isegal = blk[end]
      blk[end] = @set isegal.result = ex.result
      i = lastindex(blk) + 1
      append!(blk, exs)
      blk !== original_blk && remap_phi_sources!(targets(blk, fdef), original_blk => blk)
    end
  end
end

function emit_recursive_equal!(current_blk::Ref{Block}, ir::IR, fdef::FunctionDefinition, blk::Block, x::ResultID, y::ResultID, type::SPIRType)
  (; idcounter) = ir
  B = boolean_type()
  U32 = integer_type(32, false)

  @switch type.typename begin
    @case &SPIR_TYPE_BOOLEAN || &SPIR_TYPE_INTEGER || &SPIR_TYPE_FLOAT
    result = next!(idcounter)
    ex = @ex result = equality_operator(type)(x, y)::B
    push!(blk, ex)

    @case &SPIR_TYPE_VECTOR
    (; eltype, n) = type.vector
    intermediate_result, result = next!(idcounter), next!(idcounter)
    push!(blk, @ex intermediate_result = equality_operator(eltype)(x, y)::vector_type(B, n))
    push!(blk, @ex result = All(intermediate_result)::B)

    @case &SPIR_TYPE_MATRIX
    (; eltype, n) = type.matrix
    ids = ResultID[]
    for i in 1:n
      cx, cy = next!(idcounter), next!(idcounter)
      xex = @ex cx = CompositeExtract(x, (i - 1)U)::eltype
      yex = @ex cy = CompositeExtract(y, (i - 1)U)::eltype
      push!(blk, xex, yex)
      ex = emit_recursive_equal!(current_blk, ir, fdef, blk, xex.result, yex.result, eltype)
      push!(ids, ex.result)
    end
    # Unroll all comparisons.
    foldl(ids) do x, y
      ex = @ex next!(idcounter) = LogicalAnd(x, y)::B
      push!(blk, ex)
      ex.result
    end

    @case &SPIR_TYPE_VOID
    push!(blk, @ex next!(idcounter) = ConstantTrue()::B)

    @case &SPIR_TYPE_STRUCT
    (; members) = type.struct
    if iszero(length(members))
      push!(blk, @ex next!(idcounter) = ConstantTrue()::B)
    else
      ids = ResultID[]
      for (i, member_type) in enumerate(members)
        subx, suby = next!(idcounter), next!(idcounter)
        xex = @ex subx = CompositeExtract(x, (i - 1)U)::member_type
        yex = @ex suby = CompositeExtract(y, (i - 1)U)::member_type
        push!(blk, xex, yex)
        ex = emit_recursive_equal!(current_blk, ir, fdef, blk, xex.result, yex.result, member_type)
        push!(ids, ex.result)
      end
      # Unroll all comparisons.
      foldl(ids) do x, y
        ex = @ex next!(idcounter) = LogicalAnd(x, y)::B
        push!(blk, ex)
        ex.result
      end
    end

    @case &SPIR_TYPE_ARRAY
    (; eltype, size) = type.array
    # Iterate over all array elements.
    # The array must be statically sized.
    isnothing(size) && error("Arrays must be statically sized for `===` comparisons.")
    n = Int(size.value)
    header = new_block!(fdef, next!(idcounter))
    body = new_block!(fdef, next!(idcounter))
    merge = new_block!(fdef, next!(idcounter))
    branch!(blk, header)

    start = emit_constant!(ir, Constant(0U))
    stop = emit_constant!(ir, Constant((n)U))
    one = emit_constant!(ir, Constant(1U))
    c_true = emit_constant!(ir, Constant(true))
    i, result = next!(idcounter, 2)
    # XXX: Use intermediate results only, no variables with OpPhi if necessary.
    allocate_variable!(ir, fdef, Variable(U32, StorageClassFunction, start), i)
    allocate_variable!(ir, fdef, Variable(B, StorageClassFunction, c_true), result)

    i_load, result_load, iter_remaining, cond = next!(idcounter, 4)
    push!(header, @ex i_load = Load(i)::U32)
    push!(header, @ex result_load = Load(result)::B)
    push!(header, @ex iter_remaining = ULessThan(i_load, stop)::B)
    push!(header, @ex cond = LogicalAnd(iter_remaining, result_load)::B)
    branch!(header, cond, body, merge)

    i_load_2, xex, yex, result_load_2, intermediate_result, i_incremented = next!(idcounter, 6)
    push!(body, @ex i_load_2 = Load(i)::U32)
    push!(body, @ex xex = CompositeExtract(x, i_load_2)::eltype)
    push!(body, @ex yex = CompositeExtract(y, i_load_2)::eltype)
    comp = emit_recursive_equal!(current_blk, ir, fdef, body, xex, yex, eltype)
    push!(body, @ex result_load_2 = Load(result)::B)
    push!(body, @ex intermediate_result = LogicalAnd(result_load_2, comp.result)::B)
    push!(body, @ex Store(result, intermediate_result))
    push!(body, @ex i_incremented = IAdd(i_load_2, one)::U32)
    push!(body, @ex Store(i, i_incremented))
    branch!(body, header)

    reduced_result = next!(idcounter)
    push!(merge, @ex reduced_result = Load(result)::B)

    current_blk[] = merge
    blk = merge
  end
  blk[end]
end

function equality_operator(type::SPIRType)
  @match type.typename begin
    &SPIR_TYPE_BOOLEAN => OpLogicalEqual
    &SPIR_TYPE_INTEGER => OpIEqual
    &SPIR_TYPE_FLOAT => OpFOrdEqual
  end
end

"""
Remove blocks that consist of a single `Branch` instruction if such removal may be done without
affecting semantics.

The intended use case is to simplify long chains that may come from inlining and constant propagation,
which appear as nested folding `goto`s in Julia IR.

!!! warning
    This does not currently update merge header information and should not be attempted on IR that has `LoopMerge` or `SelectionMerge` instructions.
"""
struct CompactBlocks <: FunctionPass end

compact_blocks!(ir::IR) = CompactBlocks()(ir)

function (::CompactBlocks)(ir::IR, fdef::FunctionDefinition)
  cfg = ControlFlowGraph(fdef)
  merged_to = IdDict{Int, Int}()
  block_deletions = Int[]
  remaining = collect(1:length(fdef))
  for i in remaining
    blk = fdef[i]
    length(blk) == 2 || continue
    ex = termination_expression(blk)
    ex.op == OpBranch || continue
    next = fdef[ex[1]::ResultID]
    all(ex -> !in(blk.id, phi_sources(ex)), phi_expressions(next)) || continue
    v = block_index(fdef, blk)
    if !isempty(inneighbors(cfg, v))
      length(inneighbors(cfg, v)) == 1 || continue
      u = inneighbors(cfg, v)[1]
      u = get(merged_to, u, u)
      prev = fdef[u]
      branch_type = opcode(termination_expression(prev))
      substitute_targets!(prev, blk => next)
      new_branch_type = opcode(termination_expression(prev))
      branch_type != new_branch_type && new_branch_type == OpBranch && push!(remaining, u)
      merged_to[v] = u
    end
    # XXX: Update existing `LoopMerge`/`SelectionMerge` if any, or prevent
    # simplification if the block was declared a merge target by another block.
    # Currently this should run before the restructuring passes, so it is fine.
    push!(block_deletions, i)
  end
  unique!(sort!(block_deletions))
  delete!(fdef, block_deletions)
end

phi_sources(ex::Expression) = @view ex[2:2:end]

function substitute_targets!(blk::Block, (old, new)::Pair{Block})
  ex = termination_expression(blk)
  for i in branch_target_indices(ex)
    ex[i] === old.id && (ex[i] = new.id)
  end
  simplified = simplify_branches(ex)
  ex !== simplified && (blk[end] = simplified)
  simplified
end

function simplify_branches(ex::Expression)
  @match ex.op begin
    &OpBranchConditional => ex[2]::ResultID == ex[3]::ResultID ? @ex(Branch(ex[2]::ResultID)) : ex
    &OpSwitch => begin
      indices = branch_target_indices(ex)
      keep = Int[]
      covered = Set{ResultID}()
      for i in indices
        target = ex[i]::ResultID
        in(target, covered) && continue
        push!(covered, target)
        push!(keep, i)
      end
      length(keep) == 1 && return @ex Branch(ex[keep[1]]::ResultID)
      selector, default = ex[1]::ResultID, ex[2]::ResultID
      ret = @ex Switch(selector, default)
      for i in keep
        push!(ret.args, ex[i - 1]) # literal
        push!(ret.args, ex[i]::ResultID) # label
      end
      ret
    end
    _ => ex
  end
end
