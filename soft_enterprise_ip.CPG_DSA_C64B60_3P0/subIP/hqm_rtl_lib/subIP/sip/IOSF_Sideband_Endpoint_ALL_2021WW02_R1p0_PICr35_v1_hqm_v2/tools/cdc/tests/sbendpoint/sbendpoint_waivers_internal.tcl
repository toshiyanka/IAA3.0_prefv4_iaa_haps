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
gen_rata.gen_treg.sbetrgtreg.nstate \
gen_rata.gen_treg.sbetrgtreg.pstate \
sbebase.gen_async_blk2.sbcasync*gress.port_idle_ff \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.i_sbebulkrdwr*.fstate \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.nprdyfornxtirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.nxttregirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.*bulk* \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.cirdy \
gen_rata.genblk2.gen_hier_param.sbehierinsert_treg.out_pcmsgip \
gen_rata.gen_treg_hdr_strap.sbehierinsert_treg.out_*msgip \
global_ep_strap \
mmsg_*irdy \
mreg_irdy \
mreg_npwrite \
mreg_opcode* \
sbebase.gen_async_blk2.sbcasync*ress.sbcasync*gress.i_gen_gray_*ptr_usync_doubleflop.sync*ptr*.i_ctech_lib_*.o* \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.i_gen_gray_*ptr_*ptr_usync.i_sbcusync_rptr_*rptr.q \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.gray_*wptr \
sbebase.gen_async_blk2.sbcasyncegress.sbcasyncingress.trdy_gaten \
sbebase.sbemstr.np \
sbebase.sbemstr.sbe_sbi_mmsg_*sel* \
sbebase.sbetrgt.npfsm* \
"

foreach {async_reset_no_sync} $async_reset_no_syncs {
   cdc report crossing -scheme async_reset_no_sync -from ${async_reset_no_sync}  -to sbebase.i_sbcasyncclkreq_side_clk.clkreq_int -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme async_reset_no_sync -from ${async_reset_no_sync}  -to sbebase.i_sbcasyncclkreq_side_clk.clkreq_old -severity waived -comment ${comment} -module ${ep_top}
}

set comment "side_clkreq is a psudo-synchronous signal. It will assert \
             asynchronously and de-assert synchronous to the side_clk. The \
             output should be handled as if the signal were fully \
             asynchronous."

set no_syncs " \
sbebase.i_sbcasyncclkreq_side_clk.clkreq_en \
sbebase.i_sbcasyncclkreq_side_clk.clkreq_int \
sbebase.i_sbcasyncclkreq_side_clk.clkreq_old \
"

foreach {no_sync} $no_syncs {
   cdc report crossing -scheme no_sync -from ${no_sync} -to side_clkreq -severity waived -comment ${comment} -module ${ep_top}
}

## THIS COMMENT IS COMPLETE BALONEY
set comment "sbe_clkreq when in asynchronous mode and the target register \
             module is inserted becomes asynchronous as there are two clock \
             domains (side_clk and agent_clk). In any other circumstance the \
             inputs all come from the side_clk domain. So the checks that \
             a clocked input to an asynchronous output must be waived to \
             correctly get QCDC to work."

set no_syncs " \
gen_rata.gen_treg.sbetrgtreg.nstate \
gen_rata.gen_treg.sbetrgtreg.pstate \
sbebase.gen_async_blk2.sbcasync*gress.gray_npwptr \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.i_gen_gray_rptr_usync_doubleflop.sync*ptr*.i_ctech_lib*.o* \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.gray_*rptr_ff2_dsync \
sbebase.gen_async_blk2.sbcasync*gress.gray_wptr \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.i_gen_gray_rptr_nprptr_usync.i_sbcusync_rptr_nprptr.q \
{sbebase.gen_async_blk2.sbcasync*gress.syncnprptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasync*gress.syncrptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
sbebase.sbcport.sbcegress.mnpput \
sbebase.sbcport.sbcegress.mpcput \
sbebase.sbcport.sbcegress.npxfr \
sbebase.sbcport.sbcegress.pcxfr \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.cupsendcnt \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.outmsg_cup \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.qcnt \
sbebase.sbcport.sbcingress.npmsgip \
sbebase.sbcport.sbcingress.pcmsgip \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.i_sbebulkrdwr*.fstate \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.nprdyfornxtirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.nxttregirdy \
agent_idle \
gen_mreg.sbemstrreg.mreg_*msgip \
gen_mreg.sbemstrreg.*count \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper*.*bulkc* \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.c* \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.onebulkpop_extended* \
mmsg_*irdy \
m*cup \
mreg_irdy \
mreg_npwrite \
mreg_opcode* \
sbebase.sbcport.gen_legacy_ism.sbcgcgu.idlecnt \
sbebase.sbcport.gen_legacy_ism.sbcgcgu.sbcism0.ism_out \
sbebase.sbcport.sbcegress.*credits \
sbebase.sbemstr.np \
sbebase.sbemstr.sbe_sbi_mmsg_*msgip \
sbebase.sbemstr.sbe_sbi_mmsg_*sel* \
sbebase.sbetrgt.npfsm* \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.parity_err_out \
gen_rata.genblk2.gen_hier_param.sbehierinsert_treg.out_*msgip \
gen_rata.gen_treg_hdr_strap.sbehierinsert_treg.out_*msgip \
global_ep_strap \
sbebase.gen_async_blk2.sbcasync*ress.sbcasync*gress.trdy_gaten \
sbebase.gen_doserrmstr.sbedoserrmstr.mmsg_pcirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.i_sbebulkrdwr_np.fstate.bulkopcode \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkwrcompletions \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkrdcmsgip \
"
#hotfix for TGL
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

#hotfix for TGL

foreach {no_sync} $no_syncs {
      cdc report crossing -scheme no_sync -from agent_idle -to ${no_sync} -severity waived -comment ${comment} -module ${ep_top}
}

#hotfix for TGL
set no_syncs " \
tnpput
tpcput
teom
tparity
tpayload
"
foreach {no_sync} $no_syncs {
      cdc report crossing -scheme no_sync -from ${no_sync} -to sbe_clkreq -severity waived -comment ${comment} -module ${ep_top}
}


# Fan-In From Multiple Domains

set comment "The clock requests asynchronous wake signal may be woken up from \
             any number of clock domains. Since these signals are used to wake \
             the side_clk, it is impossible to synchronize the original signals \
             to the side_clk domain. The possible clock domains may be \
             agent_clk and asynchronous input agent_clkreq. This check will not \
             care if it is only side_clk and asynchronous inputs."

set externals " \
gen_rata.gen_treg.sbetrgtreg.nstate \
gen_rata.gen_treg.sbetrgtreg.pstate \
sbebase.gen_async_blk2.sbcasync*gress.port_idle_ff \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.i_sbebulkrdwr*.fstate \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.nprdyfornxtirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.*bulk* \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.cirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.nxttregirdy \
gen_rata.genblk2.gen_hier_param.sbehierinsert_treg.out_*msgip \
gen_rata.gen_treg_hdr_strap.sbehierinsert_treg.out_*msgip \
global_ep_strap \
mmsg_*irdy \
mreg_irdy \
mreg_npwrite \
mreg_opcode* \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.gray_*ptr* \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.i_gen_gray_*ptr*_usync_doubleflop.sync*rptr*.i_ctech_lib*.o* \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.i_gen_gray_*ptr_*rptr_usync.i_sbcusync_*ptr_*rptr.q \
sbebase.gen_async_blk2.sbcasyncegress.sbcasyncingress.trdy_gaten \
sbebase.gen_doserrmstr.sbedoserrmstr.mmsg_*irdy \
sbebase.sbemstr.np \
sbebase.sbemstr.sbe_sbi_mmsg_*sel* \
sbebase.sbetrgt.npfsm* \
agent_clkreq \

"

if { $asyncendpt == 1 } {
   foreach {external} $externals {
       cdc report crossing -scheme fanin_different_clks -from ${external} -to {sbebase.i_sbc_doublesync_wake.i_ctech_*.ctech_lib_doublesync_rst*_dcsz*} -severity waived -comment ${comment} -module ${ep_top}
       cdc report crossing -scheme fanin_different_clks -from ${external} -to {sbebase.i_sbc_doublesync_wake.i_ctech_*.ctech_lib_doublesync_rst_dcsz*} -severity waived -comment ${comment} -module ${ep_top}
   }
}

# Combinational Logic on Resets

set combo_logic " \
gen_rata.gen_treg.sbetrgtreg.nstate \
gen_rata.gen_treg.sbetrgtreg.pstate \
sbebase.gen_async_blk2.sbcasyncegress.port_idle_ff \
"
cdc report crossing -scheme combo_logic -from ${combo_logic} -to sbebase.i_sbc_doublesync_wake.d -severity waived -module ${ep_top}

