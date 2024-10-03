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

module hqm_sfi

     import hqm_sfi_pkg::*;
#(
     parameter int unsigned BRIDGE = 0,

`include "hqm_sfi_params.sv"

) (
     input  logic                                           clk
    ,input  logic                                           clk_gated
    ,input  logic                                           clk_valid
    ,input  logic                                           rst_b

    //-------------------------------------------------------------------------------------------------

    ,input  logic [2:0]                                     cfg_idle_dly
    ,input  logic                                           cfg_inj_tx_edb
    ,input  logic                                           cfg_inj_tx_poison
    ,input  logic                                           cfg_inj_tx_auxperr
    ,input  logic                                           cfg_inj_tx_dperr
    ,input  logic                                           cfg_inj_tx_cperr
    ,input  logic [31:0]                                    cfg_sif_vc_rxmap
    ,input  logic [31:0]                                    cfg_sif_vc_txmap
    ,input  logic                                           cfg_dbgbrk1
    ,input  logic                                           cfg_dbgbrk2
    ,input  logic                                           cfg_dbgbrk3
    ,input  logic                                           cfg_sfi_rx_data_par_off
    ,input  logic                                           cfg_sfi_idle_min_crds

    ,input  logic                                           config_done

    ,input  logic [31:0]                                    sfi_dfx_ctl

    ,input  logic                                           force_sfi_blocks            // For ResetPrep flow

    ,output logic                                           sfi_rx_idle
    ,output logic                                           sfi_tx_idle

    ,output hqm_sfi_rx_state_t                              rx_sm
    ,output hqm_sfi_tx_state_t                              tx_sm

    ,output logic [135:0]                                   noa_sfi

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
    // Agent TX interface

    ,input  logic                                           agent_tx_v                  // Agent master transaction
    ,input  logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             agent_tx_vc
    ,input  hqm_sfi_fc_id_t                                 agent_tx_fc
    ,input  logic [3:0]                                     agent_tx_hdr_size
    ,input  logic                                           agent_tx_hdr_has_data
    ,input  hqm_sfi_flit_header_t                           agent_tx_hdr
    ,input  logic                                           agent_tx_hdr_par
    ,input  logic [(HQM_SFI_TX_D*8)-1:0]                    agent_tx_data
    ,input  logic [(HQM_SFI_TX_D/8)-1:0]                    agent_tx_data_par

    ,output logic                                           agent_tx_ack

    //-------------------------------------------------------------------------------------------------
    // Agent TX credit interface

    ,input  logic                                           tx_hcrd_consume_v           // Consuming TX hdr  credits
    ,input  logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             tx_hcrd_consume_vc
    ,input  hqm_sfi_fc_id_t                                 tx_hcrd_consume_fc
    ,input  logic                                           tx_hcrd_consume_val

    ,input  logic                                           tx_dcrd_consume_v           // Consuming TX data credits
    ,input  logic [HQM_SFI_TX_DATA_VC_WIDTH-1:0]            tx_dcrd_consume_vc
    ,input  hqm_sfi_fc_id_t                                 tx_dcrd_consume_fc
    ,input  logic [2:0]                                     tx_dcrd_consume_val

    ,output logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_hcrds_avail  // Available TX hdr  credits
    ,output logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_dcrds_avail  // Available TX data credits

    //-------------------------------------------------------------------------------------------------
    // Agent RX interface

    ,input  logic                                           agent_rxqs_empty

    ,output logic                                           agent_rx_hdr_v              // Agent TX hdr  push
    ,output logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             agent_rx_hdr_vc
    ,output hqm_sfi_fc_id_t                                 agent_rx_hdr_fc
    ,output logic [3:0]                                     agent_rx_hdr_size
    ,output logic                                           agent_rx_hdr_has_data
    ,output hqm_sfi_flit_header_t                           agent_rx_hdr
    ,output logic                                           agent_rx_hdr_par

    ,output logic                                           agent_rx_data_v             // Agent TX data push
    ,output logic [HQM_SFI_RX_DATA_VC_WIDTH-1:0]            agent_rx_data_vc
    ,output hqm_sfi_fc_id_t                                 agent_rx_data_fc
    ,output logic [(HQM_SFI_RX_D*8)-1:0]                    agent_rx_data
    ,output logic [(HQM_SFI_RX_D/8)-1:0]                    agent_rx_data_par

    //-------------------------------------------------------------------------------------------------
    // Agent RX credit return interface

    ,input  logic                                           rx_hcrd_return_v            // Agent returning RX hdr  credits
    ,input  logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             rx_hcrd_return_vc
    ,input  hqm_sfi_fc_id_t                                 rx_hcrd_return_fc
    ,input  logic [HQM_SFI_RX_NHCRD-1:0]                    rx_hcrd_return_val

    ,input  logic                                           rx_dcrd_return_v            // Agent returning RX data credits
    ,input  logic [HQM_SFI_RX_DATA_VC_WIDTH-1:0]            rx_dcrd_return_vc
    ,input  hqm_sfi_fc_id_t                                 rx_dcrd_return_fc
    ,input  logic [HQM_SFI_RX_NDCRD-1:0]                    rx_dcrd_return_val

    //-------------------------------------------------------------------------------------------------
    // Errors

    ,output logic                                           tx_hcrds_used_xflow         // Consumed hcrd over/underflow
    ,output logic [7:0]                                     tx_hcrds_used_xflow_synd
    ,output logic                                           tx_dcrds_used_xflow         // Consumed dcrd over/underflow
    ,output logic [7:0]                                     tx_dcrds_used_xflow_synd

    ,output logic [3:0]                                     set_sfi_rx_data_err

    ,output hqm_sfi_flit_header_t                           sfi_rx_data_aux_hdr

    ,output logic [HQM_SFI_RX_DATA_EDB_WIDTH-1:0]           sfi_rx_data_edb_err_synd
    ,output logic [HQM_SFI_RX_DATA_POISON_WIDTH-1:0]        sfi_rx_data_poison_err_synd
    ,output logic [HQM_SFI_RX_DATA_PARITY_WIDTH-1:0]        sfi_rx_data_perr_synd

    //-------------------------------------------------------------------------------------------------
    // Credit status

    ,input  logic [HQM_SFI_RX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]  rx_used_hcrds   // Consumed credits
    ,input  logic [HQM_SFI_RX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]  rx_used_dcrds

    ,output logic [HQM_SFI_RX_HDR_NUM_VCS -1:0][2:0][12:0]                              rx_init_hcrds   // Initial credits
    ,output logic [HQM_SFI_RX_DATA_NUM_VCS-1:0][2:0][12:0]                              rx_init_dcrds

    ,output logic [HQM_SFI_RX_HDR_NUM_VCS -1:0][2:0][12:0]                              rx_ret_hcrds    // Returnable credits
    ,output logic [HQM_SFI_RX_DATA_NUM_VCS-1:0][2:0][12:0]                              rx_ret_dcrds

    ,output logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][12:0]                              tx_init_hcrds   // Initial credits
    ,output logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][12:0]                              tx_init_dcrds

    ,output logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][12:0]                              tx_rem_hcrds    // Remaining credits
    ,output logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][12:0]                              tx_rem_dcrds

    ,output logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][12:0]                              tx_used_hcrds   // Consumed credits
    ,output logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][12:0]                              tx_used_dcrds
);

//-----------------------------------------------------------------------------------------------------
// Interface regs

hqm_sfi_tx_txglobal_t                       sfi_tx_txglobal_next;
hqm_sfi_tx_txglobal_t                       sfi_tx_txglobal_q;

hqm_sfi_tx_rxglobal_t                       sfi_tx_rxglobal_next;
hqm_sfi_tx_rxglobal_t                       sfi_tx_rxglobal_q;

hqm_sfi_hdr_t                               sfi_tx_hdr_nexti;
hqm_sfi_hdr_t                               sfi_tx_hdr_next;
hqm_sfi_hdr_t                               sfi_tx_hdr_q;
logic                                       sfi_tx_hdr_block_q;

logic                                       sfi_tx_hdr_crd_rtn_valid_q;
logic [4:0]                                 sfi_tx_hdr_crd_rtn_vc_id_q;
hqm_sfi_fc_id_t                             sfi_tx_hdr_crd_rtn_fc_id_q;
logic [HQM_SFI_TX_NHCRD-1:0]                sfi_tx_hdr_crd_rtn_value_q;

hqm_sfi_tx_data_t                           sfi_tx_data_nexti;
hqm_sfi_tx_data_t                           sfi_tx_data_next;
hqm_sfi_tx_data_t                           sfi_tx_data_q;
logic                                       sfi_tx_data_block_q;

logic                                       sfi_tx_data_crd_rtn_valid_q;
logic [4:0]                                 sfi_tx_data_crd_rtn_vc_id_q;
hqm_sfi_fc_id_t                             sfi_tx_data_crd_rtn_fc_id_q;
logic [HQM_SFI_TX_NDCRD-1:0]                sfi_tx_data_crd_rtn_value_q;

hqm_sfi_rx_txglobal_t                       sfi_rx_txglobal_next;
hqm_sfi_rx_txglobal_t                       sfi_rx_txglobal_q;

hqm_sfi_tx_rxglobal_t                       sfi_rx_rxglobal_next;
hqm_sfi_tx_rxglobal_t                       sfi_rx_rxglobal_q;

hqm_sfi_hdr_t                               sfi_rx_hdr_next;
hqm_sfi_hdr_t                               sfi_rx_hdr_q;

logic                                       sfi_rx_hdr_early_valid_q;

logic                                       sfi_rx_hdr_crd_rtn_valid_next;
logic                                       sfi_rx_hdr_crd_rtn_valid_q;
logic [2:0]                                 sfi_rx_hdr_crd_rtn_vc_id_next;
logic [2:0]                                 sfi_rx_hdr_crd_rtn_vc_id_q;
hqm_sfi_fc_id_t                             sfi_rx_hdr_crd_rtn_fc_id_next;
hqm_sfi_fc_id_t                             sfi_rx_hdr_crd_rtn_fc_id_q;
logic [HQM_SFI_RX_NHCRD-1:0]                sfi_rx_hdr_crd_rtn_value_next;
logic [HQM_SFI_RX_NHCRD-1:0]                sfi_rx_hdr_crd_rtn_value_q;
logic                                       sfi_rx_hdr_crd_rtn_block_next;
logic                                       sfi_rx_hdr_crd_rtn_block_q;

hqm_sfi_rx_data_t                           sfi_rx_data_next;
hqm_sfi_rx_data_t                           sfi_rx_data_q;

logic                                       sfi_rx_data_early_valid_q;

logic                                       sfi_rx_data_crd_rtn_valid_next;
logic                                       sfi_rx_data_crd_rtn_valid_q;
logic [2:0]                                 sfi_rx_data_crd_rtn_vc_id_next;
logic [2:0]                                 sfi_rx_data_crd_rtn_vc_id_q;
hqm_sfi_fc_id_t                             sfi_rx_data_crd_rtn_fc_id_next;
hqm_sfi_fc_id_t                             sfi_rx_data_crd_rtn_fc_id_q;
logic [HQM_SFI_RX_NDCRD-1:0]                sfi_rx_data_crd_rtn_value_next;
logic [HQM_SFI_RX_NDCRD-1:0]                sfi_rx_data_crd_rtn_value_q;
logic                                       sfi_rx_data_crd_rtn_block_next;
logic                                       sfi_rx_data_crd_rtn_block_q;

//-----------------------------------------------------------------------------------------------------

logic                                       rx_deny_discon;             // Disconnect deny
logic                                       rx_sm_connected;            // RX SM state is CONNECTED
logic                                       rx_sm_disconnected;         // RX SM state is DISCONNECTED

logic                                       tx_discon_req;              // Disconnect request
logic                                       tx_sm_connected;            // TX SM state is CONNECTED
logic                                       tx_sm_disconnected;         // TX SM state is DISCONNECTED

logic                                       rx_crd_idle;

logic                                       rx_min_crds_sent;
logic                                       tx_min_crds_rcvd;

logic                                       sfi_rx_busy;
logic                                       sfi_tx_busy;
logic                                       sfi_go_idle;
logic                                       sfi_go_idle_ack;

logic                                       tx_has_consumed_crds;

logic [4:0]                                 inj_perr;
logic [4:0]                                 inj_perr_last_next;
logic [4:0]                                 inj_perr_last_q;

logic                                       config_done_sync;

//-----------------------------------------------------------------------------------------------------
// Treat this signal asynchronously and have the reset value default to 0

hqm_AW_sync_rst0 i_config_done_sync (

     .clk           (clk_gated)
    ,.rst_n         (rst_b)
    ,.data          (config_done)

    ,.data_sync     (config_done_sync)
);

//-----------------------------------------------------------------------------------------------------
// Register the TX interfaces

always_comb begin

 // Parity injection logic

 // If the cfg inject parity error bits are set, invert the parity on the next P or NP

 inj_perr           = (~inj_perr_last_q) &

                      {cfg_inj_tx_edb
                      ,cfg_inj_tx_poison
                      ,cfg_inj_tx_auxperr
                      ,cfg_inj_tx_dperr
                      ,cfg_inj_tx_cperr
                      } &

                      {{4{(sfi_tx_data_nexti.data_valid &
                           ((sfi_tx_data_nexti.data_info_byte.fc_id == sfi_fc_posted) |
                            (sfi_tx_data_nexti.data_info_byte.fc_id == sfi_fc_nonposted)))}}

                      ,   (sfi_tx_hdr_nexti.hdr_valid  &
                           ((sfi_tx_hdr_nexti.hdr_info_bytes.fc_id == sfi_fc_posted) |
                            (sfi_tx_hdr_nexti.hdr_info_bytes.fc_id == sfi_fc_nonposted)))
                      };

 inj_perr_last_next = inj_perr_last_q | inj_perr;

 // Outbound

 sfi_tx_txcon_req                   = sfi_tx_txglobal_q.txcon_req;

 sfi_tx_hdr_valid                   = sfi_tx_hdr_q.hdr_valid;
 sfi_tx_hdr_early_valid             = sfi_tx_hdr_q.hdr_early_valid;
 sfi_tx_hdr_info_bytes              = sfi_tx_hdr_q.hdr_info_bytes;

 sfi_tx_hdr_next                    = sfi_tx_hdr_nexti;

 if (inj_perr[0]) begin

  sfi_tx_hdr_next.hdr_info_bytes.parity = (~sfi_tx_hdr_next.hdr_info_bytes.parity);

 end

 // Swap bytes within the header DWs

 for (int i=0; i<HQM_SFI_TX_H; i=i+4) begin
  sfi_tx_header[((i*8)+ 0) +: 8]    = sfi_tx_hdr_q.header[((i*8)+24) +: 8];
  sfi_tx_header[((i*8)+ 8) +: 8]    = sfi_tx_hdr_q.header[((i*8)+16) +: 8];
  sfi_tx_header[((i*8)+16) +: 8]    = sfi_tx_hdr_q.header[((i*8)+ 8) +: 8];
  sfi_tx_header[((i*8)+24) +: 8]    = sfi_tx_hdr_q.header[((i*8)+ 0) +: 8];
 end

 sfi_tx_data_valid                  = sfi_tx_data_q.data_valid;
 sfi_tx_data_early_valid            = sfi_tx_data_q.data_early_valid;
 sfi_tx_data_aux_parity             = sfi_tx_data_q.data_aux_parity;
 sfi_tx_data_poison                 = sfi_tx_data_q.data_poison;
 sfi_tx_data_edb                    = sfi_tx_data_q.data_edb;
 sfi_tx_data_start                  = sfi_tx_data_q.data_start;
 sfi_tx_data_end                    = sfi_tx_data_q.data_end;
 sfi_tx_data_parity                 = sfi_tx_data_q.data_parity;
 sfi_tx_data_info_byte              = sfi_tx_data_q.data_info_byte;
 sfi_tx_data                        = sfi_tx_data_q.data;

 // Inbound

 sfi_tx_rxglobal_next.rxcon_ack     = sfi_tx_rxcon_ack;
 sfi_tx_rxglobal_next.rxdiscon_nack = sfi_tx_rxdiscon_nack;
 sfi_tx_rxglobal_next.rx_empty      = sfi_tx_rx_empty;

 sfi_tx_data_next                   = sfi_tx_data_nexti;

 if (inj_perr[1]) begin

  sfi_tx_data_next.data_parity[0]   = (~sfi_tx_data_next.data_parity[0]);

 end

 if (inj_perr[2]) begin

  sfi_tx_data_next.data_aux_parity  = (~sfi_tx_data_next.data_aux_parity);

 end

 if (inj_perr[3]) begin

  sfi_tx_data_next.data_poison[0]   = (~sfi_tx_data_next.data_poison[0]);

 end

 if (inj_perr[4]) begin

  sfi_tx_data_next.data_edb[0]      = (~sfi_tx_data_next.data_edb[0]);

 end

end

always_ff @(posedge clk or negedge rst_b) begin
 if (~rst_b) begin
  sfi_tx_txglobal_q             <= '0;
  sfi_tx_rxglobal_q             <= '0;
  inj_perr_last_q               <= '0;
 end else begin
  sfi_tx_txglobal_q             <= sfi_tx_txglobal_next;
  sfi_tx_rxglobal_q             <= sfi_tx_rxglobal_next;
  if (sfi_dfx_ctl[16+0]) sfi_tx_txglobal_q.txcon_req <= sfi_dfx_ctl[0];
  inj_perr_last_q               <= inj_perr_last_next;
 end
end

always_ff @(posedge clk_gated or negedge rst_b) begin
 if (~rst_b) begin
  sfi_tx_hdr_q                  <= '0;
  sfi_tx_hdr_block_q            <= '0;
  sfi_tx_hdr_crd_rtn_valid_q    <= '0;
  sfi_tx_hdr_crd_rtn_vc_id_q    <= '0;
  sfi_tx_hdr_crd_rtn_fc_id_q    <= hqm_sfi_fc_id_t'('0);
  sfi_tx_hdr_crd_rtn_value_q    <= '0;
  sfi_tx_data_q                 <= '0;
  sfi_tx_data_block_q           <= '0;
  sfi_tx_data_crd_rtn_valid_q   <= '0;
  sfi_tx_data_crd_rtn_vc_id_q   <= '0;
  sfi_tx_data_crd_rtn_fc_id_q   <= hqm_sfi_fc_id_t'('0);
  sfi_tx_data_crd_rtn_value_q   <= '0;
 end else begin
  sfi_tx_hdr_q                  <= sfi_tx_hdr_next;
  sfi_tx_hdr_block_q            <= sfi_tx_hdr_block;
  sfi_tx_hdr_crd_rtn_valid_q    <= sfi_tx_hdr_crd_rtn_valid;
  sfi_tx_hdr_crd_rtn_vc_id_q    <= sfi_tx_hdr_crd_rtn_vc_id;
  sfi_tx_hdr_crd_rtn_fc_id_q    <= sfi_tx_hdr_crd_rtn_fc_id;
  sfi_tx_hdr_crd_rtn_value_q    <= sfi_tx_hdr_crd_rtn_value;
  sfi_tx_data_q                 <= sfi_tx_data_next;
  sfi_tx_data_block_q           <= sfi_tx_data_block;
  sfi_tx_data_crd_rtn_valid_q   <= sfi_tx_data_crd_rtn_valid;
  sfi_tx_data_crd_rtn_vc_id_q   <= sfi_tx_data_crd_rtn_vc_id;
  sfi_tx_data_crd_rtn_fc_id_q   <= sfi_tx_data_crd_rtn_fc_id;
  sfi_tx_data_crd_rtn_value_q   <= sfi_tx_data_crd_rtn_value;
  if (sfi_dfx_ctl[16+5]) sfi_tx_hdr_q.hdr_early_valid   <= sfi_dfx_ctl[5];;
  if (sfi_dfx_ctl[16+9]) sfi_tx_data_q.data_early_valid <= sfi_dfx_ctl[6];
 end
end

//-----------------------------------------------------------------------------------------------------
// Register the RX interfaces

always_comb begin

 // Inbound

 sfi_rx_txglobal_next.txcon_req         = sfi_rx_txcon_req;

 sfi_rx_hdr_next                        = '0;

 sfi_rx_hdr_next.hdr_valid              = sfi_rx_hdr_valid;
 sfi_rx_hdr_next.hdr_early_valid        = sfi_rx_hdr_early_valid;
 sfi_rx_hdr_next.hdr_info_bytes         = sfi_rx_hdr_info_bytes;

 // Swap bytes within the header DWs

 for (int i=0; i<HQM_SFI_RX_H; i=i+4) begin
  sfi_rx_hdr_next.header[((i*8)+ 0) +: 8] = sfi_rx_header[((i*8)+24) +: 8];
  sfi_rx_hdr_next.header[((i*8)+ 8) +: 8] = sfi_rx_header[((i*8)+16) +: 8];
  sfi_rx_hdr_next.header[((i*8)+16) +: 8] = sfi_rx_header[((i*8)+ 8) +: 8];
  sfi_rx_hdr_next.header[((i*8)+24) +: 8] = sfi_rx_header[((i*8)+ 0) +: 8];
 end

 sfi_rx_hdr_crd_rtn_block_next          = sfi_rx_hdr_crd_rtn_block;

 sfi_rx_data_next                       = '0;

 sfi_rx_data_next.data_valid            = sfi_rx_data_valid;
 sfi_rx_data_next.data_early_valid      = sfi_rx_data_early_valid;
 sfi_rx_data_next.data_aux_parity       = sfi_rx_data_aux_parity;
 sfi_rx_data_next.data_poison           = sfi_rx_data_poison;
 sfi_rx_data_next.data_edb              = sfi_rx_data_edb;
 sfi_rx_data_next.data_start            = sfi_rx_data_start;
 sfi_rx_data_next.data_end              = sfi_rx_data_end;
 sfi_rx_data_next.data_parity           = sfi_rx_data_parity;
 sfi_rx_data_next.data_info_byte        = sfi_rx_data_info_byte;
 sfi_rx_data_next.data                  = sfi_rx_data;

 sfi_rx_data_crd_rtn_block_next         = sfi_rx_data_crd_rtn_block;

 // Outbound

 sfi_rx_rxcon_ack                       = sfi_rx_rxglobal_q.rxcon_ack;
 sfi_rx_rxdiscon_nack                   = sfi_rx_rxglobal_q.rxdiscon_nack;
 sfi_rx_rx_empty                        = sfi_rx_rxglobal_q.rx_empty;

 sfi_rx_hdr_crd_rtn_valid               = sfi_rx_hdr_crd_rtn_valid_q;
 sfi_rx_hdr_crd_rtn_fc_id               = sfi_rx_hdr_crd_rtn_fc_id_q;
 sfi_rx_hdr_crd_rtn_value               = sfi_rx_hdr_crd_rtn_value_q;

 sfi_rx_data_crd_rtn_valid              = sfi_rx_data_crd_rtn_valid_q;
 sfi_rx_data_crd_rtn_fc_id              = sfi_rx_data_crd_rtn_fc_id_q;
 sfi_rx_data_crd_rtn_value              = sfi_rx_data_crd_rtn_value_q;

end

hqm_AW_width_scale #(.A_WIDTH(3), .Z_WIDTH(5)) i_sfi_rx_hdr_crd_rtn_vc_id (

     .a     (sfi_rx_hdr_crd_rtn_vc_id_q)
    ,.z     (sfi_rx_hdr_crd_rtn_vc_id)
);

hqm_AW_width_scale #(.A_WIDTH(3), .Z_WIDTH(5)) i_sfi_rx_data_crd_rtn_vc_id (

     .a     (sfi_rx_data_crd_rtn_vc_id_q)
    ,.z     (sfi_rx_data_crd_rtn_vc_id)
);

always_ff @(posedge clk or negedge rst_b) begin
 if (~rst_b) begin
  sfi_rx_txglobal_q             <= '0;
  sfi_rx_rxglobal_q             <= '0;
  sfi_rx_hdr_early_valid_q      <= '0;
  sfi_rx_data_early_valid_q     <= '0;
 end else begin
  sfi_rx_txglobal_q             <= sfi_rx_txglobal_next;
  sfi_rx_rxglobal_q             <= sfi_rx_rxglobal_next;
  sfi_rx_hdr_early_valid_q      <= sfi_rx_hdr_early_valid;
  sfi_rx_data_early_valid_q     <= sfi_rx_data_early_valid;
  if (sfi_dfx_ctl[16+1]) sfi_rx_rxglobal_q.rxcon_ack     <= sfi_dfx_ctl[1];
  if (sfi_dfx_ctl[16+2]) sfi_rx_rxglobal_q.rxdiscon_nack <= sfi_dfx_ctl[2];
  if (sfi_dfx_ctl[16+3]) sfi_rx_rxglobal_q.rx_empty      <= sfi_dfx_ctl[3];
 end
end

always_ff @(posedge clk_gated or negedge rst_b) begin
 if (~rst_b) begin
  sfi_rx_hdr_q                  <= '0;
  sfi_rx_hdr_crd_rtn_valid_q    <= '0;
  sfi_rx_hdr_crd_rtn_vc_id_q    <= '0;
  sfi_rx_hdr_crd_rtn_fc_id_q    <= hqm_sfi_fc_id_t'('0);
  sfi_rx_hdr_crd_rtn_value_q    <= '0;
  sfi_rx_hdr_crd_rtn_block_q    <= '0;
  sfi_rx_data_q                 <= '0;
  sfi_rx_data_crd_rtn_valid_q   <= '0;
  sfi_rx_data_crd_rtn_vc_id_q   <= '0;
  sfi_rx_data_crd_rtn_fc_id_q   <= hqm_sfi_fc_id_t'('0);
  sfi_rx_data_crd_rtn_value_q   <= '0;
  sfi_rx_data_crd_rtn_block_q   <= '0;
 end else begin
  sfi_rx_hdr_q                  <= sfi_rx_hdr_next;
  sfi_rx_hdr_crd_rtn_valid_q    <= sfi_rx_hdr_crd_rtn_valid_next;
  sfi_rx_hdr_crd_rtn_vc_id_q    <= sfi_rx_hdr_crd_rtn_vc_id_next;
  sfi_rx_hdr_crd_rtn_fc_id_q    <= sfi_rx_hdr_crd_rtn_fc_id_next;
  sfi_rx_hdr_crd_rtn_value_q    <= sfi_rx_hdr_crd_rtn_value_next;
  sfi_rx_hdr_crd_rtn_block_q    <= sfi_rx_hdr_crd_rtn_block_next;
  sfi_rx_data_q                 <= sfi_rx_data_next;
  sfi_rx_data_crd_rtn_valid_q   <= sfi_rx_data_crd_rtn_valid_next;
  sfi_rx_data_crd_rtn_vc_id_q   <= sfi_rx_data_crd_rtn_vc_id_next;
  sfi_rx_data_crd_rtn_fc_id_q   <= sfi_rx_data_crd_rtn_fc_id_next;
  sfi_rx_data_crd_rtn_value_q   <= sfi_rx_data_crd_rtn_value_next;
  sfi_rx_data_crd_rtn_block_q   <= sfi_rx_data_crd_rtn_block_next;
 end
end

//-----------------------------------------------------------------------------------------------------
// SFI TX Connection State Machine: Reset state is DISCONNECTED.

always_comb begin

 // We don't support the disconnect flow, so never initiate a disconnect request

 tx_discon_req = '0;

end

hqm_sfi_tx_sm #(

`include "hqm_sfi_params_inst.sv"

) i_hqm_sfi_tx_sm (

     .clk_gated                         (clk_gated)                             //I: TX_SM:
    ,.clk_valid                         (clk_valid)                             //I: TX_SM:

    ,.rst_b                             (rst_b)                                 //I: TX_SM:

    ,.cfg_dbgbrk1                       (cfg_dbgbrk1)                           //I: TX_SM:

    ,.config_done_sync                  (config_done_sync)                      //I: TX_SM:

    ,.tx_discon_req                     (tx_discon_req)                         //I: TX_SM: Disconnect request

    ,.rxcon_ack_q                       (sfi_tx_rxglobal_q.rxcon_ack)           //I: TX_SM: Connect/Disconnect acknowledge
    ,.rxdiscon_nack_q                   (sfi_tx_rxglobal_q.rxdiscon_nack)       //I: TX_SM: Disconnect rejection

    ,.txcon_req_next                    (sfi_tx_txglobal_next.txcon_req)        //O: TX_SM: Connect/Disconnect request

    ,.tx_sm_connected                   (tx_sm_connected)                       //O: TX_SM: TX SM state is CONNECTED
    ,.tx_sm_disconnected                (tx_sm_disconnected)                    //O: TX_SM: TX SM state is DISCONNECTED

    ,.tx_sm                             (tx_sm)                                 //O: TX_SM: TX SM
);

