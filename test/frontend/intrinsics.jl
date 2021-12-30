using SPIRV, Test
using SPIRV: @trymatch

function operation(ex::Expr; mod = SPIRV)
  @trymatch ex begin
    Expr(:invoke, _, f, args...) => @trymatch f begin
      ::GlobalRef => f.mod == mod ? f.name : nothing
    end
  end
end

@testset "Intrinsics" begin
  @testset "Replacement of core intrinsics with SPIR-V intrinsics" begin
    # Test that SPIR-V intrinsics are picked up and infer correctly.
    (; code, ssavaluetypes) = SPIRV.@code_typed f_straightcode(3f0)
    fadd = code[1]
    @test Meta.isexpr(fadd, :invoke)
    @test fadd.args[2] == GlobalRef(SPIRV, :FAdd)
    @test ssavaluetypes[1] == Float32

    (; code, ssavaluetypes) = SPIRV.@code_typed f_straightcode(UInt64(0))
    @test operation(code[1]) == :IAdd
    @test ssavaluetypes[1] == UInt64
    @test all(==(:IMul), operation.(code[2:3]))
    @test all(==(UInt64), ssavaluetypes[2:3])

    (; code, ssavaluetypes) = SPIRV.@code_typed f_straightcode(UInt32(0))
    # Skip return node.
    @test operation.(code[1:end-1]) == [:SConvert, :IAdd, :IMul, :IMul]
    @test ssavaluetypes[1:end-1] == fill(Int64, 4)

    (; code, ssavaluetypes) = SPIRV.@code_typed exp(3)
    @test operation(code[1]) == :ConvertSToF
    @test operation(code[2]; mod = Base.Math) == :exp
    @test ssavaluetypes[1:end-1] == fill(Float64, 2)
  end

  @testset "Extended instruction sets" begin
    (; code, ssavaluetypes) = SPIRV.@code_typed exp(3f0)
    @test operation(code[1]) == :Exp
    @test ssavaluetypes[1] == Float32

    (; code, ssavaluetypes) = SPIRV.@code_typed clamp(1.2, 0., 0.7)
    @test operation(code[1]) == :FClamp
    @test ssavaluetypes[1] == Float64

    (; code, ssavaluetypes) = SPIRV.@code_typed f_extinst(3f0)
    @test operation.(code[1:end-1]) == [:Exp, :Sin, :FMul, :FAdd, :Log, :FAdd]
    @test ssavaluetypes[1:end-1] == fill(Float32, 6)
  end

  @testset "Array operations" begin
    @testset "GenericVector" begin
      v = SVec(1., 3., 1.)
      @test v[2] == 3.
      v[3] = 4
      @test v[3] == last(v) == 4
      @test first(v) == 1.
      @test v.x == v.r == 1.
      @test v.y == v.g == 3.
      @test v.z == v.b == 4.
      v2 = similar(v)
      @test all(iszero, v2)
    end

    @testset "Basic operations" begin
      v1 = SVec(0., 1., 0.)
      v2 = SVec(1., 2., 1.)
      v3 = SVec(3., 1., -1.)
      f_vector(x, y, z) = (x + y) * (z - y)
      @test f_vector(v1, v2, v3) == SVec(2., -3., -2.)

      (; code, ssavaluetypes) = SPIRV.@code_typed f_vector(v1, v2, v3)
      @test operation.(code[1:end-1]) == [:FAdd, :FSub, :FMul]
      @test ssavaluetypes[1:end-1] == fill(SVec{Float64,3}, 3)

      function f_vector_2(x)
        x[3] = x[1] + x[2]
      end

      (; code, ssavaluetypes) = SPIRV.@code_typed f_vector_2(v1)
      @test operation.(code[1:end-1]) == [:ISub, :UConvert, :AccessChain, :Load, :ISub, :UConvert, :AccessChain, :Load, :FAdd, :ISub, :UConvert, :AccessChain, :Store]
      @test ssavaluetypes[1:end-1] == [repeat([Int, UInt32, SPIRV.Pointer{Float64}, Float64], 2); Float64; Int; UInt32; SPIRV.Pointer{Float64}; Nothing]

      (; code, ssavaluetypes) = SPIRV.@code_typed f_vector_2([1., 2., 3.])
      @test operation.(code[1:end-1]) == [:ISub, :UConvert, :AccessChain, :Load, :ISub, :UConvert, :AccessChain, :Load, :FAdd, :ISub, :UConvert, :AccessChain, :Store]
      @test ssavaluetypes[1:end-1] == [repeat([Int, UInt32, SPIRV.Pointer{Float64}, Float64], 2); Float64; Int; UInt32; SPIRV.Pointer{Float64}; Nothing]
    end
  end

  @testset "Constant propagation" begin
    function test_constprop()
      x = 3
      z = 10 + x
      x + 2 + z
    end

    (; code) = SPIRV.@code_typed test_constprop()
    @test code[1] == Core.ReturnNode(18)

    function test_constprop2()
      x = 3.
      z = 10 + x
      x + 2f0 + z
    end

    (; code) = SPIRV.@code_typed test_constprop2()
    @test code[1] == Core.ReturnNode(18.)

    function test_constprop3()
      x = 3.
      z = Base.mod(10., x)
      x + 2f0 + z
    end

    (; code) = SPIRV.@code_typed test_constprop3()
    @test code[1] == Core.ReturnNode(6.)

    function test_constprop4()
      x = exp(3.)
      z = 1 + x^2
      x + 2f0 + floor(z)
    end

    (; code) = SPIRV.@code_typed test_constprop4()
    @test code[1] == Core.ReturnNode(426.08553692318765)

    function test_constprop5()
      y = exp(2f0)
      z = 1 + 3sin(2f0)
      log(z) + y
    end

    (; code) = SPIRV.@code_typed test_constprop5()
    @test code[1] == Core.ReturnNode(8.704899f0)
  end
end
