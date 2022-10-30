struct Source
  language::SourceLanguage
  version::VersionNumber
  file::Optional{String}
  code::Optional{String}
  extensions::Vector{String}
end

@refbroadcast mutable struct EntryPoint
  name::Symbol
  func::SSAValue
  model::ExecutionModel
  modes::Vector{Instruction}
  interfaces::Vector{SSAValue}
end

struct LineInfo
  file::String
  line::Int
  column::Int
end

mutable struct DebugInfo
  filenames::SSADict{String}
  names::SSADict{Symbol}
  lines::SSADict{LineInfo}
  source::Optional{Source}
end

DebugInfo() = DebugInfo(SSADict(), SSADict(), SSADict(), nothing)

"""
    Variable(type, initializer = nothing)

Construct a variable that wraps a value of type `type` as a pointer.
If `type` is already a `PointerType`, then its storage class is propagated
to the variable; if not, then a specific storage class can be specified
with the form `Variable(type, storage_class = StorageClassFunction, initializer = nothing)`.
"""
mutable struct Variable
  type::PointerType
  storage_class::StorageClass
  initializer::Optional{SSAValue}
  Variable(type::PointerType, initializer::Optional{SSAValue} = nothing) = new(type, type.storage_class, initializer)
end
Variable(type::SPIRType, storage_class::StorageClass = StorageClassFunction, initializer::Optional{SSAValue} = nothing) =
  Variable(PointerType(storage_class, type), initializer)
Variable(type::PointerType, ::StorageClass, initializer::Optional{SSAValue} = nothing) = Variable(type, initializer)

function Variable(inst::Instruction, type::SPIRType)
  storage_class = first(inst.arguments)
  initializer = length(inst.arguments) == 2 ? SSAValue(last(inst.arguments)) : nothing
  Variable(type, initializer)
end

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
  typerefs::Dictionary{Any,SPIRType}
end

function IR(; ir_meta::ModuleMetadata = ModuleMetadata(), addressing_model::AddressingModel = AddressingModelLogical, memory_model::MemoryModel = MemoryModelVulkan)
  IR(ir_meta, [], [], BijectiveMapping(), addressing_model, memory_model, SSADict(), SSADict(),
    BijectiveMapping(), BijectiveMapping(), BijectiveMapping(), BijectiveMapping(), SSADict(), DebugInfo(), SSACounter(0), Dictionary())
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
          Constant(reinterpret(julia_type(t, ir), literal), opcode == OpSpecConstant)
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

function has_decoration(ir::IR, id::SSAValue, dec::Decoration)
  meta = get(ir.metadata, id, nothing)
  isnothing(meta) && return false
  has_decoration(meta, dec)
end

function has_decoration(ir::IR, id::SSAValue, member_index::Int, dec::Decoration)
  meta = get(ir.metadata, id, nothing)
  isnothing(meta) && return false
  has_decoration(meta, dec, member_index)
end

function decorations(ir::IR, id::SSAValue)
  meta = get(ir.metadata, id, nothing)
  isnothing(meta) && return nothing
  decorations(meta)
end

function decorations(ir::IR, id::SSAValue, member_index::Int)
  meta = get(ir.metadata, id, nothing)
  isnothing(meta) && return nothing
  decorations(meta, member_index)
end

decorations!(ir::IR, id::SSAValue) = decorations!(metadata!(ir, id))
decorations!(ir::IR, id::SSAValue, member_index::Int) = decorations!(metadata!(ir, id, member_index))

metadata!(ir::IR, id::SSAValue) = get!(Metadata, ir.metadata, id)
metadata!(ir::IR, id::SSAValue, member_index::Int) = metadata!(metadata!(ir, id), member_index)

decorate!(ir::IR, id::SSAValue, member_index::Int, dec::Decoration, args...) = decorate!(metadata!(ir, id, member_index), dec, args...)
decorate!(ir::IR, id::SSAValue, dec::Decoration, args...) = decorate!(metadata!(ir, id), dec, args...)

function set_name!(ir::IR, id::SSAValue, name::Symbol)
  set!(ir.debug.names, id, name)
  set_name!(metadata!(ir, id), name)
end
set_name!(ir::IR, id::SSAValue, member_index::Int, name::Symbol) = set_name!(get!(Metadata, ir.metadata, id), member_index, name)

