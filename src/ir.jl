"""
Intermediate representation of SPIR-V modules.

The `types` and `constants` mappings can be updated at any time without explicitly notifying of
the mutation behavior (i.e. functions may not end with `!`), so long as additions only are performed.
Such additions are currently done upon construction of `GlobalsInfo`.
The ID counter can also be incremented without notice.
"""
@refbroadcast mutable struct IR
  ir_meta::ModuleMetadata
  capabilities::Vector{Capability}
  extensions::Vector{String}
  extinst_imports::BijectiveMapping{ResultID,String}
  addressing_model::AddressingModel
  memory_model::MemoryModel
  entry_points::ResultDict{EntryPoint}
  metadata::ResultDict{Metadata}
  types::BijectiveMapping{ResultID,SPIRType}
  "Constants, including specialization constants."
  constants::BijectiveMapping{ResultID,Constant}
  global_vars::BijectiveMapping{ResultID,Variable}
  fdefs::BijectiveMapping{ResultID,FunctionDefinition}
  debug::DebugInfo
  idcounter::IDCounter
  "SPIR-V types derived from Julia types."
  tmap::TypeMap
end

@forward_methods IR field = :metadata decorate!(_, args...) metadata!(_, args...) has_decoration(_, args...) decorations(_, args...) set_name!(_, args...)
@forward_methods IR field = :fdefs Base.iterate(_, args...)

Base.getindex(ir::IR, i::Int) = collect(ir.fdefs)[i]
Base.:(==)(x::IR, y::IR) = Module(x) == Module(y)

IR(source; satisfy_requirements = true, features = AllSupported()) = IR(Module(source); satisfy_requirements, features)

function IR(; ir_meta::ModuleMetadata = ModuleMetadata(), addressing_model::AddressingModel = AddressingModelLogical, memory_model::MemoryModel = MemoryModelVulkan)
  IR(ir_meta, [], [], BijectiveMapping(), addressing_model, memory_model, ResultDict(), ResultDict(),
    BijectiveMapping(), BijectiveMapping(), BijectiveMapping(), BijectiveMapping(), DebugInfo(), IDCounter(0), TypeMap())
end

