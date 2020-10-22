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

function Base.showable(mime::MIME, obj::GapObj)
    return GAP.Globals.IsShowable(julia_to_gap(string(mime)), obj)
end

Base.show(io::IO, ::MIME"application/x-latex", obj::GapObj) = print(io, string("\$\$", gap_to_julia(GAP.Globals.LaTeXStringOp(obj))), "\$\$")
Base.show(io::IO, ::MIME"text/latex", obj::GapObj) = print(io, string("\$\$", gap_to_julia(GAP.Globals.LaTeXStringOp(obj))), "\$\$")

function LoadPackage(pkgname::String)
    GAP.LoadPackageAndExposeGlobals(pkgname, Main, all_globals = true)
end

export LoadPackage

include("conversions.jl")

include(joinpath("..","deps","homalg-project.jl"))

## Singular
import Singular
import Singular.libSingular: call_interpreter

export call_interpreter

global SINGULAR_PATH = dirname(dirname(pathof(Singular)))

## Singular_jll
import Singular_jll

## $(HOMALG_PROJECT_PATH)/deps/usr/bin should be the last entry
global HOMALG_PATHS = vcat(
    Singular_jll.PATH_list,
    [joinpath(HOMALG_PROJECT_PATH, "deps", "usr", "bin")]
)

export HOMALG_PATHS

global SINGULAR_LIBRARY_PATHS = vcat(
    Singular_jll.LIBPATH_list,
)

export SINGULAR_LIBRARY_PATHS

##
function UseExternalSingular(bool::Bool)

    if bool == false
        ## LoadPackage( "RingsForHomalg" ) ## needed by the variable HOMALG_IO_Singular below
        LoadPackage("RingsForHomalg")
        ## Read( "LaunchCAS_JSingularInterpreterForHomalg.g" )
        path = julia_to_gap(joinpath(
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
    DownloadPackageFromHomalgProject("OscarForHomalg")

    ## Read( "Tools.g" )
    path = julia_to_gap(joinpath(HOMALG_PROJECT_PATH, "src", "Tools.g"))
    GAP.Globals.Read(path)

    ## add "~/.gap/" at the end of GAPInfo.RootPaths
    GAP.Globals.ExtendRootDirectories(julia_to_gap([GAP.Globals.UserHomeExpand(julia_to_gap("~/.gap/"))]))

    ## add "~/.julia/.../HomalgProject/" at the beginning of GAPInfo.RootPaths
    GAP.Globals.AddToRootDirectories(julia_to_gap([julia_to_gap(
        HOMALG_PROJECT_PATH * "/",
    )]))

    if GAP.Globals.TestPackageAvailability(julia_to_gap("io")) == GAP.Globals.fail
        GAP.Packages.install("io")
    end

    ## LoadPackage( "RingsForHomalg" ) ## needed by the variable HOMALG_IO_Singular below
    LoadPackage("RingsForHomalg")

    ## add binary paths to GAPInfo.DirectoriesSystemPrograms
    paths = GAP.Globals.Concatenation(
        julia_to_gap(map(julia_to_gap, HOMALG_PATHS)),
        GAP.Globals.GAPInfo.DirectoriesSystemPrograms
    )
    paths = GAP.Globals.Unique(paths)
    GAP.Globals.GAPInfo.DirectoriesSystemPrograms = paths
    GAP.Globals.GAPInfo.DirectoriesPrograms = GAP.Globals.List(
        GAP.Globals.GAPInfo.DirectoriesSystemPrograms,
        GAP.Globals.Directory
    )

    ## add library pathes to LD_LIBRARY_PATH and DYLD_LIBRARY_PATH in HOMALG_IO_Singular.environment
    lib = join(SINGULAR_LIBRARY_PATHS, ":")
    GAP.Globals.HOMALG_IO_Singular.environment =
        julia_to_gap([julia_to_gap("LD_LIBRARY_PATH=" * lib * ":\$LD_LIBRARY_PATH"),
                      julia_to_gap("DYLD_LIBRARY_PATH=" * lib * ":\$DYLD_LIBRARY_PATH")])

    SizeScreen( [ 2^12 ] )

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
