function emit(io::IO, inst::Instruction, id_bound = 999; pad_assignment = false)
    if !isnothing(inst.result_id)
        printstyled(io, inst.result_id; color=:yellow)
        print(io, " = ")
    end

    printstyled(io, inst.opcode; color=:light_cyan)

    print(io, '(')

    isfirst = true
    for (arg, info) in zip(inst.arguments, operand_infos(inst))
        !isfirst && print(io, ", ")
        isfirst = false
        emit_argument(io, arg, info.kind)
    end

    print(io, ')')

    if !isnothing(inst.type_id)
        printstyled(io, "::"; color=:light_green, bold=true)
        printstyled(io, inst.type_id; color=:light_green, bold=true)
    end
end

function emit_argument(io, arg::AbstractVector, kind)
    category = kind_to_category[kind]
    args = copy(arg)
    emit_argument(io, popfirst!(args), kind, category)
    while !isempty(args)
        print(io, ", ")
        emit_argument(io, popfirst!(args), kind, category)
    end
end

function emit_argument(io, arg, kind)
    category = kind_to_category[kind]
    emit_argument(io, arg, kind, category)
end

function emit_argument(io, arg, kind, category)
    @match category begin
        "ValueEnum" => printstyled(io, replace(string(arg), string(nameof(kind)) => ""); color=:208)
        "BitEnum" => printstyled(io, replace(string(arg), string(nameof(kind)) => ""); color=:light_magenta)
        "Literal" => @match kind begin
            &LiteralString => printstyled(io, '"', arg, '"'; color=150)
            _ => printstyled(io, arg; color=153)
        end
        "Id" => printstyled(io, arg; color=:yellow)
    end
end

show(io::IO, ::MIME"text/plain", inst::Instruction) = emit(io, inst)

"""
    disassemble(io, spir_module)

Transform the content of `spir_module` into a human-readable format and prints it to `io`.
"""
function disassemble(io::IO, mod::Module)
    (; meta, bound) = mod
    if meta.magic_number == magic_number
        println(io, "SPIR-V")
    else
        println(io, "Magic number: ", meta.magic_number)
    end
    println(io, "Version: ", join([meta.version.major, meta.version.minor], "."))
    println(io, "Generator: ", hex(meta.generator_magic_number))
    println(io, "Bound: ", bound)
    println(io, "Schema: ", meta.schema)
    println(io)

    padding(id) = length(string(bound)) - (isnothing(id) ? -4 : length(string(id)) - 1)
    for inst ∈ mod.instructions
        print(io, ' '^padding(inst.result_id))
        emit(io, inst, bound)
        println(io)
    end
end

hex(x) = "0x" * lpad(string(x, base=16), sizeof(x) * 2, '0')

disassemble(obj) = disassemble(stdout, obj)
disassemble(io::IO, mod::PhysicalModule) = disassemble(io, Module(mod))

show(io::IO, ::MIME"text/plain", mod::Module) = disassemble(io, mod)