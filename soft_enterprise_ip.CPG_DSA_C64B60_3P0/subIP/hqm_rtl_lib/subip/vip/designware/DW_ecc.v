////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 2001 - 2020 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Rick Kelly    Aug. 7, 2001
//
// VERSION:   Verilog Simulation Model for DW_ecc
//
// DesignWare_version: e3fe0635
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////
//
// ABSTRACT: Error Detection & Correction
//
//      Parameters:
//           width       - data size (4 <= "width" <= 8178)
//           chkbits     - number of checkbits (5 <= "chkbits" <= 14)
//           synd_sel    - controls checkbit correction vs syndrome
//                           emission selection when gen input is not
//                           active (0 => correct check bits
//                           1 => pass syndrome to chkout)
//
//      Ports:
//           gen         - generate versus check mode control input
//                           (1 => generate check bits from datain
//                           0 => check validity of check bits on chkin
//                           with respect to data on datain and indicate
//                           the presence of errors on err_detect & err_multpl)
//           correct_n   - control signal indicating whether or not to correct
//           datain      - input data
//           chkin       - input check bits
//           err_detect  - flag indicating occurance of error
//           err_multpl  - flag indicating multibit (i.e. uncorrectable) error
//           dataout     - output data
//           chkout      - output check bits
//
//-----------------------------------------------------------------------------
// MODIFIED:
//
//  10/7/15 RJK  Updated for compatibility with VCS NLP feature
//  12/21/16 RJK Relaxed lower bound on width (STAR 9001134170)
//  7/14/17 RJK  Updated UPF specific code (STAR 9001217597)
//  7/24/19 RJK  Updated to eliminate lint warnings (STAR 9001489004)
//
//-----------------------------------------------------------------------------

module DW_ecc(gen, correct_n, datain, chkin,
		err_detect, err_multpl, dataout, chkout);

parameter integer width = 32;
parameter integer chkbits = 7;
parameter integer synd_sel = 0;

input gen;	// checkbit generation control input (active high)
input correct_n;// correct error control input (active low)
input [width-1:0] datain;   // data input bus (generating, checking & correcting)
input [chkbits-1:0] chkin;  // checkbit input bus (checking & correcting)

output err_detect;	// error detection output flag (active high)
output err_multpl;	// multiple bit error detection output (active high)
output [width-1:0] dataout;	// data output bus (generating, checking & correcting)
output [chkbits-1:0] chkout;	// checkbit output bus (generating & scrubbing)

