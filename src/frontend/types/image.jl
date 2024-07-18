"""
SPIR-V image type.

Type parameters:
- `Format`: SPIR-V `ImageFormat` enumerated value.
- `Dim`: SPIR-V `Dim` enumerated value.
- `Depth`: 64-bit integer with value 0 (not a depth image), 1 (depth image) or 2 (unknown).
- `Arrayed`: `Bool` indicating whether the image is a layer of an image array.
- `MS`: `Bool` indicating whether the image is multisampled.
- `Sampled`: 64-bit integer with value 0 (unknown), 1 (may be sampled) or 2 (read-write, no sampling).

"""
struct Image{Format,Dim,Depth,Arrayed,MS,Sampled,T}
  data
end

image_type(format::ImageFormat, dim::SPIRV.Dim, depth::Integer, arrayed::Bool, multisampled::Bool, sampled::Integer) = Image{format, dim, depth, arrayed, multisampled, sampled, texel_type(format)}

"Alias to extract the type parameter with less verbosity."
const _Image{T} = Image{<:Any,<:Any,<:Any,<:Any,<:Any,<:Any,T}

Base.eltype(::Type{<:_Image{T}}) where {T} = T
dim(::Type{<:Image{<:Any,Dim}}) where {Dim} = Dim
depth(::Type{<:Image{<:Any,<:Any,Depth}}) where {Depth} = Depth
is_arrayed(::Type{<:Image{<:Any,<:Any,<:Any,Arrayed}}) where {Arrayed} = Arrayed
is_multisampled(::Type{<:Image{<:Any,<:Any,<:Any,<:Any,MS}}) where {MS} = MS
sample_mode(::Type{<:Image{<:Any,<:Any,<:Any,<:Any,<:Any,Sampled}}) where {Sampled} = Sampled
format(::Type{<:Image{Format}}) where {Format} = Format

is_depth(T::Type{<:Image}) = depth(T) == 2 ? nothing : Bool(depth(T))
is_sampled(T::Type{<:Image}) = sample_mode(T) == 0 ? nothing : Bool(2 - sample_mode(T))

"Read the texel at coordinate `coord` from a one-dimensional image using zero-based indexing."
Base.getindex(img::Image, coord::BitInteger) = ImageRead(img, coord)
"Read the texel at the provided coordinates from an image using zero-based indexing."
Base.getindex(img::Image, coord::BitInteger, coord2::BitInteger, coords::BitInteger...) = getindex(img, Vec(coord, coord2, coords...))
"Read the texel at the coordinates given by `coord` from an image using zero-based indexing."
Base.getindex(img::Image, coords::Vec) = ImageRead(img, coords)

"Read the texel at coordinate `coord` from a one-dimensional image using zero-based indexing."
Base.setindex!(img::Image, value, coord::BitInteger) = ImageWrite(img, coord, value)
"Read the texel at the provided coordinates from an image using zero-based indexing."
Base.setindex!(img::Image, value, coord::BitInteger, coord2::BitInteger, coords::BitInteger...) = setindex!(img, value, Vec(coord, coord2, coords...))
"Read the texel at the coordinates given by `coord` from an image using zero-based indexing."
Base.setindex!(img::_Image{T}, value::T, coords::Vec{<:Any,UInt32}) where {T} = ImageWrite(img, coords, value)
Base.setindex!(img::_Image{T}, value::T, coords::Vec{N,<:Signed}) where {N,T} = setindex!(img, value, convert(Vec{N,UInt32}, coords))
Base.setindex!(img::_Image{T}, value, coords::Vec) where {T} = setindex!(img, convert(T, value), coords)

Base.size(image::Image) = ImageQuerySize(image)
Base.size(image::Image, lod::UInt32) = ImageQuerySizeLod(image, lod)
Base.size(image::Image, lod::Integer) = size(image, convert(UInt32, lod))
Base.length(image::Image) = foldl(*, size(image))

