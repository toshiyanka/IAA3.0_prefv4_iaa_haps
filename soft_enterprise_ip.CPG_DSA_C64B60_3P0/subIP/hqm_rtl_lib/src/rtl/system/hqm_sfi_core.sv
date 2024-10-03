//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2022 Intel Corporation All Rights Reserved.
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
//-----------------------------------------------------------------------------------------------------

module hqm_sfi_core

     import hqm_sfi_pkg::*, hqm_system_pkg::*, hqm_sif_csr_pkg::*, hqm_sif_pkg::*, hqm_system_type_pkg::*;
#(
    parameter BRIDGE = 0,
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

//`include "hqm_sfi_params.sv"

) (
     input  logic                                           pgcb_clk

    ,input  logic                                           pma_safemode
    ,input  logic                                           prim_pwrgate_pmc_wake

    ,input  logic                                           prim_freerun_clk
    ,input  logic                                           prim_nonflr_clk

    ,input  logic                                           prim_rst_b
    ,input  logic                                           side_rst_b

    ,output logic                                           prim_gated_rst_b
    ,output logic                                           side_gated_rst_prim_b

    ,output logic                                           prim_clkreq
    ,input  logic                                           prim_clkack

    ,input  logic                                           prim_clkreq_sync
    ,input  logic [1:0]                                     prim_clkreq_async
    ,output logic [1:0]                                     prim_clkack_async

    ,input  logic                                           flr_clk_enable
    ,input  logic                                           flr_clk_enable_system

    ,output logic                                           prim_clk_enable
    ,output logic                                           prim_clk_enable_cdc
    ,output logic                                           prim_clk_enable_sys
    ,output logic                                           prim_clk_ungate

    ,input  logic                                           force_ip_inaccessible
    ,input  logic                                           force_pm_state_d3hot
    ,input  logic                                           force_warm_reset
    ,input  logic                                           pm_fsm_d3tod0_ok

    //-------------------------------------------------------------------------------------------------
    // Config

    ,input  hqm_sif_csr_pkg::PARITY_CTL_t                   cfg_parity_ctl
    ,input  PRIM_CDC_CTL_t                                  cfg_prim_cdc_ctl
    ,input  SIF_CTL_t                                       cfg_sif_ctl
    ,input  SIF_VC_RXMAP_t                                  cfg_sif_vc_rxmap
    ,input  SIF_VC_TXMAP_t                                  cfg_sif_vc_txmap

    ,input  hqm_sif_fuses_t                                 sb_ep_fuses

    //-------------------------------------------------------------------------------------------------
    // Status

    ,output logic                                           sfi_rx_idle
    ,output logic                                           sfi_tx_idle

    //-------------------------------------------------------------------------------------------------
    // SFI TX Global

    ,output logic                                           sfi_tx_txcon_req            // Connection request

    ,input  logic                                           sfi_tx_rxcon_ack            // Connection acknowledge
    ,input  logic                                           sfi_tx_rxdiscon_nack        // Disconnect rejection
    ,input  logic                                           sfi_tx_rx_empty             // Reciever queues are empty and all credits returned

    // SFI TX Request

    ,output logic                                           sfi_tx_hdr_valid            // Header is valid
    ,output logic                                           sfi_tx_hdr_early_valid      // Header early valid indication
    ,output hqm_sfi_hdr_info_t                              sfi_tx_hdr_info_bytes       // Header info
    ,output logic [(HQM_SFI_TX_H*8 )-1:0]                   sfi_tx_header               // Header

    ,input  logic                                           sfi_tx_hdr_block            // RX requires TX to pause hdr

    ,input  logic                                           sfi_tx_hdr_crd_rtn_valid    // RX returning hdr credit
    ,input  logic [4:0]                                     sfi_tx_hdr_crd_rtn_vc_id    // Credit virtual channel
    ,input  hqm_sfi_fc_id_t                                 sfi_tx_hdr_crd_rtn_fc_id    // Credit flow class
    ,input  logic [HQM_SFI_TX_NHCRD-1:0]                    sfi_tx_hdr_crd_rtn_value    // Number of hdr credits returned per cycle

    ,output logic                                           sfi_tx_hdr_crd_rtn_block    // TX requires RX to pause hdr credit returns

    // SFI TX Data

    ,output logic                                           sfi_tx_data_valid           // Data is valid
    ,output logic                                           sfi_tx_data_early_valid     // Data early valid indication
    ,output logic                                           sfi_tx_data_aux_parity      // Data auxilliary parity
    ,output logic [(HQM_SFI_TX_D/8)-1:0]                    sfi_tx_data_parity          // Data parity per 8B
    ,output logic [(HQM_SFI_TX_D/4)-1:0]                    sfi_tx_data_poison          // Data poisoned per DW
    ,output logic [(HQM_SFI_TX_D/4)-1:0]                    sfi_tx_data_edb             // Data bad per DW
    ,output logic                                           sfi_tx_data_start           // Start of data
    ,output logic [(HQM_SFI_TX_D/4)-1:0]                    sfi_tx_data_end             // End   of data
    ,output hqm_sfi_data_info_t                             sfi_tx_data_info_byte       // Data info
    ,output logic [(HQM_SFI_TX_D*8)-1:0]                    sfi_tx_data                 // Data payload

    ,input  logic                                           sfi_tx_data_block           // RX requires TX to pause data

    ,input  logic                                           sfi_tx_data_crd_rtn_valid   // RX returning data credit
    ,input  logic [4:0]                                     sfi_tx_data_crd_rtn_vc_id   // Credit virtual channel
    ,input  hqm_sfi_fc_id_t                                 sfi_tx_data_crd_rtn_fc_id   // Credit flow class
    ,input  logic [HQM_SFI_TX_NDCRD-1:0]                    sfi_tx_data_crd_rtn_value   // Number of data credits returned per cycle

    ,output logic                                           sfi_tx_data_crd_rtn_block   // TX requires RX to pause data credit returns

    //---------------------------------------------------------------------------------------------
    // SFI RX Global

    ,input  logic                                           sfi_rx_txcon_req            // Connection request

    ,output logic                                           sfi_rx_rxcon_ack            // Connection acknowledge
    ,output logic                                           sfi_rx_rxdiscon_nack        // Disconnect rejection
    ,output logic                                           sfi_rx_rx_empty             // Reciever queues are empty and all credits returned

    // SFI RX Request

    ,input  logic                                           sfi_rx_hdr_valid            // Header is valid
    ,input  logic                                           sfi_rx_hdr_early_valid      // Header early valid indication
    ,input  hqm_sfi_hdr_info_t                              sfi_rx_hdr_info_bytes       // Header info
    ,input  logic [(HQM_SFI_RX_H*8 )-1:0]                   sfi_rx_header               // Header

    ,output logic                                           sfi_rx_hdr_block            // RX requires TX to pause hdr

    ,output logic                                           sfi_rx_hdr_crd_rtn_valid    // RX returning hdr credit
    ,output logic [4:0]                                     sfi_rx_hdr_crd_rtn_vc_id    // Credit virtual channel
    ,output hqm_sfi_fc_id_t                                 sfi_rx_hdr_crd_rtn_fc_id    // Credit flow class
    ,output logic [HQM_SFI_RX_NHCRD-1:0]                    sfi_rx_hdr_crd_rtn_value    // Number of hdr credits returned per cycle

    ,input  logic                                           sfi_rx_hdr_crd_rtn_block    // TX requires RX to pause hdr credit returns

    // SFI RX Data

    ,input  logic                                           sfi_rx_data_valid           // Data is valid
    ,input  logic                                           sfi_rx_data_early_valid     // Data early valid indication
    ,input  logic                                           sfi_rx_data_aux_parity      // Data auxilliary parity
    ,input  logic [(HQM_SFI_RX_D/8)-1:0]                    sfi_rx_data_parity          // Data parity per 8B
    ,input  logic [(HQM_SFI_RX_D/4)-1:0]                    sfi_rx_data_poison          // Data poisoned per DW
    ,input  logic [(HQM_SFI_RX_D/4)-1:0]                    sfi_rx_data_edb             // Data bad per DW
    ,input  logic                                           sfi_rx_data_start           // Start of data
    ,input  logic [(HQM_SFI_RX_D/4)-1:0]                    sfi_rx_data_end             // End   of data
    ,input  hqm_sfi_data_info_t                             sfi_rx_data_info_byte       // Data info
    ,input  logic [(HQM_SFI_RX_D*8)-1:0]                    sfi_rx_data                 // Data payload

    ,output logic                                           sfi_rx_data_block           // RX requires TX to pause data

    ,output logic                                           sfi_rx_data_crd_rtn_valid   // RX returning data credit
    ,output logic [4:0]                                     sfi_rx_data_crd_rtn_vc_id   // Credit virtual channel
    ,output hqm_sfi_fc_id_t                                 sfi_rx_data_crd_rtn_fc_id   // Credit flow class
    ,output logic [HQM_SFI_RX_NDCRD-1:0]                    sfi_rx_data_crd_rtn_value   // Number of data credits returned per cycle

    ,input  logic                                           sfi_rx_data_crd_rtn_block   // TX requires RX to pause data credit returns

    //-------------------------------------------------------------------------------------------------
    // Agent TX Interface

    ,input  logic                                           agent_tx_v                  // Agent master transaction
    ,input  logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             agent_tx_vc
    ,input  hqm_sfi_fc_id_t                                 agent_tx_fc
    ,input  logic [3:0]                                     agent_tx_hdr_size
    ,input  logic                                           agent_tx_hdr_has_data
    ,input  hqm_sfi_flit_header_t                           agent_tx_hdr
    ,input  logic                                           agent_tx_hdr_par
    ,input  logic [(HQM_SFI_TX_D*16)-1:0]                   agent_tx_data
    ,input  logic [(HQM_SFI_TX_D/4)-1:0]                    agent_tx_data_par

    ,output logic                                           agent_tx_ack

    //-------------------------------------------------------------------------------------------------
    // Agent TX credit interface

    ,output logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_hcrds_avail  // Available TX hdr  credits
    ,output logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_dcrds_avail  // Available TX data credits

    ,input  logic                                           tx_hcrd_consume_v           // Consuming TX hdr  credits
    ,input  logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             tx_hcrd_consume_vc
    ,input  hqm_sfi_fc_id_t                                 tx_hcrd_consume_fc
    ,input  logic                                           tx_hcrd_consume_val

    ,input  logic                                           tx_dcrd_consume_v           // Consuming TX data credits
    ,input  logic [HQM_SFI_TX_DATA_VC_WIDTH-1:0]            tx_dcrd_consume_vc
    ,input  hqm_sfi_fc_id_t                                 tx_dcrd_consume_fc
    ,input  logic [2:0]                                     tx_dcrd_consume_val

    //-------------------------------------------------------------------------------------------------
    // Link Layer interface

    ,output logic                                           lli_phdr_val
    ,output tdl_phdr_t                                      lli_phdr

    ,output logic                                           lli_nphdr_val
    ,output tdl_nphdr_t                                     lli_nphdr

    ,output logic                                           lli_pdata_push
    ,output logic                                           lli_npdata_push
    ,output ri_bus_width_t                                  lli_pkt_data
    ,output ri_bus_par_t                                    lli_pkt_data_par

    //-------------------------------------------------------------------------------------------------
    // Inbound completions

    ,output logic                                           ibcpl_hdr_push
    ,output tdl_cplhdr_t                                    ibcpl_hdr

    ,output logic                                           ibcpl_data_push
    ,output logic [HQM_IBCPL_DATA_WIDTH-1:0]                ibcpl_data
    ,output logic [HQM_IBCPL_PARITY_WIDTH-1:0]              ibcpl_data_par

    //-------------------------------------------------------------------------------------------------
    // RI credit returns

    ,input  hqm_iosf_tgt_crd_t                              ri_tgt_crd_inc

    ,input  logic                                           agent_rxqs_empty

    //-------------------------------------------------------------------------------------------------
    // Errors

    ,output logic                                           iosf_ep_cpar_err
    ,output errhdr_t                                        iosf_ep_chdr_w_err

    //-------------------------------------------------------------------------------------------------
    // DFX

    ,input  logic                                           fscan_byprst_b
    ,input  logic                                           fscan_clkungate
    ,input  logic                                           fscan_rstbypen

    ,input  logic                                           prim_jta_force_clkreq
    ,input  logic                                           prim_jta_force_creditreq
    ,input  logic                                           prim_jta_force_idle
    ,input  logic                                           prim_jta_force_notidle

    ,input  logic                                           cdc_prim_jta_force_clkreq   // Force assert clkreq
    ,input  logic                                           cdc_prim_jta_clkgate_ovrd   // Force ungate gclock
);

