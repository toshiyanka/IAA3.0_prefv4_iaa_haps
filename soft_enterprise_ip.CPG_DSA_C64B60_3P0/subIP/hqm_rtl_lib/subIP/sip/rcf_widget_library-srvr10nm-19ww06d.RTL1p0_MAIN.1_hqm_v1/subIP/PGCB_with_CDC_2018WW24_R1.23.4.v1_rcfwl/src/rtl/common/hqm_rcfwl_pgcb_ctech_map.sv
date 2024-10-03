//----------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2012 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intels prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//----------------------------------------------------------------------------

`ifndef HQM_RCFWL_PGCB_CTECH_MAP_SV
`define HQM_RCFWL_PGCB_CTECH_MAP_SV

// Double-synch META Param Support 
//----------------------------------------------------------------------------------- 
//   W40: yjkim1
//----------------------------------------------------------------------------------- 
//   Copied paramters from CTECH library d-synch model for META and PULSE WIDTH check.  
//   Only overridable parameters are exposed to upper hierarchy.
//   Non-overridable parameters are commented out.
//   All modes are turned off by default because we cannot disable if Defines.
//   The modes are turned on by default.
//----------------------------------------------------------------------------------- 
//----------------------------------------------------------------------------------- 
// Parameters: 
//     Non Override Parameters
//             WIDTH (int)               Defines the number of bits that are syncronized 
//             MIN_PERIOD (int)          When non-zero, input data delays are used rather than random N/N+1 flop delays.
//                                       MIN_PERIOD (based on timescale) specifies the minimure period used by either the source or
//                                       destination clock domain.
//             SINGLE_BUS_META           This is forces all the bit of the  meta flop to use randomize based on a singal bit
//
// Parameter/Define/Plusarg decision tree :
//      Parameter (default ==1)                             Parameter (default ==0)        
//         !  /            \                                   !  /            \
//        disable         Define                              Define         Enable  
//                       !/    \                             !/    \ 
//                   Plusarg  Enable                     Plusarg  Enable  
//                   !/    \                             !/    \ 
//               disable  Enable                     disable  Enable        
// 
//    Override Parameters These have define and plusarg overrides
//             METASTABILITY_EN          When set to zero, metastability modeling is disabled on a per-instance basis.
//             PULSE_WIDTH_CHECK         When set to zero, input pulse width assertions are disabled on a per-instance basis.
//             WIDTH                     Sets the width of the data bus
//             PLUS1_ONLY                Disable the Minus 1 RX flop Mode, The meta flop will only provide 2 or 3 clock of delay
//             MINUS1_ONLY               Disable the PLus  1 RX flop Mode, The meta flop will only provide 2 or 1 clock of delay
//             ENABLE_3TO1               Enables the meta flop to make 3 clock delays to 1 clock delays and possible loss of some pulses
//                                      
// Define/Plusargs:   
//             CTECH_LIB_META_DISPLAY    Display metaflop module name, full instance path, parameter and plusarg values. (Plusarg Only)
//             CTECH_LIB_META_ON         When set it will globaly enable meta-stablity modeling expect on those instnace with the paratemer override, defaults METASTABILTY_EN to 1
//             CTECH_LIB_PULSE_ON        When set input pulse width assertions are enabled
//             CTECH_LIB_PLUS1_ONLY      Disable the Minus 1 RX flop Mode, The meta flop will only provide 2 or 3 clock of delay
//             CTECH_LIB_MINUS1_ONLY     Disable the Minus 1 RX flop Mode, The meta flop will only provide 2 or 1 clock of delay
//             CTECH_LIB_ENABLE_3TO1     Enables the meta flop to make 3 clock delays to 1 clock delays and possible loss of some pulses
//
//     Non Override Parameters 
//           parameter integer  WIDTH=1,
//           parameter integer  MIN_PERIOD=0,
//           parameter bit      SINGLE_BUS_META=0,
//    Override Parameters These have define and plusarg overrides
//
//    Defines reverse the default value for a parameter
//           parameter bit      METASTABILITY_EN=1,    
//           parameter bit      PULSE_WIDTH_CHECK=1,   
//           parameter bit      ENABLE_3TO1=1,
//           parameter bit      PLUS1_ONLY=0,
//           parameter bit      MINUS1_ONLY=0


