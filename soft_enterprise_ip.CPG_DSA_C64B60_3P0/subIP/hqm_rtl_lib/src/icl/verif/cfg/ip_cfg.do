# IP config file

# Design TOP name
set current_design          ip1_top

# Design type: chip | physical_block | sub_block
#  - chip           : SoC level
#  - physical_block : HIP/EBB
#  - sub_block      : SIP
set design_level            sub_block 

# Tessent context to load design RTL & ICL
#set tessent_context_to_read_verilog dft_rtl
set tessent_context_to_read_verilog patterns_ijtag

# Verilog vs. SystemVerilog (SV) mode
set sv_mode 0

# Path to dofiles to read ICL & RTL 
set ip_read_icl_dofile      $env(IP_ROOT)/verif/cfg/ip_read_icl.do
set ip_read_verilog_dofile  $env(IP_ROOT)/verif/cfg/ip_read_verilog.do

# Path to IP current_design config dofile
set ip_current_design_cfg_dofile   $env(IP_ROOT)/verif/cfg/ip_current_design_cfg.do

# Path to IP pattern config dofile
set ip_pattern_cfg_dofile   $env(IP_ROOT)/verif/cfg/ip_pattern_cfg.do

# Path to IP DUT/Test test config dofile
set ip_test_cfg_dofile      $env(IP_ROOT)/verif/cfg/ip_test_cfg.do
set ip_test_hotfix_dofile   $env(IP_ROOT)/verif/cfg/ip_test_hotfix.do

# Path to IP test flow config files
set ip_test_flow_pdl        $env(DUVE_M_HOME)/verif/pdl/tap_tests_all.pdl
#set ip_test_flow_pdl        $env(IP_ROOT)/verif/pdl/tap_tests_all.pdl

# Path to user-defined config dofile
set ip_user_cfg_dofile      $env(IP_ROOT)/verif/cfg/ip_user_cfg.do

# Path to user-defined IP tests
set ip_user_tests_pdl       $env(IP_ROOT)/verif/pdl/ip_user_tests.pdl

# Path to write test patterns
set ip_patterns_path        $env(IP_ROOT)/target/patterns

# Path to verilog .param file for write_patterns options
set ip_write_patterns_v_param_file $env(IP_ROOT)/verif/cfg/write_patterns_v.param

# Path to dump out Tessent log file
set mentor_tessent_logfile  $env(IP_ROOT)/target/log/tessent.log
