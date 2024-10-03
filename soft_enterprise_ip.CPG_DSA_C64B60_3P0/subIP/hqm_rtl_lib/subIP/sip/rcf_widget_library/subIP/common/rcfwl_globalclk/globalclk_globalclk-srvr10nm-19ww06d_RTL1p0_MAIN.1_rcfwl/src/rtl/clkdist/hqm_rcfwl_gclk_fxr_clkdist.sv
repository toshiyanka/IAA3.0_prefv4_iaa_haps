
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
module hqm_rcfwl_gclk_fxr_clkdist #(
		      parameter int CLK_DIVISOR = 2
		     )
		     (

		    input   clkspine_in,
		    input   pll_sync_in,
		    output  clk_preccdu,
		    output  clkusync_preccdu
		    );

   logic sync_edge;
   logic sync_edge_reg;
   logic sync_edge_det;
   logic div2_clk_stage2;
   logic div_stage1_out;

   always_ff @(posedge clkspine_in) sync_edge     <= pll_sync_in;
   always_ff @(posedge clkspine_in) sync_edge_reg <= sync_edge;
   

   assign sync_edge_det = sync_edge & (~sync_edge_reg) ;


   generate
      if (CLK_DIVISOR == 2)
	begin : div2
	   logic div2_clk;



	   always_ff@(posedge clkspine_in) 
	     begin
		if (sync_edge_det)
		  begin
		     div2_clk <= 1'b0;
		  end
		else
		  begin
		     div2_clk <= ~div2_clk;
		  end
	     end
          assign div_stage1_out = div2_clk;
	end
      else // 3
	begin: div3
	   logic div3_clk;
	   reg div3;
	   reg [1:0] cnt;
	   reg div3_d;
           wire x3clk;

	   /////// Div 3 clock
	always_ff @(posedge clkspine_in) 
	  begin 
	     if (sync_edge) 
	       cnt <= 2'b00; 
	     else if (cnt == 2'b10) 
	       begin 
		  cnt <= 2'b00; 
		  div3 <= 1'b1; 
	       end 
	     else 
	       begin 
		  cnt <= cnt + 1; 
		  div3 <= 1'b0; 
	       end 
	  end 


	   always_ff @(negedge clkspine_in) 
	     begin 
		if (sync_edge) 
		  div3_d <= 1'b1; 
		else 
		  div3_d <= div3; 
	     end 

	   assign x3clk = div3 | div3_d; 
	   assign div_stage1_out = x3clk;


	end


   endgenerate



   always_ff@(posedge div_stage1_out) 
     begin
	if (sync_edge_det)
	  begin
             div2_clk_stage2 <= 1'b1;
	  end
	else
	  begin
             div2_clk_stage2 <= ~div2_clk_stage2;
	  end
     end

   assign clk_preccdu = div2_clk_stage2;

   assign clkusync_preccdu = sync_edge; 

endmodule
