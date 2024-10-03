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
//  common AW to provide direct functional access to a RAM, no config or pf reset.
//
//-----------------------------------------------------------------------------------------------------
module hqm_AW_dc_rfw_access
      import hqm_AW_pkg::*; #(
      parameter DEPTH                           = 1024
    , parameter DWIDTH                          = 64
    , parameter AWIDTHPAD                       = 0
    , parameter DWIDTHPAD                       = 0
    , parameter IPAR_BITS                       = 0
    //..............................................................................
    , parameter AWIDTH                          = ( AW_logb2 ( DEPTH - 1 ) + 1 ) + AWIDTHPAD
    , parameter PWIDTH                          = DWIDTH + DWIDTHPAD
) (
    //------------------------------------------------------------------------------------------
    // Input side
      input  logic                              rclk
    , input  logic                              rrst_n
    , input  logic                              wclk
    , input  logic                              wrst_n

    , input  logic                              func_mem_re
    , input  logic [ ( AWIDTH ) - 1 : 0 ]       func_mem_raddr
    , input  logic [ ( AWIDTH ) - 1 : 0 ]       func_mem_waddr
    , input  logic                              func_mem_we
    , input  logic [ ( PWIDTH ) - 1 : 0 ]       func_mem_wdata
    , output logic [ ( PWIDTH ) - 1 : 0 ]       func_mem_rdata

    , output logic                              mem_rclk
    , output logic                              mem_rclk_rst_n
    , output logic                              mem_wclk
    , output logic                              mem_wclk_rst_n

    , output logic                              mem_re
    , output logic [ ( AWIDTH ) - 1 : 0 ]       mem_raddr
    , output logic [ ( AWIDTH ) - 1 : 0 ]       mem_waddr
    , output logic                              mem_we
    , output logic [( PWIDTH + IPAR_BITS )-1:0] mem_wdata
    , input  logic [( PWIDTH + IPAR_BITS )-1:0] mem_rdata
    , output logic                              mem_rdata_error
) ;

assign mem_rclk         = rclk ;
assign mem_rclk_rst_n   = rrst_n ;
assign mem_wclk         = wclk ;
assign mem_wclk_rst_n   = wrst_n ;

assign mem_we           = func_mem_we ;
assign mem_re           = func_mem_re ;
assign mem_raddr        = func_mem_raddr ;
assign mem_waddr        = func_mem_waddr ;

generate

if (IPAR_BITS == 0) begin: g_no_ipar

  assign mem_wdata            = func_mem_wdata ;
  assign func_mem_rdata       = mem_rdata;
  assign mem_rdata_error      = '0;

end else begin: g_ipar

  hqm_AW_ipar_wrap #(

     .PWIDTH            (IPAR_BITS)
    ,.DWIDTH            (PWIDTH)

  ) i_ipar (

     .mem_wdata_in      (func_mem_wdata)
    ,.mem_wdata_out     (mem_wdata)
    ,.mem_rdata_in      (mem_rdata)
    ,.rclk              (rclk)
    ,.rclk_rst_n        (rrst_n)
    ,.re                (mem_re)
    ,.mem_rdata_out     (func_mem_rdata)
    ,.cfg_errorinj      (1'b0)
    ,.error             (mem_rdata_error)
  );

end

endgenerate

endmodule