//-----------------------------------------------------------------------------------------------------
// SFI RX Connection State Machine: Reset state is DISCONNECTED.

always_comb begin

 // We don't support the disconnect flow, so always deny a disconnect request.

 rx_deny_discon = '1;

end

hqm_sfi_rx_sm #(

`include "hqm_sfi_params_inst.sv"

) i_hqm_sfi_rx_sm (

     .clk_gated                         (clk_gated)                             //I: RX_SM:
    ,.clk_valid                         (clk_valid)                             //I: RX_SM:

    ,.rst_b                             (rst_b)                                 //I: RX_SM:

    ,.cfg_dbgbrk2                       (cfg_dbgbrk2)                           //I: RX_SM:
    ,.cfg_dbgbrk3                       (cfg_dbgbrk3)                           //I: RX_SM:

    ,.config_done_sync                  (config_done_sync)                      //I: RX_SM:

    ,.rx_deny_discon                    (rx_deny_discon)                        //I: RX_SM: Deny disconnect

    ,.txcon_req_q                       (sfi_rx_txglobal_q.txcon_req)           //I: RX_SM: Connect/Disconnect request

    ,.rxcon_ack_next                    (sfi_rx_rxglobal_next.rxcon_ack)        //O: RX_SM: Connect/Disconnect acknowledge
    ,.rxdiscon_nack_next                (sfi_rx_rxglobal_next.rxdiscon_nack)    //O: RX_SM: Disconnect rejection

    ,.rx_sm_connected                   (rx_sm_connected)                       //O: RX_SM: RX SM state is CONNECTED
    ,.rx_sm_disconnected                (rx_sm_disconnected)                    //O: RX_SM: RX SM state is DISCONNECTED

    ,.rx_sm                             (rx_sm)                                 //O: RX_SM: RX SM
);

//-----------------------------------------------------------------------------------------------------
// TX Credits

hqm_sfi_tx_crd #(

`include "hqm_sfi_params_inst.sv"

) i_hqm_sfi_tx_crd (

     .clk_gated                         (clk_gated)                             //I: TX_CRD:

    ,.rst_b                             (rst_b)                                 //I: TX_CRD:

    ,.tx_sm_disconnected                (tx_sm_disconnected)                    //I: TX_CRD: TX SM state is DISCONNECTED

    ,.cfg_sif_vc_rxmap                  (cfg_sif_vc_rxmap)                      //I: TX_CRD:

    ,.tx_hcrd_consume_v                 (tx_hcrd_consume_v)                     //I: TX_CRD: Target hdr  credit consume
    ,.tx_hcrd_consume_vc                (tx_hcrd_consume_vc)                    //I: TX_CRD:
    ,.tx_hcrd_consume_fc                (tx_hcrd_consume_fc)                    //I: TX_CRD:
    ,.tx_hcrd_consume_val               (tx_hcrd_consume_val)                   //I: TX_CRD:

    ,.tx_dcrd_consume_v                 (tx_dcrd_consume_v)                     //I: TX_CRD: Target data credit consume
    ,.tx_dcrd_consume_vc                (tx_dcrd_consume_vc)                    //I: TX_CRD:
    ,.tx_dcrd_consume_fc                (tx_dcrd_consume_fc)                    //I: TX_CRD:
    ,.tx_dcrd_consume_val               (tx_dcrd_consume_val)                   //I: TX_CRD:

    ,.tx_has_consumed_crds              (tx_has_consumed_crds)                  //O: TX_CRD:

    ,.tx_min_crds_rcvd                  (tx_min_crds_rcvd)                      //O: TX_CRD:

    ,.tx_hcrds_avail                    (tx_hcrds_avail)                        //O: TX_CRD: Available hdr  credits
    ,.tx_dcrds_avail                    (tx_dcrds_avail)                        //O: TX_CRD: Available data credits

    ,.sfi_tx_rx_empty_q                 (sfi_tx_rxglobal_q.rx_empty)            //I: TX_CRD:

    ,.sfi_tx_hdr_crd_rtn_valid_q        (sfi_tx_hdr_crd_rtn_valid_q)            //I: TX_CRD: TX hdr  credit return valid
    ,.sfi_tx_hdr_crd_rtn_vc_id_q        (sfi_tx_hdr_crd_rtn_vc_id_q)            //I: TX_CRD: TX hdr  credit return VC
    ,.sfi_tx_hdr_crd_rtn_fc_id_q        (sfi_tx_hdr_crd_rtn_fc_id_q)            //I: TX_CRD: TX hdr  credit return FC
    ,.sfi_tx_hdr_crd_rtn_value_q        (sfi_tx_hdr_crd_rtn_value_q)            //I: TX_CRD: TX hdr  credit return value

    ,.sfi_tx_data_crd_rtn_valid_q       (sfi_tx_data_crd_rtn_valid_q)           //I: TX_CRD: TX data credit return valid
    ,.sfi_tx_data_crd_rtn_vc_id_q       (sfi_tx_data_crd_rtn_vc_id_q)           //I: TX_CRD: TX data credit return VC
    ,.sfi_tx_data_crd_rtn_fc_id_q       (sfi_tx_data_crd_rtn_fc_id_q)           //I: TX_CRD: TX data credit return FC
    ,.sfi_tx_data_crd_rtn_value_q       (sfi_tx_data_crd_rtn_value_q)           //I: TX_CRD: TX data credit return value

    ,.tx_hcrds_used_xflow               (tx_hcrds_used_xflow)                   //O: TX_CRD: Consumed hcrd over/underflow
    ,.tx_hcrds_used_xflow_synd          (tx_hcrds_used_xflow_synd)              //O: TX_CRD:
    ,.tx_dcrds_used_xflow               (tx_dcrds_used_xflow)                   //O: TX_CRD: Consumed dcrd over/underflow
    ,.tx_dcrds_used_xflow_synd          (tx_dcrds_used_xflow_synd)              //O: TX_CRD:

    ,.tx_init_hcrds                     (tx_init_hcrds)                         //O: TX_CRD: Initial credits
    ,.tx_init_dcrds                     (tx_init_dcrds)                         //O: TX_CRD:

    ,.tx_rem_hcrds                      (tx_rem_hcrds)                          //O: TX_CRD: Remaining credits
    ,.tx_rem_dcrds                      (tx_rem_dcrds)                          //O: TX_CRD:

    ,.tx_used_hcrds                     (tx_used_hcrds)                         //O: TX_CRD: Consumed credits
    ,.tx_used_dcrds                     (tx_used_dcrds)                         //O: TX_CRD:
);

