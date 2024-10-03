
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
//  outputs (NUM_OF_GRID_SEC_CLKS).  Two parameters control the association of
//  the DOP outputs to the primary grid source and divisors:
//  	GRID_SEC_PRICLK_MATRIX	- defines which primary domain clock is the source for each DOP
//  	GRID_SEC_DIVISOR_MATRIX	- defines the divisor value for each DOP
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


module hqm_rcfwl_gclk_pccdu
   #(
      	parameter NUM_OF_GRID_PRI_CLKS = 'd3,          	// number of primary grid domain clocks
      	parameter NUM_OF_GRID_SEC_CLKS = 'd6,          	// number of DOP (secondary) output clocks
      	parameter GRID_PRICLK_BITS = 'd4,              	// number of bits needed to specify # of pri clocks
      	parameter GRID_DIVISOR_BITS = 'd4,              // number of bits needed to specify divisors used by DOPs

	// Matrix to map each DOP clock to the appropriate primary grid. The layout of this sliced parameter is as follows:
	// +--------------------------------------+--------------------------------------+-----+-------------------------+
	// | dopclk[NUM_GRID_SCC-1] pri_grid_clk# | dopclk[NUM_GRID_SCC-1] pri_grid_clk# | ... | dopclk[0] pri_grid_clk# |
	// +--------------------------------------+--------------------------------------+-----+-------------------------+
	parameter [NUM_OF_GRID_SEC_CLKS*GRID_PRICLK_BITS-1:0] GRID_SEC_PRICLK_MATRIX = 	
	{4'd2,  // dopclk[5] <- driven by prigrid[2]
         4'd1,  // dopclk[4] <- driven by prigrid[1]
         4'd1,  // dopclk[3] <- driven by prigrid[1]	 
	 4'd0,	// dopclk[2] <- driven by prigrid[0]
	 4'd0,	// dopclk[1] <- driven by prigrid[0]
	 4'd0},	// dopclk[0] <- driven by prigrid[0]
         // Matrix to set the divisor for each DOP clock from the corresponding primary grid. The layout of this sliced parameter is as follows:
	// +--------------------------------------+--------------------------------------+-----+-------------------------+
	// | dopclk[NUM_GRID_SCC-1]  dop_divisor# | dopclk[NUM_GRID_SCC-1]  dop_divisor# | ... | dopclk[0]  dop_divisor# |
	// +--------------------------------------+--------------------------------------+-----+-------------------------+
        parameter [NUM_OF_GRID_SEC_CLKS*GRID_DIVISOR_BITS-1:0] GRID_SEC_DIVISOR_MATRIX =	
	{4'd1,  // dopclk[5] <- driven by prigrid[2] / 1
         4'd2,  // dopclk[4] <- driven by prigrid[1] / 2
         4'd1,  // dopclk[3] <- driven by prigrid[1] / 1
	 4'd4,	// dopclk[2] <- driven by prigrid[0] / 4
	 4'd2,	// dopclk[1] <- driven by prigrid[0] / 2
	 4'd1},	// dopclk[0] <- driven by prigrid[0] / 1
      	parameter NUM_OF_GRID_NONSCAN_CLKS = 'd0,          	// number of DOP free running nonscan divided clocks to instantiate 
	parameter [((NUM_OF_GRID_NONSCAN_CLKS >0 ? NUM_OF_GRID_NONSCAN_CLKS : 1) *GRID_PRICLK_BITS )-1:0] GRID_NONSCAN_PRICLK_MATRIX = 	'0,
	parameter [((NUM_OF_GRID_NONSCAN_CLKS >0 ? NUM_OF_GRID_NONSCAN_CLKS : 1) *GRID_DIVISOR_BITS)-1:0] GRID_NONSCAN_DIVISOR_MATRIX = '0
    )
 (
  // CCDU functional inputs from PLL/PMA
  input	 logic  [NUM_OF_GRID_PRI_CLKS-1:0]	fdop_preclk_grid,      	// primary grid clock inputs
  input  logic  [NUM_OF_GRID_PRI_CLKS-1:0]	fpm_preclk_div_sync, 	  // Sync from CDU
  input	 logic  [NUM_OF_GRID_SEC_CLKS-1:0]	fpm_dop_clken,     	    // Clock enable

  // CCDU scan inputs from scan controller
  input  logic                              fscan_mode,
  input  logic                              fscan_rpt_clk,          // Scan clock which toggles during shift only (not during capture)
  input  logic  [NUM_OF_GRID_SEC_CLKS-1:0]  fscan_dop_shift_dis,    // stop the secondary adop_postclk if necessary, per GUCC
  input	 logic  [NUM_OF_GRID_SEC_CLKS-1:0]	fscan_dop_clken,     	  // Clock enable
  input  logic  [NUM_OF_GRID_PRI_CLKS-1:0]  fscan_preclk_div_sync,  // scan controlled div sync, divider reset from scan path, per PRI_CLK, spec will pick one of the GUCC

  // CCDU clock outputs
  output logic  [NUM_OF_GRID_SEC_CLKS-1:0]	adop_postclk,       	  // Clock to agent (gated by clken)
  output logic  [NUM_OF_GRID_SEC_CLKS-1:0]	adop_postclk_free,   	  // Clock to agent (free)
  output logic  [(NUM_OF_GRID_NONSCAN_CLKS >0 ? NUM_OF_GRID_NONSCAN_CLKS : 1)-1:0]	adop_postclk_nonscan   	// Clock to agent (nonscan free running)
);


   
    //collage-pragma translate_off

  localparam bit [NUM_OF_GRID_SEC_CLKS-1:0][GRID_PRICLK_BITS-1:0]   PRICLK_MATRIX = GRID_SEC_PRICLK_MATRIX;
  localparam bit [NUM_OF_GRID_SEC_CLKS-1:0][GRID_DIVISOR_BITS-1:0]  DIVISOR_MATRIX  = GRID_SEC_DIVISOR_MATRIX;

  localparam bit [(NUM_OF_GRID_NONSCAN_CLKS >0 ? NUM_OF_GRID_NONSCAN_CLKS : 1)-1:0][GRID_PRICLK_BITS-1:0]   NS_PRICLK_MATRIX = GRID_NONSCAN_PRICLK_MATRIX;
  localparam bit [(NUM_OF_GRID_NONSCAN_CLKS >0 ? NUM_OF_GRID_NONSCAN_CLKS : 1)-1:0][GRID_DIVISOR_BITS-1:0]  NS_DIVISOR_MATRIX  = GRID_NONSCAN_DIVISOR_MATRIX;

  // internal controls from scan/functional mux
	logic  [NUM_OF_GRID_SEC_CLKS-1:0] dop_clken;
	logic  [NUM_OF_GRID_SEC_CLKS-1:0] fdop_clken;
	logic  [NUM_OF_GRID_SEC_CLKS-1:0] fdop_scanclk;
  logic  [NUM_OF_GRID_PRI_CLKS-1:0] fdop_preclk_div_sync;
	 
  logic  [NUM_OF_GRID_PRI_CLKS-1:0] fdop_preclk_div_sync_edge;
	logic  [NUM_OF_GRID_PRI_CLKS-1:0] fdop_preclk_div_sync_free_edge;
	logic  [NUM_OF_GRID_PRI_CLKS-1:0] dop_pri_postclk_free;
	
function automatic integer InsertedgeDet (input integer p);
    begin
      
      InsertedgeDet=0;
      for(integer i=0;i<NUM_OF_GRID_SEC_CLKS; i++)
        begin
          if((PRICLK_MATRIX[i] == p) &&(DIVISOR_MATRIX[i] >1) && (InsertedgeDet==0))
             InsertedgeDet=1;
        end
    end
endfunction

function automatic integer InsertedgeDetfree (input integer p);
    begin
      
      InsertedgeDetfree=0;
      for(integer i=0;i<NUM_OF_GRID_NONSCAN_CLKS; i++)
        begin
          if((NS_PRICLK_MATRIX[i] == p) &&(NS_DIVISOR_MATRIX[i] >1) && (InsertedgeDetfree==0))
             InsertedgeDetfree=1;
        end
    end
endfunction
// this function is used to find if there is any div1 exits in GRID_SEC_DIVISOR_MATRIX     
function automatic integer Div1 (input integer p);
    begin
      
      Div1=0;
      for(integer i=0;i<NUM_OF_GRID_SEC_CLKS; i++)
        begin
          if((PRICLK_MATRIX[i] == p) &&(DIVISOR_MATRIX[i]==1) && (Div1==0))
             Div1=1;
        end
    end
endfunction

// this function is used to find div1 bit position from  GRID_SEC_DIVISOR_MATRIX and use this free runing clock to drive adop_postclk_free
function automatic integer Div1_dop_map (input integer p);
  begin

     integer div1_done;
       div1_done=0;
      for(integer i=0;i<NUM_OF_GRID_SEC_CLKS; i++)
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
 // instantiate each of the primary grid clock resources
   for (genvar p=0; p<NUM_OF_GRID_PRI_CLKS; p++)
   begin : dop_div_reset_mux_loop
     // Instantiate the divider reset mux
    hqm_rcfwl_gclk_pccdu_dop_reset_mux dop_reset_mux (
         .fpm_dop_reset      (fpm_preclk_div_sync[p]),
         .fscan_dop_reset    (fscan_preclk_div_sync[p]),
         .fscan_mode         (fscan_mode),
         .fdop_reset         (fdop_preclk_div_sync[p])
       );
   end // end of dop_div_reset_mux_loop
  
   // instantiate each DOP mux to select between PMA and scan sources for controls
   for (genvar d=0; d<NUM_OF_GRID_SEC_CLKS; d++)
   begin : dop_mux_loop
       // Instantiate the clken mux
       hqm_rcfwl_gclk_pccdu_dop_clken_mux dop_clken_mux (
           .fpm_dop_clken      (fpm_dop_clken[d]),
           .fscan_mode         (fscan_mode),
           .fscan_dop_clken    (fscan_dop_clken[d]),
           .fdop_clken         (fdop_clken[d])
         );
      
       // Instantiate the dop shift dis path for fdop_scanclk
       hqm_rcfwl_gclk_pccdu_dop_scanclk dop_scanclk_and (
           .fscan_dop_shift_dis  (fscan_dop_shift_dis[d]),
           .fscan_rpt_clk        (fscan_rpt_clk),
           .fdop_scanclk         (fdop_scanclk[d])
         );
   end     // end of dop_loop_gate
 endgenerate
  


hqm_rcfwl_gclk_pccdu_dop_wrapper #(.NUM_OF_GRID_PRI_CLKS( NUM_OF_GRID_PRI_CLKS),
			.NUM_OF_GRID_SCC_CLKS(NUM_OF_GRID_SEC_CLKS),
			.GRID_PRICLK_BITS(GRID_PRICLK_BITS),
			.GRID_DIVISOR_BITS (GRID_DIVISOR_BITS),
			.GRID_SCC_PRICLK_MATRIX (GRID_SEC_PRICLK_MATRIX),
			.GRID_SCC_DIVISOR_MATRIX(GRID_SEC_DIVISOR_MATRIX),
			.NUM_OF_GRID_NONSCAN_CLKS(NUM_OF_GRID_NONSCAN_CLKS),
			.GRID_NONSCAN_PRICLK_MATRIX(GRID_NONSCAN_PRICLK_MATRIX),
			.GRID_NONSCAN_DIVISOR_MATRIX (GRID_NONSCAN_DIVISOR_MATRIX)
			)
		i_gclk_pccdu_dop_wrapper (
		      .fdop_preclk_grid(fdop_preclk_grid),	// grid input
	    		.fdop_scan_clk(fdop_scanclk),			// scanclk input
	    		.fscan_dop_clken(fdop_clken),		// grid clock enable ctl
	    		.fdop_preclk_div_sync(fdop_preclk_div_sync_edge),	// divisor sync reset
          .fdop_preclk_div_sync_free(fdop_preclk_div_sync_free_edge),
          .adop_postclk(adop_postclk),			// DOP output clock
	   		  .adop_postclk_free (adop_postclk_free),
          .adop_postclk_nonscan(adop_postclk_nonscan)			 
     );