"Return the first entry point corresponding to `name`."
function entry_point(ir::IR, name::Symbol)
  for ep in ir.entry_points
    ep.name == name && return ep
  end
  error("No entry point found with name '$name'")
end

SSAValue(ir::IR, t::DataType) = SSAValue(ir, spir_type(t, ir))
SSAValue(ir::IR, t::SPIRType) = ir.types[t]

function merge_metadata!(ir::IR, id::SSAValue, meta::Metadata)
  if isdefined(meta, :member_metadata) && !isempty(meta.member_metadata)
    t = get(ir.types, id, nothing)
    !isnothing(t) && !isa(t, StructType) && error("Trying to set metadata which contains member metadata on a non-aggregate type.")
  end
  merge!(metadata!(ir, id), meta)
end

for f in (:decorate!, :set_name!, :merge_metadata!, :decorations, :has_decoration, :decorations!, :metadata!)
  @eval $f(ir::IR, key, args...) = $f(ir, SSAValue(ir, key), args...)
end

"""
Get a SPIR-V type from a Julia type, caching the mapping in the `IR` if one is provided.

If `wrap_mutable` is set to true, then a pointer with class `StorageClassFunction` will wrap the result.
"""
function spir_type(t::Type, ir::Optional{IR} = nothing; wrap_mutable = false, storage_class = nothing)
  wrap_mutable && ismutabletype(t) && return PointerType(StorageClassFunction, spir_type(t, ir))
  !isnothing(ir) && haskey(ir.typerefs, t) && isnothing(storage_class) && return ir.typerefs[t]
  type = @match t begin
    &Float16 => FloatType(16)
    &Float32 => FloatType(32)
    &Float64 => FloatType(64)
    &Nothing => VoidType()
    &Bool => BooleanType()
    &UInt8 => IntegerType(8, false)
    &UInt16 => IntegerType(16, false)
    &UInt32 => IntegerType(32, false)
    &UInt64 => IntegerType(64, false)
    &Int8 => IntegerType(8, true)
    &Int16 => IntegerType(16, true)
    &Int32 => IntegerType(32, true)
    &Int64 => IntegerType(64, true)
    ::Type{<:Array} => begin
      eltype, n = t.parameters
      @match n begin
        1 => ArrayType(spir_type(eltype, ir), nothing)
        _ => ArrayType(spir_type(Array{eltype,n - 1}, ir), nothing)
      end
    end
    ::Type{<:Tuple} => @match (n = length(t.parameters), t) begin
      (GuardBy(>(1)), ::Type{<:NTuple}) => ArrayType(spir_type(eltype(t), ir), Constant(UInt32(n)))
      # Generate structure on the fly.
      _ => StructType(spir_type.(t.parameters, ir))
    end
    ::Type{<:Pointer} => PointerType(StorageClassPhysicalStorageBuffer, spir_type(eltype(t), ir))
    ::Type{<:Vec} => VectorType(spir_type(eltype(t), ir), length(t))
    ::Type{<:Mat} => MatrixType(spir_type(Vec{nrows(t),eltype(t)}, ir), ncols(t))
    ::Type{<:Arr} => ArrayType(spir_type(eltype(t), ir), Constant(UInt32(length(t))))
    ::Type{Sampler} => SamplerType()
    ::Type{<:Image} => ImageType(spir_type(component_type(t), ir), dim(t), is_depth(t), is_arrayed(t), is_multisampled(t), is_sampled(t), format(t), nothing)
    ::Type{<:SampledImage} => SampledImageType(spir_type(image_type(t), ir))
    GuardBy(isstructtype) || ::Type{<:NamedTuple} => StructType(spir_type.(t.types, ir))
    GuardBy(isprimitivetype) => primitive_type_to_spirv(t)
    _ => error("Type $t does not have a corresponding SPIR-V type.")
  end

  #TODO: WIP, need to insert an `OpCompositeExtract` for all uses if the type changed.
  promoted_type = promote_to_interface_block(type, storage_class)
  if type ≠ promoted_type
    error("The provided type must be a struct or an array of structs. The automation of this requirement is a work in progress.")
  end

  if type == promoted_type && !isnothing(ir)
    if isnothing(storage_class)
      insert!(ir.typerefs, t, type)
    else
      set!(ir.typerefs, t, type)
    end
  end

  promoted_type
