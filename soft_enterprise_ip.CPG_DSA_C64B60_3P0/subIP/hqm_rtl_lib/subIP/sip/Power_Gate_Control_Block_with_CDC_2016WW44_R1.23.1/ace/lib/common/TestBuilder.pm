##-----------------------------------------------
## Need help?
##   Use Intelpedia:    https://intelpedia.intel.com/Ace_Simulation_Environment
##   Use AceUsersGuide: http://nsec.ch.intel.com/cad_nfs/ace/doc/AceUsersGuide.pdf 
##
## Find ACE bugs?
##   File HSD to: 
##-----------------------------------------------
## AceUserGuide: Chapter 6.5 

package common::TestBuilder;
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
  $self->{_super_scope} = "$ENV{ACE_PROJECT}";

  # Set new MEMBER Vars
  return $self;
}
#--------------------------------------------------------------------------------
# Add in customize processes into default scrag
#--------------------------------------------------------------------------------
sub create_scrag {
  my ($self, %args) = @_;
  my ($cur_scope, $base_scope) = ($self->{_cur_scope}, Ace::UDF::get_base_scope());
  my $merged_test_opts = $args{-merged_test_opts};
  my $test_data        = $args{-test_data};
  my $tid              = $test_data->{$base_scope}{stid};
  my $fragment         = '';
  my $cm_found         = 0;
  my $cm_dir_found     = 0;
  my $testrun_dir      = $args{-test_data}->{$base_scope}{'top_testrun_dir'};
  my $testsrc_dir      = $args{-test_data}->{$cur_scope}{'path'};

  # Simple "breadcrumb": display the current repo.'s HEAD SHA1 commit value in the Ace output (to be captured in the Ace output, in case that information is needed at a later time.)
  # (Take care to not do this though, if run in a $IP_ROOT which has no .git/ subdirectory (such as IRR drops.))
  $fragment .= Ace::GenericScrag::add_cmd('CSME_GIT_HEAD', "test -d $ENV{IP_ROOT}/.git && git --git-dir $ENV{IP_ROOT}/.git rev-parse HEAD || true");

  # check if -simv_args already consists of -cm, if not add it
  if ( $self->get_option(-verif_data_mgmt) || $self->get_option(-code_coverage_on)) {
    foreach my $i (@{$merged_test_opts->{NON_SCOPED}{'-simv_args'}}) {
      if ($i =~ /cm/) {
        $cm_found = 1;
      }
    }
    if (! $cm_found) {
      push @{$merged_test_opts->{NON_SCOPED}{'-simv_args'}}, "-cm line+cond+branch+fsm+tgl+assert";
    }
  }

  # We must always specify the '-cm_dir' argument, otherwise a simulation running on a GateKeeper-generated
  # "release" model will result in a VCS error, at the end of the simulation, when VCS attempts to write to the
  # "elaboration" vdb database (which will fail due to permissions issues.)
  foreach my $i (@{$merged_test_opts->{NON_SCOPED}{'-simv_args'}}) {
    if ($i =~ /cm_dir/) {
      $cm_dir_found = 1;
    }
  }
  if (! $cm_dir_found) {
    push @{$merged_test_opts->{NON_SCOPED}{'-simv_args'}}, "-cm_dir $tid.simv";
  }

  # If moatfilter exists copy it to run directory
  if (-e "$ENV{IP_ROOT}/scripts/$ENV{ACE_PROJECT}/moatfilter") {
	#system("cp $ENV{IP_ROOT}/scripts/$ENV{ACE_PROJECT}/moatfilter $testrun_dir");
	$fragment .= Ace::GenericScrag::add_cmd('CSME_MOATFILTER1', "cp $ENV{IP_ROOT}/scripts/$ENV{ACE_PROJECT}/moatfilter $testrun_dir");
  }  	
  # If the test contains a moatfilter append it to the existing moatfilter
  if (-e "$testsrc_dir/moatfilter") {
	#system("cat $testsrc_dir/moatfilter >> $testrun_dir/moatfilter");
	$fragment .= Ace::GenericScrag::add_cmd('CSME_MOATFILTER2', "cat $testsrc_dir/moatfilter >> $testrun_dir/moatfilter");
  }
  return $fragment;
}
#--------------------------------------------------------------------------------

1;

