struct NOverlayMethodTable <: Core.Compiler.MethodTableView
  world::UInt
  tables::Vector{Core.MethodTable}
end

if VERSION ≥ v"1.8.0-beta1"
  Core.Compiler.isoverlayed(::NOverlayMethodTable) = true
end

@static if VERSION < v"1.8"
  function Core.Compiler.findall(@nospecialize(sig::Type), table::NOverlayMethodTable; limit::Int = typemax(Int))
    min_val = Ref(typemin(UInt))
    max_val = Ref(typemax(UInt))
    ambig = Ref{Int32}(0)
    ms = []
    for mt in [table.tables; nothing]
      min_val[] = typemin(UInt)
      max_val[] = typemax(UInt)
      ms = Base._methods_by_ftype(sig, mt, limit, table.world, false, min_val, max_val, ambig)
      # @assert ms !== false "Internal error in method lookup (sig: $sig)"
      ms === false && return Core.Compiler.missing
      # ms === false && return missing
      !isempty(ms) && return Core.Compiler.MethodLookupResult(ms::Vector{Any}, WorldRange(min_val[], max_val[]), ambig[] != 0)
    end
    Core.Compiler.MethodLookupResult(ms::Vector{Any}, WorldRange(min_val[], max_val[]), ambig[] != 0)
  end
  method_lookup_result(res::Core.Compiler.MethodLookupResult) = res
elseif VERSION == v"1.8"
  findall_result(matches::Core.Compiler.MethodLookupResult, isoverlayed::Bool) = (matches, isoverlayed)
  method_lookup_result(res::Tuple{Core.Compiler.MethodLookupResult,Bool}) = first(res)
else
  findall_result(matches::Core.Compiler.MethodLookupResult, isoverlayed::Bool) = Core.Compiler.MethodMatchResult(matches, isoverlayed)
  method_lookup_result(res::Core.Compiler.MethodMatchResult) = res.matches
end

@static if VERSION ≥ v"1.8"
  function Core.Compiler.findall(@nospecialize(sig::Type), table::NOverlayMethodTable; limit::Int = Int(typemax(Int32)))
    matches = []
    min_world = typemin(UInt)
    max_world = typemax(UInt)
    ambig = false
    for mt in [table.tables; nothing]
      result = Core.Compiler._findall(sig, mt, table.world, limit)
      result === Core.Compiler.missing && return Core.Compiler.missing
      min_world = max(min_world, result.valid_worlds.min_world)
      max_world = min(max_world, result.valid_worlds.max_world)
      ambig |= result.ambig
      if !isnothing(mt)
        nr = length(result.matches)
        if nr ≥ 1 && result.matches[nr].fully_covers
          # no need to fall back to the internal method table
          return findall_result(result, true)
        end
      else
        return findall_result(Core.Compiler.MethodLookupResult([matches; result.matches], WorldRange(min_world, max_world), ambig), !isempty(matches))
      end
      append!(matches, result.matches)
    end
  end

  function Core.Compiler.findsup(@nospecialize(sig::Type), table::NOverlayMethodTable)
    min_world = typemin(UInt)
    max_world = typemax(UInt)
    for mt in table.tables
      match, valid_worlds = Core.Compiler._findsup(sig, mt, table.world)
      min_world = max(min_world, valid_worlds.min_world)
      max_world = min(max_world, valid_worlds.max_world)
      !isnothing(match) && return match, WorldRange(min_world, max_world), true
    end
    match, valid_worlds = Core.Compiler._findsup(sig, nothing, table.world)
    min_world = max(min_world, valid_worlds.min_world)
    max_world = min(max_world, valid_worlds.max_world)
    match, WorldRange(min_world, max_world), true
  end
end
