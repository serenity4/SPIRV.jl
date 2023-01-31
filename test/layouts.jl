using SPIRV, Test, Dictionaries
using SPIRV: emit!, spir_type, PointerType, add_type_layouts!, StorageClass, StorageClassStorageBuffer, StorageClassUniform, StorageClassPhysicalStorageBuffer, StorageClassPushConstant, DecorationBlock, TypeInfo, TypeMetadata, metadata!
using SPIRV: datasize, alignment, stride, dataoffset, isinterface

function test_has_offset(tmeta, T, field, offset)
  decs = decorations(tmeta, tmeta.tmap[T], field)
  @test has_decoration(decs, SPIRV.DecorationOffset)
  @test decs.offset == offset
end

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

align_types = [Align1, Align2, Align3, Align4, Align5, Align6, Align7]
alltypes = [align_types; WeirdType]
layout = VulkanLayout(align_types)

@testset "Structure layouts" begin
  @testset "Layout types" begin
    for layout in [NoPadding(), NativeLayout(), ExplicitLayout(NativeLayout(), alltypes), layout]
      for T in align_types
        @test alignment(layout, T) ≥ 0
        @test datasize(layout, T) ≥ 0
        @test stride(layout, T) ≥ 0
        if isstructtype(T)
          @test all(dataoffset(layout, T, i) ≥ 0 for i in 1:fieldcount(T))
        end
      end
    end
  end
  @testset "Alignments" begin
    tmeta = TypeMetadata([Align1])
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align1, 1, 0)
    test_has_offset(tmeta, Align1, 2, 8)

    tmeta = TypeMetadata([Align2])
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align2, 1, 0)
    test_has_offset(tmeta, Align2, 2, 8)

    tmeta = TypeMetadata([Align3])
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align3, 1, 0)
    test_has_offset(tmeta, Align3, 2, 8)
    test_has_offset(tmeta, Align3, 3, 12)

    tmeta = TypeMetadata([Align4])
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align4, 1, 0)
    test_has_offset(tmeta, Align4, 2, 8)
    test_has_offset(tmeta, Align4, 3, 10)
    @test datasize(layout, Align4) == 14
    @test datasize(ShaderLayout(tmeta), Align4) == 14

    tmeta = TypeMetadata([Align5])
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align5, 1, 0)
    test_has_offset(tmeta, Align5, 2, 8)
    test_has_offset(tmeta, Align5, 3, 22)
    @test datasize(layout, Align5) == 23
    @test datasize(ShaderLayout(tmeta), Align5) == 23

    layout_with_storage_classes = VulkanLayout(align_types; storage_classes = Dict(Align4 => [StorageClassUniform]), interfaces = [Align4])
    tmeta = TypeMetadata(layout_with_storage_classes)
    @assert layout_with_storage_classes.tmap[Align4] === tmeta.tmap[Align4]
    @test isinterface(layout_with_storage_classes, tmeta.tmap[Align4])
    add_type_layouts!(tmeta, layout_with_storage_classes)
    test_has_offset(tmeta, Align5, 1, 0)
    test_has_offset(tmeta, Align5, 2, 16)
    test_has_offset(tmeta, Align5, 3, 30)
    @test datasize(layout_with_storage_classes, Align5) == 31
    @test datasize(ShaderLayout(tmeta), Align5) == 31

    tmeta = TypeMetadata([Align7])
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align7, 1, 0)
    test_has_offset(tmeta, Align7, 2, 16)
  end

  @testset "Array/Matrix layouts" begin
    T = Arr{4, Tuple{Float64, Float64}}
    tmeta = TypeMetadata([T])
    add_type_layouts!(tmeta, layout)
    decs = decorations(tmeta, tmeta.tmap[T])
    @test has_decoration(decs, SPIRV.DecorationArrayStride)
    @test decs.array_stride == 16

    T = Align7
    tmeta = TypeMetadata([T])
    add_type_layouts!(tmeta, layout)
    decs = decorations(tmeta, tmeta.tmap[T], 2)
    @test has_decoration(decs, SPIRV.DecorationMatrixStride)
    @test decs.matrix_stride == 16
  end
end;