function IR(mod::Module; satisfy_requirements = true, features = AllSupported()) #= ::FeatureSupport =#
  ir = IR(; ir_meta = mod.meta)
  (; debug, metadata, types) = ir
  max_id = 0

  current_function = nothing

  for inst in mod
    (; arguments, type_id, result_id, opcode) = inst
    inst_info = info(inst)
    (; class) = inst_info
    @tryswitch class begin
      @case "Mode-Setting"
      @switch opcode begin
        @case &OpCapability
        push!(ir.capabilities, arguments[1])
        @case &OpMemoryModel
        ir.addressing_model, ir.memory_model = arguments
        @case &OpEntryPoint
        model, id, name, interfaces... = arguments
        insert!(ir.entry_points, id, EntryPoint(Symbol(name), id, model, [], interfaces))
        @case &OpExecutionMode || &OpExecutionModeId
        id = arguments[1]
        push!(ir.entry_points[id].modes, inst)
      end
      @case "Extension"
      @tryswitch opcode begin
        @case &OpExtension
        push!(ir.extensions, arguments[1])
        @case &OpExtInstImport
        insert!(ir.extinst_imports, result_id, arguments[1])
      end
      @case "Debug"
      @tryswitch opcode begin
        @case &OpSource
        language, version = arguments[1:2]
        file, code = @match length(arguments) begin
          2 => (nothing, nothing)
          3 => @match arg = arguments[3] begin
            ::Integer => (arg, nothing)
            ::String => (nothing, arg)
          end
          4 => arguments[3:4]
        end

        !isnothing(file) && (file = debug.filenames[file])
        debug.source = Source(language, source_version(language, version), file, code, [])
        @case &OpSourceExtension
        !isnothing(debug.source) || error("Source extension was declared before the source, or the source was not declared at all.")
        push!(debug.source.extensions, arguments[1])
        @case &OpName
        id = arguments[1]::ResultID
        name = arguments[2]::String
        set_name!(ir, id, Symbol(name))
        @case &OpMemberName
        id = arguments[1]::ResultID
        member_index = arguments[2]::UInt32 + 1
        name = arguments[3]::String
        set_name!(ir, id, member_index, Symbol(name))
      end
      @case "Annotation"
      @tryswitch opcode begin
        @case &OpDecorate
        id = arguments[1]::ResultID
        dec = arguments[2]::Decoration
        length(arguments) == 2 ? decorate!(ir, id, dec) : decorate!(ir, id, dec, arguments[3:end]...)

        @case &OpMemberDecorate
        id = arguments[1]::ResultID
        member_index = arguments[2]::UInt32 + 1 # convert to 1-based indexing
        dec = arguments[3]::Decoration
        length(arguments) == 3 ? decorate!(ir, id, member_index, dec) : decorate!(ir, id, member_index, dec, arguments[4:end]...)
      end
      @case "Type-Declaration"
      @switch opcode begin
        @case &OpTypeFunction
        rettype = types[arguments[1]::ResultID]
        argtypes = [types[id::ResultID] for id in arguments[2:end]]
        insert!(types, result_id, FunctionType(rettype, argtypes))
        @case _
        insert!(types, result_id, parse(SPIRType, inst, types, ir.constants))
      end
      @case "Constant-Creation"
      c = @match opcode begin
        &OpConstant || &OpSpecConstant => begin
          t = types[type_id]
          T = julia_type(t)
          literal = @match T begin
            &UInt8 || &Int8 => reinterpret(T, UInt8(only(arguments)))
            &Float16 || &UInt16 || &Int16 => reinterpret(T, UInt16(only(arguments)))
            &Float32 || &UInt32 || &Int32 => reinterpret(T, only(arguments))
            &Float64 || &UInt64 || &Int64 => only(reinterpret(T, [arguments[1]::Word, arguments[2]::Word]))
            _ => error("Unexpected literal of type $T found in constant instruction with arguments $arguments")
          end
          Constant(literal, t, opcode == OpSpecConstant)
        end
        &OpConstantFalse || &OpConstantTrue => Constant(opcode == OpConstantTrue, BooleanType())
        &OpSpecConstantFalse || &OpSpecConstantTrue => Constant(opcode == OpSpecConstantTrue, BooleanType(), true)
        &OpConstantNull => Constant(nothing, types[type_id])
        &OpConstantComposite || &OpSpecConstantComposite =>
          Constant(convert(Vector{ResultID}, arguments), types[type_id], opcode == OpSpecConstantComposite)
        _ => error("Unsupported constant instruction $inst")
      end
      insert!(ir.constants, result_id, c)
      @case "Memory"
      @tryswitch opcode begin
        @case &OpVariable
        ex = Expression(inst, types)
        storage_class = ex[1]::StorageClass
        if storage_class ≠ StorageClassFunction
          insert!(ir.global_vars, result_id, Variable(ex))
        end
        if !isnothing(current_function)
          push!(current_function.local_vars, ex)
        end
      end
      @case "Function"
      @tryswitch opcode begin
        @case &OpFunction
        control, ftype = arguments
        current_function = FunctionDefinition(types[ftype], control)
        insert!(ir.fdefs, result_id, current_function)
        @case &OpFunctionParameter
        push!(current_function.args, result_id)
        @case &OpFunctionEnd
        current_function = nothing
      end
      @case "Control-Flow"
      @assert !isnothing(current_function)
      if opcode == OpLabel
        ex = Expression(inst, types)
        push!(current_function, Block(ex.result))
      end
      @case "Miscellaneous"
      if opcode == OpUndef
        ex = Expression(inst, types)
        # TODO: Handle `Undef`
        # This currently breaks because `Undef` instructions are not `Variable`s.
        # insert!(ir.global_vars, result_id, Variable(ex))
        @warn "OpUndef instructions at top-level are not yet supported; skipping"
      end
    end
    if !isnothing(current_function) && !isempty(current_function.blocks) && opcode ≠ OpVariable
      ex = Expression(inst, types)
      block = last(values(current_function.blocks))
      push!(block, ex)
    end
    !isnothing(result_id) && (max_id = max(max_id, UInt32(result_id)))
  end

  set!(ir.idcounter, ResultID(max_id))
  satisfy_requirements && satisfy_requirements!(ir, features)
  ir
end

id_bound(ir::IR) = ResultID(UInt32(ResultID(ir.idcounter)) + 1)

function set_name!(ir::IR, id::ResultID, name::Symbol)
  set!(ir.debug.names, id, name)
  set_name!(metadata!(ir, id), name)
end
set_name!(ir::IR, id::ResultID, i::Int, name::Symbol) = set_name!(ir.metadata, id, i, name)

