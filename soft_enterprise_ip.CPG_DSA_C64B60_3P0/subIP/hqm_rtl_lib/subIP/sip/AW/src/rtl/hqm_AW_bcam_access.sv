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
module hqm_AW_bcam_access
      import hqm_AW_pkg::*; #(
      parameter NUM                             = 8
    , parameter DEPTH                           = 256
    , parameter DWIDTH                          = 26
    //..............................................................................
    , parameter DEPTHB2                         = ( AW_logb2 ( DEPTH - 1 ) + 1 )
) (
    //------------------------------------------------------------------------------------------
    // Input side
      input  logic                              clk
    , input  logic                              clk_pre_rcb_lcb
    , input  logic                              rst_n
    , output logic                              error

    , input logic hqm_fullrate_clk
    , input logic hqm_clk_rptr_rst_sync_b
    , input logic hqm_gatedclk_enable_and 
    , input logic hqm_clk_ungate

     ////////////////////////////////////////////////////////////////////////////////////////////////////

    , output logic                                      bcam_AW_bcam_2048x26_wclk
    , output logic                                      bcam_AW_bcam_2048x26_rclk
    , output logic                                      bcam_AW_bcam_2048x26_cclk

    , output logic                                      bcam_AW_bcam_2048x26_dfx_clk


    , output logic [ ( NUM ) - 1 : 0 ]                  bcam_AW_bcam_2048x26_we
    , output logic [ ( NUM * DEPTHB2 ) - 1 : 0 ]        bcam_AW_bcam_2048x26_waddr
    , output logic [ ( NUM * DWIDTH ) - 1 : 0 ]         bcam_AW_bcam_2048x26_wdata

    , output logic [ ( NUM ) - 1 : 0 ]                  bcam_AW_bcam_2048x26_ce
    , output logic [ ( NUM * DWIDTH ) - 1 : 0 ]         bcam_AW_bcam_2048x26_cdata
    , input  logic [ ( NUM * DEPTH ) - 1 : 0 ]          bcam_AW_bcam_2048x26_cmatch

    , output logic                                      bcam_AW_bcam_2048x26_re
    , output logic [ ( DEPTHB2 ) - 1 : 0 ]              bcam_AW_bcam_2048x26_raddr
    , input  logic [ ( NUM *  DWIDTH ) - 1 : 0 ]        bcam_AW_bcam_2048x26_rdata


     ////////////////////////////////////////////////////////////////////////////////////////////////////
    , input  logic [ ( NUM ) - 1 : 0 ] func_FUNC_WEN_RF_IN_P0
    , input  logic [ ( NUM * DEPTHB2 ) - 1 : 0 ] func_FUNC_WR_ADDR_RF_IN_P0
    , input  logic [ ( NUM * DWIDTH ) - 1 : 0 ] func_FUNC_WR_DATA_RF_IN_P0

    , input  logic [ ( NUM ) - 1 : 0 ] func_FUNC_CEN_RF_IN_P0
    , input  logic [ ( NUM * DWIDTH ) - 1 : 0 ] func_FUNC_CM_DATA_RF_IN_P0
    , output logic [ ( NUM * DEPTH ) - 1 : 0 ] func_CM_MATCH_RF_OUT_P0

    , input  logic func_FUNC_REN_RF_IN_P0
    , input  logic [ ( DEPTHB2 ) - 1 : 0 ] func_FUNC_RD_ADDR_RF_IN_P0 
    , output logic [ ( NUM *  DWIDTH ) - 1 : 0 ] func_DATA_RF_OUT_P0

     ////////////////////////////////////////////////////////////////////////////////////////////////////
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

     ////////////////////////////////////////////////////////////////////////////////////////////////////
    , input  logic [ ( NUM ) - 1 : 0 ] pf_FUNC_WEN_RF_IN_P0
    , input  logic [ ( NUM * DEPTHB2 ) - 1 : 0 ] pf_FUNC_WR_ADDR_RF_IN_P0
    , input  logic [ ( NUM * DWIDTH ) - 1 : 0 ] pf_FUNC_WR_DATA_RF_IN_P0

    , input  logic [ ( NUM ) - 1 : 0 ] pf_FUNC_CEN_RF_IN_P0
    , input  logic [ ( NUM * DWIDTH ) - 1 : 0 ] pf_FUNC_CM_DATA_RF_IN_P0 
    , output logic [ ( NUM * DEPTH ) - 1 : 0 ] pf_CM_MATCH_RF_OUT_P0

    , input  logic pf_FUNC_REN_RF_IN_P0
    , input  logic [ ( DEPTHB2 ) - 1 : 0 ] pf_FUNC_RD_ADDR_RF_IN_P0 
    , output logic [ ( NUM *  DWIDTH ) - 1 : 0 ] pf_DATA_RF_OUT_P0

) ;

logic [ ( NUM ) - 1 : 0 ]               FUNC_WEN_RF_IN_P0 ;
logic [ ( NUM * DEPTHB2 ) - 1 : 0 ]     FUNC_WR_ADDR_RF_IN_P0 ;
logic [ ( NUM * DWIDTH ) - 1 : 0 ]      FUNC_WR_DATA_RF_IN_P0 ;

