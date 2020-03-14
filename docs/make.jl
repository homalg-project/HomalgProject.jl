using Documenter, HomalgProject

makedocs(;
    modules  = [HomalgProject],
    format   = Documenter.HTML(assets=String[]),
    doctest  = false,
    repo     = "https://github.com/homalg-project/HomalgProject.jl/blob/{commit}{path}#L{line}",
    sitename = "HomalgProject.jl",
    authors  = "Mohamed Barakat <mohamed.barakat@uni-siegen.de>",
    pages    = [
        "Home" => "index.md",
        "Examples" => "examples.md",
    ],
)

deploydocs(;
    repo     = "github.com/homalg-project/HomalgProject.jl",
)