# Multibits

set comment "universal synchronizer circuit is built to transition multiple \
             bits between two clock domains reliably and deterministically. \
             It should be noted that side_usync and agent_usync should be \
             asserted appropriately for proper synchronization to occur. \
             This would have to be handled from the SOC level."

if { $usync_enable == 1 } {
   cdc report crossing -scheme multi_bits -from sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp2  -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp3  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme multi_bits -from sbebase.gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp2  -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp3  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme multi_bits -from sbebase.gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp2 -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp3 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme multi_bits -from sbebase.gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp2 -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp3 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme multi_bits -from sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.*pre_sync_data -to sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.*qtmp3 -severity waived -comment ${comment} -module ${ep_top}   
}

#Added for HSD: 220987779
if { $usync_enable == 1 } {
    cdc report crossing -scheme multi_bits -from sbebase.gen_async_blk2.sbcasyncegress.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.pre_sync_data  -to sbebase.gen_async_blk2.sbcasyncegress.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp3  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme multi_bits -from sbebase.gen_async_blk2.sbcasyncegress.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.pre_sync_data   -to sbebase.gen_async_blk2.sbcasyncegress.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_sbcusync_rptr_nprptr.qtmp3  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme multi_bits -from sbebase.gen_async_blk2.sbcasyncingress.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.pre_sync_data -to sbebase.gen_async_blk2.sbcasyncingress.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp3 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme multi_bits -from sbebase.gen_async_blk2.sbcasyncingress.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.pre_sync_data  -to sbebase.gen_async_blk2.sbcasyncingress.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_sbcusync_rptr_nprptr.qtmp3 -severity waived -comment ${comment} -module ${ep_top}
}


# Reconvergence Paths
set reconvergence " \
gen_rata.gen_treg.sbetrgtreg.nstate \
gen_rata.gen_treg.sbetrgtreg.pstate \
sbebase.sbetrgt.npfsm \
sbebase.sbetrgt.pchdrdrp \
sbebase.sbetrgt.nphdrdrp  \
sbebase.sbetrgt.pcmsgip \
sbebase.sbetrgt.npmsgip \
sbebase.sbemstr.cfence \
sbebase.sbetrgt.gen_nexhd_blk0.pcpayload_int \
sbebase.sbetrgt.gen_nexhd_blk0.nppayload_int \
sbebase.gen_async_blk2.sbcasyncingress.nprptr \
sbebase.gen_async_blk2.sbcasyncingress.npwptr
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.mreg_nmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.mreg_pmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.ncount -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.pcount -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_rata.gen_treg.sbetrgtreg.cirdy  -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_rata.gen_treg.sbetrgtreg.nignore -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_rata.gen_treg.sbetrgtreg.pignore -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_rata.gen_treg.sbetrgtreg.ctregxfr -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_nptrdy -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_pctrdy -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.agent_clkgate.i_ctech_*.reg_o -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.agent_fifo_idle_ff -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gen_flop_queue0.i_sbcfifo.fifo -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gray_npwptr* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gray_wptr* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.port_idle_ff -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gray_rptr* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.npqempty* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.nprptr* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.npwptr* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mreg_trdy -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gray_nprptr -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.cfence -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.cmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_npmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_npsel -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_pcsel -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_pcmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_nexhd_blk0.nppayload_int -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_nexhd_blk0.pcpayload_int -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npdest -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nphdrdrp -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npsrc -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nptag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pchdrdrp -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pcmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npeom -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_nppayload -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npput -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npvalid -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pcput -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pcvalid -severity waived -module ${ep_top}

   cdc report crossing -scheme reconvergence -to visa_fifo_tier1_ag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_fifo_tier1_sb -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_fifo_tier2_ag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_fifo_tier2_sb -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to gen_treg.sbetrgtreg.nstate -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to gen_treg.sbetrgtreg.pstate -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to sbebase.sbetrgt.npfsm -severity waived -module ${ep_top}

   cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncingress.nprptr* -to gen_treg.sbetrgtreg.nignore -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbemstr.cfence -to gen_treg.sbetrgtreg.nignore -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.nphdrdrp -to gen_treg.sbetrgtreg.nignore -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.npmsgip -to gen_treg.sbetrgtreg.nignore -severity waived -module ${ep_top}

   cdc report crossing -scheme reconvergence -from gen_treg.sbetrgtreg.nignore -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from gen_treg.sbetrgtreg.pignore -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from gen_treg.sbetrgtreg.nstate -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from gen_treg.sbetrgtreg.pstate -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncingress.nprptr* -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbemstr.cfence -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.gen_nexhd_blk0.nppayload_int -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.gen_nexhd_blk0.pcpayload_int -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.npfsm -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.nphdrdrp -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.npmsgip -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.pchdrdrp -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.pcmsgip -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.gen_nexhd_blk0.nppayload_int -to gen_treg.sbetrgtreg.nignore -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncegress.npwptr -to sbebase.gen_async_blk2.sbcasyncegress.npqempty -severity waived -module ${ep_top}
}

set reconvergence " \
sbebase.gen_async_blk2.sbcasyncegress.nprptr \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.npqempty -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.npmsgipb -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.pcmsgipb -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.outdata -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.outeom -severity waived -module ${ep_top}
}

set reconvergence " \
gen_treg.sbetrgtreg.pstate \
sbebase.sbemstr.cfence \
sbebase.sbetrgt.pchdrdrp \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pchdrdrp -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pcmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pcput -severity waived -module ${ep_top}
}

set reconvergence " \
sbebase.gen_async_blk2.sbcasync*gress.gen_flop_queue1.npfifo* \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nignore -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.npmsgipb -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.pcmsgipb -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.outdata -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.outeom -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.cfence -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_nexhd_blk0.nppayload_int -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npdest -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npfsm -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nphdrdrp -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npsrc -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nptag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npeom -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_nppayload -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npput -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from gen_treg.sbetrgtreg.nstate -to ${reconvergence} -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncingress.npwptr -to ${reconvergence} -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbemstr.cfence -to ${reconvergence} -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.npfsm -to ${reconvergence} -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.nphdrdrp -to ${reconvergence} -severity waived -module ${ep_top}

   cdc report crossing -scheme reconvergence -to visa_agent_tier1_ag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_agent_tier2_ag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_port_tier1_ag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_port_tier2_ag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_port_tier1_sb -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_port_tier2_sb -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_reg_tier1_ag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_reg_tier2_ag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_fifo_tier1_sb -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_fifo_tier2_sb -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_fifo_tier1_ag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_fifo_tier2_ag -severity waived -module ${ep_top}

   cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncegress.npwptr -to sbebase.gen_async_blk2.sbcasyncegress.gen_flop_queue1.npfifo* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncegress.gen_flop_queue1.npfifo* -to sbebase.npmsgipb -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncegress.gen_flop_queue1.npfifo* -to sbebase.pcmsgipb -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncegress.gen_flop_queue1.npfifo* -to sbebase.sbcport.sbcegress.outdata* -severity waived -module ${ep_top}
}

set reconvergence " \
gen_treg.sbetrgtreg.nstate* \
sbebase.sbetrgt.gen_tx_ext_header_mux.gen_unique_ext_header.tx_eh_valid_capture \
sbebase.sbetrgt.npfsm \
"

if { $unique_ext_headers == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.gen_tx_ext_header_mux.gen_unique_ext_header.np_eh_valid -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.gen_tx_ext_header_mux.gen_unique_ext_header.p_eh_valid -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.mreg_nmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.mreg_pmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.ncount -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.pcount -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.cirdy -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.ctregxfr -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.gen_tx_ext_header_mux.gen_unique_ext_header.tx_eh_valid -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nignore -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pignore -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_nptrdy -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_pctrdy -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mreg_trdy -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.agent_clkgate.i_ctech_*.reg_o -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.agent_fifo_idle_ff -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gen_flop_queue0.i_sbcfifo.fifo* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gray_npwptr* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gray_wptr* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.port_idle_ff -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gen_flop_queue1.npfifo* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gray_nprptr* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.npqempty -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.nprptr* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.npwptr* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.cfence -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.cmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_npmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_npsel -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_pcmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_pcsel -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.cmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nphdrdrp -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npsrc -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nptag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pchdrdrp -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pcmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.ur_rx_rs -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.ur_rx_sai -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.ur_rx_sairs_valid -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npeom -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_nppayload -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npput -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npvalid -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pcput -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pcvalid -severity waived -module ${ep_top}

   cdc report crossing -scheme reconvergence -to sbebase.sbetrgt.gen_rx_ext_header_support.gen_unique_ext_header.state -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to sbebase.sbetrgt.gen_tx_ext_header_mux.gen_unique_ext_header.tx_eh_valid -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to sbebase.sbetrgt.gen_tx_ext_header_mux.gen_unique_ext_header.tx_eh_valid_capture -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to sbebase.sbetrgt.npdest -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to sbebase.sbetrgt.npsrc -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to sbebase.sbetrgt.nptag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to sbebase.sbetrgt.ur_rx_rs -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to sbebase.sbetrgt.ur_rx_sai -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to sbebase.sbetrgt.ur_rx_sairs_valid -severity waived -module ${ep_top}
}

