#-----------------------------------------------------------------------
# Intel Proprietary -- Copyright 2012 Intel -- All rights reserved
#-----------------------------------------------------------------------
# Description: Unit CDC control script.
#-----------------------------------------------------------------------

#----------------------Define Clocks------------------------------------
#Example1: netlist clock cpu_clk_in -group CPU_CLK_GR0

netlist clock pgcb_clk -group PGCB_CLK
netlist clock iosf_cdc_clock -group IOSF_CLK


#----------------------Define Resets------------------------------------
#Directive "netlist reset" will add signals to the list of
#resets or remove the specified signals from the list of resets.

#Example1: netlist reset rst_* -negedge -module pci 
#Example2: netlist reset -remove rst_a  -module crc_16_calc



#----------------------Define constants-------------------------------
#Example1: netlist constant scan_mode         1'b0
#Example2: netlist constant U0.scan_mode[1:4] 1'b1

netlist constant fscan_clkungate 0
netlist constant fscan_rstbypen 0
netlist constant fscan_byprst_b 0



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

netlist port domain pgcb_clkack -async 
netlist port domain pgcb_clkreq -async 

netlist port domain iosf_cdc_ism_fabric -clock IOSF_CLK
netlist port domain iosf_cdc_clkreq -async
netlist port domain iosf_cdc_clkack -async 
netlist port domain iosf_cdc_gclock_req_async -async
netlist port domain iosf_cdc_gclock_ack_async -async 

netlist port domain non_iosf_cdc_clkreq -async
netlist port domain non_iosf_cdc_clkack -async 
netlist port domain non_iosf_cdc_gclock_req_async -async
netlist port domain non_iosf_cdc_gclock_ack_async -async 

netlist port domain async_pwrgate_disabled -async 
netlist port domain pmc_pg_wake -async
netlist port domain pgcb_pok -clock PGCB_CLK
netlist port domain pgcb_idle -clock PGCB_CLK

netlist port domain cfg_acc_clkgate_disabled -clock PGCB_CLK
netlist port domain cfg_t_clkgate -clock PGCB_CLK
netlist port domain cfg_t_clkwake -clock PGCB_CLK

netlist port domain fscan_byprst_b -async
netlist port domain fscan_rstbypen -async 
netlist port domain fscan_clkungate -async
#netlist port domain visa_bus -clock 

#netlist port domain pgcb_gclk -clock 



#---------------------Source TCL Scripts-------------------------------
#If your unit has other CDC tcl scripts.
#do "file_name.tcl"
