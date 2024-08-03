function emit_expression!(mt::ModuleTarget, tr::Translation, target::SPIRVTarget, fdef::FunctionDefinition, jinst, jtype::Type, blk::Block)
  isa(jinst, GlobalRef) && return (emit_constant!(mt, tr, follow_globalref(jinst)), spir_type(jtype, tr.tmap))
  (opcode, args) = @match jinst begin
    Expr(:new, T, args...) => (OpCompositeConstruct, args)
    ::Core.PhiNode => begin
      args = []
      for (e, val) in zip(jinst.edges, jinst.values)
        # `e` is the index of the last instruction of the block `val` is assigned to.
        from = ResultID(findfirst(Fix1(in, e), block_ranges(target)), tr)
        push!(args, val, from)
      end
      (OpPhi, args)
    end
    :($f($(args...))) => @match follow_globalref(f) begin
      # Loop constructs use `Base.not_int` seemingly from the C code, so we
      # need to handle it if encountered.
      &Base.not_int => (OpLogicalNot, args)
      # There sometimes remain quite a few calls to this intrinsic, so let's avoid having to reimplement a bunch of methods.
      &Base.bitcast => (OpBitcast, args[2:2])
      &Base.have_fma => return (emit!(mt, tr, Constant(true)), BooleanType())
      ::Core.IntrinsicFunction => throw_compilation_error("reached unsupported core intrinsic function '$f'")
      &getfield => begin
        # If a third argument is provided, we ignore it; it indicates whether the field access is checked,
        # and for SPIR-V code there is no way to express such checks.
        composite = args[1]
        field_idx = @match args[2] begin
          node::QuoteNode => get_field_index(composite, node, tr, target)
          idx::Integer => idx
          idx::Core.SSAValue => @match spir_type(target, tr, args[1]) begin
            # Dynamic accesses into arrays are supported, but not via
            # CompositeExtract; we'll need to convert this instruction
            # to a suitable AccessChain + Load chain.
            # We do this in the pass `composite_extract_to_access_chain_load!`.
            # XXX: `idx` may be an `Int64`.
            ::ArrayType => idx
            _ => throw_compilation_error("dynamic access into inhomogeneous tuple or struct members is not supported")
          end
        end
        (OpCompositeExtract, (composite, field_idx))
      end
      &setfield! => begin
        composite = args[1]
        field_idx = @match args[2] begin
          node::QuoteNode => get_field_index(composite, node, tr, target)
          idx::Core.SSAValue => @match spir_type(target, tr, args[1]) begin
            ::ArrayType => throw_compilation_error("dynamic `setfield!` into homogeneous tuples is not yet supported")
            _ => throw_compilation_error("dynamic `setfield!` into inhomogeneous tuple or struct members is not supported")
          end
          idx::Integer => idx
          field => throw_compilation_error("unknown field type $(typeof(field))")
        end
        value = args[3]
        throw_compilation_error("`setfield!` not supported at the moment")
      end
      &Core.tuple => (OpCompositeConstruct, args)
      &(===) => begin
        x, y = args
        x, y = follow_globalref.((x, y))
        type = BooleanType()
        Tx, Ty = retrieve_type(target, tr, x), retrieve_type(target, tr, y)
        if Tx !== Ty
          ret = emit!(mt, tr, Constant(false))
          return (ret, BooleanType())
        else
          ismutabletype(Tx) && throw_compilation_error("(===) is not supported between mutable values yet, nor between values of immutable types with mutable fields")
          xid = isa(x, LiteralValue) ? emit!(mt, tr, Constant(x)) : ResultID(x, tr)
          yid = isa(y, LiteralValue) ? emit!(mt, tr, Constant(y)) : ResultID(y, tr)
          (OpEgal, args)
        end
      end
      ::Function && if jtype === Union{} end => throw_compilation_error("unresolved call to function `$f`, indicating a `MethodError`")
      &Base.fieldtype => throw_compilation_error("call to unsupported built-in function `$f`")
      ::Function => throw_compilation_error("dynamic dispatch detected for function `$f`. All call sites must be statically resolved")
      _ => throw_compilation_error("call to unknown function `$f`")
    end
    Expr(:invoke, mi, f, args...) => begin
      f = @match f begin
        ::Core.SSAValue => begin
          value = get(tr.globalrefs, f, nothing)
          isnothing(value) && throw_compilation_error("call to non-global object `$f` detected. All function calls must be made to globally defined symbols; if using a closure, the closure must be inlined")
          value
        end
        ::Core.Argument => throw_compilation_error("call to function argument `$f` detected. All function calls must be made to globally defined symbols; if using a closure, the closure must be inlined")
        ::GlobalRef => f
        _ => throw_compilation_error("call to function argument `$f` detected. All function calls must be made to globally defined symbols")
      end
      if f.mod == @__MODULE__() || !in(f.mod, (Base, Core))
        opcode = lookup_opcode(f.name)
        if !isnothing(opcode)
          !isempty(args) && isa(follow_globalref(first(args)), DataType) && (args = args[2:end])
          @switch opcode begin
            @case ::OpCode
            (opcode, args)
            @case ::OpCodeGLSL
            args = (emit_extinst!(mt, "GLSL.std.450"), opcode, args...)
            (OpExtInst, args)
          end
        else
          args, globals = peel_global_vars(args, mt, tr, fdef)
          (OpFunctionCall, (emit_new!(mt, tr, target, mi, fdef, globals), args...))
        end
      else
        args, globals = peel_global_vars(args, mt, tr, fdef)
        (OpFunctionCall, (emit_new!(mt, tr, target, mi, fdef, globals), args...))
      end
    end
    Expr(:foreigncall, f, _...) => begin
      isa(f, QuoteNode) && (f = f.value)
      throw_compilation_error("foreign call detected (to function `$f`). Foreign calls are not supported in SPIR-V")
    end
    _ => throw_compilation_error("expected call or invoke expression, got $(repr(jinst))")
  end

  args = collect(Any, args)

  if opcode in (OpCompositeExtract, OpCompositeInsert, OpVectorShuffle, OpAccessChain)
    for (i, arg) in enumerate(args)
      isa(arg, Integer) || continue
      # Turn literal 1-based indexing into 0-based literal indexing.
      # Constant indices in OpAccessChain will later show up as ResultIDs, which will be remapped by `remap_dynamic_1based_indices!`.
      opcode ≠ OpAccessChain && (arg -= 1U)
      # Force literal to be 32-bit.
      args[i] = UInt32(arg)
    end
  end

  type = in(opcode, (OpStore, OpImageWrite, OpControlBarrier, OpMemoryBarrier)) ? nothing : spir_type(jtype, tr.tmap)

  isa(jinst, Core.PhiNode) && ismutabletype(jtype) && (type = PointerType(StorageClassFunction, type))
  if isa(type, PointerType) && opcode in (OpAccessChain, OpPtrAccessChain)
    # Propagate storage class to the result.
    ptr = first(args)
    sc = storage_class(ptr, mt, tr, fdef)
    if isnothing(sc)
      @assert type.storage_class == StorageClassPhysicalStorageBuffer
    else
      type = @set type.storage_class = sc
    end
  end

  remap_args!(args, mt, tr, opcode)

  result = in(opcode, (OpStore, OpImageWrite, OpControlBarrier, OpMemoryBarrier)) ? nothing : next!(mt.idcounter)

  ex = @ex result = opcode(args...)::type
  (ex, type)
