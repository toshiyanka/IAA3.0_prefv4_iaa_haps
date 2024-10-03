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
// AUTHOR:    Igor Kurilov       07/07/94 03:06am
//
// VERSION:   Simulation Architecture
//
// DesignWare_version: 848ae855
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------
//
// ABSTRACT:  LFSR Counter with Dynamic Count-to Flag
//           Programmable wordlength (width in integer range 1 to 50)
//           positive edge-triggering clock: clk
//           asynchronous reset(active low): reset
//           count state : count
//           when reset = '0' , count <= "000...000"
//           counter state 0 to 2**width-2, "111...111" illegal state
//
// MODIFIED:
//
//           RJK Jun. 16th, 2015
//           changed for compatibility with VCS Native Low Power
//
//           GN  Feb. 16th, 1996
//           changed dw03 to DW03
//           remove $generic and $end_generic
//           defined parameter width = 8
//------------------------------------------------------------------------------

module DW03_lfsr_dcnto
 (data, count_to, load, cen, clk, reset, count, tercnt);

  parameter integer width = 8 ;
  input [width-1 : 0] data;
  input [width-1 : 0] count_to;
  input load, cen, clk, reset;
  output [width-1 : 0] count;
  output tercnt;

  // synopsys translate_off

  reg right_xor, shift_right, tc;
  reg [width-1 : 0] q, de, d;

`ifdef UPF_POWER_AWARE
`protected
d;CRV1Rd(38TfeMCZ#:4:S&#7DCOcX(b5fKOeQZabZ3<R4C<G8(8/)BO/P:aQ[db
4UK5ZRF7;>\IBWE;(<JcVa05;]X7#>?SUF[,O=QcPfTUY3(BX:G9X#\J#VJ#P2<#
g9@DN7,ag+@]=>;U/8.Fb5H@V:&[#^K^K\5c^6[>+f73G7?0\089=e#T:^UP+B4S
CR0^_.QbZYLJ^J5@^SL30N(6PC-TCDR+VDgPBPg91K21Pa,egN39,:=_(e?3;-_R
1BOUAS??LHOA3fZabg_]J@[TQCE7;W3<B4#CIJ;4^#OAK_<)3ZL-S+4EKUDB)1L+
61-X7LYRI6,>)AaQ8\cBI;,5I1C578+8U12#L[-0XbY,U-eM\N-Ya7eAQ0B_3EbF
gR97\L#NW>.eFTe^IdWVM?K^(#5U(LI[Wb/-d/LK4+H]DZ4ZdI[GgOf[EJ@,EH=X
M3,\KOAX[)d0B1VT<)af.8E6GS<]f.Sd0N?@@DG7K7ZCF?VWS>MJ93)Q/e+b0)0(
WC&XbeOBGDY8d[F_V9TG=XdZfH,,4_.f\N8Md7+FMT:>3[NX(GJ75;)+aH:]M/N-
J:496faL>)9[^>:UHB747&1BR=V1fDM;09MXM\<=A_G8]<Vf;2?F9LW?>,TVP3S+
,(YDT@gFDC5@V[,7G0C8(_Z>e:f6@>cU-A#=65aR++)MS<-YBG=W_edG_+B]g+]V
SK(Ea(6]L7EJ9E<EOKP8B<:A>&685PL5T6Z6e2Xd9<86(GT&IO9ZOH-_;>DR@.KM
eb#CbD.4R4g@J3@M\:TLJH,6#OKX?@g)#?6J(,TARA>KaUS&B3XbW2^X08&Z[BB_
)IAP&c#\ARCfFK>g#P7PR9FCA(=Z6CE5G/KI8K<T=OKBG(>VWI(:)2:<_?W@\]:e
DJ)<4+<GLE_>/@cRO^cMC=:KTKDc<D\#RFUF)PVfXGb(N?F2<b-GS2+Z2g/;J;OJ
(=7[6Q<CMU49+X_A,TFeAHd<XMbfB:))2_^Z_K#-ZP;K^N>37=C]KaLG<A:=JRH8
?D-X8Y>RUR71C_5,F0/[:-6TKT#.2+3bA(6/e49^99])L#EA_YLeNQR,K8NRO\^<
UAdRAdI>a=Q>:O0(&c70;_NB60A>e&(d>N=(>=?V&IV[c0.)A4K9Og+PLNcfP-LO
TTG&>E.#a(<+W2/d1g1/3;4@abJDKeEe8^9#+Eg:)HS/dVH(3U5)G(QG;B0/,UKW
90PO_O3BaTMPAY+)HeaA[Ice3#:#02GHO8^3EE_g]6b[-LJYM5BT2;P^^CUGU3PF
-N?7>+\f=.;>^c@A/HU&U?JL?A+9JP8.D6We]-83g@R8S9_WMSCLaWfWM^:68.1-
FJgDA<c[8Oc;a]DWb1W:(d5@2::5#5&Z)N#,XUa>Bd_Ug0D;9c(H)3=bSaVSE7H2
03e#Z69Y<JMX<EbW@;aHP\H^G9AX;YM4HD<?N#ZeCB[K.##W<)J\I[=SQLWD.P9L
2>=,<f1-10WP7,05S=DGNO+Mab\ID:[(0;P06ZZA#/+.D\,7#UZQgdHWYGLJ=e(>
E?AU.D;+O#Z08MYE(YPR=620H<6aFN3e+ZB#9]KQe[8@JSa6/VNV\AD,ff1>df_V
?;cd(\OZgY7R(])0B,7@;B^WZX#6WI+5I&M>W?C5O+L8.bD916Bdag:\?D-+?^EJ
Y#MW=(D\/@c/P>@bQUSa,<#7D)=D((_+#6:GIBgW&7#2E=1EWPS.5BF5Y<DV<dIN
&CJB?TA6T\+5(<dU.e=^#4-1A5^d8L:dE>H;g#7GZEQQ\J<SXJE/[cF?X)IFWT7(
TIOf7ZELQ+,[b\ac2LC6]5;Q38\SV&(#Y1HE6-\JZ0MQD$
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

  always @(count_to or q) tc = count_to == q;

  //---------------------------------------------------------------------------
  // Parameter legality check
  //---------------------------------------------------------------------------
  
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
    
    if ( (width < 1) || (width > 50) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter width (legal range: 1 to 50)",
	width );
    end
  
    if ( param_err_flg == 1) begin
      $display(
        "%m :\n  Simulation aborted due to invalid parameter value(s)");
      $finish;
    end

  end // parameter_check 


  // synopsys translate_on

endmodule // DW03_lfsr_dcnto
