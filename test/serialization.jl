using SPIRV, Test
using SPIRV: serialize, deserialize

recursive_equals(x::T, y::T) where {T} = isprimitivetype(T) ? x == y : all(recursive_equals(getproperty(x, name), getproperty(y, name)) for name in fieldnames(T))
recursive_equals(xs::T, ys::T) where {T<:Array} = all(recursive_equals(x, y) for (x, y) in zip(xs, ys))

function make_row_major(layout::VulkanLayout, T::Type{<:Mat})
  type = layout[T]
  layout.tmap[T] = matrix_type(type.matrix.eltype, type.matrix.n, false)
  layout
end

@testset "Serialization/deserialization" begin
  dataset = [
    (1, 2U),
    (3F, 6F),
    Align2(1, 2),
    (1, 2U, 3, (4U, 2F), 5F, 10, 11, 12),
    (1, Vec3(2, 3, 4)),
    Ref(Vec4(3, 4, 5, 6)),
    [1, 2, 3],
    [Vec3(1, 2, 7), Vec3(4, 6, 7)],
    Arr(Vec3(1, 2, 3), Vec3(4, 6, 5)),
    [Arr(4, 2), Arr(3, 6)],
    [Arr(0x04, 0x02), Arr(0x03, 0x06)],
    Align5(1, Align4(2, 3, Vec(4, 5)), 6),
    Align7(1, @mat Float32[1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16]),
    @mat(Float32[1 2; 3 4; 5 6]),
    @mat(Float32[1 2; 3 4; 5 6; 7 8; 9 10]),
    ((Ref((4F, 5F, 6F)), (Ref((7F, 8F, 9F)),)),),
    ((Vec3(4, 5, 6), (Vec3(7, 8, 9),)),),
    (1F, 2F, 3F, (Vec3(4, 5, 6), ((Vec3(7, 8, 9), Vec3(10, 11, 12)), 13F), Vec3(14, 15, 16))),
    [Align12((0.1, 0.2, 0.3), (0.4, 0.5, 0.6), 0.7, 0.8)],
  ]
  matrices = [
    [1 2; 3 4; 5 6],
  ]
  layouts = [
    NativeLayout(),
    NoPadding(),
    make_row_major(VulkanLayout(typeof.([dataset; matrices])), Mat23),
  ]
  for layout in layouts
    for data in dataset
      bytes = serialize(data, layout)
      @test isa(bytes, Vector{UInt8}) && !isempty(bytes)
      object = deserialize(typeof(data), bytes, layout)
      @test recursive_equals(object, data)
    end
    for data in matrices
      bytes = serialize(data, layout)
      @test isa(bytes, Vector{UInt8}) && !isempty(bytes)
      object = deserialize(typeof(data), bytes, layout, size(data))
      @test recursive_equals(object, data)
    end
  end

  # Julia values incompatible with shaders, but of interest in client APIs
  # e.g. for buffers or images.
  # These are not meant to be deserialized; they use dynamic sizes that are lost
  # in the serialization process.
  dataset = [[[1, 2], [3, 4], [5, 6]], [[1 2; 3 4], [5 6; 7 8]]]
  layouts = [NativeLayout(), NoPadding()]
  for layout in layouts
    for data in dataset
      n = datasize(layout, data)
      isa(n, Int)
      bytes = serialize(data, layout)
      @test isa(bytes, Vector{UInt8}) && !isempty(bytes)
      @test length(bytes) == n
    end
  end
end;
