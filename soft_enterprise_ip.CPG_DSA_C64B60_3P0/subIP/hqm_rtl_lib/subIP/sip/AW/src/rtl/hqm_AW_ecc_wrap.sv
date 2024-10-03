//-----------------------------------------------------------------------------------------------------
// 
// INTEL CONFIDENTIAL 
//
// Copyright 2020 Intel Corporation All Rights Reserved.
// 
// The source code contained or described herein and all documents related to the source code
// ("Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
//
//-----------------------------------------------------------------------------------------------------
module hqm_AW_ecc_wrap #(
  parameter ECNT                                  = 1
, parameter EWIDTH                                = 6
, parameter DWIDTH                                = 17
//.........................
, parameter TWIDTH                                =  DWIDTH + ( ECNT * EWIDTH )
) (
  input  logic [ ( DWIDTH ) - 1 : 0 ]             mem_wdata_in
, output logic [ ( TWIDTH ) - 1 : 0 ]             mem_wdata_out
, input  logic [ ( TWIDTH ) - 1 : 0 ]             mem_rdata_in
, output logic [ ( DWIDTH ) - 1 : 0 ]             mem_rdata_out
, output logic                                    error_sb
, output logic                                    error_mb
, input  logic                                    cfg_errorinj_sb
, input  logic                                    cfg_errorinj_mb
) ;

localparam PWIDTH = ( DWIDTH + ( DWIDTH % ECNT ) ) / ECNT;

logic [ ( ECNT * PWIDTH ) - 1 : 0 ] pad_mem_wdata_in ;
logic [ ( ECNT * PWIDTH ) - 1 : 0 ] pad_mem_rdata_in ;
logic [ ( ECNT * PWIDTH ) - 1 : 0 ] pad_ecc_check_dout ;
logic [ ( ECNT ) - 1 : 0 ] [ ( PWIDTH ) - 1 : 0 ] ecc_gen_d ;
logic [ ( ECNT ) - 1 : 0 ] [ ( EWIDTH ) - 1 : 0 ] ecc_gen_ecc ;
logic [ ( ECNT ) - 1 : 0 ] [ ( PWIDTH ) - 1 : 0 ] ecc_check_din ;
logic [ ( ECNT ) - 1 : 0 ] [ ( EWIDTH ) - 1 : 0 ] ecc_check_ecc ;
logic [ ( ECNT ) - 1 : 0 ] [ ( PWIDTH ) - 1 : 0 ] ecc_check_dout ;
logic [ ( ECNT ) - 1 : 0 ] ecc_check_error_sb ;
logic [ ( ECNT ) - 1 : 0 ] ecc_check_error_mb ;

generate
for ( genvar g = 0 ; g < ECNT ; g = g + 1 ) begin : g0
hqm_AW_ecc_gen # (
  .DATA_WIDTH ( PWIDTH )
, .ECC_WIDTH ( EWIDTH )
) i_ecc_gen_g (
  .d ( ecc_gen_d [ g ] )
, .ecc ( ecc_gen_ecc [ g ] )
) ;

hqm_AW_ecc_check #(
  .DATA_WIDTH ( PWIDTH )
, .ECC_WIDTH ( EWIDTH )
) i_ecc_check_g (
  .din_v ( 1'b1 )
, .din ( ecc_check_din [ g ] )
, .ecc ( ecc_check_ecc [ g ] )
, .dout ( ecc_check_dout [ g ] )
, .enable ( 1'b1 )
, .correct ( 1'b1 )
, .error_sb ( ecc_check_error_sb [ g ] )
, .error_mb ( ecc_check_error_mb [ g ] )
);
end
endgenerate

always_comb begin
  //drive output error
  error_sb = | ecc_check_error_sb ;
  error_mb = | ecc_check_error_mb ;

  //drive outputs
  for ( int e = 0 ; e < ECNT ; e = e + 1 ) begin
   pad_ecc_check_dout [ ( e * PWIDTH ) +: PWIDTH ] = ecc_check_dout [ e ] ;
  end
  mem_rdata_out = { pad_ecc_check_dout [ 0 +: DWIDTH ] } ;
  mem_wdata_out [ 0 +: DWIDTH ] = mem_wdata_in ;
  for ( int e = 0 ; e < ECNT ; e = e + 1 ) begin
    mem_wdata_out [ ( DWIDTH + ( e * EWIDTH ) ) +: EWIDTH ] = ecc_gen_ecc [ e ] ;
  end

  //connect to aw
  pad_mem_wdata_in = '0 ;
  pad_mem_wdata_in [ 0 +: DWIDTH ] = mem_wdata_in [ 0 +: DWIDTH ] ;
  pad_mem_rdata_in = '0 ;
  pad_mem_rdata_in [ 0 +: DWIDTH ] = mem_rdata_in [ 0 +: DWIDTH ] ;

  // extract ECC
  ecc_check_ecc = '0 ;
  for ( int e = 0 ; e < ECNT ; e = e + 1 ) begin
    ecc_check_ecc [ e ] = mem_rdata_in [ ( DWIDTH + ( e * EWIDTH ) ) +: EWIDTH ] ;
  end

  //connect to aw
  ecc_gen_d = '0 ;
  ecc_check_din = '0 ;
  for ( int e = 0 ; e < ECNT ; e = e + 1 ) begin
    ecc_gen_d [ e ] = pad_mem_wdata_in [ ( e * PWIDTH ) +: PWIDTH ] ;
    ecc_check_din [ e ] = pad_mem_rdata_in [ ( e * PWIDTH ) +: PWIDTH ] ;
  end

  ecc_gen_d [ 0 ] [ 0 ] = ecc_gen_d [ 0 ] [ 0 ] ^ ( cfg_errorinj_mb | cfg_errorinj_sb ) ;
  ecc_gen_d [ 0 ] [ 1 ] = ecc_gen_d [ 0 ] [ 1 ] ^ ( cfg_errorinj_mb ) ;
end

endmodule // hqm_AW_ecc_wrap
