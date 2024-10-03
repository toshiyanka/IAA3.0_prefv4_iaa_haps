//======================================================================================================================
//
// iommu.sv
//
// Contacts            : Hai Ming Khor
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//======================================================================================================================

`ifndef HQM_DEVTLB_VS
`define HQM_DEVTLB_VS

// Translate general SVA_OFF to DEVTLB-specific SVA_OFF
//
`ifdef SVA_OFF
`define HQM_DEVTLB_SVA_OFF
`define HQM_DEVTLB_IFC_SVA_OFF
`else
    `ifndef HQM_DEVTLB_COVER_EN
    `define HQM_DEVTLB_COVER_EN
    `endif
`endif

// Convert intel_simonly to local iommu version
`ifdef INTEL_SIMONLY
`ifndef HQM_DEVTLB_SIMONLY
`define HQM_DEVTLB_SIMONLY
`endif
`endif

// Convert vcssim to local iommu version
`ifdef VCSSIM
`ifndef HQM_DEVTLB_SIMONLY
`define HQM_DEVTLB_SIMONLY
`endif
`endif

   `include "hqm_devtlb_map.sv"
   `include "hqm_devtlb_macros.vh"
   `ifdef HQM_DEVTLB_EXT_RF_EN 
      `include "hqm_devtlb_custom_rf_ext_macros.vh"
   `endif
   `ifdef HQM_DEVTLB_EXT_MISCRF_EN 
      `include "hqm_devtlb_custom_miscrf_ext_macros.vh"
   `endif
   `include "hqm_devtlb_customer_defines.vh"   // File for defines that we expect customers to change

`include "hqm_devtlb_intel_checkers.sv"        // Assert/Cover Defines, Functions, Properties
`include "hqm_devtlb_intel_checkers_ext_cy.sv" // Assert/Cover Creg Files. Defines


// Sub-module includes
//
`include "hqm_devtlb_reset_ctrl.sv"
`include "hqm_devtlb_cb.sv"
`include "hqm_devtlb_iotlb_arb.sv"
`include "hqm_devtlb_tlb.sv"
`include "hqm_devtlb_plru.sv"
`include "hqm_devtlb_slru.sv"
`include "hqm_devtlb_tlb_array.sv"
`include "hqm_devtlb_invif.sv"
`include "hqm_devtlb_inv.sv"
`include "hqm_devtlb_fifo.sv"
`include "hqm_devtlb_rrarbd.sv"
`include "hqm_devtlb_rrarbdgpr.sv"
`include "hqm_devtlb_msproc.sv"
`include "hqm_devtlb_mstrk.sv"
`include "hqm_devtlb_pendq.sv"
`include "hqm_devtlb_misc_array.sv"
`include "hqm_devtlb_result.sv"

`include "hqm_devtlb_custom_rf_wrap.sv"

module hqm_devtlb 
(
`include "hqm_devtlb.ports.vh"
);

   `include "hqm_devtlb_globals_int.vh"        // Common Parameters that are not used by parent hierarchies
   `include "hqm_devtlb_params.vh"
   `include "hqm_devtlb_globals_ext.vh"        // Common Parameters that may be used by parent hierarchies
   `include "hqm_devtlb_types.vh"              // Structure, Enum, Union Definitions
   `HQM_DEVTLB_CUSTOM_RF_PARAMDEC

parameter logic DEVTLB_IN_FPV = 1'b0;

genvar g_port;
genvar g_id;
genvar g_ps;

logic                               reset0_INST;      // Version of reset for use in SVA's only (used in isknown block)
logic                               reset1_INST;      // Version of reset for use in SVA's only (used in isknown block)
logic                               reset_INST;       // Version of reset for use in SVA's only (used in isknown block)
logic                               reset;      // Reset the Unit
logic                               nonflreset; // Non Func Level reset.

`include "hqm_devtlb.ifc.vh"

always_comb begin
    reset = flreset;
    nonflreset = full_reset;
end

`include "hqm_devtlb.ifc.isknown.va"

`include "hqm_devtlb_cust_params.vh"


//======================================================================================================================
//                                            Internal signal declarations
//======================================================================================================================
//

t_devtlb_request      [DEVTLB_XREQ_PORTNUM-1:0]              IodtlbReq_1nnH;   // Request Data from primary inputs packed into a structure

logic                 [DEVTLB_XREQ_PORTNUM-1:0]              ActivityOnNZWrPorts_nnnH;
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              IodtlbEmpty_nnnH; // IOMMU tlbarb is idle (empty)
logic                                                     InvalBlkTailInt_nnnH;
//logic                 [DEVTLB_XREQ_PORTNUM-1:0]              FillGntBlk_nnnH;

//from Arb to TLB
//Arb input
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              CbLoPipeV_100H;   // Request valid from credit buffer to TLB arbiter
t_devtlb_request      [DEVTLB_XREQ_PORTNUM-1:0]              CbLoReq_100H;     // Request Data from credit buffer to TLB arbiter
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              CbLoGnt_100H;     // Grant from TLB arbiter to credit buffer
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              CbHiPipeV_100H;   // Request valid from credit buffer to TLB arbiter
t_devtlb_request      [DEVTLB_XREQ_PORTNUM-1:0]              CbHiReq_100H;     // Request Data from credit buffer to TLB arbiter
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              CbHiGnt_100H;     // Grant from TLB arbiter to credit buffer
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              PendQPipeV_100H;
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              PendQForceXRsp_100H;
logic                 [DEVTLB_XREQ_PORTNUM-1:0][1:0]         PendQPrsCode_100H;
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              PendQDPErr_100H;
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              PendQHdrErr_100H;
t_devtlb_request      [DEVTLB_XREQ_PORTNUM-1:0]              PendQReq_100H;
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              PendQGnt_100H;

logic                 [DEVTLB_XREQ_PORTNUM-1:0]              FillPipeV_100H;  // Request from Fill
t_devtlb_request      [DEVTLB_XREQ_PORTNUM-1:0]              FillReq_100H;
t_devtlb_request_ctrl [DEVTLB_XREQ_PORTNUM-1:0]              FillCtrl_100H;
t_devtlb_request_info [DEVTLB_XREQ_PORTNUM-1:0]              FillInfo_100H;
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              FillGnt_100H;

localparam logic FWDPROG_EN = 1'b1;
localparam int MISSCH_NUM = FWDPROG_EN? 2:1;
localparam int TLB_ALIASING [DEVTLB_TLB_NUM_ARRAYS:0][5:0] = DEVTLB_TLB_ALIASING;
localparam logic TLB_SHARE_EN = DEVTLB_TLB_SHARE_EN;

logic [DEVTLB_XREQ_PORTNUM-1:0][MISSCH_NUM-1:0]              RespCrdRet;      //
logic [DEVTLB_XREQ_PORTNUM-1:0][MISSCH_NUM-1:0]              MsfifoCrdRet;
logic [DEVTLB_XREQ_PORTNUM-1:0][MISSCH_NUM-1:0]              MsFifoReqAvail, MsFifoReqGet;
t_devtlb_procreq [DEVTLB_XREQ_PORTNUM-1:0][MISSCH_NUM-1:0]   MsFifoProcReq;

logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_INTERNAL_REQ_ID_WIDTH-1:0] inst_devtlb_id; // INSTRUMENTATION ID used to uniquify IOMMU requests

// From ARB to TLB
//
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              ArbPipeV_101H;    // Request valid from TLB arbiter
t_devtlb_request      [DEVTLB_XREQ_PORTNUM-1:0]              ArbReq_101H;      // Original Request
t_devtlb_request_ctrl [DEVTLB_XREQ_PORTNUM-1:0]              ArbCtrl_101H;     // Request Control from TLB arbiter to TLB
t_devtlb_request_info [DEVTLB_XREQ_PORTNUM-1:0]              ArbInfo_101H;     // Request Info from Arb to TLB

// From TLB to output
//
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              TLBOutPipeV_nnnH; // TLB output to Pw is active
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              TLBOutXRspV_nnnH;
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              TLBOutMsProcV_nnnH;
t_devtlb_request      [DEVTLB_XREQ_PORTNUM-1:0]              TLBOutReq_nnnH;   // Original Request
t_devtlb_request_ctrl [DEVTLB_XREQ_PORTNUM-1:0]              TLBOutCtrl_nnnH;  // Request Control from TLB to Pw
t_devtlb_request_info [DEVTLB_XREQ_PORTNUM-1:0]              TLBOutInfo_nnnH;  // Request Info from TLB to Pw

logic                 [DEVTLB_XREQ_PORTNUM-1:0]              TLBOutInvTail_nnH; // INV in End of pipe
// From TLB
//
t_devtlb_cr_parity_err [DEVTLB_XREQ_PORTNUM-1:0]             IOTLBParityErr_1nnH;   // parity error coming from IOTLB

// From Inv to TLB Arb
//
logic                                                        InvInitDone;
logic                                                        InvBlockDMA, InvBlockFill;
logic                  [DEVTLB_XREQ_PORTNUM-1:0]             InvPipeV_100H;  // Inv output to TLB Arb is active
t_devtlb_request       [DEVTLB_XREQ_PORTNUM-1:0]             InvReq_100H;       // Synthesized Original Request
t_devtlb_request_ctrl  [DEVTLB_XREQ_PORTNUM-1:0]             InvCtrl_100H;      // Request Control from Inv to TLB
t_devtlb_request_info  [DEVTLB_XREQ_PORTNUM-1:0]             InvInfo_100H;      // Request Info  from Inv to TLB
logic                 [DEVTLB_XREQ_PORTNUM-1:0]              InvGnt_100H;

logic                                                        InvPipeIntV_100H;
t_devtlb_request                                             InvReqInt_100H;    // Synthesized Original Request
t_devtlb_request_ctrl                                        InvCtrlInt_100H;   // Request Control from Inv to TLB
t_devtlb_request_info                                        InvInfoInt_100H;   // Request Info  from Inv to TLB

//TLB Access signals
//
logic                           [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Tag_RdEn_Spec;
logic                           [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Tag_RdEn;
t_devtlb_tlb_setaddr            [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Tag_Rd_Addr;
t_devtlb_iotlb_4k_tag_entry     [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_TLB_NUM_WAYS-1:0] DEVTLB_Tag_Rd_Data;
logic                           [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Tag_WrEn;
t_devtlb_tlb_setaddr            [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Tag_Wr_Addr;
t_tlb_bitperway                 [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Tag_Wr_Way;
t_devtlb_iotlb_4k_tag_entry     [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Tag_Wr_Data;

logic                           [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Data_RdEn_Spec;
logic                           [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Data_RdEn;
t_devtlb_tlb_setaddr            [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Data_Rd_Addr;
t_devtlb_iotlb_4k_data_entry    [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_TLB_NUM_WAYS-1:0] DEVTLB_Data_Rd_Data;
logic                           [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Data_WrEn;
t_devtlb_tlb_setaddr            [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Data_Wr_Addr;
t_tlb_bitperway                 [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Data_Wr_Way;
t_devtlb_iotlb_4k_data_entry    [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                     DEVTLB_Data_Wr_Data;

//LRU Access signals
//
logic                   [DEVTLB_XREQ_PORTNUM-1:0]                                                        DEVTLB_LRU_RdEn_Spec;
logic                   [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                             DEVTLB_LRU_RdEn;
t_devtlb_tlb_setaddr    [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                             DEVTLB_LRU_Rd_SetAddr;
logic                   [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                             DEVTLB_LRU_Rd_Invert;
logic                   [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_TLB_NUM_WAYS-1:0]         DEVTLB_LRU_Rd_WayVec;
logic                   [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_TLB_NUM_WAYS-1:0]         DEVTLB_LRU_Rd_Way2ndVec;
logic                   [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                             DEVTLB_LRU_WrEn;
t_devtlb_tlb_setaddr    [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                             DEVTLB_LRU_Wr_SetAddr;
t_tlb_bitperway         [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                             DEVTLB_LRU_Wr_HitVec;
t_tlb_bitperway         [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN]                             DEVTLB_LRU_Wr_RepVec;
logic                   [DEVTLB_XREQ_PORTNUM-1:0][IOTLB_PS_MAX:IOTLB_PS_MIN][1:0]                        LRUDisable_Ways;

logic                                              [DEVTLB_XREQ_PORTNUM-1:0]                             tmpDEVTLB_LRU_RdEn_Spec;
logic                   [IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_XREQ_PORTNUM-1:0]                             tmpDEVTLB_LRU_RdEn;
t_devtlb_tlb_setaddr    [IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_XREQ_PORTNUM-1:0]                             tmpDEVTLB_LRU_Rd_SetAddr;
logic                   [IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_XREQ_PORTNUM-1:0]                             tmpDEVTLB_LRU_Rd_Invert;
logic                   [IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]         tmpDEVTLB_LRU_Rd_WayVec;
logic                   [IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]         tmpDEVTLB_LRU_Rd_Way2ndVec;
logic                   [IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_XREQ_PORTNUM-1:0]                             tmpDEVTLB_LRU_WrEn;
t_devtlb_tlb_setaddr    [IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_XREQ_PORTNUM-1:0]                             tmpDEVTLB_LRU_Wr_SetAddr;
t_tlb_bitperway         [IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_XREQ_PORTNUM-1:0]                             tmpDEVTLB_LRU_Wr_HitVec;
t_tlb_bitperway         [IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_XREQ_PORTNUM-1:0]                             tmpDEVTLB_LRU_Wr_RepVec;
logic                   [IOTLB_PS_MAX:IOTLB_PS_MIN][DEVTLB_XREQ_PORTNUM-1:0][1:0]                        tmpLRUDisable_Ways;

// Defeature CR registers
//
t_devtlb_cr_misc_dis_defeature          CrMiscDis_nnnH;      // Misc defeature register
t_devtlb_cr_spare_defeature             CrSpareDis_nnnH;     // Spare deteature register
t_devtlb_cr_pwrdwn_ovrd_dis_defeature   CrPdoDis_nnnH;       // Powerdown override defeature register
t_devtlb_cr_parity_err                  CrParErrInj_nnnH;    // Parity error injection defeature register
logic [IOTLB_PS_MAX:IOTLB_PS_MIN]       CrTLBPsDis;
logic                                   CrSFwdProg;
logic                                   CrTMaxATSReqEn;
logic [8:0]                             CrTMaxATSReq;

//----------------------------------------------------------------------------------------------------------------------

logic                                     local_reset;         // Version of reset that is muxed with DFT reset controls
logic                                     local_nonflreset;   // Version of nonflreset that is muxed with DFT reset controls

logic                                     dfx_array_scan_mode_en;    // DFX: Force all iommu latch based arrays into loopback scanmode
logic [7:0]                               dfx_array_scan_mode_way;   // DFX: Select the way to be made available to the loopback mux


//======================================================================================================================
//  Register File Connectivity...used only when custom RFs are enabled
//======================================================================================================================

   // IOTLB 4k
   logic [DEVTLB_XREQ_PORTNUM-1:0]                                               RF_IOTLB_4k_Tag_RdEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[0])-1:0]      RF_IOTLB_4k_Tag_RdAddr;
   t_devtlb_iotlb_4k_tag_entry  [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]    RF_IOTLB_4k_Tag_RdData;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                          RF_IOTLB_4k_Tag_WrEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[0])-1:0]      RF_IOTLB_4k_Tag_WrAddr;
   t_devtlb_iotlb_4k_tag_entry  [DEVTLB_XREQ_PORTNUM-1:0]                        RF_IOTLB_4k_Tag_WrData;

   logic [DEVTLB_XREQ_PORTNUM-1:0]                                               RF_IOTLB_4k_Data_RdEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[0])-1:0]      RF_IOTLB_4k_Data_RdAddr;
   t_devtlb_iotlb_4k_data_entry [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]    RF_IOTLB_4k_Data_RdData;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                          RF_IOTLB_4k_Data_WrEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[0])-1:0]      RF_IOTLB_4k_Data_WrAddr;
   t_devtlb_iotlb_4k_data_entry [DEVTLB_XREQ_PORTNUM-1:0]                        RF_IOTLB_4k_Data_WrData;

   // IOTLB 2m
   logic [DEVTLB_XREQ_PORTNUM-1:0]                                               RF_IOTLB_2m_Tag_RdEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[1])-1:0]      RF_IOTLB_2m_Tag_RdAddr;
   t_devtlb_iotlb_2m_tag_entry  [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]    RF_IOTLB_2m_Tag_RdData;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                          RF_IOTLB_2m_Tag_WrEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[1])-1:0]      RF_IOTLB_2m_Tag_WrAddr;
   t_devtlb_iotlb_2m_tag_entry  [DEVTLB_XREQ_PORTNUM-1:0]                        RF_IOTLB_2m_Tag_WrData;

   logic [DEVTLB_XREQ_PORTNUM-1:0]                                               RF_IOTLB_2m_Data_RdEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[1])-1:0]      RF_IOTLB_2m_Data_RdAddr;
   t_devtlb_iotlb_2m_data_entry [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]    RF_IOTLB_2m_Data_RdData;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                          RF_IOTLB_2m_Data_WrEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[1])-1:0]      RF_IOTLB_2m_Data_WrAddr;
   t_devtlb_iotlb_2m_data_entry [DEVTLB_XREQ_PORTNUM-1:0]                        RF_IOTLB_2m_Data_WrData;

   // IOTLB 1g
   logic [DEVTLB_XREQ_PORTNUM-1:0]                                               RF_IOTLB_1g_Tag_RdEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[2])-1:0]      RF_IOTLB_1g_Tag_RdAddr;
   t_devtlb_iotlb_1g_tag_entry  [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]    RF_IOTLB_1g_Tag_RdData;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                          RF_IOTLB_1g_Tag_WrEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[2])-1:0]      RF_IOTLB_1g_Tag_WrAddr;
   t_devtlb_iotlb_1g_tag_entry  [DEVTLB_XREQ_PORTNUM-1:0]                        RF_IOTLB_1g_Tag_WrData;

   logic [DEVTLB_XREQ_PORTNUM-1:0]                                               RF_IOTLB_1g_Data_RdEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[2])-1:0]      RF_IOTLB_1g_Data_RdAddr;
   t_devtlb_iotlb_1g_data_entry [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]    RF_IOTLB_1g_Data_RdData;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                          RF_IOTLB_1g_Data_WrEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[2])-1:0]      RF_IOTLB_1g_Data_WrAddr;
   t_devtlb_iotlb_1g_data_entry [DEVTLB_XREQ_PORTNUM-1:0]                        RF_IOTLB_1g_Data_WrData;

   // IOTLB 5t
   logic [DEVTLB_XREQ_PORTNUM-1:0]                                               RF_IOTLB_5t_Tag_RdEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[3])-1:0]      RF_IOTLB_5t_Tag_RdAddr;
   t_devtlb_iotlb_5t_tag_entry  [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]    RF_IOTLB_5t_Tag_RdData;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                          RF_IOTLB_5t_Tag_WrEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[3])-1:0]      RF_IOTLB_5t_Tag_WrAddr;
   t_devtlb_iotlb_5t_tag_entry  [DEVTLB_XREQ_PORTNUM-1:0]                        RF_IOTLB_5t_Tag_WrData;

   logic [DEVTLB_XREQ_PORTNUM-1:0]                                               RF_IOTLB_5t_Data_RdEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[3])-1:0]      RF_IOTLB_5t_Data_RdAddr;
   t_devtlb_iotlb_5t_data_entry [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]    RF_IOTLB_5t_Data_RdData;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                          RF_IOTLB_5t_Data_WrEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[3])-1:0]      RF_IOTLB_5t_Data_WrAddr;
   t_devtlb_iotlb_5t_data_entry [DEVTLB_XREQ_PORTNUM-1:0]                        RF_IOTLB_5t_Data_WrData;

   // IOTLB Qp
   logic [DEVTLB_XREQ_PORTNUM-1:0]                                               RF_IOTLB_Qp_Tag_RdEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[4])-1:0]      RF_IOTLB_Qp_Tag_RdAddr;
   t_devtlb_iotlb_Qp_tag_entry  [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]    RF_IOTLB_Qp_Tag_RdData;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                          RF_IOTLB_Qp_Tag_WrEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[4])-1:0]      RF_IOTLB_Qp_Tag_WrAddr;
   t_devtlb_iotlb_Qp_tag_entry  [DEVTLB_XREQ_PORTNUM-1:0]                        RF_IOTLB_Qp_Tag_WrData;

   logic [DEVTLB_XREQ_PORTNUM-1:0]                                               RF_IOTLB_Qp_Data_RdEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[4])-1:0]      RF_IOTLB_Qp_Data_RdAddr;
   t_devtlb_iotlb_Qp_data_entry [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]    RF_IOTLB_Qp_Data_RdData;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                          RF_IOTLB_Qp_Data_WrEn;
   logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[4])-1:0]      RF_IOTLB_Qp_Data_WrAddr;
   t_devtlb_iotlb_Qp_data_entry [DEVTLB_XREQ_PORTNUM-1:0]                        RF_IOTLB_Qp_Data_WrData;

   logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_STATUS_WIDTH-1:0]                       resp_status;

