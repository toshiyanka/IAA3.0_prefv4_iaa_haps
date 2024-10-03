#!/usr/intel/pkgs/perl/5.26.1/bin/perl
BEGIN {
    push( @INC,
        $ENV{RTL_UTIL_ROOT}, $ENV{RTL_UTIL_ROOT} . "/" . "lib" . "/" . "perl",
        $ENV{FLOW_ROOT},     $ENV{FLOW_ROOT} . "/" . "lib" . "/" . "perl" );
}

use strict;
use warnings;
use Data::Dumper;
use Config::General;
use lib "/p/dt/sde/tools/em64t_SLES11/perl_coverage/load_cover";
use load_cover;
use Cwd qw(cwd);
use Cwd 'abs_path';
use Try::Tiny;
use File::Copy qw(copy);
use CthRTLUtils;
use ConfigParser;
use Logger;
use Constants qw(:genfile :common);
use File::Path qw(make_path);
use File::Basename qw(basename dirname);
use FilelistReader;
use H2bConstants qw(:dcconst);
use XML::Simple;
use CthPostProcessing;
#use H2bUtils qw(create_symlink);
use H2bUtils
  qw(create_symlink clean_symlinks createH2BLog);
use File::Glob qw(bsd_glob);
## hash to store the config file details
my $configHash = {};
my $flowVersion     = "1.00";

################################### PROCESS ####################################
## run Target
##############################################################################
runTarget();

###################################################################################
## Method to process the config file
###################################################################################
sub runDPConfigTarget {
    my $defaultConfigFile = $ENV{FLOW_ROOT} . "/defaults/" . "$DEFAULT_CONFIG";

    $configHash = parseConfigFile( $defaultConfigFile, $ARGV[1] );
    ConfigParser::validateUserConfigOptions();
    if ( $configHash->{OUTPUT_DIR_OVERRIDE} ) {
        $configHash->{OUTPUT_DIR} =
          "$configHash->{OUTPUT_DIR_OVERRIDE}/designpackage";

    }

}

sub runTarget {
    unless ( defined $ENV{WORKAREA} ) {
        error(
"The environment variable 'WORKAREA' is not set, please set the variable and rerun\n"
        );
        exit(1);
    }
    if ( $ARGV[0] eq "clean" ) {
        runDPConfigTarget();
	cleanDPArea();
    }
    elsif ( $ARGV[0] eq "config" ) {
        runDPConfigTarget();
    }
    else {
        my $loggingHash->{version} = $flowVersion;
        logRunData($loggingHash);
        runDPConfigTarget();
        getBanner();
        my $log = createH2BLog("designpackage");        
        PrinteDpCollaterals();
        info "Log file: $log";
        closeLogFile();
	info "Successfully completed Design Package!\n";
    }
}

