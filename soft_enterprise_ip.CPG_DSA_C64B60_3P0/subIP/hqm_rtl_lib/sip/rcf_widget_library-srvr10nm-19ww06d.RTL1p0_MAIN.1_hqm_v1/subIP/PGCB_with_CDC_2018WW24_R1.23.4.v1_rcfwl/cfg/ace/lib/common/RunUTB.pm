#-*-perl-*----------------------------------------------------------------------
package common::RunUTB;
use strict;
use Utilities::ProgramTools qw(check_args test_eval deepcopy);
use Utilities::Print;
use Utilities::System qw(Exit);
use File::Basename;
use Data::Dumper;

# Include the parents
use Ace::GenericScrag qw($CWD);
use Ace::CheckerManager;
use Ace::OSData;
use vars qw(@ISA @EXPORT_OK);
require Exporter;
@EXPORT_OK = qw();
@ISA = qw( Exporter Ace::GenericScrag );

my $ERROR = "*** ERROR [common::RunUTB]: ";


#--------------------------------------------------------------------------------
sub new {
  my( $class, %args ) = @_;
  # Print more info when exit on error
  $Utilities::System::CROAK_ON_EXIT = 1;  
  
  # dprint -> prints to STDOUT when -tool_debug on command-line
  dprint "# $class\::new\n";

  # Call the parent's constructor
  my $self = $class->SUPER::new( %args );
  
  bless $self, $class;
    
  return $self;
}


#--------------------------------------------------------------------------------
# create_scrag
#--------------------------------------------------------------------------------
sub create_scrag {
  my( $self, %args ) = @_;
  
  my $base_scope        = Ace::UDF::get_base_scope();
  $self->{_super_scope} = "pmc";
  $self->{_cur_scope}   = $args{-cur_scope};
  $self->{_testname}    = $args{-test_data}->{$self->{_cur_scope}}{'name'};
  $self->{_testsrc_dir} = $args{-test_data}->{$self->{_cur_scope}}{'path'};
  $self->{_testrun_dir} = $args{-test_data}->{$base_scope}{workdir}.'/'.$args{-test_data}->{$self->{_cur_scope}}{testrun_dir};

  my $utb_task = $self->get_array_option(-utb_task, -convert2string=>1);

  my $fragment;
 
  $fragment .= "rm -rf ".$self->{_testrun_dir}."/".$self->{_testname}."*log.gz \n";
 
  $fragment .= "echo \"***************************************\"\n";
  $fragment .= "echo \"*** Entering UTB FPV Module ***\"\n";
  $fragment .= "echo \"***************************************\"\n";


  my $model_root        = $ENV{MODEL_ROOT};
#  my $sip_variation     = $ENV{PMC_SIP_VARIATION};
  my $pmcutbtarget_root = $model_root."/target/";
  my $utb_targ_dir   = $pmcutbtarget_root."/utb";
  
  my $test_name_full;

  if( $self->{_testsrc_dir} =~ m/\.utb$/ ) {
	# In this case the _testsrc_dir is the test itself.
	$test_name_full = $self->{_testsrc_dir};
  } else {
	$test_name_full = $self->{_testsrc_dir}."/".$self->{_testname};
	unless( $test_name_full =~ m/\.utb$/ ) {
	  $test_name_full = $test_name_full.".utb";
	}
  }

  my $test_log       = $self->{_testrun_dir}."/".$self->{_testname}.".log";
  my $utb_log        = $self->{_testrun_dir}."/utb.log";
  $fragment .= "echo \"TESTNAME:           ".$self->{_testname}."\"\n";
  $fragment .= "echo \"TESTRUN_DIR:        ".$self->{_testrun_dir}."\"\n";
  $fragment .= "echo \"TESTSRC_DIR:        ".$self->{_testsrc_dir}."\"\n";
  $fragment .= "echo \"UTB TASK:           ".$utb_task."\"\n";
  
  # pick up the file from test/task automatically
  my $utb_cmd = "/usr/bin/csh ".$model_root."/scripts/UTB.csh"." ".$self->{_testname}." ".$utb_task;
  
  $fragment .= "echo \"UTB_CMD:         ".$utb_cmd."\"\n";

  # Run the Test.
  $fragment .= "echo \'# ACE SIM OUTPUT START\'\n";
  $fragment .= $utb_cmd."\n";
  $fragment .= "if test \044? != 0 ; then\n";
  $fragment .= "  echo \'UTB_TEST_RESULT: FAIL\'\n";
  $fragment .= "fi\n";
  $fragment .= "echo \'# ACE SIM OUTPUT END\'\n";
  $fragment .= "echo \'# ACE SAFE TO PARSE\'\n";

  return $fragment;
}
#-------------------------------------------------------------------------------

1;
