//==============================================================
//  Copyright (c) 2010 Intel Corporation, all rights reserved.
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY
//  COPYRIGHT LAWS AND IS CONSIDERED A TRADE SECRET BELONGING
//  TO THE INTEL CORPORATION.
//
//  Intel Confidential
//==============================================================
//
// MOAD Begin
//     File/Block                             : vlv_macro_tech_map.vh
//     Design Style [rls|rf|ssa_fuse|sdp|
//                   custom|hier|rls_hier]    : none
//     Circuit Style [non_rfs|rfs|ssa|fuse|
//                    IO|ROM|none]            : none
//     Common_lib (for custom blocks only)    : none  
//     Library (must be same as module name)  : none
//     Unit [unit id or shared]               : shared
//     Complex [North, South, CPU]            : shared
//     Bizgroup [LCP|SEG|ULMD]                : ULMD
//
// Design Unit Owner : ram.m.krishnamurthy@intel.com
// Primary Contact   : ram.m.krishnamurthy@intel.com
// 
// MOAD End
//===============================================================


`ifndef __vlv_macro_tech_map__vh
`define __vlv_macro_tech_map__vh

`ifndef P1266 //REPLACE WITH PROPER define ONCE ADDED INTO BUILDS
  


module power_switch_wrapper (gtdout,a,vccin,o);
input vccin, a;
output gtdout, o;
`ifdef SYNTH_YD8
   yd8pwb00ln1a1 power_switch (.o(o),.a(a));
`elsif SYNTH_B12
   b12pwb0wdx10 power_switch(.o(o),.a(a));
`endif
endmodule


`define LIB_POWERSWITCH(pwren_out, vcc_out, pwren_in, vcc_in, vss_in)                                      \
    power_switch_wrapper \``vcc_out``_dcszo (.gtdout(vcc_out),.a(pwren_in),.vccin(vcc_in),.o(pwren_out));  \


`define LIB_LV_BUF(o,a)                                                \
`ifdef SYNTH_B12                                                       \
    b12bf00wnx05  \``o``_dcszo <$typeof(o)> (.o(<(o)>), .a(<(a)>));    \
`elsif SYNTH_YD8                                                       \
    yd8bf00lnx05  \``o``_dcszo <$typeof(o)> (.o(<(o)>), .a(<(a)>));    \
`endif

`define LIB_FIREWALL_AND(out,data,enable)                                                   \
`ifdef SYNTH_B12                                                                            \
    b12afw0wnx50 \``out``_dcszo <$typeof(out)> (.o(<(out)>),.en(enable),.a(<(data)>));      \
`elsif SYNTH_YD8                                                                            \
    yd8afw00ln0e0 \``out``_dcszo <$typeof(out)> (.o(<(out)>),.en(enable),.a(<(data)>));     \
`endif


`define LIB_FIREWALL_OR(out,data,enable)                                                                \
`ifdef SYNTH_B12                                                                                        \
    wire [$bits(out)-1:0] \``tmp_``out ;                                                                \
    b12siriwnx30 \``out``_pin_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>), .a(enable));                 \
    b12ofw0wnx30 \``out``_dcszo     <$typeof(out)> (.o(<(out)>),.en(<(\``tmp_``out )>),.a(<(data)>));   \
`elsif SYNTH_YD8                                                                                        \
    wire [$bits(out)-1:0] \``tmp_``out ;                                                                \
    yd8pin00ln0d0 \``out``_pin_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>), .a(enable));                \
    yd8ofw00ln0e0 \``out``_dcszo     <$typeof(out)> (.o(<(out)>),.en(<(\``tmp_``out )>),.a(<(data)>));  \
`endif


`define LIB_LS_LATCH_UP(outb,iwrite_en,ipro,ib)                                                                             \
`ifdef SYNTH_B12                                                                                                            \
    b12bn01wnx10 \``outb``_dcszo <$typeof(outb)> (.a(<(ib)>), .enb(iwrite_en), .ob(<(outb)>));                              \