##############################################################################
# Sub:        PrinteDpCollaterals
# Info:       Main()
##############################################################################
sub PrinteDpCollaterals {

    my $dp_version;
    my $dp_root_path;
    my $gen_dp_collateral_cmd;
    my $views_csv;
    my $tech;
    my $pass = $configHash->{PASS};
    my $intel_tech = $configHash->{INTEL_TECH};
    my $output_dir = abs_path( trim( $configHash->{OUTPUT_DIR} ) );
    
    if ( lc( $configHash->{CTH_GK_MODE} ) ne "true" ) {
	create_symlink( "$output_dir", "output" );
    }

    ## Get dp_version either from flow.cfg or project override in rtl_tools.cth. 1st priority is flow.cfg
    if($configHash->{DP_VERSION}) {
	$dp_version = $configHash->{DP_VERSION};
    } elsif($configHash->{optionSource}->{DP_VERSION} eq "def-cfg") {
	$dp_version = &getInfraToolVersion('DP_VERSION');
	if ( defined $dp_version and $dp_version !~ /^\s*$/ ) {
	    $configHash->{DP_VERSION} = $dp_version;
	    &info("DesignPackage Version: $dp_version picked from cheetah env.");
	}
	
    }

    ## Get Technology info either from flow.cfg or project override in rtl_tools.cth. 1st priority is flow.cfg
    if($configHash->{TECH}) {
	$tech = $configHash->{TECH};
    } elsif($configHash->{optionSource}->{TECH} eq "def-cfg") {
	$tech = &getInfraToolVersion('TECH');
	if ( defined $tech and $tech !~ /^\s*$/ ) {
	    $configHash->{TECH} = $tech;
	    &info("DesignPackage Tech: $tech picked from cheetah env.");
	}
	
    }	
    #if (( defined $configHash->{DP_VERSION} ) and (( $configHash->{optionSource}->{DP_VERSION} eq "user-cfg" ) ) ) {
    #$dp_version = &getInfraToolVersion('DP_VERSION');
    #if ( defined $dp_version and $dp_version !~ /^\s*$/ ) {
    #    $configHash->{DP_VERSION} = $dp_version;
    #    &info("DesignPackage Version: $dp_version picked from cheetah env.");
    #}
    #else {
	#$dp_version = $configHash->{dp_VERSION};
	#&info("VD else >>> $dp_version");
	#error "Design Package version undefined!\n";
	#exit 1;
    #}
    

    if (!$configHash->{DP_VERSION}){
	error "Design Package version undefined!\n";
	exit 1;	
    }

    if (!$configHash->{TECH}){
	error "Design Package Tech undefined!\n";
	exit 1;	
    }
    
    ### Get DP_ROOT_PATH 
    if ($configHash->{DP_ROOT_PATH_OVERRIDE}){
	$dp_root_path = $configHash->{DP_ROOT_PATH_OVERRIDE};
    }
    else {
	if($intel_tech eq "true" && $tech eq "1276") {
	    $dp_root_path = "/p/hdk/cad/eou_tech_config_1276/$dp_version";
	} elsif($intel_tech eq "false" && $tech ne "1276") {
	    $dp_root_path = "/p/tech/$tech/tech-prerelease/$dp_version/flowinterface";
	} else {
	    error "$tech doesn't match with INTEL_TECH config. Please check your local cfg file";
            exit 1;
	}
    }

    if ( !-e $dp_root_path) {
            error "$dp_root_path: path does not exist. Check DP_VERSION config. Also check your $tech permission ";
            exit 1;
    }

    ## Choose the views csv file based on technology
    if ( $configHash->{VIEWS_CSV_OVERRIDE} ) {
	$views_csv = $configHash->{VIEWS_CSV_OVERRIDE};
    } elsif ($intel_tech eq "true") {
	$views_csv = "$ENV{FLOW_ROOT}/inputs/views_intel_tech.csv";
    } else {
	$views_csv = "$ENV{FLOW_ROOT}/inputs/views.csv";
    }
    
    info "DP version used is              : $dp_version";
    info "DP root path for $tech process  : $dp_root_path";
    info "DP views csv file used          :$views_csv";
    
      
    $gen_dp_collateral_cmd = "$ENV{FLOW_ROOT}/scripts/gen_dp_collaterals.tcl $intel_tech $dp_version $views_csv $configHash->{OUTPUT_DIR}/$pass/$tech $dp_root_path";
    info "Running DP command: $gen_dp_collateral_cmd\n";

    ### Run the tcl file in the tcsh - FIXME
    #my $dp_collateral_file = "$configHash->{OUTPUT_DIR}/$pass/${tech}.dp_collateral_run.tcl";
    #open( my $FH, "+>dp_collateral_file" )
    #	or die("Could not open $dp_collateral_file,$!");
    #print $FH "#!/usr/intel/bin/tcsh\n";
    #print $FH "cd $configHash->{OUTPUT_DIR}/$pass";
    #print $FH "$gen_dp_collateral_cmd\n";
    #close $FH;
    #info "Running DP command: $lib_analyze_cmd\n";
    #my $cmd    = "/usr/intel/bin/tcsh $dp_collateral_file";
    #my $status = system($cmd);
    ###############################trial 1

    open(my $FH, "$gen_dp_collateral_cmd 2>&1 |")
	or die("Could not open $gen_dp_collateral_cmd,$!");
    while(<$FH>) {
	info "$_";
	next;
    }    
    close $FH or die("Design Package command call failed. Exit status:$?,$!");
}


sub cleanDPArea {
    clean_symlinks();
    my $clean_all  = shift;
    my $output_dir = abs_path( trim( $configHash->{OUTPUT_DIR} ) );
    my @top_info   = split( ":", $configHash->{TOP} );
    my $work_directory;
    my $genfile_dir;

    $work_directory = "$output_dir";

    $genfile_dir =
"$ENV{WORKAREA}/output/$configHash->{DUT}/genfile_rtl/.pass/syn_genfile.PASS";
    $genfile_dir    = trim($genfile_dir);
    $work_directory = trim($work_directory);
    info "Cleaning $work_directory\n";
    if ( lc( $configHash->{CLEAN_GENFILE} ) eq "true" ) {
        if ( -e $genfile_dir ) {
            if ( !$configHash->{BLOCK_MODULE} ) {
                `rm -rf $genfile_dir`;
                info "Cleaning $genfile_dir\n";
            }
        }
    }
    if ( -e $work_directory ) {
        `rm -rf $work_directory`;
    }
    else {
        print "-I:Nothing to clean\n";
    }

}
