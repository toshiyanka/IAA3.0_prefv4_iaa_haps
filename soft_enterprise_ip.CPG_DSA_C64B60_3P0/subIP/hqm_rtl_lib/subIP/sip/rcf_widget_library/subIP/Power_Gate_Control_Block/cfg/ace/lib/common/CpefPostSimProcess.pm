#-*-perl-*-
#--------------------------------------------------------------------------------
package common::CpefPostSimProcess;
use strict;
use FileHandle;
require "dumpvar.pl";
use Utilities::System qw(Exit);
use File::Basename;

use lib "$ENV{MODEL_ROOT}/ace/lib/common";
use vars qw(@ISA @EXPORT_OK);
use Ace::GenericScrag qw($CWD add_cmd);
use Data::Dumper;

require Exporter;
@ISA = qw(Exporter Ace::WorkModules::ProtoNI);

#-------------------------------------------------------------------------------
# MEMBER Functions
#
#
#--------------------------------------------------------------------------------
sub new {
  my ($class, %args) = @_;
  my $self = $class->SUPER::new(%args);
  return $self;
}
#-------------------------------------------------------------------------------
sub create_scrag {
  my ($self, %args) = @_;
 $_ = $args{-name};
 SWITCH: {
    /^exec_test/ && do { return $self->_run_cpef_postsim_process(%args); };
    $self->_unknown_ace_command_error($_);
  }
}

#-------------------------------------------------------------------------------
sub _run_cpef_postsim_process {
  my ($self, %args)    = @_;
  my $test_data        = $args{-test_data};
  my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, Ace::UDF::get_base_scope());
  my $cpef_results_dir = $ENV{CPEF_RESULTS_DIR};
  my $power_en         = $self->get_option(-power_en);
  my $include_mda      = $self->get_option(-include_mda);
  my $model            = $self->get_option(-model);
  my $cfg              = $self->get_option(-cfg);
  my $tid              = $test_data->{$base_scope}{tid};
  my $results_dir      = $self->get_option(-results);
  my $testrun_dir      = $test_data->{$cur_scope}{testrun_dir};
  my $fragment;

  if ($cpef_results_dir ne "" && $power_en ne "0") {
    $fragment .= Ace::GenericScrag::add_cmd("CPEFPOSTSIM", "$ENV{CPEF_BIN}/CpefPostSimProcess.pl $cpef_results_dir $power_en $include_mda $model $cfg $tid $results_dir $testrun_dir");
  }
  return $fragment;
}
#-------------------------------------------------------------------------------

1;

