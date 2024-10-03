# DUT Pattern config file
#
# Note: this configuration must be applied BEFORE 
#   set_current_design <design>

# Pattern set name - base name of generated patterns
set pattern_set                        hqm_basic_tap_tests

# Generate separate test for each group: continuity, reset, rw-access, all opcodes/security
# By default, single test with all sub-tests will be generated.
set separate_test_per_group            0

# Individual test enable/disable knobs
# Note: TRST/TLR tests are disabled by default

set enable_continuity_tests            1
set enable_powergood_reset_tests       1
set enable_trst_reset_tests            0
set enable_tlr_reset_tests             0
set enable_rw_tests                    1
set enable_rw_dr_field_tests           0
set enable_all_opcodes_security_tests  1
set enable_security_tests_all_levels   0
set enable_user_tests                  1

# list of security levels to exclude (e.g. {7 9})
set excluded_security_levels          {}

# Tester and TAP TCLK parameters (used as arguments of open_pattern_set command and retargeting)
# IMPORTANT! Make sure that: tck_period = tester_period * tck_ratio
set tester_period 10ns 
set tck_ratio     1
set tck_period    10ns