end

function get_field_index(composite_type, field::QuoteNode, tr::Translation, target::SPIRVTarget)
  isa(field.value, Symbol) || throw_compilation_error("`Symbol` value expected in `QuoteNode`, got $(repr(field.value))")
  name = field.value::Symbol
  T = get_type(composite_type, tr, target)
  t = tr.tmap[T]
  isa(t, Union{ArrayType, VectorType, MatrixType}) && name === :data && throw_compilation_error("accessing the `:data` tuple field of vectors, arrays and matrices is forbidden")
  index = findfirst(==(name), fieldnames(T))
  !isnothing(index) || throw_compilation_error("symbol $(repr(name)) is not a field of $T (fields: $(repr.(fieldnames(T))))")
  index
end

retrieve_type(target::SPIRVTarget, tr::Translation, x::GlobalRef) = retrieve_type(target, tr, follow_globalref(x))
retrieve_type(target::SPIRVTarget, tr::Translation, x::Core.SSAValue) = target.code.ssavaluetypes[x.id]
retrieve_type(target::SPIRVTarget, tr::Translation, x::Core.Argument) = tr.argtypes[x.n - 1]
retrieve_type(target::SPIRVTarget, tr::Translation, x::Number) = typeof(x)
spir_type(target::SPIRVTarget, tr::Translation, x) = spir_type(retrieve_type(target, tr, x), tr.tmap, fill_tmap = false)

function lookup_opcode(fname::Symbol)
  op = try_getopcode(fname)
  !isnothing(op) && return op::OpCode
  op = try_getopcode(fname, :GLSL)
  !isnothing(op) && return op::OpCodeGLSL
  nothing
end

function get_type(arg, tr::Translation, target::SPIRVTarget)
  @match arg begin
    ::Core.SSAValue => target.code.ssavaluetypes[arg.id]
    ::Core.Argument => tr.argtypes[tr.argmap[arg]]
    _ => throw_compilation_error("cannot extract type from argument $arg")
  end
