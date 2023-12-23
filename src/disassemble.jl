const ENUM_COLOR = 208
const BITMASK_COLOR = :light_magenta

function emit(io::IO, inst::Instruction)
  if !isnothing(inst.result_id)
    printstyled(io, inst.result_id; color = :yellow)
    print(io, " = ")
  end

  printstyled(io, replace(string(inst.opcode), r"^Op" => ""); color = :light_cyan)

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

function emit_argument(io, i, arg, kind, category = kind_to_category[kind])
  @match category begin
    "ValueEnum" => printstyled(io, replace(string(arg), string(nameof(kind)) => ""); color = ENUM_COLOR)
    "BitEnum" => printstyled(io, replace(string(arg), string(nameof(kind)) => "", '(' => "", ')' => ""); color = BITMASK_COLOR)
    "Literal" => @match arg begin
      ::AbstractString => printstyled(io, '"', arg, '"'; color = 150)
      ::OpCodeGLSL => printstyled(io, replace(string(arg), "OpGLSL" => ""); color = 153)
      ::Unsigned => printstyled(io, repr(arg); color = 153)
      _ => printstyled(io, arg; color = 153)
    end
    "Id" => printstyled(io, arg; color = :yellow)
    "Composite" => begin
      kinds = map(eachmatch(r"(IdRef|LiteralInteger)", string(kind))) do part
        getproperty(@__MODULE__, Symbol(part.match))
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
An `IO` object which always indents by `indent_level` after a newline character has been printed.
"""
struct IndentedIO{T<:IO} <: IO
  io::T
  indent_level::Int
end

@forward_methods IndentedIO field = :io Base.unsafe_read Base.eof Base.get(_, args...)

indent(io::IO, level) = IndentedIO(io, level)
indent(io::IndentedIO, level) = indent(io.io, level + io.indent_level)

function Base.write(io::IndentedIO, b::UInt8)
  res = write(io.io, b)
  if b === UInt8('\n')
    for _ in 1:io.indent_level
      res += write(io.io, ' ')
    end
  end
  res
end

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

function disassemble(io::IO, amod::AnnotatedModule)
  println_metadata(io, amod.mod.meta)
  println(io, "Bound: ", amod.mod.bound)

  print_instructions(io, amod.mod.instructions, amod.mod.bound)
end

function println_metadata(io::IO, meta::ModuleMetadata)
  @assert meta.magic_number == MAGIC_NUMBER
  println(io, "SPIR-V")
  println(io, "Version: ", join([meta.version.major, meta.version.minor], "."))
  println(io, "Generator: ", repr(meta.generator_magic_number))
  println(io, "Schema: ", meta.schema)
end

padding(id, bound) = length(string(bound)) - (isnothing(id) ? -4 : length(string(id)) - 1)

function print_instructions(io::IO, insts::AbstractVector{Instruction}, bound = UInt32(compute_id_bound(insts)))
  for inst in insts
    print_instruction(io, inst, bound)
  end
end

function print_instruction(io::IO, inst::Instruction, bound)
  io = indent(io, padding(inst.result_id, bound))
  println(io)
  emit(io, inst)
end

disassemble(obj) = disassemble(stdout, obj)
disassemble(io::IO, mod::PhysicalModule) = disassemble(io, Module(mod))

sprintc(f, args...; context = :color => true, kwargs...) = sprint((args...) -> f(args...; kwargs...), args...; context)
sprint_mime(f, args...; kwargs...) = sprint(f, MIME"text/plain"(), args...; kwargs...)
sprintc_mime(f, args...; kwargs...) = sprintc(f, MIME"text/plain"(), args...; kwargs...)

# Print the module as a single string to avoid the slowdown caused by a possible IO congestion.
Base.show(io::IO, mime::MIME"text/plain", mod::Union{AnnotatedModule,Module}) = print(io, sprint(disassemble, mod; context = IOContext(io)))
