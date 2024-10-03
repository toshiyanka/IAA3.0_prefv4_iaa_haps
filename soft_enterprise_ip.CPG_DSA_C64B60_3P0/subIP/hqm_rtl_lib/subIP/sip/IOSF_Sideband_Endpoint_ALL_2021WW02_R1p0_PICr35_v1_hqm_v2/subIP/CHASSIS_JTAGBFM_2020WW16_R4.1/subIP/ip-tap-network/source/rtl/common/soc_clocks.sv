//=============================================================================
//  Copyright (c) 2008 Intel Corporation, all rights reserved.
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY
//  COPYRIGHT LAWS AND IS CONSIDERED A TRADE SECRET BELONGING
//  TO THE INTEL CORPORATION.
//
//  Intel Confidential
//=============================================================================
//
// MOAD Begin
//     File/Block                          : soc_clocks.sv
//     Block Type [hier|fub|shared|inst]   : shared
//     Design Style [rls|sdp|custom]       : none
//     Circuit Style [rfs|ssa|IO|ROM|other]: <circuit_style>
//     Collateral DB [pvx|na]              : <db>
//     Fub Type [fub|fubp]                 : <fub_type>
//     Unit                                : none
// MOAD End
//  
// Design Unit Owner : Martin.J.Licht@intel.com
// Primary Contact   : Aditi.D.Gore@intel.com
//
//=============================================================================
//
// Description:
//   <Enter Description Here>
//
//=============================================================================
`ifndef SOC_CLOCKS_VS
`define SOC_CLOCKS_VS
  
// Needed because we use the LATCH macro below.
//
`include "vlv_macro_tech_map.vh"
`include "soc_macros.sv"
//`include "pnw_macro_tech_map.vh"

//****************************************************************************************
//*****The module/Macro combination allows backend to see names for module instance names
//*****and the Macro allows usage without specific pin mapping IE (.a(a)) since it is
//*****just based on ordering of I/Os
//****************************************************************************************



// Clock buffer for "clocks in the datapath".  Usage of this macro requires a waiver.
`define CLKAND_DP(outclk,inclk, enable)                                          \
   always_comb outclk <= inclk & enable; /* novas s-50003, s-51500, s-51503 */   \

`define CLKAND(outclk,inclk,enable)                                                          \
`ifdef DC                                                                                    \
      `LIB_SOC_CLKAND(outclk,inclk,enable)                                                   \
`else                                                                                        \
   assign outclk = inclk & enable; /* novas s-50004, s-51500 */                              \
`endif 

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


