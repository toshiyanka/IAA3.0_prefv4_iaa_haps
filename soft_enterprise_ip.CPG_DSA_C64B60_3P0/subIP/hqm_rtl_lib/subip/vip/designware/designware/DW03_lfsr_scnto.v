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
// AUTHOR:    Igor Kurilov       07/09/94 01:44am
//
// VERSION:   Simulation Architecture
//
// DesignWare_version: 83242b32
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------
//
// ABSTRACT:  LFSR Counter with Static Count-to Flag
//           Programmable wordlength (width in integer range 1 to 50)
//           positive edge-triggering clock: clk
//           asynchronous reset(active low): reset
//           count state : count
//           when reset = '0' , count <= "000...000"
//           counter state 0 to 2**width-2, "111...111" illegal state
//
// MODIFIED:
//
//           07/16/2015  Liming Su   Changed for compatibility with VCS Native
//                                   Low Power
//           07/14/94 06:20am
//
//------------------------------------------------------------------------------

module DW03_lfsr_scnto
 (data, load, cen, clk, reset, count, tercnt);
parameter   integer width = 8;
parameter   integer count_to = 5;

  input [width-1 : 0] data;
  input load, cen, clk, reset;
  output [width-1 : 0] count;
  output tercnt;

  // synopsys translate_off

  reg right_xor, shift_right, tc;
  reg [width-1 : 0] q, de, d;

