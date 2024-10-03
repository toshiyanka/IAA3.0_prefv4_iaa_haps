//-----------------------------------------------------------------------------------------------------
//
// inTEL CONFIDENTIAL
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
// Purpose:
//
//
//-----------------------------------------------------------------------------------------------------
// 
module hqm_AW_smon_wtcfg
 import hqm_AW_pkg::*; #(
 parameter WIDTH = 8
) (
  input logic rst_n
, input logic clk
, input logic disable_smon

, input logic [ ( 8 ) -1 : 0 ] cfg_write
, input logic [ ( 8 ) -1 : 0 ]  cfg_read
, input cfg_req_t cfg_req
, output logic [ ( 1 ) -1 : 0 ] cfg_ack
, output logic [ ( 1 ) -1 : 0 ] cfg_err
, output logic [ ( 32 ) -1 : 0 ] cfg_rdata

, input logic [ ( WIDTH) -1 : 0 ] in_mon_v
, input logic [ ( WIDTH*32 ) -1 : 0 ] in_mon_comp
, input logic [ ( WIDTH*32 ) -1 : 0 ] in_mon_val

, output logic out_smon_interrupt 
, output logic out_smon_enabled
);
 
logic [ ( 1 ) -1 : 0] smon_cfg0_write ;
logic [ ( 1 ) -1 : 0] smon_cfg1_write ;
logic [ ( 1 ) -1 : 0] smon_cfg2_write ;
logic [ ( 1 ) -1 : 0] smon_cfg3_write ;
logic [ ( 1 ) -1 : 0] smon_cfg4_write ;
logic [ ( 1 ) -1 : 0] smon_cfg5_write ;
logic [ ( 1 ) -1 : 0] smon_cfg6_write ;
logic [ ( 1 ) -1 : 0] smon_cfg7_write ;
logic [ ( 32 ) -1 : 0] smon_cfg0_wdata ;
logic [ ( 32 ) -1 : 0] smon_cfg1_wdata ;
logic [ ( 32 ) -1 : 0] smon_cfg2_wdata ;
logic [ ( 32 ) -1 : 0] smon_cfg3_wdata ;
logic [ ( 32 ) -1 : 0] smon_cfg4_wdata ;
logic [ ( 32 ) -1 : 0] smon_cfg5_wdata ;
logic [ ( 32 ) -1 : 0] smon_cfg6_wdata ;
logic [ ( 32 ) -1 : 0] smon_cfg7_wdata ;
logic [ ( 32 ) -1 : 0] smon_cfg0_data ;
logic [ ( 32 ) -1 : 0] smon_cfg1_data ;
logic [ ( 32 ) -1 : 0] smon_cfg2_data ;
logic [ ( 32 ) -1 : 0] smon_cfg3_data ;
logic [ ( 32 ) -1 : 0] smon_cfg4_data ;
logic [ ( 32 ) -1 : 0] smon_cfg5_data ;
logic [ ( 32 ) -1 : 0] smon_cfg6_data ;
logic [ ( 32 ) -1 : 0] smon_cfg7_data ;

