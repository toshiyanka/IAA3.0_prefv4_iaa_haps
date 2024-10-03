////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 1994 - 2020 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Igor Kurilov       07/09/94 02:08am
//
// VERSION:   Simulation Architecture
//
// DesignWare_version: f4092d46
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------
//
// ABSTRACT:  LFSR Up/Down Counter
//           Programmable wordlength (width in integer range 1 to 50)
//           positive edge-triggering clock: clk
//           asynchronous reset(active low): reset
//           updn = '1' count up, updn = '0' count down
//           count state : count
//           when reset = '0' , count <= "000...000"
//           counter state 0 to 2**width-2, "111...111" illegal state
//
// MODIFIED:
//
//           07/16/2015  Liming Su   Changed for compatibility with VCS Native
//                                   Low Power
//
//           07/14/94 06:26am
//           GN Feb. 16th, 1996
//           changed dw03 to DW03
//           remove $generic
//           define parameter width=8
//-------------------------------------------------------------------------

module DW03_lfsr_updn
 (updn, cen, clk, reset, count, tercnt);


  parameter integer width = 8;
  input updn, cen, clk, reset;
  output [width-1 : 0] count;
  output tercnt;

  // synopsys translate_off

  reg shift_right, shift_left, right_xor, left_xor, tc;
  reg [width-1 : 0] q, de, d;

