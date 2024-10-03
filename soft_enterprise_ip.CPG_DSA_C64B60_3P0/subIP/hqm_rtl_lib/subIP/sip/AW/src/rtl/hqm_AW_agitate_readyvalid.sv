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
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_AW_agitate_readyvalid
  import hqm_AW_pkg::*;
#(
  parameter SEED = 1
) (
    input  logic                        clk
  , input  logic                        rst_n
  , input  logic [ (32 ) -1 : 0 ]       control
  , input  logic                        enable
  , input  logic                        up_v
  , output logic                        up_ready
  , output logic                        down_v
  , input  logic                        down_ready
);

logic in_agitate_value ;
logic in_data ;
logic in_stall_trigger ;
logic out_data ;
hqm_AW_agitate #(
.SEED(SEED)
) i_hqm_AW_agitate (
 .clk ( clk )
,.rst_n ( rst_n )
,.control ( control )
,.in_agitate_value ( in_agitate_value )
,.in_data ( in_data )
,.in_stall_trigger ( in_stall_trigger )
,.out_data ( out_data )
);
assign in_data          = 1'b1 ;
assign in_agitate_value = ~enable ;
assign in_stall_trigger = up_v & up_ready & out_data ;
assign up_ready         = down_ready & out_data ;
assign down_v           = up_v & out_data ;

endmodule
