using SPIRV, Test, Dictionaries
using SPIRV: emit!, spir_type, PointerType, add_type_layouts!, StorageClassStorageBuffer, StorageClassUniform, StorageClassPhysicalStorageBuffer, StorageClassPushConstant, DecorationBlock, payload_sizes, getstride, reinterpret_spirv

function test_has_offset(ir, T, field, offset)
  decs = decorations(ir, T, field)
  @test has_decoration(decs, SPIRV.DecorationOffset)
  @test decs.offset == offset
end

function test_has_stride(ir, T, stride)
  decs = decorations(ir, T)
  @test !isnothing(decs)
  @test has_decoration(decs, SPIRV.DecorationArrayStride) || has_decoration(decs, SPIRV.DecorationMatrixStride)
  dec = has_decoration(decs, SPIRV.DecorationArrayStride) ? decs.array_stride : decs.matrix_stride
  @test dec == stride
end

function ir_with_type(T; storage_classes = [])
  ir = IR()
  type = spir_type(T, ir)
  emit!(ir, type)
  for sc in storage_classes
    emit!(ir, PointerType(sc, type))
  end
  ir
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

primitive type WeirdType 24 end
WeirdType(bytes = [0x01, 0x02, 0x03]) = reinterpret(WeirdType, bytes)[]

