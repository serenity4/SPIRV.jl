function f_straightcode(x)
  y = x + 1
  z = 3y
  z^2
end

function f_extinst(x)
  y = exp(x)
  z = 1 + 3sin(x)
  log(z) + y
end

struct GaussianBlur
  scale::Float32
  strength::Float32
end

function compute_blur(blur::GaussianBlur, reference, direction, uv)
  weights = Arr{Float32}(0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216)
  tex_offset = 1.0 ./ size(Image(reference), 0) .* blur.scale
  res = zero(Vec3)
  for i in eachindex(weights)
    vec = direction == 1U ? Vec2(tex_offset.x * i, 0.0) : Vec2(0.0, tex_offset.y * i)
    res .+= reference(uv .+ vec).rgb .* weights[i] .* blur.strength
    res .+= reference(uv .- vec).rgb .* weights[i] .* blur.strength
  end
  res
end

function compute_blur_2(blur::GaussianBlur, reference, uv)
  res = zero(Vec3)
  imsize = size(SPIRV.Image(reference), 0U)
  pixel_size = 1F ./ imsize # Size of one pixel in UV coordinates.
  radius = Int32.(ceil.(imsize .* 0.5F .* blur.scale))
  rx, ry = radius
  for i in -rx:rx
    for j in -ry:ry
      uv_offset = Vec(i, j) .* pixel_size
      weight = 0.25 .* rx .^ 2 .* ry .^ 2
      res .+= reference(uv .+ uv_offset).rgb .* weight
    end
  end
  res
end

distance2(x::Vec, y::Vec) = sum(x -> x^2, y - x)
distance(x::Vec, y::Vec) = sqrt(distance2(x, y))
norm(x::Vec) = distance(x, zero(x))
normalize(x::Vec) = ifelse(iszero(x), x, x / norm(x))

function angle_2d(x, y)
  θ = atan(y[2], y[1]) - atan(x[2], x[1])
  θ % 2(π)F
end

function slerp(x, y, t)
  θ = angle_2d(x, y)
  wx = sin((1 - t)θ)
  wy = sin(t * θ)
  normalize(x * wx + y * wy)
end
lerp(x, y, t) = x * t + (1 - t)y

IT = image_type(SPIRV.ImageFormatRgba16f, SPIRV.Dim2D, 0, false, false, 1)

@testset "Definitions" begin
  image = SampledImage(IT(zeros(32, 32)))
  blur = GaussianBlur(1.0, 1.0)
  @test compute_blur(blur, image, 1U, zero(Vec2)) == zero(Vec3)
  @test compute_blur_2(blur, image, zero(Vec2)) == zero(Vec3)
end;
