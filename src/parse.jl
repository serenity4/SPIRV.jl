struct SPIRFormatError <: Exception
  msg
end

Base.showerror(io::IO, err::SPIRFormatError) = print(io, "Invalid SPIR-V format: ", err.msg)

function defines_extra_operands(arg)
  val = get(enum_infos, arg, nothing)
  !isnothing(val) && !isempty(val.parameters)
end

function add_extra_operands!(op_infos, i, @nospecialize(arg), info)
  if defines_extra_operands(arg) || kind_to_category[info.kind] == "BitEnum"
    if kind_to_category[info.kind] == "BitEnum"
      extra_infos = [(enum_infos[flag].parameters for flag in enabled_flags(arg))...;]
    else
      extra_infos = enum_infos[arg].parameters
    end
    for info in reverse(extra_infos)
      insert!(op_infos, i + 1, info)
    end
  end
end

invalid_format(msg...) = throw(SPIRFormatError(string(msg...)))

function info(opcode::Union{OpCode,OpCodeGLSL}, skip_ids::Bool = true)
  info = @match opcode begin
    ::OpCode => instruction_infos[opcode]
    ::OpCodeGLSL => instruction_infos_glsl[opcode]
  end
  !skip_ids && return info
  operands = OperandInfo[]
  for operand in info.operands
    (operand.kind === IdResultType || operand.kind === IdResult) && continue
    push!(operands, operand)
  end
  # XXX: use `@set` when ConstructionBase performance is fixed.
  # https://github.com/JuliaObjects/ConstructionBase.jl/issues/55
  InstructionInfo(info.class, operands, info.required)
end
info(opcode::Integer, args...) = info(OpCode(opcode), args...)
info(inst::AbstractInstruction, args...) = info(inst.opcode, args...)

start_idx(type_id, result_id) = 1 + !isnothing(type_id) + !isnothing(result_id)
start_idx(inst::AbstractInstruction) = start_idx(inst.type_id, inst.result_id)
function is_literal(opcode::OpCode, args, i)
  kind = operand_infos(opcode, args)[i].kind
  isa(kind, Literal) || (kind == PairIdRefLiteralInteger && i % 2 == 0) || (kind == PairLiteralIntegerIdRef && i % 2 == 1) || isa(kind, DataType) && (kind <: BitMask || kind <: Enum || kind <: Cenum)
end

operand_infos(args...) = info(args...).operands

"""
SPIR-V module, as a series of headers followed by a stream of instructions.
The header embeds two magic numbers, one for the module itself and one for the tool that generated it (e.g. [glslang](https://github.com/KhronosGroup/glslang)). It also contains the version of the specification applicable to the module, the maximum ID number and an optional instruction schema.
"""
@struct_hash_equal struct PhysicalModule
  magic_number::Word
  generator_magic_number::Word
  version::Word
  bound::Word
  schema::Word
  instructions::Vector{PhysicalInstruction}
end

Base.isapprox(mod1::PhysicalModule, mod2::PhysicalModule) =
  mod1.bound == mod2.bound && mod1.generator_magic_number == mod2.generator_magic_number && mod1.magic_number == mod2.magic_number &&
  mod1.schema == mod2.schema && mod1.version == mod2.version && Set(mod1.instructions) == Set(mod2.instructions)

function PhysicalModule(file::AbstractString)
  open(io -> read(io, PhysicalModule), file)
end
PhysicalModule(bytes::AbstractVector{<:Unsigned}) = PhysicalModule(reinterpret(UInt8, bytes))
PhysicalModule(bytes::AbstractVector{UInt8}) = read(IOBuffer(bytes), PhysicalModule)

Base.read(io::IO, ::Type{PhysicalModule}) = read(IOBuffer(read(io)), PhysicalModule)
Base.read(io::IOBuffer, ::Type{PhysicalModule}) = read(correct_endianess(io), PhysicalModule)

"""
Return an IO that will always read in the right endianness.
"""
function correct_endianess(io::IO)
  magic = peek(io, UInt32)
  swap = magic == MAGIC_NUMBER ? false : magic == 0x30203270 ? true : invalid_format("Invalid SPIR-V magic number: expected ", repr(MAGIC_NUMBER), " or 0x30203270, got ", repr(magic))
  SwapStream(swap, io)
end

read_word(io::IO) = read(io, Word)

function Base.read(io::SwapStream, ::Type{PhysicalModule})
  insts = PhysicalInstruction[]
  magic_number = read_word(io)
  version = read_word(io)
  generator_magic_number = read_word(io)
  bound = read_word(io)
  bound > 4_194_303 && invalid_format("ID bound above valid limit (", bound, " > ", 4_194_303)
  schema = read_word(io)
  while !eof(io) && bytesavailable(io.io) > 3
    push!(insts, next_instruction(io, read_word))
  end

  PhysicalModule(magic_number, generator_magic_number, version, bound, schema, insts)
end

function type_id(io::IO, read_word, opcode::OpCode)
  info = instruction_infos[opcode]
  isempty(info.operands) && return nothing
  operand = info.operands[1]
  operand.kind === IdResultType && return read_word(io)
  nothing
end

function result_id(io::IO, read_word, opcode::OpCode)
  info = instruction_infos[opcode]
  isempty(info.operands) && return nothing
  operand = info.operands[1]
  operand.kind === IdResult && return read_word(io)
  length(info.operands) == 1 && return nothing
  operand.kind !== IdResultType && return nothing
  operand = info.operands[2]
  operand.kind === IdResult && return read_word(io)
  nothing
end

function next_instruction(io::IO, read_word)
  op_data = read_word(io)
  word_count = op_data >> 2^4

  iszero(word_count) && invalid_format("SPIR-V instructions cannot consume 0 words")

  opcode = OpCode(op_data & 0xffff)

  tid = type_id(io, read_word, opcode)
  rid = result_id(io, read_word, opcode)

  operands = Word[]
  for i = 1:(word_count - start_idx(tid, rid))
    push!(operands, read_word(io))
  end

  PhysicalInstruction(word_count, opcode, tid, rid, operands)
end

function info(opcode::OpCode, arguments::AbstractVector, skip_ids::Bool = true)
  ref = info(opcode, skip_ids)

  op_infos = OperandInfo[]
  append!(op_infos, ref.operands)
  # XXX: use `@set` when ConstructionBase performance is fixed.
  # https://github.com/JuliaObjects/ConstructionBase.jl/issues/55
  inst_info = InstructionInfo(ref.class, op_infos, ref.required)

  # Repeat the last info if there is a variable number of arguments.
  if !isempty(op_infos)
    linfo = last(op_infos)
    if linfo.quantifier == "*" || opcode == OpConstant
      append!(op_infos, linfo for _ = 1:(length(arguments) - 1))
    end
  end

  # Add extra operands.
  for (i, arg) in enumerate(arguments)
    if opcode == OpNop
      # If we get an `OpNop`, allow having a variable number of arguments so we can strip it afterwards.
      # It is merely meant as a placeholder.
      push!(op_infos, OperandInfo(IdRef, "Operand $i", nothing))
      continue
    end
    inbounds = firstindex(op_infos) ≤ i ≤ lastindex(op_infos)
    !inbounds && error("Too many operands for instruction ", sprintc(printstyled, opcode; color = :cyan), " ($(length(arguments)) arguments received: $arguments, expected $(length(op_infos)))")
    info = op_infos[i]
    category = kind_to_category[info.kind]
    add_extra_operands!(op_infos, i, arg, info)
  end
  inst_info
end

"""
Information regarding an `Instruction` and its operands, including extra parameters.
"""
info(inst::Instruction, skip_ids::Bool = true) = info(inst.opcode, inst.arguments)

function Instruction(inst::PhysicalInstruction)
  opcode = OpCode(inst.opcode)
  op_infos = copy(operand_infos(inst))
  (; operands) = inst

  arguments = []
  operand = 1
  while operand ≤ lastindex(operands)
    argument = 1 + lastindex(arguments)
    info = if argument > lastindex(op_infos) && op_infos[end].quantifier == "*";
      op_infos[end]
    else
      op_infos[argument]
    end
    (; kind, quantifier) = info
    @switch quantifier begin
      @case "*" || "?" && if info === op_infos[end] end || nothing
      category = kind_to_category[kind]
      consumes_remaining_words = opcode == OpConstant && info === op_infos[end]
      consumed, arg = next_argument(operands[operand:end], kind, category, consumes_remaining_words)
      isa(arg, Vector{Word}) ? append!(arguments, arg) : push!(arguments, arg)
      add_extra_operands!(op_infos, operand, arg, info)
      operand += consumed
      @case "?"
      error("Unhandled non-final '?' quantifier for instruction $opcode")
    end
  end
  Instruction(opcode, inst.type_id, inst.result_id, arguments)
