struct ModuleTarget
  extinst_imports::Dictionary{String,ResultID}
  types::BijectiveMapping{ResultID,SPIRType}
  constants::BijectiveMapping{ResultID,Constant}
  global_vars::BijectiveMapping{ResultID,Variable}
  fdefs::BijectiveMapping{ResultID,FunctionDefinition}
  metadata::ResultDict{Metadata}
  debug::DebugInfo
  idcounter::IDCounter
end

@forward ModuleTarget.metadata (metadata!, decorations!, decorations, has_decoration, decorate!)

ModuleTarget() = ModuleTarget(Dictionary(), BijectiveMapping(), BijectiveMapping(), BijectiveMapping(), BijectiveMapping(), ResultDict(), DebugInfo(), IDCounter(0))

GlobalsInfo(mt::ModuleTarget) = GlobalsInfo(mt.types, mt.constants, mt.global_vars)

function set_name!(mt::ModuleTarget, id::ResultID, name::Symbol)
  set!(mt.debug.names, id, name)
  set_name!(metadata!(mt.metadata, id), name)
end

struct Translation
  args::Dictionary{Core.Argument,ResultID}
  "Result IDs for basic blocks from Julia IR."
  bbs::BijectiveMapping{Int,ResultID}
  "Result IDs for each `Core.SSAValue` that implicitly represents a basic block."
  bb_results::Dictionary{Core.SSAValue,ResultID}
  "Result IDs that correspond semantically to `Core.SSAValue`s."
  results::Dictionary{Core.SSAValue,ResultID}
  "Intermediate results that correspond to SPIR-V `Variable`s. Typically, these results have a mutable Julia type."
  variables::Dictionary{Core.SSAValue,Variable}
  tmap::TypeMap
  "SPIR-V types derived from Julia types."
  types::Dictionary{DataType,ResultID}
  globalrefs::Dictionary{Core.SSAValue,GlobalRef}
end

Translation(tmap, types) = Translation(Dictionary(), BijectiveMapping(), Dictionary(), Dictionary(), Dictionary(), tmap, types, Dictionary())
Translation() = Translation(TypeMap(), Dictionary())

ResultID(arg::Core.Argument, tr::Translation) = tr.args[arg]
ResultID(bb::Int, tr::Translation) = tr.bbs[bb]
ResultID(val::Core.SSAValue, tr::Translation) = tr.results[val]

function compile(@nospecialize(f), @nospecialize(argtypes = Tuple{}), args...; interp = SPIRVInterpreter())
  compile(SPIRVTarget(f, argtypes; interp), args...)
end

compile(target::SPIRVTarget, args...) = compile!(ModuleTarget(), Translation(), target, args...)

function compile!(mt::ModuleTarget, tr::Translation, target::SPIRVTarget, variables::Dictionary{Int,Variable} = Dictionary{Int,Variable}())
  # TODO: restructure CFG
  inferred = infer(target)
  emit!(mt, tr, inferred, variables)
  mt
end

function compile!(mt::ModuleTarget, tr::Translation, target::SPIRVTarget, features::FeatureSupport, variables = Dictionary{Int,Variable}())
  mt = compile!(mt, tr, target, variables)
  ir = IR(mt, tr)
  satisfy_requirements!(ir, features)
end

function IR(mt::ModuleTarget, tr::Translation)
  ir = IR()
  merge!(ir.extinst_imports, mt.extinst_imports)
  ir.types = mt.types
  ir.constants = mt.constants
  ir.global_vars = mt.global_vars
  ir.fdefs = mt.fdefs
  ir.debug = mt.debug
  ir.idcounter = mt.idcounter
  ir.tmap = tr.tmap
  ir.metadata = mt.metadata
  ir
end

mutable struct CompilationError <: Exception
  msg::String
  target::SPIRVTarget
  jinst::Any
  jtype::Type
  ex::Expression
  CompilationError(msg::AbstractString) = (err = new(); err.msg = msg; err)
end

function throw_compilation_error(exc::Exception, fields::NamedTuple, msg = "the following method instance could not be compiled to SPIR-V")
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
throw_compilation_error(msg::AbstractString) = throw(CompilationError(msg))

error_field(field) = string(Base.text_colors[:cyan], field, Base.text_colors[:default], ": ")

function Base.showerror(io::IO, err::CompilationError)
  # TODO: Use Base.StackTraces.
  print(io, "CompilationError")
  print(io, ": ", err.msg, '.')
  (; stacktrace) = err.target.interp.debug
  print(io, "\nStacktrace:")
  for (i, frame) in enumerate(reverse(stacktrace))
    here = i == firstindex(stacktrace)
    println(io)
    here ? printstyled(io, '>'; color = :red, bold = true) : print(io, ' ')
    print(io, " [$i] ")
    str = string(frame.mi, "::", frame.code.rettype)
    here ? printstyled(io, str; color = :red, bold = true) : print(io, str)
  end
  frame = last(stacktrace)
  frame.code.rettype == Union{} && println(io, "\n\n", frame.code)
  if isdefined(err, :jinst)
    print(io, "\n\n", error_field("Julia instruction"), err.jinst, Base.text_colors[:yellow], "::", err.jtype, Base.text_colors[:default])
  end
  if isdefined(err, :ex)
    print(io, "\n\n", error_field("Wrapped SPIR-V expression"))
    emit(io, err.ex)
  end
  println(io)
