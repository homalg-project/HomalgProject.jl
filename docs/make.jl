using HomalgProject
using Documenter
using DocumenterMarkdown

makedocs(;
    modules=[HomalgProject],
    authors="Mohamed Barakat <mohamed.barakat@uni-siegen.de>",
    repo="https://github.com/homalg-project/HomalgProject.jl/blob/{commit}{path}#{line}",
    sitename="HomalgProject.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "Tests", "false") == "true",
        canonical="https://homalg-project.github.io/HomalgProject.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Examples" => "examples.md"
    ],
)

deploydocs(;
    repo="github.com/homalg-project/HomalgProject.jl",
    devbranch="master",
)