`ifdef UPF_POWER_AWARE
`protected
d;CRV1Rd(38TfeMCZ#:4:S&#7DCOcX(b5fKOeQZabZ3<R4C<G8(8/)BO/P:aQ[db
KFWZ7R&MF@.be<?(HUQS/@d7c<](]EK9dD/UQ3#a2N@&]=7RZGaRS#\O4O9SNC&[
:Y]@U+.GIQRM3dBKI:>2I[Ffde2Bc7bM-JDN@=_K8aU;6=M2PCX:Qd3/M:\Y-,P5
\0)P3^e4bFQg3096e[D40Y21DY[?)cE?d97I4\R9/1>+D71T#aD@2<D-D#4/P5eg
GZ_Z<\D_5C\#Xa&0GdU^2F.B3Ld4b4[HU/e3II;6L3SGZb^;C=TWX<JDf)eSKC6.
;L](VOG7AX?bZEHYU>BGa.B^O][gG=Y3,BAPN[f;(^A?EAeW1f7J1\a&V2?D2^OY
F[O6F\S+Q05[IScT_5^YZ@UcS)<1dBRL.F4[HW29d>YHOJccI:.d(afO]g5E&-T0
g@-T]Y\bf_MP^&AA.GBH<CEP;A8W2PJ<O&_b(YS8<[,GB;HTfC,b:_Y5UaU2_^XZ
Ua:U=fgf\563V^6Yd8g^+VQ;C//MD^J)QY43),[&]XbMS=I]g[L>CV(fKKD_G>A8
\+O-56e_N=RQORa@Xe^WYFH80MKXZg/&&BV9[Ka>1CAOHS3:3<^)Q+d/H&@fX>L8
[8eJd=+(XU50ge]4&d=UW+1e:BSI\P+gg/J,(FT][JU\A8L4R:(Za)fGM#YAL?5F
;68.N8,K39F3(cPQ_Y^_#&d;+3=WL#]IPBF+A9XSI2cDCcX9Q/72QNB>\X<1Z178
Pd1L0Y7[=-K1<XggM1#<geFQG+-XRbb]8^7:M41g@>0@8LY[c4@Y(=1.5MbYg.aE
K1fZ.ZeOH2;A+b<(L2\SZ+TVE+M-JQ&/fbg:7(L_9c]Q)K]bdeI64,SS3IGc(2Q\
4.T\ENSMUW/IZ.=]/XJP1QJ2e_e049cc?N#TfA84JE(aUIQdfbaS0S\>L=+PaA@^
]gP;E@BH>QD3>VLHZKX2F3[TR-EUc<)gR;63_8J+9[N/+aafY<]<+[H?J/YKL-bf
;B22-OCTJ=C[G;_7V59&QFQOU+R&,>eN,O=3C>8/[DPPL&QgOC;89=8CBbB,2NER
L#YYNPLa)b=+)4O#?S3WKAK3W).L9L)]1>_f_<3DUFON_?<2<VD]=0IGFgbTU>VY
Q2SK<-J9^:eU6RN[:.]Z#]BCSF05UBID)POEY+@f>)/V934=CL3_aLVca-SfeJ^>
FaS#9F1KI68\SZdaS-T@;W=@]P4ARN\WUS=/2M2@6<XM0KC(O0[5B2@VT:<_aWf;
#B;@,SZaG8C0X[R9K<7f2UCe3IdNW7?KAKgNW;D2W9PJI0fScJN&QK;@gKVbg.\]
DaN.;7ePb4+[K,T@e3e\,)gT+?8/<S9Pc:b[I48E51a2)97Gb\7JNI?/5M5]5d(#
e:@>)a1M^CF1M^N+Q5)KfZ0TG11397D[e;#X#Y:;D2&ER&:2[?I]Z::?<G[d+/UF
fV<9b2BdS.4=]@YZS?>?1UIJeH1>fRDPWDNK3#S)4Ve6\EX+\VSdK2[7dDKF-Z9f
Y85d=9EE#:TQ>U^\ab?Z4eL)=]@L3N<.FQf3):a7&GMMR-Y4>fDE)UPa?(-C<Yd4
?AR;e[<-,OZP:P&f#;@\?X8)288+PD:9;Z;3)e4MN/CaC4J5SbdWgG:^eb8Z^a((
H=M5/^HgAJR8NM8N\[48C7J\R>BcbAS3=H,WP)5fM,JM,+-H-_1SP3?&W<R?)D::
/aFEQ+6C-840B^-C+RJ<]C^R^BR_:g]eag+L/35(S\=#5.RdK9f]8>@ZP\PU,a.AT$
`endprotected

`else
  reg [width-1 : 0] p;
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

  assign count = q;
  assign tercnt = tc;

`ifndef UPF_POWER_AWARE
  initial
    begin
    case (width)
      1: p = 1'b1;
      2,3,4,6,7,15,22: p = 'b011;
      5,11,21,29,35: p = 'b0101;
      10,17,20,25,28,31,41: p = 'b01001;
      9,39: p = 'b010001;
      23,47: p = 'b0100001;
      18: p = 'b010000001;
      49: p = 'b01000000001;
      36: p = 'b0100000000001;
      33: p = 'b010000000000001;
      8,38,43: p = 'b01100011;
      12: p = 'b010011001;
      13,45: p = 'b011011;
      14: p = 'b01100000000011;
      16: p = 'b0101101;
      19: p = 'b01100011;
      24: p = 'b011011;
      26,27: p = 'b0110000011;
      30: p = 'b011000000000000011;
      32,48: p = 'b011000000000000000000000000011;
      34: p = 'b01100000000000011;
      37: p = 'b01010000000101;
      40: p = 'b01010000000000000000101;
      42: p = 'b0110000000000000000000011;
      44,50: p = 'b01100000000000000000000000011;
      46: p = 'b01100000000000000000011;
      default p = 'bx;
    endcase
    end
`endif

  always
    begin: proc_shr
      right_xor = (width == 1) ? ~ q[0] : ^ (q & p);
      shift_right = ~ right_xor;
      @q;
    end // proc_shr

  always
    @(load or cen or shift_right or q or data)
    begin
      de = load ? shr(q,shift_right) : data;
      d = cen ? de : q;
    end

  always @(posedge clk or negedge reset)
    begin
      if (reset === 1'b0)
        begin
          q <= 0;
        end
      else
        begin
          q <= d;
        end
    end

  always @(q) tc = count_to == q;

  // synopsys translate_on

endmodule // dw03_lfsr_scnto
