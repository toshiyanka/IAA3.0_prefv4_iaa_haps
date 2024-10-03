
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
///=====================================================================================================================
///
/// clkdist_ccdu.sv
///
///=====================================================================================================================
// Detailed description:
// Clock control distribution unit
///=====================================================================================================================
module hqm_rcfwl_gclk_ccdu_clkdist
   #(
      	parameter NUM_OF_GRID_SCC_CLKS = 'd3,              // number of clocks in cluster
	parameter int GRID_CLK_DIVISOR = 'd2
    )
 (
  input	 logic  fdop_preclk_grid,      // Clock
  input	 logic  fdop_preclk_grid_sync, 
  input  logic  [((NUM_OF_GRID_SCC_CLKS > 0) ? (NUM_OF_GRID_SCC_CLKS-1) : 0):0]  fdop_preclk_div_sync,  // Sync from CDU
  input	 logic  [((NUM_OF_GRID_SCC_CLKS > 0) ? (NUM_OF_GRID_SCC_CLKS-1) : 0):0]  fscan_clk,             // Scan clock 
  input	 logic  [((NUM_OF_GRID_SCC_CLKS > 0) ? (NUM_OF_GRID_SCC_CLKS-1) : 0):0]  fscan_dop_clken,       // Clock enable
  input  logic  x4clk_in,              // 
  input  logic  x1clk_in,              // 
  input  logic  x3clk_in,              // 
  input  logic  x12clk_in,
  input  logic  x1clk_in_sync,
  input  logic  x3clk_in_sync,
  input  logic  x4clk_in_sync,
  input  logic  x12clk_in_sync,
  output logic  x4clk_out,             // 
  output logic  x1clk_out,             // 
  output logic  x3clk_out,             // 
  output logic  x12clk_out,
  output logic  x1clk_out_sync,
  output logic  x3clk_out_sync,
  output logic  x4clk_out_sync,
  output logic  x12clk_out_sync,
  output logic  [((NUM_OF_GRID_SCC_CLKS > 0) ? (NUM_OF_GRID_SCC_CLKS-1) : 0):0]  adop_postclk,          // Clock to agent (gated by clken)
  output logic  adop_postclk_free,     // Clock to agent (free)
  output logic  adop_preclk_grid_sync
);
    
  
 hqm_rcfwl_gclk_ccdu_vccagent_wrapper#(
      	.NUM_OF_GRID_SCC_CLKS (NUM_OF_GRID_SCC_CLKS),              
	.GRID_CLK_DIVISOR  (GRID_CLK_DIVISOR)
          )
 ccdu_vccagent_wrapper1(
         .fdop_preclk_grid (fdop_preclk_grid),     
         .fdop_preclk_grid_sync(fdop_preclk_grid_sync), 
         .fdop_reset_b(fdop_preclk_div_sync),          
         .fscan_clk(fscan_clk),              
         .fscan_dop_clken(fscan_dop_clken), 
         .adop_postclk(adop_postclk),          
         .adop_postclk_free(adop_postclk_free),     
         .adop_preclk_grid_sync(adop_preclk_grid_sync)
          );
  

  hqm_rcfwl_gclk_ccdu_vccinf_wrapper
   ccdu_vccinf_wrapper1(
        .x4clk_in(x4clk_in),              
        .x1clk_in(x1clk_in),            
        .x3clk_in(x3clk_in),  
        .x12clk_in(x12clk_in),             
        .x1clk_in_sync(x1clk_in_sync),
        .x3clk_in_sync(x3clk_in_sync),
        .x4clk_in_sync(x4clk_in_sync),
        .x12clk_in_sync(x12clk_in_sync),
        .x4clk_out(x4clk_out),              
        .x1clk_out(x1clk_out),              
        .x3clk_out(x3clk_out), 
        .x12clk_out(x12clk_out),       
        .x1clk_out_sync(x1clk_out_sync),
        .x3clk_out_sync(x3clk_out_sync),
        .x4clk_out_sync(x4clk_out_sync),
        .x12clk_out_sync(x12clk_out_sync) 
        );
    
 
  
endmodule
