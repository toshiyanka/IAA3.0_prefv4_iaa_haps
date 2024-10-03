//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
// devtlb includes

`include "hqm_devtlb_macros.vh"
`include "hqm_devtlb_globals_int.vh"        // Common Parameters that are not used by parent hierarchies
`include "hqm_devtlb_params.vh"
`include "hqm_devtlb_globals_ext.vh"        // Common Parameters that may be used by parent hierarchies
`include "hqm_devtlb_types.vh"              // Structure, Enum, Union Definitions

module hqm_ti

     import hqm_sfi_pkg::*, hqm_AW_pkg::*, hqm_pkg::*, hqm_sif_pkg::*, hqm_system_pkg::*, hqm_system_type_pkg::*, hqm_system_func_pkg::*, hqm_sif_csr_pkg::*;
#(

//`include "hqm_sfi_params.sv"

    parameter HQM_SFI_RX_BCM_EN                = 1,     // Fixed
    parameter HQM_SFI_RX_BLOCK_EARLY_VLD_EN    = 1,    // Fixed
    parameter HQM_SFI_RX_D                     = 32,    // Fixed
    parameter HQM_SFI_RX_DATA_AUX_PARITY_EN    = 1,     // Fixed
    parameter HQM_SFI_RX_DATA_CRD_GRAN         = 4,     // Fixed
    parameter HQM_SFI_RX_DATA_INTERLEAVE       = 0,     // Fixed
    parameter HQM_SFI_RX_DATA_LAYER_EN         = 1,     // Fixed
    parameter HQM_SFI_RX_DATA_PARITY_EN        = 1,     // Fixed
    parameter HQM_SFI_RX_DATA_PASS_HDR         = 0,     // Fixed
    parameter HQM_SFI_RX_DATA_MAX_FC_VC        = 1,     // Fixed
    parameter HQM_SFI_RX_DS                    = 1,     // Fixed
    parameter HQM_SFI_RX_ECRC_SUPPORT          = 0,     // Fixed
    parameter HQM_SFI_RX_FLIT_MODE_PREFIX_EN   = 0 ,    // Fixed
    parameter HQM_SFI_RX_FATAL_EN              = 0,     // Fixed
    parameter HQM_SFI_RX_H                     = 32,    // Fixed
    parameter HQM_SFI_RX_HDR_DATA_SEP          = 1 ,    // Fixed
    parameter HQM_SFI_RX_HDR_MAX_FC_VC         = 1 ,    // Fixed
    parameter HQM_SFI_RX_HGRAN                 = 4,     // Fixed
    parameter HQM_SFI_RX_HPARITY               = 1,     // Fixed
    parameter HQM_SFI_RX_IDE_SUPPORT           = 0,    // Fixed
    parameter HQM_SFI_RX_M                     = 1,    // Fixed
    parameter HQM_SFI_RX_MAX_CRD_CNT_WIDTH     = 12,    // Fixed: Width of agent RX credit counters
    parameter HQM_SFI_RX_MAX_HDR_WIDTH         = 32 ,   // Fixed
    parameter HQM_SFI_RX_NDCRD                 = 4 ,    // Fabric data   credit return value width
    parameter HQM_SFI_RX_NHCRD                 = 4 ,    // Fabric header credit return value width
    parameter HQM_SFI_RX_NUM_SHARED_POOLS      = 0 ,    // Fixed
    parameter HQM_SFI_RX_PCIE_MERGED_SELECT    = 0 ,    // Fixed
    parameter HQM_SFI_RX_PCIE_SHARED_SELECT    = 0 ,    // Fixed
    parameter HQM_SFI_RX_RBN                   = 3 ,    // Fixed
    parameter HQM_SFI_RX_SH_DATA_CRD_BLK_SZ    = 1 ,    // Fixed
    parameter HQM_SFI_RX_SH_HDR_CRD_BLK_SZ     = 1 ,    // Fixed
    parameter HQM_SFI_RX_SHARED_CREDIT_EN      = 0 ,    // Fixed
    parameter HQM_SFI_RX_TBN                   = 1 ,    // Cycles after agent hdr/data_block is received before fabric TX stalls
    parameter HQM_SFI_RX_TX_CRD_REG            = 1 ,    // Fixed
    parameter HQM_SFI_RX_VIRAL_EN              = 0 ,    // Fixed
    parameter HQM_SFI_RX_VR                    = 0  ,   // Fixed
    parameter HQM_SFI_RX_VT                    = 0  ,   // Fixed

    parameter HQM_SFI_TX_BCM_EN                = 1 ,   // Fixed
    parameter HQM_SFI_TX_BLOCK_EARLY_VLD_EN    = 1 ,    // Fixed
    parameter HQM_SFI_TX_D                     = 32 ,   // Fixed
    parameter HQM_SFI_TX_DATA_AUX_PARITY_EN    = 1 ,    // Fixed
    parameter HQM_SFI_TX_DATA_CRD_GRAN         = 4 ,    // Fixed
    parameter HQM_SFI_TX_DATA_INTERLEAVE       = 0 ,    // Fixed
    parameter HQM_SFI_TX_DATA_LAYER_EN         = 1 ,    // Fixed
    parameter HQM_SFI_TX_DATA_PARITY_EN        = 1 ,    // Fixed
    parameter HQM_SFI_TX_DATA_PASS_HDR         = 0 ,    // Fixed
    parameter HQM_SFI_TX_DATA_MAX_FC_VC        = 1,     // Fixed
    parameter HQM_SFI_TX_DS                    = 1 ,    // Fixed
    parameter HQM_SFI_TX_ECRC_SUPPORT          = 0 ,    // Fixed
    parameter HQM_SFI_TX_FLIT_MODE_PREFIX_EN   = 0 ,    // Fixed
    parameter HQM_SFI_TX_FATAL_EN              = 0  ,   // Fixed
    parameter HQM_SFI_TX_H                     = 32 ,   // Fixed
    parameter HQM_SFI_TX_HDR_DATA_SEP          = 1  ,   // Fixed
    parameter HQM_SFI_TX_HDR_MAX_FC_VC         = 1  ,   // Fixed
    parameter HQM_SFI_TX_HGRAN                 = 4  ,   // Fixed
    parameter HQM_SFI_TX_HPARITY               = 1  ,   // Fixed
    parameter HQM_SFI_TX_IDE_SUPPORT           = 0  ,   // Fixed
    parameter HQM_SFI_TX_M                     = 1  ,   // Fixed
    parameter HQM_SFI_TX_MAX_CRD_CNT_WIDTH     = 12 ,   // Width of agent TX credit counters
    parameter HQM_SFI_TX_MAX_HDR_WIDTH         = 32 ,   // Fixed
    parameter HQM_SFI_TX_NDCRD                 = 4  ,   // Fabric data   credit return value width
    parameter HQM_SFI_TX_NHCRD                 = 4  ,   // Fabric header credit return value width
    parameter HQM_SFI_TX_NUM_SHARED_POOLS      = 0  ,   // Fixed
    parameter HQM_SFI_TX_PCIE_MERGED_SELECT    = 0  ,   // Fixed
    parameter HQM_SFI_TX_PCIE_SHARED_SELECT    = 0  ,   // Fixed
    parameter HQM_SFI_TX_RBN                   = 1  ,   // Cycles after fabric hdr/data_crd_rtn_block is received before agent RX stalls
    parameter HQM_SFI_TX_SH_DATA_CRD_BLK_SZ    = 1 ,    // Fixed
    parameter HQM_SFI_TX_SH_HDR_CRD_BLK_SZ     = 1  ,   // Fixed
    parameter HQM_SFI_TX_SHARED_CREDIT_EN      = 0  ,   // Fixed
    parameter HQM_SFI_TX_TBN                   = 3  ,   // Fixed
    parameter HQM_SFI_TX_TX_CRD_REG            = 1  ,   // Fixed
    parameter HQM_SFI_TX_VIRAL_EN              = 0  ,   // Fixed
    parameter HQM_SFI_TX_VR                    = 0   ,  // Fixed
    parameter HQM_SFI_TX_VT                    = 0     // Fixed

) (
     input  logic                                           prim_nonflr_clk
    ,input  logic                                           prim_gated_rst_b
    ,input  logic                                           prim_gated_wflr_rst_b

    ,input  logic                                           hqm_csr_pf0_rst_n               // PF reset

    ,input  logic                                           flr_treatment_vec

    //-------------------------------------------------------------------------------------------------
    // Configuration

    ,input  logic [SAI_WIDTH:0]                             strap_hqm_tx_sai                // SAI used for P/NP transactions
    ,input  logic [SAI_WIDTH:0]                             strap_hqm_cmpl_sai              // SAI used for Cpl  transactions

    ,input  logic [7:0]                                     current_bus                     // Captured bus number

    ,input  logic                                           cfg_ats_enabled                 // ATS capability enabled
    ,input  MSTR_LL_CTL_t                                   cfg_mstr_ll_ctl                 // Linked list control
    ,input  logic                                           cfg_mstr_par_off                // No parity checking
    ,input  SCRBD_CTL_t                                     cfg_scrbd_ctl                   // Scoreboard control

    ,input  DEVTLB_CTL_t                                    cfg_devtlb_ctl                  // Devtlb control
    ,input  DEVTLB_SPARE_t                                  cfg_devtlb_spare                // Devtlb spares
    ,input  DEVTLB_DEFEATURE0_t                             cfg_devtlb_defeature0           // Devtlb defeature bits
    ,input  DEVTLB_DEFEATURE1_t                             cfg_devtlb_defeature1
    ,input  DEVTLB_DEFEATURE2_t                             cfg_devtlb_defeature2

    ,input  logic                                           cfg_ph_trigger_enable           // Address match trigger controls
    ,input  logic [63:0]                                    cfg_ph_trigger_addr
    ,input  logic [63:0]                                    cfg_ph_trigger_mask

    ,input  HQM_SIF_CNT_CTL_t                               hqm_sif_cnt_ctl

    ,input  DIR_CQ2TC_MAP_t                                 dir_cq2tc_map                   // Traffic class mapping control
    ,input  LDB_CQ2TC_MAP_t                                 ldb_cq2tc_map
    ,input  INT2TC_MAP_t                                    int2tc_map

    ,input  logic                                           csr_ppdcntl_ero                 // Enable relaxed ordering

    ,input  logic [HQM_SCRBD_DEPTH_WIDTH:0]                 cfg_ibcpl_hdr_fifo_high_wm      // FIFO high watermarks
    ,input  logic [HQM_SCRBD_DEPTH_WIDTH:0]                 cfg_ibcpl_data_fifo_high_wm

    ,output logic [31:0]                                    cfg_ibcpl_hdr_fifo_status       // FIFO status
    ,output logic [31:0]                                    cfg_ibcpl_data_fifo_status

    ,output new_DEVTLB_STATUS_t                             devtlb_status                   // Devtlb status
    ,output new_MSTR_FL_STATUS_t                            mstr_fl_status                  // Freelist status
    ,output new_MSTR_LL_STATUS_t                            mstr_ll_status                  // Linked list status
    ,output new_SCRBD_STATUS_t                              scrbd_status                    // Scoreboard status

    ,output new_LOCAL_BME_STATUS_t                          local_bme_status                // Local BME/MSIXE
    ,output new_LOCAL_MSIXE_STATUS_t                        local_msixe_status

    //-------------------------------------------------------------------------------------------------
    // Write Buffer interface

    ,output logic                                           write_buffer_mstr_ready

    ,input  logic                                           write_buffer_mstr_v
    ,input  write_buffer_mstr_t                             write_buffer_mstr

    //-------------------------------------------------------------------------------------------------
    // Outbound completions

    ,output logic                                           obcpl_ready                     // Outbound completion ready

    ,input  logic                                           obcpl_v                         // Outbound completion valid
    ,input  RiObCplHdr_t                                    obcpl_hdr                       // Outbound completion header
    ,input  csr_data_t                                      obcpl_data                      // Outbound completion data
    ,input  logic                                           obcpl_dpar                      // Outbound completion data parity
    ,input  upd_enables_t                                   obcpl_enables                   // Outbound completion enable updates

    ,input  upd_enables_t                                   gpsb_upd_enables

    //-------------------------------------------------------------------------------------------------
    // Inbound completions

    ,input  logic                                           ibcpl_hdr_push                  // Inbound completion header push
    ,input  tdl_cplhdr_t                                    ibcpl_hdr

    ,input  logic                                           ibcpl_data_push                 // Inbound completion data push
    ,input  logic [HQM_IBCPL_DATA_WIDTH-1:0]                ibcpl_data
    ,input  logic [HQM_IBCPL_PARITY_WIDTH-1:0]              ibcpl_data_par                  // Parity per DW

    //-------------------------------------------------------------------------------------------------
    // RI to devtlb invalidate request

    ,input  logic                                           rx_msg_v                        // Invalidate request valid
    ,input  hqm_devtlb_rx_msg_t                             rx_msg                          // Invalidate request

    //-------------------------------------------------------------------------------------------------
    // Agent TX Credit interface

    ,input  logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_hcrds_avail  // Available TX hdr  credits
    ,input  logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_dcrds_avail  // Available TX data credits

    ,output logic                                           tx_hcrd_consume_v               // Consuming TX hdr  credits
    ,output logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             tx_hcrd_consume_vc
    ,output hqm_sfi_fc_id_t                                 tx_hcrd_consume_fc
    ,output logic                                           tx_hcrd_consume_val

    ,output logic                                           tx_dcrd_consume_v               // Consuming TX data credits
    ,output logic [HQM_SFI_TX_DATA_VC_WIDTH-1:0]            tx_dcrd_consume_vc
    ,output hqm_sfi_fc_id_t                                 tx_dcrd_consume_fc
    ,output logic [2:0]                                     tx_dcrd_consume_val

    //-------------------------------------------------------------------------------------------------
    // Agent Transmit interface

    ,output logic                                           agent_tx_v                      // Agent master transaction
    ,output logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             agent_tx_vc
    ,output hqm_sfi_fc_id_t                                 agent_tx_fc
    ,output logic [3:0]                                     agent_tx_hdr_size
    ,output logic                                           agent_tx_hdr_has_data
    ,output hqm_sfi_flit_header_t                           agent_tx_hdr
    ,output logic                                           agent_tx_hdr_par
    ,output logic [(HQM_SFI_TX_D*16)-1:0]                   agent_tx_data
    ,output logic [(HQM_SFI_TX_D/4)-1:0]                    agent_tx_data_par

    ,input  logic                                           agent_tx_ack

    //-------------------------------------------------------------------------------------------------
    // FLR and PS change

    ,input  logic                                           func_in_rst                     // Function being reset

    ,input  logic                                           flr_txn_sent                    // FLR write received
    ,input  nphdr_tag_t                                     flr_txn_tag
    ,input  hdr_reqid_t                                     flr_txn_reqid

    ,output logic                                           flr_triggered                   // FLR write Cpl sent

    ,input  logic                                           ps_txn_sent                     // PS write received
    ,input  nphdr_tag_t                                     ps_txn_tag
    ,input  hdr_reqid_t                                     ps_txn_reqid

    //-------------------------------------------------------------------------------------------------
    // Reset Prep Handling Interface

    ,input  logic                                           sif_mstr_quiesce_req            // Quiesce master request
    ,output logic                                           sif_mstr_quiesce_ack            // Master is quiesced

    //-------------------------------------------------------------------------------------------------
    // Status and errors

    ,output logic                                           ti_idle                         // TI is IDLE for clkreq
    ,output logic                                           ti_intf_idle                    // TI is IDLE for ISM

    ,output logic                                           np_trans_pending                // For PCIe Device Status reg

    ,output logic                                           poisoned_wr_sent                // For PCIe MDPE

    ,output logic                                           cpl_abort                       // Completer abort error
    ,output logic                                           cpl_poisoned                    // Completion poisoned error
    ,output logic                                           cpl_unexpected                  // Completion unexpected error
    ,output logic                                           cpl_usr                         // Completion UR
    ,output tdl_cplhdr_t                                    cpl_error_hdr                   // Completion error header

    ,output logic                                           cpl_timeout                     // Completion timeout error
    ,output logic [8:0]                                     cpl_timeout_synd                // Completion timeout syndrome

    ,output logic                                           sif_parity_alarm                // Parity error -> alarm
    ,output logic [8:0]                                     set_sif_parity_err              // Parity error -> syndrome

    ,output logic                                           devtlb_ats_alarm                // devtlb error -> alarm
    ,output load_DEVTLB_ATS_ERR_t                           set_devtlb_ats_err              // devtlb error -> syndrome

    ,output logic [1:0] [31:0]                              mstr_cnts                       // Drop counter

    ,output logic                                           ph_trigger                      // Address compare trigger output

    //-------------------------------------------------------------------------------------------------
    // Debug

    ,output new_SIF_MSTR_DEBUG_t                            sif_mstr_debug
    ,output new_MSTR_CRD_STATUS_t                           mstr_crd_status                 // MSTR credit status
    ,output logic [191:0]                                   noa_mstr

    //-------------------------------------------------------------------------------------------------
    // Scan

    ,input  logic                                           fscan_byprst_b
    ,input  logic                                           fscan_clkungate
    ,input  logic                                           fscan_clkungate_syn
    ,input  logic                                           fscan_latchclosed_b
    ,input  logic                                           fscan_latchopen
    ,input  logic                                           fscan_mode
    ,input  logic                                           fscan_rstbypen
    ,input  logic                                           fscan_shiften

    //-------------------------------------------------------------------------------------------------
    // Memory interfaces

    ,output hqm_sif_memi_scrbd_mem_t                        memi_scrbd_mem
    ,input  hqm_sif_memo_scrbd_mem_t                        memo_scrbd_mem

    ,output hqm_sif_memi_ibcpl_hdr_t                        memi_ibcpl_hdr_fifo
    ,input  hqm_sif_memo_ibcpl_hdr_t                        memo_ibcpl_hdr_fifo

    ,output hqm_sif_memi_ibcpl_data_t                       memi_ibcpl_data_fifo
    ,input  hqm_sif_memo_ibcpl_data_t                       memo_ibcpl_data_fifo

    ,output hqm_sif_memi_mstr_ll_hpa_t                      memi_mstr_ll_hpa
    ,input  hqm_sif_memo_mstr_ll_hpa_t                      memo_mstr_ll_hpa

    ,output hqm_sif_memi_mstr_ll_hdr_t                      memi_mstr_ll_hdr
    ,input  hqm_sif_memo_mstr_ll_hdr_t                      memo_mstr_ll_hdr

    ,output hqm_sif_memi_mstr_ll_data_t                     memi_mstr_ll_data0
    ,input  hqm_sif_memo_mstr_ll_data_t                     memo_mstr_ll_data0

    ,output hqm_sif_memi_mstr_ll_data_t                     memi_mstr_ll_data1
    ,input  hqm_sif_memo_mstr_ll_data_t                     memo_mstr_ll_data1

    ,output hqm_sif_memi_mstr_ll_data_t                     memi_mstr_ll_data2
    ,input  hqm_sif_memo_mstr_ll_data_t                     memo_mstr_ll_data2

    ,output hqm_sif_memi_mstr_ll_data_t                     memi_mstr_ll_data3
    ,input  hqm_sif_memo_mstr_ll_data_t                     memo_mstr_ll_data3

    ,output hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag0_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag0_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag1_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag1_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag2_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag2_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag3_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag3_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag4_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag4_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag5_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag5_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag6_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag6_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                       memi_tlb_tag7_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                       memo_tlb_tag7_4k

    ,output hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data0_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data0_4k
    ,output hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data1_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data1_4k
    ,output hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data2_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data2_4k
    ,output hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data3_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data3_4k
    ,output hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data4_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data4_4k
    ,output hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data5_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data5_4k
    ,output hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data6_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data6_4k
    ,output hqm_sif_memi_tlb_data_4k_t                      memi_tlb_data7_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                      memo_tlb_data7_4k
);

//----------------------------------------------------------------------------------------------------
// devtlb includes

`include "hqm_devtlb_globals_int.vh"        // Common Parameters that are not used by parent hierarchies
`include "hqm_devtlb_params.vh"
`include "hqm_devtlb_globals_ext.vh"        // Common Parameters that may be used by parent hierarchies
`include "hqm_devtlb_types.vh"              // Structure, Enum, Union Definitions

//----------------------------------------------------------------------------------------------------

localparam HQM_MSTR_P_LL          = HQM_MSTR_NUM_CQS;                       // P   LL #
localparam HQM_MSTR_NP_LL         = HQM_MSTR_NUM_CQS + 1;                   // NP  LL #
localparam HQM_MSTR_CPL_LL        = HQM_MSTR_NUM_CQS + 2;                   // Cpl LL #
localparam HQM_MSTR_INT_LL        = HQM_MSTR_NUM_CQS + 3;                   // Int LL #
localparam DEVTLB_HCB_DEPTH_WIDTH = AW_logb2(DEVTLB_HCB_DEPTH)+1;
localparam DEVTLB_LCB_DEPTH_WIDTH = AW_logb2(DEVTLB_LCB_DEPTH)+1;

//----------------------------------------------------------------------------------------------------
// devtlb interface signals

logic                                                   devtlb_reset;
logic [9:0]                                             devtlb_reset_q;
logic                                                   devtlb_flr;
logic [9:0]                                             devtlb_flr_q;

logic                                                   cfg_ats_enabled_q;
logic                                                   cfg_ats_enabled_redge;

logic                                                   xreqs_active;               // O: IOMMU is currently not performing any translation requests or sequencer flows
logic                                                   tlb_reset_active;           // O: high is tlb inv due to reset or implicit inval is in progress.
logic                                                   invreqs_active;             // O: high is any inv req in invq.

logic                                                   imp_invalidation_v;         // I: Triggers an invalidation of all IOMMU TLBs/PWCs.
logic                                                   imp_invalidation_bdf_v;     // I:
logic [DEVTLB_BDF_WIDTH-1:0]                            imp_invalidation_bdf;       // I:

logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]                    scr_loxreq_gcnt;            // I: TLB Arbiter Grant count, one based.
logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]                    scr_hixreq_gcnt;            // I:
logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]                    scr_pendq_gcnt;             // I:
logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]                    scr_fill_gcnt;              // I:
logic                                                   scr_prs_continuous_retry;   // I:
logic                                                   scr_disable_prs;            // I:
logic                                                   scr_disable_2m;             // I:
logic                                                   scr_disable_1g;             // I:
logic [31:0]                                            scr_spare;                  // I:

logic                                                   PRSSTS_stopped_nc;          // O:
logic                                                   PRSSTS_uprgi_nc;            // O:
logic                                                   PRSSTS_rf_nc;               // O:
logic [31:0]                                            PRSREQALLOC_alloc;          // I:

logic [1:0]                                             ats_req_v;                  // O:
hqm_devtlb_ats_req_t                                    ats_req;                    // O:
logic [1:0]                                             ats_req_ack;                // I:

logic                                                   ats_rsp_v;                  // I:
hqm_devtlb_ats_rsp_t                                    ats_rsp;                    // I:

logic                                                   tx_msg_v;                   // O:
hqm_devtlb_tx_msg_t                                     tx_msg;                     // O:
logic                                                   tx_msg_ack;                 // I:

