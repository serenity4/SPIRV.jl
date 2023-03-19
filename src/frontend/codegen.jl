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
      ::Core.IntrinsicFunction => throw_compilation_error("reached illegal core intrinsic function '$f'")
      &getfield => begin
        # If a third argument is provided, we ignore it; it indicates whether the field access is checked,
        # and for SPIR-V code there is no way to express such checks.
        composite = args[1]
        field_idx = @match args[2] begin
          node::QuoteNode => begin
            node.value::Symbol
            sym = (args[2]::QuoteNode).value::Symbol
            T = get_type(composite, target)
            T <: Union{Arr, Vec, Mat} && sym === :data && throw_compilation_error("accessing the `:data` tuple field of vectors, arrays and matrices is forbidden")
            field_idx = findfirst(==(sym), fieldnames(T))
            !isnothing(field_idx) || throw_compilation_error("symbol $(repr(sym)) is not a field of $T (fields: $(repr.(fieldnames(T))))")
            field_idx
          end
          idx::Integer => idx
          idx::Core.SSAValue => throw_compilation_error("dynamic access into tuple or struct members is not yet supported")
        end
        (OpCompositeExtract, (composite, UInt32(field_idx - 1)))
      end
      &Core.tuple => (OpCompositeConstruct, args) # throw_compilation_error("the function `Core.tuple` is not supported at the moment")
      ::Function => throw_compilation_error("dynamic dispatch detected for function $f. All call sites must be statically resolved")
      _ => throw_compilation_error("call to unknown function $f")
    end
    Expr(:invoke, mi, f, args...) => begin
      isa(f, Core.SSAValue) && (f = tr.globalrefs[f])
      @assert isa(f, GlobalRef)
      if f.mod == @__MODULE__() || !in(f.mod, (Base, Core))
        opcode = lookup_opcode(f.name)
        if !isnothing(opcode)
          !isempty(args) && isa(first(args), DataType) && (args = args[2:end])
          @switch opcode begin
            @case ::OpCode
            (opcode, args)
            @case ::OpCodeGLSL
            args = (emit_extinst!(mt, "GLSL.std.450"), opcode, args...)
            (OpExtInst, args)
          end
        else
          args, variables = peel_global_vars(args, mt, tr, fdef)
          (OpFunctionCall, (emit_new!(mt, tr, target.interp, mi, fdef, variables), args...))
        end
      else
        args, variables = peel_global_vars(args, mt, tr, fdef)
        (OpFunctionCall, (emit_new!(mt, tr, target.interp, mi, fdef, variables), args...))
      end
    end
    Expr(:foreigncall, f, _...) => begin
      isa(f, QuoteNode) && (f = f.value)
      throw_compilation_error("foreign call detected (to function `$f`). Foreign calls are not supported in SPIR-V")
    end
    _ => throw_compilation_error("expected call or invoke expression, got $(repr(jinst))")
  end

  args = collect(args)

  if opcode == OpAccessChain
    for (i, arg) in enumerate(args)
      # Force literal in `getindex` to be 32-bit
      isa(arg, Int) && (args[i] = UInt32(arg))
    end
  end

  type = opcode == OpStore ? nothing : spir_type(jtype, tr.tmap)
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

  load_variables!(args, blk, mt, tr, fdef, opcode)
  remap_args!(args, mt, tr, opcode)

  result = opcode == OpStore ? nothing : next!(mt.idcounter)

  ex = @ex result = opcode(args...)::type
  (ex, type)
end

function lookup_opcode(fname::Symbol)
  op = try_getopcode(fname)
  !isnothing(op) && return op::OpCode
  op = try_getopcode(fname, :GLSL)
  !isnothing(op) && return op::OpCodeGLSL
  nothing
end

function get_type(arg, target::SPIRVTarget)
  @match arg begin
    ::Core.SSAValue => target.code.ssavaluetypes[arg.id]
    ::Core.Argument => target.mi.specTypes.types[arg.n]
    _ => throw_compilation_error("cannot extract type from argument $arg")
  end
end

load_variable!(blk::Block, mt::ModuleTarget, tr::Translation, var::Variable, id::ResultID) = load_variable!(blk, mt, tr, var.type, id)
function load_variable!(blk::Block, mt::ModuleTarget, tr::Translation, type::PointerType, id::ResultID)
  load = @ex next!(mt.idcounter) = OpLoad(id)::type.type
  add_expression!(blk, tr, load)
  load.result
end

function storage_class(arg, mt::ModuleTarget, tr::Translation, fdef::FunctionDefinition)
  var_or_type = @match arg begin
    ::Core.SSAValue => get(tr.variables, arg, nothing)
    ::Core.Argument => begin
      id = tr.args[arg]
      lvar_idx = findfirst(==(id), fdef.args)
      if !isnothing(lvar_idx)
        fdef.type.argtypes[lvar_idx]
      else
        gvar = get(fdef.global_vars, arg.n - 1, nothing)
        isnothing(gvar) ? nothing : mt.global_vars[gvar]
      end
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
  variables = Dictionary{Int,Variable}()
  for (i, arg) in enumerate(args)
    @switch storage_class(arg, mt, tr, fdef) begin
      @case ::Nothing || &StorageClassFunction
      push!(fargs, arg)
      @case ::StorageClass
      isa(arg, Core.Argument) && (arg = ResultID(arg, tr))
      insert!(variables, i, mt.global_vars[arg::ResultID])
    end
  end
  fargs, variables
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
  args
end

function load_variables!(args, blk::Block, mt::ModuleTarget, tr::Translation, fdef, opcode)
  for (i, arg) in enumerate(args)
    # Don't load pointers in pointer operations.
    if i == 1 && opcode in (OpStore, OpAccessChain)
      continue
    end
    # OpPhi must use variables directly (loading cannot happen before OpPhi instructions).
    opcode == OpPhi && continue
    # OpFunctionCall must use variables directly, as mutable argument types will wrapped in pointers.
    opcode == OpFunctionCall && continue
    loaded_arg = load_if_variable!(blk, mt, tr, fdef, arg)
    !isnothing(loaded_arg) && (args[i] = loaded_arg)
  end
end

function load_if_variable!(blk::Block, mt::ModuleTarget, tr::Translation, fdef::FunctionDefinition, arg)
  @trymatch arg begin
    ::Core.SSAValue => @trymatch get(tr.variables, arg, nothing) begin
        var::Variable => load_variable!(blk, mt, tr, var, tr.results[arg])
      end
    ::Core.Argument => begin
        id = tr.args[arg]
        var = get(mt.global_vars, id, nothing)
        !isnothing(var) && return load_variable!(blk, mt, tr, var, id)
        index = findfirst(==(id), fdef.args)
        if !isnothing(index)
          type = fdef.type.argtypes[index]
          if isa(type, PointerType)
            load_variable!(blk, mt, tr, type, id)
          end
        end
      end
  end
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
    if isa(arg, Bool) || (isa(arg, AbstractFloat) || isa(arg, Integer) || isa(arg, QuoteNode)) && !is_literal(opcode, args, i)
      isa(arg, QuoteNode) && (arg = arg.value)
      args[i] = emit_constant!(mt, tr, arg)
    end
  end
end

function emit_new!(mt::ModuleTarget, tr::Translation, interp::SPIRVInterpreter, mi::MethodInstance, fdef::FunctionDefinition, variables)
  emit!(mt, Translation(tr.tmap, tr.types), SPIRVTarget(mi, interp; inferred = true), variables)
end
