//-----------------------------------------------------------------------------------------------------
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
//-----------------------------------------------------------------------------------------------------
//  common AW to provide functional , config , vas reset , and pf reset access to a RAM.
//
//-----------------------------------------------------------------------------------------------------
module hqm_chp_threshold_r_pipe_access
      import hqm_AW_pkg::*; #(
      parameter DEPTH                           = 1024
    , parameter DWIDTH                          = 64
    , parameter AWIDTHPAD                       = 0
    , parameter DWIDTHPAD                       = 0
    //..............................................................................
    , parameter AWIDTH                          = ( AW_logb2 ( DEPTH - 1 ) + 1 ) + AWIDTHPAD
    , parameter PWIDTH                          = DWIDTH + DWIDTHPAD
) (
    //------------------------------------------------------------------------------------------
    // Input side
      input  logic                              clk
    , input  logic                              rst_n

    , input  logic                              func_mem_re
    , input  logic [ ( AWIDTH ) - 1 : 0 ]       func_mem_addr
    , input  logic                              func_mem_we
    , input  logic [ ( PWIDTH ) - 1 : 0 ]       func_mem_wdata
    , output logic [ ( PWIDTH ) - 1 : 0 ]       func_mem_rdata

    , input  logic                              cfg_mem_re
    , input  logic [ ( 20 ) - 1 : 0 ]           cfg_mem_addr
    , input  logic [ ( 12 ) - 1 : 0 ]           cfg_mem_minbit
    , input  logic [ ( 12 ) - 1 : 0 ]           cfg_mem_maxbit
    , input  logic                              cfg_mem_we
    , input  logic [ ( 32 ) - 1 : 0 ]           cfg_mem_wdata
    , output logic [ ( 32 ) - 1 : 0 ]           cfg_mem_rdata
    , output logic                              cfg_mem_ack

    , input  logic                              cfg_mem_cc_v
    , input  logic  [ ( 8 ) - 1 : 0 ]           cfg_mem_cc_value
    , input  logic  [ ( 4 ) - 1 : 0 ]           cfg_mem_cc_width
    , input  logic  [ ( 12 ) - 1 : 0 ]          cfg_mem_cc_position

    , input  logic                              pf_mem_re
    , input  logic [ ( AWIDTH ) - 1 : 0 ]       pf_mem_addr
    , input  logic                              pf_mem_we
    , input  logic [ ( PWIDTH ) - 1 : 0 ]       pf_mem_wdata
    , output logic [ ( PWIDTH ) - 1 : 0 ]       pf_mem_rdata

    , output logic                              mem_rclk
    , output logic                              mem_rclk_rst_n
    , output logic                              mem_wclk
    , output logic                              mem_wclk_rst_n

    , output logic                              mem_re
    , output logic [ ( AWIDTH ) - 1 : 0 ]       mem_waddr
    , output logic [ ( AWIDTH ) - 1 : 0 ]       mem_raddr
    , output logic                              mem_we
    , output logic [ ( PWIDTH ) - 1 : 0 ]       mem_wdata
    , input  logic [ ( PWIDTH ) - 1 : 0 ]       mem_rdata

    , output logic                              error
) ;




logic cfg_mem_re_f ;
logic [ ( AWIDTH ) - 1 : 0 ] cfg_mem_addr_f ;
logic [ ( 12 ) - 1 : 0 ] cfg_mem_minbit_f ; 
logic [ ( 12 ) - 1 : 0 ] cfg_mem_maxbit_f ;
logic cfg_mem_we_f ; 
logic [ ( 32 ) - 1 : 0 ] cfg_mem_wdata_f ;
logic cfg_mem_cc_v_f ;
logic [ ( 8 ) - 1 : 0 ] cfg_mem_cc_value_f ;
logic [ ( 4 ) - 1 : 0 ] cfg_mem_cc_width_f ;
logic [ ( 12 ) - 1 : 0 ] cfg_mem_cc_position_f ;


