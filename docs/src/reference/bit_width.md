# Integer and float bit widths

When working on the CPU, most of the time there is little or no performance drawback in using 64-bit integers or floats compared to their 32-bit counterparts. However, when writing code aimed at GPU execution, it becomes important to understand that GPU architectures were designed around 32-bit integers and floats, while 64-bit values are expensive and may not even be supported on some hardware. For Vulkan for instance, [reports on gpuinfo.org indicate](https://vulkan.gpuinfo.org/listfeaturescore10.php) that in 2024 only ~44% of known implementations support 64-bit float operations in shaders, and only ~53% support 64-bit integer operations (you may search for `shaderFloat64` and `shaderInt64` in the list to get the up-to-date metric).

While any decently modern hardware should in principle support these operations, the performance drawbacks encourage us to be more intentional about using 64-bit values, and to only do so if there is something to be gained from the additional precision or representation range.

In Julia, integer literals inherit the bit size of the host CPU architecture (`Int`, `UInt`), which is usually 64-bit, while float literals are always parsed as `Float64`. The problem becomes evident in light of the GPU limitations and potential lack of support with regard to such 64-bit values, and affects [other types of devices](https://github.com/JuliaLang/julia/discussions/49252) as well.

Furthermore, 64-bit types may be internally used in some functions, such as this division operator:
```julia-repl
julia> UInt32(1)/UInt32(3)
0.3333333333333333

julia> typeof(ans)
Float64
```

or even literal powers:
```julia-repl
julia> 3f0^4
81.0f0 # all fine, right?

# Well, no:
julia> @code_typed 3f0^4
CodeInfo(
1 ─      goto #2
2 ─      goto #3
3 ─      goto #4
4 ─ %4 = Base.fpext(Base.Float64, x)::Float64
│   %5 = Base.power_by_squaring::typeof(Base.power_by_squaring)
│   %6 = invoke Base.:(var"#power_by_squaring#528")(Base.:*::typeof(*), %5::typeof(Base.power_by_squaring), %4::Float64, 4::Int64)::Float64
│   %7 = Base.fptrunc(Base.Float32, %6)::Float32
└──      goto #5
5 ─      return %7
) => Float32
```

To work around the related support and performance limitations on GPUs, one may need to perform explicit conversions to 32-bit types with `Float32`, `Int32` and `UInt32`. To make it more convenient, SPIRV.jl defines symbols which, when right-multiplied, convert the input to the corresponding type:

| Symbol      | Type    | Exported | Example |
| ----------- | ------- | -------- | ------- |
| [`I`](@ref) | Int32   | no       | `(x)I` or `x*I` |
| [`U`](@ref) | UInt32  | yes      | `(x)U` or `x*U` |
| [`F`](@ref) | Float32 | yes      | `(x)F` or `x*F` |

A 32-bit floating-point representation of π is also exported as [`πF`](@ref) for convenience, defined as `(π)F`.
