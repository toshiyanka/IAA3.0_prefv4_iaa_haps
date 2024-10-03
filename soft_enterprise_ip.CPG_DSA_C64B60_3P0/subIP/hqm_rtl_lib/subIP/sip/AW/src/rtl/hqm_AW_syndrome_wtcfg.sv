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
// hqm_AW_syndrome_wtcfg
//
// syndrome regsiter to capture and hold data when triggered. Includes configuration register wthh CFG interface to indicate when
//  data is captured and to reset the syndrome contents
//
// WIDTH paramter specifies the number of data bits of syndrome. 
// AW_syndrome uses an additional bit CAPTURED to indicate when a syndrome is captured. 
// to fit in the 32b CFG space then WIDTH should be set to (n*32)-1 depending on the number of syndrom bits needed
// THe captures bit is always the MSB bit of the CFG access 
//   ex.) 31b of syndrome data[30:0] with CAPTURE indication at bit 31 when CFG access
//   ex.) 63b of syndrome data[62:0] with CAPTURE indication at bit 63 (or word2 bit 31) when CFG access
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_AW_syndrome_wtcfg import hqm_AW_pkg::*; #(
  parameter WIDTH =31
, parameter NUM_TARGET = (WIDTH+31)/32
//................................................................................................................................................
, parameter WIDTHB2 = (AW_logb2(WIDTH-1)+1)
) (
  input logic clk
, input logic rst_n

, input logic rst_prep

, input logic [( 1 ) -1 :  0] capture_v
, input logic [( WIDTH ) -1 : 0] capture_data
, output logic [( WIDTH+1 ) -1 : 0] syndrome_data

, input logic [( NUM_TARGET ) -1 : 0] cfg_write
, input logic [( NUM_TARGET ) -1 : 0] cfg_read
, input cfg_req_t cfg_req
, output logic [( 1 ) -1 : 0] cfg_ack
, output logic [( 1 ) -1 : 0] cfg_err
, output logic [( 32 ) -1 : 0] cfg_rdata
) ;

//------------------------------------------------------------------------------------------------------------------------------------------------
//Instances & Registers
logic [ ( 1 + WIDTH ) -1 : 0 ] reg_f , reg_nxt ;
logic                          cfg_ack_int ;
logic                          cfg_err_int ;
logic [ ( 32 ) -1 : 0 ]        cfg_rdata_int ;

logic wire_capture_v ;
hqm_AW_register_enable_wtcfg #(
  .WIDTH ( WIDTH+1 )
) i_hqm_AW_register_wtcfg (
  .clk ( clk )
, .rst_n ( rst_n )
, .rst_prep ( rst_prep )
, .reg_v ( wire_capture_v )
, .reg_nxt ( reg_nxt )
, .reg_f ( reg_f )
, .cfg_write ( {NUM_TARGET{1'b0}} )
, .cfg_read ( cfg_read )
, .cfg_req ( cfg_req )
, .cfg_ack ( cfg_ack_int )
, .cfg_err ( cfg_err_int )
, .cfg_rdata ( cfg_rdata_int )
);

//-----------------------------------------------------------------------------------------------------------------------------
localparam CAPTURED = WIDTH + 0;
localparam CAPTURED_CFG_BIT = WIDTH % 32;

//-----------------------------------------------------------------------------------------------------------------------------
//Functional Code
logic any_cfg_write ;
logic any_cfg_read_nc ;
always_comb begin

if ( NUM_TARGET == 1 ) begin
any_cfg_write = cfg_write ;
any_cfg_read_nc = cfg_read ;
end
else begin
any_cfg_write = |cfg_write ;
any_cfg_read_nc = |cfg_read ;
end

  reg_nxt = reg_f ;
  wire_capture_v = '0 ;

  //read will clear
  if ( cfg_write[NUM_TARGET-1] & cfg_req.wdata[CAPTURED_CFG_BIT] ) begin
    wire_capture_v = 1'b1 ;
    reg_nxt[ CAPTURED ] = 1'b0 ;
  end

  //capture event
  if ( ( reg_f[ CAPTURED ] == 1'b0 )
     & ( capture_v == 1'd1 )
     ) begin
    wire_capture_v = 1'b1 ;
    reg_nxt[ CAPTURED ] = 1'b1 ;
    reg_nxt[ WIDTH -1 : 0 ] = capture_data ;
  end

  // ack on write requests
  cfg_ack     = cfg_ack_int ;
  cfg_err     = cfg_err_int ;
  cfg_rdata   = cfg_rdata_int ;
  if ( any_cfg_write ) begin
    cfg_ack   = 1'b1 ;
    cfg_err   = '0 ;
    cfg_rdata = '0 ;
  end

end

assign syndrome_data = reg_f;
endmodule
