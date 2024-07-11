using Documenter, Literate, SPIRV

function julia_files(dir)
  files = reduce(vcat, [joinpath(root, file) for (root, dirs, files) in walkdir(dir) for file in files])
  sort(filter(endswith(".jl"), files))
end

function replace_edit(content)
  haskey(ENV, "JULIA_GITHUB_ACTIONS_CI") && return content
  # Linking does not work locally, but we can make
  # the warning go away with a hard link to the repo.
  replace(
      content,
      r"EditURL = \".*<unknown>/(.*)\"" => s"EditURL = \"https://github.com/JuliaGPU/SPIRV.jl/tree/main/\1\"",
  )
end

function generate_markdown_files()
  dir = joinpath(@__DIR__, "src")
  Threads.@threads for file in julia_files(dir)
      Literate.markdown(
          file,
          dirname(file);
          postprocess = replace_edit,
          documenter = true,
      )
  end
end

generate_markdown_files()

makedocs(;
  modules = [SPIRV],
  format = Documenter.HTML(prettyurls = true),
  pages = [
    "Home" => "index.md",
    "Introduction" => "intro.md",
    "Tutorials" => [
      "tutorials/manipulating_spirv.md",
    ],
    "Reference" => [
      "reference/bit_width.md",
    ],
    "Targeting SPIR-V via LLVM" => "spirv_llvm.md",
    "Features" => "features.md",
    "API" => "api.md",
    "Developer documentation" => "devdocs.md",
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
