//----------------------------------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2023 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code ("Material") are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//----------------------------------------------------------------------------------------------------
// File:         arf104b256e1r1w0cbbehcaa4acw_bcam_mbist_outhandler
// Revision:     v0.0
// Description:  
// Contact:      Garg, Uttam K
// Created:      Thursday Nov  19 2015
// Modified:     Thursday Nov  19 2015
// Language:     System Verilog
// Package:      N/A
// Status:       Experimental (Do Not Distribute)
//----------------------------------------------------------------------------------------------------
// Detailed description:
// Implements CAM array Test logic 
//----------------------------------------------------------------------------------------------------
module arf104b256e1r1w0cbbehcaa4acw_bcam_mbist_outhandler
#(
//------------------------------------------------------------------------------------------------------------------------
// parameters
//------------------------------------------------------------------------------------------------------------------------
  parameter RF_ENTRIES            = 128,
  parameter RF_DWIDTH            = 72,
  parameter RF_AWIDTH            = 7,
  parameter RD_PORTS            = 1
)
(
   input  logic                      bist_clk,
   input  logic                      BIST_CM_MODE_RF_IN,  // User Defined - From MBIST
   input  logic                      BIST_CM_MATCH_SEL0_RF_IN,  // User Defined - From MBIST
   input  logic                      BIST_CM_MATCH_SEL1_RF_IN,  // User Defined - From MBIST
   input  logic    [RF_AWIDTH-1:0]   BIST_RD_ADDR_RF_IN_P0, // BIST Address - From MBIST
   input  logic    [RF_ENTRIES-1:0]  CM_MATCH_DATA_P0,  // Match Lines - From CAM
   input  logic    [RF_DWIDTH-1:0]   RD_DATA_RF_IN [RD_PORTS-1:0],  // DATA Out - From CAM
   output logic    [RF_DWIDTH-1:0]   RD_DATA_RF_OUT [RD_PORTS-1:0],
   output logic    [RF_ENTRIES-1:0]  CM_MATCH_REF_DATA
);
            
   logic [RF_ENTRIES-1:0] single_matchRefData;
   logic [RF_ENTRIES-1:0] single_mismatchRefData;
   logic [RF_ENTRIES-1:0] all_matchRefData;
   logic [RF_ENTRIES-1:0] all_mismatchRefData;
   logic [RF_ENTRIES-1:0] matchRefData;
   logic [RF_ENTRIES-1:0] compared_matchout;
   logic [RF_DWIDTH-1:0] cm_match_cmp_data;
   logic [RF_AWIDTH-1:0] BIST_ADDR_1h, BIST_ADDR_2h;

//========================================================
// One hot Address decoder And Expected Match Ref data gen
//========================================================

 always_ff @(posedge bist_clk)
  begin
      BIST_ADDR_1h <= BIST_RD_ADDR_RF_IN_P0;
      BIST_ADDR_2h <= BIST_ADDR_1h;
  end

   assign single_matchRefData = ({{(RF_ENTRIES-1){1'b0}},1'b1}) << BIST_ADDR_2h;
   assign single_mismatchRefData = ~single_matchRefData;
   assign all_matchRefData = {RF_ENTRIES{1'b1}};
   assign all_mismatchRefData = {RF_ENTRIES{1'b0}};
    
//   assign matchRefData = BIST_CM_ALL_MISMATCH_RF_IN ? all_mismatchRefData : ((BIST_CM_SINGLE_MATCH_RF_IN & ~BIST_CM_ALL_MATCH_RF_IN) ? single_matchRefData : all_matchRefData);
//BIST_CM_MATCH_SEL0_RF_IN & BIST_CM_MATCH_SEL1_RF_IN are used for decoding algo specific Reference data select as:
// 00 -> ALL MATCH
// 01 -> SINGLE MATCH
// 10 -> SINGLE MISMATCH
// 11 -> ALL MISMATCH

always_comb begin
    unique casez ({BIST_CM_MATCH_SEL1_RF_IN,BIST_CM_MATCH_SEL0_RF_IN})
      2'b00      : matchRefData = all_matchRefData;
      2'b01      : matchRefData = single_matchRefData;
      2'b10      : matchRefData = single_mismatchRefData;
      2'b11      : matchRefData = all_mismatchRefData;
      default    : matchRefData = '0;
    endcase
end

   assign CM_MATCH_REF_DATA = matchRefData;

//========================================================
// Match data comparator 
//========================================================

   assign compared_matchout = matchRefData ^ CM_MATCH_DATA_P0;

//=========================================
// Compactor/Expander logic
//=========================================

generate
  if (RF_DWIDTH < RF_ENTRIES) begin : match_cm_data_compactor
     localparam RF_DWIDTH_MULT = RF_ENTRIES/RF_DWIDTH;
     genvar i1, i2, i3;
     logic [RF_DWIDTH-1:0][RF_DWIDTH_MULT-1:0] cmp_data;
     logic [RF_DWIDTH-1:0] match_comp_data;
     for (i1 = 0; i1 <RF_DWIDTH ; i1 = i1 + 1) begin : combo_loop1
       for (i2 = 0; i2 <RF_DWIDTH_MULT ; i2 = i2 + 1) begin : combo_loop2
       assign cmp_data[i1][i2] = compared_matchout[i1+(i2*RF_DWIDTH)];
       end
     end
     for (i3 = 0; i3 <RF_DWIDTH ; i3 = i3 + 1) begin : combo_loop3
       assign match_comp_data[i3] = |cmp_data[i3];
     end
     if ((RF_ENTRIES % RF_DWIDTH) != 0) begin
     assign cm_match_cmp_data = match_comp_data | {compared_matchout[RF_ENTRIES-1:(RF_DWIDTH*RF_DWIDTH_MULT)],{(((RF_DWIDTH_MULT+1)*RF_DWIDTH)-RF_ENTRIES){1'b0}}};
     end 
     else if ((RF_ENTRIES % RF_DWIDTH) == 0) begin
     assign cm_match_cmp_data = match_comp_data;
     end
  end
endgenerate

generate
  if (RF_DWIDTH == RF_ENTRIES) begin : match_comp_data_eq
      assign cm_match_cmp_data = compared_matchout[RF_DWIDTH-1:0];
  end
endgenerate

generate
  if (RF_DWIDTH > RF_ENTRIES) begin : match_comp_data_expander
      assign cm_match_cmp_data = {compared_matchout[RF_ENTRIES-1:0],{(RF_DWIDTH-RF_ENTRIES){1'b0}}};
  end
endgenerate

genvar rp, i;
generate
for (rp=0; rp<RD_PORTS; rp++) begin : rp_portnum
  for (i=0; i<RF_DWIDTH; i++) begin : rddata_bit
    arf104b256e1r1w0cbbehcaa4acw_ctech_mux_2to1 instance_ctech_mux_2to1_rd_data_out
    ( .d1(cm_match_cmp_data[i]), .d2(RD_DATA_RF_IN[rp][i]), .s(BIST_CM_MODE_RF_IN), .o(RD_DATA_RF_OUT[rp][i]) );
  end
end
endgenerate

endmodule