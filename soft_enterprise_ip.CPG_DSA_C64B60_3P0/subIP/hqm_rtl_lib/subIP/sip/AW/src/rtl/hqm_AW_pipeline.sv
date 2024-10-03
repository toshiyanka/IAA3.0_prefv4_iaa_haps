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
// single pipeline register instance with valid and data ports. pipline data width is specified by parameter
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_AW_pipeline
  import hqm_AW_pkg::*;
#(
  parameter WIDTH = 8
 ) (
  input logic clk
, input logic rst_n
, input logic [ ( 1 ) -1 : 0] in_v
, input logic [ ( WIDTH ) -1 : 0] in_data
, input logic [ ( 1 ) -1 : 0] out_v
, input logic [ ( WIDTH ) -1 : 0] out_data
) ;

//------------------------------------------------------------------------------------------------------------------------------------------------
//Instances & Registers
logic [ ( 1 ) -1 : 0] reg_v_f ;
logic [ ( WIDTH ) -1 : 0] reg_data_f ;
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    reg_v_f <= 0 ;
  end
  else begin
    reg_v_f <= in_v ;
  end
end

always_ff @(posedge clk)
begin
    reg_data_f <= in_v ? in_data : reg_data_f ;
end

//------------------------------------------------------------------------------------------------------------------------------------------------
assign out_v = reg_v_f ;
assign out_data = reg_data_f ;

endmodule