set reconvergence " \
sbebase.gen_sync_blk0.sync_sbisbeclkreq.q \
sbebase.i_sbcasyncclkreq_side_clk.i_sbc_doublesync_clkack.q \
"

set comment "sbi_sbe_clkreq and side_clkack are indirectly part of the \
             side_clkreq and side_clkack handshake. However, there is no \
             immediate assumption from the endpoint that the two signals \
             originate from the same signal to cause a reconvergence problem. \
             if in the user environment these two signals are from the same \
             origin they will have to fix or waiver the reconvergence check \
             as necessary."

if { $asyncendpt == 0 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gated_side_clk                                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_nptrdy                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_pctrdy                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_clk_valid                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.clken                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.clkgate.*                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_sync_mip_blk.npmsgipb_ff                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_sync_mip_blk.pcmsgipb_ff                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.clkactive                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.clkgated                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.clkreq_en                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.clkreq_int                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.cnt*                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.fsm                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.i_sbc_clock_gate_clk_gated*               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.mnpput                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.mpcput                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.npcredits*                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.npxfr*                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.outdata*                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.outeom                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.pccredits*                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.pcxfr*                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcgcgu.credit_init                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcgcgu.curr_state*                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcgcgu.idlecnt*                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcgcgu.sbcism0.credit_reinit                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcgcgu.sbcism0.ism_out*                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.crdinit_done_ff                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.fencecntr*                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.cupholdcnt*                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.cupsendcnt*                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.gen_flop_queue3.queueflop* -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.outmsg_cup                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.qcnt*                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.rptr*                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.wptr*                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.npmsgip                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.pccntr*                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.pcmsgip                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.cfence                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.cmsgip                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.np                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_npmsgip                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_npsel*                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_pcmsgip                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_pcsel*                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_nexhd_blk0.nppayload_int*                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_nexhd_blk0.pcpayload_int*                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npdest*                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npfsm*                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nphdrdrp                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npmsgip                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npsrc*                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nptag*                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pchdrdrp                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pcmsgip                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to side_clkreq                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to side_ism_agent*                                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.ism*                                                     -severity waived -comment ${comment} -module ${ep_top}
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

# set reconvergence "\
# gen_async_rst_blk.agent_rst_sync.q \
# sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.q \
# sbebase.gen_async_blk2.sbcasyncegress.syncnprptr*.q \
# sbebase.gen_async_blk2.sbcasyncegress.syncrptr*.q \
# sbebase.gen_async_blk2.sbcasyncegress.syncwptr*.q \
# sbebase.gen_async_blk2.sbcasyncingress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.q \
# sbebase.gen_async_blk2.sbcasyncingress.syncnprptr*.q \
# sbebase.gen_async_blk2.sbcasyncingress.syncrptr*.q \
# sbebase.gen_async_blk2.sbcasyncingress.syncwptr*.q \
# "

set reconvergence "\
{gen_async_rst_blk.agent_rst_sync.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncegress.syncnprptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncegress.syncrptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncegress.syncwptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncingress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncingress.syncnprptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncingress.syncrptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncingress.syncwptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
sbebase.gen_async_blk2.sbcasyncegress.gray_rptr* \
sbebase.gen_async_blk2.sbcasyncegress.npqempty* \
sbebase.sbcport.sbcegress.mnpput \
sbebase.sbcport.sbcegress.mpcput \
sbebase.npmsgipb \
sbebase.pcmsgipb \
sbebase.sbcport.sbcegress.npxfr* \
sbebase.sbcport.sbcegress.pcxfr* \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_clk_valid -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_clkreq    -severity waived -module ${ep_top}
}
#  cdc report crossing -scheme reconvergence -from ${reconvergence} -to gated_side_clk -severity waived -module ${ep_top}


if { $asyncendpt == 1 && $targetreg == 1 && $masterreg == 1 } {
    cdc report crossing -scheme reconvergence -from gen_treg.sbetrgtreg.np -to gen_mreg.sbemstrreg.mreg_nmsgip -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from gen_treg.sbetrgtreg.np -to gen_mreg.sbemstrreg.mreg_pmsgip -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from gen_treg.sbetrgtreg.np -to gen_mreg.sbemstrreg.ncount* -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from gen_treg.sbetrgtreg.np -to gen_mreg.sbemstrreg.pcount* -severity waived -module ${ep_top}
}

if { $asyncendpt == 1 && $masterreg == 1 } {
    cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncingress.gray_rptr* -to gen_mreg.sbemstrreg.mreg_nmsgip -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncingress.npqempty -to gen_mreg.sbemstrreg.mreg_nmsgip -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncingress.gray_rptr* -to gen_mreg.sbemstrreg.mreg_pmsgip -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncingress.npqempty -to gen_mreg.sbemstrreg.mreg_pmsgip -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncingress.gray_rptr* -to gen_mreg.sbemstrreg.ncount* -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncingress.npqempty -to gen_mreg.sbemstrreg.ncount* -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncingress.gray_rptr* -to gen_mreg.sbemstrreg.pcount* -severity waived -module ${ep_top}
    cdc report crossing -scheme reconvergence -from sbebase.gen_async_blk2.sbcasyncingress.npqempty -to gen_mreg.sbemstrreg.pcount* -severity waived -module ${ep_top}
}


# set reconvergence "\
# gen_async_rst_blk.agent_rst_sync.q \
# sbebase.gen_async_blk2.sbcasyncegress.syncnprptr*.q \
# sbebase.gen_async_blk2.sbcasyncegress.syncrptr*.q \
# sbebase.gen_async_blk2.sbcasyncingress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.q \
# sbebase.gen_async_blk2.sbcasyncingress.syncwptr*.q \
# "

set reconvergence "\
{gen_async_rst_blk.agent_rst_sync.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasync*gress.syncnprptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasync*gress.syncrptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasync*gress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasync*gress.syncwptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
gen_treg.sbetrgtreg.np \
sbebase.gen_async_blk2.sbcasyncingress.gray_rptr* \
sbebase.gen_async_blk2.sbcasyncingress.npqempty \
sbebase.sbetrgt.npsrc* \
sbebase.sbetrgt.npdest* \
sbebase.sbetrgt.nptag* \
gen_treg.sbetrgtreg.nstate.dest* \
sbebase.gen_async_blk2.sbcasyncegress.gray_rptr* \
sbebase.gen_async_blk2.sbcasyncegress.npqempty \
sbebase.npmsgipb \
sbebase.pcmsgipb \
sbebase.sbcport.sbcegress.mnpput \
sbebase.sbcport.sbcegress.mpcput \
sbebase.sbcport.sbcegress.npxfr* \
sbebase.sbcport.sbcegress.pcxfr* \
"

