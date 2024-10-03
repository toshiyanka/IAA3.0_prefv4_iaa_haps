
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
module hqm_rcfwl_gclk_clkdist_repeater 
                 #( parameter NUM_OF_SCC_CLKS = 1,
		    parameter NUM_OF_RPTRS   = 1 )
		 (
	    input  logic [(NUM_OF_SCC_CLKS >0 ? NUM_OF_SCC_CLKS : 1)-1:0] clk_en,
	    input  logic			  clk_div_sync,
	    input  logic			  adop_postclk_free,
	    output logic [(NUM_OF_SCC_CLKS >0 ? NUM_OF_SCC_CLKS : 1)-1:0] clk_en_out,
	    output logic			   clk_div_sync_out
	         );

logic [NUM_OF_RPTRS:0][(NUM_OF_SCC_CLKS >0 ? NUM_OF_SCC_CLKS : 1)-1:0] clk_en_wire;
logic [NUM_OF_RPTRS:0] 			    clk_div_sync_wire;


 assign clk_en_wire[0] = clk_en;
 assign  clk_en_out    = clk_en_wire[NUM_OF_RPTRS];
 assign clk_div_sync_wire[0] = clk_div_sync ;
 assign clk_div_sync_out     = clk_div_sync_wire[NUM_OF_RPTRS];
 
generate
genvar i;
// begin: gen_clkdist_rpt
  for( i=0;i<NUM_OF_RPTRS ; i=i+1)
   begin: gen_clkdist_rptrs
     always_ff @ (posedge adop_postclk_free )
        begin
        clk_en_wire[i+1] 	 <=  clk_en_wire[i];
	clk_div_sync_wire[i+1]   <=  clk_div_sync_wire[i];
        end
    end
// end
 
  
endgenerate    		 

endmodule	     
