    
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
//------------------------------------------------------------------------------
//====================================================================================================
// File:         clkdist_ccdu.sv
// Revision:     10nm_srvr_chassis_0p3
// Description:  Clock Control Distribution Unit - grid clock driver with scan support
// Contact:      Rich Gammack, Mark Huddart, Glenn Colon-Bonet
// Created:      Fri Apr 10 04:31:41 PDT 2015
// Modified:     Fri Apr 10 04:31:52 PDT 2015
// Language:     System Verilog
// Package:      N/A
// Status:       Experimental (Do Not Distribute)
// Copyright (c) 2015, Intel Corporation, all rights reserved.
//====================================================================================================
// Detailed description:
//  Clock Control Distribution Unit - grid clock driver with scan support.
//  The CCDU is a parameterized module which generates a set of gridded clock
//  drivers (DOPs) for a partition.  Each clock driver DOP has a programmable
//  divisor, allowing the DOP output (secondary domain) to be a divided down version of the
//  primary grid input (primary domain).  Dividers must be synchronized within
//  a primary domain, so the preclk_div_sync input periodically resets these
//  dividers to guarantee alignment of the secondary clocks derived from
//  a primary domain.
//
//  For each primary domain input, the module will also generate a free running copy of 
//  the primary clock for use by the DFx and PMA subsystems.  
//
//  This module is parameterized to support any number of primary grid domain
//  inputs (NUM_OF_GRID_PRI_CLKS) and generate any number of secondary domain 
//  outputs (NUM_OF_GRID_SCC_CLKS).  Two parameters control the association of
//  the DOP outputs to the primary grid source and divisors:
//  	GRID_SCC_PRICLK_MATRIX	- defines which primary domain clock is the source for each DOP
//  	GRID_SCC_DIVISOR_MATRIX	- defines the divisor value for each DOP
//  Detailed information about these parameters is included in the comments below.
//  It is possible to define clocks in any order, however, it is advised to
//  group entries by primary domain within the matrices, as shown in the
//  examples below.
//
//  Scan support is included for the non-free running postdop clocks.  Each
//  secondary clock has a scan clock input which drives the DOP clock output
//  during scan shift and slow speed capture.  
//
//  The dop_clken input is used to gate the functional clock both for scan and
//  power management uses.
//
//  The CCDU module is distributed as part of the STF Scan Subsystem as it is
//  a common module between clock distribution and scan.  Any changes to this
//  code must be managed through the PCR tracking process between clockdist
//  and scan teams.
//
//====================================================================================================
// Configurable parameters
//     (see below)     Details in comments, note the reuse-pragmas for params which must not be modified
//====================================================================================================


