// Text_Tag % Vendor Intel % Product c73p4rfshdxrom % Techno P1273.1 % Tag_Spec 1.0 % ECCN US_3E002 % Signature ca61518dea37e392800a93a2fc42eef8f4fb4bc2 % Version r1.0.0_m1.18 % _View_Id sv % Date_Time 20160303_050304 
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
//     File/Block                             : soc_clock_macros.sv
//     Design Style [rls|rf|ssa_fuse|sdp|
//                   custom|hier|rls_hier]    : rls
//     Circuit Style [non_rfs|rfs|ssa|fuse|
//                    IO|ROM|none]            : none
//     Common_lib (for custom blocks only)    : none  
//     Library (must be same as module name)  : soc_clock_macros
//     Unit [unit id or shared]               : shared
//     Complex [North, South, CPU]            : North
//     Bizgroup [LCP|SEG|ULMD]                : ULMD
//
// Design Unit Owner :  roy.reyes@intel.com
// Primary Contact   :  roy.reyes@intel.com
// 
// MOAD End
//
//=============================================================================
//
// Description:
//   <Enter Description Here>
//
//=============================================================================
`ifndef SOC_CLOCK_MACROS_VH
`define SOC_CLOCK_MACROS_VH

`include "bxt_macro_tech_map.vh"
`include "soc_macros.sv"

//`define MAKE_CLK_DIV2_RESET(ckdiv2rout,ckdiv2rin,ckdiv2clkin,ckdiv2resetin)       \
`define CLK_FF(ckdiv2rout,ckdiv2rin,ckdiv2clkin,ckdiv2resetin)                      \
clockdivffreset \``clockdivffreset_``ckdiv2rout (                                   \
                                               .ffoutreset(ckdiv2rout),             \
                                               .ffinreset(ckdiv2rin),               \
                                               .clockinreset(ckdiv2clkin),          \
                                               .resetckdivff(ckdiv2resetin)         \
                                              );

`define CLK_FF_RESETB(ckdiv2rout,ckdiv2rin,ckdiv2clkin,ckdiv2resetinb)                      \
clockdivffresetb \``clockdivffresetb_``ckdiv2rout (                                   \
                                               .ffoutreset(ckdiv2rout),             \
                                               .ffinreset(ckdiv2rin),               \
                                               .clockinreset(ckdiv2clkin),          \
                                               .resetckdivffb(ckdiv2resetinb)         \
                                              );





`define MAKE_CLK_DIV2_RESET(ckdiv2rout,ckdiv2rin,ckdiv2clkin,ckdiv2resetin)                      \
clockdivffreset \``clockdivffreset_``ckdiv2rout (                                   \
                                               .ffoutreset(ckdiv2rout),             \
                                               .ffinreset(ckdiv2rin),               \
                                               .clockinreset(ckdiv2clkin),          \
                                               .resetckdivff(ckdiv2resetin)         \
                                              );


                                              
//module clockdivffreset (ffoutreset, ffinreset, clockinreset,resetckdivff);    
//output ffoutreset;
//input ffinreset;
//input clockinreset;
//input resetckdivff;
//reg ffoutreset;
//wire ffinreset, clockinreset, resetckdivff;   
//reg  ffin_inv;
//wire set; 
//`ifdef DC 
//     `LIB_clockdivffreset(ffoutreset, ffinreset, clockinreset,resetckdivff) --- fixed FEV issue
//     `LIB_clockdivffreset(ffoutreset, ~ffinreset, clockinreset,resetckdivff) 
//`else 
//always @(posedge (set) or posedge clockinreset)
//begin
//  if (set)
//    ffin_inv = 1'b1; /* lintra s-60028 */
//  else
//    ffin_inv = (~ffinreset); /* lintra s-60028 */
//end
//assign set = ~resetckdivff;
//assign ffoutreset = ~ffin_inv;
//`endif
//endmodule

// This was the previous behavioural model - changed on request from Chad
// Bradley to make it FEV equivalent to the B12 Library cell

module clockdivffreset (ffoutreset, ffinreset, clockinreset,resetckdivff);    
output ffoutreset;
input ffinreset;
input clockinreset;
input resetckdivff;
reg ffoutreset;
wire ffinreset, ffinresetb, clockinreset, resetckdivff;   
wire ffin_inv;
`ifdef DC 
     assign ffinresetb = ~ffinreset;
     `LIB_clockdivffreset(ffoutreset, ffinresetb, clockinreset,resetckdivff) 
`else 
always @(negedge (resetckdivff) or posedge clockinreset)
begin
  if (~(resetckdivff))
    ffoutreset = 1'b0; /* lintra s-60028 */
  else
    ffoutreset = (ffinreset); /* lintra s-60028 */
end
`endif
endmodule

module clockdivffresetb (ffoutreset, ffinreset, clockinreset,resetckdivffb);
output ffoutreset;
input ffinreset;
input clockinreset;
input resetckdivffb;
reg ffoutreset;
wire ffinreset, ffinresetb, clockinreset, resetckdivffb, resetckdivff;
wire ffin_inv;
`ifdef DC
     assign ffinresetb = ~ffinreset;
     assign resetckdivff = ~resetckdivffb;
     `LIB_clockdivffreset(ffoutreset, ffinresetb, clockinreset,resetckdivff)
`else 
always @(posedge (resetckdivffb) or posedge clockinreset)
begin
  if (resetckdivffb)
    ffoutreset = 1'b0; /* lintra s-60028 */
  else
    ffoutreset = (ffinreset); /* lintra s-60028 */
end
`endif
endmodule


module CLK_NAND_3TO1_MUX(out,in1,in2,in3,sel1,sel2,sel3);
output logic out;
input logic in1;
input logic in2;
input logic in3;
input logic sel1;
input logic sel2;
input logic sel3;
`ifdef DC
   `LIB_CLK_NAND_3TO1MUX(out,in1,in2,in3,sel1,sel2,sel3) 
`else 
  always_comb begin
    casex({ sel1, 
            sel2,
            sel3 })
      3'b100  : out = in1;
      3'b010  : out = in2;
      3'b001  : out = in3;
      default : out = 1'b0;
    endcase
  end
`endif        
endmodule

// gclatchen clock gate macro with disable
`define MAKE_CLK_GCLATCHEN(gcenclkout,gcenin,gctein,gcclrbin,gcckin)    \
clklocgclatchen \``clklocgclatchen_``gcenclkout  (                                   \
                                               .gcenclkoutx(gcenclkout),               \
                                               .gceninx(gcenin),                       \
                                               .gcteinx(gctein),                       \
                                               .gcclrbinx(gcclrbin),                   \
                                               .gcckinx(gcckin)                        \
                                             );

module clklocgclatchen (gcenclkoutx, gceninx, gcteinx, gcclrbinx, gcckinx);
input gceninx;
input gcteinx;
input gcclrbinx;
input gcckinx;
output gcenclkoutx;

`ifdef DC
  `LIB_GCLATCHEN(gcenclkoutx,gceninx,gcteinx,gcclrbinx,gcckinx)                   
`else                                                                        
reg lq;                                                                      
                                                                             
always_latch                                                                 
begin : gclatchen0_internal_latches                                          
                                                                             
  if (( ~gcckinx) == 1'b1) lq <= gceninx;                                      
                                                                             
end // begin: gclatchen0_internal_latches                                    
                                                                             
assign gcenclkoutx = gcclrbinx & gcckinx & (gcteinx | lq);                       
`endif                                                                       
endmodule


//CLK Inverter macro added on 10/13/10 as per request of Dharshan Kobla. PBIST
//in south complex requires it.
`define MAKE_CLK_INV(ckinvout,ckinvin)             \
clkinv \``clkinv_``ckinvout (                        \
                           .clkout (ckinvout),     \
                           .clkin (ckinvin)        \
                          );

// clock inverter module
module clkinv (clkout,clkin);
output clkout;
input clkin;
wire clkout,clkin;
`ifdef DC
     `LIB_clkinv(clkout,clkin)
`else
assign clkout = ~clkin ;
`endif
endmodule

//equal rise and flal time for two input clks


`define MAKE_CLKNOR(clkout,clkin1,clkin2)                    \
clknor \``clknor_``clkout  (                                     \
                          .ckoout (clkout),                     \
                          .ckoin1 (clkin1),                     \
                          .ckoin2 (clkin2)                      \
                         );

module clknor (ckoout, ckoin1,ckoin2);
output ckoout;
input ckoin1;
input ckoin2;
wire ckoout,ckoin1,ckoin2;

`ifdef DC
     `LIB_clknor(ckoout, ckoin1,ckoin2)
`else
assign ckoout = (~(ckoin1|ckoin2));
`endif
endmodule




`define MAKE_CLK_DIV4_RESET(ckdiv4rout,ckdiv4rin,ckdiv4resetin)                 \
clockdiv4ffreset \``clockdiv4ffreset_``ckdiv4rout (                             \
                                               .clk_out(ckdiv4rout),         	\
                                               .clk_in(ckdiv4rin),              \
                                               .reset_in(ckdiv4resetin)         \
                                              );




`define CLK_GATE(o, clk, a)                                                                 \
 soc_rbe_clk \``soc_rbe_clk_``o (                                                           \
                                  .ckrcbxpn  (o),                                           \
                                  .ckgridxpn (clk),                                         \
                                  .latrcben  (a)                                            \
                                );

`define CLK_GATE_W_OVERRIDE(o, clk, pwrgate, override)                                      \
 clk_gate_kin \``clk_gate_kin_``o (                                                         \
                                  .ckrcbxpn1  (o),                                          \
                                  .ckgridxpn1 (clk),                                        \
                                  .latrcben1  (pwrgate),                                    \
                                  .testen1    (override)                                    \
                                );

`define CLKAND(outclk,inclk,enable)                                                         \
`ifdef DC                                                                                   \
      `LIB_SOC_CLKAND(outclk,inclk,enable)                                                  \
`else                                                                                       \
   `ifdef MACRO_ATTRIBUTE                                                                   \
                                                                                            \
   `endif                                                                                   \
   assign outclk = inclk & enable; /* lintra s-30004, s-31500 */                            \
`endif 

module clk_and(input logic a,b, output logic o);
`ifdef DC
  `LIB_SOC_CLKAND(o,a,b)
`else
  assign o = a & b;
`endif
endmodule

// Commented out after meeting on 24 March 2011
//// Macro for MODQ simulation queue for clock tree in bus cluster
//`define CLKANDMODQ(outclk, inclk1, inclk0)                                                  \
//   soc_clkandmodq \``clkandmodq_``outclk ( /* lintra s-32002 */                             \
//      .outclkm (outclk),                                                                    \
//      .inclk1m (inclk1),                                                                    \
//      .inclk0m (inclk0)                                                                     \
//   );
//
//
//
//module soc_clkandmodq (outclkm,
//                   inclk1m,
//                   inclk0m);
//
//output outclkm;
//input inclk1m;
//input inclk0m;
//
//wire outclkm, inclk1m, inclk0m;
//
//assign outclkm = inclk1m & inclk0m;
//
//
//endmodule // soc_clkandmodq

// Clock buffer for "clocks in the datapath".  Usage of this macro requires a waiver.
`define CLKAND_DP(outclk,inclk, enable)                                                     \
`ifdef MACRO_ATTRIBUTE                                                                      \
                                                                                            \