end

function emit!(mt::ModuleTarget, tr::Translation, target::SPIRVTarget, variables = Dictionary{Int,Variable}())
  push!(target.interp.debug.stacktrace, DebugFrame(target.mi, target.code))
  # Declare a new function.
  local fdef
  try
    # Fill the SPIR-V function with instructions generated from the target's inferred code.
    fdef = define_function!(mt, tr, target, variables)
  catch e
    throw_compilation_error(e, (; target))
  end
  fid = emit!(mt, tr, fdef)
  set_name!(mt, fid, make_name(target.mi))
  arg_idx = 0
  gvar_idx = 0
  for i in 2:target.mi.def.nargs
    argid = haskey(variables, i - 1) ? fdef.global_vars[gvar_idx += 1] : fdef.args[arg_idx += 1]
    insert!(tr.args, Core.Argument(i), argid)
    set_name!(mt, argid, target.code.slotnames[i])
  end

  try
    # Fill the SPIR-V function with instructions generated from the target's inferred code.
    emit!(fdef, mt, tr, target)
  catch e
    throw_compilation_error(e, (; target))
  end
  pop!(target.interp.debug.stacktrace)
  fid
end

function make_name(mi::MethodInstance)
  Symbol(replace(string(mi.def.name, '_', Base.tuple_type_tail(mi.specTypes)), ' ' => ""))
end

function define_function!(mt::ModuleTarget, tr::Translation, target::SPIRVTarget, variables::Dictionary{Int,Variable})
  argtypes = SPIRType[]
  global_vars = ResultID[]
  (; mi) = target

  for (i, t) in enumerate(mi.specTypes.types[2:end])
    type = spir_type(t, tr.tmap; wrap_mutable = true)
    var = get(variables, i, nothing)
    @switch var begin
      @case ::Nothing
      push!(argtypes, type)
      @case ::Variable
      @switch var.storage_class begin
        @case &StorageClassFunction
        push!(argtypes, type)
        @case ::StorageClass
        push!(global_vars, emit!(mt, tr, var))
      end
    end
  end
  ci = target.interp.global_cache[mi]
  ftype = FunctionType(spir_type(ci.rettype, tr.tmap), argtypes)
  FunctionDefinition(ftype, FunctionControlNone, [], [], ResultDict(), [], global_vars)
end

function emit!(mt::ModuleTarget, tr::Translation, fdef::FunctionDefinition)
  emit!(mt, tr, fdef.type)
  fid = next!(mt.idcounter)
  append!(fdef.args, next!(mt.idcounter) for _ = 1:length(fdef.type.argtypes))
  insert!(mt.fdefs, fdef, fid)
  fid
end

emit!(mt::ModuleTarget, tr::Translation, @nospecialize(type::SPIRType)) = emit_type!(mt.types, mt.idcounter, mt.constants, tr.tmap, type)
emit!(mt::ModuleTarget, tr::Translation, c::Constant) = emit_constant!(mt.constants, mt.idcounter, mt.types, tr.tmap, c)

function emit!(mt::ModuleTarget, tr::Translation, var::Variable)
  haskey(mt.global_vars, var) && return mt.global_vars[var]
  emit!(mt, tr, var.type)
  id = next!(mt.idcounter)
  insert!(mt.global_vars, var, id)
  id
end

function emit!(fdef::FunctionDefinition, mt::ModuleTarget, tr::Translation, target::SPIRVTarget)
  ranges = block_ranges(target)
  back_edges = backedges(target.cfg)
  vs = traverse(target.cfg)
  add_mapping!(tr, mt.idcounter, ranges, vs)
  emit_nodes!(fdef, mt, tr, target, ranges, vs, back_edges)
  replace_forwarded_ssa!(fdef, tr)
end

function add_mapping!(tr::Translation, counter::IDCounter, ranges, vs)
  for v in vs
    id = next!(counter)
    insert!(tr.bbs, v, id)
    insert!(tr.bb_results, Core.SSAValue(first(ranges[v])), id)
  end
end

function emit_nodes!(fdef::FunctionDefinition, mt::ModuleTarget, tr::Translation, target::SPIRVTarget, ranges, vs, backedges)
  for v in vs
    emit!(fdef, mt, tr, target, ranges[v], v)
  end
end

"""
Replace forward references to `Core.SSAValue`s by their appropriate `ResultID`.
"""
function replace_forwarded_ssa!(fdef::FunctionDefinition, tr::Translation)
  for block in fdef
    for ex in block
      for (i, arg) in enumerate(ex)
        isa(arg, Core.SSAValue) && (ex[i] = ResultID(arg, tr))
      end
    end
  end
end