`elsif SYNTH_YD8                                                                                                            \
    yd8bln00ln0l0 \``outb``_dcszo <$typeof(outb)> (.b(<(ib)>), .write_en(iwrite_en), .vccpro_1p05(ipro), .ob(<(outb)>));    \
`endif


`define LIB_LS_LATCH_DN(outb,iwrite_en,ipro,ib)                                                                             \
`ifdef SYNTH_B12                                                                                                            \
    b12bn01wnx10 \``outb``_dcszo <$typeof(outb)> (.a(<(ib)>), .enb(iwrite_en), .ob(<(outb)>));                              \
`elsif SYNTH_YD8                                                                                                            \
    yd8bln01ln0l0 \``outb``_dcszo <$typeof(outb)> (.b(<(ib)>), .write_en(iwrite_en), .vccpro_1p05(ipro), .ob(<(outb)>));    \
`endif


`define LIB_LS_WITH_AND_FW(mo, mpro, ma, mvccin, men)                                                                           \
`ifdef SYNTH_B12                                                                                                                \
    b12ba00wnx10 \``mo``_bla_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .o(<(mo)>));                                            \
`elsif SYNTH_YD8                                                                                                                \
    yd8bla00ln0a0 \``mo``_bla_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .vccpro_1p05(mpro), .vccin_1p05(mvccin),.o(<(mo)>));   \
`endif


// Mapped to a yd8 ln version. Need to map to a nn version if we get one in the library release
`define LIB_ASYNC_RSTB_MSFF_HF_NONSCAN(q,i,clock,rstb)                                                                \
`ifdef SYNTH_B12                                                                                                      \
   b12fa62wnx10  \``q``_reg_dcszo_nonscan <$typeof(q)> (.ck(clock), .d(<(i)>), .rb(rstb), .o(<(\``q``_nonscan )>));   \
`elsif SYNTH_YD8                                                                                                      \
   yd8ma82lnx20  \``q``_reg_dcszo_nonscan <$typeof(q)> (.ck(clock), .d(<(i)>), .rb(rstb), .o(<(\``q``_nonscan )>));   \
`endif

`define LIB_LS_WITH_OR_FW(mo, mpro, ma, mvccin, men)                                                                            \
`ifdef SYNTH_B12                                                                                                                \
    b12bo00wnx10 \``mo``_blo_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .o(<(mo)>));                                            \
`elsif SYNTH_YD8                                                                                                                \
    yd8blo00ln0a0 \``mo``_blo_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .vccpro_1p05(mpro), .vccin_1p05(mvccin),.o(<(mo)>));   \
`endif

`define LIB_POWER_INVERTER_D(powerenout, powerenin, vcc_in)                                                                 \
`ifdef SYNTH_B12                                                                                                            \
    b12siriwnx30 \``powerenout``_pin_dcszo <$typeof(powerenout)> (.o(<(powerenout)>) , .a(<(powerenin)>));                  \
`elsif SYNTH_YD8                                                                                                            \
    yd8pin00ln0d0 \``powerenout``_pin_dcszo <$typeof(powerenout)> (.o(<(powerenout)>) , .a(<(powerenin)>));                 \
`endif

`define LIB_INV_PRSRV(outb,in)                                                              \
`ifdef SYNTH_B12                                                                            \
    b12in00wnx10 \``outb``_tieoff_inv_dcszo <$typeof(outb)> (.o(<(outb)>) , .a(<(in)>));    \
`elsif SYNTH_YD8                                                                            \
    yd8in00lnx10 \``outb``_tieoff_inv_dcszo <$typeof(outb)> (.o(<(outb)>) , .a(<(in)>));    \
