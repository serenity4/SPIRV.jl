struct VersionRange
  "Inclusive lower bound."
  lower::VersionNumber
  "Exclusive upper bound."
  upper::VersionNumber
end

Base.in(version::VersionNumber, range::VersionRange) = range.lower ≤ version < range.upper || version == typemax(VersionNumber) == range.upper
Base.show(io::IO, range::VersionRange) = print(io, '[', range.lower, " — ", range.upper, ')')

struct RequiredSupport
  version::VersionRange
  extensions::Optional{Vector{String}}
  capabilities::Optional{Vector{Capability}}
end

Base.iterate(required::RequiredSupport) = (required, nothing)
Base.iterate(required::RequiredSupport, ::Nothing) = nothing

struct OperandInfo
  kind::Any
  name::Optional{String}
  quantifier::Optional{String}
end

struct InstructionInfo
  class::Optional{String}
  operands::Vector{OperandInfo}
  required::Union{RequiredSupport, Vector{RequiredSupport}}
end

struct EnumerantInfo
  required::Union{RequiredSupport, Vector{RequiredSupport}}
  parameters::Vector{OperandInfo}
end

struct EnumInfo
  type::DataType
  enumerants::Dict{UInt32,EnumerantInfo}
end

struct EnumInfos
  dict::Dict{DataType,EnumInfo}
end

Base.get(info::EnumInfo, @nospecialize(enumerant), default) = get(info.enumerants, UInt32(enumerant::info.type), default)

@nospecialize
type(T::DataType) = T
type(x) = typeof(x)
@specialize
function Base.get(infos::EnumInfos, @nospecialize(enumerant), default)
  info = get(infos.dict, type(enumerant), nothing)
  isa(enumerant, DataType) && return info
  isnothing(info) && return default
  get(info, enumerant, default)
end

function Base.getindex(infos::EnumInfos, index)
  ret = get(infos, index, nothing)
  isnothing(ret) && throw(KeyError(index))
  ret
end

function format_parameter(op::OperandInfo)
  op.quantifier === '?' && return string('[', format_parameter(@set op.quantifier = nothing), ']')
  sprintc() do io
    printstyled(io, '<', strip(something(op.name, ""), '''), '>'; color = :cyan)
    printstyled(io, "::", op.kind, op.quantifier === '*' ? "..." : ""; color = :light_black)
  end
end
