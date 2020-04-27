@doc Markdown.doc"""
The Julia package `HomalgProject` provides simplified access to the
repositories of the GAP packages hosted at the GitHub organisation
https://github.com/homalg-project, most of which are based on the

* [CAP project](https://github.com/homalg-project/CAP_project/),
* [homalg project](https://github.com/homalg-project/homalg_project/).

These are open source GAP multi-package projects for constructive
category theory and homological algebra with applications to module
theory of commutative and non-commutative algebras and algebraic
geometry.

The source code repository and the online documentation can be found at

https://github.com/homalg-project/HomalgProject.jl
"""
module HomalgProject

greet() = print("The homalg project compatibility package for Julia")

import Base: getindex

import GAP
import GAP: LoadPackageAndExposeGlobals, @g_str, @gap

export GAP
export LoadPackageAndExposeGlobals, @g_str, @gap

import Singular
import Singular.libSingular: call_interpreter

export call_interpreter

import Pkg
import Markdown

Base.:*(x::GAP.GapObj,y::String) = x*GAP.julia_to_gap(y)
Base.getindex(x::GAP.GapObj,y::String) = GAP.Globals.ELM_LIST(x,GAP.julia_to_gap(y))

function HomalgMatrix( M::String, m::Int64, n::Int64, R::GAP.GapObj )
    return GAP.Globals.HomalgMatrix( GAP.julia_to_gap( M ), m, n, R )
end

export HomalgMatrix

function CompileGapPackage( name; print_available = true )
    
    gstr = GAP.julia_to_gap( name )
    
    if GAP.Globals.TestPackageAvailability( gstr ) == GAP.Globals.fail
        
        pkg = GAP.Globals.PackageInfo( gstr )
        
        if GAP.Globals.Length( pkg ) == 0
            dirs = GAP.gap_to_julia(GAP.Globals.String( GAP.EvalString("List(DirectoriesLibrary(\"pkg\"), d -> Filename(d, \"\"))")))
            @warn "unable to find package named \"" * name * "\" in " * dirs
            return false
        end
        
        pkg = pkg[1]
        
        path = GAP.gap_to_julia( pkg.InstallationPath )
        
        @info "Compiling \"" * path, "\""
        cd(path)
        run(`./configure --with-gaproot=$(GAP.GAPROOT)`)
        run(`make -j$(Sys.CPU_THREADS)`)
        if GAP.Globals.TestPackageAvailability( gstr ) == GAP.Globals.fail
            @warn "Compiling the package \"" * name * "\" failed."
            return false
        end
        
        @info "Compiling the package \"" * name * "\" was successful."
        return true
        
    end
    
    if print_available == true
        @warn "Package \"" * name * "\" is already installed."
    end
    
    return true
    
end

export CompileGapPackage

function UseExternalSingular( bool::Bool )
    
    if bool == false
        ## LoadPackage( "RingsForHomalg" ) ## needed by the variable HOMALG_IO_Singular below
        LoadPackageAndExposeGlobals( "RingsForHomalg", Main, all_globals = true )
        ## Read( "LaunchCAS_JSingularInterpreterForHomalg.g" )
        homalg = splitdir(splitdir(pathof(HomalgProject))[1])[1]
        path = GAP.julia_to_gap(joinpath(homalg,"src","LaunchCAS_JSingularInterpreterForHomalg.g"))
        GAP.Globals.Read(path)
        GAP.Globals.HOMALG_IO_Singular.LaunchCAS = GAP.Globals.LaunchCAS_JSingularInterpreterForHomalg_preload
        return true
    end
    
    ## add ~/.julia/.../Singular/deps/usr/bin/ to GAPInfo.DirectoriesSystemPrograms
    singular = splitdir(splitdir(pathof(Singular))[1])[1]
    lib = joinpath(splitdir(splitdir(pathof(Singular))[1])[1],"deps","usr","lib")
    singular = GAP.julia_to_gap(joinpath(singular,"deps","usr","bin"))
    paths = GAP.Globals.Concatenation( GAP.julia_to_gap( [ singular ] ), GAP.Globals.GAPInfo.DirectoriesSystemPrograms )
    GAP.Globals.GAPInfo.DirectoriesSystemPrograms = paths
    
    CompileGapPackage( "io", print_available = false )
    
    ## LoadPackage( "IO_ForHomalg" ) ## needed when reading LaunchCAS_IO_ForHomalg.g below
    LoadPackageAndExposeGlobals( "IO_ForHomalg", Main, all_globals = true )
    
    ## LoadPackage( "RingsForHomalg" ) ## needed by the variable HOMALG_IO_Singular below
    LoadPackageAndExposeGlobals( "RingsForHomalg", Main, all_globals = true )
    
    ## add ~/.julia/.../Singular/deps/usr/lib/ to LD_LIBRARY_PATH and DYLD_LIBRARY_PATH
    lib = [ "LD_LIBRARY_PATH=" * lib * ":\$LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH=" * lib * ":\$DYLD_LIBRARY_PATH" ]
    GAP.Globals.HOMALG_IO_Singular.environment = GAP.julia_to_gap( [GAP.julia_to_gap(lib[1]), GAP.julia_to_gap(lib[2])] )
    
    GAP.Globals.HOMALG_IO_Singular.LaunchCAS = false
    
    return true
    
end

export UseExternalSingular

