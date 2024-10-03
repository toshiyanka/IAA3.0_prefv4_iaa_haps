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
gen_async_blk2.sbcasync*gress.port_idle_ff \
"

foreach {async_reset_no_sync} $async_reset_no_syncs {
   cdc report crossing -scheme async_reset_no_sync -from ${async_reset_no_sync} -to i_sbcasyncclkreq_side_clk.clkreq_int -severity evaluation -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme async_reset_no_sync -from ${async_reset_no_sync} -to i_sbcasyncclkreq_side_clk.clkreq_old -severity evaluation -comment ${comment} -module ${ep_top}
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
gen_async_blk2.sbcasync*gress.port_idle_ff \
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

cdc report crossing -scheme combo_logic -from sbi_sbe_clkreq -to gen_sync_blk0.sync_sbisbeclkreq.d -severity evaluation -comment ${comment} -module ${ep_top}

# Multibits

set comment "universal synchronizer circuit is built to transition multiple \
             bits between two clock domains reliably and deterministically. \
             It should be noted that side_usync and agent_usync should be \
             asserted appropriately for proper synchronization to occur. \
             This would have to be handled from the SOC level."

if { $usync_enable == 1 } {
   cdc report crossing -scheme multi_bits -from gen_async_blk2.sbcasync*gress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp2  -to gen_async_blk2.sbcasync*gress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp3  -severity evaluation -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme multi_bits -from gen_async_blk2.sbcasync*gress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp2  -to gen_async_blk2.sbcasync*gress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp3  -severity evaluation -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme multi_bits -from gen_async_blk2.sbcasync*gress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp2 -to gen_async_blk2.sbcasync*gress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp3 -severity evaluation -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme multi_bits -from gen_async_blk2.sbcasync*gress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp2 -to gen_async_blk2.sbcasync*gress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp3 -severity evaluation -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme multi_bits -from gen_async_blk2.sbcasync*gress.i_gen*ptr*.pre_sync_data -to gen_async_blk2.sbcasync*gress.i_gen*ptr*.qtmp3 -severity evaluation -comment ${comment} -module ${ep_top}
}
#Reconvergence waivers added by 
##vnandaku
set reconvergence "\
gen_async_blk2.sbcasync*gress.syncwptr*.q \
gen_async_blk2.sbcasync*gress.syncrptr*.q \
gen_async_blk2.sbcasync*gress.syncnprptr*.q \
gen_async_blk2.sbcasync*gress.i_gen_agent_idle_sync_set.i_sbc_doublesync_set_port_idle_ff.q \
"

if {$asyncendpt == 1 && $usync_enable == 1 } {
    cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcgcgu.visa_ip_idle -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier*_ag -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier*_sb -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier*_sb -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasync*gress.gen_flop_queue0.i_sbcfifo.qin -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasync*gress.gen_flop_queue0.i_sbcfifo.qout -severity waived -module ${ep_top}
	cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcgcgu.visa_ip_idle -severity waived -module ${ep_top}
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
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to clkgate.i_ctech_*.* -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gated_side_clk                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_sync_mip_blk.npmsgipb_ff                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_sync_mip_blk.pcmsgipb_ff                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.clkactive                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.clkgated                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.clkreq_en                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.clkreq_int                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.cnt*                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.fsm                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.i_sbc_clock_gate_clk_gated*                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.mnpput                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.mpcput                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.npcredits*                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.npxfr*                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.outdata*                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.outeom                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.pccredits*                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.pcxfr*                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcgcgu.credit_init                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcgcgu.curr_state*                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcgcgu.idlecnt*                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcgcgu.sbcism0.credit_reinit                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcgcgu.sbcism0.ism_out*                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.crdinit_done_ff                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.fencecntr*                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.cupholdcnt*                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.cupsendcnt*                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.gen_flop_queue3.queueflop*  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.outmsg_cup                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.qcnt*                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.rptr*                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.wptr*                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.npmsgip                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.pccntr*                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.pcmsgip                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_clk_valid                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_mmsg_nptrdy                                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_mmsg_pctrdy                                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbemstr.cfence                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbemstr.cmsgip                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbemstr.np                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbemstr.sbe_sbi_mmsg_npmsgip                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbemstr.sbe_sbi_mmsg_pcmsgip                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbemstr.sbe_sbi_mmsg_pcsel*                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.gen_nexhd_blk0.nppayload_int*                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.gen_nexhd_blk0.pcpayload_int*                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.npdest*                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.npfsm*                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.nphdrdrp                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.npmsgip                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.npsrc*                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.nptag*                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.pchdrdrp                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.pcmsgip                                                      -severity waived -comment ${comment} -module ${ep_top}
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
   if { $usync_enable == 1 } {
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp1*      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp2*      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.egr_cntr    -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.q*          -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp3*      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.usync2tmp1  -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.usync2tmp2  -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.egr_cntr   -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.q*         -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp3*     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.usync2tmp1 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.usync2tmp2 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp1*     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp2*     -severity waived -comment ${comment} -module ${ep_top}
   }
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.agent_clkgate.i_ctech_* -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.agent_fifo_idle_ff                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.gen_flop_queue0.i_sbcfifo.qin*                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.gray_npwptr*                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.gray_wptr*                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.d -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.port_idle_ff                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.syncwptr*.d                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.trdy_gaten                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.gen_flop_queue0.i_sbcfifo.bin_rptr                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.gen_flop_queue1.npfifo*                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.gray_nprptr*                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.gray_rptr*                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.npqempty                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.nprptr                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.npwptr                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.syncnprptr*.d                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.syncrptr*.d                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbc_doublesync_wake.d                                                                 -severity waived -comment ${comment} -module ${ep_top}
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
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbemstr.cfence                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbemstr.cmsgip                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbemstr.np                                                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbemstr.sbe_sbi_mmsg_npmsgip                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbemstr.sbe_sbi_mmsg_pcmsgip                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbemstr.sbe_sbi_mmsg_pcsel*                                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.cmsgip                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.gen_nexhd_blk0.nppayload_int*                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.gen_nexhd_blk0.pcpayload_int*                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.npdest*                                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.npfsm*                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.nphdrdrp                                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.npmsgip                                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.npsrc*                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.nptag*                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.pchdrdrp                                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbetrgt.pcmsgip                                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.master_cfence                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.master_cmsgip                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.master_np                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.master_npmsgip                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.master_pcmsgip                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.target_npfsm*                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.target_nphdrdrop                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.target_npmsgip                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.target_pchdrdrop                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.target_pcmsgip                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier2_ag.pcsel_bin*                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_ag.efifo.enc_gray_rwptr*                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_ag.efifo.xor_gray_rptr_ff2                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_ag.efifo.xor_gray_wptr                                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_ag.ififo.enc_gray_rwptr*                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_ag.ififo.enpirdy                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_ag.ififo.epcirdy                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.efifo.enc_gray_nprwptr*                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.efifo.xor_gray_nprptr_ff2                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.efifo.xor_gray_npwptr                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.ififo.enc_nprwptr*                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.ififo.npqempty                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.ififo.xor_gray_rptr                                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.ififo.xor_gray_wptr_ff2                                              -severity waived -comment ${comment} -module ${ep_top}
}

set reconvergence "\
gen_async_blk2.sbcasyncegress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.q \
gen_async_blk2.sbcasyncegress.syncwptr*.q \
gen_async_blk2.sbcasyncingress.syncnprptr*.q \
gen_async_blk2.sbcasyncingress.syncrptr*.q \
"

if { $asyncendpt == 1 } {
   if { $usync_enable == 1 } {
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.egr_cntr    -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.q*          -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp3*      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.usync2tmp1  -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.usync2tmp2  -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp1*      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp2*      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp1*     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp2*     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.egr_cntr   -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.q*         -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp3*     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.usync2tmp1 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.usync2tmp2 -severity waived -comment ${comment} -module ${ep_top}
   }
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to clken                                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to clkgate.i_ctech_*.* -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gated_side_clk                                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.gen_flop_queue0.i_sbcfifo.bin_rptr                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.gen_flop_queue1.npfifo*                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.gray_nprptr*                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.gray_rptr*                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.npqempty                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.nprptr                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.npwptr                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.syncnprptr*.d                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncegress.syncrptr*.d                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.gen_flop_queue0.i_sbcfifo.qin*                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.gray_npwptr*                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.gray_wptr*                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.d -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.port_idle_ff                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.syncwptr*.d                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_async_blk2.sbcasyncingress.trdy_gaten                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.clkactive                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.clkgated                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.clkreq_en                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.clkreq_int                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.cnt*                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.fsm                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to i_sbcasyncclkreq_side_clk.i_sbc_clock_gate_clk_gated*                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to meom                                                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mnpput                                                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mpayload*                                                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mpcput                                                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to npmsgipb                                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to pcmsgipb                                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.mnpput                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.mpcput                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.npcredits*                                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.npxfr*                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.outdata*                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.outeom                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.pccredits*                                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcegress.pcxfr*                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcgcgu.credit_init                                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcgcgu.curr_state*                                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcgcgu.idlecnt*                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcgcgu.sbcism0.credit_reinit                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcgcgu.sbcism0.ism_out*                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.crdinit_done_ff                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.fencecntr*                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.cupholdcnt*                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.cupsendcnt*                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.gen_flop_queue3.queueflop*                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.outmsg_cup                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.qcnt*                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.rptr*                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.gen_queue*.sbcinqueue.wptr*                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.npmsgip                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.pccntr*                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbcport.sbcingress.pcmsgip                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_clk_valid                                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_sbi_clkreq                                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to side_clkreq                                                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to side_ism_agent*                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tnpcup                                                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tpccup                                                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_sb.efifo.enc_gray_rwptr*                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_sb.efifo.xor_gray_wptr                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_sb.ififo.enc_gray_rwptr*                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_sb.ififo.enpirdy                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_sb.ififo.epcirdy                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_sb.efifo.enc_gray_nprwptr*                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_sb.efifo.xor_gray_npwptr                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_sb.ififo.enc_nprwptr*                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_sb.ififo.npqempty                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_sb.ififo.xor_gray_rptr                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.idle                                                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.npcredits                                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.npmsgip                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.npqcount*                                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.npxfr                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.outmsg_cup                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.pccredits                                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.pcqcount*                                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.pcxfr                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.fencecntr*                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.ism*                                                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.mnpput                                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.mpcput                                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.npcuphold_sendcnt*                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.pccuphold_sendcnt*                                                    -severity waived -comment ${comment} -module ${ep_top}
}

set reconvergence "\
gen_async_blk2.sbcasyncegress.syncwptr*.q \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from $reconvergence -to visa_fifo_tier2_sb.ififo.xor_gray_wptr_ff2 -severity waived -comment ${comment} -module ${ep_top}
}

