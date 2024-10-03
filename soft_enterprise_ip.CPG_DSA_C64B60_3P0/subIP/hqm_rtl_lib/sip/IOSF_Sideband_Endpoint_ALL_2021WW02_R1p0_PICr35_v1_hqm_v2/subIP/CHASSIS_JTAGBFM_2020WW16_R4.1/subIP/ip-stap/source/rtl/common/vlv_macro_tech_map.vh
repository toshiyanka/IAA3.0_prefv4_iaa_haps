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
`ifdef SYNTH_B12
   b12pwb0wfx10 power_switch(.o(o),.a(a));
`elsif SYNTH_B11
   b11pwb0wfx10 power_switch(.o(o),.a(a));
`endif
endmodule


`define LIB_POWERSWITCH(pwren_out, vcc_out, pwren_in, vcc_in, vss_in)                                      \
    power_switch_wrapper \``vcc_out``_dcszo (.gtdout(vcc_out),.a(pwren_in),.vccin(vcc_in),.o(pwren_out));  \


`define LIB_LV_BUF(o,a)                                                \
`ifdef SYNTH_B12                                                       \
    b12bf00wnx05  \``o``_dcszo <$typeof(o)> (.o(<(o)>), .a(<(a)>));    \
`elsif SYNTH_B11                                                       \
    b11bf00wnx05  \``o``_dcszo <$typeof(o)> (.o(<(o)>), .a(<(a)>));    \
`endif

`define LIB_FIREWALL_AND(out,data,enable)                                                   \
`ifdef SYNTH_B12                                                                            \
    b12afw0wnx50 \``out``_dcszo <$typeof(out)> (.o(<(out)>),.en(enable),.a(<(data)>));      \
`elsif SYNTH_B11                                                                            \
    b11afw0wnx50 \``out``_dcszo <$typeof(out)> (.o(<(out)>),.en(enable),.a(<(data)>));      \
`endif


`define LIB_FIREWALL_OR(out,data,enable)                                                                \
`ifdef SYNTH_B12                                                                                        \
    wire [$bits(out)-1:0] \``tmp_``out ;                                                                \
    b12siriwnx30 \``out``_pin_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>), .a(enable));                 \
    b12ofw0wnx30 \``out``_dcszo     <$typeof(out)> (.o(<(out)>),.en(<(\``tmp_``out )>),.a(<(data)>));   \
`elsif SYNTH_B11                                                                                        \
    wire [$bits(out)-1:0] \``tmp_``out ;                                                                \
    b11siriwnx30 \``out``_pin_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>), .a(enable));                 \
    b11ofw0wnx30 \``out``_dcszo     <$typeof(out)> (.o(<(out)>),.en(<(\``tmp_``out )>),.a(<(data)>));   \
`endif


`define LIB_LS_LATCH_UP(outb,iwrite_en,ipro,ib)                                                                             \
`ifdef SYNTH_B12                                                                                                            \
    b12bn01wnx10 \``outb``_dcszo <$typeof(outb)> (.a(<(ib)>), .enb(iwrite_en), .ob(<(outb)>));                              \
`elsif SYNTH_B11                                                                                                            \
    b11bn01wnx10 \``outb``_dcszo <$typeof(outb)> (.a(<(ib)>), .enb(iwrite_en), .ob(<(outb)>));                              \
`endif


`define LIB_LS_LATCH_DN(outb,iwrite_en,ipro,ib)                                                                             \
`ifdef SYNTH_B12                                                                                                            \
    b12bn01wnx10 \``outb``_dcszo <$typeof(outb)> (.a(<(ib)>), .enb(iwrite_en), .ob(<(outb)>));                              \
`elsif SYNTH_B11                                                                                                            \
    b11bn01wnx10 \``outb``_dcszo <$typeof(outb)> (.a(<(ib)>), .enb(iwrite_en), .ob(<(outb)>));                              \
`endif


`define LIB_LS_WITH_AND_FW(mo, mpro, ma, mvccin, men)                                                                       \
`ifdef SYNTH_B12                                                                                                            \
    b12ba00wnx10 \``mo``_ls_in_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .o(<(mo)>));                                      \
`elsif SYNTH_TG																												\
    b12svbilnx05tg \``mo``_ls_in_dcszo <$typeof(mo)> (.iehv(<(ma)>), .pwrokehv(men), .oehv(<(mo)>));                        \
`elsif SYNTH_B11                                                                                                            \
    b11ba00wnx10 \``mo``_ls_in_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .o(<(mo)>));                                      \
