# Developer documentation

## Regenerate package files

A portion of this package relies on static code generation. To re-generate the files, execute `gen/generator.jl` in the environment specified in `gen`:

```
julia --color=yes --project=gen -e 'using Pkg; Pkg.instantiate(); include("gen/generator.jl")'
```
