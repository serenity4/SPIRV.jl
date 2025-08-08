module SPIRVCthulhuExt

using Accessors
using Core.IR
using Cthulhu: Cthulhu, CthulhuState, CthulhuInterpreter, default_menu_commands, set_view, view_function, AbstractProvider, LookupResult, OptimizedSource, InferredSource, run_type_inference, Command
using SPIRV
using SPIRV: sprintc_mime, CompilationConfig
using SPIRV.CC: InferenceResult

mutable struct SPIRVProvider <: AbstractProvider
  interp::SPIRVInterpreter
  cthulhu::CthulhuInterpreter
  config::CompilationConfig
  features::FeatureSupport
end

function SPIRVProvider(interp::SPIRVInterpreter; features = AllSupported(), config = CompilationConfig())
  SPIRVProvider(interp, CthulhuInterpreter(interp), config, features)
end

Cthulhu.get_abstract_interpreter(provider::SPIRVProvider) = provider.interp
Cthulhu.AbstractProvider(interp::SPIRVInterpreter) = SPIRVProvider(interp)

function Cthulhu.menu_commands(provider::SPIRVProvider)
  commands = default_menu_commands()
  filter!(x -> !in(x.name, (:llvm, :native)), commands)
  append!(commands, [
    set_view('p', :spirv, :show, "SPIR-V"),
    toggle_pass('1', :compact_blocks),
    toggle_pass('2', :fill_phi_branches),
    toggle_pass('3', :remap_dynamic_1based_indices),
    toggle_pass('4', :egal_to_recursive_equal),
    toggle_pass('5', :propagate_constants),
    toggle_pass('6', :composite_extract_to_vector_extract_dynamic),
    toggle_pass('7', :composite_extract_dynamic_to_literal),
    toggle_pass('8', :composite_extract_to_access_chain_load),
    toggle_pass('9', :remove_op_nops),
  ])
  return commands
end

function toggle_pass(key::Char, name::Symbol, description::String = string(name))
  callback = state -> toggle_pass!(state, name)
  Command(true, key, name, description, :passes, callback, callback)
end

function toggle_pass!(state::CthulhuState, pass::Symbol)
  (; provider) = state
  (; config) = provider
  value = !getproperty(config, pass)::Bool
  provider.config = setproperties(config, NamedTuple((pass => value,)))
  state.display_code = true
end

function Cthulhu.view_function(provider::SPIRVProvider, view::Symbol)
  view === :spirv && return cthulhu_spirv
  return @invoke view_function(provider::AbstractProvider, view::Symbol)
end

function cthulhu_spirv(io::IO, provider::SPIRVProvider, state::CthulhuState, result::LookupResult)
  target = SPIRVTarget(state.mi, provider.interp)
  ir = compile(target, provider.features; provider.config)
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