@noinline ImageQuerySize(image::Image{<:Any,Dim2D})::Vec2U = Vec2U(size(image.data)...)
@noinline ImageQuerySize(image::Image{<:Any,Dim3D})::Vec{3,UInt32} = Vec{3,UInt32}(size(image.data)...)

@noinline ImageQuerySizeLod(image::Image{<:Any,Dim2D}, lod)::Vec2U = Vec2U(size(image.data)...)
@noinline ImageQuerySizeLod(image::Image{<:Any,Dim3D}, lod)::Vec{3,UInt32} = Vec{3,UInt32}(size(image.data)...)

@noinline function ImageRead(img::Image{<:Any,<:Any,<:Any,<:Any,<:Any,<:Any,T}, coord::Union{Vec{<:Any,<:BitInteger},BitInteger})::T where {T}
  isa(coord, Integer) && return img.data[coord]
  img.data[CartesianIndex(coord...)]
end
ImageRead(img::Image, coords::Vec{N,<:Union{UInt64,Int64}}) where {N} = ImageRead(img, UInt32.(coords))

@noinline function ImageWrite(img::_Image{T}, coord::Union{Vec{<:Any,<:BitInteger},BitInteger}, texel::T) where {T}
  if isa(coord, Integer)
    img.data[coord] = texel
  else
    img.data[CartesianIndex(coord...)] = texel
  end
  nothing
end

@nospecialize

texel_type(format::ImageFormat) = @match format begin
  &ImageFormatRgba32f ||
  &ImageFormatRgba16f ||
  &ImageFormatRgba16 ||
  &ImageFormatRgba16Snorm ||
  &ImageFormatRgb10A2 ||
  &ImageFormatRgba8 ||
  &ImageFormatRgba8Snorm ||
  &ImageFormatRgba32i ||
  &ImageFormatRgba16i ||
  &ImageFormatRgba8i ||
  &ImageFormatRgba32ui ||
  &ImageFormatRgba16ui ||
  &ImageFormatRgb10a2ui ||
  &ImageFormatRgba8ui => Vec{4, component_type(format)}

  &ImageFormatR11fG11fB10f => Vec{3, component_type(format)}
  
  &ImageFormatRg32f ||
  &ImageFormatRg16f ||
  &ImageFormatRg16 ||
  &ImageFormatRg16Snorm ||
  &ImageFormatRg8 ||
  &ImageFormatRg8Snorm ||
  &ImageFormatRg32i ||
  &ImageFormatRg16i ||
  &ImageFormatRg8i ||
  &ImageFormatRg32ui ||
  &ImageFormatRg16ui ||
  &ImageFormatRg8ui => Vec{2, component_type(format)}
 
  &ImageFormatR32f ||
  &ImageFormatR16f ||
  &ImageFormatR16 ||
  &ImageFormatR16Snorm ||
  &ImageFormatR8 ||
  &ImageFormatR8Snorm ||
  &ImageFormatR32i ||
  &ImageFormatR16i ||
  &ImageFormatR8i ||
  &ImageFormatR32ui ||
  &ImageFormatR16ui ||
  &ImageFormatR8ui ||
  &ImageFormatR64i ||
  &ImageFormatR64ui => component_type(format)
end

texel_type(T::Type{<:Image}) = texel_type(format(T))
texel_type(img::Image) = texel_type(typeof(img))

