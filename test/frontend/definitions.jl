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

@testset "Definitions" begin
  image = SampledImage(IT(zeros(32, 32)))
  blur = GaussianBlur(1.0, 1.0)
  @test compute_blur(blur, image, 1U, zero(Vec2)) == zero(Vec3)
end