`endif


// Mapped to a yd8 ln version. Need to map to a nn version if we get one in the library release
`define LIB_ASYNC_RSTB_MSFF_HF_NONSCAN(q,i,clock,rstb)                                                                \
`ifdef SYNTH_B12                                                                                                      \
   b12fa62wnx10  \``q``_reg_dcszo_nonscan <$typeof(q)> (.ck(clock), .d(<(i)>), .rb(rstb), .o(<(\``q``_nonscan )>));   \
`elsif SYNTH_B11                                                                                                      \
   b11fa62wnx10  \``q``_reg_dcszo_nonscan <$typeof(q)> (.ck(clock), .d(<(i)>), .rb(rstb), .o(<(\``q``_nonscan )>));   \
`endif

`define LIB_LS_WITH_OR_FW(mo, mpro, ma, mvccin, men)                                                                            \
`ifdef SYNTH_B12                                                                                                                \
    b12bo00wnx10 \``mo``_blo_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .o(<(mo)>));                                            \
`elsif SYNTH_B11                                                                                                                \
    b11bo00wnx10 \``mo``_blo_dcszo <$typeof(mo)> (.a(<(ma)>), .en(men), .o(<(mo)>));                                            \
`endif

`define LIB_POWER_INVERTER_D(powerenout, powerenin, vcc_in)                                                                 \
`ifdef SYNTH_B12                                                                                                            \
    b12siriwnx30 \``powerenout``_pin_dcszo <$typeof(powerenout)> (.o(<(powerenout)>) , .a(<(powerenin)>));                  \
`elsif SYNTH_B11                                                                                                            \
    b11siriwnx30 \``powerenout``_pin_dcszo <$typeof(powerenout)> (.o(<(powerenout)>) , .a(<(powerenin)>));                  \
`endif

`define LIB_INV_PRSRV(outb,in)                                                              \
`ifdef SYNTH_B12                                                                            \
    b12in00wnx10 \``outb``_tieoff_inv_dcszo <$typeof(outb)> (.o(<(outb)>) , .a(<(in)>));    \
`elsif SYNTH_B11                                                                            \
    b11in00wnx10 \``outb``_tieoff_inv_dcszo <$typeof(outb)> (.o(<(outb)>) , .a(<(in)>));    \
`endif

`define LIB_TIEOFF_0_PRSRV(out)                                                                                         \
`ifdef SYNTH_B12                                                                                                        \
    wire [$bits(out)-1:0] \``tmp_``out ;                                                                                \
    b12in00wnx10 \``out``_tieoff_inv1_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>) , .a(<({$bits(out){1'b0}})>));        \
    b12in00wnx10 \``out``_tieoff_inv2_dcszo <$typeof(out)> (.o(<(out)>) , .a(<(\``tmp_``out )>));                       \
`elsif SYNTH_B11                                                                                                        \
    wire [$bits(out)-1:0] \``tmp_``out ;                                                                                \
    b11in00wnx10 \``out``_tieoff_inv1_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>) , .a(<({$bits(out){1'b0}})>));        \
    b11in00wnx10 \``out``_tieoff_inv2_dcszo <$typeof(out)> (.o(<(out)>) , .a(<(\``tmp_``out )>));                       \
`endif

`define LIB_TIEOFF_1_PRSRV(out)                                                                                         \
`ifdef SYNTH_B12                                                                                                        \
    wire [$bits(out)-1:0] \``tmp_``out ;                                                                                \
    b12in00wnx10 \``out``_tieoff_inv1_dcszo <$typeof(out)> (.o(<(out)>) , .a(<({$bits(out){1'b0}})>));                  \
    b12in00wnx10 \``out``_tieoff_inv2_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>) , .a(<(out)>));                       \
`elsif SYNTH_B11                                                                                                        \
    wire [$bits(out)-1:0] \``tmp_``out ;                                                                                \
    b11in00wnx10 \``out``_tieoff_inv1_dcszo <$typeof(out)> (.o(<(out)>) , .a(<({$bits(out){1'b0}})>));                  \
    b11in00wnx10 \``out``_tieoff_inv2_dcszo <$typeof(out)> (.o(<(\``tmp_``out )>) , .a(<(out)>));                       \
`endif
      
`define LIB_BUF_1NS_DELAY_UNGATED(out,in,vcc_in)                                                           \
`ifdef SYNTH_B12                                                                                           \
    b12dly0wnx10 \``out``_buf_1ns_dly_dcszo <$typeof(out)> (.o(<(out)>) , .a(<(in)>) );                    \
`elsif SYNTH_B11                                                                                           \
    b11dly0wnx10 \``out``_buf_1ns_dly_dcszo <$typeof(out)> (.o(<(out)>) , .a(<(in)>) );                    \
