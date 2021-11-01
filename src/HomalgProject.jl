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

`HomalgProject` relies on the

| computer algebra systems | through the Julia packages |
|:------------------------:|:--------------------------:|
| GAP                      | Gap.jl                     |
| Nemo                     | Nemo = Nemo.jl             |
| Singular                 | Singular.jl                |

all of which are components of the computer algebra system
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

import Pkg
import Markdown

## Singular
import Singular
import Singular.libSingular: call_interpreter

export call_interpreter

## GAP
import GAP
import GAP: @g_str, @gap, GapObj

export GAP
export @g_str, @gap, GapObj

## CapAndHomalg
import CapAndHomalg
import CapAndHomalg:
    HomalgMatrix, RepresentationCategoryObject, SizeScreen, SIZE_SCREEN_ORIGINAL, SINGULAR_BINARY_PATHS, SINGULAR_LIBRARY_PATHS, UseSystemSingular, ≟,
    DownloadPackageFromHomalgProject, UpdatePackageFromHomalgProject, RemovePackageFromHomalgProject,
    DownloadAllPackagesFromHomalgProject, UpdateAllPackagesFromHomalgProject, RemoveAllPackagesFromHomalgProject, RemoveDeprecatedPackagesFromHomalgProject,
    CompilePackagesForHomalgProject, HOMALG_PATHS

export CapAndHomalg
export
    HomalgMatrix, RepresentationCategoryObject, SizeScreen, SIZE_SCREEN_ORIGINAL, SINGULAR_BINARY_PATHS, SINGULAR_LIBRARY_PATHS, UseSystemSingular, ≟,
    DownloadPackageFromHomalgProject, UpdatePackageFromHomalgProject, RemovePackageFromHomalgProject,
    DownloadAllPackagesFromHomalgProject, UpdateAllPackagesFromHomalgProject, RemoveAllPackagesFromHomalgProject, RemoveDeprecatedPackagesFromHomalgProject,
    CompilePackagesForHomalgProject, HOMALG_PATHS

global HOMALG_PROJECT_PATH = dirname(@__DIR__)

function LoadPackage(pkgname::String)
    CapAndHomalg.LoadPackageAndExposeGlobals(pkgname, HomalgProject)
    nothing
end

export LoadPackage

##
function UseExternalSingular(bool::Bool)

    if bool == false
        ## LoadPackage( "RingsForHomalg" ) ## needed by the variable HOMALG_IO_Singular below
        LoadPackage("RingsForHomalg")
        ## Read( "LaunchCAS_JSingularInterpreterForHomalg.g" )
        path = GapObj(joinpath(
            HOMALG_PROJECT_PATH,
            "src",
            "LaunchCAS_JSingularInterpreterForHomalg.g",
        ))
        GAP.Globals.Read(path)
        GAP.Globals.HOMALG_IO_Singular.LaunchCAS =
            GAP.Globals.LaunchCAS_JSingularInterpreterForHomalg_preload
        return true
    end

    ## loading IO_ForHomalg now suppresses its banner later
    LoadPackage("IO_ForHomalg")

    GAP.Globals.HOMALG_IO_Singular.LaunchCAS = false

    return true

end

export UseExternalSingular

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
            version = VersionNumber("$(ver.version)")
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

    UseExternalSingular(true)
    UseExternalSingular(false)

    if haskey(ENV, "HOMALG_PROJECT_SHOW_BANNER")
        show_banner = ENV["HOMALG_PROJECT_SHOW_BANNER"] == "true"
    else
        show_banner =
            isinteractive() && !any(x -> x.name in ["Oscar"], keys(Base.package_locks))
    end

    if show_banner
        print("HomalgProject v")
        printstyled("$version\n", color = :green)
        println("Imported OSCAR's components GAP, Nemo, and Singular")
        println("Type: ?HomalgProject for more information")
    end

end

end # module
