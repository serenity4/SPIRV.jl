g = JSON3.read(read(joinpath(include_dir, "spirv.core.grammar.json"), String))

const magic_number = parse(UInt32, g[:magic_number])
const spirv_version = VersionNumber(getindex.(Ref(g), [:major_version, :minor_version, :revision])...)

instructions = g[:instructions]
operand_kinds = g[:operand_kinds]

enum_categories = unique(getproperty.(operand_kinds, :category))
enum_kinds = unique(getproperty.(operand_kinds, :kind))

function generate_operand_enums(operand_kinds, kind=nothing)
    exprs = []
    for op ∈ operand_kinds
        _kind = Symbol(op["kind"])
        if op["category"] == "ValueEnum" && _kind == something(kind, _kind)
            enum_vals = []
            map(op["enumerants"]) do enumerant
                push!(enum_vals, :($(Symbol(enumerant["enumerant"])) = $(enumerant["value"])))
            end
            push!(exprs, :(@cenum $_kind::UInt32 begin $(enum_vals...) end))
        end
    end
    exprs
end

function generate_instructions(insts)
    exprs = []
    names = Symbol.(getproperty.(insts, :opname))
    classes = getproperty.(insts, :class)
    push!(exprs, :(@cenum InstructionTypes::UInt32 begin $(map((name, val) -> :($name = $val), names, getproperty.(insts, :opcode))...) end))
    push!(exprs, :(classes = (Dict($([name => Symbol(class) for (name, class) ∈ zip(names, classes)]...)))))

    exprs
end

function custom_print(io::IO, expr::Expr)
    if expr.head == :struct
        println(io)
        str = string(prettify(expr))
        str_nonewline = replace(str, "\n" => " ")
        println(io, str_nonewline)
        println(io)
    else
        println(io, prettify(expr))
    end
end

src_dir(x...) = joinpath(dirname(@__DIR__), "src", x...)

mkpath(src_dir("generated"))

open(src_dir("generated", "instructions.jl"), "w+") do io
    map(generate_instructions(instructions)) do expr
        if expr.head == :(=)
            split_text = split(format_text(string(prettify(expr))), "\n")
            @show split_text[1:5]
            println(io, join(replace.(split_text, r"^\s+\:" => "    ")), "\n")
        else
            custom_print(io, expr)
        end
        println(io)
    end
end

open(src_dir("generated", "enums.jl"), "w+") do io
    map(generate_operand_enums(operand_kinds)) do expr
        custom_print(io, expr)
        println(io)
    end
end

format_file(src_dir("generated", "instructions.jl"), margin=500)
format_file(src_dir("generated", "enums.jl"), margin=500)
