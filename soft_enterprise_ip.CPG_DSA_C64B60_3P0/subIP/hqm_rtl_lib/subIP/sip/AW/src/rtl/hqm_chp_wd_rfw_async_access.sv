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
//  common AW to provide functional , config , and pf reset access to a RAM.
//
//-----------------------------------------------------------------------------------------------------
module hqm_chp_wd_rfw_async_access
      import hqm_AW_pkg::*; #(
      parameter DEPTH                           = 1024
    , parameter DWIDTH                          = 32
    , parameter RESIDUE                         = 1
    , parameter AWIDTHPAD                       = 0
    , parameter DWIDTHPAD                       = 0
    //..............................................................................
    , parameter AWIDTH                          = ( AW_logb2 ( DEPTH - 1 ) + 1 )
    , parameter PWIDTH                          = DWIDTH + DWIDTHPAD
) (
    //------------------------------------------------------------------------------------------
    // Input side
      input  logic                              clk 
    , input  logic                              rst_n 

    , input  logic                              mem_clk 
    , input  logic                              mem_rst_n 

    , input  logic                              func_mem_re
    , input  logic [ ( AWIDTH ) - 1 : 0 ]       func_mem_raddr
    , input  logic [ ( AWIDTH ) - 1 : 0 ]       func_mem_waddr
    , input  logic                              func_mem_we
    , input  logic [ ( DWIDTH ) - 1 : 0 ]       func_mem_wdata
    , output logic [ ( DWIDTH ) - 1 : 0 ]       func_mem_rdata

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
    , input  logic [ ( AWIDTH ) - 1 : 0 ]       pf_mem_raddr
    , input  logic [ ( AWIDTH ) - 1 : 0 ]       pf_mem_waddr
    , input  logic                              pf_mem_we
    , input  logic [ ( DWIDTH ) - 1 : 0 ]       pf_mem_wdata
    , output logic [ ( DWIDTH ) - 1 : 0 ]       pf_mem_rdata

    , output logic                              mem_rclk
    , output logic                              mem_rclk_rst_n
    , output logic                              mem_wclk
    , output logic                              mem_wclk_rst_n

    , output logic                              mem_re
    , output logic [ ( AWIDTH ) - 1 : 0 ]       mem_raddr
    , output logic [ ( AWIDTH ) - 1 : 0 ]       mem_waddr
    , output logic                              mem_we
    , output logic [ ( DWIDTH ) - 1 : 0 ]       mem_wdata
    , input  logic [ ( DWIDTH ) - 1 : 0 ]       mem_rdata

    , output logic                              error
) ;



////////////////////////////////////////////////////////////////////////////////////////////////////

// All of the logic that externally drives the write signals and receives the read data is clocked by
// the clock which is connected to mem_clk, so use that for both "rclk" and "wclk".
assign mem_rclk         = mem_clk ;
assign mem_rclk_rst_n   = mem_rst_n ;
assign mem_wclk         = mem_clk ;
assign mem_wclk_rst_n   = mem_rst_n ;

always_comb begin

    mem_re = 1'b0;
    mem_we = 1'b0;
mem_raddr = '0 ;
mem_waddr = '0 ;
mem_wdata = '0 ;

    // CFG
    cfg_mem_ack = '0 ;
    cfg_mem_rdata = '0 ;

    // FUNC
    if ( func_mem_re | func_mem_we ) begin
      mem_re = func_mem_re ;
      mem_raddr = func_mem_raddr ;
      mem_waddr = func_mem_waddr ;
      mem_we = func_mem_we ;
      mem_wdata = func_mem_wdata ;
    end
    func_mem_rdata = '0 ;
      func_mem_rdata = mem_rdata ;

   // PF
   if ( pf_mem_re | pf_mem_we ) begin
     mem_re = pf_mem_re ;
     mem_raddr = pf_mem_raddr ;
     mem_waddr = pf_mem_waddr ;
     mem_we = pf_mem_we ;
     mem_wdata = pf_mem_wdata ;
   end

   pf_mem_rdata = '0 ;
     pf_mem_rdata = mem_rdata ;

end


////////////////////////////////////////////////////////////////////////////////////////////////////
//https://hsdes.intel.com/resource/2204092573
assign error = 1'b0;

// unused 
logic cfg_mem_cc_nc ;
assign cfg_mem_cc_nc = cfg_mem_re | (|cfg_mem_addr) | (|cfg_mem_minbit) | (|cfg_mem_maxbit) | cfg_mem_we | (|cfg_mem_wdata ) | cfg_mem_cc_v | (|cfg_mem_cc_value) | (|cfg_mem_cc_width) | (|cfg_mem_cc_position) |
                       clk | rst_n ;

endmodule
