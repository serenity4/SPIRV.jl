struct SPIRFormatError <: Exception
    msg
end

Base.showerror(io::IO, err::SPIRFormatError) = print(io, "Invalid SPIR-V format: ", err.msg)

invalid_format(msg) = throw(SPIRFormatError(msg))

struct Instruction
    opcode::OpCode
    operands::Vector{UInt32}
end

struct SPIRModule{V<:AbstractVector{<:Instruction}}
    magic_number::UInt32
    generator_magic_number::UInt32
    version::VersionNumber
    bound::Int
    schema::Int
    instructions::V
end

function SPIRModule(file)
    io = open(file, "r")
    mod = parse_spirv(io)
    close(io)
    mod
end

function spirv_version(word)
    major = (word & 0x00ff0000) >> 16
    minor = (word & 0x0000ff00) >> 8
    VersionNumber(major, minor)
end

function next_instruction(io::IO, next_word)
    op_data = next_word(io)
    word_count = Int(op_data >> 16)
    opcode = OpCode(op_data & 0xffff)
    if word_count == 0
        invalid_format("SPIR-V instructions cannot consume 0 words")
    end

    operands = Int[]
    for i ∈ 1:(word_count-1)
        push!(operands, next_word(io))
    end
    Instruction(opcode, operands)
end

function next_word_f(_magic_number::UInt32)
    if _magic_number == 0x30203270
        swap_endianness = ENDIAN_BOM == 0x04030201 ? ntoh : ltoh
        io::IO -> swap_endianness(read(io, UInt32))
    elseif _magic_number == magic_number
        io::IO -> read(io, UInt32)
    else
        error("Unknown magic number $_magic_number")
    end
end

function parse_spirv(io::IO)
    insts = Instruction[]
    _magic_number = read(io, UInt32)
    next_word = next_word_f(_magic_number)
    version = spirv_version(next_word(io))
    generator_magic_number = next_word(io)
    bound = next_word(io)
    bound > 4_194_303 && invalid_format("ID bound above valid limit ($bound > $(4_194_303))")
    schema = next_word(io)
    while !eof(io)
        push!(insts, next_instruction(io, next_word))
    end

    SPIRModule(_magic_number, generator_magic_number, version, Int(bound), Int(schema), insts)
end

hex(x) = "0x" * lpad(string(x, base=16), sizeof(x) * 2, '0')

function parse_bytes_for_utf8_string(bytes)
    utf8_chars = UInt8[]
    for (i, byte) ∈ enumerate(bytes)
        push!(utf8_chars, byte)
        byte == 0 && return (i, utf8_chars)
    end
    error("String is not NUL-terminated")
end

function next_argument(operands, info, category)
    kind = info.kind
    if kind == "LiteralString"
        bytes = reinterpret(UInt8, operands)
        i, chars = parse_bytes_for_utf8_string(bytes)
        str = GC.@preserve chars unsafe_string(pointer(chars))
        # @info "LiteralString => $str for $i bytes"
        div(i, 4, RoundUp), str
    # elseif kind == "LiteralInteger"
    #     for (i, word) ∈ enumerate(operands)
    #         if (0 & word) ≠ 0

    #         end
    #     end
    elseif category == "ValueEnum"
        1, Base.eval(@__MODULE__, Symbol(kind))(first(operands))
    else
        1, first(operands)
    end
end

function print_argument(io::IO, arg, kind, category)
    if kind ≠ "IdResult"
        print(io, " ")
        if category == "ValueEnum"
            print(io, arg)
        elseif category == "Literal"
            if kind == "LiteralString"
                print(io, arg)
            else
                print(io, Int(arg))
            end
        elseif category == "Id"
            print(io, "%", Int(arg))
        else
            print(io, "<$category>", hex(arg))
        end
    end
end

Base.show(io::IO, inst::Instruction) = print_instruction(io, inst, nothing)

id_padding(id::Nothing) = 0
id_padding(id) = 4 + length(string(id))

function print_instruction(io::IO, inst::Instruction, id_bound)
    op_info = classes[inst.opcode][2]
    operands = inst.operands
    op_kinds = getproperty.(op_info, :kind)
    op = findfirst(x -> x == "IdResult", op_kinds)
    inst_crayon = crayon"#99ff88"

    if isnothing(op)
        print(io, " "^id_padding(id_bound), inst_crayon, inst.opcode, crayon"reset")
    else
        id = operands[op]
        print(io, crayon"#ffbb00", lpad("%$id = ", id_padding(something(id_bound, id))), inst_crayon, inst.opcode, crayon"reset")
    end

    # According to the specification, 1 operand (4 bytes) = 1 argument, except for literals.
    # Literal arguments may be built from several operands, e.g. a string consumes as many operands
    # as necessary until it encounters a NUL character.
    # It is necessary to recover all arguments.
    # First, though, we need to know the type of the operand being processed;
    # is it a literal (in which case we scan for more words), or does it obey the rule 1 operand = 1 argument?

    arguments = []
    i = 1
    while i ≤ length(operands)
        operand = length(arguments) + 1
        info = op_info[operand]
        category = kind_to_category[info.kind]
        if hasproperty(info, :quantifier)
            quantifier = info.quantifier
            if quantifier == "*"
                push!(arguments, operands[i:end])
                break
            elseif quantifier == "?"
                error("Unhandled '?' quantifier")
            end
        else
            j, arg = next_argument(operands[i:end], info, category)
            push!(arguments, arg)
            if category == "ValueEnum" && haskey(extra_operands, typeof(arg)) && haskey(extra_operands[typeof(arg)], arg)
                extra_info = extra_operands[typeof(arg)][arg]
                insert!(op_info, operand + 1, extra_info)
            end
            # @info "$operand ($i -> $(i + j)): $arg => $arguments"
            i += j
        end
    end

    for (arg, info) ∈ zip(arguments, op_info)
        kind = info.kind
        category = kind_to_category[kind]
        if arg isa AbstractVector
            print_argument.(Ref(io), arg, kind, category)
        else
            print_argument(io, arg, kind, category)
        end
    end
end

function Base.show(io::IO, spirmod::SPIRModule)
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
