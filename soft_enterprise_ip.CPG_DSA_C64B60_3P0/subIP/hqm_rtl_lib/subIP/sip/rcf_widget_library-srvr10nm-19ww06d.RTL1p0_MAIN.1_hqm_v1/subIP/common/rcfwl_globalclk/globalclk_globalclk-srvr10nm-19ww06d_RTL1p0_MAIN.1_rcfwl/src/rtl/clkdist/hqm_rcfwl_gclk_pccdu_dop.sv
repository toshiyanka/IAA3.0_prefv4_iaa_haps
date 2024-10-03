
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
// File:         pccdu_dop.sv
// Revision:     10nm_srvr_chassis_0p3
// Description:  Drop Off Point (DOP) driver for Parameterized Clock Control Distribution Unit  (pccdu)
// Contact:      Pratik Bhatt, Rich Gammack, Glenn Colon-Bonet
// Created:      Fri Apr 10 04:31:41 PDT 2015
// Modified:     Fri Apr 10 04:31:52 PDT 2015
// Language:     System Verilog
// Package:      N/A
// Status:       Experimental (Do Not Distribute)
// Copyright (c) 2015, Intel Corporation, all rights reserved.
//====================================================================================================
// Detailed description:
//     The DOP driver implements a grid clock driver to the local regional
//     clock buffers used within a partition.  Each driver contains an
//     optional clock divider and clock gate logic.  The DOP also takes in
//     a scan clock which is ORed into the final stage to allow scan
//     shift/capture to be initiated from the scan system.
//
//     The clock divider circuit also accepts a reset input which is used to 
//     periodically sync the divider for alignment purposes.  The reset must
//     be a single cycle pulse.  The clock output clears on the reset and 
//     one cycle after the reset, the clock output will rise.
//
//     Note that this version of the DOP is a behavioral model only for scan
//     system validation purposes.  The clock team maintains the proper code
//     base for the DOP circuit.  It is meant to match behavior of the clock
//     DOP circuit, but is a greatly simplified abstraction.
//====================================================================================================
// Configurable parameters
//     GRID_CLK_DIVISOR = divides the primary grid clock to create the output
//     clock.  Divisor values of 0 or 1 will not have a divider, and divider
//     values of 2 and higher will implement a clock divider circuit.
//====================================================================================================
module hqm_rcfwl_gclk_pccdu_dop
    #(
        parameter int GRID_CLK_DIVISOR = 1
    )
 (
  input  logic  fdop_preclk_grid,
  input  logic  fscan_clk,  
  input  logic  fscan_dop_clken,
  input  logic  fdop_preclk_div_sync,
  output logic  adop_postclk,
  output logic  adop_postclk_free
);
 
    
    case (GRID_CLK_DIVISOR)
    'd1:  
   begin : div1_dop

        hqm_rcfwl_gclk_ctech_lib_glbdrvqclk   i_gclk_ctech_lib_glbdrvqclk ( 
                                                                  .clkin (fdop_preclk_grid) , 
                                                                  .clken( fscan_dop_clken),
                                                                  .clkenfree (1'b1),
                                                                  .scanclk (fscan_clk) , 
                                                                  .clkfree (adop_postclk_free), 
                                                                  .clkout (adop_postclk), 
                                                                  .soft_high_out ()
                                                                  );
    
   end
   
    'd2:
    begin : div2_dop
    
        hqm_rcfwl_gclk_ctech_lib_glbdrvdclk  i_gclk_ctech_lib_glbdrvdclk ( 
                                 .clkin (fdop_preclk_grid) , 
                                 .clkdivrst(fdop_preclk_div_sync),
                                 .clken( fscan_dop_clken),
                                 .clkenfree (1'b1),
                                 .scanclk (fscan_clk) , 
                                 .clkfree (adop_postclk_free), 
                                 .clkout (adop_postclk),
                                 .soft_high_out()
                                 );
    end
 
     'd3:
    begin : div3_dop    
    
        hqm_rcfwl_gclk_ctech_glbdrvdiv3    i_gclk_ctech_glbdrvdiv3( 
                                 .clkin (fdop_preclk_grid) , 
                                 .clkdivrst(fdop_preclk_div_sync),
                                 .clken( fscan_dop_clken),
                                 .clkenfree (1'b1),
                                 .scanclk (fscan_clk) , 
                                 .clkfree (adop_postclk_free), 
                                 .clkout (adop_postclk),
                                 .soft_high_out() 
                                 );
    end 
    
    'd4:
    begin : div4_dop
    
   hqm_rcfwl_gclk_ctech_glbdrvdiv4or2ls    i_gclk_ctech_glbdrvdiv4or2ls( 
                                  .clkin (fdop_preclk_grid) , 
                                 .clkdivrst(fdop_preclk_div_sync),
                                 .clken( fscan_dop_clken),
                                  .clkenfree (1'b1),
                                  .scanclk (fscan_clk) ,
                                 .div2 (1'b0),   // only div4 
                                 .clkfree (adop_postclk_free), 
                                 .clkout (adop_postclk),
                                 .soft_high_out ()
                                 );
    
   end 
   
     
   'd9:
    begin : div9_dop
  
         ipglbdrvby9or12pp60  i_ipglbdrvby9or12pp60_div9 ( 
                                 .clkin (fdop_preclk_grid) , 
                                 .divrst(fdop_preclk_div_sync),
                                 .clken( fscan_dop_clken),
                                 .clkenfree (1'b1),
                                 .scanclk (fscan_clk) ,
                                 .div9 (1'b1),   // only div9 
                                 .clkfree (adop_postclk_free), 
                                 .clkout (adop_postclk),
                                 .soft_high_out()
                                 );  
    
   end 
   
   'd12:
    begin : div12_dop
    
        ipglbdrvby9or12pp60   i_ipglbdrvby9or12pp60_div12 ( 
                                 .clkin (fdop_preclk_grid) , 
                                 .divrst(fdop_preclk_div_sync),
                                 .clken( fscan_dop_clken),
                                 .clkenfree (1'b1),
                                 .scanclk (fscan_clk) ,
                                 .div9 (1'b0),   // only div12 
                                 .clkfree (adop_postclk_free), 
                                 .clkout (adop_postclk),
                                  .soft_high_out() 
                                 );
      
   end   
   
   
    default: 
   begin :div_dop
    
    logic div_clk_out;
    logic div_clk_out1;
//     logic fdop_reset_b_reg;
//     logic fdop_reset_edge_b;
    
    
//     always_ff @(posedge fdop_preclk_grid) begin
//      fdop_reset_b_reg <= fdop_reset_b ;
 //    end
 
    // on rising edge of the sync, generate a reset pulse
//     assign fdop_reset_edge_b = ~(fdop_reset_b & (~fdop_reset_b_reg)) ;


    // instantiate the clock divider
    hqm_rcfwl_gclk_pccdu_dop_clkdiv 
    #(
            .DIVISOR(GRID_CLK_DIVISOR)
    ) i_iclk_clkdiv (
        .clk (fdop_preclk_grid),
        .rst_b (fdop_preclk_div_sync),
        .clkdiv(div_clk_out)
    );
 // FIX ME replacing ctech with RTL for quick_sync issues.

    // low phase latch for enable   
    // ctech_lib_latch_p i_ctech_lib_latch_p(
         //.o   (dop_clken),
         //.d   (fscan_dop_clken),
         //.clkb(div_clk_out)
    // );
 //     always_latch
 //   if (~div_clk_out)begin
  //     dop_clken<= fscan_dop_clken;
  //   end
    
    // AND for clock gate with dop_clken
    hqm_rcfwl_gclk_ctech_clk_and_en i_ctech_lib_clk_and_en(
        .clkout(div_clk_out1),
        .clk   (div_clk_out),
        .en    (fscan_dop_clken)
    );
    // inject scan clock
    hqm_rcfwl_gclk_ctech_clk_or i_ctech_lib_clk_or(
        .clkout(adop_postclk),
        .clk1  (div_clk_out1),
        .clk2  (fscan_clk)
    );
    assign   adop_postclk_free = div_clk_out;
  end
    
 endcase
endmodule
