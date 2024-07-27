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
  # Evaluate nested `@for` loops first.
  body = expand_for_macros(body, __module__)
  @trymatch ex begin
    # One-dimensional loop `@for x in iterable ... end`.
    :($(x::Symbol) = $iterable) => return for_loop(esc(x), esc(body), esc(iterable)).ex
    # Multi-dimensional loops `@for x in iterable1, y in iterable2 ... end`.
    Expr(:tuple, iters...) => if all(iters) do iter
        isa(iter, Expr) || return false
        @trymatch iter begin
          :(in($(_::Symbol), $_)) || :($(_::Symbol) = $_) => true
          _ => false
        end
      end
      body = shield_continue_and_breaks(body)
      continue_target = Ref{Symbol}()
      merge_target = Ref{Symbol}()
      loop = foldr(iters; init = esc(body)) do iter, body
        x, iterable = @match iter begin
          :(in($x, $y)) => (x::Symbol, y)
          :($x = $y) => (x::Symbol, y)
        end
        loop = for_loop(esc(x), body, esc(iterable))
        continue_target[] = loop.continue_target
        merge_target[] = loop.merge_target
        loop.ex
      end
      return apply_outer_continue_and_breaks(loop, continue_target[], merge_target[])
    end
    # C-style loop `@for (i = 0; i < 10; i += 1)`
    Expr(:block) && if count(x -> isa(x, Expr), ex.args) == 3 end => return for_loop_cstyle(filter(x -> isa(x, Expr), ex.args), body)
    # XXX: Fallback to normal loop?
    _ => error("The provided `@for` loop was not recognized: `@for $ex $body`")
  end
end

function expand_for_macros(body, __module__)
  postwalk(body) do ex
    Meta.isexpr(ex, :macrocall) || return ex
    in(ex.args[1], (Symbol("@for"), Symbol("@_for"))) || return ex
    macroexpand(__module__, ex)
  end
end

var"@for" = var"@_for"

walk(ex::Expr, inner, outer) = outer(Meta.isexpr(ex, :$) ? ex.args[1] : Expr(ex.head, map(inner, ex.args)...))
walk(ex, inner, outer) = outer(ex)

postwalk(f, ex) = walk(ex, x -> postwalk(f, x), f)
prewalk(f, ex) = walk(f(ex), x -> prewalk(f, x), identity)

function shield_continue_and_breaks(body)
  postwalk(body) do ex
    Meta.isexpr(ex, :continue) && return @set ex.head = :continue_outer
    Meta.isexpr(ex, :break) && return @set ex.head = :break_outer
    ex
  end
end

function apply_outer_continue_and_breaks(body, continue_target, merge_target)
  postwalk(body) do ex
    Meta.isexpr(ex, :continue_outer) && return :(@goto $continue_target)
    Meta.isexpr(ex, :break_outer) && return :(@goto $merge_target)
    ex
  end
end

struct ForLoop
  ex::Expr
  continue_target::Symbol
  merge_target::Symbol
end

function for_loop(i, body, iterable)
  _iterable, _loop_data = gensym.((:iterable, :loop_data))
  pre = quote
    $_iterable = $iterable
    ($i, $_loop_data) = pre_loop($_iterable)
  end
  cond = :(cond_loop($_iterable, $i, $_loop_data))
  post = :($i = post_loop($_iterable, $i, $_loop_data))
  for_loop_cstyle((pre, cond, post), body; escape = false)
end

pre_loop(range::Base.UnitRange) = (first(range), last(range))
pre_loop(range::Base.OneTo) = (first(range), last(range))
function pre_loop(range::AbstractRange)
  start = first(range)
  stop = last(range)
  increment = step(range)
  i = convert(typeof(increment), start)
  sgn = ifelse(increment > zero(increment), Int32(1), -Int32(1))
  (i, (stop, increment, sgn))
end

cond_loop(::Base.UnitRange{<:AbstractFloat}, i, stop) = with_margin(stop, oneunit(i))
cond_loop(::Base.UnitRange{<:Integer}, i, stop) = i ≤ stop
cond_loop(::Base.OneTo, i, stop) = i ≤ stop
function cond_loop(::AbstractRange, i, (stop, increment, sgn))
  with_sign(i, sgn) ≤ with_margin(with_sign(stop, sgn), increment)
end

post_loop(::Base.UnitRange, i, _) = i + oneunit(i)
post_loop(::Base.OneTo, i, _) = i + oneunit(i)
function post_loop(::AbstractRange, i, (_, increment, _))
  i + increment
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
  loop = quote
    $(_esc(pre))
    while $(_esc(cond))
      $lbody
      $(_esc(body))
      $lcont
      $(_esc(post))
    end
    $lmerge
  end
  ForLoop(loop, continue_block, merge_block)
end

with_margin(bound, increment::Integer) = bound
with_margin(bound, increment::AbstractFloat) = bound + 10eps(increment)
with_sign(i::Unsigned, sign::Int32) = Int32(i) * sign
with_sign(i, sign::Int32) = i * sign
