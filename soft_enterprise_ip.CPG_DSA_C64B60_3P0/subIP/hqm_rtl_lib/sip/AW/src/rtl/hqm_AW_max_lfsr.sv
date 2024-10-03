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
// AW_max_lfsr
//
// This module implements a parameterizable width LFSR that counts through a maximal set of
// (2**width)-1 values when enabled. The wrap output indicates when the counter is enabled and
// has wrapped around.  The set input can be used to restart the counter at the beginning of its
// interval.  If the WRAP_ON_SET parameter is set to 1, wrap gets set the first clock the counter
// is set instead of waiting a full interval before setting the first wrap indication.
// The value of all 1s is never reached.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_max_lfsr
       import hqm_AW_pkg::*; #(

	 parameter WIDTH	= 3
	,parameter WRAP_ON_SET	= 0
	,parameter SEED         = 0
) (
	 input	logic			clk
	,input	logic			rst_n
	,input	logic			set
	,input	logic			enable
	,output	logic			wrap
	,output	logic	[WIDTH-1:0]	count
);

//-----------------------------------------------------------------------------------------------------

logic	[WIDTH-1:0]	lfsr_shift;
logic	[WIDTH-1:0]	lfsr_next;
logic	[WIDTH-1:0]	lfsr_q;
logic			lfsr_next_eq1;
logic			wrap_next;
logic			wrap_q;

//-----------------------------------------------------------------------------------------------------