//-----------------------------------------------------------------------------------------------------
// RX Credits

hqm_sfi_rx_crd #(

     .BRIDGE(BRIDGE),

`include "hqm_sfi_params_inst.sv"

) i_hqm_sfi_rx_crd (

     .clk_gated                         (clk_gated)                             //I: RX_CRD:

    ,.rst_b                             (rst_b)                                 //I: RX_CRD:

    ,.rx_sm_connected                   (rx_sm_connected)                       //I: RX_CRD: RX SM state is CONNECTED
    ,.rx_sm_disconnected                (rx_sm_disconnected)                    //I: RX_CRD: RX SM state is DISCONNECTED

    ,.cfg_sif_vc_txmap                  (cfg_sif_vc_txmap)                      //I: RX_CRD:

    ,.force_sfi_blocks                  (force_sfi_blocks)                      //I: RX_CRD:

    ,.sfi_go_idle_ack                   (sfi_go_idle_ack)                       //I: RX_CRD:

    ,.rx_crd_idle                       (rx_crd_idle)                           //O: RX_CRD:

    ,.rx_min_crds_sent                  (rx_min_crds_sent)                      //O: RX_CRD:

    ,.rx_hcrd_return_v                  (rx_hcrd_return_v)                      //I: RX_CRD: Req  credits to return
    ,.rx_hcrd_return_vc                 (rx_hcrd_return_vc)                     //I: RX_CRD
    ,.rx_hcrd_return_fc                 (rx_hcrd_return_fc)                     //I: RX_CRD
    ,.rx_hcrd_return_val                (rx_hcrd_return_val)                    //I: RX_CRD

    ,.rx_dcrd_return_v                  (rx_dcrd_return_v)                      //I: RX_CRD: Data credits to return
    ,.rx_dcrd_return_vc                 (rx_dcrd_return_vc)                     //I: RX_CRD:
    ,.rx_dcrd_return_fc                 (rx_dcrd_return_fc)                     //I: RX_CRD:
    ,.rx_dcrd_return_val                (rx_dcrd_return_val)                    //I: RX_CRD:

    ,.sfi_rx_hdr_crd_rtn_block_q        (sfi_rx_hdr_crd_rtn_block_q)            //I: RX_CRD: TX hdr  credit return backpressure
    ,.sfi_rx_data_crd_rtn_block_q       (sfi_rx_data_crd_rtn_block_q)           //I: RX_CRD: TX data credit return backpressure

    ,.sfi_rx_hdr_crd_rtn_valid_next     (sfi_rx_hdr_crd_rtn_valid_next)         //O: RX_CRD: RX hdr  credit return valid
    ,.sfi_rx_hdr_crd_rtn_vc_id_next     (sfi_rx_hdr_crd_rtn_vc_id_next)         //O: RX_CRD: RX hdr  credit return VC
    ,.sfi_rx_hdr_crd_rtn_fc_id_next     (sfi_rx_hdr_crd_rtn_fc_id_next)         //O: RX_CRD: RX hdr  credit return FC
    ,.sfi_rx_hdr_crd_rtn_value_next     (sfi_rx_hdr_crd_rtn_value_next)         //O: RX_CRD: RX hdr  credit return value

    ,.sfi_rx_data_crd_rtn_valid_next    (sfi_rx_data_crd_rtn_valid_next)        //O: RX_CRD: RX data credit return valid
    ,.sfi_rx_data_crd_rtn_vc_id_next    (sfi_rx_data_crd_rtn_vc_id_next)        //O: RX_CRD: RX data credit return VC
    ,.sfi_rx_data_crd_rtn_fc_id_next    (sfi_rx_data_crd_rtn_fc_id_next)        //O: RX_CRD: RX data credit return FC
    ,.sfi_rx_data_crd_rtn_value_next    (sfi_rx_data_crd_rtn_value_next)        //O: RX_CRD: RX data credit return value

    ,.rx_used_hcrds                     (rx_used_hcrds)                         //I: RX_CRD: Consumed credits
    ,.rx_used_dcrds                     (rx_used_dcrds)                         //I: RX_CRD:

    ,.rx_init_hcrds                     (rx_init_hcrds)                         //O: RX_CRD: Initial credits
    ,.rx_init_dcrds                     (rx_init_dcrds)                         //O: RX_CRD:

    ,.rx_ret_hcrds                      (rx_ret_hcrds)                          //O: RX_CRD: Returnable credits
    ,.rx_ret_dcrds                      (rx_ret_dcrds)                          //O: RX_CRD:
);

//-----------------------------------------------------------------------------------------------------
// SFI TX Interface

hqm_sfi_tx #(

`include "hqm_sfi_params_inst.sv"

) i_hqm_sfi_tx (

     .clk_gated                         (clk_gated)                             //I: TX:

    ,.rst_b                             (rst_b)                                 //I: TX:

    ,.tx_sm_connected                   (tx_sm_connected)                       //I: TX:

    ,.cfg_sif_vc_txmap                  (cfg_sif_vc_txmap)                      //I: TX:

    ,.agent_tx_v                        (agent_tx_v)                            //I: TX:
    ,.agent_tx_vc                       (agent_tx_vc)                           //I: TX:
    ,.agent_tx_fc                       (agent_tx_fc)                           //I: TX:
    ,.agent_tx_hdr_size                 (agent_tx_hdr_size)                     //I: TX:
    ,.agent_tx_hdr_has_data             (agent_tx_hdr_has_data)                 //I: TX:
    ,.agent_tx_hdr                      (agent_tx_hdr)                          //I: TX:
    ,.agent_tx_hdr_par                  (agent_tx_hdr_par)                      //I: TX:
    ,.agent_tx_data                     (agent_tx_data)                         //I: TX:
    ,.agent_tx_data_par                 (agent_tx_data_par)                     //I: TX:

    ,.agent_tx_ack                      (agent_tx_ack)                          //O: TX:

    ,.sfi_tx_hdr_block_q                (sfi_tx_hdr_block_q)                    //I: TX: RX requires TX to pause hdr
    ,.sfi_tx_data_block_q               (sfi_tx_data_block_q)                   //I: TX: RX requires TX to pause data

    ,.sfi_tx_hdr_next                   (sfi_tx_hdr_nexti)                      //O: TX: Master hdr  intf
    ,.sfi_tx_data_next                  (sfi_tx_data_nexti)                     //O: TX: Master data intf
);

