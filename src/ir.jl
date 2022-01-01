struct Source
    language::SourceLanguage
    version::VersionNumber
    file::Optional{String}
    code::Optional{String}
    extensions::Vector{String}
end

@broadcastref mutable struct EntryPoint
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

mutable struct Variable
    type::SPIRType
    storage_class::StorageClass
    initializer::Optional{SSAValue}
end

function Variable(inst::Instruction, type::SPIRType)
    storage_class = first(inst.arguments)
    initializer = length(inst.arguments) == 2 ? SSAValue(last(inst.arguments)) : nothing
    if type isa PointerType && !isnothing(type.storage_class)
        type.storage_class == storage_class || error("""
        Storage classes for a variable and its type must be the same.
        Found pointer storage class $(type.storage_class) and variable storage class $storage_class.
        """)
    end
    Variable(type, storage_class, initializer)
end

mutable struct IR
    meta::Metadata
    capabilities::Vector{Capability}
    extensions::Vector{String}
    extinst_imports::BijectiveMapping{SSAValue,String}
    addressing_model::AddressingModel
    memory_model::MemoryModel
    entry_points::SSADict{EntryPoint}
    decorations::SSADict{DecorationData}
    types::BijectiveMapping{SSAValue,SPIRType}
    "Constants, including specialization constants."
    constants::BijectiveMapping{SSAValue,Constant}
    global_vars::BijectiveMapping{SSAValue,Variable}
    fdefs::BijectiveMapping{SSAValue,FunctionDefinition}
    results::SSADict{Any}
    debug::DebugInfo
    ssacounter::SSACounter
end

function IR(; meta::Metadata = Metadata(), addressing_model::AddressingModel = AddressingModelLogical, memory_model::MemoryModel = MemoryModelVulkan)
    IR(meta, [], [], BijectiveMapping(), addressing_model, memory_model, SSADict(), SSADict(),
        BijectiveMapping(), BijectiveMapping(), BijectiveMapping(), BijectiveMapping(), SSADict(), DebugInfo(), SSACounter(0))
end

function IR(mod::Module; satisfy_requirements = true)
    ir = IR(; mod.meta)
    (; debug, decorations, types, results) = ir

    member_decorations = SSADict{Dictionary{Int,DecorationData}}()
    member_names = SSADict{Dictionary{Int,Symbol}}()
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
                        id, name = arguments
                        insert!(debug.names, id, Symbol(name))
                    @case &OpMemberName
                        id, mindex, name = arguments
                        insert!(get!(Dictionary, member_names, id), mindex + 1, Symbol(name))
                end
            @case "Annotation"
                @tryswitch opcode begin
                    @case &OpDecorate
                        id, decoration, args... = arguments
                        if haskey(decorations, id)
                            insert!(decorations[id], decoration, args)
                        else
                            insert!(decorations, id, dictionary([decoration => args]))
                        end
                    @case &OpMemberDecorate
                        id, member, decoration, args... = arguments
                        member += 1 # convert to 1-based indexing
                        insert!(get!(DecorationData, get!(Dictionary{Int,DecorationData}, member_decorations, SSAValue(id)), member), decoration, args)
                end
            @case "Type-Declaration"
                @switch opcode begin
                    @case &OpTypeFunction
                        rettype = types[first(arguments)]
                        argtypes = [types[id] for id in arguments[2:end]]
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
                    &OpConstantComposite || &OpSpecConstantComposite => Constant((convert(Vector{SSAValue}, arguments), types[type_id]), opcode == OpSpecConstantComposite)
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
                            push!(current_function.variables, inst)
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
                    insert!(current_function.blocks, inst.result_id, Block(inst.result_id, []))
                end
        end
        if !isnothing(current_function) && !isempty(current_function.blocks) && opcode ≠ OpVariable
            push!(last(values(current_function.blocks)).insts, inst)
        end
        if !isnothing(result_id)
             insert!(results, result_id, inst)
        end
    end

    attach_member_decorations!(ir, member_decorations)
    attach_member_names!(ir, member_names)
    ir.ssacounter.val = SSAValue(maximum(id.(keys(ir.results))))
    satisfy_requirements && satisfy_requirements!(ir)
    ir
