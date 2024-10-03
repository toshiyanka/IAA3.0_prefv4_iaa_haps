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
module hqm_AW_ipar_wrap #(
  parameter PWIDTH                                = 2
, parameter DWIDTH                                = 17
, parameter FLOP_ERROR                            = 1
//.........................
,  parameter TWIDTH                               = ( DWIDTH + PWIDTH )
,  parameter XWIDTH                               = ( ( DWIDTH % PWIDTH ) == 0 ) ? ( DWIDTH / PWIDTH ) : ( ( DWIDTH / PWIDTH ) + 1 )    
) (
  input  logic [ ( DWIDTH ) - 1 : 0 ]             mem_wdata_in
, output logic [ ( TWIDTH ) - 1 : 0 ]             mem_wdata_out
, input  logic [ ( TWIDTH ) - 1 : 0 ]             mem_rdata_in
, output logic [ ( DWIDTH ) - 1 : 0 ]             mem_rdata_out
, output logic                                    error
, input  logic                                    cfg_errorinj
, input  logic                                    re
, input  logic                                    rclk
, input  logic                                    rclk_rst_n
) ;

logic RE_reg ;
always_ff @ ( posedge rclk or negedge rclk_rst_n ) begin
  if ( ~ rclk_rst_n ) begin
    RE_reg <= '0 ;
  end else begin
    RE_reg <= re;
  end
end

logic wire_error ;
generate 
  if ( FLOP_ERROR ) begin : g_if0
    logic ERROR_reg ;
    always_ff @ ( posedge rclk or negedge rclk_rst_n ) begin
      if ( ~ rclk_rst_n ) begin
        ERROR_reg <= '0 ;
      end else begin
        ERROR_reg <= wire_error;
      end
    end
    assign error = ERROR_reg ;
  end else begin : g_if1
    assign error = wire_error ;
  end
endgenerate


//-----------------------------------------------------------------------------------------------------
generate
  if ( ( PWIDTH [ 0 ] )
     ) begin : invalid
    for ( genvar g0 = PWIDTH ; g0 <= PWIDTH ; g0 = g0 + 1 ) begin : g_g0
      AW_ipar__INVALID_PARAM i_bad ( .clk() );
    end
  end
endgenerate

logic [ ( PWIDTH ) - 1 : 0 ] [ ( XWIDTH - 1 ) : 0 ] par_mem_wdata ;
logic [ ( PWIDTH ) - 1 : 0 ] [ ( XWIDTH - 1 ) : 0 ] par_mem_rdata ;
logic [ ( PWIDTH ) - 1 : 0 ] par_mem_wdata_par ;
logic [ ( PWIDTH ) - 1 : 0 ] par_mem_rdata_par ;
logic [ ( PWIDTH ) - 1 : 0 ] par_error ;
logic [ ( PWIDTH * XWIDTH ) - 1 : 0 ] pad_mem_wdata ;
logic [ ( PWIDTH * XWIDTH ) - 1 : 0 ] pad_mem_rdata ;

generate
for ( genvar g = 0 ; g < PWIDTH ; g = g + 1 ) begin : g_g 
  hqm_AW_parity_gen # (
    .WIDTH ( XWIDTH )
  ) i_parity_gen_g (
    .d   ( par_mem_wdata [ g ] )
  , .p  ( par_mem_wdata_par [ g ] )
  , .odd ( 1'b1 )
  ) ;
  hqm_AW_parity_check # (
    .WIDTH ( XWIDTH )
  ) i_parity_check_g (
    .p  ( par_mem_rdata_par [ g ] )
  , .d    ( par_mem_rdata [ g ] )
  , .e  ( 1'b1 )
  , .odd ( 1'b1 )
  , .err   ( par_error [ g ] )
  ) ;
end
endgenerate

always_comb begin
  //drive output error
  wire_error = ( | par_error ) & RE_reg ;

  //drive outputs
  mem_rdata_out = { mem_rdata_in [ 0 +: DWIDTH ] } ;
  mem_wdata_out = { par_mem_wdata_par , mem_wdata_in } ;

  //pad data to support any data width
  pad_mem_wdata = '0 ;
  pad_mem_wdata [ 0 +: DWIDTH ] = mem_wdata_in [ 0 +: DWIDTH ] ;
  pad_mem_rdata = '0 ;
  pad_mem_rdata [ 0 +: DWIDTH ] = mem_rdata_in [ 0 +: DWIDTH ] ;

  // extract PAR
  par_mem_rdata_par = '0 ;
  for ( int p = 0 ; p < PWIDTH ; p = p + 1 ) begin
    par_mem_rdata_par [ p ] = mem_rdata_in [ ( TWIDTH - PWIDTH + p ) ] ;
  end

  //create even/odd interleaved array
  par_mem_wdata = '0 ;
  par_mem_rdata = '0 ;
  for ( int p = 0 ; p < PWIDTH ; p = p + 1 ) begin 
  for ( int x = 0 ; x < XWIDTH ; x = x + 1 ) begin 
    par_mem_wdata [ p ] [ x ] = pad_mem_wdata [ ( ( p ) + ( x * PWIDTH ) ) ] ;
    par_mem_rdata [ p ] [ x ] = pad_mem_rdata [ ( ( p ) + ( x * PWIDTH ) ) ] ;
  end
  end

  par_mem_wdata [ 0 ] [ 0 ] = par_mem_wdata [ 0 ] [ 0 ] ^ cfg_errorinj ;

end

endmodule // hqm_AW_ipar_wrap