logic                                                   devtlb_req_v;               // I:
hqm_devtlb_req_t                                        devtlb_req;                 // I:
logic                                                   devtlb_lcrd_inc;            // O: Credit return for Low priority request
logic                                                   devtlb_hcrd_inc;            // O: Credite return for high priority request

logic                                                   devtlb_rsp_v;               // O:
hqm_devtlb_rsp_t                                        devtlb_rsp;                 // O:

logic                                                   drain_req_v;                // O:
hqm_devtlb_drain_req_t                                  drain_req;                  // O:
logic                                                   drain_req_ack;              // I:

logic                                                   drain_rsp_v;                // I:
hqm_devtlb_drain_rsp_t                                  drain_rsp;                  // I:

logic [(5*DEVTLB_PARITY_WIDTH)-1:0]                     tlb_tag_parity_err;         // O: Vector reporting TLB tag parity errors;
                                                                                    // 4-3:RSVD 2:IOTLB 1G TAG;  1:IOTLB 2M TAG;  0:IOTLB 4K TAG
logic [(5*DEVTLB_PARITY_WIDTH)-1:0]                     tlb_data_parity_err;        // O: Vector reporting TLB tag parity errors;
                                                                                    // 4-3:RSVD 2:IOTLB 1G DATA; 1:IOTLB 2M DATA; 0:IOTLB 4K DATA

//----------------------------------------------------------------------------------------------------

logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      wb_cq;
logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      wb_cq_scaled;
logic                                                   wb_msix;
logic                                                   wb_ims;
logic                                                   wb_alarm;
logic                                                   wb_pw;
logic                                                   wb_pcq;
logic                                                   wb_tlb_reqd;
logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      wb_ll;
logic                                                   wb_drop_msixe;
logic                                                   wb_drop_invalid;
logic                                                   wb_drop_cq;

hqm_pcie_hdr_t                                          phdr;
logic                                                   phdr_par;
hqm_pasidtlp_t                                          phdr_pasidtlp;
logic [3:0]                                             phdr_tc;

logic                                                   atshdr_ready;
logic                                                   atshdr_v;
hqm_pcie_hdr_t                                          atshdr;
logic                                                   atshdr_par;
hqm_pasidtlp_t                                          atshdr_pasidtlp;

hqm_pcie_hdr_t                                          invrsphdr;
logic                                                   invrsphdr_par;
hqm_pasidtlp_t                                          invrsphdr_pasidtlp;
logic                                                   invrsp_pend_next;
logic                                                   invrsp_pend_q;

hqm_sficpl_hdr_t                                        cplhdr;
logic                                                   cplhdr_par;

logic                                                   devtlb_hcrd_dec;
logic [DEVTLB_HCB_DEPTH_WIDTH-1:0]                      devtlb_hcrd_next;
logic [DEVTLB_HCB_DEPTH_WIDTH-1:0]                      devtlb_hcrd_q;
logic                                                   devtlb_lcrd_dec;
logic [DEVTLB_LCB_DEPTH_WIDTH-1:0]                      devtlb_lcrd_next;
logic [DEVTLB_LCB_DEPTH_WIDTH-1:0]                      devtlb_lcrd_q;

logic                                                   fl2ll_v;
logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      fl2ll_ll;

logic                                                   ll_pop;
logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      ll_pop_ll;

logic                                                   fl_push;
logic [HQM_MSTR_FL_DEPTH_WIDTH-1:0]                     fl_push_ptr;

logic                                                   fl_empty;
logic                                                   fl_aempty;
logic                                                   fl_full;
logic [HQM_MSTR_FL_DEPTH_WIDTH-1:0]                     fl_hptr;

