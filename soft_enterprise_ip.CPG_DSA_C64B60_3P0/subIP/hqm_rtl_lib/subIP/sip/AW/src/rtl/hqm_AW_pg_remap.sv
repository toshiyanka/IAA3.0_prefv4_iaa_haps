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
// AW_pg_remap
//
// This module remaps a set of signals to support the "partial goods" strategy for N clusters.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_pg_remap
       import hqm_AW_pkg::*; #(

	 parameter N = 4		// Number of clusters
	,parameter W = 1		// Width of fields
	,parameter D = 0		// Direction of remap (0:from log to phys, 1:from phys to log)
	,parameter V = 2		// Value for unused fields (0:0, 1:1, 2:remapped_field, 3:field)
) (

	 input	logic	[(N*W)-1:0]	a
	,input	logic	[N-1:0]		cpv

	,output	logic	[(N*W)-1:0]	z
);


localparam N_WIDTH = AW_logb2(N-1)+1;
localparam NP2     = (1<<N_WIDTH);

logic	[(N*W)-1:0]		a_mask;
logic	[(NP2*W)-1:0]		a_scaled;
logic	[(N*N_WIDTH)-1:0]	s;
logic	[(N*W)-1:0]		z_premask;

genvar g;

hqm_AW_width_scale #(.A_WIDTH(N*W), .Z_WIDTH(NP2*W)) i_a_scaled (.a(a_mask), .z(a_scaled));

generate

 for (g=0; g<N; g=g+1) begin: g_n

  if (D==0) begin: g_d0
   if (V==0) begin: g_v0
    hqm_AW_clkand2_comb #(.WIDTH(W)) i_pg_remap_comb_clkand2 (.a(a[(g*W) +: W]), .b( {W{cpv[g]}}), .z(a_mask[(g*W) +: W]));
   end else if (V==1) begin: g_v1
    hqm_AW_clkor2_comb  #(.WIDTH(W)) i_pg_remap_comb_clkor2  (.a(a[(g*W) +: W]), .b(~{W{cpv[g]}}), .z(a_mask[(g*W) +: W]));
   end else begin: g_vg1
    assign a_mask[(g*W) +: W] = a[(g*W) +: W];
   end
  end else begin: g_dn0
   assign a_mask[(g*W) +: W] = a[(g*W) +: W];
  end

  if (NP2==2) begin: g_2

   hqm_AW_clkmux2 #(.WIDTH(W)) i_pg_remap_comb_clkmux2 (

	 .d1	(a_scaled[(1*W) +: W])
	,.d0	(a_scaled[(0*W) +: W])
	,.s	(s[g])
	,.z	(z_premask[(g*W) +: W])
   );

  end else if (NP2==4) begin: g_4

   hqm_AW_clkmux4 #(.WIDTH(W)) i_pg_remap_comb_clkmux4 (

	 .d3	(a_scaled[(3*W) +: W])
	,.d2	(a_scaled[(2*W) +: W])
	,.d1	(a_scaled[(1*W) +: W])
	,.d0	(a_scaled[(0*W) +: W])
	,.s1	(s[(g*2)+1])
	,.s0	(s[(g*2)])
	,.z	(z_premask[(g*W) +: W])
   );

  end else if (NP2==8) begin: g_8

   hqm_AW_clkmux8 #(.WIDTH(W)) i_pg_remap_comb_clkmux8 (

	 .d7	(a_scaled[(7*W) +: W])
	,.d6	(a_scaled[(6*W) +: W])
	,.d5	(a_scaled[(5*W) +: W])
	,.d4	(a_scaled[(4*W) +: W])
	,.d3	(a_scaled[(3*W) +: W])
	,.d2	(a_scaled[(2*W) +: W])
	,.d1	(a_scaled[(1*W) +: W])
	,.d0	(a_scaled[(0*W) +: W])
	,.s2	(s[(g*3)+2])
	,.s1	(s[(g*3)+1])
	,.s0	(s[(g*3)])
	,.z	(z_premask[(g*W) +: W])
   );

  end else if (NP2==16) begin: g_16

   hqm_AW_clkmux16 #(.WIDTH(W)) i_pg_remap_comb_clkmux16 (

	 .df	(a_scaled[(15*W) +: W])
	,.de	(a_scaled[(14*W) +: W])
	,.dd	(a_scaled[(13*W) +: W])
	,.dc	(a_scaled[(12*W) +: W])
	,.db	(a_scaled[(11*W) +: W])
	,.da	(a_scaled[(10*W) +: W])
	,.d9	(a_scaled[( 9*W) +: W])
	,.d8	(a_scaled[( 8*W) +: W])
	,.d7	(a_scaled[( 7*W) +: W])
	,.d6	(a_scaled[( 6*W) +: W])
	,.d5	(a_scaled[( 5*W) +: W])
	,.d4	(a_scaled[( 4*W) +: W])
	,.d3	(a_scaled[( 3*W) +: W])
	,.d2	(a_scaled[( 2*W) +: W])
	,.d1	(a_scaled[( 1*W) +: W])
	,.d0	(a_scaled[( 0*W) +: W])
	,.s3	(s[(g*3)+3])
	,.s2	(s[(g*3)+2])
	,.s1	(s[(g*3)+1])
	,.s0	(s[(g*3)])
	,.z	(z_premask[(g*W) +: W])
   );

  end else begin: g_error

   INVALID_N_PARAM i_bad ();

  end

  if (D==1) begin: g_d1
   if (V==0) begin: g_v0
    hqm_AW_clkand2_comb #(.WIDTH(W)) i_pg_remap_comb_clkand2 (.a(z_premask[(g*W) +: W]), .b( {W{cpv[g]}}), .z(z[(g*W) +: W]));
   end else if (V==1) begin: g_v1
    hqm_AW_clkor2_comb  #(.WIDTH(W)) i_pg_remap_comb_clkor2  (.a(z_premask[(g*W) +: W]), .b(~{W{cpv[g]}}), .z(z[(g*W) +: W]));
   end else begin: g_vg1
    assign z[(g*W) +: W] = z_premask[(g*W) +: W];
   end
  end else begin
   assign z[(g*W) +: W] = z_premask[(g*W) +: W];
  end

 end

 if (D == 1) begin: g_l2p

  always_comb begin: remap
   integer i,c;
   s={(N*N_WIDTH){1'b0}}; c=0;
   // spyglass disable_block W310 W490 -- Yes, V==3 is a constant and converting int to reg
   for (i=0; i<N; i=i+1) if ( cpv[i]) begin s[(N_WIDTH*i) +: N_WIDTH] = c; c=c+1; end
   for (i=0; i<N; i=i+1) if (~cpv[i]) begin s[(N_WIDTH*i) +: N_WIDTH] = (V==3) ? i : c; c=c+1; end
   // spyglass  enable_block W310 W490
  end

 end else begin: g_p2l

  always_comb begin: remap
   integer i,c;
   s={(N*N_WIDTH){1'b0}}; c=0;
   // spyglass disable_block W310 W490 -- Yes, V==3 is a constant and converting int to reg
   for (i=0; i<N; i=i+1) if ( cpv[i]) begin s[(N_WIDTH*c) +: N_WIDTH] = i; c=c+1; end
   for (i=0; i<N; i=i+1) if (~cpv[i]) begin s[(N_WIDTH*c) +: N_WIDTH] = (V==3) ? c : i; c=c+1; end
   // spyglass  enable_block W310 W490
  end

 end
endgenerate

endmodule // AW_pg_remap

