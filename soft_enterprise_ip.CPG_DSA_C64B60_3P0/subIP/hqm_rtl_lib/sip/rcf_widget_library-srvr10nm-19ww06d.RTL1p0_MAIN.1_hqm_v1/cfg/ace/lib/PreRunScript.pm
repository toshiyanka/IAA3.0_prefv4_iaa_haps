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
package PreRunScript;

#use IP_Config qw(
#      $ovm_ROOT
#      $saola_ROOT
#      $configdb_ROOT
#      $systeminit_ROOT
#      $LINUX_PLATFORM
#);

#use IP_Config qw(
#    $basechecker_ROOT
#    $IP_AVN_RTF_ROOT
#    $IP_AVN_FNB_ROOT
#    $csv_ROOT
#    $CPU_SVTB_ROOT
#);

use strict;
use FileHandle;
use File::Basename;

use Carp;

require "dumpvar.pl";

use Utilities::ProgramTools qw(check_args test_eval deepcopy);
use Utilities::Print;
use Utilities::System qw(Exit Mkpath);
use Data::Dumper;

use vars qw(@ISA @EXPORT_OK);
use Ace::GenericScrag qw($CWD add_cmd);
use Ace::WorkModules::HDL;
use ToolConfig;
#use OneCfg::UDF;
use Ace::UDF;

require Exporter;
#-------------------------------------------------------------------------------
# Work modules MUST inherit form Ace::GenericScrag - this class contains
#      the base functionality
#
# Ace::WorkModules::HDL contains some functionality useful to HDL (currently
#      verilog only). 
#-------------------------------------------------------------------------------
@ISA = qw(Exporter Ace::WorkModules::HDL Ace::GenericScrag );

use vars qw(%params);

#-------------------------------------------------------------------------------
# MEMBER Functions
#--------------------------------------------------------------------------------
sub new {
    my ($class, %args) = @_;

    check_args(
        \%args,
        -valid    => [qw(* -debug)],
        -require  => [qw()], # look at parent for the required args
    );

    my $self = $class->SUPER::new(%args);

    #---------------------------------------------------------
    # Define all expected member variables.  Use 'undef' if
    # no value is set yet (ie, set later)
    #---------------------------------------------------------
    $self->{_array}   = undef;
    $self->{_message} = "Hello, world\n";
    $self->{_file}    = "output";
    $self->{_sandbox} = "template/sandbox";

    return $self;
}

#-------------------------------------------------------------------------------
# The following are member functions that MUST be supplied by the workmodule
#-------------------------------------------------------------------------------
# Switch for the various MODELSIM scrags
#-------------------------------------------------------------------------------
sub create_scrag {
    my ($self, %args) = @_;

    #---------------------------------------------------------
    # Use dprint for TOOL debug message -- these are messages useful to the
    # tool developer
    #---------------------------------------------------------

    #---------------------------------------------------------
    # The name corresponds with an action defined in the ace.hdl InterfaceVars
    # There may be multiple actions mapped to this single workmodule
    #---------------------------------------------------------
    $_ = $args{-name};

    SWITCH: {
        /^build_test/ && do { return $self->_create_pre_run_scripts_scrag(%args); };

        $self->_unknown_ace_command_error($_);
    }
}


