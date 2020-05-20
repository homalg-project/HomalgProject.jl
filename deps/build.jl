import GAP
import GAP: julia_to_gap

include( "homalg-project.jl" )

DownloadAllPackagesFromHomalgProject( )

CompileGapPackage( "Gauss", test_availability = false ) ## Gauss is always available, so compile anyway
CompileGapPackage( "grape", test_availability = false ) ## GRAPE is always available, so compile anyway

for pkg in PACKAGES_TO_COMPILE
    
    CompileGapPackage( pkg );
    
end
