// Text_Tag % Vendor Intel % Product c73p4rfshdxrom % Techno P1273.1 % Tag_Spec 1.0 % ECCN US_3E002 % Signature ee63ddb13c3eb6f9ffe33d743778ad8fb19f3ada % Version r1.0.0_m1.18 % _View_Id sv % Date_Time 20160303_050303 

`ifndef RFROM_MAP
`define RFROM_MAP

module rfrom_ctech_clk_buf (
   input  wire clk,
   output wire clkout
);

 ctech_lib_clk_buf ctech_lib_clk_buf1(.clk(clk), .clkout(clkout));

endmodule

module rfrom_ctech_mbist_en_sync (
	input  logic  clk,
	input  logic  rst,
	input  logic  en_in,
	output logic  en_out
);

  logic rst_int;

 ctech_lib_msff_async_rst_meta   ctech_lib_msff_async_rst_meta1(.o(rst_int), .d(1'b1), .clk(clk), .rst(~rst));
 ctech_lib_msff_async_rst_meta   ctech_lib_msff_async_rst_meta2(.o(en_out), .d(en_in), .clk(clk), .rst(~rst_int));

endmodule

module rfrom_ctech_clk_mux_2to1_glitchfree (
   input  logic  clk_in0,
   input  logic  clk_in1,
   input  logic  rst_b0,
   input  logic  rst_b1,
   input  logic  clock_sel,

   output logic  clk_out
);

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
ctech_lib_msff_async_rst_meta   ctech_lib_msff_async_rst_meta5(.o(rst_b0_int_noscan), .d(1'b1) , .clk(clk_in0), .rst(~rst_b0));  //synchronize reset to clk_in0
ctech_lib_msff_async_set_meta   ctech_lib_msff_async_set_meta1(.o(clk0_en_sync_noscan), .d(clk0_en), .clk(clk_in0), .set(~rst_b0_int_noscan));
 
  // CLK1 Sync
ctech_lib_msff_async_rst_meta   ctech_lib_msff_async_rst_meta6(.o(rst_b1_int_noscan), .d(1'b1) , .clk(clk_in1), .rst(~rst_b0));  //synchronize reset to clk_in1
ctech_lib_msff_async_rst_meta   ctech_lib_msff_async_rst_meta7(.o(clk1_en_sync_noscan), .d(clk1_en), .clk(clk_in1), .rst(~rst_b1_int_noscan));

ctech_lib_latch_p ctech_lib_latch1(.o(clk0_en_syncL), .d(clk0_en_sync_noscan), .clkb(clk_in0));
ctech_lib_clk_and_en ctech_lib_clk_and1(.clkout(clk0_gated), .clk(clk_in0), .en(clk0_en_syncL));

ctech_lib_latch_p ctech_lib_latch2(.o(clk1_en_syncL), .d(clk1_en_sync_noscan), .clkb(clk_in1));
ctech_lib_clk_and_en ctech_lib_clk_and2(.clkout(clk1_gated), .clk(clk_in1), .en(clk1_en_syncL));

ctech_lib_clk_nor ctech_lib_clk_nor2(.clkout(clk_out_inv), .clk1(clk0_gated), .clk2(clk1_gated));

ctech_lib_clk_inv ctech_lib_clk_inv1(.clkout(clk_out), .clk(clk_out_inv));

endmodule

`endif
