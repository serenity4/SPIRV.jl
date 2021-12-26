"""
Cache in which `CodeInstance`s are put to memoize the results of inference.

This cache is meant to be used with a `WorldView` to discard `CodeInstances`s
that are not applicable to the world age within which the cache is used.
"""
struct CodeInstanceCache
    dict::Dict{MethodInstance,Vector{CodeInstance}}
end
CodeInstanceCache() = CodeInstanceCache(Dict())

Base.show(io::IO, cache::CodeInstanceCache) = print(io, "CodeInstanceCache($(sum(length, values(cache.dict))) code instances for $(length(cache.dict)) method instances)")

Core.Compiler.WorldView(cache::CodeInstanceCache, mi::MethodInstance) = WorldView(cache, Core.Compiler.WorldRange(mi.def.primary_world, mi.def.deleted_world))
Base.getindex(cache::CodeInstanceCache, mi::MethodInstance) = WorldView(cache, mi)[mi]

function Base.setindex!(cache::CodeInstanceCache, ci::CodeInstance, mi::MethodInstance)
    # Attach invalidation callback if necessary.
    # callback = Base.Fix1(invalidate, cache)
    callback(mi, max_world) = invalidate(cache, mi, max_world)
    if !isdefined(mi, :callbacks)
        mi.callbacks = Any[callback]
    elseif !in(callback, mi.callbacks)
        push!(mi.callbacks, callback)
    end
    push!(get!(Vector{CodeInstance}, cache.dict, mi), ci)
end

Base.haskey(wvc::WorldView{CodeInstanceCache}, mi::MethodInstance) = !isnothing(get(wvc, mi, nothing))
Base.haskey(cache::CodeInstanceCache, mi::MethodInstance) = !isnothing(get(cache, mi, nothing))

Base.get(cache::CodeInstanceCache, mi::MethodInstance, default) = get(WorldView(cache, mi), mi, default)

function Base.get(wvc::WorldView{CodeInstanceCache}, mi::MethodInstance, default)
    cis = get(wvc.cache.dict, mi, CodeInstance[])
    # Iterate code instances in reverse, as the most recent ones
    # are more likely to be valid.
    for ci in reverse(cis)
        if Core.Compiler.last(wvc.worlds) ≤ ci.max_world
            return ci
        end
    end
    default
end

function Base.getindex(wvc::WorldView{CodeInstanceCache}, mi::MethodInstance)
    ci = get(wvc, mi, nothing)
    !isnothing(ci) || throw(KeyError(mi))
    ci
end

Base.setindex!(wvc::WorldView{CodeInstanceCache}, args...) = setindex!(wvc.cache, args...)

Core.Compiler.get(wvc::WorldView{CodeInstanceCache}, args...) = get(wvc, args...)
Core.Compiler.haskey(wvc::WorldView{CodeInstanceCache}, args...) = haskey(wvc, args...)
Core.Compiler.setindex!(wvc::WorldView{CodeInstanceCache}, args...) = setindex!(wvc, args...)
Core.Compiler.getindex(wvc::WorldView{CodeInstanceCache}, args...) = getindex(wvc, args...)

const GLOBAL_CI_CACHE = CodeInstanceCache()

function invalidate(cache::CodeInstanceCache, mi::MethodInstance, max_world, invalidated = Set{MethodInstance}())
    push!(invalidated, mi)
    cis = get(cache.dict, mi, [])
    isempty(cis) && return

    for ci in cis
        ci.max_world = cap_world(ci.max_world, max_world)
    end

    # Recurse to all backedges to update their valid range.
    if isdefined(mi, :backedges)
        for mi in filter(!in(invalidated), mi.backedges)
            invalidate(cache, mi, max_world, invalidated)
        end
    end
end

function invalidate_all(cache::CodeInstanceCache = GLOBAL_CI_CACHE)
    for mi in keys(cache.dict)
        invalidate(cache, mi, get_world_counter() - 1)
    end
end