always_comb begin
  cfg_ack = ( |cfg_write ) | ( |cfg_read );
  cfg_err = 1'd1 ;
  cfg_rdata = '0 ;

  smon_cfg0_write = '0 ;
  smon_cfg1_write = '0 ;
  smon_cfg2_write = '0 ;
  smon_cfg3_write = '0 ;
  smon_cfg4_write = '0 ;
  smon_cfg5_write = '0 ;
  smon_cfg6_write = '0 ;
  smon_cfg7_write = '0 ;
  smon_cfg0_wdata = '0 ;
  smon_cfg1_wdata = '0 ;
  smon_cfg2_wdata = '0 ;
  smon_cfg3_wdata = '0 ;
  smon_cfg4_wdata = '0 ;
  smon_cfg5_wdata = '0 ;
  smon_cfg6_wdata = '0 ;
  smon_cfg7_wdata = '0 ;

    smon_cfg0_write = cfg_write[0]; smon_cfg0_wdata = cfg_req.wdata ; cfg_err = 1'd0 ;
    smon_cfg1_write = cfg_write[1]; smon_cfg1_wdata = cfg_req.wdata ; cfg_err = 1'd0 ;
    smon_cfg2_write = cfg_write[2]; smon_cfg2_wdata = cfg_req.wdata ; cfg_err = 1'd0 ;
    smon_cfg3_write = cfg_write[3]; smon_cfg3_wdata = cfg_req.wdata ; cfg_err = 1'd0 ;
    smon_cfg4_write = cfg_write[4]; smon_cfg4_wdata = cfg_req.wdata ; cfg_err = 1'd0 ;
    smon_cfg5_write = cfg_write[5]; smon_cfg5_wdata = cfg_req.wdata ; cfg_err = 1'd0 ;
    smon_cfg6_write = cfg_write[6]; smon_cfg6_wdata = cfg_req.wdata ; cfg_err = 1'd0 ;
    smon_cfg7_write = cfg_write[7]; smon_cfg7_wdata = cfg_req.wdata ; cfg_err = 1'd0 ;

    if ( cfg_read[0] ) begin cfg_rdata = { smon_cfg0_data } ; cfg_err = 1'd0 ; end
    if ( cfg_read[1] ) begin cfg_rdata = { smon_cfg1_data } ; cfg_err = 1'd0 ; end
    if ( cfg_read[2] ) begin cfg_rdata = { smon_cfg2_data } ; cfg_err = 1'd0 ; end
    if ( cfg_read[3] ) begin cfg_rdata = { smon_cfg3_data } ; cfg_err = 1'd0 ; end
    if ( cfg_read[4] ) begin cfg_rdata = { smon_cfg4_data } ; cfg_err = 1'd0 ; end
    if ( cfg_read[5] ) begin cfg_rdata = { smon_cfg5_data } ; cfg_err = 1'd0 ; end
    if ( cfg_read[6] ) begin cfg_rdata = { smon_cfg6_data } ; cfg_err = 1'd0 ; end
    if ( cfg_read[7] ) begin cfg_rdata = { smon_cfg7_data } ; cfg_err = 1'd0 ; end

end

hqm_AW_smon #(
.WIDTH(WIDTH)
) i_hqm_AW_smon (
 .clk ( clk )
,.rst_n ( rst_n )
,.disable_smon( disable_smon )
,.in_mon_v ( in_mon_v )
,.in_mon_comp ( in_mon_comp )
,.in_mon_val ( in_mon_val )
,.in_smon_cfg0_write ( smon_cfg0_write )
,.in_smon_cfg1_write ( smon_cfg1_write )
,.in_smon_cfg2_write ( smon_cfg2_write )
,.in_smon_cfg3_write ( smon_cfg3_write )
,.in_smon_cfg4_write ( smon_cfg4_write )
,.in_smon_cfg5_write ( smon_cfg5_write )
,.in_smon_cfg6_write ( smon_cfg6_write )
,.in_smon_cfg7_write ( smon_cfg7_write )
,.in_smon_cfg0_wdata ( smon_cfg0_wdata )
,.in_smon_cfg1_wdata ( smon_cfg1_wdata )
,.in_smon_cfg2_wdata ( smon_cfg2_wdata )
,.in_smon_cfg3_wdata ( smon_cfg3_wdata )
,.in_smon_cfg4_wdata ( smon_cfg4_wdata )
,.in_smon_cfg5_wdata ( smon_cfg5_wdata )
,.in_smon_cfg6_wdata ( smon_cfg6_wdata )
,.in_smon_cfg7_wdata ( smon_cfg7_wdata )
,.out_smon_cfg0_data ( smon_cfg0_data )
,.out_smon_cfg1_data ( smon_cfg1_data )
,.out_smon_cfg2_data ( smon_cfg2_data )
,.out_smon_cfg3_data ( smon_cfg3_data )
,.out_smon_cfg4_data ( smon_cfg4_data )
,.out_smon_cfg5_data ( smon_cfg5_data )
,.out_smon_cfg6_data ( smon_cfg6_data )
,.out_smon_cfg7_data ( smon_cfg7_data )
,.out_smon_interrupt ( out_smon_interrupt )
,.out_smon_enabled ( out_smon_enabled )
);


endmodule 
// 