function emit!(fdef::FunctionDefinition, mt::ModuleTarget, tr::Translation, target::SPIRVTarget, range::UnitRange, node::Integer)
  (; code, ssavaluetypes, slottypes) = target.code
  blk = new_block!(fdef, ResultID(node, tr))
  for i in range
    jinst = code[i]
    # Ignore single `nothing::Nothing` instructions.
    # They seem to be only here as part of dummy basic blocks
    # for instructions such as `OpPhi`.
    # Actual `nothing` arguments are passed by symbol directly.
    (isnothing(jinst) || jinst === GlobalRef(Base, :nothing)) && continue
    jtype = ssavaluetypes[i]
    isa(jtype, Core.PartialStruct) && (jtype = jtype.typ)
    isa(jtype, Core.Const) && (jtype = typeof(jtype.val))
    core_ssaval = Core.SSAValue(i)
    ex = nothing
    try
      @switch jinst begin
        @case ::Core.ReturnNode
        ex = @match jinst.val begin
          ::Nothing => @ex OpReturn()
          val => begin
            args = Any[val]
            load_variables!(args, blk, mt, tr, fdef, OpReturnValue)
            remap_args!(args, mt, tr, OpReturnValue)
            @ex OpReturnValue(only(args))
          end
        end
        add_expression!(blk, tr, ex, core_ssaval)
        @case ::Core.GotoNode
        dest = tr.bb_results[Core.SSAValue(jinst.label)]
        ex = @ex OpBranch(dest)
        add_expression!(blk, tr, ex, core_ssaval)
        @case ::Core.GotoIfNot
        # Core.GotoIfNot uses the SSA value of the first instruction of the target
        # block as its `dest`.
        dest = tr.bb_results[Core.SSAValue(jinst.dest)]
        (; cond) = jinst
        cond_id = isa(cond, Bool) ? emit!(mt, tr, Constant(cond)) : ResultID(cond, tr)
        ex = @ex OpBranchConditional(cond_id, ResultID(node + 1, tr), dest)
        add_expression!(blk, tr, ex, core_ssaval)
        @case ::GlobalRef
        jtype <: Type || throw_compilation_error("unhandled global reference $(repr(jtype))")
        insert!(tr.globalrefs, core_ssaval, jinst)
        @case _
        if ismutabletype(jtype)
          # OpPhi will reuse existing variables, no need to allocate a new one.
          !isa(jinst, Core.PhiNode) && allocate_variable!(mt, tr, fdef, jtype, core_ssaval)
        end
        ret, stype = emit_expression!(mt, tr, target, fdef, jinst, jtype, blk)
        if isa(ret, Expression)
          if ismutabletype(jtype) && !isa(jinst, Core.PhiNode)
            # The current core ResultID has already been assigned (to the variable).
            add_expression!(blk, tr, ret, nothing)
            # Store to the new variable.
            add_expression!(blk, tr, @ex OpStore(tr.results[core_ssaval], ret.result::ResultID))
          elseif ismutabletype(jtype) && isa(jinst, Core.PhiNode)
            insert!(tr.variables, core_ssaval, Variable(stype, StorageClassFunction))
            add_expression!(blk, tr, ret, core_ssaval)
          else
            add_expression!(blk, tr, ret, core_ssaval)
          end
        elseif isa(ret, ResultID)
          # The value is a SPIR-V global (possibly a constant),
          # so no need to push a new expression.
          # Just map the current SSA value to the global.
          insert!(tr.results, core_ssaval, ret)
        end
      end
    catch e
      fields = (; jinst, jtype)
      !isnothing(ex) && (fields = (; fields..., ex))
      throw_compilation_error(e, fields)
    end
  end

  # Implicit `goto` to the next block.
  if !is_termination_instruction(last(blk))
    ex = @ex OpBranch(ResultID(node + 1, tr))
    add_expression!(blk, tr, ex)
  end
end

function allocate_variable!(mt::ModuleTarget, tr::Translation, fdef::FunctionDefinition, jtype::Type, core_ssaval::Core.SSAValue)
  # Create a SPIR-V variable to allow for future mutations.
  id = next!(mt.idcounter)
  type = PointerType(StorageClassFunction, spir_type(jtype, tr.tmap))
  var = Variable(type)
  emit!(mt, tr, type)
  insert!(tr.variables, core_ssaval, var)
  insert!(tr.results, core_ssaval, id)
  push!(fdef.local_vars, Expression(var, id))
end

function add_expression!(block::Block, tr::Translation, ex::Expression, core_ssaval::Optional{Core.SSAValue} = nothing)
  if !isnothing(ex.result) && !isnothing(core_ssaval)
    insert!(tr.results, core_ssaval, ex.result)
  end
  push!(block, ex)
end

function emit_extinst!(mt::ModuleTarget, extinst)
  haskey(mt.extinst_imports, extinst) && return mt.extinst_imports[extinst]
  id = next!(mt.idcounter)
  insert!(mt.extinst_imports, extinst, id)
  id
end

macro compile(features, interp, ex)
  compile_args = map(esc, get_signature(ex))
  :(compile($(compile_args...), $(esc(features)); interp = $(esc(interp))))
end

macro compile(interp, ex)
  esc(:(@compile $(AllSupported()) $interp $ex))
end
macro compile(ex)
  esc(:(@compile $(AllSupported()) $(SPIRVInterpreter()) $ex))
end
