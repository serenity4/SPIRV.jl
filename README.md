# SPIRV

![tests](https://github.com/serenity4/SPIRV.jl/workflows/Run%20tests/badge.svg) [![](https://img.shields.io/badge/docs-stable-blue.svg)](https://serenity4.github.io/SPIRV.jl/stable) [![](https://img.shields.io/badge/docs-dev-blue.svg)](https://serenity4.github.io/SPIRV.jl/dev)

## Generate package files

A portion of this package relies on static code generation. To re-generate the files, execute `gen/generator.jl` in the environment specified in `gen`:

```
julia --color=yes --project=gen 'using Pkg; Pkg.instantiate(); include("gen/generator.jl)'
```
