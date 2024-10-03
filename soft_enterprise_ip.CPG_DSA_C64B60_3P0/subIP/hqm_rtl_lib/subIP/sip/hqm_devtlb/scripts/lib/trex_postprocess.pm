package trex_postprocess;

use strict;

use lib "$ENV{WORKAREA}/cfg/vte";
use VTEToolsConfig qw($dsn %env_data %model_data);

use TRex_lib;
use File::Basename;

# ------------------------------------------------------------------------------
sub TREX_INIT {
    # This script runs prior to the END stage for both passing and failing tests
    Project_Config::Intercept_Stage('END', \&post_process);
    return 1;
}

# ------------------------------------------------------------------------------
sub post_process {

    my $cmd;
    my $envname     = "${$main::opt{'dut'}}[-1]";
    my $model       = "${$main::opt{'model'}}[-1]";
    my $testseed    = "${$main::opt{'seed'}}[-1]";
    my $testname    = "$main::Test_Info{'Test_Name'}";
    my $run_mode    = `$ENV{VTE_AUTOMATION}/ace/get_run_mode.pl`;
    my $hsdenv      = $model_data{$model}{hsdenv};
    my $hsdproject  = $model_data{$model}{hsdproject};
    my $hsdowner    = '?';
    my $hsdtitle    = '?';
    my $resultspath = "$ENV{WORKAREA}/output/$envname/vcssim";
    my $buildname   = basename($ENV{WORKAREA});
    my $vcspath     = `cth_query -tool vcssim  PARAMS vcssim_vcs_path -resolve`;
    chomp $vcspath;

    $ENV{ACE_PROJECT_HOME} = $ENV{WORKAREA};
    $ENV{VCS_HOME} = $vcspath;
    $ENV{SNPSLMD_LICENSE_FILE} = `/var/licenses/getLf synopsys/vcsmx`;

    TRex_lib::log("\n");
    TRex_lib::log("+-------------------------------------------------\n");
    TRex_lib::log("| Running enhanced postsim script\n");
    TRex_lib::log("+-------------------------------------------------\n\n");

    $cmd = "$ENV{WORKAREA}/scripts/enhanced_postsim.pl -acemodel $model -run_mode $run_mode -envtype KLV -hsddsn $dsn -hsdenv $hsdenv -hsdproject $hsdproject -project $env_data{unix_group} -relpath $env_data{release_path}/$buildname -envname $envname -testname $testname -testseed $testseed -runmodel $ENV{WORKAREA} -resultspath $resultspath";
    TRex_lib::log("$cmd\n\n");
    `$cmd`;

    TRex_lib::log("+-------------------------------------------------\n");
    TRex_lib::log("| Running event coverage script\n");
    TRex_lib::log("+-------------------------------------------------\n\n");

    $cmd = "$ENV{VTE_AUTOMATION}/coverage/event_coverage.pl -vdbfile $ENV{WORKAREA}/output/$envname/vcssim/model/$model/$model.simv.vdb -unixgroup $env_data{unix_group} -collectdir $env_data{event_collect_dir} -mapfile $env_data{event_map_file} -coverage_db=coverage.vdb -testseed $testseed -urgexe $vcspath/bin/urg";
    TRex_lib::log("$cmd\n\n");
    `$cmd`;

    return 1;
}

# ------------------------------------------------------------------------------
1;

__END__

