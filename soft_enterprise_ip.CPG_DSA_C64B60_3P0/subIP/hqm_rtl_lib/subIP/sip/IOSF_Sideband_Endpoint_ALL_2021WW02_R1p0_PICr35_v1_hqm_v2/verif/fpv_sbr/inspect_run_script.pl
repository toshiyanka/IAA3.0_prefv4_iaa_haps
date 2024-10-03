################################################################ 
# Run script for Sideband Router FPV env
#
# Original author:  Erik Seligman, 11/14/11
#
# Launch from the unix shell with:
#     inspect -s inspect_run_script.pl
#
# Be sure to set env vars MODEL_ROOT and FPV_WARD first.
################################################################

###################################################################################
# Inspect startup script
#
# All commands used are documented at
#     https://intelpedia.intel.com/InspectPro/Inspect_Pro_Scripting_Language
###################################################################################

# Major parameters
$DUT      = 'sbr';
$PROJECT  = 'SB';
$MODEL_ROOT = $ENV{'MODEL_ROOT'};
$TOP_FILE = '$(MODEL_ROOT)/verif/fpv_sbr/sbr_tb/sbr.sv';
$ACTIVITY = 'SB_ACT';
$FV_ROOT  = '$(FPV_WARD)';
#sideband clock
$PRIMARY_CLOCK = 'clk';
#agent clock
$SECONDARY_CLOCK = '';
#sideband reset
$RESETB = 'rstb';
#agent side reset
$AGT_RESETB = '';

#cgctrl Config register values
$cgctrl_idlecnt = 'cgctrl_idlecnt';
$cgctrl_clkgaten = 'cgctrl_clkgaten';
$cgctrl_clkgatedef = 'cgctrl_clkgatedef';

#jtag values
$jta_clkgate_ovrd = 'jta_clkgate_ovrd';
$jta_force_clkreq = 'jta_force_clkreq';
$jta_force_idle = 'jta_force_idle';
$jta_force_notidle = 'jta_force_notidle';
$jta_force_creditreq = 'jta_force_creditreq';

#fscan
$fscan_latchclosed_b = 'fscan_latchclosed_b';
$fscan_clkungate = 'fscan_clkungate';
$fscan_rstbypen = 'fscan_rstbypen';
$fscan_latchopen = 'fscan_latchopen';
$pd1_pwrgd = 'pd1_pwrgd';

#sideband compliance monitor
$FPV_BIND_FILE = '$(FPV_WARD)/fabric_compliance/fabric_fpv_bind.sv';
# Turn off traffic at all ports except 0 and 1 initially, to simplify
# proof debug.  After the 2-port proofs are clean, we can then relax &
# make more active.
$FPV_ASSUME_FILE = '$(FPV_WARD)/fabric_compliance/fabric_assumptions.sv';

#############################################################################
# Project/activity creation or opening.  Depends on above parameters, users
# should not need to edit.
#############################################################################

# Create project.  (If it already exists, new_project will quietly fail.) 
# Load it if it does exist.
open_project("$FV_ROOT/cfg/${PROJECT}.xml");
new_project("$FV_ROOT/cfg/$PROJECT.xml");

# Create activity.  (If it already exists, add_activity will quietly fail.)
add_activity($ACTIVITY);
set_current_project_and_activity($PROJECT,$ACTIVITY);
set_working_directory( "$FV_ROOT/work" );
set_top_module_name($DUT);
set_top_level_file_name($TOP_FILE);


#############################################################################
# Compilation options.  Users may sometimes want to modify defaults below.
#############################################################################

set_language( $LANGUAGE_SV2008 );
set_include_paths(1, '$(MODEL_ROOT)/verif/fpv_sbr/fpv_sbr', 
                  1, '$(MODEL_ROOT)/verif/fpv_sbr/fabric_compliance', 
                  1, '$(MODEL_ROOT)/source/rtl/iosfsbc/router', 
                  1, '$(MODEL_ROOT)/source/rtl/iosfsbc/common', 
                  1, '$(MODEL_ROOT)/source/rtl/iosfsbc/endpoint', 
                  1, '$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/lib',
                  1, '$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/ism', 
                  1, '$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/sideband',
                  1, '$(MODEL_ROOT)/verif/bfm/sideband_vc/tb/intf');
