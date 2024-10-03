//-----------------------------------------------------------------------------------------------------
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
//-----------------------------------------------------------------------------------------------------
// Converting Source Synchronous data into Common Clock data
// clkb >= clka
// 1-2 clks through synchronizer
//
//-----------------------------------------------------------------------------------------------------
module hqm_AW_ss2cc
  import hqm_AW_pkg::*;
#(
  parameter SDELAY                        = 4 
, parameter DWIDTH                        = 8 
) (
  input  logic                            powergood_rst_b
, input  logic                            fscan_rstbypen
, input  logic                            fscan_byprst_b
, input  logic                            clka 
, input  logic [ ( DWIDTH - 1 ) : 0 ]     clka_data_in
, input  logic                            clkb 
, output logic [ ( DWIDTH - 1 ) : 0 ]     clkb_data_out
) ;

localparam PWIDTH = ( AW_logb2 ( SDELAY - 1 ) + 1 ) ;
 
logic clka_rst_n ;
logic clkb_rst_n ; 

logic clka_started_f ;
logic clka_gray_incr_nxt ;
logic clka_gray_incr_f ;
logic [ ( PWIDTH - 1 ) : 0 ] clka_gray_f ;
logic [ ( PWIDTH - 1 ) : 0 ] clka_gray_f_sync ;
logic [ ( SDELAY - 1 ) : 0 ] clka_data_we_nxt ;
logic [ ( SDELAY - 1 ) : 0 ] clka_data_we_f ;
logic [ ( DWIDTH - 1 ) : 0 ] clka_data_nxt [ ( SDELAY - 1 ) : 0 ] ;
logic [ ( DWIDTH - 1 ) : 0 ] clka_data_f [ ( SDELAY - 1 ) : 0 ] ;

logic clkb_started_f ;
logic clkb_started_f_sync ;
logic clkb_gray_incr ;
logic [ ( PWIDTH - 1 ) : 0 ] clkb_gray_f ;
logic [ ( SDELAY - 1 ) : 0 ] clkb_data_re_f ;
logic [ ( DWIDTH - 1 ) : 0 ] clkb_data_nxt ;
logic [ ( DWIDTH - 1 ) : 0 ] clkb_data_f ;

hqm_AW_reset_sync_scan i_clka_rst_n (
  .clk			( clka )
, .rst_n		( powergood_rst_b )
, .fscan_rstbypen	( fscan_rstbypen )
, .fscan_byprst_b	( fscan_byprst_b )
, .rst_n_sync		( clka_rst_n)
);

hqm_AW_reset_sync_scan i_clkb_rst_n (
  .clk			( clkb )
, .rst_n		( powergood_rst_b )
, .fscan_rstbypen	( fscan_rstbypen )
, .fscan_byprst_b	( fscan_byprst_b )
, .rst_n_sync		( clkb_rst_n)
);

always_ff @ ( posedge clka or negedge clka_rst_n ) begin
  if ( ~ clka_rst_n ) begin
    clka_started_f <= 1'b0 ;
    clka_gray_incr_f <= 1'b0 ;
    clka_data_we_f <= { { ( SDELAY - 1 ) { 1'b0 } }, 1'b1 } ;
  end
  else begin
    clka_started_f <= 1'b1 ;
    clka_gray_incr_f <= clka_gray_incr_nxt ;
    clka_data_we_f <= clka_data_we_nxt ;
  end
end 

always_comb begin
  clka_gray_incr_nxt = clka_started_f & clkb_started_f_sync ;
  clka_data_we_nxt = clka_gray_incr_nxt ? { clka_data_we_f [ ( SDELAY - 2 ) : 0 ] , clka_data_we_f [ SDELAY - 1 ] } : clka_data_we_f ;
  for ( int i = 0 ; i < SDELAY ; i ++ ) begin
    clka_data_nxt [ i ] = clka_data_f [ i ] ;
    if ( clka_gray_incr_nxt & clka_data_we_f [ i ] ) begin
      clka_data_nxt [ i ] = clka_data_in ;
    end
  end
end

always_ff @ ( posedge clka ) begin
  for ( int i = 0 ; i < SDELAY ; i ++ ) begin
    clka_data_f [ i ] <= clka_data_nxt [ i ] ;
  end
end

always_comb begin
  clkb_gray_incr = ( clka_gray_f_sync != clkb_gray_f ) ;
end 

always_ff @ ( posedge clkb or negedge clkb_rst_n ) begin
  if ( ~ clkb_rst_n ) begin
    clkb_started_f <= '0 ;
    clkb_data_re_f <= { { ( SDELAY - 1 ) { 1'b0 } }, 1'b1 } ;
  end
  else begin
    clkb_started_f <= 1'b1 ;
    clkb_data_re_f <= clkb_gray_incr ? { clkb_data_re_f [ ( SDELAY - 2 ) : 0 ] , clkb_data_re_f [ SDELAY - 1 ] } : clkb_data_re_f ;
  end
end 

hqm_AW_sync_rst0 # (
 .WIDTH			( 1 )
) i_hqm_AW_sync_clkb_started (
  .clk			( clka )
, .rst_n		( clka_rst_n )
, .data			( clkb_started_f )
, .data_sync		( clkb_started_f_sync )
);

hqm_AW_grayinc # (
  .WIDTH 		( PWIDTH )
) i_hqm_AW_grayinc_a (
  .clk 			( clka )
, .rst_n		( clka_rst_n )
, .clear		( 1'd0 )
, .incr			( clka_gray_incr_f )
, .gray			( clka_gray_f )
);

hqm_AW_sync_rst0 # (
 .WIDTH			( PWIDTH )
) i_hqm_AW_sync_clka_gray (
  .clk			( clkb )
, .rst_n		( clkb_rst_n )
, .data			( clka_gray_f )
, .data_sync		( clka_gray_f_sync )
);

hqm_AW_grayinc # (
  .WIDTH 		( PWIDTH )
) i_hqm_AW_grayinc_b (
  .clk 			( clkb )
, .rst_n		( clkb_rst_n )
, .clear		( 1'd0 )
, .incr			( clkb_gray_incr )
, .gray			( clkb_gray_f )
);

always_comb begin
  clkb_data_nxt = clkb_data_f ;
  for ( int i = 0 ; i < SDELAY ; i ++ ) begin
    if ( clkb_data_re_f [ i ] ) begin
      clkb_data_nxt = clka_data_f [ i ] ; 
    end
  end
  clkb_data_out = clkb_data_f ;
end

always_ff @ ( posedge clkb ) begin
  clkb_data_f <= clkb_data_nxt ;
end

endmodule // hqm_AW_ss2cc