set reconvergence "\
gen_async_blk2.sbcasyncingress.syncnprptr*.q \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from $reconvergence -to visa_fifo_tier2_sb.efifo.xor_gray_nprptr_ff2 -severity waived -comment ${comment} -module ${ep_top}
}

set reconvergence "\
gen_async_blk2.sbcasyncingress.syncrptr*.q \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from $reconvergence -to visa_fifo_tier1_sb.efifo.xor_gray_rptr_ff2 -severity waived -comment ${comment} -module ${ep_top}
}

    #Added after TMSG_MMSG_RTL merge
set reconvergence "\
gen_async_blk2.sbcasyncegress.syncnprptr*.q \
gen_async_blk2.sbcasyncegress.syncrptr*.q \
"
if { $asyncendpt ==1 } {
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbemstr.gen_fnc_en_blk.dst_match -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbemstr.block_pcsel_f -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbemstr.gen_fnc_en_blk.opc_match -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbemstr.gen_fnc_en_blk.src_match -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbemstr.gen_mstr_be_15_7.sbebytecount_mstr_np.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbemstr.gen_mstr_be_15_7.sbebytecount_mstr_pc.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.gen_trgt_be_15_7.sbebytecount_mmsg.byte_count -severity waived -module ${ep_top}
}

set reconvergence "\
gen_async_blk2.sbcasyncingress.syncwptr*.q \
"
if { $asyncendpt ==1 } {
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_np.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_pc.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.npclaim_f -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.npeom_delayed -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.npput_delayed -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.nppayload_int -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.pcpayload_int -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.wait_for_claim -severity waived -module ${ep_top}
}

