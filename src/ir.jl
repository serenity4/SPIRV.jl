struct Source
    language::SourceLanguage
    version::VersionNumber
    file::Optional{String}
    code::Optional{String}
    extensions::Vector{Symbol}
end

@broadcastref struct EntryPoint <: SSAIndexable
    name::Symbol
    func::ID
    model::ExecutionModel
    modes::Vector{Instruction}
    interfaces::Vector{ID}
end

ID(ep::EntryPoint) = ep.func

struct Metadata
    magic_number::UInt32
    generator_magic_number::UInt32
    version::VersionNumber
    schema::Int
end

struct LineInfo
    file::String
    line::Int
    column::Int
end

struct DebugInfo
    filenames::SSADict{String}
    names::SSADict{Symbol}
    lines::SSADict{LineInfo}
    source::Optional{Source}
end

struct Variable
    id::ID
    type::SPIRType
    storage_class::StorageClass
    initializer::Optional{Instruction}
    decorations::Dictionary{Decoration,Vector{Any}}
end

function Variable(inst::Instruction, types::SSADict{SPIRType}, results::SSADict{Any}, decorations::SSADict{Dictionary{Decoration,Vector{Any}}})
    storage_class = first(inst.arguments)
    initializer = length(inst.arguments) == 2 ? results[last(inst.arguments)] : nothing
    Variable(inst.result_id, types[inst.type_id].type, storage_class, initializer, get(decorations, inst.result_id, Dictionary{Decoration,Vector{Any}}()))
end

SPIRType(var::Variable) = PointerType(var.storage_class, var.type)

struct IR
    meta::Metadata
    capabilities::Vector{Capability}
    extensions::Vector{Symbol}
    extinst_imports::SSADict{Symbol}
    addressing_model::AddressingModel
    memory_model::MemoryModel
    entry_points::SSADict{EntryPoint}
    decorations::SSADict{Dictionary{Decoration,Vector{Any}}}
    types::SSADict{SPIRType}
    constants::SSADict{Instruction}
    global_vars::SSADict{Variable}
    globals::SSADict{Instruction}
    fdefs::SSADict{FunctionDefinition}
    results::SSADict{Any}
    debug::Optional{DebugInfo}
end