logic [ ( NUM ) - 1 : 0 ]               FUNC_CEN_RF_IN_P0 ;
logic [ ( NUM * DWIDTH ) - 1 : 0 ]      FUNC_CM_DATA_RF_IN_P0 ;
logic [ ( NUM * DEPTH ) - 1 : 0 ]       CM_MATCH_RF_OUT_P0 ;

logic                                   FUNC_REN_RF_IN_P0 ;
logic [ ( DEPTHB2 ) - 1 : 0 ]           FUNC_RD_ADDR_RF_IN_P0 ;
logic [ ( NUM *  DWIDTH ) - 1 : 0 ]     DATA_RF_OUT_P0 ;


logic hqm_lsp_hqm_gated_clk_enable_rptr_f ;
always_ff @ ( posedge hqm_fullrate_clk or negedge hqm_clk_rptr_rst_sync_b ) begin
  if ( ! hqm_clk_rptr_rst_sync_b ) begin
    hqm_lsp_hqm_gated_clk_enable_rptr_f <= '0 ;
  end
  else begin
    hqm_lsp_hqm_gated_clk_enable_rptr_f <= hqm_gatedclk_enable_and ;
  end
end





logic func_FUNC_REN_RF_IN_P0_f ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    func_FUNC_REN_RF_IN_P0_f <= '0 ;
  end else begin
    func_FUNC_REN_RF_IN_P0_f <= func_FUNC_REN_RF_IN_P0 ;
  end
end

logic pf_FUNC_REN_RF_IN_P0_f ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    pf_FUNC_REN_RF_IN_P0_f <= '0 ;
  end else begin
    pf_FUNC_REN_RF_IN_P0_f <= pf_FUNC_REN_RF_IN_P0 ;
  end
end 

logic cfg_mem_re_f ;
logic [ 10 : 0 ] cfg_mem_addr_f ;
logic cfg_mem_re_f2 ;
logic [ 10 : 0 ] cfg_mem_addr_f2 ;
logic [ ( NUM *  DWIDTH ) - 1 : 0 ] DATA_RF_OUT_P0_f ;
logic [ 10 : 0 ] cfg_mem_addr_f2_nxt ;
logic [ ( NUM *  DWIDTH ) - 1 : 0 ] DATA_RF_OUT_P0_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    cfg_mem_re_f <= '0 ;
    cfg_mem_re_f2 <= '0 ;
  end else begin
    cfg_mem_re_f <= cfg_mem_re ;
    cfg_mem_re_f2 <= cfg_mem_re_f ;
  end
end
always_comb begin
  DATA_RF_OUT_P0_nxt    = DATA_RF_OUT_P0_f ;
  cfg_mem_addr_f2_nxt   = cfg_mem_addr_f2 ;
  if (cfg_mem_re_f) begin
    DATA_RF_OUT_P0_nxt  = DATA_RF_OUT_P0 ;
    cfg_mem_addr_f2_nxt = cfg_mem_addr_f ;
  end
end
always_ff @( posedge clk ) begin
    DATA_RF_OUT_P0_f <= DATA_RF_OUT_P0_nxt ;
    cfg_mem_addr_f <= cfg_mem_addr [ 10 : 0 ] ;
    cfg_mem_addr_f2 <= cfg_mem_addr_f2_nxt ;
end

always_comb begin
FUNC_WEN_RF_IN_P0 = '0 ;
FUNC_WR_ADDR_RF_IN_P0 = '0 ;
FUNC_WR_DATA_RF_IN_P0 = '0 ;
FUNC_CEN_RF_IN_P0 = '0 ;
FUNC_CM_DATA_RF_IN_P0 = '0 ;
FUNC_REN_RF_IN_P0 = '0 ;
FUNC_RD_ADDR_RF_IN_P0 = '0 ;

func_DATA_RF_OUT_P0 = '0 ; //ILLEGAL
func_CM_MATCH_RF_OUT_P0 = '0 ;

