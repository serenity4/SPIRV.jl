"""
Pointer that keeps its parent around to make sure its contents stay valid.

Used to represent the mutability of data structures in the type domain.
"""
struct Pointer{T}
  addr::Ptr{T}
  parent
end

function Pointer(ref::Ref{T}) where {T}
  Pointer(Base.unsafe_convert(Ptr{T}, ref), ref)
end

Base.:(==)(ptr1::Pointer, ptr2::Pointer) = PtrEqual(ptr1, ptr2)
@noinline PtrEqual(ptr1, ptr2) = ptr1.addr == ptr2.addr
Base.:(≠)(ptr1::Pointer, ptr2::Pointer) = PtrNotEqual(ptr1, ptr2)
@noinline PtrNotEqual(ptr1, ptr2) = ptr1.addr ≠ ptr2.addr

Base.setindex!(ptr::Pointer{T}, x::T) where {T} = (Store(ptr, x); x)
Base.setindex!(ptr::Pointer{T}, x) where {T} = Store(ptr, convert(T, x))
Base.eltype(::Type{Pointer{T}}) where {T} = T
Base.getindex(ptr::Pointer) = Load(ptr)
Base.getindex(ptr::Pointer, i::Integer, indices::Integer...) = Load(AccessChain(ptr, i, indices...))

@noinline Load(ptr::Pointer) = GC.@preserve ptr Base.unsafe_load(ptr.addr)

@inline AccessChain(v, i::Unsigned) = AccessChain(v, convert(UInt32, i))
@inline AccessChain(v, i::Signed, indices::Signed...) = AccessChain(v, UInt32(i - 1), UInt32.(indices .- 1)...)

@noinline function AccessChain(ptr::Pointer{T}, index::UInt32) where {T}
  new_addr = ptr.addr + index * sizeof(eltype(T))
  Pointer{eltype(T)}(new_addr, ptr.parent)
end

@noinline function AccessChain(ptr::Pointer{Tuple{T}}, i::UInt32, j::UInt32) where {T<:Vector}
  @assert i == 0
  AccessChain(Pointer{T}(ptr.addr, only(ptr.parent)), j)
end

@noinline function Store(ptr::Pointer{T}, x::T) where {T}
  GC.@preserve ptr Base.unsafe_store!(ptr.addr, x)
  nothing
end

Base.convert(::Type{Pointer{T}}, x::BitUnsigned) where {T} = ConvertUToPtr(x)
@noinline ConvertUToPtr(T::Type, x) = Pointer{T}(Base.reinterpret(Ptr{T}, x), x)
Pointer{T}(x::BitUnsigned) where {T} = ConvertUToPtr(T, x)
Pointer(T::Type, x::BitUnsigned) = Pointer{T}(x)
