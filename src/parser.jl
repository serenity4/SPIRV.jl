const Word = UInt32

struct SPIRFormatError <: Exception
    msg
end

Base.showerror(io::IO, err::SPIRFormatError) = print(io, "Invalid SPIR-V format: ", err.msg)

invalid_format(msg) = throw(SPIRFormatError(msg))

"""
SPIR-V instruction. Must contain an opcode, and optionally a type id and a result id.
"""
abstract type AbstractInstruction end

info(opcode::OpCode) = classes[opcode][2]
info(opcode::Integer) = info(OpCode(opcode))

function info(inst::AbstractInstruction, skip_ids::Bool = true)
    res = info(inst.opcode)
    skip_ids ? res[start_idx(inst):end] : res
end

start_idx(type_id, result_id) = 1 + !isnothing(type_id) + !isnothing(result_id)
start_idx(inst::AbstractInstruction) = start_idx(inst.type_id, inst.result_id)

function operand_kinds(opcode, skip_ids::Bool)
    op_kinds = getproperty.(info(opcode), :kind)
    if skip_ids
        filter(!in((IdResultType, IdResult)), op_kinds)
    else
        op_kinds
    end
end

operand_kinds(inst::AbstractInstruction, skip_ids::Bool = true) = getproperty.(info(inst, skip_ids), :kind)

"""
SPIR-V instruction in binary format.
"""
struct PhysicalInstruction <: AbstractInstruction
    word_count::UInt16
    opcode::UInt16
    type_id::Union{Nothing,Word}
    result_id::Union{Nothing,Word}
    operands::Vector{Word}
end

"""
SPIR-V module, as a series of headers followed by a stream of instructions.
The header embeds two magic numbers, one for the module itself and one for the tool that generated it (e.g. [glslang](https://github.com/KhronosGroup/glslang)). It also contains the version of the specification applicable to the module, the maximum ID number and an optional instruction schema.
"""
struct PhysicalModule
    magic_number::Word
    generator_magic_number::Word
    version::Word
    bound::Word
    schema::Word
    instructions::Vector{PhysicalInstruction}
end

function PhysicalModule(file::AbstractString)
    open(x -> PhysicalModule(x), file)
end

function PhysicalModule(io::IO)
    insts = PhysicalInstruction[]
    _magic_number = read(io, Word)
    next_word = next_word_f(_magic_number)
    version = next_word(io)
    generator_magic_number = next_word(io)
    bound = next_word(io)
    bound > 4_194_303 && invalid_format("ID bound above valid limit ($bound > $(4_194_303))")
    schema = next_word(io)
    while !eof(io)
        push!(insts, next_instruction(io, next_word))
    end

    PhysicalModule(_magic_number, generator_magic_number, version, bound, schema, insts)
end

function next_id(io::IO, next_word, op_kinds, id_type)
    @match id_type begin
        &IdResultType => begin
            if length(op_kinds) ≠ 0 && first(op_kinds) == id_type
                next_word(io)
            else
                nothing
            end
        end
        &IdResult => begin
            if length(op_kinds) == 1 && id_type == first(op_kinds) || length(op_kinds) > 1 && id_type in op_kinds[1:2]
                next_word(io)
            else
                nothing
            end
        end
    end
end

function next_instruction(io::IO, next_word)
    op_data = next_word(io)
    word_count = op_data >> 2^4

    if word_count == 0
        invalid_format("SPIR-V instructions cannot consume 0 words")
    end

    opcode = OpCode(op_data & 0xffff)
    op_kinds = operand_kinds(opcode, false)

    type_id = next_id(io, next_word, op_kinds, IdResultType)
    result_id = next_id(io, next_word, op_kinds, IdResult)

    operands = Word[]
    for i in 1:(word_count - start_idx(type_id, result_id))
        push!(operands, next_word(io))
    end

    PhysicalInstruction(word_count, opcode, type_id, result_id, operands)
end

function next_word_f(_magic_number::Word)
    if _magic_number == 0x30203270
        swap_endianness = ENDIAN_BOM == 0x04030201 ? ntoh : ltoh
        io::IO -> swap_endianness(read(io, Word))
    elseif _magic_number == magic_number
        io::IO -> read(io, Word)
    else
        error("Unknown magic number $_magic_number")
    end
end

"""
Parsed SPIR-V instruction. It represents an instruction of the form `%result_id = %opcode(%arguments...)::%type_id`.
"""
struct Instruction <: AbstractInstruction
    opcode::OpCode
    type_id::Union{Nothing,Int}
    result_id::Union{Nothing,Int}
    arguments::Vector{Any}
end

function Base.convert(::Type{Instruction}, inst::PhysicalInstruction)
    opcode = OpCode(inst.opcode)
    op_info = info(inst)
    op_kinds = operand_kinds(inst)
    operands = inst.operands

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
            if is_enum(category) && haskey(extra_operands, typeof(arg)) && haskey(extra_operands[typeof(arg)], arg)
                extra_info = extra_operands[typeof(arg)][arg]
                insert!(op_info, operand + 1, extra_info)
            end
            i += j
        end
    end
    Instruction(opcode, inst.type_id, inst.result_id, arguments)
end

function next_argument(operands, info, category)
    kind = info.kind
    if kind == LiteralString
        bytes = reinterpret(UInt8, operands)
        i, chars = parse_bytes_for_utf8_string(bytes)
        str = GC.@preserve chars unsafe_string(pointer(chars))
        div(i, 4, RoundUp), str
    elseif is_enum(category)
        1, kind(first(operands))
    else
        1, first(operands)
    end
end

function parse_bytes_for_utf8_string(bytes)
    utf8_chars = UInt8[]
    for (i, byte) ∈ enumerate(bytes)
        push!(utf8_chars, byte)
        byte == 0 && return (i, utf8_chars)
    end
    error("String is not NUL-terminated")
end

is_enum(category) = category in ("ValueEnum", "BitEnum")

struct SPIRModule
    magic_number::UInt32
    generator_magic_number::UInt32
    version::VersionNumber
    bound::Int
    schema::Int
    instructions::Vector{Instruction}
end

SPIRModule(mod::PhysicalModule) = convert(SPIRModule, mod)
SPIRModule(source) = convert(SPIRModule, PhysicalModule(source))

function Base.convert(::Type{SPIRModule}, mod::PhysicalModule)
    SPIRModule(mod.magic_number, mod.generator_magic_number, spirv_version(mod.version), mod.bound, mod.schema, mod.instructions)
end

function spirv_version(word)
    major = (word & 0x00ff0000) >> 16
    minor = (word & 0x0000ff00) >> 8
    VersionNumber(major, minor)
end
