function print_argument(io::IO, arg, kind, category)
    if kind ≠ IdResult
        print(io, " ")
        @match category begin
            GuardBy(is_enum) => print(io, replace(string(arg), Regex("^$(nameof(kind))") => ""))
            "Literal" => @match kind begin
                &LiteralString => print(io, crayon"#99ff88", arg, crayon"reset")
                _ => print(io, crayon"red", Int(arg), crayon"reset")
            end
            "Id" => print(io, crayon"#ffaaaa", "%", Int(arg), crayon"reset")
        end
    end
end

info(inst::GenericInstruction) = classes[inst.opcode][2]

id_padding(id::Nothing) = 0
id_padding(id) = 4 + length(string(id))

function print_result_id(io::IO, inst::GenericInstruction, id_bound)
    op_kinds = getproperty.(info(inst), :kind)
    index = findfirst(x -> x == IdResult, op_kinds)
    inst_crayon = crayon"#33ccff"
    @match index begin
        ::Nothing => print(io, " "^id_padding(id_bound), inst_crayon, inst.opcode, crayon"reset")
        _ => begin
            id = inst.arguments[index]
            print(io, crayon"#ffbb00", lpad("%$id = ", id_padding(something(id_bound, id))), inst_crayon, inst.opcode, crayon"reset")
        end
    end
end

function print_instruction(io::IO, inst::GenericInstruction, id_bound)
    print_result_id(io, inst, id_bound)
    for (arg, info) ∈ zip(inst.arguments, info(inst))
        kind = info.kind
        category = kind_to_category[kind]
        @match arg begin
            ::AbstractVector => print_argument.(Ref(io), arg, kind, category)
            _ => print_argument(io, arg, kind, category)
        end
    end
end

"""
    disassemble(io, spir_module)

Transform the content of `spir_module` into a human-readable format and prints it to the provided IO.
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
        print_instruction(io, inst, spirmod.bound)
        println(io)
    end
end

disassemble(spirmod::SPIRModule) = disassemble(stdout, spirmod)
