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
//     File/Block                             : soc_dfx_macros.sv
//     Design Style [rls|rf|ssa_fuse|sdp|
//                   custom|hier|rls_hier]    : rls
//     Circuit Style [non_rfs|rfs|ssa|fuse|
//                    IO|ROM|none]            : none
//     Common_lib (for custom blocks only)    : none  
//     Library (must be same as module name)  : soc_dfx_macros
//     Unit [unit id or shared]               : shared
//     Complex [North, South, CPU]            : North
//     Bizgroup [LCP|SEG|ULMD]                : ULMD
//
// Design Unit Owner : mike.lin@intel.com
// Primary Contact   : mike.lin@intel.com
// 
// MOAD End
//
//=============================================================================/
//
// Description:
//   <Enter Description Here>
//
//=============================================================================
`ifndef SOC_DFX_MACROS_VH
`define SOC_DFX_MACROS_VH

`include "vlv_macro_tech_map.vh"
`include "soc_clock_macros.sv"
`include "soc_macros.sv"



module clk_gate_kin (output logic ckrcbxpn1, input logic ckgridxpn1, latrcben1, testen1);  //lintra s-31506
`ifdef DC
     `LIB_clk_gate_kin(ckrcbxpn1,ckgridxpn1,latrcben1,testen1) 
`else
   logic latrcbenl1; // rce state element
   logic cken_int;
   assign cken_int = latrcben1|testen1;
   `LATCH_P(latrcbenl1,cken_int,ckgridxpn1)                            
   `CLKAND(ckrcbxpn1,ckgridxpn1,latrcbenl1)

   // This was the previous behavioural model - changed on request from Chad
   // Bradley to make it FEV equivalent to the B12 Library cell
   //`LATCH_P(latrcbenl1,cken_int,ckgridxpn1)                            
   //`CLKAND(ckrcbxpn1,ckgridxpn1,latrcbenl1)
`endif
endmodule

`define MAKE_CLK_LOC_CLKGATE(enclkout,clkin,enin,tein)                                          \
clk_gate_kin \``clk_gate_kin_``enclkout (                                                       \
                                       .ckrcbxpn1 (enclkout),                                   \
                                       .ckgridxpn1 (clkin),                                     \
                                       .latrcben1  (enin),                                      \
                                       .testen1 (tein));