`endif

`define LIB_TIEOFF_0_PRSRV(out)                                                                                         \
`ifdef SYNTH_B12                                                                                                        \
    wire [$bits(out)-1:0] \``tmp_``out ;                                                                                \
    b12in00wnx10 \``out``_tieoff_inv1_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>) , .a(<({$bits(out){1'b0}})>));        \
    b12in00wnx10 \``out``_tieoff_inv2_dcszo <$typeof(out)> (.o(<(out)>) , .a(<(\``tmp_``out )>));                       \
`elsif SYNTH_YD8                                                                                                        \
    wire [$bits(out)-1:0] \``tmp_``out ;                                                                                \
    yd8in00lnx10 \``out``_tieoff_inv1_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>) , .a(<({$bits(out){1'b0}})>));        \
    yd8in00lnx10 \``out``_tieoff_inv2_dcszo <$typeof(out)> (.o(<(out)>) , .a(<(\``tmp_``out )>));                       \
`endif

`define LIB_TIEOFF_1_PRSRV(out)                                                                                         \
`ifdef SYNTH_B12                                                                                                        \
    wire [$bits(out)-1:0] \``tmp_``out ;                                                                                \
    b12in00wnx10 \``out``_tieoff_inv1_dcszo <$typeof(out)> (.o(<(out)>) , .a(<({$bits(out){1'b0}})>));                  \
    b12in00wnx10 \``out``_tieoff_inv2_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>) , .a(<(out)>));                       \
`elsif SYNTH_YD8                                                                                                        \
    wire [$bits(out)-1:0] \``tmp_``out ;                                                                                \
    yd8in00lnx10 \``out``_tieoff_inv1_dcszo <$typeof(out)> (.o(<(out)>) , .a(<({$bits(out){1'b0}})>));                  \
    yd8in00lnx10 \``out``_tieoff_inv2_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>) , .a(<(out)>));                       \
`endif
      
`define LIB_BUF_1NS_DELAY_UNGATED(out,in,vcc_in)                                                           \
`ifdef SYNTH_B12                                                                                           \
    b12dly0wnx10 \``out``_buf_1ns_dly_dcszo <$typeof(out)> (.o(<(out)>) , .a(<(in)>) );                    \
`elsif SYNTH_YD8                                                                                           \
    yd8dly00ln0a0 \``out``_buf_1ns_dly_dcszo <$typeof(out)> (.o(<(out)>) , .a(<(in)>) );                   \
