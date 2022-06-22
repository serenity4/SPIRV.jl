struct SPIRFormatError <: Exception
  msg
end

Base.showerror(io::IO, err::SPIRFormatError) = print(io, "Invalid SPIR-V format: ", err.msg)

function defines_extra_operands(arg)
  val = get(enum_infos, arg, nothing)
  !isnothing(val) && !isempty(val.parameters)
end

function add_extra_operands!(op_infos, i, arg, category)
  if defines_extra_operands(arg)
    for info in reverse(enum_infos[arg].parameters)
      insert!(op_infos, i + 1, info)
    end
  end
end

invalid_format(msg...) = throw(SPIRFormatError(string(msg...)))

function info(opcode::Union{OpCode,OpCodeGLSL}, skip_ids::Bool = true)
  source = isa(opcode, OpCode) ? instruction_infos : instruction_infos_glsl
  info = source[opcode]
  if skip_ids
    info = @set info.operands = filter(x -> !in(x.kind, (IdResultType, IdResult)), info.operands)
  end
  info
end
info(opcode::Integer, args...) = info(OpCode(opcode), args...)
info(inst::AbstractInstruction, args...) = info(inst.opcode, args...)

start_idx(type_id, result_id) = 1 + !isnothing(type_id) + !isnothing(result_id)
start_idx(inst::AbstractInstruction) = start_idx(inst.type_id, inst.result_id)
function is_literal(opcode::OpCode, args, i)
  kind = operand_infos(opcode, args)[i].kind
  isa(kind, Literal) || (kind == PairIdRefLiteralInteger && i % 2 == 0) || (kind == PairLiteralIntegerIdRef && i % 2 == 1)
end

operand_infos(args...) = info(args...).operands
operand_kinds(args...) = getproperty.(operand_infos(args...), :kind)

"""
SPIR-V module, as a series of headers followed by a stream of instructions.
The header embeds two magic numbers, one for the module itself and one for the tool that generated it (e.g. [glslang](https://github.com/KhronosGroup/glslang)). It also contains the version of the specification applicable to the module, the maximum ID number and an optional instruction schema.
"""
@auto_hash_equals struct PhysicalModule
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

Base.read(io::IO, ::Type{PhysicalModule}) = read(IOBuffer(read(io)), PhysicalModule)
Base.read(io::IOBuffer, ::Type{PhysicalModule}) = read(correct_endianess(io), PhysicalModule)

"""
Return an IO that will always read in the right endianness.
"""
function correct_endianess(io::IO)
  magic = peek(io, UInt32)
  swap = magic == magic_number ? false : magic == 0x30203270 ? true : invalid_format("Invalid SPIR-V magic number: expected ", repr(magic_number), " or 0x30203270, got ", repr(magic))
  SwapStream(swap, io)
end

read_word(io::IO) = read(io, Word)

function Base.read(io::SwapStream, ::Type{PhysicalModule})
  insts = PhysicalInstruction[]
  _magic_number = read_word(io)
  version = read_word(io)
  generator_magic_number = read_word(io)
  bound = read_word(io)
  bound > 4_194_303 && invalid_format("ID bound above valid limit (", bound, " > ", 4_194_303)
  schema = read_word(io)
  while !eof(io)
    push!(insts, next_instruction(io, read_word))
  end

  PhysicalModule(_magic_number, generator_magic_number, version, bound, schema, insts)
end

function next_id(io::IO, read_word, op_kinds, id_type)
  @match id_type begin
    &IdResultType => begin
      if length(op_kinds) ≠ 0 && id_type == first(op_kinds)
        read_word(io)
      else
        nothing
      end
    end
    &IdResult => begin
      if length(op_kinds) == 1 && id_type == first(op_kinds) || length(op_kinds) > 1 && id_type in op_kinds[1:2]
        read_word(io)
      else
        nothing
      end
    end
  end
end

function next_instruction(io::IO, read_word)
  op_data = read_word(io)
  word_count = op_data >> 2^4

  if word_count == 0
    invalid_format("SPIR-V instructions cannot consume 0 words")
  end

  opcode = OpCode(op_data & 0xffff)
  op_kinds = operand_kinds(opcode, false)

  type_id = next_id(io, read_word, op_kinds, IdResultType)
  result_id = next_id(io, read_word, op_kinds, IdResult)

  operands = Word[]
  for i = 1:(word_count - start_idx(type_id, result_id))
    push!(operands, read_word(io))
  end

  PhysicalInstruction(word_count, opcode, type_id, result_id, operands)
