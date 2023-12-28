const core_grammar_file = joinpath(include_dir, "spirv.core.grammar.json")
const glsl_grammar_file = joinpath(include_dir, "extinst.glsl.std.450.grammar.json")

cp(core_grammar_file, joinpath(@__DIR__, basename(core_grammar_file)); force = true)
cp(glsl_grammar_file, joinpath(@__DIR__, basename(glsl_grammar_file)); force = true)

const g = JSON3.read(read(joinpath(include_dir, core_grammar_file), String))
const extinst_glsl = JSON3.read(read(joinpath(include_dir, glsl_grammar_file), String))

const magic_number = parse(UInt32, g[:magic_number])
const grammar_version = VersionNumber(getindex.(Ref(g), [:major_version, :minor_version, :revision])...)
const enums = filter(!in(["Id", "Literal", "Composite"]) ∘ Base.Fix2(getindex, :category), g[:operand_kinds])

generate_enums() = [map(generate_enum, enums); map(generate_category_as_enum, ["Id", "Literal", "Composite"])]

function generate_enum(enum)
  kind = Symbol(enum[:kind])
  values = map(enum[:enumerants]) do enumerant
    value = enumerant[:value]
    name = Symbol(kind, enumerant[:enumerant])
    isa(value, String) && (value = parse(UInt32, value))
    :($name = $value)
  end
  if enum[:category] == "BitEnum"
    :(@bitmask $kind::UInt32 begin
      $(values...)
    end)
  else
    :(@cenum $kind::UInt32 begin
      $(values...)
    end)
  end
end

"""
Generate enumeration values representing SPIR-V operand kind categories.
These enumerations are not defined by the specification.
"""
function generate_category_as_enum(category)
  values = map(enumerate(filter(x -> x["category"] == category, g[:operand_kinds]))) do (i, opkind)
    kind = Symbol(opkind[:kind])
    :($kind = $i)
  end
  name = Symbol(category)
  :(@enum $name::Int begin
    $(values...)
  end)
end

function generate_instruction_printing_class()
  pairs = map(g[:instruction_printing_class]) do print_info
    class = print_info["tag"]
    str = class ≠ "@exclude" ? print_info["heading"] : ""
    :($class => $str)
  end

  :(const class_printing = Dict{String,String}([$(pairs...)]))
end

glsl_opname(inst) = Symbol(:OpGLSL, inst[:opname])
opname(inst) = Symbol(inst[:opname])

function generate_instructions()
  values = (:($(opname(inst)) = $(inst[:opcode])) for inst in g[:instructions])
  :(@cenum OpCode::UInt32 begin
    $(values...)

    # Custom `OpCode`s for internal use.
    OpEgal = 200001
  end)
end

function generate_instructions_glsl()
  values = (:($(glsl_opname(inst)) = $(inst[:opcode])) for inst in extinst_glsl[:instructions])
  :(@cenum OpCodeGLSL::UInt32 begin
    $(values...)
  end)
end

function generate_instruction_infos()
  infos = map(instruction_info, g[:instructions])
  push!(infos, :(OpEgal => InstructionInfo(
    "Package-defined",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  )))
  :(const instruction_infos = Dict{OpCode,InstructionInfo}($(infos...)))
end

function generate_instruction_infos_glsl()
  infos = map(Base.Fix2(instruction_info, glsl_opname), extinst_glsl[:instructions])
  :(const instruction_infos_glsl = Dict{OpCodeGLSL,InstructionInfo}([$(infos...)]))
end

function instruction_info(inst, opname = opname)
  class = get(inst, :class, nothing)
  operands = operand_infos(inst)
  exts, caps = get(inst, :extensions, []), capabilities(inst)
  exts_ex, caps_ex = nothing_if_empty.((exts, caps))
  lower, upper = min_version(inst), typemax(VersionNumber)
  support = :(RequiredSupport(VersionRange($lower, $upper), $exts_ex, $caps_ex))
  :($(opname(inst)) => InstructionInfo($class, [$(operands...)], $support))
end

capabilities(dict) = map(Base.Fix1(Symbol, :Capability), get(dict, :capabilities, []))
function min_version(dict)
  version_spec = get(dict, :version, "0")
  parse(VersionNumber, version_spec == "None" ? "0" : version_spec)