// synopsys translate_off
`ifdef UPF_POWER_AWARE
`protected
;G/C,2a9aI+/RbcQ2gTaXPI\RJQQ,XKL(9Y]YS91\.HD/YT)Y?.g0)M)4\KU]T45
NZ-f&12+CK1KIE;F\WETUH-aa3GeCcdGQS7:[;AR,@VMZ>Q4TOg@Q5@Y_Sg)?\HI
:NAXA@Fe&/J]-SaKBI8+6CdNHNI:_FH(K-7GQK]WJ@3XNaTHR6CFWYWJM/R+M4BU
J;5>XGbP^H4V:?6-;@_\9+?UgW(_Q=-I9HUDP8[#C#_2dRT,B8690;d>4.\7H>@^
=:KAb+33BcH(A8d]58+TDKJTK_/^C4^0^N=;@_1WP;/M2Z3GSXgNK^d#8;5,LZBA
)2Ie.8YZ/2D1N]O8IV(Z:?bLf0B(?\(b+0TOa,M_\(HM97e>49<_Gf.LSYTY4V=P
IEXLFJZ\L)@^eURG@0F7JRZSU4+PWN8K_EJd\&_49Sd)\=9T21U2,0(4[JKQJTV>
Jd^Z6AH1^f4?#CFa@;BWEC_>SWaAQEX+NaV_#Xa&=.XB6eA:LVT]HA?aXC5HWaJg
[Ve@T#Va^ON(LQIQPHfW(U2D9Ce^S)ZN)cdJN4Ud8SJe^BggW@A<UH9O05HV[KZ\
8a1Bc1L^9/MMc-L2Yc^)]5K&1IG<YYW>41H1F6D.Z]#2NK_RMb1L8V_ZT#1TYK[(
<;ce]Y_)-52PfU.S@G\?[K?N7?SNb@2AN(g3+HI/>1,6^f2&g)XU1ENOD;5Q?#W3
2(g@YF>OD7@T^/&N?;]?PWBT0OSY7E8(eUdP=NH9N<FY0U1c5ZNDDbPW7.Y.\1&^
>6FXYW0+TZ[U__E&L0?;P1\>d;-.bY.4VG-a)b=Q>dG/WINd[Ng77QN\5VIR(3B]
g4NT=]-@E_[1Sg)RW&Z@f9BG0ZV6;90>f:g&@5S\ZP+#AJC+eX^2EHHESN[<,NX^
(O#/2XW.IEdC;K/3T>/:W68SC.+dMBH[=N,?R<&[V.OJXUWP57;6Hg?Yd.DU_ME\
ZB8OcYRQ10[cH]YBXD12W=SUL0IR12Efg)c7DAce>_bb4&)LgG.c2Z;^5TO#@dWG
.>K+;b6Z?4;QD[N0Y<N#FDB7?&>69C,_?dUE:Z8FR,44\I-)fF;\f@DSS^c15]5)
]gNXgK:PR:eGI6\B[S&B8bEU@R_\B;/>:8=C(?@f<Tc)L@FW;&9;=-\^[3@Jb>-T
WQ8ARL6X:fCLVQ/#X.Zb)ZC7\19IAS,:E+)5EED:<0,G6OO<Q=XWJ9Wdf8O79Y_R
)Ged_H/aFPP6MH+QK)d3QSYR5GcB(Bd0TG420.,^0B^NG(&;ZROAJdJeXFL?NgS1
VFa(SEJ6^N0aX-bf\[_DHG4PNSHHMCIW,?:4,::=6_[b2SM4VY/Ldd8>CS=D<\L3
,81QFaOb)\9+3Q1e74.Qd7fT=\.C3(/EGH.K?.X^9JK+K_EDD(UO^9SATgA7\OR1
0]C547I,&TD5(&J\g&_XVgU14K?=/@aON=CT>YQ#Bc=WG[TO0XN2[W\1fPVI0^[4
B<:P4X3A-M<[-U7X.WfaS\P)I:48[Q45DD))(9D@RX1;]G1<&2]OZ8+S<H39@>He
-\N3Eg4]LF:R5LdI,VgW;/#Sd]GIO;Z\CK8d>_<F#\3a(75^ZTW<YD^^JLN24EF5
D()2OSIGYN3=VAI6Dg[SRc:IGe[YGYL6[.STM:65Z<:\<0>,PAW(]YDT2#S)KU1g
dXC]4aRZaKHKgXCZJ(:P^577d_e5g1Wag3YD/NU6QS/?eD0ScYJL@2VDEeO]+eJ[
G>0cH@=1D1Y0YAW;=.\aNB:^J0?+?8b^J7a/5Gd(QZ3RM,4:Z(??LP-R;2Paf/+?
YE3C)G3MJ52QPII9AZPU.W:&61+,ME#[G):fge/Ofe3&6fUP7dH1E0A_4.USA&5g
)_>#DS7fGHU)fX6Lg]]Q\53F7CQX4;32T#X2(Cb&13XR^IBZ=R>3DYX4>=E#GNd+
+:U/MNB0P;/@L,UWVJ9.Y?=QY3>>JKT39>8@bUPIP6Y_(O[]7VKM+>:g:I<DTHd4
484DP@Zb)Oc?5JBa^_fW+^P?]6,:E[e3@a77@P;8#S=>3?_@STA@>@,88G;]+)P/
B5Z0b/a,D@5PBK6)(1LFK7;/K[g]ITBZ=8(g=5JX5[MP3)0ZDK_KK+fYHT\bVBDK
d]R-<Hb_K/,dc=O+)gUD@,7IX9(97M;d3N,OT@Q.a:fE04UMJQ]6R,?CN,ZQ+8;?
9KfA]]N0^5Q.KDY1+e)Q@UG=DU+LDc.K28RMEZ.G2GUD/EVB)e:cYc1gCdf78.gT
?OJ7DLQVF8):RR^MAL><=N>^Q<X&YG;9g<@1aSR]V(.,g1-;COK\\E_7?dR+bE.>
gY]19UTH,aT/b:abXP9@5UXL94^WcXVV;a6>@.=C>JZLg?;5M_\aK/&>G#>,&:0O
]_6#MZY/86VeHP4/K3g[1WZXa8-V,T+<WJU?>/_8F/8E=eSU#4Q#VT,8/ICe-44>
dO?5E-(:JYP#]E3fOLP>E5.[7-X<bN0A=].#AG8DOK?QHI:O8H@;2?(E,Z96NTfE
=e,PZVSMEEXL(,@]d2cf<+Z<^,ISH\\^K/810a),-e6CJWC<@Ng2JH7#(e,]39X-
;Z<P68QR:?gV,[UF1;//a?;8F(MPMeFYT.[@b[NA3:EM&;1We^U]LIg<T3^Sd\6O
aI3W-bQARbJ\6+RV18WWS/aXK_aaK,.NI51Z_bPP+/Jd6da:;K<^T<.Pa>d^FN68
H^=7MRe]e0J.G_Z507>_B68PI2AC9DaB)+3HEG_K=V0A]QB_VZdR-0f:>7M,ZYXa
U3(INcQ,P)^#PY&.gbU[D_&+Dc85fAVT<BQ[S/A;K&Q4T[Q7J1[2a[:&=]Bc(a&H
Vd;^aX@Q[[H]f>=9WPH1Cc@eSL9639,E?C/RV#a@cR+YbKNd^<]2]@_H?WXM?dS^
Uc^eJ8)[0b,g8U5e:)SbW[b[YP7J8Y/SICK4bER&cW/>OY<KL?3PUaJI#;AY/3RJ
g[.FgU_C9YVBTM.;X32(c/TeH<8WAX-BNC8_fAc#F.IL&6)<<aMJDH_56=O+7-Z5
Kg,S)Xc]g;66@g=&CMN<4M3SUPJDB0Q5HJGLfa32\O+0:POF=ZEQ@gV3R>&eQH:b
GZSXdI(7@1@.XJ55(=.(([2P_.1?U_\U1FFRXe9]e2Wb)3LJ^@3ZIT&:W=?T>;dQ
bV73ZU9<8</^N_-F7;,WJT\/WR_FU@,1U,a>NT>KG6+R_dA\U)0F+)?L,e[1G<O3
:_g)eYZ[(PHVSI6U64RU:+N()OT[\@T=JZa7)2(0O#O5W)fU6DABFU_]-:C9<NS(
\SYOJX(@]N+c4c:5H^g_CXJ.H,>_][#^=:#c#+2,>4YTA/DPDM;/.9L-<F:>7(M\
cT.+TDX(\/M9AfDGF<8E)>e4a5b7-]ae1Q?;\/B_K9_Z_I++OEbZ0cFc-HD#C2\:
Y41>O=M@>\=&WQNefQPNS0-a2YWd<^?E>D0>S5[&CA671F7@<fQbG4N]]7@D<2\f
_bc8),:0SK4@H;_CA(Gc,dG8<27:OXagGBZbBL4Y-7;c@X8#+/9P=>41edN3[VdT
HMe#OGLJ;/V-<L6QO[9ZYY@U51P+fId7eSWL:3F2006^^5T?aWTV5T2Q)QHO+0e3
R)F#HVQ^<2^-+]--O-6W,S&4(KB^CgNYQ2T&7(Ob[GeFR=/;BJ<_SJ/]82^\TDg/
&+=C0c<HDC1<<4:U^7=bQ@?cYCMQ?3,#B^b9:Y6/4==N_&Ceg_@O.51:e<U-RRM0
aC9_ZceI6c+D[B+X?GZH.OBb9DPC=QeO8)]ZD2b]daT2:/C?&RK;@]BHYb<5<:IW
9HL#X=]71)^GLP4f\I=)&E/7PNc\J<=,>UB4e@M&?IcYb<Ld&W)U._3=6EYOGQAD
b(>23D[_C]\6V])N9T(AMO/[I,_BR-2FT>SJ5.DFe)@+86..Q2>-BH&FXYdH2EW\
=-eLO?MX973)4U_Y<gSV4A@XBeKOV049ND#<>D-B8D2)O87I>/BQaDY>/_J2_8/,
(8gYS&6L[+=.J=5\3PXCT[CT?P4JDKgUE6T4;[Y:2K#M?K+X8QX@<L[A2@+>:WfC
Ia&4C7KSg\K<gBQ-O>D<39,[<)1&Gg6[COe]b\F[I2e8R+WGF&=F:0)L.[>:f]U^
&LT8^XQP9JbaW=5PI9BBTE116A/@&+O:S<X4A7WRaK\Z1PQ(]N(f\WGG\#_D@ZSb
a[M)J15VM&8JD_;1&gM7CM+^K^[f]@RY>+\0BJbW\.A@]3ESUY5a=,U+RM7Y2SLB
=,=X8+^OC<Y:?&,);I2-H6.&#?TSc1f&NRd?R(EB4KGcYU4I>P?7&5X/V:WE20]O
ERQXDH6+P4_S4[?#U#0=ZULf^>WKd+:OMWJ;.9fN]E)94B@Kg;?L8;a#_gI>7Qc<
GLg<LCE&9,26^gIMOKGb9U?:=H(,0ccM\Q]=dRH/WU(HP2@_PNUHBK>_8\RB]cQb
JIAb(<QW.[_&,=:8363N/AX4H=I3c[<X)0];Z&AI_<#D)@7=6Q),?A=XZ5;K+V98
gZ<#5T:Fg>6FTID#NgM]e[?JU&Q?@<VY@I;B81XVB4PaI@EC+^6RQMOfd422aN;H
W((0W-;.7^MP/&JV@I\0))5>S?DFdcUU4_R-gF=MO);[,YHbU<-G3?>AINUPQ/98
aQd1]:WQ+CF>=F?M#KIFZO9SF8fOBGN[CN+bC&MG38R</XK-Sa./]-a=_#V(-+D>T$
`endprotected

`else

 integer OI11IO001, O1IO11100;
 integer O1O00I001, IlOO01011, IIl1lll10;
 integer lO0IlIOl1, O1I1IO0IO, l1O0O110I, O0l1O10l0;
 integer OIOOl1I00, O0Olll0O0, l1IO10001;
 integer II010O0O1,  lI1O010l1, IOI001111;
 integer O0O1O11OO, O001O1Ol1, OO0O101O0, OlOOIO10I;
 integer lOlIIl001, I11000011, lOO0lO1O0, II1Il0l1l, l11O1O1II;
 integer Ill11O01O [0:(1<<chkbits)-1];
 integer O1111l11O [0:(1<<(chkbits-1))-1];
 reg  [chkbits-1:0] II0O00OIl;
 reg  [width-1:0]   IIO0O111I;
  reg [width-1:0] OO011110l [0:chkbits-1];
`endif

 wire [chkbits-1:0] OO01OO00I;
 reg  [width-1:0] O00ll11OO;
 reg  [chkbits-1:0] O000001OO;
 reg  IOO11O1I0, OI1l0OOOI;

  function [30:0] O1OO110OI;
  
    input [30:0] OO11O110l;
    input [30:0] O1IO11100;
    integer OI100OI00;
    begin
      
      if (OO11O110l) begin
        if (O1IO11100 < 1) OI100OI00 = 1;
        else if (O1IO11100 > 5) OI100OI00 = 1;
        else OI100OI00 = 0;
      end else begin
        if (O1IO11100 < 1) OI100OI00 = 5;
        else if (O1IO11100 < 3) OI100OI00 = 1;
        else OI100OI00 = 0;
      end

      O1OO110OI = OI100OI00[30:0];
    end
  endfunction


  function [30:0] O01I10010;
  
    input [30:0] I1011Ol00;
    
    integer O0O1O1101, lO1lOOlI0;
    begin
      
      lO1lOOlI0 = I1011Ol00;
      O0O1O1101 = 0;
      
      while (lO1lOOlI0 != 0) begin
        if (lO1lOOlI0 & 1)
          O0O1O1101 = O0O1O1101 + 1;
      
        lO1lOOlI0 = lO1lOOlI0 >> 1;
      end
      
      O01I10010 = O0O1O1101[30:0];
    end
  endfunction
  

`ifndef UPF_POWER_AWARE
  initial begin
    
    OI11IO001 = 1;
    O001O1Ol1 = 5;
    lOlIIl001 = OI11IO001 << chkbits;
    l1O0O110I = 2;
    lOO0lO1O0 = lOlIIl001 >> O001O1Ol1;
    O0Olll0O0 = l1O0O110I << 4;

    for (OO0O101O0=0 ; OO0O101O0 < lOlIIl001 ; OO0O101O0=OO0O101O0+1) begin
      Ill11O01O[OO0O101O0]=-1;
    end

    II1Il0l1l = lOO0lO1O0 * l1O0O110I;
    lO0IlIOl1 = 0;
    I11000011 = O001O1Ol1 + Ill11O01O[0];
    OIOOl1I00 = O0Olll0O0 + Ill11O01O[1];

    for (IOI001111=0 ; (IOI001111 < II1Il0l1l) && (lO0IlIOl1 < width) ; IOI001111=IOI001111+1) begin
      O1O00I001 = IOI001111 / l1O0O110I;

      if ((IOI001111 < 4) || ((IOI001111 > 8) && (IOI001111 >= (II1Il0l1l-(l1O0O110I*l1O0O110I)))))
        O1O00I001 = O1O00I001 ^ 1;

      if (^IOI001111 ^ 1)
        O1O00I001 = lOO0lO1O0-OI11IO001-O1O00I001;

      if (lOO0lO1O0 == OI11IO001)
        O1O00I001 = 0;

      O1I1IO0IO = 0;
      O0O1O11OO = O1O00I001 << O001O1Ol1;

      if (IOI001111 < lOO0lO1O0) begin
        II010O0O1 = 0;
        if (lOO0lO1O0 > OI11IO001)
          II010O0O1 = IOI001111 % 2;

          O0l1O10l0 = {1'b0, O1OO110OI(II010O0O1,0)};

        for (OO0O101O0=O0O1O11OO ; (OO0O101O0 < (O0O1O11OO+O0Olll0O0)) && (lO0IlIOl1 < width) ; OO0O101O0=OO0O101O0+1) begin
          lI1O010l1 = {1'b0, O01I10010(OO0O101O0)};
          if (lI1O010l1 % 2) begin
            if (O0l1O10l0 <= 0) begin
              if (lI1O010l1 > 1) begin
                Ill11O01O[OO0O101O0] = ((O1I1IO0IO < 2) && (II010O0O1 == 0))?
            			    lO0IlIOl1 ^ 1 : lO0IlIOl1;
                O1111l11O[ ((O1I1IO0IO < 2) && (II010O0O1 == 0))? lO0IlIOl1 ^ 1 : lO0IlIOl1 ] =
            			    OO0O101O0;
                lO0IlIOl1 = lO0IlIOl1 + 1;
              end

              O1I1IO0IO = O1I1IO0IO + 1;

              if (O1I1IO0IO < 8) begin
                O0l1O10l0 = {1'b0, O1OO110OI(II010O0O1,O1I1IO0IO)};

              end else begin
                OO0O101O0 = O0O1O11OO+O0Olll0O0;
              end
            end else begin

              O0l1O10l0 = O0l1O10l0 - 1;
            end
          end
        end

      end else begin
        for (OO0O101O0=O0O1O11OO+OIOOl1I00 ; (OO0O101O0 >= O0O1O11OO) && (lO0IlIOl1 < width) ; OO0O101O0=OO0O101O0-1) begin
          lI1O010l1 = {1'b0, O01I10010(OO0O101O0)};

          if (lI1O010l1 %2) begin
            if ((lI1O010l1>1) && (Ill11O01O[OO0O101O0] < 0)) begin
              Ill11O01O[OO0O101O0] = lO0IlIOl1;
              O1111l11O[lO0IlIOl1] = OO0O101O0;
              lO0IlIOl1 = lO0IlIOl1 + 1;
            end
          end
        end
      end
    end

    l1IO10001 = OI11IO001 - 1;

    for (OO0O101O0=0 ; OO0O101O0<chkbits ; OO0O101O0=OO0O101O0+1) begin
      IIO0O111I = {width{1'b0}};
      for (lO0IlIOl1=0 ; lO0IlIOl1 < width ; lO0IlIOl1=lO0IlIOl1+1) begin
        if (O1111l11O[lO0IlIOl1] & (1 << OO0O101O0)) begin
          IIO0O111I[lO0IlIOl1] = 1'b1;
        end
      end
      OO011110l[OO0O101O0] = IIO0O111I;
    end

    l11O1O1II = l1IO10001 - 1;

    for (OO0O101O0=0 ; OO0O101O0<chkbits ; OO0O101O0=OO0O101O0+1) begin
      Ill11O01O[OI11IO001<<OO0O101O0] = width+OO0O101O0;
    end

    OlOOIO10I = l1IO10001;
  end
`endif
  
  
  always @ (datain) begin : OI10l11ll_PROC
    
    for (O1IO11100=0 ; O1IO11100 < chkbits ; O1IO11100=O1IO11100+1) begin
      II0O00OIl[O1IO11100] = ^(datain & OO011110l[O1IO11100]) ^
				((O1IO11100<2)||(O1IO11100>3))? 1'b0 : 1'b1;
    end
  end // OI10l11ll_PROC
  
  assign OO01OO00I = II0O00OIl ^ chkin;

  always @ (OO01OO00I or gen) begin : l1Il10O1l_PROC
    if (gen != 1'b1) begin
      if ((^(OO01OO00I ^ OO01OO00I) !== 1'b0)) begin
        O000001OO = {chkbits{1'bx}};
        O00ll11OO = {width{1'bx}};
        IOO11O1I0 = 1'bx;
        OI1l0OOOI = 1'bx;
      end else begin
        O000001OO = {chkbits{1'b0}};
        O00ll11OO = {width{1'b0}};
        if (OO01OO00I === {chkbits{1'b0}}) begin
          IOO11O1I0 = 1'b0;
          OI1l0OOOI = 1'b0;
        end else if (Ill11O01O[OO01OO00I+OlOOIO10I] == l11O1O1II) begin
          IOO11O1I0 = 1'b1;
          OI1l0OOOI = 1'b1;
        end else begin
          IOO11O1I0 = 1'b1;
          OI1l0OOOI = 1'b0;
          if (Ill11O01O[OO01OO00I+OlOOIO10I] < width)
            O00ll11OO[Ill11O01O[OO01OO00I+OlOOIO10I]] = 1'b1;
          else
            O000001OO[Ill11O01O[OO01OO00I+OlOOIO10I]-width] = 1'b1;
        end
      end
    end
  end // l1Il10O1l_PROC

  assign err_detect = (gen === 1'b1)? 1'b0 : ((gen === 1'b0)? IOO11O1I0 : 1'bx);
  assign err_multpl = (gen === 1'b1)? 1'b0 : ((gen === 1'b0)? OI1l0OOOI : 1'bx);

  assign chkout = (gen === 1'b1)? II0O00OIl :
  		  ((gen ===1'b0) && (synd_sel == 1))? OO01OO00I :
		  ((gen === 1'b0) && (correct_n === 1'b1))? (chkin | (chkin ^ chkin)) :
		  ((gen === 1'b0) && (correct_n === 1'b0))? chkin ^ O000001OO :
		  {chkbits{1'bx}};

  assign dataout = ((gen === 1'b1) || (correct_n === 1'b1))? (datain | (datain ^ datain)) :
  		  ((gen ===1'b0) && (correct_n === 1'b0))? datain ^ O00ll11OO :
		  {width{1'bx}};
  
  
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
    
    if ( (width < 4) || (width > 8178) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter width (legal range: 4 to 8178)",
	width );
    end
    
    if ( (chkbits < 5) || (chkbits > 14) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter chkbits (legal range: 5 to 14)",
	chkbits );
    end
    
    if ( (synd_sel < 0) || (synd_sel > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter synd_sel (legal range: 0 to 1)",
	synd_sel );
    end
    
    if ( width > ((1<<(chkbits-1))-chkbits) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m : Invalid parameter combination (chkbits value too low for specified width)" );
    end
  
    if ( param_err_flg == 1) begin
      $display(
        "%m :\n  Simulation aborted due to invalid parameter value(s)");
      $finish;
    end

  end // parameter_check 

  
// synopsys translate_on
endmodule