`endif                                                                                      \
   always_comb outclk <= inclk & enable; /* lintra s-30003, s-31500, s-31503 */             \

//wire outclk``_tmp;  mnigri, removed from inside the macro, cause problem when outclk is of the form blabla[4] then adding _tmp is problematic, fails in DC
// its a MF macro technology !!!!  


// New clock buffer macro

`define CLKBF(clkbufout,clkbufin)                                                           \
`ifdef DC                                                                                   \
     `LIB_CLKBF_SOC(clkbufout,clkbufin)                                                     \
 `else                                                                                      \
  `ifdef MACRO_ATTRIBUTE                                                                    \
                                                                                            \
   `endif                                                                                   \
     assign clkbufout =  (~(~(clkbufin)));                                                  \
 `endif


`define CLKINV(clkinvout,clkinvin)                                                          \
`ifdef DC                                                                                   \
    `LIB_CLKINV_SOC(clkinvout,clkinvin)                                                     \
 `else                                                                                      \
  `ifdef MACRO_ATTRIBUTE                                                                    \
                                                                                            \
   `endif                                                                                   \
     assign clkinvout =  (~(clkinvin));                                                     \
 `endif


`define CLK_NAND(o,ck1,ck2)                                                                 \
`ifdef DC                                                                                   \
     `LIB_clknan(o,ck1,ck2)                                                                 \
`else                                                                                       \
  assign o = ~(ck1 & ck2);                                                                  \
`endif                                                                                      \


`define CLK_NAND_EN(o,ck,en)                                                                \
`ifdef DC                                                                                   \
     `LIB_clknanen(o,ck,en)                                                                 \
`else                                                                                       \
  assign o = ~(ck & en);                                                                    \
`endif                                                                                      \

`define CLK_NOR(o,ck1,ck2)                                                                  \
`ifdef DC                                                                                   \
     `LIB_clknor(o,ck1,ck2)                                                                 \
`else                                                                                       \
  assign o = ~(ck1 | ck2);                                                                  \
`endif                                                                                      \

`define CLK_AND_EN(o,ck,en)                                                                 \
`ifdef DC                                                                                   \
     `LIB_clkanden(o,ck,en)                                                                 \
`else                                                                                       \
  assign o = (ck & en);                                                                     \
`endif                                                                                      \

//needed for BSCAN that requires to map a ctech macro  AND gate for non-clock signals, they are currently using a clk AND that is giving us timing problems because they are data signals

`define DATAAND(outd,ind1,ind2)                                                             \
`ifdef DC                                                                                   \
      `LIB_SOC_NONCLKAND(outd,ind1,ind2)                                                    \
`else                                                                                       \
   `ifdef MACRO_ATTRIBUTE                                                                   \
   `endif                                                                                   \
   assign outd = ind1 & ind2; /* lintra s-30004, s-31500 */                                 \
`endif


 `define MAKE_CLK_2TO1MUX(clkmuxout,clkmuxin1,clkmuxin2,clkmuxselect)                       \
 clk2to1mux \``clk2to1mux_``clkmuxout (                                                     \
                                     .ckmuxout (clkmuxout),                                 \
                                     .ckin1    (clkmuxin1),                                 \
                                     .ckin2    (clkmuxin2),                                 \
                                     .muxselect(clkmuxselect)                               \
                                    );

 
module clk2to1mux (ckmuxout,ckin1,ckin2,muxselect);
output ckmuxout;
input ckin1;
input ckin2;
input muxselect;
wire ckmuxout,ckin1,ckin2,muxselect;
`ifdef DC  
     `LIB_clk2to1mux(ckmuxout,ckin2,ckin1,muxselect) 
`else    
 assign ckmuxout = ((ckin1&~(muxselect)) | (ckin2&muxselect));
`endif
endmodule

 `define MAKE_DATA_2TO1MUX(clkmuxout,clkmuxin1,clkmuxin2,clkmuxselect)                 \
 data2to1mux \``data2to1mux_``out (                                                    \
                                     .out (clkmuxout),                                 \
                                     .in1 (clkmuxin1),                                 \
                                     .in2 (clkmuxin2),                                 \
                                     .sel (clkmuxselect)                               \
                                    );

module data2to1mux (out,in1,in2,sel);
output out;
input in1;
input in2;
input sel;
wire out,in1,in2,sel;
`ifdef DC
     `LIB_MUX_2TO1_HF(out,in1,in2,sel)
`else
  assign out = ((in1 & sel) | (in2 & ~sel));
`endif
endmodule


`define MAKE_CLK_DELAY16(clkd16out,clkd16clkin,clkd16in0,clkd16in1,clkd16in2,clkd16in3,clkd16in4,clkd16in5,clkd16in6,clkd16in7,clkd16in8,clkd16in9,clkd16in10,clkd16in11,clkd16in12,clkd16in13,clkd16in14)                                   \
clk16delay \``clk16delay_``clkd16out (                                                      \
                                    .clk16delayout (clkd16out),                             \
                                    .clk16delayin (clkd16clkin),                            \
                                    .clk16in0 (clkd16in0),                                  \
                                    .clk16in1 (clkd16in1),                                  \
                                    .clk16in2 (clkd16in2),                                  \
                                    .clk16in3 (clkd16in3),                                  \
                                    .clk16in4 (clkd16in4),                                  \
                                    .clk16in5 (clkd16in5),                                  \
                                    .clk16in6 (clkd16in6),                                  \
                                    .clk16in7 (clkd16in7),                                  \
                                    .clk16in8 (clkd16in8),                                  \
                                    .clk16in9 (clkd16in9),                                  \
                                    .clk16in10 (clkd16in10),                                \
                                    .clk16in11 (clkd16in11),                                \
                                    .clk16in12 (clkd16in12),                                \
                                    .clk16in13 (clkd16in13),                                \
                                    .clk16in14 (clkd16in14)                                 \
                                  );

// Adjustable delay elements macros
module clk16delay (clk16delayout,clk16delayin,clk16in0,clk16in1,clk16in2,clk16in3,clk16in4,clk16in5,clk16in6,clk16in7,clk16in8,clk16in9,clk16in10,clk16in11,clk16in12,clk16in13,clk16in14);
output clk16delayout;
input clk16delayin;
input clk16in0;
input clk16in1;
input clk16in2;
input clk16in3;
input clk16in4;
input clk16in5;
input clk16in6;
input clk16in7;
input clk16in8;
input clk16in9;
input clk16in10;
input clk16in11;
input clk16in12;
input clk16in13;
input clk16in14;
wire clk16delayout,clk16delayin,clk16in0,clk16in1,clk16in2,clk16in3,clk16in4,clk16in5,clk16in6,clk16in7,clk16in8,clk16in9,clk16in10,clk16in11,clk16in12,clk16in13,clk16in14;
`ifdef DC
     `LIB_clk16delay(clk16delayout,clk16delayin,clk16in0,clk16in1,clk16in2,clk16in3,clk16in4,clk16in5,clk16in6,clk16in7,clk16in8,clk16in9,clk16in10,clk16in11,clk16in12,clk16in13,clk16in14) 
 `else
assign  clk16delayout = clk16delayin;
`endif
endmodule                                  

//`define MAKE_CLK_
// clkdiv2 \``clk_div2_``cknameout (                                   \
//                                .div2cknameout (cknameout),          \
//                                .div2ipinckin (ipinckin),            \
//                                .div2usync (usync)                   \
//                               );

// creating FF module to be used by clock macros below
module clockdivff (ffout, ffin, clockin);    
output ffout;
input ffin;
input clockin;
reg ffout;
wire ffin, clockin;
`ifdef DC 
     wire ffin_b;
     assign ffin_b = ~ffin;
     `LIB_clockdivff(ffout, ffin_b, clockin) 
`else                                                                         
 always @(posedge clockin)                                                
      begin                                                                  
         ffout = ffin; /* lintra s-60028 */
      end  
`endif
endmodule



module clkdiv2 (div2cknameout,div2ipinckin,div2usync);
output div2cknameout;
input div2ipinckin;
input div2usync;
reg div2cknameout;
wire div2ipinckin,div2usync;
 reg cknameout_ffout ;                                             
 wire cknameout_ffinvout ;                                         
 wire cknameout_andout ;                                           
always_latch                                                         
      begin                                                          
         if (~div2ipinckin) cknameout_ffout  = div2usync; /* lintra s-60028 */
      end                                                            
assign cknameout_ffinvout  = (~(cknameout_ffout));              
//assign  cknameout_andout = (cknameout_ffinvout  & ~div2cknameout); 
assign  cknameout_andout = (cknameout_ffinvout  & div2cknameout);  // bug fix - the FF cell already make the invertion
clockdivff clockdivff_cknameout (                                 
                                  .ffout(div2cknameout),                 
                                  .ffin(cknameout_andout),         
                                  .clockin(div2ipinckin)                 
                                 );
endmodule
                               

`define MAKE_CLK_OREN(ckorenout,ckorenckin,ckorenenin)              \
clkoren \``clkoren_``ckorenout (                                    \
                              .clkorenout (ckorenout),              \
                              .clkorenckin (ckorenckin),            \
                              .clkorenenin (ckorenenin)             \
                             );

module clkoren(clkorenout,clkorenckin,clkorenenin);
output clkorenout;
input clkorenckin;
input clkorenenin;
wire clkorenout,clkorenckin,clkorenenin;
wire clkorent1;
`ifdef DC
     `LIB_clkoren(clkorenout,clkorenckin,clkorenenin) 
`else
assign clkorent1 = ~(clkorenckin|clkorenenin);
assign clkorenout = ~clkorent1;
`endif
endmodule

`define MAKE_CLKOR(clkorout,clkorin1,clkorin2)                    \
clkor \``clkor_``clkorout  (                                      \
                          .ckoout (clkorout),                     \
                          .ckoin1 (clkorin1),                     \
                          .ckoin2 (clkorin2)                      \
                         );
module clkor (ckoout, ckoin1,ckoin2);
output ckoout;
input ckoin1;
input ckoin2;
wire ckoout,ckoin1,ckoin2;
`ifdef DC
     `LIB_clkor(ckoout, ckoin1,ckoin2) 
`else   
assign ckoout = (~(~(ckoin1|ckoin2)));
`endif
endmodule

// RBE clock ANDing logic.
//
module soc_rbe_clk (output logic ckrcbxpn, input logic ckgridxpn, latrcben);  //lintra s-31506

`ifdef DC
     `LIB_soc_rbe_clk(ckrcbxpn,ckgridxpn,latrcben) 
`else
`ifndef VLV_FPGA_CLK_GATE
   logic latrcbenl; // rce state element
  
  `LATCH_P(latrcbenl, latrcben, ckgridxpn)
  `CLKAND(ckrcbxpn, ckgridxpn, latrcbenl)
`else
assign ckrcbxpn = ckgridxpn;
`endif
`endif
endmodule // soc_rbe_clk                         

// RBE clock macro instantiating soc_rbe_clk module above

`define MAKE_SOC_RBE_CLK(ckrcbxpnout,ckgridxpnin,latrcbenin)                               \
 `ifdef MACRO_ATTRIBUTE                                                                    \
                                                                                           \
  `endif                                                                                   \
  soc_rbe_clk \``soc_rbe_clk_``ckrcbxpnout (                                               \
                                          .ckrcbxpn (ckrcbxpnout),                         \
                                          .ckgridxpn (ckgridxpnin),                        \
                                          .latrcben (latrcbenin)                           \
                                         );
