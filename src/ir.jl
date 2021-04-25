struct Source
    language::SourceLanguage
    version::VersionNumber
end

struct EntryPoint
    name::Symbol
    id::Int
    execution_model::ExecutionModel
end

struct Variable
    name::Symbol
    id::Int
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

struct IR
    capability::Capability
    extensions::Vector{Symbol}
    source::Source
    memory_model::MemoryModel
    addressing_model::AddressingModel
    entry_points::Vector{EntryPoint}
    variables::Vector{Pair{Int,Variable}}
end

function IR(mod::SPIRModule)
    variables = Dict{Any,Variable}()
    extensions, vars = Symbol[], Dict{Int,Dict}()
    entry_points = EntryPoint[]
    capability, source, memory_model, addressing_model = fill(nothing, 4)
    unnamed_i = 0

    for inst ∈ mod.instructions
        arguments = inst.arguments
        @switch inst.opcode begin
            @case OpCapability
                capability = first(arguments)
            @case OpMemoryModel
                addressing_model, memory_model = arguments
            @case OpEntryPoint
                push!(entry_points, EntryPoint(Symbol(arguments[3]), arguments[2], arguments[1]))
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
                vars[id] = Dict(:id => id, :name => Symbol(name), :decorations => [])
            @case OpDecorate
                id, decoration = arguments[1], arguments[2:end]
                push!(vars[id][:decorations], tuple(decoration...))
            @case _
                nothing
        end
    end

    IR(capability, extensions, source, memory_model, addressing_model, entry_points, keys(vars) .=> Variable.(values(vars)))
end
