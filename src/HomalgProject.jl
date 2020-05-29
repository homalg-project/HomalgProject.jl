@doc Markdown.doc"""
The Julia package `HomalgProject` provides simplified access to the
repositories of the GAP packages hosted at the GitHub organization
https://github.com/homalg-project, most of which are based on the

* [CAP project](https://github.com/homalg-project/CAP_project/),
* [homalg project](https://github.com/homalg-project/homalg_project/).

These are open source GAP multi-package projects for constructive
category theory and homological algebra with applications to module
theory of commutative and non-commutative algebras and algebraic
geometry.

## Software dependency

`HomalgProject` relies on the computer algebra system `GAP`
via `GAP.jl`, the latter being a component of
[OSCAR](https://oscar.computeralgebra.de/).

Some of the bundled packages use the GAP packages

* IO
* ferret
* json
* QPA2

and the

| third party software | through the GAP packages |
|:--------------------:|:------------------------:|
| cddlib               | CddInterface             |
| 4ti2                 | 4ti2Interface            |
| Normaliz             | NormalizInterface        |
| Graphviz             | Digraphs                 |

## General Disclaimer

The software comes with absolutely no warranty and will most likely have errors. If you use it for computations, please check the correctness of the result very carefully.

This software is licensed under the LGPL, version 3, or any later version.

## Funding

The development of both software projects was partially funded by the DFG (German Research Foundation) through
the [Special Priority Project SPP 1489](https://spp.computeralgebra.de/) and
the [Transregional Collaborative Research Centre SFB-TRR 195](https://www.computeralgebra.de/sfb/).

More information and the online documentation can be found at the source code repository

https://github.com/homalg-project/HomalgProject.jl
"""
module HomalgProject

greet() = print("The homalg project compatibility package for Julia")

import Base: getindex

import GAP
import GAP: julia_to_gap, gap_to_julia, @g_str, @gap, GapObj

export GAP
export julia_to_gap, gap_to_julia, @g_str, @gap, GapObj

import Pkg
import Markdown

Base.:*(x::GAP.GapObj, y::String) = x * julia_to_gap(y)
Base.getindex(x::GAP.GapObj, y::String) = GAP.Globals.ELM_LIST(x, julia_to_gap(y))
Base.:/(x::GAP.GapObj, y::Array{Main.ForeignGAP.MPtr,1}) = GAP.Globals.QUO(x, julia_to_gap(y))

function LoadPackage(pkgname::String)
    GAP.LoadPackageAndExposeGlobals(pkgname, Main, all_globals = true)
end

export LoadPackage

function HomalgMatrix(M::String, m::Int64, n::Int64, R::GAP.GapObj)
    return GAP.Globals.HomalgMatrix(julia_to_gap(M), m, n, R)
end

export HomalgMatrix

function SizeScreen(L::Array)
    return GAP.Globals.SizeScreen(julia_to_gap(L))
end

export SizeScreen

include(joinpath("..","deps","homalg-project.jl"))

global HOMALG_PATHS = []

## $(HOMALG_PROJECT_PATH)/deps/usr/bin should be the last entry
HOMALG_PATHS = vcat(HOMALG_PATHS, [[joinpath(HOMALG_PROJECT_PATH, "deps", "usr", "bin")]])

export HOMALG_PATHS

##
function LoadPackageIO()

    if GAP.Globals.TestPackageAvailability(julia_to_gap("io")) == GAP.Globals.fail
        GAP.Packages.install("io")
    end

    ## loading IO_ForHomalg now suppresses its banner later
    LoadPackage("IO_ForHomalg")

    GAP.Globals.HOMALG_IO.show_banners = false

    return true

end

"""
    HomalgProject.version

The version number of the loaded `HomalgProject`.
Please mention this number in any bug report.
"""
global version = 0

if VERSION >= v"1.4"
    deps = Pkg.dependencies()
    if Base.haskey(deps, Base.UUID("50bd374c-87b5-11e9-015a-2febe71398bd"))
        ver = Pkg.dependencies()[Base.UUID("50bd374c-87b5-11e9-015a-2febe71398bd")]
        if occursin("/dev/", ver.source)
            version = VersionNumber("$(ver.version)-dev")
        else
            version = VersionNumber("$(ver.version)")
        end
    else
        version = "not installed"
    end
else
    deps = Pkg.API.__installed(Pkg.PKGMODE_MANIFEST) #to also get installed dependencies
    if haskey(deps, "HomalgProject")
        ver = deps["HomalgProject"]
        dir = dirname(@__DIR__)
        if occursin("/dev/", dir)
            version = VersionNumber("$(ver)-dev")
        else
            version = VersionNumber("$(ver)")
        end
    else
        version = "not installed"
    end
end

function __init__()

    DownloadPackageFromHomalgProject("homalg_project")
    DownloadPackageFromHomalgProject("CAP_project")

    ## Read( "Tools.g" )
    path = julia_to_gap(joinpath(HOMALG_PROJECT_PATH, "src", "Tools.g"))
    GAP.Globals.Read(path)

    ## add "~/.gap/" at the end of GAPInfo.RootPaths
    GAP.Globals.ExtendRootDirectories(julia_to_gap([GAP.Globals.UserHomeExpand(julia_to_gap("~/.gap/"))]))

    ## add "~/.julia/.../HomalgProject/" at the beginning of GAPInfo.RootPaths
    GAP.Globals.EnhanceRootDirectories(julia_to_gap([julia_to_gap(
        HOMALG_PROJECT_PATH * "/",
    )]))

    ## add more paths to GAPInfo.DirectoriesSystemPrograms
    for paths in HOMALG_PATHS
        paths = GAP.Globals.List(julia_to_gap(paths), julia_to_gap)
        paths =
            GAP.Globals.Concatenation(paths, GAP.Globals.GAPInfo.DirectoriesSystemPrograms)
        paths = GAP.Globals.Unique(paths)
        GAP.Globals.GAPInfo.DirectoriesSystemPrograms = paths
        GAP.Globals.GAPInfo.DirectoriesPrograms = GAP.Globals.List(
            GAP.Globals.GAPInfo.DirectoriesSystemPrograms,
            GAP.Globals.Directory,
        )
    end

    LoadPackageIO()

    if haskey(ENV, "HOMALG_PROJECT_SHOW_BANNER")
        show_banner = ENV["HOMALG_PROJECT_SHOW_BANNER"] == "true"
    else
        show_banner =
            isinteractive() && !any(x -> x.name in ["Oscar", "CapAndHomalgWithOscar"], keys(Base.package_locks))
    end

    if show_banner
        print("HomalgProject v")
        printstyled("$version\n", color = :green)
        println("Imported OSCAR's component GAP")
        println("Type: ?HomalgProject for more information")
    end

end

end # module