`endif


`define LIB_lcp_dly_elmt(clklcpdlyout,clklcpdlyin,rsel0lcpdlyin,rsel1lcpdlyin,rsel2lcpdlyin)                                                                               \
`ifdef SYNTH_B12                                                                                                                                                           \
    b12lcp0wnd1 clklcpdlyout_1_dcszo (.ckout(clklcpdlyout), .ck(clklcpdlyin), .rsel0(rsel0lcpdlyin), .rsel1(rsel1lcpdlyin), .rsel2(rsel2lcpdlyin));                        \
`elsif SYNTH_B11                                                                                                                                                           \
    b11lcp0wnd1 clklcpdlyout_1_dcszo (.ckout(clklcpdlyout), .ck(clklcpdlyin), .rsel0(rsel0lcpdlyin), .rsel1(rsel1lcpdlyin), .rsel2(rsel2lcpdlyin));                        \
`endif

// Mapped to a yd8 ln version. Need to map to a nn version if we get one in the library release
`define LIB_clockdivffreset(ffoutreset, ffinresetb, clockinreset,resetckdivff)                        \
`ifdef SYNTH_B12                                                                                      \
    b12ma12wnd3 ckdiv2ff1 (.o(ffoutreset), .db(ffinresetb), .ck(clockinreset), .rb(resetckdivff));    \
`elsif SYNTH_B11                                                                                      \
    b11ma12wnd3 ckdiv2ff1 (.o(ffoutreset), .db(ffinresetb), .ck(clockinreset), .rb(resetckdivff));    \
`endif

// Mapped to a yd8 ln version. Need to map to a nn version if we get one in the library release
`define LIB_clockdivff(ffout, ffin, clockin)                                        \
`ifdef SYNTH_B12                                                                    \
    b12ma12wnd1 ckdiv2ff1 (.o(ffout), .db(ffin), .ck(clockin), .rb(1'b1));          \
`elsif SYNTH_B11                                                                    \
    b11ma12wnd1 ckdiv2ff1 (.o(ffout), .db(ffin), .ck(clockin), .rb(1'b1));          \
`endif


`define LIB_clkinv(clkout,clkin)                       \
`ifdef SYNTH_B12                                       \
    b12ci00wnd0 clkinv1_dcszo (.o(clkout),.ck(clkin)); \
`elsif SYNTH_TG                                        \
   b12in00lnx10tg clkinv1_dcszo (.oehv(clkinvout),.aehv(clkinvin)); \
`elsif SYNTH_B11                                       \
    b11ci00wnd0 clkinv1_dcszo (.o(clkout),.ck(clkin)); \
`endif       


`define LIB_clk2to1mux(ckmuxout,ckin1,ckin2,muxselect)                              \
`ifdef SYNTH_B12                                                                    \
    b12cmx2wnd4 ckmux1_dcszo (.o(ckmuxout), .d1(ckin1), .d2(ckin2), .s(muxselect)); \
`elsif SYNTH_TG                                                                     \
 b12mx12lnx05tg  ckmux1_dcszo (.oehv(ckmuxout), .d1ehv(ckin1), .d2ehv(ckin2), .sehv(muxselect)); \
 `elsif SYNTH_B11                                                                   \
    b11cmx2wnd4 ckmux1_dcszo (.o(ckmuxout), .d1(ckin1), .d2(ckin2), .s(muxselect)); \
`endif       


`define LIB_clkor(ckoout, ckoin1,ckoin2)                                    \
`ifdef SYNTH_B12                                                            \
    wire ckooutbar;                                                         \
    b12cno2wnd0   ckor1_dcszo (.o(ckooutbar),.ck1(ckoin1),.ck2(ckoin2));    \
    b12ci00wnd2   ckor2_dcszo (.o(ckoout), .ck(ckooutbar));                 \
`elsif SYNTH_TG																\
    wire ckooutbar;                                                         \
    b12no02lnx10tg  ckor1_dcszo (.oehv(ckooutbar),.aehv(ckoin1),.behv(ckoin2));    \
    b12in00lnx10tg\``clkinvout``_i0_dcszo (.oehv(clkinvout),.aehv(clkinvin));     \
`elsif SYNTH_B11                                                            \
    wire ckooutbar;                                                         \
    b11cno2wnd0   ckor1_dcszo (.o(ckooutbar),.ck1(ckoin1),.ck2(ckoin2));    \
    b11ci00wnd2   ckor2_dcszo (.o(ckoout), .ck(ckooutbar));                 \
`endif       

                
`define LIB_clkoren(clkorenout,clkorenckin,clkorenenin)                                 \
`ifdef SYNTH_B12                                                                        \
    wire ckooutbar;                                                                     \
    b12cno0wnd0 clkoren1_dcszo (.o(ckooutbar),.ck(clkorenckin),.en(clkorenenin));       \
    b12ci00wnd0   clkoren2_dcszo (.o(clkorenout),.ck(ckooutbar));                       \
`elsif SYNTH_TG																			\
    wire ckooutbar;                                                                     \
    b12no02lnx10tg  clkoren1_dcszo (.oehv(ckooutbar),.aehv(clkorenckin),.behv(clkorenenin)); \
    b12in00lnx10tg  clkoren2_dcszo (.oehv(clkorenout),.aehv(ckooutbar));					 \
`elsif SYNTH_B11                                                                        \
    wire ckooutbar;                                                                     \
    b11cno0wnd0 clkoren1_dcszo (.o(ckooutbar),.ck(clkorenckin),.en(clkorenenin));       \
    b11ci00wnd0   clkoren2_dcszo (.o(clkorenout),.ck(ckooutbar));                       \
`endif       

`define LIB_clknor(ckoout,ckoin1,ckoin2)                                    \
`ifdef SYNTH_B12                                                            \
    b12cno2wnd0  cknor_dcszo (.o(ckoout),.ck1(ckoin1),.ck2(ckoin2));        \
`elsif SYNTH_TG																\
   b12no02lnx10tg   cknor_dcszo (.oehv(ckoout),.aehv(ckoin1),.behv(ckoin2)); \
`elsif SYNTH_B11                                                            \
    b11cno2wnd0  cknor_dcszo (.o(ckoout),.ck1(ckoin1),.ck2(ckoin2));        \
`endif

`define LIB_clknoren(clknorenout,clknorenckin,clknorenenin)                                 \
`ifdef SYNTH_B12                                                                            \
    b12cno0wnd0 clkoren1_dcszo (.o(clknorenout),.ck(clknorenckin),.en(clknorenenin));       \
`elsif SYNTH_B11                                                                            \
    b11cno0wnd0 clkoren1_dcszo (.o(clknorenout),.ck(clknorenckin),.en(clknorenenin));       \
`endif

`define LIB_clkanden(outclk,inclk,enable)                                                                       \
`ifdef SYNTH_B12                                                                                                \
    b12can0wnd0 \``clkand_dcszo_``outclk  <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(outclk)>));  \
