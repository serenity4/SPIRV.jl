function emit_inst!(ir::IR, irmap::IRMapping, target::SPIRVTarget, fdef::FunctionDefinition, jinst, jtype::Type, blk::Block)
  type = spir_type(jtype, ir)
  isa(jinst, Core.PhiNode) && ismutabletype(jtype) && (type = PointerType(StorageClassFunction, type))
  (opcode, args) = @match jinst begin
    Expr(:new, T, args...) => (OpCompositeConstruct, args)
    ::Core.PhiNode => begin
      args = []
      for (e, val) in zip(jinst.edges, jinst.values)
        # `e` is the SSA value of the last instruction of the block `val` is assigned to.
        from = SSAValue(findfirst(Fix1(in, e), block_ranges(target)), irmap)
        push!(args, val, from)
      end
      # Repeat an arbitrary value for unspecified blocks.
      for from in inneighbors(target.cfg, irmap.bbs[blk.id])
        # Remap `from` to a SSAValue, using the SSA value of the first Julia instruction in that block.
        from = irmap.bb_ssavals[Core.SSAValue(target.indices[from])]
        if !in(from, @view args[2:2:end])
          push!(args, args[end - 1], from)
        end
      end
      (OpPhi, args)
    end
    :($f($(args...))) => @match f begin
      ::GlobalRef => @match getfield(f.mod, f.name) begin
        # Loop constructs use `Base.not_int` seemingly from the C code, so we
        # need to handle it if encountered.
        &Base.not_int => (OpLogicalNot, args)
        ::Core.IntrinsicFunction => throw(CompilationError("Reached illegal core intrinsic function '$f'."))
        &getfield => begin
          composite = args[1]
          field_idx = @match args[2] begin
            node::QuoteNode => begin
              node.value::Symbol
              sym = (args[2]::QuoteNode).value::Symbol
              T = get_type(composite, target)
              field_idx = findfirst(==(sym), fieldnames(T))
              !isnothing(field_idx) || throw(CompilationError("Symbol $(repr(sym)) is not a field of $T (fields: $(repr.(fieldnames(T))))"))
              field_idx
            end
            idx::Integer => idx
          end
          (OpCompositeExtract, (composite, UInt32(field_idx - 1)))
        end
        ::Function => throw(CompilationError("Dynamic dispatch detected for function $f. All call sites must be statically resolved."))
      end
      _ => throw(CompilationError("Call to unknown function $f"))
    end
    Expr(:invoke, mi, f, args...) => begin
      isa(f, Core.SSAValue) && (f = irmap.globalrefs[f])
      @assert isa(f, GlobalRef)
      if f.mod == @__MODULE__() || !in(f.mod, (Base, Core))
        opcode = @when let op::OpCode = try_getopcode(f.name)
          op
          @when op::OpCodeGLSL = try_getopcode(f.name, :GLSL)
          op
        end
        if !isnothing(opcode)
          !isempty(args) && isa(first(args), DataType) && (args = args[2:end])
          @switch opcode begin
            @case ::OpCode
            (opcode, args)
            @case ::OpCodeGLSL
            args = (emit_extinst!(ir, "GLSL.std.450"), opcode, args...)
            (OpExtInst, args)
          end
        else
          args, variables = peel_global_vars(args, ir, irmap, fdef)
          (OpFunctionCall, (emit_new!(ir, target.interp, mi, fdef, variables), args...))
        end
      else
        args, variables = peel_global_vars(args, ir, irmap, fdef)
        (OpFunctionCall, (emit_new!(ir, target.interp, mi, fdef, variables), args...))
      end
    end
    _ => throw(CompilationError("Expected call or invoke expression, got $(repr(jinst))"))
  end

  args = collect(args)

  if opcode == OpAccessChain
    for (i, arg) in enumerate(args)
      # Force literal in `getindex` to be 32-bit
      isa(arg, Int) && (args[i] = UInt32(arg))
    end
  end

  if isa(type, PointerType) && opcode in (OpAccessChain, OpPtrAccessChain)
    # Propagate storage class to the result.
    ptr = first(args)
    sc = storage_class(ptr, ir, irmap, fdef)
    if isnothing(sc)
      @assert type.storage_class == StorageClassPhysicalStorageBuffer
    else
      type = @set type.storage_class = sc
    end
  end

  load_variables!(args, blk, ir, irmap, fdef, opcode)
  remap_args!(args, ir, irmap, opcode)

  if opcode == OpStore
    result_id = type_id = nothing
  else
    type_id = emit!(ir, irmap, type)
    result_id = next!(ir.ssacounter)
  end

  @inst result_id = opcode(args...)::type_id
end

function get_type(arg, target::SPIRVTarget)
  @match arg begin
    ::Core.SSAValue => target.code.ssavaluetypes[arg.id]
    ::Core.Argument => target.mi.specTypes.types[arg.n]
    _ => throw(CompilationError("Cannot extract type from argument $arg"))
  end
