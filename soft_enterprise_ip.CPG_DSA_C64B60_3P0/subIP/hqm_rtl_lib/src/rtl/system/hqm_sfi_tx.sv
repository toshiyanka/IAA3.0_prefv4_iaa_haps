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

module hqm_sfi_tx

     import hqm_sfi_pkg::*;
#(

`include "hqm_sfi_params.sv"

) (
     input  logic                                           clk_gated

    ,input  logic                                           rst_b

    //-------------------------------------------------------------------------------------------------

    ,input  logic                                           tx_sm_connected         // TX SM state is CONNECTED

    ,input  logic [31:0]                                    cfg_sif_vc_txmap

    //-------------------------------------------------------------------------------------------------
    // Agent Transmit Interface

    ,input  logic                                           agent_tx_v
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
    // SFI Agent to Fabric Transmit Interface

    ,input  logic                                           sfi_tx_hdr_block_q      // RX requires TX to pause hdr
    ,input  logic                                           sfi_tx_data_block_q     // RX requires TX to pause data

    ,output hqm_sfi_hdr_t                                   sfi_tx_hdr_next         // A2F hdr  intf
    ,output hqm_sfi_tx_data_t                               sfi_tx_data_next        // A2F data intf
);

//-----------------------------------------------------------------------------------------------------

logic                                           hdr_early_valid_q;

logic [4:0]                                     agent_tx_vc_mapped;

hqm_sfi_tx_data_t                               sfi_tx_data_out_next;
hqm_sfi_tx_data_t                               sfi_tx_data_out_q;

logic [2:0]                                     agent_tx_data_cnt_next;
logic [2:0]                                     agent_tx_data_cnt_q;

//-----------------------------------------------------------------------------------------------------

localparam DATA_BUS_1_BEAT_DWS = HQM_SFI_TX_D>>2;        // 1B width granularity, so DWs = width/4B
localparam DATA_BUS_2_BEAT_DWS = DATA_BUS_1_BEAT_DWS*2;
localparam DATA_BUS_3_BEAT_DWS = DATA_BUS_1_BEAT_DWS*3;
localparam DATA_BUS_4_BEAT_DWS = DATA_BUS_1_BEAT_DWS*4;
localparam DATA_BUS_5_BEAT_DWS = DATA_BUS_1_BEAT_DWS*5;
localparam DATA_BUS_6_BEAT_DWS = DATA_BUS_1_BEAT_DWS*6;
localparam DATA_BUS_7_BEAT_DWS = DATA_BUS_1_BEAT_DWS*7;

//-----------------------------------------------------------------------------------------------------
// Register the agent to fabric interfaces

// Note: only supporting external VCs 0-7 w/ the 3b of cfg

assign agent_tx_vc_mapped = {2'd0, cfg_sif_vc_txmap[{agent_tx_vc, 2'd0} +: 3]};

always_comb begin

 sfi_tx_hdr_next        = '0;
 sfi_tx_data_out_next   = '0;

 agent_tx_ack           = '0;

 agent_tx_data_cnt_next = agent_tx_data_cnt_q;

 // Can only output a transaction when TX SM is in the CONNECTED state

 if (agent_tx_v & tx_sm_connected) begin // Trans valid

  if (|agent_tx_data_cnt_q) begin // Subsequent beats of transaction

   agent_tx_data_cnt_next = agent_tx_data_cnt_q - 3'd1;

   sfi_tx_data_out_next.data_valid           = '1;
   sfi_tx_data_out_next.data_info_byte.vc_id = agent_tx_vc_mapped;
   sfi_tx_data_out_next.data_info_byte.fc_id = agent_tx_fc;
   sfi_tx_data_out_next.data_parity          = agent_tx_data_par;
   sfi_tx_data_out_next.data                 = agent_tx_data;
   sfi_tx_data_out_next.data_poison          = '0;                      // Currently only set by error inject
   sfi_tx_data_out_next.data_edb             = '0;                      // Currently only set by error inject
   sfi_tx_data_out_next.data_start           = '0;

   // Ack the transaction

   agent_tx_ack = '1;

   sfi_tx_data_out_next.data_aux_parity = ^{sfi_tx_data_out_next.data_info_byte
                                           ,sfi_tx_data_out_next.data_poison
                                           ,sfi_tx_data_out_next.data_edb
                                           ,sfi_tx_data_out_next.data_start
                                           ,sfi_tx_data_out_next.data_end
                                           };

   if (agent_tx_data_cnt_q == 3'd1) begin

     for (int i=1; i<=HQM_SFI_TX_DATA_END_WIDTH; i=i+1) begin

      sfi_tx_data_out_next.data_end[i-1] = (agent_tx_hdr.mem32.len == i[9:0]);

     end

   end

  end // Subsequent beats of transaction

  else begin // First beat of transaction

   sfi_tx_hdr_next.hdr_early_valid       = '1;
   sfi_tx_data_out_next.data_early_valid = agent_tx_hdr_has_data;

   if (hdr_early_valid_q & ~sfi_tx_hdr_block_q & (~agent_tx_hdr_has_data |
           (sfi_tx_data_out_q.data_early_valid & ~sfi_tx_data_block_q))) begin // Send

    sfi_tx_hdr_next.hdr_valid                = '1;
    sfi_tx_hdr_next.hdr_info_bytes.vc_id     = agent_tx_vc_mapped;
    sfi_tx_hdr_next.hdr_info_bytes.fc_id     = agent_tx_fc;
    sfi_tx_hdr_next.hdr_info_bytes.hdr_size  = agent_tx_hdr_size;
    sfi_tx_hdr_next.hdr_info_bytes.has_data  = agent_tx_hdr_has_data;
    sfi_tx_hdr_next.header                   = agent_tx_hdr;

    // Need to adjust parity for the mapped vc

    sfi_tx_hdr_next.hdr_info_bytes.parity    = ^{agent_tx_hdr_par
                                                ,agent_tx_vc
                                                ,agent_tx_vc_mapped
                                                };

    if (agent_tx_hdr_has_data) begin // Has data

     sfi_tx_data_out_next.data_valid           = '1;
     sfi_tx_data_out_next.data_info_byte.vc_id = agent_tx_vc_mapped;
     sfi_tx_data_out_next.data_info_byte.fc_id = agent_tx_fc;
     sfi_tx_data_out_next.data_parity          = agent_tx_data_par;
     sfi_tx_data_out_next.data                 = agent_tx_data;
     sfi_tx_data_out_next.data_poison          = '0;                       // Currently only set by error inject
     sfi_tx_data_out_next.data_edb             = '0;                       // Currently only set by error inject
     sfi_tx_data_out_next.data_start           = '1;

     if (agent_tx_hdr.mem32.len <= 10'd8) begin

      for (int i=1; i<=HQM_SFI_TX_DATA_END_WIDTH; i=i+1) begin

       sfi_tx_data_out_next.data_end[i-1] = (agent_tx_hdr.mem32.len == i[9:0]);

      end

     end

     // Ack the transaction

     agent_tx_ack = '1;

     sfi_tx_data_out_next.data_aux_parity = ^{sfi_tx_data_out_next.data_info_byte
                                             ,sfi_tx_data_out_next.data_poison
                                             ,sfi_tx_data_out_next.data_edb
                                             ,sfi_tx_data_out_next.data_start
                                             ,sfi_tx_data_out_next.data_end
                                             };

     // This is a count of the number of additional (other than the first) data bus beats
     // required to get all the data for the transaction with data.

     agent_tx_data_cnt_next = (agent_tx_hdr.mem32.len > DATA_BUS_7_BEAT_DWS[9:0]) ? 3'd7 :
                             ((agent_tx_hdr.mem32.len > DATA_BUS_6_BEAT_DWS[9:0]) ? 3'd6 :
                             ((agent_tx_hdr.mem32.len > DATA_BUS_5_BEAT_DWS[9:0]) ? 3'd5 :
                             ((agent_tx_hdr.mem32.len > DATA_BUS_4_BEAT_DWS[9:0]) ? 3'd4 :
                             ((agent_tx_hdr.mem32.len > DATA_BUS_3_BEAT_DWS[9:0]) ? 3'd3 :
                             ((agent_tx_hdr.mem32.len > DATA_BUS_2_BEAT_DWS[9:0]) ? 3'd2 :
                             ((agent_tx_hdr.mem32.len > DATA_BUS_1_BEAT_DWS[9:0]) ? 3'd1 : 3'd0))))));


    end // Has data

    else begin // No data

     // Ack the transaction

     agent_tx_ack = '1;

    end // No data

   end // Send

  end // First beat of transaction

 end // Trans valid

end

// Acc Ref WG wants fixed 1 cycle latency between hdr and data
// so delaying data output with reg.

always_ff @(posedge clk_gated or negedge rst_b) begin
 if (~rst_b) begin

  hdr_early_valid_q   <= '0;
  sfi_tx_data_out_q   <= '0;

  agent_tx_data_cnt_q <= '0;

 end else begin

  hdr_early_valid_q   <= sfi_tx_hdr_next.hdr_early_valid;

  agent_tx_data_cnt_q <= agent_tx_data_cnt_next;

  if (~sfi_tx_data_block_q) begin
   sfi_tx_data_out_q.data_valid      <= sfi_tx_data_out_next.data_valid;
   sfi_tx_data_out_q.data_aux_parity <= sfi_tx_data_out_next.data_aux_parity;
   sfi_tx_data_out_q.data_poison     <= sfi_tx_data_out_next.data_poison;
   sfi_tx_data_out_q.data_edb        <= sfi_tx_data_out_next.data_edb;
   sfi_tx_data_out_q.data_start      <= sfi_tx_data_out_next.data_start;
   sfi_tx_data_out_q.data_end        <= sfi_tx_data_out_next.data_end;
   sfi_tx_data_out_q.data_parity     <= sfi_tx_data_out_next.data_parity;
   sfi_tx_data_out_q.data_info_byte  <= sfi_tx_data_out_next.data_info_byte;
   sfi_tx_data_out_q.data            <= sfi_tx_data_out_next.data;
  end

  // Must still pass the data_early_valid indication when blocked

  sfi_tx_data_out_q.data_early_valid <= sfi_tx_data_out_next.data_early_valid;

 end
end

always_comb begin

 // Zero out the data output next if the block is asserted.
 // Must still pass the early_valid indication when blocked.

 if (sfi_tx_data_block_q) begin

  sfi_tx_data_next = '0;

 end else begin

  sfi_tx_data_next = sfi_tx_data_out_q;

 end

 sfi_tx_data_next.data_early_valid = sfi_tx_data_out_q.data_early_valid;

end

endmodule // hqm_sfi_tx