function InstallPackageFromHomalgProject( pkgname )
    
    res = GAP.Globals.LoadPackage(GAP.julia_to_gap("PackageManager"), false)
    @assert res
    dir = splitdir(splitdir(pathof(HomalgProject))[1])[1] * "/pkg/"
    git = GAP.julia_to_gap("git")
    clone = GAP.julia_to_gap("clone")
    
    dir = dir * pkgname
    
    if isdir(dir)
        return true
    end
    
    @info "Cloning into \"" * dir * "\" ... "
    pkgname = GAP.julia_to_gap("https://github.com/homalg-project/" * pkgname)
    pkgname = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap("."), git, clone, pkgname, GAP.julia_to_gap(dir));
    
    if pkgname.code != 0
        @warn "Cloning failed:\n" * GAP.gap_to_julia(pkgname.output)
        return false
    end
    
    return true
    
end
    
export InstallPackageFromHomalgProject

function UpdatePackageFromHomalgProject( pkgname )
    
    res = GAP.Globals.LoadPackage(GAP.julia_to_gap("PackageManager"), false)
    @assert res
    dir = splitdir(splitdir(pathof(HomalgProject))[1])[1] * "/pkg/"
    git = GAP.julia_to_gap("git")
    pull = GAP.julia_to_gap("pull")
    
    dir = dir * pkgname
    
    if ! isdir(dir)
        return InstallPackageFromHomalgProject( pkgname )
    end
    
    @info "Updating \"" * dir * "\" ... "
    pkgname = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap(dir), git, pull, GAP.julia_to_gap("--ff-only"));
    
    if pkgname.code != 0
        @warn "Updating failed:\n" * GAP.gap_to_julia(pkgname.output)
        return false
    end
    
    @info GAP.gap_to_julia(pkgname.output)
    return true
    
end

export UpdatePackageFromHomalgProject

function RemovePackageFromHomalgProject( pkgname )
    
    res = GAP.Globals.LoadPackage(GAP.julia_to_gap("PackageManager"), false)
    @assert res
    dir = splitdir(splitdir(pathof(HomalgProject))[1])[1] * "/pkg/"
    rm = GAP.julia_to_gap("rm")
    opt = GAP.julia_to_gap("-rf")
    
    dir = dir * pkgname
    
    if ! isdir(dir)
        return false
    end
    
    @info "Removing \"" * dir * "\""
    pkgname = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap("."), rm, opt, GAP.julia_to_gap(dir));
    
    if pkgname.code != 0
        @warn "Remving failed:\n" * GAP.gap_to_julia(pkgname.output)
        return false
    end
    
    return true
    
end

export RemovePackageFromHomalgProject

if VERSION >= v"1.4"
    deps = Pkg.dependencies()
    if Base.haskey(deps, Base.UUID("50bd374c-87b5-11e9-015a-2febe71398bd"))
        ver = Pkg.dependencies()[Base.UUID("50bd374c-87b5-11e9-015a-2febe71398bd")]
        if occursin("/dev/", ver.source)
            global VERSION_NUMBER = VersionNumber("$(ver.version)-dev")
        else
            global VERSION_NUMBER = VersionNumber("$(ver.version)")
        end
    else
        global VERSION_NUMBER = "not installed"
    end
else
    deps = Pkg.API.__installed(Pkg.PKGMODE_MANIFEST) #to also get installed dependencies
    if haskey(deps, "HomalgProject")
        ver = deps["HomalgProject"]
        dir = dirname(@__DIR__)
        if occursin("/dev/", dir)
            global VERSION_NUMBER = VersionNumber("$(ver)-dev")
        else
            global VERSION_NUMBER = VersionNumber("$(ver)")
        end
    else
        global VERSION_NUMBER = "not installed"
    end
end

global HOMALG_VERSION_NUMBER = VERSION_NUMBER

export HOMALG_VERSION_NUMBER

global HOMALG_INITIALIZED = false

export HOMALG_INITIALIZED

function __init__()
    
    InstallPackageFromHomalgProject( "homalg_project" )
    InstallPackageFromHomalgProject( "CAP_project" )
    InstallPackageFromHomalgProject( "OscarForHomalg" )
    
    homalg = splitdir(splitdir(pathof(HomalgProject))[1])[1]
    
    ## Read( "Tools.g" )
    path = GAP.julia_to_gap(joinpath(homalg,"src","Tools.g"))
    GAP.Globals.Read(path)
    
    ## add ~/.julia/.../HomalgProject/ to GAPInfo.RootPaths
    GAP.Globals.EnhanceRootDirectories( GAP.julia_to_gap( [ GAP.julia_to_gap( homalg * "/" ) ] ) )
    
    ## add ~/.gap/ to GAPInfo.RootPaths
    GAP.Globals.EnhanceRootDirectories( GAP.julia_to_gap( [ GAP.Globals.UserHomeExpand( GAP.julia_to_gap( "~/.gap/" ) ) ] ) )
    
    CompileGapPackage( "Gauss", print_available = false )
    
    UseExternalSingular( true )
    UseExternalSingular( false )
    
    if isinteractive()
        #print("Version")
        #printstyled(" $VERSION_NUMBER ", color = :green)
        #println()
        #println("Type: ?HomalgProject for more information")
    end
    
    global HOMALG_INITIALIZED = true
    
end

end # module
