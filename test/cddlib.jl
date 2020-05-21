@testset "CddInterface" begin
    LoadPackage("CddInterface")
    C = cdd_PolyhedronByInequalities([ [ 0, 1, 0 ], [ 0, 1, -1 ] ])
    rays = Cdd_GeneratingRays( C )
    @test rays == cdd_prepare_gap_input(rays)
    @test rays == GAP.Globals.List(
        julia_to_gap([ [ 0, -1 ], [ 1, 1 ] ]),
        julia_to_gap,
    )
end