`ifdef UPF_POWER_AWARE
`protected
0Y_Mc2\;aU3C,c&B[(_?)9GEV2[^W]^ENeGM@T64?A<>/(>KDYC]3)aV,VaM+-2&
U(,:C]<0e0e0\K/3cP>bALQ4.8d]4^O[cff@f(1JL/_aISBPDNI:Q873JW[:.7Tb
6@d.9J)=c3]b(-KJ=^RKFBE-L)8\@b:+18M^3S?<NXU)+E2]608Z4\cdI1=gLWR^
O/\VVQLDND8\;6WV#]:9AX<?bOZL(A\5ZTe3B?cE^.-)P-agX1[MM&\S-JBg+OZ7
Y4]\cJY=8\AZXcR2LL)gM<PEO/eMQNPAHYW,Nb@<G7CR-/KFceHf\:_>#eMD^)E7
_B=,S45/ZENUDRFF+ePI5P#K,fJT.\=PV3N[R1Y@DN=bVbgf/e\_QK[,4&]LA#e.
eJ57E29a-@2FWW<>-Qd),+=APAY\.<?g]+A1LV&Y6[1RGB+?7]EB\cAQgb.]QTQ/
1cbA_)FQ9D&<C7L4QI_XGa<L^.de&B1U)02;B1TSQIcULQ(&ff3=I45#FAX9I;?A
eK1e@1LZ:9GZe2gdFQ>\dFHC:198_b/I-:SfdH?ZOKW2G22+M@JF3&0KA8[AHFB/
aDX_AM37f;<-X@1\VVGY:=6+Q,Uc/5-8NZJZZ+fH/eZf&gR7F-dL+_PTdM+D6Zb_
Z&E(;cH:DUbC>G-(B9A-K-/[GP;F->PA_)/>&G;O1LAMcNB>Gf[U-gPW.ZCRY2UO
fJ6N).c+\246SQVgLfSY3R=d0-bOQR/]aA7P<S354:/PV[V^b]HS/d.f7VVa_^=[
8c^YAP&Ddc_a#0XRc3?bDE^/KObOB;OCX#8<HfD<M8DZP7@\,AeSBCSK](?(FRC?
<W3)&P,W<,5K9D/:3)\1SOR:d&\97#Ga1IO74(69-86@G<6G+Z(@H7_Cc4O@+V9C
/C40P6E6RQ6>:DI&?cK^]=4M=A#BD\]3+4\dfb3cQF#g54B@.-H?;ADF-b/AX(XH
TdNZ\93>+.1OCaA)0S42GeS^-^+CAW8MPJV)W-;2X=8/EbAEbI2@fWM9WJ8e[g:a
_U3MQbCDT65HcId&AEUMU&2[7,P/I,8_/;J.+,0-G.cENQIE:+5O@c:(+VOcLAS1
=VgN,HLCUKH33I.OZE/J+Ncc8SZ=WUZg9Obb1]:(TG:A_6[b27/a#F.\YGL.]S=A
dU@7]JN34?eIF9RCY>90Q<(/66_C^;4^6>85/(A@Fg0EEFIMdLQY;.FO,Fg8\C=5
,]fJe8]O;L)8S]J_dcW1L_:#DFHdg_\U6ICXeF[6@gg:LTJ5a,D9G78Z1a/#=^eA
IgX&29c@&fZC2:FC)H]RY>EfQ^fSf?\9<:f7]5:ERNC+@Q\IR@)TG@(H5D+AIYd\
OBROU05JJ):?:]Q4.6>&44.+F3MS@K2(gfO,Ze+[(O(7]99KAP,-?Vb]DG<Y/W)g
e<S=2-FR3f+Ve,:D.)_0GW14&e(2ALM\[b^.U),7ac7^LQ,aYP1DWgJf,aAWKP#_
)8E6Q^JFNXU,65Mg\a:fL(IS77+>646AWI,F(P]=R:.;REX-bMV2/Qg)LfQg@)VH
Y\LfXZ1<MUO>MS=W7=aEfN6c7KN_XZ9\,MggS:=#191CB8eEMf=1ea(^U3Ma.g=a
5c/IK05aRZ2K@W]Id.^4T]3[Y.ECZ>GVZ,c=/fX#;.+FO1;.UD#N=:VD8Sgb.cc8
C^aX@5;1e+BN0].V6Ud(SA?LDT_)G.I8=a#&fNcS[d17TJPY:T?C?G5A7:F8#8#g
0;PT/3TW0]\CGeT,FVb?V&__G@CUdFgXW5McUJKY+.1/O2+O7YTG>E,\)[##FEXX
d@G<?OA3acdQaF(SLNA.WUccPJ@^9=@UYg91?.9-3RK34_1I27AAUa96A0\W:.08Q$
`endprotected

`else
  reg [width-1 : 0] pr, pl;
`endif

  function [width-1 : 0] shr;
    input [width-1 : 0] a;
    input msb;
    reg [width-1 : 0] b;
    begin
      b = a >> 1;
      b[width-1] = msb;
      shr = b;
    end
  endfunction

  function [width-1 : 0] shl;
    input [width-1 : 0] a;
    input lsb;
    reg [width-1 : 0] b;
    begin
      b = a << 1;
      b[0] = lsb;
      shl = b;
    end
  endfunction

  assign count  = q;
  assign tercnt = tc;

`ifndef UPF_POWER_AWARE
  initial
    begin
    case (width)
      1: pr = 1'b1;
      2,3,4,6,7,15,22: pr = 'b011;
      5,11,21,29,35: pr = 'b0101;
      10,17,20,25,28,31,41: pr = 'b01001;
      9,39: pr = 'b010001;
      23,47: pr = 'b0100001;
      18: pr = 'b010000001;
      49: pr = 'b01000000001;
      36: pr = 'b0100000000001;
      33: pr = 'b010000000000001;
      8,38,43: pr = 'b01100011;
      12: pr = 'b010011001;
      13,45: pr = 'b011011;
      14: pr = 'b01100000000011;
      16: pr = 'b0101101;
      19: pr = 'b01100011;
      24: pr = 'b011011;
      26,27: pr = 'b0110000011;
      30: pr = 'b011000000000000011;
      32,48: pr = 'b011000000000000000000000000011;
      34: pr = 'b01100000000000011;
      37: pr = 'b01010000000101;
      40: pr = 'b01010000000000000000101;
      42: pr = 'b0110000000000000000000011;
      44,50: pr = 'b01100000000000000000000000011;
      46: pr = 'b01100000000000000000011;
      default pr = 'bx;
    endcase
    pl = shr(pr,1'b1);
    end
`endif

  always
    begin: proc_shr
      right_xor = (width == 1) ? ~ q[0] : ^ (q & pr);
      shift_right = ~ right_xor;
      @q;
    end // proc_shr

  always
    begin: proc_shl
      left_xor = (width == 1) ? ~ q[width-1] : ^ (q & pl);
      shift_left = ~ left_xor;
      @q;
    end // proc_shl

  always
    @(updn or cen or q or shift_right or shift_left)
    begin
      de = updn ? shr(q,shift_right) : shl(q,shift_left);
      d = cen ? de : q;
    end


  always @(posedge clk or negedge reset)
    begin
    if (reset === 1'b0)
      q <= {width{1'b0}};

    else
      q <= d;
    end

  always @ (q or updn)
    begin
    if (updn === 1'bx)
      tc = 1'bx;
	  
    else
      begin
      if (updn === 1'b0)
		begin
		if (q === {1'b1, {width-1{1'b0}}})
		  tc = 1'b1;
	     
		else
		  tc = 1'b0;
		end
	     
      else
		begin
		if (q === {{width-1{1'b0}}, 1'b1})
		   tc = 1'b1;
	     
		else
		   tc = 1'b0;
		end
      end
    end

  // synopsys translate_on

endmodule // DW03_lfsr_updn
