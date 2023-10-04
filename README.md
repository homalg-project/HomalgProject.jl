<!-- BEGIN HEADER -->
# HomalgProject.jl&ensp;<sup><sup>[![View code][code-img]][code-url]</sup></sup>

### Simplified access to the repositories of the GitHub organization homalg-project

| **Documentation** | **Build Status** | **GitHub Actions** |
|:-----------------:|:----------------:|:------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][tests-img]][tests-url] [![][codecov-img]][codecov-url] | [![][tagbot-img]][tagbot-url] [![][docsbuilder-img]][docsbuilder-url] [![][compathelper-img]][compathelper-url] |

<!-- END HEADER -->

## Introduction

The [Julia](https://julialang.org/) package `HomalgProject` provides simplified access to the repositories of the [GAP](https://www.gap-system.org/) packages hosted on the [GitHub organization homalg-project](https://homalg-project.github.io/), most of which are based on the

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

For more information on the included [GAP](https://www.gap-system.org) packages see the [documentation](https://homalg-project.github.io/HomalgProject.jl/dev/#Installation-1).

The correctness of the installation and the availability of the functionality can at any time be tested using

```julia
julia> using Pkg; Pkg.test("HomalgProject")
```

After each update of the Julia package `GAP` a rebuild is (probably) necessary:

```julia
julia> using Pkg; Pkg.build("HomalgProject")
```

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

This software is licensed under the LGPL, version 3, or any later version.

## Funding

*The development of this package and many of the GAP packages hosted on the GitHub organization [homalg-project](https://github.com/homalg-project/) was partially funded by the [DFG (German Research Foundation)](https://www.dfg.de/) through the*

* [Special Priority Project SPP 1489](https://spp.computeralgebra.de/),
* [Transregional Collaborative Research Centre SFB-TRR 195](https://www.computeralgebra.de/sfb/).

<!-- BEGIN FOOTER -->

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://homalg-project.github.io/HomalgProject.jl/dev/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://homalg-project.github.io/HomalgProject.jl/stable/

[tests-img]: https://github.com/homalg-project/HomalgProject.jl/actions/workflows/Tests.yml/badge.svg?branch=master
[tagbot-img]: https://github.com/homalg-project/HomalgProject.jl/workflows/TagBot/badge.svg
[docsbuilder-img]: https://github.com/homalg-project/HomalgProject.jl/workflows/DocsBuilder/badge.svg
[compathelper-img]: https://github.com/homalg-project/HomalgProject.jl/workflows/CompatHelper/badge.svg

[action-url]: https://github.com/homalg-project/HomalgProject.jl/actions
[tests-url]: https://github.com/homalg-project/HomalgProject.jl/actions/workflows/Tests.yml
[tagbot-url]: https://github.com/homalg-project/HomalgProject.jl/actions/workflows/TagBot.yml
[docsbuilder-url]: https://github.com/homalg-project/HomalgProject.jl/actions/workflows/pages/pages-build-deployment
[compathelper-url]: https://github.com/homalg-project/HomalgProject.jl/actions/workflows/CompatHelper.yml

[codecov-img]: https://codecov.io/gh/homalg-project/HomalgProject.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/homalg-project/HomalgProject.jl

[code-img]: https://img.shields.io/badge/-View%20code-blue?logo=github
[code-url]: https://github.com/homalg-project/HomalgProject.jl#top

<!-- END FOOTER -->
