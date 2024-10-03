# -*-perl-*- for Emacs
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
		  #   are ever "turned on" the test is automatically a fail.
		  Modes => {
			    ExampleMode    => {
					       # Set this attribute to totally ignore the mode
					       Ignore      => 1,

					       # This flag requires that this mode must be "activated" this many times 
					       #   during the test (ie. must have this many occurences of StartString)
					       Required     => 0, # 0 false, otherwise true

					       # Define the regular expression which "activates" this mode
					       StartSting   => '/some expression/i',

					       # Define the regular expression which "de-activates" this mode
					       EndString    => '/some expression/',

					       # Define a list of regular expressions which must all exist within the 
					       #   start and end expressions each time the mode is activated.  
					       # Note: An end string must be specified for RequiredText to be checked
					       RequiredText => [
								'/required string 1/',
								'/Another required string/',
							       ],

					       # Define a list of regular expressions which are ignored within the
					       # start and
					       #  end expressions.
					       okErrors     => [
								'/error string 1/',
								'/ERROR string \#2/',
							       ],
					      },

			    lynxpoint_glogal => {
					   Required     => 1,

                       # the start string turns on the lnw_fullchip mode.
					   StartString  => '/ACE SIM OUTPUT START/',
					   EndString    => '/ACE SIM OUTPUT END/',

                       # We need to think about what required text there should be.
					   RequiredText => [
#                                                             '/SIMSTAT: Simulation completed./',
							   ],

                       # these are errors that should not get our undies in a bunch.
					   okErrors     => [
                                                           '/.*merror /',
                                                           '/.*serror /',

							    ],     
				},







			   },
		  # List of classified errors to look for.
		  # The parser searchs for 'All' first. Then tries to classify
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
		  Errors => [
			     # Error regular expr                                           Category    Severity
			     [ '/\s*ERROR\d{2}/',                                             "ALL",       1        ],
			     [ '/ERROR/',                                                     "ALL",       1        ],
			     [ '/Error:/',                                                    "ALL",       1        ],
			     [ '/Fatal:/',                                                    "ALL",       1        ],
			     [ '/^OVM_FATAL/',                                                "ALL",       1        ],
                             [ '/assertion.* started at .* failed at /',                      "ALL",       1        ],
                             [ '/\s*Offending /',                                             "ALL",       1        ],
		     	     ['/UTB_TEST_RESULT: FAIL/' 				,     "ALL",       1        ],
                             [ '/(Test|Task).*Status.*FAIL/',                                 "ALL",       1        ],
                             [ '/make.*\[.*\].*Error/',                                       "ALL",       1        ],

			    ],

		  # Timeout strings which result in a postsim.fail with status of "Timeout"
		  TimeoutErrors => [
				    '/Simulation TIMEOUT reached/i',
				   ],

		  # This is a list of errors which are to be considered FATAL errors regardless of
		  # whether they show up before or after the "StartOn" or "EndOn" conditions.
		  FatalErrors => [
                  '/Fatal error:/',
				  '/Error - Test failed due to phase of moon/',
				 ],

		  # Defines a list of warnings to look for
		  Warnings     => [
				   '/Warning:/',
                   '/Kilopass OTP: WARNING./',
                   '/Warning: Cant open asyncseed: No such file or directory/',
				  ],

		  # Defines a list of errors which are 'safe' to ignore
		  #
		  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		  # NOTE: These errors will be ignored globally (ie. for any of the "modes")
		  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		  okErrors     => [
				   #'/error - Zipper is down/i',
					'/JPE_ERROR_IMR/',	# basic_isp_csr_default test uses this name
					'/JPE_ERROR_RIS/',	# basic_isp_csr_default test uses this name
					'/JPE_ERROR_MIS/',	# basic_isp_csr_default test uses this name
                    '/CSR (READ|WRITE).*<NAND>.*ECC_ERROR_BLOCK_ADDRESS/',     #NAND Register name
                    '/CSR (READ|WRITE).*<NAND>.*ECC_ERROR_PAGE_ADDRESS/',      #NAND Register name
                    '/CSR (READ|WRITE).*<NAND>.*ECC_ERROR_ADDRESS/',           #NAND Register name
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
		  TestType     => {
				   Default => {
					       regex   => undef,
					       keyword => "Proc",
					      },
				   Assembly => {
						regex   => '/Reading test memory image/',
						keyword => "Asm",
					       },
				  },

		  TestInfo     => [
				    # Use this to add to, or overwrite the standards
                                    # defined in $ACE_HOME/udf/ace_test_info.pp
				   #['/SIMSTAT:  Simulation completed \@\s*\d+\.\d+\s*ns \(\s*(\d+) cycles\)/',     "Cycles", '$1'],
				   ['/Info: runtime: Total cycles are (\d+)/',     "Cycles", '$1'],
				  ],
		  
		  # Simple calulations based on contents of the 'TestInfo' array
		  Calculations => {
				   SimRate => '($TestInfo{Runtime} != 0) ? $TestInfo{Cycles}/$TestInfo{Runtime} : 0',
				  },
		 );
};


