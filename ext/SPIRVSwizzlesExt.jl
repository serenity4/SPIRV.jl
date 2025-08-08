module SPIRVSwizzlesExt

using Swizzles
import Swizzles: swizzle, swizzle!
using SPIRV
using StaticArrays

@generated function swizzle!(mut::Mutable{T}, value, indices...) where {T<:StaticVector}
  insertions = Expr[]
  for i in eachindex(indices)
    push!(insertions, :(val = SPIRV.CompositeInsert(value[$(UInt32(i))], val, UInt32(indices[$i]))))
  end
  quote
    val = mut[]
    $(insertions...)
    mut[] = val
  end
end

swizzle(mut::Mutable, indices...) = swizzle(mut[], indices...)

end # module
