Base.size(::BooleanType) = error("SPIR-V booleans have no physical size.")
Base.size(T::Union{IntegerType,FloatType}) = T.width
Base.size(T::ArrayType) = size(T.eltype) * prod(T.size.value...)

scalar_alignment(T::ScalarType) = size(T)
scalar_alignment(T::Union{VectorType,MatrixType,ArrayType}) = size(T.eltype)
scalar_alignment(T::StructType) = maximum(size.(T.members))

base_alignment(T::ScalarType) = scalar_alignment(T)
base_alignment(T::VectorType) = 2 * div(1 + T.n, 2) * scalar_alignment(T.eltype)
base_alignment(T::ArrayType) = scalar_alignment(T.eltype)
function base_alignment(T::StructType)
  if isempty(T)
    # Requires knowing the smallest scalar type permitted
    # by the storage class & module capalibities.
    error("Not implemented.")
  else
    maximum(base_alignment.(T.members))
  end
end
base_alignment(T::MatrixType) = error("Not implemented.") # Requires knowing whether T is row- or column- major.

extended_alignment(T::SPIRType) = base_alignment(T)
extended_alignment(T::Union{ArrayType,StructType}) = 16 * cld(base_alignment(T), 16)
