struct NOverlayMethodTable <: Core.Compiler.MethodTableView
  world::UInt
  tables::Vector{Core.MethodTable}
end

CC.isoverlayed(::NOverlayMethodTable) = true

function CC.findall(@nospecialize(sig::Type), table::NOverlayMethodTable; limit::Int = Int(typemax(Int32)))
  matches = []
  min_world = typemin(UInt)
  max_world = typemax(UInt)
  ambig = false
  for mt in [table.tables; nothing]
    result = CC._findall(sig, mt, table.world, limit)
    @static if VERSION ≥ v"1.10.0-DEV.67"
      result === CC.nothing && return CC.nothing
    else
      result === CC.missing && return CC.missing
    end
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
      return findall_result(CC.MethodLookupResult([matches; result.matches], WorldRange(min_world, max_world), ambig), !isempty(matches))
    end
    append!(matches, result.matches)
  end
end

findall_result(matches::Core.Compiler.MethodLookupResult, isoverlayed::Bool) = Core.Compiler.MethodMatchResult(matches, isoverlayed)
method_lookup_result(res::Core.Compiler.MethodMatchResult) = res.matches

function CC.findsup(@nospecialize(sig::Type), table::NOverlayMethodTable)
  min_world = typemin(UInt)
  max_world = typemax(UInt)
  for mt in table.tables
    match, valid_worlds = CC._findsup(sig, mt, table.world)
    min_world = max(min_world, valid_worlds.min_world)
    max_world = min(max_world, valid_worlds.max_world)
    !isnothing(match) && return match, WorldRange(min_world, max_world), true
  end
  match, valid_worlds = CC._findsup(sig, nothing, table.world)
  min_world = max(min_world, valid_worlds.min_world)
  max_world = min(max_world, valid_worlds.max_world)
  match, WorldRange(min_world, max_world), true
end
