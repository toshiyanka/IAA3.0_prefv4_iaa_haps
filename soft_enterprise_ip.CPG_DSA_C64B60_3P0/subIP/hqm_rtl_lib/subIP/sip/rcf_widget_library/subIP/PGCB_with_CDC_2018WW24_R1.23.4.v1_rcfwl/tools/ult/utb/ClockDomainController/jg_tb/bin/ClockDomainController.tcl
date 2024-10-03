
clear -all

include "$env(IJL_ROOT)/intel_jg_lib.tcl"

set top ClockDomainController

ijl_set_standard_intel_env
ijl_safe_set_msg -warning VERI-9030

iset_proof_kit_vars

################################### STEPS TO ENABLE PROOF KIT ##############################
#
# If you created a bind file with valid port-maps, uncomment the ienable_pk cmd (#UNCOMMENT_ME...) 
# and restart.  If you dont't have a bind file with valid port-maps, run the following ienable_pk 
# cmd in JG console (please replace the <pk_name> with one of the supported ones):
#
# ienable_pk <pk_name> "../../jg_tb/inc/ClockDomainController_<pk_name>_bind.sv" edit_bind_file
#
# You must use multiple ienable_pk # cmd for each interface.  For example, if you have 
# IOSF prim, SB, and AHB, you need 3 ienable_pk commands. In that case, you would have:
#
# ienable_pk iosf_prim "../../jg_tb/inc/ClockDomainController_iosf_prim_bind.sv"
# ienable_pk iosf_sb "../../jg_tb/inc/ClockDomainController_iosf_sb_bind.sv"
# ienable_pk ahb "../../jg_tb/inc/ClockDomainController_ahb_bind.sv"
#
# If you have multiple interfaces of the same bus, you may use one or multiple bind files.
# For example, when having 2 IOSF SB, you can use 1 bind file with two bind cmds or use
# 2 bind files each having one bind command per sideband interface.
#
############################################################################################
#UNCOMMENT_ME_WHEN_BIND_FILE_IS_GOOD ienable_pk iosf_sb "../../jg_tb/inc/ClockDomainController_iosf_sb_bind.sv" 

proc run_analyze {} {
    set acmd "ijl_analyze +define+FPV +define+FPV_RESTRICT +define+SVA_FORMAL +define+SVA_LIB_SVA2005 \
     \
    +define+SVA_LIB_SVA2005 \
    +define+INSTANTIATE_HIERDUMP \
    +incdir+../../../../../../src/rtl/ClockDomainController \
    -y ../../../../../../../../../../../../site/disks/hdk.cad.2/linux_2.6.16_x86-64/ctech/c2v16ww27e_hdk136/source/v \
    -y ../../../../../../src/rtl/ClockDomainController \
    +libext+.sv \
    $::IOSF_CM_ENTRIES \
    ../../../../../../src/rtl/common/pgcb_ctech_map.sv \
    ../../../../../../src/rtl/ClockDomainController/ClockDomainController.sv"

    eval $acmd
    return $acmd
}

proc run_elaborate {{elab_switches_list ""}} {

    run_analyze

    if { [llength $elab_switches_list] > 0 } {
        set ecmd [concat "ijl_elaborate -top ClockDomainController" $elab_switches_list]
        puts "The elab cmd: $ecmd"
    } else {
        set ecmd "ijl_elaborate -top ClockDomainController"
    }
    eval $ecmd
    return $ecmd
}

ijl_set_local_mode {1}

if { [info exists env(UTB_XPROP_EN)] == 1 } {
    check_xprop -init_all_control 1 -init_all_data 1
}

if { [info exists env(USE_TASK_ELAB_CMD)] != 1 } {
    run_elaborate { -loop_limit 16000}
} else {
    include "$env(JG_TASK_ELAB_TCL)"
}

set_max_trace_length 0

idrive_clk
idrive_rst

if { [file exists "../../jg_tb/bin/ClockDomainController_user.tcl"] } {
    include "../../jg_tb/bin/ClockDomainController_user.tcl"
}

