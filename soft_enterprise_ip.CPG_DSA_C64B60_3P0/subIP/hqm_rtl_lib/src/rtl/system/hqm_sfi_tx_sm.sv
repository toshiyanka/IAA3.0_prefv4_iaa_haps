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

module hqm_sfi_tx_sm

     import hqm_sfi_pkg::*;
#(

`include "hqm_sfi_params.sv"

) (
     input  logic                   clk_gated
    ,input  logic                   clk_valid

    ,input  logic                   rst_b

    //-------------------------------------------------------------------------------------------------

    ,input  logic                   config_done_sync

    ,input  logic                   cfg_dbgbrk1

    ,input  logic                   tx_discon_req

    ,input  logic                   rxcon_ack_q                 // ConnectDisconnect acknowledge
    ,input  logic                   rxdiscon_nack_q             // Disconnect rejection

    ,output logic                   txcon_req_next              // Connect/Disconnect request

    ,output logic                   tx_sm_connected             // TX SM state is CONNECTED
    ,output logic                   tx_sm_disconnected          // TX SM state is DISCONNECTED

    ,output hqm_sfi_tx_state_t      tx_sm
);

//-----------------------------------------------------------------------------------------------------

hqm_sfi_tx_state_t      tx_sm_next;
hqm_sfi_tx_state_t      tx_sm_q;

//-----------------------------------------------------------------------------------------------------
// SFI TX Connection SM
//
// Reset state is DISCONNECTED.

always_comb begin

 tx_sm_next       = tx_sm_q;

 txcon_req_next   = '0;

 case (1'b1)

  //--------------------------------------------------------------------------------------------------
  tx_sm_q[HQM_SFI_TX_STATE_DISCONNECTED_BIT]: begin // DISCONNECTED

   // Start connect sequence by asserting txcon_req_next if we are not being held in disconnect,
   // then move to the CONNECTING state.
   // Belt and suspenders: wait until we're sure the clock is valid as well...

   if (clk_valid & config_done_sync & (~cfg_dbgbrk1)) begin // Not held in disconnect

    txcon_req_next   = '1;

    tx_sm_next       = HQM_SFI_TX_STATE_CONNECTING;

   end // Not held in disconnect

  end // DISCONNECTED

  //--------------------------------------------------------------------------------------------------
  tx_sm_q[HQM_SFI_TX_STATE_CONNECTING_BIT]: begin // CONNECTING

   // Keep txcon_req_next asserted and move to the CONNECTED state once rxcon_ack_q asserts.

   txcon_req_next = '1;

   if (rxcon_ack_q) begin

    tx_sm_next    = HQM_SFI_TX_STATE_CONNECTED;

   end

  end // CONNECTING

  //--------------------------------------------------------------------------------------------------
  tx_sm_q[HQM_SFI_TX_STATE_CONNECTED_BIT]: begin // CONNECTED

   // Normal CONNECTED state.
   // Keep txcon_req_next asserted, only move to DISCONNECTING state if there is a disconnect request.
   // Handle a drop in the rxcon_ack (had to be due to an early reset of the RX) by moving to the
   // HARD_DISCONNECT state.

   if (tx_discon_req) begin

    txcon_req_next = '0;

    tx_sm_next     = HQM_SFI_TX_STATE_DISCONNECTING;

   end // Discon req

   else if (rxcon_ack_q) begin // RX ack

    txcon_req_next = '1;

   end // RX ack

   else begin // RX dropped ack

    txcon_req_next = '0;

    tx_sm_next     = HQM_SFI_TX_STATE_HARD_DISCONNECT;

   end // RX dropped ack

  end //CONNECTED

  //--------------------------------------------------------------------------------------------------
  tx_sm_q[HQM_SFI_TX_STATE_DISCONNECTING_BIT]: begin // DISCONNECTING

   // Allow default deassertion of txcon_req_next, signaling a disconnect request.
   // If rxdiscon_nack_q asserts, need to reassert txcon_req_next and move back to CONNECTED state.
   // If rxcon_ack_q deasserts, can move to the DISCONNECTED state.

   if (rxcon_ack_q & rxdiscon_nack_q) begin // Disconnect nack

    txcon_req_next = '1;

    tx_sm_next     = HQM_SFI_TX_STATE_CONNECTED;

   end // Disconnect nack

   else if (~rxcon_ack_q) begin // Disconnect ack

    tx_sm_next     = HQM_SFI_TX_STATE_DISCONNECTED;

   end // Disconnect ack

  end // DISCONNECTING

  //--------------------------------------------------------------------------------------------------
  tx_sm_q[HQM_SFI_TX_STATE_HARD_DISCONNECT_BIT]: begin // HARD_DISCONNECT

   // Just hang out here until reset

   txcon_req_next = '0;

  end // HARD_DISCONNECT

  //--------------------------------------------------------------------------------------------------
  default: begin // Should never get here

   tx_sm_next = tx_sm_q;

  end

 endcase

end

always_ff @(posedge clk_gated or negedge rst_b) begin
 if (~rst_b) begin
  tx_sm_q <= HQM_SFI_TX_STATE_DISCONNECTED;
 end else begin
  tx_sm_q <= tx_sm_next;
 end
end

always_comb begin

 tx_sm_connected    = tx_sm_q[HQM_SFI_TX_STATE_CONNECTED_BIT];
 tx_sm_disconnected = tx_sm_q[HQM_SFI_TX_STATE_DISCONNECTED_BIT];

 tx_sm              = tx_sm_q;

end

endmodule // hqm_sfi_tx_sm