@testset "Structure layouts" begin
  @testset "Alignments" begin
    ir = ir_with_type(Align1)
    add_type_layouts!(ir, layout)
    test_has_offset(ir, Align1, 1, 0)
    test_has_offset(ir, Align1, 2, 8)

    ir = ir_with_type(Align2)
    add_type_layouts!(ir, layout)
    test_has_offset(ir, Align2, 1, 0)
    test_has_offset(ir, Align2, 2, 8)

    ir = ir_with_type(Align3)
    add_type_layouts!(ir, layout)
    test_has_offset(ir, Align3, 1, 0)
    test_has_offset(ir, Align3, 2, 8)
    test_has_offset(ir, Align3, 3, 12)

    ir = ir_with_type(Align4)
    add_type_layouts!(ir, layout)
    test_has_offset(ir, Align4, 1, 0)
    test_has_offset(ir, Align4, 2, 8)
    test_has_offset(ir, Align4, 3, 10)
    @test compute_minimal_size(Align4, ir, layout) == 14

    ir = ir_with_type(Align5)
    add_type_layouts!(ir, layout)
    test_has_offset(ir, Align5, 1, 0)
    test_has_offset(ir, Align5, 2, 8)
    test_has_offset(ir, Align5, 3, 22)
    @test compute_minimal_size(Align5, ir, layout) == 23

    ir = ir_with_type(Align5; storage_classes = [StorageClassUniform])
    decorate!(ir, Align5, DecorationBlock)
    add_type_layouts!(ir, layout)
    test_has_offset(ir, Align5, 1, 0)
    test_has_offset(ir, Align5, 2, 16)
    test_has_offset(ir, Align5, 3, 30)
    @test compute_minimal_size(Align5, ir, layout) == 31
  end

  @testset "Array/Matrix layouts" begin
    T = Arr{4, Tuple{Float64, Float64}}
    ir = ir_with_type(T)
    add_type_layouts!(ir, layout)
    test_has_stride(ir, T, 16)

    T = Mat{4, 4, Float64}
    ir = ir_with_type(T)
    add_type_layouts!(ir, layout)
    test_has_stride(ir, T, 8)
  end

  @testset "Byte extraction and alignment" begin
    bytes = extract_bytes(Align1(1, 2))
    @test bytes == reinterpret(UInt8, [1, 2])
    ir = ir_with_type(Align1)
    add_type_layouts!(ir, layout)
    t = spir_type(Align1, ir)
    @test getoffsets(ir, t) == [0, 8]
    @test payload_sizes(t) == [8, 8]
    @test align(bytes, t, ir) == bytes
    @test bytes == align(bytes, [8, 8], [0, 8]) == align(bytes, t, [0, 8]) == align(bytes, Align1, ir)

    bytes = extract_bytes(Align2(1, 2))
    @test bytes == reinterpret(UInt8, [1U, 2U, 0U])
    ir = ir_with_type(Align2)
    add_type_layouts!(ir, layout)
    t = spir_type(Align2, ir)
    @test getoffsets(ir, t) == [0, 8]
    @test payload_sizes(t) == [4, 8]
    @test align(bytes, t, ir) == reinterpret(UInt8, [1, 2])

    bytes = extract_bytes(Align3(1, 2, 3))
    @test bytes == reinterpret(UInt8, [1U, 0U, 2U, 3U])
    ir = ir_with_type(Align3)
    add_type_layouts!(ir, layout)
    t = spir_type(Align3, ir)
    @test getoffsets(ir, t) == [0, 8, 12]
    @test payload_sizes(t) == [8, 4, 4]
    @test align(bytes, t, ir) == bytes

    bytes = extract_bytes(Align4(1, 2, Vec(3, 4)))
    @test bytes == [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x03, 0x00, 0x04, 0x00]
    ir = ir_with_type(Align4)
    add_type_layouts!(ir, layout)
    t = spir_type(Align4, ir)
    @test getoffsets(ir, t) == [0, 8, 10]
    @test payload_sizes(t) == [8, 1, 4]
    @test align(bytes, t, ir) == [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04, 0x00]

    bytes = extract_bytes(Align5(1, Align4(2, 3, Vec(4, 5)), 6))
    @test bytes == [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x04, 0x00, 0x05, 0x00, 0x06]
    ir = ir_with_type(Align5)
    add_type_layouts!(ir, layout)
    t = spir_type(Align5, ir)
    @test getoffsets(ir, t) == [0, 8, 16, 18, 22]
    @test payload_sizes(t) == [8, 8, 1, 4, 1]
    @test align(bytes, t, ir) == [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x04, 0x00, 0x05, 0x00, 0x06]

    bytes = extract_bytes(Align6(Align5(1, Align4(2, 3, Vec(4, 5)), 6), Align5(2, Align4(2, 3, Vec(4, 5)), 6)))
    @test bytes == [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x04, 0x00, 0x05, 0x00, 0x06, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x04, 0x00, 0x05, 0x00, 0x06]
    ir = ir_with_type(Align6)
    add_type_layouts!(ir, layout)
    t = spir_type(Align6, ir)
    @test getstride(ir, t) == 24
    @test align(bytes, t, ir) == [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x04, 0x00, 0x05, 0x00, 0x06, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x04, 0x00, 0x05, 0x00, 0x06]
  end

  @testset "TypeInfo" begin
    Ts = [
      Align1,
      Align2,
      Align3,
      Align4,
      Align5,
    ]
    type_info = TypeInfo(Ts, layout)
    for T in Ts
      @test getoffsets(type_info, T) == getoffsets(add_type_layouts!(ir_with_type(T), layout), T)
    end
  end

  @testset "Layout extraction from Julia types" begin
    @test payload_sizes(Align5) == [8, 8, 1, 4, 1]
    @test getoffsets(Align3) == [0, 8, 12]
    @test getoffsets(Align4) == [0, 8, 16]
    # FIXME: These offsets are wrong, as they assume 8-byte pointers for non-`isbits` elements.
    @test_broken getoffsets(Align5) == [0, 8, 16, 18, 22]
    @test getstride(Vector{WeirdType}) == 4
  end

  @testset "Serializing and deserializing Julia values" begin
    function test_reinterpret_noalign(x)
      bytes = extract_bytes(x)
      @test length(bytes) == payload_size(x)
      @test reinterpret_spirv(typeof(x), bytes) == x
    end
    test_reinterpret_noalign(Vec(1, 2))
    test_reinterpret_noalign([Vec(1, 2), Vec(3, 4)])
    # FIXME: Non-`isbits` types are not supported for `Arr`.
    # test_reinterpret_noalign(Arr(Vec(1, 2), Vec(3, 4)))
  end
end;
