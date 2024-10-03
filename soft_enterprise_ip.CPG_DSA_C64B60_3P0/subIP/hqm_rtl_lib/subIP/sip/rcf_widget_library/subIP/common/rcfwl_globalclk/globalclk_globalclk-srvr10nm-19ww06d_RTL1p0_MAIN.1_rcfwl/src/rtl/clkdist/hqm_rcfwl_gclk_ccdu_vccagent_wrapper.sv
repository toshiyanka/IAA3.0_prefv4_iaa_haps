
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
module hqm_rcfwl_gclk_ccdu_vccagent_wrapper

#(
      	parameter NUM_OF_GRID_SCC_CLKS = 'd3,              // number of clocks in cluster
	parameter int GRID_CLK_DIVISOR = 'd2
    )
 (
  input	 logic  fdop_preclk_grid,      // Clock
  input	 logic  fdop_preclk_grid_sync, 
  input  logic  [((NUM_OF_GRID_SCC_CLKS > 0) ? (NUM_OF_GRID_SCC_CLKS-1) : 0):0]  fdop_reset_b,          // Reset
  input	 logic  [((NUM_OF_GRID_SCC_CLKS > 0) ? (NUM_OF_GRID_SCC_CLKS-1) : 0):0]  fscan_clk,             // Scan clock 
  input	 logic  [((NUM_OF_GRID_SCC_CLKS > 0) ? (NUM_OF_GRID_SCC_CLKS-1) : 0):0]  fscan_dop_clken, 
  output logic  [((NUM_OF_GRID_SCC_CLKS > 0) ? (NUM_OF_GRID_SCC_CLKS-1) : 0):0]  adop_postclk,          // Clock to agent (gated by clken)
  output logic  adop_postclk_free,     // Clock to agent (free)
  output logic  adop_preclk_grid_sync

);

 hqm_rcfwl_gclk_legacy_clkdist_dop #(.GRID_CLK_DIVISOR(1)) 
    gated_clkdist_dop (
    .fdop_preclk_grid(fdop_preclk_grid),
    .fscan_clk(fscan_clk[0]),
    .fscan_dop_clken(fscan_dop_clken[0]),
    .fdop_reset_b(1'b0),  // Unused when DIVISOR = 1
    .adop_postclk(adop_postclk[0])
    );

    hqm_rcfwl_gclk_legacy_clkdist_dop #(.GRID_CLK_DIVISOR(1))
    free_clkdist_dop (
    .fdop_preclk_grid(fdop_preclk_grid),
    .fscan_clk(1'b0),
    .fdop_reset_b(1'b0),      // Unused when DIVISOR = 1
    .fscan_dop_clken(1'b1), // Tied to create free running
    .adop_postclk(adop_postclk_free)
    );
    
    // Divided clock
generate
if (NUM_OF_GRID_SCC_CLKS > 1)
  begin : div_dops
    hqm_rcfwl_gclk_legacy_clkdist_dop  #(.GRID_CLK_DIVISOR(GRID_CLK_DIVISOR))
     gated_clkdist_dop_div (
    .fdop_preclk_grid(fdop_preclk_grid),
    .fscan_clk(fscan_clk[1]),
    .fscan_dop_clken(fscan_dop_clken[1]),
    .fdop_reset_b(fdop_reset_b[1]),
    .adop_postclk(adop_postclk[1])
    );
  end
endgenerate

generate
if (NUM_OF_GRID_SCC_CLKS > 2)  
 begin : div4_dops
    hqm_rcfwl_gclk_legacy_clkdist_dop  #(.GRID_CLK_DIVISOR('d4))
     gated_clkdist_dop_div4 (
    .fdop_preclk_grid(fdop_preclk_grid),
    .fscan_clk(fscan_clk[2]),
    .fscan_dop_clken(fscan_dop_clken[2]),
    .fdop_reset_b(fdop_reset_b[2]),
    .adop_postclk(adop_postclk[2])
    );
  end
endgenerate

 assign  adop_preclk_grid_sync = fdop_preclk_grid_sync;

endmodule
