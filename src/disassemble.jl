function disassemble(io::IO, inst::Instruction)
    id_pad = 3 + 1

    type_id = @match inst.type_id begin
        ::Nothing => ""
               id => string(crayon"#bbff00", "::", crayon"#ffbb00", "%$id", crayon"reset")
    end

    assignment = @match inst.result_id begin
        ::Nothing => ' '^(id_pad + 3)
               id => string(crayon"#ffbb00", lpad("%$id", id_pad), crayon"reset") * " = "
    end

    print(io, assignment)
    print(io, crayon"#33ccff", inst.opcode, crayon"reset")

    args = map(zip(inst.arguments, operand_kinds(inst))) do (arg, kind)
        category = kind_to_category[kind]
        @match arg begin
            ::AbstractVector => join(argument_str.(arg, kind, category), ", ")
            _ => argument_str(arg, kind, category)
        end
    end

    if !isempty(args)
        print(io, '(', join(args, ", "), ')')
    end

    print(io, type_id)
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
function disassemble(io::IO, mod::SPIRModule)
    if mod.magic_number == magic_number
        println(io, "SPIR-V")
    else
        println(io, "Magic number: ", mod.magic_number)
    end
    println(io, "Version: ", join([mod.version.major, mod.version.minor], "."))
    println(io, "Generator: ", hex(mod.generator_magic_number))
    println(io, "Bound: ", mod.bound)
    println(io, "Schema: ", mod.schema)
    println(io)
    for inst ∈ mod.instructions
        disassemble(io, inst)
        println(io)
    end
end

hex(x) = "0x" * lpad(string(x, base=16), sizeof(x) * 2, '0')

disassemble(obj) = disassemble(stdout, obj)
disassemble(io::IO, mod::PhysicalModule) = disassemble(io, convert(SPIRModule, mod))

show(io::IO, ::MIME"text/plain", inst::Instruction) = disassemble(io, inst)

show(io::IO, ::MIME"text/plain", mod::SPIRModule) = disassemble(io, mod)
