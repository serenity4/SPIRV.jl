using SPIRV, Test, Accessors
using SPIRV: renumber_ssa, compute_id_bound, id_bound, fill_phi_branches!

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
end;