//-----------------------------------------------------------------------------------------------------

localparam DEF_PWRON    = 0;

//-----------------------------------------------------------------------------------------------------

logic                                           agent_rx_hdr_v;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             agent_rx_hdr_vc;
hqm_sfi_fc_id_t                                 agent_rx_hdr_fc;
logic [3:0]                                     agent_rx_hdr_size;
logic                                           agent_rx_hdr_has_data;
hqm_sfi_flit_header_t                           agent_rx_hdr;
logic                                           agent_rx_hdr_par;

logic                                           agent_rx_data_v;
logic [HQM_SFI_RX_DATA_VC_WIDTH-1:0]            agent_rx_data_vc;
hqm_sfi_fc_id_t                                 agent_rx_data_fc;
logic [(HQM_SFI_RX_D*8)-1:0]                    agent_rx_data;
logic [(HQM_SFI_RX_D/8)-1:0]                    agent_rx_data_par;

logic                                           rx_hcrd_return_v;       // Agent returning RX hdr  credits
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             rx_hcrd_return_vc;
hqm_sfi_fc_id_t                                 rx_hcrd_return_fc;
logic [HQM_SFI_RX_NHCRD-1:0]                    rx_hcrd_return_val;

logic                                           rx_dcrd_return_v;       // Agent returning RX data credits
logic [HQM_SFI_RX_DATA_VC_WIDTH-1:0]            rx_dcrd_return_vc;
hqm_sfi_fc_id_t                                 rx_dcrd_return_fc;
logic [HQM_SFI_RX_NDCRD-1:0]                    rx_dcrd_return_val;

