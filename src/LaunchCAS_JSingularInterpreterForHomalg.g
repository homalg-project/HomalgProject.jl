##
LaunchCAS_JSingularInterpreterForHomalg_preload :=
  function( arg )
    
    ## needed for LaunchCAS_JSingularInterpreterForHomalg below
    if not LoadPackage( "OscarForHomalg", false ) = true then
        Error( "unable to load OscarForHomalg\n" );
    fi;
    
    return CallFuncList( ValueGlobal( "LaunchCAS_JSingularInterpreterForHomalg" ), arg );
    
end;
