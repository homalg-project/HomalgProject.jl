#
# OscarForHomalg: Use Singular via its interpreter
#
# Declarations
#

#! @Chapter Accessing the Singular interpreter via JuliaInterace

# our info class:
DeclareInfoClass( "InfoJSingularInterpreterForHomalg" );
SetInfoLevel( InfoJSingularInterpreterForHomalg, 1 );

# a central place for configurations:
DeclareGlobalVariable( "JSingularInterpreterForHomalg" );

####################################
#
# global functions and operations:
#
####################################

DeclareGlobalFunction( "LaunchCASJSingularInterpreterForHomalg" );

DeclareGlobalFunction( "SendBlockingToCASJSingularInterpreterForHomalg" );

# constructor methods:

# basic operations:

