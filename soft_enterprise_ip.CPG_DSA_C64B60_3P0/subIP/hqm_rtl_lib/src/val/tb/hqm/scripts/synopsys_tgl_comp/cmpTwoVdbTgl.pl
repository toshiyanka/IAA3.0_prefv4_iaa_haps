eval 'exec perl -S $0 ${1+"$@"}'
if 0;

use File::Basename;
use Cwd qw(abs_path);

#
# Check VERDI_HOME
#
my $Verdi_Dir = "";
if( -e $ENV{"VERDI_DIR"} ) {
    $Verdi_Dir = $ENV{"VERDI_DIR"};
}
elsif( -e $ENV{"VERDI_HOME"} ) {
    $Verdi_Dir = $ENV{"VERDI_HOME"};
}
elsif( -e $ENV{"NOVAS_HOME"} ) {
    $Verdi_Dir = $ENV{"NOVAS_HOME"};
}
else {
    print "Please set env. \$VERDI_HOME to launch the VC App.\n";
    exit;
}

#
# Variables declaration
#
my $Shared_Lib_Name  = "libCmpTwoVdbTgl.so";
my $Prog_Name        = "cmpTwoVdbTgl";
my $C_Main           = "cmp_two_vdb_tgl";
my $Has_Help         = "FALSE";
my @Novas_Import_Arg;

#
# Shared Library Path
#
#my $Shared_Lib_Path = "";
#if( -e $ENV{"VCAPPS_SHARED_LIB_PATH"} ) {
#    $Shared_Lib_Path = $ENV{"VCAPPS_SHARED_LIB_PATH"};
#}
#elsif( -e $ENV{"VCAPP_SHARED_LIB_PATH"} ) {
#    $Shared_Lib_Path = $ENV{"VCAPP_SHARED_LIB_PATH"};
#}
#else {
#    print "Please set env. \$VCAPPS_SHARED_LIB_PATH for the library $Shared_Lib_Name to launch the VC App.\n";
#    exit;
#}

#
# Argument
#
my $App_Lib           = "";
my $Output            = "comp_result.log";
my $VDB1              = "";
my $VDB2              = "";
my $Scope             = "";  
my $Has_Scope         = "FALSE";
my $El_File           = "";
my $Has_El_File       = "FALSE";
my $Only_Port         = "FALSE";

#
# Temp Tcl - use PID to avoid conflict
#
my $tmp_tcl = "${Prog_Name}_$$.tcl"; 

#
# Parse argument
#
if( $#ARGV < 0 ) {
    &print_usage;
    exit;
}

&parse_argv;
if( $Has_Help =~ /TRUE/ ) {
    &print_usage;
    exit;
}
if( $App_Lib eq "" ) {
    print "Please specify -vcapp_lib <path>/$Shared_Lib_Name option...\n";
    exit;
}
if( $VDB1 eq "" ) {
    print "Please specify -vdb1 <simv.vdb> option...\n";
    exit;
}
if( $VDB2 eq "" ) {
    print "Please specify -vdb2 <simv.vdb> option...\n";
    exit;
}

#
# Play Verdi tcl
#
&play_verdi_tcl;

#################################################
# Sub-routine : gen_verdi_tcl()
#################################################
sub gen_verdi_tcl {
    open(FP, "> $tmp_tcl") or die "Failed to write out files in current directory...\n";
    print FP "viaSetupL1Apps \n";
    print FP "npiDlOpen -lib $App_Lib\n";
    print FP "npiDlSym -func \"$C_Main\" -vdb1 $VDB1 -vdb2 $VDB2 ";

    if( $Output eq "" ) {
    }  
    else {
        print FP "-o $Output ";
    }  

    if( $Only_Port =~ "TRUE" ) {
        print FP "-only_port ";
    }  

    if( $Has_Scope =~ "TRUE" ) {
        print FP "-scope $Scope ";
    }  

    if( $Has_El_File =~ "TRUE" ) {
        print FP "-elfile $El_File ";
    }  

    print FP "\n";
    print FP "debExit \n";
    close(FP);
}

sub print_help {
    print "\nUsage: \n";
    print "  cmpTwoVdbTgl.pl -vcapp_lib <vcapp_shared_lib> -vdb1 <the coverage database <dir>> -vdb2 <the coverage database <dir>> [-scope <scope name>] [-only_port] [-elfile <exclude_file>] [-o <output file>] \n";
    print "  Arguments: \n";
    print "    -vcapp_lib <path>/libCmpTwoVdbTgl.so:  specify the VC App shared lib. \n";
    print "    -vdb1     <dir>                        the first coverage database in <dir>. \n";
    print "    -vdb2     <dir>                        the second coverage database in <dir>. \n";
    print "    -scope    <scope name>                 only check the scope and its sub scopes. \n";
    print "    -only_port                             when specify this option, only check ports. \n";
    print "    -elfile   <exclusion file>             Exclusion file to be loaded. \n";
    print "    -o        <output file>                If not specified, default is comp_result.log. \n";
    print "\n";
    print "  Ex: cmpTwoVdbTgl.pl -vcapp_lib ./libCmpTwoVdbTgl.so -vdb1 simv1.vdb -vdb2 simv2.vdb -scope tb_top \n";
}

#################################################
# Sub-routine : play_verdi_tcl()
#################################################
sub play_verdi_tcl {
    my $Novas_Bin = "$Verdi_Dir/bin/verdi";
    if( ! -e $Novas_Bin ) {
	print "Failed to find Verdi executable. Please set the env \"VERDI_HOME\" correctly.\n";
	exit;
    }

    &gen_verdi_tcl;

    my $import_design_cmd = "";
    for(my $i=0; $i<=$#Novas_Import_Arg; $i++) {
      $import_design_cmd = "$import_design_cmd" . " $Novas_Import_Arg[$i]";
    }

    #system("$Novas_Bin $import_design_cmd -play $tmp_tcl -batch");
    system("$Novas_Bin -play $tmp_tcl -batch");
    system("\\rm -f $tmp_tcl");
}

#################################################
# Sub-routine : parse_argv()
#################################################
sub parse_argv {
  for(my $i=0; $i<=$#ARGV; $i++) {
    if( $ARGV[$i] =~ /^-o/i ) {
      $i++;
      $Output = $ARGV[$i];
    }
    elsif( $ARGV[$i] =~ /^-vcapp_lib/i ) {
      $i++;
      $App_Lib = $ARGV[$i];
    }
    elsif( $ARGV[$i] =~ /^-vdb1/i ) {
      $i++;
      $VDB1 = $ARGV[$i];
    }
    elsif( $ARGV[$i] =~ /^-vdb2/i ) {
      $i++;
      $VDB2 = $ARGV[$i];
    }
    elsif( $ARGV[$i] =~ /^-scope/i ) {
      $i++;
      $Scope = $ARGV[$i];
      $Has_Scope = "TRUE";
    }
    elsif( $ARGV[$i] =~ /^-elfile/i ) {
      $i++;
      $El_File = $ARGV[$i];
      $Has_El_File = "TRUE";
    }
    elsif( $ARGV[$i] =~ /^-only_port/i ) {
      $Only_Port = "TRUE";
    }
    elsif( $ARGV[$i] =~ /^-h/i ) {
      $Has_Help = "TRUE";
    }
    else { ### other options
      push @Novas_Import_Arg, $ARGV[$i];
    }
  }
}

#################################################
# Sub-routine: print_usage
#################################################
sub print_usage {
    my $Novas_Bin = "$Verdi_Dir/bin/verdi";
    if( ! -e $Novas_Bin ) {
	print "Failed to find Verdi executable. Please set the env \"VERDI_HOME\" correctly.\n";
	exit;
    }

    &print_help;
}
