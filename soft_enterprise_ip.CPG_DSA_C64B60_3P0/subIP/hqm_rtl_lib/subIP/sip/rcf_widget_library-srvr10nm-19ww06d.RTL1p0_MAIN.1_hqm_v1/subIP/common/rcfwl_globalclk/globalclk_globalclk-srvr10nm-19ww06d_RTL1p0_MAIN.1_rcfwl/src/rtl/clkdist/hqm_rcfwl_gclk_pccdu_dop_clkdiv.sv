
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
// File:         pccdu_dop_clkdiv.sv
// Revision:     10nm_srvr_chassis_0p3
// Description:  clock divider for clock grid drop off point driver
// Contact:      Pratik Bhatt, Rich Gammack, Glenn Colon-Bonet
// Created:      Fri Apr 10 04:31:41 PDT 2015
// Modified:     Thu Apr 23 05:01:39 PDT 2015
// Language:     System Verilog
// Package:      N/A
// Status:       Experimental (Do Not Distribute)
// Copyright (c) 2015, Intel Corporation, all rights reserved.
//====================================================================================================
// Detailed description:
//     The clock divider circuit implements a programmable clock divider to
//     produce a 50% duty cycle output clock.  The divider includes a reset
//     signal which clears the divider and brings the output low.  On the next
//     input clock rising edge after reset deassert, the output clock will go
//     high.  The reset signal is intended to be generated as a single cycle
//     pulse from the rising edge of the USYNC alignment signal.
//
//     Note that this version of the DOP clock is a behavioral model only for scan
//     system validation purposes.  The clock team maintains the proper code
//     base for the clock divider circuit.  It is meant to match behavior of the clock
//     DOP divider circuit, but is a greatly simplified abstraction.
//====================================================================================================
// Configurable parameters
//     DIVISOR = divides the primary grid clock to create the output
//     clock.  Divisor values of 0 or 1 will not have a divider, and divider
//     values of 2 and higher will implement a clock divider circuit.
//====================================================================================================

module hqm_rcfwl_gclk_pccdu_dop_clkdiv
    #(  parameter int DIVISOR = 1
    ) (
	input  logic clk,
	input  logic rst_b,
	output logic clkdiv
    );

generate
    if ((DIVISOR == 0) || (DIVISOR == 1)) // div1 is a buffer
    begin : nodiv
	assign clkdiv = clk; 
    end
    else if(DIVISOR == 2) // special case for div by 2
    begin : div2
	always_ff @(posedge clk) 
        begin   
	    if (~rst_b) 
	        clkdiv = 1'b0;  
	    else 
	        clkdiv = ~clkdiv;  
	end
    end
    else // divider is needed
    begin : div
	localparam DIVBITS = $clog2(DIVISOR);
	localparam bit [DIVBITS-1:0] DIV = DIVISOR;		// keep lint happy
	localparam bit [DIVBITS-1:0] DIVM1 = DIVISOR-1;		// keep lint happy
	localparam bit [DIVBITS-1:0] DIVHALF = (DIVISOR+1)/2;	// keep lint happy
	logic [DIVBITS-1:0] divcnt, divcnt_in;
	logic cnt_is_zero, cnt_is_half;
	logic posclk, posclk_in;

	always_comb
	begin
	    cnt_is_zero = ~(|divcnt); // count value is zero
	    cnt_is_half = (divcnt == DIVHALF); // count matches half of divisor (round up)
	    divcnt_in = cnt_is_zero ? (DIVM1) : divcnt - {{(DIVBITS-1){1'b0}},1'b1}; // down count and reload on zero
	    // set the output posclk to 1 on a count value of zero, reset at half count (synchronous S/R flip flop)
	    posclk_in = cnt_is_zero ? 1'b1 : (cnt_is_half ? 1'b0 : posclk);
	end

	// instantiate the counter FF's
	always_ff @(posedge clk) 
        begin   
	    if (~rst_b) 
	        divcnt <= {DIVBITS{1'b0}};  
	    else 
	        divcnt <= divcnt_in;
	end

	// instantiate the positive edge clock
	always_ff @(posedge clk)
	begin
	    if (~rst_b) 
	        posclk = 1'b0;
	    else 
	        posclk = posclk_in;
	end

	if ((DIVISOR % 2) == 0) // even divisor
	begin : even_divisor
	    assign clkdiv = posclk; // output clock is just the SR flop output
	end
	else 
	begin : odd_divisor
	    logic negclk;

	    // negedge FF to generate the delayed version of SR output for odd divisors
	    always_ff @(negedge clk)
	    begin
		if (~rst_b) 
		    negclk = 1'b0;
		else 
		    negclk = posclk;
	    end
	    // generate the clock OR for the output of the pos/neg versions to
	    // create 50% duty cycle
	    hqm_rcfwl_gclk_ctech_clk_or i_ctech_lib_clk_or(
		 .clkout(clkdiv),
		 .clk1  (negclk),
		 .clk2  (posclk)
	    );
	end
    end
endgenerate
endmodule
