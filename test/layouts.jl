using SPIRV, Test, Dictionaries
using SPIRV: emit!, spir_type, add_type_layouts!, StorageClass, StorageClassStorageBuffer, StorageClassUniform, StorageClassPhysicalStorageBuffer, StorageClassPushConstant, DecorationBlock, TypeMetadata, metadata!
using SPIRV: datasize, alignment, element_stride, stride, dataoffset, isinterface, padding

function test_has_offset(tmeta, T, field, offset)
  decs = decorations(tmeta, tmeta[T], field)
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

struct Align8
  x::Int64
  y::Float32
  z::Vec3
end

struct Align9
  x::Vec3
  y::Tuple{Vec3,Vec3,Float32}
  z::Vec3
end

struct Plane
  u::Vec3
  v::Vec3
end

struct Rotation
  plane::Plane
  angle::Float32
end

struct Transform
  translation::Vec3
  rotation::Rotation
  scaling::Vec3
end

struct Camera
  focal_length::Float32
  near_clipping_plane::Float32
  far_clipping_plane::Float32
  transform::Transform
end

struct Align10
  vertex_locations::UInt64
  vertex_data::UInt64
  primitive_data::UInt64
  primitive_indices::UInt64
  instance_data::UInt64
  user_data::UInt64
  camera::Camera
  aspect_ratio::Float32
end

struct Align11
  x::Tuple{Vec3}
  y::Float32
end

struct Align12
  position::Vec3
  color::Vec3
  intensity::Float32
  attenuation::Float32
end

struct Align13
  range::UnitRange{UInt32}
  font_size::Float32
  color::Vec4
end

primitive type WeirdType 24 end
WeirdType(bytes = [0x01, 0x02, 0x03]) = reinterpret(WeirdType, bytes)[]

align_types = [Align1, Align2, Align3, Align4, Align5, Align6, Align7, Align8, Align9, Align10, Align11, Align12, Align13]
alltypes = [align_types; WeirdType]
layout = VulkanLayout(align_types)

