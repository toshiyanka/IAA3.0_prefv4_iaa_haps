#-----------------------------------------------------------------------
# Intel Proprietary -- Copyright 2012 Intel -- All rights reserved
#-----------------------------------------------------------------------
# Description: Unit CDC control script.
#-----------------------------------------------------------------------

cdc preference  -detect_pure_latch_clock
cdc preference  -filtered_report

#cdc report scheme bus_four_latch -severity violation
#cdc report scheme bus_two_dff_phase -severity violation
#cdc report scheme four_latch -severity violation
#cdc report scheme pulse_sync -severity violation
#cdc report scheme shift_reg -severity violation
#cdc report scheme two_dff_phase -severity violation
#cdc report scheme async_reset -severity violation


#----------------------Define Clocks------------------------------------
#Example1: netlist clock cpu_clk_in -group CPU_CLK_GR0

netlist clock pgcb_clk -group PGCB_CLK
netlist clock clock -group CDC_CLK
netlist clock prescc_clock -group PRESCC_CDC_CLK 

netlist clock gclock -group CDC_CLK



#----------------------Define Resets------------------------------------
#Directive "netlist reset" will add signals to the list of
#resets or remove the specified signals from the list of resets.

#Example1: netlist reset rst_* -negedge -module pci 
#Example2: netlist reset -remove rst_a  -module crc_16_calc

netlist reset pgcb_rst_b -negedge
netlist reset reset_b -negedge
netlist reset pok_reset_b -negedge


#----------------------Define constants-------------------------------
#Example1: netlist constant scan_mode         1'b0
#Example2: netlist constant U0.scan_mode[1:4] 1'b1

netlist constant fscan_clkungate 1'b0
netlist constant fscan_rstbypen 0
netlist constant fscan_byprst_b 0
netlist constant fscan_clkgenctrlen 0


#----------------------Define stable signals---------------------------
#CDC analysis considers a stable signal as properly synchronized.
#The -stable option has no effect if signal is not an Rx or Tx of a CDC
#crossing, or if signal cannot be propagated to an Rx of a CDC crossing,
#or if signal drives an input of combinational logic whose output is not
#stable

#Example2: cdc signal tx_status -stable 





#----------------------Define black box-------------------------------
#User-defined black box:
#If the clock domain for a port is specified (using a netlist port domain
#directive), the port is included in CDC analysis. Otherwise, fanin/fanout
#logic of the port is ignored. No CDC crossing is reported for the port,
#but a warning is issued (netlist-44). Ports asynchronous with the defined clocks should
#be identified as such using the -async argument.

#Example1: netlist blackbox module_name







#----------------------Define Port Domain-------------------------------
#Identify the clock domain for the top level or black box ports

#Example: netlist port domain port_name1 -clock cclk
netlist port domain clkack -async
netlist port domain clkreq -clock PGCB_CLK

#netlist port domain pgcb_rst_b -async
#netlist port domain reset_b -async
#netlist port domain pok_reset_b -async

netlist port domain pgcb_rst_b -clock PGCB_CLK
netlist port domain reset_b -async
netlist port domain pok_reset_b -async
netlist port domain greset_b -clock CDC_CLK

netlist port domain pok -clock CDC_CLK 
netlist port domain gclock_enable_final -clock CDC_CLK 
netlist port domain gclock_req_sync -clock CDC_CLK 
netlist port domain gclock_req_async -async
netlist port domain gclock_ack_async -clock CDC_CLK 
netlist port domain gclock_active -clock CDC_CLK
netlist port domain ism_fabric -clock CDC_CLK
netlist port domain ism_agent -clock CDC_CLK
netlist port domain ism_locked -clock CDC_CLK
netlist port domain boundary_locked -clock CDC_CLK

netlist port domain cfg_clkgate_disabled -async
netlist port domain cfg_clkreq_ctl_disabled -async
netlist port domain cfg_clkgate_holdoff -async
netlist port domain cfg_pwrgate_holdoff -async 
netlist port domain cfg_clkreq_off_holdoff -async
netlist port domain cfg_clkreq_syncoff_holdoff -async

netlist port domain pwrgate_disabled -clock PGCB_CLK
netlist port domain pwrgate_force -clock PGCB_CLK
netlist port domain pwrgate_pmc_wake -clock PGCB_CLK
netlist port domain pwrgate_ready -clock PGCB_CLK
netlist port domain pgcb_force_rst_b -clock PGCB_CLK
netlist port domain pgcb_pok -clock PGCB_CLK
netlist port domain pgcb_restore -clock PGCB_CLK
netlist port domain pgcb_pwrgate_active -clock PGCB_CLK

netlist port domain {cdc_visa[13:0]} -clock CDC_CLK
netlist port domain {cdc_visa[19:14]} -clock PGCB_CLK

netlist port domain fscan_clkungate -async
netlist port domain fismdfx_force_clkreq -async 
netlist port domain fismdfx_clkgate_ovrd -async 
netlist port domain fscan_byprst_b -async 
netlist port domain fscan_rstbypen -async 
netlist port domain fscan_clkgenctrlen -async 
netlist port domain fscan_clkgenctrl -async 


#---------------------Source TCL Scripts-------------------------------
#If your unit has other CDC tcl scripts.
#do "file_name.tcl"
