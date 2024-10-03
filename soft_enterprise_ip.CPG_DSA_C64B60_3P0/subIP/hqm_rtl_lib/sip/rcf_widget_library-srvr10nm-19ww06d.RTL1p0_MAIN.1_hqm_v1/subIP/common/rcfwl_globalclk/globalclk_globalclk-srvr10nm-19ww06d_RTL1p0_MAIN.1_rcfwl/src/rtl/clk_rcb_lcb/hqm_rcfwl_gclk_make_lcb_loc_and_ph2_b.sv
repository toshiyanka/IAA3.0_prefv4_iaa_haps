
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
// File:         make_lcb_loc_and_ph2_b.sv
// Revision:     ClkLcb_v0.0
// Description:  Local Clock Buffer Module
// Contact:      Mendoza, Oscar ; Jasveen Kaur
// Created:      Fri Oct 23 2014
// Modified:     
// Language:     System Verilog
// Package:      N/A
// Status:       Experimental (Do Not Distribute)
// Copyright (c) 2014, Intel Corporation, all rights reserved.
//====================================================================================================
// Detailed description:
// Implements Local Clock Buffer
//====================================================================================================
// Configurable parameters
//	(see below)	Details in comments, note the reuse-pragmas for params which must not be modified
//****************************************************************************************************

module hqm_rcfwl_gclk_make_lcb_loc_and_ph2_b
(    
	output	logic	CkLcbXPNB,		// LCB o/p clk
	input	logic	CkRcbXPNB,		// LCB i/p clk from RCB o/p                
	input	logic	FcEn,			// Functional Enable
	input	logic	LPEn,			// Local Power Enable
	input	logic	LPOvrd,			// Local Power Override 
        input   logic   FscanClkUngate		// 10nm addition for SCAN 
);

   logic LcbEn;
   logic LatLcbEn;
   logic CkLcbXPN;
   
   always_comb begin
     LcbEn = FscanClkUngate | (FcEn & (LPEn | LPOvrd));
   end

   
    always_latch begin
      if (~(CkRcbXPNB)) LatLcbEn <= LcbEn;
    end 
   
    // Clock AND
   // Same as gclk_ctech_clk_and_en, just different BE cell (and rather than nand-inv)
    hqm_rcfwl_gclk_ctech_clk_and_en_lcb i_ctech_lib_clk_and_en(
    .clkout(CkLcbXPN),
    .clk(CkRcbXPNB),
    .en(LatLcbEn));
   
   // Clock INV
   hqm_rcfwl_gclk_ctech_clk_inv i_ctech_lib_clk_inv(
   .clkout(CkLcbXPNB),
   .clk(CkLcbXPN)
   );

endmodule
