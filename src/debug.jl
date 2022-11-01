struct Source
  language::SourceLanguage
  version::VersionNumber
  file::Optional{String}
  code::Optional{String}
  extensions::Vector{String}
end

struct LineInfo
  file::String
  line::Int
  column::Int
end

mutable struct DebugInfo
  filenames::SSADict{String}
  names::SSADict{Symbol}
  lines::SSADict{LineInfo}
  source::Optional{Source}
end

DebugInfo() = DebugInfo(SSADict(), SSADict(), SSADict(), nothing)

function append_debug_instructions!(insts, debug::DebugInfo)
  if !isnothing(debug.source)
    (; source) = debug
    args = Any[source.language, source_version(source.language, source.version)]
    !isnothing(source.file) && push!(args, source.file)
    !isnothing(source.code) && push!(args, source.code)
    push!(insts, @inst OpSource(args...))
    append!(insts, @inst(OpSourceExtension(ext)) for ext in source.extensions)
  end

  for (id, filename) in pairs(debug.filenames)
    push!(insts, @inst OpString(id, filename))
  end
end
