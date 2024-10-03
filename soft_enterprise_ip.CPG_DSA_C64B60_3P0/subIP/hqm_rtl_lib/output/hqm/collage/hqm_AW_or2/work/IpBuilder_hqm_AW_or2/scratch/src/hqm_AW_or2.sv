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
// AW_or2
//
// This module is responsible for implementing a purely combinatorial 2-input clock "OR" gate.
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapaths that are connected
//
//-----------------------------------------------------------------------------------------------------

// reuse-pragma startSub [InsertComponentPrefix %subText 7]
module hqm_AW_or2 #(


  // reuse-pragma startSub WIDTH [ReplaceParameter -design hqm_AW_or2 -lib work -format systemverilog WIDTH -endTok "" -indent "  "]
	 parameter WIDTH	= 1

  // reuse-pragma endSub WIDTH
  ) (
	 input	logic	[WIDTH-1:0]     a	
	,input	logic	[WIDTH-1:0]     b	

	,output	logic	[WIDTH-1:0]	o
);

//-----------------------------------------------------------------------------------------------------

// synopsys translate_off
genvar g;

generate
 for (g=0; g<WIDTH; g=g+1) begin: g_w
  hqm_AW_ctech_or2 i_ctech_or2 (.a(a[g]), .b(b[g]), .o(o[g]));
 end
endgenerate

// synopsys translate_on
endmodule // hqm_AW_or2

