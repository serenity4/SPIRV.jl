const g = JSON3.read(read(joinpath(include_dir, "spirv.core.grammar.json"), String))

const magic_number = parse(UInt32, g[:magic_number])
const grammar_version = VersionNumber(getindex.(Ref(g), [:major_version, :minor_version, :revision])...)
const instructions = g[:instructions]
const operand_kinds = g[:operand_kinds]

"""
Generate enumeration values representing SPIR-V operand kind categories.
These enumerations are not defined by the specification.
"""
function generate_category_as_enum(category)
    _operand_kinds = filter(x -> x["category"] == category, operand_kinds)
    kinds = getproperty.(_operand_kinds, :kind)

    typedecl = :($(Symbol(category))::Int)
    vals = (:($(Symbol(kind)) = $val) for (val, kind) in enumerate(kinds))
    :(@enum $typedecl begin $(vals...) end)
end

function extra_operands(enumerant)::Vector{Expr}
    if hasproperty(enumerant, :parameters)
        params = map(enumerant[:parameters]) do param
            Dict(k => (k == :kind ? Symbol(v) : strip(v, '\'')) for (k, v) ∈ param)
        end
        [Expr(:tuple, (:($k = $v) for (k, v) ∈ param)...) for param ∈ params]
    else
        []
    end
end

function generate_enum(operand)
    kind = Symbol(operand["kind"])
    enum_vals = []
    extra_operands_parameters = Expr[]

    foreach(operand["enumerants"]) do enumerant
        name = enumerant["enumerant"]
        enum_name = Symbol(kind, name)

        val = operand[:category] == "BitEnum" ? parse(UInt32, enumerant["value"]) : enumerant["value"]
        push!(enum_vals, :($enum_name = $val))

        parameters = extra_operands(enumerant)
        if !isempty(parameters)
            push!(extra_operands_parameters, :($enum_name => [$(parameters...)]))
        end
    end

    extra_operands_dict = isempty(extra_operands_parameters) ? nothing : :($kind => Dict($(extra_operands_parameters...)))
    :(@cenum $kind::UInt32 begin $(enum_vals...) end), extra_operands_dict
end

function generate_enums()
    enums = []
    extra_operands = []
    for op ∈ operand_kinds
        category = op["category"]
        if category ∈ ("ValueEnum", "BitEnum")
            enum_expr, extra_operands_expr = generate_enum(op)
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

function generate_kind_to_category()
    :(const kind_to_category = Dict($([:($(Symbol(operand["kind"])) => $(operand["category"])) for operand ∈ operand_kinds]...)))
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
        pretty_dump(io, generate_kind_to_category())
    end

    @info "  - enums.jl"

    open(src_dir("generated", "enums.jl"), "w+") do io
        pretty_dump(io, generate_category_as_enum("Id"))
        pretty_dump(io, generate_category_as_enum("Literal"))
        pretty_dump(io, generate_category_as_enum("Composite"))
        pretty_dump(io, generate_enums())
    end

    true
end
