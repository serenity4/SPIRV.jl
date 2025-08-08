module SPIRVCthulhuExt

using SPIRV
using SPIRV: sprintc_mime
using SPIRV.CC: InferenceResult
using Core.IR
using Cthulhu: Cthulhu, CthulhuState, CthulhuInterpreter, default_menu_commands, set_view, view_function, AbstractProvider, LookupResult, OptimizedSource, InferredSource, run_type_inference

struct SPIRVProvider <: AbstractProvider
  interp::SPIRVInterpreter
  cthulhu::CthulhuInterpreter
  features::FeatureSupport
end

function SPIRVProvider(interp::SPIRVInterpreter; features = AllSupported())
  SPIRVProvider(interp, CthulhuInterpreter(interp), features)
end

Cthulhu.get_abstract_interpreter(provider::SPIRVProvider) = provider.interp
Cthulhu.AbstractProvider(interp::SPIRVInterpreter) = SPIRVProvider(interp)

function Cthulhu.menu_commands(provider::SPIRVProvider)
  commands = default_menu_commands()
  filter!(x -> !in(x.name, (:llvm, :native)), commands)
  push!(commands, set_view('p', :spirv, :show, "SPIR-V"))
  return commands
end

function Cthulhu.view_function(provider::SPIRVProvider, view::Symbol)
  view === :spirv && return cthulhu_spirv
  return @invoke view_function(provider::AbstractProvider, view::Symbol)
end

function cthulhu_spirv(io::IO, provider::SPIRVProvider, state::CthulhuState, result::LookupResult)
  target = SPIRVTarget(state.mi, provider.interp)
  ir = compile(target, provider.features)
  output = sprintc_mime(show, ir)
  println(io, output)
end

# Let Cthulhu manage storage of all sources.
# This only works so long as we don't override compiler entry points for `SPIRVInterpreter`.

Cthulhu.run_type_inference(provider::SPIRVProvider, interp::SPIRVInterpreter, mi::MethodInstance) =
  run_type_inference(provider, provider.cthulhu, mi)
Cthulhu.OptimizedSource(provider::SPIRVProvider, interp::SPIRVInterpreter, ci::CodeInstance) =
  OptimizedSource(provider, provider.cthulhu, ci)
Cthulhu.OptimizedSource(provider::SPIRVProvider, interp::SPIRVInterpreter, result::InferenceResult) =
  OptimizedSource(provider, provider.cthulhu, result)
Cthulhu.InferredSource(provider::SPIRVProvider, interp::SPIRVInterpreter, ci::CodeInstance) =
  InferredSource(provider, provider.cthulhu, ci)

end # module
