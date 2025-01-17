@refbroadcast struct ModuleTarget
  extinst_imports::Dictionary{String,ResultID}
  types::BijectiveMapping{ResultID,SPIRType}
  constants::BijectiveMapping{ResultID,Constant}
  global_vars::BijectiveMapping{ResultID,Variable}
  fdefs::BijectiveMapping{ResultID,FunctionDefinition}
  metadata::ResultDict{Metadata}
  debug::DebugInfo
  idcounter::IDCounter
end

@forward_methods ModuleTarget field = :metadata metadata!(_, args...) decorations!(_, args...) decorations(_, args...) has_decoration(_, args...) decorate!(_, args...)

ModuleTarget() = ModuleTarget(Dictionary(), BijectiveMapping(), BijectiveMapping(), BijectiveMapping(), BijectiveMapping(), ResultDict(), DebugInfo(), IDCounter(0))

GlobalsInfo(mt::ModuleTarget) = GlobalsInfo(mt.types, mt.constants, mt.global_vars)

function set_name!(mt::ModuleTarget, id::ResultID, name::Symbol)
  set!(mt.debug.names, id, name)
  set_name!(metadata!(mt.metadata, id), name)
end

@refbroadcast mutable struct Translation
  const argtypes::Vector{Any}
  const argmap::BijectiveMapping{Int64, Core.Argument}
  const args::Dictionary{Core.Argument,ResultID}
  "Result IDs for basic blocks from Julia IR."
  const bbs::BijectiveMapping{Int,ResultID}
  "Result IDs for each `Core.SSAValue` that implicitly represents a basic block."
  const bb_results::Dictionary{Core.SSAValue,ResultID}
  "Result IDs that correspond semantically to `Core.SSAValue`s."
  const results::Dictionary{Core.SSAValue,ResultID}
  "Intermediate results that correspond to SPIR-V `Variable`s. Typically, these results have a mutable Julia type."
  const variables::Dictionary{Core.SSAValue,Variable}
  const tmap::TypeMap
  "SPIR-V types derived from Julia types."
  const types::Dictionary{DataType,ResultID}
  const globalrefs::Dictionary{Core.SSAValue,GlobalRef}
  index::Int64
end

function Translation(target::SPIRVTarget, tmap, types)
  spectypes = collect(target.mi.specTypes.types)
  kept_args = findall(T -> !(T <: Base.Callable), spectypes)
  argtypes = spectypes[kept_args]
  argmap = BijectiveMapping(Dictionary(eachindex(kept_args), Core.Argument.(kept_args)))
  Translation(argtypes, argmap, tmap, types)
end
Translation(target::SPIRVTarget) = Translation(target, TypeMap(), Dictionary())
Translation() = Translation([], BijectiveMapping(), TypeMap(), Dictionary())
Translation(argtypes, argmap, tmap, types) = Translation(argtypes, argmap, Dictionary(), BijectiveMapping(), Dictionary(), Dictionary(), Dictionary(), tmap, types, Dictionary(), 0)

ResultID(arg::Core.Argument, tr::Translation) = tr.args[arg]
ResultID(bb::Int, tr::Translation) = tr.bbs[bb]
ResultID(val::Core.SSAValue, tr::Translation) = tr.results[val]

function compile(@nospecialize(f), @nospecialize(argtypes = Tuple{}), args...; interp = SPIRVInterpreter())
  compile(SPIRVTarget(f, argtypes; interp), args...)
end

compile(target::SPIRVTarget, args...) = compile!(ModuleTarget(), Translation(target), target, args...)

function compile!(mt::ModuleTarget, tr::Translation, target::SPIRVTarget, globals::Dictionary{Int,Union{Constant,Variable}} = Dictionary{Int,Union{Constant,Variable}}())
  emit!(mt, tr, target, globals)
  mt
end

function compile!(mt::ModuleTarget, tr::Translation, target::SPIRVTarget, features::FeatureSupport, globals = Dictionary{Int,Union{Constant,Variable}}())
  mt = compile!(mt, tr, target, globals)
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
  compact_blocks!(ir)
  fill_phi_branches!(ir)
  remap_dynamic_1based_indices!(ir)
  egal_to_recursive_equal!(ir)
  # XXX: Only a handful of operations are propagated, related to index conversions
  # and subtractions coming from Int64 1-based vs UInt32 0-based indexing.
  propagate_constants!(ir)
  composite_extract_to_vector_extract_dynamic!(ir)
  composite_extract_dynamic_to_literal!(ir)
  composite_extract_to_access_chain_load!(ir)
  remove_op_nops!(ir)
