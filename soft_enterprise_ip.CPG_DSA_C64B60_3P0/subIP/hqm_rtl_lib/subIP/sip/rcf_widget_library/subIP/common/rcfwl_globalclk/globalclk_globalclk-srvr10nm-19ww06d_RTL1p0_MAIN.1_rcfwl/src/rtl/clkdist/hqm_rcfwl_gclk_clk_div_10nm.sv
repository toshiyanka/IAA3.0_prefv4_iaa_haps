
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
/// clk_div_10nm.sv
///
///=====================================================================================================================
// Detailed description:
// Generic clock divider
// Just palceholder for now
///=====================================================================================================================
module hqm_rcfwl_gclk_clk_div_10nm
    #(
	parameter int CLK_DIVISOR = 'd2
    )
 (
  input	 logic  clk_in,
  input  logic  fdop_reset_b,
  output logic  clk_out
);

   
generate
   if (CLK_DIVISOR == 2)
     begin : div2
	assign clk_out = clk_in;
     end
   else if (CLK_DIVISOR == 4)
     begin : div4
	assign clk_out = clk_in;
     end
   else if (CLK_DIVISOR == 6)
     begin : div6
	assign clk_out = clk_in;
     end
   else if (CLK_DIVISOR == 8)
     begin : div8
	assign clk_out = clk_in;
     end
   else if (CLK_DIVISOR == 10)
     begin : div10
	assign clk_out = clk_in;
     end
   else if (CLK_DIVISOR == 16)
     begin : div16
	assign clk_out = clk_in;
     end
   else
     begin : nodiv
	assign clk_out = clk_in;
     end
endgenerate

endmodule // clk_div_10nm

