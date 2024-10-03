package FlowSpec;

use strict;
use warnings;

use Exporter;
use vars qw(@ISA @EXPORT);
@ISA    = qw(Exporter);
@EXPORT = qw(%FlowSpec);
use FindBin;
use lib "$FindBin::Bin";
use File::Basename;
use Cwd qw (abs_path);
use RTLUtils;
use Utils;
use vars qw(%FlowSpec);

############################################################
# SpyGlass CDC stage 
############################################################

$FlowSpec{rtlbuild}{sgcdc} = {
   stage => "ace_command",
   opts  => {
      command => "ace -ccsg -mc=cdc_stap_model -ASSIGN -static_check_cfg_file=\$SPYGLASS_METHODOLOGY_CDC/ace_static_check.cfg",
      runlog => "",
   },
   deps => [qw()],
   default_active => "on",
   setup => \&sgcdc_setup,
};

$FlowSpec{rtlbuild}{sgcdc_test} = {
   stage => "ace_command",
   opts  => {
      command => "ace -sc -t spyglasscdc/stap  -ASSIGN   -spyglass_goals=cdc/cdc_setup_check  -ASSIGN -static_check_cfg_file=\$SPYGLASS_METHODOLOGY_CDC/ace_static_check.cfg -ecl -clh \$CDCLINT_HOME",
      runlog => "",
   },
   deps => [qw(sgcdc)],
   default_active => "off",
   setup => \&sgcdc_setup,
};

$FlowSpec{rtlbuild}{term} = {
   stage => "ace_command",
   opts  => {
      command => "xterm &",
      runlog => "",
   },
   deps => [qw(sgcdc)],
   default_active => "off",
   setup => \&sgcdc_setup,
};
sub sgcdc_setup 
{

   my %args = @_;                                                                             
   my $scopedVars = $args{scopedVars};                                                        
   $scopedVars->{ace_env_ptr} = undef;                                                        
   print_info("-I-: Clearing the ace env ptr. This will force the stage to re-source the ace env\n");

   print "-I-: SGCDC stage env setup\n";
   $ENV{"SPYGLASS_CDC"} = 1;
   return 0;
}

1;

