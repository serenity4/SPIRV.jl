abstract type AbstractCursor{I,T} end

Base.eltype(::AbstractCursor{<:Any,T}) where {T} = T
Base.position(::AbstractCursor) = error("Not implemented")
Base.seek(::AbstractCursor{I}, ::I) where {I} = error("Not implemented")
Base.seekstart(::AbstractCursor) = error("Not implemented")
Base.seekend(::AbstractCursor) = error("Not implemented")
Base.skip(::AbstractCursor{I}, ::I) where {I} = error("Not implemented")
Base.peek(::AbstractCursor) where {I} = error("Not implemented")
Base.mark(::AbstractCursor) = error("Not implemented")
prev_mark(::AbstractCursor) = error("Not implemented")
Base.unmark(::AbstractCursor) = error("Not implemented")
Base.read(::AbstractCursor) = error("Not implemented")
Base.read(::AbstractCursor, ::Type) = error("Not implemented")
write!(::AbstractCursor, x) = error("Not implemented")
Base.insert!(::AbstractCursor, x) = error("Not implemented")
Base.delete!(::AbstractCursor) = error("Not implemented")
Base.eof(::AbstractCursor) = error("Not implemented")

function write!(c::AbstractCursor, x, y, z...)
  for arg in (x, y, z...)
    write!(c, arg)
  end
end

"""
Skip instructions while `f(c)` returns false.
Returns true if the end of file has not been reached (i.e. `f(c)` evaluated to true at some point).
"""
function skip_until(f, c::AbstractCursor)
  while !eof(c) && !f(c)
    skip(c, 1)
  end
  !eof(c)
end

function Base.reset(c::AbstractCursor)
  seek(c, prev_mark(c))
  unmark(c)
  position(c)
end

function read_prev(c::AbstractCursor)
  position(c) == 1 && error("Reached start of cursor.")
  seek(c, position(c) - 1)
  peek(c)
end

mutable struct ArrayCursor{T,A<:AbstractArray{T}} <: AbstractCursor{Int,T}
  index::Int
  array::A
  marks::Vector{Int}
end

ArrayCursor{T}(array::A, index = firstindex(array)) where {T,A<:AbstractArray{T}} = ArrayCursor{T,A}(index, array, Int[])
ArrayCursor(array::AbstractArray, index = firstindex(array)) = ArrayCursor{eltype(array)}(array, index)

Base.position(c::ArrayCursor) = c.index

function Base.seek(c::ArrayCursor, index::Integer)
  firstindex(c.array) ≤ index ≤ 1 + lastindex(c.array) || error("Seek outside the cursor range (seek index: ", index, ", cursor range: ", firstindex(cursor.array), ':', 1 + lastindex(c.array), ')')
  c.index = index
end

Base.seekstart(c::ArrayCursor) = seek(c, firstindex(c.array))
Base.seekend(c::ArrayCursor) = seek(c, lastindex(c.array) + 1)

Base.peek(c::ArrayCursor) = c.array[c.index]

function Base.read(c::ArrayCursor)
  !eof(c) || error("Reached end of cursor.")
  val = peek(c)
  seek(c, position(c) + 1)
  val
end

Base.read(c::ArrayCursor{<:AbstractArray{T}}, ::Type{T}) where {T} = read(c)
Base.read(c::ArrayCursor, T::Type) = error("ArrayCursor only supports reading values whose type is the same as the element type of its internal array.")

function Base.mark(c::ArrayCursor)
  !isempty(c.marks) && last(c.marks) == position(c) && return true
  push!(c.marks, position(c))
  false
end

function Base.unmark(c::ArrayCursor; all = false)
  marked = !isempty(c.marks)
  !marked && return false
  all ? empty!(c.marks) : pop!(c.marks)
  true
end

function prev_mark(c::ArrayCursor)
  isempty(c.marks) && error("The cursor is not marked.")
  last(c.marks)
end

function Base.skip(c::ArrayCursor, offset::Integer)
  seek(c, position(c) + offset)
  nothing
end

function write!(c::ArrayCursor, x)
  eof(c) && return insert!(c, x)
  c.array[c.index] = convert(eltype(c), x)
  skip(c, 1)
end

function Base.insert!(c::ArrayCursor, value, values...)
  iter = (value, values...)
  for val in reverse(iter)
    insert!(c.array, c.index, val)
  end
  skip(c, length(iter))
end

function Base.delete!(c::ArrayCursor)
  position(c) > lastindex(c.array) && return
  deleteat!(c.array, c.index)
  seek(c, min(position(c), lastindex(c.array) + 1))
  nothing
end

Base.eof(c::ArrayCursor) = position(c) > lastindex(c.array)
