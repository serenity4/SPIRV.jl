using SPIRV, Test
using SPIRV: component_type, texel_type, sampled_type

@testset "Array operations" begin
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

  @testset "Vec" begin
    v = Vec(1.0, 3.0, 1.0, 2.0)
    @test v[2] === 3.0
    v[3] = 4
    @test v[4] == last(v) === 2.0
    @test first(v) === 1.0
    @test v.x === v.r === 1.0
    @test v.y === v.g === 3.0
    @test v.z === v.b === 4.0
    @test v.w === v.a === 2.0
    v.x = 10
    @test v.x === 10.0
    v2 = similar(v)
    @test all(iszero, v2)
    @test eltype(v2) == eltype(v)
    @test size(v2) == size(v)

    v[] = v2
    @test all(iszero, v)
    @test iszero(sum(v))
    @test sum(x -> x + 1, v) == 4

    @test_throws ArgumentError Vec(1.0)
    @test_throws ArgumentError Vec(1.0, 2.0, 3.0, 4.0, 5.0)

    # Broadcasting.
    v = Vec2(1, 2)
    copyto!(v, Vec2(0, 0))
    @test all(iszero, v)
    @test_throws MethodError copyto!(v, Vec3(0, 0, 0))
    v = Vec2(1, 2)
    @test v .+ v == v + v == 2v
    @test v .- v == v - v == zero(Vec2)
    @test v .* Vec(1, 1) == v * Vec(1, 1) == v
    @test v ./ Vec(1, 1) == v * Vec(1, 1) == v
    @test 1 .* v == 1 * v == v
    @test v .* v .+ v .* 1 == v * v + v * 1 == Vec2(2, 6)
    @test ceil.(v .* 0.3F .+ exp.(v)) == Vec2(4, 8)

    v = Vec3(2.3, 1.7, -1.2)
    @test foldr(+, v) === foldl(+, v) === sum(v) === sum(collect(v)) === 2.8F
    @test foldr(*, v) === foldl(*, v) === prod(v) === prod(collect(v))
  end

  @testset "Mat" begin
    m = Mat(Vec(1.0, 1.0), Vec(3.0, 2.0))
    @test m[1, 1] === 1.0
    @test m[1, 2] === 3.0
    m2 = @mat [1.0 3.0
               1.0 2.0]
    @test m == m2
    m[1, 2] = 5.0
    @test m[1, 2] === 5.0
    m2 = similar(m)
    @test all(iszero, m2)
    @test eltype(m2) == eltype(m)
    @test size(m2) == size(m)

    m[] = m2
    @test all(iszero, m)

    m = @mat Float32[
      1 2 3 4
      5 6 7 8
      9 10 11 12
    ]
    @test m[2, 2] === 6f0
    @test m[3, 2] === 10f0
  end

  @testset "Arr" begin
    arr = Arr(1.0, 3.0, 1.0, 2.0)
    @test all(arr .== arr.data)
    @test arr[2] === 3.0
    arr[3] = 4
    @test arr[4] == last(arr) === 2.0
    @test first(arr) === 1.0
    arr2 = similar(arr)
    @test all(iszero, arr2)
    @test eltype(arr2) == eltype(arr)
    @test size(arr2) == size(arr)

    arr[] = arr2
    @test all(iszero, arr)
    @test arr == arr2
    arr[1] = 42.0
    @test arr[2] ≠ 42.0
    @test firstindex(arr) === 0U
    @test lastindex(arr) === 3U
    @test eachindex(arr) === 0U:3U

    @test all(iszero, zero(Arr{16,Float32}))
    @test all(isone, one(Arr{16,Float32}))

    # `Arr` with mutable contents.
    arr = Arr(Vec2(1, 2), Vec2(3, 4))
    @test all(arr .== arr.data)
    @test arr[1] == Vec2(1, 2)
    @test arr[2] == Vec2(3, 4)
    arr[1] = Vec2(5, 6)
    @test arr[1] == Vec2(5, 6)
    @test arr[2] == Vec2(3, 4)

    arr = zero(Arr{16,Vec4})
    @test all(iszero, arr)
    arr[1].x = 3.0
    @test iszero(arr[2].x)
    @test all(isone, one(Arr{16,Vec4}))
  end

  @testset "Images" begin
    img = image_type(SPIRV.ImageFormatRgba32f, SPIRV.Dim2D, 0, false, false, 1)(zeros(Vec4, 32, 32))

    @test texel_type(img) === Vec4
    @test img[0] == zero(Vec4)
    @test img[0, 0] == zero(Vec4)
    @test img[31, 31] == zero(Vec4)
    @test_throws BoundsError img[32, 31] == zero(Vec4)

    img[0] = one(Vec4)
    @test img[0] == one(Vec4)
    img[4, 4] = one(Vec4)
    @test img[4, 4] == one(Vec4)

    sampler = Sampler()
    sampled = SampledImage(img, sampler)
    @test sampled_type(sampled) === Vec4
    @test sampled(1f0) == zero(eltype(img))
    @test sampled(1f0, 1f0) == zero(eltype(img))
    @test sampled(zero(Vec2), 1) == zero(eltype(img))
  end

  @testset "Copying" begin
    v = Vec2(2, 3)
    v2 = copy(v)
    v2.x = 1
    @test v.x == 1

    v2 = deepcopy(v)
    v2.x = 1
    @test v.x == 1

    ptr = Pointer(2)
    ptr2 = copy(ptr)
    ptr[] = 3
    @test ptr2[] == 2

    ptr = Pointer(Ref((3, Vec2(1, 2))))
    ptr2 = copy(ptr)
    ptr[][2].x = 3
    @test ptr2[][2].x == 1
    ptr[] = (4, one(Vec2))
    @test ptr2[] == (3, Vec2(1, 2))

    ptr = Pointer(Ref(Vec(1, 2)))
    ptr2 = copy(ptr)
    ptr[] = Vec(3, 4)
    @test ptr2[] == Vec(1, 2)
  end
end;