end

function storage_class(arg, mt::ModuleTarget, tr::Translation, fdef::FunctionDefinition)
  var_or_type = @match arg begin
    ::Core.SSAValue => get(tr.variables, arg, nothing)
    ::Core.Argument => begin
      id = tr.args[arg]
      lvar_idx = findfirst(==(id), fdef.args)
      !isnothing(lvar_idx) ? fdef.type.argtypes[lvar_idx] : nothing
    end
    ::ResultID => get(mt.global_vars, arg, nothing)
    _ => nothing
  end
  @match var_or_type begin
    ::PointerType || ::Variable => var_or_type.storage_class
    _ => nothing
  end
end

function peel_global_vars(args, mt::ModuleTarget, tr::Translation, fdef)
  fargs = []
  globals = Dictionary{Int,Union{Constant,Variable}}()
  for (i, arg) in enumerate(args)
    @switch storage_class(arg, mt, tr, fdef) begin
      @case ::Nothing || &StorageClassFunction
      push!(fargs, arg)
      @case sc::StorageClass
      id = isa(arg, Core.Argument) ? ResultID(arg, tr) : arg::ResultID
      variable = get(mt.global_vars, id, nothing)
      isnothing(variable) && throw_compilation_error("expected $id with storage class $sc to point to a global variable")
      insert!(globals, i, variable)
    end
  end
  fargs, globals
end

function try_getopcode(name, prefix = "")
  maybe_opname = Symbol(:Op, prefix, name)
  isdefined(@__MODULE__, maybe_opname) ? getproperty(@__MODULE__, maybe_opname) : nothing
end

function remap_args!(args, mt::ModuleTarget, tr::Translation, opcode)
  replace_core_arguments!(args, tr)
  replace_ssa!(args, tr, opcode)
  replace_globalrefs!(args)
  literals_to_const!(args, mt, tr, opcode)
  const_to_literals!(args, mt, tr, opcode)
  args
end

"Replace `Core.Argument` by `ResultID`."
function replace_core_arguments!(args, tr::Translation)
  for (i, arg) in enumerate(args)
    isa(arg, Core.Argument) && (args[i] = ResultID(arg, tr))
  end
end

"Replace `Core.SSAValue` by `ResultID`, ignoring forward references."
function replace_ssa!(args, tr::Translation, opcode)
  for (i, arg) in enumerate(args)
    # Phi nodes may have forward references.
    isa(arg, Core.SSAValue) && opcode ≠ OpPhi && (args[i] = ResultID(arg, tr))
  end
end

"Replace `GlobalRef`s by their actual values."
function replace_globalrefs!(args)
  for (i, arg) in enumerate(args)
    isa(arg, GlobalRef) && (args[i] = follow_globalref(arg))
  end
end

"Turn all literals passed in non-literal SPIR-V operands into `Constant`s."
function literals_to_const!(args, mt::ModuleTarget, tr::Translation, opcode)
  for (i, arg) in enumerate(args)
    isa(arg, ResultID) && continue
    is_literal(opcode, args, i) && continue
    if isa(arg, Core.SSAValue)
      @assert opcode == OpPhi
      continue
    end
    isa(arg, QuoteNode) && (arg = arg.value)
    args[i] = emit_constant!(mt, tr, arg)
  end
end

"Turn all literals passed in non-literal SPIR-V operands into `Constant`s."
function const_to_literals!(args, mt::ModuleTarget, tr::Translation, opcode)
  for (i, arg) in enumerate(args)
    if isa(arg, ResultID) && is_literal(opcode, args, i)
      c = get(mt.constants, arg, nothing)
      isnothing(c) && continue
      args[i] = c.value
    end
  end
end

function emit_new!(mt::ModuleTarget, tr::Translation, from::SPIRVTarget, mi::MethodInstance, fdef::FunctionDefinition, globals)
  (; interp) = from
  target = SPIRVTarget(mi, interp)
  add_frame_lineno!(interp.debug, tr, from)
  ret = emit!(mt, Translation(target, tr.tmap, tr.types), target, globals)
  remove_frame_lineno!(interp.debug)
  ret
end

function add_frame_lineno!(debug::InterpDebugInfo, tr::Translation, from::SPIRVTarget)
  iszero(tr.index) && return
  line = getline(from.code, tr.index)[end]
  frame = debug.stacktrace[end]
  debug.stacktrace[end] = @set frame.line = line
end

function remove_frame_lineno!(debug::InterpDebugInfo)
  frame = debug.stacktrace[end]
  debug.stacktrace[end] = @set frame.line = nothing
end
