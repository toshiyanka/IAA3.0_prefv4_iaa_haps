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
// AW_spare_ports
//
// This module is responsible for implementing a set of 2 registered spare input ports and 2 registered
// spare output ports for inter-partition signaling.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_spare_ports (

     input  wire            clk
    ,input  wire            rst_n
    ,input  wire    [1:0]   spare_in
    ,output wire    [1:0]   spare_out
);

logic   [1:0]   spare_in_q;
logic   [1:0]   spare_out_q;

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  spare_in_q  <= '0;
  spare_out_q <= '0;
 end else begin
  spare_in_q  <= spare_in;
  spare_out_q <= spare_in_q;
 end
end

assign spare_out = spare_out_q;

endmodule // hqm_AW_spare_ports

