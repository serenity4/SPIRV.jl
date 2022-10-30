function compile(@nospecialize(f), @nospecialize(argtypes = Tuple{}), args...; interp = SPIRVInterpreter())
  compile(SPIRVTarget(f, argtypes; interp), args...)
end

compile(target::SPIRVTarget, args...) = compile!(IR(), target, args...)

function compile!(ir::IR, target::SPIRVTarget, variables::Dictionary{Int,Variable} = Dictionary{Int,Variable}())
  # TODO: restructure CFG
  inferred = infer(target)
  emit!(ir, inferred, variables)
  ir
end

function compile!(ir::IR, target::SPIRVTarget, features::FeatureSupport, variables = Dictionary{Int,Variable}())
  ir = compile!(ir, target, variables)
  satisfy_requirements!(ir, features)
end

struct IRMapping
  args::Dictionary{Core.Argument,SSAValue}
  "SPIR-V SSA values for basic blocks from Julia IR."
  bbs::BijectiveMapping{Int,SSAValue}
  "SPIR-V SSA values for each `Core.SSAValue` that implicitly represents a basic block."
  bb_ssavals::Dictionary{Core.SSAValue,SSAValue}
  "SPIR-V SSA values that correspond semantically to `Core.SSAValue`s."
  ssavals::Dictionary{Core.SSAValue,SSAValue}
  "Intermediate results that correspond to SPIR-V `Variable`s. Typically, these results have a mutable Julia type."
  variables::Dictionary{Core.SSAValue,Variable}
  types::Dictionary{Type,SSAValue}
  globalrefs::Dictionary{Core.SSAValue,GlobalRef}
end

IRMapping() = IRMapping(Dictionary(), BijectiveMapping(), Dictionary(), Dictionary(), Dictionary(), Dictionary(), Dictionary())

SSAValue(arg::Core.Argument, irmap::IRMapping) = irmap.args[arg]
SSAValue(bb::Int, irmap::IRMapping) = irmap.bbs[bb]
SSAValue(ssaval::Core.SSAValue, irmap::IRMapping) = irmap.ssavals[ssaval]

mutable struct CompilationError <: Exception
  msg::String
  mi::MethodInstance
  jinst::Any
  jtype::Type
  inst::Instruction
  CompilationError(msg::AbstractString) = (err = new(); err.msg = msg; err)
end

function throw_compilation_error(exc::Exception, fields::NamedTuple, msg = "Internal compilation error")
  if isa(exc, CompilationError)
    for (prop, val) in pairs(fields)
      setproperty!(exc, prop, val)
    end
    rethrow()
  else
    err = CompilationError(msg)
    for (prop, val) in pairs(fields)
      setproperty!(err, prop, val)
    end
    throw(err)
  end
end

error_field(field) = string(Base.text_colors[:cyan], field, Base.text_colors[:default], ": ")

function Base.showerror(io::IO, err::CompilationError)
  print(io, "CompilationError")
  if isdefined(err, :mi)
    print(io, " (", err.mi, ")")
  end
  print(io, ": ", err.msg)
  if isdefined(err, :jinst)
    print(io, "\n", error_field("Julia instruction"), err.jinst, Base.text_colors[:yellow], "::", err.jtype, Base.text_colors[:default])
  end
  if isdefined(err, :inst)
    print(io, "\n", error_field("Wrapped SPIR-V instruction"))
    emit(io, err.inst)
  end
  println(io)
end

function emit!(ir::IR, target::SPIRVTarget, variables = Dictionary{Int,Variable}())
  # Declare a new function.
  fdef = define_function!(ir, target, variables)
  fid = emit!(ir, fdef)
  set_name!(ir, fid, make_name(target.mi))
  irmap = IRMapping()
  arg_idx = 0
  gvar_idx = 0
  for i in 2:target.mi.def.nargs
    argid = haskey(variables, i - 1) ? fdef.global_vars[gvar_idx += 1] : fdef.args[arg_idx += 1]
    insert!(irmap.args, Core.Argument(i), argid)
    set_name!(ir, argid, target.code.slotnames[i])
  end

  try
    # Fill the SPIR-V function with instructions generated from the target's inferred code.
    emit!(fdef, ir, irmap, target)
  catch e
    throw_compilation_error(e, (; target.mi))
  end
  fid
