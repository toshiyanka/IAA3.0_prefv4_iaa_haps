// Text_Tag % Vendor Intel % Product c73p4rfshdxrom % Techno P1273.1 % Tag_Spec 1.0 % ECCN US_3E002 % Signature f49a866a621f12c9ebc096d83efb75e0932ccbb6 % Version r1.0.0_m1.18 % _View_Id sv % Date_Time 20160303_050453 
//=============================================================================
//  Copyright (c) 2010 Intel Corporation, all rights reserved.
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY
//  COPYRIGHT LAWS AND IS CONSIDERED A TRADE SECRET BELONGING
//  TO THE INTEL CORPORATION.
//
//  Intel Confidential
//=============================================================================
//
// MOAD Begin
//     File/Block                             : soc_macros.sv
//     Design Style [rls|rf|ssa_fuse|sdp|
//                   custom|hier|rls_hier]    : rls
//     Circuit Style [non_rfs|rfs|ssa|fuse|
//                    IO|ROM|none]            : none
//     Common_lib (for custom blocks only)    : none  
//     Library (must be same as module name)  : soc_macros
//     Unit [unit id or shared]               : shared
//     Complex [North, South, CPU]            : North
//     Bizgroup [LCP|SEG|ULMD]                : ULMD
//
// Design Unit Owner :   ram.m.krishnamurthy@intel.com
// Primary Contact   :   ram.m.krishnamurthy@intel.com
// 
// MOAD End
//
//=============================================================================
//
// Description:
//   <Enter Description Here>
//
//=============================================================================
`ifndef SOC_MACROS_VH
`define SOC_MACROS_VH

`include "bxt_macro_tech_map.vh"

`define RST_LATCH_P(q,i,clock,rst)                           \
`ifdef SIM                                                   \
   `ifdef  MACRO_ATTRIBUTE                                   \
      `undef MACRO_ATTRIBUTE                                 \
      `RST_LATCH(q,i,(~(clock)),rst)                         \
      `define MACRO_ATTRIBUTE                                \
   `else                                                     \
      `RST_LATCH(q,i,(~(clock)),rst)                         \
   `endif                                                    \
`else                                                        \
  logic \clkb_``q;                                           \
  `CLKINV(\clkb_``q,(clock))                                 \
  `RST_LATCH(q,i,\clkb_``q,rst)                              \
`endif






// Commented out after meeting on 24 March 2011
//// New inverter for top level tie-offs
//// Usage is only for top level tie-offs so inverter won't be optimized away by synthesis
//`define INV_PRSRV(outb,in)                                          \
//`ifdef DC                                                           \
//     `LIB_INV_PRSRV(outb,in)                                        \
//`else                                                               \
//  assign outb = ~in ;     /* lintra s-35000, s-35006 */             \
//`endif          

