using SPIRV, Test
using SPIRV: generate_ir

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

    ir = load_ir("function_call")
    @test unwrap(validate(ir))
    ir = load_ir("single_block")
    @test unwrap(validate(ir))
    ir = load_ir("simple_conditional")
    @test unwrap(validate(ir))
    ir = load_ir("nested_conditional")
    @test unwrap(validate(ir))
    ir = load_ir("simple_loop")
    @test unwrap(validate(ir))
    ir = load_ir("simple_conditional_2")
    @test unwrap(validate(ir))
    ir = load_ir("simple_loop_2")
    @test unwrap(validate(ir))
    for ir in [load_ir("int64_literals"), load_ir_reparsed("int64_literals")]
      @test unwrap(validate(ir))
      @test only(ir.constants) === SPIRV.Constant(1)
    end
    for ir in [load_ir("float64_literals"), load_ir_reparsed("float64_literals")]
      @test unwrap(validate(ir))
      @test only(ir.constants) === SPIRV.Constant(4.65)
    end
    ir = load_ir_reparsed("optional_argument.jl")
    @test unwrap(validate(ir))
    ir = load_ir("dynamic_array_access.jl")
    @test unwrap(validate(ir))

    ir = load_ir("phi_variables")
    # TODO: We should not have to do this by hand.
    push!(ir.capabilities, SPIRV.CapabilityVariablePointers)
    @test unwrap(validate(ir))
  end
end;
