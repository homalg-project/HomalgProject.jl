# HomalgProject.jl

```@meta
CurrentModule = HomalgProject
```
## Introduction

The [Julia](https://julialang.org/) package `HomalgProject` provides simplified access to the repositories of the [GAP](https://www.gap-system.org) packages hosted on the [GitHub organization homalg-project](https://homalg-project.github.io/), most of which are based on the

* [CAP project](https://github.com/homalg-project/CAP_project#readme),
* [homalg project](https://github.com/homalg-project/homalg_project#readme).

These are open source [GAP](https://www.gap-system.org) multi-package projects for constructive category theory and homological algebra with applications to module theory of commutative and non-commutative algebras and algebraic geometry.

## Installation

#### Install Julia

To install Julia follow the first Steps 0 and 1 on our [installation page](https://homalg-project.github.io/docs/installation).

#### Install `HomalgProject.jl`

Then start `julia` in a terminal and add the package `HomalgProject`:

```julia
julia> using Pkg; Pkg.add("HomalgProject")

julia> using HomalgProject
```

## Testing

The correctness of the installation and the availability of the functionality can at any time be tested using

```julia
julia> using Pkg; Pkg.test("HomalgProject")
```

## Updating

After each update of the Julia package `GAP` a rebuild is (probably) necessary:

```julia
julia> using Pkg; Pkg.update("HomalgProject")

julia> Pkg.build("HomalgProject")
```

This will also clone the repositories listed in `CapAndHomalg.PACKAGES_TO_DOWNLOAD` using `DownloadAllPackagesFromHomalgProject` and compile the packages listed in `CapAndHomalg.PACKAGES_TO_COMPILE` using `GAP.Packages.install`(`pkgname`).

## Software dependency

`HomalgProject` relies on the

| computer algebra systems                    | through the Julia packages                                 |
|:-------------------------------------------:|:----------------------------------------------------------:|
| [GAP](https://www.gap-system.org/)          | [Gap.jl](https://github.com/oscar-system/GAP.jl)           |
| [Nemo](http://www.nemocas.org/)             | Nemo = [Nemo.jl](https://github.com/Nemocas/Nemo.jl)       |
| [Singular](https://www.singular.uni-kl.de/) | [Singular.jl](https://github.com/oscar-system/Singular.jl) |

all of which are components of the computer algebra system [OSCAR](https://oscar.computeralgebra.de/).

Some of the bundled packages use the [GAP](https://www.gap-system.org) packages

* [IO](https://github.com/gap-packages/io/)
* [ferret](https://github.com/gap-packages/ferret/)
* [json](https://github.com/gap-packages/json/)
* [QPA2](https://github.com/sunnyquiver/QPA2/)

and the

| third party software                                | through the GAP packages                                                        | and the Julia packages |
|:---------------------------------------------------:|:-------------------------------------------------------------------------------:|:----------------------:|
| [Graphviz](https://graphviz.org/)                   | [Digraphs](https://github.com/gap-packages/digraphs/)                           | [Graphviz_jll.jl](https://github.com/JuliaBinaryWrappers/Graphviz_jll.jl) |
| [4ti2](https://4ti2.github.io/)                     | [4ti2Interface](https://homalg-project.github.io/homalg_project/4ti2Interface/) | [lib4ti2_jll.jl](https://github.com/JuliaBinaryWrappers/lib4ti2_jll.jl) |

<!--
| [cddlib](https://github.com/cddlib/cddlib/)         | [CddInterface](https://github.com/homalg-project/CddInterface/)                 | [cddlib_jll.jl](https://github.com/JuliaBinaryWrappers/cddlib_jll.jl) |
| [Normaliz](https://www.normaliz.uni-osnabrueck.de/) | [NormalizInterface](https://github.com/gap-packages/NormalizInterface/)         | [normaliz_jll.jl](https://github.com/JuliaBinaryWrappers/normaliz_jll.jl) |
-->

## General Disclaimer

The software comes with absolutely no warranty and will most likely have errors. If you use it for computations, please check the correctness of the result very carefully.

This software is licensed under the [LGPL, version 3](https://www.gnu.org/licenses/lgpl-3.0.en.html), or any later version.

## Funding

*The development of this package and many of the GAP packages hosted on the GitHub organization [homalg-project](https://github.com/homalg-project/) was partially funded by the [DFG (German Research Foundation)](https://www.dfg.de/) through the*

* [Special Priority Project SPP 1489](https://spp.computeralgebra.de/),
* [Transregional Collaborative Research Centre SFB-TRR 195](https://www.computeralgebra.de/sfb/).

## Index

```@index
```

```@autodocs
Modules = [HomalgProject]
```
