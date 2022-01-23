"""
SPIR-V image type.

Type parameters:
- `Dim`: SPIR-V `Dim` enumerated value.
- `Depth`: 64-bit integer with value 0 (not a depth image), 1 (depth image) or 2 (unknown).
- `Arrayed`: `Bool` indicating whether the image is a layer of an image array.
- `MS`: `Bool` indicating whether the image is multisampled.
- `Sampled`: 64-bit integer with value 0 (unknown), 1 (may be sampled) or 2 (read-write, no sampling).
- `Format`: SPIR-V `ImageFormat` enumerated value.

"""
struct Image{T,Dim,Depth,Arrayed,MS,Sampled,Format}
  data
end

Base.eltype(::Type{<:Image{T}}) where {T} = T
dim(::Type{<:Image{<:Any,Dim}}) where {Dim} = Dim
depth(::Type{<:Image{<:Any,<:Any,Depth}}) where {Depth} = Depth
is_arrayed(::Type{<:Image{<:Any,<:Any,<:Any,Arrayed}}) where {Arrayed} = Arrayed
is_multisampled(::Type{<:Image{<:Any,<:Any,<:Any,<:Any,MS}}) where {MS} = MS
sample_mode(::Type{<:Image{<:Any,<:Any,<:Any,<:Any,<:Any,Sampled}}) where {Sampled} = Sampled
format(::Type{<:Image{<:Any,<:Any,<:Any,<:Any,<:Any,<:Any,Format}}) where {Format} = Format

is_depth(T::Type{<:Image}) = depth(T) == 2 ? nothing : Bool(depth(T))
is_sampled(T::Type{<:Image}) = sample_mode(T) == 0 ? nothing : Bool(2 - sample_mode(T))

Base.getindex(img::Image, coord::Scalar) = ImageRead(img, coord)
Base.getindex(img::Image, coord::Scalar, coord2::Scalar, coords::Scalar...) = getindex(img, Vec(coord, coord2, coords...))
Base.getindex(img::Image, coords::Vec) = ImageRead(img, coords)

#TODO: Support ImageRead and ImageWrite
# @noinline function ImageRead(img::Image, coord::Union{Vec,Scalar})
#   #TODO: Figure out return type from image format.
#   zero(???)
# end

struct Sampler end

struct SampledImage{I<:Image}
  image::I
end

combine(image::Image, sampler::Sampler) = SampledImage(image, sampler)
@noinline SampledImage(image::Image, sampler::Sampler) = SampledImage(image)
@noinline Image(sampled::SampledImage) = sampled.image

image_type(T::Type{SampledImage{I}}) where {I} = I
sampled_type(T::Type{<:SampledImage}) = Vec{4, eltype(T)}

Base.eltype(::Type{<:SampledImage{<:Image{T}}}) where {T} = T

sampled_type(img::SampledImage) = sampled_type(typeof(img))

(img::SampledImage)(coord::IEEEFloat) = ImageSampleImplicitLod(img, coord)
(img::SampledImage)(coord::IEEEFloat, coord2::IEEEFloat, coords::IEEEFloat...) = img(Vec(coord, coord2, coords...))
(img::SampledImage)(coords::Vec{<:Any,<:IEEEFloat}) = ImageSampleImplicitLod(img, coords)

@noinline function ImageSampleImplicitLod(img::SampledImage, coord)
  zero(sampled_type(img))
end
