
#-----------------------------------------------------------------
# Intel Proprietary -- Copyright 2011 Intel -- All rights reserved 
#-----------------------------------------------------------------
# Author       : melmalak 
# Date Created : 2012-08-28 
#-----------------------------------------------------------------
# Description:
# ACE Resource File for PSF project
#------------------------------------------------------------------

# Name you package so that it is unique (ie <SCOPE>::file
package RunModes;

# Include Ace::TestRunModes to get some basic funcions
use Ace::TestRunModes;
use File::Basename;

my $PROG = basename $0;

sub init_library {
   # Register the library name so as to get better error messages
   register_library "RunModes";
   
   # Parse for DYNAMIC runmodes
   # NOTE: The variable '$main::ACE_RUN_MODE' is a global
   # variable which represents the current runmode name
   # from ace command-line
   if ($main::ACE_RUN_MODE =~ /^imode_/) {
      # imode (implicit mode) has this format (imode_MODEL_SEED_PLUSARG)
      $imode = $main::ACE_RUN_MODE;
      $imode =~ s/imode_//;
      ($imode_model, $imode_seed, $imode_simv) = split ( '_', $imode, 3);
      print "$imode_model $imode_seed $imode_simv\n";

      # TODO: Now accepts only one plus arg, simple string manilpulation should be added to allow
      # multiple plus args
   }
      
   # Define your library of runmodes
   %RUNMODES = (
      "imode_$imode" => {
         -model      => $imode_model,
         -seed       => $imode_seed,
         -simv_args  => "+$imode_simv"
      },
   );
   
   %RUNMODE_GROUPS = (
      all => [ keys %RUNMODES ],            
   );
}
1;
