package dfxsecure_plugin_model::RunModes;

# Include Ace::TestRunModes to gets some basic functions
use Ace::TestRunModes;

# Define the ini_library subroutine - this subroutine, when called by Ace, defines the run modes
sub init_library {
    # Register the name of the library - yields better error messages
    register_library "dfxsecure_plugin_model::RunModes";
    my $SEED;
    if ($main::ACE_RUN_MODE =~ /^seed/) {
        $SEED = $main::ACE_RUN_MODE;
        $SEED =~ s/seed_//;
    }
    %RUNMODES = (
                 "seed_$SEED" => {
                     -seed => "$SEED",
                 },
    );
    # Group the run modes -- allows test option files to just import certain
    # sets of runmodes.
    %RUNMODE_GROUPS = (
                all => [ keys %RUNMODES ],
    );
}
1;

