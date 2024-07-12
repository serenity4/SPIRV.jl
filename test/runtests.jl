using SPIRV, Test
using SPIRV: @compute, @vertex, @fragment, @compute, @any_hit, @mesh, Sampler, Image, Pointer
using SPIRV.MathFunctions
using StaticArrays

include("vulkan_driver.jl")

resource(filename) = joinpath(@__DIR__, "resources", filename)
read_module(file) = read(joinpath(@__DIR__, "modules", file * (last(splitext(file)) == ".jl" ? "" : ".jl")), String)
load_module_expr(file) = Meta.parse(string("quote; ", read_module(file), "; end")).args[1]
load_ir(ex::Expr) = eval(macroexpand(Main, :(@spv_ir $ex)))
load_ir(file) = load_ir(load_module_expr(file))
load_ir_reparsed(file) = IR(assemble(load_ir(file)))
load_module(ex::Expr) = eval(macroexpand(Main, :(@spv_module $ex)))
load_module(file) = load_module(load_module_expr(file))

@testset "SPIRV.jl" begin
  include("deltagraph.jl");
  include("utilities.jl");
  include("formats.jl")
  include("modules.jl");
  include("spir_types.jl");
  include("metadata.jl");
  include("features.jl");
  include("ir.jl");
  include("spvasm.jl");
  include("layouts.jl");
  include("frontend/types.jl");
  include("serialization.jl");
  include("passes.jl");
  include("codegen.jl");
  include("analysis.jl");
  include("restructuring.jl");
  include("frontend.jl");

  # Run with a supported GPU driver, e.g. not SwiftShader.
  include("execution.jl")
end;
