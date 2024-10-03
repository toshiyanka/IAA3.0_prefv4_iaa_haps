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
// File:         arf124b064e1r1w0cbbehbaa4acw_bcam_mbist_inhandler
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
module arf124b064e1r1w0cbbehbaa4acw_bcam_mbist_inhandler
#(
//------------------------------------------------------------------------------------------------------------------------
// parameters
//------------------------------------------------------------------------------------------------------------------------
	parameter RF_DWIDTH						= 72,
	parameter WR_PORTS						= 1,
	parameter CAM_MATCH_ATPG_EN					= 0

)
(
   input  logic                      bist_clk,
   input  logic                      rst_b,
   input  logic                      BIST_CM_MODE_RF_IN, // User Defined - From MBIST
   input  logic                      BIST_ROTATE_MASK_RF_IN, // User Defined - From MBIST
   input  logic                      BIST_CD_MASK_ENABLE_RF_IN, // User Defined - From MBIST
   input 	logic                      BIST_DATA_INV_RF_IN, // User Defined - From MBIST
   input  logic    [RF_DWIDTH-1:0]   BIST_WR_DATA_RF_IN [WR_PORTS-1:0], // BIST Write Data - From MBIST
   input  logic    [RF_DWIDTH-1:0]   BIST_CM_DATA_RF_IN_P0, // BIST CAM Data
   input  logic    [RF_DWIDTH-1:0]   CM_DATA_RF_IN_P0 , //CM data to MEM
   input	logic                      FSCAN_MODE,
   output logic    [RF_DWIDTH-1:0]   BIST_WR_DATA_RF_OUT [WR_PORTS-1:0],
   output logic    [RF_DWIDTH-1:0]   BIST_CM_DATA_RF_P0
);

   logic [RF_DWIDTH-1:0]   BIST_MASK;
   logic [RF_DWIDTH-1:0]   BIST_COMPARE_DATA;
  
//========================================================
// Shift Register
//========================================================

   genvar j;
   generate
   if (CAM_MATCH_ATPG_EN == 1) begin: atpg_support
   for (j=0; j<RF_DWIDTH; j=j+1) begin: shift_reg_atpg_support
     if (j==0) begin
       always_ff @(posedge bist_clk) begin
        if (~rst_b) BIST_MASK[j] <= 1'b1;
        else if (BIST_ROTATE_MASK_RF_IN) BIST_MASK[j] <= BIST_MASK[RF_DWIDTH-1:RF_DWIDTH-1];
        else if (FSCAN_MODE) BIST_MASK[j] <= CM_DATA_RF_IN_P0[j];
       end
     end
     else if (j>0) begin
       always_ff @(posedge bist_clk) begin
        if (~rst_b) BIST_MASK[j] <= 1'b0;
        else if (BIST_ROTATE_MASK_RF_IN) BIST_MASK[j] <= BIST_MASK[j-1:j-1];
        else if (FSCAN_MODE) BIST_MASK[j] <= CM_DATA_RF_IN_P0[j];
       end
     end
   end : shift_reg_atpg_support
   end : atpg_support
   else begin: non_atpg_support	
   for (j=0; j<RF_DWIDTH; j=j+1) begin: shift_reg
     if (j==0) begin
       always_ff @(posedge bist_clk) begin
        if (~rst_b) BIST_MASK[j] <= 1'b1;
        else if (BIST_ROTATE_MASK_RF_IN) BIST_MASK[j] <= BIST_MASK[RF_DWIDTH-1:RF_DWIDTH-1];
       end
     end
     else if (j>0) begin
       always_ff @(posedge bist_clk) begin
        if (~rst_b) BIST_MASK[j] <= 1'b0;
        else if (BIST_ROTATE_MASK_RF_IN) BIST_MASK[j] <= BIST_MASK[j-1:j-1];
       end
     end
   end : shift_reg
   end: non_atpg_support
   endgenerate
 
//========================================================
// Compare Data Gen
//========================================================
  genvar h, wp;
   generate
   for (wp=0; wp<WR_PORTS; wp++) begin : wr_portnum
   for (h=0; h<RF_DWIDTH; h=h+1) begin: comb1
      assign  BIST_WR_DATA_RF_OUT[wp][h] = BIST_DATA_INV_RF_IN ^ BIST_WR_DATA_RF_IN[wp][h:h];
   end
   end
   endgenerate 

   genvar i;
   generate
   for (i=0; i<RF_DWIDTH; i=i+1) begin: comb2 
      assign  BIST_COMPARE_DATA[i] = (BIST_CD_MASK_ENABLE_RF_IN & BIST_MASK[i:i])^(BIST_WR_DATA_RF_OUT[0][i:i]);
   end 
   endgenerate 

   assign     BIST_CM_DATA_RF_P0  = (BIST_CM_MODE_RF_IN)? BIST_COMPARE_DATA : BIST_CM_DATA_RF_IN_P0;
 
endmodule