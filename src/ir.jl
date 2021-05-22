struct Source
    language::SourceLanguage
    version::VersionNumber
    file::Optional{String}
    code::Optional{String}
    extensions::Vector{Symbol}
end

@broadcastref struct EntryPoint
    name::Symbol
    func::ID
    model::ExecutionModel
    modes::Vector{Instruction}
    interfaces::Vector{ID}
end

struct SSADict{T}
    dict::Dict{ID,T}
    SSADict{T}() where {T} = new{T}(Dict{ID,T}())
end

@forward SSADict.dict Base.getindex, Base.setindex!, Base.pop!, Base.first, Base.last, Base.broadcastable, Base.length, Base.iterate, Base.keys, Base.values, Base.haskey

Base.merge!(vec::SSADict, others::SSADict...) = merge!(vec.dict, getproperty.(others, :dict)...)

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

struct _Decoration
    type::Decoration
    args::Vector{Any}
end

struct FunctionType
    rettype::ID
    argtypes::Vector{ID}
end

@broadcastref struct Block
    insts::Vector{Instruction}
end

struct ControlFlowGraph
    blocks::Vector{Block}
    graph::SimpleDiGraph
end

ControlFlowGraph() = ControlFlowGraph([], SimpleDiGraph())

function get_vertex!(cfg::ControlFlowGraph, block::Block)
    i = findfirst(==(block), cfg.blocks)
    if isnothing(i)
        push!(cfg.blocks, block)
        add_vertex!(cfg.graph)
        nv(cfg.graph)
    else
        i
    end
end

LightGraphs.add_edge!(cfg::ControlFlowGraph, src::Block, dst::Block) = add_edge!(cfg.graph, get_vertex!(cfg, src), get_vertex!(cfg, dst))

struct FunctionDefinition
    type::ID
    control::FunctionControl
    args::Vector{ID}
    cfg::ControlFlowGraph
end

body(fdef::FunctionDefinition) = foldl(append!, map(x -> x.insts, fdef.cfg.blocks); init=Instruction[])

struct IR
    meta::Metadata
    capabilities::Vector{Capability}
    extensions::Vector{Symbol}
    extinst_imports::SSADict{Symbol}
    addressing_model::AddressingModel
    memory_model::MemoryModel
    entry_points::SSADict{EntryPoint}
    decorations::SSADict{Vector{_Decoration}}
    types::SSADict{Any}
    constants::SSADict{Instruction}
    global_vars::SSADict{Instruction}
    globals::SSADict{Instruction}
    fdefs::SSADict{FunctionDefinition}
    results::SSADict{Any}
    debug::Optional{DebugInfo}
end

function IR(mod::Module)
    decorations = SSADict{Vector{_Decoration}}()
    capabilities = Capability[]
    extensions = Symbol[]
    extinst_imports = SSADict{Symbol}()
    source, memory_model, addressing_model = fill(nothing, 3)
    entry_points = SSADict{EntryPoint}()
    types = SSADict{Any}()
    constants = SSADict{Instruction}()
    global_vars = SSADict{Instruction}()
    globals = SSADict{Instruction}()
    fdefs = SSADict{FunctionDefinition}()
    results = SSADict{Any}()

    current_function = nothing
    blocks = SSADict{Block}()
    get_block(id) = haskey(blocks, id) ? blocks[id] : setindex!(blocks, Block([]), id)[id]

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
                        entry_points[id] = EntryPoint(Symbol(name), id, model, [], interfaces)
                    @case OpExecutionMode || OpExecutionModeId
                        id = arguments[1]
                        push!(entry_points[id].modes, inst)
                end
            @case & :Extension
                @switch opcode begin
                    @case OpExtension
                        push!(extensions, Symbol(arguments[1]))
                    @case OpExtInstImport
                        extinst_imports[result_id] = Symbol(arguments[1])
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
                            names[id] = Symbol(name)
                        end
                    @case _
                        nothing
                end
            @case & :Annotation
                @switch opcode begin
                    @case OpDecorate
                        id, type, args... = arguments
                        decoration = _Decoration(type, args)
                        if !haskey(decorations, id)
                            decorations[id] = [decoration]
                        else
                            push!(decorations[id], decoration)
                        end
                    @case _
                        nothing
                end
            @case & Symbol("Type-Declaration")
                @switch opcode begin
                    @case OpTypeFunction
                        rettype = arguments[1]
                        argtypes = length(arguments) == 2 ? arguments[2] : ID[]
                        types[result_id] = FunctionType(rettype, argtypes)
                    @case _
                        types[result_id] = inst
                end
                globals[result_id] = inst
            @case & Symbol("Constant-Creation")
                constants[result_id] = inst
                globals[result_id] = inst
            @case & Symbol("Memory")
                @switch opcode begin
                    @case OpVariable
                        storage_class = arguments[1]
                        initializer = length(arguments) == 2 ? arguments[2] : nothing
                        @switch storage_class begin
                            @case &StorageClassFunction
                                nothing
                            @case _
                                globals[result_id] = inst
                                global_vars[result_id] = inst
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
                        fdefs[result_id] = current_function
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
             results[result_id] = inst
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
    append!(insts, @inst(id = OpExtInstImport(extinst)) for (id, extinst) in ir.extinst_imports)
    push!(insts, @inst OpMemoryModel(ir.addressing_model, ir.memory_model))
    append!(insts, @inst(OpEntryPoint(entry.model, entry.func, entry.name, entry.interfaces)) for (_, entry) in ir.entry_points)

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

        foreach(debug.filenames) do (id, filename)
            push!(insts, @inst OpString(id, filename))
        end

        foreach(debug.names) do (id, name)
            push!(insts, @inst OpName(id, string(name)))
        end
    end
end

function append_annotations!(insts, ir::IR)
    foreach(ir.decorations) do (id, decorations)
        append!(insts, @inst(OpDecorate(id, dec.type, dec.args...)) for dec in decorations)
    end
end

function append_functions!(insts, ir::IR)
    foreach(ir.fdefs) do (id, fdef)
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
