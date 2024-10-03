#-----------------------------------------------------------------------
# Intel Proprietary -- Copyright 2012 Intel -- All rights reserved
#-----------------------------------------------------------------------
# Description: Unit CDC control script.
#-----------------------------------------------------------------------
set ep_top          sbebase
set ep_fifo         sbcfifo
set ep_asyncfifo    sbcasyncfifo
set ep_msff         sbc_doublesync
set ep_msff_set     sbc_doublesync_set
set ep_rst          side_rst_b
set side_clk        side_clk
set side_clk_group  SIDE_CLK
set agent_clk       agent_clk
set agent_clk_group AGENT_CLK
set asyncendpt      0
set intf_clk        $side_clk

if {$asyncendpt > 0} {
   set intf_clk $agent_clk
}

# The following directive is added per requirement from HSD 1404433297,
# "IOSF Sideband Endpoint BXTPB0 paranoia CDC isolation clocking evaluation"
# Removed for TGL CDC updates -will need to check if this is needed.
#cdc preference -detect_pure_latch_clock

#----------------------Define Clocks------------------------------------
#Example1: netlist clock cpu_clk_in -group CPU_CLK_GR0

#----------------------Define Resets------------------------------------
#Directive "netlist reset" will add signals to the list of
#resets or remove the specified signals from the list of resets.
#Example1: netlist reset rst_* -negedge -module pci 
#Example2: netlist reset -remove rst_a  -module crc_16_calc

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
cdc signal usyncselect -stable

#----------------------Define black box-------------------------------
#User-defined black box:
#If the clock domain for a port is specified (using a netlist port domain
#directive), the port is included in CDC analysis. Otherwise, fanin/fanout
#logic of the port is ignored. No CDC crossing is reported for the port,
#but a warning is issued (netlist-44). Ports asynchronous with the defined clocks should
#be identified as such using the -async argument.

#Example1: netlist blackbox module_name

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

#cdc fifo fifo -module ${ep_fifo}
#netlist port domain qout -clock egr_side_clk -module ${ep_fifo}
cdc fifo fifo* -no_read_sync -no_write_sync -module ${ep_fifo}
netlist port domain sbcasyncingress.qout -clock gated_egr_side_clk -module ${ep_asyncfifo}

cdc fifo latched_data -no_read_sync -no_write_sync -module sb_genram_bees_knees
#cdc fifo latched_data -module sb_genram_bees_knees
netlist port domain rp_based_impl.i_vram2.read_data -clock gated_egr_side_clk -module ${ep_asyncfifo}

#----------------------Define Port Domain-------------------------------
#Identify the clock domain for the top level or black box ports

#Example: netlist port domain port_name1 -clock cclk

#cdc fifo fifo* -no_read_sync -no_write_sync -module sbcfifo
#netlist port domain sbcasyncingress.qout -clock gated_egr_side_clk -module sbcasyncfifo

netlist port domain side_clkreq           -output -async                -module ${ep_top}
netlist port domain sbe_sbi_clkreq           -output -async                -module ${ep_top}

# IOSF Interface Signals

# Target Message Interface

# Master Message Interface

# Shared Extended Header

# Visa Structures

#---------------------Source TCL Scripts-------------------------------
#If your unit has other CDC tcl scripts.
#do "file_name.tcl"
