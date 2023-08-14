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

macro test_code(code, args...)
  maxlength = nothing; minlength = nothing; spirv_chunk = true; spirv_chunk_broken = false
  for arg in args
    Meta.isexpr(arg, :(=)) || isa(arg, Symbol) || throw(ArgumentError("Expected parameter expression, got $arg"))
    name, value = isa(arg, Symbol) ? (arg, arg) : arg.args
    if name == :maxlength
      maxlength = esc(value)
    elseif name == :minlength
      minlength = esc(value)
    elseif name == :spirv_chunk
      value === QuoteNode(:broken) && (spirv_chunk_broken = true)
      spirv_chunk = esc(value)
    else
      throw(ArgumentError("Parameter name expected to be one of :maxlength, :minlength, :spirv_chunk; got :$name"))
    end
  end
  code = esc(code)
  test(ex; broken = false) = begin
    ex = :(@test $ex broken = $broken)
    ex.args[2] = __source__
    ex
  end
  logmacro = GlobalRef(Base, Symbol(spirv_chunk_broken ? "@debug" : "@error"))
  log(msg) = Expr(:macrocall, logmacro, __source__, msg)
  ex = quote
    code = $code
    maxlength = $maxlength
    minlength = $minlength
    spirv_chunk = $spirv_chunk
    $(test(:(unwrap(SPIRV.validate(code)))))
    !isnothing(maxlength) && $(test(:(length(code.code) ≤ maxlength)))
    !isnothing(minlength) && $(test(:(length(code.code) ≥ minlength)))
    if spirv_chunk !== false
      sts = code.code[1:(end - 1)]
      is_spirv_chunk = all(sts) do st
        Meta.isexpr(st, :call) && st.args[1] == GlobalRef(Base, :getfield) && return true
        Meta.isexpr(st, :new) && return true
        isa(st, GlobalRef) && return true
        Meta.isexpr(st, :invoke) || ($(log(:("Expected `invoke` expression, got `$st`"))); return false)
        mi = st.args[1]::Core.MethodInstance
        (mi.def.module === SPIRV && !isnothing(SPIRV.lookup_opcode(mi.def.name))) || ($(log(:("Expected `invoke` expression corresponding to a SPIR-V opcode, got `$st`")); false))
      end
      $(test(:is_spirv_chunk, broken = spirv_chunk_broken))
    end
    nothing
  end
  pushfirst!(ex.args, __source__)
  ex
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

      (; code, ssavaluetypes) = SPIRV.@code_typed atan(::Float32, ::Float32)
      @test operation(code[1]) == :Atan2
      @test ssavaluetypes[1] == Float32

      (; code, ssavaluetypes) = SPIRV.@code_typed clamp(::Float64, ::Float64, ::Float64)
      @test operation(code[1]) == :FClamp
      @test ssavaluetypes[1] == Float64

      (; code, ssavaluetypes) = SPIRV.@code_typed f_extinst(::Float32)
      @test operation.(code[1:(end - 1)]) == [:Exp, :Sin, :FMul, :FAdd, :Log, :FAdd]
      @test ssavaluetypes[1:(end - 1)] == fill(Float32, 6)
    end

    @testset "Constant propagation" begin
      # TODO: These tests are highly unreliable because constant propagation is disabled for overlaid methods.
      # The situation should be improved once https://github.com/JuliaGPU/GPUCompiler.jl/issues/384 is implemented.
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
      @test code[1] == Core.ReturnNode(6.0) broken = VERSION ≥ v"1.10.0-DEV.101"

      function test_constprop4()
        x = exp(3.0)
        z = 1 + x^2
        x + 2.0F + floor(z)
      end

      (; code) = SPIRV.@code_typed test_constprop4()
      @test !isempty(code)
      # Constant propagation has been disabled in Core.Compiler for overlaid methods.
      # @test code[1] == Core.ReturnNode(426.08553692318765)

      function test_constprop5()
        y = exp(2F)
        z = 1 + 3sin(2F)
        log(z) + y
      end

      (; code) = SPIRV.@code_typed test_constprop5()
      @test !isempty(code)
      # @test code[1] == Core.ReturnNode(8.704899f0)
    end
  end

  @testset "Custom SPIR-V types" begin
    # We will often index until `end - 1` instead of the whole array of code expressions
    # whenever we are not interested in the `return` statement.
    @testset "Vec" begin
      v1 = Vec(0.0, 1.0, 0.0)
      v2 = Vec(1.0, 2.0, 1.0)
      v3 = Vec(3.0, 1.0, -1.0)
      f_vector(x, y, z) = (x + y) .* (z - y)
      @test f_vector(v1, v2, v3) == Vec(2.0, -3.0, -2.0)

      (; code, ssavaluetypes) = SPIRV.@code_typed f_vector(v1, v2, v3)
      @test operation.(code[1:(end - 1)]) == [:FAdd, :FSub, :FMul]
      @test ssavaluetypes[1:(end - 1)] == fill(Vec{3,Float64}, 3)

      (; code, ssavaluetypes) = SPIRV.@code_typed store(v1)
      @test operation.(code[1:(end - 1)]) ==
            [:UConvert, :ISub, :AccessChain, :Load, :UConvert, :ISub, :AccessChain, :Load, :FAdd, :UConvert, :ISub, :AccessChain, :Store]
    end

    @testset "Arrays" begin
      (; code, ssavaluetypes) = SPIRV.@code_typed store(::Arr{3, Float64})
      @test operation.(code[1:(end - 1)]) ==
            [:UConvert, :ISub, :AccessChain, :Load, :UConvert, :ISub, :AccessChain, :Load, :FAdd, :UConvert, :ISub, :AccessChain, :Store]

      (; code, ssavaluetypes) = SPIRV.@code_typed store(::Vector{Float64})
      # There may be three more `OpUConvert` + `OpISub` to convert Int64s to UInt32s at runtime.
      # On a few recent versions of Julia, this conversion is optimized away.
      # So we just test that the first 5 instructions and last 2 are correct.
      @test in(length(code), (8, 14)) # 14 is if the conversions are present.
      @test filter!(x -> !in(x, (:UConvert, :ISub)), operation.(code))[1:5] ==
            [:AccessChain, :Load, :AccessChain, :Load, :FAdd]
      @test operation.(code[end-2:end-1]) == [:AccessChain, :Store]
    end

    @testset "Matrix" begin
      (; code, ssavaluetypes) = SPIRV.@code_typed store(::Mat{4, 4, Float64})
      @test operation.(code[1:(end - 1)]) ==
            [:UConvert, :ISub, :UConvert, :ISub, :AccessChain, :Load, :UConvert, :ISub, :UConvert,
        :ISub, :AccessChain, :Load, :FAdd, :UConvert, :ISub, :UConvert, :ISub, :AccessChain, :Store]
    end

    @testset "Image" begin
      function sample_some_image(img, sampler)
        sampled_image = combine(img, sampler)
        sampled_image(Vec(1f0, 2f0))
      end

      T = image_type(SPIRV.ImageFormatRgba16f, SPIRV.Dim2D, 0, false, false, 1)
      (; code, ssavaluetypes) = SPIRV.@code_typed sample_some_image(::T, ::Sampler)
      @test operation.(code[1:(end - 1)]) == [:SampledImage, :CompositeConstruct, :ImageSampleImplicitLod]
      @test ssavaluetypes[1:(end - 1)] == [SampledImage{T}, Vec{2,Float32}, Vec{4, Float32}]
    end
  end

  @testset "Generated functions" begin
    @generated _fast_sum(f, xs::Vec{N}) where {N} = Expr(:call, :+, (:(f(xs[$i])) for i in eachindex(xs))...)
    ci = SPIRV.@code_typed debuginfo=:source _fast_sum(identity, ::Vec2)
    @test_code ci minlength = 6 maxlength = 6
  end

  @testset "Fast paths" begin
    ci = SPIRV.@code_typed debuginfo=:source (x -> x == 4)(::UInt32)
    @test_code ci minlength = 3 maxlength = 3 # 1 conversion, 1 intrinsic, 1 return

    ci = SPIRV.@code_typed debuginfo=:source deepcopy(::Vec2)
    @test_code ci minlength = 2 maxlength = 2 # 1 intrinsic, 1 return

    # Currently broken because of a Pi node, let's keep it here nonetheless.
    ci = SPIRV.@code_typed debuginfo=:source (() -> 3.0 + 2F + Base.mod(10.0, 3.0))()
    @test_code ci minlength = 1 maxlength = 3 # 2 intrinsics, 1 return (may be constproped)

    ci = SPIRV.@code_typed debuginfo=:source all(::Vec{2,Bool})
    @test_code ci minlength = 2 maxlength = 2 # 2 accesses, 1 logical operation, 1 return

    ci = SPIRV.@code_typed debuginfo=:source (==)(::Vec2, ::Vec2)
    @test_code ci minlength = 13 maxlength = 13 # 4 accesses, 2 logical operators, 1 vector construction, 1 logical operator, 1 return

    ci = SPIRV.@code_typed debuginfo=:source (==)(::Vec{2,Int32}, ::Vec{2,Float32})
    @test_code ci minlength = 20 maxlength = 20 # A bunch of promotion/conversion operations.

    ci = SPIRV.@code_typed debuginfo=:source (==)(::Vec2, ::Vec3)
    @test_code ci minlength = 1 maxlength = 1 # 1 return (false)

    ci = SPIRV.@code_typed debuginfo=:source (==)(::Vec{2,Int32}, ::Vec{3,Float32})
    @test_code ci minlength = 1 maxlength = 1 # 1 return (false)

    ci = SPIRV.@code_typed debuginfo=:source (v -> setindex!(v, Vec2(1, 2)))(::Vec2)
    @test_code ci minlength = 3 maxlength = 3 # 2 intrinsics (CompositeConstruct + Store), 1 return

    ci = SPIRV.@code_typed debuginfo=:source (x -> @load x::Int32)(::UInt64)
    @test_code ci minlength = 3 maxlength = 3 # 1 conversion, 1 load, 1 return

    ci = SPIRV.@code_typed debuginfo=:source (x -> @load x[2]::Int32)(::UInt64)
    @test_code ci minlength = 4 maxlength = 4 # 1 conversion, 1 access, 1 return

    ci = SPIRV.@code_typed debuginfo=:source (x -> @store x::Int32 = Int32(0))(::UInt64)
    @test_code ci minlength = 3 maxlength = 3 # 1 conversion, 1 store, 1 return

    ci = SPIRV.@code_typed debuginfo=:source (x -> @store x[2]::Int32 = Int32(0))(::UInt64)
    @test_code ci minlength = 4 maxlength = 6 # 1 conversion, 1 access/store, 1 return, can be 2 more instructions if index is turned into 0-based index at runtime. 

    ci = SPIRV.@code_typed debuginfo=:source copy(::Vec2)
    @test_code ci minlength = 3 maxlength = 3 # 2 intrinsics (CompositeConstruct + Store), 1 return

    ci = SPIRV.@code_typed debuginfo=:source copy(::Pointer{Vec2})
    @test_code ci minlength = 2 maxlength = 2 # 1 intrinsic, 1 return

    ci = SPIRV.@code_typed debuginfo=:source exp(::Float32)
    @test_code ci minlength = 2 maxlength = 2 # 1 intrinsic, 1 return

    ci = SPIRV.@code_typed debuginfo=:source sum(::Vec4)
    @test_code ci minlength = 12 maxlength = 12 # 4 accesses (AccessChain + Load per access), 3 additions, 1 return

    ci = SPIRV.@code_typed debuginfo=:source sum(::Arr{10,Float32})
    @test_code ci minlength = 30 maxlength = 30 # 10 accesses, 9 additions, 1 return

    ci = SPIRV.@code_typed debuginfo=:source ((x, y) -> x .+ y)(::Vec2, ::Vec2)
    @test_code ci minlength = 2 maxlength = 2 # 1 addition, 1 return

    ci = SPIRV.@code_typed debuginfo=:source ((arr, x) -> getindex.(arr .+ Ref(x), 1U))(::Arr{3,Vec2}, ::Vec2)
    @test_code ci minlength = 12 maxlength = 30 # Just make sure broadcast results in a single instruction chunk.

    ci = SPIRV.@code_typed debuginfo=:source (arr -> (arr .+= arr))(::Arr{3,Vec2})
    @test_code ci minlength = 18 maxlength = 28 spirv_chunk = false

    ci = SPIRV.@code_typed debuginfo=:source convert(::Type{Arr{3,Float32}}, ::Arr{3,Float32})
    @test_code ci minlength = 1 maxlength = 1 # 1 return

    ci = SPIRV.@code_typed debuginfo=:source convert(::Type{Arr{3,Float64}}, ::Arr{3,Float32})
    @test_code ci minlength = 11 maxlength = 30 # 3 accesses, 3 conversions, 1 construct, 1 return

    ci = SPIRV.@code_typed debuginfo=:source lerp(::Vec2, ::Vec2, ::Float32)
    @test_code ci minlength = 7 maxlength = 17 # A bunch of math operations, code length is variable due to the possibility of constructing intermediate vectors.

    ci = SPIRV.@code_typed debuginfo=:source slerp_2d(::Vec2, ::Vec2, ::Float32)
    @test_code ci minlength = 30

    ci = SPIRV.@code_typed debuginfo=:source rotate_2d(::Vec2, ::Float32)
    @test_code ci minlength = 30

    ci = SPIRV.@code_typed debuginfo=:source linearstep(::Float32, ::Float32, ::Float32)
    @test_code ci minlength = 10 maxlength = 20 spirv_chunk = false

    ci = SPIRV.@code_typed debuginfo=:source smoothstep(::Float32, ::Float32, ::Float32)
    @test_code ci minlength = 10 maxlength = 20 spirv_chunk = false

    ci = SPIRV.@code_typed debuginfo=:source smootherstep(::Float32, ::Float32, ::Float32)
    @test_code ci minlength = 10 maxlength = 20 spirv_chunk = false

    ci = SPIRV.@code_typed debuginfo=:source compute_roots(::Float32, ::Float32, ::Float32)
    @test_code ci minlength = 30 maxlength = 50 spirv_chunk = false

    ci = SPIRV.@code_typed debuginfo=:source compute_blur(::GaussianBlur, ::SampledImage{IT}, ::UInt32, ::Vec2)
    @test_code ci minlength = 100 maxlength = 150 spirv_chunk = false

    ci = SPIRV.@code_typed debuginfo=:source compute_blur_2(::GaussianBlur, ::SampledImage{IT}, ::Vec2)
    @test_code ci minlength = 100 maxlength = 400 spirv_chunk = false

    ci = SPIRV.@code_typed debuginfo=:source step_euler(::BoidAgent, ::Vec2, ::Float32)
    @test_code ci minlength = 50 maxlength = 70 spirv_chunk = false # Assumes that `wrap_around` is inlined, otherwise should be fewer lines.
  end
end;
