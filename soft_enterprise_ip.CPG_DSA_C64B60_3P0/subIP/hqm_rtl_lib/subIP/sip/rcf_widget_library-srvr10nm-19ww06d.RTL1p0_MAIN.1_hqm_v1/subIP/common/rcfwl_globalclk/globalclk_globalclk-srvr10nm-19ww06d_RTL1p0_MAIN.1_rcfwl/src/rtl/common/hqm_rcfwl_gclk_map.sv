
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

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

//`timescale 1ps/1ps

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef HQM_RCFWL_GCLK_MAP
`define HQM_RCFWL_GCLK_MAP
 
 module hqm_rcfwl_gclk_ctech_lib_doublesync #(

           parameter int      WIDTH=1,
           parameter int      MIN_PERIOD=0,
           parameter bit      SINGLE_BUS_META=0,
//    Override Parameters These have define and plusarg overrides
//    Defines reverse the default value for a parameter
           parameter bit      METASTABILITY_EN=0,
// Keeping the PUSE_WIDTH_CHECK parameter for backward comaptibly but is has no funtionalty
           parameter bit      PULSE_WIDTH_CHECK=0,
           parameter bit      ENABLE_3TO1=1,
           parameter bit      PLUS1_ONLY=0,
           parameter bit      MINUS1_ONLY=0,
           parameter bit      TX_MODE=0
 )  (
   input  logic            clk,
   input  logic [WIDTH-1:0]  d,
   output logic [WIDTH-1:0]  o
 );
   ctech_lib_doublesync #(
           .WIDTH(WIDTH),
           .MIN_PERIOD(MIN_PERIOD),
           .SINGLE_BUS_META(SINGLE_BUS_META),
           .METASTABILITY_EN(METASTABILITY_EN),
           .PULSE_WIDTH_CHECK(PULSE_WIDTH_CHECK),
           .ENABLE_3TO1(ENABLE_3TO1),
           .PLUS1_ONLY(PLUS1_ONLY),
           .MINUS1_ONLY(MINUS1_ONLY),
           .TX_MODE(TX_MODE)
   )
   i_ctech_lib_doublesync
      (
       .d     ( d),
       .clk   ( clk ),
       .o     ( o )
      );



endmodule
 






module hqm_rcfwl_gclk_ctech_doublesync_rst (
    input  logic d,
    input  logic clr_b,
    input  logic clk,
    output logic q
);

    ctech_lib_doublesync_rst ctech_lib_doublesync_rst ( .d(d) , .rst(~clr_b) , .clk(clk) , .o(q) );

endmodule // gclk_ctech_doublesync_rst


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

module hqm_rcfwl_gclk_ctech_or2_gen (
    input  logic a,
    input  logic b,
    output logic y
);

    ctech_lib_or2 ctech_lib_or2 ( .a(a) , .b(b) , .o(y) );

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

module hqm_rcfwl_gclk_ctech_and2_gen (
    input  logic a,
    input  logic b,
    output logic y
);


   ctech_lib_and2 ctech_lib_and2 ( .a(a) , .b(b) , .o(y) );

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

////// added by KC for the gclk_clkdist dir

module hqm_rcfwl_gclk_ctech_msff_async_rst_set( input logic d,
                                              input logic clk,
                                              input logic rst,
                                              input logic set,
                                              output logic o);
  
   ctech_lib_msff_async_rst_set ctech_lib_msff_async_rst_set  (.d(d), .clk(clk), .rst(rst), .set(set), .o(o));
   
endmodule

module hqm_rcfwl_gclk_ctech_glbdrvqclk(
    output logic soft_high_out,
    output logic clkout,
    output logic clkfree,
    input logic  clkin,
    input logic  clken,
    input logic  scanclk,
    input logic  clkenfree );

    ctech_lib_glbdrvqclk i_ctech_lib_glbdrvqclk (
        .soft_high_out (soft_high_out),
        .clkout(clkout),
        .clkfree(clkfree),
        .clkin(clkin),
        .clken(clken),
        .scanclk(scanclk),
        .clkenfree(clkenfree) );
        
endmodule
module hqm_rcfwl_gclk_ctech_lib_glbdrvdclk(
    output logic soft_high_out,
    output logic clkout,
    output logic clkfree,
    input logic  clkdivrst,
    input logic  clkin,
    input logic  clken,
    input logic  scanclk,
    input logic  clkenfree );


        ctech_lib_glbdrvdclk i_ctech_lib_glbdrvdclk (
                        .soft_high_out (soft_high_out),
                        .clkout(clkout),
                        .clkfree(clkfree),
                        .clkdivrst(clkdivrst),
                        .clkin(clkin),
                        .clken(clken),
                        .scanclk(scanclk),
                        .clkenfree(clkenfree) );
      
endmodule

module hqm_rcfwl_gclk_ctech_lib_glbdrvqclk(
    output logic soft_high_out,
    output logic clkout,
    output logic clkfree,
    input logic  clkin,
    input logic  clken,
    input logic  scanclk,
    input logic  clkenfree );


        ctech_lib_glbdrvqclk i_ctech_lib_glbdrvqclk (
                        .soft_high_out (soft_high_out),
                        .clkout(clkout),
                        .clkfree(clkfree),
                        .clkin(clkin),
                        .clken(clken),
                        .scanclk(scanclk),
                        .clkenfree(clkenfree) );
      
endmodule


module hqm_rcfwl_gclk_ctech_glbdrvdiv3 ( input logic clkin,
                                 input logic clkdivrst,
                                 input logic clken,
                                 input logic clkenfree,
                                 input logic scanclk,
                                 output logic clkfree,
                                 output logic clkout,
                                  output logic soft_high_out
                                  );

   ctech_lib_glbdrvdiv3 i_ctech_lib_glbdrvdiv3  (.clkin (clkin) ,
                                                  .clkdivrst(clkdivrst),
                                                  .clken(clken),
                                                  .clkenfree (clkenfree),
                                                  .scanclk (scanclk) ,
                                                  .clkfree (clkfree),
                                                  .clkout (clkout),
                                                  .soft_high_out (soft_high_out)
                                                   );
endmodule



module hqm_rcfwl_gclk_ctech_glbdrvdiv4or2ls(
    output logic soft_high_out,
    output logic clkout,
    output logic clkfree,
    input logic  clkin,
    input logic  clken,
    input logic  div2,
    input logic  clkdivrst,
    input logic  scanclk,
    input logic  clkenfree );
    
   ctech_lib_glbdrvdiv4or2ls ctech_lib_glbdrvdiv4or2ls(
        .soft_high_out(soft_high_out),
        .clkout(clkout),
        .clkfree(clkfree),
        .clkin(clkin),
        .clken(clken),
        .div2(div2),
        .clkdivrst(clkdivrst),
        .scanclk(scanclk),
        .clkenfree(clkenfree) );
    
    
 endmodule   


module hqm_rcfwl_gclk_ctech_clk_and_en (input logic clk,
                              input logic en,
                              output logic clkout);

   ctech_lib_clk_and_en ctech_lib_clk_and_en (.clkout(clkout),
                                              .clk   (clk),
                                              .en    (en));

endmodule

module hqm_rcfwl_gclk_ctech_clk_and_en_lcb (input logic clk,
                              input logic en,
                              output logic clkout);

   ctech_lib_clk_and_en_lcb ctech_lib_clk_and_en_lcb (.clkout(clkout),
                                                      .clk   (clk),
                                                      .en    (en));

endmodule

module hqm_rcfwl_gclk_ctech_clk_or (input logic clk1,
                          input logic clk2,
                          output logic clkout);

   ctech_lib_clk_or ctech_lib_clk_or(.clk1(clk1),
                                     .clk2(clk2),
                                     .clkout(clkout));

endmodule

module hqm_rcfwl_gclk_ctech_clock_mux2 (input  logic  clk1 , 
                                input  logic  clk2,  
                                input  logic  sa,        
                                output logic  clkout);
                                  
 ctech_lib_clock_mux2  ctech_lib_clock_mux2(.clk1 (clk1),
                                                   .clk2 (clk2),
                                                   .sa (sa),
                                                   .clkout (clkout));

endmodule

module hqm_rcfwl_gclk_ctech_clk_div2_reset(input logic clk,
                                 input logic rst,
                                 input logic in,
                                 output logic clkout);

                                         
ctech_lib_clk_div2_reset i_pos (.clk    (clk),
                                .rst    (rst),
                                .in     (in),
                                .clkout (clkout) );

endmodule



module hqm_rcfwl_gclk_ctech_rcb_and (input logic clkb,
                           input logic en,
                           input logic fd,
                           input logic rd,
                           output logic clkout);

   ctech_lib_rcb_and ctech_lib_rcb_and (.clkout(clkout),
                                        .clkb(clkb),
                                        .en(en),
                                        .fd(fd),
                                        .rd(rd));
endmodule

module hqm_rcfwl_gclk_ctech_rcb(input logic clkb,  
                      input logic en,    
                      input logic fd,    
                      input logic rd,    
                      output logic clkout);

   ctech_lib_rcb ctech_lib_rcb (.clkout(clkout),
                                .clkb(clkb),
                                .en(en),
                                .fd(fd),
                                .rd(rd));
endmodule

module hqm_rcfwl_gclk_ctech_rcb_and_lcp4 (input logic clkb,
                           input logic en,
                           input logic fd0,
                           input logic rd0,
                           input logic fd1,
                           input logic rd1,
                           output logic clkout);

   logic latrcbenL;

// HSD #1209644942 change ctech latch to behavioral RTL
//    ctech_lib_latch_p ctech_lib_latch_p (
//                .o(enL),
//               .d(en),
//               .clkb(clkb));
   always_latch 
    begin
     if (~(clkb)) latrcbenL <= en;
    end
    
   ctech_lib_rcb_lcp4 ctech_lib_rcb_lcp4 (.clkout(clkout),
                                        .clk(clkb),
                                        .en(latrcbenL),
                                   .fd0(fd0),
                                   .rd0(rd0),
                                   .fd1(fd1),
                                   .rd1(rd1));
endmodule

module hqm_rcfwl_gclk_ctech_rcb_lcp4(input logic clkb,
                      input logic en,
                      input logic fd0,
                      input logic rd0,
                           input logic fd1,
                           input logic rd1,
                      output logic clkout);

   ctech_lib_rcb_lcp4 ctech_lib_rcb_lcp4 (.clkout(clkout),
                                .clk(clkb),
                                .en(en),
                                .fd0(fd0),
                                .rd0(rd0),
                                .fd1(fd1),
                                .rd1(rd1));
endmodule

   

module hqm_rcfwl_gclk_ctech_clk_inv (input logic clk,   
                           output logic clkout);
   
   ctech_lib_clk_inv ctech_lib_clk_inv (.clkout(clkout),
                                        .clk(clk));
endmodule
   
   
module hqm_rcfwl_gclk_ctech_clk_flop (input logic clk,
                            input logic d,
                            output logic clkout); 

   ctech_lib_clk_flop  ctech_lib_clk_flop (.d(d),
                                          .clkout(clkout),
                                          .clk(clk));
endmodule

module  hqm_rcfwl_gclk_ctech_clk_ffb (input logic clk,
                            input logic in,
                            output logic clkout); 

   ctech_lib_clk_ffb  ctech_lib_clk_ffb (.in(in),
                                          .clkout(clkout),
                                          .clk(clk));
endmodule


module hqm_rcfwl_gclk_ctech_lib_doublesync_rstb (input logic d,
                                        input logic clk,
                                        input logic rstb,
                                        output logic o);
   ctech_lib_doublesync_rstb ctech_lib_doublesync_rstb (.d(d), .clk(clk), .rstb(rstb), .o(o));
   
endmodule // gclk_ctech_doublesync_rstb

module hqm_rcfwl_gclk_ctech_sdg_programmable_delay_clk_buf
(
     input logic clk,
     input logic rsel0,
     input logic rsel1,
     input logic rsel10,
     input logic rsel11,
     input logic rsel12,
     input logic rsel13,
     input logic rsel14,
     input logic rsel2,
     input logic rsel3,
     input logic rsel4,
     input logic rsel5,
     input logic rsel6,
     input logic rsel7,
     input logic rsel8,
     input logic rsel9,
     output logic clkout
);

  ctech_lib_sdg_programmable_delay_clk_buf ctech_lib_sdg_programmable_delay_clk_buf
      (
      .clk(clk),
      .rsel0(rsel0),
      .rsel1(rsel1),
      .rsel10(rsel10),
      .rsel11(rsel11),
      .rsel12(rsel12),
      .rsel13(rsel13),
      .rsel14(rsel14),
      .rsel2(rsel2),
      .rsel3(rsel3),
      .rsel4(rsel4),
      .rsel5(rsel5),
      .rsel6(rsel6),
      .rsel7(rsel7),
      .rsel8(rsel8),
      .rsel9(rsel9),
      .clkout(clkout)
); 
endmodule
module hqm_rcfwl_gclk_ctech_clock_mux2_glitch_free ( input  logic  clk1 , 
                                input  logic  clk2,  
                                input  logic  sel1,
                                input  logic  sel2,      
                                output logic  clkout);
                                  
  ctech_lib_clock_mux2_glitch_free  ctech_lib_clock_mux2_glitch_free (
                                                   .clk1 (clk1),
                                                   .clk2 (clk2),
                                                   .sel1(sel1),
                                                   .sel2 (sel2),
                                                   .clkout (clkout));

endmodule
module  hqm_rcfwl_gclk_ctech_lib_latch_async_rst 
      (
        input  clk,
        input  d , 
        input  rb,
        output o
       );
 ctech_lib_latch_async_rst  ctech_lib_latch_async_rst(  
                            .clk (clk),
                            .d(d),
                            .rb(rb),
                            .o(o));
 endmodule
 
 
module hqm_rcfwl_gclk_ctech_clk_nor_en  (
 output clkout,
 input en, 
 input clk
 );
 ctech_lib_clk_nor_en ctech_lib_clk_nor_en(
               .clkout(clkout),
               .en(en),
               .clk(clk));      
 endmodule 
 
 module  hqm_rcfwl_gclk_ctech_mux_2to1( 
                 input d1,
                 input d2,
                 input s,
                 output o );
                 
 ctech_lib_mux_2to1 ctech_lib_mux_2to1 (
              .d1(d1),
              .d2(d2),
              .s(s),
              .o(o));
endmodule
module hqm_rcfwl_gclk_ctech_clk_buf (
                   input clk,
                   output clkout
                   ); 
 ctech_lib_clk_buf i_ctech_lib_buf_2to1(
                   .clk(clk),
                   .clkout (clkout)
                   );   
endmodule 
 module hqm_rcfwl_gclk_ctech_clk_gate_and (
                     input clk,
                     input  en,
                     output clkout                 
                      );
                      
  ctech_lib_clk_gate_and   i_ctech_lib_clk_gate_and  (
                     .clk (clk),
                     .en (en),
                     .clkout (clkout)
                     );   
 endmodule                  
`endif
  