`elsif SYNTH_B11                                                                                                \
    b11can0wnd0 \``clkand_dcszo_``outclk  <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(outclk)>));  \
`endif

`define LIB_clk16delay(clk16delayout,clk16delayin,clk16in0,clk16in1,clk16in2,clk16in3,clk16in4,clk16in5,clk16in6,clk16in7,clk16in8,clk16in9,clk16in10,clk16in11,clk16in12,clk16in13,clk16in14)                  \
`ifdef SYNTH_B12                                                                                                    \
     b12dcc0wnd1 clk16delay_dcszo (.o(clk16delayout),  .rsel0(clk16in0),   .rsel1(clk16in1),   .rsel2(clk16in2),    \
                                     .rsel3(clk16in3),   .rsel4(clk16in4),   .rsel5(clk16in5),   .rsel6(clk16in6),  \
                                     .rsel7(clk16in7),   .rsel8(clk16in8),   .rsel9(clk16in9),   .rsel10(clk16in10),\
                                     .rsel11(clk16in11), .rsel12(clk16in12), .rsel13(clk16in13),                    \
                                     .rsel14(clk16in14), .ck(clk16delayin));                                        \
`elsif SYNTH_B11                                                                                                    \
     b11dcc0wnd1 clk16delay_dcszo (.o(clk16delayout),  .rsel0(clk16in0),   .rsel1(clk16in1),   .rsel2(clk16in2),    \
                                     .rsel3(clk16in3),   .rsel4(clk16in4),   .rsel5(clk16in5),   .rsel6(clk16in6),  \
                                     .rsel7(clk16in7),   .rsel8(clk16in8),   .rsel9(clk16in9),   .rsel10(clk16in10),\
                                     .rsel11(clk16in11), .rsel12(clk16in12), .rsel13(clk16in13),                    \
                                     .rsel14(clk16in14), .ck(clk16delayin));                                        \