set reconvergence "\
gen_async_blk2.sbcasyncegress.syncwptr*.q \
gen_async_blk2.sbcasyncegress.i_gen_agent_idle_sync_set.i_sbc_doublesync_set_port_idle_ff.q \
"
if { $asyncendpt ==1 } {
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbcport.sbcgcgu.sbcism0.cg_en_visa -severity waived -module ${ep_top}
}

set reconvergence "\
gen_sync_blk0.sync_sbisbeclkreq.q \
i_sbcasyncclkreq_side_clk.i_sbc_doublesync_clkack.q \
gen_async_blk2.sbcasyncingress.syncnprptr*.q \
gen_async_blk2.sbcasyncingress.syncrptr*.q \
gen_async_blk2.sbcasyncingress.syncwptr*.q \
gen_async_blk2.sbcasyncegress.syncnprptr*.q \
gen_async_blk2.sbcasyncegress.syncrptr*.q \
"
cdc report crossing -scheme reconvergence -from $reconvergence -to sbcport.sbcgcgu.sbcism0.cg_en_visa -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbemstr.block_pcsel_f -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbemstr.gen_fnc_en_blk.dst_match -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbemstr.gen_fnc_en_blk.opc_match -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbemstr.gen_fnc_en_blk.src_match -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbemstr.gen_mstr_be_15_7.sbebytecount_mstr_np.byte_count -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbemstr.gen_mstr_be_15_7.sbebytecount_mstr_pc.byte_count -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.cmsgip -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.gen_trgt_be_15_7.sbebytecount_mmsg.byte_count -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_np.byte_count -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_pc.byte_count -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.npclaim_f -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.npeom_delayed -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.npput_delayed -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.wait_for_claim -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.nppayload_int -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -from $reconvergence -to sbetrgt.pcpayload_int -severity waived -module ${ep_top}

