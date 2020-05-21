global HOMALG_PROJECT_PATH = dirname( @__DIR__ )

##
function DownloadPackageFromHomalgProject( pkgname )
    
    res = GAP.Globals.LoadPackage(julia_to_gap("PackageManager"), false)
    @assert res
    dir = HOMALG_PROJECT_PATH * "/pkg/"
    git = julia_to_gap("git")
    clone = julia_to_gap("clone")
    
    dir = dir * pkgname
    
    if isdir(dir)
        return true
    end
    
    @info "Cloning into \"" * dir * "\""
    pkgname = julia_to_gap("https://github.com/homalg-project/" * pkgname)
    pkgname = GAP.Globals.PKGMAN_Exec(julia_to_gap("."), git, clone, pkgname, julia_to_gap(dir));
    
    if pkgname.code != 0
        @warn "Cloning failed:\n" * gap_to_julia(pkgname.output)
        return false
    end
    
    return true
    
end
    
export DownloadPackageFromHomalgProject

##
function UpdatePackageFromHomalgProject( pkgname )
    
    res = GAP.Globals.LoadPackage(julia_to_gap("PackageManager"), false)
    @assert res
    dir = HOMALG_PROJECT_PATH * "/pkg/"
    git = julia_to_gap("git")
    pull = julia_to_gap("pull")
    
    dir = dir * pkgname
    
    if ! isdir(dir)
        return DownloadPackageFromHomalgProject( pkgname )
    end
    
    @info "Updating \"" * dir * "\""
    pkgname = GAP.Globals.PKGMAN_Exec(julia_to_gap(dir), git, pull, julia_to_gap("--ff-only"));
    
    if pkgname.code != 0
        @warn "Updating failed:\n" * gap_to_julia(pkgname.output)
        return false
    end
    
    @info gap_to_julia(pkgname.output)
    return true
    
end

export UpdatePackageFromHomalgProject

##
function RemovePackageFromHomalgProject( pkgname )
    
    res = GAP.Globals.LoadPackage(julia_to_gap("PackageManager"), false)
    @assert res
    dir = HOMALG_PROJECT_PATH * "/pkg/"
    rm = julia_to_gap("rm")
    opt = julia_to_gap("-rf")
    
    dir = dir * pkgname
    
    if ! isdir(dir)
        return false
    end
    
    @info "Removing \"" * dir * "\""
    pkgname = GAP.Globals.PKGMAN_Exec(julia_to_gap("."), rm, opt, julia_to_gap(dir));
    
    if pkgname.code != 0
        @warn "Remving failed:\n" * gap_to_julia(pkgname.output)
        return false
    end
    
    return true
    
end

export RemovePackageFromHomalgProject

##
global PACKAGES_BASED_ON_HOMALG =
    [ "homalg_project",
      "OscarForHomalg",
      
      "alcove",
      "AlgebraicThomas",
      "ArangoDBInterface",
      "Blocks",
      "D-Modules",
      "LessGenerators",
      "LoopIntegrals",
      "MatroidGeneration",
      "NConvex",
      "ParallelizedIterators",
      "PrimaryDecomposition",
      "Sheaves",
    ]

##
global PACKAGES_BASED_ON_CAP =
    [ "CAP_project",
      
      "BBGG",
      "Bialgebroids",
      "Bicomplexes",
      "CategoryConstructor",
      "CategoriesWithAmbientObjects",
      "CatReps",
      "ComplexesCategories",
      "DerivedCategories",
      "FinSetsForCAP",
      "FinGSetsForCAP",
      "FrobeniusCategories",
      "FunctorCategories",
      "GradedCategories",
      "HomotopyCategories",
      "IntrinsicCategories",
      "IntrinsicModules",
      "InternalModules",
      "LazyCategories",
      "Locales",
      "ModelCategories",
      "QPA2",
      "QuotientCategories",
      "StableCategories",
      "SubcategoriesForCAP",
      "Toposes",
      "TriangulatedCategories",
      "ZariskiFrames",
      ]

global PACKAGES_TO_DOWNLOAD =
    vcat( PACKAGES_BASED_ON_HOMALG,
          PACKAGES_BASED_ON_CAP,
          )

function DownloadAllPackagesFromHomalgProject( )
    
    for pkg in PACKAGES_TO_DOWNLOAD
        DownloadPackageFromHomalgProject( pkg )
    end
    
end

export DownloadAllPackagesFromHomalgProject

function UpdateAllPackagesFromHomalgProject( )
    
    for pkg in PACKAGES_TO_DOWNLOAD
        UpdatePackageFromHomalgProject( pkg )
    end
    
end

export UpdateAllPackagesFromHomalgProject

function RemoveAllPackagesFromHomalgProject( )
    
    for pkg in PACKAGES_TO_DOWNLOAD
        RemovePackageFromHomalgProject( pkg )
    end
    
end

export RemoveAllPackagesFromHomalgProject

global PACKAGES_TO_COMPILE =
    [ "Gauss",
      #"Browse", ## do not compile browse as it results into GAP raising the error "Error opening terminal: xterm-256color."
      "io",
      "grape",
      "digraphs",
      "ferret",
      "json",
      "orb",
      ]

global PACKAGES_DOWNLOADING_EXTERNAL_CODE =
    [ "CddInterface",
      "NormalizInterface",
      ]
