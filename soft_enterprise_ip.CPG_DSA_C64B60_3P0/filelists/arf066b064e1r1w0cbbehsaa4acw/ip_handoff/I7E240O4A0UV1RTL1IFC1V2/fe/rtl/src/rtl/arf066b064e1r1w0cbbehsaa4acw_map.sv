//----------------------------------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2023 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code ("Material") are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//----------------------------------------------------------------------------------------------------
//`ifndef ARF066B064E1R1W0CBBEHSAA4ACW_MAP_SV
//`define ARF066B064E1R1W0CBBEHSAA4ACW_MAP_SV

// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_mux_2to1 ==========
module arf066b064e1r1w0cbbehsaa4acw_ctech_mux_2to1 (
  input logic d1,
  input logic d2,
  input logic s,

  output logic o
);

  ctech_lib_mux_2to1 mux_2to1_0 (.d1(d1), .d2(d2), .s(s), .o(o));  

endmodule // arf066b064e1r1w0cbbehsaa4acw_ctech_mux_2to1

// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_clk_gate_and ==========
module arf066b064e1r1w0cbbehsaa4acw_clk_and (

   input logic clk,
   input logic en,
   output logic clkout 
);

   ctech_lib_clk_gate_and clk_gate_and (.clkout(clkout), .clk(clk), .en(en));  

endmodule

// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_clk_mux_2to1 ==========
module arf066b064e1r1w0cbbehsaa4acw_ctech_clk_mux (
  input logic clk1,
  input logic clk2,
  input logic s,

  output logic clkout
);

  ctech_lib_clk_mux_2to1 clk_mux_2to1_0 (.clk1(clk1), .clk2(clk2), .s(s), .clkout(clkout));  

endmodule // arf066b064e1r1w0cbbehsaa4acw_ctech_clk_mux_2to1



//// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_inv ==========
//module arf066b064e1r1w0cbbehsaa4acw_ctech_inv (
//  input logic a,
//  
//  output logic o1
//);
//
//  ctech_lib_inv inv_0 (.o1(o1), .a(a));  
//
//endmodule // arf066b064e1r1w0cbbehsaa4acw_ctech_inv

//// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_dq ==========
//module arf066b064e1r1w0cbbehsaa4acw_ctech_dq (
//  input logic a,
//  input logic b,
//  
//  output logic o
//);
//
//  ctech_lib_dq dq_0 (.o(o),.a(a),.b(b));
//
//endmodule // arf066b064e1r1w0cbbehsaa4acw_ctech_dq

// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_doublesync_rstb ==========
module arf066b064e1r1w0cbbehsaa4acw_ctech_doublesync_rstb (
  input logic d,
  input logic clk,
  input logic rstb,
  
  output logic o
);

  ctech_lib_doublesync_rstb ds_rstb_0 (.o(o), .d(d), .clk(clk), .rstb(rstb));

endmodule // arf066b064e1r1w0cbbehsaa4acw_ctech_doublesync_rstb

// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_doublesync_setb ==========
module arf066b064e1r1w0cbbehsaa4acw_ctech_doublesync_setb (
  input logic d,
  input logic clk,
  input logic setb,
  
  output logic o
);

  ctech_lib_doublesync_setb ds_setb_0 (.o(o), .d(d), .clk(clk), .setb(setb)); 

endmodule // arf066b064e1r1w0cbbehsaa4acw_ctech_doublesync_setb


// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_doublesync ==========
module arf066b064e1r1w0cbbehsaa4acw_ctech_doublesync (
  input logic d,
  input logic clk,
  
  output logic o
);

  ctech_lib_doublesync ds_0 (.o(o), .d(d), .clk(clk));

endmodule // arf066b064e1r1w0cbbehsaa4acw_ctech_doublesync



// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_clk_nand_en ==========
module arf066b064e1r1w0cbbehsaa4acw_ctech_clk_nand_en (
  input logic clk,
  input logic en,
  
  output logic clkout
);

  ctech_lib_clk_nand_en clk_nand_en_0 (.clkout(clkout), .clk(clk), .en(en));

endmodule // arf066b064e1r1w0cbbehsaa4acw_ctech_clk_nand_en

// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_latch_p ==========
module arf066b064e1r1w0cbbehsaa4acw_ctech_latch_p (
  input logic d,
  input logic clkb,
  
  output logic o
);

  ctech_lib_latch_p latch_p_0 (.o(o), .d(d), .clkb(clkb));

endmodule // arf066b064e1r1w0cbbehsaa4acw_ctech_latch_p

// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_clk_nand ==========
module arf066b064e1r1w0cbbehsaa4acw_ctech_clk_nand (
  input logic clk1,
  input logic clk2,
  
  output logic clkout
);

  ctech_lib_clk_nand clk_nand_0 (.clkout(clkout), .clk1(clk1), .clk2(clk2));

endmodule // arf066b064e1r1w0cbbehsaa4acw_ctech_clk_nand

// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_clk_inv ==========
module arf066b064e1r1w0cbbehsaa4acw_ctech_clk_inv (
  input logic clk,
  
  output logic clkout
);

  ctech_lib_clk_inv clk_inv_0 (.clkout(clkout), .clk(clk));

endmodule // arf066b064e1r1w0cbbehsaa4acw_ctech_clk_inv


// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_clk_or ==========
module arf066b064e1r1w0cbbehsaa4acw_ctech_clk_or (
   output logic clkout,

   input logic clk1,
   input logic clk2
);

   ctech_lib_clk_or clk_or_0 (.clkout(clkout), .clk1(clk1), .clk2(clk2));  

endmodule // arf066b064e1r1w0cbbehsaa4acw_ctech_clk_or


// ========== arf066b064e1r1w0cbbehsaa4acw_ctech_buf ==========
module arf066b064e1r1w0cbbehsaa4acw_ctech_buf (
  input logic a,
  output logic o
);

  ctech_lib_buf buf_0 (.a(a), .o(o));

endmodule // arf066b064e1r1w0cbbehsaa4acw_ctech_buf

//`endif // ARF066B064E1R1W0CBBEHSAA4ACW_MAP_SV
