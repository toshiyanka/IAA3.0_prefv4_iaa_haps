// Text_Tag % Vendor Intel % Product c73p4rfshdxrom % Techno P1273.1 % Tag_Spec 1.0 % ECCN US_3E002 % Signature dbbde551590ed5231a6dfe507a6a31aaeae50708 % Version r1.0.0_m1.18 % _View_Id sv % Date_Time 20160303_050303 
`include "soc_clocks.sv"

module dfx_sync_clock_mux (
   input  logic  clk_in0,
   input  logic  clk_in1,
   input  logic  rst_b0,
   input  logic  rst_b1,
   input  logic  clock_sel,

   output logic  clk_out
);

`ifndef VLV_FPGA_CLK_GATE

  logic   clk0_en;
  logic   clk0_en_sync_noscan;
  logic   clk0_en_syncL;
  logic   clk0_gated;

  logic   clk1_en;
  logic   clk1_en_sync_noscan;
  logic   clk1_en_syncL;
  logic   clk1_gated;
  
  logic   rst_b0_int_noscan;
  logic   rst_b1_int_noscan;

  logic   clk_out_inv;

  assign   clk0_en = ~clock_sel & ~clk1_en_syncL;
  assign   clk1_en = clock_sel  & ~clk0_en_syncL;

  // CLK0 Sync
`ASYNC_RST_2MSFF_META(rst_b0_int_noscan, 1'b1 , clk_in0, rst_b0)  //synchronize reset to clk_in0
`ASYNC_SET_2MSFF_META(clk0_en_sync_noscan, clk0_en, clk_in0, rst_b0_int_noscan)

 
  // CLK1 Sync
`ASYNC_RST_2MSFF_META(rst_b1_int_noscan, 1'b1 , clk_in1, rst_b0)  //synchronize reset to clk_in1
`ASYNC_RST_2MSFF_META(clk1_en_sync_noscan, clk1_en, clk_in1, rst_b1_int_noscan)

  `LATCH_P(clk0_en_syncL, clk0_en_sync_noscan, clk_in0)
  `CLKAND(clk0_gated, clk_in0, clk0_en_syncL)

  `LATCH_P(clk1_en_syncL, clk1_en_sync_noscan, clk_in1)
  `CLKAND(clk1_gated, clk_in1, clk1_en_syncL)

`CLK_NOR(clk_out_inv, clk0_gated, clk1_gated)

`MAKE_CLK_INV(clk_out, clk_out_inv)

`else
  assign clk_out = clk_in0;
`endif
  
endmodule
