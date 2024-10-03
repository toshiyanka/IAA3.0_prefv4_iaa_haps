//------------------------------------------------------------------------------
//INTEL CONFIDENTIAL
//
//Copyright 2020 Intel Corporation All Rights Reserved.
//
//The source code contained or described herein and all documents related
//to the source code (Material) are owned by Intel Corporation or its
//suppliers or licensors. Title to the Material remains with Intel
//Corporation or its suppliers and licensors. The Material contains trade
//secrets and proprietary and confidential information of Intel or its
//suppliers and licensors. The Material is protected by worldwide copyright
//and trade secret laws and treaty provisions. No part of the Material may
//be used, copied, reproduced, modified, published, uploaded, posted,
//transmitted, distributed, or disclosed in any way without Intel's prior
//express written permission.
//
//No license under any patent, copyright, trade secret or other intellectual
//property right is granted to or conferred upon you by disclosure or
//delivery of the Materials, either expressly, by implication, inducement,
//estoppel or otherwise. Any license under such intellectual property rights
//must be express and approved by Intel in writing.
//-------------------------------------------------------------------------------
//
//  Collateral Description:
//  ip-stap
//
//  Source organization:
//  CSG - SIP Engineering
//
//  Support Information:
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  
//
//  Module <mapfile> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
//    FILENAME    : stap_ctech_map.sv
//    DESIGNER    : Vikram Sharma 
//    PROJECT     : stap_ctech
//    PURPOSE     : ctech cells map file for stap_ctech IP
//----------------------------------------------------------------------

//---------------------------------------------------------------
// Clock Buffer 
//---------------------------------------------------------------
   
module stap_ctech_lib_clk_buf
   (
   input   logic   clk,
   output  logic   clkout
   );

   ctech_lib_clk_buf
   i_ctech_lib_clk_buf
   (
        .clk(clk),
        .clkout(clkout)
   );

endmodule

module stap_ctech_lib_and
   (
   input   logic   a,
   input   logic   b,
   output  logic   o
   );

   ctech_lib_and
   i_ctech_lib_and
   (
        .a(a),
        .b(b),
        .o(o)
   );

endmodule

module stap_ctech_lib_mux_2to1
   (
   input   logic   d1,
   input   logic   d2,
   input   logic   s,
   output  logic   o
   );

   ctech_lib_mux_2to1
   i_ctech_lib_mux_2to1
   (
        .d1(d1),
        .d2(d2),
        .s(s),
        .o(o)
   );

endmodule

module stap_ctech_lib_clk_gate_te
   (
   input   logic   en,
   input   logic   te,
   input   logic   clk,
   output  logic   clkout 
   );

   ctech_lib_clk_gate_te
   i_ctech_lib_clk_gate_te
   (
        .en(en),
        .te(te),
        .clk(clk),
        .clkout(clkout)
   );

endmodule

module stap_ctech_lib_clk_mux_2to1
   (
   input   logic   clk1,
   input   logic   clk2,
   input   logic   s,
   output  logic   clkout 
   );

   ctech_lib_clk_mux_2to1
   i_ctech_lib_clk_mux_2to1
   (
        .clk1(clk1),
        .clk2(clk2),
        .s(s),
        .clkout(clkout)
   );

endmodule

