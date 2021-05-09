struct Source
    language::SourceLanguage
    version::VersionNumber
    file::Optional{String}
    code::Optional{String}
    extensions::Vector{Symbol}
end

@broadcastref struct EntryPoint
    name::Symbol
    id::Int
    model::ExecutionModel
    modes::Vector{Instruction}
    interfaces::Vector{Int}
end

struct SSADict{T}
    dict::Dict{Int,T}
    SSADict{T}() where {T} = new{T}(Dict{Int,T}())
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

struct IR
    meta::Metadata
    capabilities::Vector{Capability}
    extensions::Vector{Symbol}
    extinst_imports::SSADict{Symbol}
    addressing_model::AddressingModel
    memory_model::MemoryModel
    entry_points::SSADict{EntryPoint}
    decorations::SSADict{Vector{_Decoration}}
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
    results = SSADict{Any}()
    unnamed_i = 0
    filenames = SSADict{String}()
    names = SSADict{Symbol}()
    lines = SSADict{LineInfo}()
    ids = Int[]

    for inst ∈ mod.instructions
        @unpack arguments, type_id, result_id, opcode = inst
        class, info = classes[opcode]
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
            @case _
                nothing
        end
        if !isnothing(result_id)
             results[result_id] = inst
        end
    end

    merge!(results, extinst_imports, entry_points)

    debug = DebugInfo(filenames, names, lines, source)

    IR(Metadata(mod.magic_number, mod.generator_magic_number, mod.version, mod.schema), capabilities, extensions, extinst_imports, addressing_model, memory_model, entry_points, decorations, results, debug)
end

function Module(ir::IR)
    insts = Instruction[]

    append!(insts, @inst(OpCapability(cap)) for cap in ir.capabilities)
    append!(insts, @inst(OpExtension(ext)) for ext in ir.extensions)
    append!(insts, @inst(id = OpExtInstImport(extinst)) for (id, extinst) in ir.extinst_imports)
    push!(insts, @inst OpMemoryModel(ir.addressing_model, ir.memory_model))
    append!(insts, @inst(OpEntryPoint(entry.model, entry.id, entry.name, entry.interfaces)) for (_, entry) in ir.entry_points)

    # debug information
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

    # annotations (non-debug)
    foreach(ir.decorations) do (id, decorations)
        append!(insts, @inst(OpDecorate(id, dec.type, dec.args...)) for dec in decorations)
    end

    # all types, variables and constants

    # all functions


    Module(ir.meta.magic_number, ir.meta.generator_magic_number, ir.meta.version, maximum(keys(ir.results)) + 1, ir.meta.schema, insts)
end
