#--*-perl-*------------------
{

################################################################################
# Note: All regular expressions must be placed with single quotes '/example/i' 
#  instead of double quotes "/example/i"
################################################################################
# If this variable is set, the config files in the list are first read in the 
#   order listed (so it is possible to overwrite information from an ealier 
#   cfgfile.)  Then the remainder of this file is parsed so that the information
#   contained within this file has the highest precedence.
#
# Note: Only one level of hierarchy can exist (so a file listed here cannot then
#   call an additional base config file.)
@BASE_CFG_FILES = (
);

%PATTERNS_DEF = (
    # Each of the defined "modes" are checked inside of postsim.pl.  If no modes
    # are ever "turned on" the test is automatically a fail.
    Modes => {
        # Fail the test if we fail to see transcript lines indicating the test actualy ran to completion (as measured by specific messages generated from the OVM VIP collateral.)
        "test_completed" => {
            # This flag requires that this mode must be "activated" this many times 
            # during the test (ie. must have this many occurences of StartString)
            Required => 1,

            # Define the regular expression which "activates" this mode
            StartString => '/ACE SIM OUTPUT START/',

            # Define the regular expression which "de-activates" this mode
            EndString => '/ACE SIM OUTPUT END/',

            # Define a list of regular expressions which must all exist within the 
            #   start and end expressions each time the mode is activated.  
            # Note: An end string must be specified for RequiredText to be checked
            RequiredText => [
                '/\[RNTST\]\s+Running\s+test/',
#'/TESTSTATUS:\s*Test/',
                '/^\s*\$finish called from file.*\.sv/',
            ],

            # Define a list of regular expressions used to ignore lines within the region of text delimited by the start and end expressions.
            okErrors => [
            ],     
        },
    },

    # List of classified errors to look for.
    # The parser searchs for 'All' first. Then tries to classify.
    # For instance,
    # # ** Error: static memory checker error : C17 : - SRAM - ....
    # The above error is matches first with the 'All' regular expression.
    # Then it matches with the '1 Static_Mem' classification.
    # The Number in front of classification is used to order the
    # error types, ie, 1 is more serious than 2.
    #
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # NOTE: These errors are only matched when one of the above "modes" is active,
    #  otherwise they are IGNORED!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #
    # NOTE: place more-specific regexps before more-general ones.
    Errors => [
        # Error regular expr                                          Category    Severity
        [ '/OVM_FATAL.*reporter.*INVTST.*Requested test from command line.*not found/', "ALL", 1 ],
        [ '/OVM_FATAL/',                                                "ALL",       1        ],
        [ '/ERROR/',                                                    "ALL",       1        ],
        [ '/Error:/',                                                   "ALL",       1        ],
        [ '/Fatal:/',                                                   "ALL",       1        ],
        # This line contains a common subset of assertion (property, SVA, etc.) error-message content, while also containing instance information, facilitating waiving specific categories.
        # If we key off of 'Offending', then we lose information (due to the error spanning multiple lines) that we could use for filtering errors.
        [ '/started at \d+(fs|ps|ns) failed at \d+(fs|ps|ns)/',         "ALL",       1        ],
    ],

    # Timeout strings which result in a postsim.fail with status of "Timeout"
    TimeoutErrors => [
        '/Simulation TIMEOUT reached/i',
    ],

    # This is a list of errors which are to be considered FATAL errors regardless of
    # whether they show up before or after the "StartOn" or "EndOn" conditions.
    FatalErrors => [
        #'/OVM_FATAL/',
        '/Fatal error:/',
    ],

    # Defines a list of warnings to look for
    Warnings => [
        '/Warning:/',
        '/Kilopass OTP: WARNING./',
        '/Warning: Cant open asyncseed: No such file or directory/',
    ],

    # Defines a list of errors which are 'safe' to ignore
    #
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # NOTE: These errors will be ignored globally (ie. for any of the "modes")
    # The way the ignoring takes place, ace_postsim.pl will apply the search patterns
    # below, replacing them with a string such as 'TEXT_REPLACED_BY_POSTSIM', thereby
    # masking the problematic sub-string in the line with that string.
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    okErrors => [
        # These are safe to ignore--they specify that no errors occurred.
        '/^\s*OVM_ERROR\s*:\s*0\s*$/',
        '/^\s*OVM_FATAL\s*:\s*0\s*$/',
        # What follows are errors that are being filtered temporarily.
        # Process Requirement: file a bug to track each waived error, and cite the HSD URL here, along with a comment.
        # Example:
        #   # HSD: https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=123456; Foobar fails to frob the baz.
        #   # '/^Error: foobar fails to frob the baz./',

        # A known EBB problem results in these time-zero assertion errors.
        # https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=4547911
        '/^Error:.*vcc_assertion: at time 0 fs/',
        '/SVA FATAL ERROR: VCC_IN must always be tied to 1.*vcc_assertion at 0.0 ns/',
    ],

    # Any additional information that is required from the logfile can be entered here:
    #
    # This is what is already extracted:
    #   Test name:
    #   Test type:  (Verilog procedural or Xscale assembly)
    #   Status:
    #   Cause: (for fails only)
    #   Error Count: 
    #   Warning Count:
    #   SIMPLI Error Count:
    #   SIMPLI Check Count:

    ## Default test type is "proc" procedural.  Gets changed to "asm" for assembly if the
    ##  following regular expression matches in the transcript.
    TestType => {
        default => {
            regex => undef,
            keyword => 'Environment "", BFM-driven system verilog',
        },
        assembly => {
            regex => '/Reading test memory image/',
            keyword => 'Asm',
        },
    },

    TestInfo => [
        # Use this to add to, or overwrite the standards
        # defined in $ACE_HOME/udf/ace_test_info.pp
        #['/SIMSTAT:  Simulation completed \@\s*\d+\.\d+\s*ns \(\s*(\d+) cycles\)/',     "Cycles", '$1'],
        #['/Info: runtime: Total cycles are (\d+)/', 'Cycles', '$1'],
        ['/^\s*\[Sequencer\]\s+(\d+)/', 'IOSF Requests', '$1'],
        ['/^\s*RUNTIME:\s*(\d+)/', 'Wallclock Time', '$1'],
        ['/^\s*\$finish at simulation time\s*(\d+)/', 'Simtime', '$1'],
    ],
    
    # Simple calulations based on contents of the 'TestInfo' array
    Calculations => {
        # Just for demonstration purposes, we will calculate the average simulation time between IOSF Requests:
        SimRate => '($TestInfo{Runtime} != 0) ? $TestInfo{"Simtime"}/$TestInfo{"IOSF Requests"} : 0',
    },
);


# Test-specific filtering helper subroutine.  No need to change this.  Just use it below.
sub add_test_specific_transcript_filter {
    my %argv = @_;
    my $testname_regexp = $argv{'testname_regexp'} || return;  # If incorrect arguments are supplied, no filter is added, so test will continue to fail.
    my $filter_regexp_array = $argv{'filter_regexp_array'} || return;
    if ($ENV{'ACE_SIMPLE_TESTNAME'} =~ eval($testname_regexp)) {
        foreach my $regexp_string (@{$filter_regexp_array}) {
            print "NOTE(", __FILE__, ":", __LINE__, "): Adding $regexp_string filter regexp to okErrors.\n";
            push(@{$PATTERNS_DEF{'okErrors'}}, $regexp_string);
        }
    }
}

# Specify test-specific filters here.  Each test will require their own invocation of this subroutine.  (But multiple filter-patterns may be specified.)



};


# Vim "modeline": configures folding and spaces-for-tabs.
# vim:expandtab:tabstop=4:foldmethod=marker:foldenable:foldlevel=0
