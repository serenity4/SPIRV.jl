function emit_inst!(ir::IR, irmap::IRMapping, cfg::CFG, fdef::FunctionDefinition, jinst, jtype::Type, blk::Block)
  type = SPIRType(jtype)
  (opcode, args) = @match jinst begin
    Expr(:new, T, args...) => begin
      if any(isa(arg, Core.SSAValue) for arg in args)
        (OpCompositeConstruct, (T, args...))
      else
        # The value is a constant.
        args = remap_args!(ir, irmap, OpConstantComposite, args)::Vector{SSAValue}
        return emit!(ir, Constant((args, type)))
      end
    end
    ::Core.PhiNode => (OpPhi, Iterators.flatten(zip(jinst.values, SSAValue(findfirst(Base.Fix1(in, e), block_ranges(cfg)), irmap) for e in jinst.edges)))
    :($f($(args...))) => begin
        @match f begin
          ::GlobalRef => begin
              func = getfield(f.mod, f.name)
              isa(func, Core.IntrinsicFunction) && throw(CompilationError("Reached illegal core intrinsic function '$func'."))
              isa(func, Function) && throw(CompilationError("Dynamic dispatch detected for function $func. All call sites must be statically resolved."))
            end
          _ => throw(CompilationError("Call to unknown function $f"))
        end
      end
    Expr(:invoke, mi, f, args...) => begin
        @assert isa(f, GlobalRef)
        if f.mod == @__MODULE__
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
            (OpFunctionCall, (emit_new!(ir, mi, fdef), args...))
          end
        else
          (OpFunctionCall, (emit_new!(ir, mi, fdef), args...))
        end
      end
    _ => throw(CompilationError("Expected call or invoke expression, got $(repr(jinst))"))
  end

  if opcode == OpAccessChain
    # Force literal in `getindex` to be 32-bit
    args = map(args) do arg
      isa(arg, Int) && return UInt32(arg)
      arg
    end
  end

  # Load all arguments that are wrapped with a variable.
  if any(x -> isa(x, Core.SSAValue) && haskey(irmap.variables, x), args)
    args = map(args) do arg
      # Don't change the stored variable.
      opcode == OpStore && arg == first(args) && return arg
      load_if_variable!(blk, ir, irmap, arg)
    end
  end

  args = remap_args!(ir, irmap, opcode, args)

  if opcode == OpStore
    result_id = type_id = nothing
  else
    type_id = emit!(ir, irmap, type)
    result_id = next!(ir.ssacounter)
  end

  @inst result_id = opcode(args...)::type_id
end

function load_if_variable!(blk, ir, irmap, arg)
  if isa(arg, Core.SSAValue)
    var = get(irmap.variables, arg, nothing)
    if !isnothing(var)
      load = @inst next!(ir.ssacounter) = OpLoad(irmap.ssavals[arg])::ir.types[var.type.type]
      push!(blk, irmap, load)
      return load.result_id
    end
  end
  arg
end

function try_getopcode(name, prefix = "")
  maybe_opname = Symbol(:Op, prefix, name)
  isdefined(@__MODULE__, maybe_opname) ? getproperty(@__MODULE__, maybe_opname) : nothing
end

function remap_args!(ir::IR, irmap::IRMapping, opcode, args)
  map(args) do arg
    # Phi nodes may have forward references.
    isa(arg, Core.Argument) && opcode ≠ OpPhi && return SSAValue(arg, irmap)
    if isa(arg, AbstractFloat) || isa(arg, Integer) || isa(arg, Bool)
      return emit!(ir, irmap, Constant(arg))
    end
    arg
  end
end

function emit_new!(ir::IR, mi::MethodInstance, fdef::FunctionDefinition)
  storage_classes = Dictionary{Int,StorageClass}()
  for (i, t) in fdef.type.argtypes
    @tryswitch t begin
      @case ::PointerType
        insert!(storage_classes, i, t.storage_class)
    end
  end
  emit!(ir, CFG(mi; inferred = true), storage_classes)
end