if { $asyncendpt == 1 } {
   if { $masterreg == 1 } {
      if { $unique_ext_headers == 1 } {
         cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.gen_tx_ext_header_mux.gen_unique_ext_header.np_eh_valid                     -severity waived -comment ${comment} -module ${ep_top}
         cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.gen_tx_ext_header_mux.gen_unique_ext_header.p_eh_valid                      -severity waived -comment ${comment} -module ${ep_top}
      }
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.mreg_nmsgip                                                                 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.mreg_pmsgip                                                                 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.ncount*                                                                     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.pcount*                                                                     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to mreg_nmsgip                                                                                     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to mreg_pmsgip                                                                                     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to mreg_trdy                                                                                       -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier1_ag.mreg_nmsgip                                                                   -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier1_ag.mreg_pmsgip                                                                   -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier1_ag.mreg_trdy                                                                     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier2_ag.mreg_ncount*                                                                  -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier2_ag.mreg_pcount*                                                                  -severity waived -comment ${comment} -module ${ep_top}
   }
   if { $targetreg == 1 } {
      if { $unique_ext_headers == 1 } {
         cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.gen_tx_ext_header_mux.gen_unique_ext_header.tx_eh_valid                     -severity waived -comment ${comment} -module ${ep_top}
      }
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.cirdy                                                                       -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.ctregcerr                                                                   -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.ctregxfr*                                                                   -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nignore                                                                     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.np                                                                          -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.addr*                                                                -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.addrlen                                                              -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.bar*                                                                 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.be*                                                                  -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.count*                                                               -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.data*                                                                -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.dest*                                                                -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.eh                                                                   -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.eh_discard                                                           -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.err                                                                  -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.ext_hdr*                                                             -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.ext_hdr_cnt                                                          -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.fid*                                                                 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.irdy                                                                 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.opcode*                                                              -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.source*                                                              -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate.tag*                                                                 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pignore                                                                     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.addr*                                                                -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.addrlen                                                              -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.bar*                                                                 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.be*                                                                  -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.count*                                                               -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.data*                                                                -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.dest*                                                                -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.eh                                                                   -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.eh_discard                                                           -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.err                                                                  -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.ext_hdr*                                                             -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.ext_hdr_cnt                                                          -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.fid*                                                                 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.irdy                                                                 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.opcode*                                                              -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.source*                                                              -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pstate.tag*                                                                 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.treg_crs_ff*                                                                -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.treg_csai_ff*                                                               -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_addr*                                                                                      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_addrlen                                                                                    -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_bar*                                                                                       -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_be*                                                                                        -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_dest*                                                                                      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_eh                                                                                         -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_eh_discard                                                                                 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_ext_header*                                                                                -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_fid*                                                                                       -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_irdy                                                                                       -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_np                                                                                         -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_opcode*                                                                                    -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_rx_rs*                                                                                     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_rx_sai*                                                                                    -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_rx_sairs_valid                                                                             -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_source*                                                                                    -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_tag*                                                                                       -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to treg_wdata*                                                                                     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier1_ag.treg_cirdy                                                                    -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier1_ag.treg_ctregcerr                                                                -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier1_ag.treg_ctregxfr*                                                                -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier1_ag.treg_err                                                                      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier1_ag.treg_irdy                                                                     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier1_ag.treg_np                                                                       -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier1_ag.treg_npignore                                                                 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier2_ag.treg_ncount*                                                                  -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier2_ag.treg_pcount*                                                                  -severity waived -comment ${comment} -module ${ep_top}
   }
   if { $unique_ext_headers == 1 } {
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_rx_ext_header_support.gen_unique_ext_header.state                           -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_tx_ext_header_mux.gen_unique_ext_header.tx_eh_valid                         -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_tx_ext_header_mux.gen_unique_ext_header.tx_eh_valid_capture                 -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to ur_rx_rs*                                                                                       -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to ur_rx_sai*                                                                                      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to ur_rx_sairs_valid                                                                               -severity waived -comment ${comment} -module ${ep_top}
   }
   if { $usync_enable == 1 } {
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp1*        -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp2*        -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.egr_cntr      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.q*            -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp3*        -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.usync2tmp1    -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.usync2tmp2    -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.egr_cntr     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.q*           -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp3*       -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.usync2tmp1   -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.usync2tmp2   -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp1*       -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp2*       -severity waived -comment ${comment} -module ${ep_top}
   }
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_npmsgip                                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_npsel                                                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_nptrdy                                                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_pcmsgip                                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_pcsel*                                                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_pctrdy                                                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbe_idle                                                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.agent_clkgate.i_ctech_*.* -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.agent_fifo_idle_ff                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gen_flop_queue0.i_sbcfifo.qin*                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gen_flop_queue0.i_sbcfifo.fifo*                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gray_npwptr*                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gray_wptr*                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.d -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.port_idle_ff                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.syncwptr*.d                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.trdy_gaten                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gen_flop_queue0.i_sbcfifo.fifo*                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gen_flop_queue0.i_sbcfifo.bin_rptr                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gen_flop_queue1.npfifo*                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gray_nprptr*                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gray_rptr*                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.npqempty                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.nprptr                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.npwptr                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.port_idle_ff                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.syncnprptr*.d                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.syncrptr*.d                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.trdy_gaten                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbc_doublesync_wake.d                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.cfence                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.cmsgip                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.np                                                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_npmsgip                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_npsel*                                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_pcmsgip                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_pcsel*                                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.cmsgip                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_nexhd_blk0.nppayload_int*                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_nexhd_blk0.pcpayload_int*                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npdest*                                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npfsm*                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nphdrdrp                                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npmsgip                                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npsrc*                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nptag*                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pchdrdrp                                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pcmsgip                                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.ur_rx_rs*                                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.ur_rx_sai*                                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.ur_rx_sairs_valid                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npeom                                                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pceom                                                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npmsgip                                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_nppayload*                                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npput                                                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npvalid                                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pccmpl                                                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pcmsgip                                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pcpayload*                                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pcput                                                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pcvalid                                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.master_cfence                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.master_cmsgip                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.master_np                                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.master_npmsgip                                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.master_pcmsgip                                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.target_npfsm*                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.target_nphdrdrop                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.target_npmsgip                                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.target_pchdrdrop                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier1_ag.target_pcmsgip                                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier2_ag.npsel_bin*                                                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_agent_tier2_ag.pcsel_bin*                                                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_ag.efifo.enc_gray_rwptr*                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_ag.efifo.xor_gray_rptr_ff2                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_ag.efifo.xor_gray_wptr                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_ag.ififo.enc_gray_rwptr*                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_ag.ififo.enpirdy                                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_ag.ififo.epcirdy                                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.efifo.enc_gray_nprwptr*                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.efifo.xor_gray_nprptr_ff2                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.efifo.xor_gray_npwptr                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.ififo.enc_nprwptr*                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.ififo.npqempty                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.ififo.xor_gray_rptr                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_ag.ififo.xor_gray_wptr_ff2                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier1_ag.mmsg_npeom                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_reg_tier1_ag.mmsg_pceom                                                                    -severity waived -comment ${comment} -module ${ep_top}
}

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -to visa_fifo_tier1_sb.ififo.epcirdy -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_fifo_tier1_sb.ififo.enpirdy -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_fifo_tier2_ag.ififo.enc_nprwptr* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_fifo_tier2_sb.efifo.xor_gray_nprptr_ff2 -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_fifo_tier2_sb.ififo.xor_gray_wptr_ff2 -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_fifo_tier2_sb.ififo.enc_nprwptr* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to visa_reg_tier1_ag.treg_npignore -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to sbebase.sbcport.sbcgcgu.visa_ip_idle -severity waived -module ${ep_top}
}

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.nphdrdrp -to tmsg_npmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.npmsgip -to tmsg_npmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.pchdrdrp -to tmsg_pcmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.pcmsgip -to tmsg_pcmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from gen_treg.sbetrgtreg.pstate.dest* -to treg_dest* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -to sbe_idle -severity waived -module ${ep_top}
}

# set reconvergence "\
# sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.q \
# sbebase.gen_async_blk2.sbcasyncegress.syncwptr*.q \
# sbebase.gen_async_blk2.sbcasyncingress.syncnprptr*.q \
# sbebase.gen_async_blk2.sbcasyncingress.syncrptr*.q \
# "
set reconvergence "\
{sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncegress.syncwptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncingress.syncnprptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncingress.syncrptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
sbebase.gen_async_blk2.sbcasyncegress.gray_rptr* \
sbebase.gen_async_blk2.sbcasyncegress.npqempty \
sbebase.npmsgipb \
sbebase.pcmsgipb \
sbebase.sbcport.sbcegress.mnpput \
sbebase.sbcport.sbcegress.mpcput \
sbebase.sbcport.sbcegress.npxfr* \
sbebase.sbcport.sbcegress.pcxfr* \
sbebase.sbcport.sbcegress.npcredits* \
sbebase.sbcport.sbcegress.pccredits* \
"

