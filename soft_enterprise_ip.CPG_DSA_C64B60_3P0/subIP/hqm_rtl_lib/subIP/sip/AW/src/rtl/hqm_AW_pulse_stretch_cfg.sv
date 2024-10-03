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
// AW_pulse_stretch_cfg
//
// This module is responsible for glitchlessly creating a pulse of N clock cycles from a single
// cycle input pulse based on a configurable pulse width value.
// For num_clocks = 0 to MAX_PULSE_WIDTH-1, this witll generate a pulse that is 1-MAX_PULSE_WIDTH wide.
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapath
//	MAX_PULSE_WIDTH	The maximum number of clock cycles the output pulse can be stretched
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_pulse_stretch_cfg
       import hqm_AW_pkg::*; #(

	 parameter WIDTH		= 1
	,parameter MAX_PULSE_WIDTH	= 2

	,parameter PWIDTH		= (AW_logb2(MAX_PULSE_WIDTH-1)+1)

) (
	 input	logic			clk
	,input	logic			rst_n
	,input	logic	[WIDTH-1:0]	din
	,input	logic	[PWIDTH-1:0]	num_clocks

	,output	logic	[WIDTH-1:0]	dout
);


//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

  initial begin

   check_max_pulse_width_param: assert (MAX_PULSE_WIDTH>=2) else begin
    $display ("\nERROR: %m: Parameter MAX_PULSE_WIDTH had an illegal value (%d).  Valid values are (>=2) !!!\n",MAX_PULSE_WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

//-----------------------------------------------------------------------------------------------------

logic	[WIDTH-1:0]	dout_next;
logic	[WIDTH-1:0]	dout_q;
logic	[PWIDTH-1:0]	cnt_next[WIDTH-1:0];
logic	[PWIDTH-1:0]	cnt_q[WIDTH-1:0];
logic	[WIDTH-1:0]	cnt_ne0;

genvar			g;

generate
 for (g=0; g<WIDTH; g=g+1) begin: g_bit

  assign cnt_ne0[g]   = |{1'b0, cnt_q[g]};

  assign dout_next[g] = din[g] | (dout_q[g] & cnt_ne0[g]);

  // spyglass disable_block W484 W164a -- Can't have borrow

  assign cnt_next[g] = (dout_next[g] & ~dout_q[g]) ? num_clocks : (cnt_q[g] - cnt_ne0[g]);

  // spyglass  enable_block W484 W164a

  always_ff @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin
    dout_q[g] <= 1'b0;
    cnt_q[g]  <= {PWIDTH{1'b0}};
   end else begin
    dout_q[g] <= dout_next[g];
    cnt_q[g]  <= cnt_next[g];
   end
  end

  assign dout[g] = dout_q[g];

 end
endgenerate

endmodule // AW_pulse_stretch_cfg

