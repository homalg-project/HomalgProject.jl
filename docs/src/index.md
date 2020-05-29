# HomalgProject.jl

```@meta
CurrentModule = HomalgProject
```
## Introduction

The [Julia](https://julialang.org/) package `HomalgProject` provides simplified access to the repositories of the [GAP](https://www.gap-system.org) packages hosted at the GitHub organization [homalg-project](https://github.com/homalg-project), most of which are based on the

* [CAP project](https://github.com/homalg-project/CAP_project/),
* [homalg project](https://github.com/homalg-project/homalg_project/).

These are open source [GAP](https://www.gap-system.org) multi-package projects for constructive category theory and homological algebra with applications to module theory of commutative and non-commutative algebras and algebraic geometry.

## Installation

To install Julia follow the instructions of the first two steps on the [Oscar installation page](https://oscar.computeralgebra.de/install/). Then start Julia and add the package `HomalgProject`:

```julia
$ julia
julia> using Pkg; Pkg.add("HomalgProject")
```

## Testing

The correctness of the installation and the availability of the functionality can at any time be tested using

```julia
julia> using Pkg; Pkg.test("HomalgProject")
```

## Updating

```julia
julia> using Pkg; Pkg.update("HomalgProject")
julia> Pkg.build("HomalgProject")
```

This will also clone the repositories listed in [`HomalgProject.PACKAGES_TO_DOWNLOAD`](@ref) using [`DownloadAllPackagesFromHomalgProject`](@ref) and compile the packages listed in [`HomalgProject.PACKAGES_TO_COMPILE`](@ref) using `GAP.Packages.install`(`pkgname`).

```@docs
version
PKG_DIR
PACKAGES_TO_DOWNLOAD
DownloadAllPackagesFromHomalgProject
UpdateAllPackagesFromHomalgProject
RemoveAllPackagesFromHomalgProject
DownloadPackageFromHomalgProject
UpdatePackageFromHomalgProject
RemovePackageFromHomalgProject
PACKAGES_TO_COMPILE
```

## Software dependency

`HomalgProject` relies on the computer algebra system [GAP](https://www.gap-system.org/)
via [Gap.jl](https://github.com/oscar-system/GAP.jl), the latter being a component of
[OSCAR](https://oscar.computeralgebra.de/).

Some of the bundled packages use the [GAP](https://www.gap-system.org) packages

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

This software is licensed under the [LGPL, version 3](https://www.gnu.org/licenses/lgpl-3.0.en.html), or any later version.

## Funding

*The development of both software projects was partially funded by the [DFG (German Research Foundation)](https://www.dfg.de/) through the [Special Priority Project SPP 1489](https://spp.computeralgebra.de/) and the [Transregional Collaborative Research Centre SFB-TRR 195](https://www.computeralgebra.de/sfb/).*

## Index

```@index
```
