using SPIRV, Test
using SPIRV: ArrayCursor, write!

@testset "Cursor" begin
  arr = [4, 5, 6, 7]
  c = ArrayCursor(arr)
  @test eltype(c) == Int

  @testset "Navigation & reading" begin
    @test position(c) == 1
    @test !eof(c)
    @test read(c) === 4
    @test position(c) == 2
    @test read(c) === 5
    @test read(c) === 6
    @test read(c) === 7
    @test_throws ErrorException read(c)
    @test eof(c)

    @test seekstart(c) == position(c) == 1
    @test isnothing(skip(c, 2))
    @test position(c) == 3
    @test seekend(c) == position(c) == 5
  end

  @testset "Marking" begin
    seek(c, 3)
    @test !mark(c)
    @test mark(c)
    seekstart(c)
    @test reset(c) == 3
    @test_throws ErrorException reset(c)
    seek(c, 2)
    @test position(c) == 2
    mark(c)
    @test unmark(c)
    @test !unmark(c)
    @test_throws ErrorException reset(c)
  end

  @testset "Writing" begin
    seek(c, 2)
    @test peek(c) == 5
    write!(c, 100)
    @test position(c) == 3
    seek(c, 2)
    @test peek(c) == read(c) == 100

    seekend(c)
    @test position(c) == 5
    write!(c, 1, 2, 3)
    @test position(c) == 8
    seek(c, 5)
    @test read(c) == 1
    @test read(c) == 2
    @test read(c) == 3
    insert!(c, 23)
    @test position(c) == 9
    seek(c, 8)
    @test read(c) == 23
    @test seekend(c) == 9
    @test isnothing(delete!(c))
    @test seekend(c) == 9
    seek(c, 8)
    @test isnothing(delete!(c))
    @test seekend(c) == 8
    seek(c, 7)
    @test peek(c) == 3
  end
end;