end

load_variable!(blk::Block, ir::IR, irmap::IRMapping, var::Variable, ssaval) = load_variable!(blk, ir, irmap, var.type, ssaval)
function load_variable!(blk::Block, ir::IR, irmap::IRMapping, type::PointerType, ssaval)
  load = @inst next!(ir.ssacounter) = OpLoad(ssaval)::SSAValue(ir, type.type)
  add_instruction!(blk, irmap, load)
  load.result_id
end

function storage_class(arg, ir::IR, irmap::IRMapping, fdef::FunctionDefinition)
  var_or_type = @match arg begin
    ::Core.SSAValue => get(irmap.variables, arg, nothing)
    ::Core.Argument => begin
      id = irmap.args[arg]
      lvar_idx = findfirst(==(id), fdef.args)
      if !isnothing(lvar_idx)
        fdef.type.argtypes[lvar_idx]
      else
        gvar = get(fdef.global_vars, arg.n - 1, nothing)
        isnothing(gvar) ? nothing : ir.global_vars[gvar]
      end
    end
    ::SSAValue => get(ir.global_vars, arg, nothing)
    _ => nothing
  end
  @match var_or_type begin
    ::PointerType || ::Variable => var_or_type.storage_class
    _ => nothing
  end
end

function peel_global_vars(args, ir::IR, irmap, fdef)
  fargs = []
  variables = Dictionary{Int,Variable}()
  for (i, arg) in enumerate(args)
    @switch storage_class(arg, ir, irmap, fdef) begin
      @case ::Nothing || &StorageClassFunction
      push!(fargs, arg)
      @case ::StorageClass
      insert!(variables, i, ir.global_vars[arg::SSAValue])
    end
  end
  fargs, variables
end

function try_getopcode(name, prefix = "")
  maybe_opname = Symbol(:Op, prefix, name)
  isdefined(@__MODULE__, maybe_opname) ? getproperty(@__MODULE__, maybe_opname) : nothing
end

function remap_args!(args, ir::IR, irmap::IRMapping, opcode)
  arguments_to_ssa!(args, irmap)
  replace_ssa!(args, irmap, opcode)
  replace_globalrefs!(args)
  literals_to_const!(args, ir, irmap, opcode)
  args
end

function load_variables!(args, blk::Block, ir::IR, irmap::IRMapping, fdef, opcode)
  for (i, arg) in enumerate(args)
    # Don't load pointers in pointer operations.
    if i == 1 && opcode in (OpStore, OpAccessChain)
      continue
    end
    # OpPhi must use variables directly (loading cannot happen before OpPhi instructions).
    opcode == OpPhi && continue
    loaded_arg = load_if_variable!(blk, ir, irmap, fdef, arg)
    !isnothing(loaded_arg) && (args[i] = loaded_arg)
  end
end

function load_if_variable!(blk::Block, ir::IR, irmap::IRMapping, fdef::FunctionDefinition, arg)
  @trymatch arg begin
    ::Core.SSAValue => @trymatch get(irmap.variables, arg, nothing) begin
        var::Variable => load_variable!(blk, ir, irmap, var, irmap.ssavals[arg])
      end
    ::Core.Argument => begin
        id = irmap.args[arg]
        var = get(ir.global_vars, id, nothing)
        !isnothing(var) && return load_variable!(blk, ir, irmap, var, id)
        index = findfirst(==(id), fdef.args)
        if !isnothing(index)
          type = fdef.type.argtypes[index]
          if isa(type, PointerType)
            load_variable!(blk, ir, irmap, type, id)
          end
        end
      end
  end
end

function arguments_to_ssa!(args, irmap::IRMapping)
  for (i, arg) in enumerate(args)
    isa(arg, Core.Argument) && (args[i] = SSAValue(arg, irmap))
  end
end

"""
Replace `Core.SSAValue` by `SSAValue`, ignoring forward references.
"""
function replace_ssa!(args, irmap::IRMapping, opcode)
  for (i, arg) in enumerate(args)
    # Phi nodes may have forward references.
    isa(arg, Core.SSAValue) && opcode ≠ OpPhi && (args[i] = SSAValue(arg, irmap))
  end
end

function replace_globalrefs!(args)
  for (i, arg) in enumerate(args)
    isa(arg, GlobalRef) && (args[i] = getproperty(arg.mod, arg.name))
  end
end

function literals_to_const!(args, ir::IR, irmap::IRMapping, opcode)
  for (i, arg) in enumerate(args)
    if isa(arg, Bool) || (isa(arg, AbstractFloat) || isa(arg, Integer) || isa(arg, QuoteNode)) && !is_literal(opcode, args, i)
      args[i] = emit!(ir, irmap, Constant(arg))
    end
  end
end

function emit_new!(ir::IR, interp::SPIRVInterpreter, mi::MethodInstance, fdef::FunctionDefinition, variables)
  emit!(ir, SPIRVTarget(mi, interp; inferred = true), variables)
end