`endif


`define LIB_soc_rbe_clk(ckrcbxpn,ckgridxpn,latrcben)                                     \
`ifdef SYNTH_B12                                                                         \
    b12gb01wcd1 ckrbexpnrcb_dcszo (.enclk(ckrcbxpn),.ck(ckgridxpn),.en(latrcben),.te(1'b0));     \
`elsif SYNTH_B11                                                                         \
    b11gb01wcd1 ckrbexpnrcb_dcszo (.enclk(ckrcbxpn),.ck(ckgridxpn),.en(latrcben),.te(1'b0));     \
`endif

//Mapped to a yd8 ln version. Need to map to a nn version if we get one in the library release
`define LIB_soc_rbe_clk_hf(ckrcbxpn,ckgridxpn,latrcben)                                     \
`ifdef SYNTH_B12                                                                            \
    b12gb01wcd1 ckrbexpnrcb_hf_dcszo (.enclk(ckrcbxpn),.ck(ckgridxpn),.en(latrcben),.te(1'b0));     \
`elsif SYNTH_B11                                                                            \
    b11gb01wcd1 ckrbexpnrcb_hf_dcszo (.enclk(ckrcbxpn),.ck(ckgridxpn),.en(latrcben),.te(1'b0));     \
`endif

`define LIB_SOC_CLKAND(outclk,inclk,enable)                                                                                     \
`ifdef SYNTH_B12                                                                                                                \
    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                                  \
    b12cna0wnd0 \``clknand_dcszo_``outclk <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(\``tmp_``outclk )>));        \
    b12ci00wnd0 \``clkinv_dcszo_``outclk <$typeof(outclk)> (.ck(<(\``tmp_``outclk )>), .o(<(outclk)>));                         \
`elsif SYNTH_B11                                                                                                                \
    wire [$bits(outclk)-1:0] \``tmp_``outclk ;                                                                                  \
    b11cna0wnd0 \``clknand_dcszo_``outclk <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(\``tmp_``outclk )>));        \
    b11ci00wnd0 \``clkinv_dcszo_``outclk <$typeof(outclk)> (.ck(<(\``tmp_``outclk )>), .o(<(outclk)>));                         \
`endif


`define LIB_SOC_NONCLKAND(outd,ind1,ind2)                                                                                       \
`ifdef SYNTH_B12                                                                                                                \
    b12an02wnx05 \``and_dcszo_``outd (.o(outd),.a(ind1),.b(ind2));                                                              \
`elsif SYNTH_B11                                                                                                                \
    b11an02wnx05 \``and_dcszo_``outd (.o(outd),.a(ind1),.b(ind2));                                                              \
`endif




`define LIB_clk_gate_kin(ckrcbxpn1,ckgridxpn1,latrcben1,testen1)                                            \
`ifdef SYNTH_B12                                                                                            \
    b12gb01wcd1 \ckrcbcell_ckrcbxpn1_dcszo (.enclk(ckrcbxpn1),.ck(ckgridxpn1),.en(latrcben1),.te(testen1)); \
`elsif SYNTH_B11                                                                                            \
    b11gb01wcd1 \ckrcbcell_ckrcbxpn1_dcszo (.enclk(ckrcbxpn1),.ck(ckgridxpn1),.en(latrcben1),.te(testen1)); \
`endif


`define LIB_CLKBF_SOC(clkbufout,clkbufin)                                  \
`ifdef SYNTH_B12                                                           \
    b12cb00wnd0 \``clkbufout``_i0_dcszo (.o(clkbufout),.ck(clkbufin));     \
`elsif SYNTH_B11                                                           \
    b11cb00wnd0 \``clkbufout``_i0_dcszo (.o(clkbufout),.ck(clkbufin));     \
`endif

`define LIB_CLKBF_GLITCH_GLOB(clkout, clkin)                               \
`ifdef SYNTH_B12                                                           \
    b12dwcbwnd1 \``clkout``_i0_dcszo (.o(clkout),.ck(clkin));              \
`elsif SYNTH_B11                                                           \
    b11dwcbwnd1 \``clkout``_i0_dcszo (.o(clkout),.ck(clkin));              \
`endif
      
`define LIB_CLKINV_SOC(clkinvout,clkinvin)                                 \
`ifdef SYNTH_B12                                                           \
    b12ci00wnd0 \``clkinvout``_i0_dcszo (.o(clkinvout),.ck(clkinvin));     \
`elsif SYNTH_TG															   \
   b12in00lnx10tg\``clkinvout``_i0_dcszo (.oehv(clkinvout),.aehv(clkinvin)); \
`elsif SYNTH_B11                                                           \
    b11ci00wnd0 \``clkinvout``_i0_dcszo (.o(clkinvout),.ck(clkinvin));     \
