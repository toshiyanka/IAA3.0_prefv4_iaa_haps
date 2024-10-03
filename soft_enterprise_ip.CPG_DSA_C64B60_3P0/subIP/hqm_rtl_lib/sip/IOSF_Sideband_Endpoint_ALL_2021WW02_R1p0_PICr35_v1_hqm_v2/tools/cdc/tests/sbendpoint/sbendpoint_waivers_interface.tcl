#-----------------------------------------------------------------------
# Intel Proprietary -- Copyright 2012 Intel -- All rights reserved
#-----------------------------------------------------------------------
# Description: Unit CDC waivers file.
#
# It is assumed that sideband agents will use this file directly. Any
# user configurations outside of the default may not be immediately
# supported due to complications with configurability and lack of ACE
# support. File HSD's as appropriately and some paths may be added
# in to support new configurations in the future.
#
# Uniquification: If uniquification of the endpoint top level is done
# the variable ep_top should be updated to match the new name. Avoid
# uniquification of the instance names or these will need to be manually
# updated.
#-----------------------------------------------------------------------

set ep_top             "sbendpoint"
set asyncendpt         0
set targetreg          1
set masterreg          1
set unique_ext_headers 0
set usync_enable       0

#Example:
#cdc report crossing -scheme <scheme_name> -from {<tx_signal>} -to {<rx_signal>} -tx_clock <tx_clock_name> -rx_clock <rx_clock_name> -severity waived

# Asynchronous Clock Crossings

set comment "agent_clkreq is an asynchronous input from the agent. This signal \
             must be used before an agent attempts to master a message. The \
             incoming clock is not known. The clock request logic will not use \
             a synchronizer because it is being used to wake up the clock \
             request logic with no running clock. The circuit has limitations \
             as one-going glitches can be created if the agent does not handle \
             it appropriatly. agent_clkreq must not have any one going glitch \
             hazards, preferably ran directly off of a flop. This is because \
             it could be used when the clock gate has already been removed. A \
             one going glitch could lead to a metastability hazard on the \
             side_clkreq output."

set async_reset_no_syncs " \
agent_clkreq \
"

foreach {async_reset_no_sync} $async_reset_no_syncs {
   cdc report crossing -scheme async_reset_no_sync -from ${async_reset_no_sync}  -to sbebase.i_sbcasyncclkreq_side_clk.clkreq_int -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme async_reset_no_sync -from ${async_reset_no_sync}  -to sbebase.i_sbcasyncclkreq_side_clk.clkreq_old -severity waived -comment ${comment} -module ${ep_top}
}

## ILLEGAL WAIVER: FIXED!
if { $asyncendpt == 1} {
   cdc report crossing -scheme async_reset -from side_rst_b -to {gen_async_rst_blk.agent_rst_sync.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1[0].*} -severity waived -module ${ep_top}
}

set comment "sbe_clkreq when in asynchronous mode and the target register \
             module is inserted becomes asynchronous as there are two clock \
             domains (side_clk and agent_clk). In any other circumstance the \
             inputs all come from the side_clk domain. So the checks that \
             a clocked input to an asynchronous output must be waived to \
             correctly get QCDC to work."

set no_syncs " \
*tnpput* \
*tpcput* \
*tpayload* \
*tparity* \
*teom* \
*tnpput_ff \
*tpcput_ff \
*tpayload_ff \
*tparity_ff \
*teom_ff \
"

foreach {no_sync} $no_syncs {
    cdc report crossing -scheme no_sync -from ${no_sync} -to sbe_clkreq -severity waived -comment ${comment} -module ${ep_top}
}


set no_syncs " \
sbebase.i_sbcasyncclkreq_side_clk.clkactive \
sbebase.i_sbcasyncclkreq_side_clk.clkreq_en \
sbebase.i_sbcasyncclkreq_side_clk.cnt \
sbebase.i_sbcasyncclkreq_side_clk.fsm \
sbebase.sbcport.sbcgcgu.sbcism0.ism_out\[1\] \
sbebase.sbcport.sbcgcgu.visa_ip_idle \
"

if { $asyncendpt == 1 && $targetreg == 1 } {
   foreach {no_sync} $no_syncs {
      cdc report crossing -scheme no_sync -from agent_idle -to ${no_sync} -severity waived -comment ${comment} -module ${ep_top}
   }
}

# Fan-In From Multiple Domains

set comment "The clock requests asynchronous wake signal may be woken up from \
             any number of clock domains. Since these signals are used to wake \
             the side_clk, it is impossible to synchronize the original signals \
             to the side_clk domain. The possible clock domains may be \
             agent_clk and asynchronous input agent_clkreq. This check will not \
             care if it is only side_clk and asynchronous inputs."

set externals " \
agent_clkreq \
"

if { $asyncendpt == 1 } {
   foreach {external} $externals {
       cdc report crossing -scheme fanin_different_clks -from ${external} -to {sbebase.i_sbc_doublesync_wake.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1[0].*} -severity waived -comment ${comment} -module ${ep_top}
   }
}

# Combinational Logic on Resets

set comment "agent_clkreq is one of many signals that will be combinationally \
             used to know when to asynchronously assert the clock request. The \
             assumption is that the agent will correctly handle the agent_clkreq \
             so that no one going glitch hazards should appear on the logic \
             going to the clock request logic inside of the endpoint."

set combo_logic " \
agent_clkreq \
"

cdc report crossing -scheme combo_logic -from ${combo_logic} -to {sbebase.gen_sync_blk0.i_sync_sbisbeclkreq.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1[0].*} -severity waived -comment ${comment} -module ${ep_top}
cdc report crossing -scheme combo_logic -from ${combo_logic} -to sbebase.gen_sync_blk0.i_sync_sbisbeclkreq.i_ctech_* -severity waived -comment ${comment} -module ${ep_top}
cdc report crossing -scheme combo_logic -from ${combo_logic} -to sbebase.i_sbc_doublesync_wake.d           -severity waived -comment ${comment} -module ${ep_top}



## Parity waivers
## These were newly added paths for parity changes, which do not need syncs
## They are either consumed internally in the same clk domain (do not need syncs)
## or send as output (which case they need to be syncd by IP)

cdc report crossing -scheme combo_logic -from tmsg_npfree -to {sbebase.gen_async_blk2.i_sync_fifo_err_out.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1[0].*} -severity waived -module ${ep_top}

# Bulk Perf waivers
set no_syncs " \
agent_clkreq \
"

foreach {no_sync} $no_syncs {
   cdc report crossing -scheme no_sync -from ${no_sync} -to side_clkreq -severity waived -comment ${comment} -module ${ep_top}
}