`endif


`define LIB_lcp_dly_elmt(clklcpdlyout,clklcpdlyin,rsel0lcpdlyin,rsel1lcpdlyin,rsel2lcpdlyin)                                                                               \
`ifdef SYNTH_B12                                                                                                                                                           \
    b12lcp0wnd1 clklcpdlyout_1_dcszo (.ckout(clklcpdlyout), .ck(clklcpdlyin), .rsel0(rsel0lcpdlyin), .rsel1(rsel1lcpdlyin), .rsel2(rsel2lcpdlyin));                        \
`elsif SYNTH_YD8                                                                                                                                                           \
    yd8cb50lnd1 clklcpdlyout_1_dcszo (.ckout(clklcpdlyout), .ck(clklcpdlyin), .rsel0(rsel0lcpdlyin), .rsel1(rsel1lcpdlyin), .rsel2(rsel2lcpdlyin), .rsel3(1'b1));          \
`endif

// Mapped to a yd8 ln version. Need to map to a nn version if we get one in the library release
`define LIB_clockdivffreset(ffoutreset, ffinresetb, clockinreset,resetckdivff)                        \
`ifdef SYNTH_B12                                                                                      \
    b12ma12wnd3 ckdiv2ff1 (.o(ffoutreset), .db(ffinresetb), .ck(clockinreset), .rb(resetckdivff));    \
`elsif SYNTH_YD8                                                                                      \
    yd8ma72lnd3 ckdiv2ff1 (.o(ffoutreset), .db(ffinresetb), .ck(clockinreset), .rb(resetckdivff));    \
`endif

// Mapped to a yd8 ln version. Need to map to a nn version if we get one in the library release
`define LIB_clockdivff(ffout, ffin, clockin)                                        \
`ifdef SYNTH_B12                                                                    \
    b12ma12wnd1 ckdiv2ff1 (.o(ffout), .db(ffin), .ck(clockin), .rb(1'b1));          \
`elsif SYNTH_YD8                                                                    \
    yd8ma72lnd1 ckdiv2ff1 (.o(ffout), .db(ffin), .ck(clockin), .rb(1'b1));          \
`endif


`define LIB_clkinv(clkout,clkin)                       \
`ifdef SYNTH_B12                                       \
    b12ci00wnd0 clkinv1_dcszo (.o(clkout),.ck(clkin)); \
`elsif SYNTH_YD8                                       \
    yd8ci00lnd0 clkinv1_dcszo (.o(clkout),.ck(clkin)); \
`endif       


`define LIB_clk2to1mux(ckmuxout,ckin1,ckin2,muxselect)                              \
`ifdef SYNTH_B12                                                                    \
    b12cmx2wnd4 ckmux1_dcszo (.o(ckmuxout), .d1(ckin1), .d2(ckin2), .s(muxselect)); \
`elsif SYNTH_YD8                                                                    \
    yd8cb01lnd4 ckmux1_dcszo (.o(ckmuxout), .d1(ckin1), .d2(ckin2), .s(muxselect)); \
`endif       


`define LIB_clkor(ckoout, ckoin1,ckoin2)                                    \
`ifdef SYNTH_B12                                                            \
    wire ckooutbar;                                                         \
    b12cno2wnd0   ckor1_dcszo (.o(ckooutbar),.ck1(ckoin1),.ck2(ckoin2));    \
    b12ci00wnd2   ckor2_dcszo (.o(ckoout), .ck(ckooutbar));                 \
`elsif SYNTH_YD8                                                            \
    wire ckooutbar;                                                         \
    yd8noc02ln0b0 ckor1_dcszo (.o(ckooutbar),.ck1(ckoin1),.ck2(ckoin2));    \
    yd8ci00lnd2   ckor2_dcszo (.o(ckoout), .ck(ckooutbar));                 \
`endif       

                
`define LIB_clkoren(clkorenout,clkorenckin,clkorenenin)                                 \
`ifdef SYNTH_B12                                                                        \
    wire ckooutbar;                                                                     \
    b12cno0wnd0 clkoren1_dcszo (.o(ckooutbar),.ck(clkorenckin),.en(clkorenenin));       \
    b12ci00wnd0   clkoren2_dcszo (.o(clkorenout),.ck(ckooutbar));                       \
`elsif SYNTH_YD8                                                                        \
    wire ckooutbar;                                                                     \
    yd8noc00ln0b0 clkoren1_dcszo (.o(ckooutbar),.clk(clkorenckin),.en(clkorenenin));    \
    yd8ci00lnd0   clkoren2_dcszo (.o(clkorenout),.ck(ckooutbar));                       \
`endif       

`define LIB_clknor(ckoout,ckoin1,ckoin2)                                    \
`ifdef SYNTH_B12                                                            \
    b12cno2wnd0  cknor_dcszo (.o(ckoout),.ck1(ckoin1),.ck2(ckoin2));        \
`elsif SYNTH_YD8                                                            \
    yd8noc02ln0b0 cknor_dcszo (.o(ckoout),.ck1(ckoin1),.ck2(ckoin2));       \
`endif

`define LIB_clknoren(clknorenout,clknorenckin,clknorenenin)                                 \
`ifdef SYNTH_B12                                                                            \
    b12cno0wnd0 clkoren1_dcszo (.o(clknorenout),.ck(clknorenckin),.en(clknorenenin));       \
`elsif SYNTH_YD8                                                                            \
    yd8noc00ln0b0 clkoren1_dcszo (.o(clknorenout),.clk(clknorenckin),.en(clknorenenin));    \
`endif

`define LIB_clkanden(outclk,inclk,enable)                                                                       \
`ifdef SYNTH_B12                                                                                                \
    b12can0wnd0 \``clkand_dcszo_``outclk  <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(outclk)>));  \
`elsif SYNTH_YD8                                                                                                \
`endif                                                                                                          \