module hqm_rcfwl_gclk_pccdu_dop_wrapper
   #(
      	parameter NUM_OF_GRID_PRI_CLKS ='d3,          	// number of primary grid domain clocks
      	parameter NUM_OF_GRID_SCC_CLKS = 'd6,          	// number of DOP (secondary) output clocks
      	parameter GRID_PRICLK_BITS = 'd4,              	// number of bits needed to specify # of pri clocks
      	parameter GRID_DIVISOR_BITS= 'd4 ,              // number of bits needed to specify divisors used by DOPs
	parameter [NUM_OF_GRID_SCC_CLKS*GRID_PRICLK_BITS-1:0] GRID_SCC_PRICLK_MATRIX =
	{4'd2, 	// dopclk[5] <- driven by prigrid[2]
	 4'd1,	// dopclk[4] <- driven by prigrid[1]
	 4'd1,	// dopclk[3] <- driven by prigrid[1]
	 4'd0,	// dopclk[2] <- driven by prigrid[0]
	 4'd0,	// dopclk[1] <- driven by prigrid[0]
	 4'd0},	// dopclk[0] <- driven by prigrid[0]
	 
        parameter [NUM_OF_GRID_SCC_CLKS*GRID_DIVISOR_BITS-1:0] GRID_SCC_DIVISOR_MATRIX =
	{4'd1,	// dopclk[5] <- driven by prigrid[2] / 1
	 4'd2,	// dopclk[4] <- driven by prigrid[1] / 2
	 4'd1,	// dopclk[3] <- driven by prigrid[1] / 1
	 4'd4,	// dopclk[2] <- driven by prigrid[0] / 4
	 4'd2,	// dopclk[1] <- driven by prigrid[0] / 2
	 4'd1},	// dopclk[0] <- driven by prigrid[0] / 1		
	
      	parameter NUM_OF_GRID_NONSCAN_CLKS = 'd0 ,          	// number of DOP free running nonscan divided clocks to instantiate 
	parameter [((NUM_OF_GRID_NONSCAN_CLKS >0 ? NUM_OF_GRID_NONSCAN_CLKS : 1) *GRID_PRICLK_BITS )-1:0] GRID_NONSCAN_PRICLK_MATRIX = 'd0,
	parameter [((NUM_OF_GRID_NONSCAN_CLKS >0 ? NUM_OF_GRID_NONSCAN_CLKS : 1) *GRID_DIVISOR_BITS)-1:0] GRID_NONSCAN_DIVISOR_MATRIX = 'd0
    )
 (
  input	 logic  [NUM_OF_GRID_PRI_CLKS-1:0]	fdop_preclk_grid,      	// primary grid clock inputs
  input  logic  [NUM_OF_GRID_PRI_CLKS-1:0]	fdop_preclk_div_sync, 	// Sync from CDU
  input  logic  [NUM_OF_GRID_PRI_CLKS-1:0]	fdop_preclk_div_sync_free, 	// Sync from PMA/repeater to bypass SSS
  input	 logic  [NUM_OF_GRID_SCC_CLKS-1:0]	fdop_scan_clk, 		// Scan clock 
  input	 logic  [NUM_OF_GRID_SCC_CLKS-1:0]	fscan_dop_clken,     	// Clock enable
  output logic  [NUM_OF_GRID_SCC_CLKS-1:0]	adop_postclk,       	// Clock to agent (gated by clken)
  output logic  [NUM_OF_GRID_SCC_CLKS-1:0]      adop_postclk_free,  	// Clock to agent (free)
  output logic  [(NUM_OF_GRID_NONSCAN_CLKS >0 ? NUM_OF_GRID_NONSCAN_CLKS : 1)-1:0]  adop_postclk_nonscan   	// Clock to agent (nonscan free running)
  
);

 //collage-pragma translate_off
   
    logic  [NUM_OF_GRID_PRI_CLKS-1:0]      adop_postclk_free_net;
  

    localparam bit [NUM_OF_GRID_SCC_CLKS-1:0][GRID_PRICLK_BITS-1:0]   PRICLK_MATRIX = GRID_SCC_PRICLK_MATRIX;
    localparam bit [NUM_OF_GRID_SCC_CLKS-1:0][GRID_DIVISOR_BITS-1:0]  DIVISOR_MATRIX  = GRID_SCC_DIVISOR_MATRIX;

    localparam bit [(NUM_OF_GRID_NONSCAN_CLKS >0 ? NUM_OF_GRID_NONSCAN_CLKS : 1)-1:0][GRID_PRICLK_BITS-1:0]   NS_PRICLK_MATRIX = GRID_NONSCAN_PRICLK_MATRIX;
    localparam bit [(NUM_OF_GRID_NONSCAN_CLKS >0 ? NUM_OF_GRID_NONSCAN_CLKS : 1)-1:0][GRID_DIVISOR_BITS-1:0]  NS_DIVISOR_MATRIX  = GRID_NONSCAN_DIVISOR_MATRIX;
 // this function is used to find div1 bit position from  GRID_SCC_DIVISOR_MATRIX and use this free runing clock to drive adop_postclk_free

function automatic integer Div1_dop_map (input integer p);
  begin

     integer div1_done;
       div1_done=0;
      for(integer i=0;i<NUM_OF_GRID_SCC_CLKS; i++)
        begin
          if((PRICLK_MATRIX[i] == p) &&(DIVISOR_MATRIX[i]==1)&& (div1_done==0) )
          begin
            Div1_dop_map  = i;
             div1_done=1;
             end
         end
     end
 endfunction

generate
for (genvar p=0; p<NUM_OF_GRID_PRI_CLKS; p++)
begin:primary_clk_map

    localparam  DIV1_DOP_POS = Div1_dop_map(p);

    always_comb
    begin
     adop_postclk_free_net[p] = adop_postclk_free[DIV1_DOP_POS];
    end
end


   


// instantiate each DOP to create the postdop clocks for each divisor
for (genvar d=0; d<NUM_OF_GRID_SCC_CLKS; d++)
begin : dop_loop_gated

    localparam bit [GRID_PRICLK_BITS-1:0] PRICLK =  PRICLK_MATRIX[d];
    localparam bit [GRID_DIVISOR_BITS-1:0] DIVISOR = DIVISOR_MATRIX[d];
    localparam int DIV = DIVISOR; // for lint
    
    


  `ifndef INTEL_EMULATION

     `ifdef INTEL_SIMONLY


    // print useful diagnostic message to the user if the parameter is misconfigured
    if ((PRICLK >= NUM_OF_GRID_PRI_CLKS) || (PRICLK < 0)) 
    begin : priclk_out_of_range
	$error ("ERROR - PCCDU - GRID_SCC_PRICLK_MATRIX(0x%0h) contains entry(%d) outside the valid range of 0..NUM_OF_GRID_PRI_CLKS-1(0..%d)",
	    GRID_SCC_PRICLK_MATRIX, PRICLK, NUM_OF_GRID_PRI_CLKS-1);
    end
`endif
`endif


    if(DIVISOR>1) 
    begin : dop_div
   
     
   
     	hqm_rcfwl_gclk_pccdu_dop  #(.GRID_CLK_DIVISOR(DIV)) gated_clkdist_dop_div (
	    .fdop_preclk_grid(fdop_preclk_grid[PRICLK]),	// grid input
	    .fscan_clk(fdop_scan_clk[d]),			// scanclk input
	    .fscan_dop_clken(fscan_dop_clken[d]),		// grid clock enable ctl
	    .fdop_preclk_div_sync(fdop_preclk_div_sync[PRICLK]),	// divisor sync reset
	    .adop_postclk(adop_postclk[d]),			// DOP output clock
	    .adop_postclk_free (adop_postclk_free[d])
	);
	
    end
    else 
    begin : dop_nodiv
      
   
	hqm_rcfwl_gclk_pccdu_dop  #(.GRID_CLK_DIVISOR(DIV)) gated_clkdist_dop (
	    .fdop_preclk_grid(fdop_preclk_grid[PRICLK]),	// grid input
	    .fscan_clk(fdop_scan_clk[d]),			// scanclk input
	    .fscan_dop_clken(fscan_dop_clken[d]),		// grid clock enable ctl
	    .fdop_preclk_div_sync(1'b0),				// divisor sync reset
	    .adop_postclk(adop_postclk[d]),			// DOP output clock
	    .adop_postclk_free (adop_postclk_free[d])
	 );
	         
	 
    end
