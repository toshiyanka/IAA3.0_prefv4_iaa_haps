# Name you package so that it is unique (ie <SCOPE>::file
package iosf_sbc::RunModes;

# Include Ace::TestRunModes to get some basic funcions
use Ace::TestRunModes;

sub init_library {
	# Register the library name so as to get better error messages
  my @valid_scenarios = qw(rnd_test testx);

	register_library "iosf_sbc::RunModes";
	
	if ($main::ACE_RUN_MODE =~ /^scenario/) {
		$SCENARIO = $main::ACE_RUN_MODE;
		$SCENARIO =~ s/scenario_//;
	}
	elsif ($main::ACE_RUN_MODE =~ /^seed_/) {
		$SEED = $main::ACE_RUN_MODE;
		$SEED =~ s/seed_//;
	}
	elsif ($main::ACE_RUN_MODE =~ /^network_/) {
		$NETWORK = $main::ACE_RUN_MODE;
		$NETWORK =~ s/network_//;
	}	
	# Define you library of runmodes
	%RUNMODES = (
		     "seed_$SEED" => {
				      -seed => $SEED,
				     },
		     "scenario_$SCENARIO" => {
					      -sim_args => ["+OVM_TESTNAME=iosf_sbc_tests::$SCENARIO"]
					     },
		     "network_$NETWORK" => {
					    -network => "${NETWORK}",
					   }
		    );
	
	%RUNMODE_GROUPS = (
			   all => [ keys %RUNMODES ],
			  );
}
1;
