using SPIRV, Test

@testset "N-Overlay method tables" begin
  spirv_method_table() = SPIRVInterpreter().method_table

  @testset "Selecting the more specific method" begin
    f = gensym()
    ft = typeof(@eval function $f end)
    @eval $f(x) = 1
    @eval $f(x::Int64) = 2
    match = first(Core.Compiler.findsup(Tuple{ft, Float64}, spirv_method_table()))
    @test match.fully_covers
    @test match.method.module === @__MODULE__
    @test match.method.sig === Tuple{ft, Any}
    match = first(Core.Compiler.findsup(Tuple{ft, Int64}, spirv_method_table()))
    @test match.fully_covers
    @test match.method.module === @__MODULE__
    @test match.method.sig === Tuple{ft, Int64}

    M = @eval module $(gensym())
      import ..Main: $f
      $SPIRV.@override $f(x::Real) = 3
    end

    match = first(Core.Compiler.findsup(Tuple{ft, Float64}, spirv_method_table()))
    @test match.fully_covers
    @test match.method.module === M

    match = first(Core.Compiler.findsup(Tuple{ft, Int64}, spirv_method_table()))
    @test match.method.module === @__MODULE__
    @test match.method.sig === Tuple{ft, Int64}

    match = first(Core.Compiler.findsup(Tuple{ft, String}, spirv_method_table()))
    @test match.method.module === @__MODULE__
    @test match.method.sig === Tuple{ft, Any}
  end

  @testset "Handling ambiguous methods" begin
    f = gensym()
    ft = typeof(@eval function $f end)
    @eval $f(x, y::Int64) = 1
    @eval $f(x::Int64, y) = 2
    @test_throws "ambiguous" @eval $f(1, 1)
    match = first(Core.Compiler.findsup(Tuple{ft, Int64, Int64}, spirv_method_table()))
    @test isnothing(match)
    @eval SPIRV.@override $f(x::Real, y::Int64) = 3 # ambiguous with the other two (ignoring custom rules)
    match = first(Core.Compiler.findsup(Tuple{ft, Int64, Int64}, spirv_method_table()))
    @test match.method.sig == Tuple{ft, Real, Int64} # choose the top-most overlay in case of ambiguities
    @eval SPIRV.@override $f(x::Int64, y::Real) = 4 # here we'll have a real ambiguity though
    match = first(Core.Compiler.findsup(Tuple{ft, Int64, Int64}, spirv_method_table()))
    @test isnothing(match)
  end

  @testset "Intrinsic overrides and fallbacks" begin
    match = first(Core.Compiler.findsup(Tuple{typeof(+), Int64, Int64}, spirv_method_table()))
    @test match.fully_covers
    @test match.method.module === SPIRV

    match = first(Core.Compiler.findsup(Tuple{typeof(print), UInt32}, spirv_method_table()))
    @test match.fully_covers
    @test match.method.module === Base
  end

  @testset "Finding all methods to report ambiguities" begin
    result = Core.Compiler.findall(Tuple{typeof(+), Int64, Int64}, spirv_method_table()).matches
    @test length(result) == 2
    @test result[1].method.module === SPIRV
    @test result[2].method.module === Base

    f = gensym()
    ft = typeof(@eval function $f end)
    @eval $f(x, y::Int64) = 1
    @eval $f(x::Int64, y) = 2
  
    result = Core.Compiler.findall(Tuple{ft, Int64, Int64}, spirv_method_table()).matches
    @test length(result) == 2
  end

  @testset "Abstract invocations" begin
    f = gensym()
    ft = typeof(@eval function $f end)
    @eval $f(x::Int64) = 1
    @eval $f(x::Float64) = 2

    result = Core.Compiler.findall(Tuple{ft, Real}, spirv_method_table()).matches
    @test length(result) == 2

    @eval $f(x::Real) = 3
    result = Core.Compiler.findall(Tuple{ft, Real}, spirv_method_table()).matches
    @test length(result) == 3

    @eval $f(x::String) = 3
    result = Core.Compiler.findall(Tuple{ft, Real}, spirv_method_table()).matches
    @test length(result) == 3

    @eval $f(x::Any) = 3
    result = Core.Compiler.findall(Tuple{ft, Real}, spirv_method_table()).matches
    @test length(result) == 3
    result = Core.Compiler.findall(Tuple{ft, Number}, spirv_method_table()).matches
    @test length(result) == 4

    (match, _, _) = Core.Compiler.findsup(Tuple{ft, Real}, spirv_method_table())
    @test isnothing(match)
  end
end;
