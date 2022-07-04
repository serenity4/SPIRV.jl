using SPIRV, Test
using SPIRV: @trymatch

function operation(ex; mod = SPIRV)
  @trymatch ex begin
    Expr(:invoke, _, f, args...) => @trymatch f begin
      ::GlobalRef => f.mod == mod ? f.name : nothing
      ::Core.SSAValue => f
    end
    ::GlobalRef => ex.name
  end
end

function store(x)
  x[3] = x[1] + x[2]
end

function store(mat::Mat)
  mat[1, 2] = mat[1, 1] + mat[3, 3]
end

@testset "Codegen - Julia" begin
  @testset "Intrinsics" begin
    @testset "Replacement of core intrinsics with SPIR-V intrinsics" begin
      # Test that SPIR-V intrinsics are picked up and infer correctly.
      (; code, ssavaluetypes) = SPIRV.@code_typed f_straightcode(::Float32)
      fadd = code[1]
      @test Meta.isexpr(fadd, :invoke)
      @test fadd.args[2] == GlobalRef(SPIRV, :FAdd)
      @test ssavaluetypes[1] == Float32

      (; code, ssavaluetypes) = SPIRV.@code_typed f_straightcode(::UInt64)
      @test operation(code[1]) == :IAdd
      @test ssavaluetypes[1] == UInt64
      @test all(==(:IMul), operation.(code[2:3]))
      @test all(==(UInt64), ssavaluetypes[2:3])

      (; code, ssavaluetypes) = SPIRV.@code_typed f_straightcode(::UInt32)
      # Skip return node.
      @test operation.(code[1:(end - 1)]) == [:SConvert, :IAdd, :IMul, :IMul]
      @test ssavaluetypes[1:(end - 1)] == fill(Int64, 4)

      (; code, ssavaluetypes) = SPIRV.@code_typed exp(::Int64)
      @test operation(code[1]) == :ConvertSToF
      @test operation(code[2]; mod = Base.Math) == :exp
      @test ssavaluetypes[1:(end - 1)] == fill(Float64, 2)
    end

    @testset "Extended instruction sets" begin
      (; code, ssavaluetypes) = SPIRV.@code_typed exp(::Float32)
      @test operation(code[1]) == :Exp
      @test ssavaluetypes[1] == Float32

      (; code, ssavaluetypes) = SPIRV.@code_typed clamp(::Float64, ::Float64, ::Float64)
      @test operation(code[1]) == :FClamp
      @test ssavaluetypes[1] == Float64

      (; code, ssavaluetypes) = SPIRV.@code_typed f_extinst(::Float32)
      @test operation.(code[1:(end - 1)]) == [:Exp, :Sin, :FMul, :FAdd, :Log, :FAdd]
      @test ssavaluetypes[1:(end - 1)] == fill(Float32, 6)
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
        x = 3.0
        z = 10 + x
        x + 2F + z
      end

      (; code) = SPIRV.@code_typed test_constprop2()
      @test code[1] == Core.ReturnNode(18.0)

      function test_constprop3()
        x = 3.0
        z = Base.mod(10.0, x)
        x + 2F + z
      end

      (; code) = SPIRV.@code_typed test_constprop3()
      @test code[1] == Core.ReturnNode(6.0)

      function test_constprop4()
        x = exp(3.0)
        z = 1 + x^2
        x + 2.0F + floor(z)
      end

      (; code) = SPIRV.@code_typed test_constprop4()
      @test code[1] == Core.ReturnNode(426.08553692318765)

      function test_constprop5()
        y = exp(2F)
        z = 1 + 3sin(2F)
        log(z) + y
      end

      # FIXME: `Base.Math.exp_impl` is called with `x::Core.Const(2.0f0)` with
      # the SPIR-V interpreter, which is invalid; the native interpreter seems
      # to remove the `Core.Const` annotation and feeds in `x::Float32`.
      # To replicate, use `f() = exp(2f0)` (or anything that passes a `Core.Const` to `exp`).
      @test begin
        (; code) = SPIRV.@code_typed test_constprop5()
        code[1] == Core.ReturnNode(8.704899f0)
      end broken = VERSION > v"1.9.0-DEV.718" # version is not exact.
    end
  end

  @testset "Custom SPIR-V types" begin
    @testset "Vec" begin
      v1 = Vec(0.0, 1.0, 0.0)
      v2 = Vec(1.0, 2.0, 1.0)
      v3 = Vec(3.0, 1.0, -1.0)
      f_vector(x, y, z) = (x + y) * (z - y)
      @test f_vector(v1, v2, v3) == Vec(2.0, -3.0, -2.0)

      (; code, ssavaluetypes) = SPIRV.@code_typed f_vector(v1, v2, v3)
      @test operation.(code[1:(end - 1)]) == [:FAdd, :FSub, :FMul]
      @test ssavaluetypes[1:(end - 1)] == fill(Vec{3,Float64}, 3)

      (; code, ssavaluetypes) = SPIRV.@code_typed store(v1)
      @test operation.(code[1:(end - 1)]) ==
            [:UConvert, :ISub, :AccessChain, :Load, :UConvert, :ISub, :AccessChain, :Load, :FAdd, :UConvert, :ISub, :AccessChain, :Store]
      @test ssavaluetypes[1:(end - 1)] ==
            [repeat([UInt32, UInt32, Pointer{Float64}, Float64], 2); Float64; UInt32; UInt32; Pointer{Float64}; Nothing]
    end

    @testset "Arrays" begin
      (; code, ssavaluetypes) = SPIRV.@code_typed store(::Arr{3, Float64})
      @test operation.(code[1:(end - 1)]) ==
            [:UConvert, :ISub, :AccessChain, :Load, :UConvert, :ISub, :AccessChain, :Load, :FAdd, :UConvert, :ISub, :AccessChain, :Store]
      @test ssavaluetypes[1:(end - 1)] ==
            [repeat([UInt32, UInt32, Pointer{Float64}, Float64], 2); Float64; UInt32; UInt32; Pointer{Float64}; Nothing]

      (; code, ssavaluetypes) = SPIRV.@code_typed store(::Vector{Float64})
      @test operation.(code[1:(end - 1)]) ==
            [:AccessChain, :Load, :AccessChain, :Load, :FAdd, :AccessChain, :Store]
      @test ssavaluetypes[1:(end - 1)] ==
            [repeat([Pointer{Float64}, Float64], 2); Float64; Pointer{Float64}; Nothing]
    end

    @testset "Matrix" begin
      (; code, ssavaluetypes) = SPIRV.@code_typed store(::Mat{4, 4, Float64})
      @test operation.(code[1:(end - 1)]) ==
            [:UConvert, :ISub, :UConvert, :ISub, :AccessChain, :Load, :UConvert, :ISub, :UConvert,
        :ISub, :AccessChain, :Load, :FAdd, :UConvert, :ISub, :UConvert, :ISub, :AccessChain, :Store]
      @test ssavaluetypes[1:(end - 1)] ==
            [repeat([UInt32, UInt32, UInt32, UInt32, Pointer{Float64}, Float64], 2); Float64; UInt32;
        UInt32; UInt32; UInt32; Pointer{Float64}; Nothing]
    end

    @testset "Image" begin
      function sample_some_image(img, sampler)
        sampled_image = combine(img, sampler)
        sampled_image(Vec(1f0, 2f0))
      end

      T = Image{Float32,SPIRV.Dim2D,0,false,false,1,SPIRV.ImageFormatRgba16f}
      (; code, ssavaluetypes) = SPIRV.@code_typed sample_some_image(::T, ::Sampler)
      @test operation.(code[1:(end - 1)]) == [:SampledImage, :CompositeConstruct, :ImageSampleImplicitLod]
      @test ssavaluetypes[1:(end - 1)] == [SampledImage{T}, Vec{2,Float32}, Vec{4, Float32}]
    end
  end
end;