logic                                           prim_rst_aon_b;
logic                                           prim_pwrgate_ready;

logic                                           force_pwr_gate_pok_next;
logic                                           force_pwr_gate_pok_q;
logic                                           force_pwr_gate_pok_clr;
logic                                           force_pwr_gate_pok_sync;
logic                                           force_pwr_gate_pok_sync_q;
logic                                           force_pwr_gate_pok_sync_edge;

logic                                           allow_force_pwrgate_next;
logic                                           allow_force_pwrgate_q;

logic                                           prim_pgcb_pok;
logic                                           prim_pwrgate_force;
logic                                           prim_pwrgate_force_in;
logic                                           prim_pgcb_pwrgate_active;
logic                                           prim_pwrgate_pmc_wake_sync;
logic                                           prim_allow_force_pwrgate_sync;

logic                                           pma_safemode_sync;

logic                                           side_rst_sync_prim_b_nc;
logic                                           prim_boundary_locked_nc;
logic                                           prim_clk_active_nc;
logic                                           prim_gclock_nc;
logic                                           prim_ism_locked_nc;
logic                                           prim_pok_nc;
logic                                           prim_rst_sync_b_nc;
logic [23:0]                                    cdc_visa_nc;

//-----------------------------------------------------------------------------------------------------

hqm_sfi #(

     .BRIDGE(0),

