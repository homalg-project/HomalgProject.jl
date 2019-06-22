module HomalgProject

greet() = print("The homalg project compatibility package for Julia")

import Base: getindex

import GAP
export GAP

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
    LoadPackageAndExposeGlobals( "IO_ForHomalg", Main, all_globals = true )
end

end # module