end

max_ssa(ir::IR) = SSAValue(ir.ssacounter)

"""
Attach member decorations to SPIR-V types (see [`SPIRType`](@ref)).

Member decorations are attached separately because they use forward references to decorated types.
"""
function attach_member_decorations!(ir::IR, member_decorations::SSADict{Dictionary{Int,DecorationData}})
    for (id, decs) in pairs(member_decorations)
        type = ir.types[id]
        isa(type, StructType) || error("Unsupported member decoration on non-struct type $type")
        for (member, decs) in pairs(decs)
            for (dec, args) in pairs(decs)
                insert!(get!(DecorationData, type.member_decorations, member), dec, args)
            end
        end
    end
end

"""
Attach member names to SPIR-V aggregate types (see [`StructType`](@ref)).

Member names are attached separately because they use forward references to decorated types.
"""
function attach_member_names!(ir::IR, member_names::SSADict{Dictionary{Int,Symbol}})
    for (id, names) in pairs(member_names)
        type = ir.types[id]
        isa(type, StructType) || error("Unsupported member name declaration on non-struct type $type")
        for (member, name) in pairs(names)
            insert!(type.member_names, member, name)
        end
    end
end

function Module(ir::IR)
    insts = Instruction[]

    append!(insts, @inst(OpCapability(cap)) for cap in ir.capabilities)
    append!(insts, @inst(OpExtension(ext)) for ext in ir.extensions)
    append!(insts, @inst(id = OpExtInstImport(extinst)) for (id, extinst) in pairs(ir.extinst_imports))
    push!(insts, @inst OpMemoryModel(ir.addressing_model, ir.memory_model))
    for entry in ir.entry_points
        push!(insts, @inst OpEntryPoint(entry.model, entry.func, String(entry.name), entry.interfaces...))
        append!(insts, entry.modes)
    end
    append_debug_instructions!(insts, ir)
    append_annotations!(insts, ir)
    append_globals!(insts, ir)
    append_functions!(insts, ir)

    Module(ir.meta, max_id(ir) + 1, insts)
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

    for (id, name) in pairs(debug.names)
        push!(insts, @inst OpName(id, String(name)))
    end

    for (id, type) in pairs(ir.types)
        if type isa StructType
            for (member, name) in pairs(type.member_names)
                push!(insts, @inst OpMemberName(id, UInt32(member - 1), String(name)))
            end
        end
    end
end

function append_annotations!(insts, ir::IR)
    for (id, decorations) in pairs(ir.decorations)
        append!(insts, @inst(OpDecorate(id, dec, args...)) for (dec, args) in pairs(decorations))
    end
    for (id, type) in pairs(ir.types)
        if type isa StructType
            append!(insts, @inst(OpMemberDecorate(id, UInt32(member - 1), dec, args...)) for (member, decs) in pairs(type.member_decorations) for (dec, args) in pairs(decs))
        end
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
    push!(insts, @inst id = OpFunction(fdef.control, ir.types[type])::ir.types[type.rettype])
    append!(insts, @inst(id = OpFunctionParameter()::ir.types[argtype]) for (id, argtype) in zip(fdef.args, type.argtypes))
    fbody = body(fdef)
    if !isempty(fbody)
        label = first(fbody)
        @assert label.opcode == OpLabel
        push!(insts, label)
        append!(insts, fdef.variables)
        append!(insts, fbody[2:end])
    end
    push!(insts, @inst OpFunctionEnd())
    insts
end

function append_globals!(insts, ir::IR)
    globals = merge_unique!(BijectiveMapping{SSAValue,Any}(), ir.types, ir.constants, ir.global_vars)
    sortkeys!(globals)
    append!(insts, Instruction(val, id, globals) for (id, val) in pairs(globals))
end

function Instruction(var::Variable, id::SSAValue, types::BijectiveMapping)
    inst = @inst id = OpVariable(var.storage_class)::types[var.type]
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
    str = sprint(disassemble, mod; context = :color => true)
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