"Return the first entry point corresponding to `name`."
function entry_point(ir::IR, name::Symbol)
  for ep in ir.entry_points
    ep.name == name && return ep
  end
  error("No entry point found with name '$name'")
end

function GlobalsInfo(ir::IR)
  emit_types!(ir)
  GlobalsInfo(ir.types, ir.constants, ir.global_vars)
end

ResultID(ir::IR, t::DataType) = ResultID(ir, spir_type(t, ir.tmap))
ResultID(ir::IR, t::SPIRType) = ir.types[t]

function merge_metadata!(ir::IR, id::ResultID, meta::Metadata)
  if isdefined(meta, :member_metadata) && !isempty(meta.member_metadata)
    t = get(ir.types, id, nothing)
    !isnothing(t) && !isa(t, StructType) && error("Trying to set metadata which contains member metadata on a non-aggregate type.")
  end
  merge!(metadata!(ir, id), meta)
end

function emit_types!(ir::IR)
  for fdef in ir.fdefs
    for blk in fdef
      emit_type!(ir.types, ir.idcounter, ir.constants, ir.tmap, fdef.type)
      for ex in blk
        isnothing(ex.type) && continue
        emit_type!(ir.types, ir.idcounter, ir.constants, ir.tmap, ex.type)
      end
    end
  end
  for var in ir.global_vars
    emit_type!(ir.types, ir.idcounter, ir.constants, ir.tmap, var.type)
  end
  ir
end

function create_variable!(ir::IR, fdef::FunctionDefinition, ex::Expression)
  emit_type!(ir.types, ir.idcounter, ir.constants, ir.tmap, ex.type)
  push!(fdef.local_vars, ex)
  ex
end
create_variable!(ir::IR, fdef::FunctionDefinition, variable::Variable, id::ResultID) = create_variable!(ir, fdef, Expression(variable, id))
create_variable!(ir::IR, fdef::FunctionDefinition, type::SPIRType, id::ResultID) = create_variable!(ir, fdef, Variable(type), id)

function Module(ir::IR; debug_info = true)
  insts = Instruction[]

  append!(insts, @inst(OpCapability(cap)) for cap in ir.capabilities)
  append!(insts, @inst(OpExtension(ext)) for ext in ir.extensions)
  append!(insts, @inst(id = OpExtInstImport(extinst)) for (id, extinst) in pairs(ir.extinst_imports))
  push!(insts, @inst OpMemoryModel(ir.addressing_model, ir.memory_model))
  for entry in ir.entry_points
    push!(insts, @inst OpEntryPoint(entry.model, entry.func, String(entry.name), entry.interfaces...))
    append!(insts, entry.modes)
  end
  if debug_info
    append_debug_instructions!(insts, ir.debug)
    append_debug_instructions!(insts, ir.metadata)
  end
  globals = GlobalsInfo(ir)
  append_annotations!(insts, ir.metadata)
  append_globals!(insts, globals)
  append_functions!(insts, ir.fdefs, globals)

  mod = Module(ir.ir_meta, insts)
  remove_obsolete_annotations!(mod)
end

function replace_name(id::ResultID, names)
  symbol = get(names, id, nothing)
  name = isnothing(symbol) || symbol == Symbol("") ? UInt32(id) : symbol
  "%$name"
end

function Base.show(io::IO, mime::MIME"text/plain", (mod, debug)::Pair{Module,DebugInfo})
  str = sprint(disassemble, mod; context = IOContext(io))
  lines = split(str, '\n')
  filter!(lines) do line
    !contains(line, "OpName") && !contains(line, "OpMemberName")
  end
  lines = map(lines) do line
    replace(line, r"%\d+" => id -> replace_name(parse(ResultID, id), debug.filenames))
    replace(line, r"%\d+" => id -> replace_name(parse(ResultID, id), debug.names))
  end
  print(io, join(lines, '\n'))
end

function Base.show(io::IO, mime::MIME"text/plain", ir::IR)
  mod = Module(ir)
  isnothing(ir.debug) && return show(io, mime, mod)
  show(io, mime, mod => ir.debug)
end

Base.isapprox(ir::IR, mod::Module; kwargs...) = isapprox(Module(ir), mod; kwargs...)
Base.isapprox(mod::Module, ir::IR; kwargs...) = isapprox(ir, mod; kwargs...)
Base.isapprox(x::IR, y::IR; kwargs...) = isapprox(Module(x), Module(y); kwargs...)
