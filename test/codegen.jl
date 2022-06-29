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

    ir = @spv_ir begin
      Int32 = TypeInt(32, 1)
      Float32 = TypeFloat(32)
      c_1f0 = Constant(1f0)::Float32
      @function f(x::Int32, y::Int32)::Float32 begin
        b = Label()
        x_plus_y = IAdd(x, y)::Int32
        x_plus_y_float = ConvertSToF(x_plus_y)::Float32
        z = FAdd(x_plus_y_float, c_1f0)::Float32
        ReturnValue(z)
      end
    end
    @test unwrap(validate(ir))

    ir = @spv_ir begin
      Bool = TypeBool()
      Int32 = TypeInt(32, 1)
      Float32 = TypeFloat(32)
      c_1f0 = Constant(1f0)::Float32
      c_1 = Constant(Int32(1))::Int32
      @function f(x::Int32, y::Int32)::Float32 begin
        b1 = Label()
        x_plus_y = IAdd(x, y)::Int32
        to_b3 = SLessThan(x_plus_y, c_1)::Bool
        BranchConditional(to_b3, b3, b2)
        b2 = Label()
        x_plus_y_float = ConvertSToF(x_plus_y)::Float32
        z = FAdd(x_plus_y_float, c_1f0)::Float32
        ReturnValue(z)
        b3 = Label()
        ReturnValue(c_1f0)
      end
    end
    @test unwrap(validate(ir))

    ir = @spv_ir begin
      Bool = TypeBool()
      Int32 = TypeInt(32, 1)
      Float32 = TypeFloat(32)
      PtrInt32 = TypePointer(SPIRV.StorageClassFunction, Int32)
      c_1f0 = Constant(1f0)::Float32
      c_1 = Constant(Int32(1))::Int32
      c_5f0 = Constant(5f0)::Float32

      @function f(x::Int32, y::Int32)::Float32 begin
        b1 = Label()
        x_plus_y = IAdd(x, y)::Int32
        to_b3 = SLessThan(x_plus_y, c_1)::Bool
        BranchConditional(to_b3, b3, b2)

        b2 = Label()
        ReturnValue(c_1f0)

        b3 = Label()
        x_plus_y_float = ConvertSToF(x_plus_y)::Float32
        z = FAdd(x_plus_y_float, c_1f0)::Float32
        z2 = FSub(z, c_5f0)::Float32
        z_int = ConvertFToS(z2)::Int32
        v = Variable(SPIRV.StorageClassFunction)::PtrInt32
        Store(v, z_int)
        Branch(loop_header_block)

        loop_header_block = Label()
        _v = Load(v)::Int32
        cond = SLessThan(_v, c_1)::Bool
        LoopMerge(loop_merge_block, loop_continue_target, SPIRV.LoopControlNone)
        BranchConditional(cond, loop_body, loop_merge_block)

        loop_body = Label()
        Branch(loop_continue_target)

        loop_continue_target = Label()
        _v2 = Load(v)::Int32
        next_v = IAdd(_v2, c_1)::Int32
        Store(v, next_v)
        Branch(loop_header_block)

        loop_merge_block = Label()
        _v3 = OpLoad(v)::Int32
        v_float = ConvertSToF(_v3)::Float32
        ReturnValue(v_float)
      end
    end
    @test unwrap(validate(ir))
  end
end;
