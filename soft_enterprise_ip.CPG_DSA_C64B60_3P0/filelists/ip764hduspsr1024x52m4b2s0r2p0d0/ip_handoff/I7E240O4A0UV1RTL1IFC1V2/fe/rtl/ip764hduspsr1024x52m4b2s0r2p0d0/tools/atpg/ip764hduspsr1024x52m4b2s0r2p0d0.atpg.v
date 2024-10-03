
//==============================================================
/////////////////////////////////////////////////////////////////////////////////////////////
// Intel Confidential                                                                      //
/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2023 Intel Corporation. The information contained herein is the proprietary   //
// and confidential information of Intel or its licensors, and is supplied subject to, and //
// may be used only in accordance with, previously executed agreements with Intel.         //
// EXCEPT AS MAY OTHERWISE BE AGREED IN WRITING: (1) ALL MATERIALS FURNISHED BY INTEL      //
// HEREUNDER ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND; (2) INTEL SPECIFICALLY     //
// DISCLAIMS ANY WARRANTY OF NONINFRINGEMENT, FITNESS FOR A PARTICULAR PURPOSE OR          //
// MERCHANTABILITY; AND (3) INTEL WILL NOT BE LIABLE FOR ANY COSTS OF PROCUREMENT OF       //
// SUBSTITUTES, LOSS OF PROFITS, INTERRUPTION OF BUSINESS, OR FOR ANY OTHER SPECIAL,       //
// CONSEQUENTIAL OR INCIDENTAL DAMAGES, HOWEVER CAUSED, WHETHER FOR BREACH OF WARRANTY,    //
// CONTRACT, TORT, NEGLIGENCE, STRICT LIABILITY OR OTHERWISE.                              //
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//  Vendor:                Intel Corporation                                               //
//  Product:               c764hduspsr                                                     //
//  Version:               r1.0.0                                                          //
//  Technology:            p1276.4                                                         //
//  Celltype:              MemoryIP                                                        //
//  IP Owner:              Intel CMO                                                       //
//  Creation Time:         Tue Mar 28 2023 19:16:06                                        //
//  Memory Name:           ip764hduspsr1024x52m4b2s0r2p0d0                                 //
//  Memory Name Generated: ip764hduspsr1024x52m4b2s0r2p0d0                                 //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////

//==============================================================
//
//  CORE MEMORY (cmem) MODEL template
//
//  Based on example model in Fastscan manual for use w/libcomp
//
//----------------------------------------------------------------------------


//--------------------------------------------------------------------------
// ip764hduspsr1024x52m4b2s0r2p0d0
//--------------------------------------------------------------------------
module ip764hduspsr1024x52m4b2s0r2p0d0 (
   clk
  ,async_reset  // active high I/O firewall enable

  ,din
  ,ren
  ,wen

  ,redrowen
  ,adr
  ,arysleep
  ,sbc
  ,mce
  ,stbyp
  ,rmce
  ,wmce
  ,wpulse
  ,ra
  ,wa

  ,q
);

  input          clk;
  input          async_reset;


  input   [52:0] din;
  input          ren;
  input          wen;

  input   [1:0]  redrowen;
  input   [9:0] adr;

  input          arysleep;
  input   [1:0]  sbc;
  input          mce;
  input          stbyp;
  input   [3:0]  rmce;
  input   [1:0]  wmce;
  input   [2:0]  wpulse;
  input   [1:0]  ra;
  input   [2:0]  wa;

  output  [52:0] q;