#-------------------------------------------------------------------------------
# Creates the SCRAG that causes pre run scripts to occur
#-------------------------------------------------------------------------------
sub _create_pre_run_scripts_scrag {
    # Look in the parents 'create_scrag' list of possible arguments
    my ($self, %args) = @_;
    my $test_opts;
    my $vlogopts     = $self->get_option('-vlog_opts');
    print "\nVLOG_OPTS = @$vlogopts\n\n\n\n\n\n";

    my $merged_test_opts  = $args{-merged_test_opts};
    my $test_data   = $args{-test_data};
    my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, &Ace::UDF::get_base_scope());
    my $rundir      = $self->get_option(-results);
    my $testrun_dir = $test_data->{$cur_scope}{testrun_dir};
    my $test = $test_data->{$cur_scope}{test};
    my $test_results_dir = "$rundir/$testrun_dir";

    my $testsrcdir = "";
    my $skipASMbuild = 0;
    # The fragment is a fragment of /bin/sh script
    # Script is executed in the CURRENT directory (Ace::Executer executes it)
    # Make sure to CHDIR to the appopriate dir

    my $fragment = "";


    $fragment .= "echo ===========================================\n";
    $fragment .= "echo  Begin $ENV{ACE_PROJECT} PreRunScript\n";
    $fragment .= "echo ===========================================\n";
    $fragment .= "echo \n";

    $fragment .= Ace::GenericScrag::chdir("$test_results_dir");


    ############
    # Systeminit
    ############
    my $dut_cfg 	= $merged_test_opts->{$cur_scope}{-dut_cfg};
    my $model           = $merged_test_opts->{$cur_scope}{-model};
    $dut_cfg =~ s/$ENV{DUT}.dut_cfg/$model.dut_cfg/g;
    my $dut_cfg_outfile	= $merged_test_opts->{$cur_scope}{-dut_cfg_outfile};
    # If -no_systeminit was specified, just copy the input .dut_cfg to the output .dut_cfg
    if ($merged_test_opts->{$cur_scope}{-no_systeminit}) {
      if ($dut_cfg && $dut_cfg_outfile) {
        $fragment .= Ace::GenericScrag::add_cmd("SYSTEMINIT", "cp $dut_cfg $dut_cfg_outfile");
      }
    }
    # Otherwise, run systeminit
    else {
      $fragment .= "echo ===========================================\n";
      $fragment .= "echo  Running Systeminit\n";
      $fragment .= "echo ===========================================\n";
      $fragment .= "echo \n";
      # Get ACE options
      my $dec_seed = hex($test_data->{$base_scope}{seed});
      my $project_constraints=$merged_test_opts->{$cur_scope}{-project_constraints};
      my $test_constraints= $merged_test_opts->{$cur_scope}{-test_constraints};
      my $test_constraints_incdirs= $merged_test_opts->{$cur_scope}{-test_constraints_incdirs};
      my $test_constraints_incfiles= $merged_test_opts->{$cur_scope}{-test_constraints_incfiles};
      my $trace_gen=$merged_test_opts->{$cur_scope}{-trace_gen};
      # Compile and run systeminit
      my $config_path = "$ENV{MODEL_ROOT}/cfg/systeminit";
      my $systeminit_path = &ToolConfig_get_tool_path("tfm_vi_tb") . "/tools/systeminit/bin";
      my $systeminit_cmd = "perl -I $config_path $systeminit_path/systeminit.pl -seed $dec_seed -l systeminit.log -stage run";
      $systeminit_cmd .= " -dut_cfg $dut_cfg" if ($dut_cfg);
      $systeminit_cmd .= " -outfile $dut_cfg_outfile" if ($dut_cfg_outfile);
      $systeminit_cmd .= " -project_constraints " . join(",", @$project_constraints) if (scalar @$project_constraints);
      $systeminit_cmd .= " -test_constraints " . join(",", @$test_constraints) if (scalar @$test_constraints);
      $systeminit_cmd .= " -incdirs $test_constraints_incdirs " . join(",", @$test_constraints_incdirs) if (scalar @$test_constraints_incdirs);
      $systeminit_cmd .= " -incfiles $test_constraints_incfiles " . join(",", @$test_constraints_incfiles) if (scalar @$test_constraints_incfiles);
      $systeminit_cmd .= " -trace_gen" if ($trace_gen);
      $fragment .= Ace::GenericScrag::add_cmd("SYSTEMINIT", $systeminit_cmd); # Check for good return code
      # Check if we should end the simulation after systeminit runs
      if ($merged_test_opts->{$cur_scope}{-systeminit_only}) {
        $fragment .= Ace::GenericScrag::add_cmd("SYSTEMINIT_ONLY", "perl -e \'die \"Ending after systeminit\"\'"); # Check for good return code
      }
      # Clean up vcs output files
      $fragment .= "rm -rf vc_hdrs.h systeminit.simv* csrc ucli.key\n"; 
    }

    if (defined $ENV{POST_SYSTEMINIT_CMD}) {
        $fragment .= "echo Running POST_SYSTEMINIT_CMD: $ENV{POST_SYSTEMINIT_CMD}\n";
        $fragment .= $ENV{POST_SYSTEMINIT_CMD}."\n";
    }

    $fragment .= "echo \n";
    $fragment .= "echo ===========================================\n";
    $fragment .= "echo  End of $ENV{ACE_PROJECT} PreRunScript \n";
    $fragment .= "echo ===========================================\n";
    $fragment .= "echo \n";

    # Return to the start directory
    $fragment .= Ace::GenericScrag::chdir($CWD);

    return $fragment;
}

#--------------------------------------------------------------------------------
1;

