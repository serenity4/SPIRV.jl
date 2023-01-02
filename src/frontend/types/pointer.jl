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

Pointer(ref::Ref{T}) where {T} = Pointer{T}(ref)
function Pointer{T}(ref::Ref{T}) where {T}
  Pointer(Base.unsafe_convert(Ptr{T}, ref), ref)
end
Pointer(x::T) where {T} = Pointer{T}(x)
function Pointer{T}(x::T) where {T}
  !ismutabletype(T) && return Pointer{T}(Ref(x))
  Pointer(Ptr{T}(pointer_from_objref(x)), x)
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

@noinline Load(ptr::Pointer{T}) where {T} = (ismutabletype(T) ? unsafe_pointer_to_objref(Ptr{Nothing}(ptr.addr)) : unsafe_load(ptr.addr))::T

@noinline function Store(ptr::Pointer{T}, x::T) where {T}
  GC.@preserve ptr unsafe_store!(ptr.addr, x)
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

@noinline function AccessChain(mut, offset::UInt32)
  @assert ismutable(mut)
  T = eltype(mut)
  @assert isconcretetype(T)
  @boundscheck 0 ≤ offset ≤ length(mut) - 1 || throw(BoundsError(mut, offset))
  # We need to retrieve a memory address directly pointing at the element at `mut.data[1 + offset]`.
  # Depending on whether elements are mutable objects or not, they may be themselves pointers and
  # we have to deal with the extra indirection.
  if !ismutabletype(T)
    # `T` is not mutable, therefore the contents of elements are stored inline in `mut`.
    # We can treat `mut` as a contiguous array of these contents.
    GC.@preserve mut begin
      addr = Ptr{T}(pointer_from_objref(mut))
      stride =  Base.elsize(Vector{T})
      Pointer(addr + offset * stride, mut)
    end
  else
    # `T` is mutable, so the contents of elements of `mut` are 8-byte pointers to other objects (`jl_value_t*`).
    # In that case, return the address of the individual object.
    mut_element = mut.data[1 + offset]
    addr = Ptr{T}(pointer_from_objref(mut_element))
    Pointer(addr, mut_element)
  end
end

AccessChain(v::AbstractVector, index::Signed) = AccessChain(v, UInt32(index) - 1U)
AccessChain(x, index::Integer, second_index::Integer) = AccessChain(AccessChain(x, index), second_index)
AccessChain(x, index::Integer, second_index::Integer, other_indices::Integer...) = AccessChain(AccessChain(x, index, second_index), other_indices...)

Base.copy(ptr::Pointer) = CopyMemory(ptr)
@noinline CopyMemory(ptr::Pointer{T}) where {T} = Pointer{T}(deepcopy(ptr[]))

function load_expr(address)
  Meta.isexpr(address, :(::)) || error("Type annotation required for the loaded element in expression $address")
  address, type = address.args
  index = nothing
  Meta.isexpr(address, :ref) ? ((address, index) = esc.(address.args)) : address = esc(address)
  type = esc(type)
  !isnothing(index) && (type = :(Vector{$type}))
  ex = Expr(:ref, :(Pointer{$type}($address)))
  !isnothing(index) && push!(ex.args, index)
  ex
end

"""
    @load address::T
    @load address[index]::T

Load a value of type `T`, either directly (if no index is specified) or at `index - 1` elements from `address`.
`address` should be a device address, i.e. a `UInt64` value representing the address of a physical storage buffer.
"""
macro load(address) load_expr(address) end
