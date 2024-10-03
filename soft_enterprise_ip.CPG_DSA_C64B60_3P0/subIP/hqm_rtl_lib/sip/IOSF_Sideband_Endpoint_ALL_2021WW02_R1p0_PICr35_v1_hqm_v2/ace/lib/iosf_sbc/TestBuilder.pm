##--------------------------------------------------------------------------------
## INTEL CONFIDENTIAL
##
## Copyright (June 2005)2 (May 2008)3 Intel Corporation All Rights Reserved.
## The source code contained or described herein and all documents related to the
## source code ("Material") are owned by Intel Corporation or its suppliers or
## licensors. Title to the Material remains with Intel Corporation or its
## suppliers and licensors. The Material contains trade secrets and proprietary
## and confidential information of Intel or its suppliers and licensors. The
## Material is protected by worldwide copyright and trade secret laws and treaty
## provisions. No part of the Material may be used, copied, reproduced, modified,
## published, uploaded, posted, transmitted, distributed, or disclosed in any way
## without Intels prior express written permission.
##
## No license under any patent, copyright, trade secret or other intellectual
## property right is granted to or conferred upon you by disclosure or delivery
## of the Materials, either expressly, by implication, inducement, estoppel or
## otherwise. Any license under such intellectual property rights must be express
## and approved by Intel in writing.
##
##--------------------------------------------------------------------------------

#-*-perl-*-
#--------------------------------------------------------------------------------
# $Author: hyabbas $
# $Date: 2008/09/17 00:10:25 $
# $Revision: 1.24 $
# $Source: /nfs/ace/CVS/ace/prototype/project_2/release/ALL/Q20040609_0840/ace/lib/Project_2/TestBuilder.pm,v $
#--------------------------------------------------------------------------------
package iosf_sbc::TestBuilder;
use strict;
use Utilities::ProgramTools qw(check_args test_eval deepcopy);
use Utilities::Print;
use Utilities::System qw(Exit);

# Useful for debbuging
use Data::Dumper;

use vars qw(@ISA @EXPORT_OK);
# Include the parents
use Ace::GenericScrag qw($CWD);
use Ace::WorkModules::DefaultTestBuilder;
use Ace::CheckerManager;
require Exporter;
@ISA = qw(Exporter Ace::WorkModules::DefaultTestBuilder);

#--------------------------------------------------------------------------------
sub new {
  my ($class, %args) = @_;
  # Print more info when exit on error
  $Utilities::System::CROAK_ON_EXIT = 1;  
  
  # dprint -> prints to STDOUT when -tool_debug on command-line
  dprint "# $class\::new\n";

  # Call the parent's constructor
  my $self = $class->SUPER::new(%args);
  
  # Set the parent scope (to self is single scope)
  $self->{_super_scope} = "iosf_sbc";
  
  return $self;
}
#--------------------------------------------------------------------------------
# Overriding the base 'build_test_scrag'
#--------------------------------------------------------------------------------
sub build_test_scrag {
  my ($self, %args) = @_;
  
  my ($cur_scope, $base_scope) = ($args{-cur_scope}, Ace::UDF::get_base_scope());
  
  my $test_data 	= $args{-test_data};
  my $testrun_dir       = $test_data->{$cur_scope}{testrun_dir};
  my @compilers = @{$self->{_hdl_compiler}};

  my $merged_test_opts  = $args{-merged_test_opts};
  
  # The parent directory in which to work on test 
  my $workdir		= $test_data->{$base_scope}{workdir};

  # my $assembler = $self->find_executable("tools/assembler.pl", $cur_scope);
  # XML ---> create VLOG ---> compile VLOG
  # Creates testbench RTL and network CSV configuration from XML spec
  my $xml2csv = $self->find_executable("gen/xml2csv.pl", $cur_scope);
  my $sbccfg  = $self->find_executable("gen/sbccfg", $cur_scope);
  my $template= $self->find_file("gen/iosf_sbc_tb_template.sv", $cur_scope);
  my $network_dir = $merged_test_opts->{$cur_scope}{-network_src_dir};
  my $network     = $merged_test_opts->{$cur_scope}{-network};
  #  Check for existence of file.
  # to exit 
  #   Exit 1, "msg";  1 for error, 0 for non-error
  Exit 1, "Cannot find specified network (${network_dir}/${network}.xml)" if ( not -e "${network_dir}/${network}.xml" );
  Exit 1, "Cannot find TB template ($template)" if (not -e "$template");

  # EX: xml2csv.pl --ipxact_file ../tests/networks
  #/$(NETWORK).xml --tb_template ../gen/iosf_sbc_tb_template.sv --tb_output_dir generated_code/$(NETWORK) --csv_output_file generated_code/$(NETWORK)/$(NETWORK).csv
  my $xml2csv_cmd = "$xml2csv --ipxact_file ${network_dir}/${network}.xml --tb_output_dir ${workdir}/${testrun_dir} --tb_template $template --csv_output_file ${workdir}/${testrun_dir}/${network}.csv";

  my $sbccfg_cmd  = "$sbccfg ${workdir}/${testrun_dir}/${network}.csv -d ${workdir}/${testrun_dir}/";

  my $fragment = $self->display_info_header(%args);
  $fragment .= Ace::GenericScrag::chdir("$workdir/$testrun_dir");
  $fragment .= Ace::GenericScrag::set_envvar("ACE_${cur_scope}_RUN_DIR" ,"$workdir/$testrun_dir" );
  $fragment .= $self->set_all_ini_var_for_test($args{-merged_test_opts});
  $fragment .= $self->check_model_compiled();

  $fragment .= Ace::GenericScrag::add_cmd("XML2CSV", $xml2csv_cmd);
  $fragment .= Ace::GenericScrag::add_cmd("SBCCFG",  $sbccfg_cmd);


 # $fragment .= $self->create_gmake_cmd(%args);
  $fragment .= $self->create_gmake_cmd(%args, -custom_make_options=>["NETWORK=$network NETWORK_DIR=$network_dir"]);

  $fragment .= $self->display_info_tailer(%args);
  
  foreach my $compiler (@compilers) {
    $self->register_testfiles(-name=>"simargs", -testdata=>$test_data, -scope=>$cur_scope, -compiler=>$compiler, -file=>"${cur_scope}_${compiler}_sim_args");
    $self->register_testfiles(-name=>"vcsargs", -testdata=>$test_data, -scope=>$cur_scope, -compiler=>$compiler, -file=>"${cur_scope}_${compiler}_args") if ($compiler eq 'vcs');
  }

  return $fragment;
}

#--------------------------------------------------------------------------------
1;
