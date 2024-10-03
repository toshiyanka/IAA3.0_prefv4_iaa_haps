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
// AW_pg_mask
//
// This module masks a set of signals to support the "partial goods" strategy for N clusters.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_pg_mask
       import hqm_AW_pkg::*; #(

	 parameter N  = 4		// Number of clusters
	,parameter CN = 0		// This cluster's number
	,parameter W  = 1		// Width of field
	,parameter V  = 0		// Value if field is masked
) (

	 input	logic	[W-1:0]		a
	,input	logic	[N-1:0]		cpv

	,output	logic	[W-1:0]		z
);

genvar g;

generate
 for (g=0; g<W; g=g+1) begin: g_w
  if (V==1) begin: g_or
   hqm_AW_clkor2_comb  i_pg_mask_comb_clkor2  (.clki0(a[g]), .clki1(~cpv[CN]), .clko(z[g]));
  end else begin: g_and
   hqm_AW_clkand2_comb i_pg_mask_comb_clkand2 (.clki0(a[g]), .clki1( cpv[CN]), .clko(z[g]));
  end
 end
endgenerate

endmodule // AW_pg_mask

