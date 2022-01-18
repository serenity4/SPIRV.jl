@MethodTable VULKAN_METHOD_TABLE

macro override_vulkan(ex)
  esc(:(@overlay SPIRV.VULKAN_METHOD_TABLE @inline $ex))
end

@override_vulkan @noinline function ConvertUToPtr(T::Type{Tuple{_T}}, x) where {_T}
  x_wrapped = (x,)
  Pointer{T}(Base.reinterpret(Ptr{T}, x), x_wrapped)
end
@override_vulkan (@inline ConvertUToPtr(T::Type{<:Vector}, x) = ConvertUToPtr(Tuple{T}, x))

@override_vulkan getindex(ptr::Pointer{<:Tuple{Vector}}, i::UInt32) = Load(AccessChain(ptr, zero(UInt32), i))
@override_vulkan (@inline getindex(ptr::Pointer{<:Tuple{Vector}}, i::Signed) = ptr[UInt32(i - 1)])