logic cfg_mem_re_f2 ;
logic [ ( AWIDTH ) - 1 : 0 ] cfg_mem_addr_f2 ;
logic [ ( 12 ) - 1 : 0 ] cfg_mem_minbit_f2_nc ; 
logic [ ( 12 ) - 1 : 0 ] cfg_mem_maxbit_f2_nc ;
logic cfg_mem_we_f2 ;
logic [ ( 32 ) - 1 : 0 ] cfg_mem_wdata_f2 ;
logic cfg_mem_cc_v_f2_nc ;
logic [ ( 8 ) - 1 : 0 ] cfg_mem_cc_value_f2 ;
logic [ ( 4 ) - 1 : 0 ] cfg_mem_cc_width_f2_nc ;
logic [ ( 12 ) - 1 : 0 ] cfg_mem_cc_position_f2_nc ;

logic [ ( PWIDTH ) - 1 : 0 ] mem_rdata_f , mem_rdata_nxt ;

logic [ ( 32 ) - 1 : 0 ] mask_cfg0 ;
logic [ ( 32 ) - 1 : 0 ] mask_cfg1 ;
logic [ ( 32 ) - 1 : 0 ] mask_cfg2 ;
logic [ ( 32 ) - 1 : 0 ] mask_cfg ;
logic [ ( PWIDTH ) - 1 : 0 ] mask_inv_cfg ;
logic [ ( 8 ) - 1 : 0 ] mask_cc ;
logic [ ( PWIDTH ) - 1 : 0 ] mem_wdata_writedata ;
logic [ ( PWIDTH ) - 1 : 0 ] mem_wdata_writecc ;


logic [ ( PWIDTH ) - 1 : 0 ] cfg_mem_rdata_pre ;
logic [ ( 32 ) - 1 : 0 ] cfg_mem_rdata_post ;
hqm_AW_width_scale #(
  .A_WIDTH( PWIDTH )
, .Z_WIDTH( 32 )
 ) i_wc0 (
 .a ( cfg_mem_rdata_pre )
,.z ( cfg_mem_rdata_post )
);

logic [ ( 32 ) - 1 : 0 ] mem_wdata_writedata_pre ;
logic [ ( PWIDTH ) - 1 : 0 ] mem_wdata_writedata_post ;
hqm_AW_width_scale #(
  .A_WIDTH( 32 )
, .Z_WIDTH( PWIDTH )
 ) i_wc1 (
 .a ( mem_wdata_writedata_pre )
,.z ( mem_wdata_writedata_post )
);


logic [ ( 8 ) - 1 : 0 ] mem_wdata_writecc_pre ;
logic [ ( PWIDTH ) - 1 : 0 ] mem_wdata_writecc_post_nc ;
hqm_AW_width_scale #(
  .A_WIDTH( 8 )
, .Z_WIDTH( PWIDTH )
 ) i_wc2 (
 .a ( mem_wdata_writecc_pre )
,.z ( mem_wdata_writecc_post_nc )
);

assign mem_rclk         = clk ;
assign mem_rclk_rst_n   = rst_n ;
assign mem_wclk         = clk ;
assign mem_wclk_rst_n   = rst_n ;

always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    cfg_mem_re_f <= '0 ;
    cfg_mem_we_f <= '0 ;
    cfg_mem_cc_v_f <= '0 ;
    cfg_mem_re_f2 <= '0 ;
    cfg_mem_we_f2 <= '0 ;
    cfg_mem_cc_v_f2_nc <= '0 ;
  end else begin
    cfg_mem_re_f <= cfg_mem_re ;
    cfg_mem_we_f <= cfg_mem_we ;
    cfg_mem_cc_v_f <= cfg_mem_cc_v ;
    cfg_mem_re_f2 <= cfg_mem_re_f ;
    cfg_mem_we_f2 <= cfg_mem_we_f ;
    cfg_mem_cc_v_f2_nc <= cfg_mem_cc_v_f ;
  end
end
always_ff @( posedge clk ) begin
    mem_rdata_f <= mem_rdata_nxt ;
    cfg_mem_minbit_f <= cfg_mem_minbit ;
    cfg_mem_maxbit_f <= cfg_mem_maxbit ;
    cfg_mem_wdata_f <= cfg_mem_wdata ;
    cfg_mem_addr_f <= cfg_mem_addr [ ( AWIDTH ) - 1 : 0 ] ;
    cfg_mem_cc_value_f <= cfg_mem_cc_value ;
    cfg_mem_cc_width_f <= cfg_mem_cc_width ;
    cfg_mem_cc_position_f <= cfg_mem_cc_position ;
    cfg_mem_minbit_f2_nc <= cfg_mem_minbit_f ;
    cfg_mem_maxbit_f2_nc <= cfg_mem_maxbit_f ;
    cfg_mem_wdata_f2 <= cfg_mem_wdata_f ;
    cfg_mem_addr_f2 <= cfg_mem_addr_f ;
    cfg_mem_cc_value_f2 <= cfg_mem_cc_value_f ;
    cfg_mem_cc_width_f2_nc <= cfg_mem_cc_width_f ;
    cfg_mem_cc_position_f2_nc <= cfg_mem_cc_position_f ;