component_type(format::ImageFormat) = @match format begin
  &ImageFormatRgba32f ||
  &ImageFormatRg32f ||
  &ImageFormatR32f ||
  &ImageFormatRgba16f ||
  &ImageFormatRg16f ||
  &ImageFormatR16f ||
  &ImageFormatRgba16 ||
  &ImageFormatRg16 ||
  &ImageFormatR16 ||
  &ImageFormatRgba16Snorm ||
  &ImageFormatRg16Snorm ||
  &ImageFormatR16Snorm ||
  &ImageFormatRgb10A2 ||
  &ImageFormatR11fG11fB10f ||
  &ImageFormatRgba8 ||
  &ImageFormatRg8 ||
  &ImageFormatR8 ||
  &ImageFormatRgba8Snorm ||
  &ImageFormatRg8Snorm ||
  &ImageFormatR8Snorm => Float32

  &ImageFormatRgba32i ||
  &ImageFormatRg32i ||
  &ImageFormatR32i ||
  &ImageFormatRgba16i ||
  &ImageFormatRg16i ||
  &ImageFormatR16i ||
  &ImageFormatRgba8i ||
  &ImageFormatRg8i ||
  &ImageFormatR8i => Int32

  &ImageFormatRgba32ui ||
  &ImageFormatRg32ui ||
  &ImageFormatR32ui ||
  &ImageFormatRgba16ui ||
  &ImageFormatRg16ui ||
  &ImageFormatR16ui ||
  &ImageFormatRgb10a2ui ||
  &ImageFormatRgba8ui ||
  &ImageFormatRg8ui ||
  &ImageFormatR8ui => UInt32

  &ImageFormatR64i => Int64
  &ImageFormatR64ui => UInt64
end

component_type(T::Type{<:Image}) = component_type(format(T))
component_type(img::Image) = component_type(typeof(img))

@specialize

struct Sampler end

struct SampledImage{I<:Image}
  image::I
end

combine(image::Image, sampler::Sampler) = SampledImage(image, sampler)
@noinline SampledImage(image::Image, sampler::Sampler) = SampledImage(image)
@noinline Image(sampled::SampledImage) = sampled.image

image_type(T::Type{SampledImage{I}}) where {I} = I
sampled_type(T::Type{<:SampledImage}) = Vec{4, component_type(image_type(T))}

image_type(img::SampledImage) = image_type(typeof(img))
sampled_type(img::SampledImage) = sampled_type(typeof(img))

convert_truncate(::Type{SampledImage{I}}, value) where {I} = convert_truncate(texel_type(I), value)
convert_truncate(::Type{T}, value::T) where {T<:Vec} = value
convert_truncate(::Type{Vec{N,T}}, value::Vec{N}) where {N,T} = convert(Vec{N,T}, value)
convert_truncate(::Type{Vec{N,T}}, value::Vec{M}) where {N,M,T} = convert_truncate(Vec{N,T}, Vec(ntuple_uint32(i -> value[i], N)))

(img::SampledImage)(coord::IEEEFloat) = convert_truncate(typeof(img), ImageSampleImplicitLod(img, coord))
(img::SampledImage)(coord::IEEEFloat, coord2::IEEEFloat, coords::IEEEFloat...) = img(Vec(coord, coord2, coords...))
(img::SampledImage)(coords::Vec{<:Any,<:IEEEFloat}) = convert_truncate(typeof(img), ImageSampleImplicitLod(img, coords))
(img::SampledImage)(coords::Vec{<:Any,<:IEEEFloat}, lod) = convert_truncate(typeof(img), ImageSampleExplicitLod(img, coords, ImageOperandsLod, lod))
(img::SampledImage)(coords::V, dx::V, dy::V) where {V<:Vec{<:Any,<:IEEEFloat}} = convert_truncate(typeof(img), ImageSampleExplicitLod(img, coords, ImageOperandsGrad, dx, dy))

function dummy_sample(img::SampledImage)
  T = sampled_type(img)
  (Base.@invokelatest zero(T::Type{T}))::T
end

@noinline ImageSampleImplicitLod(img::SampledImage, coord) = dummy_sample(img)
@noinline ImageSampleExplicitLod(img::SampledImage, coord, lod_operand::SPIRV.ImageOperands, lod::Number) = dummy_sample(img)
@noinline ImageSampleExplicitLod(img::SampledImage, coord, grad_operand::SPIRV.ImageOperands, dx, dy) = dummy_sample(img)

@noinline DPdx(p) = p
@noinline DPdy(p) = p
@noinline Fwidth(p) = p

@noinline DPdxCoarse(p) = p
@noinline DPdyCoarse(p) = p
@noinline FwidthCoarse(p) = p

@noinline DPdxFine(p) = p
@noinline DPdyFine(p) = p
@noinline FwidthFine(p) = p
