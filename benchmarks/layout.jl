using SPIRV
using SPIRV: datasize
using BenchmarkTools: @btime

layout = NativeLayout()

M = Base.RefValue{Tuple{Float32, Float32, Float32}}
@btime datasize($layout, $(Tuple{M,Int64}))
@btime datasize($layout, $(Tuple{Tuple{M, Int64}, Int64}))
@btime dataoffset($layout, $(Tuple{M,Int64}), 2)

layout = VulkanLayout([M, Tuple{M,Int64}, Tuple{Tuple{M, Int64}, Int64}, Vector{Tuple{M,Int64}}])
@btime datasize($layout, $(Tuple{M,Int64}))
@btime datasize($layout, $(Tuple{Tuple{M, Int64}, Int64}))
@btime dataoffset($layout, $(Tuple{M,Int64}), 2)
@btime stride($layout, $(Vector{Tuple{M,Int64}}))