`ifdef HQM_AW_MAX_LFSR_FAST_SIM

 assign lfsr_shift[WIDTH-1] = lfsr_shift[0];

`else

 generate
           if (WIDTH== 3) begin: g_w3  assign lfsr_shift[WIDTH-1] = ^{lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH== 4) begin: g_w4  assign lfsr_shift[WIDTH-1] = ^{lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH== 5) begin: g_w5  assign lfsr_shift[WIDTH-1] = ^{lfsr_q[2],~lfsr_q[0]};
  end else if (WIDTH== 6) begin: g_w6  assign lfsr_shift[WIDTH-1] = ^{lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH== 7) begin: g_w7  assign lfsr_shift[WIDTH-1] = ^{lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH== 8) begin: g_w8  assign lfsr_shift[WIDTH-1] = ^{lfsr_q[4:2],~lfsr_q[0]};
  end else if (WIDTH== 9) begin: g_w9  assign lfsr_shift[WIDTH-1] = ^{lfsr_q[4],~lfsr_q[0]};
  end else if (WIDTH==10) begin: g_w10 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[3],~lfsr_q[0]};
  end else if (WIDTH==11) begin: g_w11 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[2],~lfsr_q[0]};
  end else if (WIDTH==12) begin: g_w12 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[11],lfsr_q[8],lfsr_q[6],~lfsr_q[0]};
  end else if (WIDTH==13) begin: g_w13 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[12],lfsr_q[10:9],~lfsr_q[0]};
  end else if (WIDTH==14) begin: g_w14 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[13],lfsr_q[11],lfsr_q[9],~lfsr_q[0]};
  end else if (WIDTH==15) begin: g_w15 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==16) begin: g_w16 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[12],lfsr_q[3],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==17) begin: g_w17 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[3],~lfsr_q[0]};
  end else if (WIDTH==18) begin: g_w18 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[7],~lfsr_q[0]};
  end else if (WIDTH==19) begin: g_w19 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[18:17],lfsr_q[13],~lfsr_q[0]};
  end else if (WIDTH==20) begin: g_w20 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[3],~lfsr_q[0]};
  end else if (WIDTH==21) begin: g_w21 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[2],~lfsr_q[0]};
  end else if (WIDTH==22) begin: g_w22 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==23) begin: g_w23 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[5],~lfsr_q[0]};
  end else if (WIDTH==24) begin: g_w24 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[7],lfsr_q[2:1],~lfsr_q[0]};
  end else if (WIDTH==25) begin: g_w25 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[3],~lfsr_q[0]};
  end else if (WIDTH==26) begin: g_w26 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[25:24],lfsr_q[20],~lfsr_q[0]};
  end else if (WIDTH==27) begin: g_w27 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[26:25],lfsr_q[22],~lfsr_q[0]};
  end else if (WIDTH==28) begin: g_w28 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[3],~lfsr_q[0]};
  end else if (WIDTH==29) begin: g_w29 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[2],~lfsr_q[0]};
  end else if (WIDTH==30) begin: g_w30 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[29],lfsr_q[26],lfsr_q[24],~lfsr_q[0]};
  end else if (WIDTH==31) begin: g_w31 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[3],~lfsr_q[0]};
  end else if (WIDTH==32) begin: g_w32 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[31:30],lfsr_q[10],~lfsr_q[0]};
  end else if (WIDTH==33) begin: g_w33 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[13],~lfsr_q[0]};
  end else if (WIDTH==34) begin: g_w34 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[33:32],lfsr_q[7],~lfsr_q[0]};
  end else if (WIDTH==35) begin: g_w35 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[2],~lfsr_q[0]};
  end else if (WIDTH==36) begin: g_w36 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[11],~lfsr_q[0]};
  end else if (WIDTH==37) begin: g_w37 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[36:32],~lfsr_q[0]};
  end else if (WIDTH==38) begin: g_w38 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[37],lfsr_q[33:32],~lfsr_q[0]};
  end else if (WIDTH==39) begin: g_w39 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[4],~lfsr_q[0]};
  end else if (WIDTH==40) begin: g_w40 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[21],lfsr_q[19],lfsr_q[2],~lfsr_q[0]};
  end else if (WIDTH==41) begin: g_w41 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[3],~lfsr_q[0]};
  end else if (WIDTH==42) begin: g_w42 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[23:22],lfsr_q[2],~lfsr_q[0]};
  end else if (WIDTH==43) begin: g_w43 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[6:5],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==44) begin: g_w44 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[27:26],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==45) begin: g_w45 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[4:3],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==46) begin: g_w46 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[21:20],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==47) begin: g_w47 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[5],~lfsr_q[0]};
  end else if (WIDTH==48) begin: g_w48 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[28:27],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==49) begin: g_w49 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[9],~lfsr_q[0]};
  end else if (WIDTH==50) begin: g_w50 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[27:26],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==51) begin: g_w51 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[16:15],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==52) begin: g_w52 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[3],~lfsr_q[0]};
  end else if (WIDTH==53) begin: g_w53 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[16:15],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==54) begin: g_w54 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[37:36],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==55) begin: g_w55 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[24],~lfsr_q[0]};
  end else if (WIDTH==56) begin: g_w56 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[22:21],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==57) begin: g_w57 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[7],~lfsr_q[0]};
  end else if (WIDTH==58) begin: g_w58 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[19],~lfsr_q[0]};
  end else if (WIDTH==59) begin: g_w59 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[22:21],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==60) begin: g_w60 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==61) begin: g_w61 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[16:15],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==62) begin: g_w62 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[57:56],lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==63) begin: g_w63 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[1],~lfsr_q[0]};
  end else if (WIDTH==64) begin: g_w64 assign lfsr_shift[WIDTH-1] = ^{lfsr_q[4:3],lfsr_q[1],~lfsr_q[0]};
  end else                begin: g_inv UNSUPPORTED_LFSR_WIDTH_PARAMETER i_bad (.clk(clk));
  end

 endgenerate

`endif

assign lfsr_shift[WIDTH-2:0] = lfsr_q[WIDTH-1:1];

assign lfsr_next = (set) ? {{(WIDTH-1){1'b0}}, 1'b1} : lfsr_shift;

assign lfsr_next_eq1 = (lfsr_next == {{(WIDTH-1){1'b0}}, 1'b1});

// spyglass disable_block W490 -- WRAP_ON_SET==1 will be constant

assign wrap_next = enable & ((WRAP_ON_SET == 1) ? lfsr_next_eq1 : (lfsr_next_eq1 & ~set));

// spyglass  enable_block W490

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
  lfsr_q <= { SEED[WIDTH-2:0], 1'b0};   // Guarantee at least one 0 so all 1s value not used
  wrap_q <= 1'b0;
 end else begin
  if (enable) lfsr_q <= lfsr_next;
  wrap_q <= wrap_next;
 end
end

assign count = lfsr_q;
assign wrap  = wrap_q;

endmodule // AW_max_lfsr