`endif

`define LIB_MSFF_NONSCAN(q,i,clock)                                                                        \
`ifdef SYNTH_B12                                                                                           \
    b12ms00wnx05 \``q``_reg_dcszo_nonscan <$typeof(q)> (.o(<(\``q``_nonscan )>), .d(<(i)>), .ck(clock));   \
`elsif SYNTH_B11                                                                                           \
    b11ms00wnx05 \``q``_reg_dcszo_nonscan <$typeof(q)> (.o(<(\``q``_nonscan )>), .d(<(i)>), .ck(clock));   \
`endif

`define LIB_ASYNC_RST_2MSFF_META(q, i, clk, rstb)                                                                       \
`ifdef SYNTH_B12                                                                                                        \
    b12mas2wnx10  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .ck(clk), .rb(rstb), .so(), .si(1'b0), .ss(1'b0));   \
`elsif SYNTH_B11                                                                                                        \
    b11mas2wnx10  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .ck(clk), .rb(rstb), .so(), .si(1'b0), .ss(1'b0));   \
`endif


`define LIB_ASYNC_SET_2MSFF_META(q, i, clk, ipsb)                                                                       \
`ifdef SYNTH_B12                                                                                                        \
    b12mas1wnx10  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .ck(clk), .psb(ipsb));                               \
`elsif SYNTH_B11                                                                                                        \
    b11mas1wnx10  \``q``_dcszo <$typeof(q)> (.o(<(q)>), .d(<(i)>), .ck(clk), .psb(ipsb));                               \
`endif


`define LIB_SOC_MSFF_META(q,i,clock)                                                                \
`ifdef SYNTH_B12                                                                                    \
  b12fa62wnx10 \``q``meta_flop_dcszo <$typeof(q)> (.ck(clock), .d(<(i)>), .rb(1'b1), .o(<(q)>));    \
`elsif SYNTH_B11                                                                                    \
  b11fa62wnx10 \``q``meta_flop_dcszo <$typeof(q)> (.ck(clock), .d(<(i)>), .rb(1'b1), .o(<(q)>));    \
`endif

`define LIB_ASYNC_RST_MSFF_META(q, i, clk, rstb)                                                    \
`ifdef SYNTH_B12                                                                                    \
  b12fa62wnx10 \``q``_dcszo <$typeof(q)> (.ck(clk), .d(<(i)>), .rb(rstb), .o(<(q)>));               \
`elsif SYNTH_B11                                                                                    \
  b11fa62wnx10 \``q``_dcszo <$typeof(q)> (.ck(clk), .d(<(i)>), .rb(rstb), .o(<(q)>));               \
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
`elsif SYNTH_B11                                                                    \
    wire n1;                                                                        \
    wire n2;                                                                        \
    wire n3;                                                                        \
    b11na02wnx05 \``i1_dcszo_``out (.o(n1),.a(in1),.b(sel1));                       \
    b11na02wnx05 \``i2_dcszo_``out (.o(n2),.a(in2),.b(sel2));                       \
    b11na02wnx05 \``i3_dcszo_``out (.o(n3),.a(in3),.b(sel3));                       \
    b11na03wnx05 \``i4_dcszo_``out (.o(out),.a(n1),.b(n2),.c(n3));                  \
`endif // ifdef SYNTH_B12

`define LIB_CLK_NAND_3TO1MUX(out,in1,in2,in3,sel1,sel2,sel3)                        \
`ifdef SYNTH_B12                                                                    \
    wire sel3b;                                                                     \
    wire sel2b;                                                                     \
    wire sel1b;                                                                     \
    wire nor1;                                                                      \
    wire nor2;                                                                      \
    wire nor3;                                                                      \
    wire x1;                                                                        \
    wire x2;                                                                        \
    wire x3;                                                                        \
    wire x4;                                                                        \
    wire x4x;                                                                       \
    b12in00wnx10 \``i1_dcszo_``out (.o(sel3b),.a(sel3));                            \
    b12in00wnx10 \``i2_dcszo_``out (.o(sel2b),.a(sel2));                            \
    b12in00wnx10 \``i3_dcszo_``out (.o(sel1b),.a(sel1));                            \
    b12no03wnx05 \``i4_dcszo_``out (.o(nor1),.a(sel3b),.b(sel2),.c(sel1));          \
    b12no03wnx05 \``i5_dcszo_``out (.o(nor2),.a(sel3),.b(sel2b),.c(sel1));          \
    b12no03wnx05 \``i6_dcszo_``out (.o(nor3),.a(sel3),.b(sel2),.c(sel1b));          \
    b12cna0wnd0 \``i7_dcszo_``out (.ck(in3),.en(nor1),.o(x1));                      \
    b12cna0wnd0 \``i8_dcszo_``out (.ck(in2),.en(nor2),.o(x2));                      \
    b12cna0wnd0 \``i9_dcszo_``out (.ck(in1),.en(nor3),.o(x3));                      \
    b12cna2wnd2 \``i10_dcszo_``out (.o(x4x),.ck1(x1),.ck2(x2));                     \
    b12in00wnx10 \``i11_dcszo_``out (.o(x4),.a(x4x));                               \
    b12cna2wnd2 \``i12_dcszo_``out (.o(out),.ck1(x4),.ck2(x3));                     \