if { $asyncendpt == 1 } {
   if { $usync_enable == 1 } {
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.egr_cntr     -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.q*           -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp3*       -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.usync2tmp1   -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.usync2tmp2   -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp1*       -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncegress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp2*       -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp1*      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_agent_wptr_idle_usync.i_sbcusync_wptr_idle.qtmp2*      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.egr_cntr    -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.q*          -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.qtmp3*      -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.usync2tmp1  -severity waived -comment ${comment} -module ${ep_top}
      cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_gray_rptr_nprptr_usync.i_usync_rptr_nprptr.usync2tmp2  -severity waived -comment ${comment} -module ${ep_top}
   }
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gated_side_clk                                                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to meom                                                                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mnpput                                                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mpayload*                                                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mpcput                                                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.clken                                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.clkgate.i_ctech_*.* -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gen_flop_queue0.i_sbcfifo.bin_rptr                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gen_flop_queue0.i_sbcfifo.fifo*                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gen_flop_queue0.i_sbcfifo.fifo*                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gen_flop_queue1.npfifo*                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gray_nprptr*                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gray_rptr*                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.npqempty                                                   -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.nprptr                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.npwptr                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.port_idle_ff                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.syncnprptr*.d                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.syncrptr*.d                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gen_flop_queue0.i_sbcfifo.qin*                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gray_npwptr*                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gray_wptr*                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.i_gen_agent_idle_sync_set.i_sbc_doublesync*port_idle_ff.d -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.port_idle_ff                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.syncwptr*.d                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.trdy_gaten                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.clkactive                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.clkgated                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.clkreq_en                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.clkreq_int                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.cnt*                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.fsm                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.i_sbcasyncclkreq_side_clk.i_sbc_clock_gate_clk_gated*                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.npmsgipb                                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.pcmsgipb                                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.mnpput                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.mpcput                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.npcredits*                                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.npxfr*                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.outdata*                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.outeom                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.pccredits*                                                             -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcegress.pcxfr*                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcgcgu.credit_init                                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcgcgu.curr_state*                                                              -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcgcgu.idlecnt*                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcgcgu.sbcism0.credit_reinit                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcgcgu.sbcism0.ism_out*                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.crdinit_done_ff                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.fencecntr*                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.cupholdcnt*                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.cupsendcnt*                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.gen_flop_queue3.queueflop*                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.outmsg_cup                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.qcnt*                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.rptr*                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.wptr*                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.npmsgip                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.pccntr*                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbcport.sbcingress.pcmsgip                                                               -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.ur_rx_sairs_valid                                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to side_clkreq                                                                                      -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to side_ism_agent*                                                                                  -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tnpcup                                                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tpccup                                                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_sb.efifo.enc_gray_rwptr*                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_sb.efifo.xor_gray_wptr                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_sb.ififo.enc_gray_rwptr*                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_sb.ififo.enpirdy                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_sb.ififo.epcirdy                                                                 -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_sb.efifo.enc_gray_nprwptr*                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_sb.efifo.xor_gray_npwptr                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_sb.ififo.enc_nprwptr*                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_sb.ififo.npqempty                                                                -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_sb.ififo.xor_gray_rptr                                                           -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.idle                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.npcredits                                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.npmsgip                                                                       -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.npqcount*                                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.npxfr                                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.outmsg_cup                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.pccredits                                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.pcqcount*                                                                     -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier1_sb.pcxfr                                                                         -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.fencecntr*                                                                    -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.ism*                                                                          -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.mnpput                                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.mpcput                                                                        -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.npcuphold_sendcnt*                                                            -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_port_tier2_sb.pccuphold_sendcnt*                                                            -severity waived -comment ${comment} -module ${ep_top}
}

if { $asyncendpt == 1 && $masterreg == 0 && $targetreg == 1 } {
   cdc report crossing -scheme reconvergence -to gen_treg.sbetrgtreg.tx_eh_cnt -severity waived -comment ${comment} -module ${ep_top}
   cdc report crossing -scheme reconvergence -from gen_treg.sbetrgtreg.nstate -to sbebase.sbetrgt.cmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from sbebase.sbetrgt.npfsm -to sbebase.sbetrgt.cmsgip -severity waived -module ${ep_top}
}

set reconvergence "\
sbebase.gen_async_blk2.sbcasyncegress.syncwptr*.q \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_sb.ififo.xor_gray_wptr_ff2 -severity waived -comment ${comment} -module ${ep_top}
}

set reconvergence "\
sbebase.gen_async_blk2.sbcasyncingress.syncnprptr*.q \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier2_sb.efifo.xor_gray_nprptr_ff2 -severity waived -comment ${comment} -module ${ep_top}
}

set reconvergence "\
sbebase.gen_async_blk2.sbcasyncingress.syncrptr*.q \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to visa_fifo_tier1_sb.efifo.xor_gray_rptr_ff2 -severity waived -comment ${comment} -module ${ep_top}
}

cdc report crossing -scheme reconvergence -to "visa_port_tier1_sb.func_valid_visa\[0\]" -severity waived -module ${ep_top}
cdc report crossing -scheme reconvergence -to "visa_port_tier1_sb.func_valid_visa\[1\]" -severity waived -module ${ep_top}

#Added after TMSG_MMSG RTL merge
set reconvergence "\
gen_treg.sbetrgtreg.np \
gen_treg.sbetrgtreg.pstate \
gen_treg.sbetrgtreg.nstate.* \
{sbebase.gen_async_blk2.sbcasyncegress.syncnprptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncegress.syncrptr*.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncingress.syncwptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
sbebase.gen_async_blk2.sbcasyncingress.gray_rptr \
sbebase.gen_async_blk2.sbcasyncingress.npqempty \
sbebase.gen_async_blk2.sbcasyncingress.nprptr \
sbebase.sbemstr.cfence \
sbebase.sbetrgt.npfsm \
sbebase.sbetrgt.pchdrdrp \
sbebase.sbetrgt.nphdrdrp \
sbebase.sbetrgt.npmsgip \
sbebase.sbetrgt.pcmsgip \
sbebase.sbetrgt.gen_tx_ext_header_mux.gen_unique_ext_header.tx_eh_valid_capture \
sbebase.sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_np.byte_count \
sbebase.sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_pc.byte_count \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.gen_treg_be_15_7.sbebytecount_treg_trgt_pc.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.gen_treg_be_15_7.sbebytecount_treg_trgt_np.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nstate* -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.mreg_nmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.mreg_pmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.ncount -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.pcount -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.gen_mreg_be_15_7.sbebytecount_mstrreg_np.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.gen_mreg_be_15_7.sbebytecount_mstrreg_pc.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.gen_treg_be_15_7.sbebytecount_treg_mmsg_pc.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.gen_treg_be_15_7.sbebytecount_treg_trgt_pc.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.np_claim_ip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pc_claim_ip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_np.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.cmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npdest -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nphdrdrp -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nppayload_int -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npsrc -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nptag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pchdrdrp -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pcmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pcpayload_int -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_pc.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npclaim_f -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npput -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pcput -severity waived -module ${ep_top}   
}

set reconvergence "\
{sbebase.gen_async_blk2.sbcasyncegress.syncnprptr*.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncegress.syncrptr*.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncingress.syncwptr*.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} \
sbebase.gen_async_blk2.sbcasyncingress.gen_flop_queue1.npfifo* \
sbebase.sbetrgt.gen_tx_ext_header_mux.gen_unique_ext_header.tx_eh_valid_capture \
sbebase.sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_np.byte_count \
sbebase.sbetrgt.npfsm \
sbebase.sbetrgt.npdest \
sbebase.sbetrgt.npsrc \
sbebase.sbetrgt.nptag \
sbebase.sbemstr.cfence \
gen_treg.sbetrgtreg.np \
gen_treg.sbetrgtreg.nstate.* \
gen_treg.sbetrgtreg.np \
gen_treg.sbetrgtreg.nignore \
gen_treg.sbetrgtreg.np_claim_ip \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.cirdy -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.ctregxfr -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gray_nprptr -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gray_rptr -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.npqempty -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.nprptr -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.npwptr -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.block_pcsel_f -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.cfence -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.cmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.gen_fnc_en_blk.dst_match -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.gen_fnc_en_blk.opc_match -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.gen_fnc_en_blk.src_match -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.gen_mstr_be_15_7.sbebytecount_mstr_pc.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.gen_mstr_be_15_7.sbebytecount_mstr_np.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_trgt_be_15_7.sbebytecount_mmsg.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_np.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npclaim_f -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nppayload_int -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pcpayload_int  -severity waived -module ${ep_top}
}

set reconvergence "\
gen_treg.sbetrgtreg.nstate* \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_npmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_npsel -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_pcmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.sbe_sbi_mmsg_pcsel -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nphdrdrp -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pchdrdrp -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.pcmsgip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.agent_clkgate.i_ctech_lib_*.reg_o -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.agent_fifo_idle_ff -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasync*ress.gen_flop_queue*.i_sbcfifo.fifo -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncingress.gen_flop_queue*.npfifo -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gray_npwptr -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.gray_wptr -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.gen_async_blk2.sbcasyncegress.port_idle_ff -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npeom -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npput -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_npvalid -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pcput -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_pcvalid -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_nptrdy -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mmsg_pctrdy -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to mreg_trdy -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.gen_tx_ext_header_mux.gen_unique_ext_header.tx_eh_valid -severity waived -module ${ep_top}   
}


