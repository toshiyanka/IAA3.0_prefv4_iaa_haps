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
// AW_parity_check
//
// This module is responsible for checking parity.
// If the ODD input is asserted, odd parity is checked, otherwise even parity is checked.
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapath on which to check parity.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_parity_check
 #(

	 parameter WIDTH	= 1
) (
	 input	logic			p
	,input	logic	[WIDTH-1:0]	d
	,input	logic			e
	,input	logic			odd

	,output	logic			err
);

//-----------------------------------------------------------------------------------------------------

// Go through some contortions to handle Xs in the input data gracefully (for simulation only!)
// if the +NO_PAR_X_CORRECT plusarg is not specified.

logic	[WIDTH-1:0]	d_in;
logic			d_sel;

`ifdef INTEL_INST_ON

 logic	[WIDTH-1:0]	d_x;

 always_comb begin: b_d_x

  for (int i=0; i<WIDTH; i=i+1) begin
  `ifndef INTEL_SVA_OFF
   d_x[i] = ($isunknown(d[i])) ? i[0] : d[i];
  `else
   d_x[i] = d[i];
  `endif
  end
 end

`endif

assign d_sel = 1'b1 
`ifdef INTEL_INST_ON
        & ~$test$plusargs("NO_PAR_X_CORRECT")
`endif
;

always_comb begin
 case (d_sel)
`ifdef INTEL_INST_ON
  1'b1:    d_in = d_x;   
`endif
  default: d_in = d;
 endcase
end

assign err = e & ^{odd,p,d_in};

endmodule // AW_parity_check

