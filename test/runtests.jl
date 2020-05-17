using HomalgProject, Test, Documenter

DocMeta.setdocmeta!( HomalgProject, :DocTestSetup, :( using HomalgProject ); recursive = true )

include("packages.jl")
include("singular.jl")
include("homalg_project.jl")
include("testmanual.jl")
