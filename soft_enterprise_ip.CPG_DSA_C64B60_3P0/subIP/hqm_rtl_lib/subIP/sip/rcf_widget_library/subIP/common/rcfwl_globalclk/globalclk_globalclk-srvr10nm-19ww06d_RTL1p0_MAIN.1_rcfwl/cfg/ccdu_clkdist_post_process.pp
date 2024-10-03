%PATTERNS_DEF = (
   # Each of the defined "modes" are checked inside of postsim.pl.  If no modes
   #   are ever "turned on" the test is automatically a fail.
    Modes => {
       helloworld_test   => {
          Required     => 1,
#          StartString  => '/OVM_INFO @ 0: reporter \[RNTST\] Running test/',
          StartString  => '/OVM_INFO @ 0: .* connect is executing/',
          RequiredText => ['/Test Passed!/', '/OVM Report Summary/i',],
          EndString    => '/Report\s+counts\s+by\s+severity/',
          okErrors     => undef,
#          okErrors     => ['/llch_tb\.llch\.cha\.cha_under\.cbmsls\.cbtstops\.cutdc_cutdcIdvFreqbBufNoCLKTnnnH\.L_CUTDC/', '/ERROR\: Invalid agent ISM state/', '/R_CBo_Ring_Res_WrongRingStops/'],
       },
       ccdu_test   => {
          Required     => 1,
          StartString  => '/OVM_INFO @ 0: reporter \[RNTST\] Running test/',
          RequiredText => ['/Test Passed!/', ],
          EndString    => '/Report\s+counts\s+by\s+severity/',
          okErrors     => undef,
       }, 

       impossible_test   => {
          Required     => 1,
          StartString  => '/OVM_INFO @ 0: reporter \[RNTST\] Running test/',
          RequiredText => ['/YOU WILL NEVER SEE THIS MESSAGE, HA HA/', ],
          EndString    => '/Report\s+counts\s+by\s+severity/',
          okErrors     => undef,
       },
   },
   # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   #  NOTE: These errors are only matched when one of the above "modes" is active,
   #  otherwise they are IGNORED!!!
   # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   Errors => [
      # Error regular expr                              Category    Severity
      [ '/OVM_ERROR/',                                  "ALL",          1        ],
      [ '/OVM_FATAL/',                                  "ALL",          1        ],
      # Catch assertion failures
      [ '/failed\s+at\s+[0-9]+[munf]{0,1}s/',           "ALL",          1        ],
      # Catch printed error
      [ '/Error\s*:/i',                                 "ALL",          1        ],
      #         [ '/Fatal/i',                                     "ALL",          1        ],
      #         [ '/Quit count reached!/i',                       "ALL",          1        ],
   ],
   # Timeout strings which result in a postsim.fail with status of "Timeout"
   TimeoutErrors => [
     '/Simulation TIMEOUT reached/i',
   ],
);


