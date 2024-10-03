#-*-perl-*-
#--------------------------------------------------------------------------------
# INTEL CONFIDENTIAL
#
# Copyright (June 2005)2 (May 2008)3 Intel Corporation All Rights Reserved. 
# The source code contained or described herein and all documents related to the
# source code ("Material") are owned by Intel Corporation or its suppliers or
# licensors. Title to the Material remains with Intel Corporation or its
# suppliers and licensors. The Material contains trade secrets and proprietary
# and confidential information of Intel or its suppliers and licensors. The
# Material is protected by worldwide copyright and trade secret laws and treaty
# provisions. No part of the Material may be used, copied, reproduced, modified,
# published, uploaded, posted, transmitted, distributed, or disclosed in any way
# without Intels prior express written permission.
#
# No license under any patent, copyright, trade secret or other intellectual
# property right is granted to or conferred upon you by disclosure or delivery
# of the Materials, either expressly, by implication, inducement, estoppel or
# otherwise. Any license under such intellectual property rights must be express
# and approved by Intel in writing.
#
#--------------------------------------------------------------------------------
#--------------------------------------------------------------------------------
# $Author: vromaso $
# $Date: 2011/01/21 20:05:41 $
# $Revision: 1.48 $
# $Source: /nfs/ace/CVS/ace/lib/Ace/WorkModules/PostSimResults.pm,v $
#--------------------------------------------------------------------------------
# The default PostSimResults module
#
# Calls a default 'postsim.pl' script -- script parse the sim logs and determines
# PASS/FAIL status
#
# For the short term, we're just goint to hard-code some things.
# Later, we can add UDF crap to allow project customization
#
#--------------------------------------------------------------------------------
package common::PostSimResults;
use strict;
use FileHandle;
use Carp;
require "dumpvar.pl";

use Utilities::ProgramTools qw(check_args test_eval deepcopy);
use Utilities::Print;
use Utilities::System qw(Exit);
use Utilities::RunPerlCoverage qw(modify_script_for_coverage);
use Data::Dumper;

use vars qw($POSTSIM_RESULTS_FILE);
*POSTSIM_RESULTS_FILE = \"postsim.log"; #";

use vars qw(@ISA @EXPORT_OK);
use Ace::GenericScrag qw($CWD);
use Ace::CheckerManager;
require Exporter;
@ISA = qw(Exporter Ace::GenericScrag);