@testset "Structure layouts" begin
  @testset "Layout types" begin
    for layout in [NoPadding(), NativeLayout(), ExplicitLayout(NativeLayout(), align_types), layout]
      for T in align_types
        @test @inferred(alignment(layout, T)) ≥ 0
        @test @inferred(datasize(layout, T)) ≥ 0
        @test @inferred(element_stride(layout, T)) ≥ 0
        if !isa(layout, ExplicitLayout)
          @test @inferred(stride(layout, Vector{T})) ≥ 0
        end
        if isstructtype(T)
          @test all(@inferred(dataoffset(layout, T, i)) ≥ 0 for i in 1:fieldcount(T))
        end
      end
    end

    @testset "Native layout" begin
      layout = NativeLayout()
      M = Base.RefValue{Tuple{Float32, Float32, Float32}}
      @test ismutabletype(M)
      @test @inferred(datasize(layout, M)) == 12
      @test @inferred(datasize(layout, Tuple{M})) == 12
      @test @inferred(datasize(layout, Tuple{Tuple{M}})) == 12
      @test @inferred(datasize(layout, Tuple{M,Int64})) == 20
      # XXX: Don't use `@inferred`; return type seems to be Any on CI machines
      # (for unknown reasons, perhaps related to CPU architecture differences).
      @test datasize(layout, Tuple{Tuple{M,Int64},Int64}) == 28

      @test datasize(layout, Align12) == 32
      @test stride(layout, Vector{Align12}) == datasize(layout, Align12)
      @test datasize(layout, [Align12((0.1, 0.2, 0.3), (0.4, 0.5, 0.6), 0.7, 0.8)]) == 32

      data = [rand(32, 32) for _ in 1:6]
      @test_throws "Array dimensions must be provided" datasize(layout, Matrix{Float64})
      @test @inferred(datasize(layout, data[1])) == 32*32*8
      @test_throws "Array dimensions must be provided" datasize(layout, Tuple(data))
      @test @inferred(datasize(layout, data)) == 6datasize(layout, data[1])

      data = Vec3[(1, 2, 3), (4, 5, 6)]
      @test @inferred(padding(layout, data)) == 0
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
    test_has_offset(tmeta, Align5, 3, 24)
    @test datasize(layout, Align5) == 25
    @test datasize(ShaderLayout(tmeta), Align5) == 25

    layout_with_storage_classes = VulkanLayout(align_types; storage_classes = Dict(Align4 => [StorageClassUniform]), interfaces = [Align4])
    tmeta = TypeMetadata(layout_with_storage_classes)
    @assert layout_with_storage_classes[Align4] === tmeta[Align4]
    @test isinterface(layout_with_storage_classes, tmeta[Align4])
    add_type_layouts!(tmeta, layout_with_storage_classes)
    test_has_offset(tmeta, Align5, 1, 0)
    test_has_offset(tmeta, Align5, 2, 16)
    test_has_offset(tmeta, Align5, 3, 32)
    @test datasize(layout_with_storage_classes, Align5) == 33
    @test datasize(ShaderLayout(tmeta), Align5) == 33

    tmeta = TypeMetadata([Align7])
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align7, 1, 0)
    test_has_offset(tmeta, Align7, 2, 16)

    # Avoid improper straddling.
    tmeta = TypeMetadata([Align8])
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align8, 1, 0)
    test_has_offset(tmeta, Align8, 2, 8)
    test_has_offset(tmeta, Align8, 3, 16)

    tmeta = TypeMetadata([Align9])
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align9, 1, 0)
    test_has_offset(tmeta, Align9, 2, 16)
    test_has_offset(tmeta, Align9, 3, 48)

    tmeta = TypeMetadata([Align10])
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Plane, 1, 0)
    test_has_offset(tmeta, Plane, 2, 16)
    test_has_offset(tmeta, Rotation, 1, 0)
    test_has_offset(tmeta, Rotation, 2, 32)
    test_has_offset(tmeta, Transform, 1, 0)
    test_has_offset(tmeta, Transform, 2, 16)
    test_has_offset(tmeta, Transform, 3, 64)
    test_has_offset(tmeta, Camera, 1, 0)
    test_has_offset(tmeta, Camera, 2, 4)
    test_has_offset(tmeta, Camera, 3, 8)
    test_has_offset(tmeta, Camera, 4, 16)
    test_has_offset(tmeta, Align10, 1, 0)
    test_has_offset(tmeta, Align10, 2, 8)
    test_has_offset(tmeta, Align10, 3, 16)
    test_has_offset(tmeta, Align10, 4, 24)
    test_has_offset(tmeta, Align10, 5, 32)
    test_has_offset(tmeta, Align10, 6, 40)
    test_has_offset(tmeta, Align10, 7, 48)
    test_has_offset(tmeta, Align10, 8, 144)

    # Don't allow offsets in-between the end of a structure and its next multiple alignment,
    # where the structure for `Align11` is `Tuple{Vec3}` taking up 12 bytes but with an alignment of 16 bytes.
    tmeta = TypeMetadata([Align11])
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align11, 1, 0)
    test_has_offset(tmeta, Align11, 2, 16)

    tmeta = TypeMetadata([Align13])
    add_type_layouts!(tmeta, layout)
    test_has_offset(tmeta, Align13, 1, 0)
    test_has_offset(tmeta, Align13, 2, 8)
    test_has_offset(tmeta, Align13, 3, 16)
  end

  @testset "Array/Matrix layouts" begin
    T = Arr{4, Tuple{Float64, Float64}}
    tmeta = TypeMetadata([T])
    add_type_layouts!(tmeta, layout)
    decs = decorations(tmeta, tmeta[T])
    @test has_decoration(decs, SPIRV.DecorationArrayStride)
    @test decs.array_stride == 16

    T = Arr{4, Vec3}
    tmeta = TypeMetadata([T])
    add_type_layouts!(tmeta, layout)
    decs = decorations(tmeta, tmeta[T])
    @test has_decoration(decs, SPIRV.DecorationArrayStride)
    @test decs.array_stride == 16

    T = Align7
    tmeta = TypeMetadata([T])
    add_type_layouts!(tmeta, layout)
    decs = decorations(tmeta, tmeta[T], 2)
    @test has_decoration(decs, SPIRV.DecorationMatrixStride)
    @test decs.matrix_stride == 16
  end

  @testset "Merging Vulkan layouts" begin
    x = VulkanLayout([Int64])
    y = VulkanLayout([Align1, Align3]; interfaces = [Align1])
    z = merge!(x, y)
    @test z[Int64] == x[Int64]
    @test z[Align1] == y[Align1]
    @test z.interfaces == [z[Align1]]
  end
end;
