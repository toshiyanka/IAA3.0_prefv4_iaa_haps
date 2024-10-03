# IP Test config
#
# Test flow control knobs

# Lists of ICL modules and registers to include and exclude
# Note regexp for intel_tap_ir: ICL module is parameterized and can change name

# Including all registers in the specified ICL Instance(s)
set included_instances   {iosfsb_ism tapconfig taptrigger}

# Including registers based on provided pattern(s)
set included_registers   {}

# Excluding registers in the specified ICL Module(s)
# !!! All examples below are just for reference only - please update based on your project specific !!!
# Usually you need to exclude special registers like network/chain control or a register for not implemented (reserved) opcodes

set excluded_modules {}

# Excluding registers based on provided pattern(s)
set excluded_registers {}
#set excluded_registers {*IOVRESET* *__SCANDUMP_CHAIN *fake_data_bus_reg* *streaming_through_ijtag_en*}

# Patterns to specify registers for TDI-TDO continuity test only
set continuity_test_only_registers {}
#set continuity_test_only_registers {*BRKPTEN* *BRKPTCTL* *DEBUGCOUNTER?_*}

# ICL modules and register patterns to exclude from TRST/TLR tests
set trst_tlr_test_excluded_modules   {}
set trst_tlr_test_excluded_registers {}

# ICL modules and register patterns to find TAP IR registers
set ir_module_names {}
set ir_reg_names {}

# ICL modules and register patterns to find TAP BYPASS registers
set bypass_module_names {}
set bypass_reg_names {}

# ICL modules and register patterns to find network/chain control registers
set network_control_modules {}
#set network_control_modules {*intel_htap_sel sib ip74xodit05_tctrl ip74xvdmt05_tctrl}
set network_control_registers {}

# NOTE: All opcode/security tests are guaranteed to work for TAP/ICL from Intel/DTEG only!

# List of TAPs (ICL instance(s)) for ALL OPCODES test 
# Run the test for all TAPs

#set tap_opcodes_tap_instances {*}
# Run the test for specified TAP/TAP list
set tap_opcodes_tap_instances {}

# Opcodes/Registers to exclude from ALL OPCODES & SECURITY tests (per TAP instance)
# It shoud include only opcodes with special behavior (like IOVRESET in the example below)
# Ideally, nothing should be excluded.

array set tap_opcodes_to_exclude {}

# For IP with single TAP, use '.' as TAP ID:
# set tap_opcodes_to_exclude(.:0x32) *IOVRESET*

# IP signal names info (optional)
#
# DFX powergood signals
# Note that FUNCTIONAL powergood/reset signals should be handled separately from DFx POWERGOOD signals.
# The reset procedure will try to find input port with name *p*w*rgood* (case insensitive) if
#    it is not provided in the setting below.
# Suffix 0/1 of reset index indicates active reset polarity.

set reset_name_list(DFX:0)  {rtdr_taptrigger_trst_b rtdr_tapconfig_trst_b rtdr_iosfsb_ism_trst_b}; #reset_b

# Workaround for Tessent issues with TRST/TLR modeling in ICL
# Specify the modules with registers/register instances which are expected to be reset by TRST and TLR
set dr_modules_trst   {}
set dr_modules_tlr    {}
set dr_registers_trst {}
set dr_registers_tlr  {}

# Seed for generator of random numbers
set seed 1

# Following iTopProc procedure will be linked with current_design module
iProcsForModule [get_single_name [get_current_design -icl]] 

# DUT/Test specific initialization procedure
iTopProc tap_reset_preamble {} {
   # Initially, setting secure_policy to 0 (GREEN)
   iCall tap_set_secure_policy
   iCall tap_reset POWERGOOD:DFX 10 reset_name_list
   iCall tap_set_secure_policy RED

   # To initialize all DataInPorts with DefaultLoadValue property
   #iCall tap_init_ports
   # To initialize DataInPort with Attribute intel_signal_type = "slvidcode"
   #iCall tap_init_ports slvidcode
   # Using iForcePort for initialization
   #iForcePort ftap_slvidcode[31:0]  0x12345679
   #iApply
}

# User-defined unlock/lock procedure
#    $type (original values): RED, RED4, ORANGE, GREEN, or numeric value of Intel security level
#    $skip_original_flow    : set to 1 to use custom flow in that procedure and skip original flow
#
iTopProc tap_unlock_custom {type skip_original_flow} {

   upvar 1 $skip_original_flow  skip_original

   # add your custom unlock/lock sequence below
   #iForcePort feature_en[2:0] 0b100
   #iApply

   # set $skip_original to 1 to use custom code above and skip the original flow
   set skip_original 0

   return
}

# User-defined pre-/post- reset procedures
iTopProc reset_powergood_pre  {} {}
iTopProc reset_powergood_post {} {

   # Updated IOV architecture - IOV enable preamble
   #iCall tap_set_secure_policy RED
   #iRunLoop 5
   #iWrite htap2.IOVRESET_0.DR 0b0
   #iApply

}

iTopProc reset_tlr_pre  {} {}
iTopProc reset_tlr_post {} {}

iTopProc reset_trst_pre  {} {}
iTopProc reset_trst_post {} {}

iTopProc reset_default_pre  {} {}
iTopProc reset_default_post {} {}
