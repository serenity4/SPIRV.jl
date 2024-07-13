using Documenter, Literate, SPIRV

function julia_files(dir)
  files = reduce(vcat, [joinpath(root, file) for (root, dirs, files) in walkdir(dir) for file in files])
  sort(filter(endswith(".jl"), files))
end

function generate_markdown_files()
  dir = joinpath(@__DIR__, "src")
  Threads.@threads for file in julia_files(dir)
      Literate.markdown(
          file,
          dirname(file);
          documenter = true,
      )
  end
end

generate_markdown_files()

makedocs(;
  modules = [SPIRV],
  format = Documenter.HTML(prettyurls = true),
  pages = [
    "index.md",
    "intro.md",
    "Tutorials" => [
      "tutorials/manipulating_spirv.md",
      "tutorials/creating_a_shader.md",
    ],
    "Reference" => [
      "reference/shader_compilation.md",
      "reference/bit_width.md",
    ],
    "features.md",
    "api.md",
    "devdocs.md",
  ],
  repo = "https://github.com/serenity4/SPIRV.jl/blob/{commit}{path}#L{line}",
  sitename = "SPIRV.jl",
  authors = "serenity4 <cedric.bel@hotmail.fr>",
  doctest = false,
  warnonly = true,
  linkcheck = true,
  checkdocs = :exports,
)

deploydocs(
  repo = "github.com/serenity4/SPIRV.jl.git",
)