`ifndef IODTLB_REMOVE_1_0
   //Input
   // Primary Request
   //logic [DEVTLB_XREQ_PORTNUM-1:0]                                               xreq_overflow;        //
   logic [DEVTLB_XREQ_PORTNUM-1:0]                                               xreq_pasid_er;        // Req w/ PASID is Execute Request
   
   //Output
   // Primary Request
   // Primary Response
   logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLBID_WIDTH-1:0]                            xrsp_tlbid;           // TLBid
   logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_REQ_OPCODE_WIDTH-1:0]                        xrsp_opcode;          // Customer intended use for translated address
   logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_MEMTYPE_WIDTH-1:0]                          xrsp_memtype;        // Memory type of the resulting HPA // lintra s-70036
   logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_PRIV_DATA_WIDTH-1:0]                        xrsp_privdata;      // Privated data stored in DEVTLB  // lintra s-70036
   logic [DEVTLB_XREQ_PORTNUM-1:0]                                                    xrsp_ep;             // Execute Permission // lintra s-70036
   logic [DEVTLB_XREQ_PORTNUM-1:0]                                                    xrsp_pa;             // Privileged/Supervisor access Permission // lintra s-70036
   logic [DEVTLB_XREQ_PORTNUM-1:0]                                                    xrsp_global;         // Global entry  // lintra s-70036
   logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 xrsp_w;               // write permission
   logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 xrsp_r;               // read premission
   logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 xrsp_u;               // read premission
//   logic [DEVTLB_XREQ_PORTNUM-1:0]                                               xrsp_nonsnooped;               // read premission
   logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 xrsp_perm;               // read premission
   //logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_RESP_PAYLOAD_MSB:DEVTLB_RESP_PAYLOAD_LSB]   xrsp_payload;        // If DMA : HPA[61:12] ;  0xC0 when fault ;  GPA[61:12] on TLB miss when used as a remote TLB; 
                                                                                                                 // Interrupt : { APIC_ID[31:0],  RH, DstM ,  TM, TML(=1), 3'b0, DelM[2:0], Vector[7:0] } ; 
                                                                                                                 // Machines supporting 27bit of APIC Id can choose to drop upper 5 bits 
   logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_RESP_PGSIZE_WIDTH-1:0]                      xrsp_pagesize;       // Page Size  // lintra s-70036
`endif //IODTLB_REMOVE_1_0

//======================================================================================================================
//                                                 Strap Declaration & Assignments
//======================================================================================================================

//======================================================================================================================
//   Temporary Tie OFF
//======================================================================================================================
logic [DEVTLB_XREQ_PORTNUM-1:0]                                                    ObsIotlbLkpValid_nnnH;       // IOTLB any lookup valid
logic [DEVTLB_XREQ_PORTNUM-1:0][7:0]                                               ObsIotlbOrgReqID_nnnH;   // IOTLB original lookup id
logic [DEVTLB_XREQ_PORTNUM-1:0][7:0]                                               ObsIotlbID_nnnH;             // IOTLB id
logic [DEVTLB_XREQ_PORTNUM-1:0][2:0]                                               ObsIotlbOrgHitVec_nnnH;      // IOTLB original hit vector
logic [DEVTLB_XREQ_PORTNUM-1:0]                                                    ObsIotlbInvValid_nnnH;      // IOTLB inv valid
logic [DEVTLB_XREQ_PORTNUM-1:0][2:0]                                               ObsIotlbReqPageSize_nnnH;    // IOTLB requested page size
logic [DEVTLB_XREQ_PORTNUM-1:0][2:0]                                               ObsIotlbFilledPageSize_nnnH; // IOTLB filled page size
logic [DEVTLB_XREQ_PORTNUM-1:0][1:0]                                               ObsIotlbMisc_nnnH;
   //VISA signals from invalidation engine
   //
logic [2:0]                                                                     ObsIotlbInvPs_nnnH;
logic [2:0]                                                                     ObsIotlbInvBusy_nnnH;
logic                                                                           ObsIotlbGlbInProg_nnnH;      // IOTLB global invalidation in progress
logic                                                                           ObsIotlbPgSInProg_nnnH;      // IOTLB domain invalidation in progress

always_comb begin
//==================================================================================================================
   //
   // Drain interface to/from hosting unit (due to TLB Invalidation Request)
   //
   //==================================================================================================================
   //IOT
`ifndef IODTLB_REMOVE_1_0
   xreq_pasid_er = '0;
`endif //  IODTLB_REMOVE_1_0

end

//======================================================================================================================
//                                           FPV Interface Assumptions

//======================================================================================================================
//======================================================================================================================

// FPV interface assumption file
//   If we are running the FPV environment, we directly include iommu_env_ifc.va in the top fpv file,
//   so ignore the instantiation in the RTL
//
//    If the FPV Reference Model for Dynamic is turned off, turn on the assumption file so that there is some checking
//    unless the assumptions really need to be turned off.
//
`ifndef INTEL_EMULATION
`ifndef HQM_DEVTLB_IFC_SVA_OFF
   // Anthing to Enable FPV should be here.
   // `include "devtlb_env_ifc.va"
    `ifndef LINT_ON 
       `ifdef HQM_DEVTLB_SIMONLY
        always_comb          inst_devtlb_id = '0;
       `endif //DEVTLB_SIMONLY
    `endif //LINT_ON
`endif
`endif

//======================================================================================================================
// This block is temporary to resolve lint violations related to new I/Os.
//======================================================================================================================

//assign device_tlb_en = '0; // FIXME: cdpanirw(16ww05): Do we still need this here?


//======================================================================================================================
//                                                 Input assignments
//======================================================================================================================

logic ClkFreeRcb_H;
`HQM_DEVTLB_MAKE_RCB_PH1(ClkFreeRcb_H, clk,          1'b1, 1'b1)

logic ClkFree_H;
`HQM_DEVTLB_MAKE_LCB_PWR(ClkFree_H,    ClkFreeRcb_H, 1'b1, 1'b1)

   hqm_devtlb_reset_ctrl devtlb_reset_ctrl  (
      `HQM_DEVTLB_COMMON_PORTCON
      `HQM_DEVTLB_FSCAN_PORTCON
      .nonflreset                   (nonflreset),
      .local_reset_out              (local_reset),
      .local_nonflreset_out         (local_nonflreset)
   );

   // Create instrumentation reset for use in SVAs only
   // Add one more cycle of reset for SVAs (assertions and covers) to avoid application during init window
   //
   assign reset0_INST = reset | local_reset;
`ifndef HQM_DEVTLB_SVA_OFF
   `HQM_DEVTLB_ARST_MSFF(reset1_INST, reset0_INST, clk, reset)
`else  //DEVTLB_SVA_OFF
   assign reset1_INST = 1'b0;
`endif //DEVTLB_SVA_OFF
   assign reset_INST = reset0_INST | reset1_INST;


localparam logic SFWDPROG_EN = 1'b1;

