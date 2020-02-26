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

export_list = Symbol[ :HomalgMatrix ]

function __init__()
    ## Current hack to remove warning for overwriting
    ## HomalgMatrix when exporting it. Needs to remove once
    ## LoadPackageAndExposeGlobals is done better.
    global export_list
    for i in export_list
        current_value = eval(:($i))
        Base.MainInclude.eval(:($i = $current_value))
    end
    singular = GAP.julia_to_gap(joinpath(splitdir(splitdir(pathof(Singular))[1])[1],"deps/usr/bin/"))
    lib = joinpath(splitdir(splitdir(pathof(Singular))[1])[1],"deps/usr/lib/")
    paths = GAP.Globals.Concatenation( GAP.julia_to_gap( [ singular ] ), GAP.Globals.GAPInfo.DirectoriesSystemPrograms )
    GAP.Globals.GAPInfo.DirectoriesSystemPrograms = paths
    LoadPackageAndExposeGlobals( "IO_ForHomalg", Main, all_globals = true )
    homalg = joinpath(splitdir(splitdir(pathof(HomalgProject))[1])[1],"src/")
    path = GAP.julia_to_gap(joinpath(homalg,"LaunchCAS_IO_ForHomalg.g"))
    GAP.Globals.Read(path)
    LoadPackageAndExposeGlobals( "RingsForHomalg", Main, all_globals = true )
    lib = [ "LD_LIBRARY_PATH="*lib*":\$LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH="*lib*":\$DYLD_LIBRARY_PATH" ]
    GAP.Globals.HOMALG_IO_Singular.environment = GAP.julia_to_gap( [GAP.julia_to_gap(lib[1]), GAP.julia_to_gap(lib[2])] )
end

end # module
