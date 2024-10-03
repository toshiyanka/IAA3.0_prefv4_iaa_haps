# This is the tcl script for Jasper run.  To invoke, cd all_props_task1;make
# You can run any valid Jasper tcl cmd in this script.
# By default, all properties are run matching a regexp pattern in the property names using the code below.
# Please feel free to change the following lines below and write what you want.


idrive_clk
idrive_rst

#iparam -set_param DEF_PWRON=1 -set_param ISOLLATCH_NOSR_EN=0 
set target_props [get_all_properties_matching_name ]
if { [llength $target_props] == 0 } { 
	puts "ERROR: Could not find any matching properties."
}
iprove_and_report $target_props




# Clocks : 
# =======
# clk
# pgcb_tck
#
# Resets : 
# =======
# pgcb_rst_b
# fdfx_powergood_rst_b
#
# Inputs : 
# =======
# {cfg_taccrstup[1:0]}
# {cfg_tclksoffack_srst[1:0]}
# {cfg_tclksonack_cp[1:0]}
# {cfg_tclksonack_srst[1:0]}
# {cfg_tdeisolate[1:0]}
# {cfg_tinaccrstup[1:0]}
# {cfg_tisolate[1:0]}
# {cfg_tlatchdis[1:0]}
# {cfg_tlatchen[1:0]}
# {cfg_tpokdown[1:0]}
# {cfg_tpokup[1:0]}
# {cfg_trstdown[1:0]}
# {cfg_trstup2frcclks[1:0]}
# {cfg_trsvd0[1:0]}
# {cfg_trsvd1[1:0]}
# {cfg_trsvd2[1:0]}
# {cfg_trsvd3[1:0]}
# {cfg_trsvd4[1:0]}
# {cfg_tsleepact[1:0]}
# {cfg_tsleepinactiv[1:0]}
# fdfx_pgcb_bypass
# fdfx_pgcb_ovr
# fscan_isol_ctrl
# fscan_isol_lat_ctrl
# fscan_mode
# fscan_ret_ctrl
# ip_pgcb_all_pg_rst_up
# ip_pgcb_force_clks_on_ack
# ip_pgcb_frc_clk_cp_en
# ip_pgcb_frc_clk_srst_cc_en
# ip_pgcb_pg_rdy_req_b
# {ip_pgcb_pg_type[1:0]}
# ip_pgcb_sleep_en
# pmc_pgcb_fet_en_b
# pmc_pgcb_pg_ack_b
# pmc_pgcb_restore_b
#
# Outputs : 
# ========
# pgcb_force_rst_b
# pgcb_idle
# pgcb_ip_fet_en_b
# pgcb_ip_force_clks_on
# pgcb_ip_pg_rdy_ack_b
# pgcb_isol_en_b
# pgcb_isol_latchen
# pgcb_pmc_pg_req_b
# pgcb_pok
# pgcb_pwrgate_active
# pgcb_restore
# pgcb_restore_force_reg_rw
# pgcb_sleep
# pgcb_sleep2
# {pgcb_visa[23:0]}
#