always_comb begin: Input_Assigments
    // Defeature bus assignment
    //
    CrMiscDis_nnnH      = defeature_misc_dis;
    CrSpareDis_nnnH     = scr_spare;
    CrSFwdProg          = SFWDPROG_EN && ~CrSpareDis_nnnH[6];
    CrTMaxATSReqEn      = CrSpareDis_nnnH[5];
    CrTMaxATSReq        = {CrSpareDis_nnnH[4:0], 4'h0};
    CrPdoDis_nnnH       = defeature_pwrdwn_ovrd_dis | {DEVTLB_DEFEATURE_REG_WIDTH{local_reset}};
    CrParErrInj_nnnH    = DEVTLB_PARITY_EN? defeature_parity_injection: '0;
    CrTLBPsDis          = {scr_disable_1g, scr_disable_2m, 1'b0};

    IodtlbReq_1nnH          = '0;

    for (int port_id = PORT_0; port_id < DEVTLB_XREQ_PORTNUM; port_id++) begin: REQ_NUM_PORTS
        // Assign inputs to internal request structure
        //
        IodtlbReq_1nnH[port_id].PortId   = port_id[DEVTLB_PORTS_IDW-1:0];
        IodtlbReq_1nnH[port_id].tc       = xreq_tc[port_id];
        IodtlbReq_1nnH[port_id].Prs      = DEVTLB_PRS_SUPP_EN && xreq_prs[port_id];
        IodtlbReq_1nnH[port_id].Priority = xreq_priority[port_id];
        IodtlbReq_1nnH[port_id].MPrior   = xreq_priority[port_id] && CrSFwdProg;
        IodtlbReq_1nnH[port_id].ID       = xreq_id[port_id];
        IodtlbReq_1nnH[port_id].PASID    = {$bits(xreq_pasid[port_id]){DEVTLB_PASID_SUPP_EN && xreq_pasid_valid[port_id]}} & xreq_pasid[port_id];
        IodtlbReq_1nnH[port_id].PasidV   = DEVTLB_PASID_SUPP_EN && xreq_pasid_valid[port_id];
//        IodtlbReq_1nnH[port_id].ER       = DEVTLB_PASID_SUPP_EN & xreq_pasid_er[port_id];
        IodtlbReq_1nnH[port_id].PR       = DEVTLB_PASID_SUPP_EN && xreq_pasid_valid[port_id] && xreq_pasid_priv[port_id];
        IodtlbReq_1nnH[port_id].BDF      = DEVTLB_BDF_SUPP_EN? xreq_bdf[port_id]: '0;
        IodtlbReq_1nnH[port_id].TlbId    = xreq_tlbid[port_id];
        IodtlbReq_1nnH[port_id].Address  = xreq_address[port_id];

        case (xreq_opcode[port_id][1:0])
            2'b00: IodtlbReq_1nnH[port_id].Opcode   = DEVTLB_OPCODE_UTRN_W;
            2'b01: IodtlbReq_1nnH[port_id].Opcode   = DEVTLB_OPCODE_UTRN_R;
            2'b10: IodtlbReq_1nnH[port_id].Opcode   = DEVTLB_OPCODE_UARCH_INV;
            2'b11: IodtlbReq_1nnH[port_id].Opcode   = DEVTLB_OPCODE_UARCH_INV;
            default: IodtlbReq_1nnH[port_id].Opcode= DEVTLB_OPCODE_UARCH_INV;
        endcase

     // INSTRUMENTATION LOGIC: FPV assumptions sets up unique IOMMU ID association for each request
      `ifndef HQM_DEVTLB_SIMONLY
         inst_devtlb_id[port_id] = '0;
      `endif
      `ifdef HQM_DEVTLB_IFC_SVA_OFF
         inst_devtlb_id[port_id] = '0;
      `endif
      `ifdef LINT_ON
         inst_devtlb_id[port_id] = '0;
      `endif
      `ifdef  HQM_DEVTLB_SIMONLY
         IodtlbReq_1nnH[port_id].i_ID  = inst_devtlb_id[port_id];
      `endif
    end
end: Input_Assigments

   // These are the MSFF's that need to be set to force the arrays into scan mode.
   //
   // This mode will make the write data staging flops take the loopback data from
   // the array's output from array way specified.
   //
   `HQM_DEVTLB_MSFF(dfx_array_scan_mode_en,    CrMiscDis_nnnH.dfx_array_scan_mode_en,     ClkFree_H)
   `HQM_DEVTLB_MSFF(dfx_array_scan_mode_way,   CrMiscDis_nnnH.dfx_array_scan_mode_way,    ClkFree_H)


//======================================================================================================================
//                                                   Credit Buffer
//======================================================================================================================
generate
    for (g_id = PORT_0; g_id < DEVTLB_XREQ_PORTNUM; g_id++) begin: CB_NUM_PORTS
        hqm_devtlb_cb #(
           .MAX_GUEST_ADDRESS_WIDTH(DEVTLB_MAX_GUEST_ADDRESS_WIDTH),
           .REQ_PAYLOAD_MSB        (DEVTLB_REQ_PAYLOAD_MSB),
           .DEVTLB_PORT_ID         (g_id),
           .CB_DEPTH               (DEVTLB_LCB_DEPTH),
           .T_REQ                  (t_devtlb_request),
           `HQM_DEVTLB_PARAM_PORTCON
         )devtlb_lcb (
              `HQM_DEVTLB_COMMON_PORTCON_W_SYNC_RESET
              `HQM_DEVTLB_FSCAN_PORTCON
              .PwrDnOvrd_nnnH      (CrPdoDis_nnnH.pdo_cb),
              .DeftrStallCBFifo    (CrMiscDis_nnnH.stalllcbfifo),
              .req_valid           (xreq_valid[g_id]),
              .req_prior_match     (~IodtlbReq_1nnH[g_id].Priority),
              .IodtlbReq_1nnH      (IodtlbReq_1nnH[g_id]),
              .credit_return       (xreq_lcrd_inc[g_id]),
              .CbPipeV_100H      (CbLoPipeV_100H[g_id]),
              .CbReq_100H        (CbLoReq_100H[g_id]),
              .CbGnt_100H        (CbLoGnt_100H[g_id])
        );

        hqm_devtlb_cb #(
           .MAX_GUEST_ADDRESS_WIDTH(DEVTLB_MAX_GUEST_ADDRESS_WIDTH),
           .REQ_PAYLOAD_MSB        (DEVTLB_REQ_PAYLOAD_MSB),
           .DEVTLB_PORT_ID         (g_id),
           .CB_DEPTH               (DEVTLB_HCB_DEPTH),
           .T_REQ                  (t_devtlb_request),
           `HQM_DEVTLB_PARAM_PORTCON
       )devtlb_hcb (
              `HQM_DEVTLB_COMMON_PORTCON_W_SYNC_RESET
              `HQM_DEVTLB_FSCAN_PORTCON
              .PwrDnOvrd_nnnH      (CrPdoDis_nnnH.pdo_cb),
              .DeftrStallCBFifo    (CrMiscDis_nnnH.stallhcbfifo),
              .req_valid           (xreq_valid[g_id]),
              .req_prior_match     (IodtlbReq_1nnH[g_id].Priority),
              .IodtlbReq_1nnH      (IodtlbReq_1nnH[g_id]),
              .credit_return       (xreq_hcrd_inc[g_id]),
              .CbPipeV_100H        (CbHiPipeV_100H[g_id]),
              .CbReq_100H          (CbHiReq_100H[g_id]),
              .CbGnt_100H          (CbHiGnt_100H[g_id])
        );

    end
endgenerate

//======================================================================================================================
//                                                      IOTLB Arbiter
//======================================================================================================================
localparam logic DEVTLB_ALLOW_TLBRWCONFLICT = 1'b0;
t_devtlb_arbtlbinfo [DEVTLB_XREQ_PORTNUM-1:0]   TLBBlockArbInfo;
logic                                           devtlb_idle;
logic [1:0]                                     ObsArbRs_nnnH;
logic [IOTLB_PS_MAX:IOTLB_PS_MIN]               CrEvictOpPsDis;

always_comb begin
    devtlb_idle = ~(|IodtlbEmpty_nnnH) & ~(|ActivityOnNZWrPorts_nnnH); //TODO
    for (int tlb_ps = IOTLB_PS_MIN; tlb_ps <= IOTLB_PS_MAX; tlb_ps++) begin //todo ~xreq_evict_ps
        if (tlb_ps == `HQM_DEVTLB_PS_4K) CrEvictOpPsDis[tlb_ps] = '0; //spyglass disable AlwaysFalseTrueCond-ML
        else CrEvictOpPsDis[tlb_ps] = '1;
    end
end

generate
    for (g_id = PORT_0; g_id < DEVTLB_XREQ_PORTNUM; g_id++) begin: TLBARB_NUM_PORTS

        if (g_id == PORT_0) begin: PORTID_0
            assign InvPipeV_100H[g_id]    = InvPipeIntV_100H;
            assign InvReq_100H[g_id]      = InvReqInt_100H;
            assign InvInfo_100H[g_id]     = InvInfoInt_100H;
            assign InvCtrl_100H[g_id]     = InvCtrlInt_100H;
            //assign FillGntBlk_nnnH[g_id]  = (DEVTLB_LCB_DEPTH == -1) ? 1'b1 : 1'b0;
        end
        else begin: PORTID
            assign InvPipeV_100H[g_id]    = '0;
            assign InvReq_100H[g_id]      = '0;
            assign InvInfo_100H[g_id]     = '0;
            assign InvCtrl_100H[g_id]     = '0;
            //assign FillGntBlk_nnnH[g_id]  = (DEVTLB_LCB_DEPTH == -1) ? 1'b1 : 1'b0;
        end

        hqm_devtlb_iotlb_arb #(
              // Set parameters for the Arbiter to operate as TLBARB
              .DEVTLB_PORT_ID      (g_id),
              .FWDPROG_EN          (FWDPROG_EN),
              .ZERO_CYCLE_TLB_ARB  (DEVTLB_TLB_ZERO_CYCLE_ARB),
              .ALLOW_TLBRWCONFLICT  (DEVTLB_ALLOW_TLBRWCONFLICT),
              .MAX_GUEST_ADDRESS_WIDTH(DEVTLB_MAX_GUEST_ADDRESS_WIDTH),
              .MAX_HOST_ADDRESS_WIDTH(DEVTLB_MAX_HOST_ADDRESS_WIDTH),
              .T_TAG_ENTRY_0       (t_devtlb_iotlb_4k_tag_entry),
              .NUM_ARRAYS          (DEVTLB_TLB_NUM_ARRAYS),
              .TLBID_WIDTH         (DEVTLB_TLBID_WIDTH),
              .PS_MAX              (IOTLB_PS_MAX),
              .PS_MIN              (IOTLB_PS_MIN),
              .NUM_PS_SETS         (DEVTLB_TLB_NUM_PS_SETS),
              .NUM_SETS            (DEVTLB_TLB_NUM_SETS),
              .TLB_SHARE_EN        (DEVTLB_TLB_SHARE_EN),
              .TLB_ALIASING        (DEVTLB_TLB_ALIASING),
              .MISSFIFO_DEPTH      (DEVTLB_MISSFIFO_DEPTH),
              .T_SETADDR           (t_devtlb_tlb_setaddr),
              .T_TLBBLK_INFO       (t_devtlb_arbtlbinfo), 
              .T_REQ               (t_devtlb_request),
              .T_REQ_CTRL          (t_devtlb_request_ctrl),
              .T_REQ_INFO          (t_devtlb_request_info),
              .T_OPCODE            (t_devtlb_opcode),
              .T_PGSIZE            (t_devtlb_page_type),
              `HQM_DEVTLB_PARAM_PORTCON
         ) devtlb_iotlb_arb (
              `HQM_DEVTLB_COMMON_PORTCON_W_SYNC_RESET
              `HQM_DEVTLB_FSCAN_PORTCON
              .PwrDnOvrd_nnnH      (CrPdoDis_nnnH.pdo_tlbarb),
              .CrMiscDis_nnnH      (CrMiscDis_nnnH),
              .CrLoXReqGCnt        (scr_loxreq_gcnt),
              .CrHiXReqGCnt        (scr_hixreq_gcnt),
              .CrPendQGCnt         (scr_pendq_gcnt),
              .CrFillGCnt          (scr_fill_gcnt),
              .CrTLBPsDis          (CrTLBPsDis),
              .CrEvictOpPsDis      (CrEvictOpPsDis), //~xreq_evict_ps 
              .IodtlbEmpty_nnnH    (IodtlbEmpty_nnnH[g_id]),
              .TLBBlockArbInfo     (TLBBlockArbInfo[g_id]),
              .RespCrdRet          (RespCrdRet[g_id]),
              .MsfifoCrdRet         (MsfifoCrdRet[g_id]),
              .CbLoPipeV_100H      (CbLoPipeV_100H[g_id]),
              .CbLoReq_100H        (CbLoReq_100H[g_id]),
              .CbLoGnt_100H        (CbLoGnt_100H[g_id]),
              .CbHiPipeV_100H      (CbHiPipeV_100H[g_id]),
              .CbHiReq_100H        (CbHiReq_100H[g_id]),
              .CbHiGnt_100H        (CbHiGnt_100H[g_id]),
              .PendQPipeV_100H     (PendQPipeV_100H[g_id]),
              .PendQForceXRsp_100H (PendQForceXRsp_100H[g_id]),
              .PendQPrsCode_100H   (PendQPrsCode_100H[g_id]),
              .PendQDPErr_100H     (PendQDPErr_100H[g_id]),
              .PendQHdrErr_100H    (PendQHdrErr_100H[g_id]),
              .PendQReq_100H       (PendQReq_100H[g_id]),
              .PendQGnt_100H       (PendQGnt_100H[g_id]),
              .InvBlockDMA         (InvBlockDMA),
              .InvPipeV_100H       (InvPipeV_100H[g_id]),
              .InvReq_100H         (InvReq_100H[g_id]),
              .InvCtrl_100H        (InvCtrl_100H[g_id]),
              .InvInfo_100H        (InvInfo_100H[g_id]),
              .InvGnt_100H         (InvGnt_100H[g_id]),
              .FillPipeV_100H      (FillPipeV_100H[g_id]),
              .FillReq_100H        (FillReq_100H[g_id]),
              .FillCtrl_100H       (FillCtrl_100H[g_id]),
              .FillInfo_100H       (FillInfo_100H[g_id]),
              .FillGnt_100H        (FillGnt_100H[g_id]),
              .IotlbArbPipeV_101H  (ArbPipeV_101H[g_id]),
              .IotlbArbReq_101H    (ArbReq_101H[g_id]),
              .IotlbArbCtrl_101H   (ArbCtrl_101H[g_id]),
              .IotlbArbInfo_101H   (ArbInfo_101H[g_id]),
              .ObsArbRs_nnnH       (ObsArbRs_nnnH)
        );
    end
assign InvalBlkTailInt_nnnH = '0; // not used

endgenerate

//======================================================================================================================
//                                                       TLB
//======================================================================================================================

// -- BDF -> ADDR+Attribute Cache : Set Associative

// Remap IOTLB disable per TLBID into PS-TLBID form
//
logic [DEVTLB_TLB_NUM_ARRAYS-1:0] [IOTLB_PS_MAX:IOTLB_PS_MIN] [1:0]  IOTLB_Disable_Ways;
always_comb begin
   IOTLB_Disable_Ways = '0;

   for (int tlb_id = 0; tlb_id < DEVTLB_TLB_NUM_ARRAYS; tlb_id++) begin  : DisWay_ID_Lp
      for (int tlb_ps = IOTLB_PS_MIN; tlb_ps <= IOTLB_PS_MAX; tlb_ps++) begin  : DisWay_PS_Lp
          // only supporting up to 10 TLBs to disable
         if (tlb_id < ($bits(CrMiscDis_nnnH.iotlbdis)/2)) begin  //spyglass disable AlwaysFalseTrueCond-ML
            IOTLB_Disable_Ways[tlb_id][tlb_ps] = CrMiscDis_nnnH.iotlbdis[(tlb_id*2)+:2];
         end
      end
   end
end


//======================================================================================================================
//                                                     Assertions
//======================================================================================================================
logic [19:0]   iotlbdisff;
logic LRUCfgChanges;
always_comb begin
    LRUCfgChanges = ~(CrMiscDis_nnnH.iotlbdis == iotlbdisff);
end

`HQM_DEVTLB_EN_MSFF(iotlbdisff, CrMiscDis_nnnH.iotlbdis,ClkFree_H,(LRUCfgChanges || local_reset))

generate
   for (g_id = PORT_0; g_id < DEVTLB_XREQ_PORTNUM; g_id++) begin: TLB_NUM_PORTS
        hqm_devtlb_tlb #(
              // Set parameters for the TLB to operate as a primary IOTLB
              .DEVTLB_IN_FPV             (DEVTLB_IN_FPV),
              .DEVTLB_PORT_ID            (g_id),
              .ZERO_CYCLE_TLB_ARB        (DEVTLB_TLB_ZERO_CYCLE_ARB),
              .ALLOW_TLBRWCONFLICT        (DEVTLB_ALLOW_TLBRWCONFLICT),
              .ARRAY_STYLE               (DEVTLB_TLB_ARRAY_STYLE),
              .LRU_STYLE                 (DEVTLB_LRU_STYLE),
              .READ_LATENCY              (DEVTLB_TLB_READ_LATENCY),
              .TLBID_WIDTH               (DEVTLB_TLBID_WIDTH),
              .NUM_ARRAYS                (DEVTLB_TLB_NUM_ARRAYS),
              .PS_MAX                    (IOTLB_PS_MAX),
              .PS_MIN                    (IOTLB_PS_MIN),
              .NUM_SETS                  (DEVTLB_TLB_NUM_SETS),
              .TLB_SHARE_EN              (DEVTLB_TLB_SHARE_EN),
              .TLB_ALIASING              (DEVTLB_TLB_ALIASING),
              .NUM_PS_SETS               (DEVTLB_TLB_NUM_PS_SETS),
              .NUM_WAYS                  (DEVTLB_TLB_NUM_WAYS),
              .MAX_GUEST_ADDRESS_WIDTH   (DEVTLB_MAX_GUEST_ADDRESS_WIDTH),
              .GAW_LAW_MAX               (DEVTLB_GAW_LAW_MAX),
              .T_SETADDR                 (t_devtlb_tlb_setaddr),
              .T_BITPERWAY               (t_tlb_bitperway),
              .T_TAG_ENTRY_0             (t_devtlb_iotlb_4k_tag_entry),
              .T_TAG_ENTRY_1             (t_devtlb_iotlb_2m_tag_entry),
              .T_TAG_ENTRY_2             (t_devtlb_iotlb_1g_tag_entry),
              .T_TAG_ENTRY_3             (t_devtlb_iotlb_5t_tag_entry),
              .T_TAG_ENTRY_4             (t_devtlb_iotlb_Qp_tag_entry),
              .T_DATA_ENTRY_0            (t_devtlb_iotlb_4k_data_entry),
              .T_DATA_ENTRY_1            (t_devtlb_iotlb_2m_data_entry),
              .T_DATA_ENTRY_2            (t_devtlb_iotlb_1g_data_entry),
              .T_DATA_ENTRY_3            (t_devtlb_iotlb_5t_data_entry),
              .T_DATA_ENTRY_4            (t_devtlb_iotlb_Qp_data_entry),
              .T_TLBBLK_INFO             (t_devtlb_arbtlbinfo), 
              .T_REQ                     (t_devtlb_request),
              .T_REQ_CTRL                (t_devtlb_request_ctrl),
              .T_REQ_INFO                (t_devtlb_request_info),
              .T_REQ_COMPLETE            (t_request_complete),
              .T_OPCODE                  (t_devtlb_opcode),
              .T_PGSIZE                  (t_devtlb_page_type),
              .T_FAULTREASON             (t_devtlb_fault_reason),
              .T_STATUS                  (t_devtlb_resp_status),
              `HQM_DEVTLB_PARAM_PORTCON
           ) devtlb_tlb (
              `HQM_DEVTLB_COMMON_PORTCON_W_SYNC_RESET
              `HQM_DEVTLB_FSCAN_PORTCON
              .PwrDnOvrd_nnnH            (CrPdoDis_nnnH.pdo_tlb),
              .addr_translation_en       ('1),
              .DisPartInv_nnnH           (CrMiscDis_nnnH.dispartinv),

              // Inputs
              .TLBPipeV_101H             (ArbPipeV_101H[g_id]),
              .TLBReq_101H               (ArbReq_101H[g_id]),
              .TLBCtrl_101H              (ArbCtrl_101H[g_id]),
              .TLBInfo_101H              (ArbInfo_101H[g_id]),

              // Outputs to Response Interface
              .TLBOutPipeV_nnnH          (TLBOutPipeV_nnnH[g_id]),
              .TLBOutXRspV_nnnH          (TLBOutXRspV_nnnH[g_id]),
              .TLBOutMsProcV_nnnH        (TLBOutMsProcV_nnnH[g_id]),
              .TLBOutReq_nnnH            (TLBOutReq_nnnH[g_id]),
              .TLBOutCtrl_nnnH           (TLBOutCtrl_nnnH[g_id]),
              .TLBOutInfo_nnnH           (TLBOutInfo_nnnH[g_id]),
              
              .TLBBlockArbInfo           (TLBBlockArbInfo[g_id]),
              .TLBOutInvTail_nnH         (TLBOutInvTail_nnH[g_id]),

              // Parity outputs to response interface
              .TLBParityErr_1nnH         (IOTLBParityErr_1nnH[g_id]),

              // RF Blackbox Controls/Outputs
              .RF_PS0_Tag_RdEn           (RF_IOTLB_4k_Tag_RdEn[g_id]),
              .RF_PS0_Tag_RdAddr         (RF_IOTLB_4k_Tag_RdAddr[g_id]),
              .RF_PS0_Tag_RdData         (RF_IOTLB_4k_Tag_RdData[g_id]),
              .RF_PS0_Tag_WrEn           (RF_IOTLB_4k_Tag_WrEn[g_id]),
              .RF_PS0_Tag_WrAddr         (RF_IOTLB_4k_Tag_WrAddr[g_id]),
              .RF_PS0_Tag_WrData         (RF_IOTLB_4k_Tag_WrData[g_id]),

              .RF_PS0_Data_RdEn          (RF_IOTLB_4k_Data_RdEn[g_id]),
              .RF_PS0_Data_RdAddr        (RF_IOTLB_4k_Data_RdAddr[g_id]),
              .RF_PS0_Data_RdData        (RF_IOTLB_4k_Data_RdData[g_id]),
              .RF_PS0_Data_WrEn          (RF_IOTLB_4k_Data_WrEn[g_id]),
              .RF_PS0_Data_WrAddr        (RF_IOTLB_4k_Data_WrAddr[g_id]),
              .RF_PS0_Data_WrData        (RF_IOTLB_4k_Data_WrData[g_id]),

              .RF_PS1_Tag_RdEn           (RF_IOTLB_2m_Tag_RdEn[g_id]),
              .RF_PS1_Tag_RdAddr         (RF_IOTLB_2m_Tag_RdAddr[g_id]),
              .RF_PS1_Tag_RdData         (RF_IOTLB_2m_Tag_RdData[g_id]),
              .RF_PS1_Tag_WrEn           (RF_IOTLB_2m_Tag_WrEn[g_id]),
              .RF_PS1_Tag_WrAddr         (RF_IOTLB_2m_Tag_WrAddr[g_id]),
              .RF_PS1_Tag_WrData         (RF_IOTLB_2m_Tag_WrData[g_id]),

              .RF_PS1_Data_RdEn          (RF_IOTLB_2m_Data_RdEn[g_id]),
              .RF_PS1_Data_RdAddr        (RF_IOTLB_2m_Data_RdAddr[g_id]),
              .RF_PS1_Data_RdData        (RF_IOTLB_2m_Data_RdData[g_id]),
              .RF_PS1_Data_WrEn          (RF_IOTLB_2m_Data_WrEn[g_id]),
              .RF_PS1_Data_WrAddr        (RF_IOTLB_2m_Data_WrAddr[g_id]),
              .RF_PS1_Data_WrData        (RF_IOTLB_2m_Data_WrData[g_id]),

              .RF_PS2_Tag_RdEn           (RF_IOTLB_1g_Tag_RdEn[g_id]),
              .RF_PS2_Tag_RdAddr         (RF_IOTLB_1g_Tag_RdAddr[g_id]),
              .RF_PS2_Tag_RdData         (RF_IOTLB_1g_Tag_RdData[g_id]),
              .RF_PS2_Tag_WrEn           (RF_IOTLB_1g_Tag_WrEn[g_id]),
              .RF_PS2_Tag_WrAddr         (RF_IOTLB_1g_Tag_WrAddr[g_id]),
              .RF_PS2_Tag_WrData         (RF_IOTLB_1g_Tag_WrData[g_id]),

              .RF_PS2_Data_RdEn          (RF_IOTLB_1g_Data_RdEn[g_id]),
              .RF_PS2_Data_RdAddr        (RF_IOTLB_1g_Data_RdAddr[g_id]),
              .RF_PS2_Data_RdData        (RF_IOTLB_1g_Data_RdData[g_id]),
              .RF_PS2_Data_WrEn          (RF_IOTLB_1g_Data_WrEn[g_id]),
              .RF_PS2_Data_WrAddr        (RF_IOTLB_1g_Data_WrAddr[g_id]),
              .RF_PS2_Data_WrData        (RF_IOTLB_1g_Data_WrData[g_id]),

              .RF_PS3_Tag_RdEn           (RF_IOTLB_5t_Tag_RdEn[g_id]),
              .RF_PS3_Tag_RdAddr         (RF_IOTLB_5t_Tag_RdAddr[g_id]),
              .RF_PS3_Tag_RdData         (RF_IOTLB_5t_Tag_RdData[g_id]),
              .RF_PS3_Tag_WrEn           (RF_IOTLB_5t_Tag_WrEn[g_id]),
              .RF_PS3_Tag_WrAddr         (RF_IOTLB_5t_Tag_WrAddr[g_id]),
              .RF_PS3_Tag_WrData         (RF_IOTLB_5t_Tag_WrData[g_id]),

              .RF_PS3_Data_RdEn          (RF_IOTLB_5t_Data_RdEn[g_id]),
              .RF_PS3_Data_RdAddr        (RF_IOTLB_5t_Data_RdAddr[g_id]),
              .RF_PS3_Data_RdData        (RF_IOTLB_5t_Data_RdData[g_id]),
              .RF_PS3_Data_WrEn          (RF_IOTLB_5t_Data_WrEn[g_id]),
              .RF_PS3_Data_WrAddr        (RF_IOTLB_5t_Data_WrAddr[g_id]),
              .RF_PS3_Data_WrData        (RF_IOTLB_5t_Data_WrData[g_id]),

              .RF_PS4_Tag_RdEn           (RF_IOTLB_Qp_Tag_RdEn[g_id]),
              .RF_PS4_Tag_RdAddr         (RF_IOTLB_Qp_Tag_RdAddr[g_id]),
              .RF_PS4_Tag_RdData         (RF_IOTLB_Qp_Tag_RdData[g_id]),
              .RF_PS4_Tag_WrEn           (RF_IOTLB_Qp_Tag_WrEn[g_id]),
              .RF_PS4_Tag_WrAddr         (RF_IOTLB_Qp_Tag_WrAddr[g_id]),
              .RF_PS4_Tag_WrData         (RF_IOTLB_Qp_Tag_WrData[g_id]),

              .RF_PS4_Data_RdEn          (RF_IOTLB_Qp_Data_RdEn[g_id]),
              .RF_PS4_Data_RdAddr        (RF_IOTLB_Qp_Data_RdAddr[g_id]),
              .RF_PS4_Data_RdData        (RF_IOTLB_Qp_Data_RdData[g_id]),
              .RF_PS4_Data_WrEn          (RF_IOTLB_Qp_Data_WrEn[g_id]),
              .RF_PS4_Data_WrAddr        (RF_IOTLB_Qp_Data_WrAddr[g_id]),
              .RF_PS4_Data_WrData        (RF_IOTLB_Qp_Data_WrData[g_id]),

              .DEVTLB_Tag_RdEn_Spec      (DEVTLB_Tag_RdEn_Spec[g_id]),
              .DEVTLB_Tag_RdEn           (DEVTLB_Tag_RdEn[g_id]),
              .DEVTLB_Tag_Rd_Addr        (DEVTLB_Tag_Rd_Addr[g_id]),
              .DEVTLB_Tag_Rd_Data        (DEVTLB_Tag_Rd_Data[g_id]),
              .DEVTLB_Tag_WrEn           (DEVTLB_Tag_WrEn[g_id]),
              .DEVTLB_Tag_Wr_Addr        (DEVTLB_Tag_Wr_Addr[g_id]),
              .DEVTLB_Tag_Wr_Way         (DEVTLB_Tag_Wr_Way[g_id]),
              .DEVTLB_Tag_Wr_Data        (DEVTLB_Tag_Wr_Data[g_id]),

              .DEVTLB_Data_RdEn_Spec     (DEVTLB_Data_RdEn_Spec[g_id]),
              .DEVTLB_Data_RdEn          (DEVTLB_Data_RdEn[g_id]),
              .DEVTLB_Data_Rd_Addr       (DEVTLB_Data_Rd_Addr[g_id]),
              .DEVTLB_Data_Rd_Data       (DEVTLB_Data_Rd_Data[g_id]),
              .DEVTLB_Data_WrEn          (DEVTLB_Data_WrEn[g_id]),
              .DEVTLB_Data_Wr_Addr       (DEVTLB_Data_Wr_Addr[g_id]),
              .DEVTLB_Data_Wr_Way        (DEVTLB_Data_Wr_Way[g_id]),
              .DEVTLB_Data_Wr_Data       (DEVTLB_Data_Wr_Data[g_id]),

              //TLB LRU Ports
              .DEVTLB_LRU_RdEn_Spec      (DEVTLB_LRU_RdEn_Spec[g_id]),
              .DEVTLB_LRU_RdEn           (DEVTLB_LRU_RdEn[g_id]),
              .DEVTLB_LRU_Rd_SetAddr     (DEVTLB_LRU_Rd_SetAddr[g_id]),
              .DEVTLB_LRU_Rd_Invert      (DEVTLB_LRU_Rd_Invert[g_id]),
              .DEVTLB_LRU_Rd_WayVec      (DEVTLB_LRU_Rd_WayVec[g_id]),
              .DEVTLB_LRU_Rd_Way2ndVec   (DEVTLB_LRU_Rd_Way2ndVec[g_id]),
              .DEVTLB_LRU_WrEn           (DEVTLB_LRU_WrEn[g_id]),
              .DEVTLB_LRU_Wr_SetAddr     (DEVTLB_LRU_Wr_SetAddr[g_id]),
              .DEVTLB_LRU_Wr_HitVec      (DEVTLB_LRU_Wr_HitVec[g_id]),
              .DEVTLB_LRU_Wr_RepVec      (DEVTLB_LRU_Wr_RepVec[g_id]),
              .LRUDisable_Ways           (LRUDisable_Ways[g_id]),

              // VISA
              .ObsIotlbLkpValid_nnnH     (ObsIotlbLkpValid_nnnH[g_id]),
              .ObsIotlbOrgReqID_nnnH     (ObsIotlbOrgReqID_nnnH[g_id]),
              .ObsIotlbID_nnnH           (ObsIotlbID_nnnH[g_id]),
              .ObsIotlbOrgHitVec_nnnH    (ObsIotlbOrgHitVec_nnnH[g_id]),
              .ObsIotlbInvValid_nnnH    (ObsIotlbInvValid_nnnH[g_id]),
              .ObsIotlbReqPageSize_nnnH  (ObsIotlbReqPageSize_nnnH[g_id]),
              .ObsIotlbFilledPageSize_nnnH  (ObsIotlbFilledPageSize_nnnH[g_id]),
              .ObsIotlbMisc_nnnH         (ObsIotlbMisc_nnnH),

              .ParErrOneShot_nnnH        (CrParErrInj_nnnH.one_shot_mode),
              .Disable_Ways              (IOTLB_Disable_Ways),
              .CrParErrInj_nnnH          (CrParErrInj_nnnH)
           );


      // Parity error signal routing logic
      // IOTLB
      assign tlb_tag_parity_err[g_id][DEVTLB_IOTLB_250T_PARITY_POS:DEVTLB_IOTLB_4K_PARITY_POS] = IOTLBParityErr_1nnH[g_id][DEVTLB_IOTLB_250T_PARITY_POS+DEVTLB_PARITY_VEC_OFFSET -:5];
      assign tlb_data_parity_err[g_id][DEVTLB_IOTLB_250T_PARITY_POS:DEVTLB_IOTLB_4K_PARITY_POS] = IOTLBParityErr_1nnH[g_id][DEVTLB_IOTLB_250T_PARITY_POS -:5];

      for (g_ps = IOTLB_PS_MIN; g_ps <= IOTLB_PS_MAX; g_ps++)  begin: Iotlb_Par_Err

         `HQM_DEVTLB_ASSERTS_NEVER(IOTLB_Data_Parity_Error_Zero,
                                 ((g_ps>IOTLB_PS_MAX) || (DEVTLB_TLB_NUM_PS_SETS[g_ps] == 0))  & tlb_data_parity_err[g_id][g_ps],
                                 posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("No Parity Error beyond maximum supported page size."));
         `HQM_DEVTLB_ASSERTS_NEVER(IOTLB_Tag_Parity_Error_Zero,
                                 ((g_ps>IOTLB_PS_MAX) || (DEVTLB_TLB_NUM_PS_SETS[g_ps] == 0))  & tlb_tag_parity_err[g_id][g_ps],
                                 posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("No Parity Error beyond maximum supported page size."));


      end

   end

   hqm_devtlb_tlb_array #(
          .ALLOW_TLBRWCONFLICT        (DEVTLB_ALLOW_TLBRWCONFLICT),
          .T_TAG_ENTRY_4K            (t_devtlb_iotlb_4k_tag_entry),
          .T_DATA_ENTRY_4K           (t_devtlb_iotlb_4k_data_entry),
          .NUM_RD_PORTS              (DEVTLB_XREQ_PORTNUM),
          .ARRAY_STYLE               (DEVTLB_TLB_ARRAY_STYLE),
          .NUM_ARRAYS                (DEVTLB_TLB_NUM_ARRAYS),
          .NUM_PIPE_STAGE            (DEVTLB_TLB_READ_LATENCY),
          .NUM_WAYS                  (DEVTLB_TLB_NUM_WAYS),
          .NUM_PS_SETS               (DEVTLB_TLB_NUM_PS_SETS),
          .PS_MAX                    (IOTLB_PS_MAX),
          .PS_MIN                    (IOTLB_PS_MIN),
          .T_ENTRY                   (t_devtlb_iotlb_4k_tag_entry),
          .D_ENTRY                   (t_devtlb_iotlb_4k_data_entry),
          .T_BITPERWAY               (t_tlb_bitperway),
          .T_SETADDR                 (t_devtlb_tlb_setaddr),
          `HQM_DEVTLB_PARAM_PORTCON
       ) devtlb_tlb_array (
          `HQM_DEVTLB_COMMON_PORTCON_W_SYNC_RESET
          `HQM_DEVTLB_FSCAN_PORTCON
          .PwrDnOvrd_nnnH            (CrPdoDis_nnnH.pdo_tlb_array),

          //TLB Tag Ports
          .DEVTLB_Tag_RdEn_Spec      (DEVTLB_Tag_RdEn_Spec),
          .DEVTLB_Tag_RdEn           (DEVTLB_Tag_RdEn),
          .DEVTLB_Tag_Rd_Addr        (DEVTLB_Tag_Rd_Addr),
          .DEVTLB_Tag_Rd_Data        (DEVTLB_Tag_Rd_Data),
          .DEVTLB_Tag_WrEn           (DEVTLB_Tag_WrEn[PORT_0]),
          .DEVTLB_Tag_Wr_Addr        (DEVTLB_Tag_Wr_Addr[PORT_0]),
          .DEVTLB_Tag_Wr_Way         (DEVTLB_Tag_Wr_Way[PORT_0]),
          .DEVTLB_Tag_Wr_Data        (DEVTLB_Tag_Wr_Data[PORT_0]),

          //TLB Data Ports
          .DEVTLB_Data_RdEn_Spec     (DEVTLB_Data_RdEn_Spec),
          .DEVTLB_Data_RdEn          (DEVTLB_Data_RdEn),
          .DEVTLB_Data_Rd_Addr       (DEVTLB_Data_Rd_Addr),
          .DEVTLB_Data_Rd_Data       (DEVTLB_Data_Rd_Data),
          .DEVTLB_Data_WrEn          (DEVTLB_Data_WrEn[PORT_0]),
          .DEVTLB_Data_Wr_Addr       (DEVTLB_Data_Wr_Addr[PORT_0]),
          .DEVTLB_Data_Wr_Way        (DEVTLB_Data_Wr_Way[PORT_0]),
          .DEVTLB_Data_Wr_Data       (DEVTLB_Data_Wr_Data[PORT_0])

       );

   for (g_port = PORT_0; g_port < DEVTLB_XREQ_PORTNUM; g_port++) begin  : Portid_GL
      assign tmpDEVTLB_LRU_RdEn_Spec[g_port]  =  DEVTLB_LRU_RdEn_Spec[g_port];
      if (g_port == PORT_0) begin: PORT_0
         for (g_ps = IOTLB_PS_MIN; g_ps <= IOTLB_PS_MAX; g_ps++) begin  : PS_GL
            always_comb begin
               tmpDEVTLB_LRU_RdEn[g_ps][g_port]        =  DEVTLB_LRU_RdEn[g_port][g_ps];
               tmpDEVTLB_LRU_Rd_SetAddr[g_ps][g_port]  =  DEVTLB_LRU_Rd_SetAddr[g_port][g_ps];
               tmpDEVTLB_LRU_Rd_Invert[g_ps][g_port]   =  DEVTLB_LRU_Rd_Invert[g_port][g_ps];
            end
         end
      end
      else begin: PORT_NZ
         for (g_ps = IOTLB_PS_MIN; g_ps <= IOTLB_PS_MAX; g_ps++) begin  : PS_GL
            always_comb begin
               tmpDEVTLB_LRU_RdEn[g_ps][g_port]        = '0;
               tmpDEVTLB_LRU_Rd_SetAddr[g_ps][g_port]  = '0;
               tmpDEVTLB_LRU_Rd_Invert[g_ps][g_port]   = '0;
            end
         end
      end

      for (g_ps = IOTLB_PS_MIN; g_ps <= IOTLB_PS_MAX; g_ps++) begin  : WR_PS_GL
         always_comb begin
            tmpDEVTLB_LRU_WrEn[g_ps][g_port]        =  DEVTLB_LRU_WrEn[g_port][g_ps];
            tmpDEVTLB_LRU_Wr_SetAddr[g_ps][g_port]  =  DEVTLB_LRU_Wr_SetAddr[g_port][g_ps];
            tmpDEVTLB_LRU_Wr_HitVec[g_ps][g_port]   =  DEVTLB_LRU_Wr_HitVec[g_port][g_ps];
            tmpDEVTLB_LRU_Wr_RepVec[g_ps][g_port]   =  DEVTLB_LRU_Wr_RepVec[g_port][g_ps];
            tmpLRUDisable_Ways[g_ps][g_port]        =  LRUDisable_Ways[g_port][g_ps];
         end
      end
   end

   for (g_ps = IOTLB_PS_MIN; g_ps <= IOTLB_PS_MAX; g_ps++) begin  : PS_GL2
      for (g_port = PORT_0; g_port < DEVTLB_XREQ_PORTNUM; g_port++) begin  : Portid_GL2
         always_comb begin
            DEVTLB_LRU_Rd_WayVec[g_port][g_ps]   =  tmpDEVTLB_LRU_Rd_WayVec[g_ps][g_port];
            DEVTLB_LRU_Rd_Way2ndVec[g_port][g_ps]   =  tmpDEVTLB_LRU_Rd_Way2ndVec[g_ps][g_port];
         end
      end
   end

   for (g_ps = IOTLB_PS_MIN; g_ps <= IOTLB_PS_MAX; g_ps++) begin  : PS_LRU
      if (DEVTLB_TLB_NUM_PS_SETS[g_ps] > 0) begin : PS_SET
         localparam  int SET_ADDR_WIDTH      = `HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[g_ps]);
         logic [DEVTLB_XREQ_PORTNUM-1:0][SET_ADDR_WIDTH-1:0] tmpWrSetAddr_nnnH;
         logic                       [SET_ADDR_WIDTH-1:0] tmpRdSetAddr_nnnH;

         always_comb begin
            tmpRdSetAddr_nnnH = tmpDEVTLB_LRU_Rd_SetAddr[g_ps][PORT_0][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[g_ps])-1:0];
         end
         
         always_comb begin
            for (int g_port = PORT_0; g_port < DEVTLB_XREQ_PORTNUM; g_port++) begin  : PS_LRU_PORTID
                tmpWrSetAddr_nnnH[g_port] = tmpDEVTLB_LRU_Wr_SetAddr[g_ps][g_port][`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[g_ps])-1:0];
            end
         end

        if(DEVTLB_LRU_STYLE==1'b0) begin : plru_inst
         hqm_devtlb_plru #(
             .NO_POWER_GATING           (NO_POWER_GATING),
             .XREQ_PORTNUM              (DEVTLB_XREQ_PORTNUM),
             .NUM_PIPE_STAGE            (1),
             .NUM_WAYS                  (DEVTLB_TLB_NUM_WAYS),
             .NUM_SETS                  (DEVTLB_TLB_NUM_PS_SETS[g_ps])
          ) devtlb_tlb_lru (
             `HQM_DEVTLB_COMMON_PORTCON_W_SYNC_RESET
             `HQM_DEVTLB_FSCAN_PORTCON
             .PwrDnOvrd_nnnH            (CrPdoDis_nnnH.pdo_tlb_lru),

             //TLB LRU Ports
             .RdEnSpec_nnnH             (tmpDEVTLB_LRU_RdEn_Spec[PORT_0]),
             .RdEn_nnnH                 (tmpDEVTLB_LRU_RdEn[g_ps][PORT_0]),
             .RdSetAddr_nnnH            (tmpRdSetAddr_nnnH),
             .RdInvert_nn1H             (tmpDEVTLB_LRU_Rd_Invert[g_ps][PORT_0]),
             .RdWayVec_nn1H             (tmpDEVTLB_LRU_Rd_WayVec[g_ps][PORT_0]),
             .RdWay2ndVec_nn1H          (tmpDEVTLB_LRU_Rd_Way2ndVec[g_ps][PORT_0]),
             .WrEn_nnnH                 (tmpDEVTLB_LRU_WrEn[g_ps]),
             .WrSetAddr_nnnH            (tmpWrSetAddr_nnnH),
             .WrHitVec_nnnH             (tmpDEVTLB_LRU_Wr_HitVec[g_ps]),
             .WrRepVec_nnnH             (tmpDEVTLB_LRU_Wr_RepVec[g_ps]),
             .Disable_Ways              (tmpLRUDisable_Ways[g_ps][PORT_0])
          );
        end else begin : slru_inst
         hqm_devtlb_slru #(
             .NO_POWER_GATING           (NO_POWER_GATING),
             .XREQ_PORTNUM              (DEVTLB_XREQ_PORTNUM),
             .NUM_PIPE_STAGE            (1),
             .NUM_WAYS                  (DEVTLB_TLB_NUM_WAYS),
             .NUM_SETS                  (DEVTLB_TLB_NUM_PS_SETS[g_ps])
          ) devtlb_tlb_lru (
             `HQM_DEVTLB_COMMON_PORTCON_W_SYNC_RESET
             `HQM_DEVTLB_FSCAN_PORTCON
             .PwrDnOvrd_nnnH            (CrPdoDis_nnnH.pdo_tlb_lru),
             .LRUReset_nnnH             (LRUCfgChanges),
             //TLB LRU Ports
             .RdEnSpec_nnnH             (tmpDEVTLB_LRU_RdEn_Spec[PORT_0]),
             .RdEn_nnnH                 (tmpDEVTLB_LRU_RdEn[g_ps][PORT_0]),
             .RdSetAddr_nnnH            (tmpRdSetAddr_nnnH),
             .RdInvert_nn1H             (tmpDEVTLB_LRU_Rd_Invert[g_ps][PORT_0]),
             .RdWayVec_nn1H             (tmpDEVTLB_LRU_Rd_WayVec[g_ps][PORT_0]),
             .RdWay2ndVec_nn1H          (tmpDEVTLB_LRU_Rd_Way2ndVec[g_ps][PORT_0]),
             .WrEn_nnnH                 (tmpDEVTLB_LRU_WrEn[g_ps]),
             .WrSetAddr_nnnH            (tmpWrSetAddr_nnnH),
             .WrHitVec_nnnH             (tmpDEVTLB_LRU_Wr_HitVec[g_ps]),
             .WrRepVec_nnnH             (tmpDEVTLB_LRU_Wr_RepVec[g_ps]),
             .Disable_Ways              (tmpLRUDisable_Ways[g_ps][PORT_0])
          );
        end
      end
      else begin : NO_PS_SET
         assign tmpDEVTLB_LRU_Rd_WayVec[g_ps][0] = '0;
         assign tmpDEVTLB_LRU_Rd_Way2ndVec[g_ps][0] = '0;
      end

      if (DEVTLB_XREQ_PORTNUM > 1) begin: MULTIPORT
         for (g_id = 1; g_id < DEVTLB_XREQ_PORTNUM; g_id++) begin: TLB_RD_NZ_PORTS
            assign tmpDEVTLB_LRU_Rd_WayVec[g_ps][g_id]   = '0;
            assign tmpDEVTLB_LRU_Rd_Way2ndVec[g_ps][g_id]   = '0;
         end
      end
   end

   if (DEVTLB_XREQ_PORTNUM > 1) begin: MULTIPORT2
      for (g_id = 1; g_id < DEVTLB_XREQ_PORTNUM; g_id++) begin: TLB_NZ_PORTS
         assign ActivityOnNZWrPorts_nnnH[g_id]  = (|DEVTLB_Tag_WrEn[g_id])
                                                & (|DEVTLB_Tag_Wr_Addr[g_id])
                                                & (|DEVTLB_Tag_Wr_Way[g_id])
                                                & (|DEVTLB_Tag_Wr_Data[g_id])
                                                & (|DEVTLB_Data_WrEn[g_id])
                                                & (|DEVTLB_Data_Wr_Addr[g_id])
                                                & (|DEVTLB_Data_Wr_Way[g_id])
                                                & (|DEVTLB_Data_Wr_Data[g_id])
                                                & (|tmpDEVTLB_LRU_RdEn_Spec[g_id]);
//                                                & (|tmpDEVTLB_LRU_RdEn[g_id])
//                                                & (|tmpDEVTLB_LRU_Rd_SetAddr[g_id])
//                                                & (|tmpDEVTLB_LRU_Rd_Invert[g_id])
//                                                & (|tmpDEVTLB_LRU_Rd_WayVec[g_id])
//                                                & (|tmpLRUDisable_Ways[g_id]);
      end
   end

   assign ActivityOnNZWrPorts_nnnH[PORT_0] = '0;

endgenerate


//======================================================================================================================
//                                                Invalidation engine
//======================================================================================================================

logic [63:0]                     swizzled_invreq_data;

always_comb begin
    //byte swapping invreq_data[63:0]
    for (int i=0; i<8; i++) swizzled_invreq_data[(i*8) +: 8] = rx_msg_data[((7-i)*8) +: 8];
end
   
logic                            InvQWrEn, InvQRdEn;
logic [DEVTLB_INVQ_IDW-1:0]   InvQWrAddr, InvQRdAddr;
t_devtlb_invreq                  InvQWrData, InvQRdData;
logic                            InvQPerr;

logic                            InvIfReqPut, InvIfReqFree, InvIfReqAvail;
t_devtlb_invreq                  InvIfReq;

logic                            InvIfCmpAvail;
logic [7:0]                      InvIfCmpTC;
logic [4:0]                      InvIfCmpITag;
logic [DEVTLB_BDF_WIDTH-1:0]     InvIfCmpBDF;
logic                            InvIfCmpGet;

logic                            InvMsTrkStart;
logic                            InvMsTrkEnd;
logic [DEVTLB_BDF_WIDTH-1:0]     InvBDF;
logic                            InvBdfV;
logic [DEVTLB_PASID_WIDTH-1:0]   InvPASID;
logic                            InvGlob;
logic                            InvPasidV;
logic                            InvAOR;
logic [DEVTLB_REQ_PAYLOAD_MSB:DEVTLB_REQ_PAYLOAD_LSB] InvAddr;
logic [DEVTLB_REQ_PAYLOAD_MSB:DEVTLB_REQ_PAYLOAD_LSB] InvAddrMask;
logic                            InvMsTrkBusy, MsTrkFillInFlight;

logic                           invrsp_valid;
logic [15:0]                    invrsp_did;
logic [31:0]                    invrsp_itag;
logic [DEVTLB_BDF_WIDTH-1:0]    invrsp_bdf;
logic [2:0]                     invrsp_cc;
logic [2:0]                     invrsp_tc;
logic                           invrsp_ack;
logic                           invreqs_active_i;
logic                           drainreq_bdf_valid;

hqm_devtlb_invif
#(
    .NO_POWER_GATING(NO_POWER_GATING),
    .T_INVREQ(t_devtlb_invreq),
    .BDF_SUPP_EN(DEVTLB_BDF_SUPP_EN),
    .BDF_WIDTH(DEVTLB_BDF_WIDTH),
    .PASID_SUPP_EN(DEVTLB_PASID_SUPP_EN),
    .PASID_WIDTH(DEVTLB_PASID_WIDTH),
    .REQ_PAYLOAD_MSB(DEVTLB_REQ_PAYLOAD_MSB),
    .REQ_PAYLOAD_LSB(DEVTLB_REQ_PAYLOAD_LSB),
    .DEVTLB_INVQ_DEPTH(DEVTLB_INVQ_DEPTH)
) devtlb_invif (
    .clk(clk),
    .reset(local_nonflreset),
    .reset_INST(local_nonflreset),
    .fscan_clkungate(fscan_clkungate),
    .flr_fw(local_reset),
    .PwrDnOvrd_nnnH(CrPdoDis_nnnH.pdo_inv),
    .invreqs_active(invreqs_active_i),
    
    .invreq_valid(rx_msg_valid && rx_msg_opcode == 1'b0),
    .invreq_dperror(rx_msg_dperror),
    .invreq_reqid(rx_msg_invreq_reqid),
    .invreq_itag(rx_msg_invreq_itag),
    .invreq_bdf(rx_msg_dw2[16+:DEVTLB_BDF_WIDTH]),
    .invreq_pasid_valid(rx_msg_pasid_valid),
    .invreq_pasid_priv(rx_msg_pasid_priv),
    .invreq_pasid(rx_msg_pasid),
    .invreq_data(swizzled_invreq_data),
    
    .InvIfReqAvail(InvIfReqAvail),
    .InvIfReqPut(InvIfReqPut),
    .InvIfReq(InvIfReq),
    .InvIfReqFree(InvIfReqFree),

    .InvIfCmpAvail(InvIfCmpAvail),
     .InvIfCmpBDF(InvIfCmpBDF),
    .InvIfCmpITag(InvIfCmpITag),
    .InvIfCmpTC(InvIfCmpTC),
    .InvIfCmpGet(InvIfCmpGet),
    
    .invrsp_valid(invrsp_valid),
    .invrsp_ack(invrsp_ack),
    .invrsp_did(invrsp_did),
    .invrsp_bdf(invrsp_bdf),
    .invrsp_itag(invrsp_itag),
    .invrsp_cc(invrsp_cc),
    .invrsp_tc(invrsp_tc),
    
    .InvQWrEn(InvQWrEn),
    .InvQWrAddr(InvQWrAddr),
    .InvQWrData(InvQWrData),
    .InvQRdEn(InvQRdEn),
    .InvQRdAddr(InvQRdAddr),
    .InvQRdData(InvQRdData));

hqm_devtlb_inv
#(
    .NO_POWER_GATING(NO_POWER_GATING),
    .PF_INV_VF(1'b0),
    .T_INVREQ(t_devtlb_invreq),
    .T_REQ(t_devtlb_request),
    .T_REQ_CTRL(t_devtlb_request_ctrl),
    .T_REQ_INFO(t_devtlb_request_info),
    .T_OPCODE(t_devtlb_opcode),
    .T_PGSIZE(t_devtlb_page_type),
    .BDF_SUPP_EN(DEVTLB_BDF_SUPP_EN),
    .BDF_WIDTH(DEVTLB_BDF_WIDTH),
    .PASID_SUPP_EN(DEVTLB_PASID_SUPP_EN),
    .PASID_WIDTH(DEVTLB_PASID_WIDTH),
    .REQ_PAYLOAD_MSB(DEVTLB_REQ_PAYLOAD_MSB),
    .REQ_PAYLOAD_LSB(DEVTLB_REQ_PAYLOAD_LSB),
    .ZERO_CYCLE_TLB_ARB(DEVTLB_TLB_ZERO_CYCLE_ARB),
    .READ_LATENCY(DEVTLB_TLB_READ_LATENCY),
    .TLB_NUM_ARRAYS(DEVTLB_TLB_NUM_ARRAYS),
    .TLB_NUM_SETS(DEVTLB_TLB_NUM_SETS),
    .TLB_SHARE_EN(DEVTLB_TLB_SHARE_EN),
    .TLB_ALIASING(DEVTLB_TLB_ALIASING),
    .PS_MAX(IOTLB_PS_MAX),
    .PS_MIN(IOTLB_PS_MIN)
) devtlb_inv (
      .clk                       (clk),
      .reset                     (local_reset),
      .reset_INST                (reset_INST),
      .fscan_clkungate           (fscan_clkungate),
      .CrPFId                    ('0),
      .PwrDnOvrd_nnnH            (CrPdoDis_nnnH.pdo_inv),
      .DisPartInv_nnnH           (CrMiscDis_nnnH.dispartinv),

      .InvInitDone               (InvInitDone),
      .tlb_reset_active          (tlb_reset_active),

      .ImplicitInv_nnnH            (implicit_invalidation_valid),
      .ImplicitInvBDF_nnnH         (implicit_invalidation_bdf),
      .ImplicitInvBDFV_nnnH        (implicit_invalidation_bdf_valid),
      .ImplicitInvPASID_nnnH       ('0),
      .ImplicitInvPasidV_nnnH      ('0),

      .InvIfReqPut               (InvIfReqPut),
      .InvIfReq                  (InvIfReq),
      .InvIfReqFree              (InvIfReqFree),
  
      .InvIfCmpAvail             (InvIfCmpAvail),
      .InvIfCmpBDF               (InvIfCmpBDF),
      .InvIfCmpITag              (InvIfCmpITag),
      .InvIfCmpTC                (InvIfCmpTC),
      .InvIfCmpGet               (InvIfCmpGet),

      .InvMsTrkStart             (InvMsTrkStart),
      .InvMsTrkEnd               (InvMsTrkEnd),
      .InvBDF                    (InvBDF),
      .InvBdfV                   (InvBdfV),
      .InvPASID                  (InvPASID),
      .InvPasidV                 (InvPasidV),
      .InvGlob                   (InvGlob),
      .InvAOR                    (InvAOR),
      .InvAddr                   (InvAddr),
      .InvAddrMask               (InvAddrMask),
      .InvMsTrkBusy              (InvMsTrkBusy),
      .MsTrkFillInFlight             (MsTrkFillInFlight),
      
      .InvPipeV_100H             (InvPipeIntV_100H),   // From Inv to top of TLB Pipe
      .InvReq_100H               (InvReqInt_100H),     // From Inv to top of TLB/PWC Pipe
      .InvCtrl_100H              (InvCtrlInt_100H),    // From Inv to top of TLB/PWC Pipe
      .InvInfo_100H              (InvInfoInt_100H),    // From Inv to top of TLB/PWC Pipe
      .InvGnt_100H               (InvGnt_100H[PORT_0]),

      .InvBlockDMA               (InvBlockDMA),
      .InvBlockFill              (InvBlockFill),
      .TLBOutInvTail_nnH         (TLBOutInvTail_nnH[PORT_0]),
      
      .drainreq_valid            (drainreq_valid),
      .drainreq_pasid            (drainreq_pasid),
      .drainreq_pasid_priv       (drainreq_pasid_priv),
      .drainreq_pasid_valid      (drainreq_pasid_valid),
      .drainreq_pasid_global     (drainreq_pasid_global),
      .drainreq_bdf              (drainreq_bdf),
      .drainreq_bdf_valid        (drainreq_bdf_valid),
      .drainreq_ack              (drainreq_ack),
      .drainrsp_valid            (drainrsp_valid),
      .drainrsp_tc               (drainrsp_tc),

      .ObsIotlbInvPs_nnnH        (ObsIotlbInvPs_nnnH),
      .ObsIotlbInvBusy_nnnH      (ObsIotlbInvBusy_nnnH),
      .ObsIotlbGlbInProg_nnnH    (ObsIotlbGlbInProg_nnnH),
      .ObsIotlbPgSInProg_nnnH    (ObsIotlbPgSInProg_nnnH)
);

hqm_devtlb_misc_array
    #( .NO_POWER_GATING(NO_POWER_GATING),
       .ARRAY_STYLE(DEVTLB_INVQ_ARRAY_STYLE),
       .ENTRY(DEVTLB_INVQ_DEPTH),
       .T_ENTRY(t_devtlb_invreq),
       .CAM_EN(1'b0)
    ) devtlb_invq_mem (
        .clk(clk),
        .dfx_array_scan_mode_en(dfx_array_scan_mode_en),
        .dfx_array_scan_mode_way(dfx_array_scan_mode_way),
        .reset(local_nonflreset),
        .reset_INST(local_nonflreset),
        `HQM_DEVTLB_FSCAN_PORTCON
        .PwrDnOvrd_nnnH(CrPdoDis_nnnH.pdo_inv),

`ifdef DEVTLB_EXT_MISCRF_EN  //RF-External
        .EXT_RF_CAMEn(), // lintra s-0214
        .EXT_RF_CAMData(), // lintra s-0214
        .EXT_RF_CAMHit('0),

        .EXT_RF_RdEn(EXT_RF_InvQRdEn),
        .EXT_RF_RdAddr(EXT_RF_InvQRdAddr),
        .EXT_RF_RdData(EXT_RF_InvQRdData),

        .EXT_RF_WrEn (EXT_RF_InvQWrEn ),
        .EXT_RF_WrAddr(EXT_RF_InvQWrAddr),
        .EXT_RF_WrData(EXT_RF_InvQWrData),
`endif //DEVTLB_EXT_MISCRF_EN  //RF-External

        .CamEn('0),
        .CamData('0),
        .CamHit(), // lintra s-0214

        .WrEn(InvQWrEn),
        .WrAddr(InvQWrAddr),
        .WrData(InvQWrData),

        .RdEn(InvQRdEn),
        .RdAddr(InvQRdAddr),
        .RdData(InvQRdData),
        .Perr(InvQPerr)
    );

//======================================================================================================================
//                                                Result/Response Module
//======================================================================================================================
    logic [DEVTLB_XREQ_PORTNUM-1:0]    FillTLBOutV;
    logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_MISSTRK_IDW-1:0] FillTLBOutMsTrkIdx;
    t_fillinfo [DEVTLB_XREQ_PORTNUM-1:0]    FillTLBOutInfo;

always_comb begin
    for (int i=PORT_0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        xrsp_result[i][0] = resp_status[i][0]; //assert xrsp_result[i][0] only if resp_status[i][0]==DEVTLB_RESP_HIT_VALID);
    end
end

generate
   for (g_id = PORT_0; g_id < DEVTLB_XREQ_PORTNUM; g_id++) begin: RESP_NUM_PORTS
      hqm_devtlb_result #(
         .DEVTLB_PORT_ID      (g_id),
         .FWDPROG_EN          (FWDPROG_EN),
         .MISSFIFO_DEPTH      (DEVTLB_MISSFIFO_DEPTH),
         .RESP_PAYLOAD_MSB    (DEVTLB_RESP_PAYLOAD_MSB),
         .RESP_PAYLOAD_LSB    (DEVTLB_RESP_PAYLOAD_LSB),
         .NUM_ARRAYS          (DEVTLB_TLB_NUM_ARRAYS),
         .TLB_SHARE_EN        (DEVTLB_TLB_SHARE_EN),
         .TLB_ALIASING        (DEVTLB_TLB_ALIASING),
         .PS_MAX              (IOTLB_PS_MAX),
         .PS_MIN              (IOTLB_PS_MIN),
         .T_REQ               (t_devtlb_request),
         .T_PROCREQ           (t_devtlb_procreq),
         .T_REQ_CTRL          (t_devtlb_request_ctrl),
         .T_REQ_INFO          (t_devtlb_request_info),
         .T_OPCODE            (t_devtlb_opcode),
         .T_STATUS            (t_devtlb_resp_status),
         `HQM_DEVTLB_PARAM_PORTCON
      ) devtlb_result (
            `HQM_DEVTLB_COMMON_PORTCON_W_SYNC_RESET
            `HQM_DEVTLB_FSCAN_PORTCON

            // Inputs
            .InvMsTrkEnd               (InvMsTrkEnd),
            .TLBOutPipeV_nnnH          (TLBOutPipeV_nnnH[g_id]),
            .TLBOutXRspV_nnnH          (TLBOutXRspV_nnnH[g_id]),
            .TLBOutMsProcV_nnnH        (TLBOutMsProcV_nnnH[g_id]),
            .TLBOutReq_nnnH            (TLBOutReq_nnnH[g_id]),
            .TLBOutCtrl_nnnH           (TLBOutCtrl_nnnH[g_id]),
            .TLBOutInfo_nnnH           (TLBOutInfo_nnnH[g_id]),

            // Outputs
            .MsFifoReqAvail            (MsFifoReqAvail[g_id]),
            .MsFifoProcReq             (MsFifoProcReq[g_id]),
            .MsFifoReqGet              (MsFifoReqGet[g_id]),
            .MsfifoCrdRet              (MsfifoCrdRet[g_id]),
            .RespCrdRet                (RespCrdRet[g_id]),
            .resp_valid                (xrsp_valid[g_id]),
            .resp_id                   (xrsp_id[g_id]),
            .resp_tlbid                (xrsp_tlbid[g_id]),
            .resp_opcode               (xrsp_opcode[g_id]),
            .resp_status               (resp_status[g_id]),
            .resp_prs_code             (xrsp_prs_code[g_id]),
            .resp_dperror              (xrsp_dperror[g_id]),
            .resp_hdrerror             (xrsp_hdrerror[g_id]),
            .resp_n                    (xrsp_nonsnooped[g_id]),
            .resp_payload              (xrsp_address[g_id]),
            .resp_pagesize             (xrsp_pagesize[g_id]),
            .resp_priv_data            (xrsp_privdata[g_id]),
            .resp_r                    (xrsp_r[g_id]),
            .resp_w                    (xrsp_w[g_id]),
            .resp_u                    (xrsp_u[g_id]),
            .resp_perm                 (xrsp_perm[g_id]),
            .resp_ep                   (xrsp_ep[g_id]),
            .resp_pa                   (xrsp_pa[g_id]),
            .resp_global               (xrsp_global[g_id]),
            .resp_memtype              (xrsp_memtype[g_id]),

            .FillTLBOutV               (FillTLBOutV[g_id]),
            .FillTLBOutMsTrkIdx        (FillTLBOutMsTrkIdx[g_id]),
            .FillTLBOutInfo            (FillTLBOutInfo[g_id])
            );
   end
endgenerate

//arbitrate miss req for processing
localparam int DEVTLB_SHAREDMSTRK_CRDT=DEVTLB_MISSTRK_DEPTH-DEVTLB_HPMSTRK_CRDT-DEVTLB_LPMSTRK_CRDT;

logic ClkMsProc_H;
logic pEn_MsProc;
logic MsProcFree, MsProcPut;
t_devtlb_procreq MsProcReq;
`HQM_DEVTLB_MAKE_LCB_PWR(ClkMsProc_H,    ClkFree_H, pEn_MsProc, CrPdoDis_nnnH.pdo_msproc)

localparam int MSPROC_REQ_W = DEVTLB_XREQ_PORTNUM*MISSCH_NUM;
localparam int MSPROC_REQ_IDW = (MSPROC_REQ_W==1)? 1: $clog2(MSPROC_REQ_W);

logic [MISSCH_NUM-1:0][DEVTLB_XREQ_PORTNUM-1:0] MsProcArbReq, MsProcArbGnt;

logic                                                                   MsProcPrimCrdRet, MsTrkPrimCrdRet;
logic [MISSCH_NUM-1:0]                                                  MsProcSecCrdRet, MsTrkSecCrdRet;

logic [DEVTLB_MISSTRK_IDW:0]                                            SharedMsTrkCrd, NxtSharedMsTrkCrd;
logic                                                                   SharedMsTrkCrdRet, SharedMsTrkCrdInc, SharedMsTrkCrdDec, SharedMsTrkCrdAvail;
logic [DEVTLB_MISSTRK_IDW:0]                                            SharedMsTrkAccCrd, NxtSharedMsTrkAccCrd;
logic                                                                   SharedMsTrkAccCrdInc, SharedMsTrkAccCrdDec;

logic [DEVTLB_MISSTRK_IDW:0]                                            HpMsTrkCrd, NxtHpMsTrkCrd;
logic                                                                   HpMsTrkCrdRet, HpMsTrkCrdInc, HpMsTrkCrdDec, HpMsTrkCrdAvail;
logic [DEVTLB_MISSTRK_IDW:0]                                            HpMsTrkAccCrd, NxtHpMsTrkAccCrd;
logic                                                                   HpMsTrkAccCrdInc, HpMsTrkAccCrdDec;

logic [DEVTLB_MISSTRK_IDW:0]                                            LpMsTrkCrd, NxtLpMsTrkCrd;
logic                                                                   LpMsTrkCrdRet, LpMsTrkCrdInc, LpMsTrkCrdDec, LpMsTrkCrdAvail;
logic [DEVTLB_MISSTRK_IDW:0]                                            LpMsTrkAccCrd, NxtLpMsTrkAccCrd;
logic                                                                   LpMsTrkAccCrdInc, LpMsTrkAccCrdDec;

/*
logic [DEVTLB_PENDQ_IDW:0]                                              PendQCrd, NxtPendQCrd;
logic [DEVTLB_PENDQ_IDW:0]                                              PendQAccCrd, NxtPendQAccCrd;
logic                                                                   PendQCrdInc, PendQCrdDec;
logic                                                                   PendQAccCrdInc, PendQAccCrdDec;
logic                                                                   PendQCrdAvail; */
logic                                                                   MsProcPendQCrdRet, PendQCrdRet;

always_comb begin
    SharedMsTrkCrdDec = MsProcPut && (FWDPROG_EN? SharedMsTrkCrdAvail: 1'b1);
    HpMsTrkCrdDec     = MsProcPut && (~SharedMsTrkCrdAvail) &&  MsProcReq.Req.Priority;
    LpMsTrkCrdDec     = MsProcPut && (~SharedMsTrkCrdAvail) && ~MsProcReq.Req.Priority;

    SharedMsTrkAccCrdInc = MsProcPrimCrdRet;
    SharedMsTrkAccCrdDec = (~MsTrkPrimCrdRet) & ~(SharedMsTrkAccCrd=='0);
    NxtSharedMsTrkAccCrd = (SharedMsTrkAccCrdInc ^ SharedMsTrkAccCrdDec)? 
                      (SharedMsTrkAccCrd + {{(DEVTLB_MISSTRK_IDW){SharedMsTrkAccCrdDec}},1'b1}): SharedMsTrkAccCrd;
    SharedMsTrkCrdRet = MsTrkPrimCrdRet || SharedMsTrkAccCrdDec;

    HpMsTrkAccCrdInc = MsProcSecCrdRet[MISSCH_NUM-1] && FWDPROG_EN;
    HpMsTrkAccCrdDec = (~|MsTrkSecCrdRet) && ~(HpMsTrkAccCrd=='0);
    NxtHpMsTrkAccCrd = (HpMsTrkAccCrdInc ^ HpMsTrkAccCrdDec)? 
                      (HpMsTrkAccCrd + {{(DEVTLB_MISSTRK_IDW){HpMsTrkAccCrdDec}},1'b1}): HpMsTrkAccCrd;
    HpMsTrkCrdRet = MsTrkSecCrdRet[MISSCH_NUM-1] || HpMsTrkAccCrdDec;

    LpMsTrkAccCrdInc = MsProcSecCrdRet[0] && FWDPROG_EN;
    LpMsTrkAccCrdDec = (~|MsTrkSecCrdRet) && (~(LpMsTrkAccCrd=='0)) && ~HpMsTrkAccCrdDec;  //fixed arbitor
    NxtLpMsTrkAccCrd = (LpMsTrkAccCrdInc ^ LpMsTrkAccCrdDec)? 
                      (LpMsTrkAccCrd + {{(DEVTLB_MISSTRK_IDW){LpMsTrkAccCrdDec}},1'b1}): LpMsTrkAccCrd;
    LpMsTrkCrdRet = MsTrkSecCrdRet[0] || LpMsTrkAccCrdDec;

    HpMsTrkCrdInc = (HpMsTrkCrdDec || (HpMsTrkCrd!=DEVTLB_HPMSTRK_CRDT)) && HpMsTrkCrdRet;
    LpMsTrkCrdInc = (LpMsTrkCrdDec || (LpMsTrkCrd!=DEVTLB_LPMSTRK_CRDT)) && LpMsTrkCrdRet;
    SharedMsTrkCrdInc = FWDPROG_EN? 
                        (HpMsTrkCrdRet && ~HpMsTrkCrdInc) || (LpMsTrkCrdRet && ~LpMsTrkCrdInc): // onehot
                        SharedMsTrkCrdRet;

    NxtSharedMsTrkCrd = (SharedMsTrkCrdInc ^ SharedMsTrkCrdDec)? 
                      (SharedMsTrkCrd + {{(DEVTLB_MISSTRK_IDW){SharedMsTrkCrdDec}},1'b1}): SharedMsTrkCrd;
    NxtHpMsTrkCrd = (HpMsTrkCrdInc ^ HpMsTrkCrdDec)? 
                      (HpMsTrkCrd + {{(DEVTLB_MISSTRK_IDW){HpMsTrkCrdDec}},1'b1}): HpMsTrkCrd;
    NxtLpMsTrkCrd = (LpMsTrkCrdInc ^ LpMsTrkCrdDec)? 
                      (LpMsTrkCrd + {{(DEVTLB_MISSTRK_IDW){LpMsTrkCrdDec}},1'b1}): LpMsTrkCrd;

/*
    PendQCrdDec = MsProcPut;
    PendQAccCrdInc = MsProcPendQCrdRet;
    PendQAccCrdDec = (~PendQCrdRet) & ~(PendQAccCrd=='0);
    PendQCrdInc = PendQCrdRet || PendQAccCrdDec;

    NxtPendQCrd = (PendQCrdInc ^ PendQCrdDec)? 
                      (PendQCrd + {{(DEVTLB_PENDQ_IDW){PendQCrdDec}},1'b1}): PendQCrd;
    NxtPendQAccCrd = (PendQAccCrdInc ^ PendQAccCrdDec)? 
                      (PendQAccCrd + {{(DEVTLB_PENDQ_IDW){PendQAccCrdDec}},1'b1}): PendQAccCrd;
*/
    for (int i=0; i<MISSCH_NUM; i++) begin
        for (int j=0; j<DEVTLB_XREQ_PORTNUM; j++) begin
            MsProcArbReq[MISSCH_NUM-1-i][j] = MsFifoReqAvail[j][i] && 
                                              (SharedMsTrkCrdAvail || 
                                              (((i==HPXREQ)?HpMsTrkCrdAvail: LpMsTrkCrdAvail) && FWDPROG_EN));//inverse to put HP MsProcArbReq  at lsb.
            MsFifoReqGet[j][i] = MsProcArbGnt[MISSCH_NUM-1-i][j];
        end
    end
end

`HQM_DEVTLB_RSTD_MSFF(SharedMsTrkCrd,NxtSharedMsTrkCrd,ClkMsProc_H,local_reset,DEVTLB_SHAREDMSTRK_CRDT)
`HQM_DEVTLB_RST_MSFF(SharedMsTrkCrdAvail,(NxtSharedMsTrkCrd!='0),ClkMsProc_H,local_reset)
`HQM_DEVTLB_RST_MSFF(SharedMsTrkAccCrd,NxtSharedMsTrkAccCrd,ClkMsProc_H,local_reset)

`HQM_DEVTLB_RSTD_MSFF(HpMsTrkCrd,NxtHpMsTrkCrd,ClkMsProc_H,local_reset,DEVTLB_HPMSTRK_CRDT)
`HQM_DEVTLB_RST_MSFF(HpMsTrkCrdAvail,(NxtHpMsTrkCrd!='0),ClkMsProc_H,local_reset)
`HQM_DEVTLB_RST_MSFF(HpMsTrkAccCrd,NxtHpMsTrkAccCrd,ClkMsProc_H,local_reset)

`HQM_DEVTLB_RSTD_MSFF(LpMsTrkCrd,NxtLpMsTrkCrd,ClkMsProc_H,local_reset,DEVTLB_LPMSTRK_CRDT)
`HQM_DEVTLB_RST_MSFF(LpMsTrkCrdAvail,(NxtLpMsTrkCrd!='0),ClkMsProc_H,local_reset)
`HQM_DEVTLB_RST_MSFF(LpMsTrkAccCrd,NxtLpMsTrkAccCrd,ClkMsProc_H,local_reset)

/*
`HQM_DEVTLB_RSTD_MSFF(PendQCrd,NxtPendQCrd,ClkMsProc_H,local_reset,DEVTLB_PENDQ_DEPTH)
`HQM_DEVTLB_RST_MSFF(PendQCrdAvail,(NxtPendQCrd!='0),ClkMsProc_H,local_reset)
`HQM_DEVTLB_RST_MSFF(PendQAccCrd,NxtPendQAccCrd,ClkMsProc_H,local_reset)
*/

hqm_devtlb_rrarbd #(.REQ_W (MSPROC_REQ_W), .REQ_IDW (MSPROC_REQ_IDW))  // lsb is given higher priority in rr
   msproc_arb (.clk (ClkMsProc_H), .rst_b (~local_reset), .arb_rs (MsProcFree), .arb_req (MsProcArbReq), .arb_gnt (MsProcArbGnt));
               
always_comb begin
    pEn_MsProc = |{local_reset, MsFifoReqAvail, MsTrkPrimCrdRet, |MsTrkSecCrdRet, MsProcPrimCrdRet, |MsProcSecCrdRet, SharedMsTrkAccCrdDec, HpMsTrkAccCrdDec, LpMsTrkAccCrdDec};
    
    MsProcPut = |MsFifoReqGet;
    MsProcReq = '0;
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        for (int j=0; j<MISSCH_NUM; j++) begin
            MsProcReq = MsProcReq | (MsFifoProcReq[i][j] & {($bits(t_devtlb_procreq)){MsFifoReqGet[i][j]}});
        end
    end
end

`ifndef HQM_DEVTLB_SVA_OFF
`HQM_DEVTLB_COVERS_TRIGGER( CP_MSFIFOAVAIL_MSTRKFULL,
    (|MsFifoReqAvail),
    (~SharedMsTrkCrdAvail),
    posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER( CP_MSFIFOAVAIL_MSTRKALLFULL,
    (|MsFifoReqAvail),
    (~(SharedMsTrkCrdAvail || HpMsTrkCrdAvail || LpMsTrkCrdAvail)),
    posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER( CP_HPMSTRKCRDDEC,
    (MsProcPut),
    (HpMsTrkCrdDec),
    posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER( CP_LPMSTRKCRDDEC,
    (MsProcPut),
    (LpMsTrkCrdDec),
    posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER( CP_HPMSTRKACCCRD,
    (MsProcSecCrdRet[MISSCH_NUM-1]),
    (MsTrkSecCrdRet[MISSCH_NUM-1]),
    posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_COVERS_TRIGGER( CP_LPMSTRKACCCRD,
    (MsProcSecCrdRet[0]),
    (MsTrkSecCrdRet[0]),
    posedge clk, reset_INST,
`HQM_DEVTLB_COVER_MSG("%0t: %m HIT", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER( AS_MSPROCPUTHP,
    (MsProcPut && MsProcReq.Req.Priority),
    (SharedMsTrkCrdAvail || HpMsTrkCrdAvail),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER( AS_MSPROCPUTLP,
    (MsProcPut && ~MsProcReq.Req.Priority),
    (SharedMsTrkCrdAvail || LpMsTrkCrdAvail),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER( AS_HPMSTRKCRDINC,
    (|{SharedMsTrkCrdInc, HpMsTrkCrdInc}),
    ($onehot({SharedMsTrkCrdInc, HpMsTrkCrdInc})),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER( AS_LPMSTRKCRDINC,
    (|{SharedMsTrkCrdInc, LpMsTrkCrdInc}),
    ($onehot({SharedMsTrkCrdInc, LpMsTrkCrdInc})),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER( AS_HPLPMSTRKCRDRET_ONEHOT,
    (LpMsTrkCrdRet || HpMsTrkCrdRet ),
    ($onehot({LpMsTrkCrdRet, HpMsTrkCrdRet})),
    posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%t %m failed", $time));

`endif //DEVTLB_SVA_OFF
//======================================================================================================================
//                                                Miss Req processing Module
//======================================================================================================================
    logic                              MsTrkReqCamEn;
    t_devtlb_camreq                    MsTrkReqCamData;
    logic [DEVTLB_MISSTRK_DEPTH-1:0]   MsTrkReqCamHit;
    
    logic [DEVTLB_MISSTRK_DEPTH-1:0]   MsTrkVacant;
    logic [DEVTLB_MISSTRK_DEPTH-1:0]   MsTrkVld;
    logic [DEVTLB_MISSTRK_DEPTH-1:0]   MsTrkWrOp;
    logic                              MsTrkReqPut;
    logic [DEVTLB_MISSTRK_IDW-1:0]     MsTrkReqIdx;
    t_devtlb_request                   MsTrkReq;

    logic                              PendQFull;
    logic                              PendQEmpty;
    logic [DEVTLB_PENDQ_DEPTH-1:0]     PendQVacant;
    logic                              PendQPut;
    logic [DEVTLB_PENDQ_IDW-1:0]       PendQIdx;
    t_devtlb_request                   PendQReq;
    logic                              PendQWakeAtPut;
    t_wakeinfo                         PendQWakeInfoAtPut;
    logic [DEVTLB_MISSTRK_IDW-1:0]     PendQMsHitIdx;

    hqm_devtlb_msproc
    #(
        .NO_POWER_GATING(NO_POWER_GATING),
        .FWDPROG_EN(FWDPROG_EN),
        .T_REQ(t_devtlb_request),
        .T_PROCREQ(t_devtlb_procreq),
        .T_CAMREQ(t_devtlb_camreq),
        .T_OPCODE(t_devtlb_opcode),
        .BDF_SUPP_EN(DEVTLB_BDF_SUPP_EN),
        .BDF_WIDTH(DEVTLB_BDF_WIDTH),
        .PASID_SUPP_EN(DEVTLB_PASID_SUPP_EN),
        .PASID_WIDTH(DEVTLB_PASID_WIDTH),
        .PENDQ_SUPP_EN(DEVTLB_PENDQ_SUPP_EN),
        .XREQ_PORTNUM(DEVTLB_XREQ_PORTNUM),
        .MISSTRK_DEPTH(DEVTLB_MISSTRK_DEPTH),
        .PENDQ_DEPTH(DEVTLB_PENDQ_DEPTH)
     ) devtlb_msproc (
        .clk(clk),
        .reset(local_reset),
        .reset_INST(reset_INST),
        .fscan_clkungate(fscan_clkungate),
        .PwrDnOvrd_nnnH(CrPdoDis_nnnH.pdo_msproc),
        
        .InvMsTrkEnd(InvMsTrkEnd),

        .MsProcFree(MsProcFree),
        .MsProcPut(MsProcPut),
        .MsProcReq(MsProcReq),
        .MsProcPrimCrdRet(MsProcPrimCrdRet),
        .MsProcSecCrdRet(MsProcSecCrdRet),
        .MsProcPendQCrdRet(MsProcPendQCrdRet),
        
        .MsTrkReqCamEn(MsTrkReqCamEn),
        .MsTrkReqCamData(MsTrkReqCamData),
        .MsTrkReqCamHit(MsTrkReqCamHit),
        
        .MsTrkVacant(MsTrkVacant),
        .MsTrkVld(MsTrkVld),
        .MsTrkWrOp(MsTrkWrOp),
        .MsTrkReqPut(MsTrkReqPut),
        .MsTrkReqIdx(MsTrkReqIdx),
        .MsTrkReq(MsTrkReq),
        
        .PendQFull(PendQFull),
        .PendQVacant(PendQVacant),
        .PendQPut(PendQPut),
        .PendQIdx(PendQIdx),
        .PendQReq(PendQReq),
        .PendQWakeAtPut(PendQWakeAtPut),
        .PendQWakeInfoAtPut(PendQWakeInfoAtPut),
        .PendQMsHitIdx(PendQMsHitIdx)
    );
    
//======================================================================================================================
//                                                Miss Tracker Module
//======================================================================================================================
    //mstrk wrt
    logic                            MsTrkReqWrEn;
    logic [DEVTLB_MISSTRK_IDW-1:0]   MsTrkReqWrAddr;
    t_devtlb_request                 MsTrkReqWrData;

    logic                            MsTrkRspWrEn;
    logic [DEVTLB_MISSTRK_IDW-1:0]   MsTrkRspWrAddr;
    t_mstrk_atsrsp                   MsTrkRspWrData;

    //Pendq interface
    logic                            PendQWake;
    t_wakeinfo                       PendQWakeInfo;
    logic [DEVTLB_MISSTRK_IDW-1:0]   PendQWakeMsTrkId;
    //mstrk read - ATS REQ/Fill
    logic                            MsTrkReqRdEn;
    logic [DEVTLB_MISSTRK_IDW-1:0]   MsTrkReqRdAddr;
    t_devtlb_request                 MsTrkReqRdData;
    logic                            MsTrkReqPerr;
    logic [63:0]                     swizzled_atsrsp_data;
    
    logic                            MsTrkRspRdEn;
    logic [DEVTLB_MISSTRK_IDW-1:0]   MsTrkRspRdAddr;
    t_mstrk_atsrsp                   MsTrkRspRdData;
    logic                            MsTrkRspPerr;

    logic                                               prsreq_vld;
    logic [DEVTLB_REQ_PAYLOAD_MSB:DEVTLB_REQ_PAYLOAD_LSB] prsreq_addr;
    logic [DEVTLB_BDF_WIDTH-1:0]                        prsreq_bdf;
    logic [DEVTLB_MISSTRK_IDW-1:0]                      prsreq_id;
    logic                                               prsreq_W, prsreq_R;
    logic                                               prsreq_pasid_vld;
    logic                                               prsreq_pasid_priv;
    logic [DEVTLB_PASID_WIDTH-1:0]                      prsreq_pasid;
    logic                                               prsreq_ack;

   always_comb begin
        //byte swapping atsrsp_data[63:0]
        for (int i=0; i<8; i++) swizzled_atsrsp_data[(i*8) +: 8] = atsrsp_data[((7-i)*8) +: 8];
        
        //PRSREQALLOC_cap = DEVTLB_PRS_SUPP_EN? DEVTLB_MISSTRK_DEPTH[31:0] : '0;
   end
    
    hqm_devtlb_mstrk
    #(
         .NO_POWER_GATING(NO_POWER_GATING),
         .FWDPROG_EN(FWDPROG_EN),
         .PRS_SUPP_EN(DEVTLB_PRS_SUPP_EN),
         .BDF_SUPP_EN(DEVTLB_BDF_SUPP_EN),
         .BDF_WIDTH(DEVTLB_BDF_WIDTH),
         .PASID_SUPP_EN(DEVTLB_PASID_SUPP_EN),
         .PASID_WIDTH(DEVTLB_PASID_WIDTH),
         .XREQ_PORTNUM(DEVTLB_XREQ_PORTNUM),
         .TLB_NUM_ARRAYS(DEVTLB_TLB_NUM_ARRAYS),
         .TLB_NUM_SETS(DEVTLB_TLB_NUM_SETS),
         .TLB_SHARE_EN(DEVTLB_TLB_SHARE_EN),
         .TLB_ALIASING(DEVTLB_TLB_ALIASING),
         .PS_MAX(IOTLB_PS_MAX),
         .PS_MIN(IOTLB_PS_MIN),
         .T_REQ(t_devtlb_request),
         .T_REQ_CTRL(t_devtlb_request_ctrl),
         .T_REQ_INFO(t_devtlb_request_info),
         .T_ATSRSP(t_mstrk_atsrsp),
         .T_OPCODE(t_devtlb_opcode),
         .T_PGSIZE(t_devtlb_page_type),
         .T_SETADDR(t_devtlb_tlb_setaddr),
         .T_FAULTREASON(t_devtlb_fault_reason),
         .READ_LATENCY(DEVTLB_TLB_READ_LATENCY),
         .ATSREQ_PORTNUM(DEVTLB_ATSREQ_PORTNUM),
         .REQ_PAYLOAD_MSB(DEVTLB_REQ_PAYLOAD_MSB),
         .REQ_PAYLOAD_LSB(DEVTLB_REQ_PAYLOAD_LSB),
         .TLBID_WIDTH(DEVTLB_TLBID_WIDTH),
         .MAX_HOST_ADDRESS_WIDTH(DEVTLB_MAX_HOST_ADDRESS_WIDTH),
         .HPMSTRK_CRDT(DEVTLB_HPMSTRK_CRDT),
         .LPMSTRK_CRDT(DEVTLB_LPMSTRK_CRDT),
         .MISSTRK_DEPTH(DEVTLB_MISSTRK_DEPTH)
    ) devtlb_mstrk (
        .clk(clk),
        .reset(local_reset),
        .reset_INST(reset_INST),
        .fscan_clkungate(fscan_clkungate),
        .fscan_latchopen(fscan_latchopen),
        .fscan_latchclosed_b(fscan_latchclosed_b),
        .PwrDnOvrd_nnnH(CrPdoDis_nnnH.pdo_mstrk),
        .CrTLBPsDis(CrTLBPsDis),
        .CrTMaxATSReqEn(CrTMaxATSReqEn),
        .CrTMaxATSReq(CrTMaxATSReq[DEVTLB_MISSTRK_IDW:0]),
        .CrPrsDis(scr_disable_prs),
        .CrPrsCntDis(scr_prs_continuous_retry),
        .CrPrsCnt(3'd7),
        .CrPrsReqAlloc(PRSREQALLOC_alloc[DEVTLB_MISSTRK_IDW:0]),
        .CrPrsStsUprgi(PRSSTS_uprgi),
        .CrPrsStsRf(PRSSTS_rf),
        .CrPrsStsStopped(PRSSTS_stopped),
        
        .MsTrkVacant(MsTrkVacant),
        .MsTrkVld(MsTrkVld),
        .MsTrkWrOp(MsTrkWrOp),
        .MsTrkPut(MsTrkReqPut),
        .MsTrkIdx(MsTrkReqIdx),
        .MsTrkReq(MsTrkReq),
        .MsTrkPrimCrdRet(MsTrkPrimCrdRet),
        .MsTrkSecCrdRet(MsTrkSecCrdRet),
        
        .MsTrkReqWrEn(MsTrkReqWrEn),
        .MsTrkReqWrAddr(MsTrkReqWrAddr),
        .MsTrkReqWrData(MsTrkReqWrData),

        //mstrk read - ATS REQ/Fill
        .MsTrkReqRdEn(MsTrkReqRdEn),
        .MsTrkReqRdAddr(MsTrkReqRdAddr),
        .MsTrkReqRdData(MsTrkReqRdData),
        .MsTrkReqPerr(MsTrkReqPerr),
        
        //Invalidation
        .InvMsTrkStart(InvMsTrkStart),
        .InvMsTrkEnd(InvMsTrkEnd),
        .InvBlockFill(InvBlockFill),
        .InvBDF(InvBDF),
        .InvBdfV(InvBdfV),
        .InvPASID(InvPASID),
        .InvGlob(InvGlob),
        .InvPasidV(InvPasidV),
        .InvAOR(InvAOR),
        .InvAddr(InvAddr),
        .InvAddrMask(InvAddrMask),
        .InvMsTrkBusy(InvMsTrkBusy),
        .MsTrkFillInFlight(MsTrkFillInFlight),
        
        .atsreq_vld(atsreq_valid),
        .atsreq_addr(atsreq_address),
        .atsreq_bdf(atsreq_bdf),
        .atsreq_pasid_vld(atsreq_pasid_valid),
        .atsreq_pasid_priv(atsreq_pasid_priv),
        .atsreq_pasid(atsreq_pasid),
        .atsreq_id(atsreq_id),
        .atsreq_tc(atsreq_tc),
        //.atsreq_vc(atsreq_vc),
        .atsreq_nw(atsreq_nw),
        .atsreq_ack(atsreq_ack),
        
        .atsrsp_vld(atsrsp_valid),
        .atsrsp_sts('0),
        .atsrsp_dperr(atsrsp_dperror),
        .atsrsp_hdrerr(atsrsp_hdrerror),
        .atsrsp_id(atsrsp_id),
        .atsrsp_data(swizzled_atsrsp_data),
        
        .prsreq_vld(prsreq_vld),
        .prsreq_addr(prsreq_addr),
        .prsreq_W(prsreq_W),
        .prsreq_R(prsreq_R),
        .prsreq_bdf(prsreq_bdf),
        .prsreq_id(prsreq_id),
        .prsreq_pasid_vld(prsreq_pasid_vld),
        .prsreq_pasid_priv(prsreq_pasid_priv),
        .prsreq_pasid(prsreq_pasid),
        .prsreq_ack(prsreq_ack),

        .prsrsp_vld(rx_msg_valid && (rx_msg_opcode == 1'b1)),
        .prsrsp_sts(rx_msg_dw2[15:12]),
        .prsrsp_id(rx_msg_dw2[8:0]),  //8:0

        //mstrk rsp write
        .MsTrkRspWrEn(MsTrkRspWrEn),
        .MsTrkRspWrAddr(MsTrkRspWrAddr),
        .MsTrkRspWrData(MsTrkRspWrData),

        //mstrk rsp read - Fill
        .MsTrkRspRdEn(MsTrkRspRdEn),
        .MsTrkRspRdAddr(MsTrkRspRdAddr),
        .MsTrkRspRdData(MsTrkRspRdData),
        .MsTrkRspPerr(MsTrkRspPerr),

        .FillReqV(FillPipeV_100H),
        .FillReq(FillReq_100H),
        .FillCtrl(FillCtrl_100H),
        .FillInfo(FillInfo_100H),
        .FillGnt(FillGnt_100H),

        .FillTLBOutV(FillTLBOutV),
        .FillTLBOutMsTrkIdx(FillTLBOutMsTrkIdx),
        .FillTLBOutInfo(FillTLBOutInfo),

        .PendQWake(PendQWake),
        .PendQWakeInfo(PendQWakeInfo),
        .PendQWakeMsTrkId(PendQWakeMsTrkId)
    );

//======================================================================================================================
//                                                MissTrk Memory Module - Req portion
//======================================================================================================================
    hqm_devtlb_misc_array
    #( .NO_POWER_GATING(NO_POWER_GATING),
       .ARRAY_STYLE(DEVTLB_MISSTRK_ARRAY_STYLE),
       .ENTRY(DEVTLB_MISSTRK_DEPTH),
       .T_ENTRY(t_devtlb_request),
       .CAM_EN(1'b1),
       .T_CAMENTRY(t_devtlb_camreq)
    ) devtlb_mstrkreq_array (
        `HQM_DEVTLB_COMMON_PORTCON_W_SYNC_RESET
        `HQM_DEVTLB_FSCAN_PORTCON
        .PwrDnOvrd_nnnH(CrPdoDis_nnnH.pdo_mstrk),

`ifdef DEVTLB_EXT_MISCRF_EN  //RF-External
        .EXT_RF_CAMEn(EXT_RF_MsTrkReqCAMEn),
        .EXT_RF_CAMData(EXT_RF_MsTrkReqCAMData),
        .EXT_RF_CAMHit(EXT_RF_MsTrkReqCAMHit),

        .EXT_RF_RdEn(EXT_RF_MsTrkReqRdEn),
        .EXT_RF_RdAddr(EXT_RF_MsTrkReqRdAddr),
        .EXT_RF_RdData(EXT_RF_MsTrkReqRdData),

        .EXT_RF_WrEn (EXT_RF_MsTrkReqWrEn),
        .EXT_RF_WrAddr(EXT_RF_MsTrkReqWrAddr),
        .EXT_RF_WrData(EXT_RF_MsTrkReqWrData),
`endif //DEVTLB_EXT_MISCRF_EN  //RF-External

        .CamEn(MsTrkReqCamEn),
        .CamData(MsTrkReqCamData),
        .CamHit(MsTrkReqCamHit),

        .WrEn(MsTrkReqWrEn),
        .WrAddr(MsTrkReqWrAddr),
        .WrData(MsTrkReqWrData),

        .RdEn(MsTrkReqRdEn),
        .RdAddr(MsTrkReqRdAddr),
        .RdData(MsTrkReqRdData),
        .Perr(MsTrkReqPerr)
    );

//======================================================================================================================
//                                                MissTrk Memory Module - Rsp portion
//======================================================================================================================
    hqm_devtlb_misc_array
    #( .NO_POWER_GATING(NO_POWER_GATING),
       .ARRAY_STYLE(DEVTLB_MISSTRK_ARRAY_STYLE),
       .ENTRY(DEVTLB_MISSTRK_DEPTH),
       .T_ENTRY(t_mstrk_atsrsp),
       .CAM_EN(1'b0)
    ) devtlb_mstrkrsp_array (
        `HQM_DEVTLB_COMMON_PORTCON_W_SYNC_RESET
        `HQM_DEVTLB_FSCAN_PORTCON
        .PwrDnOvrd_nnnH(CrPdoDis_nnnH.pdo_mstrk),

`ifdef DEVTLB_EXT_MISCRF_EN  //RF-External
        .EXT_RF_CAMEn(EXT_RF_MsTrkRspCAMEn),
        .EXT_RF_CAMData(EXT_RF_MsTrkRspCAMData),
        .EXT_RF_CAMHit(EXT_RF_MsTrkRspCAMHit),

        .EXT_RF_RdEn(EXT_RF_MsTrkRspRdEn),
        .EXT_RF_RdAddr(EXT_RF_MsTrkRspRdAddr),
        .EXT_RF_RdData(EXT_RF_MsTrkRspRdData),

        .EXT_RF_WrEn (EXT_RF_MsTrkRspWrEn),
        .EXT_RF_WrAddr(EXT_RF_MsTrkRspWrAddr),
        .EXT_RF_WrData(EXT_RF_MsTrkRspWrData),
`endif //DEVTLB_EXT_MISCRF_EN  //RF-External

        .CamEn('0),
        .CamData('0),
        .CamHit(),  // lintra s-0214

        .WrEn(MsTrkRspWrEn),
        .WrAddr(MsTrkRspWrAddr),
        .WrData(MsTrkRspWrData),

        .RdEn(MsTrkRspRdEn),
        .RdAddr(MsTrkRspRdAddr),
        .RdData(MsTrkRspRdData),
        .Perr(MsTrkRspPerr)
    );

//======================================================================================================================
//                                                PendQ Module
//======================================================================================================================
    logic                            PendQWrEn;
    logic [DEVTLB_PENDQ_IDW-1:0]     PendQWrAddr;
    t_devtlb_request                 PendQWrData;

    //PendQ read - ATS REQ/Fill
    logic                            PendQRdEn;
    logic [DEVTLB_PENDQ_IDW-1:0]     PendQRdAddr;
    t_devtlb_request                 PendQRdData;
    logic                            PendQPerr;

    hqm_devtlb_pendq
    #(
         .NO_POWER_GATING(NO_POWER_GATING),
         .T_REQ(t_devtlb_request),
         .XREQ_PORTNUM(DEVTLB_XREQ_PORTNUM),
         .PENDQ_DEPTH(DEVTLB_PENDQ_DEPTH),
         .MISSTRK_DEPTH(DEVTLB_MISSTRK_DEPTH)
    ) devtlb_pendq (
        .clk(clk),
        .reset(local_reset),
        .reset_INST(reset_INST),
        .fscan_clkungate(fscan_clkungate),
        .PwrDnOvrd_nnnH(CrPdoDis_nnnH.pdo_pendq),
        
        .PendQWrEn(PendQWrEn),
        .PendQWrAddr(PendQWrAddr),
        .PendQWrData(PendQWrData),
    
        .PendQRdEn(PendQRdEn),
        .PendQRdAddr(PendQRdAddr),
        .PendQRdData(PendQRdData),
        .PendQPerr(PendQPerr),

        .PendQFull(PendQFull),
        .PendQEmpty(PendQEmpty),
        .PendQVacant(PendQVacant),
        .PendQPut(PendQPut),
        .PendQIdx(PendQIdx),
        .PendQReq(PendQReq),
        .PendQWakeAtPut(PendQWakeAtPut),
        .PendQWakeInfoAtPut(PendQWakeInfoAtPut),
        .PendQMsHitIdx(PendQMsHitIdx),
        
        .PendQWake(PendQWake),
        .PendQWakeInfo(PendQWakeInfo),
        .PendQWakeMsTrkId(PendQWakeMsTrkId),
        .PendQCrdRet(PendQCrdRet),
        .InvMsTrkEnd(InvMsTrkEnd),
        
        .PendQPipeV_100H(PendQPipeV_100H),
        .PendQForceXRsp_100H(PendQForceXRsp_100H),
        .PendQPrsCode_100H(PendQPrsCode_100H),
        .PendQDPErr_100H(PendQDPErr_100H),
        .PendQHdrErr_100H(PendQHdrErr_100H),
        .PendQReq_100H(PendQReq_100H),
        .PendQGnt_100H(PendQGnt_100H)
    );

`ifndef HQM_DEVTLB_SVA_OFF
`HQM_DEVTLB_ASSERTS_TRIGGER(AS_PENDQ_PUTMISSWAKE,
   (PendQPut && ~PendQWakeAtPut && PendQWake),
   (~(PendQMsHitIdx == PendQWakeMsTrkId) || MsTrkVld[PendQMsHitIdx]),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED. New entry missing its WAKE", $time));

`HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(AS_MSPROC_LastMsTrkHit_endedwith_Wake,
   (PendQPut && (~PendQWakeAtPut) && ~MsTrkVld[PendQMsHitIdx]), 1,
   (PendQWake && (PendQWakeMsTrkId == $past(PendQMsHitIdx))),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_MSPROC_PendQStuck,
   (PendQPut && ~PendQWakeAtPut),
   (MsTrkVld[PendQMsHitIdx] || 
    (|(({{(DEVTLB_MISSTRK_DEPTH-1){1'b0}}, 1'b1} << PendQMsHitIdx) & $past(MsTrkVld)))),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("%0t: %m FAILED", $time));

`endif //DEVTLB_SVA_OFF
//======================================================================================================================
//                                                Pendq Memory Module
//======================================================================================================================
    hqm_devtlb_misc_array
    #( .NO_POWER_GATING(NO_POWER_GATING),
       .ARRAY_STYLE(DEVTLB_PENDQ_ARRAY_STYLE),
       .ENTRY(DEVTLB_PENDQ_DEPTH),
       .T_ENTRY(t_devtlb_request),
       .CAM_EN(1'b0)
    ) devtlb_pendq_mem (
        `HQM_DEVTLB_COMMON_PORTCON_W_ASYNC_RESET
        `HQM_DEVTLB_FSCAN_PORTCON
        .PwrDnOvrd_nnnH(CrPdoDis_nnnH.pdo_pendq),

`ifdef DEVTLB_EXT_MISCRF_EN  //RF-External
        .EXT_RF_CAMEn(), // lintra s-0214
        .EXT_RF_CAMData(), // lintra s-0214
        .EXT_RF_CAMHit('0),

        .EXT_RF_RdEn(EXT_RF_PendQRdEn),
        .EXT_RF_RdAddr(EXT_RF_PendQRdAddr),
        .EXT_RF_RdData(EXT_RF_PendQRdData),

        .EXT_RF_WrEn (EXT_RF_PendQWrEn ),
        .EXT_RF_WrAddr(EXT_RF_PendQWrAddr),
        .EXT_RF_WrData(EXT_RF_PendQWrData),
`endif //DEVTLB_EXT_MISCRF_EN  //RF-External

        .CamEn('0),
        .CamData('0),
        .CamHit(), // lintra s-0214

        .WrEn(PendQWrEn),
        .WrAddr(PendQWrAddr),
        .WrData(PendQWrData),

        .RdEn(PendQRdEn),
        .RdAddr(PendQRdAddr),
        .RdData(PendQRdData),
        .Perr(PendQPerr)
    );

//======================================================================================================================
//                                           Custom RF Wrapper
//======================================================================================================================
generate
   hqm_devtlb_custom_rf_wrap
   #(
        .ALLOW_TLBRWCONFLICT(DEVTLB_ALLOW_TLBRWCONFLICT),
        .T_TAG_ENTRY_4K(t_devtlb_iotlb_4k_tag_entry),
        .T_DATA_ENTRY_4K(t_devtlb_iotlb_4k_data_entry),
        .T_TAG_ENTRY_2M(t_devtlb_iotlb_2m_tag_entry),
        .T_DATA_ENTRY_2M(t_devtlb_iotlb_2m_data_entry),
        .T_TAG_ENTRY_1G(t_devtlb_iotlb_1g_tag_entry),
        .T_DATA_ENTRY_1G(t_devtlb_iotlb_1g_data_entry),
        .T_TAG_ENTRY_5T(t_devtlb_iotlb_5t_tag_entry),
        .T_DATA_ENTRY_5T(t_devtlb_iotlb_5t_data_entry),
        .T_TAG_ENTRY_QP(t_devtlb_iotlb_Qp_tag_entry),
        .T_DATA_ENTRY_QP(t_devtlb_iotlb_Qp_data_entry),
        .T_IO_TAG_ENTRY_4K(t_devtlb_io_4k_tag_entry),
        .T_IO_TAG_ENTRY_2M(t_devtlb_io_2m_tag_entry),
        .T_IO_TAG_ENTRY_1G(t_devtlb_io_1g_tag_entry),
        .T_IO_TAG_ENTRY_5T(t_devtlb_io_5t_tag_entry),
        .T_IO_TAG_ENTRY_QP(t_devtlb_io_Qp_tag_entry),
        .T_IO_DATA_ENTRY_4K(t_devtlb_io_4k_data_entry),
        .T_IO_DATA_ENTRY_2M(t_devtlb_io_2m_data_entry),
        .T_IO_DATA_ENTRY_1G(t_devtlb_io_1g_data_entry),
        .T_IO_DATA_ENTRY_5T(t_devtlb_io_5t_data_entry),
        .T_IO_DATA_ENTRY_QP(t_devtlb_io_Qp_data_entry),
        .DEVTLB_TAG_ENTRY_4K_RF_WIDTH(DEVTLB_TAG_ENTRY_4K_RF_WIDTH),
        .DEVTLB_DATA_ENTRY_4K_RF_WIDTH(DEVTLB_DATA_ENTRY_4K_RF_WIDTH),
        .DEVTLB_TAG_ENTRY_2M_RF_WIDTH(DEVTLB_TAG_ENTRY_2M_RF_WIDTH),
        .DEVTLB_DATA_ENTRY_2M_RF_WIDTH(DEVTLB_DATA_ENTRY_2M_RF_WIDTH),
        .DEVTLB_TAG_ENTRY_1G_RF_WIDTH(DEVTLB_TAG_ENTRY_1G_RF_WIDTH),
        .DEVTLB_DATA_ENTRY_1G_RF_WIDTH(DEVTLB_DATA_ENTRY_1G_RF_WIDTH),
        `HQM_DEVTLB_PARAM_PORTCON
   ) devtlb_custom_rf_wrap (
         `HQM_DEVTLB_COMMON_PORTCON_W_SYNC_RESET
         `HQM_DEVTLB_FSCAN_PORTCON
         `HQM_DEVTLB_CUSTOM_RF_PORTCON

         .RF_IOTLB_4k_Tag_RdEn      (RF_IOTLB_4k_Tag_RdEn),
         .RF_IOTLB_4k_Tag_RdAddr    (RF_IOTLB_4k_Tag_RdAddr),
         .RF_IOTLB_4k_Tag_RdData    (RF_IOTLB_4k_Tag_RdData),
         .RF_IOTLB_4k_Tag_WrEn      (RF_IOTLB_4k_Tag_WrEn),
         .RF_IOTLB_4k_Tag_WrAddr    (RF_IOTLB_4k_Tag_WrAddr),
         .RF_IOTLB_4k_Tag_WrData    (RF_IOTLB_4k_Tag_WrData),

         .RF_IOTLB_4k_Data_RdEn     (RF_IOTLB_4k_Data_RdEn),
         .RF_IOTLB_4k_Data_RdAddr   (RF_IOTLB_4k_Data_RdAddr),
         .RF_IOTLB_4k_Data_RdData   (RF_IOTLB_4k_Data_RdData),
         .RF_IOTLB_4k_Data_WrEn     (RF_IOTLB_4k_Data_WrEn),
         .RF_IOTLB_4k_Data_WrAddr   (RF_IOTLB_4k_Data_WrAddr),
         .RF_IOTLB_4k_Data_WrData   (RF_IOTLB_4k_Data_WrData),

         .RF_IOTLB_2m_Tag_RdEn      (RF_IOTLB_2m_Tag_RdEn),
         .RF_IOTLB_2m_Tag_RdAddr    (RF_IOTLB_2m_Tag_RdAddr),
         .RF_IOTLB_2m_Tag_RdData    (RF_IOTLB_2m_Tag_RdData),
         .RF_IOTLB_2m_Tag_WrEn      (RF_IOTLB_2m_Tag_WrEn),
         .RF_IOTLB_2m_Tag_WrAddr    (RF_IOTLB_2m_Tag_WrAddr),
         .RF_IOTLB_2m_Tag_WrData    (RF_IOTLB_2m_Tag_WrData),

         .RF_IOTLB_2m_Data_RdEn     (RF_IOTLB_2m_Data_RdEn),
         .RF_IOTLB_2m_Data_RdAddr   (RF_IOTLB_2m_Data_RdAddr),
         .RF_IOTLB_2m_Data_RdData   (RF_IOTLB_2m_Data_RdData),
         .RF_IOTLB_2m_Data_WrEn     (RF_IOTLB_2m_Data_WrEn),
         .RF_IOTLB_2m_Data_WrAddr   (RF_IOTLB_2m_Data_WrAddr),
         .RF_IOTLB_2m_Data_WrData   (RF_IOTLB_2m_Data_WrData),

         .RF_IOTLB_1g_Tag_RdEn      (RF_IOTLB_1g_Tag_RdEn),
         .RF_IOTLB_1g_Tag_RdAddr    (RF_IOTLB_1g_Tag_RdAddr),
         .RF_IOTLB_1g_Tag_RdData    (RF_IOTLB_1g_Tag_RdData),
         .RF_IOTLB_1g_Tag_WrEn      (RF_IOTLB_1g_Tag_WrEn),
         .RF_IOTLB_1g_Tag_WrAddr    (RF_IOTLB_1g_Tag_WrAddr),
         .RF_IOTLB_1g_Tag_WrData    (RF_IOTLB_1g_Tag_WrData),

         .RF_IOTLB_1g_Data_RdEn     (RF_IOTLB_1g_Data_RdEn),
         .RF_IOTLB_1g_Data_RdAddr   (RF_IOTLB_1g_Data_RdAddr),
         .RF_IOTLB_1g_Data_RdData   (RF_IOTLB_1g_Data_RdData),
         .RF_IOTLB_1g_Data_WrEn     (RF_IOTLB_1g_Data_WrEn),
         .RF_IOTLB_1g_Data_WrAddr   (RF_IOTLB_1g_Data_WrAddr),
         .RF_IOTLB_1g_Data_WrData   (RF_IOTLB_1g_Data_WrData),

         .RF_IOTLB_5t_Tag_RdEn      (RF_IOTLB_5t_Tag_RdEn),
         .RF_IOTLB_5t_Tag_RdAddr    (RF_IOTLB_5t_Tag_RdAddr),
         .RF_IOTLB_5t_Tag_RdData    (RF_IOTLB_5t_Tag_RdData),
         .RF_IOTLB_5t_Tag_WrEn      (RF_IOTLB_5t_Tag_WrEn),
         .RF_IOTLB_5t_Tag_WrAddr    (RF_IOTLB_5t_Tag_WrAddr),
         .RF_IOTLB_5t_Tag_WrData    (RF_IOTLB_5t_Tag_WrData),

         .RF_IOTLB_5t_Data_RdEn     (RF_IOTLB_5t_Data_RdEn),
         .RF_IOTLB_5t_Data_RdAddr   (RF_IOTLB_5t_Data_RdAddr),
         .RF_IOTLB_5t_Data_RdData   (RF_IOTLB_5t_Data_RdData),
         .RF_IOTLB_5t_Data_WrEn     (RF_IOTLB_5t_Data_WrEn),
         .RF_IOTLB_5t_Data_WrAddr   (RF_IOTLB_5t_Data_WrAddr),
         .RF_IOTLB_5t_Data_WrData   (RF_IOTLB_5t_Data_WrData),

         .RF_IOTLB_Qp_Tag_RdEn      (RF_IOTLB_Qp_Tag_RdEn),
         .RF_IOTLB_Qp_Tag_RdAddr    (RF_IOTLB_Qp_Tag_RdAddr),
         .RF_IOTLB_Qp_Tag_RdData    (RF_IOTLB_Qp_Tag_RdData),
         .RF_IOTLB_Qp_Tag_WrEn      (RF_IOTLB_Qp_Tag_WrEn),
         .RF_IOTLB_Qp_Tag_WrAddr    (RF_IOTLB_Qp_Tag_WrAddr),
         .RF_IOTLB_Qp_Tag_WrData    (RF_IOTLB_Qp_Tag_WrData),

         .RF_IOTLB_Qp_Data_RdEn     (RF_IOTLB_Qp_Data_RdEn),
         .RF_IOTLB_Qp_Data_RdAddr   (RF_IOTLB_Qp_Data_RdAddr),
         .RF_IOTLB_Qp_Data_RdData   (RF_IOTLB_Qp_Data_RdData),
         .RF_IOTLB_Qp_Data_WrEn     (RF_IOTLB_Qp_Data_WrEn),
         .RF_IOTLB_Qp_Data_WrAddr   (RF_IOTLB_Qp_Data_WrAddr),
         .RF_IOTLB_Qp_Data_WrData   (RF_IOTLB_Qp_Data_WrData)

   );
endgenerate

//======================================================================================================================
//                                                     tx_msg arbitration (PrsReq and InvRsp)
//======================================================================================================================

logic           ClkTxMsg_H;
logic           pEn_TxMsg;
logic [1:0]     TxMsgArbReq, TxMsgArbGnt;
logic [31:0]    prsreq_dw2, prsreq_dw3;

always_comb begin
    invreqs_active = invreqs_active_i || (tx_msg_valid && ~tx_msg_opcode);

    TxMsgArbReq = {invrsp_valid, prsreq_vld};
    pEn_TxMsg = |{TxMsgArbReq, tx_msg_valid}; 
    {invrsp_ack, prsreq_ack} = TxMsgArbGnt;
    
    prsreq_dw2                     = '0;
    prsreq_dw2[DEVTLB_REQ_PAYLOAD_MSB-32:32-32] = prsreq_addr[DEVTLB_REQ_PAYLOAD_MSB:32]; //TODO temporary 
    prsreq_dw3                     = {prsreq_addr[31:12], {(9-DEVTLB_MISSTRK_IDW){1'b0}}, prsreq_id, 1'b1, prsreq_W, prsreq_R}; //TODO
end

`HQM_DEVTLB_MAKE_LCB_PWR(ClkTxMsg_H,    ClkFree_H, pEn_TxMsg, (CrPdoDis_nnnH.pdo_mstrk && CrPdoDis_nnnH.pdo_inv))

hqm_devtlb_rrarbd #(.REQ_W (2), .REQ_IDW (1))  // lsb first
   tx_msg_arb (.clk (ClkTxMsg_H), .rst_b (~local_nonflreset), .arb_rs (tx_msg_ack || ~tx_msg_valid), .arb_req (TxMsgArbReq), .arb_gnt (TxMsgArbGnt));

`HQM_DEVTLB_RST_MSFF(tx_msg_valid,(tx_msg_valid && ~tx_msg_ack) || (|TxMsgArbGnt),ClkTxMsg_H,local_nonflreset)
`HQM_DEVTLB_EN_MSFF(tx_msg_opcode, (prsreq_ack? 1'b1: 1'b0), ClkTxMsg_H, |TxMsgArbGnt)
`HQM_DEVTLB_EN_MSFF(tx_msg_pasid_valid, (prsreq_ack? prsreq_pasid_vld: '0), ClkTxMsg_H, |TxMsgArbGnt)
`HQM_DEVTLB_EN_MSFF(tx_msg_pasid_priv, (prsreq_ack? prsreq_pasid_priv: '0), ClkTxMsg_H, |TxMsgArbGnt)
`HQM_DEVTLB_EN_MSFF(tx_msg_pasid, (prsreq_ack? prsreq_pasid: '0), ClkTxMsg_H, |TxMsgArbGnt)
`HQM_DEVTLB_EN_MSFF(tx_msg_bdf, (prsreq_ack? prsreq_bdf: invrsp_bdf), ClkTxMsg_H, |TxMsgArbGnt)
`HQM_DEVTLB_EN_MSFF(tx_msg_tc, (prsreq_ack? '0: invrsp_tc), ClkTxMsg_H, |TxMsgArbGnt)
`HQM_DEVTLB_EN_MSFF(tx_msg_dw2, (prsreq_ack? prsreq_dw2: {invrsp_did, 13'h0, invrsp_cc[2:0]}), ClkTxMsg_H, |TxMsgArbGnt) //TODO
`HQM_DEVTLB_EN_MSFF(tx_msg_dw3, (prsreq_ack? prsreq_dw3: invrsp_itag), ClkTxMsg_H, |TxMsgArbGnt)

//======================================================================================================================
//                                                     Xreq tracking
//======================================================================================================================

logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_REQ_ID_WIDTH:0] XReqCnt, NxtXReqCnt;

always_comb begin
    for (int i=0; i<DEVTLB_XREQ_PORTNUM; i++) begin
        NxtXReqCnt[i] = (xreq_valid[i] ^ xrsp_valid[i])? 
                        (XReqCnt[i] + {{(DEVTLB_REQ_ID_WIDTH){xrsp_valid[i]}},1'b1}): XReqCnt[i];
    end
end

generate
for (genvar g_portid=PORT_0; g_portid<DEVTLB_XREQ_PORTNUM; g_portid++) begin : gen_XreqCnt
    `HQM_DEVTLB_EN_RST_MSFF(XReqCnt[g_portid],NxtXReqCnt[g_portid],ClkFree_H,(xreq_valid[g_portid] || xrsp_valid[g_portid]),local_reset)
end
`HQM_DEVTLB_EN_RST_MSFF(xreqs_active, (|NxtXReqCnt), ClkFree_H, (|{xreq_valid, xrsp_valid}), local_reset)
endgenerate

//======================================================================================================================
//Debug Bus
//======================================================================================================================
always_comb begin
   for (int i=0; i<DEVTLB_NUM_DBGPORTS; i++) begin
      debugbus[i] = '0; 
   end

   debugbus[11][7:0] = {tx_msg_dw3[1:0], swizzled_atsrsp_data[1:0], PendQFull, PendQWakeAtPut, ObsIotlbOrgHitVec_nnnH[0][2:1]};
   debugbus[10][7:0] = {InvAOR, TLBOutInfo_nnnH[0].ParityError, TLBOutInfo_nnnH[0].HeaderError, TLBOutInfo_nnnH[0].N, TLBOutInfo_nnnH[0].W, TLBOutInfo_nnnH[0].R, TLBOutCtrl_nnnH[0].InvalBdfMask, TLBOutCtrl_nnnH[0].PendQXReq};
   debugbus[9][7:0] = {{{(3-(1+IOTLB_PS_MAX-IOTLB_PS_MIN)){1'b0}}, TLBOutCtrl_nnnH[0].DisRdEn}, TLBOutReq_nnnH[0].PR, TLBOutReq_nnnH[0].PasidV, TLBOutInfo_nnnH[0].PrsCode, TLBOutReq_nnnH[0].Prs};
   debugbus[8][7:0] = {rx_msg_dperror, rx_msg_pasid_priv, rx_msg_pasid_valid, rx_msg_opcode, rx_msg_valid, tx_msg_pasid_priv, tx_msg_pasid_valid, tx_msg_opcode};
   debugbus[7][7:4] = {tx_msg_valid, ObsIotlbInvBusy_nnnH[2:0]};
   debugbus[7][3:0] = {ObsIotlbPgSInProg_nnnH, ObsIotlbInvPs_nnnH[2:0]};
   debugbus[6][7:0] = {drainreq_valid, InvIfReqAvail, PendQWake, PendQEmpty, PendQPut, atsreq_valid[1:0], MsTrkReqPut};
   debugbus[5][7:0] = {MsTrkFillInFlight, ObsIotlbID_nnnH[0][6:0]};
   debugbus[4][7:0] = {atsrsp_valid, ObsIotlbOrgReqID_nnnH[0][6:0]};
   debugbus[3][7:0] = {ObsIotlbMisc_nnnH[0][1], xrsp_valid[0], ObsIotlbOrgHitVec_nnnH[0][0], TLBOutInfo_nnnH[0].Size[1:0] , TLBOutReq_nnnH[0].Opcode[2:0]};
   debugbus[2][7:4] = {ObsIotlbMisc_nnnH[0][0], TLBOutCtrl_nnnH[0].ForceXRsp, TLBOutCtrl_nnnH[0].Fill, TLBOutReq_nnnH[0].Priority};
   debugbus[2][3:0] = {TLBOutPipeV_nnnH[0], TLBOutInfo_nnnH[0].Status};
   debugbus[1][7:0] = {MsFifoReqAvail[0][1:0], LpMsTrkCrdAvail, HpMsTrkCrdAvail, SharedMsTrkCrdAvail, ObsArbRs_nnnH[1:0], InvBlockDMA};
   debugbus[0][7:4] = {FillPipeV_100H[0], PendQPipeV_100H[0], CbHiPipeV_100H[0], CbLoPipeV_100H[0]};
   debugbus[0][3:0] = {InvPipeV_100H[0], invreqs_active, xreqs_active, InvInitDone};
end

//======================================================================================================================
//                                                     Assertions
//======================================================================================================================

`ifndef HQM_DEVTLB_SVA_OFF
`ifndef LINT_ON

   `HQM_DEVTLB_ASSERTS_TRIGGER( DEVTLB_ImplicitInval_NoXreqPending_allBdf,
        $rose(implicit_invalidation_valid) && ~implicit_invalidation_bdf_valid,
        ~(xreq_valid || xreqs_active),
        posedge clk, reset_INST,
   `HQM_DEVTLB_ERR_MSG("There are outstanding xreq/atsreq when Invalidatoin Invalidation (all BDF) is requested"));

   `HQM_DEVTLB_ASSERTS_TRIGGER( DEVTLB_DisableParityError_Stable,
        xreqs_active,
        $stable(CrParErrInj_nnnH.disable_iotlb_parityerror),
        posedge clk, reset_INST,
   `HQM_DEVTLB_ERR_MSG("defeature_parity_injection.disable_iotlb_parityerror must be stable when xreqs_active==1"));
 
   `HQM_DEVTLB_ASSERTS_TRIGGER( DEVTLB_CrTMaxATSReq_NonZero,
        CrTMaxATSReqEn,
        (/*(DEVTLB_MISSTRK_DEPTH>=16) && */
         (CrTMaxATSReq>=(DEVTLB_HPMSTRK_CRDT+DEVTLB_LPMSTRK_CRDT)) &&
         !(CrTMaxATSReq=='0)),
        posedge clk, reset_INST,
   `HQM_DEVTLB_ERR_MSG("illegal CrTMaxATSReq"));

   `HQM_DEVTLB_ASSERTS_TRIGGER( DEVTLB_scr_spare_stable,
        xreqs_active,
        $stable(scr_spare),
        posedge clk, reset_INST,
   `HQM_DEVTLB_ERR_MSG("scr_spare must be stable when xreqs_active==1"));

 `HQM_DEVTLB_ASSERTS_MUST( IOMMU_tlbid_width_log2_of_num_tlb_arrays,
      DEVTLB_TLBID_WIDTH == `HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_ARRAYS), posedge clk, reset_INST,
   `HQM_DEVTLB_ERR_MSG("TLBID Width = LOG2(IOTLB NUM Arrays)"));

   logic [4:0][31:0] iotlb_set_count;
   logic [4:0][31:0] pwc_set_count;
   logic [4:0][31:0] rcc_set_count;

   generate
      always_comb begin: sva_tlb_set_cnts
         iotlb_set_count = '0;
         pwc_set_count   = '0;
         rcc_set_count   = '0;

         for (int id=0; id<DEVTLB_TLB_NUM_ARRAYS; id++) begin: sva_iotlb_tlbid
            for (int ps=IOTLB_PS_MIN; ps<=IOTLB_PS_MAX; ps++) begin: sva_iotlb_ps
               iotlb_set_count[ps] += DEVTLB_TLB_NUM_SETS[id][ps];
            end
         end

      end

      `HQM_DEVTLB_ASSERTS_MUST( IOMMU_iotlb_tlbid_setCount_proper,
           (DEVTLB_TLB_NUM_PS_SETS[0] == iotlb_set_count[0])
         & (DEVTLB_TLB_NUM_PS_SETS[1] == iotlb_set_count[1])
         & (DEVTLB_TLB_NUM_PS_SETS[2] == iotlb_set_count[2])
         & (DEVTLB_TLB_NUM_PS_SETS[3] == iotlb_set_count[3])
         ,
         posedge clk, reset_INST,
      `HQM_DEVTLB_ERR_MSG("IOTLB has nonzero TLB size for unsupported TLBID"));

      for (genvar g_i=0; g_i<DEVTLB_TLB_NUM_ARRAYS; g_i++) begin: sva_iotlb_tlbid
         for (genvar g_p=0; g_p<3; g_p++) begin: sva_iotlb_ps
            if ( (g_p < IOTLB_PS_MIN) | (g_p > IOTLB_PS_MAX) ) begin : ps_improper
               `HQM_DEVTLB_ASSERTS_MUST( IOMMU_iotlb_PS_setCount_proper,
                  DEVTLB_TLB_NUM_SETS[`HQM_DEVTLB_GET_TLBID(g_i, g_p)][g_p] == '0,
                  posedge clk, reset_INST,
               `HQM_DEVTLB_ERR_MSG("IOTLB has nonzero TLB size for unsupported PS"));
            end
         end
      end

      for (genvar g_i=0; g_i<DEVTLB_TLB_NUM_ARRAYS; g_i++) begin: sva_iotlb_aliasing
       `HQM_DEVTLB_ASSERTS_MUST( IOMMU_iotlb_PS_4K_No_Sharing,
          `HQM_DEVTLB_GET_TLBID(g_i, 0) == g_i,
          posedge clk, reset_INST,
       `HQM_DEVTLB_ERR_MSG("Sharing of 4K PS TLB by multiple uTLBs is not supported"));
        for (genvar g_p=IOTLB_PS_MIN; g_p<=IOTLB_PS_MAX; g_p++) begin: sva_iotlb_aliasing_ps
           `HQM_DEVTLB_ASSERTS_MUST( IOMMU_iotlb_PS_No_SharingPrivate_Mix,
              ((DEVTLB_TLB_NUM_SETS[g_i][g_p] == '0) ||
               (`HQM_DEVTLB_GET_TLBID(g_i, g_p) == g_i)),
              posedge clk, reset_INST,
           `HQM_DEVTLB_ERR_MSG("Mixture of Shared and Private uTLB is not allowed"));
        end
      end
  
      for (g_ps = IOTLB_PS_MIN; g_ps <= IOTLB_PS_MAX; g_ps++)  begin: gen_Iotlb_Array_Style
         `HQM_DEVTLB_ASSERTS_MUST( IOMMU_ARRAY_STYLE_Legal_IOTLB,
            (DEVTLB_TLB_ARRAY_STYLE [g_ps]        == ARRAY_LATCH) ||
            (DEVTLB_TLB_ARRAY_STYLE [g_ps]        == ARRAY_FPGA) ||
            (DEVTLB_TLB_ARRAY_STYLE [g_ps]        == ARRAY_RF) ||
            (DEVTLB_TLB_ARRAY_STYLE [g_ps]        == ARRAY_MSFF),
         posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("ARRAY_STYLE value is legal"));
      end

       for (g_id = PORT_0; g_id < DEVTLB_XREQ_PORTNUM; g_id++)  begin: gen_as_xrsp
            `HQM_DEVTLB_ASSERTS_TRIGGER(AS_DMA_XRSP_RESULT_1,
               (xrsp_valid[g_id] && ((xrsp_opcode[g_id]==DEVTLB_OPCODE_UTRN_W) || (xrsp_opcode[g_id]==DEVTLB_OPCODE_UTRN_R)) && xrsp_result[g_id][0]),
               (resp_status[g_id]==DEVTLB_RESP_HIT_VALID),
               posedge clk, reset_INST,
            `HQM_DEVTLB_ERR_MSG("XRSP result ==1 but status is not DEVTLB_RESP_HIT_VALID."));

            `HQM_DEVTLB_ASSERTS_TRIGGER(AS_EVICT_XRSP_RESULT,
               (xrsp_valid[g_id] && (xrsp_opcode[g_id]==DEVTLB_OPCODE_UARCH_INV)),
               xrsp_result[g_id][0] && ((resp_status[g_id]==DEVTLB_RESP_INV_HIT) || (resp_status[g_id]==DEVTLB_RESP_INV_MISS)),
               posedge clk, reset_INST,
            `HQM_DEVTLB_ERR_MSG("XRSP result ==1 but status is not DEVTLB_RESP_HIT_VALID."));

            `HQM_DEVTLB_ASSERTS_TRIGGER(AS_XRSP_PRSCODE_1,
               (xrsp_valid[g_id] && xrsp_result[g_id][0]),
               (xrsp_prs_code[g_id]==DEVTLB_PRSRSP_SUC),
               posedge clk, reset_INST,
            `HQM_DEVTLB_ERR_MSG("XRSP result ==1 but status is not DEVTLB_RESP_HIT_VALID."));
            `HQM_DEVTLB_ASSERTS_TRIGGER(AS_XRSP_PRSCODE_2,
               (xrsp_valid[g_id] && (xrsp_prs_code[g_id]!=DEVTLB_PRSRSP_SUC)),
               ~xrsp_result[g_id][0],
               posedge clk, reset_INST,
            `HQM_DEVTLB_ERR_MSG("XRSP result ==1 but status is not DEVTLB_RESP_HIT_VALID."));
       end
   endgenerate

   `HQM_DEVTLB_COVERS_DELAYED_TRIGGER( IOMMU_TLB_Inval_PendQMISS,
            $fell(InvBlockDMA), 3,
            (TLB_NUM_PORTS[0].devtlb_tlb.TLBMissPipeV_nnnH && TLB_NUM_PORTS[0].devtlb_tlb.TLBPipe_H[103].Ctrl.PendQXReq
            && ~TLB_NUM_PORTS[0].devtlb_tlb.TLBPipe_H[103].Ctrl.ForceXRsp), 
      posedge clk, reset_INST,
   `HQM_DEVTLB_COVER_MSG("PendQ Request Miss due to Inval"));

   `HQM_DEVTLB_COVERS_TRIGGER( IOMMU_TLB_Inval_XReq_InvReqQAvail,
            (~InvBlockDMA) && ObsIotlbInvBusy_nnnH[0] && InvIfReqAvail,  //devtlb_inv.InvDrainBusy
            |{CbLoGnt_100H, CbHiGnt_100H}, 
      posedge clk, reset_INST,
   `HQM_DEVTLB_COVER_MSG("Xreq is served while InvIfReqAvail"));

   `HQM_DEVTLB_COVERS_TRIGGER( IOMMU_TLB_Inval_FillPendQReq_InvReqQAvail,
            (~InvBlockDMA) && ObsIotlbInvBusy_nnnH[0] && InvIfReqAvail,  //devtlb_inv.InvDrainBusy
            |{PendQGnt_100H, FillGnt_100H}, 
      posedge clk, reset_INST,
   `HQM_DEVTLB_COVER_MSG("FIll or PendQReq is served while InvIfReqAvail"));


// Parity errors should not be seen in dynamic if not injected
`ifndef FPV

/*`HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_Parity_error_never_seen_unless_injected,
   |tlb_tag_parity_err || |tlb_data_parity_err,
   |defeature_parity_injection,
   clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("Parity errors cannot happen in dynamic simulation."));
*/

`HQM_DEVTLB_ASSERTS_MUST(DEVTLB_Unused_Ports_Are_Idle,
   ~(|ActivityOnNZWrPorts_nnnH),
   posedge clk, reset_INST,
`HQM_DEVTLB_ERR_MSG("Activity seen on unused ports."));

final begin : ASF_DEVTLB_IDLE
    assert (SharedMsTrkCrd==DEVTLB_SHAREDMSTRK_CRDT) 
    `HQM_DEVTLB_ERR_MSG("End Of Sim Check %m FAILED: SharedMsTrkCrd is not balance.");
    assert (HpMsTrkCrd==DEVTLB_HPMSTRK_CRDT) 
    `HQM_DEVTLB_ERR_MSG("End Of Sim Check %m FAILED: HpMsTrkCrd is not balance.");
    assert (LpMsTrkCrd==DEVTLB_LPMSTRK_CRDT) 
    `HQM_DEVTLB_ERR_MSG("End Of Sim Check %m FAILED: LpMsTrkCrd is not balance.");
end

`endif

`endif //DEVTLB_SVA_OFF
`endif //~LINT_ON

endmodule


//======================================================================================================================
//                                                FPV Reference Model
//======================================================================================================================

// Dynamic Validation instantiation of the FPV Environment
//    To disable, declare DEVTLB_FPV_REF_DIS during compile
//
`ifdef  HQM_DEVTLB_SIMONLY
`ifndef DEVTLB_FPV_REF_DIS
`ifndef DC
`ifndef INTEL_EMULATION
`ifndef FPV
`ifndef LINT_ON

//   put anything to Enable FPV here
//   `include "devtlb_top.va"
//   bind devtlb devtlb_top #() devtlb_ref_top(.*);

`endif // ~LINT_ON
`endif // ~FPV
`endif // ~INTEL_EMULATION
`endif // ~DC
`endif // DEVTLB_FPV_REF_DIS
`endif // DEVTLB_SIMONLY

`undef HQM_DEVTLB_PACKAGE_NAME

`endif // DEVTLB_VS

