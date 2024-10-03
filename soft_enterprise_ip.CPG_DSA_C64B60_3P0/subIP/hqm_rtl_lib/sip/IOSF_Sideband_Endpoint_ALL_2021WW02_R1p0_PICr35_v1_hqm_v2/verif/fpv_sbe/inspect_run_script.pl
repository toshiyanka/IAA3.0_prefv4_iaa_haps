#!/usr/intel/bin/perl
################################################################ 
# Run script for Sideband FPV env
#
# Original author:  Erik Seligma, Dhwani Daftary, 8/3/11
#
# Launch from the unix shell with:
#     inspect -s inspect_run_script.pl
#
################################################################

###################################################################################
# Inspect startup script
#
# To use, launch Inspect like this:
#     inspect --execute-perl "require '`pwd`/this_script';"
# All commands used are documented at
#     https://intelpedia.intel.com/InspectPro/Inspect_Pro_Scripting_Language
###################################################################################

# Major parameters
$DUT      = 'sbendpoint';
$PROJECT  = 'SB';
$MODEL_ROOT = $ENV{'MODEL_ROOT'};
$TOP_FILE = '$(MODEL_ROOT)/source/rtl/iosfsbc/endpoint/sbendpoint.sv';
$ACTIVITY = 'SB_ACT';
$FV_ROOT  = '$(FPV_WARD)';
#sideband clock
$PRIMARY_CLOCK = 'side_clk';
#agent clock
$SECONDARY_CLOCK = 'agent_clk';
#sideband reset
$RESETB = 'side_rst_b';
#agent side reset
#$AGT_RESETB = 'agent_rst_b';

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

#IP signals
$mmsg_pcirdy = 'mmsg_pcirdy';
$mmsg_npirdy = 'mmsg_npirdy';
$mmsg_pceom  = 'mmsg_pceom';
$mmsg_npeom  = 'mmsg_npeom';
$mmsg_pcpayload = 'mmsg_pcpayload';
$mmsg_nppayload = 'mmsg_nppayload';

$tmsg_npclaim = 'tmsg_npclaim';
$tmsg_npfree = 'tmsg_npfree';
$tmsg_pcfree = 'tmsg_pcfree';

$agent_clkreq = 'agent_clkreq';
$agent_idle = 'agent_idle';

$pc_vld = 'agent_compliance.agent_mmsg_compliance.m_agt_pc_msg_buf.vld';
$np_vld = 'agent_compliance.agent_mmsg_compliance.m_agt_np_msg_buf.vld';

#sideband compliance monitor
$FPV_BIND_FILE = '$(FPV_WARD)/sideband_compliance/sideband_fpv_bind.sv';
#agent compliance 
$FPV_AGT_BIND_FILE = '$(FPV_AGT_COMP)/agent_compliance/agent_fpv_bind.sv';

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
set_include_paths(1, '$(MODEL_ROOT)/source/rtl/iosfsbc/common', 
                  1, '$(MODEL_ROOT)/source/rtl/iosfsbc/endpoint', 
                  1, '$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/lib',
                  1, '$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/ism', 
                  1, '$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/sideband',
                  1, '$(MODEL_ROOT)/verif/fpv_sbe/sideband_compliance',
                  1, '$(MODEL_ROOT)/verif/bfm/sideband_vc/tb/intf',
                  1, '$(MODEL_ROOT)/verif/fpv_sbe/sideband_compliance',
                  1, '$(MODEL_ROOT)/verif/tests/ep_tests',
                  1, '$(MODEL_ROOT)/verif/tb/ep_tb/agent_compliance');
set_additional_files(
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/common/sbc_map.sv',
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/common/sbff.sv',
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/common/sbcport.sv',
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/common/sbcgcgu.sv',
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/common/sbcism.sv',
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/common/sbcingress.sv',
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/common/sbcegress.sv',
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/common/sbcinqueue.sv',
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/endpoint/sbebase.sv',
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/endpoint/sbemstr.sv',
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/endpoint/sbemstrreg.sv',
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/endpoint/sbetrgt.sv',
                     1,'$(MODEL_ROOT)/source/rtl/iosfsbc/endpoint/sbetrgtreg.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/lib/iosf_sb_lib_cam.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/lib/iosf_sb_lib_fifo.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/ism/iosf_sb_agent_ism_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/ism/iosf_sb_fabric_ism_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/ism/iosf_sb_clock_gating_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/sideband/iosf_sb_credit_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/sideband/iosf_sb_flow_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/sideband/iosf_sb_ifc_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/bfm/sideband_vc/compmon/sideband/iosf_sb_message_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/fpv_sbe/sideband_compliance/sideband_compliance.sv',
                     1,$FPV_BIND_FILE,
                     1,'$(MODEL_ROOT)/verif/tb/ep_tb/agent_compliance/agent_mmsg_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/tb/ep_tb/agent_compliance/agent_mreg_compliance.sv',
                     1,'$(MODEL_ROOT)/verif/tb/ep_tb/agent_compliance/agent_compliance.sv',
                     1,$FPV_AGT_BIND_FILE);