end

mutable struct CompilationError <: Exception
  msg::String
  target::SPIRVTarget
  jinst::Any
  jinst_index::Int64
  jtype::Type
  ex::Expression
  CompilationError(msg::AbstractString) = (err = new(); err.msg = msg; err.jinst_index = 0; err)
end

function throw_compilation_error(exc::Exception, fields::NamedTuple, msg = "the following method instance could not be compiled to SPIR-V")
  if isa(exc, CompilationError)
    for (prop, val) in pairs(fields)
      (!isdefined(exc, prop) || (prop === :jinst_index && iszero(exc.jinst_index))) && setproperty!(exc, prop, val)
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
throw_compilation_error(msg::AbstractString...) = throw(CompilationError(string(msg...)))

error_field(field) = string(Base.text_colors[:cyan], field, Base.text_colors[:default], ": ")

function Base.showerror(io::IO, err::CompilationError)
  # TODO: Use Base.StackTraces.
  if isdefined(err, :target)
    println(io, "An error occurred while compiling a `CodeInfo`.")
    show_debug_native_code(io, err.target.code)
  end
  print(io, "CompilationError")
  print(io, ": ", err.msg, '.')
  if isdefined(err, :target)
    (; stacktrace) = err.target.interp.debug
    print(io, "\nStacktrace:")
    for (i, frame) in enumerate(reverse(stacktrace))
      (; mi) = frame
      here = (i == firstindex(stacktrace))
      color = here ? :red : :default
      weight = here ? :bold : :normal
      file = contractuser(string(mi.def.file))
      ci = retrieve_code_instance(err.target.interp, mi)
      rettype = cached_return_type(ci)
      line = !isnothing(frame.line) ? frame.line.line : !iszero(err.jinst_index) && i == lastindex(stacktrace) ? getline(err.target.code, err.jinst_index).line : mi.def.line
      print(io, styled"""
        \n{$color,$weight: $(here ? '>' : ' ') [$i] $mi::$rettype}
             {magenta:@ $(mi.def.module)} {gray:$file:$line}""")
    end
  end
  if isdefined(err, :jinst)
    print(io, "\n\n", error_field("Julia instruction" * (!iszero(err.jinst_index) ? " at index %$(err.jinst_index)" : "")), err.jinst, Base.text_colors[:yellow], "::", err.jtype, Base.text_colors[:default])
    err.jtype === Union{} && printstyled(io, "\n\n", "The type of the instruction is `Union{}`, which may indicate an error in the code that would throw an exception at runtime."; italic = true)
  end
  if isdefined(err, :ex)
    print(io, "\n\n", error_field("Wrapped SPIR-V expression"), err.ex)
  end
  println(io)
end

function emit!(mt::ModuleTarget, tr::Translation, target::SPIRVTarget, globals = Dictionary{Int,Union{Constant,Variable}}())
  push!(target.interp.debug.stacktrace, DebugFrame(target.mi, target.code))
  # Declare a new function.
  local fdef
  try
    # Fill the SPIR-V function with instructions generated from the target's inferred code.
    fdef = define_function!(mt, tr, target, globals)
  catch e
    throw_compilation_error(e, (; target))
  end
  fid = emit!(mt, tr, fdef)
  set_name!(mt, fid, function_name(target.mi))
  arg_idx = 0
  for (i, argument) in pairs(tr.argmap)
    x = get(globals, i, nothing)
    T = target.mi.specTypes.parameters[argument.n]
    argid = @match x begin
      ::Variable && if begin
        type = spir_type(T, tr.tmap)
        istype(type, SPIR_TYPE_POINTER) || istype(type, SPIR_TYPE_ARRAY) && is_descriptor_backed(type)
    end end => mt.global_vars[x]
      ::Constant => mt.constants[x]
      _ => fdef.args[arg_idx += 1]
    end
    insert!(tr.args, argument, argid)
    in(argument.n, eachindex(target.code.slotnames)) && set_name!(mt, argid, target.code.slotnames[argument.n])
  end

  try
    # Fill the SPIR-V function with instructions generated from the target's inferred code.
    emit!(fdef, mt, tr, target)
    assert_type_known(fdef.type.function.rettype)
  catch e
    throw_compilation_error(e, (; target))
  end
  pop!(target.interp.debug.stacktrace)
  fid
