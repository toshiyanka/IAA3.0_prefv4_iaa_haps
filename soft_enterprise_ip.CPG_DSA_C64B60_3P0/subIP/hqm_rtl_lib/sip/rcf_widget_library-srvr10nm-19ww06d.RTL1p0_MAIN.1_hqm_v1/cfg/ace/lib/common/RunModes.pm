
#---*-perl-*-----------------------------------------------------------------------------

# Name you package so that it is unique (ie <SCOPE>::file
package common::RunModes;

# Include Ace::TestRunModes to get some basic funcions
use Ace::TestRunModes;
use File::Basename;

my $PROG = basename $0;

sub init_library {
	# Register the library name so as to get better error messages
	register_library "common::RunModes";
	
	# Parse for DYNAMIC runmodes
	# NOTE: The variable '$main::ACE_RUN_MODE' is a global
	# variable which represents the current runmode name
	# from ace command-line
	if ($main::ACE_RUN_MODE =~ /^runlimit/) {
		$RUNLIMIT = $main::ACE_RUN_MODE;
		$RUNLIMIT =~ s/runlimit_//;
		unless ($RUNLIMIT =~ /\d+ns$/) {
			die "$PROG: The limit in runmode runlimit_<limit> should be of the from <d>ns. E.g. 9000ns\n\t(This really isn't a Syntax error)\n";
		}
	}	
	elsif ($main::ACE_RUN_MODE =~ /^seed_/) {
		$SEED = $main::ACE_RUN_MODE;
		$SEED =~ s/seed_//;
	}
        elsif ($main::ACE_RUN_MODE =~ /^model_/) {
                $MODEL = $main::ACE_RUN_MODE;
                $MODEL =~ s/model_//;
        }
	elsif ($main::ACE_RUN_MODE =~ /^cfg_/) {
                $CFG = $main::ACE_RUN_MODE;
                $CFG =~ s/cfg_//;
        } elsif ($main::ACE_RUN_MODE =~ /^merged_upf$/) {
                $ENV{MERGED_UPF} = "merged.upf";
        }

		
	# Define your library of runmodes
	%RUNMODES = (
		"seed_$SEED" => {
			-seed => $SEED,
		},
		"runlimit_$RUNLIMIT" => {
			-ns => $RUNLIMIT,
		},
		"model_$MODEL" => {
			-model => $MODEL,
		},
                "cfg_$CFG" => {
                        -cfg => $CFG,
                },					
                merged_upf => {
                        -cfg => "",
                }
	);
	
	%RUNMODE_GROUPS = (
			   all => [ keys %RUNMODES ],			   
			  );
}
1;
