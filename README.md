# HomalgProject.jl

| **Documentation** | **Build Status** | **GibHub Actions** |
|:-----------------:|:----------------:|:------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][tests-img]][action-url] [![][codecov-img]][codecov-url] | [![][tagbot-img]][action-url] [![][compathelper-img]][action-url] |

## Introduction

The [Julia](https://julialang.org/) package `HomalgProject` provides simplified access to the repositories of the [GAP](https://www.gap-system.org) packages hosted at the GitHub organization [homalg-project](https://github.com/homalg-project), most of which are based on the

* [CAP project](https://github.com/homalg-project/CAP_project/),
* [homalg project](https://github.com/homalg-project/homalg_project/).

These are open source [GAP](https://www.gap-system.org) multi-package projects for constructive category theory and homological algebra with applications to module theory of commutative and non-commutative algebras and algebraic geometry.

## Installation

To install Julia follow the instructions of the first two steps on the [Oscar installation page](https://oscar.computeralgebra.de/install/). Then start Julia and add the package `HomalgProject`:

```julia
$ julia
julia> using Pkg
julia> Pkg.add("HomalgProject")
```

This will also clone the repositories listed in `HomalgProject.PACKAGES_TO_DOWNLOAD` using `DownloadAllPackagesFromHomalgProject( )` and compile the packages listed in `HomalgProject.PACKAGES_TO_COMPILE` using `GAP.Packages.install( pkgname )`.

Furthermore:

* `UpdateAllPackagesFromHomalgProject( )` updates all packages listed in `HomalgProject.PACKAGES_TO_DOWNLOAD` using `UpdatePackageFromHomalgProject( pkgname )`.

* `RemoveAllPackagesFromHomalgProject( )` removes all packages listed in `HomalgProject.PACKAGES_TO_DOWNLOAD` using `RemovePackageFromHomalgProject( pkgname )`. This might be useful if you encounter problems while updating the packages.

After each update of the Julia package `GAP` a rebuild is (probably) necessary:

```julia
julia> using Pkg
julia> Pkg.build("HomalgProject")
```

This will (re)compile the packages listed in `HomalgProject.PACKAGES_TO_COMPILE`.

## Software dependency

`HomalgProject` relies on the

| computer algebra systems                    | through the Julia packages                                 |
|:-------------------------------------------:|:----------------------------------------------------------:|
| [GAP](https://www.gap-system.org/)          | [Gap.jl](https://github.com/oscar-system/GAP.jl)           |
| [Nemo](http://www.nemocas.org/)             | Nemo = [Nemo.jl](https://github.com/wbhart/Nemo.jl)        |
| [Singular](https://www.singular.uni-kl.de/) | [Singular.jl](https://github.com/oscar-system/Singular.jl) |

all of which are components of the computer algebra system [OSCAR](https://oscar.computeralgebra.de/).

Some of the bundled packages use the GAP packages

* [IO](https://github.com/gap-packages/io/)
* [ferret](https://github.com/gap-packages/ferret/)
* [json](https://github.com/gap-packages/json/)
* [QPA2](https://github.com/oysteins/QPA2/)

and the

| third party software                                | through the GAP packages                                                        |
|:---------------------------------------------------:|:-------------------------------------------------------------------------------:|
| [cddlib](https://github.com/cddlib/cddlib/)         | [CddInterface](https://github.com/homalg-project/CddInterface/)                 |
| [4ti2](https://4ti2.github.io/)                     | [4ti2Interface](https://homalg-project.github.io/homalg_project/4ti2Interface/) |
| [Normaliz](https://www.normaliz.uni-osnabrueck.de/) | [NormalizInterface](https://github.com/gap-packages/NormalizInterface/)         |
| [Graphviz](https://graphviz.org/)                   | [Digraphs](https://github.com/gap-packages/digraphs/)                           |

## General Disclaimer

The software comes with absolutely no warranty and will most likely have errors. If you use it for computations, please check the correctness of the result very carefully.

This software is licensed under the LGPL, version 3, or any later version.

## Funding

*The development of both software projects was partially funded by the [DFG (German Research Foundation)](https://www.dfg.de/) through the [Special Priority Project SPP 1489](https://spp.computeralgebra.de/) and the [Transregional Collaborative Research Centre SFB-TRR 195](https://www.computeralgebra.de/sfb/).*

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://homalg-project.github.io/HomalgProject.jl/dev/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://homalg-project.github.io/HomalgProject.jl/stable/

[tests-img]: https://github.com/homalg-project/HomalgProject.jl/workflows/Tests/badge.svg
[tagbot-img]: https://github.com/homalg-project/HomalgProject.jl/workflows/TagBot/badge.svg
[compathelper-img]: https://github.com/homalg-project/HomalgProject.jl/workflows/CompatHelper/badge.svg

[action-url]: https://github.com/homalg-project/HomalgProject.jl/actions

[codecov-img]: https://codecov.io/gh/homalg-project/HomalgProject.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/homalg-project/HomalgProject.jl
