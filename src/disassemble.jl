function emit(io::IO, inst::Instruction)
  if !isnothing(inst.result_id)
    printstyled(io, inst.result_id; color = :yellow)
    print(io, " = ")
  end

  printstyled(io, inst.opcode; color = :light_cyan)

  print(io, '(')

  isfirst = true
  for (i, (arg, info)) in enumerate(zip(inst.arguments, operand_infos(inst)))
    !isfirst && kind_to_category[info.kind] ≠ "Composite" && print(io, ", ")
    isfirst = false
    emit_argument(io, i, arg, info.kind)
  end

  print(io, ')')

  if !isnothing(inst.type_id)
    printstyled(io, "::"; color = :light_green, bold = true)
    printstyled(io, inst.type_id; color = :light_green, bold = true)
  end
end

function emit_argument(io, i, arg::AbstractVector, kind)
  category = kind_to_category[kind]
  args = copy(arg)
  emit_argument(io, popfirst!(args), kind, category)
  while !isempty(args)
    print(io, ", ")
    emit_argument(io, popfirst!(args), kind, category)
  end
end

function emit_argument(io, i, arg, kind, category = kind_to_category[kind])
  @match category begin
    "ValueEnum" => printstyled(io, replace(string(arg), string(nameof(kind)) => ""); color = 208)
    "BitEnum" => printstyled(io, replace(string(arg), string(nameof(kind)) => ""); color = :light_magenta)
    "Literal" => @match arg begin
      ::AbstractString => printstyled(io, '"', arg, '"'; color = 150)
      ::OpCodeGLSL => printstyled(io, replace(string(arg), "OpGLSL" => ""); color = 153)
      ::Unsigned => printstyled(io, hex(arg); color = 153)
      _ => printstyled(io, arg; color = 153)
    end
    "Id" => printstyled(io, arg; color = :yellow)
    "Composite" => begin
      kinds = map(split(replace(string(kind), r"^Pair" => ""), "IdRef")[1:(end - 1)]) do part
        str = isempty(part) ? "IdRef" : part
        getproperty(@__MODULE__, Symbol(str))
      end
      @assert length(kinds) == 2
      i % 2 == 0 && print(io, " => ")
      i ≠ 1 && i % 2 == 1 && print(io, ", ")
      emit_argument(io, i, arg, kinds[1 + i % 2])
    end
  end
end

Base.show(io::IO, ::MIME"text/plain", inst::Instruction) = emit(io, inst)

"""
    disassemble(io, spir_module)

Transform the content of `spir_module` into a human-readable format and prints it to `io`.
"""
function disassemble(io::IO, mod::Module)
  println_metadata(io, mod.meta)
  println(io, "Bound: ", mod.bound)

  println(io)

  print_instructions(io, mod.instructions, mod.bound)
end

function println_metadata(io::IO, meta::ModuleMetadata)
  @assert meta.magic_number == magic_number
  println(io, "SPIR-V")
  println(io, "Version: ", join([meta.version.major, meta.version.minor], "."))
  println(io, "Generator: ", hex(meta.generator_magic_number))
  println(io, "Schema: ", meta.schema)
end

function print_instructions(io::IO, insts::AbstractVector{Instruction}, bound = compute_bound(insts))
  padding(id) = length(string(bound)) - (isnothing(id) ? -4 : length(string(id)) - 1)
  for inst ∈ insts
    print(io, ' '^padding(inst.result_id))
    emit(io, inst)
    println(io)
  end
end

hex(x) = "0x" * lpad(string(x, base = 16), sizeof(x) * 2, '0')

disassemble(obj) = disassemble(stdout, obj)
disassemble(io::IO, mod::PhysicalModule) = disassemble(io, Module(mod))

Base.show(io::IO, ::MIME"text/plain", mod::Module) = disassemble(io, mod)
