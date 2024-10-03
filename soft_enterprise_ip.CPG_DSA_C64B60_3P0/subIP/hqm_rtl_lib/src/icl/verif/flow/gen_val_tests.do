// DTEG DUVE-M reference .do file

// continue and exit on error
//set_dofile_abort off
//set_dofile_abort exit

// Load IP Tessent cfg
source $env(IP_TESSENT_CFG)

// Tessent log file with transcript
set_logfile_handling $mentor_tessent_logfile -R

if {$tessent_context_to_read_verilog eq "dft_rtl"} {
   // Starting with "dft -rtl" context to allow use of '-vcs_compatibility' option for loading RTL
   set_context dft -rtl
}

set_context patterns -ijtag

// Register Intel specific ICL attributes
source $env(DUVE_M_HOME)/verif/pdl/common/intel_register_attr.dofile

// Load ICL and RTL collateral (TIP: for RTL, you need to load top level only)
dofile $ip_read_icl_dofile

// Exmaple of the file content:
// read_icl $env(IP_ROOT)/source/icl/ip.icl

dofile $ip_read_verilog_dofile

// Exmaple of the file content:
// read_verilog $env(IP_ROOT)/source/rtl/ip_top.sv

// Change severity of some predefined Tessent ICL DRC
set_drc_handling ICL77  Warning
set_drc_handling ICL78  Warning
set_drc_handling ICL137 Warning

// Setting top level of the design to work with
// (elaboration of the design)
set_current_design $current_design

// Setting design level (design type)
set_design_level $design_level

source $ip_current_design_cfg_dofile

add_black_boxes -auto 
report_clocks

// Transition from setup mode to analysis mode
check_design_rules

// Load common DUVE-M TAP test procedures
source $env(DUVE_M_HOME)/verif/pdl/common/tap_utils.pdl
source $env(DUVE_M_HOME)/verif/pdl/common/tap_tests_common.pdl

set enable_continuity_group	       1
set enable_reset_group  	       1
set enable_rw_group		       1
set enable_all_opcodes_security_group  1

source $ip_pattern_cfg_dofile

set_ijtag_retargeting_options -iapply_target_annotations full -tck_period $tck_period

// Opening/defining pattern(s)

if {!$separate_test_per_group} {

   set pattern_name $pattern_set
   open_pattern_set $pattern_name -tester_period $tester_period -tck_ratio $tck_ratio

   // User-defined setup
   source $ip_user_cfg_dofile

   // Test specific setup
   source $ip_test_cfg_dofile

   // Temporary hotfixes
   source $ip_test_hotfix_dofile

   ///////// Test flow ////////

   source $ip_test_flow_pdl

   if {$enable_user_tests} {
      iNote "-INFO- Starting User Defined tests..."
      source $ip_user_tests_pdl
   }

   ///////// End of test flow ////////

   // Reporting details of last error during dofile execution
   //if {[info exists errorInfo]} {puts $errorInfo}

   close_pattern_set

   write_patterns $ip_patterns_path/$pattern_name.pdl -pdl     -pattern_set $pattern_name -replace
   write_patterns $ip_patterns_path/$pattern_name.v   -verilog -pattern_set $pattern_name -replace -param $ip_write_patterns_v_param_file

} else {

   set enable_continuity_group            0
   set enable_reset_group                 0
   set enable_rw_group                    0
   set enable_all_opcodes_security_group  0

   source $ip_user_cfg_dofile
   source $ip_test_cfg_dofile
   source $ip_test_hotfix_dofile

   if {$enable_continuity_tests} {
      set enable_continuity_group 1
      set pattern_name ${pattern_set}_continuity
      open_pattern_set $pattern_name -tester_period $tester_period -tck_ratio $tck_ratio
      source $ip_test_flow_pdl
      close_pattern_set
      write_patterns $ip_patterns_path/$pattern_name.pdl -pdl     -pattern_set $pattern_name -replace
      write_patterns $ip_patterns_path/$pattern_name.v   -verilog -pattern_set $pattern_name -replace -param $ip_write_patterns_v_param_file
      set enable_continuity_group 0
   }

   if {$enable_powergood_reset_tests || $enable_trst_reset_tests || $enable_tlr_reset_tests} {
      set enable_reset_group 1
      set pattern_name ${pattern_set}_reset
      open_pattern_set $pattern_name -tester_period $tester_period -tck_ratio $tck_ratio
      source $ip_test_flow_pdl
      close_pattern_set
      write_patterns $ip_patterns_path/$pattern_name.pdl -pdl     -pattern_set $pattern_name -replace
      write_patterns $ip_patterns_path/$pattern_name.v   -verilog -pattern_set $pattern_name -replace -param $ip_write_patterns_v_param_file
      set enable_reset_group 0
   }

   if {$enable_rw_tests} {
      set enable_rw_group 1
      set pattern_name ${pattern_set}_rw_access
      open_pattern_set $pattern_name -tester_period $tester_period -tck_ratio $tck_ratio
      source $ip_test_flow_pdl
      close_pattern_set
      write_patterns $ip_patterns_path/$pattern_name.pdl -pdl     -pattern_set $pattern_name -replace
      write_patterns $ip_patterns_path/$pattern_name.v   -verilog -pattern_set $pattern_name -replace -param $ip_write_patterns_v_param_file
      set enable_rw_group 0
   }

   if {$enable_all_opcodes_security_tests} {
      set enable_all_opcodes_security_group 1
      set pattern_name ${pattern_set}_all_opcodes_security
      open_pattern_set $pattern_name -tester_period $tester_period -tck_ratio $tck_ratio
      source $ip_test_flow_pdl
      close_pattern_set
      write_patterns $ip_patterns_path/$pattern_name.pdl -pdl     -pattern_set $pattern_name -replace
      write_patterns $ip_patterns_path/$pattern_name.v   -verilog -pattern_set $pattern_name -replace -param $ip_write_patterns_v_param_file
      set enable_all_opcodes_security_group 0
   }

   if {$enable_user_tests} {
      set pattern_name ${pattern_set}_user_defined
      open_pattern_set $pattern_name -tester_period $tester_period -tck_ratio $tck_ratio
      iNote "-INFO- Starting User Defined tests..."
      source $ip_user_tests_pdl
      close_pattern_set
      write_patterns $ip_patterns_path/$pattern_name.pdl -pdl     -pattern_set $pattern_name -replace
      write_patterns $ip_patterns_path/$pattern_name.v   -verilog -pattern_set $pattern_name -replace -param $ip_write_patterns_v_param_file
   }
}

report_pattern_set

exit

