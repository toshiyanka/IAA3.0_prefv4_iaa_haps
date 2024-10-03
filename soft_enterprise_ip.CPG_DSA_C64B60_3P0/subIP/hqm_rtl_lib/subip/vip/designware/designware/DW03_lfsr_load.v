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
// AUTHOR:    Igor Kurilov       07/08/94 03:41am
//
// VERSION:   Simulation Architecture
//
// DesignWare_version: b22fcb2d
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------
//
// ABSTRACT:  LFSR Counter with Loadable Data Input
//           Programmable wordlength (width in integer range 1 to 50)
//           positive edge-triggering clock: clk
//           asynchronous reset(active low): reset
//           loadable (active low): load
//           when load = '0' load data and xor previous count
//           when load = '1' regular lfsr up counter
//           count state : count
//           when reset = '0', count <= "000...000"
//           counter state 0 to 2**width-2, "111...111" illegal state
//
// MODIFIED:
//
//           07/15/2015  Liming Su   Changed for compatibility with VCS Native
//                                   Low Power
//           07/14/94 06:14am
//           GN  Feb. 16th, 1996
//           changed DW03 to DW03
//           remove $generic and $end_generic
//           define paramter = 8
//------------------------------------------------------------------------------

module DW03_lfsr_load
  (data, load, cen, clk, reset, count);

  parameter integer width = 8 ;
  input [width-1 : 0] data;
  input load, cen, clk, reset;
  output [width-1 : 0] count;

  // synopsys translate_off

  reg right_xor, shift_right;
  reg [width-1 : 0] q, d, de, datax;

`ifdef UPF_POWER_AWARE
`protected
577?6T_5&]^91PVLM[IM:&J0Y)2(_K<C,/,?Z]&)bUD5IXM)PAM11)20JJeQU.f3
YA/OHV6K#H4EOQ]80Yc^T:UUE3]V7U9I9b54GE:[e_IEHJ#5:G7LTR+g3&@830T:
X3DY)HE2]QdIKO>-gY/BC:.Uf2UL&#.<3;b+ZK4-+dWb_QGSQX=[\\()UG_]abY&
_J]Y4b&aM)><LZB-/L.2I9G[/AQ5.d@>-c]2M@G=)L?@3LIG.f,B)7LbNLR5-J/6
+9L_:K/(IA8AFKTgK\QEX:dX(:A<7&@A;S+T10FHWYX,9CQQ_H50eLb?V_:F&L<A
SD+S].EdL@+5KX0B#6[(/_@F[c:43g1].U?J_D\A1]Z5dT.TMEaK.(,e;1AEN:&L
?;>SN6GgZg@fQHQPWRR@AL9<X+I)XNNYL[0:D(F:dV)ZO#CCFT.GQP2<T1ZWI5DD
&HK_O6F&FfZf<XETPbP(G)eQX_Se)\]U.V6,V=^cJ&37I>YN=64K82\e,R0bPG2?
:]T]aV)(M4/1Q&J[c2]D.D3g03_\HKFYU23=VGA2#7C-E<Qc^0;W<ST&?AfS2QK6
1YYJ+OTB&+T]3WS4-L9R7FM0LZC,8_WF;YF4W?2<PEC4SNM#RC/_,6,,U8]ATUH^
3CTE5ZI0<aYc21^SAf7>:Y>#G]@OfTRZS:6#POX2B))XS?.B@6]G:J#?eA(dCDH:
gdP:(S]=d7BFH1Q2(YL\O^fP+b#0:O1U3;TS_T@e92J&D.Lb;?RcE=5+A9I=5&I:
W)D]eGI+POSCCN(>_O)EU])S>Le@P/c0#&_d;?aTZU.?S=b(d-\.Y(Z71X@c+e@:
fTOEP33O]+YH2.34L(0d_+>V\\3SY<eD;KZYeICRB&TB6TYWUeH@-5/RK@QVce#f
VQLbOgNRcM+P7)NL(eg^N8M(d6/)RA8EbcJ?#Ed?1+LaeA[f;=LGQ<5.)fO1\bH8
3WMVS.XJA)a33[E_\>cKMG)6S3P,fgYbRYM_+&1b[7Z3G?[<EE?&GIeI?7L9]F5D
]4g>+cLMMZ_[KdMY+/4CWA>D0d_L#OH61C?>D56He;c0MeO\5+GM5NK10?W_[F]B
1aSQf?C4G9.KS+e@aW(^0C7d/KV:K[/PbERZ=(OA6=X[JS],J=7Z9B]YB2&J0QXC
UU^3T,@T]83]KWed]gN@=U7\6.cd.9<CZd+E/#cAg(>gBM6@)T4&fQLPOTfc4^FC
I+:&#,Z7?/-U^(WPYIFSZF5-ZNO\G^J/4QBaM_]V5BQ?BT8JGY_7b@,@6g:+9eS.
eb>B4XeQE@75O#9LB:NS&QgCIRCaDUBF^LVcKG0D.6,>.&MO=LH#V#+Q]K7faf+T
/\;Q.7\,eWf92F\2R_Y:e.OQ51;[UaWTP)-J,SDfD:d-013TH>V_A;0cLEN/ZcQZ
53EfNZN&&\1:K\4e?WF#bM2-M131W?fW)a2I^YJJ\DW\W6FBZS&]Q&B#b0.ML7?P
_&;ED3XXc/H]gQ1b22RZ60^g7P8IKJYPa?C\C?EbQO+VJP;5e_f(UGU]G00L&4=-
@#Z]]WNgN#S;(J?CL/9)+,[dY_^^IHXFT->B<M#]GH-d-_S-P5,7]BR;6CL6-K]K
de5/f?/@U2RM,>VNYe?cM?YPfD9M+D-,?44ZY5dYOT0DUU^_(fc^/^156VLJ(dPD
N,)PZT&A71bEQIY;^BF1bb>cNbV>2K_=3INBJGF1T;gWeY0X9TV(UC-=?,D#38Oa
)Q=L,^DZ1U4P+)?8ZQf/,E)1/;H9M+>V;EEFA@<EbfM?_^]+MK-N9K\[cFH1fHeET$
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
      datax = data ^ shr(q,shift_right);
      de = load ? shr(q,shift_right) : datax;
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

  // synopsys translate_on

endmodule // DW03_lfsr_load
