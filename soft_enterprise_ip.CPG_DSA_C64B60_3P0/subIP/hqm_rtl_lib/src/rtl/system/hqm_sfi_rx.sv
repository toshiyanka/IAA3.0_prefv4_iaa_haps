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

module hqm_sfi_rx

     import hqm_sfi_pkg::*;
#(

`include "hqm_sfi_params.sv"

) (
     input  logic                                       clk
    ,input  logic                                       clk_gated

    ,input  logic                                       rst_b

    //-------------------------------------------------------------------------------------------------

    ,input  logic                                       tx_sm_connected             // TX SM state is CONNECTED

    ,input  logic [2:0]                                 cfg_idle_dly
    ,input  logic [31:0]                                cfg_sif_vc_rxmap
    ,input  logic                                       cfg_sfi_rx_data_par_off

    ,input  logic [31:0]                                sfi_dfx_ctl

    ,input  logic                                       force_sfi_blocks            // For ResetPrep flow

    ,input  logic                                       sfi_go_idle                 // Request to assert blocks

    ,output logic                                       sfi_go_idle_ack             // Okay to clock gate

    //-------------------------------------------------------------------------------------------------
    // SFI Fabric to Agent Interface

    ,input  hqm_sfi_hdr_t                               sfi_rx_hdr_q
    ,input  hqm_sfi_rx_data_t                           sfi_rx_data_q

    ,input  logic                                       sfi_rx_hdr_early_valid_q    // Hdr  unblock
    ,input  logic                                       sfi_rx_data_early_valid_q   // Data unblock

    ,output logic                                       sfi_rx_hdr_block            // RX requires TX to pause hdr
    ,output logic                                       sfi_rx_data_block           // RX requires TX to pause data

    ,output logic                                       sfi_tx_hdr_crd_rtn_block    // TX requires RX to pause hdr  credit returns
    ,output logic                                       sfi_tx_data_crd_rtn_block   // TX requires RX to pause data credit returns

    //-------------------------------------------------------------------------------------------------
    // Agent Receive Interface

    ,output logic                                       agent_rx_hdr_v              // Agent receive hdr  push
    ,output logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]         agent_rx_hdr_vc
    ,output hqm_sfi_fc_id_t                             agent_rx_hdr_fc
    ,output logic [3:0]                                 agent_rx_hdr_size
    ,output logic                                       agent_rx_hdr_has_data
    ,output hqm_sfi_flit_header_t                       agent_rx_hdr
    ,output logic                                       agent_rx_hdr_par

    ,output logic                                       agent_rx_data_v             // Agent receive data push
    ,output logic [HQM_SFI_RX_DATA_VC_WIDTH-1:0]        agent_rx_data_vc
    ,output hqm_sfi_fc_id_t                             agent_rx_data_fc
    ,output logic [(HQM_SFI_RX_D*8)-1:0]                agent_rx_data
    ,output logic [HQM_SFI_RX_DATA_PARITY_WIDTH-1:0]    agent_rx_data_par

    //-------------------------------------------------------------------------------------------------
    // Errors

    ,output logic [3:0]                                 set_sfi_rx_data_err

    ,output hqm_sfi_flit_header_t                       sfi_rx_data_aux_hdr

    ,output logic [HQM_SFI_RX_DATA_EDB_WIDTH-1:0]       sfi_rx_data_edb_err_synd
    ,output logic [HQM_SFI_RX_DATA_POISON_WIDTH-1:0]    sfi_rx_data_poison_err_synd
    ,output logic [HQM_SFI_RX_DATA_PARITY_WIDTH-1:0]    sfi_rx_data_perr_synd
);

//-----------------------------------------------------------------------------------------------------

// Need to account for transactions and credit returns in flight before gating the clock.
// Need to cover the number of cycles required for the fabric to stall.
// Must be the larger of the associated TBN and RBN values.

localparam int unsigned STALL_CNT       = (HQM_SFI_RX_RBN > HQM_SFI_TX_TBN) ? (HQM_SFI_RX_RBN+1) : (HQM_SFI_TX_TBN+1);
localparam int unsigned STALL_CNT_WIDTH = $clog2(STALL_CNT)+1;

//-----------------------------------------------------------------------------------------------------

logic                                       sfi_rx_hdr_block_next;
logic                                       sfi_rx_hdr_block_q;
logic                                       sfi_rx_data_block_next;
logic                                       sfi_rx_data_block_q;
logic                                       sfi_rx_data_block_dly_q;

logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]         sfi_rx_data_saved_vc_next;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]         sfi_rx_data_saved_vc_q;
hqm_sfi_fc_id_t                             sfi_rx_data_saved_fc_next;
hqm_sfi_fc_id_t                             sfi_rx_data_saved_fc_q;

logic                                       sfi_tx_hdr_crd_rtn_block_q;
logic                                       sfi_tx_data_crd_rtn_block_q;

logic [STALL_CNT_WIDTH-1:0]                 stall_cnt_next;
logic [STALL_CNT_WIDTH-1:0]                 stall_cnt_q;

logic [10:0]                                idle_cnt_next;
logic [10:0]                                idle_cnt_q;

logic [2:0]                                 sfi_rx_hdr_vc;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]         sfi_rx_hdr_vc_mapped;
logic [2:0]                                 sfi_rx_data_vc;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]         sfi_rx_data_vc_mapped;

logic [HQM_SFI_RX_DATA_END_WIDTH-1:0]       sfi_rx_data_end_mask;

logic                                       sfi_rx_data_aux_perr_i;
logic                                       sfi_rx_data_aux_perr;
logic [HQM_SFI_RX_DATA_PARITY_WIDTH-1:0]    sfi_rx_data_aux_perr_synd;
logic                                       sfi_rx_data_edb_err;
logic                                       sfi_rx_data_poison_err;
logic                                       sfi_rx_data_perr;

logic [HQM_SFI_RX_DATA_PARITY_WIDTH-1:0]    sfi_rx_data_par;

hqm_sfi_flit_header_t                       sfi_rx_last_hdr_next;
hqm_sfi_flit_header_t                       sfi_rx_last_hdr_q;

logic                                       stop_and_scream_q;

//-----------------------------------------------------------------------------------------------------

always_comb begin

 sfi_rx_hdr_block_next      = sfi_rx_hdr_block_q;
 sfi_rx_data_block_next     = sfi_rx_data_block_q;

 sfi_rx_data_saved_vc_next  = sfi_rx_data_saved_vc_q;
 sfi_rx_data_saved_fc_next  = sfi_rx_data_saved_fc_q;

 // Map external to internal VC numbers
 // Note: Only supporting external VCs 0-7

 sfi_rx_hdr_vc              = sfi_rx_hdr_q.hdr_info_bytes.vc_id[2:0];
 sfi_rx_data_vc             = sfi_rx_data_q.data_info_byte.vc_id[2:0];

 sfi_rx_hdr_vc_mapped       = cfg_sif_vc_rxmap[{sfi_rx_hdr_vc,  2'd0} +: HQM_SFI_RX_HDR_VC_WIDTH];
 sfi_rx_data_vc_mapped      = cfg_sif_vc_rxmap[{sfi_rx_data_vc, 2'd0} +: HQM_SFI_RX_DATA_VC_WIDTH];

 agent_rx_hdr_v             = '0;
 agent_rx_hdr_vc            = sfi_rx_hdr_vc_mapped;
 agent_rx_hdr_fc            = sfi_rx_hdr_q.hdr_info_bytes.fc_id;
 agent_rx_hdr_size          = sfi_rx_hdr_q.hdr_info_bytes.hdr_size;
 agent_rx_hdr_has_data      = sfi_rx_hdr_q.hdr_info_bytes.has_data;
 agent_rx_hdr               = sfi_rx_hdr_q.header;

 // Adjust header parity for vc mapping

 agent_rx_hdr_par           = ^{sfi_rx_hdr_q.hdr_info_bytes.parity
                               ,sfi_rx_hdr_q.hdr_info_bytes.vc_id
                               ,sfi_rx_hdr_vc_mapped
                               };

 agent_rx_data_v            = '0;

 stall_cnt_next             = stall_cnt_q;

 sfi_go_idle_ack            = '0;

 idle_cnt_next              = idle_cnt_q;

 sfi_rx_data_end_mask       = '0;

 sfi_rx_last_hdr_next       = sfi_rx_last_hdr_q;

 for (int i=0; i<HQM_SFI_RX_DATA_END_WIDTH; i=i+1) begin

  if (sfi_rx_data_q.data_end[i]) begin

   sfi_rx_data_end_mask     = {HQM_SFI_RX_DATA_END_WIDTH{1'b1}}>>(HQM_SFI_RX_DATA_END_WIDTH-(i+1));

  end

 end

 // data_info_byte is only valid when data_start is asserted.
 // Save values on data_start==1 and use last saved values when data_start==0.

 if (sfi_rx_data_q.data_valid & sfi_rx_data_q.data_start) begin

  agent_rx_data_vc            = sfi_rx_data_vc_mapped;
  agent_rx_data_fc            = sfi_rx_data_q.data_info_byte.fc_id;

  sfi_rx_data_saved_vc_next   = sfi_rx_data_vc_mapped;
  sfi_rx_data_saved_fc_next   = sfi_rx_data_q.data_info_byte.fc_id;

 end else begin

  agent_rx_data_vc            = sfi_rx_data_saved_vc_q;
  agent_rx_data_fc            = sfi_rx_data_saved_fc_q;

 end

 agent_rx_data                = sfi_rx_data_q.data;

 sfi_rx_data_aux_perr_i       = sfi_rx_data_q.data_valid &
                                (^{sfi_rx_data_q.data_aux_parity
                                  ,sfi_rx_data_q.data_poison
                                  ,sfi_rx_data_q.data_edb
                                  ,sfi_rx_data_q.data_start
                                  ,sfi_rx_data_q.data_end
                                  ,sfi_rx_data_q.data_info_byte
                                  }
                                );

 sfi_rx_data_aux_perr         = sfi_rx_data_aux_perr_i & (~cfg_sfi_rx_data_par_off);

 // Header to be logged with a data aux parity error when reported as ieunc AER error
 // is the last header saved.

 sfi_rx_data_aux_hdr          = sfi_rx_last_hdr_q;

 sfi_rx_data_edb_err_synd     = (sfi_rx_data_end_mask & sfi_rx_data_q.data_edb);
 sfi_rx_data_edb_err          = (|sfi_rx_data_edb_err_synd);

 sfi_rx_data_poison_err_synd  = (sfi_rx_data_end_mask & sfi_rx_data_q.data_poison);
 sfi_rx_data_poison_err       = (|sfi_rx_data_poison_err_synd);

 // Fold the data_poison and data_edb bits into the corresponding parity bits.
 // Parity is per 2 DWs (64b) while poisoned and edb are per DW (32b).

 sfi_rx_data_perr_synd        = '0;
 sfi_rx_data_perr             = '0;

 // Fold a data_aux_parity error into parity bit 0 if SFI parity checking is disabled.

 sfi_rx_data_aux_perr_synd    = '0;
 sfi_rx_data_aux_perr_synd[0] = sfi_rx_data_aux_perr_i & cfg_sfi_rx_data_par_off;

 for (int i=0; i<HQM_SFI_RX_DATA_PARITY_WIDTH; i=i+1) begin

  sfi_rx_data_par[i] = (^sfi_rx_data_q.data[(i*64) +: 64]);

  if (^{sfi_rx_data_q.data_parity[i], sfi_rx_data_par[i]}) begin

   sfi_rx_data_perr_synd[i]   = (~cfg_sfi_rx_data_par_off);
   sfi_rx_data_perr           = (~cfg_sfi_rx_data_par_off);

  end

  agent_rx_data_par[i] = (|{sfi_rx_data_edb_err_synd[   (i*2) +: 2]
                           ,sfi_rx_data_poison_err_synd[(i*2) +: 2]
                           ,sfi_rx_data_perr_synd[       i        ]
                           ,sfi_rx_data_aux_perr_synd[   i        ]
                           }
                         ) ? (~sfi_rx_data_par[i]) : sfi_rx_data_par[i];

 end

 set_sfi_rx_data_err = {sfi_rx_data_aux_perr
                       ,sfi_rx_data_edb_err
                       ,sfi_rx_data_poison_err
                       ,sfi_rx_data_perr
                       };

 // Only accept transactions when the TX SM is in the CONNECTED state

 if (tx_sm_connected) begin // CONNECTED

  if (sfi_rx_hdr_q.hdr_valid) begin // Hdr valid

   agent_rx_hdr_v = ~(sfi_rx_data_aux_perr | stop_and_scream_q);

   // Save last header so it can be logged if we have a data aux parity error

   if (agent_rx_hdr_v) begin

    sfi_rx_last_hdr_next = sfi_rx_hdr_q.header;

   end

  end // Hdr valid

  if (sfi_rx_data_q.data_valid) begin // Data valid

   agent_rx_data_v = ~(stop_and_scream_q);

  end // Data valid

  // Block when idle so we can clock gate

  if (sfi_go_idle) begin

   // Programmable delay after go_idle request to when we start blocking

   if (idle_cnt_q[{1'd0, cfg_idle_dly} + 4'd3]) begin

    sfi_rx_hdr_block_next  = '1;
//  sfi_rx_data_block_next = '1;    // Never assert data_block; use hdr_block as RX throttle

   end else begin

    idle_cnt_next          = idle_cnt_q + 11'd1;

   end

  end

  // Unblock on early valid or if the go_idle deasserts.
  // Since the block regs load on the gated clock, we are guaranteed to have a
  // clock when the block regs deassert.

  if (sfi_rx_hdr_early_valid_q | sfi_rx_data_early_valid_q | (~sfi_go_idle)) begin

   sfi_rx_hdr_block_next  = '0;
   sfi_rx_data_block_next = '0;
   idle_cnt_next          = '0;

  end

  // If we're blocking, wait the required number of cycles for TX to stall
  // before allowing any clock gating.

//if (sfi_rx_hdr_block_q & sfi_rx_data_block_q) begin
  if (sfi_rx_hdr_block_q) begin

   if (stall_cnt_q == STALL_CNT[STALL_CNT_WIDTH-1:0]) begin

    // Okay to clock gate

    sfi_go_idle_ack  = '1;

   end else begin

    // Inc stall counter

    stall_cnt_next   = stall_cnt_q + {{(STALL_CNT_WIDTH-1){1'b0}}, 1'b1};

   end

  end else begin

   // Reset stall counter

   stall_cnt_next    = '0;

  end

 end // CONNECTED

end

// Need to drive the block signals for the credit returns as well.
// Using separate flops for them so they can move easily in the floorplan.

// Adding flop to delay data_block by one cycle for HDR_DATA_SEP==1

// Force the header and credit return block signals if force_sfi_blocks is asserted.
// Do not force the data block to prevent stalling in the middle of a packet.

always_ff @(posedge clk_gated or negedge rst_b) begin
 if (~rst_b) begin
  sfi_rx_hdr_block_q          <= '0;
  sfi_rx_data_block_q         <= '0;
  sfi_tx_hdr_crd_rtn_block_q  <= '0;
  sfi_tx_data_crd_rtn_block_q <= '0;
  sfi_rx_data_saved_vc_q      <= '0;
  sfi_rx_data_saved_fc_q      <= hqm_sfi_fc_id_t'('0);
  stall_cnt_q                 <= '0;
  idle_cnt_q                  <= '0;
  sfi_rx_last_hdr_q           <= '0;
  stop_and_scream_q           <= '0;
 end else begin
  sfi_rx_hdr_block_q          <= (sfi_dfx_ctl[16+ 4]) ? sfi_dfx_ctl[ 4] :
                                    (sfi_rx_hdr_block_next  | force_sfi_blocks);
  sfi_rx_data_block_q         <= (sfi_dfx_ctl[16+ 8]) ? sfi_dfx_ctl[ 8] :
                                     sfi_rx_data_block_next;
  sfi_tx_hdr_crd_rtn_block_q  <= (sfi_dfx_ctl[16+ 6]) ? sfi_dfx_ctl[ 6] :
                                    (sfi_rx_hdr_block_next  | force_sfi_blocks);
  sfi_tx_data_crd_rtn_block_q <= (sfi_dfx_ctl[16+10]) ? sfi_dfx_ctl[10] :
                                    (sfi_rx_data_block_next | force_sfi_blocks);
  sfi_rx_data_saved_vc_q      <=  sfi_rx_data_saved_vc_next;
  sfi_rx_data_saved_fc_q      <=  sfi_rx_data_saved_fc_next;
  stall_cnt_q                 <=  stall_cnt_next;
  idle_cnt_q                  <=  idle_cnt_next;
  stop_and_scream_q           <=  stop_and_scream_q | sfi_rx_data_aux_perr;
  sfi_rx_last_hdr_q           <=  sfi_rx_last_hdr_next;
 end
end

always_ff @(posedge clk or negedge rst_b) begin
 if (~rst_b) begin
  sfi_rx_data_block_dly_q     <= '0;
 end else begin
  sfi_rx_data_block_dly_q     <= sfi_rx_data_block_q;
 end
end

// Block signal outputs

always_comb begin

 sfi_rx_hdr_block          = sfi_rx_hdr_block_q;
 sfi_rx_data_block         = sfi_rx_data_block_dly_q;

 sfi_tx_hdr_crd_rtn_block  = sfi_tx_hdr_crd_rtn_block_q;
 sfi_tx_data_crd_rtn_block = sfi_tx_data_crd_rtn_block_q;

end

//-----------------------------------------------------------------------------------------------------

endmodule // hqm_sfi_rx