`define MAKE_CLKOR(clkorout,clkorin1,clkorin2)                    \
clkor \``clkor_``clkorout  (                                      \
                          .ckoout (clkorout),                     \
                          .ckoin1 (clkorin1),                     \
                          .ckoin2 (clkorin2)                      \
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

`define MAKE_CLK_OREN(ckorenout,ckorenckin,ckorenenin)              \
clkoren \``clkoren_``ckorenout (                                    \
                              .clkorenout (ckorenout),              \
                              .clkorenckin (ckorenckin),            \
                              .clkorenenin (ckorenenin)             \
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


`define MAKE_CLK_NOREN(cknorenout,cknorenckin,cknorenenin)              \
clknoren \``clknoren_``cknorenout (                                     \
                              .clknorenout (cknorenout),                \
                              .clknorenckin (cknorenckin),              \
                              .clknorenenin (cknorenenin)               \
                             );

module clknoren(clknorenout,clknorenckin,clknorenenin);
output clknorenout;
input clknorenckin;
input clknorenenin;
wire clknorenout,clknorenckin,clknorenenin;
`ifdef DC
     `LIB_clknoren(clknorenout,clknorenckin,clknorenenin) 
`else
assign clknorenout = ~(clknorenckin|clknorenenin);
`endif
endmodule


// module clkinv declared before
`define MAKE_CLK_INV(ckinvout,ckinvin)             \
clkinv \``clkinv_``ckinvout (                        \
                           .clkout (ckinvout),     \
                           .clkin (ckinvin)        \
                          );

`define CLKINV(clkinvout,clkinvin)                              \
`ifdef DC                                                                    \
    `LIB_CLKINV_SOC(clkinvout,clkinvin) \
 `else                                                                       \
     assign clkinvout =  (~(clkinvin));                                      \
 `endif
   
`define CLK_GATE(o, clk, a)  \
 soc_rbe_clk \``soc_rbe_clk_``o (                                                           \
                                  .ckrcbxpn  (o),                                            \
                                  .ckgridxpn (clk),                                          \
                                  .latrcben  (a)                                             \
                                );

`define CLK_GATE_W_OVERRIDE(o, clk, pwrgate, override)  \
 clk_gate_kin \``clk_gate_kin_``o (                                                        \
                                  .ckrcbxpn1  (o),                                           \
                                  .ckgridxpn1 (clk),                                         \
                                  .latrcben1  (pwrgate),                                     \
                                  .testen1    (override)                                     \
                                );
//SAME as LS_WITH_AND_FW from soc_macros.sv but created seperate version
//for different checking on clocks. Still same library cell though.
`define LS_WITH_AND_FW_CLK(o, pro, a, vcc_in, en)                                                 \
`ifdef DC                                                                                         \
     `LIB_LS_WITH_AND_FW(o, pro, a, vcc_in, en)                                                   \
`else                                                                                             \
     assign o = a & {$bits(o){en}};   /* novas s-55000, s-55019 */                                \
`endif 

//SAME as FIREWALL_AND from soc_macros.sv but created seperate version
//for different checking on clocks. Still same library cell though.
`define FIREWALL_AND_CLK(out,data,enable)                                               \
`ifdef DC                                                                           \
   `LIB_FIREWALL_AND(out,data,enable)                                               \
`else                                                                               \
   `ifdef MACRO_ATTRIBUTE                                                           \
      (* macro_attribute = `"FIREWALL_AND_CLK(out``,data``,enable``)`" *)               \
   `endif                                                                           \
   assign out = data & {$bits(out){enable}}; /* novas s-55000, s-55006 */           \
`endif

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


`define MAKE_CLK_2TO1MUX(clkmuxout,clkmuxin1,clkmuxin2,clkmuxselect)     \
 clk2to1mux \``clk2to1mux_``clkmuxout (                                    \
                                     .ckmuxout (clkmuxout),              \
                                     .ckin1    (clkmuxin1),              \
                                     .ckin2    (clkmuxin2),              \
                                     .muxselect(clkmuxselect)            \
                                    );

`define MAKE_CLK_GLITCHFREE_MUX_PART(clkout, clka, clkb, sela, selb)             \
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

module clk_glitchfree_mux (clk_out, sel_clka, usync_clka, clka_in, usync_clkb, clkb_in, resetb_in, scan_mode_in);
output clk_out;
input  sel_clka;
input  usync_clka;
input  clka_in;
input  usync_clkb;
input  clkb_in;
input  scan_mode_in;
input resetb_in;
logic sel_a_muxed, sel_a_muxed_h, sel_a_or_scan_l, sel_b_muxed, sel_b_muxed_h, sel_b_or_scan_l;
logic sel_a_or_scan, sel_b_or_scan;
assign sel_a_muxed = usync_clka ?  sel_clka : sel_a_muxed_h;
assign sel_b_muxed = usync_clkb ? ~sel_clka : sel_b_muxed_h;
`ASYNC_SET_MSFF(sel_a_muxed_h, sel_a_muxed, clka_in, ~resetb_in)
`ASYNC_RST_MSFF(sel_b_muxed_h, sel_b_muxed, clkb_in, ~resetb_in)
assign sel_a_or_scan = scan_mode_in ? sel_clka  : sel_a_muxed_h;
assign sel_b_or_scan = scan_mode_in ? ~sel_clka : sel_b_muxed_h;
`MAKE_CLK_GLITCHFREE_MUX_PART(clk_out, clka_in, clkb_in, sel_a_or_scan, sel_b_or_scan)
endmodule


// MAKE_CLK_GLITCHFREE_MUX handles only single bit inputs 
`define MAKE_CLK_GLITCHFREE_MUX(clkout, selclka, usyncclka, clka, usyncclkb, clkb, resetb, scan_mode) \
clk_glitchfree_mux \clk_glitchfree_mux``clkout (                                \
                                                .clk_out       (clkout),         \
                                                .sel_clka      (selclka),        \
                                                .usync_clka    (usyncclka),      \
                                                .clka_in       (clka),           \
                                                .usync_clkb    (usyncclkb),      \
                                                .clkb_in       (clkb),           \
                                                .resetb_in     (resetb),         \
                                                .scan_mode_in  (scan_mode)       \
                                                );


// **************************************************************************************************** //
// ****************************   High Frequency Macro      ******************************************* //
// **************************************************************************************************** //

`define CLK_GATE_HF(o, clk, a)                                                               \
 soc_rbe_clk_hf \``soc_rbe_clk_hf_``o (                                                      \
                                       .ckrcbxpn  (o),                                       \
                                       .ckgridxpn (clk),                                     \
                                       .latrcben  (a)                                        \
                                      );

module soc_rbe_clk_hf (output logic ckrcbxpn, input logic ckgridxpn, latrcben);  //novas s-51506

`ifdef DC
     `LIB_soc_rbe_clk_hf(ckrcbxpn,ckgridxpn,latrcben) 
`else
   logic latrcbenl; // rce state element
  
  `LATCH_P(latrcbenl, latrcben, ckgridxpn) //novas s-51552
  `CLKAND(ckrcbxpn,ckgridxpn,latrcbenl)
`endif
endmodule // soc_rbe_clk_hf

// *******************************************************************************************************

`define MAKE_CLK_GATE_TRUNK(igatedclk, iipclk, iusync, iresetb, iclken, idfx_scan_dbg_mode) \
   clk_gate_trunk \``clk_gate_trunk_``igatedclk (                                           \
                                                 .gatedclk(igatedclk),                      \
                                                 .ipclk(iipclk),                            \
                                                 .usync(iusync),                            \
                                                 .resetb(iresetb),                          \
                                                 .clken(iclken),                            \
                                                 .dfx_scan_dbg_mode(idfx_scan_dbg_mode)     \
                                                );

module clk_gate_trunk(output logic gatedclk,
                      input logic ipclk,
                      input logic usync,
                      input logic resetb,
                      input logic clken,
                      input logic dfx_scan_dbg_mode);
logic clken_qual_in, clken_qual_out;
logic qual_or_ovrd;
assign clken_qual_in = usync ? clken : clken_qual_out;
`SET_MSFF(clken_qual_out, clken_qual_in, ipclk, ~resetb)
assign qual_or_ovrd = clken_qual_out | dfx_scan_dbg_mode;
`CLK_GATE_HF(gatedclk, ipclk, qual_or_ovrd)
endmodule

`define MAKE_CLK_GATE_TYPE1(igatedipclk, ipulse_shaper, idfx_scan_enable, idfx_atpg_mode, iresetb, idfx_global_en, idfx_global_override, iselect_ip_clk, iip_clk, idfx_pulse_cfg, iscan_shift_clk, iusync, iusync_override, iedt_update) \
   clk_gate1 \``clkgate_type1_``igatedipclk (   /* novas s-52522, s-52002, s-90001 */\
      .gatedipclk       (igatedipclk),                                             \
      .pulse_shaper     (ipulse_shaper),                                           \
      .dfx_scan_enable  (idfx_scan_enable),                                        \
      .dfx_atpg_mode    (idfx_atpg_mode),                                          \
      .resetb           (iresetb),                                                 \
      .dfx_global_en    (idfx_global_en),                                          \
      .dfx_global_override      (idfx_global_override),                            \
      .select_ip_clk    (iselect_ip_clk),                                          \
      .ip_clk           (iip_clk),                                                 \
      .dfx_pulse_cfg    (idfx_pulse_cfg),                                          \
      .scan_shift_clk   (iscan_shift_clk),                                         \
      .usync            (iusync),                                                  \
      .usync_override   (iusync_override),                                         \
      .edt_update       (iedt_update));

module clk_gate1 (output logic gatedipclk,
                  output logic pulse_shaper,
                  input logic dfx_scan_enable,
                  input logic dfx_atpg_mode, 
                  input logic resetb,
                  input logic dfx_global_en,
                  input logic dfx_global_override,
                  input logic select_ip_clk,
                  input logic ip_clk,
                  input logic [2:0] dfx_pulse_cfg,
                  input logic scan_shift_clk,
                  input logic usync,
                  input logic usync_override,
                  input logic edt_update);
   logic muxsel, temp1, temp2, temp3, temp4, temp5, temp6, temp2_d;
   logic [8:0] global_en_d;
   logic [7:0] temp;
  assign muxsel = dfx_scan_enable & dfx_atpg_mode;
  always@(posedge ip_clk)
    global_en_d <= {dfx_global_en, global_en_d[8:1]};
  always_comb
    begin
       integer i;
       for (i=0; i<=7; i++)
        begin
          temp[i] = ~global_en_d[0] & global_en_d[i+1];
        end
       temp1 = temp[dfx_pulse_cfg];
    end // UNMATCHED !!

   assign pulse_shaper = temp1;
   
    assign temp2 = ((usync | usync_override) & (dfx_global_en | dfx_global_override)) |
                   (!(usync | usync_override) & temp2_d);
   

  `SET_MSFF(temp2_d, temp2, ip_clk, ~resetb)

  assign temp3 = dfx_atpg_mode ? temp1 : temp2_d;
  assign temp4 = temp3 & select_ip_clk;
 
  `CLKAND(temp5,scan_shift_clk,~edt_update)

`CLK_GATE(temp6,ip_clk,temp4)

  `MAKE_CLK_2TO1MUX(gatedipclk, temp6, temp5, muxsel)

endmodule


`define MAKE_CLK_GATE_TYPE2(igatedipclk, ipulse_shaper, idfx_scan_enable, idfx_atpg_mode, iresetb, idfx_global_en, idfx_global_override, icoreclk, iselect_ip_clk, idfx_pulse_cfg, iscan_shift_clk, iusync, iusync_override, iedt_update, iclk_pwr_en)  \
   clk_gate2  \``clkgate_type2_``igatedipclk ( /* novas s-52522, s-52002, s-90001 */    \
        .gatedipclk         (igatedipclk),                                              \
        .pulse_shaper       (ipulse_shaper),                                            \
        .dfx_scan_enable    (idfx_scan_enable),                                         \
        .dfx_atpg_mode      (idfx_atpg_mode),                                           \
        .resetb             (iresetb),                                                  \
        .dfx_global_en      (idfx_global_en),                                           \
        .dfx_global_override(idfx_global_override),                                     \
        .coreclk            (icoreclk),                                                 \
        .select_ip_clk      (iselect_ip_clk),                                           \
        .dfx_pulse_cfg      (idfx_pulse_cfg),                                           \
        .scan_shift_clk     (iscan_shift_clk),                                          \
        .usync              (iusync),                                                   \
        .usync_override     (iusync_override),                                          \
        .edt_update         (iedt_update),                                              \
        .clk_pwr_en         (iclk_pwr_en));

module clk_gate2  (output logic gatedipclk,
                   output logic pulse_shaper,
                   input logic dfx_scan_enable,
                   input logic dfx_atpg_mode, 
                   input logic resetb,
                   input logic dfx_global_en,
                   input logic dfx_global_override,
                   input logic coreclk,
                   input logic select_ip_clk,
                   input logic [2:0] dfx_pulse_cfg,
                   input logic scan_shift_clk,
                   input logic usync, 
                   input logic usync_override, 
                   input logic edt_update,
                   input logic clk_pwr_en);

  logic muxsel, temp1, temp2, temp2_d, 
        temp3, temp4, temp5, temp6, temp7, temp7_d;
  logic [8:0] global_en_d;
  logic [7:0] temp;
  assign muxsel = dfx_scan_enable & dfx_atpg_mode;
  always@(posedge coreclk)
    global_en_d <= {dfx_global_en, global_en_d[8:1]};
  always_comb
      begin
      integer i;              
      for (i=0; i<=7; i++)
        begin
          temp[i] = ~global_en_d[0] & global_en_d[i+1];
        end
         temp1 = temp[dfx_pulse_cfg];
      end // UNMATCHED !!

   assign pulse_shaper = temp1;
   
  assign temp2 = ((usync | usync_override) & (dfx_global_en | dfx_global_override)) |
                 (!(usync | usync_override) & temp2_d);
  assign temp7 = (clk_pwr_en & (usync | usync_override)) |
                 (!(usync | usync_override) & temp7_d);
                   
  `SET_MSFF(temp2_d, temp2, coreclk, ~resetb)
  `SET_MSFF(temp7_d, temp7, coreclk, ~resetb)
                   
  assign temp3 = dfx_atpg_mode ? temp1 : temp2_d;
  assign temp4 = temp3 & select_ip_clk & (temp7_d | dfx_atpg_mode);
 
  `CLKAND(temp5,scan_shift_clk,~edt_update)

`CLK_GATE(temp6,  coreclk, temp4)

  `MAKE_CLK_2TO1MUX(gatedipclk, temp6, temp5, muxsel)

endmodule 

`define MAKE_CLK_GATE_TYPE3(igatedipclk, iresetb, idfx_global_en, idfx_global_override, iip_clk, idfx_atpg_mode, iselect_ip_clk, iusync, iusync_override) \
   clk_gate3 \``clkgate_type3_``igatedipclk (   /* novas s-52522, s-52002, s-90001 */                          \
        .gatedipclk     (igatedipclk), \
        .resetb         (iresetb), \
        .dfx_global_en  (idfx_global_en), \
        .dfx_global_override    (idfx_global_override), \
        .ip_clk (iip_clk), \
        .dfx_atpg_mode  (idfx_atpg_mode), \
        .select_ip_clk  (iselect_ip_clk), \
        .usync          (iusync), \
        .usync_override (iusync_override));

module clk_gate3 (output logic gatedipclk,
                  input logic resetb, 
                  input logic dfx_global_en,
                  input logic dfx_global_override,
                  input logic ip_clk, 
                  input logic dfx_atpg_mode,
                  input logic select_ip_clk,
                  input logic usync,
                  input logic usync_override);
  logic temp, temp1, temp_d;
  logic temp2;


  assign temp1 =  ~dfx_atpg_mode &
                  select_ip_clk &
                  temp_d;

  assign temp = ((usync | usync_override) & (dfx_global_en | dfx_global_override)) |
                (!(usync | usync_override) & temp_d);

  `SET_MSFF(temp_d, temp, ip_clk, ~resetb)

`CLK_GATE(gatedipclk,  ip_clk, temp1)
   
endmodule

`define MAKE_CLK_GATE_TYPE3_EXT(igatedipclk, idfx_global_en, idfx_global_override, iip_clk, idfx_atpg_mode, iselect_ip_clk) \
   clk_gate3_ext \``clkgate_type3_ext_``igatedipclk (   /* novas s-52522, s-52002, s-90001 */                          \
        .gatedipclk     (igatedipclk), \
        .dfx_global_en  (idfx_global_en), \
        .dfx_global_override    (idfx_global_override), \
        .ip_clk (iip_clk), \
        .dfx_atpg_mode  (idfx_atpg_mode), \
        .select_ip_clk  (iselect_ip_clk));

module clk_gate3_ext (output logic gatedipclk,
                      input logic dfx_global_en,
                      input logic dfx_global_override,
                      input logic ip_clk, 
                      input logic dfx_atpg_mode,
                      input logic select_ip_clk);
logic select_ipclk_qual;
assign select_ipclk_qual = (dfx_global_en | dfx_global_override) & 
                           ~dfx_atpg_mode                        &
                           select_ip_clk;
`CLK_GATE(gatedipclk, ip_clk, select_ipclk_qual) 
endmodule


`define MAKE_LOC_OVERRIDE(itest_override, idfx_ip_override, iscan_en) \
        make_loc_override \``loc_override_``itest_override ( \
                .test_override          (itest_override), \
                .dfx_ip_override        (idfx_ip_override), \
                .scan_en                (iscan_en) \
        );

module make_loc_override (output logic test_override, input logic dfx_ip_override, scan_en);
        assign test_override = dfx_ip_override || scan_en;
endmodule

`define MAKE_CLK_LOC_SOC(igatedclk, iipclk, itest_override, ilocal_function_gating, ilocal_power_gating, ilocal_power_gating_override) \
   clk_loc \``clk_loc_``igatedclk ( \
                                 .gatedclk (igatedclk), \
                                 .ipclk (iipclk), \
                                 .test_override (itest_override) , \
                                 .local_function_gating (ilocal_function_gating), \
                                 .local_power_gating (ilocal_power_gating), \
                                 .local_power_gating_override (ilocal_power_gating_override));  


module clk_loc (output logic gatedclk, input logic ipclk, test_override, local_function_gating, local_power_gating, local_power_gating_override);
                     logic latout;
                     logic func_en;

  assign func_en = (local_power_gating | local_power_gating_override) & local_function_gating ;
  `CLK_GATE_W_OVERRIDE(gatedclk, ipclk, func_en, test_override)
endmodule

`define MAKE_CLK_LOC_LPSCAN(igatedclk, iipclk, itest_override, ifunc_en, ipwr_en, ipwr_ovrd, idfx_force_off) \
clk_loc_lpscan \``clk_loc_lpscan_``igatedclk (                                                               \
                                              .gatedclk(igatedclk),                                          \
                                              .ipclk(iipclk),                                               \
                                              .test_override(itest_override),                               \
                                              .func_en(ifunc_en),                                           \
                                              .pwr_en(ipwr_en),                                             \
                                              .pwr_ovrd(ipwr_ovrd),                                         \
                                              .dfx_force_off(idfx_force_off)                                \
                                              );

module clk_loc_lpscan (output logic gatedclk, input logic ipclk, input logic test_override, input logic func_en, input logic pwr_en, input logic pwr_ovrd, input logic dfx_force_off);
logic lat_in;
assign lat_in = (((pwr_en | pwr_ovrd) & func_en) | test_override ) & dfx_force_off;
`CLK_GATE(gatedclk, ipclk, lat_in)
endmodule

//Note: please make sure there is no space if you concatenate several individual signals as input bus when use the following macro
//Bad:  `MAKE_SCANEN_FINAL(dfx_local_se, {vedclk_local_se, coreclk_local_se})
//Good: `MAKE_SCANEN_FINAL(dfx_local_se, {vedclk_local_se,coreclk_local_se})
//Good: assign temp_bus_se={vedclk_local_se, coreclk_local_se}; `MAKE_SCANEN_FINAL(dfx_local_se, temp_bus_se)
`define MAKE_SCANEN_FINAL(iscanen_out, iscanen_in) \
    localparam  \``width_``iscanen_in  = $bits({iscanen_in});     \
    logic [\``width_``iscanen_in  -1:0]  \``packed_``iscanen_in ; \
    assign \``packed_``iscanen_in  ={>>{iscanen_in}};             \
    make_scanen_final  #(\``width_``iscanen_in ) \``iscanen_out``_scanen_final (.scanen_out_final(iscanen_out), .vector_in(\``packed_``iscanen_in ));

module make_scanen_final(scanen_out_final, vector_in);
output scanen_out_final;
parameter width=100;
logic scanen_out_final;
input [width-1:0] vector_in;
logic [width-1:0] vector_in;
    assign scanen_out_final = &vector_in;
endmodule // make_scanen_final

`define MAKE_ATSPEED_SE(ilocal_scan_en, idfx_scan_en, igatedipclk, ilos_mode) \
        make_atspeed_se \``make_atspeedse_``ilocal_scan_en ( \
                                               .local_scan_en   (ilocal_scan_en), \
                                               .dfx_scan_en     (idfx_scan_en), \
                                               .gatedipclk      (igatedipclk), \
                                               .los_mode        (ilos_mode)); 

module make_atspeed_se(output logic local_scan_en, input logic dfx_scan_en, gatedipclk, los_mode);
  logic temp;
  `MSFF(temp, dfx_scan_en, gatedipclk)
  assign local_scan_en = los_mode ? (dfx_scan_en | temp) : dfx_scan_en;
endmodule

`define MAKE_SCAN_ARRAY_EN(iscanen_wr_out, iscanen_rd_out, ipulse_shaper, iipclk) \
make_scan_array_en \``make_scan_array_en_``iscanen_wr_out ( \
                                       .scanen_wr_out  (iscanen_wr_out), \
                                       .scanen_rd_out  (iscanen_rd_out), \
                                       .pulse_shaper   (ipulse_shaper), \
                                       .ipclk          (iipclk) \
                                       );

module make_scan_array_en(output scanen_wr_out, scanen_rd_out, input pulse_shaper, ipclk);
   logic temp, temp1;
   assign temp = scanen_wr_out & pulse_shaper;
   `MSFF(temp1,temp, ipclk)
   assign scanen_wr_out = ~temp1;
   assign scanen_rd_out = temp1;
endmodule // make_scan_array_en


module clk_gate_kin (output logic ckrcbxpn1, input logic ckgridxpn1, latrcben1, testen1);  //novas s-51506
`ifdef DC
     `LIB_clk_gate_kin(ckrcbxpn1,ckgridxpn1,latrcben1,testen1) 
`else
   logic latrcbenl1; // rce state element
   logic cken_int;
   assign cken_int = latrcben1|testen1;
   `LATCH_P(latrcbenl1,cken_int,ckgridxpn1)                            
   `CLKAND(ckrcbxpn1,ckgridxpn1,latrcbenl1)
`endif
endmodule

// RBE clock ANDing logic.
//
module soc_rbe_clk (output logic ckrcbxpn, input logic ckgridxpn, latrcben);  //novas s-51506

`ifdef DC
     `LIB_soc_rbe_clk(ckrcbxpn,ckgridxpn,latrcben) 
`else
   logic latrcbenl; // rce state element
  
  `LATCH_P(latrcbenl, latrcben, ckgridxpn) //novas s-51552
  `CLKAND(ckrcbxpn,ckgridxpn,latrcbenl)
`endif
endmodule // soc_rbe_clk

// New clock buffer macro
`define CLKBF(clkbufout,clkbufin)                              \
`ifdef DC                                                                  \
     `LIB_CLKBF_SOC(clkbufout,clkbufin) \
 `else                                                                     \
     assign clkbufout =  (~(~(clkbufin)));                                 \
 `endif

//CLKBF_GLITCH_GLOB is a clkbuf used to remove glitches
//It is coded as a buffer, but this doesnot match the schematics.
//NEED TO CHECK IF SYNTHESIS ISNT REPLACING THE CELL WITH A BUFFER
`define CLKBF_GLITCH_GLOB(clkout, clkin)                          \
`ifdef DC                                                         \
   `LIB_CLKBF_GLITCH_GLOB(clkout,clkin)                           \
`else                                                             \
   assign clkout = clkin;                                         \
`endif

///============================================================================================
///
// LCP delay element macro
///===========================================================================================

module lcp_dly_elmt (clklcpdlyout,clklcpdlyin,rsel0lcpdlyin,rsel1lcpdlyin,rsel2lcpdlyin);
output clklcpdlyout;
input clklcpdlyin;
input rsel0lcpdlyin;
input rsel1lcpdlyin;
input rsel2lcpdlyin;
reg clklcpdlyout;
wire clklcpdlyin,rsel0lcpdlyin,rsel1lcpdlyin,rsel2lcpdlyin;
`ifdef DC
     `LIB_lcp_dly_elmt(clklcpdlyout,clklcpdlyin,rsel0lcpdlyin,rsel1lcpdlyin,rsel2lcpdlyin) 
`else
assign clklcpdlyout = clklcpdlyin;
`endif
endmodule

module lcp_dly_dec (lcprsel0out,lcprsel1out,lcprsel2out,lcpdlysel0in,lcpdlysel1in);
output lcprsel0out;
output lcprsel1out;
output lcprsel2out;
input lcpdlysel0in;
input lcpdlysel1in;
wire lcpdlysel0in,lcpdlysel1in,lcprsel0out,lcprsel1out,lcprsel2out;
assign lcprsel0out = lcpdlysel0in  | lcpdlysel1in;
assign lcprsel1out = lcpdlysel0in  | ~lcpdlysel1in;
assign lcprsel2out = ~lcpdlysel0in | lcpdlysel1in;
endmodule

`define MAKE_LCP_DLY_ELEMENT(lcpdlyelementclkout,lcpdlyelementclkin,lcpdlyelementsel0in,lcpdlyelementsel1in)     \
wire lcpdlyelementclkout``_rsel0,lcpdlyelementclkout``_rsel1,lcpdlyelementclkout``_rsel2;                        \
lcp_dly_dec \``lcpdlymac1_``lcpdlyelementclkout (                                                                \
                                                .lcprsel0out(lcpdlyelementclkout``_rsel0),                       \
                                                .lcprsel1out(lcpdlyelementclkout``_rsel1),                       \
                                                .lcprsel2out(lcpdlyelementclkout``_rsel2),                       \
                                                .lcpdlysel0in(lcpdlyelementsel0in),                              \
                                                .lcpdlysel1in(lcpdlyelementsel1in)                               \
                                               );                                                                \
lcp_dly_elmt \``lcpdlymac2_``lcpdlyelementclkout (                                                               \
                                                 .clklcpdlyout (lcpdlyelementclkout),                            \
                                                 .clklcpdlyin  (lcpdlyelementclkin),                             \
                                                 .rsel0lcpdlyin(lcpdlyelementclkout``_rsel0),                    \
                                                 .rsel1lcpdlyin(lcpdlyelementclkout``_rsel1),                    \
                                                 .rsel2lcpdlyin(lcpdlyelementclkout``_rsel2)                     \
                                                 );       

///============================================================================================
///
/// Clocks
///
///============================================================================================
module clkqualdiv_local (divckout,divckin,divipinckin,divusync);
output divckout;
input divckin;
input divipinckin;
input divusync;
   logic temp, temp1, temp2, temp3;
    wire ckout_tmp1, ckout_tmp2, ckout_tmp, ckout_invclk;                                 
   `LATCH_P_DESKEW(temp, divusync, divipinckin)
   assign temp2 = ~temp1 & ~temp;
   `MSFF(temp1, temp2, divipinckin)
   `MSFF(temp3, temp1, divckin)
`CLK_GATE(divckout, divckin, temp3)
 
     /* novas s-51500 */
endmodule

`define MAKE_CLK_LOCAL_QUALDIV2(ckout,ckin,ipinckin,usync)         \
 clkqualdiv_local \``clk_qualdiv2_``ckout (                         \
                                         .divckout(ckout),       \
                                         .divckin(ckin) ,        \
                                         .divipinckin(ipinckin), \
                                         .divusync(usync)          \
                                         );
/* novas s-51500, s-53048, s-53050 */

`define MAKE_QUAL_LOCAL_QUALDIV2(qual_out, inclk, inusync, inqualovrd)     \
 qualdiv2_local \``qualdiv2_``qual_out (                                         \
                                         .qualifier_out(qual_out),       \
                                         .ipinclk(inclk) ,                  \
                                         .usync(inusync),                       \
                                         .qualovrd(inqualovrd)                  \
                                         );
/* novas s-51500, s-53048, s-53050 */
module qualdiv2_local (qualifier_out,ipinclk,usync,qualovrd);
  output qualifier_out;
  input ipinclk;
  input usync;
  input qualovrd;
 
  logic usync_lat, qual_staged;
  logic nxt, pst;
 
  `LATCH_P_DESKEW(usync_lat, usync, ipinclk)
  assign nxt = pst + 1'b1;
  `RST_MSFF(pst, nxt, ipinclk, usync_lat)
  `MSFF(qual_staged, pst, ipinclk)
  assign qualifier_out = qual_staged | qualovrd;
endmodule
 
`define MAKE_QUAL_LOCAL_QUALDIV4(qual_out, inclk, inusync, inqualovrd)     \
 qualdiv4_local \``qualdiv4_``qual_out (                                         \
                                         .qualifier_out(qual_out),       \
                                         .ipinclk(inclk) ,                  \
                                         .usync(inusync),                       \
                                         .qualovrd(inqualovrd)                  \
                                         );
/* novas s-51500, s-53048, s-53050 */
module qualdiv4_local (qualifier_out,ipinclk,usync,qualovrd);
  output qualifier_out;
  input ipinclk;
  input usync;
  input qualovrd;
 
  logic usync_lat, qual_staged, qual;
  logic [1:0] nxt;
  logic [1:0] pst;
 
  `LATCH_P_DESKEW(usync_lat, usync, ipinclk)
  assign nxt = pst + 2'b01;
  
  `RST_MSFF(pst, nxt, ipinclk, usync_lat)

  assign qual = (&(pst));
  `MSFF(qual_staged, qual, ipinclk)
  assign qualifier_out = qual_staged | qualovrd;
endmodule

// This macro has a decrementing counter and hence we would see a low phase on the output clock when get the usync.
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


`define MAKE_QUAL_LOCAL_QUALDIV8(qual_out, inclk, inusync, inqualovrd)     \
 qualdiv8_local \``qualdiv8_``qual_out (                                         \
                                         .qualifier_out(qual_out),       \
                                         .ipinclk(inclk) ,                  \
                                         .usync(inusync),                       \
                                         .qualovrd(inqualovrd)                  \
                                         );
/* novas s-51500, s-53048, s-53050 */
module qualdiv8_local (qualifier_out,ipinclk,usync,qualovrd);
  output qualifier_out;
  input ipinclk;
  input usync;
  input qualovrd;
 
  logic usync_lat, qual_staged, qual;
  logic [2:0] nxt;
  logic [2:0] pst;
 
  `LATCH_P_DESKEW(usync_lat, usync, ipinclk)
  assign nxt = pst + 3'b001;
  `RST_MSFF(pst, nxt, ipinclk, usync_lat)
  assign qual = (&(pst));
  `MSFF(qual_staged, qual, ipinclk)
  assign qualifier_out = qual_staged | qualovrd;
endmodule
 
//*****ANY USES OF MAKE_QUAL_LOCAL_QUALDIV8_ADJ SHOULD EVENTUALLY BE REPLACED BY 
//*****MAKE_QUAL_LOCAL_QUALDIV1TO8_ADJ WE CAN'T JUST CHANGE THIS MACRO AS IT WOULD CAUSE FAILS
// ML_FIX : Eventually need to remove this define and module
`define MAKE_QUAL_LOCAL_QUALDIV8_ADJ(qual_out, inclk, inusync, inqualovrd, inratiosel)     \
 qualdiv8_adj_local \``qualdiv8adj_``qual_out (                                                   \
                                         .qualifier_out(qual_out),                     \
                                         .ipinclk(inclk) ,                                \
                                         .usync(inusync),                                     \
                                         .qualovrd(inqualovrd),                                \
                                         .ratiosel(inratiosel)                                \
                                         );
/* novas s-51500, s-53048, s-53050 */
module qualdiv8_adj_local (qualifier_out,ipinclk,usync,qualovrd,ratiosel);
  output qualifier_out;
  input ipinclk;
  input usync;
  input qualovrd;
  input [2:0] ratiosel;
 
  logic usync_lat, qual_staged, qual;
  logic [2:0] nxt;
  logic [2:0] pst;
 
  `LATCH_P_DESKEW(usync_lat, usync, ipinclk)
  assign nxt = pst + 3'b001;
  `RST_MSFF(pst, nxt, ipinclk, usync_lat)
  always_comb begin
    casex(ratiosel)
      3'b000 : qual = &pst[2:0]; // div 8
      3'b001 : qual = &pst[1:0]; // div 4
      3'b011 : qual = pst[0];    // div 2
      3'b111 : qual = 1'b1;      // div 1
      default: qual = 1'b1;
    endcase // case(ratiosel)
  end
  `MSFF(qual_staged, qual, ipinclk)
  assign qualifier_out = qual_staged | qualovrd;
endmodule // qualdiv8_adj_local

`define MAKE_QUAL_LOCAL_QUALDIV1TO8_ADJ(qual_out, inclk, inusync, inqualovrd, inratiosel)     \
 qualdiv1to8_adj_local \``qualdiv1to8adj_``qual_out (                                         \
                                                    .qualifier_out(qual_out),                 \
                                                    .ipinclk(inclk) ,                         \
                                                    .usync(inusync),                          \
                                                    .qualovrd(inqualovrd),                    \
                                                    .ratiosel(inratiosel)                     \
                                                    );
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

`define MAKE_QUAL_LOCAL_QUALDIV1TO8_ADJ_WEN(qual_out, inclk, inusync, inqualovrd, inratiosel, inenable)     \
 qualdiv1to8_adj_wen_local \``qualdiv1to8adjwen_``qual_out (                                         \
                                                    .qualifier_out(qual_out),                 \
                                                    .ipinclk(inclk) ,                         \
                                                    .usync(inusync),                          \
                                                    .qualovrd(inqualovrd),                    \
                                                    .ratiosel(inratiosel),                    \
                                                    .enable(inenable)                         \
                                                    );
/* novas s-51500, s-53048, s-53050 */
module qualdiv1to8_adj_wen_local (qualifier_out,ipinclk,usync,qualovrd,ratiosel,enable);
  output qualifier_out;
  input ipinclk;
  input usync;
  input qualovrd;
  input [2:0] ratiosel;
  input enable;
 
  logic usync_or_qual_lat, usync_or_qual, qual_staged, qual;
  logic [2:0] ratiosel_muxed_staged, ratiosel_muxed;
  logic [2:0] nxt;
  logic [2:0] pst;
 
  //Whenever a qual or usync comes through we reset the counter
  assign usync_or_qual = usync | qual;

  `LATCH_P_DESKEW(usync_or_qual_lat, usync_or_qual, ipinclk)
  assign nxt = pst + 1;
  `RST_MSFF(pst, nxt, ipinclk, usync_or_qual_lat)

  //only grab ratiosel on usync boundary
  assign ratiosel_muxed = usync ? ratiosel : ratiosel_muxed_staged;
  `MSFF(ratiosel_muxed_staged, ratiosel_muxed, ipinclk)

  //Once we've reached the count that matches the ratiosel we're dividing by
  //Set the qual indicator and reset the count
  assign qual = (pst == ratiosel_muxed_staged);

  `MSFF(qual_staged, qual, ipinclk)
  assign qualifier_out = (qual_staged & enable) | qualovrd;
endmodule // qualdiv1to8_adj_wen_local

`define MAKE_CLK_LOCAL_QUALDIV1TO8_ADJ(qual_out,inclk,inusync,inqualovrd,inratiosel)     \
clk_qualdiv1to8_adj_local \``clk_qualdiv1to8_adj_local_``qual_out (                           \
                                                                  .qualclk_out(qual_out),    \
                                                                  .clk(inclk),               \
                                                                  .usync(inusync),           \
                                                                  .qualovrd(inqualovrd),     \
                                                                  .ratiosel(inratiosel)     \
                                                                 ); /* novas s-51500, s-53048, s-53050 */

module clk_qualdiv1to8_adj_local(qualclk_out, clk, usync, qualovrd, ratiosel);
  output qualclk_out;
  input clk;
  input usync;
  input qualovrd;
  input [2:0] ratiosel;
  logic qual_out;
  `MAKE_QUAL_LOCAL_QUALDIV1TO8_ADJ(qual_out, clk, usync, qualovrd, ratiosel)        
  `CLK_GATE(qualclk_out, clk,  qual_out) //novas s-51557, s-51552
endmodule

`define MAKE_QUAL_LOCAL_QUALDIV1TO16_ADJ(qual_out, inclk, inusync, inqualovrd, inratiosel)     \
 qualdiv1to16_adj_local \``qualdiv1to16adj_``qual_out (                                         \
                                                    .qualifier_out(qual_out),                 \
                                                    .ipinclk(inclk) ,                         \
                                                    .usync(inusync),                          \
                                                    .qualovrd(inqualovrd),                    \
                                                    .ratiosel(inratiosel)                     \
                                                    );
/* novas s-51500, s-53048, s-53050 */
module qualdiv1to16_adj_local (qualifier_out,ipinclk,usync,qualovrd,ratiosel);
  output qualifier_out;
  input ipinclk;
  input usync;
  input qualovrd;
  input [3:0] ratiosel;
 
  logic usync_or_qual_lat, usync_or_qual, qual_staged, qual;
  logic [3:0] ratiosel_muxed_staged, ratiosel_muxed;
  logic [3:0] nxt;
  logic [3:0] pst;
 
  //Whenever a qual or usync comes through we reset the counter
  assign usync_or_qual = usync | qual;

  `LATCH_P_DESKEW(usync_or_qual_lat, usync_or_qual, ipinclk)
  assign nxt = pst + 4'b0001;
  `RST_MSFF(pst, nxt, ipinclk, usync_or_qual_lat)

  //only grab ratiosel on usync boundary
  assign ratiosel_muxed = usync ? ratiosel : ratiosel_muxed_staged;
  `MSFF(ratiosel_muxed_staged, ratiosel_muxed, ipinclk)

  //Once we've reached the count that matches the ratiosel we're dividing by
  //Set the qual indicator and reset the count
  assign qual = (pst == ratiosel_muxed_staged);

  `MSFF(qual_staged, qual, ipinclk)
  assign qualifier_out = qual_staged | qualovrd;
endmodule // qualdiv1to16_adj_local

`define MAKE_CLK_LOCAL_QUALDIV1TO16_ADJ(qual_out,inclk,inusync,inqualovrd,inratiosel)     \
clk_qualdiv1to16_adj_local \``clk_qualdiv1to16_adj_local_``qual_out (                           \
                                                                  .qualclk_out(qual_out),    \
                                                                  .clk(inclk),               \
                                                                  .usync(inusync),           \
                                                                  .qualovrd(inqualovrd),     \
                                                                  .ratiosel(inratiosel)     \
                                                                 ); /* novas s-51500, s-53048, s-53050 */

module clk_qualdiv1to16_adj_local(qualclk_out, clk, usync, qualovrd, ratiosel);
  output qualclk_out;
  input clk;
  input usync;
  input qualovrd;
  input [3:0] ratiosel;
  logic qual_out;
  `MAKE_QUAL_LOCAL_QUALDIV1TO16_ADJ(qual_out, clk, usync, qualovrd, ratiosel)        
  `CLK_GATE(qualclk_out, clk,  qual_out)
endmodule


`define MAKE_CLK_LOCAL_QUALDIV4(ckout2,ckin2,ipinckin2,usync2)            \
clkqualdiv4_local \``clk_qualdiv4_local``ckout2 (                                \
                                   .divckout (ckout2),             \
                                   .divckin  (ckin2),              \
                                   .divipinckin(ipinckin2),        \
                                   .divusync (usync2)                \
                                  );
/* novas s-51500, s-53048, s-53050 */
module clkqualdiv4_local (divckout,divckin,divipinckin,divusync);
   output divckout;
   input  divckin;
   input  divipinckin;
   input  divusync;
   reg    divckout;
   wire   divckin,divusync;
   reg    ckdiv4out_pout;                                                
   reg [1:0] ckdiv4out_rstffpst;                                      
   wire [1:0] ckdiv4out_rstffnxt;
   logic       temp1, usync;
   always_latch                                                         
     begin                                                          
        if (~divipinckin) ckdiv4out_pout  <= divusync;        
     end                                                            
   always_ff @(posedge divipinckin)                                 
     begin                                                          
        if (ckdiv4out_pout) ckdiv4out_rstffpst  <= '0;          
        else ckdiv4out_rstffpst  <=  ckdiv4out_rstffnxt;     
     end                                                            
   assign ckdiv4out_rstffnxt = ckdiv4out_rstffpst  + 2'b01 ;           
   assign usync = &ckdiv4out_rstffpst;
   
   clockdivff clockdivff_ckdiv4out(                                 
                                   .ffout(temp1),                      
                                   .ffin(usync),              
                                   .clockin(divckin)                      
                                   );
`CLK_GATE(divckout, divckin, temp1)
endmodule

`define MAKE_CLK_LOCAL_QUALDIV8(ckout2,ckin2,ipinckin2,usync2)            \
clkqualdiv8_local \``clk_qualdiv4_local``ckout2 (                                \
                                   .divckout (ckout2),             \
                                   .divckin  (ckin2),              \
                                   .divipinckin(ipinckin2),        \
                                   .divusync (usync2)                \
                                  );
/* novas s-51500, s-53048, s-53050 */
module clkqualdiv8_local (divckout,divckin,divipinckin,divusync);
   output divckout;
   input  divckin;
   input  divipinckin;
   input  divusync;
   reg    divckout;
   wire   divckin,divusync;
   reg    ckdiv8out_pout;                                                
   reg [2:0] ckdiv8out_rstffpst;                                      
   wire [2:0] ckdiv8out_rstffnxt;
   logic       temp1, temp2, usync;
   always_latch                                                         
     begin                                                          
        if (~divipinckin) ckdiv8out_pout  <= divusync;        
     end                                                            
   always_ff @(posedge divipinckin)                                 
     begin                                                          
        if (ckdiv8out_pout) ckdiv8out_rstffpst  <= '0;          
        else ckdiv8out_rstffpst  <=  ckdiv8out_rstffnxt;     
     end                                                            
   assign ckdiv8out_rstffnxt = ckdiv8out_rstffpst  + 3'b001 ;           
   assign usync = &ckdiv8out_rstffpst;
   
   clockdivff clockdivff_ckdiv8out(                                 
                                   .ffout(temp1),                      
                                   .ffin(usync),              
                                   .clockin(divckin)                      
                                   );
`CLK_GATE(divckout, divckin, temp1)
endmodule

`define MAKE_CLK_LOCAL_QUALDIV8_ADJ(ckout2,ckin2,ipinckin2,usync2, ratiosel2)            \
clkqualdiv8_local_adj \``clk_qualdiv4_local_adj``ckout2 (                                \
                                   .divckout (ckout2),             \
                                   .divckin  (ckin2),              \
                                   .divipinckin(ipinckin2),        \
                                   .divusync (usync2),               \
                                   .ratiosel (ratiosel2)                \
                                  );
/* novas s-51500, s-53048, s-53050 */
module clkqualdiv8_local_adj (divckout,divckin,divipinckin,divusync,ratiosel);
   output divckout;
   input  divckin;
   input  divipinckin;
   input  divusync;
   input [2:0] ratiosel;
   reg    divckout;
   wire   divckin,divusync;
   reg    ckdiv8out_pout;                                                
   reg [2:0] ckdiv8out_rstffpst;                                      
   wire [2:0] ckdiv8out_rstffnxt;
   logic       temp1, usync;

   `LATCH_P_DESKEW(ckdiv8out_pout, divusync, divipinckin)           
   assign ckdiv8out_rstffnxt = ckdiv8out_rstffpst  + 3'b001 ;
   `RST_MSFF(ckdiv8out_rstffpst, ckdiv8out_rstffnxt, divipinckin, ckdiv8out_pout)                   

   always_comb
     case(ratiosel)
       3'b000 : usync = &ckdiv8out_rstffpst[2:0]; // div 8
       3'b001 : usync = &ckdiv8out_rstffpst[1:0]; // div 4
       3'b011 : usync = ckdiv8out_rstffpst[0];    // div 2
       3'b111 : usync = 1'b1;                     // div 1
       default: usync = 1'b1;
     endcase // case(ratiosel)
       
   clockdivff clockdivff_ckdiv8out(                                 
                                   .ffout(temp1),                      
                                   .ffin(usync),              
                                   .clockin(divckin)                      
                                   );
`CLK_GATE(divckout, divckin, temp1)
endmodule

`define MAKE_CLK_LOCAL_QUALDIV16(outclk,inclk,ipinck,inusync)             \
clkqualdiv16_local \``clk_qualdiv4_local``outclk (                               \
                                   .divckout (outclk),                      \
                                   .divckin  (inclk),                       \
                                   .divipinckin(ipinck),                      \
                                   .divusync (inusync)                            \
                                  );
/* novas s-51500, s-53048, s-53050 */
module clkqualdiv16_local (divckout,divckin,divipinckin,divusync);
   output divckout;
   input  divckin;
   input  divipinckin;
   input  divusync;
   reg    divckout;
   wire   divckin,divusync;
   reg    ckdiv16out_pout;                                                
   reg [3:0] ckdiv16out_rstffpst;                                      
   wire [3:0] ckdiv16out_rstffnxt;
   logic       temp1, usync;
   always_latch                                                         
     begin                                                          
        if (~divipinckin) ckdiv16out_pout  <= divusync;        
     end                                                            
   always_ff @(posedge divipinckin)                                 
     begin                                                          
        if (ckdiv16out_pout) ckdiv16out_rstffpst  <= '0;          
        else ckdiv16out_rstffpst  <=  ckdiv16out_rstffnxt;     
     end                                                            
   assign ckdiv16out_rstffnxt = ckdiv16out_rstffpst  + 4'b0001 ;           
   assign usync = &ckdiv16out_rstffpst;
   
   clockdivff clockdivff_ckdiv16out(                                 
                                   .ffout(temp1),                      
                                   .ffin(usync),              
                                   .clockin(divckin)                      
                                   );
`CLK_GATE(divckout, divckin, temp1)

endmodule

`define MAKE_QUAL_LOCAL_QUALDIV16(qual_out, inclk, inusync, inqualovrd)          \
 qualdiv16_local \``qualdiv16_``qual_out (                                       \
                                         .qualifier_out(qual_out),               \
                                         .ipinclk(inclk) ,                       \
                                         .usync(inusync),                        \
                                         .qualovrd(inqualovrd)                   \
                                         );
module qualdiv16_local (qualifier_out,ipinclk,usync,qualovrd);
  output qualifier_out;
  input ipinclk;
  input usync;
  input qualovrd;
 
  logic usync_lat, qual_staged, qual;
  logic [3:0] nxt;
  logic [3:0] pst;
 
  `LATCH_P_DESKEW(usync_lat, usync, ipinclk)
  assign nxt = pst + 4'b0001;
  `RST_MSFF(pst, nxt, ipinclk, usync_lat)
  assign qual = (&(pst));
  `MSFF(qual_staged, qual, ipinclk)
  assign qualifier_out = qual_staged | qualovrd;
endmodule

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
    ffoutreset = 1'b0; /* novas s-60028 */
  else
    ffoutreset = (ffinreset); /* novas s-60028 */
end
`endif
endmodule

//`define MAKE_CLK_DIV2_RESET(ckdiv2rout,ckdiv2rin,ckdiv2clkin,ckdiv2resetin)        \
`define CLK_FF(ckdiv2rout,ckdiv2rin,ckdiv2clkin,ckdiv2resetin)        \
clockdivffreset \``clockdivffreset_``ckdiv2rout (                                \
                                               .ffoutreset(ckdiv2rout),        \
                                               .ffinreset(ckdiv2rin),          \
                                               .clockinreset(ckdiv2clkin),     \
                                               .resetckdivff(ckdiv2resetin)        \
                                              );


module clockdivffreset_inv (ffoutresetb, ffinreset, clockinreset,resetckdivff);    
output ffoutresetb;
input ffinreset;
input clockinreset;
input resetckdivff;
reg ffoutresetb;
wire ffinreset, clockinreset, resetckdivff;
`ifdef DC
     `LIB_clockdivffreset(ffoutresetb, ffinreset, clockinreset,resetckdivff) 
`else 
always @(negedge (resetckdivff) or posedge clockinreset)
begin
  if (~(resetckdivff))
    ffoutresetb = 1'b0; /* novas s-60028 */
  else
    ffoutresetb = ~(ffinreset); /* novas s-60028 */
end
`endif
endmodule


`define CLK_FF_INV(ckdiv2routb,ckdiv2rin,ckdiv2clkin,ckdiv2resetin)                       \
clockdivffreset_inv \``clockdivffreset_inv_``ckdiv2routb (                                \
                                                         .ffoutresetb(ckdiv2routb),       \
                                                         .ffinreset(ckdiv2rin),           \
                                                         .clockinreset(ckdiv2clkin),      \
                                                         .resetckdivff(ckdiv2resetin)     \
                                                        );


`define CLKDIVFF(iffout, iffin, iclockin)             \
clockdivff \``clockdivff_``iffout (                   \
                                   .ffout(iffout),    \
                                   .ffin(iffin),      \
                                   .clockin(iclockin) \
);

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
         ffout = ffin; /* novas s-60028 */
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
         if (~div2ipinckin) cknameout_ffout  = div2usync; /* novas s-60028, s-50531 */
      end                                                            
assign cknameout_ffinvout  = (~(cknameout_ffout));               
assign #1 cknameout_andout = (cknameout_ffinvout  & ~div2cknameout); 
clockdivff clockdivff_cknameout (                                 
                                  .ffout(div2cknameout),                 
                                  .ffin(cknameout_andout),         
                                  .clockin(div2ipinckin)                 
                                 );
endmodule

`define MAKE_CLK_DIV2(cknameout,ipinckin,usync)             \
 clkdiv2 \``clk_div2_``cknameout (                                     \
                                .div2cknameout (cknameout),          \
                                .div2ipinckin (ipinckin),            \
                                .div2usync (usync)                   \
                               );

module clk2div2shft (div2shftckdiv2shftout,div2shftipinckdiv2shftin,div2shftusyncdiv2shft);
output div2shftckdiv2shftout;
input div2shftipinckdiv2shftin;
input div2shftusyncdiv2shft;
reg div2shftckdiv2shftout;
wire div2shftipinckdiv2shftin,div2shftusyncdiv2shft;
 reg ckdiv2shftout_ffout;                                                          
  wire ckdiv2shftout_invout,ckdiv2shftout_andout,ckdiv2shftout_ckinvout;        
  always_ff @(posedge div2shftipinckdiv2shftin)                                               
      begin                                                                           
       ckdiv2shftout_ffout   <= div2shftusyncdiv2shft;                                      
      end  
  assign ckdiv2shftout_invout = ~ckdiv2shftout_ffout;       
  clkinv clkinvdiv2shft (
                         .clkout (ckdiv2shftout_ckinvout),
                         .clkin (div2shftipinckdiv2shftin)
                        );
  assign #1 ckdiv2shftout_andout = (ckdiv2shftout_invout) & (~div2shftckdiv2shftout);     
  clockdivff clockdivff_ckdiv2shftout (                                            
                                   .ffout(div2shftckdiv2shftout),                             
                                   .ffin(ckdiv2shftout_andout),                     
                                   .clockin(ckdiv2shftout_ckinvout)                 
                                  );
endmodule

`define MAKE_CLK_DIV2SHIFT(ckdiv2shftout,ipinckdiv2shftin,usyncdiv2shft)      \
 clk2div2shft \``clk_div2shift_``ckdiv2shftout (                                             \
                                              .div2shftckdiv2shftout (ckdiv2shftout),      \
                                              .div2shftipinckdiv2shftin (ipinckdiv2shftin),\
                                              .div2shftusyncdiv2shft (usyncdiv2shft)       \
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
         if (~div8ipinckdiv8in) ckdiv8out_pout  = div8usyncdiv8in; /* novas s-60028 */
      end                                                            
   always_ff @(posedge div8ipinckdiv8in)                                 
      begin                                                          
         if (ckdiv8out_pout) ckdiv8out_rstffpst  <= '0;          
         else ckdiv8out_rstffpst  <=  ckdiv8out_rstffnxt;     
      end                                                            
 assign ckdiv8out_rstffnxt = ckdiv8out_rstffpst  + 3'b001 ;           
assign ckdiv8out_invout = ~ckdiv8out_rstffpst[2];                
clockdivff clockdivff_ckdiv8out (                                 
                             .ffout(div8ckdiv8out),                      
                             .ffin(ckdiv8out_invout),              
                             .clockin(div8ipinckdiv8in)                      
                            );
endmodule


`define MAKE_CLK_DIV8(ckdiv8out,ipinckdiv8in,usyncdiv8in)        \
clkdiv8 \``clk_div8_``ckdiv8out (                                           \
                               .div8ckdiv8out (ckdiv8out),                \
                               .div8ipinckdiv8in (ipinckdiv8in),          \
                               .div8usyncdiv8in (usyncdiv8in)             \
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
         if (~div4ipinckdiv4in) ckdiv4out_pout  = div4usyncdiv4in; /* novas s-60028 */
      end                                                            
   always_ff @(posedge div4ipinckdiv4in)                                 
      begin                                                          
         if (ckdiv4out_pout) ckdiv4out_rstffpst  <= '0;          
         else ckdiv4out_rstffpst  <=  ckdiv4out_rstffnxt;     
      end                                                            
 assign ckdiv4out_rstffnxt = ckdiv4out_rstffpst  + 2'b01 ;           
assign ckdiv4out_invout = ~ckdiv4out_rstffpst[1];                
clockdivff clockdivff_ckdiv4out (                                 
                             .ffout(div4ckdiv4out),                      
                             .ffin(ckdiv4out_invout),              
                             .clockin(div4ipinckdiv4in)                      
                            );
endmodule


`define MAKE_CLK_DIV4(ckdiv4out,ipinckdiv4in,usyncdiv4in)        \
clkdiv4 \``clk_div4_``ckdiv4out (                                           \
                               .div4ckdiv4out (ckdiv4out),                \
                               .div4ipinckdiv4in (ipinckdiv4in),          \
                               .div4usyncdiv4in (usyncdiv4in)             \
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
assign clk16delayout = clk16delayin;
`endif
endmodule

`define MAKE_CLK_DELAY16(clkd16out,clkd16clkin,clkd16in0,clkd16in1,clkd16in2,clkd16in3,clkd16in4,clkd16in5,clkd16in6,clkd16in7,clkd16in8,clkd16in9,clkd16in10,clkd16in11,clkd16in12,clkd16in13,clkd16in14)                                   \
clk16delay \``clk16delay_``clkd16out (                                                        \
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


// Macro for MODQ simulation queue for clock tree in bus cluster
`define CLKANDMODQ(outclk, inclk1, inclk0)                                     \
   soc_clkandmodq \``clkandmodq_``outclk ( /* novas s-52002 */                       \
      .outclkm (outclk),                                                       \
      .inclk1m (inclk1),                                                       \
      .inclk0m (inclk0)                                                        \
   );



module soc_clkandmodq (outclkm,
                   inclk1m,
                   inclk0m);

output outclkm;
input inclk1m;
input inclk0m;

wire outclkm, inclk1m, inclk0m;

assign outclkm = inclk1m & inclk0m;
 
`ifndef DC
`ifndef LINT
`ifndef FEV
specify
  (inclk1m, inclk0m => outclkm) = 0;
endspecify
`endif //FEV
`endif //LINT
`endif //DC

endmodule // soc_clkandmodq

`define MAKE_CLK_LOCAL_QUALDIV100(div100clkout, div100_base_clk, div100_reset_n, div100_byp_div, div100_clk_disable, div100_squash_div)        \
   crp_sample_gen_common #(7) \``make_clk_qualdiv100_``div100clksample (                                           \
                                                    .base_clk              (div100_base_clk),                \
                                                    .byp_div               (div100_byp_div),                 \
                                                    .reset_n               (div100_reset_n),                 \
                                                    .clk_disable           (div100_clk_disable),             \
                                                    .squash_div            (div100_squash_div),              \
                                                    .clk_out               (div100clkout)                    \
                                                    );

`define MAKE_CLK_LOCAL_QUALDIV600(div600clkout, div600_base_clk, div600_reset_n, div600_byp_div, div600_clk_disable, div600_squash_div)        \
   crp_sample_gen_common #(10) \``make_clk_qualdiv600_``div600clksample (                                           \
                                                    .base_clk              (div600_base_clk),                \
                                                    .reset_n               (div600_reset_n),                 \
                                                    .byp_div               (div600_byp_div),                 \
                                                    .clk_disable           (div600_clk_disable),             \
                                                    .squash_div            (div600_squash_div),              \
                                                    .clk_out               (div600clkout)                    \
                                                    );

module crp_sample_gen_common  #(parameter dWidth = 3) 
                     (
                      input                  base_clk,       // Pre or Post CTS based on Physical Design
                      input                  reset_n,        // Must be pre-stinkronized to base_clk input
                      input                  byp_div,        // PMU Register input
                      input                  clk_disable,    // PMU Register input
                      input [(dWidth - 1):0] squash_div,     // PMU Register input
                      output                 clk_out
                      );

   reg [(dWidth - 1):0]    count;
   reg                     clk_sample_fe;
   wire                    clk_sample;

   // Standard up-down counter with some extras
   always @(posedge base_clk or negedge reset_n )
     if (~reset_n)
       count         <= {dWidth{1'b0}};     // Divider initial 1 or 0
     else if (clk_disable || (squash_div == 0))
       count         <= {dWidth{1'b0}};
     else if (count < squash_div)
       count         <= count + {{(dWidth-1){1'b0}}, 1'b1};
     else
       count         <= {dWidth{1'b0}};

   // Falling edge used to clock forward the sample signal
   always @(negedge base_clk or negedge reset_n )
     if (~reset_n)
       clk_sample_fe <= 1'b0;     
     else if (clk_disable)    // I1 control
       clk_sample_fe <= 1'b0;
     else if ( count == 0 )
       clk_sample_fe <= 1'b1;
     else
       clk_sample_fe <= 1'b0;

   assign  clk_sample = byp_div ? 1'b1 : clk_sample_fe;

   soc_rbe_clk \``soc_rbe_clk_``clk_out (clk_out,base_clk,clk_sample);
endmodule // clk_sample_gen

module det_clkdomainX #(parameter dWidth = 32, parameter fifo_depth = 10, parameter separation = 2) 
                     (
                      input reset_ckRd,
                      input reset_ckWr,
                      input ckWr,
                      input ckRd,
                      input qualWr,
                      input qualRd,
                      input [dWidth-1:0] data_in,
                      input test_override,
                      output [dWidth-1:0] data_out
                      );

   logic [dWidth-1:0] det_clkdomainX_write_data_array[fifo_depth - 1:0];
   logic [dWidth-1:0] det_clkdomainX_read_data_mux;
   logic [fifo_depth - 1:0] wrptr;
   logic [fifo_depth - 1:0] rdptr;
   logic [fifo_depth - 1:0] start_ptr;
   logic write_clk;
   logic read_clk;

   `CLK_GATE_W_OVERRIDE(write_clk,ckWr,qualWr,test_override)
   `CLK_GATE_W_OVERRIDE(read_clk,ckRd,qualRd,test_override)
  
   // data path generation
   always@(posedge write_clk or negedge reset_ckWr)
     begin
        if (~reset_ckWr)
          begin
             integer i;
             for (i=0;i<fifo_depth;i=i+1)
               begin
                  det_clkdomainX_write_data_array[i] <= {dWidth{1'b0}};
               end
          end
        else
          begin
             integer i;
             for (i=0;i<fifo_depth;i=i+1)
               begin
                  if (wrptr[i])
                    det_clkdomainX_write_data_array[i] <= data_in;
               end
          end
     end

   always@(posedge read_clk or negedge reset_ckRd)
     begin
        if (~reset_ckRd)
          begin
             det_clkdomainX_read_data_mux <= {dWidth{1'b0}};
          end
        else
          begin
             integer i;
             for (i=0;i<fifo_depth;i=i+1)
               begin
                  if (rdptr[i])
                    det_clkdomainX_read_data_mux <= det_clkdomainX_write_data_array[i];
               end
          end
     end

   assign data_out = det_clkdomainX_read_data_mux;

   // wrptr and rdptr generation
   assign start_ptr = {{(fifo_depth-1){1'b0}},1'b1};
   
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

`ifndef SVA_OFF
   reg            ckRd_delayed;
   assign #10     ckRd_delayed = ckRd;
   genvar i;
   generate
   for (i=0;i<fifo_depth;i=i+1)
     begin
	setup_check : assert property (@(posedge ckRd) disable iff (~reset_ckRd) ((rdptr[i] && qualRd)) |-> (det_clkdomainX_write_data_array[i] == $past(det_clkdomainX_write_data_array[i],,,@(negedge ckRd_delayed)))) else $error("det_clkdomainX setup_check failed");
	hold_check : assert property (@(posedge ckRd) disable iff (~reset_ckRd) ((rdptr[i] && qualRd)) |=> (@(negedge ckRd) det_clkdomainX_write_data_array[i] == $past(det_clkdomainX_write_data_array[i],,,@(posedge ckRd_delayed)))) else $error("det_clkdomainX hold_check failed");
     end
   endgenerate
`endif
   
endmodule // det_clkdomainX

module qual_1_1(
                input usync_fast_clk,
                input fast_clk,
                output fast_qual,
                output slow_qual
                );
  
   assign              fast_qual = 1'b1;
   assign              slow_qual = 1'b1;
endmodule // qual_1_1

module qual_4_3(
                input usync_fast_clk,
                input fast_clk,
                output fast_qual,
                output slow_qual
                );
   reg [1:0]           count;

   always@(posedge fast_clk)
     if(usync_fast_clk)
       count <= 2'b00;
     else
       count <= count + 2'b01;

   assign              fast_qual = ~(count == 2);
   assign              slow_qual = 1'b1;
endmodule // qual_4_3

module qual_8_5(
                input usync_fast_clk,
                input fast_clk,
                output fast_qual,
                output slow_qual
                );
   reg [2:0]           count;
   always@(posedge fast_clk)
     if(usync_fast_clk)
       count <= 3'b000;
     else
       count <= count + 3'b001;
   assign              fast_qual = (count == 0 ||
                                    count == 2 ||
                                    count == 3 ||
                                    count == 5 ||
                                    count == 6);
   assign              slow_qual = 1'b1;
endmodule // qual_8_5

module qual_2_1(
                input usync_fast_clk,
                input fast_clk,
                output fast_qual,
                output slow_qual
                );
   reg                 count;

   always@(posedge fast_clk)
     if(usync_fast_clk)
       count <= 1'b0;
     else
       count <= count + 1'b1;

   assign              fast_qual = count == 0;
   assign              slow_qual = 1'b1;
endmodule // qual_2_1

module qual_16_7(
                input usync_fast_clk,
                input fast_clk,
                output fast_qual,
                output slow_qual
                );
   reg [3:0]           count;
   always@(posedge fast_clk)
     if(usync_fast_clk)
       count <= 4'b0000;
     else
       count <= count + 4'b0001;
   assign              fast_qual = (count == 0  ||
                                    count == 2  ||
                                    count == 5  ||
                                    count == 7  ||
                                    count == 9  ||
                                    count == 11 ||
                                    count == 14);
   assign              slow_qual = 1'b1;
endmodule // qual_16_7

module qual_8_3(
                input usync_fast_clk,
                input fast_clk,
                output fast_qual,
                output slow_qual
                );
   reg [2:0]           count;
   always@(posedge fast_clk)
     if(usync_fast_clk)
       count <= 3'b000;
     else
       count <= count + 3'b001;
   assign              fast_qual = (count == 0 ||
                                    count == 3 ||
                                    count == 5);
   assign              slow_qual = 1'b1;
endmodule // qual_8_3

module qual_16_5(
                input usync_fast_clk,
                input fast_clk,
                output fast_qual,
                output slow_qual
                );
   reg [3:0]           count;
   always@(posedge fast_clk)
     if(usync_fast_clk)
       count <= 4'b0000;
     else
       count <= count + 4'b0001;
   assign              fast_qual = (count == 0  ||
                                    count == 3  ||
                                    count == 6  ||
                                    count == 10 ||
                                    count == 13);
   assign              slow_qual = 1'b1;
endmodule // qual_16_5

module qual_4_1(
                input usync_fast_clk,
                input fast_clk,
                output fast_qual,
                output slow_qual
                );
   reg [1:0]           count;

   always@(posedge fast_clk)
     if(usync_fast_clk)
       count <= 2'b00;
     else
       count <= count + 2'b01;

   assign              fast_qual = count == 0;
   assign              slow_qual = 1'b1;
endmodule // qual_4_1

module qual_5_3(
                input usync_fast_clk,
                input fast_clk,
                output fast_qual,
                output slow_qual
                );
   reg [2:0]           count;

   always@(posedge fast_clk)
     if(usync_fast_clk)
       count <= 3'b000;
     else
       count <= (count + 3'b001) & {3{~(count == 4)}};

   assign              fast_qual = (count == 0  ||
                                    count == 2  ||
                                    count == 3);
   assign              slow_qual = 1'b1;
endmodule // qual_5_3

module qual_5_2(
                input usync_fast_clk,
                input fast_clk,
                output fast_qual,
                output slow_qual
                );
   reg [2:0]           count;

   always@(posedge fast_clk)
     if(usync_fast_clk)
       count <= 3'b000;
     else
       count <= (count + 3'b001) & {3{~(count == 4)}};

   assign              fast_qual = (count == 0  ||
                                    count == 3);
   assign              slow_qual = 1'b1;
endmodule //qual_5_2


module qual_gen (
    input      clka,
    input      clkb,
    input      clka_usync,
    input      clkb_usync,
    input [4:0] clka_ratio,
    input [4:0] clkb_ratio,
    output reg 	clka_qual,
    output reg 	clkb_qual
		  );
		  
   reg[5:0]   clka_error;
   reg[5:0]   clkb_error;
   wire[5:0]  clka_error_tmp;
   wire[5:0]  clkb_error_tmp;
   wire[5:0]  clka_ratio_adjusted;
   wire[5:0]  clkb_ratio_adjusted;
   wire[5:0]  clka_ratio_twos;
   wire[5:0]  clkb_ratio_twos;

   assign clka_ratio_adjusted[5:0] = {1'b0, clka_ratio[4:0]} + 1'b1;
   assign clkb_ratio_adjusted[5:0] = {1'b0, clkb_ratio[4:0]} + 1'b1;
   assign clka_ratio_twos[5:0]     = ~clka_ratio_adjusted[5:0] + 1'b1;
   assign clkb_ratio_twos[5:0]     = ~clkb_ratio_adjusted[5:0] + 1'b1;
   assign clka_error_tmp[5:0]      = {clkb_ratio_twos[5], clkb_ratio_twos[5:1]};
   assign clkb_error_tmp[5:0]      = {clka_ratio_twos[5], clka_ratio_twos[5:1]};
		   
   always@(posedge clka)
     if (clka_ratio[4:0] > clkb_ratio[4:0])
       begin
	  if(clka_usync)
            clka_error[5:0] <= clka_error_tmp[5:0];
	  else
            clka_error[5:0] <= clka_error[5] ?
			       (clka_error[5:0] + clka_ratio_adjusted[5:0] - clkb_ratio_adjusted[5:0]) :
			       (clka_error[5:0] - clkb_ratio_adjusted[5:0]);
       end
     else
       clka_error[5:0] <= 6'b111111;
       
   always@(posedge clkb)
     if (clkb_ratio[4:0] > clka_ratio[4:0])
       begin
	  if(clkb_usync)
            clkb_error[5:0] <= clkb_error_tmp[5:0];
	  else
            clkb_error[5:0] <= clkb_error[5] ?
			       (clkb_error[5:0] + clkb_ratio_adjusted[5:0] - clka_ratio_adjusted[5:0]) :
			       (clkb_error[5:0] - clka_ratio_adjusted[5:0]);
       end
     else
       clkb_error[5:0] <= 6'b111111;

   always_comb
     begin
        clka_qual = clka_error[5];
	clkb_qual = clkb_error[5];
     end
endmodule // qual_gen	



`endif

