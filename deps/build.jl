import GAP

include( "homalg-project.jl" )

DownloadAllPackagesFromHomalgProject( )

for pkg in PACKAGES_TO_COMPILE
    
    CompileGapPackage( pkg );

end
