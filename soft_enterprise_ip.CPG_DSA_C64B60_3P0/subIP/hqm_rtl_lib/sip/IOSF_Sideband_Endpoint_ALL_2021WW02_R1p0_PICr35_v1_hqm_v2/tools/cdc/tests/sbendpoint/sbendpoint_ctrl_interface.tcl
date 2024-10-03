#-----------------------------------------------------------------------
# Intel Proprietary -- Copyright 2012 Intel -- All rights reserved
#-----------------------------------------------------------------------
# Description: Unit CDC control script.
#-----------------------------------------------------------------------
set ep_top          sbendpoint
set ep_fifo         sbcfifo
set ep_msff         sbc_doublesync
set ep_msff_set     sbc_doublesync_set
set ep_rst          side_rst_b
set side_clk        side_clk
set side_clk_group  SIDE_CLK
set agent_clk       agent_clk
set agent_clk_group AGENT_CLK
set agent_usync     agent_usync_clk
set side_usync      side_usync_clk
set asyncendpt      0
set targetreg       1
set masterreg       1
set intf_clk        $side_clk
#set intf_clk        $agent_clk

if {$asyncendpt > 0} {
   set intf_clk $agent_clk
}

# If metastability modelling is enabled, reconvergence can be switched off from DA (Amit)
cdc reconvergence off

#----------------------Define Clocks------------------------------------
#Example1: netlist clock cpu_clk_in -group CPU_CLK_GR0

netlist clock ${side_clk}  -group ${side_clk_group}  -module ${ep_top}
netlist clock ${agent_clk} -group ${agent_clk_group} -module ${ep_top}
netlist clock ${side_usync} -group ${side_clk_group} -module ${ep_top}
netlist clock ${agent_usync} -group ${agent_clk_group} -module ${ep_top}
netlist clock {visa_ser_cfg_in[0]} -group VISACFGCLK_GROUP -module ${ep_top}

#----------------------Define Resets------------------------------------
#Directive "netlist reset" will add signals to the list of
#resets or remove the specified signals from the list of resets.
#Example1: netlist reset rst_* -negedge -module pci 
#Example2: netlist reset -remove rst_a  -module crc_16_calc

#----------------------Define constants-------------------------------
#Example1: netlist constant scan_mode         1'b0
#Example2: netlist constant U0.scan_mode[1:4] 1'b1

netlist constant fscan_latchopen     1'b0 -module ${ep_top}
netlist constant fscan_latchclosed_b 1'b1 -module ${ep_top}
netlist constant fscan_mode          1'b0 -module ${ep_top}
netlist constant fscan_shiften       1'b0 -module ${ep_top}
netlist constant fscan_clkungate     1'b0 -module ${ep_top}
netlist constant fscan_clkungate_syn 1'b0 -module ${ep_top}
netlist constant fscan_rstbypen      1'b0 -module ${ep_top}
netlist constant fscan_byprst_b      1'b1 -module ${ep_top}

# Static Configuration Inputs
#netlist constant cgctrl_clkgatedef   1'b0  -module ${ep_top}
#netlist constant cgctrl_clkgaten     1'b1  -module ${ep_top}

netlist constant jta_clkgate_ovrd    1'b0 -module ${ep_top}
netlist constant jta_force_clkreq    1'b0 -module ${ep_top}
netlist constant jta_force_idle      1'b0 -module ${ep_top}
netlist constant jta_force_notidle   1'b0 -module ${ep_top}
netlist constant jta_force_creditreq 1'b0 -module ${ep_top}

netlist constant visa_all_disable      0 -module ${ep_top}
netlist constant visa_customer_disable 0 -module ${ep_top}

#----------------------Define stable signals---------------------------
#CDC analysis considers a stable signal as properly synchronized.
#The -stable option has no effect if signal is not an Rx or Tx of a CDC
#crossing, or if signal cannot be propagated to an Rx of a CDC crossing,
#or if signal drives an input of combinational logic whose output is not
#stable

#Example2: cdc signal tx_status -stable 
cdc signal cgctrl_idlecnt -stable
cdc signal cgctrl_clkgatedef -stable
cdc signal cgctrl_clkgaten -stable

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

