#-----------------------------------------------------------------------
# Intel Proprietary -- Copyright 2012 Intel -- All rights reserved
#-----------------------------------------------------------------------
# Description: Unit CDC control script.
#-----------------------------------------------------------------------

cdc preference  -detect_pure_latch_clock
cdc preference -filtered_report

#cdc report scheme bus_four_latch -severity violation
#cdc report scheme bus_two_dff_phase -severity violation
#cdc report scheme four_latch -severity violation
#cdc report scheme pulse_sync -severity violation
#cdc report scheme shift_reg -severity violation
#cdc report scheme two_dff_phase -severity violation
#cdc report scheme async_reset -severity violation


#----------------------Define Clocks------------------------------------
#Example1: netlist clock cpu_clk_in -group CPU_CLK_GR0

netlist clock clk -group PGCB_CLK
netlist clock pgcb_tck -group PGCB_TCK




#----------------------Define Resets------------------------------------
#Directive "netlist reset" will add signals to the list of
#resets or remove the specified signals from the list of resets.

#Example1: netlist reset rst_* -negedge -module pci 
#Example2: netlist reset -remove rst_a  -module crc_16_calc

#netlist reset pgcb_rst_b -negedge
#netlist reset fdfx_powergood_rst_b -negedge 



#----------------------Define constants-------------------------------
#Example1: netlist constant scan_mode         1'b0
#Example2: netlist constant U0.scan_mode[1:4] 1'b1




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

#netlist port domain pgcb_rst_b -async 
#netlist port domain fdfx_powergood_rst_b -async 

netlist port domain pgcb_pmc_pg_req_b -clock PGCB_CLK 
netlist port domain pmc_pgcb_pg_ack_b -async
netlist port domain pmc_pgcb_restore_b -async

netlist port domain ip_pgcb_pg_rdy_req_b -clock PGCB_CLK
netlist port domain pgcb_ip_pg_rdy_ack_b -clock PGCB_CLK
netlist port domain ip_pgcb_pg_type -clock PGCB_CLK 

netlist port domain pgcb_pok -clock PGCB_CLK
netlist port domain pgcb_restore -clock PGCB_CLK
netlist port domain pgcb_restore_force_reg_rw -clock PGCB_CLK

netlist port domain pgcb_sleep -clock PGCB_CLK
netlist port domain pgcb_sleep2 -clock PGCB_CLK
netlist port domain pgcb_isol_latchen -clock PGCB_CLK
netlist port domain pgcb_isol_en_b -clock PGCB_CLK

netlist port domain pgcb_force_rst_b -clock PGCB_CLK
netlist port domain ip_pgcb_all_pg_rst_up -clock PGCB_CLK

netlist port domain pgcb_idle -clock PGCB_CLK
netlist port domain pgcb_pwrgate_active -clock PGCB_CLK
netlist port domain ip_pgcb_frc_PGCB_CLK_srst_cc_en -clock clk
netlist port domain ip_pgcb_frc_PGCB_CLK_cp_en -clock clk
netlist port domain pgcb_ip_force_PGCB_CLKs_on -clock clk
netlist port domain ip_pgcb_force_PGCB_CLKs_on_ack -clock clk

netlist port domain cfg_tsleepinactiv -clock PGCB_CLK
netlist port domain cfg_tdeisolate -clock PGCB_CLK
netlist port domain cfg_tpokup -clock PGCB_CLK
netlist port domain cfg_tinaccrstup -clock PGCB_CLK
netlist port domain cfg_taccrstup -clock PGCB_CLK
netlist port domain cfg_tlatchen -clock PGCB_CLK

netlist port domain cfg_tpokdown -clock PGCB_CLK
netlist port domain cfg_tlatchdis -clock PGCB_CLK
netlist port domain cfg_tsleepact -clock PGCB_CLK
netlist port domain cfg_tisolate -clock PGCB_CLK
netlist port domain cfg_trstdown -clock PGCB_CLK
netlist port domain cfg_tPGCB_CLKsonack_srst -clock clk
netlist port domain cfg_tPGCB_CLKsoffack_srst -clock clk
netlist port domain cfg_tPGCB_CLKsonack_cp -clock clk
netlist port domain cfg_trstup2frcPGCB_CLKs -clock clk

netlist port domain cfg_trsvd0 -clock PGCB_CLK
netlist port domain cfg_trsvd1 -clock PGCB_CLK
netlist port domain cfg_trsvd2 -clock PGCB_CLK
netlist port domain cfg_trsvd3 -clock PGCB_CLK
netlist port domain cfg_trsvd4 -clock PGCB_CLK

netlist port domain pmc_pgcb_fet_en_b -async
netlist port domain pgcb_ip_fet_en_b -async

netlist port domain fdfx_pgcb_bypass -clock PGCB_TCK
netlist port domain fdfx_pgcb_ovr -clock PGCB_TCK
netlist port domain fscan_ret_ctrl -clock PGCB_TCK
netlist port domain fscan_mode -clock PGCB_TCK



#---------------------Source TCL Scripts-------------------------------
#If your unit has other CDC tcl scripts.
#do "file_name.tcl"
