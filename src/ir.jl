struct Source
    language::SourceLanguage
    version::VersionNumber
end

@broadcastref struct EntryPoint
    name::Symbol
    id::Int
    model::ExecutionModel
    modes::Vector{Instruction}
    interfaces::Vector{Int}
end

struct SSAVector{T}
    els::Dict{Int,T}
    SSAVector{T}() where {T} = new{T}(Dict{Int,T}())
end

@forward SSAVector.els Base.getindex, Base.setindex!, Base.pop!, Base.first, Base.last, Base.broadcastable, Base.length, Base.iterate

struct Variable
    id::Int
    name::Optional{Symbol}
    decorations::Vector{Any}
end

Variable(d::AbstractDict) = Variable(d[:name], d[:id], d[:decorations])

function show(io::IO, var::Variable)
    print(io, "Variable ", var.name, " (%", var.id)
    if !isempty(var.decorations)
        for dec ∈ var.decorations
            print(io, ", ", join((dec .|> @λ begin
                x::Decoration -> replace(string(x), r".*Decoration" => "")
                x -> x
            end), ": ")...)
        end
    end
    print(io, ")")
end

struct Metadata
    magic_number::UInt32
    generator_magic_number::UInt32
    version::VersionNumber
    schema::Int
end

struct IR
    meta::Metadata
    capabilities::Vector{Capability}
    extensions::Vector{Symbol}
    extinst_imports::SSAVector{Symbol}
    memory_model::MemoryModel
    entry_points::SSAVector{EntryPoint}
    addressing_model::AddressingModel
    variables::SSAVector{Variable}
    ids::Vector{Int}
end

function IR(mod::Module)
    variables = SSAVector{Variable}()
    extensions = Symbol[]
    extinst_imports = SSAVector{Symbol}()
    entry_points = SSAVector{EntryPoint}()
    capabilities = Capability[]
    source, memory_model, addressing_model = fill(nothing, 3)
    unnamed_i = 0
    ids = Int[]

    for inst ∈ mod.instructions
        arguments = inst.arguments
        result_id = inst.result_id
        @switch inst.opcode begin
            @case OpCapability
                @assert length(arguments) == 1
                push!(capabilities, arguments[1])
            @case OpExtInstImport
                extinst_imports[result_id] = Symbol(arguments[1])
            @case OpMemoryModel
                addressing_model, memory_model = arguments
            @case OpEntryPoint
                model, id, name, interfaces = arguments
                entry_points[id] = EntryPoint(Symbol(name), id, model, [], interfaces)
            @case OpSource
                int_version = arguments[2]
                major = int_version ÷ 100
                minor = (int_version - 100*major) ÷ 10
                source = Source(arguments[1], VersionNumber(major, minor))
            @case OpName
                id, name_str = arguments
                name = if isempty(name_str)
                    unnamed_i += 1
                    Symbol("__var_$unnamed_i")
                else
                    Symbol(name_str)
                end
                variables[id] = Variable(id, name, [])
            @case OpDecorate
                id, decoration... = arguments
                push!(variables[id].decorations, tuple(decoration...))
            @case _
                nothing
        end
        if !isnothing(inst.result_id)
            push!(ids, inst.result_id)
        end
    end

    IR(Metadata(mod.magic_number, mod.generator_magic_number, mod.version, mod.schema), capabilities, extensions, extinst_imports, memory_model, entry_points, addressing_model, variables, sort(ids))
end

function Base.convert(::Type{Module}, ir::IR)
    insts = Instruction[]

    append!(insts, @inst(OpCapability(cap)) for cap in ir.capabilities)
    append!(insts, @inst(OpExtension(ext)) for ext in ir.extensions)
    append!(insts, @inst(id = OpExtInstImport(extinst)) for (id, extinst) in ir.extinst_imports)
    push!(insts, @inst OpMemoryModel(ir.addressing_model, ir.memory_model))
    append!(insts, @inst(OpEntryPoint(entry.model, entry.id, entry.name, entry.interfaces)) for (_, entry) in ir.entry_points)

    Module(ir.meta.magic_number, ir.meta.generator_magic_number, ir.meta.version, maximum(ir.ids) + 1, ir.meta.schema, insts)
end
