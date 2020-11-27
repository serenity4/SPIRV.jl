struct SPIRFormatError <: Exception
    msg
end

Base.showerror(io::IO, err::SPIRFormatError) = print(io, "Invalid SPIR-V format: ", err.msg)

invalid_format(msg) = throw(SPIRFormatError(msg))

struct Instruction
    opcode::OpCode
    operands::Vector{Int}
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

function Base.show(io::IO, inst::Instruction)
    op_info = classes[inst.opcode][2]
    op_kinds = getproperty.(op_info, :kind)
    op = findfirst(x -> x == "IdResult", op_kinds)
    inst_crayon = crayon"#99ff88"
    if isnothing(op)
        print(io, " "^8, inst_crayon, inst.opcode, crayon"reset")
    else
        print(io, crayon"#ffbb00", lpad("%$(inst.operands[op]) = ", 8), inst_crayon, inst.opcode, crayon"reset")
    end
    for (op, info) ∈ zip(inst.operands, op_info)
        if info.kind ≠ "IdResult"
            print(io, " %", op)
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
    println(io, "Generator: ", spirmod.generator_magic_number)
    println(io, "Bound: ", spirmod.bound)
    println(io, "Schema: ", spirmod.schema)
    for inst ∈ spirmod.instructions
        println(io, inst)
    end
end
