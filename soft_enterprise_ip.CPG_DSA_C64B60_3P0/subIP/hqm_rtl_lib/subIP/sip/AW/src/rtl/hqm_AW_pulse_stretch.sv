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
// AW_pulse_stretch
//
// This module is responsible for glitchlessly creating a pulse of N clock cycles from a single
// cycle input pulse.
//
// The following parameters are supported:
//
//	WIDTH		Width of the datapath
//	PULSE_WIDTH	The number of clock cycles the output pulse should be
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_pulse_stretch
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 1
	,parameter PULSE_WIDTH	= 2

) (
	 input	logic			clk
	,input	logic			rst_n
	,input	logic	[WIDTH-1:0]	din

	,output	logic	[WIDTH-1:0]	dout
);


//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

  initial begin

   check_pulse_width_param: assert (PULSE_WIDTH>=2) else begin
    $display ("\nERROR: %m: Parameter PULSE_WIDTH had an illegal value (%d).  Valid values are (>=2) !!!\n",PULSE_WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

//-----------------------------------------------------------------------------------------------------

localparam PWIDTH = AW_logb2(PULSE_WIDTH-1)+1;

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


  assign cnt_next[g] = (dout_next[g] & ~dout_q[g]) ? ( PULSE_WIDTH[PWIDTH-1:0] - { {(PWIDTH-1){1'b0}},1'b1 } ) : (cnt_q[g] - { {(PWIDTH-1){1'b0}},cnt_ne0[g] } );


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

endmodule // AW_pulse_stretch