`elsif SYNTH_B11                                                                    \
    wire sel3b;                                                                     \
    wire sel2b;                                                                     \
    wire sel1b;                                                                     \
    wire nor1;                                                                      \
    wire nor2;                                                                      \
    wire nor3;                                                                      \
    wire x1;                                                                        \
    wire x2;                                                                        \
    wire x3;                                                                        \
    wire x4;                                                                        \
    wire x4x;                                                                       \
    b11in00wnx10 \``i1_dcszo_``out (.o(sel3b),.a(sel3));                            \
    b11in00wnx10 \``i2_dcszo_``out (.o(sel2b),.a(sel2));                            \
    b11in00wnx10 \``i3_dcszo_``out (.o(sel1b),.a(sel1));                            \
    b11no03wnx05 \``i4_dcszo_``out (.o(nor1),.a(sel3b),.b(sel2),.c(sel1));          \
    b11no03wnx05 \``i5_dcszo_``out (.o(nor2),.a(sel3),.b(sel2b),.c(sel1));          \
    b11no03wnx05 \``i6_dcszo_``out (.o(nor3),.a(sel3),.b(sel2),.c(sel1b));          \
    b11cna0wnd0 \``i7_dcszo_``out (.ck(in3),.en(nor1),.o(x1));                      \
    b11cna0wnd0 \``i8_dcszo_``out (.ck(in2),.en(nor2),.o(x2));                      \
    b11cna0wnd0 \``i9_dcszo_``out (.ck(in1),.en(nor3),.o(x3));                      \
    b11cna2wnd2 \``i10_dcszo_``out (.o(x4x),.ck1(x1),.ck2(x2));                     \
    b11in00wnx10 \``i11_dcszo_``out (.o(x4),.a(x4x));                               \
    b11cna2wnd2 \``i12_dcszo_``out (.o(out),.ck1(x4),.ck2(x3));                     \
`endif // ifdef SYNTH_B12

`define LIB_GCLATCHEN(gcenclkout,gcenin,gctein,gcclrbin,gcckin)                     \
`ifdef SYNTH_B12                                                                    \
    b12db02wnd2 \ckgclatchen_dcszo (.enclk(gcenclkout),.ck(gcckin),.en(gcenin),.te(gctein),.rb(gcclrbin),.ss(1'b0)); \
`elsif SYNTH_B11                                                                    \
    b11db02wnd2 \ckgclatchen_dcszo (.enclk(gcenclkout),.ck(gcckin),.en(gcenin),.te(gctein),.rb(gcclrbin),.ss(1'b0)); \
`endif


// used ln version for yd8 cells as nn was not available. Change to nn if present
`define LIB_MUX_2TO1_HF(out,in1,in2,sel)                                                            \
`ifdef SYNTH_B12                                                                                    \
  b12mx22wnx30 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .d1(<(in1)>), .d2(<(in2)>), .s(sel));    \
`elsif SYNTH_B11                                                                                    \
  b11mx22wnx30 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .d1(<(in1)>), .d2(<(in2)>), .s(sel));    \
`endif // ifdef SYNTH_B12

// used ln version for yd8 cells as nn was not available. Change to nn if present
`define LIB_MUX_2TO1_INV_HF(out,in1,in2,sel)                                                        \
`ifdef SYNTH_B12                                                                                    \
  b12mx12wnx30 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .d1(<(in1)>), .d2(<(in2)>), .s(sel));    \
`elsif SYNTH_B11                                                                                    \
  b11mx12wnx30 \``out``_dcszo <$typeof(out)> (.o(<(out)>), .d1(<(in1)>), .d2(<(in2)>), .s(sel));    \
`endif // ifdef SYNTH_B12
      
`define LIB_clk_glitchfree_mux_part(out, clka, clkb, sela, selb)                                   \
`ifdef SYNTH_B12                                                                                   \
      b12gm22wnd0 \``out``_dcszo (.cka(clka), .ckb(clkb), .sa(sela), .sb(selb), .o(out));          \
