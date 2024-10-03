
///
///  INTEL CONFIDENTIAL
///
///  Copyright 2015 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///
///====================================================================================================
///
///  INTEL CONFIDENTIAL
///
///  Copyright 2015 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///
//====================================================================================================
// File:         make_clk_and_rcb_ph1.sv
// Revision:     ClkRcb_v0.0
// Description:  Regional Clock Buffer Module
// Contact:      Mendoza, Oscar ; Jasveen Kaur
// Created:      Fri Oct 21 2014
// Modified:     
// Language:     System Verilog
// Package:      N/A
// Status:       Experimental (Do Not Distribute)
// Copyright (c) 2014, Intel Corporation, all rights reserved.
//====================================================================================================
// Detailed description:
// Implements Regional Clock Buffer
//====================================================================================================
// Configurable parameters
//	(see below)	Details in comments, note the reuse-pragmas for params which must not be modified
//****************************************************************************************************

///=====================================================================================================================
/// RCB & LCB Generation with LCP capability
///=====================================================================================================================

module hqm_rcfwl_gclk_make_clk_rcb_lcb_ph1  
(
	output	logic	CkLcbXPN,		// LCB o/p clk
	output	logic	CkRcbXPN,		// RCB o/p clk
	
	// RCB
        input  logic   CkGridX1N,               // Input Grid Clock    
        input  logic   RPEn, 			// Regional Power Enable: (Idle=0, Functional=1)
        input  logic   RPOvrd,			// Regional Power Override: (Steady State =0, Override mode = 1)
        input  logic   FscanClkUngate		// 10nm addition for SCAN 
	
); 

  // RCB
  hqm_rcfwl_gclk_make_clk_and_rcb_ph1 i_gclk_make_clk_and_rcb_ph1(
  .CkRcbX1N(CkRcbXPN),
  .CkGridX1N(CkGridX1N),
  .RPEn(RPEn),
  .RPOvrd(RPOvrd),
  .FscanClkUngate(FscanClkUngate),
  .Fd(1'b0),
  .Rd(1'b1)
  );
  
  // LCB
  hqm_rcfwl_gclk_make_lcb_loc_and i_glck_make_lcb_loc_and(
  .CkLcbXPN(CkLcbXPN), 
  .CkRcbXPN(CkRcbXPN),
  .FcEn(1'b1),
  .LPEn(1'b1),
  .LPOvrd(1'b0),
  .FscanClkUngate(FscanClkUngate)
  );

endmodule
