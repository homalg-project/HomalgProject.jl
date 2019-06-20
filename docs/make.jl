using Documenter, HomalgProject

makedocs(;
    modules=[HomalgProject],
    format=Documenter.HTML(assets=String[]),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/homalg-project/HomalgProject.jl/blob/{commit}{path}#L{line}",
    sitename="HomalgProject.jl",
    authors="Mohamed Barakat <mohamed.barakat@uni-siegen.de>",
)

deploydocs(;
    repo="github.com/homalg-project/HomalgProject.jl",
)