`elsif SYNTH_B11                                                                                   \
      b11gm22wnd0 \``out``_dcszo (.cka(clka), .ckb(clkb), .sa(sela), .sb(selb), .o(out));          \
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
`elsif SYNTH_B11                                                                                   \
   wire [5:0] comp1 ;                                                                              \
   wire [1:0] comp2 ;                                                                              \
   b11xn00wnx05 \``comp_dcszo_``out <$typeof(comp1)> (.o(<(comp1)>), .a(<(in1)>), .b(<(in2)>));    \
   b11na03wnx50 \``comp1_dcszo_``out (.o(comp2[0]), .a(comp1[0]), .b(comp1[1]), .c(comp1[2]));     \
   b11na03wnx50 \``comp2_dcszo_``out (.o(comp2[1]), .a(comp1[3]), .b(comp1[4]), .c(comp1[5]));     \
   b11no02wnx30 \``comp3_dcszo_``out (.o(out), .a(comp2[0]), .b(comp2[1]));                        \
`endif


`define LIB_clknanen(outclk,inclk,enable)                                                          \
`ifdef SYNTH_B12                                                                                   \
    b12cna0wnd0 \``clknand_dcszo_``outclk  <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(outclk)>));        \
`elsif SYNTH_TG																					  \
   b12na02lnx10tg \``clknand_dcszo_``outclk  <$typeof(outclk)> (.aehv(<(inclk)>), .behv(<(enable)>), .oehv(<(outclk)>)); \
`elsif SYNTH_B11                                                                                   \
    b11cna0wnd0 \``clknand_dcszo_``outclk  <$typeof(outclk)> (.ck(<(inclk)>), .en(<(enable)>), .o(<(outclk)>));        \
`endif

// need to replace for b12cna2wnd2 once it available in lib b12

`define LIB_clknan(outclk,inclk,inclk2)                                                            \
`ifdef SYNTH_B12                                                                                   \
    b12cna2wnd2 \``clknand_dcszo_``outclk  <$typeof(outclk)> (.ck1(<(inclk)>), .ck2(<(inclk2)>), .o(<(outclk)>));        \
`elsif SYNTH_B11                                                                                   \
    b11cna2wnd2 \``clknand_dcszo_``outclk  <$typeof(outclk)> (.ck1(<(inclk)>), .ck2(<(inclk2)>), .o(<(outclk)>));        \
`endif


//Adding this macro after approval from Raboul. 
//Email notes from Quddus, Wasim: We need a MACRO to instantiate LS going from rtc_well to sus_well.
//I talked with Rabiul, he suggested to use a different name, i.e. LS_WITH_NO_FW_TG.
//We want the b12sirblnx20tg cell to implement the LS from TG library.

`define LIB_LS_WITH_NO_FW_TG(mo, mpro, ma, mvccin)                                                 \
`ifdef SYNTH_TG                                                                                    \
    b12sianlnx05tg \``mo``_ls_out_dcszo <$typeof(mo)> (.aehv(<(ma)>), .enehv(<(ma)>), .oehv(<(mo)>)); \
`endif

`define LIB_TG_CLKBF_SOC(clkbufout,clkbufin)                                  \
`ifdef SYNTH_TG                                                           \
  b12cb00lnd1tg   \``clkbufout``_i0_dcszo (.oehv(clkbufout),.ckehv(clkbufin));     \
`endif

// Mapped to a yd8 ln version. Need to map to a nn version if we get one in the library release
// COMMENTED OUT ********Used in a macro LATCH_P_HF_NONSCAN which is not being used anymore. ******
//`define LIB_LATCH_P_HF_NONSCAN(q,i,clock)                                                                         \
//`ifdef SYNTH_B12                                                                                                  \
//   b12la40wnx05  \``q``_reg_dcszo_nonscan <$typeof(q)> (.ckb(clock), .d(<(i)>), .o(<(\``q``_nonscan )>));         \
//`endif

// Commented out as per the feedback from Rabiul Islam. This is going to be
// used only for custom blcoks so the ifdef DC option can be removed as per
// Rabiul. 

//`define LIB_LS_WITH_NO_FW(out, vccout, i)                                                          \
//`ifdef SYNTH_B12                                                                                   \
//   wire [$bits(i)-1:0] i``_b;                                                                      \
//   bl0inn00ln0c5 \``_inv``out  <$typeof(i)> (.o1(<(i``_b )>),.a(<(i )>));                          \
//   bl0bln20ln0l0 \``out``_dcszo <$typeof(out)> (.a(<(i``_b )>), .vccxx(vccout), .ob(<(out)>));     \
//`endif                                                                                             \


`endif // ifndef P1266
`endif // ifndef __vlv_macro_tech_map__vh
