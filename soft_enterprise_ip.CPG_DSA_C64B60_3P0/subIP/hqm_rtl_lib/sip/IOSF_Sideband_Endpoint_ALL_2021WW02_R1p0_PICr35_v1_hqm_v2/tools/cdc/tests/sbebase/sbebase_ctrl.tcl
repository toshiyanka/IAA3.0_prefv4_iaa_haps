#-----------------------------------------------------------------------
# Intel Proprietary -- Copyright 2012 Intel -- All rights reserved
#-----------------------------------------------------------------------
# Description: Unit CDC control script.
#-----------------------------------------------------------------------
set ep_top          sbebase
set ep_fifo         sbcfifo
set ep_msff         sbc_doublesync
set ep_msff_set     sbc_doublesync_set
set ep_rst          side_rst_b
set side_clk        side_clk
set side_clk_group  side_clk
set agent_clk       agent_clk
set agent_clk_group agent_clk
set asyncendpt      0
set intf_clk        $side_clk

if {$asyncendpt > 0} {
   set intf_clk $agent_clk
}

# The following directive is added per requirement from HSD 1404433297,
# "IOSF Sideband Endpoint BXTPB0 paranoia CDC isolation clocking evaluation"
cdc preference -detect_pure_latch_clock
# If metastability modelling is enabled, reconvergence can be switched off from DA (Amit)
cdc reconvergence off

#----------------------Define Clocks------------------------------------
#Example1: netlist clock cpu_clk_in -group CPU_CLK_GR0

netlist clock ${side_clk}  -group ${side_clk_group}  -module ${ep_top}
netlist clock ${agent_clk} -group ${agent_clk_group} -module ${ep_top}

#----------------------Define Resets------------------------------------
#Directive "netlist reset" will add signals to the list of
#resets or remove the specified signals from the list of resets.
#Example1: netlist reset rst_* -negedge -module pci 
#Example2: netlist reset -remove rst_a  -module crc_16_calc

netlist reset ${ep_rst}                            -negedge -module ${ep_top}
netlist reset agent_side_rst_b_sync                -negedge -module ${ep_top}
netlist reset sbebase.clkreq_async                 -posedge -module ${ep_top}
netlist reset sbebase.clkreq_set                   -posedge -module ${ep_top}
netlist reset -remove sbcport.sbcgcgu.sbcism0.credit_reinit -module ${ep_top}

#----------------------Define constants-------------------------------
#Example1: netlist constant scan_mode         1'b0
#Example2: netlist constant U0.scan_mode[1:4] 1'b1

netlist constant fscan_latchopen     1'b0 -module ${ep_top}
netlist constant fscan_latchclosed_b 1'b0 -module ${ep_top}
netlist constant fscan_mode          1'b0 -module ${ep_top}
netlist constant fscan_shiften       1'b0 -module ${ep_top}
netlist constant fscan_clkungate     1'b0 -module ${ep_top}
netlist constant fscan_clkungate_syn 1'b0 -module ${ep_top}
netlist constant fscan_rstbypen      1'b0 -module ${ep_top}
netlist constant fscan_byprst_b      1'b1 -module ${ep_top}

# Static Configuration Inputs
netlist constant cgctrl_clkgatedef   1'b0  -module ${ep_top}
netlist constant cgctrl_clkgaten     1'b1  -module ${ep_top}
netlist constant cgctrl_idlecnt      8'd16 -module ${ep_top}

netlist constant jta_clkgate_ovrd    1'b0 -module ${ep_top}
netlist constant jta_force_clkreq    1'b0 -module ${ep_top}
netlist constant jta_force_idle      1'b0 -module ${ep_top}
netlist constant jta_force_notidle   1'b0 -module ${ep_top}
netlist constant jta_force_creditreq 1'b0 -module ${ep_top}

netlist constant visa_all_disable      0 -module ${ep_top}
netlist constant visa_customer_disable 0 -module ${ep_top}
netlist constant visa_ser_cfg_in       0 -module ${ep_top}

