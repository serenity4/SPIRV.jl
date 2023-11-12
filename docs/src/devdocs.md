# Developer documentation

## Updating the SPIR-V bindings

SPIR-V bindings are generated in this package, according to the [SPIR-V specification](https://registry.khronos.org/SPIR-V/).
To update to bindings reflecting a newer version of the specification, run

```
julia --color=yes --project=gen -e 'using Pkg; Pkg.instantiate(); include("gen/generator.jl")'
```

Note that this should not be performed by package users. This is only relevant if a maintainer or developer wishes to upgrade the bindings to reflect that of a newer version of the SPIR-V specification, at which point a pull request would be highly appreciated so that everyone gets to enjoy the update.
