if not IsPackageMarkedForLoading( "IO_ForHomalg", ">=2020.02.26" ) then
    
MakeReadWriteGlobal( "LaunchCAS_IO_ForHomalg" );

LaunchCAS_IO_ForHomalg :=
  function( arg )
    local nargs, HOMALG_IO_CAS, executables, options, env, e, x, s;
    
    nargs := Length( arg );
    
    HOMALG_IO_CAS := arg[1];
    
    executables := [ ];
    
    if nargs > 1 and IsStringRep( arg[2] ) then
        Add( executables, arg[2] );
    fi;
    
    if nargs > 2 and IsList( arg[3] ) then
        if IsString( arg[3] ) then
            options := [ arg[3] ];
        else
            options := arg[3];
        fi;
    else
        options := HOMALG_IO_CAS.options;
    fi;
    
    if IsBound( HOMALG_IO_CAS.executable ) then
        if IsStringRep( HOMALG_IO_CAS.executable ) then
            Add( executables, HOMALG_IO_CAS.executable );
        elif ForAll( HOMALG_IO_CAS.executable, IsStringRep ) then
            Append( executables, HOMALG_IO_CAS.executable );
        fi;
    fi;
    
    if executables = [ ] then
        Error( "either the name of the ", HOMALG_IO_CAS.name,  " executable must exist as a component of the CAS specific record (normally called HOMALG_IO_", HOMALG_IO_CAS.name, " and which probably have been provided as the first argument), or the name must be provided as a second argument:\n", HOMALG_IO_CAS, "\n" );
    fi;
    
    env := Filename( DirectoriesSystemPrograms( ), "env" );
    
    if IsBound( HOMALG_IO_CAS.environment ) then
        e := HOMALG_IO_CAS.environment;
        if env = fail then
            Info( InfoWarning, 1, "the entry HOMALG_IO_CAS.environment is set but there is no executable `env'\n" );
        fi;
    else
        e := [ ];
    fi;
    
    for x in executables do
        
        s := Filename( DirectoriesSystemPrograms( ), x );
        
        if s <> fail then
            if not env = fail then
                s := IO_Popen3( env, Concatenation( e, [ s ], options ) );
            else
                s := IO_Popen3( s, options );
            fi;
        fi;
        
        if s <> fail then
            break;
        fi;
        
    od;
    
    if s = fail then
        Error( "found no ",  HOMALG_IO_CAS.name, " executable in PATH while searching the following list:\n", executables, "\n" );
    fi;
    
    s.stdout!.rbufsize := false;   # switch off buffering
    s.stderr!.rbufsize := false;   # switch off buffering
    
    s.SendBlockingToCAS := SendBlockingToCAS;
    s.SendBlockingToCAS_original := SendBlockingToCAS;
    
    s.TerminateCAS :=
      function( s )
        
        if s.stdin <> fail then
            IO_Close( s.stdin );
            s.stdin := fail;
        fi;
        
        if s.stdout <> fail then
            IO_Close( s.stdout );
            s.stdout := fail;
        fi;
        
        if s.stderr <> fail then
            IO_Close( s.stderr );
            s.stderr := fail;
        fi;
        
    end;
    
    return s;
    
end;

MakeReadOnlyGlobal( "LaunchCAS_IO_ForHomalg" );

fi;
