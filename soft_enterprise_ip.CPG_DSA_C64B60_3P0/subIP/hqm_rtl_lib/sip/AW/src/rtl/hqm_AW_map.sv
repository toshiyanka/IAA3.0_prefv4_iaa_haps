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
//
// ***********************
// * AW CTECH MAP FILE *
// ***********************
//
// File              : AW_map.vs
//
// Description       : AW CTECH map file
//
// Unit Owner        : Steve Pollock
// Secondary Contact :
//
// Original Author   : Steve Pollock
// Original Date     : 08/19/2015
//
// Copyright 2020 Intel Corporation
// Intel Proprietary and Top Secret Information
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_ctech_clk_and (
   input  logic clk1,
   input  logic clk2,
   output logic clkout
);
  ctech_lib_clk_and ctech_lib_clk_and (.clkout(clkout), .clk1(clk1), .clk2(clk2));
endmodule

module hqm_AW_ctech_clk_and_en (
   input  logic clk,
   input  logic en,
   output logic clkout
);
   ctech_lib_clk_and_en ctech_lib_clk_and_en (.clkout(clkout), .clk(clk), .en(en));
endmodule

module hqm_AW_ctech_clk_buf (
   input  logic clk,
   output logic clkout
);
   ctech_lib_clk_buf ctech_lib_clk_buf (.clk(clk), .clkout(clkout));
endmodule

module hqm_AW_ctech_clk_divider2 (
   input  logic clk,
   output logic clkout
);
   ctech_lib_clk_divider2 ctech_lib_clk_divider2 (.clk(clk), .clkout(clkout));
endmodule

module hqm_AW_ctech_clk_divider2_rst (
   input  logic clk,
   input  logic rst,
   output logic clkout
);
   ctech_lib_clk_divider2_rst ctech_lib_clk_divider2_rst (.clk(clk), .rst(rst), .clkout(clkout));
endmodule

module hqm_AW_ctech_clk_gate_and (
   input  logic clk,
   input  logic en,
   output logic clkout
);
   ctech_lib_clk_gate_and ctech_lib_clk_gate_and (.clkout(clkout), .clk(clk), .en(en));
endmodule

module hqm_AW_ctech_clk_gate_or (
   input  logic clk,
   input  logic en,
   output logic clkout
);
   ctech_lib_clk_gate_or ctech_lib_clk_gate_or (.clkout(clkout), .en(en), .clk(clk));
endmodule

module hqm_AW_ctech_clk_gate_te (
  input  logic clk,
  input  logic en,
  input  logic te,
  output logic clkout
);
   ctech_lib_clk_gate_te ctech_lib_clk_gate_te (.clk(clk), .en(en), .te(te), .clkout(clkout));
endmodule

module hqm_AW_ctech_clk_gate_te_rst_ss (
   input  logic en,      // Enable input logic signal
   input  logic te,      // Test mode latch open. Port map to: Tlatch_open
   input  logic rst,     // Test mode latch close. Port map to: Tlatch_closedB
   input  logic clk,     // Clock input
   input  logic ss,
   output logic clkout   // Clock-gated enable output
);
   ctech_lib_clk_gate_te_rst_ss ctech_lib_clk_gate_te_rst_ss (.en(en), .te(te), .rst(rst), .clk(clk), .ss(ss), .clkout(clkout));
endmodule

module hqm_AW_ctech_clk_inv (
   input  logic clk,
   output logic clkout
);
   ctech_lib_clk_inv ctech_lib_clk_inv (.clk(clk), .clkout(clkout));
endmodule

module hqm_AW_ctech_clk_mux_2to1 (
   input  logic clk1,
   input  logic clk2,
   input  logic s,
   output logic clkout
);
   ctech_lib_clk_mux_2to1 ctech_lib_clk_mux_2to1 (.clk1(clk1), .clk2(clk2), .s(s), .clkout(clkout));
endmodule

module hqm_AW_ctech_clk_nand (
   input  logic clk1,
   input  logic clk2,
   output logic clkout
);
   ctech_lib_clk_nand ctech_lib_clk_nand (.clkout(clkout), .clk1(clk1), .clk2(clk2));
endmodule

module hqm_AW_ctech_clk_nand_en (
   input  logic clk,
   input  logic en,
   output logic clkout
);
   ctech_lib_clk_nand_en ctech_lib_clk_nand_en (.clk(clk),.en(en),.clkout(clkout));
endmodule

module hqm_AW_ctech_clk_nor (
   input  logic clk1,
   input  logic clk2,
   output logic clkout
);
   ctech_lib_clk_nor ctech_lib_clk_nor (.clkout(clkout), .clk1(clk1), .clk2(clk2));
endmodule

module hqm_AW_ctech_clk_nor_en (
   input  logic clk,
   input  logic en,
   output logic clkout
);
   ctech_lib_clk_nor_en ctech_lib_clk_nor_en (.clk(clk),.en(en),.clkout(clkout));
endmodule

module hqm_AW_ctech_clk_or (
   input  logic clk1,
   input  logic clk2,
   output logic clkout
);
   ctech_lib_clk_or ctech_lib_clk_or (.clkout(clkout), .clk1(clk1), .clk2(clk2));
endmodule

module hqm_AW_ctech_clk_or_en (
   input  logic clk,
   input  logic en,
   output logic clkout
);
   ctech_lib_clk_or_en ctech_lib_clk_or_en (.clk(clk),.en(en),.clkout(clkout));
endmodule

module hqm_AW_ctech_doublesync_rstb (
   input  logic clk,
   input  logic rstb,
   input  logic d,
   output logic o
);
   ctech_lib_doublesync_rstb ctech_lib_doublesync_rstb (.clk(clk), .d(d), .rstb(rstb), .o(o));

endmodule

module hqm_AW_ctech_doublesync_setb (
   input  logic clk,
   input  logic setb,
   input  logic d,
   output logic o
);
   ctech_lib_doublesync_setb ctech_lib_doublesync_setb (.d(d), .clk(clk), .setb(setb), .o(o));
endmodule

module hqm_AW_ctech_dq (
   input  logic a,
   input  logic b,
   output logic o
);
   ctech_lib_dq ctech_lib_dq (.a(a), .b(b), .o(o));
endmodule

module hqm_AW_ctech_ident (
   input  logic a,
   output logic o
);
   ctech_lib_ident ctech_lib_ident (.a(a), .o(o));
endmodule

module hqm_AW_ctech_inv (
   input  logic a,
   output logic o1
);
   ctech_lib_inv ctech_lib_inv (.a(a), .o1(o1));
endmodule

module hqm_AW_ctech_mux_2to1 (
   input  logic d1,
   input  logic d2,
   input  logic s,
   output logic o
);
   ctech_lib_mux_2to1 ctech_lib_mux_2to1 (.d1(d1), .d2(d2), .s(s), .o(o));
endmodule

module hqm_AW_ctech_or2 (
   input  logic a,
   input  logic b,
   output logic o
);
   ctech_lib_or2 ctech_lib_or2 (.a(a), .b(b), .o(o));
endmodule

module hqm_AW_ctech_buf (
   input  logic a,
   output logic o
);
   ctech_lib_buf ctech_lib_buf (.a(a), .o(o));
endmodule

