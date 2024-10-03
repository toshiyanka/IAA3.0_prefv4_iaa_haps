##------------------------------------------------------------------------------
## This module is used to make sure that the cm_dir is added in simv options
## for test in model. Without this, test realted .vdb folder will be updated 
## in target directory instead of creating in results directory. 
## 
## *.vdb is needed in results area inorder to create pcov files
##
## Author: dmeka
##------------------------------------------------------------------------------

package common::PostTestBuilder;
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
  my $seed             = $test_data->{$base_scope}{seed};
  my $cm_found         = 0;
  my $cm_dir_found     = 0;

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

  # check if -simv_args already consists of -cm_dir, if not then add it in
  if ( $self->get_option(-verif_data_mgmt) && !($self->get_option(-code_coverage_on))) {
    foreach my $i (@{$merged_test_opts->{NON_SCOPED}{'-simv_args'}}) {
      if ($i =~ /cm_dir/) {
        $cm_dir_found = 1;
      }
    }
    if (! $cm_dir_found) {
      push @{$merged_test_opts->{NON_SCOPED}{'-simv_args'}}, "-cm_dir ${tid}_seed_${seed}.simv";
    }
  }
}
#--------------------------------------------------------------------------------

1;

