package common::Switches;
use File::Basename;
use vars qw(@ISA @EXPORT_OK);
require Exporter;
@ISA = qw(Exporter);

#-------------------------------------------------------------------------------
use vars qw( %TestcaseGlobals ) ;
@EXPORT_OK = qw( %TestcaseGlobals );
#-------------------------------------------------------------------------------
my $PROJECT = $ENV{ACE_PROJECT};

if (defined $ENV{ACE_TEST_SUBDIR}){

	## temporary workaround for GK to to flatten the model/cfg, pass in empty test_subdir till ACE dev gave solution
	%TestcaseGlobals = (
	#    the defination of the results directory structure and the values
	#    <-results>/<-test_results_subdir>/<-test_subdor>
	#        -test_subdir => "${default_tsd}", # todo : to support dynamic switches # refer to common_ivar
	#       -test_results_subdir => "$user",# replace with $user only in common_ivar.udf
	);
}else{
	%TestcaseGlobals = (
	##    the defination of the results directory structure and the values 
	##    <-results>/<-test_results_subdir>/<-test_subdor>
	#        -test_subdir => "<${PROJECT}::-model>/cfg<NON_SCOPED::-cfg>/<NON_SCOPED::-run_type>", # todo : to support dynamic switches # refer to common_ivar
	##	-test_results_subdir => "$user",# replace with $user only in common_ivar.udf	
	);
}
#-------------------------------------------------------------------------------
1
