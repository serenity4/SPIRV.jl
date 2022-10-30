using SPIRV, Test

resource(filename) = joinpath(@__DIR__, "resources", filename)
read_module(file) = read(joinpath(@__DIR__, "modules", file * (last(splitext(file)) == ".jl" ? "" : ".jl")), String)
load_module_expr(file) = Meta.parse(string("quote; ", read_module(file), "; end")).args[1]
load_ir(file) = eval(macroexpand(Main, :(@spv_ir $(load_module_expr(file)))))
load_module(file) = eval(macroexpand(Main, :(@spv_module $(load_module_expr(file)))))

@testset "SPIRV.jl" begin
  include("deltagraph.jl");
  include("utilities.jl");
  include("modules.jl");
  include("spir_types.jl");
  include("metadata.jl");
  include("features.jl");
  include("ir.jl");
  include("spvasm.jl");
  include("layouts.jl");
  if VERSION ≥ v"1.8"
    include("passes.jl");
    include("codegen.jl");
    include("analysis.jl");
    include("restructuring.jl");
    include("frontend.jl");
  end;
end;