pf_DATA_RF_OUT_P0 = '0 ; //ILLEGAL
pf_CM_MATCH_RF_OUT_P0 = '0 ; //ILLEGAL

  //FUNC access does not support read (write and compare only)
  if ( ( | func_FUNC_CEN_RF_IN_P0 ) | ( | func_FUNC_WEN_RF_IN_P0 ) ) begin
    FUNC_WEN_RF_IN_P0 = {8{hqm_lsp_hqm_gated_clk_enable_rptr_f | hqm_clk_ungate}} & func_FUNC_WEN_RF_IN_P0 ;
    FUNC_WR_ADDR_RF_IN_P0 = func_FUNC_WR_ADDR_RF_IN_P0 ;
    FUNC_WR_DATA_RF_IN_P0 = func_FUNC_WR_DATA_RF_IN_P0 ;

    FUNC_CEN_RF_IN_P0 = {8{hqm_lsp_hqm_gated_clk_enable_rptr_f | hqm_clk_ungate}} & func_FUNC_CEN_RF_IN_P0 ;
    FUNC_CM_DATA_RF_IN_P0 = func_FUNC_CM_DATA_RF_IN_P0 ;
  end
    func_CM_MATCH_RF_OUT_P0 = CM_MATCH_RF_OUT_P0 ;

  //PF supports write only
  if ( | pf_FUNC_WEN_RF_IN_P0 ) begin
    FUNC_WEN_RF_IN_P0 = {8{hqm_lsp_hqm_gated_clk_enable_rptr_f | hqm_clk_ungate}} & pf_FUNC_WEN_RF_IN_P0 ;
    FUNC_WR_ADDR_RF_IN_P0 = pf_FUNC_WR_ADDR_RF_IN_P0 ;
    FUNC_WR_DATA_RF_IN_P0 = pf_FUNC_WR_DATA_RF_IN_P0 ;
  end

  //CFG supports read only
  if ( cfg_mem_re ) begin
    FUNC_REN_RF_IN_P0 = hqm_lsp_hqm_gated_clk_enable_rptr_f & cfg_mem_re ;
    FUNC_RD_ADDR_RF_IN_P0 = cfg_mem_addr [ 7 : 0 ] ; //HARDCODED 8*256
  end
  cfg_mem_rdata = '0 ;
  cfg_mem_ack = '0 ;
  if ( cfg_mem_re_f2 ) begin
    cfg_mem_rdata = { {(32-DWIDTH){1'b0}} , DATA_RF_OUT_P0_f [ ( cfg_mem_addr_f2 [ 10 : 8 ]  * DWIDTH ) +: DWIDTH ] } ; 
    cfg_mem_ack = 1'b1 ;
  end
end


////////////////////////////////////////////////////////////////////////////////////////////////////
assign bcam_AW_bcam_2048x26_rclk        = clk_pre_rcb_lcb ;
assign bcam_AW_bcam_2048x26_wclk        = clk_pre_rcb_lcb ;
assign bcam_AW_bcam_2048x26_cclk        = clk_pre_rcb_lcb ;
assign bcam_AW_bcam_2048x26_dfx_clk     = clk ;


assign bcam_AW_bcam_2048x26_we          = FUNC_WEN_RF_IN_P0 ;
assign bcam_AW_bcam_2048x26_waddr       = FUNC_WR_ADDR_RF_IN_P0 ;
assign bcam_AW_bcam_2048x26_wdata       = FUNC_WR_DATA_RF_IN_P0 ;

assign bcam_AW_bcam_2048x26_ce          = FUNC_CEN_RF_IN_P0 ;
assign bcam_AW_bcam_2048x26_cdata       = FUNC_CM_DATA_RF_IN_P0 ;

assign bcam_AW_bcam_2048x26_re          = FUNC_REN_RF_IN_P0 ;
assign bcam_AW_bcam_2048x26_raddr       = FUNC_RD_ADDR_RF_IN_P0 ;


assign DATA_RF_OUT_P0                   = bcam_AW_bcam_2048x26_rdata ;
assign CM_MATCH_RF_OUT_P0               = bcam_AW_bcam_2048x26_cmatch ;


////////////////////////////////////////////////////////////////////////////////////////////////////
logic error_f , error_next ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    error_f <= '0 ;
  end else begin
    error_f <= error_next ;
  end
end
always_comb begin
  error_next = hqm_lsp_hqm_gated_clk_enable_rptr_f & ( ( cfg_mem_we )
               | ( pf_FUNC_REN_RF_IN_P0 )
               | ( | pf_FUNC_CEN_RF_IN_P0 )
               | ( func_FUNC_REN_RF_IN_P0 )
               | ( ( | func_FUNC_WEN_RF_IN_P0 ) & ( | { func_FUNC_CEN_RF_IN_P0, pf_FUNC_WEN_RF_IN_P0, cfg_mem_re } ) )
               | ( ( | func_FUNC_CEN_RF_IN_P0 ) & ( | {                         pf_FUNC_WEN_RF_IN_P0, cfg_mem_re } ) )
               | ( ( | pf_FUNC_WEN_RF_IN_P0   ) &                                                     cfg_mem_re     )
               ) ;
end

assign error = error_f ;

logic unused_nc ;       // avoid lint warning
assign unused_nc        = | {   func_FUNC_RD_ADDR_RF_IN_P0 
                              , cfg_mem_minbit 
                              , cfg_mem_maxbit 
                              , cfg_mem_wdata 
                              , cfg_mem_cc_v 
                              , cfg_mem_cc_value 
                              , cfg_mem_cc_width 
                              , cfg_mem_cc_position 
                              , pf_FUNC_CM_DATA_RF_IN_P0 
                              , pf_FUNC_RD_ADDR_RF_IN_P0
                              , func_FUNC_REN_RF_IN_P0_f
                              , pf_FUNC_REN_RF_IN_P0_f  } ;

endmodule
