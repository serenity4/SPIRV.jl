struct NOverlayMethodTable <: Core.Compiler.MethodTableView
  world::UInt
  tables::Vector{Core.MethodTable}
end

CC.isoverlayed(::NOverlayMethodTable) = true

function CC.findall(@nospecialize(sig::Type), table::NOverlayMethodTable; limit::Int = -1)
  results = find_matching_methods(sig, table, limit, find_including_ambiguous)
  limit_exceeded(results) && return results
  results = first.(results) # drop the overlay level information
  matches = foldl((x, y) -> append!(x, y.matches), results; init = CC.MethodMatch[])
  # XXX: Figure out if ambiguity persists after discarding unconsequential ambiguities.
  world = reduce((x, y) -> intersect_world_ranges(x, y.valid_worlds), results; init = WorldRange(typemin(UInt), typemax(UInt)))
  ambig = any(x -> x.ambig, results)
  overlayed = any(x -> any(y -> isoverlayed(y.method), x.matches), results)
  CC.MethodMatchResult(CC.MethodLookupResult(matches, world, ambig), overlayed)
end

@static if VERSION ≥ v"1.10.0-DEV.67"
  limit_exceeded(result) = result === CC.nothing
else
  limit_exceeded(result) = result === CC.missing
end

function find_matching_methods(@nospecialize(sig::Type), table::NOverlayMethodTable, limit::Int, find::F) where {F}
  results = Pair{CC.MethodLookupResult, Int}[]
  for (level, mt) in enumerate([table.tables; nothing])
    result = find(sig, mt, table.world, limit)
    @static if VERSION ≥ v"1.10.0-DEV.67"
      result === CC.nothing && return CC.nothing
    else
      result === CC.missing && return CC.missing
    end
    if result.valid_worlds.min_world ≤ table.world ≤ result.valid_worlds.max_world
      push!(results, result => level)
    end
  end
  results
end

find_excluding_ambiguous(@nospecialize(sig::Type), mt::Union{Nothing,Core.MethodTable}, world::UInt, limit::Int) = CC._findall(sig, mt, world, limit)

function find_including_ambiguous(@nospecialize(sig::Type), mt::Union{Nothing,Core.MethodTable}, world::UInt, limit::Int)
  min_world = Ref(typemin(UInt))
  max_world = Ref(typemax(UInt))
  ambig = Ref(Int32(0))
  ms = Base._methods_by_ftype(sig, mt, limit, world, true, min_world, max_world, ambig)
  return CC.MethodLookupResult(ms, WorldRange(min_world[], max_world[]), ambig[] != 0)
end

intersect_world_ranges(x::WorldRange, y::WorldRange) = WorldRange(max(x.min_world, y.min_world), min(x.max_world, y.max_world))

isoverlayed(x::Method) = isdefined(x, :external_mt)

method_lookup_result(res::CC.MethodMatchResult) = res.matches

struct OverlayMethodMatch
  match::CC.MethodMatch
  level::Int
  world::WorldRange
end

function overlay_method_matches(results)
  matches = OverlayMethodMatch[]
  for (result, level) in results
    for match in result.matches
      push!(matches, OverlayMethodMatch(match, level, result.valid_worlds))
    end
  end
  matches
end

function is_more_specific(x::Method, y::Method)
  (@ccall jl_type_morespecific(x.sig::Any, y.sig::Any)::Bool) && return true
  (@ccall jl_type_morespecific(y.sig::Any, x.sig::Any)::Bool) && return false
  nothing
end

function most_specific_match(x::OverlayMethodMatch, y::OverlayMethodMatch)
  @something(is_more_specific(x.match.method, y.match.method), x.level < y.level)
end

function select_matching_method(results)
  #=

  First, gather results of all lookups.
  There may be ambiguous matches on a given table, and results down the overlay stack may be more specific than all other overlays.

  In case of ambiguity across overlay levels, the top-most overlay wins.
  Ambiguity will be triggered only if ambiguous methods are more specific than all others.
  Otherwise, the ambiguity will be ignored.

  =#
  matches = overlay_method_matches(results)
  isempty(matches) && return nothing
  sort!(matches, lt = most_specific_match)
  length(matches) == 1 && return matches[1]
  is_more_specific(matches[1].match.method, matches[2].match.method) === true && return matches[1]
  matches[1].level < matches[2].level && return matches[1]
  nothing
end

function CC.findsup(@nospecialize(sig::Type), table::NOverlayMethodTable)
  results = find_matching_methods(sig, table, -1, find_excluding_ambiguous)
  limit_exceeded(results) && return results
  isempty(results) && return (CC.nothing, WorldRange(typemin(UInt), typemax(UInt)), false)
  match = select_matching_method(results)
  isnothing(match) && return (CC.nothing, WorldRange(typemin(UInt), typemax(UInt)), false)
  (match.match, match.world, match.level < maxoverlay(table))
end

maxoverlay(table::NOverlayMethodTable) = length(table.tables) + 1