set_compilation_options( "-D FPV -D IOSF_COMPMON_MODULE -D VCS ".
                         "-mdr -pfn -l sv2008 -D EP_FPV"
                       );
set_compilation_trigger_quality_check_on( 1 );


############################################################################
# Clock, init, prun info.  Users may sometimes want to modify defaults below.
############################################################################
# Currently assumes primary and secondary clock in sync
# set clocks for sideband and agent side
set_clocks(1, $PRIMARY_CLOCK, '1',1,$SECONDARY_CLOCK,'1' );
set_initialization( $INITIALIZATION_SEQUENCE );
# set initialization sequences for side_rst and agent_rst and some additional signals that otherwise shwo up as Xs and cause undetermined behavior
set_initialization_sequences(1,$INITIALIZATION_SEQUENCE_SIGNAL,$RESETB,0,101,0,
                             #1,$INITIALIZATION_SEQUENCE_SIGNAL,$AGT_RESETB,0,101,0,
                             1,$INITIALIZATION_SEQUENCE_SIGNAL, $mmsg_pcirdy,0,101,0,
                             1,$INITIALIZATION_SEQUENCE_SIGNAL, $mmsg_npirdy,0,101,0,
                             1,$INITIALIZATION_SEQUENCE_SIGNAL, $mmsg_pceom,0,101,0,
                             1,$INITIALIZATION_SEQUENCE_SIGNAL, $mmsg_npeom,0,101,0,
                             1,$INITIALIZATION_SEQUENCE_SIGNAL, $mmsg_pcpayload,0,101,"00000000000000000000000000000000",
                             1,$INITIALIZATION_SEQUENCE_SIGNAL, $mmsg_nppayload,0,101,"00000000000000000000000000000000",
                             1,$INITIALIZATION_SEQUENCE_SIGNAL, $agent_clkreq,0,101,"1",
                             1,$INITIALIZATION_SEQUENCE_SIGNAL, $agent_idle,0,101,"1"
                            );

# set_global_prunings(1, $PRUNING_DIRECTIVE_FILE, $GLOB_PRUN, '');

for($i=0;$i<72;$i++){
    push(@my_pc_flits, 1, $PRUNING_DIRECTIVE_INCLUDE, "agent_compliance.agent_mmsg_compliance.m_agt_pc_msg_buf.flits[$i][7:0]",0);
    push(@my_np_flits, 1, $PRUNING_DIRECTIVE_INCLUDE, "agent_compliance.agent_mmsg_compliance.m_agt_np_msg_buf.flits[$i][7:0]",0);
}