`define LIB_clk16delay(clk16delayout,clk16delayin,clk16in0,clk16in1,clk16in2,clk16in3,clk16in4,clk16in5,clk16in6,clk16in7,clk16in8,clk16in9,clk16in10,clk16in11,clk16in12,clk16in13,clk16in14)                  \
`ifdef SYNTH_B12                                                                                                    \
     b12dcc0wnd1 clk16delay_dcszo (.o(clk16delayout),  .rsel0(clk16in0),   .rsel1(clk16in1),   .rsel2(clk16in2),    \
                                     .rsel3(clk16in3),   .rsel4(clk16in4),   .rsel5(clk16in5),   .rsel6(clk16in6),  \
                                     .rsel7(clk16in7),   .rsel8(clk16in8),   .rsel9(clk16in9),   .rsel10(clk16in10),\
                                     .rsel11(clk16in11), .rsel12(clk16in12), .rsel13(clk16in13),                    \
                                     .rsel14(clk16in14), .ck(clk16delayin));                                        \
`elsif SYNTH_YD8                                                                                                    \
     yd8dcc16ln0a0 clk16delay_dcszo (.o(clk16delayout),  .rsel0(clk16in0),   .rsel1(clk16in1),   .rsel2(clk16in2),  \
                                     .rsel3(clk16in3),   .rsel4(clk16in4),   .rsel5(clk16in5),   .rsel6(clk16in6),  \
                                     .rsel7(clk16in7),   .rsel8(clk16in8),   .rsel9(clk16in9),   .rsel10(clk16in10),\
                                     .rsel11(clk16in11), .rsel12(clk16in12), .rsel13(clk16in13),                    \
                                     .rsel14(clk16in14), .clk(clk16delayin));                                       \
`endif


