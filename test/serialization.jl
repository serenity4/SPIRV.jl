using SPIRV, Test
using SPIRV: serialize, deserialize

recursive_equals(x::T, y::T) where {T} = isprimitivetype(T) ? x == y : all(recursive_equals(getproperty(x, name), getproperty(y, name)) for name in fieldnames(T))

function make_row_major(layout::VulkanLayout, T::Type{<:Mat})
  T = Mat{2,5,Float32}
  t = layout.tmap[T]
  layout.tmap[T] = MatrixType(t.eltype, t.n, false)
  layout
end

@testset "Serialization/deserialization" begin
  dataset = [
    (1, 2U),
    (1, Vec3(2, 3, 4)),
    Ref(Vec4(3, 4, 5, 6)),
    [1, 2, 3],
    [Vec3(1, 2, 7), Vec3(4, 6, 7)],
    Arr(Vec3(1, 2, 3), Vec3(4, 6, 5)),
    [Arr(4, 2), Arr(3, 6)],
    [Arr(0x04, 0x02), Arr(0x03, 0x06)],
    Align5(1, Align4(2, 3, Vec(4, 5)), 6),
    Align7(1, Mat4(Vec4(1, 2, 3, 4), Vec4(5, 6, 7, 8), Vec4(9, 10, 11, 12), Vec4(13, 14, 15, 16))),
    Mat{2,3,Float32}(Vec2(1, 2), Vec2(3, 4), Vec2(5, 6)),
    Mat{2,5,Float32}(Vec2(1, 2), Vec2(3, 4), Vec2(5, 6), Vec2(7, 8), Vec2(9, 10)),
  ]
  layouts = [
    NativeLayout(),
    NoPadding(),
    make_row_major(VulkanLayout(typeof.(dataset)), Mat{2,5,Float32}),
  ]
  for layout in layouts
    for data in dataset
      bytes = serialize(data, layout)
      @test isa(bytes, Vector{UInt8}) && !isempty(bytes)
      object = deserialize(typeof(data), bytes, layout)
      @test recursive_equals(object, data)
    end
  end
end
