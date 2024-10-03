# This is the tcl script for Jasper run.  To invoke, cd all_props;make
# You can run any valid Jasper tcl cmd in this script.
# By default, all properties are run matching a regexp pattern in the property names using the code below.
# Please feel free to change the following lines below and write what you want.


idrive_clk
idrive_rst

set target_props [get_all_properties_matching_name]
if { [llength $target_props] == 0 } { 
	puts "ERROR: Could not find any matching properties."
}
iprove_and_report $target_props




# Clocks : 
# =======
# clock
# pgcb_clk
#
# Resets : 
# =======
# pgcb_rst_b
#
# Inputs : 
# =======
# cfg_clkgate_disabled
# {cfg_clkgate_holdoff[3:0]}
# cfg_clkreq_ctl_disabled
# {cfg_clkreq_off_holdoff[3:0]}
# {cfg_clkreq_syncoff_holdoff[3:0]}
# {cfg_pwrgate_holdoff[3:0]}
# clkack
# fismdfx_clkgate_ovrd
# fismdfx_force_clkreq
# {fscan_byprst_b[2:0]}
# {fscan_clkgenctrl[1:0]}
# {fscan_clkgenctrlen[1:0]}
# fscan_clkungate
# {fscan_rstbypen[2:0]}
# {gclock_req_async[0:0]}
# gclock_req_sync
# {ism_agent[2:0]}
# {ism_fabric[2:0]}
# pgcb_force_rst_b
# pgcb_pok
# pgcb_pwrgate_active
# pgcb_restore
# pok_reset_b
# prescc_clock
# pwrgate_disabled
# pwrgate_force
# pwrgate_pmc_wake
# {reset_b[0:0]}
#
# Outputs : 
# ========
# boundary_locked
# {cdc_visa[23:0]}
# clkreq
# gclock
# {gclock_ack_async[0:0]}
# gclock_active
# gclock_enable_final
# {greset_b[0:0]}
# ism_locked
# pok
# pwrgate_ready
# {reset_sync_b[0:0]}
#