end

function define_function!(mt::ModuleTarget, tr::Translation, target::SPIRVTarget, globals::Dictionary{Int,Union{Constant,Variable}})
  argtypes = SPIRType[]
  (; mi) = target

  for (i, T) in enumerate(tr.argtypes)
    x = get(globals, i, nothing)
    isa(x, Constant) && continue
    type = spir_type(T, tr.tmap)
    @switch x begin
      @case ::Nothing
      push!(argtypes, type)
      @case ::Variable
      @switch x.storage_class begin
        @case &StorageClassFunction
        push!(argtypes, type)
        @case ::StorageClass
        if !istype(type, SPIR_TYPE_POINTER) && (!istype(type, SPIR_TYPE_ARRAY) || !is_descriptor_backed(type))
          # The Variable does not originate from a pointer type, so we'll need
          # the function to be called with the result of a corresponding Load.
          # If the variable had originated from a pointer type, code that uses
          # it would have explicitly loaded and stored as appropriate.
          push!(argtypes, type)
        end
      end
    end
  end
  code_instance = retrieve_code_instance(target.interp, mi)
  return_t = code_instance.rettype === Nothing ? void_type() : spir_type(code_instance.rettype, tr.tmap)
  ftype = function_type(return_t, argtypes)
  FunctionDefinition(ftype, FunctionControlNone, [], [], ResultDict(), [])
end

function emit!(mt::ModuleTarget, tr::Translation, fdef::FunctionDefinition)
  emit!(mt, tr, fdef.type)
  fid = next!(mt.idcounter)
  append!(fdef.args, next!(mt.idcounter) for _ = 1:length(fdef.type.function.argtypes))
  insert!(mt.fdefs, fdef, fid)
  fid
end

emit!(mt::ModuleTarget, tr::Translation, @nospecialize(type::SPIRType)) = emit_type!(mt.types, mt.idcounter, mt.constants, tr.tmap, type)
emit!(mt::ModuleTarget, tr::Translation, c::Constant) = emit_constant!(mt.constants, mt.idcounter, mt.types, tr.tmap, c)

emit_constant!(mt::ModuleTarget, tr::Translation, value; is_specialization_constant = false) = emit_constant!(mt.constants, mt.idcounter, mt.types, tr.tmap, Constant(value, mt, tr; is_specialization_constant))

Constant(value::GlobalRef, mt::ModuleTarget, tr::Translation; is_specialization_constant = false) = Constant(follow_globalref(value, mt, tr), mt, tr; is_specialization_constant)
Constant(value::BitMask, mt::ModuleTarget, tr::Translation; is_specialization_constant = false) = Constant(value.val, mt, tr; is_specialization_constant)
Constant(value::QuoteNode, mt::ModuleTarget, tr::Translation; is_specialization_constant = false) = Constant(value.value, mt, tr; is_specialization_constant)

function Constant(value::T, mt::ModuleTarget, tr::Translation; is_specialization_constant = false) where {T}
  type = spir_type(T, tr.tmap)
  is_spec_const = is_specialization_constant ? Ref(true) : IS_SPEC_CONST_FALSE
  !iscomposite(type) && return Constant(value, type, is_specialization_constant ? Ref(true) : IS_SPEC_CONST_FALSE)
  ids = @match type.typename begin
    &SPIR_TYPE_VECTOR || &SPIR_TYPE_ARRAY => [emit_constant!(mt, tr, value[i]; is_specialization_constant) for i in 1:length(value)]
    &SPIR_TYPE_MATRIX => [emit_constant!(mt, tr, col; is_specialization_constant) for col in columns(mat)]
    &SPIR_TYPE_STRUCT => [emit_constant!(mt, tr, getproperty(value, name); is_specialization_constant) for name in fieldnames(T)]
    _ => error("Unexpected composite type `$type`")
  end
  Constant(ids, type, ifelse(is_specialization_constant, IS_SPEC_CONST_TRUE, IS_SPEC_CONST_FALSE))
