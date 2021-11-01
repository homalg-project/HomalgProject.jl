@testset "Singular" begin
    @test UseExternalSingular(false)
    LoadPackage("GradedModules")
    ℚ = HomalgFieldOfRationalsInSingular()
    @test IsHomalgExternalRingInSingularRep( ℚ )
    @test UseExternalSingular(true)
    ℚ = HomalgFieldOfRationalsInSingular()
    @test IsHomalgExternalRingInSingularRep( ℚ )
    @test UseExternalSingular(false)
    ℚ = HomalgFieldOfRationalsInSingular()
    @test IsHomalgExternalRingInSingularRep( ℚ )
end