cdc report crossing -scheme no_sync -from sbe_sbi_parity_err_out -to gen_doserrmstr.sbedoserrmstr.flag -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from gen_doserrmstr.sbedoserrmstr.flag -to gen_doserrmstr.sbedoserrmstr.flag_f -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from gen_doserrmstr.sbedoserrmstr.flag -to gen_doserrmstr.sbedoserrmstr.mmsg_pcirdy -severity waived -module ${ep_top}

cdc report crossing -scheme async_reset_no_sync -from side_rst_b -to gen_doserrmstr.sbedoserrmstr.flag -severity evaluation -module ${ep_top}
cdc report crossing -scheme async_reset_no_sync -from gen_doserrmstr.sbedoserrmstr.mmsg_pcirdy -to i_sbcasyncclkreq_side_clk.clkreq_int -severity evaluation -module ${ep_top}
cdc report crossing -scheme async_reset_no_sync -from gen_doserrmstr.sbedoserrmstr.mmsg_pcirdy -to i_sbcasyncclkreq_side_clk.clkreq_old -severity evaluation -module ${ep_top}
cdc report crossing -scheme combo_logic -from ext_parity_err_detected -to gen_ext_par_async.i_sync_ext_parity_err_detected.d -severity evaluation -module ${ep_top}
cdc report crossing -scheme combo_logic -from fdfx_sbparity_def -to gen_ext_par_async.i_sync_ext_parity_err_detected.d -severity evaluation -module ${ep_top}

