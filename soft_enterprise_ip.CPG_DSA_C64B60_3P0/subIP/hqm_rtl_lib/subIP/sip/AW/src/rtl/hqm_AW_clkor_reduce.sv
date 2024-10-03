//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
// AW_clkor_reduce
//
// This module is responsible for implementing a purely combinatorial clock "OR" reduction.
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapaths that are connected
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_clkor_reduce
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 2
) (
	 input	logic	[WIDTH-1:0]	clki

	,output	logic			clko
);

`ifndef INTEL_SVA_OFF

  initial begin

   check_width_param: assert ((WIDTH>=2) && (WIDTH<=16)) else begin
    $display ("\nERROR: %m: Parameter WIDTH had an illegal value (%d).  Valid values are (2-16) !!!\n",WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

logic	[(((WIDTH+1)>>1)<<1)-1:0]	clki_scaled;
logic	[ ((WIDTH+1)>>1)    -1:0]	clkl0;

hqm_AW_width_scale #(.A_WIDTH(WIDTH), .Z_WIDTH(((WIDTH+1)>>1)<<1)) i_clki_scaled (.a(clki), .z(clki_scaled));

hqm_AW_clkor2_comb #(.WIDTH((WIDTH+1)>>1)) i_AW_clkor2_comb (

         .clki0	(clki_scaled[((WIDTH+1)>>1) +: ((WIDTH+1)>>1)])
        ,.clki1	(clki_scaled[            0  +: ((WIDTH+1)>>1)])
        ,.clko  (clkl0[                  0  +: ((WIDTH+1)>>1)])
);

generate

 if (WIDTH==2) begin: g_w2

  assign clko = clkl0[0];

 end else if (WIDTH>2) begin: g_wg2

  logic	[(((WIDTH+3)>>2)<<1)-1:0]	clkl0_scaled;
  logic	[ ((WIDTH+3)>>2)    -1:0]	clkl1;

  hqm_AW_width_scale #(.A_WIDTH((WIDTH+1)>>1), .Z_WIDTH(((WIDTH+3)>>2)<<1)) i_clkl0_scaled (.a(clkl0), .z(clkl0_scaled));

  hqm_AW_clkor2_comb #(.WIDTH((WIDTH+3)>>2)) i_AW_clkor2_comb (

         .clki0	(clkl0_scaled[((WIDTH+3)>>2) +: ((WIDTH+3)>>2)])
        ,.clki1	(clkl0_scaled[            0  +: ((WIDTH+3)>>2)])
        ,.clko	(clkl1[                   0  +: ((WIDTH+3)>>2)])
  );

  if (WIDTH<=4) begin: g_wle4

   assign clko = clkl1[0];

  end else begin: g_wg4

   logic [(((WIDTH+7)>>3)<<1)-1:0]	clkl1_scaled;
   logic [ ((WIDTH+7)>>3)    -1:0]	clkl2;

   hqm_AW_width_scale #(.A_WIDTH((WIDTH+3)>>2), .Z_WIDTH(((WIDTH+7)>>3)<<1)) i_clkl1_scaled (.a(clkl1), .z(clkl1_scaled));

   hqm_AW_clkor2_comb #(.WIDTH((WIDTH+7)>>3)) i_AW_clkor2_comb (

         .clki0	(clkl1_scaled[((WIDTH+7)>>3) +: ((WIDTH+7)>>3)])
        ,.clki1	(clkl1_scaled[            0  +: ((WIDTH+7)>>3)])
        ,.clko	(clkl2[                   0  +: ((WIDTH+7)>>3)])
   );

   if (WIDTH<=8) begin: g_wle8

    assign clko = clkl2[0];

   end else begin: g_wg8

    logic [(((WIDTH+15)>>4)<<1)-1:0]	clkl2_scaled;
    logic [ ((WIDTH+15)>>4)    -1:0]	clkl3;

    hqm_AW_width_scale #(.A_WIDTH((WIDTH+7)>>3), .Z_WIDTH(((WIDTH+15)>>4)<<1)) i_clkl2_scaled (.a(clkl2), .z(clkl2_scaled));

    hqm_AW_clkor2_comb #(.WIDTH((WIDTH+15)>>4)) i_AW_clkor2_comb (

         .clki0	(clkl2_scaled[((WIDTH+15)>>4) +: ((WIDTH+15)>>4)])
        ,.clki1	(clkl2_scaled[             0  +: ((WIDTH+15)>>4)])
        ,.clko	(clkl3[                    0  +: ((WIDTH+15)>>4)])
    );

    assign clko = clkl3[0];

   end

  end

 end

endgenerate

`ifndef INTEL_SVA_OFF

  // Error if more than one clock is enabled

  check_enable: assert property (@(posedge clko) ($countones(clki) <= 1)) else begin
   $display ("\nERROR: %t: %m: More than one clock enabled at a time !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

`endif

endmodule // AW_clkor_reduce