end


if(NUM_OF_GRID_NONSCAN_CLKS>0)
begin: dop_nonscan
// instantiate each DOP to create the nonscan free running  postdop clocks for each divisor
for (genvar d=0; d<NUM_OF_GRID_NONSCAN_CLKS; d++)
begin : dop_loop_nonscan

    localparam bit [GRID_PRICLK_BITS-1:0] PRICLK =  NS_PRICLK_MATRIX[d];
    localparam bit [GRID_DIVISOR_BITS-1:0] DIVISOR = NS_DIVISOR_MATRIX[d];
    localparam int DIV = DIVISOR; // for lint

    if(DIVISOR>1) 
    begin : dop_div_nonscan
	hqm_rcfwl_gclk_pccdu_dop  #(.GRID_CLK_DIVISOR(DIV)) gated_clkdist_dop_div (
	    .fdop_preclk_grid(fdop_preclk_grid[PRICLK]),	// grid input
	    .fscan_clk(1'b0),			// scanclk input
	    .fscan_dop_clken(1'b1),				// grid clock enable ctl
	    .fdop_preclk_div_sync(fdop_preclk_div_sync_free[PRICLK]),	// divisor sync reset
	    .adop_postclk(adop_postclk_nonscan[d]),		// DOP output clock
	    .adop_postclk_free ()
	);
    end
    else 
    // drive this div1 clock from existing div1 dop.
    begin : dop_nodiv_nonscan
	assign  adop_postclk_nonscan[d] = adop_postclk_free_net[PRICLK];
    end
  end
 end
else // drive nothing when NUM_OF_GRID_NONSCAN_CLKS is 0.
 begin: no_dop_nonscan
 assign  adop_postclk_nonscan =  'd0;
 end 

endgenerate

  


    //collage-pragma translate_on

endmodule
