global HOMALG_PROJECT_PATH = dirname( @__DIR__ )

function CompileGapPackage( name; print_available = true, install_script = false, test_availability = true )
    
    gstr = GAP.julia_to_gap( name )
    
    if ( test_availability == false ) || ( GAP.Globals.TestPackageAvailability( gstr ) == GAP.Globals.fail )
        
        pkg = GAP.Globals.PackageInfo( gstr )
        
        if GAP.Globals.Length( pkg ) == 0
            dirs = GAP.gap_to_julia(GAP.Globals.String( GAP.EvalString("List(DirectoriesLibrary(\"pkg\"), d -> Filename(d, \"\"))")))
            @warn "unable to find package named \"" * name * "\" in " * dirs
            return false
        end
        
        pkg = pkg[1]
        
        path = GAP.gap_to_julia( pkg.InstallationPath )
        
        @info "Compiling \"" * path * "\""
        
        cd(path)
        
        if install_script == false
            if name in PACKAGES_WITH_OLD_CONFIGURE
                run(`./configure $(GAP.GAPROOT)`)
            else
                run(`./configure --with-gaproot=$(GAP.GAPROOT)`)
            end
            run(`make -k -j$(Sys.CPU_THREADS)`) ## -k = Keep going when some targets can't be made.
        else
            run(`$(install_script) $(GAP.GAPROOT)`)
        end
        
        if GAP.Globals.TestPackageAvailability( gstr ) == GAP.Globals.fail
            @warn "Compiling the package \"" * name * "\" failed."
            return false
        end
        
        @info "Compiling the package \"" * name * "\" was successful."
        return true
        
    end
    
    if print_available == true
        @info "Package \"" * name * "\" is already installed."
    end
    
    return true
    
end

export CompileGapPackage

##
function DownloadPackageFromHomalgProject( pkgname )
    
    res = GAP.Globals.LoadPackage(GAP.julia_to_gap("PackageManager"), false)
    @assert res
    dir = HOMALG_PROJECT_PATH * "/pkg/"
    git = GAP.julia_to_gap("git")
    clone = GAP.julia_to_gap("clone")
    
    dir = dir * pkgname
    
    if isdir(dir)
        return true
    end
    
    @info "Cloning into \"" * dir * "\""
    pkgname = GAP.julia_to_gap("https://github.com/homalg-project/" * pkgname)
    pkgname = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap("."), git, clone, pkgname, GAP.julia_to_gap(dir));
    
    if pkgname.code != 0
        @warn "Cloning failed:\n" * GAP.gap_to_julia(pkgname.output)
        return false
    end
    
    return true
    
end
    
export DownloadPackageFromHomalgProject

##
function UpdatePackageFromHomalgProject( pkgname )
    
    res = GAP.Globals.LoadPackage(GAP.julia_to_gap("PackageManager"), false)
    @assert res
    dir = HOMALG_PROJECT_PATH * "/pkg/"
    git = GAP.julia_to_gap("git")
    pull = GAP.julia_to_gap("pull")
    
    dir = dir * pkgname
    
    if ! isdir(dir)
        return DownloadPackageFromHomalgProject( pkgname )
    end
    
    @info "Updating \"" * dir * "\""
    pkgname = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap(dir), git, pull, GAP.julia_to_gap("--ff-only"));
    
    if pkgname.code != 0
        @warn "Updating failed:\n" * GAP.gap_to_julia(pkgname.output)
        return false
    end
    
    @info GAP.gap_to_julia(pkgname.output)
    return true
    
end

export UpdatePackageFromHomalgProject

##
function RemovePackageFromHomalgProject( pkgname )
    
    res = GAP.Globals.LoadPackage(GAP.julia_to_gap("PackageManager"), false)
    @assert res
    dir = HOMALG_PROJECT_PATH * "/pkg/"
    rm = GAP.julia_to_gap("rm")
    opt = GAP.julia_to_gap("-rf")
    
    dir = dir * pkgname
    
    if ! isdir(dir)
        return false
    end
    
    @info "Removing \"" * dir * "\""
    pkgname = GAP.Globals.PKGMAN_Exec(GAP.julia_to_gap("."), rm, opt, GAP.julia_to_gap(dir));
    
    if pkgname.code != 0
        @warn "Remving failed:\n" * GAP.gap_to_julia(pkgname.output)
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
      "HomotopyCategories",
      "IntrinsicCategories",
      "IntrinsicModules",
      "InternalModules",
      "FinSetsForCAP",
      "FinGSetsForCAP",
      "FrobeniusCategories",
      "FunctorCategories",
      "GradedCategories",
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

global PACKAGES_TO_COMPILE =
    [ "Gauss",
      #"Browse", ## do not compile browse as it results into GAP raising the error "Error opening terminal: xterm-256color."
      "io",
      "digraphs",
      "ferret",
      "json",
      "orb",
      ]

global PACKAGES_WITH_OLD_CONFIGURE  =
    [ "Browse",
      "Gauss",
      "orb",
      ]
    
global PACKAGES_DOWNLOADING_EXTERNAL_CODE =
    [ "CddInterface",
      "NormalizInterface",
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
