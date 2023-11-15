using SPIRV, Test, Accessors
using SPIRV: renumber_ssa, compute_id_bound, id_bound, fill_phi_branches!, remap_dynamic_1based_indices!

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
end;
