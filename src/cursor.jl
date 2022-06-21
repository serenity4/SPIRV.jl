abstract type AbstractCursor{I,T} end

Base.eltype(::AbstractCursor{<:Any,T}) where {T} = T
Base.position(::AbstractCursor) = error("Not implemented")
Base.seek(::AbstractCursor{I}, ::I) where {I} = error("Not implemented")
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

function write!(cursor::AbstractCursor, x, y, z...)
  for arg in (x, y, z...)
    write!(cursor, arg)
  end
end

Base.seekstart(::AbstractCursor) = error("Not implemented")
Base.seekend(::AbstractCursor) = error("Not implemented")

function Base.reset(c::AbstractCursor)
  seek(c, prev_mark(c))
  unmark(c)
  position(c)
end

mutable struct ArrayCursor{T,A<:AbstractArray{T}} <: AbstractCursor{Int,T}
  index::Int
  array::A
  marks::Vector{Int}
end

ArrayCursor(array::AbstractArray, index = firstindex(array)) = ArrayCursor(index, array, Int[])

Base.position(cursor::ArrayCursor) = cursor.index

function Base.seek(cursor::ArrayCursor, index::Integer)
  firstindex(cursor.array) ≤ index ≤ 1 + lastindex(cursor.array) || error("Seek outside the cursor range (seek index: ", index, ", cursor range: ", firstindex(cursor.array), ':', 1 + lastindex(cursor.array), ')')
  cursor.index = index
end

Base.seekstart(cursor::ArrayCursor) = seek(cursor, firstindex(cursor.array))
Base.seekend(cursor::ArrayCursor) = seek(cursor, lastindex(cursor.array) + 1)

Base.peek(cursor::ArrayCursor) = cursor.array[cursor.index]

function Base.read(cursor::ArrayCursor)
  cursor.index > lastindex(cursor.array) && error("Reached end of cursor.")
  val = peek(cursor)
  seek(cursor, position(cursor) + 1)
  val
end

Base.read(cursor::ArrayCursor{<:AbstractArray{T}}, ::Type{T}) where {T} = read(cursor)
Base.read(cursor::ArrayCursor, T::Type) = error("ArrayCursor only supports reading values whose type is the same as the element type of its internal array.")

function Base.mark(cursor::ArrayCursor)
  !isempty(cursor.marks) && last(cursor.marks) == position(cursor) && return true
  push!(cursor.marks, position(cursor))
  false
end

function Base.unmark(cursor::ArrayCursor; all = false)
  marked = !isempty(cursor.marks)
  !marked && return false
  all ? empty!(cursor.marks) : pop!(cursor.marks)
  true
end

function prev_mark(cursor::ArrayCursor)
  isempty(cursor.marks) && error("The cursor is not marked.")
  last(cursor.marks)
end

function Base.skip(cursor::ArrayCursor, offset::Integer)
  seek(cursor, position(cursor) + offset)
  nothing
end

function write!(cursor::ArrayCursor, x)
  position(cursor) > lastindex(cursor.array) && return insert!(cursor, x)
  cursor.array[cursor.index] = convert(eltype(cursor), x)
  skip(cursor, 1)
end

function Base.insert!(cursor::ArrayCursor, value, values...)
  iter = (value, values...)
  for val in reverse(iter)
    insert!(cursor.array, cursor.index, val)
  end
  skip(cursor, length(iter))
end

function Base.delete!(cursor::ArrayCursor)
  position(cursor) > lastindex(cursor.array) && return
  deleteat!(cursor.array, cursor.index)
  seek(cursor, min(position(cursor), lastindex(cursor.array) + 1))
  nothing
end
