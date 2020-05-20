import GAP
import GAP: julia_to_gap

include( "homalg-project.jl" )

DownloadAllPackagesFromHomalgProject( )

for pkg in PACKAGES_TO_COMPILE
    
    GAP.Packages.install( pkg );
    
end