set_additional_files(
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/common/sbc_map.sv',
                     1,$FPV_BIND_FILE,
                     1,'$(MODEL_ROOT)/verif/fpv_sbr/fabric_compliance/fabric_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/lib/iosf_sb_lib_cam.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/lib/iosf_sb_lib_fifo.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/ism/iosf_sb_agent_ism_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/ism/iosf_sb_fabric_ism_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/ism/iosf_sb_clock_gating_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/sideband/iosf_sb_credit_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/sideband/iosf_sb_flow_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/sideband/iosf_sb_ifc_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/sideband/iosf_sb_message_compliance.sv',
                     1,$FPV_ASSUME_FILE);

set_compilation_options( "-D FPV -D IOSF_COMPMON_MODULE -D VCS -fex sv ".
                         "-mdr -pfn -l sv2008"
                       );
set_compilation_trigger_quality_check_on( 1 );


############################################################################
# Clock, init, prun info.  Users may sometimes want to modify defaults below.
############################################################################
# Currently assumes primary and secondary clock in sync
# set clocks for sideband and agent side
set_clocks(1, $PRIMARY_CLOCK, '1',0,$SECONDARY_CLOCK,'1' );
set_initialization( $INITIALIZATION_SEQUENCE );
# set initialization sequences for side_rst and agent_rst and some additional signals that otherwise shwo up as Xs and cause undetermined behavior
set_initialization_sequences(1,$INITIALIZATION_SEQUENCE_SIGNAL,$RESETB,0,101,0,
                             );

# set_global_prunings(1, $PRUNING_DIRECTIVE_FILE, $GLOB_PRUN, '');

# Set verication pruning for side_rst and agent_rst
set_verification_prunings(1,$PRUNING_DIRECTIVE_SET, $RESETB,1,
                          1,$PRUNING_DIRECTIVE_SET, $fscan_latchclosed_b,1,
                          1,$PRUNING_DIRECTIVE_SET, $fscan_clkungate,0,
                          1,$PRUNING_DIRECTIVE_SET, $fscan_rstbypen,0,
                          1,$PRUNING_DIRECTIVE_SET, $fscan_latchopen,0,
                          1,$PRUNING_DIRECTIVE_SET, $pd1_pwrgd,1,
                         );
set_internal_verification_options( "--proversl --fsdb");

# All signals transition only on posedge of clk
set_stable_inputs(1,$PRIMARY_CLOCK,$STABLE_INPUT_POSEDGE,
                  $STABLE_INPUT_ALL_SIGNALS,'');

#Alternatively, can have many lines like:
# set_stable_inputs(1,$PRIMARY_CLOCK,$STABLE_INPUT_POSEDGE,
#                  $STABLE_INPUT_SIGNAL,'foo');



############################################################################
# Proof strategy  & engine choices.  Will sometimes be tuned by users.
############################################################################
#TODO: Increase Bound(30) to high value once none of the assertions are failing
add_verification_strategy(
        1, $STRATEGY_BMC, "", "1", "60", "7200", 0, 0);


# set_netbatch_pool( '$(NBPOOL)' );
# set_netbatch_class( '$(NBCLASS)' );
# set_netbatch_slot( '$(NBQSLOT)' );
#set_cex_k_delay( 10 );

###########################################################################
# Control active properties if desired
# We should probably turn off covers on interfaces other than 0 and 1, if
# initially doing 2-endpoint proofs.
###########################################################################
set_all_assertions_active( );
set_all_covers_active( );
set_all_assumptions_active( );
set_verification_trigger_quality_check_on( 1 );


#get verification results
$vr_results = get_verification_results();
open VR_RESULT_FILE, ">SBR_VERIFICATION_RESULTS.csv";

print VR_RESULT_FILE "$vr_results";

close VR_RESULT_FILE;
###########################################################################
# KEEP AT END, DO NOT REMOVE
###########################################################################
# return good status code from script
1;

