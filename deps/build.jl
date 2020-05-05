import GAP

include( "homalg-project.jl" )

DownloadAllPackagesFromHomalgProject( )

CompileGapPackage( "Gauss", test_availability = false ) ## Gauss is always available, so compile anyway

for pkg in PACKAGES_TO_COMPILE
    
    CompileGapPackage( pkg );
    
end