end

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

follow_globalref(@nospecialize x) = x
function follow_globalref(x::GlobalRef)
  isdefined(x.mod, x.name) || throw_compilation_error("undefined global reference `$x`")
  getproperty(x.mod, x.name)
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
    Meta.isexpr(jinst, :loopinfo) && continue
    core_ssaval = Core.SSAValue(i)
    if Meta.isexpr(jinst, :boundscheck)
      # Act as if bounds checking was disabled, emitting a constant instead of the actual condition.
      insert!(tr.results, core_ssaval, emit!(mt, tr, Constant(jinst.args[1])))
      continue
    end
    jtype = ssavaluetypes[i]
    isa(jtype, Core.PartialStruct) && (jtype = jtype.typ)
    isa(jtype, Core.Const) && (jtype = typeof(jtype.val))
    ex = nothing
    tr.index = i
    try
      @switch jinst begin
        @case ::Core.ReturnNode
        !isdefined(jinst, :val) && throw_compilation_error("unreachable statement encountered at location $i")
        ex = @match follow_globalref(jinst.val) begin
          ::Nothing => @ex OpReturn()
          val => begin
            args = Any[val]
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
        @case _
        if isa(jinst, GlobalRef)
          value = follow_globalref(jinst)
          if isa(value, UnionAll) || isa(value, DataType)
            # Just keep references to types for later.
            insert!(tr.globalrefs, core_ssaval, jinst)
            continue
          else
            jtype === Any && throw_compilation_error("got a `GlobalRef` inferred as `Any`; the global might not have been declared as `const`")
          end
        end
        ret, stype = emit_expression!(mt, tr, target, fdef, jinst, jtype, blk)
        if isa(ret, Expression)
          add_expression!(blk, tr, ret, core_ssaval)
        elseif isa(ret, ResultID)
          # The value references one that has already been inserted,
          # possibly a SPIR-V global (e.g. a constant).
          # Just map the current SSA value to the global, unless it has already been set.
          !haskey(tr.results, core_ssaval) && insert!(tr.results, core_ssaval, ret)
        end
      end
      jtype === Union{} && !isa(jinst, Union{Core.GotoNode, Core.GotoIfNot}) && throw_compilation_error("`Union{}` type detected: the code to compile contains an error")
    catch e
      fields = (; jinst, jinst_index = i, jtype)
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

function allocate_variable!(mt::ModuleTarget, tr::Translation, fdef::FunctionDefinition, variable::Variable, id::ResultID)
  emit!(mt, tr, variable.type)
  push!(fdef.local_vars, Expression(variable, id))
end

function allocate_variable!(mt::ModuleTarget, tr::Translation, fdef::FunctionDefinition, jtype::Type, core_ssaval::Core.SSAValue)
  id = next!(mt.idcounter)
  variable = Variable(spir_type(jtype, tr.tmap))
  insert!(tr.variables, core_ssaval, variable)
  insert!(tr.results, core_ssaval, id)
  allocate_variable!(mt, tr, fdef, variable, id)
end

function add_expression!(block::Block, tr::Translation, ex::Expression, core_ssaval::Optional{Core.SSAValue} = nothing)
  if !isnothing(ex.result) && !isnothing(core_ssaval)
    insert!(tr.results, core_ssaval, ex.result)
  end
  push!(block, ex)
  ex
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
  esc(:($(@__MODULE__).@compile $(AllSupported()) $interp $ex))
end
macro compile(ex)
  esc(:($(@__MODULE__).@compile $(AllSupported()) $SPIRVInterpreter() $ex))
end

function getline(code::CodeInfo, i::Int)
  @static if VERSION ≥ v"1.12-DEV"
    line = Base.IRShow.buildLineInfoNode(code.debuginfo, code.parent, i)
  else
    codeloc = code.codelocs[i]
    iszero(codeloc) && return nothing
    line = code.linetable[codeloc]
  end
  line
end