// gclatchen clock gate macro with disable
`define MAKE_CLK_LOC_GCLATCHEN(gcenclkout,gcenin,gctein,gcclrbin,gcckin)                        \
`ifdef DC                                                                                       \
  `LIB_GCLATCHEN(gcenclkout,gcenin,gctein,gcclrbin,gcckin)                                      \
`else                                                                                           \
reg lq;                                                                                         \
always_latch                                                                                    \
 begin                                                                                          \
  if ((~gcckin)==1'b1) lq <= gcenin;                                                            \
 end                                                                                            \
wire ckenint;                                                                                   \
assign ckenint = lq | gctein ;                                                                  \
`CLKAND(gcenclkout, gcckin, ckenint)                                                            \
`endif

// Commented out after meeting on 24 March 2011 --> used in dunit/rtl/dunit/dunit.sv
`define MAKE_CLK_LOC_SOC(igatedclk, iipclk, itest_override, ilocal_function_gating, ilocal_power_gating, ilocal_power_gating_override) \
   clk_loc \``clk_loc_``igatedclk (                                                 \
                                 .gatedclk (igatedclk),                             \
                                 .ipclk (iipclk),                                   \
                                 .test_override (itest_override) ,                  \
                                 .local_function_gating (ilocal_function_gating),   \
                                 .local_power_gating (ilocal_power_gating),         \
                                 .local_power_gating_override (ilocal_power_gating_override));  


module clk_loc (output logic gatedclk, input logic ipclk, test_override, local_function_gating, local_power_gating, local_power_gating_override);
                     logic latout;
                     logic func_en;

  assign func_en = (local_power_gating | local_power_gating_override) & local_function_gating ;
  `CLK_GATE_W_OVERRIDE(gatedclk, ipclk, func_en, test_override)
endmodule


///============================================================================================
///
// LCP delay element macro
///===========================================================================================

module lcp_dly_elmt (clklcpdlyout,clklcpdlyin,c0lcpdlyin,c1lcpdlyin,f0lcpdlyin);
output clklcpdlyout;
input clklcpdlyin;
input c0lcpdlyin;
input c1lcpdlyin;
input f0lcpdlyin;
reg clklcpdlyout;
wire clklcpdlyin,c0lcpdlyin,c1lcpdlyin,f0lcpdlyin;
`ifdef DC
     `LIB_lcp_dly_elmt(clklcpdlyout,clklcpdlyin,c0lcpdlyin,c1lcpdlyin,f0lcpdlyin) 
`else
assign   clklcpdlyout = clklcpdlyin;
`endif
endmodule

module lcp_dly_dec (lcpdlyf0out,lcpdlyc0out,lcpdlyc1out,lcpdlysel0in,lcpdlysel1in);
output lcpdlyf0out;
output lcpdlyc0out;
output lcpdlyc1out;
input lcpdlysel0in;
input lcpdlysel1in;
wire lcpdlysel0in,lcpdlysel1in,lcpdlyf0out,lcpdlyc0out,lcpdlyc1out;
assign lcpdlyf0out = ((~lcpdlysel0in)&(~lcpdlysel1in));
assign lcpdlyc0out = lcpdlysel0in;
assign lcpdlyc1out = (lcpdlysel0in&lcpdlysel1in);
endmodule

// Commented out after meeting on 24 March 2011 -- Used in /nfs/site/disks/an_umg_disk1606/vlv_repo_02_28_2011/soc/rtl/cck/cckp.v
`define MAKE_LCP_DLY_ELEMENT(lcpdlyelementclkout,lcpdlyelementclkin,lcpdlyelementsel0in,lcpdlyelementsel1in)     \
wire lcpdlyelementclkout``_f0,lcpdlyelementclkout``_c0,lcpdlyelementclkout``_c1;                                 \
lcp_dly_dec \``lcpdlymac1_``lcpdlyelementclkout (                                                                \
                                                .lcpdlyf0out (lcpdlyelementclkout``_f0),                         \
                                                .lcpdlyc0out (lcpdlyelementclkout``_c0),                         \
                                                .lcpdlyc1out (lcpdlyelementclkout``_c1),                         \
                                                .lcpdlysel0in(lcpdlyelementsel0in),                              \
                                                .lcpdlysel1in(lcpdlyelementsel1in)                               \
                                               );                                                                \
lcp_dly_elmt \``lcpdlymac2_``lcpdlyelementclkout (                                                               \
                                                 .clklcpdlyout (lcpdlyelementclkout),                            \
                                                  .clklcpdlyin  (lcpdlyelementclkin),                            \
                                                  .c0lcpdlyin   (lcpdlyelementclkout``_c0),                      \
                                                  .c1lcpdlyin   (lcpdlyelementclkout``_c1),                      \
                                                  .f0lcpdlyin   (lcpdlyelementclkout``_f0)                       \
                                                 );       

// bwilk: Updating MAKE_LOC_OVERRIDE to PNW version to allow MDV checkin.
//`define MAKE_LOC_OVERRIDE(itest_override, idfx_ip_override, iscan_en, iresetb) \
//        make_loc_override \``loc_override_``itest_override ( \
//                .test_override          (itest_override), \
//                .dfx_ip_override        (idfx_ip_override), \
//                .scan_en                (iscan_en), \
//                .resetb                 (iresetb) \
//        );
//
//module make_loc_override (output logic test_override, input logic dfx_ip_override, scan_en, resetb);
//        assign test_override = dfx_ip_override || scan_en || ~resetb;
//endmodule

// bwilk: This is the PNW version
//
// Commented out after meeting on 24 March 2011 --> Used in common/rtl/dft_unit_controller.v
`define MAKE_LOC_OVERRIDE(itest_override, idfx_ip_override, iscan_en)   \
        make_loc_override \``loc_override_``itest_override (            \
                .test_override          (itest_override),               \
                .dfx_ip_override        (idfx_ip_override),             \
                .scan_en                (iscan_en)                      \
        );

module make_loc_override (output logic test_override, input logic dfx_ip_override, scan_en);
        assign test_override = dfx_ip_override || scan_en;
endmodule




////This macro has a decrementing counter and hence we would see a low phase on
////the output clock when get the usync.
//`define MAKE_CLK_DIV2OR4(idivoutclk, iipinclk, iusync, iseldiv2)     \
//clkdiv2or4 \``clk_div_2or4_``idivoutclk (                            \
//                                          .divoutclk(idivoutclk),    \
//                                          .ipinclk(iipinclk),        \
//                                          .usync(iusync),            \
//                                          .seldiv2(iseldiv2)         \
//                                        );
//
//module clkdiv2or4 (divoutclk, ipinclk, usync, seldiv2);
//output divoutclk;
//input  ipinclk;
//input  usync;
//input  seldiv2;
//
//logic [1:0] nxt;
//logic [1:0] pst;
//logic usync_lat;
//logic divinclk;
//logic divinclk_b;
//`LATCH_P_DESKEW(usync_lat, usync, ipinclk)
//`SET_MSFF(pst, nxt, ipinclk, usync_lat)
//assign nxt = ~(|(pst))? 2'b11:(pst - 1);
//assign divinclk_b = seldiv2? pst[0] : pst[1];
//assign divinclk  = ~divinclk_b; 
//clockdivff clockdivff_clkdiv2or4(
//                                  .ffout(divoutclk),
//                                  .ffin(divinclk),
//                                  .clockin(ipinclk)
//                                );
//endmodule

// Commented out after meeting on 24 March 2011 -> gfx/results_pipe2d/visa/disp2d/visasig_VALLEYVIEW/rmbus_sync.v;
//                                                 gfx/results_pipe2d/visa/disp2d/visasig_VALLEYVIEW/disp2d.v
module pulse_sync  #(parameter dataWidth = 1) 
  (
   input wire clk_wr, 
   input wire clk_rd,
   input wire rstn_wr,
   input wire rstn_rd,
   input wire [dataWidth-1:0] data_wr,
   input wire qual_wr,
   input wire qual_rd,
   
   output wire [dataWidth-1:0] data_rd
   
   );

  reg  [dataWidth-1:0]       bgf_input;
  wire [dataWidth-1:0] 	     bgf_output;
  reg [dataWidth-1:0] 	     bgf_output_s;
  integer     i,j;
  

  //according to input pulse toggling level indication
  always @(posedge clk_wr or negedge rstn_wr)
    if (!rstn_wr)
      bgf_input <= {dataWidth{1'b0}};
    else
      for (i=0;i<dataWidth;i=i+1) begin
	if (data_wr[i])
	  bgf_input[i] <= ~bgf_input[i];

      end
  //det sync level indication
  det_clkdomainX #(.dWidth(dataWidth), .fifo_depth(3), .separation(1)) det_clkdomainX0
    (
     .ckWr           (clk_wr),
     .reset_ckWr     (rstn_wr),
     .ckRd           (clk_rd),
     .reset_ckRd     (rstn_rd),
     .qualWr         (qual_wr),
     .qualRd         (qual_rd),
     //     .first_usyncWr  (first_usync_cz),
     //     .first_usyncRd  (first_usync_cd),
     .data_in        (bgf_input),
     .data_out       (bgf_output)
     );
  
  
  //level detection to create output pulse
  always @(posedge clk_rd or negedge rstn_rd)
    if (!rstn_rd)
      begin
	bgf_output_s <= {dataWidth{1'b0}};
    
      end
    else
      for(j=0;j<=dataWidth-1;j=j+1) begin
	bgf_output_s[j] <= bgf_output[j];
      end

  
  //generating output pulse
  assign data_rd = bgf_output ^ bgf_output_s;



 endmodule 



`endif //  `ifndef SOC_DFX_MACROS_VH

/*******************************************************************************************************************
*
 *  MACROS NOT BEING USED BY ANYONE ELSE - 
*  
*******************************************************************************************************************/

//module clk_glitchfree_mux (clk_out, sel_clka, usync_clka, clka_in, usync_clkb, clkb_in);
//output clk_out;
//input  sel_clka;
//input  usync_clka;
//input  clka_in;
//input  usync_clkb;
//input  clkb_in;
//logic sel_a_muxed, sel_a_muxed_h, sel_a_muxed_l, sel_b_muxed, sel_b_muxed_h, sel_b_muxed_l;
//
//assign sel_a_muxed = usync_clka ?  sel_clka : sel_a_muxed_h;
//assign sel_b_muxed = usync_clkb ? ~sel_clka : sel_b_muxed_h;
//
//`MSFF   (sel_a_muxed_h, sel_a_muxed, clka_in)
//`MSFF   (sel_b_muxed_h, sel_b_muxed, clkb_in)
//
//`LATCH_P(sel_a_muxed_l, sel_a_muxed_h, clka_in)
//`LATCH_P(sel_b_muxed_l, sel_b_muxed_h, clkb_in)
//
////NEEDS TO BE MAPPED TO LIB CELL ONCE LIB CELL IS ADDED TO LIBRARY
//assign clk_out = ( (sel_a_muxed_l & clka_in) | (sel_b_muxed_l & clkb_in) );
//
//endmodule
//
//`define MAKE_CLK_GLITCHFREE_MUX(clkout, selclka, usyncclka, clka, usyncclkb, clkb) \
//clk_glitchfree_mux \clk_glitchfree_mux``clkout (                                \
//                                                .clk_out       (clkout)         \
//                                                .sel_clka      (selclka)        \
//                                                .usync_clka    (usyncclka)      \
//                                                .clka_in       (clka)           \
//                                                .usync_clkb    (usyncclkb)      \
//                                                .clkb_in       (clkb)           \
//                                               );

//`define MAKE_SCAN_ARRAY_EN(iscanen_wr_out, iscanen_rd_out, ipulse_shaper, iipclk) \
//make_scan_array_en \``make_scan_array_en_``iscanen_wr_out ( \
//                                       .scanen_wr_out  (iscanen_wr_out), \
//                                       .scanen_rd_out  (iscanen_rd_out), \
//                                       .pulse_shaper   (ipulse_shaper), \
//                                       .ipclk          (iipclk) \
//                                       );
//
//module make_scan_array_en(output scanen_wr_out, scanen_rd_out, input pulse_shaper, ipclk);
//   logic temp, temp1;
//   assign scanen_wr_out = !temp1;
//   assign scanen_rd_out = temp1;
//   assign temp = scanen_wr_out & pulse_shaper;
//   `MSFF(temp1,temp, ipclk)
//endmodule // make_scan_array_en
//
//
////Note: please make sure there is no space if you concatenate several individual signals as input bus when use the following macro
////Bad:  `MAKE_SCANEN_FINAL(dfx_local_se, {vedclk_local_se, coreclk_local_se})
////Good: `MAKE_SCANEN_FINAL(dfx_local_se, {vedclk_local_se,coreclk_local_se})
////Good: assign temp_bus_se={vedclk_local_se, coreclk_local_se}; `MAKE_SCANEN_FINAL(dfx_local_se, temp_bus_se)
//
///* -----\/----- EXCLUDED -----\/-----
//`define MAKE_SCANEN_FINAL(iscanen_out,iscanen_in)                \
//        localparam  \``width_``iscanen_in  = $bits({iscanen_in});     \
//        logic [\``width_``iscanen_in  -1:0]  \``packed_``iscanen_in ; \
//        assign \``packed_``iscanen_in  ={>>{iscanen_in}};             \
//        assign iscanen_out= & \``packed_``iscanen_in ;              
// -----/\----- EXCLUDED -----/\----- */
//
///* -----\/----- EXCLUDED -----\/-----
//`define MAKE_SCANEN_FINAL(iscanen_out, iscanen_in) \
//        make_scanen_final  #($typeof(iscanen_in)) \``iscanen_out``_scanen_final (.scanen_out_final(iscanen_out), \
//                                                                            .scanen_in(iscanen_in));
//
//module make_scanen_final #(parameter type t_intype = logic) (output logic scanen_out_final, input t_intype scanen_in);
//   assign scanen_out_final = &scanen_in;
//endmodule // make_scanen_final
// -----/\----- EXCLUDED -----/\----- */
//
//`define MAKE_SCANEN_FINAL(iscanen_out, iscanen_in) \
//    localparam  \``width_``iscanen_in  = $bits({iscanen_in});     \
//    logic [\``width_``iscanen_in  -1:0]  \``packed_``iscanen_in ; \
//    assign \``packed_``iscanen_in  ={>>{iscanen_in}};             \
//    make_scanen_final  #(\``width_``iscanen_in ) \``iscanen_out``_scanen_final (.scanen_out_final(iscanen_out), .vector_in(\``packed_``iscanen_in ));
//
//module make_scanen_final(scanen_out_final, vector_in);
//output scanen_out_final;
//parameter width=100;
//logic scanen_out_final;
//input [width-1:0] vector_in;
//logic [width-1:0] vector_in;
//    assign scanen_out_final = &vector_in;
//endmodule // make_scanen_final
//
//
//`define PULSE_SYNC (dataWidth, clk_wr, clk_rd, rstn_wr, rstn_rd, qual_wr, qual_rd, data_wr, data_rd)  \
// pulse_sync \``pulse_sync_``o  #(.dWidth(dataWidth)) (                                                        \
//                                 .clk_wr  (clk_wr),   \
//				 .clk_rd  (clk_rd),   \
//				 .rstn_wr (rstn_wr),  \
//				 .rstn_rd (rstn_rd),  \
//				 .data_wr (data_wr),  \
//				 .qual_wr (qual_wr),  \
//				 .qual_rd (qual_rd),  \
//				 .data_rd (data_rd)   \
//                                );
//soc_dfx_macros.sv


//`define MAKE_CLK_LOC_LPSCAN(igatedclk, iipclk, itest_override, ifunc_en, ipwr_en, ipwr_ovrd, idfx_force_off) \
//clk_loc_lpscan \``clk_loc_lpscan_``igatedclk (                                                               \
//                                              .gatedclk(igatedclk),            // creating FF module to be used by clock macros below
//                                              .ipclk(iipclk),                                               \
//                                              .test_override(itest_override),                               \
//                                              .func_en(ifunc_en),                                           \
//                                              .pwr_en(ipwr_en),                                             \
//                                              .pwr_ovrd(ipwr_ovrd),                                         \
//                                              .dfx_force_off(idfx_force_off)                                \
//                                              );
//
//module clk_loc_lpscan (output logic gatedclk, input logic ipclk, input logic test_override, input logic func_en, input logic pwr_en, input logic pwr_ovrd, input logic dfx_force_off);
//logic lat_in;
//assign lat_in = (((pwr_en | pwr_ovrd) & func_en) | test_override ) & dfx_force_off;
//`CLK_GATE(gatedclk, ipclk, lat_in)
//endmodule


// `define DFX_REPLAY_SIZE 97
//

//`define MAKE_ATSPEED_SE(ilocal_scan_en, idfx_scan_en, igatedipclk, ilos_mode)       \
//        make_atspeed_se \``make_atspeedse_``ilocal_scan_en (                        \
//                                               .local_scan_en   (ilocal_scan_en),   \
//                                               .dfx_scan_en     (idfx_scan_en),     \
//                                               .gatedipclk      (igatedipclk),      \
//                                               .los_mode        (ilos_mode)); 
//
//module make_atspeed_se(output logic local_scan_en, input logic dfx_scan_en, gatedipclk, los_mode);
//  logic temp;
//  always@(posedge gatedipclk)
//    temp <= dfx_scan_en;
//  assign local_scan_en = los_mode ? (dfx_scan_en | temp) : dfx_scan_en;
//endmodule
//
//`define MAKE_CLK_GATE_TYPE1(igatedipclk, ipulse_shaper, idfx_scan_enable, idfx_atpg_mode, iresetb, idfx_global_en, idfx_global_override, iselect_ip_clk, iip_clk, idfx_pulse_cfg, iscan_shift_clk, iusync, iusync_override, iedt_update) \
//   clk_gate1 \``clkgate_type1_``igatedipclk (   /* lintra s-32522, s-32002, s-90001 */  \
//      .gatedipclk       (igatedipclk),                                                  \
//      .pulse_shaper     (ipulse_shaper),                                                \
//      .dfx_scan_enable  (idfx_scan_enable),                                             \
//      .dfx_atpg_mode    (idfx_atpg_mode),                                               \
//      .resetb           (iresetb),                                                      \
//      .dfx_global_en    (idfx_global_en),                                               \
//      .dfx_global_override      (idfx_global_override),                                 \
//      .select_ip_clk    (iselect_ip_clk),                                               \
//      .ip_clk           (iip_clk),                                                      \
//      .dfx_pulse_cfg    (idfx_pulse_cfg),                                               \
//      .scan_shift_clk   (iscan_shift_clk),                                              \
//      .usync            (iusync),                                                       \
//      .usync_override   (iusync_override),                                              \
//      .edt_update       (iedt_update));
//
//module clk_gate1 (output logic gatedipclk,
//                  output logic pulse_shaper,
//                  input logic dfx_scan_enable,
//                  input logic dfx_atpg_mode, 
//                  input logic resetb,
//                  input logic dfx_global_en,
//                  input logic dfx_global_override,
//                  input logic select_ip_clk,
//                  input logic ip_clk,
//                  input logic [2:0] dfx_pulse_cfg,
//                  input logic scan_shift_clk,
//                  input logic usync,
//                  input logic usync_override,
//                  input logic edt_update);
//   logic muxsel, temp1, temp2, temp3, temp4, temp5, temp6, temp2_d;
//   logic [8:0] global_en_d;
//   logic [7:0] temp;
//
//   assign muxsel = dfx_scan_enable & dfx_atpg_mode;
//   
//   always @(posedge ip_clk)
//     global_en_d <= {dfx_global_en, global_en_d[8:1]};
//   
//   integer     i;
//   always_comb
//     begin
//       for (i=0; i<=7; i=i+1)
//         begin
//           temp[i] = ~global_en_d[0] & global_en_d[i+1];
//         end
//       temp1 = temp[dfx_pulse_cfg];
//     end
//   
//   assign pulse_shaper = temp1;
//   
//   assign temp2 = ((usync | usync_override) & (dfx_global_en | dfx_global_override)) |
//                  (!(usync | usync_override) & temp2_d);
//   
//
//  `SET_MSFF(temp2_d, temp2, ip_clk, ~resetb)
//
//  assign temp3 = dfx_atpg_mode ? temp1 : temp2_d;
//  assign temp4 = temp3 & select_ip_clk;
// 
//  `CLKAND(temp5, scan_shift_clk, ~edt_update)
//
//  `CLK_GATE(temp6, ip_clk, temp4)
//
//  `MAKE_CLK_2TO1MUX(gatedipclk, temp6, temp5, muxsel)
//
//endmodule
//
//
//`define MAKE_CLK_GATE_TYPE2(igatedipclk, ipulse_shaper, idfx_scan_enable, idfx_atpg_mode, iresetb, idfx_global_en, idfx_global_override, icoreclk, iselect_ip_clk, idfx_pulse_cfg, iscan_shift_clk, iusync, iusync_override, iedt_update, iclk_pwr_en)  \
//   clk_gate2  \``clkgate_type2_``igatedipclk ( /* lintra s-32522, s-32002, s-90001 */   \
//        .gatedipclk         (igatedipclk),                                              \
//        .pulse_shaper       (ipulse_shaper),                                            \
//        .dfx_scan_enable    (idfx_scan_enable),                                         \
//        .dfx_atpg_mode      (idfx_atpg_mode),                                           \
//        .resetb             (iresetb),                                                  \
//        .dfx_global_en      (idfx_global_en),                                           \
//        .dfx_global_override(idfx_global_override),                                     \
//        .coreclk            (icoreclk),                                                 \
//        .select_ip_clk      (iselect_ip_clk),                                           \
//        .dfx_pulse_cfg      (idfx_pulse_cfg),                                           \
//        .scan_shift_clk     (iscan_shift_clk),                                          \
//        .usync              (iusync),                                                   \
//        .usync_override     (iusync_override),                                          \
//        .edt_update         (iedt_update),                                              \
//        .clk_pwr_en         (iclk_pwr_en));
//
//module clk_gate2  (output logic gatedipclk,
//                   output logic pulse_shaper,
//                   input logic dfx_scan_enable,
//                   input logic dfx_atpg_mode, 
//                   input logic resetb,
//                   input logic dfx_global_en,
//                   input logic dfx_global_override,
//                   input logic coreclk,
//                   input logic select_ip_clk,
//                   input logic [2:0] dfx_pulse_cfg,
//                   input logic scan_shift_clk,
//                   input logic usync, 
//                   input logic usync_override, 
//                   input logic edt_update,
//                   input logic clk_pwr_en);
//
//  logic muxsel, temp1, temp2, temp2_d, 
//        temp3, temp4, temp5, temp6, temp7, temp7_d;
//  logic [8:0] global_en_d;
//  logic [7:0] temp;
//  assign muxsel = dfx_scan_enable & dfx_atpg_mode;
//  always@(posedge coreclk)
//    global_en_d <= {dfx_global_en, global_en_d[8:1]};
//   
//   integer    i;              
//   always_comb
//     begin
//       for (i=0; i<=7; i=i+1)
//         begin
//           temp[i] = ~global_en_d[0] & global_en_d[i+1];
//         end
//       temp1 = temp[dfx_pulse_cfg];
//     end
//   
//   assign pulse_shaper = temp1;
//   
//  assign temp2 = ((usync | usync_override) & (dfx_global_en | dfx_global_override)) |
//                 (!(usync | usync_override) & temp2_d);
//  assign temp7 = (clk_pwr_en & (usync | usync_override)) |
//                 (!(usync | usync_override) & temp7_d);
//                   
//  `SET_MSFF(temp2_d, temp2, coreclk, ~resetb)
//  `SET_MSFF(temp7_d, temp7, coreclk, ~resetb)
//                   
//  assign temp3 = dfx_atpg_mode ? temp1 : temp2_d;
//  assign temp4 = temp3 & select_ip_clk & (temp7_d | dfx_atpg_mode);
// 
//  `CLKAND(temp5, scan_shift_clk, ~edt_update)
//
//  `CLK_GATE(temp6, coreclk, temp4)
//
//  `MAKE_CLK_2TO1MUX(gatedipclk, temp6, temp5, muxsel)
//
//endmodule 
//
// `define MAKE_CLK_GATE_TYPE3(igatedipclk, iresetb, idfx_global_en, idfx_global_override, iip_clk, idfx_atpg_mode, iselect_ip_clk, iusync, iusync_override) \
//    clk_gate3 \``clkgate_type3_``igatedipclk (   /* lintra s-32522, s-32002, s-90001 */             \
//         .gatedipclk     (igatedipclk),                                                             \
//         .resetb         (iresetb),                                                                 \
//         .dfx_global_en  (idfx_global_en),                                                          \
//         .dfx_global_override    (idfx_global_override),                                            \
//         .ip_clk (iip_clk),                                                                         \
//         .dfx_atpg_mode  (idfx_atpg_mode),                                                          \
//         .select_ip_clk  (iselect_ip_clk),                                                          \
//         .usync          (iusync),                                                                  \
//         .usync_override (iusync_override));
//
// module clk_gate3 (output logic gatedipclk,
//                   input logic resetb, 
//                   input logic dfx_global_en,
//                   input logic dfx_global_override,
//                   input logic ip_clk, 
//                   input logic dfx_atpg_mode,
//                   input logic select_ip_clk,
//                   input logic usync,
//                   input logic usync_override);
//   logic temp, temp1, temp_d;
//   logic temp2;
//
//
//   assign temp1 =  ~dfx_atpg_mode &
//                   select_ip_clk &
//                   temp_d;
//
//   assign temp = ((usync | usync_override) & (dfx_global_en | dfx_global_override)) |
//                 (!(usync | usync_override) & temp_d);
//
//   `SET_MSFF(temp_d, temp, ip_clk, ~resetb)
//
//   `CLK_GATE(gatedipclk, ip_clk, temp1)
//   
// endmodule
//
