# -*-perl-*- for Emacs
#--------------------------------------------------------------------------------
# INTEL CONFIDENTIAL
#
# Copyright (June 2005)2 (May 2008)3 Intel Corporation All Rights Reserved. 
# The source code contained or described herein and all documents related to the
# source code ("Material") are owned by Intel Corporation or its suppliers or
# licensors. Title to the Material remains with Intel Corporation or its
# suppliers and licensors. The Material contains trade secrets and proprietary
# and confidential information of Intel or its suppliers and licensors. The
# Material is protected by worldwide copyright and trade secret laws and treaty
# provisions. No part of the Material may be used, copied, reproduced, modified,
# published, uploaded, posted, transmitted, distributed, or disclosed in any way
# without Intels prior express written permission.
#
# No license under any patent, copyright, trade secret or other intellectual
# property right is granted to or conferred upon you by disclosure or delivery
# of the Materials, either expressly, by implication, inducement, estoppel or
# otherwise. Any license under such intellectual property rights must be express
# and approved by Intel in writing.
#
#--------------------------------------------------------------------------------
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
#
################################################################################
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

			    AceDefault => {
					   Required     => 1,
					   StartString  => '/START OF TEST/',
					   EndString    => '/Note: \$finish/',
					   RequiredText => [
                                                            '/(Note: \$finish)|($finish at simulation time)/',
							   ],
					   okErrors     => undef,
					   #okErrors_multiLine => [
								  #[3, "/ERROR.*\(introduced error\)/", "/At time/", "/ERROR - example multi-line error/"],
								 #],
					  },


			    HierDump   => {
					   Required     => 1,
					   StartString  => '/ACE SIM OUTPUT START/',
					   EndString    => '/ACE SIM OUTPUT END/',
					   RequiredText => [ '/RC = -1/' ],
					   okErrors     => [
                                           ],
					  },
         
          #NLP related Modes
			    "NLP_reg_read" => {
					   Ignore      => 1,
					   Required     => 0,
					   StartString  => '/Reading register contents/',
					   EndString    => '/Finished reading register contents/',
						RequiredText => [
								'/Reading 0000abcd from GPRS reg 0/',
								'/Reading 00111111 from GPRS reg 1/',
								'/Reading 00222222 from GPRS reg 2/',
								'/Reading 00333333 from GPRS reg 3/',
								'/Reading 00444444 from GPRS reg 4/',
							   ],
					   okErrors     => undef,
					},
				  "NLP_reg_restore" => {
					   Ignore      => 1,
					   Required     => 0,
					   StartString  => '/Verifying restored values/',
					   EndString    => '/Finished verifying restored values/',
					   RequiredText => [
								'/Reading 0000abcd from GPRS reg 0/',
								'/Reading 00111111 from GPRS reg 1/',
								'/Reading 00222222 from GPRS reg 2/',
								'/Reading 00333333 from GPRS reg 3/',
							 #       '/Reading 00444444 from GPRS reg 4/',
							   ],
					  },

        #CDC related checks
				"AceCDC_default" => {
					   Ignore      => 1,
					   Required     => 0,
					   StartString  => '/ACE SIM OUTPUT START/',
					   EndString    => '/ACE SIM OUTPUT END/',
					   RequiredText => [
							    '/Final Process Statistics:/',
							   ],
					   okErrors     => [
								'/Error\/Warning Summary/',
							   ],
				},
				"AceCDC_summary" => {
					   Ignore       => 1,
					   Required     => 0,
                  StartString  => '/^START cdc.rpt DATA/',
					   EndString    => '/^END cdc.rpt DATA/',
					   RequiredText => [
							    '/Violations \(0\)/',
                         '/Cautions \(0\)/',
							   ],
				},
				"cdc_design.rpt" => {
					   Ignore      => 1,
					   Required     => 0,
					   StartString  => '/START cdc_design.rpt DATA/',
					   EndString    => '/END cdc_design.rpt DATA/',
					   RequiredText => [
							  #pcheang  '/Number of Inferred Clock Groups\s*:\s*0/',
							    #'/Number of Inferred Clock Groups     : 3/',  #for failure testing
							   ],
				},
				"cdc.rpt" => {
					   Ignore      => 1,
					   Required     => 0,
					   StartString  => '/START cdc.rpt DATA/',
					   EndString    => '/END cdc.rpt DATA/',
					   RequiredText => [
							     '/Violations \(0\)/', 
							   ],
				 },
				"AceSpyglass_default" => {
					   Ignore      => 1,
					   Required     => 0,
					   StartString  => '/SPYGLASS EXECUTION START/',
					   EndString    => '/SPYGLASS EXECUTION DONE/',
					   RequiredText => [
							    '/SpyGlass Exit Code 0/', 
							   ],
					   okErrors     => [
								'/:\s*0 error,/',
								'/\(\s*0 error,/',
								'/NOTE: It is recommended to first fix.*error/',
								'/Please re-run SpyGlass once .*error clean/',
							    '/checking completed with errors/', 
							   ],
				 },
		   },  #end for Modes definitions

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
			     # Error regular expr                          Category    Severity
			     [ '/Error\s*-\s*Test\s*failed\s*due\s*to\s*(.*)\s*in gears/i',   "ALL",       3        ],
			     [ '/read miscompare/',                                           "Read",      1        ],
			     [ '/Test Exit: processor \d+ failed/i',                          "ASM_Fail",  1        ],
			     [ '/Error/i',						      "ALL",       1        ],
			    ],

		  # Timeout strings which result in a postsim.fail with status of "Timeout"
		  TimeoutErrors => [
				    '/Simulation TIMEOUT reached/i',
				   ],

		  # This is a list of errors which are to be considered FATAL errors regardless of
		  # whether they show up before or after the "StartOn" or "EndOn" conditions.
		  FatalErrors => [
				  '/Error - Test failed due to phase of moon/',
				  '/Instantiation of \'tui_unit\' failed/',
				 ],
		  # Defines a list of warnings to look for
		  Warnings     => [
				   '/warning/i',
					 '/Number of blackboxes = [0-9]/',
					 '/Cautions \([1-9]\)/',
				  ],

		  # Defines a list of errors which are 'safe' to ignore
		  #
		  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		  # NOTE: These errors will be ignored globally (ie. for any of the "modes")
		  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		  okErrors     => [
				   '/error - Zipper is down/i',
				  ],
                  okErrors_multiLine => [
			##[<N lines per error message>, <match pattern for first line>, ..   , <line N-1 pattern> , <line N pattern ],
                        [3, "/ERROR.*\(introduced error\)/", "/At time/", "/ERROR - example multi-line error/"],
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
				  ],
		  
		  # Simple calulations based on contents of the 'TestInfo' array
		  Calculations => {
				   SimRate => '($TestInfo{Runtime} != 0) ? $TestInfo{Cycles}/$TestInfo{Runtime} : 0',
				  },
		 );
};

