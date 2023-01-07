using SPIRV, Test, Dictionaries
using SPIRV: emit!, spir_type, PointerType, add_type_layouts!, StorageClassStorageBuffer, StorageClassUniform, StorageClassPhysicalStorageBuffer, StorageClassPushConstant, DecorationBlock, payload_sizes, getstride, reinterpret_spirv, TypeInfo, TypeMetadata, metadata!, validate_offsets

function test_has_offset(tmeta, T, field, offset)
  decs = decorations(tmeta, tmeta.tmap[T], field)
  @test has_decoration(decs, SPIRV.DecorationOffset)
  @test decs.offset == offset
end

function type_metadata(T; storage_classes = [])
  tmeta = TypeMetadata()
  type = spir_type(T, tmeta.tmap)
  for sc in storage_classes
    metadata!(tmeta, PointerType(sc, type))
  end
  tmeta
end

layout = VulkanLayout()

struct Align1
  x::Int64
  y::Int64
end

struct Align2
  x::Int32
  y::Int64
end

struct Align3
  x::Int64
  y::Int32
  z::Int32
end

struct Align4
  x::Int64
  y::Int8
  z::Vec{2,Int16}
end

struct Align5
  x::Int64
  y::Align4
  z::Int8
end

Align6 = Arr{2, Align5}

struct Align7
  x::Int8
  mat::Mat4
end

primitive type WeirdType 24 end
WeirdType(bytes = [0x01, 0x02, 0x03]) = reinterpret(WeirdType, bytes)[]

