//------------------------------------------------------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
// This modules ensure that incoming data qualified via data_v pulse is transfered into dst_clk domain before next request is accepted.
// NOTE that if the rate of requests (data_v) is faster than time it takes to observe the data in dst_clk domain some requests will be lost.
// The above mentioned behavior is acceptable for this design and this behavior has been reviewd for this project. 
// Any design using this module should put note in RDL of this behavior. The suggested programming model is write followed by read before issuing
// another write.
//
module hqm_AW_async_data
  import hqm_AW_pkg::*;
#(
  parameter WIDTH = 32
 ,parameter RST_DEFAULT = 0
 ) (
  input  logic      src_clk
, input  logic      src_rst_n
, input  logic      dst_clk
, input  logic      dst_rst_n

, input  logic [( WIDTH ) -1 : 0] data
, input  logic                    data_v
, output logic [( WIDTH ) -1 : 0] data_f

) ;

//-----------------------------------------------------------------------------------------------------
logic [( WIDTH ) -1 : 0] dst_data_f, dst_data_nxt;
logic [( WIDTH ) -1 : 0]  out_data;
logic out_v ;
logic req_active_nc;
//-----------------------------------------------------------------------------------------------------
hqm_AW_async_one_pulse_reg #(
      .WIDTH        (WIDTH) 
) i_async_one_pulse_reg (
      .src_clk      (src_clk)
     ,.src_rst_n    (src_rst_n)
     ,.dst_clk      (dst_clk)
     ,.dst_rst_n    (dst_rst_n)

     ,.in_v         (data_v)
     ,.in_data      (data)
     ,.out_v        (out_v)
     ,.out_data     (out_data)

     ,.req_active   (req_active_nc)
);
//-----------------------------------------------------------------------------------------------------
assign dst_data_nxt = (out_v) ? out_data : dst_data_f;

always_ff @(posedge dst_clk or negedge dst_rst_n) begin
  if (~dst_rst_n) begin
    dst_data_f      <= RST_DEFAULT; 
  end else begin
    dst_data_f      <= dst_data_nxt;
  end
end

assign data_f       = dst_data_f;

endmodule // AW_async_data