`include "hqm_sfi_params_inst.sv"

) i_hqm_sfi (

     .clk                                   (prim_freerun_clk)                  //I: SFI:
    ,.clk_gated                             (prim_nonflr_clk)                   //I: SFI:
    ,.rst_b                                 (prim_gated_rst_b)                  //I: SFI:

    ,.cfg_sfi_con_dly                       (cfg_sif_ctl.SIF_CON_DLY)           //I: SFI:
    ,.cfg_idle_dly                          (cfg_sif_ctl.IDLE_DLY)              //I: SFI:
    ,.cfg_sif_vc_rxmap                      (cfg_sif_vc_rxmap)                  //I: SFI:
    ,.cfg_sif_vc_txmap                      (cfg_sif_vc_txmap)                  //I: SFI:

    ,.sfi_rx_idle                           (sfi_rx_idle)                       //O: SFI:
    ,.sfi_tx_idle                           (sfi_tx_idle)                       //O: SFI:

    ,.sfi_tx_txcon_req                      (sfi_tx_txcon_req)                  //O: SFI:

    ,.sfi_tx_rxcon_ack                      (sfi_tx_rxcon_ack)                  //I: SFI:
    ,.sfi_tx_rxdiscon_nack                  (sfi_tx_rxdiscon_nack)              //I: SFI:
    ,.sfi_tx_rx_empty                       (sfi_tx_rx_empty)                   //I: SFI:

    ,.sfi_tx_hdr_valid                      (sfi_tx_hdr_valid)                  //O: SFI:
    ,.sfi_tx_hdr_early_valid                (sfi_tx_hdr_early_valid)            //O: SFI:
    ,.sfi_tx_hdr_info_bytes                 (sfi_tx_hdr_info_bytes)             //O: SFI:
    ,.sfi_tx_header                         (sfi_tx_header)                     //O: SFI:

    ,.sfi_tx_hdr_block                      (sfi_tx_hdr_block)                  //I: SFI:

    ,.sfi_tx_hdr_crd_rtn_valid              (sfi_tx_hdr_crd_rtn_valid)          //I: SFI:
    ,.sfi_tx_hdr_crd_rtn_vc_id              (sfi_tx_hdr_crd_rtn_vc_id)          //I: SFI:
    ,.sfi_tx_hdr_crd_rtn_fc_id              (sfi_tx_hdr_crd_rtn_fc_id)          //I: SFI:
    ,.sfi_tx_hdr_crd_rtn_value              (sfi_tx_hdr_crd_rtn_value)          //I: SFI:

    ,.sfi_tx_hdr_crd_rtn_block              (sfi_tx_hdr_crd_rtn_block)          //O: SFI:

    ,.sfi_tx_data_valid                     (sfi_tx_data_valid)                 //O: SFI:
    ,.sfi_tx_data_early_valid               (sfi_tx_data_early_valid)           //O: SFI:
    ,.sfi_tx_data_aux_parity                (sfi_tx_data_aux_parity)            //O: SFI:
    ,.sfi_tx_data_poison                    (sfi_tx_data_poison)                //O: SFI:
    ,.sfi_tx_data_edb                       (sfi_tx_data_edb)                   //O: SFI:
    ,.sfi_tx_data_start                     (sfi_tx_data_start)                 //O: SFI:
    ,.sfi_tx_data_end                       (sfi_tx_data_end)                   //O: SFI:
    ,.sfi_tx_data_parity                    (sfi_tx_data_parity)                //O: SFI:
    ,.sfi_tx_data_info_byte                 (sfi_tx_data_info_byte)             //O: SFI:
    ,.sfi_tx_data                           (sfi_tx_data)                       //O: SFI:

    ,.sfi_tx_data_block                     (sfi_tx_data_block)                 //I: SFI:

    ,.sfi_tx_data_crd_rtn_valid             (sfi_tx_data_crd_rtn_valid)         //I: SFI:
    ,.sfi_tx_data_crd_rtn_vc_id             (sfi_tx_data_crd_rtn_vc_id)         //I: SFI:
    ,.sfi_tx_data_crd_rtn_fc_id             (sfi_tx_data_crd_rtn_fc_id)         //I: SFI:
    ,.sfi_tx_data_crd_rtn_value             (sfi_tx_data_crd_rtn_value)         //I: SFI:

    ,.sfi_tx_data_crd_rtn_block             (sfi_tx_data_crd_rtn_block)         //O: SFI:

    ,.sfi_rx_txcon_req                      (sfi_rx_txcon_req)                  //I: SFI:

    ,.sfi_rx_rxcon_ack                      (sfi_rx_rxcon_ack)                  //O: SFI:
    ,.sfi_rx_rxdiscon_nack                  (sfi_rx_rxdiscon_nack)              //O: SFI:
    ,.sfi_rx_rx_empty                       (sfi_rx_rx_empty)                   //O: SFI:

    ,.sfi_rx_hdr_valid                      (sfi_rx_hdr_valid)                  //I: SFI:
    ,.sfi_rx_hdr_early_valid                (sfi_rx_hdr_early_valid)            //I: SFI:
    ,.sfi_rx_hdr_info_bytes                 (sfi_rx_hdr_info_bytes)             //I: SFI:
    ,.sfi_rx_header                         (sfi_rx_header)                     //I: SFI:

    ,.sfi_rx_hdr_block                      (sfi_rx_hdr_block)                  //O: SFI:

    ,.sfi_rx_hdr_crd_rtn_valid              (sfi_rx_hdr_crd_rtn_valid)          //O: SFI:
    ,.sfi_rx_hdr_crd_rtn_vc_id              (sfi_rx_hdr_crd_rtn_vc_id)          //O: SFI:
    ,.sfi_rx_hdr_crd_rtn_fc_id              (sfi_rx_hdr_crd_rtn_fc_id)          //O: SFI:
    ,.sfi_rx_hdr_crd_rtn_value              (sfi_rx_hdr_crd_rtn_value)          //O: SFI:

    ,.sfi_rx_hdr_crd_rtn_block              (sfi_rx_hdr_crd_rtn_block)          //I: SFI:

    ,.sfi_rx_data_valid                     (sfi_rx_data_valid)                 //I: SFI:
    ,.sfi_rx_data_early_valid               (sfi_rx_data_early_valid)           //I: SFI:
    ,.sfi_rx_data_aux_parity                (sfi_rx_data_aux_parity)            //I: SFI:
    ,.sfi_rx_data_poison                    (sfi_rx_data_poison)                //I: SFI:
    ,.sfi_rx_data_edb                       (sfi_rx_data_edb)                   //I: SFI:
    ,.sfi_rx_data_start                     (sfi_rx_data_start)                 //I: SFI:
    ,.sfi_rx_data_end                       (sfi_rx_data_end)                   //I: SFI:
    ,.sfi_rx_data_parity                    (sfi_rx_data_parity)                //I: SFI:
    ,.sfi_rx_data_info_byte                 (sfi_rx_data_info_byte)             //I: SFI:
    ,.sfi_rx_data                           (sfi_rx_data)                       //I: SFI:

    ,.sfi_rx_data_block                     (sfi_rx_data_block)                 //O: SFI:

    ,.sfi_rx_data_crd_rtn_valid             (sfi_rx_data_crd_rtn_valid)         //O: SFI:
    ,.sfi_rx_data_crd_rtn_vc_id             (sfi_rx_data_crd_rtn_vc_id)         //O: SFI:
    ,.sfi_rx_data_crd_rtn_fc_id             (sfi_rx_data_crd_rtn_fc_id)         //O: SFI:
    ,.sfi_rx_data_crd_rtn_value             (sfi_rx_data_crd_rtn_value)         //O: SFI:

    ,.sfi_rx_data_crd_rtn_block             (sfi_rx_data_crd_rtn_block)         //I: SFI:

    ,.agent_tx_v                            (agent_tx_v)                        //I: SFI:
    ,.agent_tx_vc                           (agent_tx_vc)                       //I: SFI:
    ,.agent_tx_fc                           (agent_tx_fc)                       //I: SFI:
    ,.agent_tx_hdr_size                     (agent_tx_hdr_size)                 //I: SFI:
    ,.agent_tx_hdr_has_data                 (agent_tx_hdr_has_data)             //I: SFI:
    ,.agent_tx_hdr                          (agent_tx_hdr)                      //I: SFI:
    ,.agent_tx_hdr_par                      (agent_tx_hdr_par)                  //I: SFI:
    ,.agent_tx_data                         (agent_tx_data)                     //I: SFI:
    ,.agent_tx_data_par                     (agent_tx_data_par)                 //I: SFI:

    ,.agent_tx_ack                          (agent_tx_ack)                      //O: SFI:

    ,.tx_hcrds_avail                        (tx_hcrds_avail)                    //O: SFI:
    ,.tx_dcrds_avail                        (tx_dcrds_avail)                    //O: SFI:

    ,.tx_hcrd_consume_v                     (tx_hcrd_consume_v)                 //I: SFI:
    ,.tx_hcrd_consume_vc                    (tx_hcrd_consume_vc)                //I: SFI:
    ,.tx_hcrd_consume_fc                    (tx_hcrd_consume_fc)                //I: SFI:
    ,.tx_hcrd_consume_val                   (tx_hcrd_consume_val)               //I: SFI:

    ,.tx_dcrd_consume_v                     (tx_dcrd_consume_v)                 //I: SFI:
    ,.tx_dcrd_consume_vc                    (tx_dcrd_consume_vc)                //I: SFI:
    ,.tx_dcrd_consume_fc                    (tx_dcrd_consume_fc)                //I: SFI:
    ,.tx_dcrd_consume_val                   (tx_dcrd_consume_val)               //I: SFI:

    ,.agent_rxqs_empty                      (agent_rxqs_empty)                  //I: SFI:

    ,.agent_rx_hdr_v                        (agent_rx_hdr_v)                    //O: SFI:
    ,.agent_rx_hdr_vc                       (agent_rx_hdr_vc)                   //O: SFI:
    ,.agent_rx_hdr_fc                       (agent_rx_hdr_fc)                   //O: SFI:
    ,.agent_rx_hdr_size                     (agent_rx_hdr_size)                 //O: SFI:
    ,.agent_rx_hdr_has_data                 (agent_rx_hdr_has_data)             //O: SFI:
    ,.agent_rx_hdr                          (agent_rx_hdr)                      //O: SFI:
    ,.agent_rx_hdr_par                      (agent_rx_hdr_par)                  //O: SFI:

    ,.agent_rx_data_v                       (agent_rx_data_v)                   //O: SFI:
    ,.agent_rx_data_vc                      (agent_rx_data_vc)                  //O: SFI:
    ,.agent_rx_data_fc                      (agent_rx_data_fc)                  //O: SFI:
    ,.agent_rx_data                         (agent_rx_data)                     //O: SFI:
    ,.agent_rx_data_par                     (agent_rx_data_par)                 //O: SFI:

    ,.rx_hcrd_return_v                      (rx_hcrd_return_v)                  //I: SFI:
    ,.rx_hcrd_return_vc                     (rx_hcrd_return_vc)                 //I: SFI:
    ,.rx_hcrd_return_fc                     (rx_hcrd_return_fc)                 //I: SFI:
    ,.rx_hcrd_return_val                    (rx_hcrd_return_val)                //I: SFI:

    ,.rx_dcrd_return_v                      (rx_dcrd_return_v)                  //I: SFI:
    ,.rx_dcrd_return_vc                     (rx_dcrd_return_vc)                 //I: SFI:
    ,.rx_dcrd_return_fc                     (rx_dcrd_return_fc)                 //I: SFI:
    ,.rx_dcrd_return_val                    (rx_dcrd_return_val)                //I: SFI:
);

hqm_sfi_rx_xlate #(

`include "hqm_sfi_params_inst.sv"

) i_hqm_sfi_rx_xlate (

     .prim_nonflr_clk                       (prim_nonflr_clk)                   //I: SFI_RX_XLATE:
    ,.prim_gated_rst_b                      (prim_gated_rst_b)                  //I: SFI_RX_XLATE:

    ,.cfg_sifp_par_off                      (cfg_parity_ctl.SIFP_PAR_OFF)       //I: SFI_RX_XLATE:

    ,.fuse_proc_disable                     (sb_ep_fuses.proc_disable)          //I: SFI_RX_XLATE:

    ,.agent_rx_hdr_v                        (agent_rx_hdr_v)                    //I: SFI_RX_XLATE:
    ,.agent_rx_hdr_vc                       (agent_rx_hdr_vc)                   //I: SFI_RX_XLATE:
    ,.agent_rx_hdr_fc                       (agent_rx_hdr_fc)                   //I: SFI_RX_XLATE:
    ,.agent_rx_hdr_size                     (agent_rx_hdr_size)                 //I: SFI_RX_XLATE:
    ,.agent_rx_hdr_has_data                 (agent_rx_hdr_has_data)             //I: SFI_RX_XLATE:
    ,.agent_rx_hdr                          (agent_rx_hdr)                      //I: SFI_RX_XLATE:
    ,.agent_rx_hdr_par                      (agent_rx_hdr_par)                  //I: SFI_RX_XLATE:

    ,.agent_rx_data_v                       (agent_rx_data_v)                   //I: SFI_RX_XLATE:
    ,.agent_rx_data_vc                      (agent_rx_data_vc)                  //I: SFI_RX_XLATE:
    ,.agent_rx_data_fc                      (agent_rx_data_fc)                  //I: SFI_RX_XLATE:
    ,.agent_rx_data                         (agent_rx_data)                     //I: SFI_RX_XLATE:
    ,.agent_rx_data_par                     (agent_rx_data_par)                 //I: SFI_RX_XLATE:

    ,.lli_phdr_val                          (lli_phdr_val)                      //O: SFI_RX_XLATE:
    ,.lli_phdr                              (lli_phdr)                          //O: SFI_RX_XLATE:

    ,.lli_nphdr_val                         (lli_nphdr_val)                     //O: SFI_RX_XLATE:
    ,.lli_nphdr                             (lli_nphdr)                         //O: SFI_RX_XLATE:

    ,.lli_pdata_push                        (lli_pdata_push)                    //O: SFI_RX_XLATE:
    ,.lli_npdata_push                       (lli_npdata_push)                   //O: SFI_RX_XLATE:
    ,.lli_pkt_data                          (lli_pkt_data)                      //O: SFI_RX_XLATE:
    ,.lli_pkt_data_par                      (lli_pkt_data_par)                  //O: SFI_RX_XLATE:

    ,.ibcpl_hdr_push                        (ibcpl_hdr_push)                    //O: SFI_RX_XLATE:
    ,.ibcpl_hdr                             (ibcpl_hdr)                         //O: SFI_RX_XLATE:

    ,.ibcpl_data_push                       (ibcpl_data_push)                   //O: SFI_RX_XLATE:
    ,.ibcpl_data                            (ibcpl_data)                        //O: SFI_RX_XLATE:
    ,.ibcpl_data_par                        (ibcpl_data_par)                    //O: SFI_RX_XLATE:

    ,.ri_tgt_crd_inc                        (ri_tgt_crd_inc)                    //I: SFI_RX_XLATE:

    ,.rx_hcrd_return_v                      (rx_hcrd_return_v)                  //O: SFI_RX_XLATE:
    ,.rx_hcrd_return_vc                     (rx_hcrd_return_vc)                 //O: SFI_RX_XLATE:
    ,.rx_hcrd_return_fc                     (rx_hcrd_return_fc)                 //O: SFI_RX_XLATE:
    ,.rx_hcrd_return_val                    (rx_hcrd_return_val)                //O: SFI_RX_XLATE:

    ,.rx_dcrd_return_v                      (rx_dcrd_return_v)                  //O: SFI_RX_XLATE:
    ,.rx_dcrd_return_vc                     (rx_dcrd_return_vc)                 //O: SFI_RX_XLATE:
    ,.rx_dcrd_return_fc                     (rx_dcrd_return_fc)                 //O: SFI_RX_XLATE:
    ,.rx_dcrd_return_val                    (rx_dcrd_return_val)                //O: SFI_RX_XLATE:

    ,.iosf_ep_cpar_err                      (iosf_ep_cpar_err)                  //O: SFI_RX_XLATE:
    ,.iosf_ep_chdr_w_err                    (iosf_ep_chdr_w_err)                //O: SFI_RX_XLATE:
);