netlist port domain fdfx_rst_b            -input -async            -module ${ep_top}

netlist port domain cgctrl_clkgatedef     -input -clock ${side_clk} -module ${ep_top}
netlist port domain cgctrl_clkgaten       -input -clock ${side_clk} -module ${ep_top}
netlist port domain cgctrl_idlecnt        -input -clock ${side_clk} -module ${ep_top}
netlist port domain jta_clkgate_ovrd      -input -clock ${side_clk} -module ${ep_top}
netlist port domain jta_force_clkreq      -input -async             -module ${ep_top}
netlist port domain jta_force_idle        -input -clock ${side_clk} -module ${ep_top}
netlist port domain jta_force_notidle     -input -clock ${side_clk} -module ${ep_top}
netlist port domain jta_force_creditreq   -input -clock ${side_clk} -module ${ep_top}

netlist port domain ${ep_rst}             -input  -clock ${side_clk}    -module ${ep_top}
#HSD: 1409297209
#netlist port domain side_usync            -input  -clock ${side_clk}    -module ${ep_top}
#netlist port domain agent_usync           -input  -clock ${agent_clk}   -module ${ep_top}
netlist port domain agent_clkreq          -input  -async                -module ${ep_top}
netlist port domain agent_idle            -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain side_ism_fabric       -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain side_clkack           -input  -async                -module ${ep_top}
netlist port domain side_ism_lock_b       -input  -clock ${side_clk}    -module ${ep_top}

# IOSF Interface Signals
netlist port domain mpccup                -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain mnpcup                -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain tpcput                -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain tnpput                -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain teom                  -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain tpayload              -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain tparity               -input  -clock ${side_clk}    -module ${ep_top}

# Target Message Interface
netlist port domain tmsg_pcfree           -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain tmsg_npfree           -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain tmsg_npclaim          -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain ur_csairs_valid       -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain ur_csai               -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain ur_crs                -input  -clock ${intf_clk}    -module ${ep_top}

# Master Message Interface
netlist port domain mmsg_pcirdy           -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mmsg_npirdy           -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mmsg_pceom            -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mmsg_npeom            -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mmsg_pcpayload        -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mmsg_nppayload        -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mmsg_pcparity         -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mmsg_npparity         -input  -clock ${intf_clk}    -module ${ep_top}

# Target Register Interface
netlist port domain treg_trdy             -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain treg_cerr             -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain treg_rdata            -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain treg_csairs_valid     -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain treg_csai             -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain treg_crs              -input  -clock ${intf_clk}    -module ${ep_top}

# Master Register Interface
netlist port domain mreg_irdy             -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_npwrite          -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_dest             -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_source           -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_opcode           -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_addrlen          -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_bar              -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_tag              -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_be               -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_fid              -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_addr             -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_wdata            -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_sairs_valid      -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_sai              -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_rs               -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_hier_destid      -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain mreg_hier_srcid       -input  -clock ${intf_clk}    -module ${ep_top}

# Shared Extended Header
netlist port domain tx_ext_headers        -input  -clock ${intf_clk}    -module ${ep_top}

# Parity Interface
netlist port domain do_serr_hier_dstid_strap    -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain do_serr_hier_srcid_strap    -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain do_serr_srcid_strap         -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain do_serr_dstid_strap         -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain do_serr_tag_strap           -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain global_ep_strap             -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain do_serr_sairs_valid         -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain do_serr_sai                 -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain do_serr_rs                  -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain ext_parity_err_detected     -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain fdfx_sbparity_def           -input  -clock ${intf_clk}    -module ${ep_top}

### TEMPORARY CMDS UNTIL HSD:1405328939 IS FIXED
netlist clock avisa_clk_out -group VISA_SSCLK_GROUP
netlist port domain {visa_ser_cfg_in[2:1]} -clock VISACFGCLK_GROUP
netlist port domain avisa_data_out -clock VISA_SSCLK_GROUP

#---------------------Source TCL Scripts-------------------------------
#If your unit has other CDC tcl scripts.
#do "file_name.tcl"
