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
// register instance that provides a CFG connection. Use paramter WIDTH to specify the nuymber of bits and parameter RESETABLE to 
//  indicate if the register should be reset to zero on rst_n=0;
//
// status : input to provide all status signals concatonated. THis will be read throught he cfg interface  READONLY
// 
// Ex.) connect all AW status output and debug into this for turnkey CFG access to all status
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
// 
module hqm_AW_status_wtcfg
  import hqm_AW_pkg::*;
#(
  parameter NUM_TARGET = 1
, parameter NUM_TARGETB2 = (NUM_TARGET==1) ? 1 : (AW_logb2(NUM_TARGET-1)+1)
 ) (
  input logic clk 
, input logic rst_n 
, input logic [( NUM_TARGET*32 ) -1 : 0] status
, input logic [( NUM_TARGET ) -1 : 0] cfg_write
, input logic [( NUM_TARGET ) -1 : 0] cfg_read
, input cfg_req_t cfg_req  
, output logic [( 1 ) -1 : 0] cfg_ack
, output logic [( 1 ) -1 : 0] cfg_err
, output logic [( 32 ) -1 : 0] cfg_rdata
) ;


logic [( NUM_TARGETB2 ) -1 : 0] cfg_readb2;
logic any_nc ;
hqm_AW_binenc_wrap #(
 .WIDTH (NUM_TARGET)
,.EWIDTH (NUM_TARGETB2)
) i_hqm_AW_binenc (
 .a ( cfg_read ) 
,.enc ( cfg_readb2 )
,.any ( any_nc) 
);

//------------------------------------------------------------------------------------------------------------------------------------------------
//Functional Code
logic any_cfg_write ;
logic any_cfg_read ;
always_comb begin

if ( NUM_TARGET == 1 ) begin
any_cfg_write = cfg_write ;
any_cfg_read = cfg_read ;
end
else begin
any_cfg_write = |cfg_write ;
any_cfg_read = |cfg_read ;
end

  //..............................................................................................................................................
  //default output values
  cfg_ack = ( any_cfg_write ) | ( any_cfg_read ) ;
  cfg_err = 1'd1 ;
  cfg_rdata = '0 ;

  //..............................................................................................................................................
  // CFG access
  if ( any_cfg_read ) begin
    cfg_err = 1'd0;
    cfg_rdata = status[ ( cfg_readb2 * 32 ) +: 32 ] ; 
  end


end

logic unused_nc ;       // avoid lint warning
assign unused_nc        = | { clk, rst_n, cfg_req } ;

endmodule
// 
