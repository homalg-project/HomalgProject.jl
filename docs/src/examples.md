# HomalgProject.jl

## Examples

The following examples tests the functionality of the software projects
* [homalg project](https://github.com/homalg-project/homalg_project)
* [CAP project](https://github.com/homalg-project/CAP_project)

```@meta
DocTestSetup = quote
    using HomalgProject
    GAP.Globals.SizeScreen( GAP.julia_to_gap( [ 4096 ] ) )
    LoadPackageAndExposeGlobals( "IO_ForHomalg", Main, all_globals = true )
    LoadPackageAndExposeGlobals( "GradedModules", Main, all_globals = true )
    GAP.Globals.HOMALG_IO.show_banners = false
    HomalgFieldOfRationalsInSingular = GAP.Globals.HomalgFieldOfRationalsInSingular
    LeftPresentation = GAP.Globals.LeftPresentation
    Display = GAP.Display
    PurityFiltration = GAP.Globals.PurityFiltration
    SpectralSequence = GAP.Globals.SpectralSequence
    FilteredByPurity = GAP.Globals.FilteredByPurity
    OnFirstStoredPresentation = GAP.Globals.OnFirstStoredPresentation
    OnLastStoredPresentation = GAP.Globals.OnLastStoredPresentation
end
```

```jldoctest
julia> using HomalgProject

julia> LoadPackageAndExposeGlobals( "GradedModules", Main, all_globals = true )

julia> ℚ = HomalgFieldOfRationalsInSingular( )
GAP: Q

julia> R = ℚ["x,y,z"]
GAP: Q[x,y,z]

julia> m = "[ x*y,y*z,z,0,0, x^3*z,x^2*z^2,0,x*z^2,-z^2, x^4,x^3*z,0,x^2*z,-x*z, 0,0,x*y,-y^2,x^2-1, 0,0,x^2*z,-x*y*z,y*z, 0,0,x^2*y-x^2,-x*y^2+x*y,y^2-y ]";

julia> m = HomalgMatrix( m, 6, 5, R )
GAP: <A 6 x 5 matrix over an external ring>

julia> M = LeftPresentation( m )
GAP: <A left module presented by 6 relations for 5 generators>

julia> Display( M )
x*y,  y*z,    z,        0,         0,
x^3*z,x^2*z^2,0,        x*z^2,     -z^2,
x^4,  x^3*z,  0,        x^2*z,     -x*z,
0,    0,      x*y,      -y^2,      x^2-1,
0,    0,      x^2*z,    -x*y*z,    y*z,
0,    0,      x^2*y-x^2,-x*y^2+x*y,y^2-y

Cokernel of the map

Q[x,y,z]^(1x6) --> Q[x,y,z]^(1x5),

currently represented by the above matrix

julia> filt = PurityFiltration( M )
GAP: <The ascending purity filtration with degrees [ -3 .. 0 ] and graded parts:
   0:	<A codegree-[ 1, 1 ]-pure rank 2 left module presented by 3 relations for 4 generators>
  -1:	<A codegree-1-pure grade 1 left module presented by 4 relations for 3 generators>
  -2:	<A cyclic reflexively pure grade 2 left module presented by 2 relations for a cyclic generator>
  -3:	<A cyclic reflexively pure grade 3 left module presented by 3 relations for a cyclic generator>
of
<A non-pure rank 2 left module presented by 6 relations for 5 generators>>

julia> Display( filt )
Degree 0:

0,  0,   x, -y,
x*y,-y*z,-z,0,
x^2,-x*z,0, -z

Cokernel of the map

Q[x,y,z]^(1x3) --> Q[x,y,z]^(1x4),

currently represented by the above matrix
----------
Degree -1:

y,-z,0,
x,0, -z,
0,x, -y,
0,-y,x^2-1

Cokernel of the map

Q[x,y,z]^(1x4) --> Q[x,y,z]^(1x3),

currently represented by the above matrix
----------
Degree -2:

Q[x,y,z]/< z, y-1 >
----------
Degree -3:

Q[x,y,z]/< z, y, x >

julia> II_E = SpectralSequence( filt )
GAP: <A stable homological spectral sequence with sheets at levels [ 0 .. 4 ] each consisting of left modules at bidegrees [ -3 .. 0 ]x[ 0 .. 3 ]>

julia> Display( II_E )
The associated transposed spectral sequence:

a homological spectral sequence at bidegrees
[ [ 0 .. 3 ], [ -3 .. 0 ] ]
---------
Level 0:

 * * * *
 * * * *
 . * * *
 . . * *
---------
Level 1:

 * * * *
 . . . .
 . . . .
 . . . .
---------
Level 2:

 s . . .
 . . . .
 . . . .
 . . . .

Now the spectral sequence of the bicomplex:

a homological spectral sequence at bidegrees
[ [ -3 .. 0 ], [ 0 .. 3 ] ]
---------
Level 0:

 * * * *
 * * * *
 . * * *
 . . * *
---------
Level 1:

 * * * *
 * * * *
 . * * *
 . . . *
---------
Level 2:

 s . . .
 * s . .
 . * * .
 . . . *
---------
Level 3:

 s . . .
 * s . .
 . . s .
 . . . *
---------
Level 4:

 s . . .
 . s . .
 . . s .
 . . . s

julia> FilteredByPurity( M )
GAP: <A non-pure rank 2 left module presented by 12 relations for 9 generators>

julia> Display( M )
0,  0,   x, -y,0,1, 0,    0,  0,
x*y,-y*z,-z,0, 0,0, 0,    0,  0,
x^2,-x*z,0, -z,1,0, 0,    0,  0,
0,  0,   0, 0, y,-z,0,    0,  0,
0,  0,   0, 0, x,0, -z,   0,  -1,
0,  0,   0, 0, 0,x, -y,   -1, 0,
0,  0,   0, 0, 0,-y,x^2-1,0,  0,
0,  0,   0, 0, 0,0, 0,    z,  0,
0,  0,   0, 0, 0,0, 0,    y-1,0,
0,  0,   0, 0, 0,0, 0,    0,  z,
0,  0,   0, 0, 0,0, 0,    0,  y,
0,  0,   0, 0, 0,0, 0,    0,  x

Cokernel of the map

Q[x,y,z]^(1x12) --> Q[x,y,z]^(1x9),

currently represented by the above matrix

julia> OnFirstStoredPresentation( M )
GAP: <A non-pure rank 2 left module presented by 6 relations for 5 generators>

julia> Display( M )
x*y,  y*z,    z,        0,         0,
x^3*z,x^2*z^2,0,        x*z^2,     -z^2,
x^4,  x^3*z,  0,        x^2*z,     -x*z,
0,    0,      x*y,      -y^2,      x^2-1,
0,    0,      x^2*z,    -x*y*z,    y*z,
0,    0,      x^2*y-x^2,-x*y^2+x*y,y^2-y

Cokernel of the map

Q[x,y,z]^(1x6) --> Q[x,y,z]^(1x5),

currently represented by the above matrix

julia> OnLastStoredPresentation( M )
GAP: <A non-pure rank 2 left module presented by 12 relations for 9 generators>

julia> Display( M )
0,  0,   x, -y,0,1, 0,    0,  0,
x*y,-y*z,-z,0, 0,0, 0,    0,  0,
x^2,-x*z,0, -z,1,0, 0,    0,  0,
0,  0,   0, 0, y,-z,0,    0,  0,
0,  0,   0, 0, x,0, -z,   0,  -1,
0,  0,   0, 0, 0,x, -y,   -1, 0,
0,  0,   0, 0, 0,-y,x^2-1,0,  0,
0,  0,   0, 0, 0,0, 0,    z,  0,
0,  0,   0, 0, 0,0, 0,    y-1,0,
0,  0,   0, 0, 0,0, 0,    0,  z,
0,  0,   0, 0, 0,0, 0,    0,  y,
0,  0,   0, 0, 0,0, 0,    0,  x

Cokernel of the map

Q[x,y,z]^(1x12) --> Q[x,y,z]^(1x9),

currently represented by the above matrix

```

```@meta
DocTestSetup = nothing
```