//New macros for top level tie-offs
`define TIEOFF_0_PRSRV(out)                                        \
`ifdef DC                                                          \
   `LIB_TIEOFF_0_PRSRV(out)  /* lintra s-30516 */                  \
`else                                                              \
   assign out = {$bits(out){1'b0}};                                \
`endif                                                             

`define TIEOFF_1_PRSRV(out)                                        \
`ifdef DC                                                          \
   `LIB_TIEOFF_1_PRSRV(out) /* lintra s-30516 */                   \
`else                                                              \
   assign out = {$bits(out){1'b1}};                                \
`endif 








///============================================================================================
///
/// Flops and Drivers
///
///============================================================================================

// MSFF macros:
//
// The standard MSFF takes as its input both the gridclk and its counterpart clock enable. In real circuit
// implementation, these two signals ANDed together will give you your gated clock.
//
// If you create your own clock, (you are not using the MAKE_CLK_ENABLE() macro) then tie the clken off with 1'b1 as its
// input. Otherwise use the MAKE_CLK_ENABLE() macro and use gridclock as your clk input.
//
// If you are flopping an L phase signal, be sure to pass in ~gridclk as your clk and an L phase clken. The L phase
// clken should be created with the MAKE_CLK_ENABLE() macro, with all inputs of L phase.
//
`define MSFF(q,i,clock)                                     \
   always_ff @(posedge clock)                               \
      begin                                                 \
         q <= i;                                            \
      end                                                   \
/* lintra s-30500 */

`define MSFF_BLK(q,i,clock)                                 \
   logic [$bits(i)-1:0] \``dlyin_``q ;                      \
   assign  \``dlyin_``q = i;                                \
   always_ff @(posedge clock)                               \
      begin                                                 \
         q = \``dlyin_``q ;                                 \
      end                                                   \
/* lintra s-30500, s-31501, s-30531 */                      \

`define MSFF_P(q,i,clock)                                   \
   always_ff @(negedge clock)                               \
      begin                                                 \
         q <= i;                                            \
      end                                                   \
/* lintra s-30500 */

`define EN_MSFF(q,i,clock,enable)                           \
   always_ff @(posedge clock)                               \
      begin                                                 \
         if (enable) q <= i;                                \
       end                                                  \
/* lintra s-30500 */

`define RST_MSFF(q,i,clock,rst)                             \
   always_ff @(posedge clock)                               \
      begin                                                 \
         if (rst) q <= '0;                                  \
         else     q <=  i;                                  \
      end                                                   \
/* lintra s-30500 */


`define SET_MSFF(q,i,clock,set)                             \
   always_ff @(posedge clock)                               \
      begin                                                 \
         if (set) q <= {$bits(q){1'b1}};                    \
         else     q <=  i;                                  \
      end                                                   \
/* lintra s-30500 */                                        \


`define RST_MSFF_P(q,i,clock,rst)                           \
   always_ff @(negedge clock)                               \
      begin                                                 \
         if (rst) q <= '0;                                  \
         else     q <=  i;                                  \
      end

`define EN_RST_MSFF(q,i,clock,enable,rst)                   \
   always_ff @(posedge clock )                              \
      begin                                                 \
         if ( rst )         q <= '0 ;                       \
         else if ( enable ) q <= i ;                        \
      end                                                   \

/* lintra s-30500 */

`define EN_RST_MSFF_P(q,i,clock,enable,rst)                 \
   always_ff @(negedge clock )                              \
      begin                                                 \
         if ( rst )         q <= '0 ;                       \
         else if ( enable ) q <= i ;                        \
      end


`define EN_SET_MSFF(q,i,clock,enable,set)                   \
   always_ff @(posedge clock)                               \
      begin                                                 \
         if (set)         q <=  {$bits(q){1'b1}};           \
         else if (enable) q <=  i;                          \
      end                                                   \
/* lintra s-30500 */

`define ASYNC_RST_MSFF(q,i,clock,rst)                       \
wire \``q``_rst ;                                           \
assign \``q``_rst = rst ;                                   \
   always_ff @(posedge clock or posedge \``q``_rst )        \
      begin                                                 \
         if ( \``q``_rst )  q <= '0;                        \
         else      q <= i;                                  \
      end                                                   \
/* lintra s-30500 */

`define ASYNC_SET_MSFF(q,i,clock,set)                       \
   logic \``q``_set ;                                       \
   assign \``q``_set = set ;                                \
   always_ff @(posedge clock or posedge \``q``_set )        \
      begin                                                 \
         if (\``q``_set ) q <= {$bits(q){1'b1}};            \
         else                 q <= i;                       \
      end                                                   \
/* lintra s-30500, s-30531 */

`define ASYNC_RST_MSFF_P(q,i,clock,rst)                     \
   always_ff @(negedge clock or posedge rst)                \
      begin                                                 \
         if (rst)  q <=  '0;                                \
         else      q <=  i;                                 \
   end

/* lintra s-30500, s-30531 */

`define ASYNC_RSTD_MSFF(q,i,clock,rst,rstd)                 \
   always_ff @(posedge clock or posedge rst)                \
      begin                                                 \
         if (rst)  q <=  rstd;                              \
         else      q <=  i;                                 \
      end                                                   \
/* lintra s-30500 */

`define EN_ASYNC_RSTD_MSFF(q,i,clock,enable,rst,rstd)       \
   always_ff @(posedge clock or posedge rst)                \
      begin                                                 \
         if (rst)  q <= rstd;                               \
         else if (enable) q <= i;                           \
      end                                                   \

/* lintra s-30500, s-30531 */

`define ASYNC_SET_RST_MSFF(q,i,clock,set,rst)                \
   logic \``rst_``q ;                                        \
   logic \``set_``q ;                                        \
   assign \``rst_``q = rst ;                                 \
   assign \``set_``q = set ;                                 \
   always_ff @(posedge clock or posedge set or posedge rst ) \
      begin                                                  \
         if (rst)      q <=  {$bits(q){1'b0}};               \
         else if (set) q <=  {$bits(q){1'b1}};               \
         else                 q <= i;                        \
      end                                                   


/* lintra s-30500 */
`define EN_ASYNC_RST_MSFF(q,i,clock,enable,rst)               \
   logic [$bits(i)-1:0] \``dlyin_``q ;                        \
   logic \``dlyen_``q ;                                       \
   assign  \``dlyin_``q = i;                                  \
   assign  \``dlyen_``q = enable;                             \
   always_ff @(posedge clock or posedge rst)                  \
      begin                                                   \
         if (rst)     q <=  '0;                                \
         else if (\``dlyen_``q ) q <=  \``dlyin_``q ;          \
      end                                                     \



///============================================================================================
///           META STABLE 2 FLOP MACROS - REQUESTED BY Larry Thatcher for cJTAG IP support,
///                                                    Chris Tsay for South Cluster support
///============================================================================================
`define ASYNC_RST_2MSFF_META(q,i,clk,rstb)                     \
`ifdef DC                                                      \
  `LIB_ASYNC_RST_2MSFF_META(q,i,clk,rstb)                      \
`else                                                          \
  logic [$bits(i)-1:0] \``staged_``q ;                         \
  always_ff @(posedge clk or negedge rstb ) begin              \
    if ( ~rstb )       \``staged_``q <= '0;                    \
    else               \``staged_``q <=  i;                    \
  end                                                          \
  always_ff @(posedge clk or negedge rstb) begin               \
    if ( ~rstb )       q <= '0;                                \
    else               q <=  \``staged_``q ;                   \
  end                                                          \
`endif                                                         \
/* lintra s-30500 */

`define ASYNC_SET_2MSFF_META(q,i,clk,psb)                      \
`ifdef DC                                                      \
  `LIB_ASYNC_SET_2MSFF_META(q,i,clk,psb)                       \
`else                                                          \
  logic [$bits(i)-1:0] \``staged_``q ;                         \
  always_ff @(posedge clk or negedge psb ) begin               \
    if ( ~psb )        \``staged_``q <= '1;                    \
    else               \``staged_``q <=  i;                    \
  end                                                          \
  always_ff @(posedge clk or negedge psb) begin                \
    if ( ~psb )        q <= '1;                                \
    else               q <=  \``staged_``q ;                   \
  end                                                          \
`endif                                                         \
/* lintra s-30500 */

///============================================================================================
///           META STABLE FLOP MACRO 
///============================================================================================
//***** NEEDS TO BE UPDATED BASED ON OUTCOME OF LIBRARY REQUEST *****
`define MSFF_META(q,i,clock)                                   \
`ifdef DC                                                      \
     `LIB_SOC_MSFF_META(q,i,clock)                             \
`else                                                          \
 `ifdef MACRO_ATTRIBUTE                                        \
                                                               \
   `endif                                                      \
   always_ff @(posedge clock)                                  \
      begin                                                    \
         q <= i;                                               \
      end                                                      \
/* lintra s-30500 */                                           \
`endif

//***** NEEDS TO BE UPDATED BASED ON OUTCOME OF LIBRARY REQUEST *****
/* lintra s-30500 */


`define LATCH(q,i,clock)                                    \
   always_latch                                             \
      begin                                                 \
         if (clock) q <= i;                                 \
      end                                                   \
/* lintra s-30500 */

`define LATCH_P(q,i,clock)                                  \
   always_latch                                             \
      begin                                                 \
         if (~clock) q <=  i;                               \
      end                                                   

`define RST_LATCH(q,i,clock,rst)                            \
   always_latch                                             \
      begin                                                 \
         if (clock)                                         \
            if (rst) q <= '0;                               \
            else     q <=  i;                               \
      end                                                   \
/* lintra s-30500 */


`define ASYNC_SET_LATCH(q,i,clock,set)                      \
   always_latch                                             \
     begin                                                  \
         if (set)          q <= '1; /* lintra s-30529 */    \
           else if (clock) q <=  i;                         \
             end                                            \
/* lintra s-30500 */

`define ASYNC_RST_LATCH(q,i,clock,rst)                      \
   always_latch                                             \
      begin                                                 \
         if      (rst) q <= '0; /* lintra s-30529 */        \
         else if (clock) q <= i;                            \
      end /* lintra s-30500 */

`define ASYNC_RST_LATCH_BLK(q,i,clock,rst)                  \
   always_latch                                             \
      begin                                                 \
         if      (rst) q = '0; /* lintra s-30529 */        \
         else if (clock) q = i;                             \
      end /* lintra s-30500 */

`define EN_ASYNC_RST_LATCH(q,i,clock,enable,rst)            \
   always_latch                                             \
      begin                                                 \
         if      (rst)      q <= '0; /* lintra s-30529 */   \
         else if (clock & enable) q <=   i;                 \
      end /* lintra s-30500 */

/* lintra s-30500 */

`define ASYNC_RSTD_LATCH_P(q,i,clock,rst,rstd) `ASYNC_RSTD_LATCH(q,i,(~(clock)),rst,rstd)

`define ASYNC_RSTD_LATCH(q,i,clock,rst,rstd)                \
   always_latch                                             \
      begin                                                 \
         if      (rst) q <= rstd;                           \
         else if (clock) q <=  i;                           \
      end                                                   \



/* lintra s-30500 */

`define ASYNC_RST_SET(q,rst,set)                            \
  `RST_LATCH(q,set,(set|rst),rst)

/* lintra s-30500 */

// Commented out after meeting on 24 March 2011 --> used by MAKE_CLK_DIV2OR4
`define LATCH_P_DESKEW(q,i,clock)                           \
   always_latch                                             \
      begin                                                 \
         if (~clock) q <=  i;                               \
      end                                                   \
/* lintra s-50500 */

`define ASYNC_RST_MSFF_META(q,i,clk,rstb)                      \
`ifdef DC                                                      \
  `LIB_ASYNC_RST_MSFF_META(q,i,clk,rstb)                       \
`else                                                          \
                                                               \
  always_ff @(posedge clk or negedge rstb) begin               \
    if ( ~rstb )  q <= '0;                                     \
    else          q <=  i;                                     \
  end                                                          \
`endif                                                         \

// ----------------------------------
//  RESET DISTRIBUTION MACROS
// ----------------------------------
`define MAKE_RST_DIST(irstoutb, iusyncout, iclk, irstinb, iusyncin) \
    sync_rst_gen \``sync_rst_``irstoutb (                           \
         .rstoutb(irstoutb),                                        \
         .usyncout(iusyncout),                                      \
         .clk(iclk),                                                \
         .rstinb(irstinb),                                          \
         .usyncin(iusyncin)                                         \
   );                                                                  
/* lintra s-31500, s-33048, s-33049 */

module sync_rst_gen (rstoutb, usyncout, clk, rstinb, usyncin);
output logic rstoutb;
output logic usyncout;
input  logic clk;
input  logic rstinb;
input  logic usyncin;
      logic n_rstoutb;                                                        
      logic nin_rstoutb;                                                      
      `MSFF(usyncout, usyncin, clk)                                            
      assign n_rstoutb = (usyncout? rstinb : rstoutb);                     
      assign nin_rstoutb = ~rstinb;                                         
      `ASYNC_RST_MSFF(rstoutb, n_rstoutb, clk, nin_rstoutb)
endmodule 



///============================================================================================
///
/// IO Driver Macros
///
///============================================================================================
///
///
///   BUS TYPE MACRO                DESCRIPTION        UNDRIVEN VALUE* CONTENTION*
///  
///   TRI                         - Tri-State          'Z              Multiple Drivers

///   WAND                        - Wired-And          Weakpull 1      None 

///   WOR                         - Wired-Or           Weakpull 0      None 

///   *Semantics achieved only in conjunction with applicable, explict SUSTAIN, WEAKPULL, PRECHARGE, DRIVE macros
///    and relevant assertions
///
///   BUS DRIVER MACRO              DESCRIPTION
///
///   TRI_DRIVE     (Bus,En,Data) - Driver for busses of all Tri-State types
///   WAND_DRIVE    (Bus,En,Data) - WAND bus driver
///   WAND_WEAKPULL (Bus, En)     - WAND bus weak pull up
///   WOR_DRIVE     (Bus,En,Data) - WOR bus driver
///   WOR_WEAKPULL  (Bus, En)     - WOR bus weak pull down


// Commented out after meeting on 24 March 2011 -> dunit/results_dunitcte/gen/pinpull/pinpull.sv
`define NO_SYNTH_WAND_WEAKPULL(Bus,En)                                                                   \
  `ifdef EMULATION                                                                                       \
        assign (weak1, highz0)   Bus = {$bits(Bus){1'b1}};                                               \
  `else                                                                                                  \
        assign (weak1, highz0)   Bus = En ? {$bits(Bus){1'b1}} : {$bits(Bus){1'bz}};                     \
  `endif

// Commented out after meeting on 24 March 2011 -> dunit/results_dunitcte/gen/pinpull/pinpull.sv
`define NO_SYNTH_WAND_DRIVE(Bus,En,Data)                                                                 \
  `ifdef EMULATION                                                                                       \
        assign (strong0, highz1) Bus = En ? Data : {$bits(Bus){1'b1}};                                   \
  `else                                                                                                  \
        assign (strong0, highz1) Bus = En ? Data : {$bits(Bus){1'bz}};                                   \
  `endif

// Commented out after meeting on 24 March 2011 -> dunit/results_dunitcte/gen/pinpull/pinpull.sv
`define NO_SYNTH_WOR_WEAKPULL(Bus,En)                                                                    \
  `ifdef EMULATION                                                                                       \
        assign (weak0, highz1)   Bus = {$bits(Bus){1'b0}};                                               \
  `else                                                                                                  \
        assign (weak0, highz1)   Bus = En ? {$bits(Bus){1'b0}} : {$bits(Bus){1'bz}};                     \
  `endif

// Commented out after meeting on 24 March 2011 -> dunit/results_dunitcte/gen/pinpull/pinpull.sv
`define NO_SYNTH_WOR_DRIVE(Bus,En,Data)                                                                  \
  `ifdef EMULATION                                                                                       \
        assign (strong1, highz0) Bus = En ? Data : {$bits(Bus){1'b0}};                                   \
  `else                                                                                                  \
        assign (strong1, highz0) Bus = En ? Data : {$bits(Bus){1'bz}};                                   \
  `endif

// Commented out after meeting on 24 March 2011 --> used here: dunit/results_dunitcte/gen/pinpull/pinpull.sv
`define NO_SYNTH_WOR_TRI_DRIVE(Bus,En,Data) /* lintra s-50505 */                                         \
  `ifdef EMULATION                                                                                       \
        assign Bus = En ? Data : {$bits(Bus){1'b0}}; /* lintra s-23083 */                                \
  `else                                                                                                  \
        assign Bus = En ? Data : {$bits(Bus){1'bz}}; /* lintra s-23083 */                                \
  `endif



///============================================================================================
//Added by Sanjeev. Please review

`define SET_MSFF_BLK(q,i,clock,set)                                                                      \
   `ifdef MACRO_ATTRIBUTE                                                                                \
                                                                                                         \
   `endif                                                                                                \
   logic [$bits(i)-1:0] \``dlyin_``q ;                                                                   \
   logic \``dlyset_``q ;                                                                                 \
   assign  \``dlyin_``q = i;                                                                             \
   assign  \``dlyset_``q = set;                                                                          \
   always_ff @(posedge clock)                                                                            \
      begin                                                                                              \
         if ( \``dlyset_``q ) q = {$bits(q){1'b1}};                                                      \
         else     q =  \``dlyin_``q ;                                                                    \
      end    /* lintra s-30500, s-31501, s-30531 */
                                                      
`define EN_RSTD_MSFF(q,i,clock,enable,rst,rstd)             \
   `ifdef MACRO_ATTRIBUTE                                   \
                                                            \
     `endif                                                 \
   always_ff @(posedge clock)                               \
      begin                                                 \
         if (rst)          q <=  rstd;                      \
         else if (enable)  q <=  i;                         \
      end /* lintra s-30500 */   
                                                     
// Commented out after meeting on 24 March 2011
//`define TRI_DRIVE(Bus,En,Data) /* lintra s-30505 */         \
//  `ifdef FALCON                                             \
//        assign Bus = {$bits(Bus){1'b1}};                    \
//      `else                                                 \
//        assign Bus = En ? Data : {$bits(Bus){1'bz}};        \
//  `endif

`define MSFF_P_BLK(q,i,clock)                               \
   `ifdef MACRO_ATTRIBUTE                                   \
                                                            \
   `endif                                                   \
   logic [$bits(i)-1:0] \``dlyin_``q ;                      \
   assign  \``dlyin_``q = i;                                \
   always_ff @(negedge clock )                              \
      begin                                                 \
         q = \``dlyin_``q ;                                 \
      end /* lintra s-30500, s-30531 */

`define ASYNC_RST_MSFF_BLK(q,i,clock,rst)                   \
   `ifdef MACRO_ATTRIBUTE                                   \
                                                            \
   `endif                                                   \
   logic [$bits(i)-1:0] \``dlyin_``q ;                      \
   assign  \``dlyin_``q = i;                                \
   wire \``q``_rst ;                                        \
   assign \``q``_rst = rst ;                                \
   always_ff @(posedge clock or posedge \``q``_rst )        \
      begin                                                 \
         if ( \``q``_rst )  q = '0;                         \
         else      q =  \``dlyin_``q ;                      \
      end /* lintra s-30500, s-31501, s-30531 */

///=====================================================================
/// sVID Macros - Should be Review , Aviel
///======================================================================  

`define RSTD_MSFF(q,i,clock,rst,rstd)                 \
   always_ff @(posedge clock)                         \
      begin                                           \
         if (rst)  q <=  rstd;                        \
         else      q <= i;                            \
      end                                             \
/* lintra s-30500 */

`define RSTD_MSFF_P(q,i,clock,rst,rstd)               \
   always_ff @(negedge clock)                         \
      begin                                           \
         if (rst)  q <=  rstd;                        \
         else      q <=  i;                           \
      end                                             \
/* lintra s-30500 */

// `define RSTD_MSFF(q,i,clock,rst,rstd)                       \
// `ifdef SYNPLIFY_WA_COMPLEX_EVENT                            \
//    node \clock_``q ;                                        \
//    assign \clock_``q = clock ;                              \
//    always_ff @(posedge \clock_``q )                         \
//          if (rst) q <= rstd;                                \
//          else     q <=  i;                                  \
// `else                                                       \
// `ifdef SIM                                                  \
//    `ifdef MACRO_ATTRIBUTE                                   \
//                                                             \
//    `endif                                                   \
//    always_ff @(posedge clock)                               \
//       begin                                                 \
//          if (rst)                                           \
//             q <= rstd;                                      \
//          else                                               \
//             q <= i;                                         \
//       end                                                   \
// /* lintra s-30500 */                                        \
// `else                                                       \
//    node \``rst_``q ;                                        \
//    assign \``rst_``q = rst ;                                \
//    /* synopsys sync_set_reset `" \``rst_``q `" */           \
//    always_ff @(posedge  clock )                             \
//       begin                                                 \
//          if ( \``rst_``q )                                  \
//             q <= rstd;                                      \
//          else                                               \
//             q <= i;                                         \
//       end                                                   \
// `endif                                                      \
// `endif


`define SET_RST_MSFF(q,i,clock,set,rst)                       \
   logic \``rst_``q ;                                         \
   logic \``set_``q ;                                         \
   assign \``rst_``q = rst ;                                  \
   assign \``set_``q = set ;                                  \
   always_ff @(posedge clock )                                \
      begin                                                   \
         if (rst)      q <=  {$bits(q){1'b0}};                \
         else if (set) q <=  {$bits(q){1'b1}};                \
         else          q <=  i;                               \
      end                                                   


// We currently don't have such library cells.
//
// `define SET_RST_MSFF(q,i,clock,set,rst)                    \
// `ifdef SIM                                                 \
//    `ifdef MACRO_ATTRIBUTE                                  \
//                                                            \
//    `endif                                                  \
//    always_ff @(posedge clock)                              \
//       begin                                                \
//          if (rst)      q <= '0;                            \
//          else if (set) q <= '1;                            \
//          else          q <=  i;                            \
//       end                                                  \
// /* lintra s-30500 */                                       \
// `else                                                      \
//    node \``rst_``q ;                                       \
//    node \``set_``q ;                                       \
//    assign \``rst_``q = rst ;                               \
//    assign \``set_``q = set ;                               \
//    /* synopsys sync_set_reset `" \``rst_``q  , \``set_``q `" */ \
//    always_ff @(posedge clock )                             \
//       begin                                                \
//          if ( \``rst_``q )      q <= '0;                   \
//          else if ( \``set_``q ) q <= '1;                   \
//          else                 q <=  i;                     \
//       end                                                  \
// `endif



`define RST_SET_MSFF(q,i,clock,rst,set)                       \
   logic \``rst_``q ;                                         \
   logic \``set_``q ;                                         \
   assign \``rst_``q = rst ;                                  \
   assign \``set_``q = set ;                                  \
   always_ff @(posedge clock )                                \
      begin                                                   \
         if (set)        q <=  {$bits(q){1'b1}};              \
         else if (rst)   q <=  {$bits(q){1'b0}};              \
         else            q <=  i;                             \
      end                                                   




// `define RST_SET_MSFF(q,i,clock,rst,set)                      \
// `ifdef SIM                                                   \
//    `ifdef MACRO_ATTRIBUTE                                    \
//                                                              \
//    `endif                                                    \
//    always_ff @(posedge clock)                                \
//       begin                                                  \
//    `ifdef VAL4_OPTIMIZED                                     \
//        q <= (clock) ? ((set) ? '1 : ((rst) ? '0 : i)) : q;   \
//    `else                                                     \
//            if (set)      q <= '1;                            \
//            else if (rst) q <= '0;                            \
//            else          q <=  i;                            \
//    `endif                                                    \
//       end                                                    \
// `else                                                        \
// `ifdef INF                                                   \
//    node \rst_``q ;                                           \
//    node \set_``q ;                                           \
//    assign \rst_``q = (rst) ;                                 \
//    assign \set_``q = (set) ;                                 \
//    /* synopsys sync_set_reset `" \rst_``q  , \set_``q `" */  \
//    always_ff @(posedge clock )                               \
//       begin                                                  \
//          if ( \set_``q )      q <= {$bits(q){1'b1}};         \
//          else if ( \rst_``q ) q <= {$bits(q){1'b0}};         \
//          else                 q <=  i;                       \
//       end                                                    \
// `else                                                        \
//    localparam \w_``q = $bits(q);                             \
//    node [\w_``q -1:0] \qual_i_``q ;                          \
//    node [\w_``q -1:0] \ibit_``q ;                            \
//    yg0bfn00nn1d0 \ibbuf_``q <$typeof(q)> (.o(<(\ibit_``q )>),.a(<(i)>)); \
//    always_comb                                               \
//       if (set)   \qual_i_``q = {\w_``q  {1'b1}};             \
//       else                                                   \
//  if (rst) \qual_i_``q = {\w_``q  {1'b0}};                    \
//         else     \qual_i_``q = \ibit_``q ;                   \
//   /* synopsys keep_signal_name \``q  */                      \
//    `BASIC_FF \_reg``q <$typeof(q)> (.o(<(q)>),.clk(clock),.d(<(\qual_i_``q )>)); \
// `endif                                                       \
// `endif

///============================================================================================

/////////////////////////////////////////////////////////////////
// BEGIN - Multi-cycle path macros section
/////////////////////////////////////////////////////////////////


`define MCP(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
                                                                                                                                                                \
 `ifdef MCP_ON                                                                                                                                                  \
  logic signal_``macro_inst_name;                                                                                                                               \
  `ifndef SVA_OFF                                                                                                                                               \
  SVA_``macro_inst_name : `ASSERT_FORBIDDEN (signal_``macro_inst_name , 1'b0) `ERR_MSG (`"MCP stability condition violated for assertion SVA_``macro_inst_name as MCP_source_sig was not stable for phase_delay phases before it was sampled`") ; \
  `endif                                                                                                                                                        \
                                                                                                                                                                \
  generate                                                                                                                                                      \
    if ((`"clock_edges_aligned_at_destination`" == "ALIGNED") && ((`"sampling_edge_or_phase`" == "RISING") || (`"sampling_edge_or_phase`" == "LOW")))           \
      soc_multi_cycle #(.N($bits(MCP_source_sig)), .PHASE(phase_delay), .CLOCKS_ALIGNED(1), .RX_SAMPLED_AT_POSEDGE(1)) mcpinst_``macro_inst_name (.out(signal_``macro_inst_name), .source_sig({>>{MCP_source_sig}}), .rx_clk(MCP_rx_clk), .rx_enable(MCP_rx_enable), .count_clk(MCP_count_clk)); \
    else if ((`"clock_edges_aligned_at_destination`" == "ALIGNED") && ((`"sampling_edge_or_phase`" == "FALLING") || (`"sampling_edge_or_phase`" == "HIGH")))    \
      soc_multi_cycle #(.N($bits(MCP_source_sig)), .PHASE(phase_delay), .CLOCKS_ALIGNED(1), .RX_SAMPLED_AT_POSEDGE(0)) mcpinst_``macro_inst_name (.out(signal_``macro_inst_name), .source_sig({>>{MCP_source_sig}}), .rx_clk(MCP_rx_clk), .rx_enable(MCP_rx_enable), .count_clk(MCP_count_clk)); \
    else if ((`"clock_edges_aligned_at_destination`" == "NOT_ALIGNED") && ((`"sampling_edge_or_phase`" == "RISING") || (`"sampling_edge_or_phase`" == "LOW")))  \
      soc_multi_cycle #(.N($bits(MCP_source_sig)), .PHASE(phase_delay), .CLOCKS_ALIGNED(0), .RX_SAMPLED_AT_POSEDGE(1)) mcpinst_``macro_inst_name (.out(signal_``macro_inst_name), .source_sig({>>{MCP_source_sig}}), .rx_clk(MCP_rx_clk), .rx_enable(MCP_rx_enable), .count_clk(MCP_count_clk)); \
    else if ((`"clock_edges_aligned_at_destination`" == "NOT_ALIGNED") && ((`"sampling_edge_or_phase`" == "FALLING") || (`"sampling_edge_or_phase`" == "HIGH"))) \
      soc_multi_cycle #(.N($bits(MCP_source_sig)), .PHASE(phase_delay), .CLOCKS_ALIGNED(0), .RX_SAMPLED_AT_POSEDGE(0)) mcpinst_``macro_inst_name (.out(signal_``macro_inst_name), .source_sig({>>{MCP_source_sig}}), .rx_clk(MCP_rx_clk), .rx_enable(MCP_rx_enable), .count_clk(MCP_count_clk)); \
    else                                                                                                                                                        \
      non_existent_mcp_module bogus_mcp_instance();                                                                                                             \
  endgenerate                                                                                                                                                   \
`endif







/////////////////////////////////////////////////////////////////
// END - Multi-cycle path macros
/////////////////////////////////////////////////////////////////


  // FOR NORTHC
// New Sequential definations... Lint friendly

`define FLOP(_clk_,_rstB_,_in_,_out_) `RST_MSFF(_out_,_in_,_clk_,(~_rstB_))
`define FLOP_NORESET(_clk_,_in_,_out_) `MSFF(_out_,_in_,_clk_)

`define FLOP_ENABLED(_clk_,_rstB_,_en_,_in_,_out_) `EN_RST_MSFF(_out_,_in_,_clk_,_en_,(~_rstB_))
`define FLOP_SET(_clk_,_rstB_,_in_,_out_) `SET_MSFF(_out_,_in_,_clk_,(~_rstB_))
`define FLOP_ENABLED_SET(_clk_,_rstB_,_en_,_in_,_out_) `EN_SET_MSFF(_out_,_in_,_clk_,_en_,(~_rstB_))
   
// Commented out after meeting on 24 March 2011.
// `define MUX41(_sel_,_ina_,_inb_,_inc_,_ind_,_out_) assign _out_ = _sel_[1] ?  (_sel_[0] ? _ind_ : _inc_) : (_sel_[0] ? _inb_ : _ina_)
// `define MUX81(_sel_,_ina_,_inb_,_inc_,_ind_,_ine_,_inf_,_ing_,_inh_,_out_) assign _out_ = _sel_[2] ? (_sel_[1] ?  (_sel_[0] ? _inh_ : _ing_) : (_sel_[0] ? _inf_ : _ine_)) : (_sel_[1] ?  (_sel_[0] ? _ind_ : _inc_) : (_sel_[0] ? _inb_ : _ina_))   
// `define MUX161(_sel_,_ina_,_inb_,_inc_,_ind_,_ine_,_inf_,_ing_,_inh_,_ini_,_inj_,_ink_,_inl_,_inm_,_inn_,_ino_,_inp_,_out_) assign _out_ = _sel_[3] ? (_sel_[2] ? (_sel_[1] ?  (_sel_[0] ? _inp_ : _ino_) : (_sel_[0] ? _inn_ : _inm_)) : (_sel_[1] ?  (_sel_[0] ? _inl_ : _ink_) : (_sel_[0] ? _inj_ : _ini_))) : (_sel_[2] ? (_sel_[1] ?  (_sel_[0] ? _inh_ : _ing_) : (_sel_[0] ? _inf_ : _ine_)) : (_sel_[1] ?  (_sel_[0] ? _ind_ : _inc_) : (_sel_[0] ? _inb_ : _ina_)))  


  //                                84 2152 1
  //                                     15 2
  //                                     26 8
  //                                GG GGGG G
  //                                BB BBBB B  


 `define DATA_2_TO_1_MUX(dataout, datin1, datain2, muxselect)                                    \
   `ifdef MACRO_ATTRIBUTE                                                                        \
   `endif                                                                                        \
   assign dataout = ((datin1&({$bits(dataout){muxselect}})) | (datain2&{$bits(dataout){~muxselect}})); \

  

`endif //  `ifndef SOC_MACROS_VH
  


/*************************************************************************************************************************
*
*    MACROS NOT BEING USED BY ANYONE - COMMENTED OUT - PLS CNCT RAM M KRISHNAMURTHY FOR ANY ISSUES
*
**************************************************************************************************************************/     

//
//
///* lintra s-30500 */
//
//`define NO_SYNTH_ASYNC_RST_MSFF_BLK(q,i,clock,rst)                   \
//   logic [$bits(i)-1:0] \``dlyin_``q ;                        \
//   assign  \``dlyin_``q = i;                                \
//   always_ff @(posedge clock or posedge rst)                \
//      begin                                                 \
//         if (rst)  q =  '0;                                  \
//         else      q =  \``dlyin_``q ;                        \
//      end                                                   \
//
//
//
//`define NO_SYNTH_ASYNC_RST_MSFF_P_BLK(q,i,clock,rst)                 \
//   logic [$bits(i)-1:0] \``dlyin_``q ;                        \
//   assign  \``dlyin_``q = i;                                \
//   always_ff @(negedge clock or posedge rst)                \
//      begin                                                 \
//         if (rst)  q =  '0;                                  \
//         else      q =  \``dlyin_``q ;                        \
//      end                                                   \
//
//
///* lintra s-30500 */
//
//`define NO_SYNTH_EN_ASYNC_RST_MSFF_BLK(q,i,clock,enable,rst)         \
//   logic [$bits(i)-1:0] \``dlyin_``q ;                        \
//   logic \``dlyen_``q ;                                       \
//   assign  \``dlyin_``q = i;                                \
//   assign  \``dlyen_``q = enable;                           \
//   always_ff @(posedge clock or posedge rst)                \
//      begin                                                 \
//         if (rst)     q =  '0;                               \
//         else if (\``dlyen_``q ) q =  \``dlyin_``q ;             \
//      end                                                   \
//
//
//`define ASYNC_RST_SET_B(q_b,rst,set)                          \
//   always_latch                                               \
//      begin                                                   \
//         if (set | rst)                                       \
//            if (rst) q_b =  '1; /* lintra s-30529, s-30531  */  \
//            else     q_b = '0;                                \
//      end                                                     \
//
//
//`define NO_SYNTH_TRI_DRIVE(Bus,En,Data) /* lintra s-30505 */              \
//  `ifdef EMULATION                                                          \
//        assign Bus = {$bits(Bus){1'b1}}; \
//  `else                                                                  \
//        assign Bus = En ? Data : {$bits(Bus){1'bz}}; \
//  `endif
//
//
//
//`define NO_SYNTH_WAND_TRI_DRIVE(Bus,En,Data) /* lintra s-30505 */          \
//  `ifdef EMULATION                                                          \
//        assign Bus = En ? Data : {$bits(Bus){1'b1}}; \
//  `else                                                                  \
//        assign Bus = En ? Data : {$bits(Bus){1'bz}}; \
//  `endif
//
//
//
//
//
//`define MCP_BNL     `BNL
//`define MCP_PUNIT   `PUNIT
//`define MCP_CCK     `CCK
//`define MCP_DUNIT   `DUNIT
//`define MCP_NORTHC  `NORTHC
//`define MCP_MUNIT   `MUNIT
//`define MCP_HUNIT   `HUNIT
//`define MCP_AUNIT   `AUNIT
//`define MCP_BUNIT   `BUNIT
//`define MCP_CUNIT   `CUNIT
//`define MCP_BLAUNCH_PATH  `BLAUNCH_PATH
//`define MCP_BRAM_PATH     `BRAM_PATH
//`define MCP_DISP_2D `DISP_2D
//`define MCP_GVD     `GVD
//`define MCP_GFX     `GFX
//`define MCP_VED     `VED
//`define MCP_VEC     `VEC
//`define MCP_FUS     `FUS
//`define MCP_DMIC    `DMIC
//
//
//
//
//`define MCP_LNCGFX(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
//\
//`ifdef LNCGFX \
//`MCP(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
//`else \
//`MCP_LNCFC(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
//`endif 
//
//
//`define MCP_LNCBFM(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
//\
//`ifdef LNCBFM \
//`MCP(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
//`else \
//`MCP_LNCGFX(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
//`endif
//
// `define MUX21(_sel_,_ina_,_inb_,_out_) assign _out_ = (_sel_ ? _inb_ : _ina_)
//
//`define FLOP_NORESET_NODELAY(_clk_,_in_,_out_) `MSFF(_out_,_in_,_clk_)
//
//`define FLOP_NEGEDGE(_clk_,_rstB_,_in_,_out_) `RST_MSFF_P(_out_,_in_,_clk_,(~_rstB_))
//`define FLOP_NEGEDGE_ENABLED(_clk_,_rstB_,_en_,_in_,_out_) `EN_RST_MSFF_P(_out_,_in_,_clk_,_en_,(~_rstB_))
//
//`define FLOP_NEGEDGE_SET(_clk_,_rstB_,_in_,_out_) `SET_MSFF_P(_out_,_in_,_clk_,(~_rstB_))
//`define FLOP_NEGEDGE_ENABLED_SET(_clk_,_rstB_,_en_,_in_,_out_) `EN_SET_MSFF_P(_out_,_in_,_clk_,_en_,(~_rstB_))

/*************************************************************************************************************************
*
*    MACROS NOT BEING USED BY ANYONE - COMMENTED OUT - PLS CNCT RAM M KRISHNAMURTHY FOR ANY ISSUES 2nD LEVEL CLEANUP
*
**************************************************************************************************************************/     

//`define ASYNC_FLOP(_clk_,_rstB_,_in_,_out_) `ASYNC_RST_MSFF(_out_,_in_,_clk_,(~_rstB_))
//`define ASYNC_FLOP_SET(_clk_,_rstB_,_in_,_out_) `ASYNC_SET_MSFF(_out_,_in_,_clk_,(~_rstB_))               \
//
//`define ASYNC_RST_MSFF_META(q,i,clk,rstb)                      \
//`ifdef DC                                                      \
//  `LIB_ASYNC_RST_MSFF_META(q,i,clk,rstb)                       \
//`else                                                          \
//                                                               \
//  always_ff @(posedge clk or negedge rstb) begin               \
//    if ( ~rstb )  q <= '0;                                     \
//    else          q <=  i;                                     \
//  end                                                          \
//`endif                                                         \
//
//// New BUFFER for 1ns of delay ***** ONLY FOR USE ON UNGATED SUPPLIES (VNN OR VNNAON)
//`define BUF_1NS_DELAY_UNGATED(out,in,vcc_in)                      \
//`ifdef DC                                                         \
//     `LIB_BUF_1NS_DELAY_UNGATED(out,in,vcc_in)                    \
//`else                                                             \
//  assign out = in ;     /* lintra s-35000, s-35006 */              \
//`endif         
//
//
//  //                              3333 3322 2222 2222 1111 1111
//  //                              5432 1098 7654 3210 9876 5432
// `define BUNIT_REAL_BANK_MASK 24'b0000_0001_0000_0000_0100_1111
// `define BUNIT_REAL_ROW_MASK  24'b0000_1111_1111_1111_1111_1110
// `define BUNIT_REAL_RANK_MASK 24'b0001_1110_0000_0000_0000_0000  
//
//

//  
// `define FUNCTIONL_ADDRESS    24'b0011_1110_0000_0000_0000_0000
//
///* lintra s-30500 */
//
////Same functionality as regular latch, but adding DE-SKEW to the name
////so that it is clear whenever this latch is instantiated it is intended to be 
////redundant to reduce mindelay problems between high-skew sequentials
//`define LATCH_DESKEW(q,i,clock)                             \
//   always_latch                                             \
//      begin                                                 \
//         if (clock) q <=  i;                                 \
//      end                                                   \
//
//
//`define ASYNC_RST_MSFFD(q,i,clock,rst)                       \
//wire \``q``_rst ;                                             \
//assign \``q``_rst = rst ;                                      \
//   always_ff @(posedge clock or posedge \``q``_rst )           \
//      begin                                                 \
//         if ( \``q``_rst )  q <=  '0;                      \
//         else      q <=  i;                                 \
//      end                                                   \
//
//`define ASYNC_RSTB_MSFF_HF_NONSCAN(q,i,clock,rstb)                      \
//  logic [$bits(q)-1:0] \``q``_nonscan ;                                 \
//  assign q = \``q``_nonscan ;                                           \
//`ifdef DC                                                               \
//   `LIB_ASYNC_RSTB_MSFF_HF_NONSCAN(q,i,clock,rstb)                      \
//`else                                                                   \
//   wire \``q``_rstb ;                                                   \
//   assign \``q``_rstb = rstb ;                                          \
//   always_ff @(posedge clock or negedge \``q``_rstb )                   \
//      begin                                                             \
//         if (~(\``q``_rstb ))  \``q``_nonscan <= '0;                    \
//         else      \``q``_nonscan <=  i;                                \
//      end                                                               \
//`endif
//
////============================================================================================
////
////  6 Bit Comparator
////
////============================================================================================
//`define COMPARATOR_6_BIT(out, in1, in2)                       \
//compare_6_bit \``compare_6_bit_``out (                        \
//                                  .iout(out),                 \
//                                  .iin1(in1),                 \
//                                  .iin2(in2)                  \
//                                 ); 
//
//module compare_6_bit(iout, iin1, iin2);
//output logic iout;
//input logic [5:0] iin1;
//input logic [5:0] iin2;
//`ifdef DC
//   `LIB_compare_6_bit(iout, iin1, iin2)
//`else 
//   assign iout = (iin1 == iin2);
//`endif        
//endmodule
//    
//`define LATCH_NEGEDGE(_le_,_in_,_out_) `LATCH_PD(_out_,_in_,_le_)
//
//`define LATCH_P_HF_NONSCAN(q,i,clock)                       \
//  logic [$bits(q)-1:0] \``q``_nonscan ;                     \
//  assign q = \``q``_nonscan ;                               \
//`ifdef DC                                                   \
//   `LIB_LATCH_P_HF_NONSCAN(q,i,clock)                       \
//`else                                                       \
//   always_latch                                             \
//      begin                                                 \
//         if (~clock) \``q``_nonscan <= i;                   \
//      end                                                   \
//`endif
//
///* lintra s-50500 */
//
//
//`define LATCH_PD(q,i,clock)                                  \
//   always_latch                                             \
//      begin                                                 \
//         if (~clock) q <= i;                                \
//      end                                                   \
//
///* lintra s-50500 */
//
////Creating a MSFF_NONSCAN to allow users to instantiate a flop which won't be added to the scan chain
////Note that in DC mode the library module creates an instance name integration can key off
////of as well as appending _nonscan to the output signal name. Both of which should ensure the
////cell is kept and not swapped out for a scan version.
//`define MSFF_NONSCAN(q,i,clock)                              \
//  logic [$bits(q)-1:0] \``q``_nonscan ;                      \
//  assign q = \``q``_nonscan ;                                \
//                                                             \
//  `ifdef DC                                                  \
//    `LIB_MSFF_NONSCAN(q,i,clock)                \
//  `else                                                      \
//    always_ff @(posedge clock)                               \
//      begin                                                  \
//         \``q``_nonscan <= i;                                \
//      end                                                    \
//  `endif
//
//// Data Mux for timing critical signals
//
//`define MUX_2TO1_HF(out,in1,in2,sel)                       \
//`ifdef DC                                                  \
//   `LIB_MUX_2TO1_HF(out,in1,in2,sel)                       \
//`else                                                      \
//   assign out = (in1 & sel) | (in2 & ~sel);                \
//`endif  
//
//`define MUX_2TO1_INV_HF(out,in1,in2,sel)                       \
//`ifdef DC                                                  \
//   `LIB_MUX_2TO1_INV_HF(out,in1,in2,sel)                       \
//`else                                                      \
//   assign out = ~((in1 & sel) | (in2 & ~sel));                \
//`endif        
//
//
//// Data Mux using NAND-NAND gates for timing critical signals
//`define NAND_3TO1MUX(iout,iin1,iin2,iin3,isel1,isel2,isel3)    \
//nand_3to1_mux \``nand_mux_``iout (                             \
//                                  .out(iout),                  \
//                                  .in1(iin1),                  \
//                                  .in2(iin2),                  \
//                                  .in3(iin3),                  \
//                                  .sel1(isel1),                \
//                                  .sel2(isel2),                \
//                                  .sel3(isel3)                 \
//                                 ); 
//
//module nand_3to1_mux(out,in1,in2,in3,sel1,sel2,sel3);
//output logic out;
//input logic in1;
//input logic in2;
//input logic in3;
//input logic sel1;
//input logic sel2;
//input logic sel3;
//`ifdef DC
//   `LIB_NAND_3TO1MUX(out,in1,in2,in3,sel1,sel2,sel3) 
//`else 
//  always_comb begin
//    casex({ sel1, 
//            sel2,
//            sel3 })
//      3'b100  : out = in1;
//      3'b010  : out = in2;
//      3'b001  : out = in3;
//      default : out = 1'b0;
//    endcase
//  end
//`endif        
//endmodule
//
//  `define OUTREG logic
//
//`define MCP_LNCFC(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
//\
//`ifdef LNCFC \
//`MCP(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
//`endif