end

function next_argument(operands::Vector{Word}, kind, category, consumes_remaining_words::Bool)
  (nwords, val) = if kind == LiteralString
    bytes = reinterpret(UInt8, operands)
    i, chars = parse_bytes_for_utf8_string(bytes)
    str = GC.@preserve chars unsafe_string(pointer(chars))
    div(i, 4, RoundUp), str
  elseif kind isa Literal
    consumes_remaining_words ? (length(operands), operands) : (1, first(operands))
  elseif kind isa DataType && is_enum(kind)
    T = kind
    1, T(operands[1])
  else
    arg = operands[1]
    category == "Id" && (arg = ResultID(arg))
    1, arg
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

is_enum(category::AbstractString) = category in ("ValueEnum", "BitEnum")

const enum_types = Set(map(first, filter!(is_enum ∘ last, collect(pairs(kind_to_category)))))

is_enum(val) = is_enum(typeof(val))
is_enum(t::DataType) = t in enum_types

struct ModuleMetadata
  magic_number::UInt32
  generator_magic_number::UInt32
  version::VersionNumber
  schema::Int
end

ModuleMetadata() = ModuleMetadata(MAGIC_NUMBER, GENERATOR_MAGIC_NUMBER, SPIRV_VERSION, 0)

"""
Logical representation of a SPIR-V module.
"""
@struct_hash_equal struct Module
  meta::ModuleMetadata
  bound::Int
  instructions::Vector{Instruction}
end

Module(mod::PhysicalModule) =
  Module(ModuleMetadata(mod.magic_number, mod.generator_magic_number, spirv_version(mod.version), mod.schema), mod.bound, Instruction.(mod.instructions))
Module(source) = Module(PhysicalModule(source))
Module(meta::ModuleMetadata, insts::AbstractVector{Instruction}, bound = compute_id_bound(insts)) = Module(meta, bound, insts)

function Base.isapprox(mod1::Module, mod2::Module; compare_debug_info = false, renumber = false)
  if !compare_debug_info
    mod1 = strip_debug_info(mod1)
    mod2 = strip_debug_info(mod2)
  end
  renumber && ((mod1, mod2) = (renumber_ssa(mod1), renumber_ssa(mod2)))
  mod1.meta == mod2.meta && mod1.bound == mod2.bound && Set(mod1.instructions) == Set(mod2.instructions)
end

function strip_debug_info!(mod::Module)
  filter!(mod.instructions) do inst
    info(inst).class ≠ "Debug"
  end
  mod
end
strip_debug_info(mod::Module) = strip_debug_info!(@set mod.instructions = deepcopy(mod.instructions))

@forward_interface Module field = :instructions interface = [indexing, iteration]
@forward_methods Module field = :instructions Base.view(_, args...)

function Base.getindex(mod::Module, id::ResultID)
  for inst in mod.instructions
    inst.result_id === id && return inst
  end
  throw(KeyError(id))
end

function spirv_version(word)
  major = (word & 0x00ff0000) >> 16
  minor = (word & 0x0000ff00) >> 8
  VersionNumber(major, minor)
end

function spirv_version(version::VersionNumber)
  version.major << 16 + version.minor << 8
end

Base.show(io::IO, mod::Module) = print(io, "Module($(length(mod.instructions)) instructions)")

Base.write(io::IO, mod::Module) = write(io, assemble(mod))

function print_diff(mod1::Module, mod2::Module)
  buff1 = IOBuffer()
  disassemble(buff1, mod1)
  seekstart(buff1)
  buff2 = IOBuffer()
  disassemble(buff2, mod2)
  seekstart(buff2)
  for (l1, l2) in zip(readlines(buff1), readlines(buff2))
    if l1 ≠ l2
      println(l1, " => ", l2)
    end
  end
end

compute_id_bound(insts::Vector{Instruction}) = ResultID(1 + UInt32(maximum(x -> something(x.result_id, ResultID(0)), insts)))
id_bound(mod::Union{PhysicalModule,Module}) = ResultID(mod.bound)