@testset "Structure layouts" begin
  @testset "Alignments" begin
    tmeta = type_metadata(Align1)
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align1, 1, 0)
    test_has_offset(tmeta, Align1, 2, 8)

    tmeta = type_metadata(Align2)
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align2, 1, 0)
    test_has_offset(tmeta, Align2, 2, 8)

    tmeta = type_metadata(Align3)
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align3, 1, 0)
    test_has_offset(tmeta, Align3, 2, 8)
    test_has_offset(tmeta, Align3, 3, 12)

    tmeta = type_metadata(Align4)
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align4, 1, 0)
    test_has_offset(tmeta, Align4, 2, 8)
    test_has_offset(tmeta, Align4, 3, 10)
    @test compute_minimal_size(Align4, tmeta, layout) == 14

    tmeta = type_metadata(Align5)
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align5, 1, 0)
    test_has_offset(tmeta, Align5, 2, 8)
    test_has_offset(tmeta, Align5, 3, 22)
    @test compute_minimal_size(Align5, tmeta, layout) == 23

    tmeta = type_metadata(Align5; storage_classes = [StorageClassUniform])
    decorate!(tmeta, tmeta.tmap[Align5], DecorationBlock)
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align5, 1, 0)
    test_has_offset(tmeta, Align5, 2, 16)
    test_has_offset(tmeta, Align5, 3, 30)
    @test compute_minimal_size(Align5, tmeta, layout) == 31

    tmeta = type_metadata(Align7)
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align7, 1, 0)
    test_has_offset(tmeta, Align7, 2, 16)
  end

  @testset "Array/Matrix layouts" begin
    T = Arr{4, Tuple{Float64, Float64}}
    tmeta = type_metadata(T)
    add_type_layouts!(tmeta, layout)
    decs = decorations(tmeta, tmeta.tmap[T])
    @test has_decoration(decs, SPIRV.DecorationArrayStride)
    @test decs.array_stride == 16

    T = Align7
    tmeta = type_metadata(T)
    add_type_layouts!(tmeta, layout)
    decs = decorations(tmeta, tmeta.tmap[T], 2)
    @test has_decoration(decs, SPIRV.DecorationMatrixStride)
    @test decs.matrix_stride == 4
  end

  @testset "Byte extraction and alignment" begin
    bytes = serialize(Align1(1, 2), NoPadding())
    @test bytes == reinterpret(UInt8, [1, 2])
    tmeta = type_metadata(Align1)
    add_type_layouts!(tmeta, layout)
    t = tmeta.tmap[Align1]
    @test getoffsets(tmeta, t) == [0, 8]
    @test payload_sizes(t) == [8, 8]
    @test align(bytes, t, tmeta) == bytes
    @test bytes == align(bytes, [8, 8], [0, 8]) == align(bytes, t, [0, 8]) == align(bytes, Align1, tmeta)

    bytes = serialize(Align2(1, 2), NoPadding())
    @test bytes == reinterpret(UInt8, [1U, 2U, 0U])
    tmeta = type_metadata(Align2)
    add_type_layouts!(tmeta, layout)
    t = tmeta.tmap[Align2]
    @test getoffsets(tmeta, t) == [0, 8]
    @test payload_sizes(t) == [4, 8]
    @test align(bytes, t, tmeta) == reinterpret(UInt8, [1, 2])

    bytes = serialize(Align3(1, 2, 3), NoPadding())
    @test bytes == reinterpret(UInt8, [1U, 0U, 2U, 3U])
    tmeta = type_metadata(Align3)
    add_type_layouts!(tmeta, layout)
    t = tmeta.tmap[Align3]
    @test getoffsets(tmeta, t) == [0, 8, 12]
    @test payload_sizes(t) == [8, 4, 4]
    @test align(bytes, t, tmeta) == bytes

    bytes = serialize(Align4(1, 2, Vec(3, 4)), NoPadding())
    @test bytes == [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x03, 0x00, 0x04, 0x00]
    tmeta = type_metadata(Align4)
    add_type_layouts!(tmeta, layout)
    t = tmeta.tmap[Align4]
    @test getoffsets(tmeta, t) == [0, 8, 10]
    @test payload_sizes(t) == [8, 1, 4]
    @test align(bytes, t, tmeta) == [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04, 0x00]

    bytes = serialize(Align5(1, Align4(2, 3, Vec(4, 5)), 6), NoPadding())
    @test bytes == [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x04, 0x00, 0x05, 0x00, 0x06]
    tmeta = type_metadata(Align5)
    add_type_layouts!(tmeta, layout)
    t = tmeta.tmap[Align5]
    @test getoffsets(tmeta, t) == [0, 8, 16, 18, 22]
    @test payload_sizes(t) == [8, 8, 1, 4, 1]
    @test align(bytes, t, tmeta) == [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x04, 0x00, 0x05, 0x00, 0x06]

    bytes = serialize(Align6(Align5(1, Align4(2, 3, Vec(4, 5)), 6), Align5(2, Align4(2, 3, Vec(4, 5)), 6)), NoPadding())
    @test bytes == [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x04, 0x00, 0x05, 0x00, 0x06, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x04, 0x00, 0x05, 0x00, 0x06]
    tmeta = type_metadata(Align6)
    add_type_layouts!(tmeta, layout)
    t = tmeta.tmap[Align6]
    @test getstride(tmeta, t) == 24
    @test align(bytes, t, tmeta) == [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x04, 0x00, 0x05, 0x00, 0x06, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x04, 0x00, 0x05, 0x00, 0x06]

    bytes = serialize(Align7(1, @mat Float32[
      1 2 3 4
      5 6 7 8
      9 10 11 12
      13 14 15 16
    ]), NoPadding())
    @test length(bytes) == payload_size(Align7) == 1 + 4 * 4 * 4
    tmeta = type_metadata(Align7)
    add_type_layouts!(tmeta, layout)
    t = tmeta.tmap[Align7]
    @test getoffsets(tmeta, t) == [0, 16]
    @test payload_sizes(t) == [1, 64]
    @test compute_minimal_size(Align7, tmeta, layout) == 16 + 64
  end

  @testset "TypeInfo" begin
    Ts = [
      Align1,
      Align2,
      Align3,
      Align4,
      Align5,
      Tuple{Tuple{Int64,Int64}, Tuple{Float32, Float32}},
    ]
    type_info = TypeInfo(Ts, layout)
    for T in Ts
      offsets = getoffsets(type_info, T)
      @test validate_offsets(offsets)
      @test offsets == getoffsets(add_type_layouts!(type_metadata(T), layout), T)
    end
  end

  @testset "Layout extraction from Julia types" begin
    @test payload_sizes(Align5) == [8, 8, 1, 4, 1]
    @test getoffsets(Align3) == [0, 8, 12]
    @test getoffsets(Align4) == [0, 8, 16]
    # FIXME: These offsets are wrong, as they assume 8-byte pointers for non-`isbits` elements.
    @test SPIRV.fieldsize_with_padding(Align4) == 8 + 8 + 4
    @test SPIRV.fieldsize_with_padding(Tuple{Align4,Int8}) == SPIRV.fieldsize_with_padding(Align4) + (8 - 4) + 1
    @test getoffsets(Align5) == [0, 8, 16, 24, 28]
    @test getstride(Vector{WeirdType}) == 4
  end

  @testset "Serializing and deserializing Julia values" begin
    function test_reinterpret_noalign(x)
      bytes = serialize(x, NoPadding())
      @test length(bytes) == payload_size(x)
      @test reinterpret_spirv(typeof(x), bytes) == x
    end
    test_reinterpret_noalign(Vec(1, 2))
    test_reinterpret_noalign([Vec(1, 2), Vec(3, 4)])
    # FIXME: Non-`isbits` types are not supported for `Arr`.
    # test_reinterpret_noalign(Arr(Vec(1, 2), Vec(3, 4)))
  end
end;