//-----------------------------------------------------------------------------------------------------
// The force_pwr_gate_pok_q must set when either of the force_ip_inaccessible or force_warm_reset
// inputs are asserted.  It must remain set until it can be captured by the sync in the pgcb_clk domain,
// so we hold it once it sets and sync the pgcb_clk domain synced version back into the prim_clk domain
// and use that as the clear.

hqm_AW_reset_sync_scan i_prim_rst_aon_b (

     .clk               (pgcb_clk)
    ,.rst_n             (prim_rst_b)
    ,.fscan_rstbypen    (fscan_rstbypen)
    ,.fscan_byprst_b    (fscan_byprst_b)
    ,.rst_n_sync        (prim_rst_aon_b)
);

assign force_pwr_gate_pok_next = (force_ip_inaccessible | force_warm_reset | force_pwr_gate_pok_q) &
                                    ~force_pwr_gate_pok_clr;

assign allow_force_pwrgate_next = force_pm_state_d3hot & pm_fsm_d3tod0_ok;

always_ff @(posedge prim_freerun_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  force_pwr_gate_pok_q  <= '0;
  allow_force_pwrgate_q <= '0;
 end else begin
  force_pwr_gate_pok_q  <= force_pwr_gate_pok_next;
  allow_force_pwrgate_q <= allow_force_pwrgate_next;
 end
end

hqm_AW_sync_rst0 #(.WIDTH(1)) i_force_pwr_gate_pok_sync (

     .clk           (pgcb_clk)
    ,.rst_n         (prim_rst_aon_b)
    ,.data          (force_pwr_gate_pok_q)
    ,.data_sync     (force_pwr_gate_pok_sync)
);

