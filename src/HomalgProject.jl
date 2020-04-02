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

function InstallHomalgAndCAP()
    
    res = GAP.Globals.LoadPackage(GAP.julia_to_gap("PackageManager"), false)
    @assert res
    dir = splitdir(splitdir(pathof(HomalgProject))[1])[1]*"/pkg/"
    git = GAP.julia_to_gap("git")
    clone = GAP.julia_to_gap("clone")
    
    homalg_dir = dir * "homalg_project"
    if ! isdir(homalg_dir)
        homalg_url = GAP.julia_to_gap("https://github.com/homalg-project/homalg_project.git")
        print("Cloning into \"" * homalg_dir * "\" ... ")
        homalg = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap("."), git, clone, homalg_url, GAP.julia_to_gap(homalg_dir));
        if homalg.code == 0
            print("done.\n")
        else
            print("failed.\n" * GAP.gap_to_julia(homalg.output) * "\n")
        end
        code_homalg = homalg.code
    else
        code_homalg = 0
    end
    
    cap_dir = dir * "CAP_project"
    if ! isdir(cap_dir)
        cap_url = GAP.julia_to_gap("https://github.com/homalg-project/CAP_project.git")
        print("Cloning into \"" * cap_dir * "\" ... ")
        cap = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap("."), git, clone, cap_url, GAP.julia_to_gap(cap_dir));
        if cap.code == 0
            print("done.\n")
        else
            print("failed.\n" * GAP.gap_to_julia(cap.output) * "\n")
        end
        code_cap = cap.code
    else
        code_cap = 0
    end
    
    return code_homalg == 0 && code_cap == 0
    
end

export InstallHomalgAndCAP

function UpdateHomalgAndCAP()
    
    if ! InstallHomalgAndCAP( )
        return false
    end
    
    res = GAP.Globals.LoadPackage(GAP.julia_to_gap("PackageManager"), false)
    @assert res
    dir = splitdir(splitdir(pathof(HomalgProject))[1])[1]*"/pkg/"
    git = GAP.julia_to_gap("git")
    pull = GAP.julia_to_gap("pull")
    
    homalg_dir = dir * "homalg_project"
    if isdir(homalg_dir)
        print("Updating \"" * homalg_dir * "\" ... ")
        homalg = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap(homalg_dir), git, pull, GAP.julia_to_gap("--ff-only"));
        print(GAP.gap_to_julia(homalg.output))
        code_homalg = homalg.code
    else
        code_homalg = 1
    end
    
    cap_dir = dir * "CAP_project"
    if isdir(cap_dir)
        print("Updating \"" * cap_dir * "\" ... ")
        cap = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap(cap_dir), git, pull, GAP.julia_to_gap("--ff-only"));
        print(GAP.gap_to_julia(cap.output))
        code_cap = cap.code
    else
        code_cap = 1
    end
    
    return code_homalg == 0 && code_cap == 0
    
end

export UpdateHomalgAndCAP

function RemoveHomalgAndCAP()
    
    res = GAP.Globals.LoadPackage(GAP.julia_to_gap("PackageManager"), false)
    @assert res
    dir = splitdir(splitdir(pathof(HomalgProject))[1])[1]*"/pkg/"
    rm = GAP.julia_to_gap("rm")
    opt = GAP.julia_to_gap("-rf")
    
    homalg_dir = dir * "homalg_project"
    if isdir(homalg_dir)
        homalg = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap("."), rm, opt, GAP.julia_to_gap(homalg_dir));
        if homalg.code == 0
            print("done.\n")
        else
            print("failed.\n" * GAP.gap_to_julia(homalg.output) * "\n")
        end
        code_homalg = homalg.code
    else
        code_homalg = 1
    end
    
    cap_dir = dir * "CAP_project"
    if isdir(cap_dir)
        cap = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap("."), rm, opt, GAP.julia_to_gap(cap_dir));
        if cap.code == 0
            print("done.\n")
        else
            print("failed.\n" * GAP.gap_to_julia(cap.output) * "\n")
        end
        code_cap = cap.code
    else
        code_cap = 1
    end
    
    return code_homalg == 0 && code_cap == 0
    
end

export RemoveHomalgAndCAP

function __init__()
    
    InstallHomalgAndCAP()
    
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
