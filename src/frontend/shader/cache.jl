mutable struct CacheDiagnostics
  @atomic hits::Int
  @atomic misses::Int
end
CacheDiagnostics() = CacheDiagnostics(0, 0)

mutable struct Cache{D}
  const d::D
  @atomic diagnostics::CacheDiagnostics
end
Cache{D}() where {D} = Cache{D}(D(), CacheDiagnostics())

Base.deepcopy_internal(cache::Cache, ::IdDict) = typeof(cache)(deepcopy(cache.d), deepcopy(cache.diagnostics))

function Base.empty!(cache::Cache)
  empty!(cache.d)
  @atomic :monotonic cache.diagnostics = CacheDiagnostics()
  cache
end

@forward_methods Cache field = :d Base.haskey(_, key) Base.iterate(_, args...) Base.length Base.keys Base.getindex(_, key)

function Base.get!(f, cache::Cache, key)
  if haskey(cache, key)
    @atomic :monotonic cache.diagnostics.hits += 1
    cache.d[key]
  else
    @atomic :monotonic cache.diagnostics.misses += 1
    get!(f, cache.d, key)
  end
end

function Base.get(f, cache::Cache, key)
  if haskey(cache, key)
    @atomic :monotonic cache.diagnostics.hits += 1
    cache[key]
  else
    @atomic :monotonic cache.diagnostics.misses += 1
    f()
  end
end

Base.get!(cache::Cache, key, default) = get!(() -> default, cache, key)
Base.get(cache::Cache, key, default) = get(() -> default, cache, key)

"""
    ShaderCompilationCache()

Create a cache that may be used to associate shaders to be compiled ([`ShaderSpec`](@ref)) with
compiled code ([`ShaderSource`](@ref)).

Although this cache will already significantly speed up shader creation by compiling only what is required,
performance-critical applications will additionally want to use a high-level cache that maps a [`ShaderSource`](@ref)
to a driver-dependent object generated by the graphics API chosen for that application.
For Vulkan, that would be a `Vk.ShaderModule`, for example. It is then recommended to use an `IdDict` to perform the caching,
to avoid hashing the whole source code.

!!! warning
    This cache assumes that the same `MethodInstance` and [`ShaderInterface`](@ref) will result in the same compiled shader. However, if different (non-default) [`SPIRVInterpreter`](@ref)s are used, compilation may yield different results. For performance reasons, and because most users will be fine with the default interpreter, the choice of interpreter is not checked; it is the user's responsibility to ensure different caches are used if different interpreters are to be used.
"""
const ShaderCompilationCache = Cache{Dict{ShaderSpec,ShaderSource}}

# The cache could be reused across devices, if we want to avoid going through codegen again.
# However the supported features would have to be taken as the intersection of all the supported
# ones on each hypothetical device.

ShaderSource(cache::ShaderCompilationCache, spec::ShaderSpec, layout::Union{VulkanAlignment, LayoutStrategy}, interp) = get!(cache, spec, layout, interp)
ShaderSource(::Nothing, spec::ShaderSpec, layout::Union{VulkanAlignment, LayoutStrategy}, interp) = ShaderSource(spec, layout, interp)
Base.get!(cache::ShaderCompilationCache, spec::ShaderSpec, layout::Union{VulkanAlignment, LayoutStrategy}, interp::SPIRVInterpreter = SPIRVInterpreter()) = get!(() -> ShaderSource(spec, layout, interp), cache, spec)
