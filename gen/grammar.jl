g = JSON3.read(read(joinpath(include_dir, "spirv.core.grammar.json"), String))

const magic_number = parse(UInt32, g[:magic_number])
const grammar_version = VersionNumber(getindex.(Ref(g), [:major_version, :minor_version, :revision])...)

instructions = g[:instructions]
operand_kinds = g[:operand_kinds]

enum_categories = unique(getproperty.(operand_kinds, :category))
enum_kinds = unique(getproperty.(operand_kinds, :kind))

function generate_operand_ids(id_operands)
    :(@enum IdType::Int begin $([:($(Symbol(kind)) = $val) for (val, kind) ∈ enumerate(getindex.(id_operands, "kind"))]...) end)
end

function generate_operand_enums(value_enum_operands)
    exprs = []
    for op ∈ value_enum_operands
        kind = Symbol(op["kind"])
        enum_vals = []
        map(op["enumerants"]) do enumerant
            name = enumerant["enumerant"]
            push!(enum_vals, :($(Symbol(kind, name)) = $(enumerant["value"])))
        end
        push!(exprs, :(@cenum $kind::UInt32 begin $(enum_vals...) end))
    end
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
    dict_args = [Expr(:call, :(=>), name, Expr(:tuple, :(Symbol($class)), Expr(:tuple, info(insts[i])...))) for (i, (name, class)) ∈ enumerate(zip(names, classes))]

    [
        :(@cenum OpCode::UInt32 begin $(map((name, val) -> :($name = $val), names, getproperty.(insts, :opcode))...) end),
        Expr(:const, Expr(:(=), :classes, Expr(:call, :Dict, dict_args...))),
    ]

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
    end

    @info "  - enums.jl"
    open(src_dir("generated", "enums.jl"), "w+") do io
        pretty_dump(io, generate_operand_enums(filter(x -> x["category"] == "ValueEnum", operand_kinds)))
        pretty_dump(io, generate_operand_ids(filter(x -> x["category"] == "Id", operand_kinds)))
    end

    true
end

generate() && format()
