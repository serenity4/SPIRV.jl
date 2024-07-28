module SPIRVSwizzlesExt

using Swizzles
import Swizzles: swizzle, swizzle!
using SPIRV
using StaticArrays

@generated function swizzle!(mut::Mutable{T}, value, indices...) where {T<:StaticVector}
  body = quote
    val = mut[]
  end
  for i in eachindex(indices)
    push!(body.args, :(val = SPIRV.CompositeInsert(value[$(UInt32(i))], val, UInt32(indices[$i]))))
  end
  push!(body.args, :(mut[] = val))
  body
end

swizzle(mut::Mutable, indices...) = swizzle(mut[], indices...)

end # module