`define LIB_soc_rbe_clk(ckrcbxpn,ckgridxpn,latrcben)                                     \
`ifdef SYNTH_B12                                                                         \
    b12gb01wnd0 ckrbexpnrcb_dcszo (.enclk(ckrcbxpn),.ck(ckgridxpn),.en(latrcben),.te(1'b0));     \
`elsif SYNTH_YD8                                                                         \
    yd8gb00lnd0 ckrbexpnrcb_dcszo (.enclk(ckrcbxpn),.ck(ckgridxpn),.en(latrcben));       \
`endif

//Mapped to a yd8 ln version. Need to map to a nn version if we get one in the library release
`define LIB_soc_rbe_clk_hf(ckrcbxpn,ckgridxpn,latrcben)                                     \
`ifdef SYNTH_B12                                                                            \
    b12gb01wnd0 ckrbexpnrcb_hf_dcszo (.enclk(ckrcbxpn),.ck(ckgridxpn),.en(latrcben),.te(1'b0));     \
`elsif SYNTH_YD8                                                                            \
    yd8gb70lnd0 ckrbexpnrcb_hf_dcszo (.enclk(ckrcbxpn), .ck(ckgridxpn), .en(latrcben));     \
`endif

`define LIB_SOC_CLKAND(outclk,inclk,enable)                                                                                     \
`ifdef SYNTH_B12                                                                                                                \
    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                                  \
    b12cna0wnd0 \``clknand_dcszo_``outclk <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(\``tmp_``outclk )>));        \
    b12ci00wnd0 \``clkinv_dcszo_``outclk <$typeof(outclk)> (.ck(<(\``tmp_``outclk )>), .o(<(outclk)>));                         \
`elsif SYNTH_YD8                                                                                                                \
    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                                  \
    yd8nac00ln0e0 \``clknand_dcszo_``outclk <$typeof(outclk)> (.clk(<(inclk)>), .en(<(enable)>), .o(<(\``tmp_``outclk )>));     \
    yd8ci00lnd0 \``clkinv_dcszo_``outclk <$typeof(outclk)> (.ck(<(\``tmp_``outclk )>), .o(<(outclk)>));                         \
`endif


`define LIB_clk_gate_kin(ckrcbxpn1,ckgridxpn1,latrcben1,testen1)                                            \
`ifdef SYNTH_B12                                                                                            \
    b12gb01wnd0 \ckrcbcell_ckrcbxpn1_dcszo (.enclk(ckrcbxpn1),.ck(ckgridxpn1),.en(latrcben1),.te(testen1)); \
`elsif SYNTH_YD8                                                                                            \
    yd8gb01lnd0 \ckrcbcell_ckrcbxpn1_dcszo (.enclk(ckrcbxpn1),.ck(ckgridxpn1),.en(latrcben1),.te(testen1)); \
`endif


`define LIB_CLKBF_SOC(clkbufout,clkbufin)                                  \
`ifdef SYNTH_B12                                                           \
    b12cb00wnd0 \``clkbufout``_i0_dcszo (.o(clkbufout),.ck(clkbufin));     \
`elsif SYNTH_YD8                                                           \
    yd8cb00lnd0 \``clkbufout``_i0_dcszo (.o(clkbufout),.ck(clkbufin));     \
`endif

`define LIB_CLKBF_GLITCH_GLOB(clkout, clkin)                               \
`ifdef SYNTH_B12                                                           \
    b12dwcbwnd1 \``clkout``_i0_dcszo (.o(clkout),.ck(clkin));              \
`elsif SYNTH_YD8                                                           \
    yd8dwcblnd1 \``clkout``_i0_dcszo (.o(clkout),.ck(clkin));              \
`endif
      
`define LIB_CLKINV_SOC(clkinvout,clkinvin)                                 \
`ifdef SYNTH_B12                                                           \
    b12ci00wnd0 \``clkinvout``_i0_dcszo (.o(clkinvout),.ck(clkinvin));     \
`elsif SYNTH_YD8                                                           \
    yd8ci00lnd0 \``clkinvout``_i0_dcszo (.o(clkinvout),.ck(clkinvin));     \
`endif

`define LIB_MSFF_NONSCAN(q,i,clock)                                                                        \
`ifdef SYNTH_B12                                                                                           \
    b12ms00wnx05 \``q``_reg_dcszo_nonscan <$typeof(q)> (.o(<(\``q``_nonscan )>), .d(<(i)>), .ck(clock));   \
`elsif SYNTH_YD8                                                                                           \
    yd8ms00lnx05 \``q``_reg_dcszo_nonscan <$typeof(q)> (.o(<(\``q``_nonscan )>), .d(<(i)>), .ck(clock));   \
`endif

`define LIB_ASYNC_RST_2MSFF_META(q, i, clk, rstb)                                                                       \
`ifdef SYNTH_B12                                                                                                        \
    b12mas2wnx10  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .ck(clk), .rb(rstb), .so(), .si(1'b0), .ss(1'b0));   \
`elsif SYNTH_YD8                                                                                                        \
    yd8mas02lnx10 \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .ck(clk), .rb(rstb));                                \
`endif


`define LIB_ASYNC_SET_2MSFF_META(q, i, clk, ipsb)                                                                       \
`ifdef SYNTH_B12                                                                                                        \
    wire [$bits(q)-1:0] \``inv1_``q ;                                                                                   \
    wire [$bits(q)-1:0] \``inv2_``q ;                                                                                   \
    b12in00wnx10  \``q``i1_dcszo <$typeof(q)> (.o(<(\``inv1_``q )>), .a(<(i)>));                                        \
    b12mas2wnx10  \``q``_dcszo <$typeof(q)> (.o(<(\``inv2_``q )>), .d(<(\``inv1_``q )>), .ck(clk), .rb(ipsb));          \
    b12in00wnx10  \``q``i2_dcszo <$typeof(q)> (.o(<(q)>), .a(<(\``inv2_``q )>));                                        \
`elsif SYNTH_YD8                                                                                                        \
    yd8mas01lnx10 \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .ck(clk), .psb(ipsb));                               \
`endif                                                                                                                  \


`define LIB_SOC_MSFF_META(q,i,clock)                                                                \
`ifdef SYNTH_B12                                                                                    \
  b12fa62wnx10 \``q``meta_flop_dcszo <$typeof(q)> (.ck(clock), .d(<(i)>), .rb(1'b1), .o(<(q)>));    \
`elsif SYNTH_YD8                                                                                    \
  yd8ma82lnx10 \``q``meta_flop_dcszo <$typeof(q)> (.ck(clock), .d(<(i)>), .rb(1'b1), .o(<(q)>));    \
`endif

`define LIB_ASYNC_RST_MSFF_META(q, i, clk, rstb)                                                    \
`ifdef SYNTH_B12                                                                                    \
  b12fa62wnx10 \``q``_dcszo <$typeof(q)> (.ck(clk), .d(<(i)>), .rb(rstb), .o(<(q)>));               \
`elsif SYNTH_YD8                                                                                    \
  yd8ma82lnx10 \``q``_dcszo <$typeof(q)> (.ck(clk), .d(<(i)>), .rb(rstb), .o(<(q)>));               \
`endif

`define LIB_NAND_3TO1MUX(out,in1,in2,in3,sel1,sel2,sel3)                            \
`ifdef SYNTH_B12                                                                    \
    wire n1;                                                                        \
    wire n2;                                                                        \
    wire n3;                                                                        \
    b12na02wnx05 \``i1_dcszo_``out (.o(n1),.a(in1),.b(sel1));                       \
    b12na02wnx05 \``i2_dcszo_``out (.o(n2),.a(in2),.b(sel2));                       \
    b12na02wnx05 \``i3_dcszo_``out (.o(n3),.a(in3),.b(sel3));                       \
    b12na03wnx05 \``i4_dcszo_``out (.o(out),.a(n1),.b(n2),.c(n3));                  \
`elsif SYNTH_YD8                                                                    \
    wire n1;                                                                        \
    wire n2;                                                                        \
    wire n3;                                                                        \
    yd8na02lnx05 \``i1_dcszo_``out (.o(n1),.a(in1),.b(sel1));                       \
    yd8na02lnx05 \``i2_dcszo_``out (.o(n2),.a(in2),.b(sel2));                       \
    yd8na02lnx05 \``i3_dcszo_``out (.o(n3),.a(in3),.b(sel3));                       \
    yd8na03lnx05 \``i4_dcszo_``out (.o(out),.a(n1),.b(n2),.c(n3));                  \
`endif // ifdef SYNTH_B12

// used ln version for yd8 cells as nn was not available. Change to nn if present
`define LIB_MUX_2TO1_HF(out,in1,in2,sel)                                                            \
`ifdef SYNTH_B12                                                                                    \
  b12mx22wnx30 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .d1(<(in1)>), .d2(<(in2)>), .s(sel));    \
`elsif SYNTH_YD8                                                                                    \
  yd8mx22lnx50 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .d1(<(in1)>), .d2(<(in2)>), .s(sel));    \
