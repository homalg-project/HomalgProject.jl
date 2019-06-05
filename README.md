# HomalgProject

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://homalg-project.github.io/HomalgProject.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://homalg-project.github.io/HomalgProject.jl/dev)
[![Build Status](https://travis-ci.com/homalg-project/HomalgProject.jl.svg?branch=master)](https://travis-ci.com/homalg-project/HomalgProject.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/homalg-project/HomalgProject.jl?svg=true)](https://ci.appveyor.com/project/homalg-project/HomalgProject-jl)
[![Codecov](https://codecov.io/gh/homalg-project/HomalgProject.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/homalg-project/HomalgProject.jl)
[![Coveralls](https://coveralls.io/repos/github/homalg-project/HomalgProject.jl/badge.svg?branch=master)](https://coveralls.io/github/homalg-project/HomalgProject.jl?branch=master)
[![Build Status](https://api.cirrus-ci.com/github/homalg-project/HomalgProject.jl.svg)](https://cirrus-ci.com/github/homalg-project/HomalgProject.jl)

This Julia package is a compatility package for the homalg project.

## Installation:

```julia
julia> using Pkg
julia> Pkg.add("https://github.com/homalg-project/HomalgProject.jl")
```

## Example usage:
At the `julia>` prompt:

```julia
using HomalgProject
LoadPackageAndExposeGlobals( "GradedModules", Main, all_globals = true )
ℚ = HomalgFieldOfRationalsInSingular( )
R = ℚ["x,y,z"]
M = "[ x*y,y*z,z,0,0, x^3*z,x^2*z^2,0,x*z^2,-z^2, x^4,x^3*z,0,x^2*z,-x*z, 0,0,x*y,-y^2,x^2-1, 0,0,x^2*z,-x*y*z,y*z, 0,0,x^2*y-x^2,-x*y^2+x*y,y^2-y]";
M = HomalgMatrix( GAP.julia_to_gap( M ), 6, 5, R )
M = LeftPresentation( M )
SetAsOriginalPresentation( M )
FilteredByPurity( M )
Display( M )
Display( SpectralSequence( PurityFiltration( M ) ) )
```