cdc report crossing -scheme multi_sync_mux_select -from sbe_sbi_parity_err_out -to gen_async_blk2.sbcasync*gress.port_idle_ff -severity evaluation -module ${ep_top}
cdc report crossing -scheme multi_sync_mux_select -from sbe_sbi_parity_err_out -to sbe_sbi_idle -severity evaluation -module ${ep_top}

cdc report crossing -scheme async_reset -from side_rst_b -to gen_async_blk2.i_sync_fifo_err_out.clr_b -severity evaluation -module ${ep_top}

cdc report crossing -scheme combo_logic -from fdfx_sbparity_def -to gen_async_blk2.i_sync_fifo_err_out.d -severity evaluation -module ${ep_top}
cdc report crossing -scheme combo_logic -from gen_async_blk2.sbcasyncingress.gen_flop_queue0.i_sbcfifo.qout -to gen_async_blk2.i_sync_fifo_err_out.d -severity evaluation -module ${ep_top}
cdc report crossing -scheme combo_logic -from gen_async_blk2.sbcasyncingress.gen_flop_queue1.npfifo* -to gen_async_blk2.i_sync_fifo_err_out.d -severity evaluation -module ${ep_top}
cdc report crossing -scheme combo_logic -from gen_async_blk2.sbcasyncingress.gen_par.*parity_err_gen_out_pre -to gen_async_blk2.i_sync_fifo_err_out.d -severity evaluation -module ${ep_top}
cdc report crossing -scheme combo_logic -from gen_async_blk2.sbcasyncingress.gray_rptr -to gen_async_blk2.i_sync_fifo_err_out.d -severity evaluation -module ${ep_top}
cdc report crossing -scheme combo_logic -from gen_async_blk2.sbcasyncingress.npqempty -to gen_async_blk2.i_sync_fifo_err_out.d -severity evaluation -module ${ep_top}
cdc report crossing -scheme combo_logic -from gen_async_blk2.sbcasyncingress.nprptr -to gen_async_blk2.i_sync_fifo_err_out.d -severity evaluation -module ${ep_top}
cdc report crossing -scheme combo_logic -from gen_async_blk2.sbcasyncingress.syncwptr*.q -to gen_async_blk2.i_sync_fifo_err_out.d -severity evaluation -module ${ep_top}
cdc report crossing -scheme combo_logic -from sbemstr.cfence -to gen_async_blk2.i_sync_fifo_err_out.d -severity evaluation -module ${ep_top}
cdc report crossing -scheme combo_logic -from sbi_sbe_tmsg_npfree -to gen_async_blk2.i_sync_fifo_err_out.d -severity evaluation -module ${ep_top}
cdc report crossing -scheme combo_logic -from gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.q* -to gen_async_blk2.i_sync_fifo_err_out.d -severity evaluation -module ${ep_top}

## Async FIFO split PCR

