function disassemble(io::IO, inst::Instruction)
    id_pad = 3 + 1

    typeid = @match inst.type_id begin
        ::Nothing => ""
               id => string(crayon"#bbff00", "::", crayon"#ffbb00", "%$id", crayon"reset")
    end

    assignment = @match inst.result_id begin
        ::Nothing => ' '^(id_pad + 3)
               id => string(crayon"#ffbb00", lpad("%$id", id_pad), crayon"reset") * " = "
    end

    print(io, assignment)
    print(io, crayon"#33ccff", inst.opcode, crayon"reset")

    args = map(zip(inst.arguments, operand_kinds(inst.opcode, true))) do (arg, op_kind)
        category = kind_to_category[op_kind]
        @match arg begin
            ::AbstractVector => join(argument_str.(arg, op_kind, category), ", ")
            _ => argument_str(arg, op_kind, category)
        end
    end

    if !isempty(args)
        print(io, '(', join(args, ", "), ')')
    end

    print(io, typeid)
end

function argument_str(arg, kind, category)
    literalnum_color = crayon"red"
    @match category begin
        "ValueEnum" => string(crayon"#abffcd", replace(string(arg), Regex("^$(nameof(kind))") => ""), crayon"reset")
        "BitEnum" => string(literalnum_color, arg, crayon"reset")
        "Literal" => @match kind begin
            &LiteralString => string(crayon"#99ff88", arg, crayon"reset")
            _ => string(literalnum_color, arg, crayon"reset")
        end
        "Id" => string(crayon"#ffbb00", "%", Int(arg), crayon"reset")
    end
end

"""
    disassemble(io, spir_module)

Transform the content of `spir_module` into a human-readable format and prints it to `io`.
"""
function disassemble(io::IO, spirmod::SPIRModule)
    if spirmod.magic_number == magic_number
        println(io, "SPIR-V")
    else
        println(io, "Magic number: ", spirmod.magic_number)
    end
    println(io, "Version: ", join([spirmod.version.major, spirmod.version.minor], "."))
    println(io, "Generator: ", hex(spirmod.generator_magic_number))
    println(io, "Bound: ", spirmod.bound)
    println(io, "Schema: ", spirmod.schema)
    println(io)
    for inst ∈ spirmod.instructions
        disassemble(io, inst)
        println(io)
    end
end

hex(x) = "0x" * lpad(string(x, base=16), sizeof(x) * 2, '0')

disassemble(obj) = disassemble(stdout, obj)

Base.show(io::IO, ::MIME"text/plain", inst::Instruction) = disassemble(io, inst)

Base.show(io::IO, spirmod::SPIRModule) = print(io, "SPIRModule(#instructions=$(length(spirmod.instructions)))")
Base.show(io::IO, ::MIME"text/plain", spirmod::SPIRModule) = disassemble(io, spirmod)
