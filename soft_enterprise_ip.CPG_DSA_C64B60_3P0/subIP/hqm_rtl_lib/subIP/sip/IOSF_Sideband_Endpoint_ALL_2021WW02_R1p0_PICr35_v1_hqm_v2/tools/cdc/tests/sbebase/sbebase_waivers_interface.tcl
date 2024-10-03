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

set ep_top       "sbebase"
set asyncendpt   0
set usync_enable 0

#Example:
#cdc report crossing -scheme <scheme_name> -from {<tx_signal>} -to {<rx_signal>} -tx_clock <tx_clock_name> -rx_clock <rx_clock_name> -severity waived

# Asynchronous Clock Crossings

set comment "sbi_sbe_clkreq is an asynchronous input from the agent. This signal \
             must be used before an agent attempts to master a message. The \
             incoming clock is not known. The clock request logic will not use \
             a synchronizer because it is being used to wake up the clock \
             request logic with no running clock. The circuit has limitations \
             as glitches can be created if the agent does not handle it \
             appropriatly. sbi_sbe_clkreq must not have one going glitch hazards, \
             preferably ran directly off of a flop."

set async_reset_no_syncs " \
sbi_sbe_clkreq \
"

foreach {async_reset_no_sync} $async_reset_no_syncs {
   cdc report crossing -scheme async_reset_no_sync -from ${async_reset_no_sync} -to i_sbcasyncclkreq_side_clk.clkreq_int -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme async_reset_no_sync -from ${async_reset_no_sync} -to i_sbcasyncclkreq_side_clk.clkreq_old -severity waived -comment ${comment} -module ${ep_top}
}

set comment "side_clkreq is a psudo-synchronous signal. It will assert \
             asynchronously and de-assert synchronous to the side_clk. The \
             output should be handled as if the signal were fully asynchronous."

set no_syncs " \
i_sbcasyncclkreq_side_clk.clkreq_en \
i_sbcasyncclkreq_side_clk.clkreq_int \
i_sbcasyncclkreq_side_clk.clkreq_old \
"

foreach {no_sync} $no_syncs {
   cdc report crossing -scheme no_sync -from ${no_sync} -to side_clkreq -severity waived -comment ${comment} -module ${ep_top}
}

# Fanin logic from multiple clock domains. (fanin_different_clks)

set comment "The clock requests asynchronous wake signal may be woken up from \
             any number of clock domains. Since these signals are used to wake \
             the side_clk, it is impossible to synchronize the original signals \
             to the side_clk domain. The possible clock domains may be \
             from the users sbi_sbe_clkreq and the agent_clk domain \
             care if it is only side_clk and asynchronous inputs."

set externals " \
sbi_sbe_clkreq \
"

if { $asyncendpt == 1 } {
   foreach {external} $externals {
      cdc report crossing -scheme fanin_different_clks -from ${external} -to i_sbc_doublesync_wake.d -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme fanin_different_clks -from ${external} -to i_sbc_doublesync_wake.i_ctech_lib*.o1 -severity waived -comment ${comment} -module ${ep_top}
   }
}

# Combinational Logic on Resets

set comment "sbi_sbe_clkreq is one of many signals that will be combinationally \
             used to know when to asynchronously assert the clock request. The \
             assumption is that the agent will correctly handle the sbi_sbe_clkreq \
             so that no one going glitch hazards should appear on the logic \
             going to the clock request logic inside of the endpoint."

cdc report crossing -scheme combo_logic -from sbi_sbe_clkreq -to gen_sync_blk0.sync_sbisbeclkreq.d -severity waived -comment ${comment} -module ${ep_top}

#Reconvergence waivers added by 
##vnandaku
set reconvergence "\
gen_async_blk2.sbcasync*gress.syncwptr*.q \
gen_async_blk2.sbcasync*gress.syncrptr*.q \
gen_async_blk2.sbcasync*gress.syncnprptr*.q \
gen_async_blk2.sbcasync*gress.i_gen_agent_idle_sync_set.i_sbc_doublesync_set_port_idle_ff.q \
"