netlist constant fdfx_rst_b          1'b1 -module ${ep_top}

#----------------------Define stable signals---------------------------
#CDC analysis considers a stable signal as properly synchronized.
#The -stable option has no effect if signal is not an Rx or Tx of a CDC
#crossing, or if signal cannot be propagated to an Rx of a CDC crossing,
#or if signal drives an input of combinational logic whose output is not
#stable

#Example2: cdc signal tx_status -stable 
cdc signal usyncselect -stable

#----------------------Define black box-------------------------------
#User-defined black box:
#If the clock domain for a port is specified (using a netlist port domain
#directive), the port is included in CDC analysis. Otherwise, fanin/fanout
#logic of the port is ignored. No CDC crossing is reported for the port,
#but a warning is issued (netlist-44). Ports asynchronous with the defined clocks should
#be identified as such using the -async argument.

#Example1: netlist blackbox module_name

cdc preference -fifo_scheme
cdc preference fifo -no_write_sync -no_read_sync
cdc fifo fifo -module ${ep_fifo}

# SBC FIFO Used for asynchronous clock crossing
#if {$asyncendpt > 0} {
#   cdc synchronizer custom                                                ${ep_fifo}
#   netlist port domain bin_rptr*      -input  -clock egr_side_clk -module ${ep_fifo}
#   netlist port domain bin_wptr*      -input  -ignore             -module ${ep_fifo}
#   netlist port domain ing_side_rst_b -input  -ignore             -module ${ep_fifo}
#   netlist port domain qin            -input  -clock ing_side_clk -module ${ep_fifo}
#   netlist port domain qout           -output -clock egr_side_clk -module ${ep_fifo}
#   netlist port domain qpush          -input  -ignore             -module ${ep_fifo}
#}
#
# SBC Double Synchronizers for asynchronous clock crossing
#cdc synchronizer custom                                     ${ep_msff}
#netlist port domain d     -input  -clock clk -async -module ${ep_msff}
#netlist port domain q     -output -clock clk        -module ${ep_msff}
#netlist port domain clr_b -input  -clock clk -async -module ${ep_msff}
#
#cdc synchronizer custom                                     ${ep_msff_set}
#netlist port domain d     -input  -clock clk -async -module ${ep_msff_set}
#netlist port domain q     -output -clock clk        -module ${ep_msff_set}
#netlist port domain set_b -input  -clock clk -async -module ${ep_msff_set}

#----------------------Define Port Domain-------------------------------
#Identify the clock domain for the top level or black box ports

#Example: netlist port domain port_name1 -clock cclk

#cdc fifo fifo* -no_read_sync -no_write_sync -module sbcfifo
#netlist port domain sbcasyncingress.qout -clock gated_egr_side_clk -module sbcasyncfifo

netlist port domain sbe_sbi_clkreq -output -clock ${side_clk} -module ${ep_top}

netlist port domain cgctrl_clkgatedef     -input -clock ${side_clk} -module ${ep_top}
netlist port domain cgctrl_clkgaten       -input -clock ${side_clk} -module ${ep_top}
netlist port domain cgctrl_idlecnt        -input -clock ${side_clk} -module ${ep_top}
netlist port domain jta_clkgate_ovrd      -input -clock ${side_clk} -module ${ep_top}
netlist port domain jta_force_clkreq      -input -async             -module ${ep_top}
netlist port domain jta_force_idle        -input -clock ${side_clk} -module ${ep_top}
netlist port domain jta_force_notidle     -input -clock ${side_clk} -module ${ep_top}
netlist port domain jta_force_creditreq   -input -clock ${side_clk} -module ${ep_top}

