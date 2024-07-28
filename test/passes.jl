using SPIRV, Test, Accessors
using SPIRV: renumber_ssa, compute_id_bound, id_bound, fill_phi_branches!, remap_dynamic_1based_indices!, composite_extract_dynamic_to_literal!, composite_extract_to_access_chain_load!, propagate_constants!, remove_op_nops!, remove_obsolete_annotations!, egal_to_recursive_equal!, add_merge_headers!, compact_blocks!

@testset "Passes" begin
  @testset "SSA renumbering" begin
    mod = SPIRV.Module(PhysicalModule(resource("vert.spv")))
    composite_extract = mod[end - 8]
    mod[end - 8] = @set composite_extract.result_id = ResultID(57)
    mod[end - 6].arguments[1] = ResultID(57)
    renumbered = renumber_ssa(mod)
    @test renumbered ≠ mod
    @test unwrap(validate(renumbered))
    @test length(mod) == length(renumbered)
    @test renumbered[end - 8].result_id ≠ ResultID(57)
    @test id_bound(renumbered) == compute_id_bound(renumbered.instructions) == id_bound(mod)

    mod = SPIRV.Module(PhysicalModule(resource("comp.spv")))
    renumbered = renumber_ssa(mod)
    @test unwrap(validate(renumbered))
  end

  @testset "Compacting blocks" begin
    ir = @spv_ir begin
      Nothing = TypeVoid()
      @function f()::Nothing begin
        blk1 = Label()
        Branch(blk2)
        blk2 = Label()
        Branch(blk3)
        blk3 = Label()
        Return()
      end
    end
    @test unwrap(validate(ir))
    compact_blocks!(ir)
    expected = @spv_ir begin
      Nothing = TypeVoid()
      @function f()::Nothing begin
        blk3 = Label()
        Return()
      end
    end
    @test unwrap(validate(expected))
    @test ir ≈ expected renumber = true

    ir = @spv_ir begin
      Nothing = TypeVoid()
      B = TypeBool()
      c_true = ConstantTrue()::B
      @function f()::Nothing begin
        blk1 = Label()
        trivia = LogicalAnd(c_true, c_true)::B
        BranchConditional(c_true, blk2, blk3)
        blk2 = Label()
        Branch(blk3)
        blk3 = Label()
        Return()
      end
    end
    @test unwrap(validate(ir))
    compact_blocks!(ir)
    expected = @spv_ir begin
      Nothing = TypeVoid()
      B = TypeBool()
      c_true = ConstantTrue()::B
      @function f()::Nothing begin
        blk1 = Label()
        trivia = LogicalAnd(c_true, c_true)::B
        Branch(blk3)
        blk3 = Label()
        Return()
      end
    end
    @test unwrap(validate(expected))
    @test ir ≈ expected renumber = true

    ir = @spv_ir begin
      Nothing = TypeVoid()
      B = TypeBool()
      c_true = ConstantTrue()::B
      @function f()::Nothing begin
        blk1 = Label()
        BranchConditional(c_true, blk2, blk3)
        blk2 = Label()
        Branch(blk3)
        blk3 = Label()
        Return()
      end
    end
    @test unwrap(validate(ir))
    compact_blocks!(ir)
    expected = @spv_ir begin
      Nothing = TypeVoid()
      B = TypeBool()
      c_true = ConstantTrue()::B
      @function f()::Nothing begin
        blk3 = Label()
        Return()
      end
    end
    @test unwrap(validate(expected))
    @test ir ≈ expected renumber = true
  end

  @testset "Filling in missing Phi branches" begin
    ir = @spv_ir begin
      Bool = TypeBool()
      no = ConstantFalse()::Bool
      @function f()::Bool begin
        b1 = Label()
        BranchConditional(no, b2, b3)
        b2 = Label()
        Branch(b4)
        b3 = Label()
        Branch(b4)
        b4 = Label()
        phi = Phi(no, b2)::Bool
        phi2 = Phi(no, b3)::Bool
        ReturnValue(phi2)
      end
    end
    ret = validate(ir)
    @test iserror(ret) && contains(unwrap_error(ret).msg, "number of incoming blocks")
    fill_phi_branches!(ir)
    @test unwrap(validate(ir))
  end

  @testset "Replace 1-based array accesses with 0-based indices" begin
    @testset "Constant index (CompositeExtract)" begin
      ir = @spv_ir begin
        Float32 = TypeFloat(32)
        UInt32 = TypeInt(32, false)
        Vec2 = TypeVector(Float32, 2)
        f1 = Constant(1f0)::Float32
        f2 = Constant(2f0)::Float32
        u1 = Constant(1U)::UInt32
        @function f()::Float32 begin
          _ = Label()
          x = CompositeConstruct(f1, f2)::Vec2
          ret = VectorExtractDynamic(x, u1)::Float32
          ReturnValue(ret)
        end
      end
      @test unwrap(validate(ir))
      remap_dynamic_1based_indices!(ir)
      expected = @spv_ir begin
        Float32 = TypeFloat(32)
        UInt32 = TypeInt(32, false)
        Vec2 = TypeVector(Float32, 2)
        f1 = Constant(1f0)::Float32
        f2 = Constant(2f0)::Float32
        u1 = Constant(1U)::UInt32
        @function f()::Float32 begin
          _ = Label()
          x = CompositeConstruct(f1, f2)::Vec2
          i = ISub(u1, u1)::UInt32
          ret = VectorExtractDynamic(x, i)::Float32
          ReturnValue(ret)
        end
      end
      @test unwrap(validate(expected))
      @test ir ≈ expected renumber = true
    end

    @testset "Dynamic index (AccessChain + Load)" begin
      ir = @spv_ir begin
        Float32 = TypeFloat(32)
        UInt32 = TypeInt(32, false)
        Vec2 = TypeVector(Float32, 2)
        PtrVec2 = TypePointer(SPIRV.StorageClassFunction, Vec2)
        PtrFloat32 = TypePointer(SPIRV.StorageClassFunction, Float32)
        index = Constant(1U)::UInt32
        @function f(x::PtrVec2)::Float32 begin
          _ = Label()
          ptr = AccessChain(x, index)::PtrFloat32
          ret = Load(ptr)::Float32
          ReturnValue(ret)
        end
      end
      @test unwrap(validate(ir))
      remap_dynamic_1based_indices!(ir)
      expected = @spv_ir begin
        Float32 = TypeFloat(32)
        UInt32 = TypeInt(32, false)
        Vec2 = TypeVector(Float32, 2)
        PtrVec2 = TypePointer(SPIRV.StorageClassFunction, Vec2)
        PtrFloat32 = TypePointer(SPIRV.StorageClassFunction, Float32)
        index = Constant(1U)::UInt32
        @function f(x::PtrVec2)::Float32 begin
          _ = Label()
          i = ISub(index, index)::UInt32
          ptr = AccessChain(x, i)::PtrFloat32
          ret = Load(ptr)::Float32
          ReturnValue(ret)
        end
      end
      @test unwrap(validate(expected))
      @test ir ≈ expected renumber = true
    end
  end

  @testset "Dynamic index to literal" begin
    ir = @spv_ir begin
      Float32 = TypeFloat(32)
      UInt32 = TypeInt(32, false)
      Vec2 = TypeVector(Float32, 2)
      index = Constant(0U)::UInt32
      @function f(x::Vec2)::Float32 begin
        _ = Label()
        ret = CompositeExtract(x, index)::Float32
        ReturnValue(ret)
      end
    end
    # The validator will take the index value to be the result ID, and not its constant value.
    @test_throws "out of bounds" unwrap(validate(ir))

    expected = @spv_ir begin
      Float32 = TypeFloat(32)
      UInt32 = TypeInt(32, false)
      Vec2 = TypeVector(Float32, 2)
      index = Constant(0U)::UInt32
      @function f(x::Vec2)::Float32 begin
        _ = Label()
        ret = CompositeExtract(x, 0U)::Float32
        ReturnValue(ret)
      end
    end

    composite_extract_dynamic_to_literal!(ir)
    @test ir == expected
    @test unwrap(validate(ir))
  end

  @testset "Array dynamic indices in `CompositeExtract` conversion to Variable/AccessChain/Load" begin
    count_operations(fdef, opcode) = sum(blk -> count(x -> x.op == opcode, blk), fdef)
    number_of_access_chains(fdef) = count_operations(fdef, SPIRV.OpAccessChain)
    number_of_stores(fdef) = count_operations(fdef, SPIRV.OpStore)

    ir = @spv_ir begin
      F32 = TypeFloat(32)
      U32 = TypeInt(32, false)
      c_U32_2 = Constant(2U)::U32
      ArrayF32_2 = TypeArray(F32, c_U32_2)

      @function f(arr::ArrayF32_2, index::U32)::F32 begin
        _ = Label()
        x = CompositeExtract(arr, index)::F32
        ReturnValue(x)
      end
    end
    # The validator confuses `index` for a literal.
    @test_throws "Array access is out of bounds" unwrap(validate(ir))
    fdef = ir[1]
    @test length(fdef.local_vars) == 0
    @test number_of_access_chains(fdef) == 0

    composite_extract_to_access_chain_load!(ir)
    @test unwrap(validate(ir))

    @test length(fdef.local_vars) == 1
    @test number_of_access_chains(fdef) == 1

    expected = @spv_ir begin
      F32 = TypeFloat(32)
      U32 = TypeInt(32, false)
      c_U32_2 = Constant(2U)::U32
      ArrayF32_2 = TypeArray(F32, c_U32_2)
      # XXX: The const-proped result is inserted after function types,
      # which is impossible to express given the current DSL. That should be addressed some time.
      ft = TypeFunction(F32, ArrayF32_2, U32)
      PtrArrayF32_2 = TypePointer(SPIRV.StorageClassFunction, ArrayF32_2)
      PtrF32 = TypePointer(SPIRV.StorageClassFunction, F32)
      f = Function(SPIRV.FunctionControlNone, ft)
      arr = FunctionParameter()::ArrayF32_2
      index = FunctionParameter()::U32
      _ = Label()
      var = Variable(SPIRV.StorageClassFunction)::PtrArrayF32_2
      Store(var, arr)
      ptr = AccessChain(var, index)::PtrF32
      x = Load(ptr)::F32
      ReturnValue(x)
      FunctionEnd()
    end
    @test unwrap(validate(expected))
    @test ir ≈ expected renumber = true

    ir = @spv_ir begin
      F32 = TypeFloat(32)
      U32 = TypeInt(32, false)
      c_U32_2 = Constant(2U)::U32
      ArrayF32_2 = TypeArray(F32, c_U32_2)
      PtrArrayF32_2 = TypePointer(SPIRV.StorageClassFunction, ArrayF32_2)
      PtrF32 = TypePointer(SPIRV.StorageClassFunction, F32)

      @function f(arr_ptr::PtrArrayF32_2, index::U32)::F32 begin
        _ = Label()
        arr = Load(arr_ptr)::ArrayF32_2
        x = CompositeExtract(arr, index)::F32
        ReturnValue(x)
      end
    end
    @test_throws "Array access is out of bounds" unwrap(validate(ir))
    @test_throws "non-variable" composite_extract_to_access_chain_load!(ir)

    ir = @spv_ir begin
      F32 = TypeFloat(32)
      U32 = TypeInt(32, false)
      c_U32_2 = Constant(2U)::U32
      ArrayF32_2 = TypeArray(F32, c_U32_2)
      PtrArrayF32_2 = TypePointer(SPIRV.StorageClassFunction, ArrayF32_2)
      PtrF32 = TypePointer(SPIRV.StorageClassFunction, F32)

      @function f(arr::ArrayF32_2, index::U32)::F32 begin
        _ = Label()
        var = Variable(SPIRV.StorageClassFunction)::PtrArrayF32_2
        Store(var, arr)
        load = Load(var)::ArrayF32_2
        x = CompositeExtract(load, index)::F32
        ReturnValue(x)
      end
    end
    @test_throws "Array access is out of bounds" unwrap(validate(ir))

    composite_extract_to_access_chain_load!(ir)
    @test unwrap(validate(ir))

    ir = @spv_ir begin
      F32 = TypeFloat(32)
      U32 = TypeInt(32, false)
      c_U32_2 = Constant(2U)::U32
      ArrayF32_2 = TypeArray(F32, c_U32_2)
      PtrArrayF32_2 = TypePointer(SPIRV.StorageClassPushConstant, ArrayF32_2)
      arr_ptr = Variable(SPIRV.StorageClassPushConstant)::PtrArrayF32_2

      @function f(index::U32)::F32 begin
        _ = Label()
        arr = Load(arr_ptr)::ArrayF32_2
        x = CompositeExtract(arr, index)::F32
        ReturnValue(x)
      end
    end
    @test_throws "Array access is out of bounds" unwrap(validate(ir))

    composite_extract_to_access_chain_load!(ir)
    @test unwrap(validate(ir))

    ir = @spv_ir begin
      F32 = TypeFloat(32)
      U32 = TypeInt(32, false)
      c_U32_2 = Constant(2U)::U32
      ArrayF32_2 = TypeArray(F32, c_U32_2)
      PtrArrayF32_2 = TypePointer(SPIRV.StorageClassPushConstant, ArrayF32_2)
      arr_ptr = Variable(SPIRV.StorageClassPushConstant)::PtrArrayF32_2

      @function f(index::U32, arr::ArrayF32_2)::F32 begin
        _ = Label()
        x = CompositeExtract(arr, index)::F32
        ReturnValue(x)
      end
      @function main()::F32 begin
        _ = Label()
        arr = Load(arr_ptr)::ArrayF32_2
        ret = FunctionCall(f, c_U32_2, arr)::F32
        ReturnValue(ret)
      end
    end
    @test_throws "Array access is out of bounds" unwrap(validate(ir))
    fdef = ir[1]
    @test number_of_access_chains(fdef) == 0
    @test number_of_stores(fdef) == 0
    @test length(fdef.local_vars) == 0

    composite_extract_to_access_chain_load!(ir)
    @test unwrap(validate(ir))

    @test number_of_access_chains(fdef) == 1
    @test number_of_stores(fdef) == 1
    @test length(fdef.local_vars) == 1

    ir = @spv_ir begin
      F32 = TypeFloat(32)
      U32 = TypeInt(32, false)
      Vec2 = TypeVector(F32, 2U)
      c_F32_05 = Constant(0.5F)::F32
      uv = ConstantComposite(c_F32_05, c_F32_05)::Vec2
      c_U32_4 = Constant(4U)::U32
      Vec4 = TypeVector(F32, 4U)
      c_U32_256 = Constant(256U)::U32
      _IT = TypeImage(F32, SPIRV.Dim2D, 0x00000000, 0x00000000, 0x00000000, 0x00000001, SPIRV.ImageFormatRgba16f)
      IT = TypeSampledImage(_IT)
      ArrayIT_256 = TypeArray(IT, c_U32_256)
      PtrArrayIT_256 = TypePointer(SPIRV.StorageClassUniformConstant, ArrayIT_256)
      arr_ptr = Variable(SPIRV.StorageClassUniformConstant)::PtrArrayIT_256

      @function f(index::U32)::Vec4 begin
        _ = Label()
        img = CompositeExtract(arr_ptr, index)::IT
        x = ImageSampleImplicitLod(img, uv)::Vec4
        ReturnValue(x)
      end
    end
    @test_throws "Reached non-composite type while indexes still remain to be traversed" unwrap(validate(ir))
    fdef = ir[1]
    @test number_of_access_chains(fdef) == 0
    @test number_of_stores(fdef) == 0
    @test length(fdef.local_vars) == 0

    composite_extract_to_access_chain_load!(ir)
    @test unwrap(validate(ir))

    @test number_of_access_chains(fdef) == 1
    @test number_of_stores(fdef) == 0
    @test length(fdef.local_vars) == 0
  end

  @testset "Constant propagation" begin
    ir = @spv_ir begin
      Float32 = TypeFloat(32)
      UInt32 = TypeInt(32, false)
      Int16 = TypeInt(16, true)
      Vec2 = TypeVector(Float32, 2)
      index = Constant(1U)::UInt32
      one_int16 = Constant(Int16(1))::Int16
      @function f(x::Vec2)::Float32 begin
        _ = Label()
        one = UConvert(one_int16)::UInt32
        i = ISub(index, one)::UInt32
        ret = CompositeExtract(x, i)::Float32
        ReturnValue(ret)
      end
    end
    propagate_constants!(ir)
    expected = @spv_ir begin
      Float32 = TypeFloat(32)
      UInt32 = TypeInt(32, false)
      Int16 = TypeInt(16, true)
      Vec2 = TypeVector(Float32, 2)
      index = Constant(1U)::UInt32
      one_int16 = Constant(Int16(1))::Int16
      # XXX: The const-proped result is inserted after function types,
      # which is impossible to express given the current DSL. That should be addressed some time.
      ft = TypeFunction(Float32, Vec2)
      result = Constant(0U)::UInt32
      f = Function(SPIRV.FunctionControlNone, ft)
      x = FunctionParameter()::Vec2
      _ = Label()
      ret = CompositeExtract(x, result)::Float32
      ReturnValue(ret)
      FunctionEnd()
    end
    @test ir ≈ expected renumber = true
    propagate_constants!(ir)
    @test ir ≈ expected renumber = true
  end

  @testset "OpNop removal" begin
    ir = @spv_ir begin
      UInt32 = TypeInt(32, false)
      Nothing = TypeVoid()
      @function f(x::UInt32)::UInt32 begin
        _ = Label()
        y = Nop(x)::UInt32
        y2 = Nop(y)::UInt32
        z = Nop()::Nothing
        ReturnValue(y2)
      end
    end
    remove_op_nops!(ir)
    expected = @spv_ir begin
      UInt32 = TypeInt(32, false)
      Nothing = TypeVoid()
      @function f(x::UInt32)::UInt32 begin
        _ = Label()
        ReturnValue(x)
      end
    end
    @test ir ≈ expected
    @test unwrap(validate(ir))
  end

  @testset "Egal to recursive Equal" begin
    ir = @spv_ir begin
      Bool = TypeBool()
      Float32 = TypeFloat(32)
      @function (===)(x::Float32, y::Float32)::Bool begin
        _ = Label()
        same = Egal(x, y)::Bool
        ReturnValue(same)
      end
    end
    egal_to_recursive_equal!(ir)
    expected = @spv_ir begin
      Bool = TypeBool()
      Float32 = TypeFloat(32)
      @function (===)(x::Float32, y::Float32)::Bool begin
        _ = Label()
        same = FOrdEqual(x, y)::Bool
        ReturnValue(same)
      end
    end
    @test ir ≈ expected
    @test unwrap(validate(ir))

    ir = @spv_ir begin
      B = TypeBool()
      F32 = TypeFloat(32)
      U32 = TypeInt(32, false)
      c_U32_2 = Constant(2U)::U32
      ArrayF32_2 = TypeArray(F32, c_U32_2)
      @function (===)(x::ArrayF32_2, y::ArrayF32_2)::B begin
        _ = Label()
        same = Egal(x, y)::B
        ReturnValue(same)
      end
    end
    egal_to_recursive_equal!(ir)
    composite_extract_to_access_chain_load!(ir)
    add_merge_headers!(ir)
    @test unwrap(validate(ir))
  end
end;