if {$asyncendpt == 1 && $usync_enable == 1 } {
    cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier*_ag -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier*_sb -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier*_sb -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_clkreq -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_idle -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_npeom -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_nppayload -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_npput -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_npvalid -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_pcput -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_pcvalid -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_mmsg_nptrdy -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_mmsg_pctrdy -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier*_ag -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier*_sb -severity waived -module ${ep_top}
}
if {$asyncendpt == 1 && $usync_enable == 1 } {
    cdc report crossing -scheme async_reset -from side_rst_b -to gen_async_blk1.sync_rstb.clr_b -severity waived -module ${ep_top}
}
## Added for ACECDC
cdc report crossing -scheme reconvergence -from gen_sync_blk0.sync_sbisbeclkreq.q -to visa_port_tier*_sb -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from i_sbcasyncclkreq_side_clk.i_sbc_doublesync_clkack.q -to visa_port_tier*_sb -severity waived -module ${ep_top}
#end vnandaku

# Reconvergence Paths
set reconvergence " \
gen_sync_blk0.sync_sbisbeclkreq.q \
i_sbcasyncclkreq_side_clk.i_sbc_doublesync_clkack.q \
"

set comment "sbi_sbe_clkreq and side_clkack are indirectly part of the \
             side_clkreq and side_clkack handshake. However, there is no \
             immediate assumption from the endpoint that the two signals \
             originate from the same signal to cause a reconvergence problem. \
             if in the user environment these two signals are from the same \
             origin they will have to fix or waiver the reconvergence check \
             as necessary."

if { $asyncendpt == 0 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to clken                                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gated_side_clk                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_clk_valid                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_mmsg_nptrdy                                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_mmsg_pctrdy                                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to side_clkreq                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to side_ism_agent*                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.ism*                                              -severity waived -comment ${comment} -module ${ep_top}
}

set comment "When the endpoint is in asynchronous mode an asynchronous fifo \
             gets inserted. This fifo uses a gray coded pointer for both the \
             read pointer and the write pointer in their perspective clock \
             domains. They are then synchronized through a doublesync or \
             universal synchronizer into the opposite clock domain. \
             So long as the two pointers are not equal, data will be pushed \
             into the fifo or pulled out of the fifo as appropriate. \
             When the egress and ingress fifos meet they contain two different \
             data paths that have no true convergence issues. The biggest \
             issue is when the read and write pointers (multibits) cross \
             over. The read and write pointers synchronizers max delay paths \
             must be set to be within one transmit clock domain. The gray \
             pointers are coded pesimistically, so the receiving clock domain \
             should either see the old pointer value or the new pointer value \
             upon crossing through the receiving domains synchronizer. Any \
             detection of the reset synchronizers can be ignored."

set reconvergence " \
gen_async_blk1.sync_rstb.q \
gen_async_blk2.sbcasyncegress.syncnprptr*.q \
gen_async_blk2.sbcasyncegress.syncrptr*.q \
gen_async_blk2.sbcasyncingress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.q \
gen_async_blk2.sbcasyncingress.syncwptr*.q \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_idle                                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_mmsg_npmsgip                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_mmsg_nptrdy                                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_mmsg_pcmsgip                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_mmsg_pcsel                                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_mmsg_pctrdy                                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_npeom                                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_npmsgip                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_nppayload*                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_npput                                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_npvalid                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_pccmpl                                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_pcmsgip                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_pcpayload*                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_pcput                                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_tmsg_pcvalid                                                                    -severity waived -comment ${comment} -module ${ep_top}
}

set reconvergence "\
gen_async_blk2.sbcasyncegress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.q \
gen_async_blk2.sbcasyncegress.syncwptr*.q \
gen_async_blk2.sbcasyncingress.syncnprptr*.q \
gen_async_blk2.sbcasyncingress.syncrptr*.q \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to clken                                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to meom                                                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mnpput                                                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mpayload*                                                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mpcput                                                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to npmsgipb                                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to pcmsgipb                                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_clk_valid                                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_clkreq                                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to side_clkreq                                                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to side_ism_agent*                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tnpcup                                                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tpccup                                                                                   -severity waived -comment ${comment} -module ${ep_top}
}


