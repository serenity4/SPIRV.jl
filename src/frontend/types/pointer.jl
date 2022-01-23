"""
Pointer that keeps its parent around to make sure its contents stay valid.

Used to represent the mutability of data structures in the type domain.
"""
struct Pointer{T}
  addr::Ptr{T}
  parent
end

"Reconstruct a pointer from a memory address."
Pointer{T}(x::UInt) where {T} = convert(Pointer{T}, x)
Base.convert(::Type{Pointer{T}}, x::UInt) where {T} = ConvertUToPtr(T, x)
@noinline ConvertUToPtr(T::Type, x) = Pointer{T}(Base.reinterpret(Ptr{T}, x), x)

function Pointer(ref::Ref{T}) where {T}
  Pointer(Base.unsafe_convert(Ptr{T}, ref), ref)
end

Base.setindex!(ptr::Pointer{T}, x::T) where {T} = (Store(ptr, x); x)
Base.setindex!(ptr::Pointer{T}, x) where {T} = Store(ptr, convert(T, x))
Base.eltype(::Type{Pointer{T}}) where {T} = T
Base.getindex(ptr::Pointer) = Load(ptr)
Base.getindex(ptr::Pointer, i::Integer, indices::Integer...) = Load(AccessChain(ptr, i, indices...))

Base.:(==)(ptr1::Pointer, ptr2::Pointer) = isequal(ptr1, ptr2)
Base.isequal(ptr1::Pointer, ptr2::Pointer) = PtrEqual(ptr1, ptr2)
@noinline PtrEqual(ptr1, ptr2) = ptr1.addr == ptr2.addr
Base.:(≠)(ptr1::Pointer, ptr2::Pointer) = PtrNotEqual(ptr1, ptr2)
@noinline PtrNotEqual(ptr1, ptr2) = ptr1.addr ≠ ptr2.addr

@noinline Load(ptr::Pointer) = GC.@preserve ptr Base.unsafe_load(ptr.addr)

@noinline function Store(ptr::Pointer{T}, x::T) where {T}
  GC.@preserve ptr Base.unsafe_store!(ptr.addr, x)
  nothing
end

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

"""
    AccessChain(v, index)

Get a [`Pointer`](@ref) to `v` using an indexing scheme that depends on the signedness of `index`:
- An unsigned index will use 0-based indexing.
- A signed index will use 1-based indexing, but will be explicitly converted to an 0-based unsigned index.

"""
function AccessChain end

@noinline function AccessChain(mut, index::UInt32)
  @assert ismutable(mut)
  T = eltype(mut)
  # Make sure `isbitstype(T)` holds if executing that on the CPU.
  # @assert isbitstype(T)
  @boundscheck 0 ≤ index ≤ length(mut) - 1 || throw(BoundsError(mut, index))
  GC.@preserve mut begin
    addr = Base.unsafe_convert(Ptr{T}, pointer_from_objref(mut))
    Pointer(addr + index * sizeof(T), mut)
  end
end

AccessChain(v::AbstractVector, index::Signed) = AccessChain(v, UInt32(index) - 1U)
AccessChain(x, index::Integer, second_index::Integer) = AccessChain(AccessChain(x, index), second_index)
AccessChain(x, index::Integer, second_index::Integer, other_indices::Integer...) = AccessChain(AccessChain(x, index, second_index), other_indices...)
