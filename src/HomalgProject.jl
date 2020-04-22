module HomalgProject

greet() = print("The homalg project compatibility package for Julia")

import Base: getindex

import GAP
export GAP

import Singular
import Singular.libSingular: call_interpreter
export call_interpreter

import GAP: LoadPackageAndExposeGlobals, @g_str, @gap
export LoadPackageAndExposeGlobals, @g_str, @gap

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
            print( "unable to find package named \"" * name * "\" in " * dirs * "\n\n" )
            return false
        end
        
        pkg = pkg[1]
        
        path = GAP.gap_to_julia( pkg.InstallationPath )
        
        print( "Start compiling " * path * ":\n\n" )
        cd(path)
        run(`./configure --with-gaproot=$(GAP.GAPROOT)`)
        run(`make -j$(Sys.CPU_THREADS)`)
        if GAP.Globals.TestPackageAvailability( gstr ) == GAP.Globals.fail
            print( "\nThe compilation of the package " * name * " failed.\n\n" )
            return false
        end
        
        print( "\nThe compilation of the package " * name * " was successful.\n\n" )
        return true
        
    end

    if print_available == true
        print( "package " * name * " is already installed\n\n" )
    end
    
    return true
    
end

export CompileGapPackage

function UseExternalSingular( bool::Bool )
    
    if bool == false
        ## LoadPackage( "OscarForHomalg" ) ## needed for LaunchCASJSingularInterpreterForHomalg
        LoadPackageAndExposeGlobals( "OscarForHomalg", Main, all_globals = true )
        GAP.Globals.HOMALG_IO_Singular.LaunchCAS = GAP.Globals.LaunchCASJSingularInterpreterForHomalg
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
    
    ## Read( "LaunchCAS_IO_ForHomalg.g" )
    homalg = splitdir(splitdir(pathof(HomalgProject))[1])[1]
    path = GAP.julia_to_gap(joinpath(joinpath(homalg,"src"),"LaunchCAS_IO_ForHomalg.g"))
    GAP.Globals.Read(path)
    
    ## LoadPackage( "RingsForHomalg" ) ## needed by the variable HOMALG_IO_Singular below
    LoadPackageAndExposeGlobals( "RingsForHomalg", Main, all_globals = true )
    
    ## add ~/.julia/.../Singular/deps/usr/lib/ to LD_LIBRARY_PATH and DYLD_LIBRARY_PATH
    lib = [ "LD_LIBRARY_PATH="*lib*":\$LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH="*lib*":\$DYLD_LIBRARY_PATH" ]
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
    
    pkgname = GAP.julia_to_gap("https://github.com/homalg-project/" * pkgname)
    print("Cloning into \"" * dir * "\" ... ")
    pkgname = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap("."), git, clone, pkgname, GAP.julia_to_gap(dir));
    
    if pkgname.code != 0
        print("failed.\n" * GAP.gap_to_julia(pkgname.output) * "\n")
        return false
    end
    
    print("done.\n")
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
    
    print("Updating \"" * dir * "\" ... ")
    pkgname = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap(dir), git, pull, GAP.julia_to_gap("--ff-only"));
    print(GAP.gap_to_julia(pkgname.output))
    
    if pkgname.code != 0
        return false
    end
    
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
    
    pkgname = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap("."), rm, opt, GAP.julia_to_gap(dir));
    
    if pkgname.code != 0
        print("failed.\n" * GAP.gap_to_julia(pkgname.output) * "\n")
        return false
    end
    
    return true
    
end

export RemovePackageFromHomalgProject

function __init__()
    
    InstallPackageFromHomalgProject( "homalg_project" )
    InstallPackageFromHomalgProject( "CAP_project" )
    
    homalg = splitdir(splitdir(pathof(HomalgProject))[1])[1]
    
    ## Read( "Tools.g" )
    path = GAP.julia_to_gap(joinpath(joinpath(homalg,"src"),"Tools.g"))
    GAP.Globals.Read(path)
    
    ## add ~/.julia/.../HomalgProject/ to GAPInfo.RootPaths
    GAP.Globals.EnhanceRootDirectories( GAP.julia_to_gap( [ GAP.julia_to_gap( homalg*"/" ) ] ) )
    
    ## add ~/.gap/ to GAPInfo.RootPaths
    GAP.Globals.EnhanceRootDirectories( GAP.julia_to_gap( [ GAP.Globals.UserHomeExpand( GAP.julia_to_gap( "~/.gap/" ) ) ] ) )
    
    CompileGapPackage( "Gauss", print_available = false )
    
    UseExternalSingular( true )
    
end

end # module