`endif // ifdef SYNTH_B12

// used ln version for yd8 cells as nn was not available. Change to nn if present
`define LIB_MUX_2TO1_INV_HF(out,in1,in2,sel)                                                        \
`ifdef SYNTH_B12                                                                                    \
  b12mx12wnx30 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .d1(<(in1)>), .d2(<(in2)>), .s(sel));    \
`elsif SYNTH_YD8                                                                                    \
  yd8mx12lnx50 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .d1(<(in1)>), .d2(<(in2)>), .s(sel));    \
`endif // ifdef SYNTH_B12
      
`define LIB_clk_glitchfree_mux_part(out, clka, clkb, sela, selb)                                   \
`ifdef SYNTH_B12                                                                                   \
      b12gm22wnd0 \``out``_dcszo (.cka(clka), .ckb(clkb), .sa(sela), .sb(selb), .o(out));          \
`elsif SYNTH_YD8                                                                                   \
      yd8gm22lnd0 \``out``_dcszo (.cka(clka), .ckb(clkb), .sa(sela), .sb(selb), .o(out));          \
`endif

// used ln version for yd8 cells as nn was not available. Change to nn if present
`define LIB_compare_6_bit(out, in1, in2)                                                           \
`ifdef SYNTH_B12                                                                                   \
   wire [5:0] comp1 ;                                                                              \
   wire [1:0] comp2 ;                                                                              \
   b12xn00wnx05 \``comp_dcszo_``out <$typeof(comp1)> (.o(<(comp1)>), .a(<(in1)>), .b(<(in2)>));    \
   b12na03wnx50 \``comp1_dcszo_``out (.o(comp2[0]), .a(comp1[0]), .b(comp1[1]), .c(comp1[2]));     \
   b12na03wnx50 \``comp2_dcszo_``out (.o(comp2[1]), .a(comp1[3]), .b(comp1[4]), .c(comp1[5]));     \
   b12no02wnx30 \``comp3_dcszo_``out (.o(out), .a(comp2[0]), .b(comp2[1]));                        \