//-----------------------------------------------------------------------------------------------------
// SFI RX Interface

hqm_sfi_rx #(

`include "hqm_sfi_params_inst.sv"

) i_hqm_sfi_rx (

     .clk                               (clk)                                   //I: RX:
    ,.clk_gated                         (clk_gated)                             //I: RX:

    ,.rst_b                             (rst_b)                                 //I: RX:

    ,.tx_sm_connected                   (tx_sm_connected)                       //I: RX: TX SM state is CONNECTED

    ,.cfg_idle_dly                      (cfg_idle_dly)                          //I: RX:
    ,.cfg_sif_vc_rxmap                  (cfg_sif_vc_rxmap)                      //I: RX:
    ,.cfg_sfi_rx_data_par_off           (cfg_sfi_rx_data_par_off)               //I: RX:

    ,.sfi_dfx_ctl                       (sfi_dfx_ctl)                           //I: RX:

    ,.force_sfi_blocks                  (force_sfi_blocks)                      //I: RX:

    ,.sfi_go_idle                       (sfi_go_idle)                           //I: RX: Request to assert blocks
    ,.sfi_go_idle_ack                   (sfi_go_idle_ack)                       //O: RX: Okay to clock gate

    ,.sfi_rx_hdr_q                      (sfi_rx_hdr_q)                          //I: RX: RX hdr  intf
    ,.sfi_rx_data_q                     (sfi_rx_data_q)                         //I: RX: RX data intf

    ,.sfi_rx_hdr_early_valid_q          (sfi_rx_hdr_early_valid_q)              //I: RX: Hdr  unblock
    ,.sfi_rx_data_early_valid_q         (sfi_rx_data_early_valid_q)             //I: RX: Data unblock

    ,.sfi_rx_hdr_block                  (sfi_rx_hdr_block)                      //O: RX: RX requires TX to pause hdr
    ,.sfi_rx_data_block                 (sfi_rx_data_block)                     //O: RX: RX requires TX to pause data

    ,.sfi_tx_hdr_crd_rtn_block          (sfi_tx_hdr_crd_rtn_block)              //O: RX: TX requires RX to pause hdr  credit returns
    ,.sfi_tx_data_crd_rtn_block         (sfi_tx_data_crd_rtn_block)             //O: RX: TX requires RX to pause data credit returns

    ,.agent_rx_hdr_v                    (agent_rx_hdr_v)                        //O: RX: Agent target hdr  interface
    ,.agent_rx_hdr_vc                   (agent_rx_hdr_vc)                       //O: RX:
    ,.agent_rx_hdr_fc                   (agent_rx_hdr_fc)                       //O: RX:
    ,.agent_rx_hdr_size                 (agent_rx_hdr_size)                     //O: RX:
    ,.agent_rx_hdr_has_data             (agent_rx_hdr_has_data)                 //O: RX:
    ,.agent_rx_hdr                      (agent_rx_hdr)                          //O: RX:
    ,.agent_rx_hdr_par                  (agent_rx_hdr_par)                      //O: RX:

    ,.agent_rx_data_v                   (agent_rx_data_v)                       //O: RX: Agent target data interface
    ,.agent_rx_data_vc                  (agent_rx_data_vc)                      //O: RX:
    ,.agent_rx_data_fc                  (agent_rx_data_fc)                      //O: RX:
    ,.agent_rx_data                     (agent_rx_data)                         //O: RX:
    ,.agent_rx_data_par                 (agent_rx_data_par)                     //O: RX:

    ,.set_sfi_rx_data_err               (set_sfi_rx_data_err)                   //O: RX:

    ,.sfi_rx_data_aux_hdr               (sfi_rx_data_aux_hdr)                   //O: RX:

    ,.sfi_rx_data_edb_err_synd          (sfi_rx_data_edb_err_synd)              //O: RX:
    ,.sfi_rx_data_poison_err_synd       (sfi_rx_data_poison_err_synd)           //O: RX:
    ,.sfi_rx_data_perr_synd             (sfi_rx_data_perr_synd)                 //O: RX:
);

//-----------------------------------------------------------------------------------------------------
// Idle logic

always_comb begin

 // RX is busy if the header, data, or credit channel interface regs are valid,
 // we are in the middle of a connect or disconnect request,
 // or we have unreturned credits.
 // If the cfg_sfi_idle_min_crds is set, we can clock gate if we've returned the minimum amount
 // of credits on each VC/FC. We'll still try to return all the credits, but if the credit block
 // signals are both asserted (potentially indicating that the upstream requestor is clock gating
 // after receiving a minimum amount of credits back on each VC/FC itself and w/o having received
 // all its outstanding credits back), we can clock gate w/o having returned all the credits.

 sfi_rx_busy = |{ sfi_rx_hdr_crd_rtn_valid_q
                , sfi_rx_data_crd_rtn_valid_q
                , sfi_rx_hdr_q.hdr_valid
                , sfi_rx_data_q.data_valid
                , sfi_rx_hdr_early_valid_q
                , sfi_rx_data_early_valid_q
                ,(sfi_rx_txglobal_q.txcon_req ^ sfi_rx_rxglobal_q.rxcon_ack)
                ,((cfg_sfi_idle_min_crds & sfi_rx_hdr_crd_rtn_block_q & sfi_rx_data_crd_rtn_block_q) ?
                  (~rx_min_crds_sent) : (~rx_crd_idle))
                };

 // TX is busy if the header, data, or credit channel interface regs are valid,
 // we are in the middle of a connect or disconnect request,
 // or we have outstanding credits.

 sfi_tx_busy = |{ sfi_tx_hdr_crd_rtn_valid_q
                , sfi_tx_data_crd_rtn_valid_q
                , sfi_tx_hdr_q.hdr_early_valid
                , sfi_tx_data_q.data_early_valid
                , sfi_tx_hdr_q.hdr_valid
                , sfi_tx_data_q.data_valid
                ,(sfi_tx_txglobal_q.txcon_req ^ sfi_tx_rxglobal_q.rxcon_ack)
                ,((cfg_sfi_idle_min_crds) ? (~tx_min_crds_rcvd) : tx_has_consumed_crds)
                };

 // Condition the RX idle indication on having received the ack for our "go idle" request.

 sfi_rx_idle = (~sfi_rx_busy) & sfi_go_idle_ack;

 sfi_tx_idle = (~sfi_tx_busy);

 // Only request to go idle if both the RX and TX are idle.
 // Note that if we are is the DISCONNECTED state and have not received a connect request the RX
 // and TX will be idle.

 sfi_go_idle = (~sfi_rx_busy) & (~sfi_tx_busy);

 // RX empty indication

 sfi_rx_rxglobal_next.rx_empty = agent_rxqs_empty & (~sfi_rx_busy);

end

//-----------------------------------------------------------------------------------------------------

always_comb begin

 noa_sfi = {rx_sm                                       // 135:133
           ,tx_sm                                       // 132:128

           ,sfi_go_idle                                 // 127
           ,sfi_go_idle_ack                             // 126
           ,agent_rxqs_empty                            // 125
           ,tx_hcrd_consume_v                           // 124
           ,tx_hcrd_consume_vc                          // 123
           ,tx_hcrd_consume_fc[1:0]                     // 122:121
           ,tx_hcrd_consume_val                         // 120

           ,tx_has_consumed_crds                        // 119
           ,tx_dcrd_consume_v                           // 118
           ,tx_dcrd_consume_vc                          // 117
           ,tx_dcrd_consume_fc[1:0]                     // 116:115
           ,tx_dcrd_consume_val[2:0]                    // 114:112

           ,agent_tx_ack                                // 111
           ,agent_tx_v                                  // 110
           ,agent_tx_vc[0]                              // 109
           ,agent_tx_fc[1:0]                            // 108:107
           ,agent_tx_hdr_size[2:0]                      // 106:104

           ,agent_tx_hdr.mem32.ttype[7:0]               // 103: 96

           ,sfi_rx_data_crd_rtn_block_q                 //  95
           ,sfi_rx_hdr_crd_rtn_block_q                  //  94
           ,sfi_tx_data_crd_rtn_block                   //  93
           ,sfi_tx_hdr_crd_rtn_block                    //  92
           ,agent_rx_data_v                             //  91
           ,agent_rx_data_vc[0]                         //  90
           ,agent_rx_data_fc[1:0]                       //  89: 88

           ,agent_rx_hdr_v                              //  87
           ,agent_rx_hdr_has_data                       //  86
           ,agent_rx_hdr_vc[0]                          //  85
           ,agent_rx_hdr_fc[1:0]                        //  84: 83
           ,agent_rx_hdr_size[2:0]                      //  82: 80

           ,agent_rx_hdr.mem32.ttype[7:0]               //  79: 72

           ,sfi_rx_data_block                           //  71
           ,sfi_rx_data_q.data_valid                    //  70
           ,sfi_rx_data_early_valid_q                   //  69
           ,sfi_rx_data_q.data_info_byte.vc_id[2:0]     //  68: 66
           ,sfi_rx_data_q.data_info_byte.fc_id[1:0]     //  65: 64

           ,sfi_rx_hdr_block                            //  63
           ,sfi_rx_hdr_early_valid_q                    //  62
           ,sfi_rx_hdr_q.hdr_valid                      //  61
           ,sfi_rx_hdr_q.hdr_info_bytes.vc_id[2:0]      //  60: 58
           ,sfi_rx_hdr_q.hdr_info_bytes.fc_id[1:0]      //  57: 56

           ,sfi_tx_data_block_q                         //  55
           ,sfi_tx_data_q.data_early_valid              //  54
           ,sfi_tx_data_q.data_valid                    //  53
           ,sfi_tx_data_q.data_info_byte.vc_id[2:0]     //  52: 50
           ,sfi_tx_data_q.data_info_byte.fc_id[1:0]     //  49: 48

           ,sfi_tx_hdr_block_q                          //  47
           ,sfi_tx_hdr_q.hdr_early_valid                //  46
           ,sfi_tx_hdr_q.hdr_valid                      //  45
           ,sfi_tx_hdr_q.hdr_info_bytes.vc_id[2:0]      //  44: 42
           ,sfi_tx_hdr_q.hdr_info_bytes.fc_id[1:0]      //  41: 40

           ,sfi_rx_data_crd_rtn_valid_q                 //  39
           ,sfi_rx_data_crd_rtn_vc_id_q[2:0]            //  38: 36
           ,sfi_rx_data_crd_rtn_fc_id_q[1:0]            //  35: 34
           ,sfi_rx_data_crd_rtn_value_q[1:0]            //  33: 32

           ,sfi_rx_hdr_crd_rtn_valid_q                  //  31
           ,sfi_rx_hdr_crd_rtn_vc_id_q[2:0]             //  30: 28
           ,sfi_rx_hdr_crd_rtn_fc_id_q[1:0]             //  27: 26
           ,sfi_rx_hdr_crd_rtn_value_q[1:0]             //  25: 24

           ,sfi_tx_data_crd_rtn_valid_q                 //  23
           ,sfi_tx_data_crd_rtn_vc_id_q[2:0]            //  22:20
           ,sfi_tx_data_crd_rtn_fc_id_q[1:0]            //  19: 18
           ,sfi_tx_data_crd_rtn_value_q[1:0]            //  17: 16

           ,sfi_tx_hdr_crd_rtn_valid_q                  //  15
           ,sfi_tx_hdr_crd_rtn_vc_id_q[2:0]             //  14: 12
           ,sfi_tx_hdr_crd_rtn_fc_id_q[1:0]             //  11: 10
           ,sfi_tx_hdr_crd_rtn_value_q[1:0]             //   9:  8

           ,rx_sm_connected                             //   7
           ,sfi_rx_rxglobal_q.rx_empty                  //   6
           ,sfi_rx_txglobal_q.txcon_req                 //   5
           ,sfi_rx_rxglobal_q.rxcon_ack                 //   4
           ,tx_sm_connected                             //   3
           ,sfi_tx_rxglobal_q.rx_empty                  //   2
           ,sfi_tx_txglobal_q.txcon_req                 //   1
           ,sfi_tx_rxglobal_q.rxcon_ack                 //   0
           };

end

//-----------------------------------------------------------------------------------------------------

endmodule // hqm_sfi

