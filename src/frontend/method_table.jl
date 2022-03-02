struct NOverlayMethodTable <: Core.Compiler.MethodTableView
  world::UInt
  tables::Vector{Core.MethodTable}
end

@static if VERSION ≥ v"1.8-beta1"
  Core.Compiler.isoverlayed(::NOverlayMethodTable) = true
end

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
