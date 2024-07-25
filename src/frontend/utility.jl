### Utility functions.

const Scalar = Union{Bool,BitInteger,IEEEFloat}

eachindex_uint32(x) = firstindex_uint32(x):lastindex_uint32(x)
firstindex_uint32(x) = UInt32(firstindex(x))
lastindex_uint32(x) = UInt32(lastindex(x))
firstindex_uint32(::Type{<:SVector}) = 1U
lastindex_uint32(::Type{<:SVector{N}}) where {N} = UInt32(N)

unsigned_index(x::Integer) = convert(UInt32, x)

# Extracted from Base.
"""
Similar to `ntuple`, except that `f` is provided with a 0-based `UInt32` index instead of a 1-based `Int64` index.
"""
@inline function ntuple_uint32(f::F, n::Integer) where F
  t = n == 0  ? () :
      n == 1  ? (f(1U),) :
      n == 2  ? (f(1U), f(2U)) :
      n == 3  ? (f(1U), f(2U), f(3U)) :
      n == 4  ? (f(1U), f(2U), f(3U), f(4U)) :
      n == 5  ? (f(1U), f(2U), f(3U), f(4U), f(5U)) :
      n == 6  ? (f(1U), f(2U), f(3U), f(4U), f(5U), f(6U)) :
      n == 7  ? (f(1U), f(2U), f(3U), f(4U), f(5U), f(6U), f(7U)) :
      n == 8  ? (f(1U), f(2U), f(3U), f(4U), f(5U), f(6U), f(7U), f(8U)) :
      n == 9  ? (f(1U), f(2U), f(3U), f(4U), f(5U), f(6U), f(7U), f(8U), f(9U)) :
      n == 10 ? (f(1U), f(2U), f(3U), f(4U), f(5U), f(6U), f(7U), f(8U), f(9U), f(10U)) :
      _ntuple_uint32(f, n)
  return t
end

@noinline function _ntuple_uint32(f::F, n) where F
  (n >= 0) || throw(ArgumentError(LazyString("tuple length should be ≥ 0, got ", n)))
  ([f(unsigned_index(i)) for i in 1:n]...,)
end

macro _for(ex, body)
  @when :(in($x, $y)) = ex begin
    ex = Expr(:(=), x, y)
  end
  @trymatch ex begin
    :($(x::Symbol) = $(iterable::Expr)) => begin
      @trymatch iterable begin
        Expr(:call, :(:), _...) || Expr(:(::), iterable, :Range) => return for_loop_range(esc(x), body, iterable)
      end
    end
    Expr(:block) && if count(x -> isa(x, Expr), ex.args) == 3 end => for_loop_cstyle(filter(x -> isa(x, Expr), ex.args), body)
  end
  Expr(:for, esc(ex), esc(body))
end

var"@for" = var"@_for"

walk(ex::Expr, inner, outer) = outer(Meta.isexpr(ex, :$) ? ex.args[1] : Expr(ex.head, map(inner, ex.args)...))
walk(ex, inner, outer) = outer(ex)

postwalk(f, ex) = walk(ex, x -> postwalk(f, x), f)
prewalk(f, ex) = walk(f(ex), x -> prewalk(f, x), identity)

function for_loop_range(i, body, iterable)
  pre = quote
    range = $(esc(iterable))
    start = first(range)
    stop = last(range)
    increment = step(range)
    $i = convert(typeof(increment), start)
    sgn = ifelse(increment > zero(increment), Int32(1), -Int32(1))
  end
  cond = :(with_sign($i, sgn) ≤ with_margin(with_sign(stop, sgn), increment))
  post = :($i += increment)
  body = esc(body)
  for_loop_cstyle((pre, cond, post), body; escape = false)
end

function for_loop_cstyle((pre, cond, post), body; escape = true)
  body_block, continue_block, merge_block = gensym.((:body_block, :continue_block, :merge_block))
  lbody, lcont, lmerge = esc.(Expr.(:symboliclabel, (body_block, continue_block, merge_block)))
  body = postwalk(body) do ex
    Meta.isexpr(ex, :continue) && return :(@goto $continue_block)
    Meta.isexpr(ex, :break) && return :(@goto $merge_block)
    ex
  end
  _esc(ex) = escape ? esc(ex) : ex
  quote
    $(_esc(pre))
    while $(_esc(cond))
      $lbody
      $(_esc(body))
      $lcont
      $(_esc(post))
    end
    $lmerge
  end
end

with_margin(bound, increment::Integer) = bound
with_margin(bound, increment::AbstractFloat) = bound + 10eps(increment)
with_sign(i::Unsigned, sign::Int32) = Int32(i) * sign
with_sign(i, sign::Int32) = i * sign
