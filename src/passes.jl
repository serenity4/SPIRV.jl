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
      pointer = def.type
      (; type, storage_class) = pointer
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

function enforce_calling_convention!(ir::IR, fdef::FunctionDefinition)
  exs = body(fdef)
  called = FunctionDefinition[]
  for ex in exs
    opcode(ex) == OpFunctionCall || continue
    callee = ir.fdefs[ex[1]::ResultID]
    !in(callee, called) && push!(called, callee)
    @assert length(ex) == length(argtypes(callee)) + 1
    for (arg, t) in zip(@view(ex[2:end]), argtypes(callee))
      arg.t::SPIRType == t && continue
      arg.t ≈ t || error("Types don't match between a function call and its defining function type: $(arg.t) ≉ $t")
      storage_class()
    end
  end
  for fdef in called
    # Recurse into function calls (but not more than once).
    enforce_calling_convention!(ir, called)
  end
  ir
end

argtypes(fdef::FunctionDefinition) = fdef.type.argtypes

"""
SPIR-V requires all branching nodes to give a result, while Julia does not if the Phi instructions
will never get used if coming from branches that are not covered.
We can make use of OpUndef to provide a value, producing it in the incoming nodes
just before branching to the node which defines a Phi instruction.
"""
function fill_phi_branches!(ir::IR)
  for fdef in ir.fdefs
    cfg = ControlFlowGraph(fdef)
    for v in traverse(cfg)
      blk = fdef[v]
      exs = phi_expressions(blk)
      for ex in exs
        length(ex) == 2length(inneighbors(cfg, v)) && continue
        missing_branches = filter(u -> !in(fdef.block_ids[u], @view ex[2:2:end]), inneighbors(cfg, v))
        for u in missing_branches
          blkin = fdef[u]
          id = next!(ir.idcounter)
          insert!(blkin, lastindex(blkin), @ex id = OpUndef()::ex.type)
          push!(ex, id, fdef.block_ids[u])
        end
      end
    end
  end
  ir
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
    &OpImageRead && if ex.type.dim ≠ DimSubpassData end || &OpImageWrite || &OpImageFetch || &OpImageSparseFetch || &OpImageSparseRead => 2:2
    &OpImageTexelPointer => 2:3
    _ => 1:0
  end
end

function (::RemapDynamic1BasedIndices)(ir::IR, fdef::FunctionDefinition)
  for blk in fdef
    insert = Pair{Int,Expression}[]
    for ex in blk
      if ex.op in (OpCompositeExtract, OpVectorExtractDynamic, OpAccessChain, OpInBoundsAccessChain)
        indices = index_arguments(ex)
        for i in indices
          arg = ex[i]
          if isa(arg, ResultID)
            j = findfirst(x -> x === ex, blk)
            c = Constant(1U)
            get!(() -> next!(ir.idcounter), ir.types, c.type)
            one = get!(() -> next!(ir.idcounter), ir.constants, c)
            ret = next!(ir.idcounter)
            decrement = @ex ret = OpISub(arg, one)::IntegerType(32, false)
            push!(insert, j => decrement)
            ex[i] = ret
          end
        end
      end
    end
    for (i, ex) in reverse(insert)
      insert!(blk.exs, i, ex)
    end
  end
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
            isnothing(c) && throw_compilation_error("In CompositeExtractDynamicToLiteral pass, expected a constant dynamic index, got reference to non-constant $index for ", sprintc_mime(show, Instruction(ex, ir.types)))
            c.type == IntegerType(32, false) || throw_compilation_error("Expected 32-bit unsigned integer type for index constant, got $(c.type)")
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
function builtin_type end

builtin_type(ir::IR, t::SPIRType) = builtin_type(t)
function builtin_type(ir::IR, t::StructType)
  for (T, t′) in pairs(ir.tmap.d)
    t′ == t && return T
  end
  error_no_builtin_type_known(t)
end

function builtin_type(t::IntegerType)
  if t.signed
    @match t.width begin
      8 => Int8
      16 => Int16
      32 => Int32
      64 => Int64
      _ => error_no_builtin_type_known(t)
    end
  else
    @match t.width begin
      8 => UInt8
      16 => UInt16
      32 => UInt32
      64 => UInt64
      _ => error_no_builtin_type_known(t)
    end
  end
end

builtin_type(t::FloatType) = @match t.width begin
  16 => Float16
  32 => Float32
  64 => Float64
  _ => error_no_builtin_type_known(t)
end

builtin_type(::BooleanType) = Bool
builtin_type(ir::IR, t::VectorType) = Vec{t.eltype,builtin_type(t.eltype)}
builtin_type(ir::IR, t::MatrixType) = t.is_column_major ? Mat{t.eltype.n, t.n, builtin_type(t.eltype.eltype)} : Mat{t.n, t.eltype.n, builtin_type(t.eltype.eltype)}
builtin_type(ir::IR, t::ArrayType) = isnothing(t.size) ? Vector{builtin_type(ir, t.eltype)} : Arr{t.size.value, builtin_type(t.eltype)}
builtin_type(ir::IR, t::PointerType) = Pointer{builtin_type(ir, t.type)}

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
      else
        for (j, arg) in enumerate(ex)
          isa(arg, ResultID) || continue
          replacement = get(replacements, arg, nothing)
          isnothing(replacement) && continue
          ex[j] = replacement
        end
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
      isa(composite_t, ArrayType) || continue

      patch = Expression[]
      # 1. Create a Variable if `composite` does not result from a load instruction.
      def = definition(composite, fdef, ir)
      def_id = isa(def, ResultID) ? def : def.result
      storage_class, ptr_id = if isa(def, Expression) && def.op == OpLoad
        from = def[1]::ResultID
        if haskey(ir.global_vars, from)
          var = definition(from, fdef, ir)::Variable
          var.storage_class, from
        else
          j = findfirst(ex -> ex.result === from, fdef.local_vars)
          # XXX: It could be that we load from a non-variable pointer.
          # In this case the typeassert will su
          @assert !isnothing(j) "Loading from a non-variable pointer, which is not supported for this pass yet"
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
      access_chain_t = PointerType(storage_class, ex.type)
      access_chain = @ex next!(ir.idcounter) = AccessChain(ptr_id, index)::access_chain_t
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
  # Look for the global variable instead.
  in(id, fdef.global_vars) && return nothing
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
    ::Variable => def.type.type
    ::Constant => SPIRType(def, ir.tmap)
    ::ResultID => begin
      # The definition comes from a function argument.
      # We need to extract the type from the function signature.
      i = findfirst(==(def), fdef.args)::Int
      fdef.type.argtypes[i]
    end
    ::Block => throw(ArgumentError("Blocks don't have types"))
  end
end