module hqm_rcfwl_pgcb_ctech_doublesync #(  
           parameter bit      METASTABILITY_EN=1,    
           parameter bit      PULSE_WIDTH_CHECK=1,   
           parameter bit      ENABLE_3TO1=1,         
           parameter bit      PLUS1_ONLY=0,	     
           parameter bit      MINUS1_ONLY=0   
 )  (
   input  logic  d,
   input  logic  clr_b,
   input  logic  clk,
   output logic  q
 );
   ctech_lib_doublesync_rstb #(
           .METASTABILITY_EN(METASTABILITY_EN),    
           .PULSE_WIDTH_CHECK(PULSE_WIDTH_CHECK),   
           .ENABLE_3TO1(ENABLE_3TO1),
           .PLUS1_ONLY(PLUS1_ONLY),
           .MINUS1_ONLY(MINUS1_ONLY)
  )ctech_lib_doublesync_rstb1 (
      .d(d),
      .o(q),
      .clk(clk),
      .rstb(clr_b)
   );
endmodule


module hqm_rcfwl_pgcb_ctech_doublesync_lpst # (  
           parameter bit      METASTABILITY_EN=1,    
           parameter bit      PULSE_WIDTH_CHECK=1,   
           parameter bit      ENABLE_3TO1=1,         
           parameter bit      PLUS1_ONLY=0,	     
           parameter bit      MINUS1_ONLY=0   
 )  (
   input  logic  d,
   input  logic  pst_b,
   input  logic  clk,
   output logic  q
 );
   ctech_lib_doublesync_setb #(
      .METASTABILITY_EN(METASTABILITY_EN), 
      .PULSE_WIDTH_CHECK(PULSE_WIDTH_CHECK),
      .ENABLE_3TO1(ENABLE_3TO1),
      .PLUS1_ONLY(PLUS1_ONLY),
      .MINUS1_ONLY(MINUS1_ONLY)
   )ctech_lib_doublesync_setb1 (
      .d(d),
      .o(q),
      .clk(clk),
      .setb(pst_b)
   );
endmodule 


module hqm_rcfwl_pgcb_ctech_doublesync_rstmux #(
           parameter bit      METASTABILITY_EN=1,
           parameter bit      PULSE_WIDTH_CHECK=1,   
           parameter bit      ENABLE_3TO1=1,
           parameter bit      PLUS1_ONLY=0,
           parameter bit      MINUS1_ONLY=0
)
(
    input  logic                 clk, // rxclk
    input  logic                 clr_b, // txrst_b
    input  logic                 rst_bypass_b, // dt_scanrst_b
    input  logic                 rst_bypass_sel, // dt_scanmode
    output logic                 q  // rxrst_b
 ); 
   logic q_sync;

   ctech_lib_doublesync_rstb #(
           .METASTABILITY_EN(METASTABILITY_EN),    
           .PULSE_WIDTH_CHECK(PULSE_WIDTH_CHECK),   
           .ENABLE_3TO1(ENABLE_3TO1),
           .PLUS1_ONLY(PLUS1_ONLY),
           .MINUS1_ONLY(MINUS1_ONLY)
   )ctech_lib_doublesync_rstb1 (
      .d(1'b1),
      .o(q_sync),
      .clk(clk),
      .rstb(clr_b)
   );

   ctech_lib_mux_2to1 ctech_lib_mux_2to11 (
      .s(rst_bypass_sel),
      .d1(rst_bypass_b),
      .d2(q_sync),
      .o(q)
   );

endmodule


module hqm_rcfwl_pgcb_ctech_clock_gate (
   input  logic   en,
   input  logic   te,
   input  logic   clk,
   output logic   enclk 
);
   ctech_lib_clk_gate_te ctech_lib_clk_gate_te1 (
      .en(en),
      .te(te),
      .clk(clk),
      .clkout(enclk)
   );
endmodule


module hqm_rcfwl_pgcb_ctech_and2_gen (
   input  logic  a,
   input  logic  b,
   output logic  y
);

   ctech_lib_dq ctech_lib_dq1 (
      .a(a),
      .b(b),
      .o(y)
   );
endmodule


//module pgcb_ctech_or2_gen (
//   input  logic  a,
//   input  logic  b,
//   output logic  y
//);
//   // TODO - No CTECH lib available 
//   assign y = a | b; 
//endmodule

module hqm_rcfwl_pgcb_ctech_mux_2to1_gen (
   input  logic  d1,
   input  logic  d2,
   input  logic  s,
   output logic  o
);
   ctech_lib_mux_2to1 ctech_lib_mux_2to11 (
      .d1(d1),
      .d2(d2),
      .s(s),
      .o(o)
   );
endmodule

module hqm_rcfwl_pgcb_ctech_clock_buf (
   input  logic  ck,
   output logic  o
);
   ctech_lib_clk_buf ctech_lib_clk_buf1 (
      .clk(ck),
      .clkout(o)
   );
endmodule

`endif