end

function make_name(mi::MethodInstance)
  Symbol(replace(string(mi.def.name, '_', Base.tuple_type_tail(mi.specTypes)), ' ' => ""))
end

function define_function!(ir::IR, target::SPIRVTarget, variables::Dictionary{Int,Variable})
  argtypes = SPIRType[]
  global_vars = SSAValue[]
  (; mi) = target

  for (i, t) in enumerate(mi.specTypes.types[2:end])
    type = spir_type(t, ir; wrap_mutable = true)
    var = get(variables, i, nothing)
    @switch var begin
      @case ::Nothing
      push!(argtypes, type)
      @case ::Variable
      @switch var.storage_class begin
        @case &StorageClassFunction
        push!(argtypes, type)
        @case ::StorageClass
        push!(global_vars, emit!(ir, var))
      end
    end
  end
  ci = target.interp.global_cache[mi]
  ftype = FunctionType(spir_type(ci.rettype, ir), argtypes)
  FunctionDefinition(ftype, FunctionControlNone, [], [], SSADict(), global_vars)
end

function emit!(ir::IR, fdef::FunctionDefinition)
  emit!(ir, fdef.type)
  fid = next!(ir.ssacounter)
  append!(fdef.args, next!(ir.ssacounter) for _ = 1:length(fdef.type.argtypes))
  insert!(ir.fdefs, fid, fdef)
  fid
end

emit!(ir::IR, irmap::IRMapping, c::Constant) = emit!(ir, c)
emit!(ir::IR, irmap::IRMapping, @nospecialize(type::SPIRType)) = emit!(ir, type)

function emit!(ir::IR, @nospecialize(type::SPIRType))
  haskey(ir.types, type) && return ir.types[type]
  @switch type begin
    @case ::PointerType
    emit!(ir, type.type)
    @case (::ArrayType && GuardBy(isnothing ∘ Fix2(getproperty, :size))) || ::VectorType || ::MatrixType
    emit!(ir, type.eltype)
    @case ::ArrayType
    emit!(ir, type.eltype)
    emit!(ir, type.size)
    @case ::StructType
    for t in type.members
      emit!(ir, t)
    end
    @case ::ImageType
    emit!(ir, type.sampled_type)
    @case ::SampledImageType
    emit!(ir, type.image_type)
    @case ::VoidType || ::IntegerType || ::FloatType || ::BooleanType || ::OpaqueType || ::SamplerType
    nothing
    @case ::FunctionType
    emit!(ir, type.rettype)
    for t in type.argtypes
      emit!(ir, t)
    end
  end

  id = next!(ir.ssacounter)
  insert!(ir.types, id, type)
  id
end

function emit!(ir::IR, c::Constant)
  haskey(ir.constants, c) && return ir.constants[c]
  emit!(ir, SPIRType(c, ir))
  id = next!(ir.ssacounter)
  insert!(ir.constants, id, c)
  id
end

function emit!(ir::IR, var::Variable)
  haskey(ir.global_vars, var) && return ir.global_vars[var]
  emit!(ir, var.type)
  id = next!(ir.ssacounter)
  insert!(ir.global_vars, id, var)
  id
end

function emit!(fdef::FunctionDefinition, ir::IR, irmap::IRMapping, target::SPIRVTarget)
  ranges = block_ranges(target)
  back_edges = backedges(target.cfg)
  vs = traverse(target.cfg)
  add_mapping!(irmap, ir, ranges, vs)
  emit_nodes!(fdef, ir, irmap, target, ranges, vs, back_edges)
  replace_forwarded_ssa!(fdef, irmap)
