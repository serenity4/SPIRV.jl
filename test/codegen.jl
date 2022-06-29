using SPIRV, Test
using SPIRV: generate_ir

read_module(file) = read(joinpath(@__DIR__, "modules", file), String)
load_module_expr(file) = Meta.parse(string("quote; ", read_module(file), "; end")).args[1]
load_ir(file) = eval(macroexpand(Main, :(@spv_ir $(load_module_expr(file)))))
load_module(file) = eval(macroexpand(Main, :(@spv_module $(load_module_expr(file)))))

@testset "Code generation" begin
  @testset "Error handling" begin
    @test_throws "function definition of the form" generate_ir(quote
      @function 2
    end)

    @test_throws "Invalid redefinition of binding 'b'" generate_ir(quote
      b = BoolType()
      b = ConstantFalse()::b
    end)

    @test_throws "Invalid redefinition of local binding 'b'" generate_ir(quote
      Nothing = TypeVoid()
      @function f()::Nothing begin
        b = Label()
        b = Label()
        Return()
      end
    end)

     @test_throws "typed argument declaration" generate_ir(quote
      Nothing = TypeVoid()
      @function f(x)::Nothing begin
        b = Label()
        Return()
      end
    end)

    @test_throws "Invalid redefinition of function 'f'" generate_ir(quote
      Nothing = TypeVoid()
      @function f()::Nothing begin
        b = Label()
        Return()
      end
      @function f()::Nothing begin
        b = Label()
        Return()
      end
    end)
  end

  @testset "Example programs" begin
    ir = @spv_ir begin
      Nothing = TypeVoid()
      @function f()::Nothing begin
        b = Label()
        Return()
      end
    end
    @test unwrap(validate(ir))

    ir = load_ir("single_block.jl")
    @test unwrap(validate(ir))

    ir = load_ir("simple_conditional.jl")
    @test unwrap(validate(ir))

    ir = load_ir("simple_loop.jl")
    @test unwrap(validate(ir))
  end
end;
