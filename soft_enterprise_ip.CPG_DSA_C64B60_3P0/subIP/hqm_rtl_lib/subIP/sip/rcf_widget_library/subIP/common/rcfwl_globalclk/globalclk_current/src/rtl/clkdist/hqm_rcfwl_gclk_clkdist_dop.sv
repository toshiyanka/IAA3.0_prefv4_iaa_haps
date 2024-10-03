
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
/// clkdist_dop.sv
///
///=====================================================================================================================
// Detailed description:
// Clock DOP
///=====================================================================================================================
module hqm_rcfwl_gclk_clkdist_dop
    #(
	parameter int GRID_CLK_DIVISOR = 0
    )
 (
  input	 logic  fdop_preclk_grid,
  input	 logic  fscan_clk,  
  input	 logic  fscan_dop_clken,
  input  logic  fdop_reset_b,
  output logic  adop_postclk
);

   
logic dop_clken;
localparam DOP_DIVISOR = (GRID_CLK_DIVISOR == 2) ? 2 : 1 ;
logic fdop_reset_b_reg;
logic fdop_reset_edge;

always_ff @(posedge fdop_preclk_grid) begin
    fdop_reset_b_reg <= fdop_reset_b ;
  end
 
 assign fdop_reset_edge = fdop_reset_b & (~fdop_reset_b_reg) ;
  
    
generate
if (DOP_DIVISOR == 2)
  begin : div2
    logic div2_clk;
    
    always_ff @(posedge fdop_preclk_grid) begin   
     if (fdop_reset_edge)
       begin
         div2_clk = 1'b0;  
       end         
     else
       begin
         div2_clk = ~div2_clk;  
       end       
    end         
       
    always_latch begin                                                  
       if (~div2_clk) 
         begin
	   dop_clken <= fscan_dop_clken;                                 
	 end
    end         
	 
    always_comb begin
       adop_postclk  = (dop_clken & div2_clk) | fscan_clk;
    end         
  end
else // 1:1
  if (DOP_DIVISOR == 4)
  begin : div4
    logic div4_in;
    logic div4_clk;
    logic [1:0] div4_counter_in;
    logic [1:0] div4_counter;
    
 always_comb begin
      
      div4_in = div4_clk;
      div4_counter_in = div4_counter + 2'd1;

      if (div4_counter == 2'd3) begin
         div4_counter_in = '0;
         div4_in = ~div4_clk;
      end
   end

 always_ff @( posedge fdop_preclk_grid   ) begin
      if (fdop_reset_edge) begin
         div4_counter <= '0;
         div4_clk <= '0;
      end
      else begin
         div4_counter <= div4_counter_in;
         div4_clk <= div4_in;
      end
   end    
    
     
    always_latch begin                                                  
       if (~div4_clk) 
         begin
	   dop_clken <= fscan_dop_clken;                                 
	 end
    end         
	 
    always_comb begin
       adop_postclk  = (dop_clken & div4_clk) | fscan_clk;
    end         
  end
  
else 
  begin : no_div
   // B phase latch for enable
    always_latch begin                                                  
       if (~fdop_preclk_grid) dop_clken <= fscan_dop_clken;                                 
    end
    always_comb begin
       adop_postclk  = (dop_clken & fdop_preclk_grid) | fscan_clk;
    end
  end
endgenerate

endmodule
