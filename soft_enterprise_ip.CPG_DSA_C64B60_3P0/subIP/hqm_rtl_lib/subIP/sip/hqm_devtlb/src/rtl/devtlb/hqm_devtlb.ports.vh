//===========================================================================================================
//
// iommu.ports.sv
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//===========================================================================================================
//
// This file contains the list of all interace signals. See iommu.ifc.sv for the definitions of the signals.
//
//===========================================================================================================
//lintra -68099
   clk,

   flreset,
   full_reset,

   fscan_mode,
   fscan_shiften,
   fscan_clkungate_syn,
   fscan_clkgenctrl,
   fscan_clkgenctrlen,
   `HQM_DEVTLB_FSCAN_PORTLIST
   fscan_ram_wrdis_b,
   fscan_ram_rddis_b,
   fscan_ram_odis_b,
   fsta_afd_en,
   fsta_dfxact_afd,
   fdfx_earlyboot_exit,
   `HQM_DEVTLB_CUSTOM_RF_PORTLIST
   `HQM_DEVTLB_CUSTOM_MISCRF_PORTLIST
   
   xreqs_active,
   invreqs_active,
   tlb_reset_active,

   implicit_invalidation_valid,
   implicit_invalidation_bdf,
   implicit_invalidation_bdf_valid,
   //=========================================================================================================
   //
   // Host Interface (Upstream Request or downstream completion to/from Host interface, i.e IOSF)
   //
   //=========================================================================================================
   
    //ATS REQ
    atsreq_valid,
    atsreq_id,
    atsreq_address,
    atsreq_bdf,
    atsreq_pasid,
    atsreq_pasid_priv,
    atsreq_pasid_valid,
    atsreq_tc,
    atsreq_nw,
    atsreq_ack,

    //ATS RSP
    atsrsp_valid, 
    atsrsp_id,
    atsrsp_dperror,
    atsrsp_hdrerror,
    atsrsp_data,
   
   //=========================================================================================================
   //
   // Message interface to/from hosting unit
   //
   //=========================================================================================================
   rx_msg_valid,
   rx_msg_opcode,
   rx_msg_pasid_valid,
   rx_msg_pasid_priv,
   rx_msg_pasid,
   rx_msg_dw2,
   rx_msg_data,
   rx_msg_dperror,
   rx_msg_invreq_itag,
   rx_msg_invreq_reqid,

   tx_msg_valid,
   tx_msg_ack,
   tx_msg_opcode,
   tx_msg_bdf,
   tx_msg_pasid_valid,
   tx_msg_pasid_priv,
   tx_msg_pasid,
   tx_msg_dw2,
   tx_msg_dw3,
   tx_msg_tc,

   //=========================================================================================================
   //
   //
   // Drain interface to/from hosting unit (due to TLB Invalidation Request)
   //
   //=========================================================================================================
   drainreq_valid,
   drainreq_ack,
   drainreq_pasid,
   drainreq_pasid_priv,
   drainreq_pasid_valid,
   drainreq_pasid_global,
   drainreq_bdf,
   drainrsp_valid,
   drainrsp_tc,

   //=========================================================================================================
   //
   // Primary interface to/from hosting unit
   //
   //=========================================================================================================
   xreq_valid,
   xreq_id,
   xreq_tlbid,
   xreq_priority,
   xreq_address,
   xreq_bdf,
   xreq_pasid,
   xreq_pasid_priv,
   xreq_pasid_valid,
   xreq_prs,
   xreq_opcode,
   xreq_tc,
   //xreq_overflow,

   xreq_lcrd_inc,
   xreq_hcrd_inc,

   xrsp_valid,
   xrsp_id,
   xrsp_result,
   xrsp_address,
//   xrsp_u,
//   xrsp_perm,
   xrsp_nonsnooped,
   xrsp_prs_code,
   xrsp_dperror,
   xrsp_hdrerror,
   
   // Defeature Interface
   defeature_misc_dis,
   defeature_pwrdwn_ovrd_dis,  
   defeature_parity_injection, 
   
   //Configuration
   scr_loxreq_gcnt,
   scr_hixreq_gcnt,
   scr_pendq_gcnt,
   scr_fill_gcnt,
   scr_prs_continuous_retry,
   scr_disable_prs,
   scr_disable_2m,
   scr_disable_1g,
   scr_spare,

   PRSSTS_stopped,
   PRSSTS_uprgi,
   PRSSTS_rf,
   PRSREQALLOC_alloc,
//   PRSREQALLOC_cap,

   // parity error outputs
   tlb_tag_parity_err,
   tlb_data_parity_err,

   debugbus
//lintra +68099