end

"""
    primitive_type_to_spirv(::Type{T})::SPIRType where {T}

Specify which SPIR-V type corresponds to a given primitive type.
Both types must have the same number of bits.
"""
function primitive_type_to_spirv end

function promote_to_interface_block(type, storage_class)
  @tryswitch storage_class begin
    @case &StorageClassPushConstant
    # Type must be a struct.
    !isa(type, StructType) && return StructType([type])
    @case &StorageClassUniform || &StorageClassStorageBuffer
    # Type must be a struct or an array of structs.
    @tryswitch type begin
      @case ::StructType
      nothing
      @case ::ArrayType
      !isa(type.eltype, StructType) && return @set type.eltype = StructType([type.eltype])
      @case _
      return StructType([type])
    end
  end
  type
end

Instruction(inst::Instruction, id::SSAValue, ::IR) = @set inst.result_id = id
Instruction(::VoidType, id::SSAValue, ::IR) = @inst id = OpTypeVoid()
Instruction(::BooleanType, id::SSAValue, ::IR) = @inst id = OpTypeBool()
Instruction(t::IntegerType, id::SSAValue, ::IR) = @inst id = OpTypeInt(UInt32(t.width), UInt32(t.signed))
Instruction(t::FloatType, id::SSAValue, ::IR) = @inst id = OpTypeFloat(UInt32(t.width))
Instruction(t::VectorType, id::SSAValue, ir::IR) = @inst id = OpTypeVector(SSAValue(ir, t.eltype), UInt32(t.n))
Instruction(t::MatrixType, id::SSAValue, ir::IR) = @inst id = OpTypeMatrix(SSAValue(ir, t.eltype), UInt32(t.n))
function Instruction(t::ImageType, id::SSAValue, ir::IR)
  inst = @inst id = OpTypeImage(
    SSAValue(ir, t.sampled_type),
    t.dim,
    UInt32(something(t.depth, 2)),
    UInt32(t.arrayed),
    UInt32(t.multisampled),
    UInt32(2 - something(t.sampled, 2)),
    t.format,
  )
  !isnothing(t.access_qualifier) && push!(inst.arguments, t.access_qualifier)
  inst
end
Instruction(t::SamplerType, id::SSAValue, ::IR) = @inst id = OpTypeSampler()
Instruction(t::SampledImageType, id::SSAValue, ir::IR) = @inst id = OpTypeSampledImage(SSAValue(ir, t.image_type))
function Instruction(t::ArrayType, id::SSAValue, ir::IR)
  if isnothing(t.size)
    @inst id = OpTypeRuntimeArray(SSAValue(ir, t.eltype))
  else
    @inst id = OpTypeArray(SSAValue(ir, t.eltype), ir.constants[t.size::Constant])
  end
end
function Instruction(t::StructType, id::SSAValue, ir::IR)
  inst = @inst id = OpTypeStruct()
  append!(inst.arguments, SSAValue(ir, member) for member in t.members)
  inst
end
Instruction(t::OpaqueType, id::SSAValue, ::IR) = @inst id = OpTypeOpaque(t.name)
Instruction(t::PointerType, id::SSAValue, ir::IR) = @inst id = OpTypePointer(t.storage_class, SSAValue(ir, t.type))
function Instruction(t::FunctionType, id::SSAValue, ir::IR)
  inst = @inst id = OpTypeFunction(SSAValue(ir, t.rettype))
  append!(inst.arguments, SSAValue(ir, argtype) for argtype in t.argtypes)
  inst
