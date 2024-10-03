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
// File:         arf156b040e2r2w0cbbehbaa4acw_gclk_make_clk_and_rcb_ph1.sv
// Revision:     ClkRcb_v0.0
// Description:  Regional Clock Buffer Module
// Contact:      Mendoza, Oscar ; Jasveen Kaur
// Created:      Fri Oct 21 2014
// Modified:     
// Language:     System Verilog
// Package:      N/A
// Status:       Experimental (Do Not Distribute)
// Copyright (c) 2014, Intel Corporation, all rights reserved.
//----------------------------------------------------------------------------------------------------
// Detailed description:
// Implements Regional Clock Buffer
//----------------------------------------------------------------------------------------------------
// Configurable parameters
//	(see below)	Details in comments, note the reuse-pragmas for params which must not be modified
//****************************************************************************************************

///=====================================================================================================================
/// RCB Generation with LCP capability
///=====================================================================================================================

module arf156b040e2r2w0cbbehbaa4acw_gclk_make_clk_and_rcb_ph1 
(
	output logic   CkRcbX1N,		// RCB o/p clock                                                      
        input  logic   CkGridX1N,               // Input Grid Clock    
        input  logic   RPEn, 			// Regional Power Enable: (Idle=0, Functional=1)
        input  logic   RPOvrd,			// Regional Power Override: (Steady State =0, Override mode = 1)
        input  logic   FscanClkUngate,		// 10nm addition for SCAN 
        input  logic   Fd,			// LCP bit
        input  logic   Rd			// LCP bit
); 

   logic RcbEn;
// Latch is inside ctech    logic RcbEnL;
   
   always_comb begin
      RcbEn = RPEn  | RPOvrd | FscanClkUngate;
   end
   
// Latch is inside ctech     always_latch begin
// Latch is inside ctech      if (~(CkGridX1N)) RcbEnL <= RcbEn;
// Latch is inside ctech    end 
   
   
   // arf156b040e2r2w0cbbehbaa4acw_rcb_and
   arf156b040e2r2w0cbbehbaa4acw_rcb_and i_arf156b040e2r2w0cbbehbaa4acw_rcb_and(
     .clkout(CkRcbX1N),
     .clkb(CkGridX1N),
     .en(RcbEn),
     .fd(Fd),
     .rd(Rd)
   );

   
//   ctech_lib_clk_and_en i_ctech_lib_clk_and_en(
//   .clkout(CkRcbX1N),
//   .clk(CkGridX1N),
//   .en(RcbEnL));
   

endmodule