using Documenter, SPIRV

makedocs(;
    modules=[SPIRV],
    format=Documenter.HTML(prettyurls = true),
    pages=[
        "Home" => "index.md",
        "Introduction" => "intro.md",
        "API" => 
            "api.md"
        ,
    ],
    repo="https://github.com/serenity4/SPIRV.jl/blob/{commit}{path}#L{line}",
    sitename="SPIRV.jl",
    authors="serenity4 <cedric.bel@hotmail.fr>",
)

deploydocs(
    repo = "github.com/serenity4/SPIRV.jl.git",
)