end
function Instruction(c::Constant, id::SSAValue, ir::IR)
  @match (c.value, c.is_spec_const) begin
    ((::Nothing, type), false) => @inst id = OpConstantNull()::SSAValue(ir, type)
    (true, false) => @inst id = OpConstantTrue()::SSAValue(ir, BooleanType())
    (true, true) => @inst id = OpSpecConstantTrue()::SSAValue(ir, BooleanType())
    (false, false) => @inst id = OpConstantFalse()::SSAValue(ir, BooleanType())
    (false, true) => @inst id = OpSpecConstantFalse()::SSAValue(ir, BooleanType())
    ((ids::Vector{SSAValue}, type), false) => @inst id = OpConstantComposite(ids...)::SSAValue(ir, type)
    ((ids::Vector{SSAValue}, type), true) => @inst id = OpSpecConstantComposite(ids...)::SSAValue(ir, type)
    (val, false) => begin
      if isa(val, UInt64) || isa(val, Int64) || isa(val, Float64)
        # `val` is a 64-bit literal, and so takes two words.
        @inst id = OpConstant(reinterpret(UInt32, [val])...)::SSAValue(ir, typeof(val))
      else
        @inst id = OpConstant(reinterpret(UInt32, val))::SSAValue(ir, typeof(val))
      end
    end
  end
end

function SPIRType(c::Constant, ir::IR)
  @match c.value begin
    (_, type::SPIRType) || (_, type::SPIRType) => type
    val => spir_type(typeof(val), ir)
  end
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
  debug_info && append_debug_instructions!(insts, ir)
  append_annotations!(insts, ir)
  append_globals!(insts, ir)
  append_functions!(insts, ir)

  Module(ir.ir_meta, ssa_bound(ir), insts)
end

function append_debug_instructions!(insts, ir::IR)
  (; debug) = ir
  if !isnothing(debug.source)
    (; source) = debug
    args = Any[source.language, source_version(source.language, source.version)]
    !isnothing(source.file) && push!(args, source.file)
    !isnothing(source.code) && push!(args, source.code)
    push!(insts, @inst OpSource(args...))
    append!(insts, @inst(OpSourceExtension(ext)) for ext in source.extensions)
  end

  for (id, filename) in pairs(debug.filenames)
    push!(insts, @inst OpString(id, filename))
  end
  for (id, meta) in pairs(ir.metadata)
    append_debug_annotations!(insts, id, meta)
  end
end

function append_annotations!(insts, ir::IR)
  for (id, meta) in pairs(ir.metadata)
    append_decorations!(insts, id, meta)
  end
end

function append_functions!(insts, ir::IR)
  for (id, fdef) in pairs(ir.fdefs)
    append!(insts, instructions(ir, fdef, id))
  end
end

function instructions(ir::IR, fdef::FunctionDefinition, id::SSAValue)
  insts = Instruction[]
  (; type) = fdef
  push!(insts, @inst id = OpFunction(fdef.control, SSAValue(ir, type))::SSAValue(ir, type.rettype))
  append!(insts, @inst(id = OpFunctionParameter()::SSAValue(ir, argtype)) for (id, argtype) in zip(fdef.args, type.argtypes))
  fbody = body(fdef)
  if !isempty(fbody)
    label = first(fbody)
    @assert label.opcode == OpLabel
    push!(insts, label)
    append!(insts, fdef.local_vars)
    append!(insts, fbody[2:end])
  end
  push!(insts, @inst OpFunctionEnd())
  insts
end

function append_globals!(insts, ir::IR)
  globals = merge_unique!(BijectiveMapping{SSAValue,Any}(), ir.types, ir.constants, ir.global_vars)
  sortkeys!(globals)
  append!(insts, Instruction(val, id, ir) for (id, val) in pairs(globals))
end

function Instruction(var::Variable, id::SSAValue, ir::IR)
  inst = @inst id = OpVariable(var.storage_class)::SSAValue(ir, var.type)
  !isnothing(var.initializer) && push!(inst.arguments, var.initializer)
  inst
end

function replace_name(val::SSAValue, names)
  name = get(names, val, id(val))
  "%$name"
end

function Base.show(io::IO, mime::MIME"text/plain", ir::IR)
  mod = Module(ir)
  isnothing(ir.debug) && return show(io, mime, mod)
  str = sprintc(disassemble, mod)
  lines = split(str, '\n')
  filter!(lines) do line
    !contains(line, "OpName") && !contains(line, "OpMemberName")
  end
  lines = map(lines) do line
    replace(line, r"%\d+" => id -> replace_name(parse(SSAValue, id), ir.debug.filenames))
    replace(line, r"%\d+" => id -> replace_name(parse(SSAValue, id), ir.debug.names))
  end
  print(io, join(lines, '\n'))
end

Base.isapprox(ir::IR, mod::Module) = Module(ir) ≈ mod
