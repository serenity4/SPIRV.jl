g = JSON3.read(read(joinpath(include_dir, "spirv.core.grammar.json"), String))

const magic_number = parse(UInt32, g[:magic_number])
const grammar_version = VersionNumber(getindex.(Ref(g), [:major_version, :minor_version, :revision])...)

instructions = g[:instructions]
operand_kinds = g[:operand_kinds]

enum_categories = unique(getproperty.(operand_kinds, :category))
enum_kinds = unique(getproperty.(operand_kinds, :kind))

function generate_category_as_enum(operand_kinds, category)
    :(@enum $(Symbol(category))::Int begin $([:($(Symbol(kind)) = $val) for (val, kind) ∈ enumerate(getindex.(filter(x -> x["category"] == category, operand_kinds), "kind"))]...) end)
end

const_dict(name, arguments) = Expr(:const, Expr(:(=), :($(Symbol(name))), Expr(:call, :Dict, arguments...)))

nt_from_dict(d) = Expr(:tuple, [Expr(:(=), Symbol(k), v) for (k, v) ∈ d]...)

function generate_operand_enums(value_enum_operands)
    exprs = []
    extra_operands = []
    for op ∈ value_enum_operands
        kind = Symbol(op["kind"])
        enum_vals = []
        parameters = []
        foreach(op["enumerants"]) do enumerant
            name = enumerant["enumerant"]
            enum_name = Symbol(kind, name)
            if hasproperty(enumerant, :parameters)
                params = map(enumerant[:parameters]) do param
                    # Dict(k => (k == :kind ? (v ∈ getproperty.(op["enumerants"], :enumerant) ? Symbol(kind, v) : Symbol(v)) : strip(v, '\'')) for (k, v) ∈ param)
                    Dict(k => strip(v, '\'') for (k, v) ∈ param)
                end
                push!(parameters, (enum_name, :(($(nt_from_dict.(params)...)))))
            end
            push!(enum_vals, :($enum_name = $(enumerant["value"])))
        end
        push!(exprs, :(@cenum $kind::UInt32 begin $(enum_vals...) end))
        !isempty(parameters) && push!(extra_operands, Expr(:call, :(=>), kind, Expr(:call, :Dict, map(x -> Expr(:call, :(=>), x[1], x[2]), parameters)...)))
    end
    parameter_dict = const_dict(:extra_operands, extra_operands)
    push!(exprs, parameter_dict)

    exprs
end

function generate_instruction_printing_class(insts_pc)
    insts_pc_noexclude = insts_pc[2:end]
    classes = getindex.(insts_pc_noexclude, "tag")
    strs = getindex.(insts_pc_noexclude, "heading")
    dict_args = vcat(:(Symbol("@exclude") => ""), [:(Symbol($class) => $str) for (class, str) ∈ zip(classes, strs)])
    Expr(:const, Expr(:(=), :class_printing, Expr(:call, :Dict, dict_args...)))
end

function generate_instructions(insts)
    names = Symbol.(getproperty.(insts, :opname))
    classes = getproperty.(insts, :class)
    info(inst) = "operands" ∈ keys(inst) ? [Expr(:tuple, Expr(:parameters, [Expr(:kw, Symbol(name), strip(value, '\'')) for (name, value) ∈ operand]...)) for operand ∈ inst["operands"]] : Expr[]
    dict_args = [Expr(:call, :(=>), name, Expr(:tuple, :(Symbol($class)), Expr(:vect, info(insts[i])...))) for (i, (name, class)) ∈ enumerate(zip(names, classes))]

    [
        :(@cenum OpCode::UInt32 begin $(map((name, val) -> :($name = $val), names, getproperty.(insts, :opcode))...) end),
        Expr(:const, Expr(:(=), :classes, Expr(:call, :Dict, dict_args...))),
    ]
end

function generate_kind_to_category(operands)
    Expr(:const, Expr(:(=), :kind_to_category, Expr(:call, :Dict, [Expr(:call, :(=>), :($(operand["kind"])), :($(operand["category"]))) for operand ∈ operands]...)))
end

function pretty_dump(io, expr::Expr)
    custom_print(io, expr)
    println(io)
end

pretty_dump(io, exprs) = foreach(x -> pretty_dump(io, x), exprs)

src_dir(x...) = joinpath(dirname(@__DIR__), "src", x...)

mkpath(src_dir("generated"))

function generate()
    @info "Generating files:"
    @info "  - instructions.jl"
    open(src_dir("generated", "instructions.jl"), "w+") do io
        pretty_dump(io, generate_instructions(instructions))
        pretty_dump(io, generate_instruction_printing_class(g[:instruction_printing_class]))
        pretty_dump(io, generate_kind_to_category(operand_kinds))
    end

    @info "  - enums.jl"
    open(src_dir("generated", "enums.jl"), "w+") do io
        pretty_dump(io, generate_category_as_enum(operand_kinds, "Id"))
        pretty_dump(io, generate_category_as_enum(operand_kinds, "Literal"))
        pretty_dump(io, generate_operand_enums(filter(x -> x["category"] == "ValueEnum", operand_kinds)))
    end

    true
end

generate() && format()
