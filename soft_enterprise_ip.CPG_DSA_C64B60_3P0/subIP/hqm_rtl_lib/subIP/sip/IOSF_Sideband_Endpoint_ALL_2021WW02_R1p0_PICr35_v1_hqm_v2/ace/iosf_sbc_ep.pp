# -*-perl-*- for Emacs
{
@BASE_CFG_FILES = ( );
%PATTERNS_DEF = (
    Modes => {
        IosfSvcB2bTestbench => {
            Required        => 1,
            StartString     => '/ACE SIM OUTPUT START/',
            EndString       => '/ACE SIM OUTPUT END/',
            RequiredText    => [
                '/TESTSTATUS: Test.*Passed/',
                '/^\s*\$finish called from file.*\.sv/',
            ],
            okErrors => [
                 '/OVM_ERROR\s:\s+0/',
                 '/UVM_ERROR\s:\s+0/',
                 '/INFO = \d+ , WARNING = \d+ , ERROR = \d+ , FATAL = 0/',
            ],     
        }, # end IosfSvcB2bTestbench
        IosfEpAceVisa       => {
            Required        => 1,
            StartString     => '/ACE SIM OUTPUT START/',
            EndString       => '/ACE SIM OUTPUT END/',
            RequiredText    => [
                '/VISA_TEST: Test.*Passed/',
                '/^\s*\$finish called from file.*\.sv/',
            ],
            okErrors => [
                 '/OVM_ERROR\s:\s+0/',
                 '/UVM_ERROR\s:\s+0/',
                 '/INFO = \d+ , WARNING = \d+ , ERROR = \d+ , FATAL = 0/',
            ], 
        }, # end of ace visa

# Disabling checks for strings... not all endpoint tests toggle primary power
####	lpa => {
####		Required => 1,
####                   StartString     => '/ACE SIM OUTPUT START/',
####                   EndString       => '/ACE SIM OUTPUT END/',
####                RequiredText => [
####		    '/\[INFO\] \[LP_PPN_STATE_CHANGE\] State of the primary power net/',
####		],
####	}, # end lpa
    }, # end Modes

    Errors => [
        # Error regular expr                        Category Severity
        [ '/ERROR/',                                "ALL",   1 ],
        [ '/Error/',                                "ALL",   1 ],
        [ '/Fatal:/',                               "ALL",   1 ],
        [ '/assertion.* started at .* failed at /', "ALL",   1 ],
    ],
    TimeoutErrors => ['/Simulation TIMEOUT reached/i',],
    FatalErrors   => [
        '/Fatal error:/',
        '/Error - Test failed due to phase of moon/',
    ],
    Warnings => ['/Warning:/',],
    TestType => {},
    #Access to unsupported address range error valid for ep
    okErrors => ['/ERROR: Invalid ingress message:/',
                 '/VISA_TESTS_SUMMARY: Total tests failed: 0/',
                 '/Number of caught UVM_ERROR reports   :    0/',
                 '/Number of demoted UVM_ERROR reports  :    0/'
                ],
#   TestInfo => [['/Info: runtime: Total cycles are (\d+)/', "Cycles", '$1'],],
#   Calculations => {
#    SimRate => '($TestInfo{Runtime} != 0) ? $TestInfo{Cycles}/$TestInfo{Runtime} : 0',
#    },
); # end %PATTERNS_DEF
}; # end {