module qual_gen (
    input      clka,
    input      clkb,
    input      clka_usync,
    input      clkb_usync,
    input [5:0] clka_ratio,
    input [5:0] clkb_ratio,
    input       test_override,
    output reg  clka_qual,
    output reg  clkb_qual,
    output wire freq_match
                 
                  );
                  
   reg[6:0]   clka_error;
   reg[6:0]   clkb_error;
   wire[6:0]  clka_error_tmp;
   wire[6:0]  clkb_error_tmp;
   wire[6:0]  clka_ratio_adjusted;
   wire[6:0]  clkb_ratio_adjusted;
   wire[6:0]  clka_ratio_twos;
   wire[6:0]  clkb_ratio_twos;

   assign     freq_match = clka_ratio == clkb_ratio;
   assign clka_ratio_adjusted[6:0] = {1'b0, clka_ratio[5:0]} + 7'b0000001;
   assign clkb_ratio_adjusted[6:0] = {1'b0, clkb_ratio[5:0]} + 7'b0000001;
   assign clka_ratio_twos[6:0]     = ~clka_ratio_adjusted[6:0] + 7'b0000001;
   assign clkb_ratio_twos[6:0]     = ~clkb_ratio_adjusted[6:0] + 7'b0000001;
   assign clka_error_tmp[6:0]      = {clkb_ratio_twos[6], clkb_ratio_twos[6:1]};
   assign clkb_error_tmp[6:0]      = {clka_ratio_twos[6], clka_ratio_twos[6:1]};

   always@(posedge clka)
     if(clka_usync)
       begin
          clka_error[6:0] <= clka_error_tmp[6:0];
//         clka_error[6:0] <= clka_error_tmp[6] ? 
//                    (clka_error_tmp[6:0] + clka_ratio_adjusted[6:0] - clkb_ratio_adjusted[6:0]) :
//                    (clka_error_tmp[6:0] - clkb_ratio_adjusted[6:0]);
       end
     else
       begin
         clka_error[6:0] <= clka_error[6] ?
                      (clka_error[6:0] + clka_ratio_adjusted[6:0] - clkb_ratio_adjusted[6:0]) :
                      (clka_error[6:0] - clkb_ratio_adjusted[6:0]);
       end
       
   always@(posedge clkb)
     if(clkb_usync)
       begin
          clkb_error[6:0] <= clkb_error_tmp[6:0];
//         clkb_error[6:0] <= clkb_error_tmp[6] ? 
//                    (clkb_error_tmp[6:0] + clkb_ratio_adjusted[6:0] - clka_ratio_adjusted[6:0]) :
//                    (clkb_error_tmp[6:0] - clka_ratio_adjusted[6:0]);
       end
     else
       begin
         clkb_error[6:0] <= clkb_error[6] ?
                      (clkb_error[6:0] + clkb_ratio_adjusted[6:0] - clka_ratio_adjusted[6:0]) :
                      (clkb_error[6:0] - clka_ratio_adjusted[6:0]);
       end

   always_comb
     begin
        if (clka_ratio[5:0] == clkb_ratio[5:0] | test_override)
            begin
               clka_qual = 1'b1;
               clkb_qual = 1'b1;
            end
        else if (clka_ratio[5:0] > clkb_ratio[5:0])
            begin
               clka_qual = clka_error[6];
               clkb_qual = 1'b1;
            end
        else
            begin
               clka_qual = 1'b1;
               clkb_qual = clkb_error[6];
            end   
     end
endmodule // qual_gen


///============================================================================================
///
/// Clocks
///
///============================================================================================

// changing all the clock macros to add an extra module level of hierarchy



// Commented out after meeting on 24 March 2011 -- Used in disp2d/visasig_VALLEYVIEW/... disp2d.v, gci.v; common/rtl/sync_tx_to_rx_fifo_with_rst.v; 
module det_clkdomainX #(parameter dWidth = 32, parameter fifo_depth = 10, parameter separation = 2) 
// aamshall: for synchronization that's done between two clocks that are derived from the same reference clock and use separation 1,
// this synchronizer must initiate it's rd/wr pointers at usync and not at reset!
// otherwise separation is not ensured.
// module det_clkdomainX must be abandoned and only this module det_clkdomainX_with_usync must be used.
(
                      input reset_ckRd,
                      input reset_ckWr,
                      input ckWr,
                      input ckRd,
                      input qualWr,
                      input qualRd,
                      input [dWidth-1:0] data_in,
                      output [dWidth-1:0] data_out
                      );

   logic [dWidth-1:0] det_clkdomainX_write_data_array[fifo_depth - 1:0];
   logic [dWidth-1:0] det_clkdomainX_read_data_mux;
   logic [fifo_depth - 1:0] wrptr;
   logic [fifo_depth - 1:0] rdptr;
   logic [fifo_depth - 1:0] start_ptr;
   logic write_clk;
   logic read_clk;

   `CLK_GATE(write_clk, ckWr, qualWr)
   `CLK_GATE(read_clk, ckRd, qualRd)
  
   // data path generation
   always @(posedge write_clk or negedge reset_ckWr)
     begin: write_clk_scope
        integer i;
        if (~reset_ckWr)
          begin
             for (i=0;i<fifo_depth;i=i+1)
               begin
                  det_clkdomainX_write_data_array[i] <= 0;
               end
          end
        else
          begin
             for (i=0;i<fifo_depth;i=i+1)
               begin
                  if (wrptr[i])
                    det_clkdomainX_write_data_array[i] <= data_in;
               end
          end
     end

   always @(posedge read_clk or negedge reset_ckRd)
     begin: read_clk_scope
        integer i;
        if (~reset_ckRd)
          begin
             det_clkdomainX_read_data_mux <= 0;
          end
        else
          begin
             for (i=0;i<fifo_depth;i=i+1)
               begin
                  if (rdptr[i])
                    det_clkdomainX_read_data_mux <= det_clkdomainX_write_data_array[i];
               end
          end
     end

   assign data_out = det_clkdomainX_read_data_mux;

   // wrptr and rdptr generation
   assign start_ptr = 1;
   
   always@(posedge write_clk or negedge reset_ckWr)
     if(!reset_ckWr)
       wrptr <= start_ptr << separation;
     else
       wrptr <= {wrptr[(fifo_depth - 2):0], wrptr[(fifo_depth - 1)]};

   always@(posedge read_clk or negedge reset_ckRd)
     if(!reset_ckRd)
       rdptr <= start_ptr;
     else
       rdptr <= {rdptr[(fifo_depth - 2):0], rdptr[(fifo_depth - 1)]};

endmodule // det_clkdomainX

// Moved from soc_dfx_macros.sv after meeting on 24 March 2011.
//This macro has a decrementing counter and hence we would see a low phase on
//the output clock when get the usync.
`define MAKE_CLK_DIV2OR4(idivoutclk, iipinclk, iusync, iseldiv2)     \
clkdiv2or4 \``clk_div_2or4_``idivoutclk (                            \
                                          .divoutclk(idivoutclk),    \
                                          .ipinclk(iipinclk),        \
                                          .usync(iusync),            \
                                          .seldiv2(iseldiv2)         \
                                        );

module clkdiv2or4 (divoutclk, ipinclk, usync, seldiv2);
output divoutclk;
input  ipinclk;
input  usync;
input  seldiv2;

logic [1:0] nxt;
logic [1:0] pst;
logic usync_lat;
logic divinclk;
logic divinclk_b;
`LATCH_P_DESKEW(usync_lat, usync, ipinclk)
`SET_MSFF(pst, nxt, ipinclk, usync_lat)
assign nxt = ~(|(pst))? 2'b11:(pst - 1);
assign divinclk_b = seldiv2? pst[0] : pst[1];
assign divinclk  = ~divinclk_b; 
clockdivff clockdivff_clkdiv2or4(
                                  .ffout(divoutclk),
                                  .ffin(divinclk),
                                  .clockin(ipinclk)
                                );
endmodule

`define MAKE_CLK_DIV8(ckdiv8out,ipinckdiv8in,usyncdiv8in)        \
clkdiv8 \``clk_div8_``ckdiv8out (                                \
                               .div8ckdiv8out (ckdiv8out),       \
                               .div8ipinckdiv8in (ipinckdiv8in), \
                               .div8usyncdiv8in (usyncdiv8in)    \
                              );

module clkdiv8 (div8ckdiv8out,div8ipinckdiv8in,div8usyncdiv8in);
output div8ckdiv8out;
input div8ipinckdiv8in;
input div8usyncdiv8in;
reg div8ckdiv8out;
wire div8ipinckdiv8in,div8usyncdiv8in;
reg ckdiv8out_pout;                                                
reg [2:0] ckdiv8out_rstffpst;                                      
wire [2:0] ckdiv8out_rstffnxt;                                     
wire ckdiv8out_invout;                                             
always_latch                                                         
      begin                                                          
         if (~div8ipinckdiv8in) ckdiv8out_pout  = div8usyncdiv8in; /* lintra s-60028 */
      end                                                            
   always_ff @(posedge div8ipinckdiv8in)                                 
      begin                                                          
         if (ckdiv8out_pout) ckdiv8out_rstffpst  <= '0;          
         else ckdiv8out_rstffpst  <=  ckdiv8out_rstffnxt;     
      end                                                            
 assign ckdiv8out_rstffnxt = ckdiv8out_rstffpst  + 1 ;           
assign ckdiv8out_invout = ~ckdiv8out_rstffpst[2];                
clockdivff clockdivff_ckdiv8out (                                 
                             .ffout(div8ckdiv8out),                      
                             .ffin(ckdiv8out_invout),              
                             .clockin(div8ipinckdiv8in)                      
                            );
endmodule



`define MAKE_CLK_DIV4(ckdiv4out,ipinckdiv4in,usyncdiv4in)        \
clkdiv4 \``clk_div4_``ckdiv4out (                                \
                               .div4ckdiv4out (ckdiv4out),       \
                               .div4ipinckdiv4in (ipinckdiv4in), \
                               .div4usyncdiv4in (usyncdiv4in)    \
                              );


module clkdiv4 (div4ckdiv4out,div4ipinckdiv4in,div4usyncdiv4in);
output div4ckdiv4out;
input div4ipinckdiv4in;
input div4usyncdiv4in;
reg div4ckdiv4out;
wire div4ipinckdiv4in,div4usyncdiv4in;
reg ckdiv4out_pout;                                                
reg [1:0] ckdiv4out_rstffpst;                                      
wire [1:0] ckdiv4out_rstffnxt;                                     
wire ckdiv4out_invout;                                             
always_latch                                                         
      begin                                                          
         if (~div4ipinckdiv4in) ckdiv4out_pout  = div4usyncdiv4in; /* lintra s-60028 */
      end                                                            
   always_ff @(posedge div4ipinckdiv4in)                                 
      begin                                                          
         if (ckdiv4out_pout) ckdiv4out_rstffpst  <= '0;          
         else ckdiv4out_rstffpst  <=  ckdiv4out_rstffnxt;     
      end                                                            
 assign ckdiv4out_rstffnxt = ckdiv4out_rstffpst  + 1 ;           
assign ckdiv4out_invout = ~ckdiv4out_rstffpst[1];                
clockdivff clockdivff_ckdiv4out (                                 
                             .ffout(div4ckdiv4out),                      
                             .ffin(ckdiv4out_invout),              
                             .clockin(div4ipinckdiv4in)                      
                            );
endmodule



`define MAKE_CLK_GLITCHFREE_MUX(clkout, clka, clkb, sela, selb)             	 \
clk_glitchfree_mux_part \clk_glitchfree_mux_part_``clkout (                      \
                                                            .clk_out(clkout),    \
                                                            .clk_a(clka),        \
                                                            .clk_b(clkb),        \
                                                            .sel_a(sela),        \
                                                            .sel_b(selb)         \
                                                          );               

module clk_glitchfree_mux_part (clk_out, clk_a, clk_b, sel_a, sel_b);
output clk_out;
input clk_a;
input clk_b;
input sel_a;
input sel_b;
logic sel_a_l, sel_b_l;
`ifdef DC
  `LIB_clk_glitchfree_mux_part(clk_out, clk_a, clk_b, sel_a, sel_b)
`else
  `LATCH_P(sel_a_l, sel_a, clk_a)
  `LATCH_P(sel_b_l, sel_b, clk_b)
  assign clk_out = (clk_a & sel_a_l) | (clk_b & sel_b_l);
`endif
endmodule

// New clock buffer macro only for SIPs that use thick gate library cells as are RTC in VLV

`define TG_CLKBF(clkbufout,clkbufin)                                                           \
`ifdef DC                                                                                   \
     `LIB_TG_CLKBF_SOC(clkbufout,clkbufin)                                                     \
 `else                                                                                      \
  `ifdef MACRO_ATTRIBUTE                                                                    \
                                                                                            \
   `endif                                                                                   \
     assign clkbufout =  (~(~(clkbufin)));                                                  \
 `endif


//programmable divider with usync, divivalonehot can one have one of the 10 bits high
//0000000001 is for div1 to 1000000000 is for div 10

`define MAKE_CLK_DIV_1_TO_10_USYNC(clkout, divvalonehot, clkin, usync, asyncrstb )      	\
div1to10macro_usync \div1to10macro_usync_``clkout (                      			\
                                                            .clk_out(clkout),    		\
                                                            .div_val_onehot(divvalonehot),      \
                                                            .clk_in(clkin),        		\
                                                            .usync_in(usync),        		\
                                                            .asyncrst_in(asyncrstb)         	\
                                                          );

module div1to10macro_usync (clk_out, div_val_onehot, clk_in, usync_in, asyncrst_in);
         input logic clk_in, usync_in,asyncrst_in;
         input logic [9:0] div_val_onehot;
         output logic clk_out;

         logic usync_lat;
         logic divclk, divclk_p1,divclkout;
         logic divodd;
         logic [3:0] divsel_flop;

         logic div1, div2, div3, div4, div5, div6, div7, div8, div9, div10;
         logic q0,q1,q2,q3,q4;
         logic q1_or_fb,q2_or_fb,q3_or_fb,q4_or_fb,q5in;
         logic div1_b;

         logic q0in;
         logic q1in;
         logic q2in;
         logic q3in;
         logic q4in;
         
         // Latch the incoming usync to prevent min-vio
         `LATCH_P_DESKEW(usync_lat, usync_in, clk_in)
         
         //Flop hte div-sel based on usync_lat
         // Capture new value on usync_lat, else keep the old value
         always_ff @(posedge clk_in or negedge asyncrst_in)
         begin
                 if(asyncrst_in == 1'b0)
                 begin
                          div1 <= 0;
                          div2 <= 0;
                          div3 <= 0;
                          div4 <= 0;
                          div5 <= 0;
                          div6 <= 0;
                          div7 <= 0;
                          div8 <= 0;
                          div9 <= 0;
                          div10 <= 0;
                 end
                 else     
                 if(usync_lat)
                 begin    
                          div1 <= div_val_onehot[0];
                          div2 <= div_val_onehot[1];
                          div3 <= div_val_onehot[2];
                          div4 <= div_val_onehot[3];
                          div5 <= div_val_onehot[4];
                          div6 <= div_val_onehot[5];
                          div7 <= div_val_onehot[6];
                          div8 <= div_val_onehot[7];
                          div9 <= div_val_onehot[8];
                          div10 <= div_val_onehot[9];
                 end
         end



                 // Shift-reg based counter
                 
                 assign fb = divodd ?~(q0|q1):~q0;
                 

                 //If the divsel value is invalue, do a div1

                 assign div3or4 = div3 | div4;
                 assign div5or6 = div5 | div6;
                 assign div7or8 = div7 | div8;
                 assign div9or10 = div9 | div10;
                 assign divodd = div3 | div5 | div7 | div9 ;        
                 
                 //the feedback point is selected based on the div-value
                 assign q1_or_fb = div2?fb:q1;
                 assign q2_or_fb = div3or4?fb:q2;
                 assign q3_or_fb = div5or6?fb:q3;
                 assign q4_or_fb = div7or8?fb:q4;
                 assign q5in = div9or10 & fb;

                 assign q0in = usync_lat ?1'b0:q1_or_fb;
                 assign q1in = usync_lat ?1'b0:q2_or_fb;
                 assign q2in = usync_lat ?1'b0:q3_or_fb;
                 assign q3in = usync_lat ?1'b0:q4_or_fb;
                 assign q4in = usync_lat ?1'b0:q5in;
                 

                 `CLK_FF(q0,q0in,clk_in,asyncrst_in)
                 `CLK_FF(q1,q1in,clk_in,asyncrst_in)
                 `CLK_FF(q2,q2in,clk_in,asyncrst_in)
                 `CLK_FF(q3,q3in,clk_in,asyncrst_in)
                 `CLK_FF(q4,q4in,clk_in,asyncrst_in)
         
                 
                 //If it is div1, then just send out the input clock
                 assign divinclk = div1?1'b0:fb;   



                 `CLK_FF(divclk,divinclk,clk_in,asyncrst_in)
                 `CLK_FF(divclk_p1,(divodd & divclk),~clk_in,asyncrst_in)

                 assign divclkout = divodd?(divclk | divclk_p1):divclk;
                 
                 //assign clkout = div1?clk_in:divclk_out;
                 //clkmux_glitchfree iclkmx(.clka(clk_in),.clkb(divclkout),.sela(div1),.clkout(clk_out));
                assign div1_b = ~div1;

                 `MAKE_CLK_GLITCHFREE_MUX(clk_out,clk_in,divclkout,div1,~div1)

                 
endmodule



//programmable divider  divivalonehot can one have one of the 10 bits high
//0000000001 is for div1 to 1000000000 is for div 10

`define MAKE_CLK_DIV_1_TO_10(clkout, divvalonehot, clkin, asyncrstb)             		\
div1to10macro \div1to10macro_``clkout (                      					\
                                                            .clk_out(clkout),    		\
                                                            .div_val_onehot(divvalonehot),      \
                                                            .clk_in(clkin),        		\
                                                            .asyncrst_in(asyncrstb)         	\
                                                          );

module div1to10macro (clk_out, div_val_onehot, clk_in, asyncrst_in);
                    input logic clk_in, asyncrst_in;
                    input logic [9:0] div_val_onehot;
                    output logic clk_out;

                    logic usync_lat;
                    logic divclk, divclk_p1,divclkout;
                    logic divodd;
                    logic [3:0] divsel_flop;

                    logic div1, div2, div3, div4, div5, div6, div7, div8, div9, div10;
                   logic div1_b;
                    logic q0,q1,q2,q3,q4;
                    logic q1_or_fb,q2_or_fb,q3_or_fb,q4_or_fb,q5in;

                    logic q0in;
                    logic q1in;
                    logic q2in;
                    logic q3in;
                    logic q4in;


                                        // Shift-reg based counter
                                        
                                        assign fb = divodd?~(q0|q1):~q0;
                                        

                                        //If the divsel value is invalue, do a div1

                                        assign div3or4 = div_val_onehot[2] | div_val_onehot[3];
                                        assign div5or6 = div_val_onehot[4] | div_val_onehot[5];
                                        assign div7or8 = div_val_onehot[6] | div_val_onehot[7];
                                        assign div9or10 = div_val_onehot[8] | div_val_onehot[9];
                                        assign divodd = div_val_onehot[2] | div_val_onehot[4] | div_val_onehot[6] | div_val_onehot[8] ;     
                                        
                                        //the feedback point is selected based on the div-value

                                        assign q0in = div_val_onehot[1]?fb:q1;
                                        assign q1in = div3or4?fb:q2;
                                        assign q2in = div5or6?fb:q3;
                                        assign q3in = div7or8?fb:q4;
                                        assign q4in = div9or10 & fb;

                                        `CLK_FF(q0,q0in,clk_in,asyncrst_in)
                                        `CLK_FF(q1,q1in,clk_in,asyncrst_in)
                                        `CLK_FF(q2,q2in,clk_in,asyncrst_in)
                                        `CLK_FF(q3,q3in,clk_in,asyncrst_in)
                                        `CLK_FF(q4,q4in,clk_in,asyncrst_in)
                    
                                        
                                        //If it is div1, then just send out the input clock
                                        assign divinclk = div_val_onehot[0]?1'b0:fb; 



                                        `CLK_FF(divclk,divinclk,clk_in,asyncrst_in)
                                        `CLK_FF(divclk_p1,(divodd & divclk),~clk_in,asyncrst_in)

                                        assign divclkout = divodd?(divclk | divclk_p1):divclk;
                                        
//                                       clkmux_glitchfree iclkmx(.clka(clk_in),.clkb(divclkout),.sela(div_val_onehot[0]),.clkout(clk_out));
                                      assign div1 =  div_val_onehot[0];
                                      assign div1_b =  ~div_val_onehot[0];

                                         `MAKE_CLK_GLITCHFREE_MUX(clk_out, clk_in, divclkout, div1, div1_b)  
                                          
endmodule


   
module clockdiv4ffreset (clk_in, reset_in, clk_out);
output clk_out;
input clk_in; 
input reset_in;
wire counter_0, counter_0_b, xor_out, nand_out, and_out, nor_out;
`MAKE_CLK_INV(counter_0_b,counter_0) 
`CLK_FF(counter_0,counter_0_b,clk_in,reset_in)
`CLK_FF(clk_out,xor_out,clk_in,reset_in)
`CLK_NAND(nand_out,counter_0,clk_out)
`MAKE_CLK_INV(and_out,nand_out)    
`MAKE_CLKNOR(nor_out,counter_0,clk_out)
`MAKE_CLKNOR(xor_out,nor_out,and_out)
endmodule





/* novas s-51500, s-53048, s-53050 */
module qualdiv1to8_adj_local (qualifier_out,ipinclk,usync,qualovrd,ratiosel);
  output qualifier_out;
  input ipinclk;
  input usync;
  input qualovrd;
  input [2:0] ratiosel;
 
  logic usync_or_qual_lat, usync_or_qual, qual_staged, qual;
  logic [2:0] ratiosel_muxed_staged, ratiosel_muxed;
  logic [2:0] nxt;
  logic [2:0] pst;
 
  //Whenever a qual or usync comes through we reset the counter
  assign usync_or_qual = usync | qual;

  `LATCH_P_DESKEW(usync_or_qual_lat, usync_or_qual, ipinclk)
  assign nxt = pst + 3'b001;
  `RST_MSFF(pst, nxt, ipinclk, usync_or_qual_lat)

  //only grab ratiosel on usync boundary
  assign ratiosel_muxed = usync ? ratiosel : ratiosel_muxed_staged;
  `MSFF(ratiosel_muxed_staged, ratiosel_muxed, ipinclk)

  //Once we've reached the count that matches the ratiosel we're dividing by
  //Set the qual indicator and reset the count
  assign qual = (pst == ratiosel_muxed_staged);

  `MSFF(qual_staged, qual, ipinclk)
  assign qualifier_out = qual_staged | qualovrd;
endmodule // qualdiv1to8_adj_local

`define MAKE_QUAL_LOCAL_QUALDIV1TO8_ADJ(qual_out, inclk, inusync, inqualovrd, inratiosel)     \
 qualdiv1to8_adj_local \``qualdiv1to8adj_``qual_out (                                         \
                                                    .qualifier_out(qual_out),                 \
                                                    .ipinclk(inclk),                          \
                                                    .usync(inusync),                          \
                                                    .qualovrd(inqualovrd),                    \
                                                    .ratiosel(inratiosel)                     \
                                                    );



//this macro will divide the clk with output qualified with the period of the clk coming in//
//ratio stting for dividering is://
//Raiosel(2) ratiosel(1) ratiosel(0)//
//000 div1//
//001 div2//
//010 div3//
//011 div4//
//100 div5//
//101 div6//
//110 div7//
//111 div8//

module clk_qualdiv1to8_adj_local(xqualclk_out, xclk, xusync, xqualovrd, xratiosel);
  output xqualclk_out;
  input xclk;
  input xusync;
  input xqualovrd;
  input [2:0] xratiosel;
  logic xqual_out;
  `MAKE_QUAL_LOCAL_QUALDIV1TO8_ADJ(xqual_out, xclk, xusync, xqualovrd, xratiosel)        
  `CLK_GATE(xqualclk_out, xclk,  xqual_out) //novas s-51557, s-51552
endmodule

`define CLK_QUALDIV1TO8_ADJ_LOCAL(qualclk_out, clk, usync, qualovrd, ratiosel )                 \
clk_qualdiv1to8_adj_local \``clk_qualdiv1to8_adj_local_``qualclk_out (                          \
                                                            .xqualclk_out(qualclk_out),         \
                                                            .xclk(clk),                         \
                                                            .xusync(usync),                     \
                                                            .xqualovrd(qualovrd),               \
                                                            .xratiosel(ratiosel)                \
                                                          );







`endif //  `ifndef SOC_CLOCK_MACROS_VH  



/*******************************************************************************************************************
*
 *  MACROS NOT BEING USED BY ANYONE ELSE - PLS CONTATC RAM M KRISHNAMURTHY for
   *  ISSUES 
*  
*******************************************************************************************************************/



//`define MAKE_CLK_DELAY4(clkd4out,clkd4clkin,clkd4in0,clkd4in1,clkd4in2)    \
//clk4delay \``clk4delay_``clkd4out (                                          \
//                                    .clk4delayout (clkd4out),              \
//                                    .clk4delayin (clkd4clkin),             \
//                                    .clk4in0 (clkd4in0),                   \
//                                    .clk4in1 (clkd4in1),                   \
//                                    .clk4in2 (clkd4in2)                    \
//                                );
//
//`define LIB_clk4delay(clk4delayout,clk4delayin,clk4in0,clk4in1,clk4in2) \
//  vl0dcc04ln0a0 ck2(.o(clk4delayout),.clk(clk4delayin),.rsel0(clk4in0),.rsel1(clk4in1),.rsel2(clk4in2)); \
//
//module clk4delay (clk4delayout,clk4delayin,clk4in0,clk4in1,clk4in2);
//output clk4delayout;
//input clk4delayin;
//input clk4in0;
//input clk4in1;
//input clk4in2;
//wire clk4delayout,clk4delayin,clk4in0,clk4in1,clk4in2;
//`ifdef DC
//     `LIB_clk4delay(clk4delayout,clk4delayin,clk4in0,clk4in1,clk4in2) 
// `else
//assign clk4delayout = clk4delayin;
//`endif
//endmodule
//
//
//`define MAKE_CLK_DELAY8(clkd8out,clkd8clkin,clkd8in0,clkd8in1,clkd8in2,clkd8in3,clkd8in4,clkd8in5,clkd8in6)    \
//clk8delay \``clk8delay_``clkd8out (                                                         \
//                                    .clk8delayout (clkd8out),                             \
//                                    .clk8delayin (clkd8clkin),                            \
//                                    .clk8in0 (clkd8in0),                                  \
//                                    .clk8in1 (clkd8in1),                                  \
//                                    .clk8in2 (clkd8in2),                                  \
//                                    .clk8in3 (clkd8in3),                                  \
//                                    .clk8in4 (clkd8in4),                                  \
//                                    .clk8in5 (clkd8in5),                                  \
//                                    .clk8in6 (clkd8in6)                                   \
//                                );
//
//
//`define LIB_clk8delay(clk8delayout,clk8delayin,clk8in0,clk8in1,clk8in2,clk8in3,clk8in4,clk8in5,clk8in6) \
//  vl0dcc08ln0a0 ck2(.o(clk8delayout),.clk(clk8delayin),.rsel0(clk8in0),.rsel1(clk8in1),.rsel2(clk8in2),.rsel3(clk8in3),.rsel4(clk8in4),.rsel5(clk8in5),.rsel6(clk8in6)); \
//
//module clk8delay (clk8delayout,clk8delayin,clk8in0,clk8in1,clk8in2,clk8in3,clk8in4,clk8in5,clk8in6);
//output clk8delayout;
//input clk8delayin;
//input clk8in0;
//input clk8in1;
//input clk8in2;
//input clk8in3;
//input clk8in4;
//input clk8in5;
//input clk8in6;
//wire clk8delayout,clk8delayin,clk8in0,clk8in1,clk8in2,clk8in3,clk8in4,clk8in5,clk8in6;
//`ifdef DC
//     `LIB_clk8delay(clk8delayout,clk8delayin,clk8in0,clk8in1,clk8in2,clk8in3,clk8in4,clk8in5,clk8in6) 
// `else
//assign clk8delayout = clk8delayin;
//`endif
//endmodule
//
//
//`define MAKE_CLK_DIV2SHIFT(ckdiv2shftout,ipinckdiv2shftin,usyncdiv2shft)      \
// clk2div2shft \``clk_div2shift_``ckdiv2shftout (                                             \
//                                              .div2shftckdiv2shftout (ckdiv2shftout),      \
//                                              .div2shftipinckdiv2shftin (ipinckdiv2shftin),\
//                                              .div2shftusyncdiv2shft (usyncdiv2shft)       \
//                                             );
//
//module clk2div2shft (div2shftckdiv2shftout,div2shftipinckdiv2shftin,div2shftusyncdiv2shft);
//output div2shftckdiv2shftout;
//input div2shftipinckdiv2shftin;
//input div2shftusyncdiv2shft;
//reg div2shftckdiv2shftout;
//wire div2shftipinckdiv2shftin,div2shftusyncdiv2shft;
// reg ckdiv2shftout_ffout;                                                          
//  wire ckdiv2shftout_invout,ckdiv2shftout_andout,ckdiv2shftout_ckinvout;        
//  always_ff @(posedge div2shftipinckdiv2shftin)                                               
//      begin                                                                           
//       ckdiv2shftout_ffout   <= div2shftusyncdiv2shft;                                      
//      end  
//  assign ckdiv2shftout_invout = ~ckdiv2shftout_ffout;       
//  clkinv clkinvdiv2shft (
//                         .clkout (ckdiv2shftout_ckinvout),
//                         .clkin (div2shftipinckdiv2shftin)
//                        );
//  assign  ckdiv2shftout_andout = (ckdiv2shftout_invout) & (~div2shftckdiv2shftout);     
//  clockdivff clockdivff_ckdiv2shftout (                                            
//                                   .ffout(div2shftckdiv2shftout),                             
//                                   .ffin(ckdiv2shftout_andout),                     
//                                   .clockin(ckdiv2shftout_ckinvout)                 
//                                  );
//endmodule
//
//                                             
//
//
//
//
//
//`define MAKE_CLK_LOCAL_QUALDIV100(div100clkout, div100_base_clk, div100_reset_n, div100_byp_div, div100_clk_disable, div100_squash_div)        \
//   crp_sample_gen_common #(100) \``make_clk_qualdiv100_``div100clksample (                                           \
//                                                    .base_clk              (div100_base_clk),                \
//                                                    .byp_div               (div100_byp_div),                 \
//                                                    .reset_n               (div100_reset_n),                 \
//                                                    .clk_disable           (div100_clk_disable),             \
//                                                    .squash_div            (div100_squash_div),              \
//                                                    .clk_out               (div100clkout)                    \
//                                                    );
//
//`define MAKE_CLK_LOCAL_QUALDIV16(outclk,inclk,ipinck,inusync)             \
//clkqualdiv16_local \``clk_qualdiv4_local``outclk (                               \
//                                   .divckout (outclk),                      \
//                                   .divckin  (inclk),                       \
//                                   .divipinckin(ipinck),                      \
//                                   .divusync (inusync)                            \
//                                  );
//
///* lintra s-31500, s-33048, s-33050 */
//module clkqualdiv16_local (divckout,divckin,divipinckin,divusync);
//   output divckout;
//   input  divckin;
//   input  divipinckin;
//   input  divusync;
//   reg    divckout;
//   wire   divckin,divusync;
//   reg    ckdiv16out_pout;                                                
//   reg [3:0] ckdiv16out_rstffpst;                                      
//   wire [3:0] ckdiv16out_rstffnxt;
//   logic       temp1, usync;
//   always_latch                                                         
//     begin                                                          
//        if (~divipinckin) ckdiv16out_pout  <= divusync;        
//     end                                                            
//   always_ff @(posedge divipinckin)                                 
//     begin                                                          
//        if (ckdiv16out_pout) ckdiv16out_rstffpst  <= '0;
//        else ckdiv16out_rstffpst  <=  ckdiv16out_rstffnxt;     
//     end                                                            
//   assign ckdiv16out_rstffnxt = ckdiv16out_rstffpst  + 1 ;           
//   assign usync = &ckdiv16out_rstffpst;
//   
//   clockdivff clockdivff_ckdiv16out(                                 
//                                   .ffout(temp1),                      
//                                   .ffin(usync),              
//                                   .clockin(divckin)                      
//                                   );
//   `CLK_GATE(divckout, divckin, temp1)
//
//endmodule
//
//`define MAKE_CLK_LOCAL_QUALDIV2(ckout,ckin,ipinckin,usync)         \
// clkqualdiv_local \``clk_qualdiv2_``ckout (                         \
//                                         .divckout(ckout),       \
//                                         .divckin(ckin) ,        \
//                                         .divipinckin(ipinckin), \
//                                         .divusync(usync)          \
//                                         );
//
//
//
///* lintra s-31500, s-33048, s-33050 */
//`define MAKE_CLK_LOCAL_QUALDIV4(ckout2,ckin2,ipinckin2,usync2)            \
//clkqualdiv4_local \``clk_qualdiv4_local``ckout2 (                                \
//                                   .divckout (ckout2),             \
//                                   .divckin  (ckin2),              \
//                                   .divipinckin(ipinckin2),        \
//                                   .divusync (usync2)                \
//                                  );
//
//`define MAKE_CLK_LOCAL_QUALDIV600(div600clkout, div600_base_clk, div600_reset_n, div600_byp_div, div600_clk_disable, div600_squash_div)        \
//   crp_sample_gen_common #(600) \``make_clk_qualdiv600_``div600clksample (                                           \
//                                                    .base_clk              (div600_base_clk),                \
//                                                    .reset_n               (div600_reset_n),                 \
//                                                    .byp_div               (div600_byp_div),                 \
//                                                    .clk_disable           (div600_clk_disable),             \
//                                                    .squash_div            (div600_squash_div),              \
//                                                    .clk_out               (div600clkout)                    \
//                                                    );
//
//module crp_sample_gen_common  #(parameter dWidth = 3) 
//                     (
//                      input                  base_clk,       // Pre or Post CTS based on Physical Design
//                      input                  reset_n,        // Must be pre-stinkronized to base_clk input
//                      input                  byp_div,        // PMU Register input
//                      input                  clk_disable,    // PMU Register input
//                      input [(dWidth - 1):0] squash_div,     // PMU Register input
//                      output                 clk_out
//                      );
//
//   reg [(dWidth - 1):0]    count;
//   reg                     clk_sample_fe;
//   wire                    clk_sample;
//
//   // Standard up-down counter with some extras
//   always @(posedge base_clk or negedge reset_n )
//     if (~reset_n)
//       count         <= 'b0;     // Divider initial 1 or 0
//     else if (clk_disable || (squash_div == 0))
//       count         <= 'b0;
//     else if (count < squash_div)
//       count         <= count + 1;
//     else
//       count         <= 'b0;
//
//   // Falling edge used to clock forward the sample signal
//   always @(negedge base_clk or negedge reset_n )
//     if (~reset_n)
//       clk_sample_fe <= 'b0;     
//     else if (clk_disable)    // I1 control
//       clk_sample_fe <= 'b0;
//     else if ( count == 0 )
//       clk_sample_fe <= 'b1;
//     else
//       clk_sample_fe <= 'b0;
//
//   assign  clk_sample = byp_div ? 1'b1 : clk_sample_fe;
//
//   soc_rbe_clk \``soc_rbe_clk_``clk_out (clk_out,base_clk,clk_sample);
//endmodule // clk_sample_gen
//
//
//`define MAKE_CLK_LOCAL_QUALDIV8(ckout2,ckin2,ipinckin2,usync2)            \
//clkqualdiv8_local \``clk_qualdiv4_local``ckout2 (                                \
//                                   .divckout (ckout2),             \
//                                  .divckin  (ckin2),              \
//                                   .divipinckin(ipinckin2),        \
//                                   .divusync (usync2)                \
//                                  );
///* lintra s-31500, s-33048, s-33050 */
//module clkqualdiv8_local (divckout,divckin,divipinckin,divusync);
//   output divckout;
//   input  divckin;
//   input  divipinckin;
//   input  divusync;
//   reg    divckout;
//   wire   divckin,divusync;
//   reg    ckdiv8out_pout;                                                
//   reg [2:0] ckdiv8out_rstffpst;                                      
//   wire [2:0] ckdiv8out_rstffnxt;
//   logic       temp1, temp2, usync;
//   always_latch                                                         
//     begin                                                          
//        if (~divipinckin) ckdiv8out_pout  <= divusync;        
//     end                                                            
//   always_ff @(posedge divipinckin)                                 
//     begin                                                          
//        if (ckdiv8out_pout) ckdiv8out_rstffpst  <= '0;          
//        else ckdiv8out_rstffpst  <=  ckdiv8out_rstffnxt;     
//     end                                                            
//   assign ckdiv8out_rstffnxt = ckdiv8out_rstffpst  + 1 ;           
//   assign usync = &ckdiv8out_rstffpst;
//   
//   clockdivff clockdivff_ckdiv8out(                                 
//                                   .ffout(temp1),                      
//                                   .ffin(usync),              
//                                   .clockin(divckin)                      
//                                   );
//   `CLK_GATE(divckout, divckin, temp1)
//endmodule
//                                  
//
//`define MAKE_CLK_LOCAL_QUALDIV8_ADJ(ckout2,ckin2,ipinckin2,usync2, ratiosel2)            \
//clkqualdiv8_local_adj \``clk_qualdiv4_local_adj``ckout2 (                                \
//                                   .divckout (ckout2),             \
//                                   .divckin  (ckin2),              \
//                                   .divipinckin(ipinckin2),        \
//                                   .divusync (usync2),               \
//                                   .ratiosel (ratiosel2)                \
//                                  );
///* lintra s-31500, s-33048, s-33050 */
//module clkqualdiv8_local_adj (divckout,divckin,divipinckin,divusync,ratiosel);
//   output divckout;
//   input  divckin;
//   input  divipinckin;
//   input  divusync;
//   input [2:0] ratiosel;
//   reg    divckout;
///   wire   divckin,divusync;
//   reg    ckdiv8out_pout;                                                
//   reg [2:0] ckdiv8out_rstffpst;                                      
//   wire [2:0] ckdiv8out_rstffnxt;
//   logic       temp1, usync;
//
//   `LATCH_P_DESKEW(ckdiv8out_pout, divusync, divipinckin)           
//   assign ckdiv8out_rstffnxt = ckdiv8out_rstffpst  + 1 ;
//   `RST_MSFF(ckdiv8out_rstffpst, ckdiv8out_rstffnxt, divipinckin, ckdiv8out_pout)                   
//
//   always_comb
//     case(ratiosel)
//       3'b000 : usync = &ckdiv8out_rstffpst[2:0]; // div 8
//       3'b001 : usync = &ckdiv8out_rstffpst[1:0]; // div 4
//       3'b011 : usync = ckdiv8out_rstffpst[0];    // div 2
//       3'b111 : usync = 1'b1;                     // div 1
//       default: usync = 1'b1;
//     endcase // case(ratiosel)
//       
//   clockdivff clockdivff_ckdiv8out(                                 
//                                   .ffout(temp1),                      
//                                   .ffin(usync),              
//                                   .clockin(divckin)                      
//                                   );
//   `CLK_GATE(divckout, divckin, temp1)
//endmodule
//
//// original MAKE_CLK_QUALDIV2 need to comment out after iosf is inplace
//`define MAKE_CLK_QUALDIV2(ckout,ckin,ipinckin,qual)         \
// clkqualdiv \``clk_qualdiv2_``ckout (                         \
//                                    .divckout(ckout),       \
//                                    .divckin(ckin) ,        \
//                                    .divipinckin(ipinckin), \
//                                    .divqual(qual)          \
//                                   );
//module clkqualdiv_local (divckout,divckin,divipinckin,divusync);
//output divckout;
//input divckin;
//input divipinckin;
//input divusync;
//   logic temp, temp1, temp2, temp3;
//    wire ckout_tmp1, ckout_tmp2, ckout_tmp, ckout_invclk;                                 
//   `LATCH_P(temp, divusync, divipinckin)
//   `MSFF(temp1, temp2, divipinckin)
//   assign temp2 = ~temp1 & ~temp;
//   `MSFF(temp3, temp1, divckin)
//   `CLK_GATE(divckout, divckin, temp3)
// 
//     /* lintra s-31500 */
//endmodule
//
//// original MAKE_CLK_QUALDIV4 - need to comment out after iosf in place
//`define MAKE_CLK_QUALDIV4(ckout2,ckin2,ipinckin2,qual2)            \
//clkqualdiv \``clk_qualdiv4_``ckout2 (                                \
//                                   .divckout (ckout2),             \
//                                   .divckin  (ckin2),              \
//                                   .divipinckin(ipinckin2),        \
//                                   .divqual (qual2)                \
//                                  );
//
//
//`define MAKE_QUAL_LOCAL_QUALDIV2(qual_out, inclk, inusync, inqualovrd)     \
// qualdiv2_local \``qualdiv2_``qual_out (                                         \
//                                         .qualifier_out(qual_out),       \
//                                         .ipinclk(inclk) ,                  \
//                                         .usync(inusync),                       \
//                                         .qualovrd(inqualovrd)                  \
//                                         );
//
///* lintra s-31500, s-33048, s-33050 */
//module qualdiv2_local (qualifier_out,ipinclk,usync,qualovrd);
//  output qualifier_out;
//  input ipinclk;
//  input usync;
//  input qualovrd;
// 
//  logic usync_lat, qual_staged;
//  logic nxt, pst;
// 
//  `LATCH_P(usync_lat, usync, ipinclk)
//  assign nxt = pst + 1;
//  `RST_MSFF(pst, nxt, ipinclk, usync_lat)
//  `MSFF(qual_staged, pst, ipinclk)
//  assign qualifier_out = qual_staged | qualovrd;
//endmodule
// 
//`define MAKE_QUAL_LOCAL_QUALDIV4(qual_out, inclk, inusync, inqualovrd)     \
// qualdiv4_local \``qualdiv4_``qual_out (                                         \
//                                         .qualifier_out(qual_out),       \
//                                         .ipinclk(inclk) ,                  \
//                                         .usync(inusync),                       \
//                                         .qualovrd(inqualovrd)                  \
//                                         );
///* lintra s-31500, s-33048, s-33050 */
//module clkqualdiv4_local (divckout,divckin,divipinckin,divusync);
//   output divckout;
//   input  divckin;
//   input  divipinckin;
//   input  divusync;
//   reg    divckout;
//   wire   divckin,divusync;
//   reg    ckdiv4out_pout;                                                
//   reg [1:0] ckdiv4out_rstffpst;                                      
//   wire [1:0] ckdiv4out_rstffnxt;
//   logic       temp1, usync;
//   always_latch                                                         
//     begin                                                          
//        if (~divipinckin) ckdiv4out_pout  <= divusync;        
//     end                                                            
//   always_ff @(posedge divipinckin)                                 
//     begin                                                          
//        if (ckdiv4out_pout) ckdiv4out_rstffpst  <= '0;          
//        else ckdiv4out_rstffpst  <=  ckdiv4out_rstffnxt;     
//     end                                                            
//   assign ckdiv4out_rstffnxt = ckdiv4out_rstffpst  + 1 ;           
//   assign usync = &ckdiv4out_rstffpst;
//   
//   clockdivff clockdivff_ckdiv4out(                                 
//                                   .ffout(temp1),                      
//                                   .ffin(usync),              
//                                   .clockin(divckin)                      
//                                   );
//   `CLK_GATE(divckout, divckin, temp1)
//endmodule
//
//// origianl clkqualdiv - need to remove after iosf is in place
//module clkqualdiv (divckout,divckin,divipinckin,divqual);
//output divckout;
//input divckin;
//input divipinckin;
//input divqual;
//wire divckout,divckin,divipinckin,divqual;
//`ifdef DC                                                                                         
//    wire ckout_tmp1, ckout_tmp2, ckout_tmp, ckout_invclk;                                 
//    `LIB_clkqualdiv(divckout,divckin,divipinckin,divqual) 
//`else                                                                                             
//reg ckout_qualout, ckout_qual1out;                                                            
// always @(negedge divipinckin)                                                                       
//   begin                                                                                          
//      ckout_qual1out = divqual; /* lintra s-60028 */
//   end                                                                                            
// always @(negedge divipinckin)                                                                       
//  begin                                                                                           
//      ckout_qualout  = ckout_qual1out; /* lintra s-60028 */
//   end                                                                                            
//   assign divckout = ckout_qualout & divckin;                                                     
//`endif     /* lintra s-31500 */
//endmodule
//
//
//                                        
//`define MAKE_QUAL_LOCAL_QUALDIV8(qual_out, inclk, inusync, inqualovrd)     \
// qualdiv8_local \``qualdiv8_``qual_out (                                         \
//                                        .qualifier_out(qual_out),       \
//                                         .ipinclk(inclk) ,                  \
//                                         .usync(inusync),                       \
//                                        .qualovrd(inqualovrd)                  \
//                                         );
//
///* lintra s-31500, s-33048, s-33050 */
//module qualdiv8_local (qualifier_out,ipinclk,usync,qualovrd);
//  output qualifier_out;
//  input ipinclk;
//  input usync;
//  input qualovrd;
// 
//  logic usync_lat, qual_staged, qual;
//  logic [2:0] nxt;
//  logic [2:0] pst;
// 
//  `LATCH_P(usync_lat, usync, ipinclk)
//  assign nxt = pst + 1;
//  `RST_MSFF(pst, nxt, ipinclk, usync_lat)
//  assign qual = (&(pst));
//  `MSFF(qual_staged, qual, ipinclk)
//  assign qualifier_out = qual_staged | qualovrd;
//endmodule
//
//*****ANY USES OF MAKE_QUAL_LOCAL_QUALDIV8_ADJ SHOULD EVENTUALLY BE REPLACED BY 
//*****MAKE_QUAL_LOCAL_QUALDIV1TO8_ADJ WE CAN'T JUST CHANGE THIS MACRO AS IT WOULD CAUSE FAILS
// ML_FIX : Eventually need to remove this define and module
//`define MAKE_QUAL_LOCAL_QUALDIV8_ADJ(qual_out, inclk, inusync, inqualovrd, inratiosel)     \
// qualdiv8_adj_local \``qualdiv8adj_``qual_out (                                                   \
//                                         .qualifier_out(qual_out),                     \
//                                         .ipinclk(inclk) ,                                \
//                                         .usync(inusync),                                     \
//                                         .qualovrd(inqualovrd),                                \
//                                         .ratiosel(inratiosel)                                \
//                                         );
//
///* lintra s-31500, s-33048, s-33050 */
//module qualdiv8_adj_local (qualifier_out,ipinclk,usync,qualovrd,ratiosel);
//  output qualifier_out;
//  input ipinclk;
//  input usync;
//  input qualovrd;
//  input [2:0] ratiosel;
// 
//  logic usync_lat, qual_staged, qual;
//  logic [2:0] nxt;
//  logic [2:0] pst;
// 
//  `LATCH_P_DESKEW(usync_lat, usync, ipinclk)
//  assign nxt = pst + 1;
//  `RST_MSFF(pst, nxt, ipinclk, usync_lat)
//  always_comb begin
//    casex(ratiosel)
//      3'b000 : qual = &pst[2:0]; // div 8
//      3'b001 : qual = &pst[1:0]; // div 4
//      3'b011 : qual = pst[0];    // div 2
//      3'b111 : qual = 1'b1;      // div 1
//      default: qual = 1'b1;
//    endcase // case(ratiosel)
//  end
//  `MSFF(qual_staged, qual, ipinclk)
//  assign qualifier_out = qual_staged | qualovrd;
//endmodule // qualdiv8_adj_local
//
//`define CLK_FF_INV(ckdiv2routb,ckdiv2rin,ckdiv2clkin,ckdiv2resetin)                       \
//clockdivffreset_inv \``clockdivffreset_inv_``ckdiv2routb (                                \
//                                                         .ffoutresetb(ckdiv2routb),       \
//                                                         .ffinreset(ckdiv2rin),           \
//                                                         .clockinreset(ckdiv2clkin),      \
//                                                         .resetckdivff(ckdiv2resetin)     \
//                                                        );
//
//module clockdivffreset_inv (ffoutresetb, ffinreset, clockinreset,resetckdivff);    
//output ffoutresetb;
//input ffinreset;
//input clockinreset;
//input resetckdivff;
//reg ffoutresetb;
//wire ffinreset, clockinreset, resetckdivff;
//`ifdef DC
//     `LIB_clockdivffreset(ffoutresetb, ffinreset, clockinreset,resetckdivff) 
//`else 
//always @(negedge (resetckdivff) or posedge clockinreset)
//begin
//  if (~(resetckdivff))
//    ffoutresetb = 1'b0; /* lintra s-60028 */
//  else
//    ffoutresetb = ~(ffinreset); /* lintra s-60028 */
//end
//`endif
//endmodule
//
//
//`define CLK_GATE_HF(o, clk, a)                                                               \
// soc_rbe_clk_hf \``soc_rbe_clk_hf_``o (                                                      \
//                                       .ckrcbxpn  (o),                                       \
//                                       .ckgridxpn (clk),                                     \
//                                       .latrcben  (a)                                        \
//                                      );
//module soc_rbe_clk_hf (output logic ckrcbxpn, input logic ckgridxpn, latrcben);  //lintra s-51506
//
//`ifdef DC
//     `LIB_soc_rbe_clk_hf(ckrcbxpn,ckgridxpn,latrcben) 
//`else
//   logic latrcbenl; // rce state element
//  
//  `LATCH_P(latrcbenl, latrcben, ckgridxpn) //lintra s-51552
//  `CLKAND(ckrcbxpn,ckgridxpn,latrcbenl)
//`endif
//endmodule // soc_rbe_clk_hf
//
////CLKBF_GLITCH_GLOB is a clkbuf used to remove glitches
////It is coded as a buffer, but this doesnot match the schematics.
////NEED TO CHECK IF SYNTHESIS ISNT REPLACING THE CELL WITH A BUFFER
//`define CLKBF_GLITCH_GLOB(clkout, clkin)                          \
//`ifdef DC                                                         \
//   `LIB_CLKBF_GLITCH_GLOB(clkout,clkin)                           \
//`else                                                             \
//   assign clkout = clkin;                                         \
//`endif
//
//`define CLKDIVFF(iffout, iffin, iclockin)             \
//clockdivff \``clockdivff_``iffout (                   \
//                                   .ffout(iffout),    \
//                                   .ffin(iffin),      \
//                                   .clockin(iclockin) \
//);
//
//// creating FF module to be used by clock macros below
//module clockdivff (ffout, ffin, clockin);    
//output ffout;
//input ffin;
//input clockin;
//reg ffout;
//wire ffin, clockin;
//`ifdef DC 
//     wire ffin_b;
//     assign ffin_b = ~ffin;
//     `LIB_clockdivff(ffout, ffin_b, clockin) 
//`else                                                                         
// always @(posedge clockin)                                                
//      begin                                                                  
//         ffout = ffin; /* lintra s-60028 */
//      end 
//`endif
//endmodule
//
//`define MAKE_CLK_GATE_TRUNK(igatedclk, iipclk, iusync, iresetb, iclken, idfx_scan_dbg_mode) \
//   clk_gate_trunk \``clk_gate_trunk_``igatedclk (                                           \
//                                                 .gatedclk(igatedclk),                      \
//                                                 .ipclk(iipclk),                            \
//                                                 .usync(iusync),                            \
//                                                 .resetb(iresetb),                          \
//                                                 .clken(iclken),                            \
//                                                 .dfx_scan_dbg_mode(idfx_scan_dbg_mode)     \
//                                                );
//
//module clk_gate_trunk(output logic gatedclk,
//                      input logic ipclk,
//                      input logic usync,
//                      input logic resetb,
//                      input logic clken,
//                      input logic dfx_scan_dbg_mode);
//logic clken_qual_in, clken_qual_out;
//logic qual_or_ovrd;
//assign clken_qual_in = usync ? clken : clken_qual_out;
//`SET_MSFF(clken_qual_out, clken_qual_in, ipclk, ~resetb)
//assign qual_or_ovrd = clken_qual_out | dfx_scan_dbg_mode;
//`CLK_GATE_HF(gatedclk, ipclk, qual_or_ovrd)
//endmodule
//                                                
//











//`define MAKE_CLK_LOCAL_QUALDIV1TO16_ADJ(qual_out,inclk,inusync,inqualovrd,inratiosel)     \
//clk_qualdiv1to16_adj_local \``clk_qualdiv1to16_adj_local_``qual_out (                           \
//                                                                  .qualclk_out(qual_out),    \
//                                                                  .clk(inclk),               \
//                                                                  .usync(inusync),           \
//                                                                  .qualovrd(inqualovrd),     \
//                                                                  .ratiosel(inratiosel)     \
//                                                                 ); /* lintra s-51500, s-53048, s-53050 */
//
//module clk_qualdiv1to16_adj_local(qualclk_out, clk, usync, qualovrd, ratiosel);
//  output qualclk_out;
//  input clk;
//  input usync;
//  input qualovrd;
//  input [3:0] ratiosel;
//  logic qual_out;
//  `MAKE_QUAL_LOCAL_QUALDIV1TO8_ADJ(qual_out, clk, usync, qualovrd, ratiosel)        
//  `CLK_GATE(qualclk_out, clk,  qual_out)
//endmodule
//
//
//
//`define MAKE_CLK_LOCAL_QUALDIV1TO8_ADJ(qual_out,inclk,inusync,inqualovrd,inratiosel)     \
//clk_qualdiv1to8_adj_local \``clk_qualdiv1to8_adj_local_``qual_out (                           \
//                                                                  .qualclk_out(qual_out),    \
//                                                                  .clk(inclk),               \
//                                                                  .usync(inusync),           \
//                                                                  .qualovrd(inqualovrd),     \
//                                                                  .ratiosel(inratiosel)     \
//                                                                 ); /* lintra s-51500, s-53048, s-53050 */
//module clk_qualdiv1to8_adj_local(qualclk_out, clk, usync, qualovrd, ratiosel);
//  output qualclk_out;
//  input clk;
//  input usync;
//  input qualovrd;
//  input [2:0] ratiosel;
//  logic qual_out;
//  `MAKE_QUAL_LOCAL_QUALDIV1TO8_ADJ(qual_out, clk, usync, qualovrd, ratiosel)        
//  `CLK_GATE(qualclk_out, clk,  qual_out) //lintra s-51557, s-51552
//endmodule
//
//`define MAKE_CLK_NOREN(cknorenout,cknorenckin,cknorenenin)              \
//clknoren \``clknoren_``cknorenout (                                     \
//                              .clknorenout (cknorenout),                \
//                              .clknorenckin (cknorenckin),              \
//                              .clknorenenin (cknorenenin)               \
//                             );
//
//module clknoren(clknorenout,clknorenckin,clknorenenin);
//output clknorenout;
//input clknorenckin;
//input clknorenenin;
//wire clknorenout,clknorenckin,clknorenenin;
//`ifdef DC
//     `LIB_clknoren(clknorenout,clknorenckin,clknorenenin) 
//`else
//assign clknorenout = ~(clknorenckin|clknorenenin);
//`endif
//endmodule
//



//
//`define MAKE_QUAL_LOCAL_QUALDIV16(qual_out, inclk, inusync, inqualovrd)          \
// qualdiv16_local \``qualdiv16_``qual_out (                                       \
//                                         .qualifier_out(qual_out),               \
//                                         .ipinclk(inclk) ,                       \
//                                         .usync(inusync),                        \
//                                         .qualovrd(inqualovrd)                   \
//                                         );
//module qualdiv16_local (qualifier_out,ipinclk,usync,qualovrd);
//  output qualifier_out;
//  input ipinclk;
//  input usync;
//  input qualovrd;
// 
//  logic usync_lat, qual_staged, qual;
//  logic [3:0] nxt;
//  logic [3:0] pst;
// 
//  `LATCH_P_DESKEW(usync_lat, usync, ipinclk)
//  assign nxt = pst + 4'b0001;
//  `RST_MSFF(pst, nxt, ipinclk, usync_lat)
//  assign qual = (&(pst));
//  `MSFF(qual_staged, qual, ipinclk)
//  assign qualifier_out = qual_staged | qualovrd;
//endmodule
//
//`define MAKE_QUAL_LOCAL_QUALDIV1TO16_ADJ(qual_out, inclk, inusync, inqualovrd, inratiosel)     \
// qualdiv1to16_adj_local \``qualdiv1to16adj_``qual_out (                                         \
//                                                    .qualifier_out(qual_out),                 \
//                                                    .ipinclk(inclk) ,                         \
//                                                    .usync(inusync),                          \
//                                                    .qualovrd(inqualovrd),                    \
//                                                    .ratiosel(inratiosel)                     \
//                                                    );
///* lintra s-51500, s-53048, s-53050 */
//module qualdiv1to16_adj_local (qualifier_out,ipinclk,usync,qualovrd,ratiosel);
//  output qualifier_out;
//  input ipinclk;
//  input usync;
//  input qualovrd;
//  input [3:0] ratiosel;
// 
//  logic usync_or_qual_lat, usync_or_qual, qual_staged, qual;
//  logic [3:0] ratiosel_muxed_staged, ratiosel_muxed;
//  logic [3:0] nxt;
//  logic [3:0] pst;
// 
//  //Whenever a qual or usync comes through we reset the counter
//  assign usync_or_qual = usync | qual;
//
//  `LATCH_P_DESKEW(usync_or_qual_lat, usync_or_qual, ipinclk)
//  assign nxt = pst + 4'b0001;
//  `RST_MSFF(pst, nxt, ipinclk, usync_or_qual_lat)
//
//  //only grab ratiosel on usync boundary
//  assign ratiosel_muxed = usync ? ratiosel : ratiosel_muxed_staged;
//  `MSFF(ratiosel_muxed_staged, ratiosel_muxed, ipinclk)
//
//  //Once we've reached the count that matches the ratiosel we're dividing by
//  //Set the qual indicator and reset the count
//  assign qual = (pst == ratiosel_muxed_staged);
//
//  `MSFF(qual_staged, qual, ipinclk)
//  assign qualifier_out = qual_staged | qualovrd;
//endmodule // qualdiv1to16_adj_local
//
//`define MAKE_QUAL_LOCAL_QUALDIV1TO8_ADJ_WEN(qual_out, inclk, inusync, inqualovrd, inratiosel, inenable)     \
// qualdiv1to8_adj_wen_local \``qualdiv1to8adjwen_``qual_out (                                         \
//                                                    .qualifier_out(qual_out),                 \
//                                                    .ipinclk(inclk) ,                         \
//                                                    .usync(inusync),                          \
//                                                    .qualovrd(inqualovrd),                    \
//                                                    .ratiosel(inratiosel),                    \
//                                                    .enable(inenable)                         \
//                                                    );
///* lintra s-51500, s-53048, s-53050 */
//module qualdiv1to8_adj_wen_local (qualifier_out,ipinclk,usync,qualovrd,ratiosel,enable);
//  output qualifier_out;
//  input ipinclk;
//  input usync;
//  input qualovrd;
//  input [2:0] ratiosel;
//  input enable;
// 
//  logic usync_or_qual_lat, usync_or_qual, qual_staged, qual;
//  logic [2:0] ratiosel_muxed_staged, ratiosel_muxed;
//  logic [2:0] nxt;
//  logic [2:0] pst;
// 
//  //Whenever a qual or usync comes through we reset the counter
//  assign usync_or_qual = usync | qual;
//
//  `LATCH_P_DESKEW(usync_or_qual_lat, usync_or_qual, ipinclk)
//  assign nxt = pst + 1;
//  `RST_MSFF(pst, nxt, ipinclk, usync_or_qual_lat)
//
//  //only grab ratiosel on usync boundary
//  assign ratiosel_muxed = usync ? ratiosel : ratiosel_muxed_staged;
//  `MSFF(ratiosel_muxed_staged, ratiosel_muxed, ipinclk)
//
//  //Once we've reached the count that matches the ratiosel we're dividing by
//  //Set the qual indicator and reset the count
//  assign qual = (pst == ratiosel_muxed_staged);
//
//  `MSFF(qual_staged, qual, ipinclk)
//  assign qualifier_out = (qual_staged & enable) | qualovrd;
//endmodule // qualdiv1to8_adj_wen_local
//
//
////module qual_5_2(
//                input usync_fast_clk,
//                input fast_clk,
//                output fast_qual,
//                output slow_qual
//                );
//   reg [2:0]           count;
//
//   always@(posedge fast_clk)
//     if(usync_fast_clk)
//       count <= 3'b000;
//     else
//       count <= (count + 3'b001) & {3{~(count == 4)}};
//
//   assign              fast_qual = (count == 0  ||
//                                    count == 3);
//   assign              slow_qual = 1'b1;
//endmodule //qual_5_2
//
//
//module qual_1_1(
//                input usync_fast_clk,
//                input fast_clk,
//                output fast_qual,
//                output slow_qual
//                );
//  
//   assign              fast_qual = 1'b1;
//   assign              slow_qual = 1'b1;
//endmodule // qual_1_1
//
//module qual_4_3(
//                input usync_fast_clk,
//                input fast_clk,
//                output fast_qual,
//                output slow_qual
//                );
//   reg [1:0]           count;
//
//   always@(posedge fast_clk)
//     if(usync_fast_clk)
//       count <= 0;
//     else
//       count <= count + 1;
//
//   assign              fast_qual = ~(count == 2);
//   assign              slow_qual = 1'b1;
//endmodule // qual_4_3
//
//module qual_8_5(
//                input usync_fast_clk,
//                input fast_clk,
//                output fast_qual,
//                output slow_qual
//                );
//   reg [2:0]           count;
//   always@(posedge fast_clk)
//     if(usync_fast_clk)
//       count <= 0;
//     else
//       count <= count + 1;
//   assign              fast_qual = (count == 0 ||
//                                    count == 2 ||
//                                    count == 3 ||
//                                    count == 5 ||
//                                    count == 6);
//   assign              slow_qual = 1'b1;
//endmodule // qual_8_5
//
//module qual_2_1(
//                input usync_fast_clk,
//                input fast_clk,
//                output fast_qual,
//                output slow_qual
//                );
//   reg                 count;
//
//   always@(posedge fast_clk)
//     if(usync_fast_clk)
//       count <= 0;
//     else
//       count <= count + 1;
//
//   assign              fast_qual = count == 0;
//   assign              slow_qual = 1'b1;
//endmodule // qual_2_1
//
//module qual_16_7(
//                input usync_fast_clk,
//                input fast_clk,
//                output fast_qual,
//                output slow_qual
//                );
//   reg [3:0]           count;
//   always@(posedge fast_clk)
//     if(usync_fast_clk)
//       count <= 0;
//     else
//       count <= count + 1;
//   assign              fast_qual = (count == 0  ||
//                                    count == 2  ||
//                                    count == 5  ||
//                                    count == 7  ||
//                                    count == 9  ||
//                                    count == 11 ||
//                                    count == 14);
//   assign              slow_qual = 1'b1;
//endmodule // qual_16_7
//
//module qual_8_3(
//                input usync_fast_clk,
//                input fast_clk,
//                output fast_qual,
//                output slow_qual
//                );
//   reg [2:0]           count;
//   always@(posedge fast_clk)
//     if(usync_fast_clk)
//       count <= 0;
//     else
//       count <= count + 1;
//   assign              fast_qual = (count == 0 ||
//                                    count == 3 ||
//                                    count == 5);
//   assign              slow_qual = 1'b1;
//endmodule // qual_8_3
//
//module qual_16_5(
//                input usync_fast_clk,
//                input fast_clk,
//                output fast_qual,
//                output slow_qual
//                );
//   reg [3:0]           count;
//   always@(posedge fast_clk)
//     if(usync_fast_clk)
//       count <= 0;
//     else
//       count <= count + 1;
//   assign              fast_qual = (count == 0  ||
//                                    count == 3  ||
//                                    count == 6  ||
//                                    count == 10 ||
//                                    count == 13);
//   assign              slow_qual = 1'b1;
//endmodule // qual_16_5
//
//module qual_4_1(
//                input usync_fast_clk,
//                input fast_clk,
//                output fast_qual,
//                output slow_qual
//                );
//   reg [1:0]           count;
//
//   always@(posedge fast_clk)
//     if(usync_fast_clk)
//       count <= 0;
//     else
//       count <= count + 1;
//
//   assign              fast_qual = count == 0;
//   assign              slow_qual = 1'b1;
//endmodule // qual_4_1
//
//module qual_5_3(
//                input usync_fast_clk,
//                input fast_clk,
//                output fast_qual,
//                output slow_qual
//                );
//   reg [2:0]           count;
//
//   always@(posedge fast_clk)
//     if(usync_fast_clk)
//       count <= 0;
//     else
//       count <= (count + 1) & {3{~(count == 4)}};
//
//   assign              fast_qual = (count == 1  ||
//                                    count == 2  ||
//                                    count == 4);
//   assign              slow_qual = 1'b1;
//endmodule // qual_5_3
//
//
//
//module det_clkdomainX_with_usync #(parameter dWidth = 32, parameter fifo_depth = 10, parameter separation = 2) 
//// aamshall: for synchronization that's done between two clocks that are derived from the same reference clock and use separation 1,
//// this synchronizer must initiate it's rd/wr pointers at usync and not at reset!
//// otherwise separation is not ensured.
//// module det_clkdomainX must be abandoned and only this module det_clkdomainX_with_usync must be used.
//                     (
//                      input reset_ckRd,
//                      input reset_ckWr,
//                      input ckWr,
//                      input ckRd,
//                      input qualWr,
//                      input qualRd,
//                    input first_usyncWr,
//                    input first_usyncRd,
//                      input [dWidth-1:0] data_in,
//                      output [dWidth-1:0] data_out
//                      );
//
//   logic [dWidth-1:0] det_clkdomainX_write_data_array[fifo_depth - 1:0];
//   logic [dWidth-1:0] det_clkdomainX_read_data_mux;
//   logic [fifo_depth - 1:0] wrptr;
//   logic [fifo_depth - 1:0] rdptr;
//   logic [fifo_depth - 1:0] start_ptr;
//   logic write_clk;
//   logic read_clk;
//
//   `CLK_GATE(write_clk, ckWr, qualWr)
//   `CLK_GATE(read_clk, ckRd, qualRd)
//  
//   // data path generation
//   always@(posedge write_clk or negedge reset_ckWr)
//     begin: write_clk_scope
//        integer i;
//        if (~reset_ckWr)
//          begin
//             for (i=0;i<fifo_depth;i=i+1)
//               begin
//                  det_clkdomainX_write_data_array[i] <= 0;
//               end
//          end
//        else
//          begin
//             for (i=0;i<fifo_depth;i=i+1)
//               begin
//                  if (wrptr[i])
//                    det_clkdomainX_write_data_array[i] <= data_in;
//               end
//          end
//     end
//
//   always@(posedge read_clk or negedge reset_ckRd)
//     begin: read_clk_scope
//        integer i;
//        if (~reset_ckRd)
//          begin
//             det_clkdomainX_read_data_mux <= 0;
//          end
//        else
//          begin
//             for (i=0;i<fifo_depth;i=i+1)
//               begin
//                  if (rdptr[i])
//                    det_clkdomainX_read_data_mux <= det_clkdomainX_write_data_array[i];
//               end
//          end
//     end
//
//   assign data_out = det_clkdomainX_read_data_mux;
//
//   // wrptr and rdptr generation
//   assign start_ptr = 1;
//   
//   always@(posedge write_clk or negedge reset_ckWr)
//     if(!reset_ckWr)
//       wrptr <= start_ptr << separation;
//     else if (first_usyncWr)
//       wrptr <= start_ptr << separation;
//     else
//       wrptr <= {wrptr[(fifo_depth - 2):0], wrptr[(fifo_depth - 1)]};
//
//   always@(posedge read_clk or negedge reset_ckRd)
//     if(!reset_ckRd)
//       rdptr <= start_ptr;
//     else if (first_usyncRd)
//       rdptr <= start_ptr;
//     else
//       rdptr <= {rdptr[(fifo_depth - 2):0], rdptr[(fifo_depth - 1)]};
//
//endmodule // det_clkdomainX_with_usync
//