end

operand_infos(inst) = map(operand_info, get(inst, :operands, []))

function operand_info(operand)
  kind = Symbol(operand[:kind])
  name = get(operand, :name, nothing)
  quantifier = get(operand, :quantifier, nothing)
  :(OperandInfo($kind, $name, $quantifier))
end

function generate_enum_infos()
  infos = map(enums) do enum
    type = Symbol(enum[:kind])
    enumerants = generate_enumerant_info(type, enum[:enumerants])
    :($type => EnumInfo($type, Dict($(enumerants...))))
  end
  :(const enum_infos = EnumInfos(Dict($(infos...))))
end

function generate_enumerant_info(type, enumerants)
  infos = Dict{UInt32,Any}()
  for enumerant in enumerants
    value = enumerant[:value]
    isa(value, String) && (value = parse(UInt32, value))
    info = get!(Dict{Symbol,Any}, infos, value)
    info[:value] = value
    info[:name] = Symbol(type, enumerant[:enumerant])
    version = min_version(enumerant)
    support = get!(Dict{VersionNumber,Any}, info, :support)
    parameters = map(operand_info, get(Vector{Any}, enumerant, :parameters))
    @assert get!(info, :parameters, parameters) == parameters
    exts = collect(get(Vector{Any}, enumerant, :extensions))
    caps = capabilities(enumerant)
    requirements = get(support, version, nothing)
    if isnothing(requirements)
      support[version] = Dict(:extensions => exts, :capabilities => caps)
    else
      isempty(requirements[:extensions]) || isempty(exts) ? empty!(requirements[:extensions]) : union!(requirements[:extensions], exts)
      isempty(requirements[:capabilities]) || isempty(caps) ? empty!(requirements[:capabilities]) : union!(requirements[:capabilities], caps)
    end
  end
  for info in values(infos)
    support = get!(Dict{VersionNumber,Any}, info, :support)
    info[:ranges] = compute_support_requirements(support)
  end
  map(sort!(collect(values(infos)); by = x -> x[:value])) do x
    :($(x[:name]) * U => EnumerantInfo($(x[:ranges]), [$(x[:parameters]...)]))
  end
end

function compute_support_requirements(support)
  versions = collect(keys(support))
  sort!(versions)
  ranges = []
  for lower in versions
    upper = typemax(VersionNumber)
    requirements = support[lower]
    exts, caps = requirements[:extensions], requirements[:capabilities]
    exts_ex, caps_ex = nothing_if_empty.((exts, caps))
    push!(ranges, :(RequiredSupport(VersionRange($lower, $upper), $exts_ex, $caps_ex)))
  end
  length(ranges) == 1 ? ranges[1] : :([$(ranges...)])
end

nothing_if_empty(xs) = isempty(xs) ? nothing : :([$(xs...)])

function generate_kind_to_category()
  pairs = map(g[:operand_kinds]) do opkind
    kind = Symbol(opkind["kind"])
    category = opkind[:category]
    :($kind => $category)
  end
  :(const kind_to_category = Dict($(pairs...)))
end

function pretty_dump(io, expr::Expr)
  custom_print(io, expr)
  println(io)
end

pretty_dump(io, exprs) = foreach(x -> pretty_dump(io, x), exprs)

src_dir(x...) = joinpath(dirname(@__DIR__), "src", x...)

function generate()
  @info "Generating files:"
  @info "  - instructions.jl"

  open(src_dir("generated", "instructions.jl"), "w+") do io
    pretty_dump(io, generate_instructions())
    pretty_dump(io, generate_instruction_infos())
    pretty_dump(io, generate_instruction_printing_class())
    pretty_dump(io, generate_kind_to_category())
  end

  @info "  - enums.jl"

  open(src_dir("generated", "enums.jl"), "w+") do io
    pretty_dump(io, generate_enums())
  end

  @info "  - enum_infos.jl"

  open(src_dir("generated", "enum_infos.jl"), "w+") do io
    pretty_dump(io, generate_enum_infos())
  end

  @info "  - extinsts.jl"

  open(src_dir("generated", "extinsts.jl"), "w+") do io
    pretty_dump(io, generate_instructions_glsl())
    pretty_dump(io, generate_instruction_infos_glsl())
  end
  true
end