#CDC 10.4f_3 waivers
cdc report crossing -scheme shift_reg -from sbi_sbe_clkreq -to gen_sync_blk0.i_sync_sbisbeclkreq.i_ctech_lib_*.ctech_lib_*.sync* -severity evaluation -module ${ep_top}
cdc report crossing -scheme shift_reg -from side_clkack -to i_sbcasyncclkreq_side_clk.i_sbc_doublesync_clkack.i_ctech_lib_*.ctech_lib_*.sync* -severity evaluation -module ${ep_top}
cdc report crossing -scheme no_sync -from sbe_sbi_parity_err_out -to gen_async_blk2.sbcasyncegress.sbcasyncingress.port_idle_ff -severity evaluation -module ${ep_top}
cdc report crossing -scheme no_sync -from sbe_sbi_parity_err_out -to sbe_sbi_idle -severity evaluation -module ${ep_top}
cdc report crossing -scheme async_reset -from side_rst_b -to gen_async_blk1.sync_rstb.i_ctech_lib*.ctech_lib_*.sync -severity evaluation -module ${ep_top}
cdc report crossing -scheme fanin_different_clks -from gen_async_blk2.sbcasyncegress.sbcasyncingress.port_idle_ff -to i_sbc_doublesync_wake.i_ctech_lib*.ctech_lib_*.sync* -severity evaluation -module ${ep_top}
cdc report crossing -scheme fanin_different_clks -from sbi_sbe_clkreq -to i_sbc_doublesync_wake.i_ctech_lib_msff*.ctech_lib*.sync* -severity evaluation -module ${ep_top}
cdc report crossing -scheme shift_reg -from gen_async_blk2.sbcasync*ress.sbcasync*ress.gray* -to gen_async_blk2.sbcasync*ress.sbcasync*ress.sync*.i_ctech_lib*.ctech_lib*.sync* -severity evaluation -module ${ep_top}
cdc report crossing -scheme shift_reg -from gen_async_blk2.sbcasync*ress.sbcasync*ress.port_idle_ff -to gen_async_blk2.sbcasync*ress.sbcasync*ress.i_gen_agent_idle_sync_set.i_sbc_doublesync_set_port_idle_ff.i_ctech_lib*.ctech_lib_*.sync* -severity evaluation -module ${ep_top}
cdc report crossing -scheme shift_reg -from sbe_sbi_parity_err_out -to gen_doserrmstr.gen_do_async.i_parity_err_sync.i_ctech_lib*.ctech_lib*.sync* -severity evaluation -module ${ep_top}
## RP based waivers
cdc report crossing -scheme multi_bits -from gen_async_blk2.sbcasync*ress.sbcasync*ress.rp_based_impl* -to *tmsg_*payload -severity evaluation -module ${ep_top}

set  multi_sync_mux_select " \
sbcport.sbcegress.out* \
*msgipb \
gen_async_blk2.sbcasync*gress.sbcasync*gress.gray_*ptr \
gen_async_blk2.sbcasync*gress.sbcasync*gress.npqempty \
gen_async_blk2.sbcasync*gress.sbcasync*gress.rp_based_impl_np.i_vram_npq2.byte_enable*.i_sb_vram_genram_bees_knees.latched_data* \
gen_async_blk2.sbcasync*gress.sbcasync*gress.npwptr \
sbcport.sbcegress.m*put \
sbcport.sbcegress.*credits* \
sbcport.sbcegress.*xfr \
gen_async_blk2.sbcasync*gress.sbcasync*gress.*ptr \
sbetrgt.npclaim_f \
sbetrgt.npfsm \
sbetrgt.npsrc_mstr \
sbetrgt.nptag_mstr \
sbetrgt.*hdrdrp \
sbetrgt.hier_src_tmsg \
sbetrgt.hier_dest_tmsg \
tmsg_* \
sbetrgt.*msgip \
sbemstr.cfence \
sbetrgt.npdest_mstr \
sbetrgt.*payload_int* \
sbe_sbi_tmsg_*payload \
sbe_sbi_tmsg_*eom \
sbe_sbi_tmsg_*put \
sbe_sbi_tmsg_*valid \
"

foreach {multi_sync_mux_select} $multi_sync_mux_select {
   cdc report crossing -scheme multi_sync_mux_select -from gen_async_blk2.sbcasync*ress.sbcasync*ress.rp_based_impl* -to ${multi_sync_mux_select} -severity waived -module ${ep_top}
}

set  no_sync " \
visa_fifo_tier1_*.ififo.e*irdy \
visa_port_tier2_sb.m*put \
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

