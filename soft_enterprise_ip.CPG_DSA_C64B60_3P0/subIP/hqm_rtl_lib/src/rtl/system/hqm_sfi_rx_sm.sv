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

module hqm_sfi_rx_sm

     import hqm_sfi_pkg::*;
#(

`include "hqm_sfi_params.sv"

) (
     input  logic                   clk_gated
    ,input  logic                   clk_valid

    ,input  logic                   rst_b

    //-------------------------------------------------------------------------------------------------

    ,input  logic                   cfg_dbgbrk2
    ,input  logic                   cfg_dbgbrk3

    ,input  logic                   config_done_sync

    ,input  logic                   rx_deny_discon              // Deny disconnect

    ,input  logic                   txcon_req_q                 // Connect/Disconnect request

    ,output logic                   rxcon_ack_next              // Connect/Disconnect acknowledge
    ,output logic                   rxdiscon_nack_next          // Disconnect rejection

    ,output logic                   rx_sm_connected             // RX SM state is CONNECTED
    ,output logic                   rx_sm_disconnected          // RX SM state is DISCONNECTED

    ,output hqm_sfi_rx_state_t      rx_sm
);

//-----------------------------------------------------------------------------------------------------

hqm_sfi_rx_state_t      rx_sm_next;
hqm_sfi_rx_state_t      rx_sm_q;

//-----------------------------------------------------------------------------------------------------
// SFI RX Connection SM
//
// Reset state is DISCONNECTED.

always_comb begin

 rx_sm_next         = rx_sm_q;

 rxcon_ack_next     = '0;
 rxdiscon_nack_next = '0;

 case (1'b1)

  //--------------------------------------------------------------------------------------------------
  rx_sm_q[HQM_SFI_RX_STATE_DISCONNECTED_BIT]: begin // DISCONNECTED

   // Wait until txcon_req_q is asserted and then move to CONNECTED state and assert rxcon_ack_next.
   // Belt and suspenders: wait until we're sure the clock is valid as well...

   if (txcon_req_q & clk_valid & config_done_sync & (~cfg_dbgbrk2)) begin

    rxcon_ack_next  = '1;

    rx_sm_next      = HQM_SFI_RX_STATE_CONNECTED;

   end

  end // DISCONNECTED

  //--------------------------------------------------------------------------------------------------
  rx_sm_q[HQM_SFI_RX_STATE_CONNECTED_BIT]: begin // CONNECTED

   // Normal CONNECTED state.
   // Keep rxcon_ack_next asserted unless we get a disconnect request.

   rxcon_ack_next = '1;

   if ((~txcon_req_q) & (~cfg_dbgbrk3)) begin // Disconnect request

    // If we need to deny the disconnect request (why?), must keep rxcon_ack_next asserted and also
    // assert rxdiscon_nack_next and move to the DENY state.

    if (rx_deny_discon) begin // nack

     rxdiscon_nack_next = '1;

     rx_sm_next         = HQM_SFI_RX_STATE_DENY;

    end //nack

    // We ack the disconnect request by deasserting rxcon_ack_next and moving to the DISCONNECTED state.

    else begin // ack

     rxcon_ack_next = '0;

     rx_sm_next     = HQM_SFI_RX_STATE_DISCONNECTED;

    end // ack

   end // Disconnect request

  end // CONNECTED

  //--------------------------------------------------------------------------------------------------
  rx_sm_q[HQM_SFI_RX_STATE_DENY_BIT]: begin // DENY

   // Need to keep both rxcon_ack_next and rxdiscon_nack_next asserted until txcon_req_q reasserts,
   // then we can deassert rxdiscon_nack_next and move back to the CONNECTED state.

   rxcon_ack_next     = '1;
   rxdiscon_nack_next = '1;

   if (txcon_req_q) begin

    rxdiscon_nack_next = '0;

    rx_sm_next         = HQM_SFI_RX_STATE_CONNECTED;

   end

  end // DENY

  //--------------------------------------------------------------------------------------------------
  default: begin // Should never get here

   rx_sm_next = rx_sm_q;

  end

 endcase

end

always_ff @(posedge clk_gated or negedge rst_b) begin
 if (~rst_b) begin
  rx_sm_q <= HQM_SFI_RX_STATE_DISCONNECTED;
 end else begin
  rx_sm_q <= rx_sm_next;
 end
end

always_comb begin

 rx_sm_connected    = rx_sm_q[HQM_SFI_RX_STATE_CONNECTED_BIT];
 rx_sm_disconnected = rx_sm_q[HQM_SFI_RX_STATE_DISCONNECTED_BIT];

 rx_sm              = rx_sm_q;

end

endmodule // hqm_sfi_rx_sm