function validate(code::CodeInfo)::Result{Bool,ValidationError}
  globalrefs = Dictionary{Core.SSAValue, GlobalRef}()
  validation_error(msg, i, ex, (line,)) = ValidationError(string(msg, " in expression `", ex, "` at code location ", i, " around ", line.file, ":", line.line, '\n'))
  for (i, ex) in enumerate(code.code)
    ex === nothing && continue
    isa(ex, GlobalRef) && insert!(globalrefs, Core.SSAValue(i), ex)
    isa(ex, Core.ReturnNode) && ex != Core.ReturnNode() && continue
    (isa(ex, Core.GotoNode) || isa(ex, Core.GotoIfNot)) && continue
    line = getline(code, i)
    !isnothing(line) || error("No code location was found at code location $i for ex $ex; make sure to provide a `CodeInfo` which was generated with debugging info (`debuginfo = :source`).")
    @trymatch ex begin
      &Core.ReturnNode() => return validation_error("Unreachable statement detected (previous instruction: $(code.code[i - 1]))", i, ex, line)
      Expr(:foreigncall, _...) => return validation_error("Foreign call detected", i, ex, line)
      Expr(:call, f, _...) => @match follow_globalref(f) begin
        &Base.not_int || &Base.bitcast || &Base.getfield || &Core.tuple => nothing
        ::Core.IntrinsicFunction => return validation_error("Illegal core intrinsic function `$f` detected", i, ex, line)
        ::Function => return validation_error("Dynamic dispatch detected", i, ex, line)
        _ => return validation_error("Expected `GlobalRef`", i, ex, line)
      end
      Expr(:invoke, mi, f, _...) => begin
        mi::MethodInstance
        isa(f, Core.SSAValue) && (f = globalrefs[f])
        isa(f, GlobalRef) && (f = follow_globalref(f))
        f === throw && return validation_error("An exception may be throwned", i, ex, line)
        in(mi.def.module, (Base, Core)) && return validation_error("Invocation of a `MethodInstance` detected that is defined in Base or Core (they should be inlined)", i, ex, line)
      end
    end
  end

  # Validate types in a second pass so that we can see things such as unreachable statements and exceptions before
  # raising an error because e.g. a String type is detected when building the error message.
  for (i, ex) in enumerate(code.code)
    isa(ex, Union{Core.ReturnNode, Core.GotoNode, Core.GotoIfNot, Nothing}) && continue
    T = code.ssavaluetypes[i]
    isa(ex, GlobalRef) && isa(T, Type) && continue
    Meta.isexpr(ex, :invoke) && ex.args[2] == GlobalRef(@__MODULE__, :Store) && continue
    line = getline(code, i)
    @trymatch T begin
      ::Type{Union{}} => return validation_error("Bottom type Union{} detected", i, ex, line)
      ::Type{<:AbstractString} => return validation_error("String type `$T` detected", i, ex, line)
      ::Type{Any} => return validation_error("Type `Any` detected", i, ex, line)
      ::Type{<:UnionAll} => return validation_error("`UnionAll` detected", i, ex, line)
      ::Type{T} => @trymatch T begin
        GuardBy(isabstracttype) => return validation_error("Abstract type `$T` detected", i, ex, line)
        GuardBy(!isconcretetype) => return validation_error("Non-concrete type `$T` detected", i, ex, line)
      end
    end
  end

  for (i, ex) in enumerate(code.code)
    !Meta.isexpr(ex, :invoke) && continue
    T = code.ssavaluetypes[i]
    line = getline(code, i)
    mi = ex.args[1]
    if mi.def.module === SPIRV
      opcode = lookup_opcode(mi.def.name)
      isnothing(opcode) && return validation_error("Invocation of a `MethodInstance` defined in module SPIRV that does not correspond to an opcode (they should be inlined to ones that correspond to opcodes)", i, ex, line)
    end
  end

  true
end

function FunctionDefinition(mt::ModuleTarget, name::Symbol)
  for (id, val) in pairs(mt.debug.names)
    if val == name && haskey(mt.fdefs, id)
      return mt.fdefs[id]
    end
  end
  error("No function named '$name' could be found.")
end

function_name(mi::MethodInstance) = Symbol((mi.def::Method).name, :_, repr(hash(mi.specTypes)))

FunctionDefinition(mt::ModuleTarget, mi::MethodInstance) = FunctionDefinition(mt, function_name(mi))