#--------------------------------------------------------------------------------
sub new {
  my ($class, %args) = @_;
  check_args( \%args,
	      -valid    => [qw(*)],
	      -require  => [qw()],
	    );

  my $self = $class->SUPER::new(%args);

  if ( ($self->get_option(-check_test)) and ($self->get_option(-use_simple_testlog_names)==0 ) ) {
         Exit 1, "ERROR: The 'check_test' (or -check_test switch) can only be used when '-use_simple_testlog_names' is enabled.\n";
  }
  return $self;
}
#--------------------------------------------------------------------------------
sub get_results_file {
  my ($self) = @_;
  return $self->{_results_file}
}
#-------------------------------------------------------------------------------
sub create_scrag {
  my ($self, %args) = @_;
 my $name = $args{-name};
 my $scrag;
 if (($name =~ /^exec_test$/) or ($name =~ /^static_check$/) or ($name =~ /^check_test$/) ) {  
  my $base_scope = Ace::UDF::get_base_scope();

  $scrag .= $self->_test_checker_scrag(%args);
  return $scrag;
 }
 else {
  $self->_unknown_ace_command_error($_);
 }

}
#-------------------------------------------------------------------------------
sub _test_checker_scrag {
  my ($self, %args) = @_;
  my $fragment = $self->SUPER::create_scrag(%args);
  my $cm = new Ace::CheckerManager;

  # Check the test results
  $fragment .= "\necho '# ACE SAFE TO PARSE'\n"  if ($self->get_option(-check_test));
  $fragment .= $self->_parse_test_results_scrag(%args);
  
  $fragment .= $cm->add_checkers(-group => 'onda_postchecker', -scope => $args{-cur_scope}, -tid => $args{-tid}, -file => __FILE__);
  $fragment .= $cm->add_checkers(-group => 'post_simulation',  -scope => $args{-cur_scope}, -tid => $args{-tid}, -file => __FILE__);
  $fragment .= $self->_call_nbstat(%args);

  return $fragment;
}
#-------------------------------------------------------------------------------
sub _parse_test_results_scrag {
  my ($self, %args) = @_;

  my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, Ace::UDF::get_base_scope());

  my $test_data 	= $args{-test_data};
  my $log_file		= $self->get_option(-enable_simv_log)?  $test_data->{$base_scope}{tid} . '.simv.log' :     $args{-logfile};

  my $workdir		= $test_data->{$base_scope}{workdir};
  my $testrun_dir       = $test_data->{$cur_scope}{testrun_dir};
  my $results_file      = $self->get_option(-postsim_log);

  my $pp_script 	= $self->find_executable($self->get_option(-post_process_parser), $cur_scope);
  my $base_patterns 	= $self->find_file($self->get_option(-post_process_pattern_file), $cur_scope);

  my $testinfo_pat_file = $self->find_file($self->get_option(-post_process_testinfo_base_file), $cur_scope);

  my $max_num_warn = ($self->get_option(-postsim_log_max_num_warn) != 0  )
                                          ? "-max_num_warn " . $self->get_option(-postsim_log_max_num_warn) 
                                          : undef; 
  my @sc_tools     = $self->get_array_option('-static_check_tools');
  my $e_pp_modes   = $self->get_option(-enabled_post_process_modes);
  my $ovr_modes ;
  if ( $self->get_option(-static_check) ) {
    foreach my $sc_tool (@sc_tools) {
      my $sc_pp_modes = $self->get_option("-${sc_tool}_post_process_modes");
         $sc_pp_modes = $e_pp_modes if (($sc_tool eq 'cdc') and ($sc_pp_modes eq '')); ## backward compatibility thing
      $ovr_modes .= ($ovr_modes =~ /\S+/)? ",$sc_pp_modes" : $sc_pp_modes;
    }
    $ovr_modes = ( $ovr_modes =~ /\S+/)? "-pp_modes_ovr $ovr_modes" : undef;
  } else {
    $ovr_modes = ($e_pp_modes =~ /\S+/)? "-pp_modes_ovr $e_pp_modes" : undef;  
  }

  my $ok_errors 	=   join ' ', map("-okError '$_'", $self->get_array_option(-ok_error));
  my $multiline_ok_errors = join ' ', map("-okError_multiLine '$_'", $self->get_array_option(-multiline_ok_error));
  my $force 		= ($self->get_option(-force_post_process)) ? "-force " : "";
  my $ppwt              = $self->get_option(-post_process_wait_times);
  my $waitTimes         = (defined $ppwt and scalar @{$ppwt}) ? "-incWaitTime $ppwt->[0] -maxWaitTime $ppwt->[1]":"";
  #my $create_res_links  = ($self->get_option(-create_postmortem_file)) ? "-nocreate_result_links" : '';
  my $pp_cmd            = "$pp_script $ovr_modes $max_num_warn -p $base_patterns -b $testinfo_pat_file -l $log_file -tid '$test_data->{$base_scope}{tid}' -r $results_file $ok_errors $multiline_ok_errors $force $waitTimes";

  if ( $self->get_option(-enable_simv_log) and (! $self->get_option(-static_check)) and ($self->get_option(-simulator) eq 'vcs' ) ) {
     $pp_cmd            .= ' -take_full_log ' 
  }

  my $pp_parse          = "$pp_script -mode 2 -r $workdir/$testrun_dir/$results_file";

  $pp_cmd = modify_script_for_coverage(
  		-name => "ace_postsim_record_data_cleanup",
		-cmd  => $pp_cmd,
		);
  my $fragment .= Ace::GenericScrag::chdir("$workdir/$testrun_dir");
  
  my $log2tcl = undef;
  if ( ($self->get_option(-enable_spyglass_log2tcl)and($self->get_array_option(-static_check_tools, -convert2string=>1 ) =~ /spyglass/)) ) {
     $log2tcl    .= $self->_log2tcl_exe(%args);
  }

  $fragment .= <<EOS;

if [ -f \${ACE_LOGFILE}.gz ]; then
    gunzip -f \${ACE_LOGFILE}.gz
fi

# ------------------------------------------------
# Collect the test results
# Creates either
#	postsim.pass
# or
#	postsim.fail
# ------------------------------------------------
echo \"\nParse Test Results: `date --universal`\"    #"
echo \"=========================\"
echo \">> $pp_cmd\"               #"
$pp_cmd
POSTSIM_RC=\$?
checkrc PARSE_RESULTS

