@testset "download/update/remove packages from the homalg-project organization" begin
    RemovePackageFromHomalgProject( "HomalgProject.jl" )
    @test DownloadPackageFromHomalgProject( "HomalgProject.jl" )
    @test DownloadPackageFromHomalgProject( "HomalgProject.jl" )
    @test UpdatePackageFromHomalgProject( "HomalgProject.jl" )
    @test UpdatePackageFromHomalgProject( "HomalgProject.jl" )
    @test RemovePackageFromHomalgProject( "HomalgProject.jl" )
    @test ! RemovePackageFromHomalgProject( "HomalgProject.jl" )
end