netlist port domain ${ep_rst}             -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain agent_side_rst_b_sync -input  -clock ${agent_clk}   -module ${ep_top}
netlist port domain gated_side_clk        -output -clock ${side_clk}    -module ${ep_top}
netlist port domain side_usync            -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain agent_usync           -input  -clock ${agent_clk}   -module ${ep_top}
netlist port domain sbi_sbe_clkreq        -input  -async                -module ${ep_top}
netlist port domain sbi_sbe_idle          -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain side_ism_fabric       -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain side_ism_agent        -output -clock ${side_clk}    -module ${ep_top}
netlist port domain side_clkreq           -output -async                -module ${ep_top}
netlist port domain side_clkack           -input  -async                -module ${ep_top}
netlist port domain side_ism_lock_b       -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain sbe_sbi_idle          -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_clk_valid     -output -clock ${side_clk}    -module ${ep_top}
netlist port domain sbe_sbi_comp_exp      -output -clock ${side_clk}    -module ${ep_top}

# IOSF Interface Signals
netlist port domain mpccup                -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain mnpcup                -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain mpcput                -output -clock ${side_clk}    -module ${ep_top}
netlist port domain mnpput                -output -clock ${side_clk}    -module ${ep_top}
netlist port domain meom                  -output -clock ${side_clk}    -module ${ep_top}
netlist port domain mpayload              -output -clock ${side_clk}    -module ${ep_top}
netlist port domain tpccup                -output -clock ${side_clk}    -module ${ep_top}
netlist port domain tnpcup                -output -clock ${side_clk}    -module ${ep_top}
netlist port domain tpcput                -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain tnpput                -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain teom                  -input  -clock ${side_clk}    -module ${ep_top}
netlist port domain tpayload              -input  -clock ${side_clk}    -module ${ep_top}

# Target Message Interface
netlist port domain sbi_sbe_tmsg_pcfree    -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbi_sbe_tmsg_npfree    -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbi_sbe_tmsg_npclaim   -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_tmsg_pcput     -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_tmsg_npput     -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_tmsg_pcmsgip   -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_tmsg_npmsgip   -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_tmsg_pceom     -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_tmsg_npeom     -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_tmsg_pcpayload -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_tmsg_nppayload -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_tmsg_pccmpl    -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_tmsg_npvalid   -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_tmsg_pcvalid   -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain ur_rx_sairs_valid      -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain ur_rx_sai              -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain ur_rx_rs               -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain ur_csairs_valid        -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain ur_csai                -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain ur_crs                 -input  -clock ${intf_clk}    -module ${ep_top}

# Master Message Interface
netlist port domain sbi_sbe_mmsg_pcirdy    -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbi_sbe_mmsg_npirdy    -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbi_sbe_mmsg_pceom     -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbi_sbe_mmsg_npeom     -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbi_sbe_mmsg_pcpayload -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbi_sbe_mmsg_nppayload -input  -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_mmsg_pctrdy    -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_mmsg_nptrdy    -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_mmsg_pcmsgip   -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_mmsg_npmsgip   -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_mmsg_pcsel     -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain sbe_sbi_mmsg_npsel     -output -clock ${intf_clk}    -module ${ep_top}

# Shared Extended Header
netlist port domain tx_ext_headers        -input  -clock ${intf_clk}    -module ${ep_top}

# Visa Structures
netlist port domain visa_port_tier1_sb    -output -clock ${side_clk}    -module ${ep_top}
netlist port domain visa_fifo_tier1_sb    -output -clock ${side_clk}    -module ${ep_top}
netlist port domain visa_fifo_tier1_ag    -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain visa_agent_tier1_ag   -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain visa_port_tier2_sb    -output -clock ${side_clk}    -module ${ep_top}
netlist port domain visa_fifo_tier2_sb    -output -clock ${side_clk}    -module ${ep_top}
netlist port domain visa_fifo_tier2_ag    -output -clock ${intf_clk}    -module ${ep_top}
netlist port domain visa_agent_tier2_ag   -output -clock ${intf_clk}    -module ${ep_top}

#---------------------Source TCL Scripts-------------------------------
#If your unit has other CDC tcl scripts.
#do "file_name.tcl"
