# Base.getproperty(::Vec, ::Symbol)
# =================================

it = zip((:x, :y, :z, :w), (:r, :g, :b, :a))

for (i, (pos, color)) in enumerate(it)
  println(:((prop === $(QuoteNode(pos)) || prop === $(QuoteNode(color))) && return CompositeExtract(v, $i * U)))
  for (j, (pos2, color2)) in enumerate(it)
    i == j && continue
    pos_combined = Symbol(pos, pos2)
    color_combined = Symbol(color, color2)
    println(:((prop === $(QuoteNode(pos_combined)) || prop === $(QuoteNode(color_combined))) && return VectorShuffle(v, v, $i * U, $j * U)))
    for (k, (pos3, color3)) in enumerate(it)
      (k == j || k == i) && continue
      pos_combined2 = Symbol(pos, pos2, pos3)
      color_combined2 = Symbol(color, color2, color3)
      println(:((prop === $(QuoteNode(pos_combined2)) || prop === $(QuoteNode(color_combined2))) && return VectorShuffle(v, v, $i * U, $j * U, $k * U)))
      for (l, (pos4, color4)) in enumerate(it)
        (l == k || l == i || l == j) && continue
        pos_combined3 = Symbol(pos, pos2, pos3, pos4)
        color_combined3 = Symbol(color, color2, color3, color4)
        println(:((prop === $(QuoteNode(pos_combined3)) || prop === $(QuoteNode(color_combined3))) && return VectorShuffle(v, v, $i * U, $j * U, $k * U, $l * U)))
      end
    end
  end
end

# Base.setproperty!(::Vec, ::Symbol)
# =================================

for (i, (pos, color)) in enumerate(it)
  println(:((prop === $(QuoteNode(pos)) || prop === $(QuoteNode(color))) && return setindex!(v, val, $i * U)))
  for (j, (pos2, color2)) in enumerate(it)
    i == j && continue
    pos_combined = Symbol(pos, pos2)
    color_combined = Symbol(color, color2)
    println(:((prop === $(QuoteNode(pos_combined)) || prop === $(QuoteNode(color_combined))) && return setslice!(v, val, $i * U, $j * U)))
    for (k, (pos3, color3)) in enumerate(it)
      (k == j || k == i) && continue
      pos_combined2 = Symbol(pos, pos2, pos3)
      color_combined2 = Symbol(color, color2, color3)
      println(:((prop === $(QuoteNode(pos_combined2)) || prop === $(QuoteNode(color_combined2))) && return setslice!(v, val, $i * U, $j * U, $k * U)))
      for (l, (pos4, color4)) in enumerate(it)
        (l == k || l == i || l == j) && continue
        pos_combined3 = Symbol(pos, pos2, pos3, pos4)
        color_combined3 = Symbol(color, color2, color3, color4)
        println(:((prop === $(QuoteNode(pos_combined3)) || prop === $(QuoteNode(color_combined3))) && return setslice!(v, val, $i * U, $j * U, $k * U, $l * U)))
      end
    end
  end
end
