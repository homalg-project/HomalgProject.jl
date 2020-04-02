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

if not IsPackageMarkedForLoading( "HomalgToCAS", ">=2020.02.26" ) then
    
MakeReadWriteGlobal( "LaunchCAS" );

LaunchCAS := function( arg )
    local nargs, HOMALG_IO_CAS, executables, e, s;
    
    nargs := Length( arg );
    
    HOMALG_IO_CAS := arg[1];
    
    if IsString( HOMALG_IO_CAS ) then
        HOMALG_IO_CAS := ValueGlobal( HOMALG_IO_CAS );
    else
        Error( "for security reasons LaunchCAS only accepts a string (as a first argument) which points to a HOMALG_IO_CAS record\n" );
    fi;
    
    if IsBound( HOMALG_IO_CAS.LaunchCAS ) and IsFunction( HOMALG_IO_CAS.LaunchCAS ) then
        
        s := CallFuncList( HOMALG_IO_CAS.LaunchCAS, arg );
        
        if s = fail then
            Error( "the alternative launcher returned fail\n" );
        fi;
        
    else
        
        if LoadPackage( "IO_ForHomalg" ) <> true then
            Error( "the package IO_ForHomalg failed to load\n" );
        fi;
        
        s := CallFuncList( LaunchCAS_IO_ForHomalg, Concatenation( [ HOMALG_IO_CAS ], arg{[ 2 .. nargs ]} ) );
        
    fi;
    
    for e in NamesOfComponents( HOMALG_IO_CAS ) do
        if not IsBound( s.( e ) ) then
            s.( e ) := HOMALG_IO_CAS.( e );
        fi;
    od;
    
    if not IsBound( s.variable_name ) then
        s.variable_name := HOMALG_IO.variable_name;
    fi;
    
    if IsBound( HOMALG_IO.color_display ) and HOMALG_IO.color_display = true
       and IsBound( s.display_color ) then
        s.color_display := s.display_color;
    fi;
    
    if IsBound( HOMALG_IO.DeletePeriod ) and
       ( IsPosInt( HOMALG_IO.DeletePeriod ) or IsBool( HOMALG_IO.DeletePeriod ) ) then
        s.DeletePeriod := HOMALG_IO.DeletePeriod;
    fi;
    
    s.StatisticsObject :=
      NewStatisticsObject(
              rec(
                  LookupTable := "HOMALG_IO.Pictograms",
                  summary := rec(
                       HomalgExternalCallCounter := 0,
                       HomalgExternalVariableCounter := 0,
                       HomalgExternalCommandCounter := 0,
                       HomalgExternalOutputCounter := 0,
                       HomalgBackStreamMaximumLength := 0,
                       HomalgExternalWarningsCounter := 0
                       )
                  ),
              TheTypeStatisticsObjectForStreams
              );
    
    s.homalgExternalObjectsPointingToVariables :=
      ContainerForWeakPointers( TheTypeContainerForWeakPointersOnHomalgExternalObjects );
    
    s.homalgExternalObjectsPointingToVariables!.assignments_pending := [ ];
    s.homalgExternalObjectsPointingToVariables!.assignments_failed := [ ];
    s.homalgExternalObjectsPointingToVariables!.processes := [ ];
    
    if IsBound( s.InitialSendBlockingToCAS ) then
        s.InitialSendBlockingToCAS( s, "\n" );
    else
        s.SendBlockingToCAS( s, "\n" );
    fi;
    
    if ( not ( IsBound( HOMALG_IO.show_banners ) and HOMALG_IO.show_banners = false )
         and not ( IsBound( s.show_banner ) and s.show_banner = false ) )
       and ( ( IsBound( s.banner ) and ( IsString( s.banner ) or IsFunction( s.banner ) ) )
             or Length( s.lines ) > 0 ) then
        Print( "================================================================\n" );
        if IsBound( s.color_display ) then
            Print( s.color_display );
        fi;
        if IsBound( s.banner ) and IsString( s.banner ) then
            Print( s.banner );
        elif IsBound( s.banner ) and IsFunction( s.banner ) then
            s.banner( s );
        else
            Print( s.lines );
        fi;
        Print( "\033[0m\n================================================================\n" );
    fi;
    
    return s;
    
end;

MakeReadOnlyGlobal( "LaunchCAS" );

fi;
