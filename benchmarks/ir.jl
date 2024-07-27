using BenchmarkTools
using SPIRV
using SPIRV: optimize
using .MathFunctions

struct GaussianBlur
  scale::Float32
  strength::Float32
end

function compute_blur(blur::GaussianBlur, reference, direction, uv)
  weights = @arr Float32[0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216]
  tex_offset = 1.0 ./ size(Image(reference), 0) .* blur.scale
  res = zero(Vec4)
  for i in eachindex(weights)
    vec = direction == 1U ? Vec2(tex_offset.x * i, 0.0) : Vec2(0.0, tex_offset.y * i)
    res += reference(uv .+ vec) .* weights[i] .* blur.strength
    res += reference(uv .- vec) .* weights[i] .* blur.strength
  end
  res
end

IT = SampledImage{SPIRV.image_type(SPIRV.ImageFormatRgba16f,SPIRV.Dim2D,0,false,false,1)}

# Optimizing shaders via `spirv-opt`.

shader = @fragment ((res, blur, reference, direction, uv) -> res[] =
        compute_blur(blur, reference, direction, uv))(::Mutable{Vec4}::Output, ::GaussianBlur::PushConstant, ::IT::UniformConstant{@DescriptorSet(0), @Binding(0)}, ::UInt32::Input{@Flat}, ::Vec2::Input)
@assert unwrap(validate(shader))

@btime unwrap(optimize($shader))
@profview for _ in 1:300; unwrap(optimize(shader)); end

# Parsing SPIR-V modules.

bytes = assemble(shader)
SPIRV.Module(bytes); @profview for _ in 1:10000; SPIRV.Module(bytes); end
@btime SPIRV.Module($bytes)

# Compiling shaders.

function _shader!(res, blur, reference, direction, uv)
  res[] = compute_blur(blur, reference, direction, uv)
end

@btime @fragment _shader!(::Mutable{Vec4}::Output, ::GaussianBlur::PushConstant, ::IT::UniformConstant{@DescriptorSet(0), @Binding(0)}, ::UInt32::Input{@Flat}, ::Vec2::Input)

@profview for _ in 1:1000; @fragment _shader!(::Mutable{Vec4}::Output, ::GaussianBlur::PushConstant, ::IT::UniformConstant{@DescriptorSet(0), @Binding(0)}, ::UInt32::Input{@Flat}, ::Vec2::Input); end

# Call a function to @descend into with Cthulhu.

using Cthulhu

target = @target _shader!(::Mutable{Vec4}, ::GaussianBlur, ::IT, ::UInt32, ::Vec2)
@descend compile(target, AllSupported())