hqm_AW_sync_rst0 #(.WIDTH(1)) i_force_pwr_gate_pok_clr (

     .clk           (prim_freerun_clk)
    ,.rst_n         (prim_gated_rst_b)
    ,.data          (force_pwr_gate_pok_sync)
    ,.data_sync     (force_pwr_gate_pok_clr)
);

// logic that takes the pwrgate_ready output and feeds it back into cdc

assign force_pwr_gate_pok_sync_edge = force_pwr_gate_pok_sync & ~force_pwr_gate_pok_sync_q;

always_ff @(posedge pgcb_clk or negedge prim_rst_aon_b) begin
 if (~prim_rst_aon_b) begin
  force_pwr_gate_pok_sync_q <= '0;
  prim_pgcb_pok             <= '0;
  prim_pwrgate_force        <= '0;
 end else begin
  force_pwr_gate_pok_sync_q <= force_pwr_gate_pok_sync;
  prim_pgcb_pok             <= ~prim_pwrgate_ready;
  prim_pwrgate_force        <= (force_pwr_gate_pok_sync_edge | prim_pwrgate_force) & prim_pgcb_pok;
 end
end

hqm_AW_sync_rst0 #(.WIDTH(1)) i_prim_allow_force_pwrgate_sync (

     .clk           (pgcb_clk)
    ,.rst_n         (prim_rst_aon_b)
    ,.data          (allow_force_pwrgate_q)
    ,.data_sync     (prim_allow_force_pwrgate_sync)
);