end

function add_mapping!(irmap::IRMapping, ir::IR, ranges, vs)
  for v in vs
    id = next!(ir.ssacounter)
    insert!(irmap.bbs, v, id)
    insert!(irmap.bb_ssavals, Core.SSAValue(first(ranges[v])), id)
  end
end

function emit_nodes!(fdef::FunctionDefinition, ir::IR, irmap::IRMapping, target::SPIRVTarget, ranges, vs, backedges)
  for v in vs
    emit!(fdef, ir, irmap, target, ranges[v], v)
  end
end

"""
Replace forward references to `Core.SSAValue`s by their appropriate `SSAValue`.
"""
function replace_forwarded_ssa!(fdef::FunctionDefinition, irmap::IRMapping)
  for block in fdef.blocks
    for inst in block.insts
      for (i, arg) in enumerate(inst.arguments)
        isa(arg, Core.SSAValue) && (inst.arguments[i] = SSAValue(arg, irmap))
      end
    end
  end
end

function emit!(fdef::FunctionDefinition, ir::IR, irmap::IRMapping, target::SPIRVTarget, range::UnitRange, node::Integer)
  (; code, ssavaluetypes, slottypes) = target.code
  blk = new_block!(fdef, SSAValue(node, irmap))
  for i in range
    jinst = code[i]
    # Ignore single `nothing::Nothing` instructions.
    # They seem to be only here as part of dummy basic blocks
    # for instructions such as `OpPhi`.
    # Actual `nothing` arguments are passed by symbol directly.
    (isnothing(jinst) || jinst === GlobalRef(Base, :nothing)) && continue
    jtype = ssavaluetypes[i]
    core_ssaval = Core.SSAValue(i)
    spv_inst = nothing
    @assert !(jtype <: Core.IntrinsicFunction) "Encountered illegal core intrinsic $jinst."
    jtype ≠ Union{} || throw(CompilationError("Encountered bottom type $jtype, which may indicate an error in the original code."))
    try
      @switch jinst begin
        @case ::Core.ReturnNode
        spv_inst = @match jinst.val begin
          ::Nothing => @inst OpReturn()
          val => begin
            args = Any[val]
            load_variables!(args, blk, ir, irmap, fdef, OpReturnValue)
            remap_args!(args, ir, irmap, OpReturnValue)
            @inst OpReturnValue(only(args))
          end
        end
        add_instruction!(blk, irmap, spv_inst, core_ssaval)
        @case ::Core.GotoNode
        dest = irmap.bb_ssavals[Core.SSAValue(jinst.label)]
        spv_inst = @inst OpBranch(dest)
        add_instruction!(blk, irmap, spv_inst, core_ssaval)
        @case ::Core.GotoIfNot
        # Core.GotoIfNot uses the SSA value of the first instruction of the target
        # block as its `dest`.
        dest = irmap.bb_ssavals[Core.SSAValue(jinst.dest)]
        (; cond) = jinst
        cond_inst = isa(cond, Bool) ? emit!(ir, Constant(cond)) : SSAValue(cond, irmap)
        spv_inst = @inst OpBranchConditional(cond_inst, SSAValue(node + 1, irmap), dest)
        add_instruction!(blk, irmap, spv_inst, core_ssaval)
        @case ::GlobalRef
        jtype <: Type || throw(CompilationError("Unhandled global reference $(repr(jtype))"))
        insert!(irmap.globalrefs, core_ssaval, jinst)
        @case _
        check_isvalid(jtype)
        if ismutabletype(jtype)
          # OpPhi will reuse existing variables, no need to allocate a new one.
          !isa(jinst, Core.PhiNode) && allocate_variable!(ir, irmap, fdef, jtype, core_ssaval)
        end
        ret = emit_inst!(ir, irmap, target, fdef, jinst, jtype, blk)
        if isa(ret, Instruction)
          if ismutabletype(jtype) && !isa(jinst, Core.PhiNode)
            # The current core SSAValue has already been assigned (to the variable).
            add_instruction!(blk, irmap, ret, nothing)
            # Store to the new variable.
            add_instruction!(blk, irmap, @inst OpStore(irmap.ssavals[core_ssaval], ret.result_id::SSAValue))
          elseif ismutabletype(jtype) && isa(jinst, Core.PhiNode)
            insert!(irmap.variables, core_ssaval, Variable(ir.types[ret.type_id], StorageClassFunction))
            add_instruction!(blk, irmap, ret, core_ssaval)
          else
            add_instruction!(blk, irmap, ret, core_ssaval)
          end
        elseif isa(ret, SSAValue)
          # The value is a SPIR-V global (possibly a constant),
          # so no need to push a new function instruction.
          # Just map the current SSA value to the global.
          insert!(irmap.ssavals, core_ssaval, ret)
        end
      end
    catch e
      fields = (; jinst, jtype)
      !isnothing(spv_inst) && (fields = (; fields..., inst = spv_inst))
      throw_compilation_error(e, fields)
    end
  end

  # Implicit `goto` to the next block.
  if !is_termination_instruction(last(blk))
    spv_inst = @inst OpBranch(SSAValue(node + 1, irmap))
    add_instruction!(blk, irmap, spv_inst)
  end
