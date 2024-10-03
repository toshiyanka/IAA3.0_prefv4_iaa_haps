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
// AW_sticky_bit
//
// This module is responsible for implementing "sticky" bits by capturing signals once they set and
// then keeping those bits set until cleared by a write operation with the wdata value set to '1' in
// the bit positin to be cleared.
// The primary use is for remembering error conditions or interrupts that have occurred.
// The diag input puts the register into a normal R/W mode for testing.
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapath that is registered
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_sticky_bit
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 1
) (
	 input	logic			clk
	,input	logic			rst_n

	,input	logic			diag

	,input	logic	[WIDTH-1:0]	d
	
	,input	logic			write
	,input	logic	[WIDTH-1:0]	wdata

	,output	logic	[WIDTH-1:0]	q
);

// diag	write	wdata[n] q_q[n]	d[n]	q_q_next[n]
//
//   x	  0	   x	   0	 0	    0		Functional Mode: No Action
//   x	  0	   x	   0	 1	    1		Functional Mode: Latch Current Error
//   x	  0	   x	   1	 x	    1		Functional Mode: Remember Previous Error
//
//   0	  1	   0	   0	 0	    0		Functional Mode: No Action
//   0	  1	   0	   0	 1	    1		Functional Mode: Latch Current Error
//   0	  1	   0	   1	 x	    1		Functional Mode: Remember Previous Error
//   0	  1	   1	   x	 x	    0		Functional Mode: Clear on Write With 1
//
//   1	  1	   0	   x	 x	    0		Diagnostic Mode: Write 0
//   1	  1	   1	   x	 x	    1		Diagnostic Mode: Write 1

logic	[WIDTH-1:0]	q_q;

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  q_q <= {WIDTH{1'b0}};
 end else begin
  q_q <= (write) ? ((diag) ? wdata : (~wdata & (q_q | d))) : (q_q | d);
 end
end

assign q = q_q;

endmodule // AW_sticky_bit

