"""
Library of mathematical functions mainly intended for GPU execution through SPIR-V.

These functions are implemented in such a way that they are compileable to efficient GPU code.
This means, among other things, that no error handling will be performed; exceptions are not
supported in SPIR-V.
"""
module MathFunctions

using ..SPIRV: AbstractSPIRVArray, U, F

import LinearAlgebra: norm, normalize

export lerp, slerp_2d, angle_2d, rotate_2d, normalize, distance2, distance, norm, compute_roots, saturated_softmax, linearstep, smoothstep, smootherstep, remap

lerp(x, y, t) = x .* t .+ (1 .- t)y

# from https://en.wikipedia.org/wiki/Slerp
function slerp_2d(x, y, t)
  θ = angle_2d(x, y)
  wx = sin((1 - t)θ)
  wy = sin(t * θ)
  normalize(x * wx + y * wy)
end

# from https://stackoverflow.com/questions/21483999/using-atan2-to-find-angle-between-two-vectors
function angle_2d(x, y)
  θ = atan(y[2], y[1]) - atan(x[2], x[1])
  θ % 2(π)F
end

function rotate_2d(v, angle)
  cv = v.x + v.y * im
  crot = cos(angle) + sin(angle) * im
  cv′ = cv * crot
  typeof(v)(real(cv′), imag(cv′))
end

normalize(x::AbstractSPIRVArray) = ifelse(iszero(x), x, x / norm(x))
norm(x::AbstractSPIRVArray) = distance(x, zero(x))

distance2(x, y) = sum(x -> x^2, y - x)
distance(x, y) = sqrt(distance2(x, y))

function compute_roots(a, b, c)
  if isapprox(a, zero(a), atol = 1e-7)
    t₁ = t₂ = c / 2b
    return (t₁, t₂)
  end
  Δ = b^2 - a * c
  T = typeof(a)
  Δ < 0 && return (T(NaN), T(NaN))
  δ = sqrt(Δ)
  t₁ = (b - δ) / a
  t₂ = (b + δ) / a
  (t₁, t₂)
end

"""
Remap a value from `(low1, high1)` to `(low2, high2)`.
"""
function remap(value, low1, high1, low2, high2)
  low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

function linearstep(min, max, value)
  value < min && return zero(value)
  value ≥ max && return one(value)
  remap(value, min, max, zero(value), one(value))
end

"""
    smoothstep(min, max, value)

Has null 1-derivative at `min` and `max`.
"""
function smoothstep(min, max, value)
  value < min && return zero(value)
  value ≥ max && return one(value)
  x = remap(value, min, max, zero(value), one(value))
  x^2 * (3 - 2x)
end

"""
    smootherstep(min, max, value)

Has null 1- and 2-derivatives at `min` and `max`.
"""
function smootherstep(min, max, value)
  value < min && return zero(value)
  value ≥ max && return one(value)
  x = remap(value, min, max, zero(value), one(value))
  x^3 * (x * (6x - 15) + 10)
end

end
