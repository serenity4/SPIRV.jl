using StaticArrays

abstract type Sampler end

struct SamplerCPU{D}
    data::D
end

Base.getindex(s::SamplerCPU, index::SVector{2,Int32}) = s.data[index...]

function Base.getindex(::Sampler, index::SVector{2,Int32})::Float64 end

@noinline Base.getindex(::Sampler, index::SVector{2,Int})::Float64 = Ref{Float64}()[]

function f(x, sampler)
    intensity = sampler[x] * 2
    if intensity < 0.
        return 3.
    end
    clamp(intensity, 0., 1.)
end

code = first(first(code_typed(f, Tuple{SVector{2,Int32},SamplerCPU{SMatrix{4,4,Float64}}}, optimize=true)))
code = first(first(code_typed(f, Tuple{SVector{2,Int},Sampler}, optimize=false)))
code = first(first(code_typed(f, Tuple{SVector{2,Int},Sampler}, optimize=true)))

f(SVector{2,Int32}(1, 2), SamplerCPU(SMatrix{4,4,Float64}(ones(Float64, 4, 4))))