function IR(mod::Module)
    decorations = SSADict{Dictionary{Decoration,Vector{Any}}}()
    capabilities = Capability[]
    extensions = Symbol[]
    extinst_imports = SSADict{Symbol}()
    source, memory_model, addressing_model = fill(nothing, 3)
    entry_points = SSADict{EntryPoint}()
    types = SSADict{SPIRType}()
    constants = SSADict{Instruction}()
    global_vars = SSADict{Variable}()
    globals = SSADict{Instruction}()
    fdefs = SSADict{FunctionDefinition}()
    results = SSADict{Any}()

    current_function = nothing
    blocks = SSADict{Block}()
    get_block(id) = get!(blocks, id, Block([]))

    current_block = nothing
    current_cfg = nothing

    # debug
    filenames = SSADict{String}()
    names = SSADict{Symbol}()
    lines = SSADict{LineInfo}()

    for (i, inst) ∈ enumerate(mod.instructions)
        @unpack arguments, type_id, result_id, opcode = inst
        class, info = classes[opcode]
        isnothing(current_block) || push!(current_block.insts, inst)
        @switch class begin
            @case & Symbol("Mode-Setting")
                @switch opcode begin
                    @case OpCapability
                        push!(capabilities, arguments[1])
                    @case OpMemoryModel
                        addressing_model, memory_model = arguments
                    @case OpEntryPoint
                        model, id, name, interfaces = arguments
                        insert!(entry_points, id, EntryPoint(Symbol(name), id, model, [], interfaces))
                    @case OpExecutionMode || OpExecutionModeId
                        id = arguments[1]
                        push!(entry_points[id].modes, inst)
                end
            @case & :Extension
                @switch opcode begin
                    @case OpExtension
                        push!(extensions, Symbol(arguments[1]))
                    @case OpExtInstImport
                        insert!(extinst_imports, result_id, Symbol(arguments[1]))
                    @case OpExtInst
                        nothing
                end
            @case & :Debug
                @switch opcode begin
                    @case OpSource
                        language, version = arguments[1:2]
                        file, code = @match length(arguments) begin
                            2 => (nothing, nothing)
                            3 => @match arg = arguments[3] begin
                                ::Integer => (arg, nothing)
                                ::String => (nothing, arg)
                            end
                            4 => arguments[3:4]
                        end

                        if !isnothing(file)
                            file = filenames[file]
                        end
                        source = Source(language, source_version(language, version), file, code, [])
                    @case OpSourceExtension
                        @assert !isnothing(source) "Source extension was declared before the source."
                        push!(source.extensions, Symbol(arguments[1]))
                    @case OpName
                        id, name = arguments
                        if !isempty(name)
                            insert!(names, id, Symbol(name))
                        end
                    @case _
                        nothing
                end
            @case & :Annotation
                @switch opcode begin
                    @case OpDecorate
                        id, type, args... = arguments
                        if haskey(decorations, id)
                            insert!(decorations[id], type, args)
                        else
                            insert!(decorations, id, dictionary([type => args]))
                        end
                    @case _
                        nothing
                end
            @case & Symbol("Type-Declaration")
                @switch opcode begin
                    @case OpTypeFunction
                        rettype = arguments[1]
                        argtypes = length(arguments) == 2 ? arguments[2] : ID[]
                        insert!(types, result_id, FunctionType(rettype, argtypes))
                    @case _
                        insert!(types, result_id, parse_type(inst, types, results))
                end
                insert!(globals, result_id, inst)
            @case & Symbol("Constant-Creation")
                insert!(constants, result_id, inst)
                insert!(globals, result_id, inst)
            @case & Symbol("Memory")
                @switch opcode begin
                    @case OpVariable
                        storage_class = arguments[1]
                        initializer = length(arguments) == 2 ? arguments[2] : nothing
                        @switch storage_class begin
                            @case &StorageClassFunction
                                nothing
                            @case _
                                insert!(globals, result_id, inst)
                                insert!(global_vars, result_id, Variable(inst, types, results, decorations))
                        end
                    @case _
                        nothing
                end
            @case & :Function
                @switch opcode begin
                    @case OpFunction
                        control, type = arguments
                        current_cfg = ControlFlowGraph(Block[], SimpleDiGraph())
                        current_function = FunctionDefinition(type, control, [], current_cfg)
                        insert!(fdefs, result_id, current_function)
                    @case OpFunctionParameter
                        push!(current_function.args, result_id)
                    @case OpFunctionEnd
                        current_function = nothing
                    @case _
                        nothing
                end
            @case & Symbol("Control-Flow")
                @switch opcode begin
                    # first block instruction
                    @case OpLabel
                        current_block = get_block(result_id)
                        push!(current_block.insts, inst)
                        @assert !isnothing(current_function) "Block definition outside function"
                        cfg = current_cfg
                        if current_block ∉ cfg.blocks
                            push!(cfg.blocks, current_block)
                            add_vertex!(cfg.graph)
                        end

                    @case OpBranch || OpBranchConditional || OpSwitch || OpReturn || OpReturnValue || OpKill || OpUnreachable || OpSelectionMerge || OpLoopMerge
                        cfg = current_cfg
                        src = current_block

                        _add_edge! = dst -> add_edge!(cfg, src, get_block(dst))

                        @switch opcode begin
                            @case OpBranch
                                dst = arguments[1]
                                _add_edge!(dst)
                            @case OpBranchConditional
                                cond, dst1, dst2, weights... = arguments
                                _add_edge!(dst1)
                                _add_edge!(dst2)
                            @case OpSwitch
                                cond, default, dsts... = arguments
                                foreach(_add_edge!, (default, dsts...))
                            @case OpLoopMerge
                                merge_id, continue_id, loop_control, params... = arguments
                                _add_edge!(merge_id)
                                _add_edge!(continue_id)
                            @case OpSelectionMerge
                                merge_id, selection_control = arguments
                                _add_edge!(merge_id)
                            @case _
                                nothing
                        end

                        @switch opcode begin
                            # last block instruction
                            @case OpBranch || OpBranchConditional || OpSwitch || OpReturn || OpReturnValue || OpKill || OpUnreachable
                                current_block = nothing
                            @case _
                                nothing
                        end
                    @case _
                        nothing
                end
            @case _
                nothing
        end
        if !isnothing(result_id) && !haskey(results, result_id)
             insert!(results, result_id, inst)
        end
    end

    merge!(results, extinst_imports)

    meta = Metadata(mod.magic_number, mod.generator_magic_number, mod.version, mod.schema)
    debug = DebugInfo(filenames, names, lines, source)

    IR(meta, capabilities, extensions, extinst_imports, addressing_model, memory_model, entry_points, decorations, types, constants, global_vars, globals, fdefs, results, debug)
