using BenchmarkTools
using Cthulhu

layout = NoPadding()
layout = NativeLayout()
# layout = make_row_major(VulkanLayout(typeof.(dataset)), Mat{2,5,Float32})

dataset = [
  [Arr(4, 2), Arr(3, 6)],
  Align2(1, 2),
  (1, 2U, 3, (4U, 2F), 5F, 10, 11, 12),
  Align5(1, Align4(2, 3, Vec(4, 5)), 6),
  Align7(1, Mat4(Vec4(1, 2, 3, 4), Vec4(5, 6, 7, 8), Vec4(9, 10, 11, 12), Vec4(13, 14, 15, 16))),
]

data = dataset[end]
@time serialize(data, layout)
@btime serialize($data, $layout)

# @descend serialize(data, layout)

@profview for i in 1:100000; serialize(data, layout); end

for data in dataset
  @btime serialize($data, $layout)
end