assign prim_pwrgate_force_in    = prim_pwrgate_force & prim_allow_force_pwrgate_sync;

assign prim_pgcb_pwrgate_active = ~prim_pgcb_pok | prim_pwrgate_ready;

// Only allow the synchronized wake signals to be seen by the CDCs once the resets have been deasserted

hqm_AW_sync_rst0 #(.WIDTH(1)) i_prim_pwrgate_pmc_wake_sync (

     .clk           (pgcb_clk)
    ,.rst_n         (prim_rst_aon_b)
    ,.data          (prim_pwrgate_pmc_wake)
    ,.data_sync     (prim_pwrgate_pmc_wake_sync)
);

//-----------------------------------------------------------------------------------------------------
// IOSF Primary Clock CDC

hqm_ClockDomainController #(

     .DEF_PWRON         (DEF_PWRON)     // Default to a powered-on state after reset
    ,.ITBITS            (16)            // Idle Timer Bits.  Max is 16
    ,.RST               (2)             // Number of resets.  Min is one.
    ,.AREQ              (2)             // Number of async gclock requests.  Min is one.
    ,.DRIVE_POK         (1)             // Determines whether this domain must drive POK
    ,.ISM_AGT_IS_NS     (0)             // If 1, *_locked signals will be driven as the output of a flop
                                        // If 0, *_locked signals will assert combinatorially
    ,.RSTR_B4_FORCE     (0)             // Determines if this CDC will require restore phase to complete
                                        // in order to transition from IP-Accessible to IP-Inaccessible PG
    ,.PRESCC            (0)             // If 1, The master_clock gate logic with have clkgenctrl muxes for scan to have control
                                        //       of the master_clock branch in order to be used preSCC
                                        //       NOTE: FLOP_CG_EN and DSYNC_CG_EN are a dont care when PRESCC=1
    ,.DSYNC_CG_EN       (0)             // If 1, the master_clock-gate enable will be synchronized to the short master_clock-tree version
                                        //       of master_clock to allow for STA convergence on fast clocks ( >120 MHz )
                                        //       Note: FLOP_CG_EN is a don't care when DSYNC_CG_EN=1
    ,.FLOP_CG_EN        (1)             // If 1, the clock-gate enable will be driven solely by the output of a flop
                                        // If 0, there will be a combi path into the cg enable to allow for faster ungating
    ,.CG_LOCK_ISM       (0)             // if set to 1, ism_locked signal is asserted whenever gclock_active is low

) i_prim_cdc (

    // PGCB ClockDomain

     .pgcb_clk                      (pgcb_clk)                                  //I: PRIM_CDC: PGCB clock; always running
    ,.pgcb_rst_b                    (prim_rst_aon_b)                            //I: PRIM_CDC: Reset with de-assert synchronized to pgcb_clk

    // Master Clock Domain

    ,.clock                         (prim_freerun_clk)                          //I: PRIM_CDC: Master clock
    ,.prescc_clock                  (1'b0)                                      //I: PRIM_CDC: Tie to 0 if PRESCC param is 0
    ,.reset_b                       ({side_rst_b                                //I: PRIM_CDC: Asynchronous ungated reset.  reset_b[0] must be deepest
                                     ,prim_rst_b                                //   reset for the domain.
                                    })
    ,.reset_sync_b                  ({side_rst_sync_prim_b_nc                   //O: PRIM_CDC: Version of reset_b with de-assertion synchronized to clock
                                     ,prim_rst_sync_b_nc
                                    })
    ,.clkreq                        (prim_clkreq)                               //O: PRIM_CDC: Async (glitch free) clock request to disable
    ,.clkack                        (prim_clkack)                               //I: PRIM_CDC: Async (glitch free) clock request acknowledge
    ,.pok_reset_b                   (prim_rst_b)                                //I: PRIM_CDC: Asynchronous reset for POK
    ,.pok                           (prim_pok_nc)                               //O: PRIM_CDC: Power ok indication, synchronous

    ,.gclock_enable_final           (prim_clk_enable_cdc)                       //O: PRIM_CDC: Final enable signal to clock-gate

    // Gated Clock Domain

    ,.gclock                        (prim_gclock_nc)                            //O: PRIM_CDC: Gated version of the clock
    ,.greset_b                      ({side_gated_rst_prim_b                     //O: PRIM_CDC: Gated version of reset_sync_b
                                     ,prim_gated_rst_b
                                    })
    ,.gclock_req_sync               (prim_clkreq_sync)                          //I: PRIM_CDC: Synchronous gclock request.
    ,.gclock_req_async              (prim_clkreq_async[1:0])                    //I: PRIM_CDC: Async (glitch free) gclock requests
    ,.gclock_ack_async              (prim_clkack_async[1:0])                    //O: PRIM_CDC: Clock req ack for each gclock_req_async in this CDC's domain.
    ,.gclock_active                 (prim_clk_active_nc)                        //O: PRIM_CDC: Indication that gclock is running.
    ,.ism_fabric                    ('0)                                        //I: PRIM_CDC: IOSF Fabric ISM.  Tie to zero for non-IOSF domains.
    ,.ism_agent                     ('0)                                        //I: PRIM_CDC: IOSF Agent ISM.  Tie to zero for non-IOSF domains.
    ,.ism_locked                    (prim_ism_locked_nc)                        //O: PRIM_CDC: Indicates that the ISMs for this domain should be locked
    ,.boundary_locked               (prim_boundary_locked_nc)                   //O: PRIM_CDC: Indicates that all non IOSF accesses should be locked out

    // Configuration - Quasi-static

    ,.cfg_clkgate_disabled          (cfg_prim_cdc_ctl.CLKGATE_DISABLED)         //I: PRIM_CDC: Don't allow idle-based clock gating
    ,.cfg_clkreq_ctl_disabled       (cfg_prim_cdc_ctl.CLKREQ_CTL_DISABLED)      //I: PRIM_CDC: Don't allow de-assertion of clkreq when idle
    ,.cfg_clkgate_holdoff           (cfg_prim_cdc_ctl.CLKGATE_HOLDOFF)          //I: PRIM_CDC: Min time from idle to clock gating; 2^value in clocks
    ,.cfg_pwrgate_holdoff           (cfg_prim_cdc_ctl.PWRGATE_HOLDOFF)          //I: PRIM_CDC: Min time from clock gate to power gate ready; 2^value in clocks
    ,.cfg_clkreq_off_holdoff        (cfg_prim_cdc_ctl.CLKREQ_OFF_HOLDOFF)       //I: PRIM_CDC: Min time from locking to !clkreq; 2^value in clocks
    ,.cfg_clkreq_syncoff_holdoff    (cfg_prim_cdc_ctl.CLKREQ_SYNCOFF_HOLDOFF)   //I: PRIM_CDC: Min time from ck gate to !clkreq (powerGateDisabled)

    // CDC Aggregateion and Control (synchronous to pgcb_clk domain)

    ,.pwrgate_disabled              (1'd1)                                      //I: PRIM_CDC: Don't allow idle-based clock gating; PGCB clock
    ,.pwrgate_force                 (prim_pwrgate_force_in)                     //I: PRIM_CDC: Force the controller to gate clocks and lock up
    ,.pwrgate_pmc_wake              (prim_pwrgate_pmc_wake_sync)                //I: PRIM_CDC: PMC wake signal (after sync); PGCB clock domain
    ,.pwrgate_ready                 (prim_pwrgate_ready)                        //O: PRIM_CDC: Allow power gating in the PGCB clock domain.  Can de-assert
                                                                                //   even if never power gated if new wake event occurs.

    // PGCB Controls (synchronous to pgcb_clk domain)

    ,.pgcb_force_rst_b              (1'd1)                                      //I: PRIM_CDC: Force for resets to assert
    ,.pgcb_pok                      (prim_pgcb_pok)                             //I: PRIM_CDC: Power OK signal in the PGCB clock domain
    ,.pgcb_restore                  (1'd0)                                      //I: PRIM_CDC: A restore is in pregress so  ISMs should unlock
    ,.pgcb_pwrgate_active           (prim_pgcb_pwrgate_active)                  //I: PRIM_CDC: Pwr gating in progress, so keep boundary locked

    // Test Controls

    ,.fscan_clkungate               (fscan_clkungate)                           //I: PRIM_CDC: Test clock ungating control
    ,.fscan_byprst_b                ({4{fscan_byprst_b}})                       //I: PRIM_CDC: Scan reset bypass value
    ,.fscan_rstbypen                ({4{fscan_rstbypen}})                       //I: PRIM_CDC: Scan reset bypass enable
    ,.fscan_clkgenctrlen            ('0)                                        //I: PRIM_CDC: Scan clock bypass enable (unused)
    ,.fscan_clkgenctrl              ('0)                                        //I: PRIM_CDC: Scan clock bypass value  (unused)

    ,.fismdfx_force_clkreq          (cdc_prim_jta_force_clkreq)                 //I: PRIM_CDC: DFx force assert clkreq
    ,.fismdfx_clkgate_ovrd          (cdc_prim_jta_clkgate_ovrd)                 //I: PRIM_CDC: DFx force GATE gclock

    // CDC VISA Signals

    ,.cdc_visa                      (cdc_visa_nc)                               //O: PRIM_CDC: Set of internal signals for VISA visibility
);

//-----------------------------------------------------------------------------------------------------
// Clock enable logic

// Sync the safemode signal from the PMA and use it to disable all clock gating
// Purposely not reset

hqm_AW_sync i_pma_safemode_sync (

     .clk           (prim_freerun_clk)
    ,.data          (pma_safemode)
    ,.data_sync     (pma_safemode_sync)
);

always_comb begin

 prim_clk_enable     = prim_clk_enable_cdc & flr_clk_enable;
 prim_clk_enable_sys = prim_clk_enable_cdc & flr_clk_enable_system;
 prim_clk_ungate     = (cfg_prim_cdc_ctl.CLKGATE_DISABLED | pma_safemode_sync) & flr_clk_enable;

end

//-----------------------------------------------------------------------------------------------------

hqm_AW_unused_bits i_unused_prim_cdc (

     .a     (|{side_rst_sync_prim_b_nc
              ,prim_boundary_locked_nc
              ,prim_clk_active_nc
              ,prim_gclock_nc
              ,prim_ism_locked_nc
              ,prim_pok_nc
              ,prim_rst_sync_b_nc
              ,cdc_visa_nc
            })
);

//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

 logic  cmd_parity_off;

 initial begin
  cmd_parity_off=1'b0;
  if ($test$plusargs("HQM_COMMAND_PARITY_CHECK")) cmd_parity_off=1'b1;
 end

 SFI_RX_CMD_PARITY_WRONG: assert property (
  @(posedge prim_freerun_clk)
  disable iff (~prim_gated_rst_b | cmd_parity_off)
  (cfg_parity_ctl.SIFP_PAR_OFF | ~(^{sfi_rx_hdr_info_bytes, sfi_rx_header}))
 ) else
  $error ("Error: SFI RX header parity is not correct!");

 SFI_TX_CMD_PARITY_WRONG: assert property (
  @(posedge prim_freerun_clk)
  disable iff (~prim_gated_rst_b | cmd_parity_off)
  (cfg_parity_ctl.SIFP_PAR_OFF | ~(^{sfi_tx_hdr_info_bytes, sfi_tx_header}))
 ) else
  $error ("Error: SFI TX header parity is not correct!");

`endif

//-----------------------------------------------------------------------------------------------------

endmodule // hqm_sfi_core
