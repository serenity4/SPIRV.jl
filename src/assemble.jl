function PhysicalModule(mod::Module)
  (; meta, bound, instructions) = mod
  (; magic_number, generator_magic_number, version, schema) = meta
  PhysicalModule(magic_number, generator_magic_number, spirv_version(version), bound, schema, PhysicalInstruction.(instructions))
end

function PhysicalInstruction(inst::Instruction)
  operands = physical_operands(inst)
  PhysicalInstruction(
    1 + length(operands) + !isnothing(inst.type_id) + !isnothing(inst.result_id),
    inst.opcode,
    inst.type_id,
    inst.result_id,
    operands,
  )
end

function physical_operands(inst::Instruction)
  operands = Word[]
  for arg in inst.arguments
    add_operand!(operands, arg)
  end
  operands
end

struct SerializedArgument
  words::Vector{Word}
  SerializedArgument(words::Vector{Word}) = new(words)
end

SerializedArgument(arg) = SerializedArgument([arg])

function SerializedArgument(arg::AbstractVector)
  words = Word[]
  for el in arg
    append!(words, reinterpret(Word, [el]))
  end
  SerializedArgument(words)
end

function SerializedArgument(arg::AbstractString)
  utf8_chars = collect(transcode(UInt8, arg))
  push!(utf8_chars, '\0')
  nrem = length(utf8_chars) % 4
  if nrem ≠ 0
    append!(utf8_chars, zeros(4 - nrem))
  end
  SerializedArgument(collect(reinterpret(Word, utf8_chars)))
end

add_operand!(operands, arg::Union{ResultID,Vector{ResultID}}) = push!(operands, arg)
add_operand!(operands, arg) = add_operand!(operands, SerializedArgument(arg))
add_operand!(operands, arg::SerializedArgument) = append!(operands, arg.words)

function Base.write(io::IO, mod::PhysicalModule)
  write(io, assemble(mod))
end

assemble(obj) = assemble!(Word[], obj)

function assemble!(words, inst::PhysicalInstruction)
  push!(words, UInt32(inst.word_count) << 16 + inst.opcode)

  # add optional type ID and result ID
  for field in (:type_id, :result_id)
    val = getproperty(inst, field)
    if !isnothing(val)
      push!(words, val)
    end
  end

  append!(words, inst.operands)

  words
end

function assemble!(words, mod::PhysicalModule)
  append!(words, Word[
    mod.magic_number,
    mod.version,
    mod.generator_magic_number,
    mod.bound,
    mod.schema,
  ])

  for inst in mod.instructions
    assemble!(words, inst)
  end

  words
end

assemble(mod::Module) = assemble(PhysicalModule(mod))
assemble(ir::IR) = assemble(Module(ir))

Base.read(::Type{Module}, filename::AbstractString) = open(io -> read(Module, io), filename)

function Base.read(::Type{Module}, io::IO)
  insts = Instruction[]

  # XXX: Skip any header information.
  # XXX: Handle named variables (e.g. %color instead of %447) to handle IR-disassembled SPIR-V.

  while !eof(io)
    result_id = nothing
    type_id = nothing
    arguments = []
    line = strip(readline(io))
    operands = []
    (startswith(line, ';') || startswith(line, '#') || isempty(line)) && continue
    ex = if contains(line, '=')
      m = match(r"(%\d+)\s*=\s*(.*)", line)
      push!(operands, m[1])
      m[2]
    else
      line
    end
    if endswith(ex, r"\)(::%\d+)?")
      # Pretty print-like format.
      m = match(r"(.*)::(%\d+)", ex)
      if !isnothing(m)
        push!(operands, m[2])
        ex = m[1]
      end
      m = match(r"([a-zA-Z\d]+)\((.*)\)$", ex)::RegexMatch
      ex = replace(join(m, " "), ", " => " ")
      ex = replace(ex, " => " => " ")
    end
    opcode, rest = match(r"([a-zA-Z\d]+)\(?\s*(.*|$)", ex)
    opcode = getproperty(@__MODULE__, Symbol(opcode))::OpCode
    !isempty(rest) && append!(operands, split(rest, ' '))
    op_infos = copy(operand_infos(opcode, false))
    if length(op_infos) > 1 && first(op_infos).kind === IdResultType
      # The result ID is defined after the type ID, but parsed first.
      # Therefore they need to be switched.
      op_infos[1], op_infos[2] = op_infos[2], op_infos[1]
    end
    pair_info = nothing => 0
    for (i, (op, op_info)) in enumerate(zip(operands, op_infos))
      (; kind) = op_info
      category = kind_to_category[kind]
      @switch kind begin
        @case &IdResult
        result_id = parse(ResultID, op)
        @case &IdResultType
        type_id = parse(ResultID, op)
        @case _
        t = isa(kind, DataType) ? kind : typeof(kind)
        arg = @match name = nameof(t) begin
          :Id => parse(ResultID, op)
          :Literal => @match kind begin
            &LiteralExtInstInteger => begin
              if isdigit(first(op))
                parse(Int, op)
              elseif try_getopcode(op, :GLSL) ≠ nothing
                try_getopcode(op, :GLSL)::OpCodeGLSL
              end
            end
            &LiteralInteger || &LiteralSpecConstantOpInteger => parse(UInt32, op)
            &LiteralContextDependentNumber => contains(op, '.') ? reinterpret(UInt32, parse(Float32, op)) : parse(UInt32, op)
            &LiteralString => String(strip(op, '"'))
          end
          :Composite => begin
              if first(pair_info) ≠ kind
                pair_info = kind => 1
              else
                pair_info = kind => last(pair_info) + 1
              end
              @match kind begin
                &PairLiteralIntegerIdRef => last(pair_info) % 2 == 0 ? parse(UInt32, op) : parse(ResultID, op)
                &PairIdRefLiteralInteger => last(pair_info) % 2 == 1 ? parse(UInt32, op) : parse(ResultID, op)
                &PairIdRefIdRef => parse(ResultID, op)
              end
          end
          _ => getproperty(@__MODULE__, Symbol(name, op))
        end
        push!(arguments, arg)
        add_extra_operands!(op_infos, i, arg, op_info)
        op_info.quantifier == "*" && length(operands) ≠ length(arguments) && push!(op_infos, last(op_infos))
      end
    end
    push!(insts, Instruction(opcode, type_id, result_id, arguments))
  end
  Module(ModuleMetadata(), compute_id_bound(insts), insts)
end

Base.parse(::Type{Module}, str::AbstractString) = read(Module, IOBuffer(str))
