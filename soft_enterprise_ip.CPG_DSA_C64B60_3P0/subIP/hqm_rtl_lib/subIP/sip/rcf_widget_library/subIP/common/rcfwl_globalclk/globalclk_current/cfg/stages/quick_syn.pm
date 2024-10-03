######################################################################
# VCS Stage
#
# No dependency checks are done prior to executing VCS as
# we're relying on VCS' incremental build capability to figure
# out if rebuilding is required.
#
# Output from stage is logged to vcs.log
#
######################################################################
######################################################################
# Flow definition
######################################################################
package quick_syn_flow;

use ToolConfig;
use lib ToolConfig_get_tool_path("srvr10nm_flows") . '/lib';
use acebuild_flow;
use RTLUtils;
@quick_syn_flow::ISA = qw ( acebuild_flow );

#sub setup($) {
#  my $self = shift;
#  my $flow_ptr = shift;
#  my $status = 0;
#  $status = $self->SUPER::setup($flow_ptr, [ '$synopsysSimSetupFile' ]);
#  
#  $flow_ptr->{setup_ok} = 1 unless $status;
#}

sub pre_flow($) {
  my $self = shift;
  my $scopedVars = shift;
  my $status = 0;

  $status = $self->SUPER::pre_flow($scopedVars);

  print "ERROR: quick_syn is deprecated for your IP; Please run HDK FEBE insstead; Refer to https://securewiki.ith.intel.com/display/P17X/HDK+FEBE for cheatsheet/documentation\n" ;
  $status = 1;

  return $status;
}

#sub post_flow($) {
#  my $self = shift;
#  my $scopedVars = shift;
#  my $status = 0;
#
#  $status = $self->SUPER::pre_flow($scopedVars);
#
#  return $status;
#}

#sub opt_spec() {
#  my $self = shift;
#  my $opt_spec = $self->SUPER::opt_spec();
#  $opt_spec->{vericomtarget} = {TYPE => "string", DEFAULT => "vericom_2value",};
#
#  return $opt_spec;
#}

package quick_syn;
use IPC::Open2;

use RTLUtils;
use ToolConfig;
use Data::Dumper;
use File::Basename;
use File::Path;
use Utils;
use acebuild_lib_base;
use lib ToolConfig_get_tool_path("srvr10nm_flows") . '/lib';
use strict;
use warnings;

@quick_syn::ISA = ("acebuild_model_base");

my $timeout = 0;
my @errors;
my $recordError = 0;

########## Stage Constructor ##########
sub new {
   my $class = shift;
   my $stagevars = shift;
   my $scopedvars = shift;

   # Define stage options here
   $stagevars->opt_spec( 
                        {                     
                        }
                   );
   # allow arguments pass thru to VCS.
   $stagevars->enable_passthru(1);
   # call base constructor
   my $self = $class->SUPER::new($stagevars, $scopedvars);
}

########## Stage Body ##########