end


always_comb begin

  mem_re = '0 ;
  mem_waddr = '0 ;
  mem_raddr = '0 ;
  mem_we = '0 ;
  mem_wdata = '0 ;
  func_mem_rdata = '0 ;
  pf_mem_rdata = '0 ;
  cfg_mem_ack = '0 ; 
  cfg_mem_rdata = '0 ;

  if ( func_mem_re | func_mem_we ) begin
    mem_re = func_mem_re ;
    mem_waddr = func_mem_addr ;
    mem_raddr = func_mem_addr ;
    mem_we = func_mem_we ;
    mem_wdata = func_mem_wdata ;
  end
  func_mem_rdata = mem_rdata ;

  if ( pf_mem_re | pf_mem_we ) begin
    mem_re = pf_mem_re ;
    mem_waddr = pf_mem_addr ;
    mem_raddr = pf_mem_addr ;
    mem_we = pf_mem_we ;
    mem_wdata = pf_mem_wdata ;
  end
  pf_mem_rdata = mem_rdata ;



  if ( cfg_mem_re | cfg_mem_we ) begin
    mem_re = 1'b1 ;
    mem_waddr = cfg_mem_addr [ ( AWIDTH ) - 1 : 0 ] ;
    mem_raddr = cfg_mem_addr [ ( AWIDTH ) - 1 : 0 ] ;
    mem_we = '0 ;
    mem_wdata = '0 ;
  end
  mem_rdata_nxt = mem_rdata_f ;
  if ( cfg_mem_re_f | cfg_mem_we_f ) begin
    mem_rdata_nxt = mem_rdata ;
  end

  mem_wdata_writedata = '0 ;
  mem_wdata_writecc = '0 ;
  mask_cfg0 = '0 ;
  mask_cfg1 = '0 ;
  mask_cfg2 = '0 ;
  mask_cfg = '0 ;
  mask_inv_cfg = '0 ;
  mask_cc = '0 ;
  cfg_mem_rdata_pre = mem_rdata_f ;
  mem_wdata_writedata_pre = '0 ;
  mem_wdata_writecc_pre = '0 ;

//hardcode read & write access since this is a dedicated access module
  if ( cfg_mem_re_f2 ) begin
    cfg_mem_ack = 1'b1 ;
    cfg_mem_rdata = { cfg_mem_rdata_post [ 31 : 1 ] , 1'b1 } ;
  end

  if ( cfg_mem_we_f2 ) begin
    cfg_mem_ack = 1'b1 ;
    mem_we = 1'b1 ;
    mem_waddr = cfg_mem_addr_f2 [ ( AWIDTH ) - 1 : 0 ] ;
    mem_raddr = cfg_mem_addr_f2 [ ( AWIDTH ) - 1 : 0 ] ;

    mem_wdata_writedata_pre = { 18'd0 , cfg_mem_wdata_f2 [ 13 : 1 ] , cfg_mem_cc_value_f2 [ 0 ]  } ;
    mem_wdata_writedata = ( mem_wdata_writedata_post  ) ;

    mem_wdata = { mem_wdata_writedata } ;
  end
end





////////////////////////////////////////////////////////////////////////////////////////////////////
logic error_f , error_next ;
assign error = error_f ;
always_ff @( posedge clk or negedge rst_n ) begin 
  if ( ~ rst_n ) begin
    error_f <= '0 ;
  end else begin
    error_f <= error_next ;
  end
end
always_comb begin
  error_next = ( ( func_mem_re | func_mem_we ) & ( | { cfg_mem_re, cfg_mem_we, pf_mem_re, pf_mem_we } ) )
             | ( cfg_mem_re                    & ( | {             cfg_mem_we, pf_mem_re, pf_mem_we } ) )
             | ( cfg_mem_we                    & ( | {                         pf_mem_re, pf_mem_we } ) )
             | ( pf_mem_re                     &                                          pf_mem_we     );
end

endmodule