# Set verication pruning for side_rst and agent_rst
set_verification_prunings(1,$PRUNING_DIRECTIVE_SET, $RESETB,1,
                          #1,$PRUNING_DIRECTIVE_SET, $AGT_RESETB,1,
                          1,$PRUNING_DIRECTIVE_SET, $cgctrl_idlecnt,"16",
                          1,$PRUNING_DIRECTIVE_SET, $cgctrl_clkgaten,1,
                          1,$PRUNING_DIRECTIVE_SET, $cgctrl_clkgatedef,0,
                          1,$PRUNING_DIRECTIVE_SET, $jta_clkgate_ovrd,0,
                          1,$PRUNING_DIRECTIVE_SET, $jta_force_clkreq,0,
                          1,$PRUNING_DIRECTIVE_SET, $jta_force_idle,0,
                          1,$PRUNING_DIRECTIVE_SET, $jta_force_notidle,0,
                          1,$PRUNING_DIRECTIVE_SET, $jta_force_creditreq,0,
                          1,$PRUNING_DIRECTIVE_SET, $fscan_latchclosed_b,1,
                          1,$PRUNING_DIRECTIVE_SET, $fscan_clkungate,0,
                          1,$PRUNING_DIRECTIVE_SET, $fscan_rstbypen,0,
                          1,$PRUNING_DIRECTIVE_SET, $fscan_latchopen,0,
                          1,$PRUNING_DIRECTIVE_INCLUDE, $pc_vld,0,
                          1,$PRUNING_DIRECTIVE_INCLUDE, $np_vld,0,
                          1,$PRUNING_DIRECTIVE_SET, $tmsg_pcfree,1,
                          1,$PRUNING_DIRECTIVE_SET, $tmsg_npfree,1,
                          1,$PRUNING_DIRECTIVE_SET, $agent_idle,0,
                          1,$PRUNING_DIRECTIVE_SET, $agent_clkreq,1,
                          @my_np_flits,
                          @my_pc_flits                          
                         
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

#set_netbatch_on( 1 );
#set_netbatch_pool( 'CSE_VirtualPool_nb6' );
#set_netbatch_class( 'SLES_EM64T_4G_nosusp' );
#set_netbatch_slot( '/SEG/All/SIP/sb' );
#set_cex_k_delay( 10 );

###########################################################################
# Control active properties if desired
###########################################################################
#removing the all active assertions call, till they all have been debugged 
#successfully and all assumptions fixed
#set_all_assertions_active( );

set_all_covers_active( );
set_all_assumptions_active( );
set_verification_trigger_quality_check_on( 1 );
# Remove all asserts from the active list
remove_all_active_assertions();

# Add the ones we know are provable back into the active list
add_active_assertions(
"sbendpoint.agent_compliance.vr_ep_0001", 
"sbendpoint.agent_compliance.vr_ep_0018",
"sbendpoint.agent_compliance.vr_ep_0020",
"sbendpoint.agent_compliance.vr_ep_0022",
"sbendpoint.agent_compliance.vr_ep_0023",
"sbendpoint.agent_compliance.vr_ep_0025",
"sbendpoint.agent_compliance.vr_ep_0026",
"sbendpoint.agent_compliance.vr_ep_0027", 
"sbendpoint.agent_compliance.vr_ep_0028", 
"sbendpoint.agent_compliance.vr_ep_0029",
"sbendpoint.agent_compliance.vr_ep_0030",
"sbendpoint.agent_compliance.vr_ep_0031",
"sbendpoint.agent_compliance.vr_ep_0033",
"sbendpoint.agent_compliance.vr_ep_0035",
"sbendpoint.agent_compliance.vr_ep_0036",
"sbendpoint.agent_compliance.vr_ep_0037",
"sbendpoint.agent_compliance.vr_ep_0038",
"sbendpoint.agent_compliance.vr_ep_0039",
"sbendpoint.agent_compliance.vr_ep_0041",
"sbendpoint.agent_compliance.vr_ep_0044", 
"sbendpoint.agent_compliance.vr_ep_0047", 
"sbendpoint.agent_compliance.vr_ep_0053",
"sbendpoint.agent_compliance.vr_ep_0054",
"sbendpoint.agent_compliance.vr_ep_0055",
"sbendpoint.agent_compliance.vr_ep_0056",
"sbendpoint.agent_compliance.vr_ep_0057",
"sbendpoint.agent_compliance.vr_ep_0058",
"sbendpoint.agent_compliance.vr_ep_0059",
"sbendpoint.agent_compliance.vr_ep_0095",
"sbendpoint.agent_compliance.vr_ep_0418",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.ISMPM_ISM_Stabilization.ISMPM_ISM_Stabilization_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.SBMI_062_ClkReqValidFromReset.SBMI_062_ClkReqValidFromReset_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.SBMI_062_ValidSignals_Agent.SBMI_062_ValidSignals_Agent_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.SBMI_062_meomValidFromReset.SBMI_062_meomValidFromReset_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.SBMI_062_mnpputValidFromReset.SBMI_062_mnpputValidFromReset_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.SBMI_062_mpcputValidFromReset.SBMI_062_mpcputValidFromReset_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.SBMI_062_tnpcupValidFromReset.SBMI_062_tnpcupValidFromReset_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.SBMI_062_tpccupValidFromReset.SBMI_062_tpccupValidFromReset_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_credit_compliance.FlowCompliance[0].ISMPM_007_SBMI_061_AgentCreditCanNotBeZeroWhen_CREDIT_DONE.ISMPM_007_SBMI_061_AgentCreditCanNotBeZeroWhen_CREDIT_DONE_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_credit_compliance.FlowCompliance[0].ISMPM_009_010_CreditUpdateWhenISMIsActive.ISMPM_009_010_CreditUpdateWhenISMIsActive_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_credit_compliance.FlowCompliance[0].ISMPM_020_UpdateCreditOnlyAfterReclaiming.ISMPM_020_UpdateCreditOnlyAfterReclaiming_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_credit_compliance.FlowCompliance[0].SBMI_016_017_ISMPM_009_010_PutOnlyWhenISMIsActive.SBMI_016_017_ISMPM_009_010_PutOnlyWhenISMIsActive_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_credit_compliance.FlowCompliance[1].ISMPM_007_SBMI_061_AgentCreditCanNotBeZeroWhen_CREDIT_DONE.ISMPM_007_SBMI_061_AgentCreditCanNotBeZeroWhen_CREDIT_DONE_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_credit_compliance.FlowCompliance[1].ISMPM_009_010_CreditUpdateWhenISMIsActive.ISMPM_009_010_CreditUpdateWhenISMIsActive_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_credit_compliance.FlowCompliance[1].ISMPM_020_UpdateCreditOnlyAfterReclaiming.ISMPM_020_UpdateCreditOnlyAfterReclaiming_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_credit_compliance.FlowCompliance[1].SBMI_016_017_ISMPM_009_010_PutOnlyWhenISMIsActive.SBMI_016_017_ISMPM_009_010_PutOnlyWhenISMIsActive_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_flow_compliance.SBMI_059_NPAndPCPutsCanNotHappenTogether.SBMI_059_NPAndPCPutsCanNotHappenTogether_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_flow_compliance.SBMI_ValidPayloadSize.SBMI_ValidPayloadSize_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_AgentStuckIn_ACTIVE_REQ.ISMPM_002_AgentStuckIn_ACTIVE_REQ_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_AgentStuckIn_ACTIVE_REQ_bis.ISMPM_002_AgentStuckIn_ACTIVE_REQ_bis_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_AgentStuckIn_CREDIT_DONE.ISMPM_002_AgentStuckIn_CREDIT_DONE_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_AgentStuckIn_CREDIT_REQ.ISMPM_002_AgentStuckIn_CREDIT_REQ_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_AgentStuckIn_IDLE.ISMPM_002_AgentStuckIn_IDLE_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_AgentStuckIn_IDLE_REQ.ISMPM_002_AgentStuckIn_IDLE_REQ_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_AgentStuckIn_IDLE_REQ_bis.ISMPM_002_AgentStuckIn_IDLE_REQ_bis_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_AgentStuckIn_IDLE_bis.ISMPM_002_AgentStuckIn_IDLE_bis_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_ISM_Initialization_With_AGENT_CREDIT_REQ.ISMPM_002_ISM_Initialization_With_AGENT_CREDIT_REQ_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_ISM_Initialization_With_AGENT_IDLE.ISMPM_002_ISM_Initialization_With_AGENT_IDLE_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_ACTIVE_1.ISMPM_002_StateTransitionFrom_AGENT_ACTIVE_1_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_ACTIVE_2.ISMPM_002_StateTransitionFrom_AGENT_ACTIVE_2_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_ACTIVE_REQ_1.ISMPM_002_StateTransitionFrom_AGENT_ACTIVE_REQ_1_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_ACTIVE_REQ_2.ISMPM_002_StateTransitionFrom_AGENT_ACTIVE_REQ_2_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_ACTIVE_REQ_3.ISMPM_002_StateTransitionFrom_AGENT_ACTIVE_REQ_3_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_CREDIT_DONE_1.ISMPM_002_StateTransitionFrom_AGENT_CREDIT_DONE_1_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_CREDIT_DONE_2.ISMPM_002_StateTransitionFrom_AGENT_CREDIT_DONE_2_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_CREDIT_INIT_1.ISMPM_002_StateTransitionFrom_AGENT_CREDIT_INIT_1_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_CREDIT_INIT_2.ISMPM_002_StateTransitionFrom_AGENT_CREDIT_INIT_2_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_CREDIT_REQ_1.ISMPM_002_StateTransitionFrom_AGENT_CREDIT_REQ_1_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_CREDIT_REQ_2.ISMPM_002_StateTransitionFrom_AGENT_CREDIT_REQ_2_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_IDLE_1.ISMPM_002_StateTransitionFrom_AGENT_IDLE_1_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_IDLE_2.ISMPM_002_StateTransitionFrom_AGENT_IDLE_2_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_IDLE_3.ISMPM_002_StateTransitionFrom_AGENT_IDLE_3_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_IDLE_4.ISMPM_002_StateTransitionFrom_AGENT_IDLE_4_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_IDLE_REQ_1.ISMPM_002_StateTransitionFrom_AGENT_IDLE_REQ_1_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_IDLE_REQ_2.ISMPM_002_StateTransitionFrom_AGENT_IDLE_REQ_2_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_002_StateTransitionFrom_AGENT_IDLE_REQ_3.ISMPM_002_StateTransitionFrom_AGENT_IDLE_REQ_3_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_008_AgentMustReturnCreditsBeforeMovingTo_CREDIT_REQ.ISMPM_008_AgentMustReturnCreditsBeforeMovingTo_CREDIT_REQ_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_045_InterfaceIdleForSixteenClocks.ISMPM_045_InterfaceIdleForSixteenClocks_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_045_InterfaceNotInMiddleOfTransaction.ISMPM_045_InterfaceNotInMiddleOfTransaction_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_045_MinimumAgentCreditsAdvertised.ISMPM_045_MinimumAgentCreditsAdvertised_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_ism_compliance.ISMPM_046_AgentMustEnter_IDLE_REQ.ISMPM_046_AgentMustEnter_IDLE_REQ_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].CheckSAIOnMasterInterface.SBMI_096_100_MasterHasNoSAISupport.SBMI_096_100_MasterHasNoSAISupport_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].CheckSAIOnMasterInterface.SBMI_096_100_MasterHasSAISupport.SBMI_096_100_MasterHasSAISupport_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_024_MessageIsMultipleDWInLength.SBMI_024_MessageIsMultipleDWInLength_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_027_030_054_RegAccess16bitAddrForIOCFG.SBMI_027_030_054_RegAccess16bitAddrForIOCFG_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_030_055_057_058_MemIORegAccessAddrDWAligned.SBMI_030_055_057_058_MemIORegAccessAddrDWAligned_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_030_055_CfgRegAccessAddrDWAligned.SBMI_030_055_CfgRegAccessAddrDWAligned_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_034_053_RegWriteIsValid_NonZeroSBE.SBMI_034_053_RegWriteIsValid_NonZeroSBE_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_034_053_RegWriteIsValid_ZeroSBE.SBMI_034_053_RegWriteIsValid_ZeroSBE_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_036_041_CompletionIsValid.SBMI_036_041_CompletionIsValid_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_042_050_CompletionWithDataIsValid.SBMI_042_050_CompletionWithDataIsValid_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_048_DataMessageReservedBitsDrivenToZero.SBMI_048_DataMessageReservedBitsDrivenToZero_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_048_SimpleMessageReservedBitsDrivenToZero.SBMI_048_SimpleMessageReservedBitsDrivenToZero_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_049_SimpleMessageIsSingleDW.SBMI_049_SimpleMessageIsSingleDW_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_060_MessageUsesAllowedOpcode.SBMI_060_MessageUsesAllowedOpcode_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_063_DataMessageAtLeast2DW.SBMI_063_DataMessageAtLeast2DW_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_082_RegReadIsValid.SBMI_082_RegReadIsValid_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[0].SBMI_SomeNum_RegAccessValidAddrModePreEH.SBMI_SomeNum_RegAccessValidAddrModePreEH_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].CheckSAIOnMasterInterface.SBMI_096_100_MasterHasNoSAISupport.SBMI_096_100_MasterHasNoSAISupport_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].CheckSAIOnMasterInterface.SBMI_096_100_MasterHasSAISupport.SBMI_096_100_MasterHasSAISupport_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_024_MessageIsMultipleDWInLength.SBMI_024_MessageIsMultipleDWInLength_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_027_030_054_RegAccess16bitAddrForIOCFG.SBMI_027_030_054_RegAccess16bitAddrForIOCFG_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_030_055_057_058_MemIORegAccessAddrDWAligned.SBMI_030_055_057_058_MemIORegAccessAddrDWAligned_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_030_055_CfgRegAccessAddrDWAligned.SBMI_030_055_CfgRegAccessAddrDWAligned_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_034_053_RegWriteIsValid_NonZeroSBE.SBMI_034_053_RegWriteIsValid_NonZeroSBE_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_034_053_RegWriteIsValid_ZeroSBE.SBMI_034_053_RegWriteIsValid_ZeroSBE_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_036_041_CompletionIsValid.SBMI_036_041_CompletionIsValid_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_042_050_CompletionWithDataIsValid.SBMI_042_050_CompletionWithDataIsValid_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_048_DataMessageReservedBitsDrivenToZero.SBMI_048_DataMessageReservedBitsDrivenToZero_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_048_SimpleMessageReservedBitsDrivenToZero.SBMI_048_SimpleMessageReservedBitsDrivenToZero_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_049_SimpleMessageIsSingleDW.SBMI_049_SimpleMessageIsSingleDW_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_060_MessageUsesAllowedOpcode.SBMI_060_MessageUsesAllowedOpcode_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_063_DataMessageAtLeast2DW.SBMI_063_DataMessageAtLeast2DW_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_082_RegReadIsValid.SBMI_082_RegReadIsValid_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.MessageValidityCheck[1].SBMI_SomeNum_RegAccessValidAddrModePreEH.SBMI_SomeNum_RegAccessValidAddrModePreEH_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.SBMI_082_ReadCanNotBePosted.SBMI_082_ReadCanNotBePosted_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.SBMI_115_DO_SERRIsPosted.SBMI_115_DO_SERRIsPosted_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.SBMI_115_SIMPLEIsPosted.SBMI_115_SIMPLEIsPosted_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.SBMI_116_CFGWRIsNonPosted.SBMI_116_CFGWRIsNonPosted_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.SBMI_116_IOWRIsNonPosted.SBMI_116_IOWRIsNonPosted_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.SBMI_116_LTRIsPosted.SBMI_116_LTRIsPosted_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.SBMI_116_PCIErrorIsPosted.SBMI_116_PCIErrorIsPosted_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.SBMI_116_PCIPMIsPosted.SBMI_116_PCIPMIsPosted_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.SBMI_116_PMIsPosted.SBMI_116_PMIsPosted_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.SBMI_CompletionCanNotBeNonPosted.SBMI_CompletionCanNotBeNonPosted_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.SBMI_SomeNum_LTRSizeValid.SBMI_SomeNum_LTRSizeValid_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.agent_message_compliance.SBMI_SomeNum_PMIsSizeValid.SBMI_SomeNum_PMIsSizeValid_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.clock_gating_compliance.ISMPM_015_ClkReqDeassertsOnlyWhenAgentIsmIsInIdleState.ISMPM_015_ClkReqDeassertsOnlyWhenAgentIsmIsInIdleState_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.clock_gating_compliance.ISMPM_032_AgentIs_IDLE_WhenClockIsInvalid.ISMPM_032_AgentIs_IDLE_WhenClockIsInvalid_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.clock_gating_compliance.ISMPM_033_AgentNeeds_clkreq_And_clkack_ToMoveTo_IDLE_REQ_Or_CREDIT_DONE.ISMPM_033_AgentNeeds_clkreq_And_clkack_ToMoveTo_IDLE_REQ_Or_CREDIT_DONE_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.clock_gating_compliance.ISMPM_034_clkreq_Rises.ISMPM_034_clkreq_Rises_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.clock_gating_compliance.ISMPM_035_clkreq_Falls.ISMPM_035_clkreq_Falls_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.clock_gating_compliance.ISMPM_IntoOrOutOfIdle_1",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.clock_gating_compliance.ISMPM_IntoOrOutOfIdle_2",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.clock_gating_compliance.ISMPM_PreidleAxiom_1",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.clock_gating_compliance.ISMPM_PreidleAxiom_2",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.clock_gating_compliance.ISMPM_PreidleAxiom_3",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.clock_gating_compliance.ISMPM_SBMI_062_PRI_157_StateInitialization_clkreq.ISMPM_SBMI_062_PRI_157_StateInitialization_clkreq_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.fabric_flow_compliance.SBMI_ValidPayloadSize.SBMI_ValidPayloadSize_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.fabric_message_compliance.SBMI_006_QueueShouldNeverBeFull.SBMI_006_QueueShouldNeverBeFull_ASSERT",
"sbendpoint.sbc_compliance.sbc_ifc_compliance.fabric_message_compliance.SBMI_SomeNum_NoMultiplePendingPMRequest.SBMI_SomeNum_NoMultiplePendingPMRequest_ASSERT",
);


#get verification results
$vr_results = get_verification_results();
open VR_RESULT_FILE, ">SBE_VERIFICATION_RESULTS.csv";

print VR_RESULT_FILE "$vr_results";

close VR_RESULT_FILE;

###########################################################################
# KEEP AT END, DO NOT REMOVE
###########################################################################
# return good status code from script
1;