`ifndef INTC_MEM_ATPG_SIMPLE
  // firewall pins
  wire    [52:0] din_fw;               // fw 0
  wire           ren_fw;               // fw 0
  wire           wen_fw;               // fw 0

  wire    [1:0]  redrowen_fw;           // fw 0
  wire    [9:0] adr_fw;               // fw 0

  wire           arysleep_fw;          // fw 0

  wire    [52:0] q_fw;               // fw 1
  wire    [52:0] q_s;
  wire  stbyp_l;

  // latched signal pins
  wire    [52:0] din_lt;
  wire           ren_lt;
  wire           wen_lt;

  wire    [1:0]  redrowen_lt;
  wire    [9:0] adr_lt;

  // internals
  wire [52:0]    biten;
  wire [9:0]    rrowaddr;       // address with Row Reduncancy enabled
  wire [9:0]    redaddr;        // Full Row redundancy address
  wire [2:0]     rcolblkrow;     // Partial Row redundancy address
  wire           redrowen_w;
  wire           redrowenx;
  wire [0:0]     redrowen_addr;
  wire [1:0]     redrowen_b;
  wire           rdwrx_b;
  wire           wren;
  wire           rden;
  wire           wren_ck;
  wire           wren_cka;
  wire           wren_ckr;
  wire           rden_ck;

// wires for output latch reset control
  wire           q_rst;
  wire           clkrd;
  wire           q_lat;
  wire [52 : 0] do_cram;
  wire [52 : 0] do_crama;
  wire [52 : 0] do_cramr;
  wire           asel;
  wire           asel_b;
  wire           asel_lt;

  wire           tiex;
  wire           tie0;
  wire           tie1;

// internal firewall
//  wire           fwenb;
  wire           fwenbi;
  wire           shutoff_oc;

  wire         pshutoff;
  wire         shutoff;
  wire         shutoffout;
  assign pshutoff = 1'b0;
  assign shutoff = 1'b0;

  assign tiex = 1'bx;
  assign tie0 = 1'b0;
  assign tie1 = 1'b1;

// firewall/power enable logic
//  assign fwenb = ~async_reset;
//  assign fwenbi = fwenb & ~shutoff & ~shutoffout;
  assign fwenbi = 1'b1;
  assign shutoff_oc = ~shutoff & ~shutoffout;

// firewall gates
//  and  an_f_01 [52:0] (din_fw,       fwenbi, din);
// The following ripped version of the above line is for Tetramax compatibility

  and an_f_01_52 (din_fw[52], fwenbi, din[52]);
  and an_f_01_51 (din_fw[51], fwenbi, din[51]);
  and an_f_01_50 (din_fw[50], fwenbi, din[50]);
  and an_f_01_49 (din_fw[49], fwenbi, din[49]);
  and an_f_01_48 (din_fw[48], fwenbi, din[48]);
  and an_f_01_47 (din_fw[47], fwenbi, din[47]);
  and an_f_01_46 (din_fw[46], fwenbi, din[46]);
  and an_f_01_45 (din_fw[45], fwenbi, din[45]);
  and an_f_01_44 (din_fw[44], fwenbi, din[44]);
  and an_f_01_43 (din_fw[43], fwenbi, din[43]);
  and an_f_01_42 (din_fw[42], fwenbi, din[42]);
  and an_f_01_41 (din_fw[41], fwenbi, din[41]);
  and an_f_01_40 (din_fw[40], fwenbi, din[40]);
  and an_f_01_39 (din_fw[39], fwenbi, din[39]);
  and an_f_01_38 (din_fw[38], fwenbi, din[38]);
  and an_f_01_37 (din_fw[37], fwenbi, din[37]);
  and an_f_01_36 (din_fw[36], fwenbi, din[36]);
  and an_f_01_35 (din_fw[35], fwenbi, din[35]);
  and an_f_01_34 (din_fw[34], fwenbi, din[34]);
  and an_f_01_33 (din_fw[33], fwenbi, din[33]);
  and an_f_01_32 (din_fw[32], fwenbi, din[32]);
  and an_f_01_31 (din_fw[31], fwenbi, din[31]);
  and an_f_01_30 (din_fw[30], fwenbi, din[30]);
  and an_f_01_29 (din_fw[29], fwenbi, din[29]);
  and an_f_01_28 (din_fw[28], fwenbi, din[28]);
  and an_f_01_27 (din_fw[27], fwenbi, din[27]);
  and an_f_01_26 (din_fw[26], fwenbi, din[26]);
  and an_f_01_25 (din_fw[25], fwenbi, din[25]);
  and an_f_01_24 (din_fw[24], fwenbi, din[24]);
  and an_f_01_23 (din_fw[23], fwenbi, din[23]);
  and an_f_01_22 (din_fw[22], fwenbi, din[22]);
  and an_f_01_21 (din_fw[21], fwenbi, din[21]);
  and an_f_01_20 (din_fw[20], fwenbi, din[20]);
  and an_f_01_19 (din_fw[19], fwenbi, din[19]);
  and an_f_01_18 (din_fw[18], fwenbi, din[18]);
  and an_f_01_17 (din_fw[17], fwenbi, din[17]);
  and an_f_01_16 (din_fw[16], fwenbi, din[16]);
  and an_f_01_15 (din_fw[15], fwenbi, din[15]);
  and an_f_01_14 (din_fw[14], fwenbi, din[14]);
  and an_f_01_13 (din_fw[13], fwenbi, din[13]);
  and an_f_01_12 (din_fw[12], fwenbi, din[12]);
  and an_f_01_11 (din_fw[11], fwenbi, din[11]);
  and an_f_01_10 (din_fw[10], fwenbi, din[10]);
  and an_f_01_9 (din_fw[9], fwenbi, din[9]);
  and an_f_01_8 (din_fw[8], fwenbi, din[8]);
  and an_f_01_7 (din_fw[7], fwenbi, din[7]);
  and an_f_01_6 (din_fw[6], fwenbi, din[6]);
  and an_f_01_5 (din_fw[5], fwenbi, din[5]);
  and an_f_01_4 (din_fw[4], fwenbi, din[4]);
  and an_f_01_3 (din_fw[3], fwenbi, din[3]);
  and an_f_01_2 (din_fw[2], fwenbi, din[2]);
  and an_f_01_1 (din_fw[1], fwenbi, din[1]);
  and an_f_01_0 (din_fw[0], fwenbi, din[0]);

  and  an_f_02        (ren_fw,       fwenbi, ren);
  and  an_f_03        (wen_fw,       fwenbi, wen);


//  and  an_f_05 [1:0]  (redrowen_fw,   fwenbi, redrowen);
// The following ripped version of the above line is for Tetramax compatibility

  and an_f_05_1 (redrowen_fw[1], fwenbi, redrowen[1]);
  and an_f_05_0 (redrowen_fw[0], fwenbi, redrowen[0]);
// The following ripped version of the above line is for Tetramax compatibility

  and an_f_06_9 (adr_fw[9], fwenbi, adr[9]);
  and an_f_06_8 (adr_fw[8], fwenbi, adr[8]);
  and an_f_06_7 (adr_fw[7], fwenbi, adr[7]);
  and an_f_06_6 (adr_fw[6], fwenbi, adr[6]);
  and an_f_06_5 (adr_fw[5], fwenbi, adr[5]);
  and an_f_06_4 (adr_fw[4], fwenbi, adr[4]);
  and an_f_06_3 (adr_fw[3], fwenbi, adr[3]);
  and an_f_06_2 (adr_fw[2], fwenbi, adr[2]);
  and an_f_06_1 (adr_fw[1], fwenbi, adr[1]);
  and an_f_06_0 (adr_fw[0], fwenbi, adr[0]);

  and  an_f_10        (arysleep_fw,  fwenbi, arysleep);

  // signals for input latches
  wire wakeup, wakeup_l, wakeup_fw, clk_lat, clk_fw;
  wire r_or_w, s_or_f, s_or_f_b;

  // latches for signal pins
  or   or_l_rw        (r_or_w, ren_fw, wen_fw);
  or   or_l_sf        (s_or_f, arysleep, pshutoff, shutoff, async_reset);
  not  inv_l_sf       (s_or_f_b, s_or_f);
  and  an_l_wu        (wakeup, r_or_w, s_or_f_b);
  and  an_l_ckfw      (clk_fw,  fwenbi, clk);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_wu (wakeup_l, 1'b0, 1'b0, clk_fw, wakeup);
  and  an_f_wu        (wakeup_fw, fwenbi, wakeup_l);
  and  an_l_ck        (clk_lat, clk, wakeup_fw);
//  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data [52:0] (din_lt, 1'b0, 1'b0, clk_fw, din_fw);
// The following ripped version of the above line is for Tetramax compatibility

  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_52 (din_lt[52], 1'b0, 1'b0, clk_fw, din_fw[52]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_51 (din_lt[51], 1'b0, 1'b0, clk_fw, din_fw[51]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_50 (din_lt[50], 1'b0, 1'b0, clk_fw, din_fw[50]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_49 (din_lt[49], 1'b0, 1'b0, clk_fw, din_fw[49]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_48 (din_lt[48], 1'b0, 1'b0, clk_fw, din_fw[48]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_47 (din_lt[47], 1'b0, 1'b0, clk_fw, din_fw[47]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_46 (din_lt[46], 1'b0, 1'b0, clk_fw, din_fw[46]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_45 (din_lt[45], 1'b0, 1'b0, clk_fw, din_fw[45]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_44 (din_lt[44], 1'b0, 1'b0, clk_fw, din_fw[44]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_43 (din_lt[43], 1'b0, 1'b0, clk_fw, din_fw[43]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_42 (din_lt[42], 1'b0, 1'b0, clk_fw, din_fw[42]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_41 (din_lt[41], 1'b0, 1'b0, clk_fw, din_fw[41]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_40 (din_lt[40], 1'b0, 1'b0, clk_fw, din_fw[40]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_39 (din_lt[39], 1'b0, 1'b0, clk_fw, din_fw[39]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_38 (din_lt[38], 1'b0, 1'b0, clk_fw, din_fw[38]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_37 (din_lt[37], 1'b0, 1'b0, clk_fw, din_fw[37]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_36 (din_lt[36], 1'b0, 1'b0, clk_fw, din_fw[36]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_35 (din_lt[35], 1'b0, 1'b0, clk_fw, din_fw[35]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_34 (din_lt[34], 1'b0, 1'b0, clk_fw, din_fw[34]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_33 (din_lt[33], 1'b0, 1'b0, clk_fw, din_fw[33]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_32 (din_lt[32], 1'b0, 1'b0, clk_fw, din_fw[32]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_31 (din_lt[31], 1'b0, 1'b0, clk_fw, din_fw[31]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_30 (din_lt[30], 1'b0, 1'b0, clk_fw, din_fw[30]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_29 (din_lt[29], 1'b0, 1'b0, clk_fw, din_fw[29]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_28 (din_lt[28], 1'b0, 1'b0, clk_fw, din_fw[28]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_27 (din_lt[27], 1'b0, 1'b0, clk_fw, din_fw[27]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_26 (din_lt[26], 1'b0, 1'b0, clk_fw, din_fw[26]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_25 (din_lt[25], 1'b0, 1'b0, clk_fw, din_fw[25]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_24 (din_lt[24], 1'b0, 1'b0, clk_fw, din_fw[24]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_23 (din_lt[23], 1'b0, 1'b0, clk_fw, din_fw[23]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_22 (din_lt[22], 1'b0, 1'b0, clk_fw, din_fw[22]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_21 (din_lt[21], 1'b0, 1'b0, clk_fw, din_fw[21]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_20 (din_lt[20], 1'b0, 1'b0, clk_fw, din_fw[20]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_19 (din_lt[19], 1'b0, 1'b0, clk_fw, din_fw[19]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_18 (din_lt[18], 1'b0, 1'b0, clk_fw, din_fw[18]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_17 (din_lt[17], 1'b0, 1'b0, clk_fw, din_fw[17]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_16 (din_lt[16], 1'b0, 1'b0, clk_fw, din_fw[16]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_15 (din_lt[15], 1'b0, 1'b0, clk_fw, din_fw[15]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_14 (din_lt[14], 1'b0, 1'b0, clk_fw, din_fw[14]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_13 (din_lt[13], 1'b0, 1'b0, clk_fw, din_fw[13]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_12 (din_lt[12], 1'b0, 1'b0, clk_fw, din_fw[12]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_11 (din_lt[11], 1'b0, 1'b0, clk_fw, din_fw[11]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_10 (din_lt[10], 1'b0, 1'b0, clk_fw, din_fw[10]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_9 (din_lt[9], 1'b0, 1'b0, clk_fw, din_fw[9]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_8 (din_lt[8], 1'b0, 1'b0, clk_fw, din_fw[8]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_7 (din_lt[7], 1'b0, 1'b0, clk_fw, din_fw[7]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_6 (din_lt[6], 1'b0, 1'b0, clk_fw, din_fw[6]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_5 (din_lt[5], 1'b0, 1'b0, clk_fw, din_fw[5]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_4 (din_lt[4], 1'b0, 1'b0, clk_fw, din_fw[4]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_3 (din_lt[3], 1'b0, 1'b0, clk_fw, din_fw[3]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_2 (din_lt[2], 1'b0, 1'b0, clk_fw, din_fw[2]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_1 (din_lt[1], 1'b0, 1'b0, clk_fw, din_fw[1]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_data_0 (din_lt[0], 1'b0, 1'b0, clk_fw, din_fw[0]);

  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_rden       (ren_lt, 1'b0, 1'b0, clk_lat, ren_fw);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_wren       (wen_lt, 1'b0, 1'b0, clk_lat, wen_fw);


//  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_redrowen [1:0] (redrowen_lt, 1'b0, 1'b0, clk_lat, redrowen_fw);
// The following ripped version of the above line is for Tetramax compatibility

  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_redrowen_1 (redrowen_lt[1], 1'b0, 1'b0, clk_lat, redrowen_fw[1]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_redrowen_0 (redrowen_lt[0], 1'b0, 1'b0, clk_lat, redrowen_fw[0]);

//  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_addr [9:0] (adr_lt, 1'b0, 1'b0, clk_lat, adr_fw);
// The following ripped version of the above line is for Tetramax compatibility

  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_addr_9 (adr_lt[9], 1'b0, 1'b0, clk_lat, adr_fw[9]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_addr_8 (adr_lt[8], 1'b0, 1'b0, clk_lat, adr_fw[8]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_addr_7 (adr_lt[7], 1'b0, 1'b0, clk_lat, adr_fw[7]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_addr_6 (adr_lt[6], 1'b0, 1'b0, clk_lat, adr_fw[6]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_addr_5 (adr_lt[5], 1'b0, 1'b0, clk_lat, adr_fw[5]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_addr_4 (adr_lt[4], 1'b0, 1'b0, clk_lat, adr_fw[4]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_addr_3 (adr_lt[3], 1'b0, 1'b0, clk_lat, adr_fw[3]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_addr_2 (adr_lt[2], 1'b0, 1'b0, clk_lat, adr_fw[2]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_addr_1 (adr_lt[1], 1'b0, 1'b0, clk_lat, adr_fw[1]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_addr_0 (adr_lt[0], 1'b0, 1'b0, clk_lat, adr_fw[0]);

//  and  an_f_19 [52:0] (q,          fwenbi, q_fw);
// The following ripped version of the above line is for Tetramax compatibility

  and an_f_19_52 (q[52], shutoff_oc, q_fw[52]);
  and an_f_19_51 (q[51], shutoff_oc, q_fw[51]);
  and an_f_19_50 (q[50], shutoff_oc, q_fw[50]);
  and an_f_19_49 (q[49], shutoff_oc, q_fw[49]);
  and an_f_19_48 (q[48], shutoff_oc, q_fw[48]);
  and an_f_19_47 (q[47], shutoff_oc, q_fw[47]);
  and an_f_19_46 (q[46], shutoff_oc, q_fw[46]);
  and an_f_19_45 (q[45], shutoff_oc, q_fw[45]);
  and an_f_19_44 (q[44], shutoff_oc, q_fw[44]);
  and an_f_19_43 (q[43], shutoff_oc, q_fw[43]);
  and an_f_19_42 (q[42], shutoff_oc, q_fw[42]);
  and an_f_19_41 (q[41], shutoff_oc, q_fw[41]);
  and an_f_19_40 (q[40], shutoff_oc, q_fw[40]);
  and an_f_19_39 (q[39], shutoff_oc, q_fw[39]);
  and an_f_19_38 (q[38], shutoff_oc, q_fw[38]);
  and an_f_19_37 (q[37], shutoff_oc, q_fw[37]);
  and an_f_19_36 (q[36], shutoff_oc, q_fw[36]);
  and an_f_19_35 (q[35], shutoff_oc, q_fw[35]);
  and an_f_19_34 (q[34], shutoff_oc, q_fw[34]);
  and an_f_19_33 (q[33], shutoff_oc, q_fw[33]);
  and an_f_19_32 (q[32], shutoff_oc, q_fw[32]);
  and an_f_19_31 (q[31], shutoff_oc, q_fw[31]);
  and an_f_19_30 (q[30], shutoff_oc, q_fw[30]);
  and an_f_19_29 (q[29], shutoff_oc, q_fw[29]);
  and an_f_19_28 (q[28], shutoff_oc, q_fw[28]);
  and an_f_19_27 (q[27], shutoff_oc, q_fw[27]);
  and an_f_19_26 (q[26], shutoff_oc, q_fw[26]);
  and an_f_19_25 (q[25], shutoff_oc, q_fw[25]);
  and an_f_19_24 (q[24], shutoff_oc, q_fw[24]);
  and an_f_19_23 (q[23], shutoff_oc, q_fw[23]);
  and an_f_19_22 (q[22], shutoff_oc, q_fw[22]);
  and an_f_19_21 (q[21], shutoff_oc, q_fw[21]);
  and an_f_19_20 (q[20], shutoff_oc, q_fw[20]);
  and an_f_19_19 (q[19], shutoff_oc, q_fw[19]);
  and an_f_19_18 (q[18], shutoff_oc, q_fw[18]);
  and an_f_19_17 (q[17], shutoff_oc, q_fw[17]);
  and an_f_19_16 (q[16], shutoff_oc, q_fw[16]);
  and an_f_19_15 (q[15], shutoff_oc, q_fw[15]);
  and an_f_19_14 (q[14], shutoff_oc, q_fw[14]);
  and an_f_19_13 (q[13], shutoff_oc, q_fw[13]);
  and an_f_19_12 (q[12], shutoff_oc, q_fw[12]);
  and an_f_19_11 (q[11], shutoff_oc, q_fw[11]);
  and an_f_19_10 (q[10], shutoff_oc, q_fw[10]);
  and an_f_19_9 (q[9], shutoff_oc, q_fw[9]);
  and an_f_19_8 (q[8], shutoff_oc, q_fw[8]);
  and an_f_19_7 (q[7], shutoff_oc, q_fw[7]);
  and an_f_19_6 (q[6], shutoff_oc, q_fw[6]);
  and an_f_19_5 (q[5], shutoff_oc, q_fw[5]);
  and an_f_19_4 (q[4], shutoff_oc, q_fw[4]);
  and an_f_19_3 (q[3], shutoff_oc, q_fw[3]);
  and an_f_19_2 (q[2], shutoff_oc, q_fw[2]);
  and an_f_19_1 (q[1], shutoff_oc, q_fw[1]);
  and an_f_19_0 (q[0], shutoff_oc, q_fw[0]);

  // shutoff pass through
  buf pbuf    (shutoffout, shutoff);

  // make sure all redrow enables are included in address
//  not    not_rrena [1:0] (redrowen_b, redrowen_lt);
// The following ripped version of the above line is for Tetramax compatibility

  not not_rrena_1 (redrowen_b[1], redrowen_lt[1]);
  not not_rrena_0 (redrowen_b[0], redrowen_lt[0]);

// and rdredrowen_* together"
  and    and_rrena0 (redrowen_addr[0], tie1, redrowen_b[0], redrowen_lt[1]);

  // calculate redundancy row address
assign rcolblkrow[2] = redrowenx ? tiex : adr_lt[1];
assign rcolblkrow[1] = redrowenx ? tiex : adr_lt[0];

  assign rcolblkrow[0] = redrowenx ? tiex : redrowen_addr[0];
//  buf buf_adrN [9:4]  (redaddr[9:4], tie1);
// The following ripped version of the above line is for Tetramax compatibility

  buf buf_adrN_9 (redaddr[9], tie1);
  buf buf_adrN_8 (redaddr[8], tie1);
  buf buf_adrN_7 (redaddr[7], tie1);
  buf buf_adrN_6 (redaddr[6], tie1);
  buf buf_adrN_5 (redaddr[5], tie1);
  buf buf_adrN_4 (redaddr[4], tie1);
  buf buf_adrN_3 (redaddr[3], tie1);
//  buf buf_adr0 [3:0] (redaddr[3:0],  rcolblkrow[3:0]);
// The following ripped version of the above line is for Tetramax compatibility

  buf buf_adr0_2 (redaddr[2], rcolblkrow[2]);
  buf buf_adr0_1 (redaddr[1], rcolblkrow[1]);
  buf buf_adr0_0 (redaddr[0], rcolblkrow[0]);

  // mux redundancy vs regular row address

// or redrowen_lt[*] together
  or    or_rrena0 (redrowen_w, tie0, redrowen_lt[0], redrowen_lt[1]);

assign rrowaddr[9] = redrowen_w ? redaddr[9] : adr_lt[9];
assign rrowaddr[8] = redrowen_w ? redaddr[8] : adr_lt[8];
assign rrowaddr[7] = redrowen_w ? redaddr[7] : adr_lt[7];
assign rrowaddr[6] = redrowen_w ? redaddr[6] : adr_lt[6];
assign rrowaddr[5] = redrowen_w ? redaddr[5] : adr_lt[5];
assign rrowaddr[4] = redrowen_w ? redaddr[4] : adr_lt[4];
assign rrowaddr[3] = redrowen_w ? redaddr[3] : adr_lt[3];
assign rrowaddr[2] = redrowen_w ? redaddr[2] : adr_lt[2];
assign rrowaddr[1] = redrowen_w ? redaddr[1] : adr_lt[1];
assign rrowaddr[0] = redrowen_w ? redaddr[0] : adr_lt[0];

  // E4 or E10 contention if both row enables set at same time
//  and and_rren  (redrowenx, redrowen_lt[0], redrowen_lt[1]);
//  xgate xgate1 (.xpin(redrowenx), .vss(unused));
  // if more than 1 row selected, propogate X into address
  and   and_rrenax0 (redrowenx, tie1, redrowen_lt[0], redrowen_lt[1]);


  // Force bit writes all one for dual redundancy enable collision case
//  not not_rrenb (redrowenx_b, redrowenx);

  // E4 or E10 contention if both read and write at same time
//  and and_rw   (rdwrx, ren_lt, wen_lt);
//  xgate xgate2 (.xpin(rdwrx), .vss(unused));

  // Force bit writes all one for collision case
  nand nand_rw (rdwrx_b, ren_lt, wen_lt);

  // OR Bit write enables to get "one per cram" write enables
//  buf buf_be [52:0] (biten, tie1);
// The following ripped version of the above line is for Tetramax compatibility

  buf buf_be_52 (biten[52], tie1);
  buf buf_be_51 (biten[51], tie1);
  buf buf_be_50 (biten[50], tie1);
  buf buf_be_49 (biten[49], tie1);
  buf buf_be_48 (biten[48], tie1);
  buf buf_be_47 (biten[47], tie1);
  buf buf_be_46 (biten[46], tie1);
  buf buf_be_45 (biten[45], tie1);
  buf buf_be_44 (biten[44], tie1);
  buf buf_be_43 (biten[43], tie1);
  buf buf_be_42 (biten[42], tie1);
  buf buf_be_41 (biten[41], tie1);
  buf buf_be_40 (biten[40], tie1);
  buf buf_be_39 (biten[39], tie1);
  buf buf_be_38 (biten[38], tie1);
  buf buf_be_37 (biten[37], tie1);
  buf buf_be_36 (biten[36], tie1);
  buf buf_be_35 (biten[35], tie1);
  buf buf_be_34 (biten[34], tie1);
  buf buf_be_33 (biten[33], tie1);
  buf buf_be_32 (biten[32], tie1);
  buf buf_be_31 (biten[31], tie1);
  buf buf_be_30 (biten[30], tie1);
  buf buf_be_29 (biten[29], tie1);
  buf buf_be_28 (biten[28], tie1);
  buf buf_be_27 (biten[27], tie1);
  buf buf_be_26 (biten[26], tie1);
  buf buf_be_25 (biten[25], tie1);
  buf buf_be_24 (biten[24], tie1);
  buf buf_be_23 (biten[23], tie1);
  buf buf_be_22 (biten[22], tie1);
  buf buf_be_21 (biten[21], tie1);
  buf buf_be_20 (biten[20], tie1);
  buf buf_be_19 (biten[19], tie1);
  buf buf_be_18 (biten[18], tie1);
  buf buf_be_17 (biten[17], tie1);
  buf buf_be_16 (biten[16], tie1);
  buf buf_be_15 (biten[15], tie1);
  buf buf_be_14 (biten[14], tie1);
  buf buf_be_13 (biten[13], tie1);
  buf buf_be_12 (biten[12], tie1);
  buf buf_be_11 (biten[11], tie1);
  buf buf_be_10 (biten[10], tie1);
  buf buf_be_9 (biten[9], tie1);
  buf buf_be_8 (biten[8], tie1);
  buf buf_be_7 (biten[7], tie1);
  buf buf_be_6 (biten[6], tie1);
  buf buf_be_5 (biten[5], tie1);
  buf buf_be_4 (biten[4], tie1);
  buf buf_be_3 (biten[3], tie1);
  buf buf_be_2 (biten[2], tie1);
  buf buf_be_1 (biten[1], tie1);
  buf buf_be_0 (biten[0], tie1);


  // effect of sleep on write
  and  and_wren  (wren, s_or_f_b, wen_lt);
  and  and_wrenck  (wren_ck, wren, clk_lat);
  and  and_rdenck  (rden_ck, rden, clk_lat);

  // effect of sleep on read
  and  and_rden  (rden, s_or_f_b, ren_lt);

  // Mem output reset
  or or_pwds (q_rst, shutoff, pshutoff, async_reset);

  // AND clock and latched read enable for output reset
  and and_clkrd (clkrd, clk, ren_lt, clk_lat);

  // Invert anded clock and latched read enable for output reset
  not not_q_lat (q_lat, clkrd);

  // Asyncronously resettable output latches

  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_52 (q_s[52], 1'b0, q_rst, q_lat, do_cram[52]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_51 (q_s[51], 1'b0, q_rst, q_lat, do_cram[51]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_50 (q_s[50], 1'b0, q_rst, q_lat, do_cram[50]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_49 (q_s[49], 1'b0, q_rst, q_lat, do_cram[49]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_48 (q_s[48], 1'b0, q_rst, q_lat, do_cram[48]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_47 (q_s[47], 1'b0, q_rst, q_lat, do_cram[47]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_46 (q_s[46], 1'b0, q_rst, q_lat, do_cram[46]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_45 (q_s[45], 1'b0, q_rst, q_lat, do_cram[45]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_44 (q_s[44], 1'b0, q_rst, q_lat, do_cram[44]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_43 (q_s[43], 1'b0, q_rst, q_lat, do_cram[43]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_42 (q_s[42], 1'b0, q_rst, q_lat, do_cram[42]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_41 (q_s[41], 1'b0, q_rst, q_lat, do_cram[41]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_40 (q_s[40], 1'b0, q_rst, q_lat, do_cram[40]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_39 (q_s[39], 1'b0, q_rst, q_lat, do_cram[39]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_38 (q_s[38], 1'b0, q_rst, q_lat, do_cram[38]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_37 (q_s[37], 1'b0, q_rst, q_lat, do_cram[37]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_36 (q_s[36], 1'b0, q_rst, q_lat, do_cram[36]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_35 (q_s[35], 1'b0, q_rst, q_lat, do_cram[35]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_34 (q_s[34], 1'b0, q_rst, q_lat, do_cram[34]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_33 (q_s[33], 1'b0, q_rst, q_lat, do_cram[33]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_32 (q_s[32], 1'b0, q_rst, q_lat, do_cram[32]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_31 (q_s[31], 1'b0, q_rst, q_lat, do_cram[31]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_30 (q_s[30], 1'b0, q_rst, q_lat, do_cram[30]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_29 (q_s[29], 1'b0, q_rst, q_lat, do_cram[29]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_28 (q_s[28], 1'b0, q_rst, q_lat, do_cram[28]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_27 (q_s[27], 1'b0, q_rst, q_lat, do_cram[27]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_26 (q_s[26], 1'b0, q_rst, q_lat, do_cram[26]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_25 (q_s[25], 1'b0, q_rst, q_lat, do_cram[25]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_24 (q_s[24], 1'b0, q_rst, q_lat, do_cram[24]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_23 (q_s[23], 1'b0, q_rst, q_lat, do_cram[23]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_22 (q_s[22], 1'b0, q_rst, q_lat, do_cram[22]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_21 (q_s[21], 1'b0, q_rst, q_lat, do_cram[21]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_20 (q_s[20], 1'b0, q_rst, q_lat, do_cram[20]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_19 (q_s[19], 1'b0, q_rst, q_lat, do_cram[19]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_18 (q_s[18], 1'b0, q_rst, q_lat, do_cram[18]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_17 (q_s[17], 1'b0, q_rst, q_lat, do_cram[17]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_16 (q_s[16], 1'b0, q_rst, q_lat, do_cram[16]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_15 (q_s[15], 1'b0, q_rst, q_lat, do_cram[15]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_14 (q_s[14], 1'b0, q_rst, q_lat, do_cram[14]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_13 (q_s[13], 1'b0, q_rst, q_lat, do_cram[13]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_12 (q_s[12], 1'b0, q_rst, q_lat, do_cram[12]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_11 (q_s[11], 1'b0, q_rst, q_lat, do_cram[11]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_10 (q_s[10], 1'b0, q_rst, q_lat, do_cram[10]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_9 (q_s[9], 1'b0, q_rst, q_lat, do_cram[9]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_8 (q_s[8], 1'b0, q_rst, q_lat, do_cram[8]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_7 (q_s[7], 1'b0, q_rst, q_lat, do_cram[7]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_6 (q_s[6], 1'b0, q_rst, q_lat, do_cram[6]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_5 (q_s[5], 1'b0, q_rst, q_lat, do_cram[5]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_4 (q_s[4], 1'b0, q_rst, q_lat, do_cram[4]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_3 (q_s[3], 1'b0, q_rst, q_lat, do_cram[3]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_2 (q_s[2], 1'b0, q_rst, q_lat, do_cram[2]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_1 (q_s[1], 1'b0, q_rst, q_lat, do_cram[1]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_0 (q_s[0], 1'b0, q_rst, q_lat, do_cram[0]);
  and (stbyp_l, stbyp , clkrd);

  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_52 (q_fw[52], 1'b0, q_rst, stbyp_l, q_s[52]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_51 (q_fw[51], 1'b0, q_rst, stbyp_l, q_s[51]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_50 (q_fw[50], 1'b0, q_rst, stbyp_l, q_s[50]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_49 (q_fw[49], 1'b0, q_rst, stbyp_l, q_s[49]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_48 (q_fw[48], 1'b0, q_rst, stbyp_l, q_s[48]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_47 (q_fw[47], 1'b0, q_rst, stbyp_l, q_s[47]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_46 (q_fw[46], 1'b0, q_rst, stbyp_l, q_s[46]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_45 (q_fw[45], 1'b0, q_rst, stbyp_l, q_s[45]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_44 (q_fw[44], 1'b0, q_rst, stbyp_l, q_s[44]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_43 (q_fw[43], 1'b0, q_rst, stbyp_l, q_s[43]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_42 (q_fw[42], 1'b0, q_rst, stbyp_l, q_s[42]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_41 (q_fw[41], 1'b0, q_rst, stbyp_l, q_s[41]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_40 (q_fw[40], 1'b0, q_rst, stbyp_l, q_s[40]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_39 (q_fw[39], 1'b0, q_rst, stbyp_l, q_s[39]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_38 (q_fw[38], 1'b0, q_rst, stbyp_l, q_s[38]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_37 (q_fw[37], 1'b0, q_rst, stbyp_l, q_s[37]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_36 (q_fw[36], 1'b0, q_rst, stbyp_l, q_s[36]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_35 (q_fw[35], 1'b0, q_rst, stbyp_l, q_s[35]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_34 (q_fw[34], 1'b0, q_rst, stbyp_l, q_s[34]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_33 (q_fw[33], 1'b0, q_rst, stbyp_l, q_s[33]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_32 (q_fw[32], 1'b0, q_rst, stbyp_l, q_s[32]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_31 (q_fw[31], 1'b0, q_rst, stbyp_l, q_s[31]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_30 (q_fw[30], 1'b0, q_rst, stbyp_l, q_s[30]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_29 (q_fw[29], 1'b0, q_rst, stbyp_l, q_s[29]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_28 (q_fw[28], 1'b0, q_rst, stbyp_l, q_s[28]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_27 (q_fw[27], 1'b0, q_rst, stbyp_l, q_s[27]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_26 (q_fw[26], 1'b0, q_rst, stbyp_l, q_s[26]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_25 (q_fw[25], 1'b0, q_rst, stbyp_l, q_s[25]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_24 (q_fw[24], 1'b0, q_rst, stbyp_l, q_s[24]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_23 (q_fw[23], 1'b0, q_rst, stbyp_l, q_s[23]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_22 (q_fw[22], 1'b0, q_rst, stbyp_l, q_s[22]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_21 (q_fw[21], 1'b0, q_rst, stbyp_l, q_s[21]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_20 (q_fw[20], 1'b0, q_rst, stbyp_l, q_s[20]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_19 (q_fw[19], 1'b0, q_rst, stbyp_l, q_s[19]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_18 (q_fw[18], 1'b0, q_rst, stbyp_l, q_s[18]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_17 (q_fw[17], 1'b0, q_rst, stbyp_l, q_s[17]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_16 (q_fw[16], 1'b0, q_rst, stbyp_l, q_s[16]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_15 (q_fw[15], 1'b0, q_rst, stbyp_l, q_s[15]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_14 (q_fw[14], 1'b0, q_rst, stbyp_l, q_s[14]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_13 (q_fw[13], 1'b0, q_rst, stbyp_l, q_s[13]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_12 (q_fw[12], 1'b0, q_rst, stbyp_l, q_s[12]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_11 (q_fw[11], 1'b0, q_rst, stbyp_l, q_s[11]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_10 (q_fw[10], 1'b0, q_rst, stbyp_l, q_s[10]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_9 (q_fw[9], 1'b0, q_rst, stbyp_l, q_s[9]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_8 (q_fw[8], 1'b0, q_rst, stbyp_l, q_s[8]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_7 (q_fw[7], 1'b0, q_rst, stbyp_l, q_s[7]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_6 (q_fw[6], 1'b0, q_rst, stbyp_l, q_s[6]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_5 (q_fw[5], 1'b0, q_rst, stbyp_l, q_s[5]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_4 (q_fw[4], 1'b0, q_rst, stbyp_l, q_s[4]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_3 (q_fw[3], 1'b0, q_rst, stbyp_l, q_s[3]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_2 (q_fw[2], 1'b0, q_rst, stbyp_l, q_s[2]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_1 (q_fw[1], 1'b0, q_rst, stbyp_l, q_s[1]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_0 (q_fw[0], 1'b0, q_rst, stbyp_l, q_s[0]);
// Mux output from regualr and redudnant arrays
  or or_do_asel (asel_b, redrowen[1], redrowen[0]);
  not not_do_asel (asel, asel_b);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT lat_asel_rrowen (asel_lt, 1'b0, 1'b0, clk_fw, asel);
assign do_cram[52] = asel_lt ? do_crama[52]: do_cramr[52];
assign do_cram[51] = asel_lt ? do_crama[51]: do_cramr[51];
assign do_cram[50] = asel_lt ? do_crama[50]: do_cramr[50];
assign do_cram[49] = asel_lt ? do_crama[49]: do_cramr[49];
assign do_cram[48] = asel_lt ? do_crama[48]: do_cramr[48];
assign do_cram[47] = asel_lt ? do_crama[47]: do_cramr[47];
assign do_cram[46] = asel_lt ? do_crama[46]: do_cramr[46];
assign do_cram[45] = asel_lt ? do_crama[45]: do_cramr[45];
assign do_cram[44] = asel_lt ? do_crama[44]: do_cramr[44];
assign do_cram[43] = asel_lt ? do_crama[43]: do_cramr[43];
assign do_cram[42] = asel_lt ? do_crama[42]: do_cramr[42];
assign do_cram[41] = asel_lt ? do_crama[41]: do_cramr[41];
assign do_cram[40] = asel_lt ? do_crama[40]: do_cramr[40];
assign do_cram[39] = asel_lt ? do_crama[39]: do_cramr[39];
assign do_cram[38] = asel_lt ? do_crama[38]: do_cramr[38];
assign do_cram[37] = asel_lt ? do_crama[37]: do_cramr[37];
assign do_cram[36] = asel_lt ? do_crama[36]: do_cramr[36];
assign do_cram[35] = asel_lt ? do_crama[35]: do_cramr[35];
assign do_cram[34] = asel_lt ? do_crama[34]: do_cramr[34];
assign do_cram[33] = asel_lt ? do_crama[33]: do_cramr[33];
assign do_cram[32] = asel_lt ? do_crama[32]: do_cramr[32];
assign do_cram[31] = asel_lt ? do_crama[31]: do_cramr[31];
assign do_cram[30] = asel_lt ? do_crama[30]: do_cramr[30];
assign do_cram[29] = asel_lt ? do_crama[29]: do_cramr[29];
assign do_cram[28] = asel_lt ? do_crama[28]: do_cramr[28];
assign do_cram[27] = asel_lt ? do_crama[27]: do_cramr[27];
assign do_cram[26] = asel_lt ? do_crama[26]: do_cramr[26];
assign do_cram[25] = asel_lt ? do_crama[25]: do_cramr[25];
assign do_cram[24] = asel_lt ? do_crama[24]: do_cramr[24];
assign do_cram[23] = asel_lt ? do_crama[23]: do_cramr[23];
assign do_cram[22] = asel_lt ? do_crama[22]: do_cramr[22];
assign do_cram[21] = asel_lt ? do_crama[21]: do_cramr[21];
assign do_cram[20] = asel_lt ? do_crama[20]: do_cramr[20];
assign do_cram[19] = asel_lt ? do_crama[19]: do_cramr[19];
assign do_cram[18] = asel_lt ? do_crama[18]: do_cramr[18];
assign do_cram[17] = asel_lt ? do_crama[17]: do_cramr[17];
assign do_cram[16] = asel_lt ? do_crama[16]: do_cramr[16];
assign do_cram[15] = asel_lt ? do_crama[15]: do_cramr[15];
assign do_cram[14] = asel_lt ? do_crama[14]: do_cramr[14];
assign do_cram[13] = asel_lt ? do_crama[13]: do_cramr[13];
assign do_cram[12] = asel_lt ? do_crama[12]: do_cramr[12];
assign do_cram[11] = asel_lt ? do_crama[11]: do_cramr[11];
assign do_cram[10] = asel_lt ? do_crama[10]: do_cramr[10];
assign do_cram[9] = asel_lt ? do_crama[9]: do_cramr[9];
assign do_cram[8] = asel_lt ? do_crama[8]: do_cramr[8];
assign do_cram[7] = asel_lt ? do_crama[7]: do_cramr[7];
assign do_cram[6] = asel_lt ? do_crama[6]: do_cramr[6];
assign do_cram[5] = asel_lt ? do_crama[5]: do_cramr[5];
assign do_cram[4] = asel_lt ? do_crama[4]: do_cramr[4];
assign do_cram[3] = asel_lt ? do_crama[3]: do_cramr[3];
assign do_cram[2] = asel_lt ? do_crama[2]: do_cramr[2];
assign do_cram[1] = asel_lt ? do_crama[1]: do_cramr[1];
assign do_cram[0] = asel_lt ? do_crama[0]: do_cramr[0];



// mux for wen
  assign wren_cka = asel_lt ? wren_ck : 1'b0;
  assign wren_ckr = asel_lt ? 1'b0 : wren_ck;

// _cram core
  ip764hduspsr1024x52m4b2s0r2p0d0_mem_1024x53 ramxx(
     .ad1(rrowaddr)
    ,.we1(wren_cka)
    ,.di1(din_lt)
    ,.be1(biten[0])
    ,.re1(rden_ck)
    ,.do1(do_crama)
  );


// redundant row _cram core
  ip764hduspsr1024x52m4b2s0r2p0d0_mem_2rx53 ramxxr(
     .ad1(rrowaddr[2:0])
    ,.we1(wren_ckr)
    ,.di1(din_lt)
    ,.be1(biten[0])
    ,.re1(rden_ck)
    ,.do1(do_cramr)
  );


`else // INTC_MEM_ATPG_SIMPLE
   // simple ATPG model

  wire    [52:0] q_s;
  wire  stbyp_l;


  and (stbyp_l, stbyp , clk);

  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_52 (q[52], 1'b0, 1'b0, stbyp_l, q_s[52]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_51 (q[51], 1'b0, 1'b0, stbyp_l, q_s[51]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_50 (q[50], 1'b0, 1'b0, stbyp_l, q_s[50]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_49 (q[49], 1'b0, 1'b0, stbyp_l, q_s[49]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_48 (q[48], 1'b0, 1'b0, stbyp_l, q_s[48]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_47 (q[47], 1'b0, 1'b0, stbyp_l, q_s[47]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_46 (q[46], 1'b0, 1'b0, stbyp_l, q_s[46]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_45 (q[45], 1'b0, 1'b0, stbyp_l, q_s[45]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_44 (q[44], 1'b0, 1'b0, stbyp_l, q_s[44]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_43 (q[43], 1'b0, 1'b0, stbyp_l, q_s[43]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_42 (q[42], 1'b0, 1'b0, stbyp_l, q_s[42]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_41 (q[41], 1'b0, 1'b0, stbyp_l, q_s[41]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_40 (q[40], 1'b0, 1'b0, stbyp_l, q_s[40]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_39 (q[39], 1'b0, 1'b0, stbyp_l, q_s[39]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_38 (q[38], 1'b0, 1'b0, stbyp_l, q_s[38]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_37 (q[37], 1'b0, 1'b0, stbyp_l, q_s[37]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_36 (q[36], 1'b0, 1'b0, stbyp_l, q_s[36]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_35 (q[35], 1'b0, 1'b0, stbyp_l, q_s[35]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_34 (q[34], 1'b0, 1'b0, stbyp_l, q_s[34]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_33 (q[33], 1'b0, 1'b0, stbyp_l, q_s[33]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_32 (q[32], 1'b0, 1'b0, stbyp_l, q_s[32]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_31 (q[31], 1'b0, 1'b0, stbyp_l, q_s[31]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_30 (q[30], 1'b0, 1'b0, stbyp_l, q_s[30]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_29 (q[29], 1'b0, 1'b0, stbyp_l, q_s[29]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_28 (q[28], 1'b0, 1'b0, stbyp_l, q_s[28]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_27 (q[27], 1'b0, 1'b0, stbyp_l, q_s[27]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_26 (q[26], 1'b0, 1'b0, stbyp_l, q_s[26]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_25 (q[25], 1'b0, 1'b0, stbyp_l, q_s[25]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_24 (q[24], 1'b0, 1'b0, stbyp_l, q_s[24]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_23 (q[23], 1'b0, 1'b0, stbyp_l, q_s[23]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_22 (q[22], 1'b0, 1'b0, stbyp_l, q_s[22]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_21 (q[21], 1'b0, 1'b0, stbyp_l, q_s[21]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_20 (q[20], 1'b0, 1'b0, stbyp_l, q_s[20]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_19 (q[19], 1'b0, 1'b0, stbyp_l, q_s[19]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_18 (q[18], 1'b0, 1'b0, stbyp_l, q_s[18]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_17 (q[17], 1'b0, 1'b0, stbyp_l, q_s[17]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_16 (q[16], 1'b0, 1'b0, stbyp_l, q_s[16]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_15 (q[15], 1'b0, 1'b0, stbyp_l, q_s[15]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_14 (q[14], 1'b0, 1'b0, stbyp_l, q_s[14]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_13 (q[13], 1'b0, 1'b0, stbyp_l, q_s[13]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_12 (q[12], 1'b0, 1'b0, stbyp_l, q_s[12]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_11 (q[11], 1'b0, 1'b0, stbyp_l, q_s[11]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_10 (q[10], 1'b0, 1'b0, stbyp_l, q_s[10]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_9 (q[9], 1'b0, 1'b0, stbyp_l, q_s[9]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_8 (q[8], 1'b0, 1'b0, stbyp_l, q_s[8]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_7 (q[7], 1'b0, 1'b0, stbyp_l, q_s[7]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_6 (q[6], 1'b0, 1'b0, stbyp_l, q_s[6]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_5 (q[5], 1'b0, 1'b0, stbyp_l, q_s[5]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_4 (q[4], 1'b0, 1'b0, stbyp_l, q_s[4]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_3 (q[3], 1'b0, 1'b0, stbyp_l, q_s[3]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_2 (q[2], 1'b0, 1'b0, stbyp_l, q_s[2]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_1 (q[1], 1'b0, 1'b0, stbyp_l, q_s[1]);
  ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT latB_0 (q[0], 1'b0, 1'b0, stbyp_l, q_s[0]);

// _cram core instantiation
  ip764hduspsr1024x52m4b2s0r2p0d0_mem_simple_1024x53 ramxx(
     .clk(clk)
    ,.ad1(adr)
    ,.we1(wen)
    ,.di1(din)

    ,.re1(ren)
    ,.do1(q_s)
  );



`endif // INTC_MEM_ATPG_SIMPLE

`ifndef INTC_MEM_ATPG_SIMPLE
`ifdef INTC_MEM_ESP
// ESP specific code =================================================
always @(shutoff)
  begin
    if (shutoff)
      begin
        setarray(1'bx);
        setredarray(1'bx);
      end
  end

task setarray(input reg val);
  integer widx; // words index
  begin
    for (widx=0; widx < 1024; widx=widx+1)
      begin

            ramxx.sl_0.mem[widx] = val;
            ramxx.sl_1.mem[widx] = val;
            ramxx.sl_2.mem[widx] = val;
            ramxx.sl_3.mem[widx] = val;
            ramxx.sl_4.mem[widx] = val;
            ramxx.sl_5.mem[widx] = val;
            ramxx.sl_6.mem[widx] = val;
            ramxx.sl_7.mem[widx] = val;
            ramxx.sl_8.mem[widx] = val;
            ramxx.sl_9.mem[widx] = val;
            ramxx.sl_10.mem[widx] = val;
            ramxx.sl_11.mem[widx] = val;
            ramxx.sl_12.mem[widx] = val;
            ramxx.sl_13.mem[widx] = val;
            ramxx.sl_14.mem[widx] = val;
            ramxx.sl_15.mem[widx] = val;
            ramxx.sl_16.mem[widx] = val;
            ramxx.sl_17.mem[widx] = val;
            ramxx.sl_18.mem[widx] = val;
            ramxx.sl_19.mem[widx] = val;
            ramxx.sl_20.mem[widx] = val;
            ramxx.sl_21.mem[widx] = val;
            ramxx.sl_22.mem[widx] = val;
            ramxx.sl_23.mem[widx] = val;
            ramxx.sl_24.mem[widx] = val;
            ramxx.sl_25.mem[widx] = val;
            ramxx.sl_26.mem[widx] = val;
            ramxx.sl_27.mem[widx] = val;
            ramxx.sl_28.mem[widx] = val;
            ramxx.sl_29.mem[widx] = val;
            ramxx.sl_30.mem[widx] = val;
            ramxx.sl_31.mem[widx] = val;
            ramxx.sl_32.mem[widx] = val;
            ramxx.sl_33.mem[widx] = val;
            ramxx.sl_34.mem[widx] = val;
            ramxx.sl_35.mem[widx] = val;
            ramxx.sl_36.mem[widx] = val;
            ramxx.sl_37.mem[widx] = val;
            ramxx.sl_38.mem[widx] = val;
            ramxx.sl_39.mem[widx] = val;
            ramxx.sl_40.mem[widx] = val;
            ramxx.sl_41.mem[widx] = val;
            ramxx.sl_42.mem[widx] = val;
            ramxx.sl_43.mem[widx] = val;
            ramxx.sl_44.mem[widx] = val;
            ramxx.sl_45.mem[widx] = val;
            ramxx.sl_46.mem[widx] = val;
            ramxx.sl_47.mem[widx] = val;
            ramxx.sl_48.mem[widx] = val;
            ramxx.sl_49.mem[widx] = val;
            ramxx.sl_50.mem[widx] = val;
            ramxx.sl_51.mem[widx] = val;
            ramxx.sl_52.mem[widx] = val;
      end
  end
endtask


task setredarray(input reg val);
  integer widx;
  begin
    for (widx=0; widx< 8; widx=widx+1)
      begin
            ramxxr.slr_0.mem[widx] = val;
            ramxxr.slr_1.mem[widx] = val;
            ramxxr.slr_2.mem[widx] = val;
            ramxxr.slr_3.mem[widx] = val;
            ramxxr.slr_4.mem[widx] = val;
            ramxxr.slr_5.mem[widx] = val;
            ramxxr.slr_6.mem[widx] = val;
            ramxxr.slr_7.mem[widx] = val;
            ramxxr.slr_8.mem[widx] = val;
            ramxxr.slr_9.mem[widx] = val;
            ramxxr.slr_10.mem[widx] = val;
            ramxxr.slr_11.mem[widx] = val;
            ramxxr.slr_12.mem[widx] = val;
            ramxxr.slr_13.mem[widx] = val;
            ramxxr.slr_14.mem[widx] = val;
            ramxxr.slr_15.mem[widx] = val;
            ramxxr.slr_16.mem[widx] = val;
            ramxxr.slr_17.mem[widx] = val;
            ramxxr.slr_18.mem[widx] = val;
            ramxxr.slr_19.mem[widx] = val;
            ramxxr.slr_20.mem[widx] = val;
            ramxxr.slr_21.mem[widx] = val;
            ramxxr.slr_22.mem[widx] = val;
            ramxxr.slr_23.mem[widx] = val;
            ramxxr.slr_24.mem[widx] = val;
            ramxxr.slr_25.mem[widx] = val;
            ramxxr.slr_26.mem[widx] = val;
            ramxxr.slr_27.mem[widx] = val;
            ramxxr.slr_28.mem[widx] = val;
            ramxxr.slr_29.mem[widx] = val;
            ramxxr.slr_30.mem[widx] = val;
            ramxxr.slr_31.mem[widx] = val;
            ramxxr.slr_32.mem[widx] = val;
            ramxxr.slr_33.mem[widx] = val;
            ramxxr.slr_34.mem[widx] = val;
            ramxxr.slr_35.mem[widx] = val;
            ramxxr.slr_36.mem[widx] = val;
            ramxxr.slr_37.mem[widx] = val;
            ramxxr.slr_38.mem[widx] = val;
            ramxxr.slr_39.mem[widx] = val;
            ramxxr.slr_40.mem[widx] = val;
            ramxxr.slr_41.mem[widx] = val;
            ramxxr.slr_42.mem[widx] = val;
            ramxxr.slr_43.mem[widx] = val;
            ramxxr.slr_44.mem[widx] = val;
            ramxxr.slr_45.mem[widx] = val;
            ramxxr.slr_46.mem[widx] = val;
            ramxxr.slr_47.mem[widx] = val;
            ramxxr.slr_48.mem[widx] = val;
            ramxxr.slr_49.mem[widx] = val;
            ramxxr.slr_50.mem[widx] = val;
            ramxxr.slr_51.mem[widx] = val;
            ramxxr.slr_52.mem[widx] = val;
      end
  end
endtask
`endif // INTC_MEM_ESP
`endif // INTC_MEM_ATPG_SIMPLE

endmodule // ip764hduspsr1024x52m4b2s0r2p0d0

//`ifndef INTC_MEM_ATPG_SIMPLE

// --------------------------------------------------------------------------
// Level Latch primitive (translatable by libcomp, infers _dlat)
//
// Good ATPG coverage
// --------------------------------------------------------------------------
primitive ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT(Q, S, R, CK, D);
  output Q;
  input  S, R, CK, D;
  reg    Q;
  table
// S  R  CK  D   :  Q  :  Q(t+1)
   ?  0  0 (?1)  :  ?  :  1  ; //
   0  ?  0 (?0)  :  ?  :  0  ; //
   ?  0 (?0) 1   :  ?  :  1  ; // Clock transition Low
   0  ? (?0) 0   :  ?  :  0  ; // Clock transition Low
   ?  ? (?1) ?   :  ?  :  -  ; // Clock transition High
   0  0  1   *   :  ?  :  -  ; // No change when data transitions
   1  ?  ?   ?   :  ?  :  1  ; // Set
   *  0  1   ?   :  1  :  1  ; // Set transistions
   *  0  ?   1   :  1  :  1  ; // Set transistions
   0  1  ?   ?   :  ?  :  0  ; // Reset
   0  *  1   ?   :  0  :  0  ; // Reset transistions
   0  *  ?   ?   :  0  :  0  ; // Reset transistions
  endtable
endprimitive // ip764hduspsr1024x52m4b2s0r2p0d0_ASYNC_RST_LAT


//`endif // INTC_MEM_ATPG_SIMPLE

//=============================================================================
// END of ip764hduspsr1024x52m4b2s0r2p0d0_ATPG.v
//=============================================================================


