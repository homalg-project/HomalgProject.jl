@testset "internal and external Singular" begin
    @test UseExternalSingular( false )
    LoadPackage( "GradedModules" )
    ℚ = HomalgFieldOfRationalsInSingular( )
    @test UseExternalSingular( true )
    ℚ = HomalgFieldOfRationalsInSingular( )
    @test UseExternalSingular( false )
    ℚ = HomalgFieldOfRationalsInSingular( )
end