set reconvergence "\
sbebase.sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_np.byte_count \
sbebase.sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_pc.byte_count \
sbebase.sbetrgt.nppayload_int \
sbebase.sbetrgt.pcpayload_int \
gen_treg.sbetrgtreg.nstate.* \
gen_treg.sbetrgtreg.gen_treg_be_15_7.sbebytecount_treg_trgt_pc.byte_count \
gen_treg.sbetrgtreg.pc_claim_ip \
gen_treg.sbetrgtreg.np_claim_ip \
gen_treg.sbetrgtreg.gen_treg_be_15_7.sbebytecount_treg_trgt_np.byte_count \
"

if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.nignore -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.np -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pignore -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to tmsg_nppayload -severity waived -module ${ep_top}
}

set reconvergence "\
sbebase.sbemstr.cfence \
sbebase.sbetrgt.npfsm \
sbebase.sbetrgt.nphdrdrp \
sbebase.sbetrgt.pchdrdrp \
sbebase.sbetrgt.nppayload_int \
sbebase.sbetrgt.pcpayload_int \
sbebase.sbetrgt.gen_rx_ext_header_support.gen_unique_ext_header.state \
sbebase.sbetrgt.gen_tx_ext_header_mux.gen_unique_ext_header.tx_eh_valid_capture \
sbebase.sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_np.byte_count \
gen_treg.sbetrgtreg.nstate* \
gen_treg.sbetrgtreg.np \
gen_treg.sbetrgtreg.pstate \
gen_treg.sbetrgtreg.gen_treg_be_15_7.sbebytecount_treg_trgt_np.byte_count \
gen_treg.sbetrgtreg.gen_treg_be_15_7.sbebytecount_treg_trgt_pc.byte_count \
{sbebase.gen_async_blk2.sbcasyncegress.syncnprptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncegress.syncrptr*.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncingress.syncwptr*.i_ctech_*.ctech_lib_doublesync_rstb_dcszo1*} \
sbebase.gen_async_blk2.sbcasyncingress.gen_flop_queue*.npfifo* \
sbebase.gen_async_blk2.sbcasyncingress.nprptr \
"
if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.pc_claim_ip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.np_claim_ip -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.gen_treg_be_15_7.sbebytecount_treg_trgt_np.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.tx_eh_cnt -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_treg.sbetrgtreg.gen_treg_be_15_7.sbebytecount_treg_trgt_np.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_np.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_pc.byte_count -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npclaim_f -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.ur_rx_sairs_valid_flag -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbemstr.block_npsel_f -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.np_eh_cnt -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to gen_mreg.sbemstrreg.p_eh_cnt -severity waived -module ${ep_top}
}

set reconvergence "\
sbebase.sbetrgt.npclaim_f \
sbebase.sbetrgt.nppayload_int \
gen_treg.sbetrgtreg.nstate* \
"
if { $asyncendpt == 1 } {
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npdest -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.npsrc -severity waived -module ${ep_top}
   cdc report crossing -scheme reconvergence -from ${reconvergence} -to sbebase.sbetrgt.nptag -severity waived -module ${ep_top}
}

set reconvergence "\
{sbebase.gen_async_blk2.sbcasyncegress.syncwptr*.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncegress.i_gen_agent_idle_sync_set.i_sbc_doublesync_set_port_idle_ff*.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncingress.syncnprptr*.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} \
{sbebase.gen_async_blk2.sbcasyncingress.syncrptr*.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} \
sbebase.gen_async_blk2.sbcasyncegress.gray_rptr \
sbebase.gen_async_blk2.sbcasyncegress.npqempty \
sbebase.npmsgipb \
sbebase.pcmsgipb \
sbebase.sbcport.sbcegress.mnpput \
sbebase.sbcport.sbcegress.mpcput \
sbebase.sbcport.sbcegress.npxfr \
sbebase.sbcport.sbcegress.pcxfr \
"
if { $asyncendpt ==1 } {
   cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.sbcport.sbcgcgu.sbcism0.cg_en_visa -severity waived -module ${ep_top}
}

cdc report crossing -scheme combo_logic -from gen_treg.sbetrgtreg.nstate -to sbebase.i_sbc_doublesync_wake.i_ctech_*.o* -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from gen_treg.sbetrgtreg.nstate -to sbebase.i_sbc_doublesync_wake.i_ctech_lib_* -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from gen_treg.sbetrgtreg.pstate -to sbebase.i_sbc_doublesync_wake.i_ctech_*.o* -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from gen_treg.sbetrgtreg.pstate -to sbebase.i_sbc_doublesync_wake.i_ctech_lib_* -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.port_idle_ff -to sbebase.i_sbc_doublesync_wake.i_ctech_*.o* -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.port_idle_ff -to sbebase.i_sbc_doublesync_wake.i_ctech_lib_* -severity waived -module ${ep_top}

set reconvergence "\
sbebase.sbetrgt.gen_rx_ext_header_support.gen_unique_ext_header.state \
sbebase.sbetrgt.nphdrdrp \
gen_treg.sbetrgtreg.nstate* \
sbebase.gen_async_blk2.sbcasyncingress.gen_flop_queue1.npfifo \
sbebase.gen_async_blk2.sbcasyncingress.nprptr \
sbebase.sbemstr.cfence \
sbebase.sbetrgt.gen_tx_ext_header_mux.gen_unique_ext_header.tx_eh_valid_capture \
sbebase.sbetrgt.npfsm \
sbebase.sbetrgt.gen_trgt_be_15_7.sbebytecount_trgt_np.byte_count \
"
if { $unique_ext_headers == 1 } {
cdc report crossing -scheme reconvergence -from $reconvergence -to sbebase.sbetrgt.ur_rx_sai_temp -severity waived -module ${ep_top}
}

## Parity waivers
## These were newly added paths for parity changes, which do not need syncs
## They are either consumed internally in the same clk domain (do not need syncs)
## or send as output (which case they need to be syncd by IP)

cdc report crossing -scheme no_sync -from gen_rata.gen_treg.sbetrgtreg.parity_err_out -to sbe_clkreq -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from sbebase.sbcport.parity_err_out_pre -to sbe_clkreq -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from sbebase.gen_ext_par_async.i_sync_ext_parity_err_detected.i_ctech_lib* -to sbe_clkreq -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from sbebase.gen_doserrmstr.sbedoserrmstr.flag -to sbebase.gen_doserrmstr.sbedoserrmstr.flag_f -severity waived -module ${ep_top}

cdc report crossing -scheme no_sync -from sbebase.gen_doserrmstr.sbedoserrmstr.flag -to sbebase.gen_doserrmstr.sbedoserrmstr.mmsg_pcirdy -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from sbebase.sbe_sbi_parity_err_out -to sbebase.gen_doserrmstr.sbedoserrmstr.flag -severity waived -module ${ep_top}

cdc report crossing -scheme combo_logic -from gen_rata*.parity_err_out -to sbebase.gen_ext_par_async.i_sync_ext_parity_err_detected.i_ctech_lib* -severity waived -module ${ep_top}
cdc report crossing -scheme async_reset_no_sync -from sbebase.gen_doserrmstr.sbedoserrmstr.mmsg_pcirdy -to sbebase.i_sbcasyncclkreq_side_clk.clkreq_int -severity waived -module ${ep_top}
cdc report crossing -scheme async_reset_no_sync -from sbebase.gen_doserrmstr.sbedoserrmstr.mmsg_pcirdy -to sbebase.i_sbcasyncclkreq_side_clk.clkreq_old -severity waived -module ${ep_top}
cdc report crossing -scheme async_reset_no_sync -from side_rst_b -to sbebase.gen_doserrmstr.sbedoserrmstr.flag -severity waived -module ${ep_top}

cdc report crossing -scheme multi_sync_mux_select -from sbebase.sbe_sbi_parity_err_out -to sbe_idle -severity waived -module ${ep_top}
cdc report crossing -scheme multi_sync_mux_select -from sbebase.sbe_sbi_parity_err_out -to gen_rata.gen_treg.sbetrgtreg*state* -severity waived -module ${ep_top}
cdc report crossing -scheme multi_sync_mux_select -from sbebase.sbe_sbi_parity_err_out -to sbebase.gen_async_blk2.sbcasync*gress.port_idle_ff -severity waived -module ${ep_top}

cdc report crossing -scheme no_sync -from sbebase.sbe_sbi_parity_err_out -to sbe_clkreq -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from sbebase.sbe_sbi_parity_err_out -to sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.port_idle_ff -severity waived -module ${ep_top}

