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
//-----------------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------------
module hqm_chp_cial_tx_sync
import hqm_AW_pkg::*;
 (
  input  logic                              hqm_gated_clk
, input  logic                              hqm_gated_rst_n

, output logic                              idle
, input  logic                              rst_prep

, input  logic                              interrupt_w_req_v_nxt
, output logic                              interrupt_w_req_v_f
, output logic                              interrupt_w_req_valid

) ;

assign idle = ( interrupt_w_req_v_f == 1'b0 ) ;

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
  if (~hqm_gated_rst_n) begin
      interrupt_w_req_v_f <= 0;
  end else begin
      interrupt_w_req_v_f <= interrupt_w_req_v_nxt;
  end
end

assign interrupt_w_req_valid = rst_prep ? 1'b0 : interrupt_w_req_v_f;

endmodule