$log2tcl 

# check for result file

TRC=0
POSTSIM_STATUS="PASS"
if [[ -e "postsim.fail" ]]
then
  TRC=99
  POSTSIM_STATUS="FAIL"
     HAS_ERROR=1
fi

EOS

  #####################
  if ($self->get_option(-create_postmortem_file)) {
    my $postmortem_file        = $self->get_option(-postmortem_log);
    my $Pm = new Ace::PostMortem();
    $fragment .= "echo \">> Rollup $results_file to ". $self->get_option(-postmortem_log) ."\"\n";
    $fragment .= "outcontents=`cat $results_file`\n";
    $fragment .= $Pm->create_reap_process_scrag(-cmd => $pp_cmd,
                                            -status_holder => 'POSTSIM_STATUS', -rc_holder => 'POSTSIM_RC',
                                            -process_name  => 'POSTSIMPL', -process_type => "checker",
                                            -outvar => "outcontents",
                                            -ext_parse_cmd => "$pp_parse",
                                            );
  }        
  $fragment .= "check_givenrc POSTSIMPL \$POSTSIM_RC\n\n";  
  
  return $fragment;
}
#-------------------------------------------------------------------------------
# Use NB Log system to log stats
#-------------------------------------------------------------------------------
sub _call_nbstat {
  my ($self, %args) = @_;

  my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, Ace::UDF::get_base_scope());
  my $test_data 	= $args{-test_data};
  my $workdir		= $test_data->{$base_scope}{workdir};
  my $testrun_dir       = $test_data->{$cur_scope}{testrun_dir};

  my $pp_script 	= $self->find_executable($self->get_option(-post_process_parser), $cur_scope);
  my $nblog_script 	= $self->find_executable($self->get_option(-log_nb_stats_script), $cur_scope);

  my $results_file      = $self->get_option(-postsim_log);
  my $simulator         = $self->get_option(-simulator);
  my $model_rev         = $self->get_option(-model_revision);

  my $cmd               = "$nblog_script -pp $pp_script -r $results_file -s $simulator -mr $model_rev ";
  
  my $fragment;

  if ($self->get_option(-ace_mode) eq 'remote') {
    if ($self->get_option(-log_nb_stats)) {
      print "LOGGING nbstats\n";
      $fragment .= Ace::GenericScrag::chdir("$workdir/$testrun_dir");
      $fragment .= Ace::GenericScrag::add_cmd("NB_LOG", $cmd);

    }
  }
  return $fragment;
}
sub _log2tcl_exe {
    my ($self, %args) = @_;
    my $fragment;
    my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, Ace::UDF::get_base_scope());
    my $log2tcl_exe     = $self->get_option(-spyglass_log2tcl_exe );
    my $log2tcl_args    = $self->get_array_option(-spyglass_log2tcl_args, -convert2string=>1  );
    my $dot_f_dir = $self->get_option(-model_compile_results_dir) . "/dot_f/spyglass";

    my $sc_top        = $self->get_option(-static_check_top);
    my ($toplib,$top) = split /\./, $sc_top;
    
    my $test_data 	= $args{-test_data};
    my $testname        = $test_data->{$cur_scope}{name};
    my $workdir		= $test_data->{$base_scope}{workdir};
    my $testrun_dir     = "$workdir/" . $test_data->{$cur_scope}{testrun_dir};

    my $cmd  = "$self->{_timer} $log2tcl_exe ";
       $cmd .= "-ti $top ";
       $cmd .= "-tm $top ";
       $cmd .= "-spyglass_elab_log $testrun_dir/$top/$top/Group_Run/spyglass_reports/SpyGlass/elab_summary.rpt ";
       $cmd .= " $log2tcl_args ";
       $cmd .= "-dot_f_dir $dot_f_dir ";
       $cmd .= "-res_dir $workdir";
       
       $fragment .= 'if [[ -e "postsim.pass" ]]; then' . "\n";
       $fragment .= '   ' . 'echo "==> Running log2tcl RLT file-list generation"' ."\n";
       my $f = '   ' . Ace::GenericScrag::add_cmd("LOG2TCL_EXE" , $cmd);
          $f =~ s/\n(\S+)/\n   $1/g;
       $fragment .= $f; 
       $fragment .=  "fi\n";


    return $fragment;
}
#-------------------------------------------------------------------------------
1;
