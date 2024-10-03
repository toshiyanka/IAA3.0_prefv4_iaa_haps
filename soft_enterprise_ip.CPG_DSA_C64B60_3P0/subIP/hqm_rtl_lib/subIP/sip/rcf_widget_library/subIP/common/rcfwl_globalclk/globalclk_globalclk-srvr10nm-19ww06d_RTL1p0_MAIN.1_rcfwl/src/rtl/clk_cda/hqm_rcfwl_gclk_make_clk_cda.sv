
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
// File:         make_clk_cda.sv
// Revision:     ClkCda_v0.0
// Description:  Regional Clock Distribution 
// Contact:      Flint, Jennifer; Huddart, Mark 
// Created:      Fri Oct 1 2016
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
/// CDA Generation with LCP capability
///=====================================================================================================================

module hqm_rcfwl_gclk_make_clk_cda  
(
	// Clock in/out
        input  logic   clk_in,          // Input Clock  
	output	logic  clk_out,		// Output Clock
	
        // LCP shift chain for config
	input  logic CkLcpXPNB,
        input  logic reset_b,
	
        input  logic CdaDatIn,
        output logic CdaDatOut
	
	
); 

  // "LCP" Registers
  logic [3:0] LcpReg;
  
  // Decode
  logic [14:0] cda_decode;

  // CDA
  // Local copy until ctech is available
   hqm_rcfwl_gclk_ctech_sdg_programmable_delay_clk_buf i_ctech_lib_sdg_programmable_delay_clk_buf(
    .clk(clk_in),
    .rsel0(cda_decode[0]),
    .rsel1(cda_decode[1]),
    .rsel2(cda_decode[2]),
    .rsel3(cda_decode[3]),
    .rsel4(cda_decode[4]),
    .rsel5(cda_decode[5]),
    .rsel6(cda_decode[6]),
    .rsel7(cda_decode[7]),
    .rsel8(cda_decode[8]),
    .rsel9(cda_decode[9]),
    .rsel10(cda_decode[10]),
    .rsel11(cda_decode[11]),
    .rsel12(cda_decode[12]),
    .rsel13(cda_decode[13]),
    .rsel14(cda_decode[14]),
    .clkout(clk_out)	
  );

  // 4:15 decode
  always_comb 
  begin
    unique casez (LcpReg)
      4'b0000: cda_decode = 15'b000_0000_0000_0000;
      4'b0001: cda_decode = 15'b000_0000_0000_0001;
      4'b0010: cda_decode = 15'b000_0000_0000_0011;
      4'b0011: cda_decode = 15'b000_0000_0000_0111;
      4'b0100: cda_decode = 15'b000_0000_0000_1111;
      4'b0101: cda_decode = 15'b000_0000_0001_1111;
      4'b0110: cda_decode = 15'b000_0000_0011_1111;
      4'b0111: cda_decode = 15'b000_0000_0111_1111;
      4'b1000: cda_decode = 15'b000_0000_1111_1111;
      4'b1001: cda_decode = 15'b000_0001_1111_1111;
      4'b1010: cda_decode = 15'b000_0011_1111_1111;
      4'b1011: cda_decode = 15'b000_0111_1111_1111;
      4'b1100: cda_decode = 15'b000_1111_1111_1111;
      4'b1101: cda_decode = 15'b001_1111_1111_1111;
      4'b1110: cda_decode = 15'b011_1111_1111_1111;
      4'b1111: cda_decode = 15'b111_1111_1111_1111;
      default: cda_decode = 15'b000_0000_0000_0000;
    endcase
  end

  
  always_ff @(posedge CkLcpXPNB or negedge reset_b)
  begin
    if (~reset_b) begin
      LcpReg <= 4'b0;    
    end 
    else begin
      LcpReg <= {CdaDatIn, LcpReg[3:1]};
    end
  end
    
  // B-latch on output
  always_latch 
  begin
    if (~CkLcpXPNB)
    begin
      CdaDatOut <= LcpReg[0];
    end
  end
  

endmodule
