
///
///  INTEL CONFIDENTIAL
///
///  Copyright 2015 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///
module hqm_rcfwl_gclk_glitchfree_clkmux (
                 
	input logic x12clk,
	input logic agentclk,
	input logic x12clk_sync,
	input logic agentclk_sync,
	input logic iso_b,
	output logic clk_out,
	output logic sync_out
);


logic x12clk_ff1;
logic x12clk_ff2;
logic x12clk_ff3;
logic agtclk_ff1;
logic agtclk_ff2;
logic agtclk_ff3;
logic x12clk_ff1_nxt;
logic x12clk_ff2_nxt;
logic x12clk_ff3_nxt;
logic agtclk_ff1_nxt;
logic agtclk_ff2_nxt;
logic agtclk_ff3_nxt;
logic net1;
logic net2;
logic net3;
logic net4;
logic net5;
logic net6;
logic iso_b_x12clk_sync;
logic iso_b_agentclk_sync;
logic x12clk_ff4;
logic agtclk_ff4;
logic agtclk_ff3_latch;
logic x12clk_ff3_latch;
logic x12clk_sync_out;
logic agtclk_sync_out;

// HSD#1405595897
hqm_rcfwl_gclk_ctech_lib_doublesync_rstb x12clk_iso_b_sync(.d(1'b1), .clk(x12clk), .rstb(iso_b), .o(iso_b_x12clk_sync));
hqm_rcfwl_gclk_ctech_lib_doublesync_rstb agentclk_iso_b_sync(.d(1'b1), .clk(agentclk), .rstb(iso_b), .o(iso_b_agentclk_sync));

hqm_rcfwl_gclk_ctech_or2_gen i_gclk_ctech_or2_gen_1 (
                              
	.a(agtclk_ff2) , .b(iso_b) , .y(x12clk_ff1_nxt) );

always_comb
begin

//x12clk_ff1_nxt = agtclk_ff2 | iso_b ;

net1 = (~x12clk_sync) & x12clk_ff1 ;
net2 = (~x12clk_sync) | x12clk_ff1 ;
net3 =  net1 | x12clk_ff2 ;

x12clk_ff2_nxt = net2 & net3;
end

hqm_rcfwl_gclk_ctech_lib_doublesync_rstb x12clk_ctech_lib_doublesync_rstb (

    .d(x12clk_ff1_nxt), .clk(x12clk), .rstb(1'b1), .o(x12clk_ff1));
    

always_ff@( posedge x12clk or negedge iso_b_x12clk_sync) 
 begin
 if (~iso_b_x12clk_sync)
  x12clk_ff2 <= 1'b0;
 else
  x12clk_ff2 <= x12clk_ff2_nxt;
 end

hqm_rcfwl_gclk_ctech_and2_gen i_gclk_ctech_and2_gen_1(
                              
	.a(x12clk_ff2) , .b(iso_b) , .y(agtclk_ff1_nxt) );

always_comb
begin
//agtclk_ff1_nxt = x12clk_ff2 & iso_b ;

net4 = (~agentclk_sync) &  agtclk_ff1 ;
net5 = (~agentclk_sync) | agtclk_ff1 ;
net6 = net4 | agtclk_ff2 ; 

agtclk_ff2_nxt =  net6 & net5 ; 
end

hqm_rcfwl_gclk_ctech_lib_doublesync_rstb agtclk_ctech_lib_doublesync_rstb (

    .d(agtclk_ff1_nxt), .clk(agentclk), .rstb(iso_b_agentclk_sync), .o(agtclk_ff1));
    
always_ff@( posedge agentclk or negedge iso_b_agentclk_sync) 
 begin
 if (~iso_b_agentclk_sync)
  agtclk_ff2 <= 1'b0;
 else
  agtclk_ff2 <= agtclk_ff2_nxt;
 end

always_ff@( posedge agentclk or negedge iso_b_agentclk_sync)
 begin
 if (~iso_b_agentclk_sync)
  agtclk_ff4 <= 1'b0;
 else
  agtclk_ff4 <= agtclk_ff3;
 end

always_ff@( posedge x12clk or negedge iso_b_x12clk_sync)
 begin
 if (~iso_b_x12clk_sync)
  x12clk_ff4 <= 1'b0;
 else
  x12clk_ff4 <= x12clk_ff3;
 end
 
 
// clock controlling logic.

hqm_rcfwl_gclk_ctech_or2_gen i_gclk_ctech_or2_gen (
                              
	.a(x12clk_ff2) , .b(agtclk_ff4) , .y(x12clk_ff3_nxt) );

hqm_rcfwl_gclk_ctech_and2_gen i_gclk_ctech_and2_gen(
                              
	.a(x12clk_ff2) , .b(x12clk_ff4) , .y(agtclk_ff3_nxt) );
	

hqm_rcfwl_gclk_ctech_lib_doublesync_rstb i_x12clk_ctech_lib_doublesync_rstb (

    .d(x12clk_ff3_nxt), .clk(x12clk), .rstb(iso_b_x12clk_sync), .o(x12clk_ff3));

hqm_rcfwl_gclk_ctech_lib_doublesync_rstb i_agtclk_ctech_lib_doublesync_rstb (

    .d(agtclk_ff3_nxt), .clk(agentclk), .rstb(iso_b_agentclk_sync), .o(agtclk_ff3));

// HSD #1406493502 Glitchfree clkmux timing issue
//1.  Add low phase latch on select to avoid race condition
//2. Separate out clock muxing from data (sync) muxing using appropriate CTECH cells (updated with Ctech AND-OR structure).
//3.  Add positive edge triggered flop in feedback loop of each select path.Further the PH2 latches and pose edge flops need to have async reset controls from same clock domain as the metaflop driving the inputs.


hqm_rcfwl_gclk_ctech_lib_latch_async_rst x12clk_ctech_lib_latch_async_rst( .clk(~x12clk), .d(x12clk_ff3) , .rb(iso_b_x12clk_sync), .o(x12clk_ff3_latch));
hqm_rcfwl_gclk_ctech_lib_latch_async_rst agtclk_ctech_lib_latch_async_rst( .clk(~agentclk), .d(agtclk_ff3) , .rb(iso_b_agentclk_sync), .o(agtclk_ff3_latch));


// clock mux.
 hqm_rcfwl_gclk_ctech_clock_mux2_glitch_free clk_ctech_clock_mux2_glitch_free(
                                                   .clk1 (x12clk),
						   .clk2 (agentclk),
						   .sel1 (~x12clk_ff3_latch),
						   .sel2 (agtclk_ff3_latch),
						   .clkout (clk_out));
//Sync mux.
hqm_rcfwl_gclk_ctech_and2_gen x12clksync_ctech_and2_gen  ( .a(x12clk_sync) , .b(~x12clk_ff2) , .y(x12clk_sync_out) );
hqm_rcfwl_gclk_ctech_and2_gen agentclksync_ctech_and2_gen(.a(agentclk_sync) , .b(agtclk_ff2) , .y(agtclk_sync_out) );
hqm_rcfwl_gclk_ctech_or2_gen sync_out_ctech_or2_gen      (.a(x12clk_sync_out) , .b(agtclk_sync_out) , .y(sync_out) );

endmodule 