`elsif SYNTH_YD8                                                                                   \
   wire [5:0] comp1 ;                                                                              \
   wire [1:0] comp2 ;                                                                              \
   yd8xn00lnx40 \``comp_dcszo_``out <$typeof(comp1)> (.o(<(comp1)>), .a(<(in1)>), .b(<(in2)>));    \
   yd8na03lnx50 \``comp1_dcszo_``out (.o(comp2[0]), .a(comp1[0]), .b(comp1[1]), .c(comp1[2]));     \
   yd8na03lnx50 \``comp2_dcszo_``out (.o(comp2[1]), .a(comp1[3]), .b(comp1[4]), .c(comp1[5]));     \
   yd8no02lnx70 \``comp3_dcszo_``out (.o(out), .a(comp2[0]), .b(comp2[1]));                        \
`endif


`define LIB_clknanen(outclk,inclk,enable)                                                          \
`ifdef SYNTH_B12                                                                                   \
    b12cna0wnd0 \``clknand_dcszo_``outclk  <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(outclk)>));        \
`elsif SYNTH_YD8                                                                                   \
`endif                                                                                             \

// need to replace for b12cna2wnd2 once it available in lib b12

`define LIB_clknan(outclk,inclk,inclk2)                                                            \
`ifdef SYNTH_B12                                                                                   \
    b12cna0wnd0 \``clknand_dcszo_``outclk  <$typeof(outclk)> (.ck(<(inclk)>), .en(<(inclk2)>), .o(<(outclk)>));        \
`elsif SYNTH_YD8                                                                                   \
`endif                                                                                             \




// Mapped to a yd8 ln version. Need to map to a nn version if we get one in the library release
// COMMENTED OUT ********Used in a macro LATCH_P_HF_NONSCAN which is not being used anymore. ******
//`define LIB_LATCH_P_HF_NONSCAN(q,i,clock)                                                                         \
//`ifdef SYNTH_B12                                                                                                  \
//   b12la40wnx05  \``q``_reg_dcszo_nonscan <$typeof(q)> (.ckb(clock), .d(<(i)>), .o(<(\``q``_nonscan )>));         \
//`elsif SYNTH_YD8                                                                                                  \
//   yd8la80lnx10  \``q``_reg_dcszo_nonscan <$typeof(q)> (.ckb(clock), .d(<(i)>), .o(<(\``q``_nonscan )>));         \
//`endif

// Commented out as per the feedback from Rabiul Islam. This is going to be
// used only for custom blcoks so the ifdef DC option can be removed as per
// Rabiul. 

//`define LIB_LS_WITH_NO_FW(out, vccout, i)                                                          \
//`ifdef SYNTH_B12                                                                                   \
//   wire [$bits(i)-1:0] i``_b;                                                                      \
//   bl0inn00ln0c5 \``_inv``out  <$typeof(i)> (.o1(<(i``_b )>),.a(<(i )>));                          \
//   bl0bln20ln0l0 \``out``_dcszo <$typeof(out)> (.a(<(i``_b )>), .vccxx(vccout), .ob(<(out)>));     \
//`elsif SYNTH_YD8                                                                                   \
//`endif                                                                                             \


`endif // ifndef P1266
`endif // ifndef __vlv_macro_tech_map__vh