end

function info(opcode::OpCode, arguments::AbstractVector, skip_ids::Bool = true)
  inst_info = deepcopy(info(opcode, skip_ids))
  op_infos = inst_info.operands

  # Repeat the last info if there is a variable number of arguments.
  if !isempty(op_infos)
    linfo = last(op_infos)
    if linfo.quantifier == "*"
      append!(op_infos, linfo for _ = 1:(length(arguments) - 1))
    end
  end

  # Add extra operands.
  for (i, arg) in enumerate(arguments)
    info = op_infos[i]
    category = kind_to_category[info.kind]
    add_extra_operands!(op_infos, i, arg, category)
  end
  inst_info
end

"""
Information regarding an `Instruction` and its operands, including extra parameters.
"""
function info(inst::Instruction, skip_ids::Bool = true)
  inst_info = info(inst.opcode, inst.arguments)
  inst_info
end

function Instruction(inst::PhysicalInstruction)
  opcode = OpCode(inst.opcode)
  op_infos = copy(operand_infos(inst))
  operands = inst.operands

  arguments = []
  i = 1
  while i ≤ length(operands)
    operand = length(arguments) + 1
    info = op_infos[operand]
    category = kind_to_category[info.kind]
    (; quantifier) = info
    @switch quantifier begin
      @case "?"
      error("Unhandled '?' quantifier")
      @case "*" || nothing
      j, arg = next_argument(operands[i:end], info)
      category == "Id" && (arg = SSAValue(arg))
      push!(arguments, arg)
      add_extra_operands!(op_infos, i, arg, category)
      i += j
    end
    quantifier == "*" && push!(op_infos, last(op_infos))
  end
  Instruction(opcode, inst.type_id, inst.result_id, arguments)
end

function next_argument(operands, info)
  (; kind) = info
  (nwords, val) = if kind == LiteralString
    bytes = reinterpret(UInt8, operands)
    i, chars = parse_bytes_for_utf8_string(bytes)
    str = GC.@preserve chars unsafe_string(pointer(chars))
    div(i, 4, RoundUp), str
  elseif kind isa Literal
    arg = first(operands)
    #FIXME: Literals that consume multiple words are not supported.
    # We need a way to detect the number of words they take.
    1, arg
  elseif kind isa DataType && is_enum(kind)
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

ModuleMetadata() = ModuleMetadata(magic_number, generator_magic_number, v"1.5", 0)

@auto_hash_equals struct Module
  meta::ModuleMetadata
  bound::Int
  instructions::Vector{Instruction}
end

Module(mod::PhysicalModule) =
  Module(ModuleMetadata(mod.magic_number, mod.generator_magic_number, spirv_version(mod.version), mod.schema), mod.bound, Instruction.(mod.instructions))
Module(source) = Module(PhysicalModule(source))

Base.getindex(mod::Module, index::Integer) = mod.instructions[index]

function Base.isapprox(mod1::Module, mod2::Module; compare_debug_info = false)
  if !compare_debug_info
    mod1 = strip_debug_info(mod1)
    mod2 = strip_debug_info(mod2)
  end
  mod1.meta == mod2.meta && mod1.bound == mod2.bound && Set(mod1.instructions) == Set(mod2.instructions)
end

function strip_debug_info!(mod::Module)
  filter!(mod.instructions) do inst
    info(inst).class ≠ "Debug"
  end
  mod
end
strip_debug_info(mod::Module) = strip_debug_info!(@set mod.instructions = deepcopy(mod.instructions))

@forward Module.instructions (Base.iterate,)

function spirv_version(word)
  major = (word & 0x00ff0000) >> 16
  minor = (word & 0x0000ff00) >> 8
  VersionNumber(major, minor)
end

function spirv_version(version::VersionNumber)
  version.major << 16 + version.minor << 8
end

Base.show(io::IO, mod::Module) = print(io, "Module(#instructions=$(length(mod.instructions)))")

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

max_ssa(insts::Vector{Instruction}) = maximum(x -> something(x.result_id, SSAValue(0)), insts)
max_ssa(mod::Union{PhysicalModule,Module}) = SSAValue(mod.bound)
