//------------------------------------------------------------------------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------------------------------------------------------------------------
//
// buffer CFG req bus
//
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_AW_cfg_buf_req (
    input  logic                                   clk
  , input  logic                                   rst_n
  , input  logic                                   in_cfg_req_down_read
  , input  logic                                   in_cfg_req_down_write
  , input  logic [ ( 93 ) - 1 : 0 ]                in_cfg_req_down
  , output logic                                   out_cfg_req_down_read
  , output logic                                   out_cfg_req_down_write
  , output logic [ ( 93 ) - 1 : 0 ]                out_cfg_req_down
) ;

logic cfg_req_down_read_f , cfg_req_down_read_nxt ;
logic cfg_req_down_write_f , cfg_req_down_write_nxt ;
logic [ ( 93 ) - 1 : 0 ] cfg_req_down_f , cfg_req_down_nxt ;
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cfg_req_down_read_f <= '0 ;
    cfg_req_down_write_f <= '0 ;
    cfg_req_down_f <= '0 ;
  end 
  else begin
    cfg_req_down_read_f <= cfg_req_down_read_nxt ;
    cfg_req_down_write_f <= cfg_req_down_write_nxt ;
    cfg_req_down_f <= cfg_req_down_nxt ;
  end
end

assign cfg_req_down_read_nxt = in_cfg_req_down_read ;
assign cfg_req_down_write_nxt = in_cfg_req_down_write ;
assign cfg_req_down_nxt = in_cfg_req_down ;

assign out_cfg_req_down_read = cfg_req_down_read_f ;
assign out_cfg_req_down_write = cfg_req_down_write_f ;
assign out_cfg_req_down = cfg_req_down_f ;

endmodule
