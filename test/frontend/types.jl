using SPIRV, Test
using SPIRV: component_type, texel_type, sampled_type, column, Pointer
using StaticArrays

@testset "Frontend types" begin
  @testset "Pointers" begin
    ptr = Pointer(Ref(5))
    @test ptr[] === 5
    ptr[] = 3
    @test ptr[] === 3
    ptr = Pointer(5)
    @test ptr[] == 5
    ptr[] = 3
    @test ptr[] === 3
    ptr = Pointer(Vec2(1, 2))
    @test ptr[] == Vec2(1, 2)
    ptr[] = Vec2(3, 4)
    @test ptr[] == Vec2(3, 4)

    @testset "Array pointers" begin
      # Immutable elements.
      arr = [1, 2]
      GC.@preserve arr begin
        p = pointer(arr)
        address = convert(UInt64, p)
        ptr = Pointer{Vector{Int64}}(address)
        @test eltype(ptr) == Vector{Int64}
        @test ptr[1] == 1
        @test ptr[2] == 2
        @test (@load address::Int64) == 1
        @test (@load address[1]::Int64) == 1
        @test (@load address[2]::Int64) == 2
        @store address[2]::Int64 = 4
        @test (@load address[2]::Int64) == 4
        @store 5 address[2]::Int64
        @test (@load address[2]::Int64) == 5
      end

      # Mutable elements.
      (a, b, c, d) = (Vec2(3, 4), Vec2(5, 6), Vec2(7, 8), Vec2(8, 9))
      arr = [a, b]
      GC.@preserve arr begin
        p = pointer(arr)
        address = convert(UInt64, p)
        ptr = Pointer{Vector{Vec2}}(address)
        @test eltype(ptr) == Vector{Vec2}
        @test ptr[1] == a
        @test ptr[2] == b
        @test (@load address[1]::Vec2) == a
        @test (@load address[2]::Vec2) == b
        @store address[2]::Vec2 = c
        @test (@load address[2]::Vec2) == c
        @store d address[2]::Vec2
        @test (@load address[2]::Vec2) == d
      end
    end
  end

  @testset "Mat" begin
    m = Mat{2,2}(1.0, 1.0, 3.0, 2.0)
    @test m[1, 1] === 1.0
    @test m[1, 2] === 3.0
    @test column(m, 1) == Vec(1.0, 1.0)
    @test column(m, 2) == Vec(3.0, 2.0)
    mz = @mat [0.0 0.0
               0.0 0.0]
    m2 = @mat [1.0 3.0
               1.0 2.0]
    @test m == m2

    m = @mat Float32[
      1 2 3 4
      5 6 7 8
      9 10 11 12
    ]
    @test m[2, 2] === 6f0
    @test m[3, 2] === 10f0
  end

  @testset "Images" begin
    img = image_type(SPIRV.ImageFormatRgba32f, SPIRV.Dim2D, 0, false, false, 1)(zeros(Vec4, 32, 32))

    @test texel_type(img) === Vec4
    @test img[1] == zero(Vec4)
    @test img[1, 1] == zero(Vec4)
    @test img[32, 32] == zero(Vec4)
    @test_throws BoundsError img[33, 32]

    img[1] = @vec ones(Float32, 4)
    @test img[1] == @vec ones(Float32, 4)
    img[4, 4] = @vec ones(Float32, 4)
    @test img[4, 4] == @vec ones(Float32, 4)

    sampler = Sampler()
    sampled = SampledImage(img, sampler)
    @test sampled_type(sampled) === Vec4
    @test sampled(1f0) == zero(eltype(img))
    @test sampled(1f0, 1f0) == zero(eltype(img))
    @test sampled(zero(Vec2), 1) == zero(eltype(img))

    img = image_type(SPIRV.ImageFormatRg32ui, SPIRV.Dim2D, 0, false, false, 1)(zeros(Vec4U, 32, 32))
    sampled = SampledImage(img, sampler)
    @test sampled(1f0, 1f0) == zero(eltype(img))
  end

  @testset "Copying" begin
    ptr = Pointer(2)
    ptr2 = copy(ptr)
    ptr[] = 3
    @test ptr2[] == 2

    ptr = Pointer(Ref((3, Vec2(1, 2))))
    ptr2 = copy(ptr)
    ptr[] = (4, @vec ones(Float32, 2))
    @test ptr2[] == (3, Vec2(1, 2))

    ptr = Pointer(Ref(Vec(1, 2)))
    ptr2 = copy(ptr)
    ptr[] = Vec(3, 4)
    @test ptr2[] == Vec(1, 2)
  end
end;
