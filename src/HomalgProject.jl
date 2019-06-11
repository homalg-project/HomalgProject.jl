module HomalgProject

greet() = print("The homalg project compatibility package for Julia")

import Base: getindex

import GAP
export GAP

import GAP: LoadPackageAndExposeGlobals, @g_str, @gap
export LoadPackageAndExposeGlobals, @g_str, @gap

Base.:*(x::GAP.MPtr,y::String) = x*GAP.julia_to_gap(y)
Base.getindex(x::GAP.MPtr,y::String) = GAP.Globals.ELM_LIST(x,GAP.julia_to_gap(y))

end # module
