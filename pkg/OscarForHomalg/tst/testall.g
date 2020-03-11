#
# OscarForHomalg: OscarForHomalg with extra structure
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "OscarForHomalg" );
LoadPackage( "Modules" );

HOMALG_IO.show_banners := false;

TestDirectory( DirectoriesPackageLibrary( "OscarForHomalg", "tst" ),
  rec(
        testOptions := rec ( compareFunction := "uptowhitespace" ),
        exitGAP := true,
     )
);

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
