const g = JSON3.read(read(joinpath(include_dir, "spirv.core.grammar.json"), String))

const magic_number = parse(UInt32, g[:magic_number])
const grammar_version = VersionNumber(getindex.(Ref(g), [:major_version, :minor_version, :revision])...)
const instructions = g[:instructions]
const operand_kinds = g[:operand_kinds]

function generate_category_as_enum(operand_kinds, category)
    :(@enum $(Symbol(category))::Int begin $([:($(Symbol(kind)) = $val) for (val, kind) ∈ enumerate(getindex.(filter(x -> x["category"] == category, operand_kinds), "kind"))]...) end)
end

function extra_operands(enumerant, enum_name, operand)
    if hasproperty(enumerant, :parameters)
        params = map(enumerant[:parameters]) do param
            Dict(k => (k == :kind ? Symbol(v) : strip(v, '\'')) for (k, v) ∈ param)
        end
        (enum_name, [:(tuple($([:($k = $v) for (k, v) ∈ param]...))) for param ∈ params]...)
    else
        nothing
    end
end

function generate_enum(operand, category)
    kind = Symbol(operand["kind"])
    enum_vals = []
    parameters = []

    foreach(operand["enumerants"]) do enumerant
        name = enumerant["enumerant"]
        enum_name = Symbol(kind, name)

        extra_ops = extra_operands(enumerant, enum_name, operand)
        !isnothing(extra_ops) && push!(parameters, extra_ops)
        val = category == "BitEnum" ? parse(UInt16, enumerant["value"]) : enumerant["value"]

        push!(enum_vals, :($enum_name = $val))
    end

    enum_expr = :(@cenum $kind::UInt32 begin $(enum_vals...) end)
    extra_operands_expr = isempty(parameters) ? nothing : :($kind => Dict($(map(x -> :($(x[1]) => $(x[2])), parameters)...)))

    enum_expr, extra_operands_expr
end

function generate_enums(operands)
    enums = []
    extra_operands = []
    for op ∈ operands
        category = op["category"]
        if category ∈ ("ValueEnum", "BitEnum")
            enum_expr, extra_operands_expr = generate_enum(op, category)
            !isnothing(extra_operands_expr) && push!(extra_operands, extra_operands_expr)
            push!(enums, enum_expr)
        end
    end

    parameter_dict = :(const extra_operands = Dict($(extra_operands...)))

    vcat(enums, parameter_dict)
end

function generate_instruction_printing_class(insts_pc)
    insts_pc_noexclude = insts_pc[2:end]
    classes = getindex.(insts_pc_noexclude, "tag")
    strs = getindex.(insts_pc_noexclude, "heading")

    dict_args = vcat(:(Symbol("@exclude") => ""), [:(Symbol($class) => $str) for (class, str) ∈ zip(classes, strs)])

    :(const class_printing = Dict($(dict_args...)))
end

function attrs(operand)
    map(zip(keys(operand), values(operand))) do (name, value)
        if name == :kind
            :($name = $(Symbol(value)))
        else
            :($name = $(strip(value, '\'')))
        end
    end
end

function generate_instructions(insts)
    names = Symbol.(getproperty.(insts, :opname))
    classes = getproperty.(insts, :class)

    info(inst) = "operands" ∈ keys(inst) ? [:(tuple($(attrs(operand)...))) for operand ∈ inst["operands"]] : Expr[]

    dict_args = [:($name => $(:(tuple(Symbol($class), [$(info(insts[i])...)])))) for (i, (name, class)) ∈ enumerate(zip(names, classes))]

    [
        :(@cenum OpCode::UInt32 begin $(map((name, val) -> :($name = $val), names, getproperty.(insts, :opcode))...) end),
        :(const classes = Dict($(dict_args...))),
    ]
end

function generate_kind_to_category(operands)
    :(const kind_to_category = Dict($([:($(Symbol(operand["kind"])) => $(operand["category"])) for operand ∈ operands]...)))
end

function pretty_dump(io, expr::Expr)
    custom_print(io, expr)
    println(io)
end

pretty_dump(io, exprs) = foreach(x -> pretty_dump(io, x), exprs)

src_dir(x...) = joinpath(dirname(@__DIR__), "src", x...)

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
        pretty_dump(io, generate_category_as_enum(operand_kinds, "Composite"))
        pretty_dump(io, generate_enums(operand_kinds))
    end

    true
end
