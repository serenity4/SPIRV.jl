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
        return result
      end
    else
      return CC.MethodLookupResult([matches; result.matches], WorldRange(min_world, max_world), ambig)
    end
    append!(matches, result.matches)
  end
end

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