sub run {
    my $self = shift;
    #print_info(Dumper($self));
    my $flowVars   = $self->{flow_vars};
    my $scopedVars   = $self->{scoped_vars};
    my $status = 0;

    my $targetRoot = $flowVars->{targetRoot};
    my $topModel   = $self->{opts}->{topModel};
    my $library    = $self->{opts}->{library}->[0];
    my $target_dir = $targetRoot . "/quick_syn" ;
    &RTL_mkDir( [$target_dir] );
    &RTL_mkDir( ["$target_dir/log"] );

    #template scripts for DC run
    my $quick_syn_script = &ToolConfig::get_tool_path('srvr10nm_flows')."/stages/run_quicksyn.pl";

    my $aceModel = $self->get_model() ;
    my $tdut = $aceModel->name ;
    #print_info("QWER -> tDut = $tdut\n" );
    my @quick_syn_par = () ;
    @quick_syn_par   = $aceModel->get_tags('QUICK_SYN_PAR') ;
    if (!(scalar @quick_syn_par > 0)) {  ## if quick_syn_par specified in udf file than use "model" name
      push @quick_syn_par, "$tdut" ;
    }

    # Added by gprasann to handle quick_syn enabling by setting DC variables -
    # HSD 1404156748
    my @febe_dir = ();
    my $febe_cfg_dir = undef;
    @febe_dir = $aceModel->get_tags('FEBE_CFG_DIR') ;
    # print_info("QWER -> febe = @febe_dir\n" );
    $febe_cfg_dir = $febe_dir[0];
    print_info ("febe_cfg_dir =  @febe_dir\n");

    print_info("targetRoot = $flowVars->{targetRoot}\nquick_syn_par = @quick_syn_par\n");
    #$status = &setup_dc_run($flowVars->{dut}, $targetRoot, "$ENV{MODEL_ROOT}/cfg/dc_scripts");
    #amitk $status = $status | &setup_dc_run($tdut, $targetRoot, $dc_scripts);

    my @cmds = () ;
    my @cmd_info = () ;
    foreach my $block (@quick_syn_par) {
       my @cmd = ()  ;
       push @cmd , $quick_syn_script ;
       push @cmd , "-block $block -target_dir $target_dir -dut $tdut -mr $ENV{MODEL_ROOT} " ;
       push @cmd , "-febe_cfg_dir $febe_cfg_dir" if ($febe_cfg_dir);
       push @cmd , " -sched $self->{scheduler}{type} ";
       my $quicksyn_log = "$target_dir/log/${block}_quicksyn.log" ;
       push @cmd , ">& $quicksyn_log" ;
       push @cmds, [ (join " ",@cmd),$quicksyn_log ] ; 
       push (@cmd_info, { "runcmd" => (join " ",@cmd),
                          "block"  => $block,
                       }) ;
    }
    #$status =  &RTL_execControl (@cmds, "$target_dir/log/.fork_quicksyn") ;
    ### Forking jobs, Above RTL_execControl is failing b/c of non-zero exit status returned from Setup
    my $n_runs_in_progress = 0;
    my %quicksyn_pid ;
    my $i = 0;

if (scalar @cmd_info eq "1" ) {
   my $cmd_line = $cmd_info[0]->{runcmd} ;
   print_info("Executing: $cmd_line\n");
   system("$cmd_line");
} else  {

    while (1) {
       if ( $i < scalar(@cmd_info) ) {
          my $quick_syn_run = $cmd_info[$i] ;
          $i++;
          # start new run
          my $kidpid = fork();
          die "ERROR: quick_syn.pm : fork() call failed\n" unless (defined($kidpid));
          if ($kidpid) {
             # it's parent
             $quick_syn_run->{pid} = $kidpid;
             $n_runs_in_progress++;
          } else {
             # it's a child
             my $cmd_line = $quick_syn_run->{runcmd};
             print_info("Forking: $cmd_line\n");
             print_info("\n") ;
             system("$cmd_line");
             my $res = $?;
             #amitk print_info("FINISH(res=$res): $cmd_line\n");
             #amitk exit($res | 1) if ($res);
             exit(0);
          }
       } else {
            if ($n_runs_in_progress > 0) {
               # wait for some run to finish.
               my $kidpid = wait();
               my $exit_status = $?;
               if ($kidpid == -1) {
                  # this means no runs in progress left. But that's not smth we expect.
                  $n_runs_in_progress = 0;
                  die "ERROR: error in quick_syn.pm wait() returned -1 while some chef runs still expected to be active\n";
               }
               # find run_info entry assotiated with this pid.
               my $syn_run;
               my $found = 0;
               RUN_SEARCH: foreach $syn_run (@cmd_info) {
               if ((defined($syn_run->{pid})) && ($syn_run->{pid} == $kidpid)) {
                  $syn_run->{exit_status} = $exit_status;
                  $found = 1;
                  last RUN_SEARCH;
               }
            }
            unless ($found) {
            # this shouldn't happen. We have a child that we don't have report about.
               die "ERROR: error in quick_syn.pm wait() returned pid that we don't have record about. That's bad.\n";
            }
        $n_runs_in_progress--;
      }
    }
    # determine whether we exit the loop
    if ( ($n_runs_in_progress == 0) && ($i >= scalar(@cmd_info)) ) {
      last;
    }
  }
}

  ##Parse Logfile to determine pass/fail status
  foreach my $syn_run (@cmd_info) {
     my $log_file =  "$target_dir/$syn_run->{block}/syn/logs/dc.log" ;
     if (!(-e $log_file )) { print_error("[ERROR] : DC logfile missing, Please check $target_dir/log/$syn_run->{block}_quicksyn.log\n") ;  $status |= 1 ;} 
     my @dc_errors = `perl -ne 'print if /-E-|ERROR-MSG|child process exited abnormally/' $log_file` ; 
     if (@dc_errors){
        my $dc_str = join " " , @dc_errors ;
        print_error("[ERROR] : Found errors in $log_file\n");
        print_error("SUMMARY : $dc_str\n");
        $status |= 1 ; 
     }
  }

  $self->{run_status} = $status;
  return $status;
}

sub help{
}

1;