logic [HQM_MSTR_NUM_LLS-1:0]                            ll_v;
logic [(HQM_MSTR_NUM_LLS*HQM_MSTR_FL_DEPTH_WIDTH)-1:0]  ll_hptr;
logic [HQM_MSTR_FL_DEPTH_WIDTH-1:0]                     ll_hptr_mda[(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0];

logic                                                   scrbd_tag_v;
logic [HQM_SCRBD_DEPTH_WIDTH-1:0]                       scrbd_tag;
logic [9:0]                                             scrbd_tag_10b;

logic                                                   scrbd_alloc;
scrbd_data_t                                            scrbd_alloc_data;

logic                                                   scrbd_free;

logic                                                   hdr_rdata_par;
hqm_pasidtlp_t                                          hdr_rdata_pasidtlp;
hqm_pcie_hdr_t                                          hdr_rdata_hdr;
hqm_sficpl_hdr_t                                        hdr_rdata_hdr_cpl;
logic                                                   hdr_rdata_tlb_reqd;
hqm_sfi_pcie_cmd_t                                      hdr_rdata_pcie_cmd;
logic                                                   hdr_rdata_pcie_cmd_mrd;
logic [63:12]                                           hdr_rdata_addr;
logic                                                   hdr_rdata_fmt0;
logic                                                   hdr_rdata_padj;

logic                                                   hpa_rdata_p;
logic [DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:12]              hpa_rdata_hpa;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 hpa_v_next;
logic [HQM_MSTR_NUM_CQS-1:0]                            hpa_v_q;
logic [HQM_MSTR_NUM_CQS-1:0]                            hpa_v;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 hpa_v_scaled;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 hpa_err_next;
logic [HQM_MSTR_NUM_CQS-1:0]                            hpa_err_q;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 hpa_err_scaled;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 hpa_pnd_next;
logic [HQM_MSTR_NUM_CQS-1:0]                            hpa_pnd_q;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 hpa_pnd_scaled;

logic                                                   clr_hpa_v;
logic                                                   clr_hpa_err;
logic [HQM_MSTR_NUM_CQS_WIDTH-1:0]                      clr_hpa_err_cq;

logic [HQM_MSTR_FL_DEPTH-1:0]                           msix_v_next;
logic [HQM_MSTR_FL_DEPTH-1:0]                           msix_v_q;
logic [HQM_MSTR_NUM_CQS-1:0]                            msix_v;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 msix_v_scaled;

logic [HQM_MSTR_FL_DEPTH-1:0]                           ims_v_next;
logic [HQM_MSTR_FL_DEPTH-1:0]                           ims_v_q;
logic [HQM_MSTR_NUM_CQS-1:0]                            ims_v;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 ims_v_scaled;

logic [HQM_MSTR_FL_DEPTH-1:0]                           cpld_next;
logic [HQM_MSTR_FL_DEPTH-1:0]                           cpld_q;

logic [HQM_MSTR_FL_DEPTH-1:0]                           blk_v_next;
logic [HQM_MSTR_FL_DEPTH-1:0]                           blk_v_q;
logic [HQM_MSTR_NUM_LLS-1:0]                            blk_v;

logic                                                   ll_read_v_next;
logic                                                   ll_read_v_q;
logic [1:0]                                             ll_read_vc_next;
logic [1:0]                                             ll_read_vc_q;
hqm_sfi_fc_id_t                                         ll_read_fc_next;
hqm_sfi_fc_id_t                                         ll_read_fc_q;
hqm_sfi_pcie_cmd_t                                      ll_read_hdr;

logic [HQM_MSTR_NUM_LLS-1:0]                            ll_arb_reqs_next;
logic [HQM_MSTR_NUM_LLS-1:0]                            ll_arb_reqs_q;
logic [HQM_MSTR_NUM_LLS-1:0]                            ll_arb_reqs;
logic                                                   ll_arb_reqs_cq;
logic                                                   ll_arb_reqs_int;
logic                                                   ll_arb_update;
logic                                                   ll_arb_hold;
logic                                                   ll_arb_winner_v_next;
logic                                                   ll_arb_winner_v_q;
logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      ll_arb_winner_next;
logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      ll_arb_winner_q;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 ll_arb_winner_mask;
logic [1:0]                                             ll_arb_winner_vc;
hqm_sfi_fc_id_t                                         ll_arb_winner_fc;
logic                                                   ll_arb_winner_is_ats;
logic                                                   ll_arb_winner_is_cpl;
logic                                                   ll_arb_winner_is_cpld;
logic                                                   ll_arb_winner_is_cq;
logic                                                   ll_arb_winner_is_int;
logic                                                   ll_arb_winner_is_inv;
logic                                                   ll_arb_winner_drain;

logic                                                   agent_tx_hold;

logic                                                   poisoned_wr_sent_next;
logic                                                   poisoned_wr_sent_q;

logic                                                   sif_mstr_quiesce_req_q;
logic                                                   sif_mstr_quiesce_ack_next;
logic                                                   sif_mstr_quiesce_ack_q;

scrbd_data_t                                            ats_alloc_data;

logic [5:0]                                             ats_req_cnt_next;
logic [5:0]                                             ats_req_cnt_q;              // Max 32 pending ATS requests
logic                                                   ats_req_cnt_inc;
logic                                                   ats_req_cnt_dec;
logic                                                   ats_req_cnt_lt_limit;

logic [6:0]                                             xreq_cnt_next;
logic [6:0]                                             xreq_cnt_q;                 // Pending queue has 64 entries
logic                                                   xreq_cnt_inc;
logic                                                   xreq_cnt_dec;
logic                                                   xreq_cnt_lt_limit;

logic                                                   scrbd_perr;
logic                                                   ibcpl_hdr_fifo_perr;
logic                                                   ibcpl_data_fifo_perr;

logic [8:0]                                             parity_error_next;
logic [8:0]                                             parity_error_q;
logic [8:0]                                             parity_error_last_q;

logic                                                   drain_pend_next;
logic                                                   drain_pend_q;
hqm_devtlb_drain_req_t                                  drain_req_next;
hqm_devtlb_drain_req_t                                  drain_req_q;

logic                                                   flr_txn_sent_q;
nphdr_tag_t                                             flr_txn_tag_q;
hdr_reqid_t                                             flr_txn_reqid_q;
logic                                                   flr_cpl_sent_next;
logic                                                   flr_cpl_sent_q;
logic                                                   flr_cpl_last_q;

logic                                                   block_cq_p_np_lls;
logic                                                   drain_cq_p_np_lls;

logic                                                   ps_txn_sent_q;
nphdr_tag_t                                             ps_txn_tag_q;
hdr_reqid_t                                             ps_txn_reqid_q;
logic                                                   ps_cpl_sent_next;
logic                                                   ps_cpl_sent_q;
logic                                                   ps_d0;

logic                                                   local_bme_next;
logic                                                   local_bme_q;
logic                                                   local_bme;
logic                                                   local_msixe_next;
logic                                                   local_msixe_q;
logic                                                   local_msixe;

logic                                                   allow_bme_update;
logic                                                   sent_bme_cpl_next;
logic                                                   sent_bme_cpl_q;

logic                                                   allow_msixe_update;
logic                                                   sent_msixe_cpl_next;
logic                                                   sent_msixe_cpl_q;

logic                                                   cnt_inc;

logic                                                   ph_trigger_next;

hqm_sif_memi_mstr_ll_hpa_t                              memi_mstr_ll_hpa_next;
hqm_sif_memi_mstr_ll_hpa_t                              memi_mstr_ll_hpa_q;
hqm_sif_memi_mstr_ll_hdr_t                              memi_mstr_ll_hdr_next;
hqm_sif_memi_mstr_ll_hdr_t                              memi_mstr_ll_hdr_q;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data0_next;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data0_q;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data1_next;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data1_q;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data2_next;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data2_q;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data3_next;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data3_q;

logic                                                   ti_req_idle;

logic [8:0]                                             cq_np_cnt_next[HQM_MSTR_NUM_CQS-1:0];
logic [8:0]                                             cq_np_cnt_q[HQM_MSTR_NUM_CQS-1:0];
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 cq_np_cnt_inc;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 cq_np_cnt_dec;

logic                                                   cpl_hdr_requires_ohca5;

logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_hcrds_reqd;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_dcrds_reqd;

//----------------------------------------------------------------------------------------------------
// devtlb memory interfaces
// Single read enable reads all ways at single read address in parallel
// Per way write enable selects which way gets written

logic                                                   EXT_RF_IOTLB_4k_Tag_RdEn;
logic [HQM_TLB_4K_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_4k_Tag_RdAddr;
logic [HQM_TLB_NUM_WAYS-1:0][HQM_TLB_4K_TAG_WIDTH-1:0]  EXT_RF_IOTLB_4k_Tag_RdData;
logic [HQM_TLB_NUM_WAYS-1:0]                            EXT_RF_IOTLB_4k_Tag_WrEn;
logic [HQM_TLB_4K_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_4k_Tag_WrAddr;
logic [HQM_TLB_4K_TAG_WIDTH-1:0]                        EXT_RF_IOTLB_4k_Tag_WrData;

logic                                                   EXT_RF_IOTLB_4k_Data_RdEn;
logic [HQM_TLB_4K_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_4k_Data_RdAddr;
logic [HQM_TLB_NUM_WAYS-1:0][HQM_TLB_4K_DATA_WIDTH-1:0] EXT_RF_IOTLB_4k_Data_RdData;
logic [HQM_TLB_NUM_WAYS-1:0]                            EXT_RF_IOTLB_4k_Data_WrEn;
logic [HQM_TLB_4K_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_4k_Data_WrAddr;
logic [HQM_TLB_4K_DATA_WIDTH-1:0]                       EXT_RF_IOTLB_4k_Data_WrData;

logic                                                   EXT_RF_IOTLB_2m_Tag_RdEn;
logic [HQM_TLB_2M_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_2m_Tag_RdAddr;
logic [HQM_TLB_NUM_WAYS-1:0][HQM_TLB_2M_TAG_WIDTH-1:0]  EXT_RF_IOTLB_2m_Tag_RdData;
logic [HQM_TLB_NUM_WAYS-1:0]                            EXT_RF_IOTLB_2m_Tag_WrEn;
logic [HQM_TLB_2M_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_2m_Tag_WrAddr;
logic [HQM_TLB_2M_TAG_WIDTH-1:0]                        EXT_RF_IOTLB_2m_Tag_WrData;

logic                                                   EXT_RF_IOTLB_2m_Data_RdEn;
logic [HQM_TLB_2M_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_2m_Data_RdAddr;
logic [HQM_TLB_NUM_WAYS-1:0][HQM_TLB_2M_DATA_WIDTH-1:0] EXT_RF_IOTLB_2m_Data_RdData;
logic [HQM_TLB_NUM_WAYS-1:0]                            EXT_RF_IOTLB_2m_Data_WrEn;
logic [HQM_TLB_2M_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_2m_Data_WrAddr;
logic [HQM_TLB_2M_DATA_WIDTH-1:0]                       EXT_RF_IOTLB_2m_Data_WrData;

logic                                                   EXT_RF_IOTLB_1g_Tag_RdEn;
logic [HQM_TLB_1G_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_1g_Tag_RdAddr;
logic [HQM_TLB_NUM_WAYS-1:0][HQM_TLB_1G_TAG_WIDTH-1:0]  EXT_RF_IOTLB_1g_Tag_RdData;
logic [HQM_TLB_NUM_WAYS-1:0]                            EXT_RF_IOTLB_1g_Tag_WrEn;
logic [HQM_TLB_1G_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_1g_Tag_WrAddr;
logic [HQM_TLB_1G_TAG_WIDTH-1:0]                        EXT_RF_IOTLB_1g_Tag_WrData;

logic                                                   EXT_RF_IOTLB_1g_Data_RdEn;
logic [HQM_TLB_1G_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_1g_Data_RdAddr;
logic [HQM_TLB_NUM_WAYS-1:0][HQM_TLB_1G_DATA_WIDTH-1:0] EXT_RF_IOTLB_1g_Data_RdData;
logic [HQM_TLB_NUM_WAYS-1:0]                            EXT_RF_IOTLB_1g_Data_WrEn;
logic [HQM_TLB_1G_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_1g_Data_WrAddr;
logic [HQM_TLB_1G_DATA_WIDTH-1:0]                       EXT_RF_IOTLB_1g_Data_WrData;

// Standard RF devtlb interfaces for each way

hqm_sif_memi_tlb_tag_4k_t                               memi_tlb_tag_4k[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memi_tlb_tag_2m_t                               memi_tlb_tag_2m[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memi_tlb_tag_1g_t                               memi_tlb_tag_1g[HQM_TLB_NUM_WAYS-1:0];

hqm_sif_memo_tlb_tag_4k_t                               memo_tlb_tag_4k[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memo_tlb_tag_2m_t                               memo_tlb_tag_2m[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memo_tlb_tag_1g_t                               memo_tlb_tag_1g[HQM_TLB_NUM_WAYS-1:0];

hqm_sif_memi_tlb_data_4k_t                              memi_tlb_data_4k[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memi_tlb_data_2m_t                              memi_tlb_data_2m[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memi_tlb_data_1g_t                              memi_tlb_data_1g[HQM_TLB_NUM_WAYS-1:0];

hqm_sif_memo_tlb_data_4k_t                              memo_tlb_data_4k[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memo_tlb_data_2m_t                              memo_tlb_data_2m[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memo_tlb_data_1g_t                              memo_tlb_data_1g[HQM_TLB_NUM_WAYS-1:0];

// Flop memories

logic [HQM_TLB_2M_TAG_WIDTH-1:0]                        tlb_tag_2m_mem[ HQM_TLB_NUM_WAYS-1:0][HQM_TLB_2M_DEPTH-1:0];
logic [HQM_TLB_2M_DATA_WIDTH-1:0]                       tlb_data_2m_mem[HQM_TLB_NUM_WAYS-1:0][HQM_TLB_2M_DEPTH-1:0];
logic [HQM_TLB_1G_TAG_WIDTH-1:0]                        tlb_tag_1g_mem[ HQM_TLB_NUM_WAYS-1:0][HQM_TLB_1G_DEPTH-1:0];
logic [HQM_TLB_1G_DATA_WIDTH-1:0]                       tlb_data_1g_mem[HQM_TLB_NUM_WAYS-1:0][HQM_TLB_1G_DEPTH-1:0];

generate
 for (genvar g=0; g<HQM_TLB_NUM_WAYS; g=g+1) begin

  // Convert devtlb memory interfaces to separate per RF interfaces
  // Broadcast re, raddr, waddr, and wdata.  Separate rdata[way] and we[way].

  assign memi_tlb_tag_4k[g].re          = EXT_RF_IOTLB_4k_Tag_RdEn;
  assign memi_tlb_tag_4k[g].raddr       = EXT_RF_IOTLB_4k_Tag_RdAddr;
  assign memi_tlb_tag_4k[g].we          = EXT_RF_IOTLB_4k_Tag_WrEn[g];
  assign memi_tlb_tag_4k[g].waddr       = EXT_RF_IOTLB_4k_Tag_WrAddr;
  assign memi_tlb_tag_4k[g].wdata       = EXT_RF_IOTLB_4k_Tag_WrData;

  assign EXT_RF_IOTLB_4k_Tag_RdData[g]  = memo_tlb_tag_4k[g].rdata;

  assign memi_tlb_data_4k[g].re         = EXT_RF_IOTLB_4k_Data_RdEn;
  assign memi_tlb_data_4k[g].raddr      = EXT_RF_IOTLB_4k_Data_RdAddr;
  assign memi_tlb_data_4k[g].we         = EXT_RF_IOTLB_4k_Data_WrEn[g];
  assign memi_tlb_data_4k[g].waddr      = EXT_RF_IOTLB_4k_Data_WrAddr;
  assign memi_tlb_data_4k[g].wdata      = EXT_RF_IOTLB_4k_Data_WrData;

  assign EXT_RF_IOTLB_4k_Data_RdData[g] = memo_tlb_data_4k[g].rdata;

  assign memi_tlb_tag_2m[g].re          = EXT_RF_IOTLB_2m_Tag_RdEn;
  assign memi_tlb_tag_2m[g].raddr       = EXT_RF_IOTLB_2m_Tag_RdAddr;
  assign memi_tlb_tag_2m[g].we          = EXT_RF_IOTLB_2m_Tag_WrEn[g];
  assign memi_tlb_tag_2m[g].waddr       = EXT_RF_IOTLB_2m_Tag_WrAddr;
  assign memi_tlb_tag_2m[g].wdata       = EXT_RF_IOTLB_2m_Tag_WrData;

  assign EXT_RF_IOTLB_2m_Tag_RdData[g]  = memo_tlb_tag_2m[g].rdata;

  assign memi_tlb_data_2m[g].re         = EXT_RF_IOTLB_2m_Data_RdEn;
  assign memi_tlb_data_2m[g].raddr      = EXT_RF_IOTLB_2m_Data_RdAddr;
  assign memi_tlb_data_2m[g].we         = EXT_RF_IOTLB_2m_Data_WrEn[g];
  assign memi_tlb_data_2m[g].waddr      = EXT_RF_IOTLB_2m_Data_WrAddr;
  assign memi_tlb_data_2m[g].wdata      = EXT_RF_IOTLB_2m_Data_WrData;

  assign EXT_RF_IOTLB_2m_Data_RdData[g] = memo_tlb_data_2m[g].rdata;

  assign memi_tlb_tag_1g[g].re          = EXT_RF_IOTLB_1g_Tag_RdEn;
  assign memi_tlb_tag_1g[g].raddr       = EXT_RF_IOTLB_1g_Tag_RdAddr;
  assign memi_tlb_tag_1g[g].we          = EXT_RF_IOTLB_1g_Tag_WrEn[g];
  assign memi_tlb_tag_1g[g].waddr       = EXT_RF_IOTLB_1g_Tag_WrAddr;
  assign memi_tlb_tag_1g[g].wdata       = EXT_RF_IOTLB_1g_Tag_WrData;

  assign EXT_RF_IOTLB_1g_Tag_RdData[g]  = memo_tlb_tag_1g[g].rdata;

  assign memi_tlb_data_1g[g].re         = EXT_RF_IOTLB_1g_Data_RdEn;
  assign memi_tlb_data_1g[g].raddr      = EXT_RF_IOTLB_1g_Data_RdAddr;
  assign memi_tlb_data_1g[g].we         = EXT_RF_IOTLB_1g_Data_WrEn[g];
  assign memi_tlb_data_1g[g].waddr      = EXT_RF_IOTLB_1g_Data_WrAddr;
  assign memi_tlb_data_1g[g].wdata      = EXT_RF_IOTLB_1g_Data_WrData;

  assign EXT_RF_IOTLB_1g_Data_RdData[g] = memo_tlb_data_1g[g].rdata;

  // Build these 4 (per way) smaller memories out of flops

  always_ff @(posedge prim_nonflr_clk) begin
   if (memi_tlb_tag_2m[ g].re) memo_tlb_tag_2m[ g].rdata <= tlb_tag_2m_mem[ g][memi_tlb_tag_2m[ g].raddr];
   if (memi_tlb_data_2m[g].re) memo_tlb_data_2m[g].rdata <= tlb_data_2m_mem[g][memi_tlb_data_2m[g].raddr];
   if (memi_tlb_tag_1g[ g].re) memo_tlb_tag_1g[ g].rdata <= tlb_tag_1g_mem[ g][memi_tlb_tag_1g[ g].raddr];
   if (memi_tlb_data_1g[g].re) memo_tlb_data_1g[g].rdata <= tlb_data_1g_mem[g][memi_tlb_data_1g[g].raddr];

   if (memi_tlb_tag_2m[ g].we) tlb_tag_2m_mem[ g][memi_tlb_tag_2m[ g].waddr] <= memi_tlb_tag_2m[ g].wdata;
   if (memi_tlb_data_2m[g].we) tlb_data_2m_mem[g][memi_tlb_data_2m[g].waddr] <= memi_tlb_data_2m[g].wdata;
   if (memi_tlb_tag_1g[ g].we) tlb_tag_1g_mem[ g][memi_tlb_tag_1g[ g].waddr] <= memi_tlb_tag_1g[ g].wdata;
   if (memi_tlb_data_1g[g].we) tlb_data_1g_mem[g][memi_tlb_data_1g[g].waddr] <= memi_tlb_data_1g[g].wdata;
  end

 end
endgenerate

// Hardcoding these memory solution ports for 8 ways.  Need to change if number of ways is changed.

assign memi_tlb_tag0_4k    = memi_tlb_tag_4k[0];
assign memi_tlb_tag1_4k    = memi_tlb_tag_4k[1];
assign memi_tlb_tag2_4k    = memi_tlb_tag_4k[2];
assign memi_tlb_tag3_4k    = memi_tlb_tag_4k[3];
assign memi_tlb_tag4_4k    = memi_tlb_tag_4k[4];
assign memi_tlb_tag5_4k    = memi_tlb_tag_4k[5];
assign memi_tlb_tag6_4k    = memi_tlb_tag_4k[6];
assign memi_tlb_tag7_4k    = memi_tlb_tag_4k[7];

assign memi_tlb_data0_4k   = memi_tlb_data_4k[0];
assign memi_tlb_data1_4k   = memi_tlb_data_4k[1];
assign memi_tlb_data2_4k   = memi_tlb_data_4k[2];
assign memi_tlb_data3_4k   = memi_tlb_data_4k[3];
assign memi_tlb_data4_4k   = memi_tlb_data_4k[4];
assign memi_tlb_data5_4k   = memi_tlb_data_4k[5];
assign memi_tlb_data6_4k   = memi_tlb_data_4k[6];
assign memi_tlb_data7_4k   = memi_tlb_data_4k[7];

assign memo_tlb_tag_4k[0]  = memo_tlb_tag0_4k;
assign memo_tlb_tag_4k[1]  = memo_tlb_tag1_4k;
assign memo_tlb_tag_4k[2]  = memo_tlb_tag2_4k;
assign memo_tlb_tag_4k[3]  = memo_tlb_tag3_4k;
assign memo_tlb_tag_4k[4]  = memo_tlb_tag4_4k;
assign memo_tlb_tag_4k[5]  = memo_tlb_tag5_4k;
assign memo_tlb_tag_4k[6]  = memo_tlb_tag6_4k;
assign memo_tlb_tag_4k[7]  = memo_tlb_tag7_4k;

assign memo_tlb_data_4k[0] = memo_tlb_data0_4k;
assign memo_tlb_data_4k[1] = memo_tlb_data1_4k;
assign memo_tlb_data_4k[2] = memo_tlb_data2_4k;
assign memo_tlb_data_4k[3] = memo_tlb_data3_4k;
assign memo_tlb_data_4k[4] = memo_tlb_data4_4k;
assign memo_tlb_data_4k[5] = memo_tlb_data5_4k;
assign memo_tlb_data_4k[6] = memo_tlb_data6_4k;
assign memo_tlb_data_4k[7] = memo_tlb_data7_4k;

//----------------------------------------------------------------------------------------------------
// devtlb instantiation

// The devtlb requires at least 8 clocks of reset w/ clocks running, so stretching the resets here

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  devtlb_reset_q <= '1;
 end else begin
  devtlb_reset_q <= {1'b0, devtlb_reset_q[9:1]};
 end
end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_wflr_rst_b) begin
 if (~prim_gated_wflr_rst_b) begin
  devtlb_flr_q   <= '1;
 end else begin
  devtlb_flr_q   <= {1'b0, devtlb_flr_q[9:1]};
 end
end

assign devtlb_reset = devtlb_reset_q[0];
assign devtlb_flr   = devtlb_reset_q[0] | devtlb_flr_q[0];

hqm_devtlb i_hqm_devtlb (

     .clk                               (prim_nonflr_clk)               // I: Unit Clock
    ,.flreset                           (devtlb_flr)                    // I: Reset the Unit
    ,.full_reset                        (devtlb_reset)                  // I: Non Func Level reset.

    ,.fscan_byprst_b                    (fscan_byprst_b)                // I:
    ,.fscan_clkungate                   (fscan_clkungate)               // I:
    ,.fscan_clkungate_syn               (fscan_clkungate_syn)           // I:
    ,.fscan_latchclosed_b               (fscan_latchclosed_b)           // I:
    ,.fscan_latchopen                   (fscan_latchopen)               // I:
    ,.fscan_mode                        (fscan_mode)                    // I:
    ,.fscan_rstbypen                    (fscan_rstbypen)                // I:
    ,.fscan_shiften                     (fscan_shiften)                 // I:

    ,.fscan_clkgenctrl                  ('0)                            // I: Not used in devtlb
    ,.fscan_clkgenctrlen                ('0)                            // I: Not used in devtlb
    ,.fscan_ram_wrdis_b                 ('1)                            // I: Not used in devtlb
    ,.fscan_ram_rddis_b                 ('1)                            // I: Not used in devtlb
    ,.fscan_ram_odis_b                  ('1)                            // I: Not used in devtlb
    ,.fsta_afd_en                       ('0)                            // I: Not used in devtlb
    ,.fsta_dfxact_afd                   ('0)                            // I: Not used in devtlb
    ,.fdfx_earlyboot_exit               ('0)                            // I: Not used in devtlb

    ,.xreqs_active                      (xreqs_active)                  // O: IOMMU is currently not performing any translation requests or sequencer flows
    ,.tlb_reset_active                  (tlb_reset_active)              // O: high is tlb inv due to reset or implicit inval is in progress.
    ,.invreqs_active                    (invreqs_active)                // O: high is any inv req in invq.

    ,.implicit_invalidation_valid       (imp_invalidation_v)            // I: Triggers an invalidation of all IOMMU TLBs/PWCs.
    ,.implicit_invalidation_bdf_valid   (imp_invalidation_bdf_v)        // I:
    ,.implicit_invalidation_bdf         (imp_invalidation_bdf)          // I:

    ,.scr_loxreq_gcnt                   (scr_loxreq_gcnt)               // I: TLB Arbiter Grant count, one based.
    ,.scr_hixreq_gcnt                   (scr_hixreq_gcnt)               // I:
    ,.scr_pendq_gcnt                    (scr_pendq_gcnt)                // I:
    ,.scr_fill_gcnt                     (scr_fill_gcnt)                 // I:
    ,.scr_prs_continuous_retry          (scr_prs_continuous_retry)      // I:
    ,.scr_disable_prs                   (scr_disable_prs)               // I:
    ,.scr_disable_2m                    (scr_disable_2m)                // I:
    ,.scr_disable_1g                    (scr_disable_1g)                // I:
    ,.scr_spare                         (scr_spare)                     // I:

    ,.PRSSTS_stopped                    (PRSSTS_stopped_nc)             // O:
    ,.PRSSTS_uprgi                      (PRSSTS_uprgi_nc)               // O:
    ,.PRSSTS_rf                         (PRSSTS_rf_nc)                  // O:
    ,.PRSREQALLOC_alloc                 (PRSREQALLOC_alloc)             // I:

    ,.atsreq_valid                      (ats_req_v)                     // O:
    ,.atsreq_pasid_valid                (ats_req.pasid_valid)           // O:
    ,.atsreq_pasid_priv                 (ats_req.pasid_priv)            // O:
    ,.atsreq_pasid                      (ats_req.pasid)                 // O:
    ,.atsreq_id                         (ats_req.id)                    // O:
    ,.atsreq_tc                         (ats_req.tc)                    // O:
    ,.atsreq_nw                         (ats_req.nw)                    // O:
    ,.atsreq_bdf                        (ats_req.bdf)                   // O:
    ,.atsreq_address                    (ats_req.address)               // O:
    ,.atsreq_ack                        (ats_req_ack)                   // I:

    ,.atsrsp_valid                      (ats_rsp_v)                     // I:
    ,.atsrsp_id                         (ats_rsp.id)                    // I:
    ,.atsrsp_dperror                    (ats_rsp.dperror)               // I:
    ,.atsrsp_hdrerror                   (ats_rsp.hdrerror)              // I:
    ,.atsrsp_data                       (ats_rsp.data)                  // I:

    ,.rx_msg_valid                      (rx_msg_v)                      // I:
    ,.rx_msg_pasid_valid                (rx_msg.pasid_valid)            // I:
    ,.rx_msg_pasid_priv                 (rx_msg.pasid_priv)             // I:
    ,.rx_msg_pasid                      (rx_msg.pasid)                  // I:
    ,.rx_msg_opcode                     (rx_msg.opcode)                 // I:
    ,.rx_msg_dperror                    (rx_msg.dperror)                // I:
    ,.rx_msg_invreq_itag                (rx_msg.invreq_itag)            // I:
    ,.rx_msg_invreq_reqid               (rx_msg.invreq_reqid)           // I:
    ,.rx_msg_dw2                        (rx_msg.dw2)                    // I:
    ,.rx_msg_data                       (rx_msg.data)                   // I:

    ,.tx_msg_valid                      (tx_msg_v)                      // O:
    ,.tx_msg_pasid_valid                (tx_msg.pasid_valid)            // O:
    ,.tx_msg_pasid_priv                 (tx_msg.pasid_priv)             // O:
    ,.tx_msg_pasid                      (tx_msg.pasid)                  // O:
    ,.tx_msg_opcode                     (tx_msg.opcode)                 // O:
    ,.tx_msg_tc                         (tx_msg.tc)                     // O:
    ,.tx_msg_bdf                        (tx_msg.bdf)                    // O:
    ,.tx_msg_dw2                        (tx_msg.dw2)                    // O:
    ,.tx_msg_dw3                        (tx_msg.dw3)                    // O:

    ,.tx_msg_ack                        (tx_msg_ack)                    // I:

    ,.xreq_valid                        (devtlb_req_v)                  // I: translation request is valid
    ,.xreq_pasid_valid                  (devtlb_req.pasid_valid)        // I:
    ,.xreq_pasid_priv                   (devtlb_req.pasid_priv)         // I:
    ,.xreq_pasid                        (devtlb_req.pasid)              // I:
    ,.xreq_id                           (devtlb_req.id)                 // I: Transaction ID width=log2(customer buffer size)
    ,.xreq_tlbid                        (devtlb_req.tlbid)              // I: TLBid
    ,.xreq_priority                     (devtlb_req.ppriority)          // I: request priority
    ,.xreq_prs                          (devtlb_req.prs)                // I:
    ,.xreq_opcode                       (devtlb_req.opcode)             // I: Customer intended use for translated address
    ,.xreq_tc                           (devtlb_req.tc)                 // I: Transaction's Traffic class
    ,.xreq_bdf                          (devtlb_req.bdf)                // I:
    ,.xreq_address                      (devtlb_req.address)            // I: Address that needs to be translated.

    ,.xreq_lcrd_inc                     (devtlb_lcrd_inc)               // O: Credit return for Low priority request
    ,.xreq_hcrd_inc                     (devtlb_hcrd_inc)               // O: Credite return for high priority request

    ,.xrsp_valid                        (devtlb_rsp_v)                  // O: Translation Response valid
    ,.xrsp_result                       (devtlb_rsp.result)             // O: Response status: 1=success (translated) 0=failure.
    ,.xrsp_dperror                      (devtlb_rsp.dperror)            // O: data parity error was seen as part of translation request
    ,.xrsp_hdrerror                     (devtlb_rsp.hdrerror)           // O: a header error was seen as part of ATS request (e.g. UR, CA, CTO, etc).
    ,.xrsp_nonsnooped                   (devtlb_rsp.nonsnooped)         // O: 1 if the translated address should be accessed with non-snoop cycle.
    ,.xrsp_prs_code                     (devtlb_rsp.prs_code)           // O:
    ,.xrsp_id                           (devtlb_rsp.id)                 // O: Transaction ID
    ,.xrsp_address                      (devtlb_rsp.address)            // O: Translated Address

    ,.drainreq_valid                    (drain_req_v)                   // O: request to drain ALL transaction in Q
    ,.drainreq_pasid                    (drain_req.pasid)               // O:
    ,.drainreq_pasid_priv               (drain_req.pasid_priv)          // O:
    ,.drainreq_pasid_valid              (drain_req.pasid_valid)         // O:
    ,.drainreq_pasid_global             (drain_req.pasid_global)        // O:
    ,.drainreq_bdf                      (drain_req.bdf)                 // O:
    ,.drainreq_ack                      (drain_req_ack)                 // I: set when a drainreq is accepted.

    ,.drainrsp_valid                    (drain_rsp_v)                   // I: set when a drain req is processed, i.e outstanding request are flushed or marked for translation retry.
    ,.drainrsp_tc                       (drain_rsp.tc)                  // I: Traffic Class (bitwise) used by the hosting unit for all transaction.

    ,.defeature_misc_dis                (cfg_devtlb_defeature0)         // I:
    ,.defeature_pwrdwn_ovrd_dis         (cfg_devtlb_defeature1)         // I:
    ,.defeature_parity_injection        (cfg_devtlb_defeature2)         // I:

    ,.tlb_tag_parity_err                (tlb_tag_parity_err)            // O:
    ,.tlb_data_parity_err               (tlb_data_parity_err)           // O:

    ,.debugbus                          ()                              // O: TBD: Wire up debugbus?

    ,.EXT_RF_IOTLB_4k_Tag_RdEn          (EXT_RF_IOTLB_4k_Tag_RdEn)      // O:
    ,.EXT_RF_IOTLB_4k_Tag_RdAddr        (EXT_RF_IOTLB_4k_Tag_RdAddr)    // O:
    ,.EXT_RF_IOTLB_4k_Tag_RdData        (EXT_RF_IOTLB_4k_Tag_RdData)    // I:
    ,.EXT_RF_IOTLB_4k_Tag_WrEn          (EXT_RF_IOTLB_4k_Tag_WrEn)      // O:
    ,.EXT_RF_IOTLB_4k_Tag_WrAddr        (EXT_RF_IOTLB_4k_Tag_WrAddr)    // O:
    ,.EXT_RF_IOTLB_4k_Tag_WrData        (EXT_RF_IOTLB_4k_Tag_WrData)    // O:

    ,.EXT_RF_IOTLB_4k_Data_RdEn         (EXT_RF_IOTLB_4k_Data_RdEn)     // O:
    ,.EXT_RF_IOTLB_4k_Data_RdAddr       (EXT_RF_IOTLB_4k_Data_RdAddr)   // O:
    ,.EXT_RF_IOTLB_4k_Data_RdData       (EXT_RF_IOTLB_4k_Data_RdData)   // I:
    ,.EXT_RF_IOTLB_4k_Data_WrEn         (EXT_RF_IOTLB_4k_Data_WrEn)     // O:
    ,.EXT_RF_IOTLB_4k_Data_WrAddr       (EXT_RF_IOTLB_4k_Data_WrAddr)   // O:
    ,.EXT_RF_IOTLB_4k_Data_WrData       (EXT_RF_IOTLB_4k_Data_WrData)   // O:

    ,.EXT_RF_IOTLB_2m_Tag_RdEn          (EXT_RF_IOTLB_2m_Tag_RdEn)      // O:
    ,.EXT_RF_IOTLB_2m_Tag_RdAddr        (EXT_RF_IOTLB_2m_Tag_RdAddr)    // O:
    ,.EXT_RF_IOTLB_2m_Tag_RdData        (EXT_RF_IOTLB_2m_Tag_RdData)    // I:
    ,.EXT_RF_IOTLB_2m_Tag_WrEn          (EXT_RF_IOTLB_2m_Tag_WrEn)      // O:
    ,.EXT_RF_IOTLB_2m_Tag_WrAddr        (EXT_RF_IOTLB_2m_Tag_WrAddr)    // O:
    ,.EXT_RF_IOTLB_2m_Tag_WrData        (EXT_RF_IOTLB_2m_Tag_WrData)    // O:

    ,.EXT_RF_IOTLB_2m_Data_RdEn         (EXT_RF_IOTLB_2m_Data_RdEn)     // O:
    ,.EXT_RF_IOTLB_2m_Data_RdAddr       (EXT_RF_IOTLB_2m_Data_RdAddr)   // O:
    ,.EXT_RF_IOTLB_2m_Data_RdData       (EXT_RF_IOTLB_2m_Data_RdData)   // I:
    ,.EXT_RF_IOTLB_2m_Data_WrEn         (EXT_RF_IOTLB_2m_Data_WrEn)     // O:
    ,.EXT_RF_IOTLB_2m_Data_WrAddr       (EXT_RF_IOTLB_2m_Data_WrAddr)   // O:
    ,.EXT_RF_IOTLB_2m_Data_WrData       (EXT_RF_IOTLB_2m_Data_WrData)   // O:

    ,.EXT_RF_IOTLB_1g_Tag_RdEn          (EXT_RF_IOTLB_1g_Tag_RdEn)      // O:
    ,.EXT_RF_IOTLB_1g_Tag_RdAddr        (EXT_RF_IOTLB_1g_Tag_RdAddr)    // O:
    ,.EXT_RF_IOTLB_1g_Tag_RdData        (EXT_RF_IOTLB_1g_Tag_RdData)    // I:
    ,.EXT_RF_IOTLB_1g_Tag_WrEn          (EXT_RF_IOTLB_1g_Tag_WrEn)      // O:
    ,.EXT_RF_IOTLB_1g_Tag_WrAddr        (EXT_RF_IOTLB_1g_Tag_WrAddr)    // O:
    ,.EXT_RF_IOTLB_1g_Tag_WrData        (EXT_RF_IOTLB_1g_Tag_WrData)    // O:

    ,.EXT_RF_IOTLB_1g_Data_RdEn         (EXT_RF_IOTLB_1g_Data_RdEn)     // O:
    ,.EXT_RF_IOTLB_1g_Data_RdAddr       (EXT_RF_IOTLB_1g_Data_RdAddr)   // O:
    ,.EXT_RF_IOTLB_1g_Data_RdData       (EXT_RF_IOTLB_1g_Data_RdData)   // I:
    ,.EXT_RF_IOTLB_1g_Data_WrEn         (EXT_RF_IOTLB_1g_Data_WrEn)     // O:
    ,.EXT_RF_IOTLB_1g_Data_WrAddr       (EXT_RF_IOTLB_1g_Data_WrAddr)   // O:
    ,.EXT_RF_IOTLB_1g_Data_WrData       (EXT_RF_IOTLB_1g_Data_WrData)   // O:
);

//----------------------------------------------------------------------------------------------------
// devtlb configuration

always_comb begin

 scr_loxreq_gcnt                = cfg_devtlb_ctl.LOXREQ_GCNT;
 scr_hixreq_gcnt                = cfg_devtlb_ctl.HIXREQ_GCNT;
 scr_pendq_gcnt                 = cfg_devtlb_ctl.PENDQ_GCNT;
 scr_fill_gcnt                  = cfg_devtlb_ctl.FILL_GCNT;
 scr_prs_continuous_retry       = cfg_devtlb_ctl.PRS_CRETRY;
 scr_disable_prs                = cfg_devtlb_ctl.DISABLE_PRS;
 scr_disable_2m                 = cfg_devtlb_ctl.DISABLE_2M;
 scr_disable_1g                 = cfg_devtlb_ctl.DISABLE_1G;
 scr_spare                      = cfg_devtlb_spare;

 // PRS unused

 PRSREQALLOC_alloc              = '0;

 // Status

 devtlb_status.XREQ_CNT         = xreq_cnt_q;
 devtlb_status.ATS_REQ_CNT      = ats_req_cnt_q;
 devtlb_status.DRAIN_REQ_V      = drain_req_v;
 devtlb_status.TX_MSG_V         = tx_msg_v;
 devtlb_status.ATS_HREQ_V       = ats_req_v[1];
 devtlb_status.ATS_LREQ_V       = ats_req_v[0];
 devtlb_status.HCRD_CNT         = devtlb_hcrd_q;
 devtlb_status.LCRD_CNT         = devtlb_lcrd_q;
 devtlb_status.ATS_ENABLED      = cfg_ats_enabled_q;
 devtlb_status.XREQS_ACTIVE     = xreqs_active;
 devtlb_status.INVREQS_ACTIVE   = invreqs_active;
 devtlb_status.RESET_ACTIVE     = tlb_reset_active;

end

hqm_AW_unused_bits i_unused_prs (

     .a     (|{
                 PRSSTS_stopped_nc
                ,PRSSTS_uprgi_nc
                ,PRSSTS_rf_nc
            })
);

//----------------------------------------------------------------------------------------------------
// Initiate an implicit devtlb invalidation whenever ATS is enabled

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  cfg_ats_enabled_q <= '0;
 end else begin
  cfg_ats_enabled_q <= cfg_ats_enabled;
 end
end

assign cfg_ats_enabled_redge = cfg_ats_enabled & ~cfg_ats_enabled_q;

always_comb begin

 imp_invalidation_v         = cfg_ats_enabled_redge;
 imp_invalidation_bdf_v     = '0;
 imp_invalidation_bdf       = '0;

end

//----------------------------------------------------------------------------------------------------
// devtlb HP and LP xreq credit counters

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  devtlb_hcrd_q <= DEVTLB_HCB_DEPTH[DEVTLB_HCB_DEPTH_WIDTH-1:0];
  devtlb_lcrd_q <= DEVTLB_LCB_DEPTH[DEVTLB_LCB_DEPTH_WIDTH-1:0];
 end else begin
  devtlb_hcrd_q <= devtlb_hcrd_next;
  devtlb_lcrd_q <= devtlb_lcrd_next;
 end
end

always_comb begin

 case ({(devtlb_hcrd_inc & ~devtlb_reset), devtlb_hcrd_dec})
  2'b10:   devtlb_hcrd_next = devtlb_hcrd_q + {{(DEVTLB_HCB_DEPTH_WIDTH-1){1'b0}}, 1'b1};
  2'b01:   devtlb_hcrd_next = devtlb_hcrd_q - {{(DEVTLB_HCB_DEPTH_WIDTH-1){1'b0}}, 1'b1};
  default: devtlb_hcrd_next = devtlb_hcrd_q;
 endcase

 case ({(devtlb_lcrd_inc & ~devtlb_reset), devtlb_lcrd_dec})
  2'b10:   devtlb_lcrd_next = devtlb_lcrd_q + {{(DEVTLB_LCB_DEPTH_WIDTH-1){1'b0}}, 1'b1};
  2'b01:   devtlb_lcrd_next = devtlb_lcrd_q - {{(DEVTLB_LCB_DEPTH_WIDTH-1){1'b0}}, 1'b1};
  default: devtlb_lcrd_next = devtlb_lcrd_q;
 endcase

end

//----------------------------------------------------------------------------------------------------
// LLs for CQ, P, NP, Cpl, and Alarm

hqm_ti_ll i_hqm_ti_ll (

     .prim_nonflr_clk               (prim_nonflr_clk)                   //I: LL
    ,.prim_gated_rst_b              (prim_gated_rst_b)                  //I: LL

    ,.cfg_mstr_ll_ctl               (cfg_mstr_ll_ctl)                   //I: LL

    ,.mstr_fl_status                (mstr_fl_status)                    //O: LL
    ,.mstr_ll_status                (mstr_ll_status)                    //O: LL

    ,.fl2ll_v                       (fl2ll_v)                           //I: LL
    ,.fl2ll_ll                      (fl2ll_ll)                          //I: LL

    ,.ll_pop                        (ll_pop)                            //I: LL
    ,.ll_pop_ll                     (ll_pop_ll)                         //I: LL

    ,.fl_push                       (fl_push)                           //I: LL
    ,.fl_push_ptr                   (fl_push_ptr)                       //I: LL

    ,.fl_empty                      (fl_empty)                          //O: LL
    ,.fl_aempty                     (fl_aempty)                         //O: LL
    ,.fl_full                       (fl_full)                           //O: LL
    ,.fl_hptr                       (fl_hptr)                           //O: LL

    ,.ll_v                          (ll_v)                              //O: LL
    ,.ll_hptr                       (ll_hptr)                           //O: LL

    ,.blk_v_q                       (blk_v_q)                           //I: LL
    ,.msix_v_q                      (msix_v_q)                          //I: LL

    ,.hpa_v_scaled                  (hpa_v_scaled)                      //I: LL
    ,.hpa_err_scaled                (hpa_err_scaled)                    //I: LL
    ,.hpa_pnd_scaled                (hpa_pnd_scaled)                    //I: LL

    ,.clr_hpa_err                   (clr_hpa_err)                       //O: LL
    ,.clr_hpa_err_cq                (clr_hpa_err_cq)                    //O: LL
);

//----------------------------------------------------------------------------------------------------
// Scoreboard for NP transactions and completions

hqm_ti_scrbd i_hqm_ti_scrbd (

     .prim_nonflr_clk               (prim_nonflr_clk)                   //I: SCRBD
    ,.prim_gated_rst_b              (prim_gated_rst_b)                  //I: SCRBD

    ,.current_bus                   (current_bus)                       //I: SCRBD

    ,.cfg_scrbd_ctl                 (cfg_scrbd_ctl)                     //I: SCRBD
    ,.cfg_mstr_par_off              (cfg_mstr_par_off)                  //I: SCRBD

    ,.cfg_ibcpl_hdr_fifo_high_wm    (cfg_ibcpl_hdr_fifo_high_wm)        //I: SCRBD
    ,.cfg_ibcpl_data_fifo_high_wm   (cfg_ibcpl_data_fifo_high_wm)       //I: SCRBD

    ,.cfg_ibcpl_hdr_fifo_status     (cfg_ibcpl_hdr_fifo_status)         //O: SCRBD
    ,.cfg_ibcpl_data_fifo_status    (cfg_ibcpl_data_fifo_status)        //O: SCRBD

    ,.scrbd_status                  (scrbd_status)                      //O: SCRBD

    ,.scrbd_tag_v                   (scrbd_tag_v)                       //O: SCRBD
    ,.scrbd_tag                     (scrbd_tag)                         //O: SCRBD

    ,.scrbd_alloc                   (scrbd_alloc)                       //I: SCRBD
    ,.scrbd_alloc_data              (scrbd_alloc_data)                  //I: SCRBD

    ,.scrbd_free                    (scrbd_free)                        //O: SCRBD

    ,.ibcpl_hdr_push                (ibcpl_hdr_push)                    //I: SCRBD
    ,.ibcpl_hdr                     (ibcpl_hdr)                         //I: SCRBD

    ,.ibcpl_data_push               (ibcpl_data_push)                   //I: SCRBD
    ,.ibcpl_data                    (ibcpl_data)                        //I: SCRBD
    ,.ibcpl_data_par                (ibcpl_data_par)                    //I: SCRBD

    ,.cq_np_cnt_dec                 (cq_np_cnt_dec)                     //O: SCRBD

    ,.ats_rsp_v                     (ats_rsp_v)                         //O: SCRBD
    ,.ats_rsp                       (ats_rsp)                           //O: SCRBD

    ,.np_trans_pending              (np_trans_pending)                  //O: SCRBD

    ,.cpl_usr                       (cpl_usr)                           //O: SCRBD
    ,.cpl_abort                     (cpl_abort)                         //O: SCRBD
    ,.cpl_poisoned                  (cpl_poisoned)                      //O: SCRBD
    ,.cpl_unexpected                (cpl_unexpected)                    //O: SCRBD
    ,.cpl_error_hdr                 (cpl_error_hdr)                     //O: SCRBD

    ,.cpl_timeout                   (cpl_timeout)                       //O: SCRBD
    ,.cpl_timeout_synd              (cpl_timeout_synd)                  //O: SCRBD

    ,.scrbd_perr                    (scrbd_perr)                        //O: SCRBD
    ,.ibcpl_hdr_fifo_perr           (ibcpl_hdr_fifo_perr)               //O: SCRBD
    ,.ibcpl_data_fifo_perr          (ibcpl_data_fifo_perr)              //O: SCRBD

    ,.memi_scrbd_mem                (memi_scrbd_mem)                    //I: SCRBD
    ,.memo_scrbd_mem                (memo_scrbd_mem)                    //O: SCRBD

    ,.memi_ibcpl_hdr_fifo           (memi_ibcpl_hdr_fifo)               //I: SCRBD
    ,.memo_ibcpl_hdr_fifo           (memo_ibcpl_hdr_fifo)               //O: SCRBD

    ,.memi_ibcpl_data_fifo          (memi_ibcpl_data_fifo)              //I: SCRBD
    ,.memo_ibcpl_data_fifo          (memo_ibcpl_data_fifo)              //O: SCRBD
);

hqm_AW_width_scale #(.A_WIDTH(HQM_SCRBD_DEPTH_WIDTH), .Z_WIDTH(10)) i_scrbd_tag_10b (

     .a     (scrbd_tag)
    ,.z     (scrbd_tag_10b)
);

//----------------------------------------------------------------------------------------------------
// Convert from obcpl_hdr format to PCIe Cpl/CplD header format

always_comb begin

 cplhdr         = '0;

 // Note that rsvd127, rsvd106, rsvd31_0, attr2, and bcm fields of cplhdr are always 0.

 // For obcpl_hdr, we currently don't use the 2b pm field, we use cid[4] for tc[3], and use cid[3:0]
 // for the SFI tag[13:10] bits since the lower 8b of the cid field are our 8b function # (always 0).

 // For UR completion, PCI expects length=0 and bc=0, but IOSF expects bc to match the original
 // request.  Therefore, ri_cds will set length to the orignal request length so it can be used
 // to re-calculate the bc here, and we'll zero out the length here.

 cplhdr.fmt     =  {obcpl_hdr.fmt, 1'b0};
 cplhdr.ttype   =  {4'b0101, obcpl_hdr.lok};
 cplhdr.tc      =  {1'b0,    obcpl_hdr.tc};
 cplhdr.ep      =   obcpl_hdr.ep;
 cplhdr.attr[0] =   obcpl_hdr.attr[0];                                  // ns
 cplhdr.attr[1] =   obcpl_hdr.attr[1];                                  // ro
 cplhdr.len     =  (obcpl_hdr.cs == 3'b001) ? '0 : obcpl_hdr.length;
 cplhdr.cplid   =  {obcpl_hdr.cid[15:5], 5'd0};                         // cid[4:0] is passing tc[3], tag[13:10]
 cplhdr.cplstat =   obcpl_hdr.cs;
 cplhdr.bytecnt =  (obcpl_hdr.fmt | (obcpl_hdr.cs == 3'b001)) ?
                    f_hqm_pcie_bytecnt(obcpl_hdr.startbe,obcpl_hdr.endbe,obcpl_hdr.length) :
                    12'h004;
 cplhdr.rqid    =   obcpl_hdr.rid;
 cplhdr.tag     =   {obcpl_hdr.cid[3:0], obcpl_hdr.tag[9:0]};           // cid[3:0] is tag[13:10]
 cplhdr.lowaddr =   obcpl_hdr.addr;

 cplhdr_par     = ^{obcpl_hdr.par
                   ,obcpl_hdr.pm
                   ,obcpl_hdr.endbe
                   ,obcpl_hdr.startbe
                   ,obcpl_hdr.length
                   ,cplhdr.len
                   ,cplhdr.bytecnt
                   };
end

//----------------------------------------------------------------------------------------------------
// Convert from write_buffer_mstr.hdr format to PCIe header format
//
// Write buffer is only sending posted writes which will be MWr32 (3DW) or MWr64 (4DW).

always_comb begin

 // Map traffic class for schedule writes based on their CQ.
 // The tc_sel field is the 2b hash select based on the associated CQ.
 // The ldb_cq field is the indication that the CQ was load balanced.
 // Use the above bits to select one of the 8 configured traffic class values.
 // IMS interrupt writes must use the same traffic class mapping function.
 // MSI-X interrupt writes use the configured interrupt traffic class.

 phdr_tc = '0;

 if (write_buffer_mstr.hdr.src == MSIX) begin

  // CQ occupancy MSIX interrupt or alarm MSIX writes

  phdr_tc = int2tc_map.INT_TC;

 end else if (write_buffer_mstr.hdr.cq_ldb) begin

  // LDB schedule or CQ occupancy IMS interrupt write

  case (write_buffer_mstr.hdr.tc_sel)
   2'd3:    phdr_tc = ldb_cq2tc_map.LDB3_TC;
   2'd2:    phdr_tc = ldb_cq2tc_map.LDB2_TC;
   2'd1:    phdr_tc = ldb_cq2tc_map.LDB1_TC;
   default: phdr_tc = ldb_cq2tc_map.LDB0_TC;
  endcase

 end else begin

  // DIR schedule or CQ occupancy IMS interrupt write

  case (write_buffer_mstr.hdr.tc_sel)
   2'd3:    phdr_tc = dir_cq2tc_map.DIR3_TC;
   2'd2:    phdr_tc = dir_cq2tc_map.DIR2_TC;
   2'd1:    phdr_tc = dir_cq2tc_map.DIR1_TC;
   default: phdr_tc = dir_cq2tc_map.DIR0_TC;
  endcase

 end

 phdr = '0;

 // Note that rsvd3(rsvd1_7/tag[9]), rsvd2(rsvd1_3/tag[8]), rsvd0(rsvd1_1), oh(th), rsvd5/rsvd6(addr[1:0]),
 // attr2(ido), attr[0](ns), td, ep, tag[7:0], and at[1:0] fields are always 0.
 // Since we always write full DWs, first byte enable is always 4'hf.
 // Last byte enable is also always 4'hf unless it's just a single DW where the spec says it must be 4'h0.

 if (|write_buffer_mstr.hdr.add[63:32]) begin // 4DW

   phdr.pcie64.rsvd4   = phdr_tc[3];
  {phdr.pcie64.fmt
  ,phdr.pcie64.ttype}  = HQM_MWR4;
   phdr.pcie64.tc      = phdr_tc[2:0];
   phdr.pcie64.attr[1] = write_buffer_mstr.hdr.ro & csr_ppdcntl_ero;
   phdr.pcie64.len     = {5'd0, write_buffer_mstr.hdr.length};
   phdr.pcie64.rqid    = {current_bus, 8'd0};
   phdr.pcie64.lbe     = (write_buffer_mstr.hdr.length == 5'd1) ? 4'h0 : 4'hf;
   phdr.pcie64.fbe     = 4'hf;
   phdr.pcie64.addr    = write_buffer_mstr.hdr.add[63:2];

 end else begin // 3DW

   phdr.pcie32.rsvd4   = phdr_tc[3];
  {phdr.pcie32.fmt
  ,phdr.pcie32.ttype}  = HQM_MWR3;
   phdr.pcie32.tc      = phdr_tc[2:0];
   phdr.pcie32.attr[1] = write_buffer_mstr.hdr.ro & csr_ppdcntl_ero;
   phdr.pcie32.len     = {5'd0, write_buffer_mstr.hdr.length};
   phdr.pcie32.rqid    = {current_bus, 8'd0};
   phdr.pcie32.lbe     = (write_buffer_mstr.hdr.length == 5'd1) ? 4'h0 : 4'hf;
   phdr.pcie32.fbe     = 4'hf;
   phdr.pcie32.addr    = write_buffer_mstr.hdr.add[31:2];

 end

 phdr_pasidtlp = write_buffer_mstr.hdr.pasidtlp;

 // Parity covers the following write_buffer_mstr.hdr fields:
 //
 // add_par : add[63:2]
 // len_par : length[4:0]
 // par:    : invalid, num_hcws, src, cq_v, cq_ldb, cq, ro, pasidtlp, tc_sel
 //
 // Only add, length, and pasidtlp are passed directly to the phdr, so need to adjust for the other fields.

 phdr_par = ^{ write_buffer_mstr.hdr.par
             , write_buffer_mstr.hdr.add_par
             , write_buffer_mstr.hdr.len_par
             , write_buffer_mstr.hdr.invalid
             , write_buffer_mstr.hdr.num_hcws
             , write_buffer_mstr.hdr.src
             , write_buffer_mstr.hdr.cq_v
             , write_buffer_mstr.hdr.cq_ldb
             , write_buffer_mstr.hdr.cq
             ,(write_buffer_mstr.hdr.ro & ~csr_ppdcntl_ero)
             , write_buffer_mstr.hdr.tc_sel
             , phdr.pcie32.rsvd4
             , phdr.pcie32.fmt
             , phdr.pcie32.ttype
             , phdr.pcie32.tc
             , current_bus
             };

end //always_comb

//----------------------------------------------------------------------------------------------------
// HAP Channel IDs
//
// 0: ordered   (ints)
// 1: unordered (main data path)
// 2: unordered (unused)
// 3: unordered (ATS requests)

//----------------------------------------------------------------------------------------------------
// For a write that turns off BME, we need to stop mastering any transactions except for completions
// AND ATS Invalidate Responses.  From a bus POV, we should not master any transactions (w/ the noted
// exceptions) after the completion for the BME reset has been sent out.
// The easiest way to do this would be to recognize the completion for the BME=0 write, hold it and
// prevent further IOSF requests, and wait until we have sent out any transactions for which we've
// already sent an IOSF request, and then send the completion.  We can set a piece of state that
// prevents further CQ or NP LLs from looking valid to the RL arbiter.  This would allow P (which are
// currently only ATS Invalidate responses) and completions to proceed after this completion has been
// sent.  I don't think we need to do any type of other draining and throwing away of requests; we
// can just pick up where we left off if BME is set to 1.

//----------------------------------------------------------------------------------------------------
// For a write that turns off MSIXE, we need to stop mastering MSIX writes.  From a bus POV, we should
// not master any MSIX writes after the completion for the MSIXE reset has been sent out.  In the past
// we've thrown these MSIX writes away, but I think it would be better to have a mechanism for draining
// these interrupt writes and setting the appropriate pending bit for them back in the system.  That
// seems complicated and problematic, though.

//----------------------------------------------------------------------------------------------------
// Input transaction processing to add transactions to the appropriate LL

hqm_AW_width_scale #(.A_WIDTH(HQM_SYSTEM_CQ_WIDTH), .Z_WIDTH(HQM_MSTR_NUM_LLS_WIDTH)) i_wb_cq_scaled (

     .a     (write_buffer_mstr.hdr.cq)
    ,.z     (wb_cq_scaled)
);

always_comb begin

 // Convert hptr vectors to MDAs

 for (int i=0; i<(1<<HQM_MSTR_NUM_LLS_WIDTH); i=i+1) begin
  ll_hptr_mda[i] = (i<HQM_MSTR_NUM_LLS) ? ll_hptr[i* HQM_MSTR_FL_DEPTH_WIDTH +:  HQM_MSTR_FL_DEPTH_WIDTH] : '0;
 end

 // cq_ldb and cq are setup for CQ and interrupt writes.  cq_v and src distinguish the cases.
 // Putting interrupts on the tail of the LL for the CQ they are associated with.
 // Alarm interrupts go on their own LL.

 wb_cq = (write_buffer_mstr.hdr.cq_ldb) ? (wb_cq_scaled + NUM_DIR_CQ[HQM_MSTR_NUM_LLS_WIDTH-1:0])
                                        :  wb_cq_scaled;

 // src  cq_v
 // PW    x    Other posted write (no other P writes are POR right now)
 // SCH   x    CQ    posted write
 // MSIX  0    Alarm MSI-X interrupt write
 // MSIX  1    CQ    MSI-X interrupt write
 // AI    x    CQ    IMS   interrupt write

 wb_pw               = write_buffer_mstr_v & (write_buffer_mstr.hdr.src ==   PW);
 wb_pcq              = write_buffer_mstr_v & (write_buffer_mstr.hdr.src ==  SCH);
 wb_msix             = write_buffer_mstr_v & (write_buffer_mstr.hdr.src == MSIX);
 wb_ims              = write_buffer_mstr_v & (write_buffer_mstr.hdr.src ==   AI);
 wb_alarm            = wb_msix & ~write_buffer_mstr.hdr.cq_v;

 // Only POR transaction right now that needs ATS are the CQ writes.

 wb_tlb_reqd         = cfg_ats_enabled_q & wb_pcq;

 wb_ll               = (wb_alarm) ? HQM_MSTR_INT_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0] :
                      ((wb_pw)    ? HQM_MSTR_P_LL[  HQM_MSTR_NUM_LLS_WIDTH-1:0] : wb_cq);

 wb_drop_msixe       = '0;
 wb_drop_invalid     = '0;
 wb_drop_cq          = '0;

 blk_v_next          = blk_v_q;
 msix_v_next         = msix_v_q;
 ims_v_next          = ims_v_q;
 cpld_next           = cpld_q;

 hpa_v_next          = '0;
 hpa_err_next        = '0;
 hpa_pnd_next        = '0;

 hpa_v_next[  HQM_MSTR_NUM_CQS-1:0] = hpa_v_q;
 hpa_err_next[HQM_MSTR_NUM_CQS-1:0] = hpa_err_q;
 hpa_pnd_next[HQM_MSTR_NUM_CQS-1:0] = hpa_pnd_q;

 fl2ll_v             = '0;
 fl2ll_ll            = wb_ll;

 devtlb_req_v        = '0;
 devtlb_req          = '0;

 devtlb_hcrd_dec     = '0;
 devtlb_lcrd_dec     = '0;

 tx_msg_ack          = '0;

 scrbd_alloc         = '0;
 scrbd_alloc_data    = '0;

 devtlb_ats_alarm    = '0;
 set_devtlb_ats_err  = '0;

 atshdr_ready        = '0;
 obcpl_ready         = '0;

 flr_cpl_sent_next   = '0;
 ps_cpl_sent_next    = '0;
 ps_d0               = '0;
 block_cq_p_np_lls   = '0;
 drain_cq_p_np_lls   = '0;
 allow_bme_update    = '0;
 allow_msixe_update  = '0;

 sent_bme_cpl_next   = sent_bme_cpl_q;
 sent_msixe_cpl_next = sent_msixe_cpl_q;

 xreq_cnt_dec        = '0;
 xreq_cnt_inc        = '0;

 xreq_cnt_lt_limit   = (xreq_cnt_q < cfg_scrbd_ctl.XREQ_LIMIT);

 invrsphdr_pasidtlp  = {
                        tx_msg.pasid_valid
                       ,tx_msg.pasid_priv
                       ,1'b0
                       ,tx_msg.pasid
                       };

 invrsphdr           = '0;

 // Note that rsvd4(tc[3]), rsvd3(rsvd1_7), rsvd2(rsvd1_3), attr2(ido), rsvd0(rsvd1_1), oh(th),
 // td, ep, attr, rsvd5(addr[1]), at[1:0], length, tag are always 0

 // tx_msg.opcode should always be 0 for invrsp since PRS is not supported

 invrsphdr.pciemsg.fmt      = 2'h1;
 invrsphdr.pciemsg.ttype    = 5'h12;
 invrsphdr.pciemsg.tc       = tx_msg.tc;
 invrsphdr.pciemsg.rqid     = tx_msg.bdf;
 invrsphdr.pciemsg.msgcode  = 8'h02;
 invrsphdr.pciemsg.rsvd5    = {tx_msg.dw3, tx_msg.dw2};

 invrsphdr_par              = ^{invrsphdr_pasidtlp, invrsphdr.pcie32};

 write_buffer_mstr_ready    = '0;

 memi_mstr_ll_hpa_next.we      = '0;
 memi_mstr_ll_hpa_next.waddr   = devtlb_rsp.id;
 memi_mstr_ll_hpa_next.wdata   = {(^devtlb_rsp.address), devtlb_rsp.address};

 memi_mstr_ll_hdr_next.we      = '0;
 memi_mstr_ll_hdr_next.waddr   = fl_hptr;
 memi_mstr_ll_hdr_next.wdata   = {atshdr_par, 1'b0, atshdr_pasidtlp, atshdr};

 memi_mstr_ll_data0_next.we    = '0;
 memi_mstr_ll_data0_next.waddr = fl_hptr;
 memi_mstr_ll_data0_next.wdata = {(^write_buffer_mstr.data_ls.dpar[3:0]), write_buffer_mstr.data_ls.data[127:0]};

 memi_mstr_ll_data1_next.we    = '0;
 memi_mstr_ll_data1_next.waddr = fl_hptr;
 memi_mstr_ll_data1_next.wdata = {(^write_buffer_mstr.data_ls.dpar[7:4]), write_buffer_mstr.data_ls.data[255:128]};

 memi_mstr_ll_data2_next.we    = '0;
 memi_mstr_ll_data2_next.waddr = fl_hptr;
 memi_mstr_ll_data2_next.wdata = {(^write_buffer_mstr.data_ms.dpar[3:0]), write_buffer_mstr.data_ms.data[127:0]};

 memi_mstr_ll_data3_next.we    = '0;
 memi_mstr_ll_data3_next.waddr = fl_hptr;
 memi_mstr_ll_data3_next.wdata = {(^write_buffer_mstr.data_ms.dpar[7:4]), write_buffer_mstr.data_ms.data[255:128]};

 //---------------------------------------------------------------------------------------------------
 // Outbound completions

 if (obcpl_v) begin // OBCPL valid

  //--------------------------------------------------------------------------------------------------
  // If this is the completion for a write that turned off BME, need to stop mastering new transactions
  // (except for completions and invalidate responses (which are posted messages)).  The spec rule is
  // that we should master no more transactions on the bus after the completion for the write that
  // turned off BME is seen on the bus.
  // We'll use the local BME bit to make any current CQ P or NP LLs look invalid to the LL arbiter so
  // there are no more requests generated.

  if ((obcpl_hdr.cs == 3'd0) & ~obcpl_hdr.fmt &
      (obcpl_enables.enable == BME) & ~obcpl_enables.value & local_bme) begin // BME 1->0 Cpl

   if (~sif_mstr_quiesce_req_q) begin // Not quiescing

    // Block CQ P and NP LLs from LL arbiter

    block_cq_p_np_lls = '1;

    if (~fl_aempty) begin // Send Cpl

     allow_bme_update    = '1;

     obcpl_ready         = '1;

     fl2ll_v             = '1;
     fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];

     blk_v_next[fl_hptr] = '1;

     memi_mstr_ll_hdr_next.we    = '1;
     memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};

     // BME write completion is Cpl and not CplD, so no data

    end // Send Cpl

   end // Not quiescing

  end // BME 1->0 Cpl

  //--------------------------------------------------------------------------------------------------
  // If this is the completion for a write that turned on BME, can start mastering new transactions.
  // The spec rule is that we can master a transaction on the bus after the completion for the write
  // that turned on BME is seen on the bus.
  // So, send out the BME=1 completion and wait for it to go out on the bus before updating the local
  // BME bit to allow the LL arbiter to see any other pending CQ P and NP LL transactions.

  else if ((obcpl_hdr.cs == 3'd0) & ~obcpl_hdr.fmt &
           (obcpl_enables.enable == BME) & obcpl_enables.value & ~local_bme) begin // BME 0->1 Cpl

   if (~sif_mstr_quiesce_req_q) begin // Not quiescing

    if (~sent_bme_cpl_q) begin // Cpl not yet sent

     if (~fl_aempty) begin // Send Cpl

      sent_bme_cpl_next   = '1;

      fl2ll_v             = '1;
      fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];

      blk_v_next[fl_hptr] = '1;

      memi_mstr_ll_hdr_next.we    = '1;
      memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};

      // BME write completion is Cpl and not CplD, so no data

     end // Send Cpl

    end // Cpl not yet sent

    else if (~ll_v[HQM_MSTR_CPL_LL]) begin // Cpl sent

     // Allow the local BME update and pop the Cpl

     sent_bme_cpl_next = '0;

     allow_bme_update  = '1;

     obcpl_ready       = '1;

    end // Cpl sent

   end // Not quiescing

  end // BME=1 Cpl

  //--------------------------------------------------------------------------------------------------
  // If this is the completion for a write that turned off MSIXE, need to stop mastering new MSIX
  // interrupts.  The spec rule is that we should master no more MSIX writes on the bus after the
  // completion for the write that turned off MSIXE is seen on the bus.
  // Since MSIXE=0 will stop the write buffer from generating new MSIX writes, we can wait for any
  // existing MSIX writes to be issued before allowing the local MSIXE update.

  else if ((obcpl_hdr.cs == 3'd0) & ~obcpl_hdr.fmt &
      (obcpl_enables.enable == MSIXE) & ~obcpl_enables.value & local_msixe) begin // MSIXE 1->0 Cpl

   if (~sif_mstr_quiesce_req_q) begin // Not quiescing

    if (~sent_msixe_cpl_q) begin // Cpl not yet sent

     if (~(|msix_v_q) & ~fl_aempty) begin // Send Cpl

      // Send completion when we have no more outstanding interrupts queued

      sent_msixe_cpl_next = '1;

      fl2ll_v             = '1;
      fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];

      blk_v_next[fl_hptr] = '1;

      memi_mstr_ll_hdr_next.we    = '1;
      memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};

      // MSIXE write completion is Cpl and not CplD, so no data

     end

    end // Cpl not yet sent

    else if (~ll_v[HQM_MSTR_CPL_LL]) begin // Cpl sent

     // Allow the local MSIXE update and pop the Cpl

     sent_msixe_cpl_next = '0;

     allow_msixe_update  = '1;

     obcpl_ready         = '1;

    end // Cpl sent

   end // Not quiescing

  end // MSIXE 1->0 Cpl

  //--------------------------------------------------------------------------------------------------
  // If this is the completion for a write that turned on MSIXE, can start mastering new MSIX
  // interrupts.  The spec rule is that we can master MSIX writes on the bus after the completion
  // for the write that turned on MSIXE is seen on the bus.
  // Since MSIXE=1 will allow the write buffer to generate new MSIX writes, we should wait until we
  // send out the completion before allowing new MSIX writes into the Cpl RL.

  else if ((obcpl_hdr.cs == 3'd0) & ~obcpl_hdr.fmt &
      (obcpl_enables.enable == MSIXE) & obcpl_enables.value & ~local_msixe) begin // MSIXE 0->1 Cpl

   if (~sif_mstr_quiesce_req_q) begin // Not quiescing

    if (~sent_msixe_cpl_q) begin // Cpl not yet sent

     if (~fl_aempty) begin // Send Cpl

      sent_msixe_cpl_next = '1;

      fl2ll_v             = '1;
      fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];

      blk_v_next[fl_hptr] = '1;

      memi_mstr_ll_hdr_next.we    = '1;
      memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};

      // MSIXE write completion is Cpl and not CplD, so no data

     end // Send Cpl

    end // Cpl not yet sent

    else if (~ll_v[HQM_MSTR_CPL_LL]) begin // Cpl sent

     // Allow the local MSIXE update and pop the Cpl

     sent_msixe_cpl_next = '0;

     allow_msixe_update  = '1;

     obcpl_ready         = '1;

    end // Cpl Sent

   end // Not quiescing

  end // MSIXE 0->1 Cpl

  //--------------------------------------------------------------------------------------------------
  // If this is an FLR completion, let's keep it valid to block any further TI transactions and wait
  // for any pending transactions to drain before allowing it into the LL.
  // Should not get any more outbound completions after the FLR completion (CDS throwing them away).

  else if (flr_txn_sent_q & (flr_txn_tag_q   == obcpl_hdr.tag) &
                            (flr_txn_reqid_q == obcpl_hdr.rid)) begin // FLR Cpl

   if (~sif_mstr_quiesce_req_q) begin // Not quiescing

    if (|ll_v) begin // MSTR not empty

     // We can throw away any CQ P or NP LL blocks that are pending.  Doing this by pushing one block
     // at a time back to the FL using the LL arbiter and forcing these LLs to look valid, to avoid
     // needing per LL counters (if we had them we could just push the whole list for each LL instead).
     // Should wait until all the pending RLs and DBs have been granted.

     drain_cq_p_np_lls = '1;

    end // MSTR not empty

    else if (~fl_empty) begin // MSTR empty

     // Accept FLR completion, pop FL to push hdr onto appropriate LL, and store header.
     // Set the flag to hold off any further input transactions (the FLR will clear them).

     flr_cpl_sent_next   = '1;

     obcpl_ready         = '1;

     fl2ll_v             = '1;
     fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];

     blk_v_next[fl_hptr] = '1;

     memi_mstr_ll_hdr_next.we    = '1;
     memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};

     // FLR completion is Cpl and not CplD, so no data

    end // MSTR empty

   end // Not quiescing

  end // FLR Cpl

  //--------------------------------------------------------------------------------------------------

  else if (ps_txn_sent_q & (ps_txn_tag_q   == obcpl_hdr.tag) &
                           (ps_txn_reqid_q == obcpl_hdr.rid)) begin // PS Cpl

   if (~sif_mstr_quiesce_req_q) begin // Not quiescing

    if (|ll_v) begin // MSTR not empty

     // Need same treatment as FLR: allow Cpl to proceed but drain any pending CQ P or NP LL blocks

     drain_cq_p_np_lls = '1;

    end // MSTR not empty

    else if (~fl_empty) begin // MSTR empty

     // Accept PS completion, pop FL to push hdr onto appropriate LL, and store header.

     ps_cpl_sent_next    = '1;
     ps_d0               = ~(|obcpl_hdr.pm);

     obcpl_ready         = '1;

     fl2ll_v             = '1;
     fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];

     blk_v_next[fl_hptr] = '1;

     memi_mstr_ll_hdr_next.we    = '1;
     memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};

     // PS completion is Cpl and not CplD, so no data

    end // MSTR empty

   end // Not quiescing

  end // PS Cpl

  //--------------------------------------------------------------------------------------------------

  else if (~fl_aempty) begin // Normal Cpl

   // Completions do not require ATS.  Allow completions even during quiesce.
   // Accept completion, pop FL to push hdr onto appropriate LL, and store header

   obcpl_ready         = '1;

   fl2ll_v             = '1;
   fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];

   blk_v_next[fl_hptr] = '1;
   cpld_next[ fl_hptr] = (obcpl_hdr.cs == 3'd0) & obcpl_hdr.fmt;

   memi_mstr_ll_hdr_next.we    = '1;
   memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};

   if (cplhdr.fmt[1]) begin

    memi_mstr_ll_data0_next.we    = '1;
    memi_mstr_ll_data0_next.wdata = {obcpl_dpar, 96'd0, obcpl_data};

   end

  end // Normal Cpl

 end // OBCPL valid

 //---------------------------------------------------------------------------------------------------
 // Message valid (invalidate response) from devtlb
 //
 // These need to persist through an FLR?

 else if (tx_msg_v & ~devtlb_reset & ~fl_empty & ~sif_mstr_quiesce_req_q) begin // Invalidate Response

  // As long as we have a freelist block available, format the posted Msg header, pop the FL block
  // and push it onto the P LL, and write the Msg header.  No ATS required.

  tx_msg_ack = '1;

  fl2ll_v    = '1;
  fl2ll_ll   = HQM_MSTR_P_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];

  blk_v_next[fl_hptr] = '1;

  memi_mstr_ll_hdr_next.we    = '1;
  memi_mstr_ll_hdr_next.wdata = {invrsphdr_par, 1'b0, invrsphdr_pasidtlp, invrsphdr};

 end // Invalidate Response

 //---------------------------------------------------------------------------------------------------

 else if (flr_cpl_sent_q | ps_cpl_sent_q) begin // FLR/PS Cpl Sent

  // Just park here if waiting for FLR to occur or PS to return to D0 after sending the FLR/PS Cpl

  // Invalidate responses have priority because they have to go out

 end // FLR/PS Cpl Sent

 //---------------------------------------------------------------------------------------------------
 // Header valid from devtlb ATS request

 else if (atshdr_v & ~sif_mstr_quiesce_req_q) begin // ATS Header

  // Already checked freelist available before setting atshdr_v, so pop the FL block, push it onto
  // the NP LL, and write the header.
  // Never a data phase for ATS requests.

  atshdr_ready = '1;

  fl2ll_v      = '1;
  fl2ll_ll     = HQM_MSTR_NP_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];

  blk_v_next[fl_hptr] = '1;

  memi_mstr_ll_hdr_next.we    = '1;
  memi_mstr_ll_hdr_next.wdata = {atshdr_par, 1'b0, atshdr_pasidtlp, atshdr};

  // Allocate the scoreboard entry

  scrbd_alloc      = '1;
  scrbd_alloc_data = ats_alloc_data;

 end // ATS Header

 else if (write_buffer_mstr_v & ~sif_mstr_quiesce_req_q) begin // WB packet

  // Drop the packet if the invalid bit is set, if the local_msixe bit is off and this is an MSI-X,
  // or if this is a CQ write and the HPA error flag is set for the CQ.

  wb_drop_msixe   = (write_buffer_mstr.hdr.src == MSIX) & ~local_msixe;
  wb_drop_invalid =  write_buffer_mstr.hdr.invalid;
  wb_drop_cq      =  write_buffer_mstr.hdr.cq_v & hpa_err_scaled[wb_cq];

  if (wb_drop_msixe | wb_drop_invalid  | wb_drop_cq) begin // Invalid

   write_buffer_mstr_ready = '1;

  end // Invalid

  // Can accept a new header if the FL is not empty, and we are not in the middle of an inalidate request,
  // and we either don't need to generate a TLB lookup or we have at least one HP TLB request credit and
  // the xreq count is below the limit to allow us to do a new devtlb request.
  // Won't get here if we have a pending FLR or PS state change.

  else if (~fl_aempty & ~invrsp_pend_q & (~wb_tlb_reqd | ((|devtlb_hcrd_q) & xreq_cnt_lt_limit))) begin // Accept WB

   write_buffer_mstr_ready = '1;

   //TBD: If we want to replace the write buffer storage it presents a problem of how we save partial CL
   // writes so earlier HCWs can be rewritten.
   // If the WB optimization indicates a full cache line is expected, then we can just not set the blk_v
   // until we get the last write.  But if we don't know we'll be getting any more blocks, we do have
   // to send the CL out.  Do we hang onto the block instead of putting it back onto the FL?
   //
   // addr[5:4]
   //    0       1st HCW in new CL: hcw -> d0, zeros w/ ~gen -> d1,d2,d3
   //    1       2nd HCW in new CL: hcw -> d1
   //    2       3rd HCW in new CL: hcw -> d2
   //    3       4th HCW in new CL: hcw -> d3

   // Pop FL to push hdr onto appropriate LL and store header

   fl2ll_v = '1;

   memi_mstr_ll_hdr_next.we    = '1;
   memi_mstr_ll_hdr_next.wdata = {(phdr_par ^ wb_tlb_reqd), wb_tlb_reqd, phdr_pasidtlp, phdr};

   // All current transactions have data, so store the data

   memi_mstr_ll_data0_next.we = '1;
   memi_mstr_ll_data1_next.we = (write_buffer_mstr.hdr.length > 5'd4);
   memi_mstr_ll_data2_next.we = (write_buffer_mstr.hdr.length > 5'd8);
   memi_mstr_ll_data3_next.we = (write_buffer_mstr.hdr.length > 5'd12);

   // Interrupts set the interrupt valid indication, but do not set the wb_tlb_reqd indication,
   // which ultimately is used to mux in the HPA when the other transactions that require it go out.
   // Not setting the blk_v on CQ interrupt writes since they need the source ordering and need to wait
   // until all the previous NP CQ writes have completed.

   msix_v_next[fl_hptr] =  wb_msix;
   ims_v_next[ fl_hptr] =  wb_ims;
   blk_v_next[ fl_hptr] = ~(wb_msix | wb_ims) | wb_alarm;

   // Generate devtlb request if the HPA is not yet valid for this CQ and we don't have one pending already.

   if (wb_tlb_reqd & ~hpa_v_scaled[wb_cq] & ~hpa_pnd_scaled[wb_cq]) begin // Need devtlb lookup

    // Increment the xreq counter, decrement the HP xreq credit counter, set the HPA pending flag, and
    // send the request to the devtlb.

    hpa_pnd_next[wb_cq]     = '1;

    xreq_cnt_inc            = '1;

    devtlb_hcrd_dec         = '1;

    devtlb_req_v            = '1;
    devtlb_req.pasid_valid  = phdr_pasidtlp.fmt2;
    devtlb_req.pasid_priv   = phdr_pasidtlp.pm_req;
    devtlb_req.pasid        = phdr_pasidtlp.pasid;
    devtlb_req.id           = wb_cq[HQM_MSTR_NUM_CQS_WIDTH-1:0];    // Use CQ as ID
    devtlb_req.tlbid        = '0;                                   // uTLB[0]
    devtlb_req.ppriority    = '1;                                   // High priority
    devtlb_req.prs          = '0;                                   // No PRS
    devtlb_req.opcode       = '0;                                   // UTRN_W: Write access required
    devtlb_req.tc           = 3'd0;
    devtlb_req.bdf          = '0;
    devtlb_req.address      = (phdr.pcie64.fmt[0]) ?
                               phdr.pcie64.addr[DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:12] :
                               {{(DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-32){1'b0}}, phdr.pcie32.addr[31:12]};

   end // Need devtlb lookup

  end // Accept WB

 end // WB packet

 //---------------------------------------------------------------------------------------------------
 // devtlb request response

 if (devtlb_rsp_v & ~devtlb_reset) begin // devtlb response

  // Decrement the xreq counter, mark the HPA valid and reset the HPA pending flag for this CQ in any
  // case.  The error case will also end up setting the HPA error flag.

  xreq_cnt_dec                = '1;

  hpa_v_next[  devtlb_rsp.id] = '1;
  hpa_pnd_next[devtlb_rsp.id] = '0;

  if (devtlb_rsp.result & ~devtlb_rsp.dperror & ~devtlb_rsp.hdrerror) begin // devtlb success

   // If no error, store the HPA

   memi_mstr_ll_hpa_next.we   = '1;

   //TBD: Do we care about nonsnooped?

   //devtlb_rsp.nonsnooped;
   //devtlb_rsp.prs_code;

  end // devtlb success

  else begin // devtlb failure

   // Error case sets the HPA error flag for this CQ and reports the alarm w/ syndrome

   devtlb_ats_alarm              = '1;

   hpa_err_next[devtlb_rsp.id]   = '1;

   set_devtlb_ats_err.BAD_RESULT = ~devtlb_rsp.result;
   set_devtlb_ats_err.HDRERROR   =  devtlb_rsp.hdrerror;
   set_devtlb_ats_err.DPERROR    =  devtlb_rsp.dperror;

  end // devtlb failure

 end // devtlb response

 // Reset HPA error flag for a particular CQ only on a SW clear

 if (clr_hpa_err) begin

  hpa_err_next[clr_hpa_err_cq] = '0;

 end

 // Reset all HPA valid flags on a drain request completion

 if (clr_hpa_v) begin

  hpa_v_next = '0;

 end

 // Reset all the per block flags when a block is pushed back onto the FL

 if (fl_push) begin

  blk_v_next[ fl_push_ptr] = '0;
  msix_v_next[fl_push_ptr] = '0;
  ims_v_next[ fl_push_ptr] = '0;
  cpld_next[  fl_push_ptr] = '0;

 end

 // Vector of the blk_v, msix_v, ims_v, and hpa_v status at the head of each LL

 // Since the arbiter inputs and outputs are registered, there is a 2 cycle delay from blk_v to any
 // TX credit update, so we need to account for this in the credit checks.
 //
 // VC FC LL
 //  3  1 NP                ATS requests        require 1 header credit.               
 //  1  0 0 to NUM_CQS-1    CQ writes           require 1 header and 4 data credits.
 //  0  2 CPL               Cpls                require 1 header credit.
 //  0  2 CPL               CplDs               require 1 header and 1 data credit.
 //  0  0 0 to NUM_CQS-1    CQ interrupt writes require 1 header and 1 data credit.
 //  0  0 INT               Alarm writes        require 1 header and 1 data credit.
 //  0  0 P                 Inv responses       require 1 header credit.

 for (int i=0; i<HQM_MSTR_NUM_CQS; i=i+1) begin

   msix_v[i] = ll_v[i] & msix_v_q[ll_hptr_mda[i]];
   ims_v[i]  = ll_v[i] & ims_v_q[ ll_hptr_mda[i]];

 end

 tx_hcrds_reqd = '0;
 tx_dcrds_reqd = '0;

 tx_hcrds_reqd[2][1] = (ll_arb_reqs[HQM_MSTR_NP_LL] & ll_arb_winner_is_ats) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd3} :
                      ((ll_arb_reqs[HQM_MSTR_NP_LL] | ll_arb_winner_is_ats) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd2} :
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd1});

 tx_hcrds_reqd[1][0] = (ll_arb_reqs_cq & ll_arb_winner_is_cq) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd3} :
                      ((ll_arb_reqs_cq | ll_arb_winner_is_cq) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd2} :
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd1});

 tx_hcrds_reqd[0][2] = (ll_arb_reqs[HQM_MSTR_CPL_LL] & (ll_arb_winner_is_cpl | ll_arb_winner_is_cpld)) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd3} :
                      ((ll_arb_reqs[HQM_MSTR_CPL_LL] | (ll_arb_winner_is_cpl | ll_arb_winner_is_cpld)) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd2} :
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd1});

 tx_hcrds_reqd[0][0] = ((ll_arb_reqs[HQM_MSTR_P_LL] | ll_arb_reqs_int) & (ll_arb_winner_is_inv | ll_arb_winner_is_int)) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd3} :
                      (((ll_arb_reqs[HQM_MSTR_P_LL] | ll_arb_reqs_int) | (ll_arb_winner_is_inv | ll_arb_winner_is_int)) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd2} :
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd1});

 tx_dcrds_reqd[1][0] = (ll_arb_reqs_cq & ll_arb_winner_is_cq) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-4){1'b0}}, 4'd12} :
                      ((ll_arb_reqs_cq | ll_arb_winner_is_cq) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-4){1'b0}}, 4'd8} :
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-4){1'b0}}, 4'd4});

 tx_dcrds_reqd[0][2] = ((ll_arb_reqs[HQM_MSTR_CPL_LL] & cpld_q[ll_hptr_mda[HQM_MSTR_CPL_LL]]) & ll_arb_winner_is_cpld) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd3} :
                      (((ll_arb_reqs[HQM_MSTR_CPL_LL] & cpld_q[ll_hptr_mda[HQM_MSTR_CPL_LL]]) | ll_arb_winner_is_cpld) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd2} :
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd1});

 tx_dcrds_reqd[0][0] = (ll_arb_reqs_int & ll_arb_winner_is_int) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd3} :
                      ((ll_arb_reqs_int | ll_arb_winner_is_int) ?
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd2} :
                            {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH-2){1'b0}}, 2'd1});

 for (int i=0; i<HQM_MSTR_NUM_LLS; i=i+1) begin // LL flags

  if (i < HQM_MSTR_NUM_CQS) begin // CQ P

   // CQ LLs: CQ writes.  Need to be able to drain for FLR. Must hold if BME==0.

//TBD: Use NP credits for UIOWR instead of current posted credits for MWR

   blk_v[i]  = ll_v[i] & (drain_cq_p_np_lls |
                ((blk_v_q[ll_hptr_mda[i]] | (cq_np_cnt_q[i] == 9'd0)) & local_bme & ~block_cq_p_np_lls &
                 ((msix_v[i] | ims_v[i]) ? (tx_hcrds_avail[0][0] >= tx_hcrds_reqd[0][0]) :
                                           (tx_hcrds_avail[1][0] >= tx_hcrds_reqd[1][0])) &
                 ((msix_v[i] | ims_v[i]) ? (tx_dcrds_avail[0][0] >= tx_dcrds_reqd[0][0]) :
                                           (tx_dcrds_avail[1][0] >= tx_dcrds_reqd[1][0]))));

   hpa_v[i]  = ll_v[i] & (drain_cq_p_np_lls |  hpa_v_q[i] | ~cfg_ats_enabled_q);

  end // CQ P

  else if (i == HQM_MSTR_P_LL) begin // P

   // P LL: Invalidate responses.  Not affected by BME setting. Must also be allowed during an FLR?

   blk_v[i] = ll_v[i] & blk_v_q[ll_hptr_mda[i]] & (tx_hcrds_avail[0][0] >= tx_hcrds_reqd[0][0]);

  end // P

  else if (i == HQM_MSTR_NP_LL) begin // NP

   // NP LL: ATS requests.  Need to be able to drain for FLR. Must hold if BME==0.

   blk_v[i] = ll_v[i] & (drain_cq_p_np_lls | (blk_v_q[ll_hptr_mda[i]] & local_bme & ~block_cq_p_np_lls &
                (tx_hcrds_avail[2][1] >= tx_hcrds_reqd[2][1])));

  end // NP

  else if (i == HQM_MSTR_CPL_LL) begin // CPL

   // CPL LL: No ATS or dependence on BME.
   //         Need a request credit and either 1 data credit (CplD) or no data credits (Cpl)

   blk_v[i] = ll_v[i] & blk_v_q[ll_hptr_mda[i]] & (tx_hcrds_avail[0][2] >= tx_hcrds_reqd[0][2]) &
                       (~cpld_q[ll_hptr_mda[i]] | (tx_dcrds_avail[0][2] >= tx_dcrds_reqd[0][2]));

  end // CPL

  else if (i == HQM_MSTR_INT_LL) begin // Alarm Int (P)

   // INT LL: No ATS.  Need to be able to drain for FLR.
   //         Must hold if BME==0.

   blk_v[i] = ll_v[i] & (drain_cq_p_np_lls | (blk_v_q[ll_hptr_mda[i]] & local_bme & ~block_cq_p_np_lls &
                (tx_hcrds_avail[0][0] >= tx_hcrds_reqd[0][0]) & (tx_dcrds_avail[0][0] >= tx_dcrds_reqd[0][0])));

  end // Alarm Int (P)

 end // LL Flags

end

//----------------------------------------------------------------------------------------------------
// Register memory write interfaces

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  memi_mstr_ll_hdr_q.we   <= '0;
  memi_mstr_ll_hpa_q.we   <= '0;
  memi_mstr_ll_data0_q.we <= '0;
  memi_mstr_ll_data1_q.we <= '0;
  memi_mstr_ll_data2_q.we <= '0;
  memi_mstr_ll_data3_q.we <= '0;
 end else begin
  memi_mstr_ll_hdr_q.we   <= memi_mstr_ll_hdr_next.we;
  memi_mstr_ll_hpa_q.we   <= memi_mstr_ll_hpa_next.we;
  memi_mstr_ll_data0_q.we <= memi_mstr_ll_data0_next.we;
  memi_mstr_ll_data1_q.we <= memi_mstr_ll_data1_next.we;
  memi_mstr_ll_data2_q.we <= memi_mstr_ll_data2_next.we;
  memi_mstr_ll_data3_q.we <= memi_mstr_ll_data3_next.we;
 end
end

always_ff @(posedge prim_nonflr_clk) begin
  if (memi_mstr_ll_hdr_next.we) begin
   memi_mstr_ll_hdr_q.waddr   <= memi_mstr_ll_hdr_next.waddr;
   memi_mstr_ll_hdr_q.wdata   <= memi_mstr_ll_hdr_next.wdata;
  end
  if (memi_mstr_ll_hpa_next.we) begin
   memi_mstr_ll_hpa_q.waddr   <= memi_mstr_ll_hpa_next.waddr;
   memi_mstr_ll_hpa_q.wdata   <= memi_mstr_ll_hpa_next.wdata;
  end
  if (memi_mstr_ll_data0_next.we) begin
   memi_mstr_ll_data0_q.waddr <= memi_mstr_ll_data0_next.waddr;
   memi_mstr_ll_data0_q.wdata <= memi_mstr_ll_data0_next.wdata;
  end
  if (memi_mstr_ll_data1_next.we) begin
   memi_mstr_ll_data1_q.waddr <= memi_mstr_ll_data1_next.waddr;
   memi_mstr_ll_data1_q.wdata <= memi_mstr_ll_data1_next.wdata;
  end
  if (memi_mstr_ll_data2_next.we) begin
   memi_mstr_ll_data2_q.waddr <= memi_mstr_ll_data2_next.waddr;
   memi_mstr_ll_data2_q.wdata <= memi_mstr_ll_data2_next.wdata;
  end
  if (memi_mstr_ll_data3_next.we) begin
   memi_mstr_ll_data3_q.waddr <= memi_mstr_ll_data3_next.waddr;
   memi_mstr_ll_data3_q.wdata <= memi_mstr_ll_data3_next.wdata;
  end
end

always_comb begin
 memi_mstr_ll_hdr.we      = memi_mstr_ll_hdr_q.we;
 memi_mstr_ll_hdr.waddr   = memi_mstr_ll_hdr_q.waddr;
 memi_mstr_ll_hdr.wdata   = memi_mstr_ll_hdr_q.wdata;
 memi_mstr_ll_hpa.we      = memi_mstr_ll_hpa_q.we;
 memi_mstr_ll_hpa.waddr   = memi_mstr_ll_hpa_q.waddr;
 memi_mstr_ll_hpa.wdata   = memi_mstr_ll_hpa_q.wdata;
 memi_mstr_ll_data0.we    = memi_mstr_ll_data0_q.we;
 memi_mstr_ll_data0.waddr = memi_mstr_ll_data0_q.waddr;
 memi_mstr_ll_data0.wdata = memi_mstr_ll_data0_q.wdata;
 memi_mstr_ll_data1.we    = memi_mstr_ll_data1_q.we;
 memi_mstr_ll_data1.waddr = memi_mstr_ll_data1_q.waddr;
 memi_mstr_ll_data1.wdata = memi_mstr_ll_data1_q.wdata;
 memi_mstr_ll_data2.we    = memi_mstr_ll_data2_q.we;
 memi_mstr_ll_data2.waddr = memi_mstr_ll_data2_q.waddr;
 memi_mstr_ll_data2.wdata = memi_mstr_ll_data2_q.wdata;
 memi_mstr_ll_data3.we    = memi_mstr_ll_data3_q.we;
 memi_mstr_ll_data3.waddr = memi_mstr_ll_data3_q.waddr;
 memi_mstr_ll_data3.wdata = memi_mstr_ll_data3_q.wdata;
end

//----------------------------------------------------------------------------------------------------
// Per LL block pointer flags and xreq counter

always_comb begin

 // XREQ counter inc/dec

 case ({xreq_cnt_inc, xreq_cnt_dec})
  2'b10:   xreq_cnt_next = xreq_cnt_q + 6'd1;
  2'b01:   xreq_cnt_next = xreq_cnt_q - 6'd1;
  default: xreq_cnt_next = xreq_cnt_q;
 endcase

end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  blk_v_q    <= '0;
  msix_v_q   <= '0;
  ims_v_q    <= '0;
  cpld_q     <= '0;
  hpa_v_q    <= '0;
  hpa_err_q  <= '0;
  hpa_pnd_q  <= '0;
  xreq_cnt_q <= '0;
 end else begin
  blk_v_q    <= blk_v_next;
  msix_v_q   <= msix_v_next;
  ims_v_q    <= ims_v_next;
  cpld_q     <= cpld_next;
  hpa_v_q    <= hpa_v_next[  HQM_MSTR_NUM_CQS-1:0];
  hpa_err_q  <= hpa_err_next[HQM_MSTR_NUM_CQS-1:0];
  hpa_pnd_q  <= hpa_pnd_next[HQM_MSTR_NUM_CQS-1:0];
  xreq_cnt_q <= xreq_cnt_next;
 end
end

hqm_AW_width_scale #(.A_WIDTH(HQM_MSTR_NUM_CQS), .Z_WIDTH(1<<HQM_MSTR_NUM_LLS_WIDTH)) i_hpa_v_scaled (

     .a     (hpa_v_q)
    ,.z     (hpa_v_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(HQM_MSTR_NUM_CQS), .Z_WIDTH(1<<HQM_MSTR_NUM_LLS_WIDTH)) i_hpa_err_scaled (

     .a     (hpa_err_q)
    ,.z     (hpa_err_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(HQM_MSTR_NUM_CQS), .Z_WIDTH(1<<HQM_MSTR_NUM_LLS_WIDTH)) i_hpa_pnd_scaled (

     .a     (hpa_pnd_q)
    ,.z     (hpa_pnd_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(HQM_MSTR_NUM_CQS), .Z_WIDTH(1<<HQM_MSTR_NUM_LLS_WIDTH)) i_msix_v_scaled (

     .a         (msix_v)
    ,.z         (msix_v_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(HQM_MSTR_NUM_CQS), .Z_WIDTH(1<<HQM_MSTR_NUM_LLS_WIDTH)) i_ims_v_scaled (

     .a         (ims_v)
    ,.z         (ims_v_scaled)
);

//----------------------------------------------------------------------------------------------------
// Local enable logic
//
// Need local copies of the BME and MSIXE bits to manage when we can master transactions.
// These local bits get updated when the completion for the write that changed them is processed
// (or immediately when they are updated through sideband).

always_comb begin

 local_bme_next   = local_bme_q;
 local_msixe_next = local_msixe_q;

 // Doesn't matter when we update these if they are changed by GPSB since primary and sideband
 // are asynchronous.  There can be no real expectations on ordering between the two.

 if (gpsb_upd_enables.enable == BME)   local_bme_next   = gpsb_upd_enables.value;
 if (gpsb_upd_enables.enable == MSIXE) local_msixe_next = gpsb_upd_enables.value;

 // Primary wins on a conflict (not a usage case)

 if (allow_bme_update) begin
  if (obcpl_enables.enable == BME)   local_bme_next   = obcpl_enables.value;
 end

 if (allow_msixe_update) begin
  if (obcpl_enables.enable == MSIXE) local_msixe_next = obcpl_enables.value;
 end

end

always_ff @(posedge prim_nonflr_clk or negedge hqm_csr_pf0_rst_n) begin
 if (~hqm_csr_pf0_rst_n) begin
  local_bme_q      <= '0;
  local_msixe_q    <= '0;
  sent_bme_cpl_q   <= '0;
  sent_msixe_cpl_q <= '0;
 end else begin
  local_bme_q      <= local_bme_next;
  local_msixe_q    <= local_msixe_next;
  sent_bme_cpl_q   <= sent_bme_cpl_next;
  sent_msixe_cpl_q <= sent_msixe_cpl_next;
 end
end

assign local_bme   = local_bme_q   & ~flr_treatment_vec;
assign local_msixe = local_msixe_q & ~flr_treatment_vec;

assign local_bme_status   = local_bme;
assign local_msixe_status = local_msixe;

//----------------------------------------------------------------------------------------------------
// Arbitrate among valid LLs

// An LL looks valid if the LL is not empty and all conditions are met.
// Using hpa_v to indicate when the HPA has been received for transactions that require ATS.
// Using blk_v to indicate when "other conditions" are met.
//
// Only CQ writes (LLs 0 thru HQM_MSTR_NUM_CQS-1) require the HPA valid.  Interrupt writes and completions
// do not require HPA and we currently have no other P or NP transactions that require HPA.
// NP also require an available scoreboard location.
//
// Registering LL arbiter inputs and outputs for timing.
//
// Make LLs that don't have an request or data credits available look not valid, so one rtype isn't
// channel or rtype is not blocking the others.
//
// A quiesce request blocks any P or NP requests from looking valid to the arbiter.  Completions can
// continue during a quiesce.

//TBD: Do we need a guard so an LL doesn't consume all the FL blocks and starve the other LLs?

always_comb begin

 ll_arb_reqs_next = blk_v & {4'b1111, hpa_v} & ~ll_arb_winner_mask[HQM_MSTR_NUM_LLS-1:0];

 ll_arb_reqs      = ll_arb_reqs_q & ~ll_arb_winner_mask[HQM_MSTR_NUM_LLS-1:0] &
                           ~{sif_mstr_quiesce_req_q                         // P Alarm
                            ,1'b0                                           // Cpl/CplD
                            ,sif_mstr_quiesce_req_q                         // NP ATS req
                            ,sif_mstr_quiesce_req_q                         // P  Inv resp
                            ,{HQM_MSTR_NUM_CQS{sif_mstr_quiesce_req_q}}     // NP CQ
                            };

 ll_arb_reqs_cq   = (|(ll_arb_reqs[HQM_MSTR_NUM_CQS-1:0] & ~(msix_v | ims_v)));
 ll_arb_reqs_int  = (|(ll_arb_reqs[HQM_MSTR_NUM_CQS-1:0] &  (msix_v | ims_v)));

end

hqm_AW_rr_arbiter #(.NUM_REQS(HQM_MSTR_NUM_LLS)) u_arb (

     .clk           (prim_nonflr_clk)
    ,.rst_n         (prim_gated_rst_b)

    ,.mode          (2'd2)
    ,.update        (ll_arb_update)

    ,.reqs          (ll_arb_reqs)

    ,.winner_v      (ll_arb_winner_v_next)
    ,.winner        (ll_arb_winner_next)
);

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  ll_arb_reqs_q      <= '0;
  ll_arb_winner_v_q  <= '0;
  ll_arb_winner_q    <= '0;
 end else begin
  ll_arb_reqs_q      <= ll_arb_reqs_next;
  if (~ll_arb_hold) begin
   ll_arb_winner_v_q <= ll_arb_winner_v_next;
   ll_arb_winner_q   <= ll_arb_winner_next;
  end
 end
end

hqm_AW_bindec #(.WIDTH(HQM_MSTR_NUM_LLS_WIDTH)) i_ll_arb_winner_mask (

     .a         (ll_arb_winner_q)
    ,.enable    (ll_arb_winner_v_q)

    ,.dec       (ll_arb_winner_mask)
);

always_comb begin

 ll_arb_winner_vc      = 2'd0;
 ll_arb_winner_fc      = hqm_sfi_fc_id_t'(2'd0);

 ll_arb_winner_is_ats  = '0;
 ll_arb_winner_is_cpl  = '0;
 ll_arb_winner_is_cpld = '0;
 ll_arb_winner_is_cq   = '0;
 ll_arb_winner_is_int  = '0;
 ll_arb_winner_is_inv  = '0;

 // Draining the current arbitration winner if the FLR drain indication is on and it isn't a completion
 // or invalidate response.
 // Only the CQ P LL can have the hpa_err flag set.  If it does, we need to prevent further pushes to
 // that LL and need to drain that LL.

 ll_arb_winner_drain  = ll_arb_winner_v_q & (hpa_err_scaled[ll_arb_winner_q] |
                        (drain_cq_p_np_lls & ~((ll_arb_winner_q == HQM_MSTR_P_LL[  HQM_MSTR_NUM_LLS_WIDTH-1:0]) |
                                               (ll_arb_winner_q == HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0]))));

 if (ll_arb_winner_v_q) begin // Arb valid

  if (ll_arb_winner_q == HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0]) begin // Cpl/CplD

   // Completions on Ch0

   ll_arb_winner_vc      = 2'd0;
   ll_arb_winner_fc      = hqm_sfi_fc_id_t'(2'd2);

   ll_arb_winner_is_cpl  = '1;
   ll_arb_winner_is_cpld = cpld_q[ll_hptr_mda[HQM_MSTR_CPL_LL]];

  end // Cpl/CplD

  else if (ll_arb_winner_q == HQM_MSTR_NP_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0]) begin // NP

   // NP ATS requests on Ch2

   ll_arb_winner_vc      = 2'd2;
   ll_arb_winner_fc      = hqm_sfi_fc_id_t'(2'd1);

   // Gate off the NP and CQ P indications during draining

   ll_arb_winner_is_ats  = ~ll_arb_winner_drain;

  end // NP

  else if (ll_arb_winner_q == HQM_MSTR_P_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0]) begin // P

   // P Invalidate resposes on Ch0

   ll_arb_winner_vc      = 2'd0;
   ll_arb_winner_fc      = hqm_sfi_fc_id_t'(2'd0);

   ll_arb_winner_is_inv  = '1;

  end // P

  else if (ll_arb_winner_q == HQM_MSTR_INT_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0]) begin // Int

   // P Alarms on Ch0

   ll_arb_winner_vc      = 2'd0;
   ll_arb_winner_fc      = hqm_sfi_fc_id_t'(2'd0);

   ll_arb_winner_is_int  = '1;

  end // Int

  else if (msix_v_scaled[ll_arb_winner_q] | ims_v_scaled[ll_arb_winner_q]) begin // CQ int write

   // P Int writes on Ch0

   ll_arb_winner_vc      = 2'd0;
   ll_arb_winner_fc      = hqm_sfi_fc_id_t'(2'd0);

   ll_arb_winner_is_int  = '1;

  end // CQ Int write

  else begin // CQ write

   // P CQ writes on Ch1

   ll_arb_winner_vc      = 2'd1;
// ll_arb_winner_fc      = hqm_sfi_fc_id_t'(2'd1);  // TBD: CQ writes will ultimately be NP UIOWR
   ll_arb_winner_fc      = hqm_sfi_fc_id_t'(2'd0);

   // Gate off the NP and CQ P indications during draining

   ll_arb_winner_is_cq   = ~ll_arb_winner_drain;

  end // CQ write

 end // Arb valid

 ll_arb_hold          = agent_tx_hold & ~ll_arb_winner_drain;

 // Only update if we are not holding

 ll_arb_update        = ll_arb_winner_v_next & ~ll_arb_hold;

end

//----------------------------------------------------------------------------------------------------
// Credit management and LL reads for arbitration winner

// A valid arbitration winner needs to initiate the reads of the header, HPA, and data storage, pull
// the block off the winning LL HP and push it onto the freelist.  When the data is available the next
// clock, need to generate the request.

always_comb begin
  
 tx_hcrd_consume_v        = '0;
 tx_hcrd_consume_vc       = ll_arb_winner_vc;
 tx_hcrd_consume_fc       = ll_arb_winner_fc;
 tx_hcrd_consume_val      = '0;

 tx_dcrd_consume_v        = '0;
 tx_dcrd_consume_vc       = ll_arb_winner_vc;
 tx_dcrd_consume_fc       = ll_arb_winner_fc;
 tx_dcrd_consume_val      = '0;

 ll_pop                   = '0;
 ll_pop_ll                = ll_arb_winner_q;

 fl_push                  = '0;
 fl_push_ptr              = ll_hptr_mda[ll_arb_winner_q];

 cq_np_cnt_inc            = '0;

 ll_read_v_next           = '0;
 ll_read_vc_next          = ll_arb_winner_vc;
 ll_read_fc_next          = ll_arb_winner_fc;

 memi_mstr_ll_hpa.re      = '0;
 memi_mstr_ll_hdr.re      = '0;
 memi_mstr_ll_data0.re    = '0;
 memi_mstr_ll_data1.re    = '0;
 memi_mstr_ll_data2.re    = '0;
 memi_mstr_ll_data3.re    = '0;

 memi_mstr_ll_hpa.raddr   = ll_arb_winner_q[HQM_MSTR_NUM_CQS_WIDTH-1:0];
 memi_mstr_ll_hdr.raddr   = fl_push_ptr;
 memi_mstr_ll_data0.raddr = fl_push_ptr;
 memi_mstr_ll_data1.raddr = fl_push_ptr;
 memi_mstr_ll_data2.raddr = fl_push_ptr;
 memi_mstr_ll_data3.raddr = fl_push_ptr;

 if (ll_arb_winner_v_q & ~agent_tx_hold) begin // Arb valid

  // Push the block back onto the freelist

  ll_pop       = '1;
  ll_pop_ll    = ll_arb_winner_q;

  fl_push      = '1;
  fl_push_ptr  = ll_hptr_mda[ll_arb_winner_q];

  if (~ll_arb_winner_drain) begin // Not draining

   // Read the hdr and data storage for the arb winner

   memi_mstr_ll_hpa.re   = '1;
   memi_mstr_ll_hdr.re   = '1;
   memi_mstr_ll_data0.re = '1;
   memi_mstr_ll_data1.re = '1;
   memi_mstr_ll_data2.re = '1;
   memi_mstr_ll_data3.re = '1;

   ll_read_v_next        = '1;

   // Consume the TX credits here
  
   tx_hcrd_consume_v     = '1;
   tx_hcrd_consume_val   = '1;

   if (ll_arb_winner_is_int | ll_arb_winner_is_cq | ll_arb_winner_is_cpld) begin

    // TBD: Any need to have other than 1 or 4 data credits (ie. always a cacheline for CQ writes?)
    tx_dcrd_consume_v    = '1;
    tx_dcrd_consume_val  = (ll_arb_winner_is_cq) ? 3'd4 : 3'd1;

   end

   // If this is a CQ write and not an interrupt write, increment the NP counter

   // TBD: Need this when switching to UIOWR

// if (ll_arb_winner_is_cq) begin
//  cq_np_cnt_inc[ll_arb_winner_q] = '1;
// end

  end // Not draining

 end // Arb valid

end

//----------------------------------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  ll_read_v_q <= '0;
 end else if (~agent_tx_hold) begin
  ll_read_v_q <= ll_read_v_next;
 end
end

always_ff @(posedge prim_nonflr_clk) begin
 if (ll_read_v_next & ~agent_tx_hold) begin
  ll_read_vc_q <= ll_read_vc_next;
  ll_read_fc_q <= ll_read_fc_next;
 end
end

//----------------------------------------------------------------------------------------------------

always_comb begin

 // Translate the header

 // For transactions that required a TLB lookup, need to use the HPA result.
 // This can potentially change between 4DW<->3DW transactions depending on the resulting upper 32
 // address bits...  Note: Need to adjust the parity as well...

 {hdr_rdata_par, hdr_rdata_tlb_reqd, hdr_rdata_pasidtlp, hdr_rdata_hdr} = memo_mstr_ll_hdr.rdata;

 hdr_rdata_hdr_cpl = hdr_rdata_hdr;

 {hpa_rdata_p, hpa_rdata_hpa} = memo_mstr_ll_hpa.rdata;

 if (hdr_rdata_tlb_reqd) begin // Need HPA

  hdr_rdata_addr = {{(64-DEVTLB_MAX_HOST_ADDRESS_WIDTH){1'b0}}, hpa_rdata_hpa};
  hdr_rdata_fmt0 = (|hpa_rdata_hpa[DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:32]);

  // Since the tlb_reqd bit was included in the parity, need to invert here (hence 1'b1)

  if (hdr_rdata_hdr.pcie32.fmt[0]) begin

   hdr_rdata_padj = ^{1'b1, hpa_rdata_p, (~hdr_rdata_fmt0),
                      hdr_rdata_hdr.pcie64.addr[DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:12]};

  end else begin

   hdr_rdata_padj = ^{1'b1, hpa_rdata_p, hdr_rdata_fmt0, hdr_rdata_hdr.pcie32.addr[31:12]};

  end

 end // Need HPA

 else begin // No HPA

  hdr_rdata_addr = (hdr_rdata_hdr.pcie32.fmt[0]) ?
                    hdr_rdata_hdr.pcie64.addr[63:12] :
                    {32'd0, hdr_rdata_hdr.pcie32.addr[31:12]};

  hdr_rdata_fmt0 = hdr_rdata_hdr.pcie32.fmt[0];
  hdr_rdata_padj = '0;

 end // No HPA

 // Generate the SFI header and data

 agent_tx_v             = '0;
 agent_tx_vc            = '0;
 agent_tx_fc            = hqm_sfi_fc_id_t'('0);
 agent_tx_hdr_size      = '0;
 agent_tx_hdr_has_data  = '0;
 agent_tx_hdr           = '0;
 agent_tx_hdr_par       = '0;
 agent_tx_data          = '0;
 agent_tx_data_par      = '0;

 hdr_rdata_pcie_cmd     = hqm_sfi_pcie_cmd_t'('0);
 hdr_rdata_pcie_cmd_mrd = '0;

 cpl_hdr_requires_ohca5 = |{hdr_rdata_hdr_cpl.cplstat, hdr_rdata_hdr_cpl.lowaddr[1:0]};

 if (ll_read_v_q) begin // LL read valid

  agent_tx_v  = '1;

  agent_tx_vc = ll_read_vc_q;
  agent_tx_fc = ll_read_fc_q;

  hdr_rdata_pcie_cmd     = hqm_sfi_pcie_cmd_t'({hdr_rdata_hdr.pcie64.fmt, hdr_rdata_hdr.pcie64.ttype});
  hdr_rdata_pcie_cmd_mrd = (hdr_rdata_pcie_cmd == PCIE_CMD_MRD32) | (hdr_rdata_pcie_cmd == PCIE_CMD_MRD64);

  // The output buses are 64B + 8b parity while the LL data storage is 16B + 1b parity

  agent_tx_data_par =
   {((hdr_rdata_hdr.pcie64.len > 10'd12) ? {(^memo_mstr_ll_data3.rdata[127:64]), (^memo_mstr_ll_data3.rdata[63:0])} : 2'd0)
   ,((hdr_rdata_hdr.pcie64.len > 10'd8 ) ? {(^memo_mstr_ll_data2.rdata[127:64]), (^memo_mstr_ll_data2.rdata[63:0])} : 2'd0)
   ,((hdr_rdata_hdr.pcie64.len > 10'd4 ) ? {(^memo_mstr_ll_data1.rdata[127:64]), (^memo_mstr_ll_data1.rdata[63:0])} : 2'd0)
   ,((hdr_rdata_hdr.pcie64.len > 10'd0 ) ? {(^memo_mstr_ll_data0.rdata[127:64]), (^memo_mstr_ll_data0.rdata[63:0])} : 2'd0)
   };

  agent_tx_data =
   {((hdr_rdata_hdr.pcie64.len > 10'd12) ? memo_mstr_ll_data3.rdata[127:0] : 128'd0)
   ,((hdr_rdata_hdr.pcie64.len > 10'd8 ) ? memo_mstr_ll_data2.rdata[127:0] : 128'd0)
   ,((hdr_rdata_hdr.pcie64.len > 10'd4 ) ? memo_mstr_ll_data1.rdata[127:0] : 128'd0)
   ,((hdr_rdata_hdr.pcie64.len > 10'd0 ) ? memo_mstr_ll_data0.rdata[127:0] : 128'd0)
   };

  case (hdr_rdata_pcie_cmd) // PCIe cmd

   PCIE_CMD_MRD32,
   PCIE_CMD_MWR32: begin // 3DW MRD/MWR

    // MRD32 can only be ATS requests which require OHCA1 to provide the PASID.
    // MWR32 can be MSI-X, IMS, or CQ writes.  Interrupts are Ch0 and CQ writes are Ch1.
    // TBD: The CQ writes need to be NP UIOWR commands and need a scoreboard location.

    agent_tx_hdr.mem32.ohc_dw3           = '0;
    agent_tx_hdr.mem32.ohc_dw2           = '0;
    agent_tx_hdr.mem32.ohc_dw1           = '0;

    if (hdr_rdata_pcie_cmd_mrd) begin

     agent_tx_hdr.mem32.ohc              = ohc_noe_a;
     agent_tx_hdr.mem32.ohc_dw0.a1.nw    = '0;
     agent_tx_hdr.mem32.ohc_dw0.a1.pv    = hdr_rdata_pasidtlp[22];
     agent_tx_hdr.mem32.ohc_dw0.a1.pmr   = hdr_rdata_pasidtlp[21];
     agent_tx_hdr.mem32.ohc_dw0.a1.er    = hdr_rdata_pasidtlp[20];
     agent_tx_hdr.mem32.ohc_dw0.a1.pasid = hdr_rdata_pasidtlp[19:0];
     agent_tx_hdr.mem32.ohc_dw0.a1.lbe   = '1;
     agent_tx_hdr.mem32.ohc_dw0.a1.fbe   = '1;

     agent_tx_hdr.mem32.ttype            = FLIT_CMD_MRD32;

     agent_tx_hdr_size                   = 4'd5;

    end else begin

     agent_tx_hdr.mem32.ohc              = ohc_none;
     agent_tx_hdr.mem32.ohc_dw0          = '0;
                                      
//   agent_tx_hdr.mem32.ttype            = (ll_read_vc_q == 2'd1) ? FLIT_CMD_UIOWR : FLIT_CMD_MWR32;
     agent_tx_hdr.mem32.ttype            = FLIT_CMD_MWR32;
                                      
     agent_tx_hdr_size                   = 4'd4;
                                      
    end                               
                                      
    agent_tx_hdr_has_data                = (hdr_rdata_pcie_cmd == PCIE_CMD_MWR32);
                                      
    agent_tx_hdr.mem32.address31_2       = {hdr_rdata_addr[31:12], hdr_rdata_hdr.pcie32.addr[11:2]};
    agent_tx_hdr.mem32.at                = hqm_sfi_at_t'(hdr_rdata_hdr.pcie32.at);
                                      
    agent_tx_hdr.mem32.reqid             = hdr_rdata_hdr.pcie32.rqid;
    agent_tx_hdr.mem32.ep                = hdr_rdata_hdr.pcie32.ep;
    agent_tx_hdr.mem32.rsvd78            = '0;
    agent_tx_hdr.mem32.tag               = {6'd0, hdr_rdata_hdr.pcie32.tag};
                                      
    agent_tx_hdr.mem32.tc2_0             = hdr_rdata_hdr.pcie32.tc;
    agent_tx_hdr.mem32.ts                = hqm_sfi_ts_t'('0);
    agent_tx_hdr.mem32.attr              = {hdr_rdata_hdr.pcie32.attr2, hdr_rdata_hdr.pcie32.attr};
    agent_tx_hdr.mem32.len               = hdr_rdata_hdr.pcie32.len;
                                        
    agent_tx_hdr.mem32.pf0.srcid         = '0;
    agent_tx_hdr.mem32.pf0.sai           = strap_hqm_tx_sai;
    agent_tx_hdr.mem32.pf0.bcm           = '0;
    agent_tx_hdr.mem32.pf0.rs            = '0;
    agent_tx_hdr.mem32.pf0.ee            = '0;
    agent_tx_hdr.mem32.pf0.n             = '0;
    agent_tx_hdr.mem32.pf0.c             = '0;
    agent_tx_hdr.mem32.pf0.prefix_type   = 8'h8e;

    // SFI header parity is ultimately stored in the hdr_info_bytes field and covers all header
    // and hdr_info_bytes bits.  The other hdr_info_bytes bits are:
    //
    //  {has_data, shared_credit (always 0 for us), vc, hdr_size, and fc}
    //
    // We transfer all bits from the internal header format except for the following, so the
    // internal header parity must be adjusted by the following to create the SFI header parity:
    //
    //      Any parity adjust due to including the HPA (CQ writes only)
    //      We replace the internal {fmt[1:0],type[4:0]} with the SFI {type[7:0]}
    //      We do not transfer the oh, td, rsvd5/6 bits
    //      Memory reads are ATS requests and require ohca1 to pass the pasidtlp.  ohca1 also
    //      includes lbe/fbe but they will always be all ones for ATS requests.  So we need
    //      to adjust for the ohc and pasidtlp fields for memory reads.
    //      The lbe/fbe are either all ones for the CQ write cases or 0/f for the interrupt
    //      write cases, so they do not affect the parity.
    //      The hdr_size field needs to be taken into account.
    //      The has_data field will only be set on memory writes.
    //      Need to account for vc and fc.
    //      Need to add in SAI

    agent_tx_hdr_par           = ^{ hdr_rdata_par
                                  , hdr_rdata_padj
                                  , hdr_rdata_hdr.pcie32.fmt
                                  , hdr_rdata_hdr.pcie32.ttype
                                  , hdr_rdata_hdr.pcie32.rsvd3
                                  , hdr_rdata_hdr.pcie32.rsvd2
                                  , hdr_rdata_hdr.pcie32.rsvd0
                                  , hdr_rdata_hdr.pcie32.oh
                                  , hdr_rdata_hdr.pcie32.td
                                  , hdr_rdata_hdr.pcie32.rsvd4  // tc3
                                  , hdr_rdata_hdr.pcie32.rsvd5
                                  , hdr_rdata_hdr.pcie32.rsvd6
                                  ,(hdr_rdata_pasidtlp & {23{~hdr_rdata_pcie_cmd_mrd}})
                                  , agent_tx_hdr.mem32.ttype
                                  , agent_tx_hdr.mem32.ohc
                                  , agent_tx_hdr_size
                                  , agent_tx_hdr_has_data
                                  , ll_read_vc_q
                                  , ll_read_fc_q
                                  , strap_hqm_tx_sai
                                  };
   end // 3DW MRD/MWR

   PCIE_CMD_MRD64,
   PCIE_CMD_MWR64: begin // 4DW MRD/MWR

    // MRD32/64 can only be ATS requests which require OHCA1 to provide the PASID.
    // MWR32/64 can be MSI-X, IMS, or CQ writes.  Interrupts are Ch0 and CQ writes are Ch1.
    // TBD: The CQ writes need to be NP UIOWR commands and need a scoreboard location.

    agent_tx_hdr.mem64.ohc_dw2           = '0;
    agent_tx_hdr.mem64.ohc_dw1           = '0;

    if (hdr_rdata_pcie_cmd_mrd) begin

     agent_tx_hdr.mem64.ohc              = ohc_noe_a;
     agent_tx_hdr.mem64.ohc_dw0.a1.nw    = '0;
     agent_tx_hdr.mem64.ohc_dw0.a1.pv    = hdr_rdata_pasidtlp[22];
     agent_tx_hdr.mem64.ohc_dw0.a1.pmr   = hdr_rdata_pasidtlp[21];
     agent_tx_hdr.mem64.ohc_dw0.a1.er    = hdr_rdata_pasidtlp[20];
     agent_tx_hdr.mem64.ohc_dw0.a1.pasid = hdr_rdata_pasidtlp[19:0];
     agent_tx_hdr.mem64.ohc_dw0.a1.lbe   = '1;
     agent_tx_hdr.mem64.ohc_dw0.a1.fbe   = '1;

     agent_tx_hdr.mem64.ttype            = FLIT_CMD_MRD64;
                                        
     agent_tx_hdr_size                   = 4'd6;
                                        
    end else begin                      
                                        
     agent_tx_hdr.mem64.ohc              = ohc_none;
     agent_tx_hdr.mem64.ohc_dw0          = '0;
                                        
//   agent_tx_hdr.mem64.ttype            = (ll_read_vc_q == 2'd1) ? FLIT_CMD_UIOWR : FLIT_CMD_MWR64;
     agent_tx_hdr.mem64.ttype            = FLIT_CMD_MWR64;
                                        
     agent_tx_hdr_size                   = 4'd5;
                                        
    end                                 
                                        
    agent_tx_hdr_has_data                = (hdr_rdata_pcie_cmd == PCIE_CMD_MWR64);
                                        
    agent_tx_hdr.mem64.address63_32      =  hdr_rdata_addr[63:32];
    agent_tx_hdr.mem64.address31_2       = {hdr_rdata_addr[31:12], hdr_rdata_hdr.pcie64.addr[11:2]};
    agent_tx_hdr.mem64.at                = hqm_sfi_at_t'(hdr_rdata_hdr.pcie64.at);
                                        
    agent_tx_hdr.mem64.reqid             = hdr_rdata_hdr.pcie64.rqid;
    agent_tx_hdr.mem64.ep                = hdr_rdata_hdr.pcie64.ep;
    agent_tx_hdr.mem64.rsvd78            = '0;
    agent_tx_hdr.mem64.tag               = {6'd0, hdr_rdata_hdr.pcie64.tag};
                                        
    agent_tx_hdr.mem64.tc2_0             = hdr_rdata_hdr.pcie64.tc;
    agent_tx_hdr.mem64.ts                = hqm_sfi_ts_t'('0);
    agent_tx_hdr.mem64.attr              = {hdr_rdata_hdr.pcie64.attr2, hdr_rdata_hdr.pcie64.attr};
    agent_tx_hdr.mem64.len               = hdr_rdata_hdr.pcie64.len;

    agent_tx_hdr.mem64.pf0.srcid         = '0;
    agent_tx_hdr.mem64.pf0.sai           = strap_hqm_tx_sai;
    agent_tx_hdr.mem64.pf0.bcm           = '0;
    agent_tx_hdr.mem64.pf0.rs            = '0;
    agent_tx_hdr.mem64.pf0.ee            = '0;
    agent_tx_hdr.mem64.pf0.n             = '0;
    agent_tx_hdr.mem64.pf0.c             = '0;
    agent_tx_hdr.mem64.pf0.prefix_type   = 8'h8e;

    // SFI header parity is ultimately stored in the hdr_info_bytes field and covers all header
    // and hdr_info_bytes bits.  The other hdr_info_bytes bits are:
    //
    //  {has_data, shared_credit (always 0 for us), vc, hdr_size, and fc}
    //
    // We transfer all bits from the internal header format except for the following, so the
    // internal header parity must be adjusted by the following to create the SFI header parity:
    //
    //      Any parity adjust due to including the HPA (CQ writes only)
    //      We replace the internal {fmt[1:0],type[4:0]} with the SFI {type[7:0]}
    //      We do not transfer the oh, td, rsvd5/6 bits
    //      Memory reads are ATS requests and require ohca1 to pass the pasidtlp.  ohca1 also
    //      includes lbe/fbe but they will always be all ones for ATS requests.  So we need
    //      to adjust for the ohc and pasidtlp fields for memory reads.
    //      The lbe/fbe are either all ones for the CQ write cases or 0/f for the interrupt
    //      write cases, so they do not affect the parity.
    //      The hdr_size field will always be 5 or 6, so it doesn't contribute.
    //      The has_data field will only be set on memory writes.
    //      Need to account for vc and fc.
    //      Need to add in SAI

    agent_tx_hdr_par           = ^{ hdr_rdata_par
                                  , hdr_rdata_padj
                                  , hdr_rdata_hdr.pcie64.fmt
                                  , hdr_rdata_hdr.pcie64.ttype
                                  , hdr_rdata_hdr.pcie64.rsvd3
                                  , hdr_rdata_hdr.pcie64.rsvd2
                                  , hdr_rdata_hdr.pcie64.rsvd0
                                  , hdr_rdata_hdr.pcie64.oh
                                  , hdr_rdata_hdr.pcie64.td
                                  , hdr_rdata_hdr.pcie64.rsvd4  // tc3
                                  , hdr_rdata_hdr.pcie64.rsvd5
                                  , hdr_rdata_hdr.pcie64.rsvd6
                                  ,(hdr_rdata_pasidtlp & {23{~hdr_rdata_pcie_cmd_mrd}})
                                  , agent_tx_hdr.mem64.ttype
                                  , agent_tx_hdr.mem64.ohc
                                  , agent_tx_hdr_has_data
                                  , ll_read_vc_q
                                  , ll_read_fc_q
                                  , strap_hqm_tx_sai
                                  };
   end // 4DW MRD/MWR

   PCIE_CMD_CPL,
   PCIE_CMD_CPLD,
   PCIE_CMD_CPLLK: begin // CPLs

    // OHCA5 is needed for the errored completion case or if lowaddr[1:0] != 0

    agent_tx_hdr.cpl.ohc_dw3                = '0;
    agent_tx_hdr.cpl.ohc_dw2                = '0;
    agent_tx_hdr.cpl.ohc_dw1                = '0;

    if (cpl_hdr_requires_ohca5) begin

     agent_tx_hdr.cpl.ohc                   = ohc_noe_a;
     agent_tx_hdr.cpl.ohc_dw0               = '0;

     agent_tx_hdr.cpl.ohc_dw0.a5.la1_0      = hdr_rdata_hdr_cpl.lowaddr[1:0];
     agent_tx_hdr.cpl.ohc_dw0.a5.cpl_status = hqm_sfi_cpl_status_t'(hdr_rdata_hdr_cpl.cplstat);

     agent_tx_hdr_size                      = 4'd5;
                                    
    end else begin                  
                                    
     agent_tx_hdr.cpl.ohc                   = ohc_none;
     agent_tx_hdr.cpl.ohc_dw0               = '0;
                                    
     agent_tx_hdr_size                      = 4'd4;
                                    
    end                             
                                    
    agent_tx_hdr_has_data                   = (hdr_rdata_pcie_cmd == PCIE_CMD_CPLD);
                                    
    agent_tx_hdr.cpl.bdf                    = hdr_rdata_hdr_cpl.rqid;
    agent_tx_hdr.cpl.la5_2                  = hdr_rdata_hdr_cpl.lowaddr[5:2];
    agent_tx_hdr.cpl.bc                     = hdr_rdata_hdr_cpl.bytecnt;
                                    
    agent_tx_hdr.cpl.cplid                  = hdr_rdata_hdr_cpl.cplid;
    agent_tx_hdr.cpl.ep                     = hdr_rdata_hdr_cpl.ep;
    agent_tx_hdr.cpl.la6                    = hdr_rdata_hdr_cpl.lowaddr[6];
    agent_tx_hdr.cpl.tag                    = hdr_rdata_hdr_cpl.tag[13:0];
    agent_tx_hdr.cpl.ttype                  =  (hdr_rdata_pcie_cmd == PCIE_CMD_CPL)    ? FLIT_CMD_CPL   :
                                              ((hdr_rdata_pcie_cmd == PCIE_CMD_CPLD)   ? FLIT_CMD_CPLD  :
                                                                                       FLIT_CMD_CPLLK);
    agent_tx_hdr.cpl.tc2_0                  = hdr_rdata_hdr_cpl.tc[2:0];
    agent_tx_hdr.cpl.ts                     = hqm_sfi_ts_t'('0);
    agent_tx_hdr.cpl.attr                   = {hdr_rdata_hdr_cpl.attr2, hdr_rdata_hdr_cpl.attr};
    agent_tx_hdr.cpl.len                    = hdr_rdata_hdr_cpl.len;
                                           
    agent_tx_hdr.cpl.pf0.srcid              = '0;
    agent_tx_hdr.cpl.pf0.sai                = strap_hqm_cmpl_sai;
    agent_tx_hdr.cpl.pf0.bcm                = '0;
    agent_tx_hdr.cpl.pf0.rs                 = '0;
    agent_tx_hdr.cpl.pf0.ee                 = '0;
    agent_tx_hdr.cpl.pf0.n                  = '0;
    agent_tx_hdr.cpl.pf0.c                  = '0;
    agent_tx_hdr.cpl.pf0.prefix_type        = 8'h8e;

    // SFI header parity is ultimately stored in the hdr_info_bytes field and covers all header
    // and hdr_info_bytes bits.  The other hdr_info_bytes bits are:
    //
    //  {has_data, shared_credit (always 0 for us), vc, hdr_size, and fc}
    //
    // We transfer all bits from the internal header format except for the following, so the
    // internal header parity must be adjusted by the following to create the SFI header parity:
    //
    //      We replace the internal {fmt[1:0],type[4:0]} with the SFI {type[7:0]}
    //      We do not transfer the rsvd127, rsvd106, rsvd31_0, or bcm bits.
    //      If cplstat is nonzero, ohca5 is required to pass cplstat and lowaddr[1:0].  So we
    //      need to adjust for ohc and those 2 fields for errored completions.
    //      The hdr_size field needs to be taken into account.
    //      The has_data field will only be set on CplD.
    //      Need to account for vc and fc.
    //      Need to add in SAI

    agent_tx_hdr_par           = ^{ hdr_rdata_par
                                  , hdr_rdata_hdr_cpl.fmt
                                  , hdr_rdata_hdr_cpl.ttype
                                  , hdr_rdata_hdr_cpl.rsvd127
                                  , hdr_rdata_hdr_cpl.rsvd106
                                  , hdr_rdata_hdr_cpl.rsvd31_0
                                  , hdr_rdata_hdr_cpl.bcm
                                  , hdr_rdata_hdr_cpl.tc[3]
                                  ,(hdr_rdata_hdr_cpl.lowaddr[1:0] & {2{~cpl_hdr_requires_ohca5}})
                                  ,(hdr_rdata_hdr_cpl.cplstat      & {3{~cpl_hdr_requires_ohca5}})
                                  , agent_tx_hdr.cpl.ttype
                                  , agent_tx_hdr.cpl.ohc
                                  , agent_tx_hdr_size
                                  ,(hdr_rdata_pcie_cmd == PCIE_CMD_CPLD)    // has_data
                                  , ll_read_vc_q
                                  , ll_read_fc_q
                                  , strap_hqm_cmpl_sai
                                  };

   end // CPLs

   PCIE_CMD_MSG0,
   PCIE_CMD_MSG1,
   PCIE_CMD_MSG2,
   PCIE_CMD_MSG3,
   PCIE_CMD_MSG4,
   PCIE_CMD_MSG5: begin // MSG (Invalidate Response)

    // OHCA1 is needed for PASID

    agent_tx_hdr.invrsp.ohc_dw0.a1.nw    = '0;
    agent_tx_hdr.invrsp.ohc_dw0.a1.pv    = hdr_rdata_pasidtlp[22];
    agent_tx_hdr.invrsp.ohc_dw0.a1.pmr   = hdr_rdata_pasidtlp[21];
    agent_tx_hdr.invrsp.ohc_dw0.a1.er    = hdr_rdata_pasidtlp[20];
    agent_tx_hdr.invrsp.ohc_dw0.a1.pasid = hdr_rdata_pasidtlp[19:0];
    agent_tx_hdr.invrsp.ohc_dw0.a1.lbe   = '1;
    agent_tx_hdr.invrsp.ohc_dw0.a1.fbe   = '1;

    agent_tx_hdr.invrsp.itag_vec         = hdr_rdata_hdr.pciemsg.rsvd5[63:32];
                                       
    agent_tx_hdr.invrsp.bdf              = hdr_rdata_hdr.pciemsg.rsvd5[31:16];
    agent_tx_hdr.invrsp.rsvd111_99       = '0;
    agent_tx_hdr.invrsp.cc               = hdr_rdata_hdr.pciemsg.rsvd5[2:0];
                                       
    agent_tx_hdr.invrsp.reqid            = hdr_rdata_hdr.pciemsg.rqid;
    agent_tx_hdr.invrsp.rsvd79_72        = '0;
    agent_tx_hdr.invrsp.msg_code         = hdr_rdata_hdr.pciemsg.msgcode;
                                       
    agent_tx_hdr.invrsp.ttype            = {FLIT_CMD_MSG0[7:3], hdr_rdata_hdr.pciemsg.ttype[2:0]};
    agent_tx_hdr.invrsp.tc2_0            = hdr_rdata_hdr.pciemsg.tc;
    agent_tx_hdr.invrsp.ohc              = ohc_noe_a;
    agent_tx_hdr.invrsp.ts               = hqm_sfi_ts_t'('0);
    agent_tx_hdr.invrsp.attr             = {hdr_rdata_hdr.pciemsg.attr2, hdr_rdata_hdr.pciemsg.attr};
    agent_tx_hdr.invrsp.len              = hdr_rdata_hdr.pciemsg.len;
                                        
    agent_tx_hdr.invrsp.pf0.srcid        = '0;
    agent_tx_hdr.invrsp.pf0.sai          = strap_hqm_tx_sai;
    agent_tx_hdr.invrsp.pf0.bcm          = '0;
    agent_tx_hdr.invrsp.pf0.rs           = '0;
    agent_tx_hdr.invrsp.pf0.ee           = '0;
    agent_tx_hdr.invrsp.pf0.n            = '0;
    agent_tx_hdr.invrsp.pf0.c            = '0;
    agent_tx_hdr.invrsp.pf0.prefix_type  = 8'h8e;
                                        
    agent_tx_hdr_size                    = 4'd6;
    agent_tx_hdr_has_data                = '0;

    // SFI header parity is ultimately stored in the hdr_info_bytes field and covers all header
    // and hdr_info_bytes bits.  The other hdr_info_bytes bits are:
    //
    //  {has_data, shared_credit (always 0 for us), vc, hdr_size, and fc}
    //
    // We transfer all bits from the internal header format except for the following, so the
    // internal header parity must adjusted by the following to create the SFI header parity:
    //
    //      We replace the internal {fmt[1:0],type[4:0]} with the SFI {type[7:0]}
    //      We do not transfer the rsvd5[15:3], rsvd3, rsvd2, rsvd0, oh, td, at, ep, or tag fields.
    //      The hdr_size field will always be 6, so it doesn't contribute.
    //      The has_data field will only always be 0.
    //      ohca1 is required to pass the pasidtlp. lbe/fbe will be all ones so do not contribute.
    //      Need to account for vc and fc.
    //      Need to add in SAI

    agent_tx_hdr_par                = ^{ hdr_rdata_par
                                       , hdr_rdata_hdr.pciemsg.fmt
                                       , hdr_rdata_hdr.pciemsg.ttype
                                       , hdr_rdata_hdr.pciemsg.rsvd4    // tc3
                                       , hdr_rdata_hdr.pciemsg.rsvd3
                                       , hdr_rdata_hdr.pciemsg.rsvd2
                                       , hdr_rdata_hdr.pciemsg.rsvd0
                                       , hdr_rdata_hdr.pciemsg.oh
                                       , hdr_rdata_hdr.pciemsg.td
                                       , hdr_rdata_hdr.pciemsg.at
                                       , hdr_rdata_hdr.pciemsg.ep
                                       , hdr_rdata_hdr.pciemsg.tag
                                       , hdr_rdata_hdr.pciemsg.rsvd5[15:3]
                                       , agent_tx_hdr.invrsp.ttype
                                       , agent_tx_hdr.invrsp.ohc
                                       , ll_read_vc_q
                                       , ll_read_fc_q
                                       , strap_hqm_tx_sai
                                       };
   end // MSG

  endcase // PCIE cmd

 end // LL read valid

 agent_tx_hold = agent_tx_v & ~agent_tx_ack;

end

//----------------------------------------------------------------------------------------------------

always_comb begin // Credit Debug

 sif_mstr_debug  = '0;
 mstr_crd_status = '0;

end

//----------------------------------------------------------------------------------------------------
// Set MDPE when we send a poisoned transaction
//TBD: Do we ever set the ep bit?

assign poisoned_wr_sent_next = write_buffer_mstr_v & write_buffer_mstr_ready & 1'b0;

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  poisoned_wr_sent_q <= '0;
 end else begin
  poisoned_wr_sent_q <= poisoned_wr_sent_next;
 end
end

assign poisoned_wr_sent = poisoned_wr_sent_q;

//----------------------------------------------------------------------------------------------------
// Idle and ResetPrep quiesce

always_comb begin

 // Not idle if the scoreboard has outstanding transactions, the FL isn't full, we have something in
 // the output stages (DBs and interface regs), or the devtlb has any pending invalidate requests.

 // Need 2 different IDLE outputs.  One is used for the ISM and needs to track just when we have
 // outstanding interface requests not granted or outstanding NP transactions.  The other needs to
 // be the indication that the entire MSTR is IDLE used for the clock request.

 ti_req_idle  = ~(|{ll_arb_winner_v_next
                   ,ll_arb_winner_v_q
                   ,ll_read_v_q
                   });

 ti_intf_idle = ti_req_idle & ~np_trans_pending;

 ti_idle      = fl_full & ti_intf_idle & ~(invreqs_active & ~devtlb_reset);

end

// ResetPrep Vote Handling Logic - Vote to send a ResetPrepAck when the master is idle.
// A quiesce request will prevent any new P or NP requests by blocking the arbiter inputs.
// Can be considered quiesced from a mastering point of view when any oustanding interface requests
// have been granted and sent out.

assign sif_mstr_quiesce_ack_next = sif_mstr_quiesce_ack_q |         // Remain set until reset
                                   (sif_mstr_quiesce_req_q &        // Only take a vote if quiesce is requested
                                    ti_req_idle);                   // Master has no ungranted interface requests

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  sif_mstr_quiesce_req_q <= '0;
  sif_mstr_quiesce_ack_q <= '0;
 end else begin
  sif_mstr_quiesce_req_q <= sif_mstr_quiesce_req_q | sif_mstr_quiesce_req;
  sif_mstr_quiesce_ack_q <= sif_mstr_quiesce_ack_next;
 end
end

assign sif_mstr_quiesce_ack = sif_mstr_quiesce_ack_q;

//----------------------------------------------------------------------------------------------------
// Convert ATS requests to IOSF NP transactions
//
// Need to be able to limit the maximum number of HP and LP ATS requests outstanding (max is 32).
// Adding counters for the requests that are compared against configurable limits.
// Need an available freelist location and an available scoreboard location to store the ID so it can
// be looked up and returned with the ATS response.  The tag used is the scoreboard location.

always_comb begin

 ats_alloc_data       = '0;

 ats_req_ack          = '0;

 ats_req_cnt_dec      = '0;
 ats_req_cnt_inc      = '0;

 ats_req_cnt_lt_limit = (ats_req_cnt_q < cfg_scrbd_ctl.ATS_LIMIT);

 // Defaults here for the NP header are set up for a 3DW HP ATS request (modify only if LP or 4DW)

 atshdr_v             = '0;
 atshdr               = '0;
 atshdr_pasidtlp      = {
                         ats_req.pasid_valid[1]
                        ,ats_req.pasid_priv[1]
                        ,1'b0
                        ,ats_req.pasid[1]
                        };

 // Note that rsvd4(tc[3]), attr2(ido), rsvd0(rsvd1_1), oh(th), td, ep, attr[0](ns), rsvd5(addr[1:0]) are always 0

 atshdr.pcie32.fmt     = 2'h0;
 atshdr.pcie32.ttype   = 5'h00;
 atshdr.pcie32.tc      = ats_req.tc[1];
 atshdr.pcie32.at      = 2'h1;
 atshdr.pcie32.attr[1] = csr_ppdcntl_ero;           // Set to 1 (if allowed) to prevent deadlock of ATS Cpl stuck behind posted
 atshdr.pcie32.len     = 10'h002;
 atshdr.pcie32.rqid    = {current_bus, 8'd0};
 atshdr.pcie32.rsvd3   = scrbd_tag_10b[9];          // rsvd1_7
 atshdr.pcie32.rsvd2   = scrbd_tag_10b[8];          // rsvd1_3
 atshdr.pcie32.tag     = scrbd_tag_10b[7:0];
 atshdr.pcie32.lbe     = 4'hf;
 atshdr.pcie32.fbe     = 4'hf;
 atshdr.pcie32.rsvd6   = ats_req.nw[1];
 atshdr.pcie32.addr    = {ats_req.address[1][31:12], 10'd0};

 atshdr_par            = ^{atshdr_pasidtlp, atshdr.pcie32};

 // Don't allow an ATS request if an FLR is pending.  We're going to nuke the devtlb anyway.

 if (scrbd_tag_v & ~fl_empty & ~flr_txn_sent_q) begin // Tag and FL available

  if (ats_req_v[1] & ats_req_cnt_lt_limit & ~devtlb_reset) begin // HP ATS Request

   // If HP ATS request is available and the current count is less than the configured limit, form
   // the NP request, push it onto the NP LL, increment the counter, ack the ATS request, and
   // allocate the scoreboard entry.

   atshdr_v              = '1;

   if (|ats_req.address[1][DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:32]) begin // 4DW

    atshdr.pcie64.fmt    = 2'h1;
    atshdr.pcie64.addr   = {
                            {(64-DEVTLB_MAX_LINEAR_ADDRESS_WIDTH){1'b0}}
                           ,ats_req.address[1][DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:12]
                           ,10'd0
                           };
    atshdr_par           = ^{atshdr_pasidtlp, atshdr.pcie64};

   end

   ats_alloc_data        = '0;
   ats_alloc_data.src    = 2'd1;
   ats_alloc_data.id     = {{(HQM_MSTR_NUM_CQS_WIDTH-6){1'b0}}, ats_req.id[1]};
   ats_alloc_data.parity = ~(^ats_req.id[1]);

   if (atshdr_ready) begin

    ats_req_ack[1]       = '1;
    ats_req_cnt_inc      = '1;

   end

  end // HP ATS Request

  else if (ats_req_v[0] & ats_req_cnt_lt_limit & ~devtlb_reset) begin // LP ATS Request

   // If LP ATS request is available and the current count is less than the configured threshold,
   // form the NP request, push it onto the NP LL, increment the counter, ack the ATS request, and
   // allocate the scoreboard entry.

   atshdr_v              = '1;

   atshdr_pasidtlp       = {
                            ats_req.pasid_valid[0]
                           ,ats_req.pasid_priv[0]
                           ,1'b0
                           ,ats_req.pasid[0]
                           };

   atshdr.pcie32.tc      = ats_req.tc[0];
   atshdr.pcie32.rsvd6   = ats_req.nw[0];

   if (|ats_req.address[0][DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:32]) begin // 4DW

    atshdr.pcie64.fmt    = 2'h1;
    atshdr.pcie64.addr   = {
                            {(64-DEVTLB_MAX_LINEAR_ADDRESS_WIDTH){1'b0}}
                           ,ats_req.address[0][DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:12]
                           ,10'd0
                           };
    atshdr_par           = ^{atshdr_pasidtlp, atshdr.pcie64};

   end else begin // 3DW

    atshdr.pcie32.addr   = {ats_req.address[0][31:12], 10'd0};
    atshdr_par           = ^{atshdr_pasidtlp, atshdr.pcie32};

   end

   ats_alloc_data        = '0;
   ats_alloc_data.src    = 2'd1;
   ats_alloc_data.id     = {{(HQM_MSTR_NUM_CQS_WIDTH-6){1'b0}}, ats_req.id[0]};
   ats_alloc_data.parity = ~(^ats_req.id[0]);

   if (atshdr_ready) begin

    ats_req_ack[1]       = '1;
    ats_req_cnt_inc      = '1;

   end

  end // LP ATS Request

 end // Tag and FL available

 if (ats_rsp_v) begin

  // Decrement ATS request counter

  ats_req_cnt_dec        = '1;

 end

 // ATS request counter inc/dec

 case ({ats_req_cnt_inc, ats_req_cnt_dec})
  2'b10:   ats_req_cnt_next = ats_req_cnt_q + 6'd1;
  2'b01:   ats_req_cnt_next = ats_req_cnt_q - 6'd1;
  default: ats_req_cnt_next = ats_req_cnt_q;
 endcase

end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  ats_req_cnt_q <= '0;
 end else begin
  ats_req_cnt_q <= ats_req_cnt_next;
 end
end

//------------------------------------------------------------------------------------------------
// Drain requests
//
// Need to stop sending any new devtlb requests and wait for any ATS enabled transactions to drain.

always_comb begin

 drain_req_ack    = '0;

 drain_rsp_v      = '0;
 drain_rsp        = '0;

 clr_hpa_v        = '0;

 drain_pend_next  = drain_pend_q;
 drain_req_next   = drain_req_q;;

 invrsp_pend_next = invrsp_pend_q;

 if (drain_req_v & ~devtlb_reset) begin // Drain request

  // Acknowledge the drain request, set the drain and invalidate response pending flags

  drain_req_ack    = '1;

  drain_pend_next  = '1;
  drain_req_next   = drain_req;

  invrsp_pend_next = '1;

 end // Drain request

 else if (drain_pend_q) begin // Drain pending

  // Sledge hammer for now: Wait until whole master is empty

  if (fl_full) begin

   // Reset the drain pending flag, send the drain response, and clear the local hpa_v flag

   drain_pend_next  = '0;

   drain_rsp_v      = '1;
   drain_rsp.tc     = '1;

   clr_hpa_v        = '1;

  end

 end // Drain pending

 // If we have reset the drain pending because we're empty and the devtlb has deasserted its
 // invalidate requests active flag, we can reset our invalidate response pending flag to
 // allow us to generate new ATS requests to the devtlb.

 else if (invrsp_pend_q & ~(invreqs_active & ~devtlb_reset)) begin

  invrsp_pend_next = '0;

 end

end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  drain_pend_q  <= '0;
  invrsp_pend_q <= '0;
 end else begin
  drain_pend_q  <= drain_pend_next;
  invrsp_pend_q <= invrsp_pend_next;
 end
end

always_ff @(posedge prim_nonflr_clk) begin
 if (drain_req_v & ~drain_pend_q) begin
  drain_req_q <= drain_req;
 end
end

//------------------------------------------------------------------------------------------------
// Set flr_txn_sent_q when the flr_txn_sent pulse comes in and keep it set until the FLR occurs.
// Save the tag and reqid to compare to identify the completion for the startflr write.
// Set flr_cpl_sent_q when that completion is detected and keep it set until the FLR occurs.
// Use flr_cpl_sent_q to prevent processing any further transactions until after the FLR occurs.

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_wflr_rst_b) begin
 if (~prim_gated_wflr_rst_b) begin
  flr_txn_sent_q   <= '0;
  flr_txn_reqid_q  <= '0;
  flr_txn_tag_q    <= '0;
  flr_cpl_sent_q   <= '0;
  flr_cpl_last_q   <= '0;
 end else begin
  flr_txn_sent_q   <= flr_txn_sent | flr_txn_sent_q;
  if (flr_txn_sent & ~flr_txn_sent_q) begin
   flr_txn_reqid_q <= flr_txn_reqid;
   flr_txn_tag_q   <= flr_txn_tag;
  end
  flr_cpl_sent_q   <= (flr_cpl_sent_q) ? func_in_rst : flr_cpl_sent_next;
  flr_cpl_last_q   <= flr_cpl_sent_q;
 end
end

// This goes to the hqm_master and will send a pulse on a rising edge of flr_cpl_sent

always_comb begin

 flr_triggered = flr_cpl_sent_q & ~flr_cpl_last_q;

end

//------------------------------------------------------------------------------------------------
// Set ps_txn_sent_q when the ps_txn_sent pulse comes in and keep it set until the completion occurs.
// Save the tag and reqid to compare to identify the completion for the ps write.
// Set ps_cpl_sent_q when that completion is detected and keep it set until we are back in D0 power
// state as indicated by a completion header received with the pm field all zeros.
// Use ps_cpl_sent_q to prevent further posted transactions from being processed.
// So it needs to do what?

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_wflr_rst_b) begin
 if (~prim_gated_wflr_rst_b) begin
  ps_txn_sent_q   <= '0;
  ps_txn_reqid_q  <= '0;
  ps_txn_tag_q    <= '0;
  ps_cpl_sent_q   <= '0;
 end else begin
  ps_txn_sent_q   <= (ps_txn_sent |  ps_txn_sent_q) & ~ps_cpl_sent_next;
  if (ps_txn_sent & ~ps_txn_sent_q) begin
   ps_txn_reqid_q <=  ps_txn_reqid;
   ps_txn_tag_q   <=  ps_txn_tag;
  end
  ps_cpl_sent_q  <= (ps_cpl_sent_q | ps_cpl_sent_next) & ~ps_d0;
 end
end

//------------------------------------------------------------------------------------------------
// Parity error reporting

assign parity_error_next = {
                             scrbd_perr
                            ,ibcpl_data_fifo_perr
                            ,ibcpl_hdr_fifo_perr
                            ,(tlb_data_parity_err[2:0] & ~{3{devtlb_reset}})
                            ,(tlb_tag_parity_err[ 2:0] & ~{3{devtlb_reset}})
};

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  parity_error_q      <= '0;
  parity_error_last_q <= '0;
 end else begin
  parity_error_q      <= parity_error_next;
  parity_error_last_q <= parity_error_q;
 end
end

assign sif_parity_alarm   = |(parity_error_q & ~parity_error_last_q);
assign set_sif_parity_err =   parity_error_q & ~parity_error_last_q;

//------------------------------------------------------------------------------------------------
// Dedicated system drop counter for MSI-X dropped due to MSIXE==0 or CQ dropped due to drain.

// Invalid drops are already counted by the write buffer.

assign cnt_inc = (wb_drop_msixe | wb_drop_cq) & ~flr_treatment_vec;    // 1:0 Posted drops

hqm_AW_inc_64b_val i_cnt (

     .clk       (prim_nonflr_clk)
    ,.rst_n     (prim_gated_rst_b)
    ,.clr       (hqm_sif_cnt_ctl.CNT_CLR)
    ,.clrv      (hqm_sif_cnt_ctl.CNT_CLRV)
    ,.inc       (cnt_inc)
    ,.count     ({mstr_cnts[1], mstr_cnts[0]})
);

//------------------------------------------------------------------------------------------------
// Register a trigger indication if the trigger is enabled and the address matches the configured
// address with mask when we write the posted header storage.
// Stretch the trigger for 5 prim_clk cycles in case the trigger clock ends up not being
// being faster than prim_clk.

assign ph_trigger_next = memi_mstr_ll_hdr_q.we & cfg_ph_trigger_enable &
    ((memi_mstr_ll_hdr_q[63:0] & cfg_ph_trigger_mask) == (cfg_ph_trigger_addr & cfg_ph_trigger_mask));

hqm_AW_pulse_stretch #(.PULSE_WIDTH(5)) i_ph_trigger (

     .clk       (prim_nonflr_clk)
    ,.rst_n     (prim_gated_wflr_rst_b)
    ,.din       (ph_trigger_next)

    ,.dout      (ph_trigger)
);

//------------------------------------------------------------------------------------------------

// TBD: Update visa.sig to reflect new set of signals

always_comb begin

 noa_mstr[  7:  0] = {write_buffer_mstr.hdr.invalid
                     ,write_buffer_mstr.hdr.cq_v
                     ,write_buffer_mstr.hdr.cq_ldb
                     ,write_buffer_mstr.hdr.src[1:0]
                     ,write_buffer_mstr_ready
                     ,write_buffer_mstr_v
                     ,1'b1
                     };
 noa_mstr[ 15:  8] = {write_buffer_mstr_v
                     ,phdr.pcie64.fmt
                     ,phdr.pcie64.ttype
                     };
 noa_mstr[ 23: 16] = {poisoned_wr_sent
                     ,(wb_msix | wb_ims)
                     ,write_buffer_mstr.hdr.cq[5:0]
                     };
 noa_mstr[ 31: 24] = {sif_mstr_quiesce_req_q
                     ,sif_mstr_quiesce_ack
                     ,write_buffer_mstr.hdr.tc_sel[1:0]
                     ,phdr_tc[3:0]
                     };
 noa_mstr[ 39: 32] = {write_buffer_mstr.hdr.num_hcws[2:0]
                     ,write_buffer_mstr.hdr.length[4:0]
                     };
 noa_mstr[ 47: 40] = {fl2ll_v
                     ,fl_push
                     ,ll_pop
                     ,2'd0
                     ,1'd0
                     ,2'd0
                     };
 noa_mstr[ 55: 48] =  fl2ll_ll;

 noa_mstr[ 63: 56] =  ll_pop_ll;
 noa_mstr[ 71: 64] =  fl_push_ptr;

 noa_mstr[ 79: 72] = {devtlb_req_v
                     ,devtlb_req.pasid_valid
                     ,devtlb_req.opcode[1:0]
                     ,(devtlb_rsp_v & ~devtlb_reset)
                     ,devtlb_rsp.result
                     ,devtlb_rsp.dperror
                     ,devtlb_rsp.hdrerror
                     };
 noa_mstr[ 87: 80] = {rx_msg_v
                     ,rx_msg.pasid_valid
                     ,rx_msg.opcode
                     ,rx_msg.dperror
                     ,(tx_msg_v & ~devtlb_reset)
                     ,tx_msg_ack
                     ,tx_msg.pasid_valid
                     ,tx_msg.opcode
                     };
 noa_mstr[ 95: 88] = {(ats_req_v[1:0] & ~{2{devtlb_reset}})
                     ,ats_req_ack[1:0]
                     ,ats_req.pasid_valid[1:0]
                     ,imp_invalidation_v
                     ,tlb_reset_active
                     };
 noa_mstr[103: 96] = {ats_rsp_v
                     ,ats_rsp.dperror
                     ,ats_rsp.hdrerror
                     ,ats_rsp.data[55:54]
                     ,(xreqs_active & ~devtlb_reset)
                     ,(invreqs_active & ~devtlb_reset)
                     ,ti_idle
                     };
 noa_mstr[111:104] = {scrbd_alloc
                     ,scrbd_free
                     ,ibcpl_hdr_push
                     ,ibcpl_data_push
                     ,cpl_timeout
                     ,cpl_abort
                     ,cpl_unexpected
                     ,np_trans_pending
                     };
 noa_mstr[119:112] =  parity_error_q[7:0];
 noa_mstr[127:120] = {parity_error_q[8]
                     ,ti_intf_idle
                     ,6'd0
                     };
 noa_mstr[135:128] = {agent_tx_v, agent_tx_hdr.mem32.at, agent_tx_hdr.mem32.len[4:0]};
 noa_mstr[143:136] = {agent_tx_hdr.mem32.ttype};
 noa_mstr[151:144] = {agent_tx_hdr.cpl.bdf[7:0]};
 noa_mstr[159:152] = {agent_tx_hdr.cpl.bdf[15:8]};
 noa_mstr[167:160] = {agent_tx_hdr.mem32.tag[7:0]};
 noa_mstr[175:168] = {agent_tx_hdr.mem32.tc2_0, agent_tx_hdr.mem32.ohc};
 noa_mstr[183:176] = 8'd0;
 noa_mstr[191:184] = 8'd0;

end

//------------------------------------------------------------------------------------------------
// Per CQ non-posted counters to support source ordering

always_comb begin

 for (int i=0; i<HQM_MSTR_NUM_CQS; i=i+1) begin

  case ({cq_np_cnt_inc[i], cq_np_cnt_dec[i]})
   2'b01:   cq_np_cnt_next[i] = cq_np_cnt_q[i] - 9'd1;
   2'b10:   cq_np_cnt_next[i] = cq_np_cnt_q[i] + 9'd1;
   default: cq_np_cnt_next[i] = cq_np_cnt_q[i];
  endcase

 end

end

hqm_AW_unused_bits i_unused_np_cnt (

     .a (|{cq_np_cnt_inc[(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:HQM_MSTR_NUM_CQS]
          ,cq_np_cnt_inc[(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:HQM_MSTR_NUM_CQS]
          }
        )
);

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  for (int i=0; i<HQM_MSTR_NUM_CQS; i=i+1) begin
   cq_np_cnt_q[i] <= '0;
  end
 end else begin
  cq_np_cnt_q <= cq_np_cnt_next;
 end
end

endmodule // hqm_ti

