using .MathFunctions

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
  res = zero(Vec4)
  for i in eachindex(weights)
    vec = direction == 1U ? Vec2(tex_offset.x * i, 0.0) : Vec2(0.0, tex_offset.y * i)
    res .+= reference(uv .+ vec) .* weights[i] .* blur.strength
    res .+= reference(uv .- vec) .* weights[i] .* blur.strength
  end
  res
end

function compute_blur_2(blur::GaussianBlur, reference, uv)
  res = zero(Vec4)
  imsize = size(SPIRV.Image(reference), 0U)
  pixel_size = 1F ./ imsize # Size of one pixel in UV coordinates.
  radius = Int32.(ceil.(imsize .* 0.5F .* blur.scale))
  rx, ry = radius
  for i in -rx:rx
    for j in -ry:ry
      uv_offset = Vec(i, j) .* pixel_size
      weight = 0.25 .* rx .^ 2 .* ry .^ 2
      res .+= reference(uv .+ uv_offset) .* weight
    end
  end
  res
end

IT = image_type(SPIRV.ImageFormatRgba16f, SPIRV.Dim2D, 0, false, false, 1)

# from Lava.jl

!@isdefined(OUT_OF_SCENE) && (const OUT_OF_SCENE = Vec2(-1000, -1000))

struct BoidAgent
  position::Vec2
  velocity::Vec2 # facing direction is taken to be the normalized velocity
  mass::Float32
end

struct _BoidAgent
  position::SVector{2,Float32}
  velocity::SVector{2,Float32} # facing direction is taken to be the normalized velocity
  mass::Float32
end

function step_euler(agent::BoidAgent, forces::Vec2, Δt)
  (; position, velocity, mass) = agent

  position == OUT_OF_SCENE && return agent

  # Use a simple Euler integration scheme to get the next state.
  acceleration = forces / mass
  new_position = wrap_around(position + velocity * Δt)
  new_velocity = velocity + acceleration * Δt

  BoidAgent(new_position, new_velocity, mass)
end

wrap_around(position::Vec2) = Base.mod.(position .+ 1F, 2F) .- 1F

@testset "Definitions" begin
  image = SampledImage(IT(zeros(32, 32)))
  blur = GaussianBlur(1.0, 1.0)
  @test compute_blur(blur, image, 1U, zero(Vec2)) == zero(Vec4)
  @test compute_blur_2(blur, image, zero(Vec2)) == zero(Vec4)
  agent = BoidAgent(zero(Vec2), one(Vec2), 1.0)
  @test isa(step_euler(agent, rand(Vec2), rand(Float32)), BoidAgent)
end;
