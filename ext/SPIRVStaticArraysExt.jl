module SPIRVStaticArraysExt

using SPIRV
using StaticArrays

for N in 2:4
  @eval Base.convert(::Type{Vec{$N,T}}, x::SVector{$N}) where {T} = Vec{$N,T}(x.data)
  @eval Base.convert(::Type{<:SVector{$N,T}}, x::Vec{$N}) where {T} = SVector{$N,T}(x.data)
  @eval Base.convert(::Type{Vec{$N}}, x::SVector{$N}) = Vec(x.data)
  @eval Base.convert(::Type{<:SVector{$N}}, x::Vec{$N}) = SVector{$N}(x.data)
  for M in 2:4
    @eval Base.convert(::Type{Mat{$N,$M,T}}, x::SMatrix{$N,$M}) where {T} = Mat{$N,$M,T}(Vec{$N,T}.(ntuple(i -> x.data[1 + (i-1)*$N:i*$N], $M))...)
    @eval Base.convert(::Type{<:SMatrix{$N,$M,T}}, x::Mat{$N,$M}) where {T} = SMatrix{$N,$M,T}(x.data)
    @eval Base.convert(::Type{Mat{$N,$M}}, x::SMatrix{$N,$M}) = Mat(Vec.(ntuple(i -> x.data[1 + (i-1)*$N:i*$N], $M))...)
    @eval Base.convert(::Type{<:SMatrix{$N,$M}}, x::Mat{$N,$M}) = SMatrix{$N,$M}(x.data)
  end
end

Base.convert(::Type{Arr{N,T}}, x::SVector{N}) where {N,T} = Arr{N,T}(x.data)
Base.convert(::Type{<:SVector{N,T}}, x::Arr{N}) where {N,T} = SVector{N,T}(x.data)
Base.convert(::Type{Arr{N}}, x::SVector{N}) where {N} = Arr(x.data)
Base.convert(::Type{<:SVector{N}}, x::Arr{N}) where {N} = SVector{N}(x.data)

end
