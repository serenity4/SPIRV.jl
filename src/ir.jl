@refbroadcast mutable struct IR
  ir_meta::ModuleMetadata
  capabilities::Vector{Capability}
  extensions::Vector{String}
  extinst_imports::BijectiveMapping{SSAValue,String}
  addressing_model::AddressingModel
  memory_model::MemoryModel
  entry_points::SSADict{EntryPoint}
  metadata::SSADict{Metadata}
  types::BijectiveMapping{SSAValue,SPIRType}
  "Constants, including specialization constants."
  constants::BijectiveMapping{SSAValue,Constant}
  global_vars::BijectiveMapping{SSAValue,Variable}
  fdefs::BijectiveMapping{SSAValue,FunctionDefinition}
  results::SSADict{Any}
  debug::DebugInfo
  ssacounter::SSACounter
  "SPIR-V types derived from Julia types."
  tmap::TypeMap
end

@forward IR.metadata (decorate!, metadata!, has_decoration, decorations, set_name!)

function IR(; ir_meta::ModuleMetadata = ModuleMetadata(), addressing_model::AddressingModel = AddressingModelLogical, memory_model::MemoryModel = MemoryModelVulkan)
  IR(ir_meta, [], [], BijectiveMapping(), addressing_model, memory_model, SSADict(), SSADict(),
    BijectiveMapping(), BijectiveMapping(), BijectiveMapping(), BijectiveMapping(), SSADict(), DebugInfo(), SSACounter(0), TypeMap())
end

function IR(mod::Module; satisfy_requirements = true, features = AllSupported()) #= ::FeatureSupport =#
  ir = IR(; ir_meta = mod.meta)
  (; debug, metadata, types, results) = ir

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
        id = arguments[1]::SSAValue
        name = arguments[2]::String
        set_name!(ir, id, Symbol(name))
        @case &OpMemberName
        id = arguments[1]::SSAValue
        member_index = arguments[2]::UInt32 + 1
        name = arguments[3]::String
        set_name!(ir, id, member_index, Symbol(name))
      end
      @case "Annotation"
      @tryswitch opcode begin
        @case &OpDecorate
        id = arguments[1]::SSAValue
        dec = arguments[2]::Decoration
        length(arguments) == 2 ? decorate!(ir, id, dec) : decorate!(ir, id, dec, arguments[3:end]...)

        @case &OpMemberDecorate
        id = arguments[1]::SSAValue
        member_index = arguments[2]::UInt32 + 1 # convert to 1-based indexing
        dec = arguments[3]::Decoration
        length(arguments) == 3 ? decorate!(ir, id, member_index, dec) : decorate!(ir, id, member_index, dec, arguments[4:end]...)
      end
      @case "Type-Declaration"
      @switch opcode begin
        @case &OpTypeFunction
        rettype = types[arguments[1]::SSAValue]
        argtypes = [types[id::SSAValue] for id in arguments[2:end]]
        insert!(types, result_id, FunctionType(rettype, argtypes))
        @case _
        insert!(types, result_id, parse(SPIRType, inst, types, ir.constants))
      end
      @case "Constant-Creation"
      c = @match opcode begin
        &OpConstant || &OpSpecConstant => begin
          literal = only(arguments)
          t = types[type_id]
          Constant(reinterpret(julia_type(t), literal), opcode == OpSpecConstant)
        end
        &OpConstantFalse || &OpConstantTrue => Constant(opcode == OpConstantTrue)
        &OpSpecConstantFalse || &OpSpecConstantTrue => Constant(opcode == OpSpecConstantTrue, true)
        &OpConstantNull => Constant((nothing, types[type_id]))
        &OpConstantComposite || &OpSpecConstantComposite =>
          Constant((convert(Vector{SSAValue}, arguments), types[type_id]), opcode == OpSpecConstantComposite)
        _ => error("Unsupported constant instruction $inst")
      end
      insert!(ir.constants, result_id, c)
      @case "Memory"
      @tryswitch opcode begin
        @case &OpVariable
        storage_class = first(arguments)
        if storage_class ≠ StorageClassFunction
          insert!(ir.global_vars, result_id, Variable(inst, types[inst.type_id]))
        end
        if !isnothing(current_function)
          push!(current_function.local_vars, inst)
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
        insert!(current_function.blocks, inst.result_id, Block(inst.result_id))
      end
    end
    if !isnothing(current_function) && !isempty(current_function.blocks) && opcode ≠ OpVariable
      push!(last(values(current_function.blocks)).insts, inst)
    end
    if !isnothing(result_id)
      insert!(results, result_id, inst)
    end
  end

  ir.ssacounter.val = SSAValue(maximum(id.(keys(ir.results))))
  satisfy_requirements && satisfy_requirements!(ir, features)
  ir
end

ssa_bound(ir::IR) = SSAValue(id(SSAValue(ir.ssacounter)) + 1)

function set_name!(ir::IR, id::SSAValue, name::Symbol)
  set!(ir.debug.names, id, name)
  set_name!(metadata!(ir, id), name)
end
set_name!(ir::IR, id::SSAValue, i::Int, name::Symbol) = set_name!(ir.metadata, id, i, name)

"Return the first entry point corresponding to `name`."
function entry_point(ir::IR, name::Symbol)
  for ep in ir.entry_points
    ep.name == name && return ep
  end
  error("No entry point found with name '$name'")
end

GlobalsInfo(ir::IR) = GlobalsInfo(ir.types, ir.constants, ir.global_vars)

SSAValue(ir::IR, t::DataType) = SSAValue(ir, spir_type(t, ir.tmap))
SSAValue(ir::IR, t::SPIRType) = ir.types[t]

function merge_metadata!(ir::IR, id::SSAValue, meta::Metadata)
  if isdefined(meta, :member_metadata) && !isempty(meta.member_metadata)
    t = get(ir.types, id, nothing)
    !isnothing(t) && !isa(t, StructType) && error("Trying to set metadata which contains member metadata on a non-aggregate type.")
  end
  merge!(metadata!(ir, id), meta)
end

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

  Module(ir.ir_meta, ssa_bound(ir), insts)
end

function replace_name(val::SSAValue, names)
  name = get(names, val, id(val))
  "%$name"
end

function Base.show(io::IO, mime::MIME"text/plain", (mod, debug)::Pair{Module,DebugInfo})
  str = sprintc(disassemble, mod)
  lines = split(str, '\n')
  filter!(lines) do line
    !contains(line, "OpName") && !contains(line, "OpMemberName")
  end
  lines = map(lines) do line
    replace(line, r"%\d+" => id -> replace_name(parse(SSAValue, id), debug.filenames))
    replace(line, r"%\d+" => id -> replace_name(parse(SSAValue, id), debug.names))
  end
  print(io, join(lines, '\n'))
end

function Base.show(io::IO, mime::MIME"text/plain", ir::IR)
  mod = Module(ir)
  isnothing(ir.debug) && return show(io, mime, mod)
  show(io, mime, mod => ir.debug)
end

Base.isapprox(ir::IR, mod::Module) = Module(ir) ≈ mod
