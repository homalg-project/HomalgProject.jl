module HomalgProject

greet() = print("The homalg project compatibility package for Julia")

import Base: getindex

import GAP
export GAP

import Singular

import GAP: LoadPackageAndExposeGlobals, @g_str, @gap
export LoadPackageAndExposeGlobals, @g_str, @gap

Base.:*(x::GAP.GapObj,y::String) = x*GAP.julia_to_gap(y)
Base.getindex(x::GAP.GapObj,y::String) = GAP.Globals.ELM_LIST(x,GAP.julia_to_gap(y))

function HomalgMatrix( M::String, m::Int64, n::Int64, R::GAP.GapObj )
    return GAP.Globals.HomalgMatrix( GAP.julia_to_gap( M ), m, n, R )
end

export HomalgMatrix

function UseExternalSingular( )
    
    ## add ~/.julia/.../Singular/deps/usr/bin/ to GAPInfo.DirectoriesSystemPrograms
    singular = splitdir(splitdir(pathof(Singular))[1])[1]
    lib = joinpath(splitdir(splitdir(pathof(Singular))[1])[1],"deps","usr","lib")
    singular = GAP.julia_to_gap(joinpath(singular,"deps","usr","bin"))
    paths = GAP.Globals.Concatenation( GAP.julia_to_gap( [ singular ] ), GAP.Globals.GAPInfo.DirectoriesSystemPrograms )
    GAP.Globals.GAPInfo.DirectoriesSystemPrograms = paths
    
    ## LoadPackage( "IO_ForHomalg" ) ## needed to when reading LaunchCAS_IO_ForHomalg.g below
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
    
    return nothing
    
end

export UseExternalSingular

function CompileGapPackage( name; print_available = true )
    
    gstr = GAP.julia_to_gap( name )
    
    if GAP.Globals.TestPackageAvailability( gstr ) == GAP.Globals.fail
        
        gap = splitdir(splitdir(pathof(GAP))[1])[1]
        
        pkg = GAP.Globals.Filtered( GAP.Globals.PackageInfo( gstr ), a -> splitdir(splitdir(splitdir(GAP.gap_to_julia( a.InstallationPath ))[1])[1])[1] == gap )
        
        if GAP.Globals.Length( pkg ) == 0
            print( "unable to find package named " * name * " in " * gap * "\n\n" )
            return false
        end
        
        pkg = pkg[1]
        path = GAP.gap_to_julia( pkg.InstallationPath )
        
        print( "Start compiling " * path * ":\n\n" )
        cd(path)
        run(`./configure`)
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

function __init__()
    
    ## add ~/.gap/ to GAPInfo.RootPaths
    GAP.Globals.ExtendRootDirectories( GAP.julia_to_gap( [ GAP.Globals.UserHomeExpand( GAP.julia_to_gap( "~/.gap/" ) ) ] ) )
    
    CompileGapPackage( "io", print_available = false )
    CompileGapPackage( "Gauss", print_available = false )

    UseExternalSingular( )
    
end

end # module
