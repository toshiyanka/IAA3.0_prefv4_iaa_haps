
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
module hqm_rcfwl_gclk_trunk_clock_switch (
                 
        input logic clk_in,
        input logic divider_reset,
        input logic switch_mode,
        
        output logic clk_out
         
);

logic divider_reset_reg;
logic divider_reset_edge;
logic divider_reset_sync;
logic clk_in_sel_dly;
logic clk_div_sel_dly;
logic clk_div_sel_nxt;
logic clk_in_sel_nxt;
logic clk_div_sel_l;
logic clk_in_sel_l;
logic clk_div_sel;
logic clk_in_sel;
logic swth_mode_clk_in_sync;
logic swth_mode_clk_div_sync;
logic clk_div;
logic switch_mode_sync_div;
logic switch_mode_sync;

//syncronize divider reset
hqm_rcfwl_gclk_ctech_lib_doublesync gclk_ctech_lib_doublesync_div_reset
                        
  (
       .d     ( divider_reset),
       .clk   ( clk_in ),
       .o     ( divider_reset_sync)
      );

hqm_rcfwl_gclk_ctech_lib_doublesync gclk_ctech_lib_doublesync_switch_mode
                        
  (
       .d     (switch_mode ),
       .clk   ( clk_in ),
       .o     ( switch_mode_sync)
      );      
      
 hqm_rcfwl_gclk_ctech_lib_doublesync gclk_ctech_lib_doublesync_switch_mode_div
                        
  (
       .d     (switch_mode ),
       .clk   ( clk_div ),
       .o     ( switch_mode_sync_div)
      );     
      
      

//Edege det
  always_ff @(posedge clk_in) begin
        divider_reset_reg <= divider_reset_sync ;
    end

// on rising edge of the sync, generate a reset pulse
    assign divider_reset_edge = (divider_reset_sync & (~divider_reset_reg)) ;


// divider by 2     
 hqm_rcfwl_gclk_ctech_lib_glbdrvdclk   i_gclk_ctech_lib_glbdrvdclk   ( 
                                 .clkin (clk_in) , 
                                 .clkdivrst(divider_reset_edge),
                                 .clken(1'b1 ),
                                 .clkenfree (1'b1),
                                 .scanclk (1'b0) , 
                                 .clkfree (clk_div), 
                                 .clkout (),
                                 .soft_high_out() 
                                 );   



//######################################
////glitchfree mux
//###################################### 
// hsd #1606808261 clk divider widget for PLL trunk clock switching(TCS) has incorrect control polarity for clk muxing
// 0 -> clk_in = clk_out , 1 -> clk_div= clk_out 
hqm_rcfwl_gclk_ctech_and2_gen i_gclk_ctech_and2_gen_clkdiv(

        .a(switch_mode_sync_div) , .b(~clk_in_sel_dly) , .y(clk_div_sel_nxt) );

hqm_rcfwl_gclk_ctech_and2_gen i_gclk_ctech_and2_gen_clk_in(

        .a(~switch_mode_sync) , .b(~clk_div_sel_dly) , .y(clk_in_sel_nxt) );
        
always_ff@( posedge clk_in )
 begin

  clk_in_sel_dly <= clk_in_sel;
 end

always_ff@( posedge clk_div)
 begin
  clk_div_sel_dly <= clk_div_sel;
 end    

hqm_rcfwl_gclk_ctech_lib_doublesync gclk_ctech_lib_doublesync_clk_in_sel
                        
  (
       .d     (clk_in_sel_nxt),
       .clk   ( clk_in ),
       .o     ( clk_in_sel)
      );

hqm_rcfwl_gclk_ctech_lib_doublesync gclk_ctech_lib_doublesync_div_sel
                        
  (
       .d     (clk_div_sel_nxt),
       .clk   ( clk_div ),
       .o     ( clk_div_sel)
      );

hqm_rcfwl_gclk_ctech_lib_latch_async_rst clkdiv_ctech_lib_latch_async_rst( .clk(~clk_div), .d(clk_div_sel) , .rb(1'b1), .o(clk_div_sel_l));
hqm_rcfwl_gclk_ctech_lib_latch_async_rst clkin_ctech_lib_latch_async_rst( .clk(~clk_in), .d(clk_in_sel) , .rb(1'b1), .o(clk_in_sel_l));   

// clock mux.
 hqm_rcfwl_gclk_ctech_clock_mux2_glitch_free i_trunk_clk_ctech_clock_mux2_glitch_free(
                                                   .clk1 (clk_div),
                                                   .clk2 (clk_in),
                                                   .sel1 (clk_div_sel_l),
                                                   .sel2 (clk_in_sel_l),
                                                   .clkout (clk_out));  


endmodule 