generate



// Run this for each primary clock.
for (genvar p=0; p<NUM_OF_GRID_PRI_CLKS; p++)
begin:primary_clk
 
 localparam DIV1_DOP = Div1(p); 

if (DIV1_DOP==1)
 begin:primary_clk_map
   localparam  DIV1_DOP_POS = Div1_dop_map(p);
    
    // this is the free running 1X clock for a particular priclk (used by edge detector)
    always_comb begin
     dop_pri_postclk_free[p] = adop_postclk_free[DIV1_DOP_POS];
    end
  end

localparam INS_EDGE_DET_SCAN      = InsertedgeDet(p);
localparam INS_EDGE_DET_NONSCAN = InsertedgeDetfree(p);

 if (INS_EDGE_DET_SCAN ==1)         
  begin:scan_edge_det
    hqm_rcfwl_gclk_pccdu_edge_det i_gclk_pccdu_edge_det (
             .adop_postclk_free(dop_pri_postclk_free[p]),     // the 1X priclk free
             .fdop_preclk_div_sync (fdop_preclk_div_sync[p]), // muxed version of the div sync (between PMA/scan source)
             .fdop_preclk_div_sync_edge (fdop_preclk_div_sync_edge[p])
          );
  end
 else 
  begin:no_scan_edge_det
       always_comb
       begin
       fdop_preclk_div_sync_edge[p] =1'b0;
       end
  end

  if (INS_EDGE_DET_NONSCAN ==1)      
     begin:nonscan_edge_det
     hqm_rcfwl_gclk_pccdu_edge_det i_gclk_pccdu_edge_det_free (
             .adop_postclk_free(dop_pri_postclk_free[p]), // the 1X priclk free
             .fdop_preclk_div_sync (fpm_preclk_div_sync[p]), // use the PMA direct version of div sync for nonscan clocks
	           .fdop_preclk_div_sync_edge  (fdop_preclk_div_sync_free_edge[p])
          );
     end   
 else 
  begin:no_nonscan_edge_det
       always_comb begin
       fdop_preclk_div_sync_free_edge[p] =1'b0;
       end
  end

end
endgenerate

    //collage-pragma translate_on

endmodule