end

function Module(ir::IR)
    insts = Instruction[]

    append!(insts, @inst(OpCapability(cap)) for cap in ir.capabilities)
    append!(insts, @inst(OpExtension(ext)) for ext in ir.extensions)
    append!(insts, @inst(id = OpExtInstImport(extinst)) for (id, extinst) in pairs(ir.extinst_imports))
    push!(insts, @inst OpMemoryModel(ir.addressing_model, ir.memory_model))
    append!(insts, @inst(OpEntryPoint(entry.model, entry.func, entry.name, entry.interfaces)) for entry in ir.entry_points)

    append_debug_instructions!(insts, ir)
    append_annotations!(insts, ir)
    append_globals!(insts, ir)
    append_functions!(insts, ir)

    Module(ir.meta.magic_number, ir.meta.generator_magic_number, ir.meta.version, maximum(keys(ir.results)) + 1, ir.meta.schema, insts)
end

function append_debug_instructions!(insts, ir::IR)
    if !isnothing(ir.debug)
        debug::DebugInfo = ir.debug
        if !isnothing(debug.source)
            source::Source = debug.source
            args = Any[source.language, source_version(source.language, source.version)]
            !isnothing(source.file) && push!(args, source.file)
            !isnothing(source.code) && push!(args, source.code)
            push!(insts, @inst OpSource(args...))
            append!(insts, @inst(OpSourceExtension(string(ext))) for ext in source.extensions)
        end

        foreach(pairs(debug.filenames)) do (id, filename)
            push!(insts, @inst OpString(id, filename))
        end

        foreach(pairs(debug.names)) do (id, name)
            push!(insts, @inst OpName(id, string(name)))
        end
    end
end

function append_annotations!(insts, ir::IR)
    foreach(pairs(ir.decorations)) do (id, decorations)
        append!(insts, @inst(OpDecorate(id, type, args...)) for (type, args) in pairs(decorations))
    end
end

function append_functions!(insts, ir::IR)
    foreach(pairs(ir.fdefs)) do (id, fdef)
        append!(insts, instructions(ir, fdef, id))
    end
end

function instructions(ir::IR, fdef::FunctionDefinition, id::ID)
    insts = Instruction[]
    type_id = fdef.type
    type = ir.types[type_id]
    push!(insts, @inst id = OpFunction(fdef.control, type_id)::type.rettype)
    append!(insts, @inst(id = OpFunctionParameter()::argtype) for (id, argtype) in zip(fdef.args, type.argtypes))
    append!(insts, body(fdef))
    push!(insts, @inst OpFunctionEnd())
    insts
end

function append_globals!(insts, ir::IR)
    ids = keys(ir.globals)
    vals = values(ir.globals)
    perm = sortperm(collect(ids))
    append!(insts, collect(vals)[perm])
end