cdc report crossing -scheme combo_logic -from sbebase.gen_async_blk2.sbcasyncingress.gen_flop_queue1.npfifo* -to {sbebase.gen_async_blk2.i_sync_fifo_err_out.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from sbebase.gen_async_blk2.sbcasyncingress.gen_par.*parity_err_gen_out_pre -to {sbebase.gen_async_blk2.i_sync_fifo_err_out.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from sbebase.gen_async_blk2.sbcasyncingress.gray_rptr -to {sbebase.gen_async_blk2.i_sync_fifo_err_out.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from sbebase.gen_async_blk2.sbcasyncingress.npqempty -to {sbebase.gen_async_blk2.i_sync_fifo_err_out.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from sbebase.gen_async_blk2.sbcasyncingress.nprptr -to {sbebase.gen_async_blk2.i_sync_fifo_err_out.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from {sbebase.gen_async_blk2.sbcasyncingress.syncwptr*.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -to {sbebase.gen_async_blk2.i_sync_fifo_err_out.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from sbebase.sbemstr.cfence -to {sbebase.gen_async_blk2.i_sync_fifo_err_out.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from tmsg_npfree -to {sbebase.gen_async_blk2.i_sync_fifo_err_out.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -severity waived -module ${ep_top}

#CDC 10.4f_3 waivers
cdc report crossing -scheme shift_reg -from sbebase.gen_async_blk2.sbcasync*gress.sbcasync*ress.gray* -to {sbebase.gen_async_blk2.sbcasync*ress.sbcasync*ress.sync*.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -severity waived -module ${ep_top}
cdc report crossing -scheme shift_reg -from sbebase.gen_async_blk2.sbcasync*ress.sbcasync*ress.port_idle_ff -to {sbebase.gen_async_blk2.sbcasync*ress.sbcasync*ress.sync*.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -severity waived -module ${ep_top}
cdc report crossing -scheme shift_reg -from sbebase.gen_async_blk2.sbcasync*ress.sbcasync*ress.port_idle_ff -to {sbebase.gen_async_blk2.sbcasync*ress.sbcasync*ress.i_gen_agent_idle_sync_set.i_sbc_doublesync_set_port_idle_ff*.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -severity waived -module ${ep_top}
cdc report crossing -scheme shift_reg -from side_clkack -to {sbebase.i_sbcasyncclkreq_side_clk.i_sbc_doublesync_clkack.i_ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -severity waived -module ${ep_top}
cdc report crossing -scheme shift_reg -from side_clkack -to sbebase.i_sbcasyncclkreq_side_clk.i_sbc_doublesync_clkack.i_ctech_lib_* -severity waived -module ${ep_top}
cdc report crossing -scheme shift_reg -from sbebase.sbe_sbi_parity_err_out -to {sbebase.gen_doserrmstr.gen_do_async.i_parity_err_sync.i_ctech_lib*.ctech_lib_*.ctech_lib_doublesync_rstb_dcszo1*} -severity waived -module ${ep_top}
#RP

set  multi_sync_mux_select " \
sbebase.sbcport.sbcegress.out* \
sbebase.*msgipb \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.gray_*ptr \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.npqempty \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.rp_based_impl_np.i_vram_npq2.byte_enable*.i_sb_vram_genram_bees_knees.latched_data* \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.npwptr \
sbebase.sbcport.sbcegress.m*put \
sbebase.sbcport.sbcegress.*credits* \
sbebase.sbcport.sbcegress.*xfr \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.*ptr \
gen_treg.sbetrgtreg* \
sbebase.sbetrgt.npclaim_f \
sbebase.sbetrgt.npfsm \
sbebase.sbetrgt.npsrc_mstr \
sbebase.sbetrgt.nptag_mstr \
sbebase.sbetrgt.*hdrdrp \
sbebase.sbetrgt.*msgip \
sbebase.sbemstr.cfence \
sbebase.sbetrgt.npdest_mstr \
sbebase.sbetrgt.*payload_int* \
"

foreach {multi_sync_mux_select} $multi_sync_mux_select {
   cdc report crossing -scheme multi_sync_mux_select -from sbebase.gen_async_blk2.sbcasync*ress.sbcasync*ress.rp_based_impl* -to ${multi_sync_mux_select} -severity waived -module ${ep_top}
}

set  no_sync " \
visa_fifo_tier1_*.ififo.e*irdy \
visa_port_tier2_sb.m*put \
gen_treg.sbetrgtreg.np \
gen_treg.sbetrgtreg.np \
sbebase.*msgipb \
sbebase.sbcport.sbcegress.outeom \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.gray_*ptr \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.np* \
sbebase.sbcport.sbcegress.m*put \
sbebase.sbcport.sbcegress.*credits* \
sbebase.sbcport.sbcegress.*xfr \
gen_treg.sbetrgtreg.*ignore \
gen_treg.sbetrgtreg.tmsg_npfree \
sbebase.sbemstr.cfence \
sbebase.sbetrgt.npclaim_f \
sbebase.sbetrgt.*hdrdrp \
sbebase.sbetrgt.*msgip \
sbebase.sbetrgt.npfsm \
sbebase.sbetrgt.np*_mstr \
sbebase.sbetrgt.*payload* \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.rp_based_impl*.i_sb_vram_genram_bees_knees.latched_data* \
"

foreach {no_sync} $no_sync {
   cdc report crossing -scheme no_sync -from sbebase.gen_async_blk2.sbcasync*ress.sbcasync*ress.rp_based_impl* -to ${no_sync} -severity waived -module ${ep_top}
}

cdc report crossing -scheme multi_bits -from sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.gray_*ptr -to sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.gray_*ptr_ff2_dsync -severity waived -module ${ep_top}
cdc report crossing -scheme fifo_ptr_no_sync -from sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.*rp_based_impl.gen_flop_queue*.i_sbcfifo.fifo -to sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.*rp_based_impl.gen_flop_queue*.i_sbcfifo.qout -severity waived -module ${ep_top}

#10.4f_5 waivers
cdc report crossing -scheme dmux -from sbebase.sbe_sbi_parity_err_out -to gen_treg.sbetrgtreg* -severity waived -module ${ep_top}


set multi_bits " \
gen_async_blk2.sbcasync*gress.sbcasync*gress.rp_based_impl_np.i_vram_npq2.byte_enable*.i_sb_vram_genram_bees_knees.latched_data* \
sbebase.sbcport.sbcegress.outdata \
gen_treg.sbetrgtreg.*state* \
sbebase.sbetrgt.npfsm \
sbebase.sbetrgt.np*_mstr \
sbebase.sbetrgt.*payload_int* \
"

foreach {multi_bits} $multi_bits {
   cdc report crossing -scheme multi_bits -from sbebase.gen_async_blk2.sbcasync*ress.sbcasync*ress.rp_based_impl*.i_sb_vram_genram_bees_knees* -to ${multi_bits} -severity waived -module ${ep_top}
}

cdc report crossing -scheme multi_bits -from sbebase.gen_async_blk2.sbcasync*gress.sbcasync*ngress.rp_based_impl.i_vram2.byte_enable*.i_sb_vram_genram_bees_knees.latched_data* -to sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.rp_based_impl_np.i_vram_npq2.byte_enable*.i_sb_vram_genram_bees_knees.latched_data* -severity waived -module ${ep_top}

#Waivers for CDCLINT 17.31.7
cdc report crossing -scheme no_sync -from ext_parity_err_detected -to sbe_clkreq -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from ext_parity_err_detected -to gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.pbulkmsgip -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from ext_parity_err_detected -to gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.ctregcerr -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from fdfx_sbparity_def -to sbe_clkreq -severity waived -module ${ep_top}

set no_syncs " \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.gray_*ptr \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.non_rp_based_impl.gen_flop_queue*.i_sbcfifo.fifo* \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.port_idle_ff \
sbebase.sbcport.gen_legacy_ism.sbcgcgu.idlecnt \
sbebase.sbcport.parity_err_out_pre \
sbebase.sbcport.sbcingress.fencecntr \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.cupholdcnt \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.cupsendcnt \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.gen_par_ep.parity_err_gen_out_pre \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.outmsg_cup \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.qcnt \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.rptr \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.wptr \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.cupholdcnt \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.non_rp_based_impl.gen_flop_queue*.queueflop* \
sbebase.sbcport.sbcingress.npmsgip \
sbebase.sbcport.sbcingress.parity_err_f* \
sbebase.sbcport.sbcingress.pccntr \
sbebase.sbe_sbi_parity_err_out \
sbebase.sbe_sbi_parity_err_out_side \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.gen_forep.gen_pc.parity_err_in_f \
sbe_clkreq \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.ctregcerr \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.pbulkmsgip \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.gen_forep.gen_pc.parity_err_in_f \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkwrcompletions \
sbebase.clken \
sbebase.sbcport.gen_legacy_ism.sbcgcgu.sbcism0.cg_en_visa \
sbebase.sbcport.gen_legacy_ism.sbcgcgu.sbcism0.ism_out \
sbebase.sbcport.gen_legacy_ism.sbcgcgu.visa_ip_idle \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.gen_forep.gen_pc.crd_cnt* \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.gen_forep.gen_pc.ppp_cnt \
sbebase.sbcport.sbcegress.outdata \
sbebase.sbcport.sbcegress.outparity \
"

foreach {no_syncs} $no_syncs {
   cdc report crossing -scheme no_sync -from fdfx_sbparity_def -to ${no_syncs} -severity waived -module ${ep_top}
}

cdc report crossing -scheme combo_logic -from ext_parity_err_detected -to sbebase.gen_ext_par_async.i_sync_ext_parity_err_detected.i_ctech_lib_*.ctech_lib_*.o* -severity waived -module ${ep_top}
cdc report crossing -scheme combo_logic -from fdfx_sbparity_def -to sbebase.gen_ext_par_async.i_sync_ext_parity_err_detected.i_ctech_lib_*.ctech_lib_*.o* -severity waived -module ${ep_top}

set dmuxs " \
sbebase.clken \
sbebase.sbcport.gen_legacy_ism.sbcgcgu.sbcism0.cg_en_visa \
sbebase.sbcport.gen_legacy_ism.sbcgcgu.sbcism0.ism_out* \
sbebase.sbcport.gen_legacy_ism.sbcgcgu.visa_ip_idle \
sbebase.sbcport.sbcegress.outdata \
sbebase.sbcport.sbcegress.outparity \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.gen_forep.gen_pc.parity_err_in_f \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.wptr \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.non_rp_based_impl.gen_flop_queue*.queueflop* \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.rp_based_impl.i_vram2.byte_enable*.i_sb_vram_genram_bees_knees.latched_data* \

"

foreach {dmuxs} $dmuxs {
    cdc report crossing -scheme dmux -from fdfx_sbparity_def -to ${dmuxs} -severity waived -module ${ep_top}
}

set multi_syncs " \
sbebase.clken \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.gray_*ptr \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.non_rp_based_impl.gen_flop_queue*.i_sbcfifo.fifo* \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.rp_based_impl.i_vram2.byte_enable*.i_sb_vram_genram_bees_knees.latched_data* \
sbebase.gen_async_blk2.sbcasync*gress.sbcasync*gress.port_idle_ff \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.rp_based_impl.rptr_rp \
sbebase.sbcport.gen_legacy_ism.sbcgcgu.idlecnt \
sbebase.sbcport.gen_legacy_ism.sbcgcgu.sbcism0.cg_en_visa \
sbebase.sbcport.gen_legacy_ism.sbcgcgu.sbcism0.ism_out* \
sbebase.sbcport.gen_legacy_ism.sbcgcgu.visa_ip_idle \
sbebase.sbcport.sbcegress.outdata \
sbebase.sbcport.sbcegress.outparity \
sbebase.sbcport.sbcingress.fencecntr \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.cupholdcnt \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.cupsendcnt \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.outmsg_cup \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.qcnt \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.rptr \
sbebase.sbcport.sbcingress.npmsgip \
sbebase.sbcport.sbcingress.pccntr \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.gen_forep.gen_pc.crd_cnt* \
sbebase.sbcport.sbcingress.gen_queue*.sbcinqueue.gen_forep.gen_pc.ppp_cnt \
"

foreach {multi_syncs} $multi_syncs {
    cdc report crossing -scheme multi_sync_mux_select -from fdfx_sbparity_def -to ${multi_syncs} -severity waived -module ${ep_top}
}

# bulk waivers
# adding sync gives a redundant sync error (not needed)
cdc report crossing -scheme no_sync -from sbebase.sbe_sbi_parity_err_out -to gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.gen_mreg_parity.treg_input_parity_err_f -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from sbebase.sbe_sbi_parity_err_out -to gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.ctregcerr -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from sbebase.sbe_sbi_parity_err_out -to gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.pbulkmsgip -severity waived -module ${ep_top}


set multi_syncs " \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkcirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.ctregcerr \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.erronearlypkts \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.extra_bulkcompletion \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.i_sbebulkrdwr_np.fstate.irdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.i_sbebulkrdwr_p.fstate.irdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.mask_bulkcirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.nxttregirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.onebulkpop_extended \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.pbulkmsgip \
sbebase.sbemstr.cfence \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkceom \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkrdceom \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkrsp \
sbe_idle \
gen_rata.gen_treg.sbetrgtreg*state* \
sbebase.gen_async_blk2.sbcasync*gress.port_idle_ff \
"

foreach {multi_syncs} $multi_syncs {
    cdc report crossing -scheme multi_sync_mux_select -from sbebase.sbe_sbi_parity_err_out -to ${multi_syncs} -severity waived -module ${ep_top}
    cdc report crossing -scheme multi_sync_mux_select -from sbebase.sbe_sbi_parity_err_out_side -to ${multi_syncs} -severity waived -module ${ep_top}
}

set no_syncs " \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkcirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.ctregcerr \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.erronearlypkts \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.extra_bulkcompletion \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.i_sbebulkrdwr_np.fstate.irdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.i_sbebulkrdwr_p.fstate.irdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.mask_bulkcirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.nxttregirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.onebulkpop_extended \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.pbulkmsgip \
sbebase.sbemstr.cfence \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkceom \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkrdceom \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkrsp \
gen_rata.gen_treg.sbetrgtreg.nstate* \
gen_rata.gen_treg.sbetrgtreg.pstate* \
"

foreach {no_syncs} $no_syncs {
    cdc report crossing -scheme no_sync -from sbebase.sbe_sbi_parity_err_out -to ${no_syncs} -severity waived -module ${ep_top}
}

cdc report crossing -scheme redundant -from sbebase.sbe_sbi_parity_err_out_side -to sbebase.gen_doserrmstr.gen_do_async.i_parity_err_sync.i_ctech_lib_*.ctech_lib_doublesync* -severity waived -module ${ep_top}
cdc report crossing -scheme redundant -from sbebase.sbe_sbi_parity_err_out_side -to sbebase.gen_par_err_out.gen_par_out_async.i_parity_err_out_sync.i_ctech_lib_*.ctech_lib_doublesync_* -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from sbebase.sbe_sbi_parity_err_out_side -to sbe_clkreq -severity waived -module ${ep_top}
cdc report crossing -scheme no_sync -from sbebase.sbe_sbi_parity_err_out_side -to sbebase.gen_doserrmstr.sbedoserrmstr.flag -severity waived -module ${ep_top}

# Waivers for bulk performance config
set no_syncs " \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkcirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkcmsgip \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkctregxfr \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkwrcompletions \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.cirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.extra_bulkcompletion \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.i_sbebulkrdwr_np.fstate \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.i_sbebulkrdwr_p.fstate \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.mask_bulkcirdy \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.onebulkpop_extended \
mmsg_*irdy \
sbebase.gen_async_blk2.sbcasyncegress.sbcasyncingress.gray_npwptr \
sbebase.gen_async_blk2.sbcasyncegress.sbcasyncingress.gray_wptr \
sbebase.gen_async_blk2.sbcasync*ress.sbcasync*ress.i_gen_gray_*ptr_usync_doubleflop.syncptrs*.i_sync*.i_ctech_lib*.ctech_lib_doublesync* \
sbebase.gen_async_blk2.sbcasyncegress.sbcasyncingress.port_idle_ff \
sbebase.gen_async_blk2.sbcasyncegress.sbcasyncingress.trdy_gaten \
sbebase.sbemstr.np \
sbebase.sbemstr.sbe_sbi_mmsg_*sel \
sbebase.sbetrgt.npfsm* \
side_ism_fabric \
side_rst_b \
gen_rata.gen_bulk_widget.sbebulkrdwrwrapper.bulkrdcmsgip \

"

foreach {no_sync} $no_syncs {
   cdc report crossing -scheme no_sync -from ${no_sync} -to side_clkreq -severity waived -comment ${comment} -module ${ep_top}
}

# waivers for latch based queues
set multi_bits " \
sbebase.gen_async_blk2.sbcasync*ress.sbcasync*ress.non_rp_based_impl.gen_latch_queue0.sbcvram2q.data_memory* \

"

foreach {no_sync} $no_syncs {
   cdc report crossing -scheme multi_bits -from ${multi_bits} -to sbebase.gen_async_blk2.sbcasync*ress.sbcasync*gress.qout -severity waived -comment ${comment} -module ${ep_top}
}