cdc report crossing -scheme no_sync -from sbe_sbi_parity_err_out -to gen_doserrmstr.sbedoserrmstr.flag -severity waived -module ${ep_top}

cdc report crossing -scheme async_reset_no_sync -from side_rst_b -to gen_doserrmstr.sbedoserrmstr.flag -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from ext_parity_err_detected -to gen_ext_par_async.i_sync_ext_parity_err_detected.d -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from fdfx_sbparity_def -to gen_ext_par_async.i_sync_ext_parity_err_detected.d -severity waived -module ${ep_top}

cdc report crossing -scheme multi_sync_mux_select -from sbe_sbi_parity_err_out -to gen_async_blk2.sbcasync*gress.port_idle_ff -severity waived -module ${ep_top}
cdc report crossing -scheme multi_sync_mux_select -from sbe_sbi_parity_err_out -to sbe_sbi_idle -severity waived -module ${ep_top}

cdc report crossing -scheme async_reset -from side_rst_b -to gen_async_blk2.i_sync_fifo_err_out.clr_b -severity waived -module ${ep_top}

cdc report crossing -scheme combo_logic -from fdfx_sbparity_def -to gen_async_blk2.i_sync_fifo_err_out.d -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from sbi_sbe_tmsg_npfree -to gen_async_blk2.i_sync_fifo_err_out.d -severity waived -module ${ep_top}

## Async FIFO split PCR

#CDC 10.4f_3 waivers
cdc report crossing -scheme shift_reg -from sbi_sbe_clkreq -to gen_sync_blk0.i_sync_sbisbeclkreq.i_ctech_lib_*.ctech_lib_*.sync* -severity waived -module ${ep_top}
cdc report crossing -scheme shift_reg -from side_clkack -to i_sbcasyncclkreq_side_clk.i_sbc_doublesync_clkack.i_ctech_lib_*.ctech_lib_*.sync* -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from sbe_sbi_parity_err_out -to gen_async_blk2.sbcasyncegress.sbcasyncingress.port_idle_ff -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from sbe_sbi_parity_err_out -to sbe_sbi_idle -severity waived -module ${ep_top}
cdc report crossing -scheme async_reset -from side_rst_b -to gen_async_blk1.sync_rstb.i_ctech_lib*.ctech_lib_*.sync -severity waived -module ${ep_top}
cdc report crossing -scheme fanin_different_clks -from sbi_sbe_clkreq -to i_sbc_doublesync_wake.i_ctech_lib_msff*.ctech_lib*.sync* -severity waived -module ${ep_top}
cdc report crossing -scheme shift_reg -from sbe_sbi_parity_err_out -to gen_doserrmstr.gen_do_async.i_parity_err_sync.i_ctech_lib*.ctech_lib*.sync* -severity waived -module ${ep_top}
## RP based waivers
cdc report crossing -scheme multi_bits -from gen_async_blk2.sbcasync*ress.sbcasync*ress.rp_based_impl* -to *tmsg_*payload -severity waived -module ${ep_top}

set  multi_sync_mux_select " \
sbe_sbi_tmsg_*payload \
sbe_sbi_tmsg_*eom \
sbe_sbi_tmsg_*put \
sbe_sbi_tmsg_*valid \
"

foreach {multi_sync_mux_select} $multi_sync_mux_select {
   cdc report crossing -scheme multi_sync_mux_select -from gen_async_blk2.sbcasync*ress.sbcasync*ress.rp_based_impl* -to ${multi_sync_mux_select} -severity waived -module ${ep_top}
}

set  no_sync " \
tmsg_pccmpl \
tmsg_pceom \
sbe_sbi_tmsg_pccmpl \
sbe_sbi_tmsg_pceom \
sbe_sbi_tmsg_pccmpl \
sbe_sbi_tmsg_pceom \
"

foreach {no_sync} $no_sync {
   cdc report crossing -scheme no_sync -from gen_async_blk2.sbcasync*ress.sbcasync*ress.rp_based_impl* -to ${no_sync} -severity waived -module ${ep_top}
}