end

function allocate_variable!(ir::IR, irmap::IRMapping, fdef::FunctionDefinition, jtype::Type, core_ssaval::Core.SSAValue)
  # Create a SPIR-V variable to allow for future mutations.
  id = next!(ir.ssacounter)
  type = PointerType(StorageClassFunction, spir_type(jtype, ir))
  var = Variable(type)
  emit!(ir, type)
  insert!(irmap.variables, core_ssaval, var)
  insert!(irmap.ssavals, core_ssaval, id)
  push!(fdef.local_vars, Instruction(var, id, ir))
end

function add_instruction!(block::Block, irmap::IRMapping, inst::Instruction, core_ssaval::Optional{Core.SSAValue} = nothing)
  if !isnothing(inst.result_id) && !isnothing(core_ssaval)
    insert!(irmap.ssavals, core_ssaval, inst.result_id)
  end
  push!(block.insts, inst)
end

function julia_type(@nospecialize(t::SPIRType), ir::IR)
  @match t begin
    &(IntegerType(8, false)) => UInt8
    &(IntegerType(16, false)) => UInt16
    &(IntegerType(32, false)) => UInt32
    &(IntegerType(64, false)) => UInt64
    &(IntegerType(8, true)) => Int8
    &(IntegerType(16, true)) => Int16
    &(IntegerType(32, true)) => Int32
    &(IntegerType(64, true)) => Int64
    &(FloatType(16)) => Float16
    &(FloatType(32)) => Float32
    &(FloatType(64)) => Float64
  end
end

function emit_extinst!(ir::IR, extinst)
  haskey(ir.extinst_imports, extinst) && return ir.extinst_imports[extinst]
  id = next!(ir.ssacounter)
  insert!(ir.extinst_imports, id, extinst)
  id
end

function check_isvalid(jtype::Type)
  if !in(jtype, spirv_types)
    if isabstracttype(jtype)
      throw(CompilationError("Found abstract type '$jtype' after type inference. All types must be concrete."))
    elseif !isconcretetype(jtype)
      throw(CompilationError("Found non-concrete type '$jtype' after type inference. All types must be concrete."))
    end
  end
end

macro compile(features, interp, ex)
  compile_args = map(esc, get_signature(ex))
  :(compile($(compile_args...), $(esc(features)); interp = $interp))
end

macro compile(interp, ex)
  esc(:($(@__MODULE__).@compile $(AllSupported()) $(esc(interp)) $ex))
end
macro compile(ex)
  esc(:($(@__MODULE__).@compile $(AllSupported()) $(SPIRVInterpreter()) $ex))
end
