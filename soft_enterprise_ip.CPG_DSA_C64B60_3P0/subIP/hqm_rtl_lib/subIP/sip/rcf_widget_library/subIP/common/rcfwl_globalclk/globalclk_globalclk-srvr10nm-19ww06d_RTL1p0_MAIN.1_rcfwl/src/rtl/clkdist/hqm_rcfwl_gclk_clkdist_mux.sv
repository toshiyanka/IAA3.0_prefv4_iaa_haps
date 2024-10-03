
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
module hqm_rcfwl_gclk_clkdist_mux 
                 
		 (
	    input  logic  clk_in ,
	    input  logic  fscan_ovrd_clk, 			  
	    input  logic  fscan_ovrd_clk_sel,
	    output logic  clk_out
	         );

//assign  clk_out = fscan_ovrd_clk_sel ? fscan_ovrd_clk : clk_in ; 

hqm_rcfwl_gclk_ctech_clock_mux2 i_ctech_lib_clk_mux_2to1 (
              .clk1 (fscan_ovrd_clk),
              .clk2 (clk_in),
              .sa (fscan_ovrd_clk_sel),
              .clkout (clk_out)
	      );


endmodule 
