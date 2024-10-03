////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 1998  - 2020 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Rick Kelly               November 3, 1998
//
// VERSION:   Verilog Simulation Model for DW02_multp
//
// DesignWare_version: 81a71b68
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
//
// ABSTRACT:  Multiplier, partial products
//
//    **** >>>>  NOTE:	This model is architecturally different
//			from the 'wall' implementation of DW02_multp
//			but will generate exactly the same result
//			once the two partial product outputs are
//			added together
//
// MODIFIED:
//
//              Aamir Farooqui 7/11/02
//              Corrected parameter simplied sim model, checking, and X_processing 
//              Alex Tenca  6/3/2011
//              Introduced a new parameter (verif_en) that allows the use of random 
//              CS output values, instead of the fixed CS representation used in 
//              the original model. By "fixed" we mean: the CS output is always the
//              the same for the same input values. By using a randomization process, 
//              the CS output for a given input value will change with time. The CS
//              output takes one of the possible CS representations that correspond 
//              to the product of the input values. For example: 3*2=6 may generate
//              sometimes the output (0101,0001), sometimes (0110,0000), sometimes
//              (1100,1010), etc. These are all valid CS representations of 6.
//              Options for the CS output behavior are (based on verif_en parameter):
//              0 - old behavior (fixed CS representation)
//              1 - partially random CS output. MSB of out0 is always '0'
//                  This behavior is similar to the old behavior, in the sense that
//                  the MSB of the old behavior has a constant bit. It differs from
//                  the old behavior because the other bits are random. The patterns
//                  are such that allow simple sign extension.
//              2 - partially random CS output. MSB of either out0 or out1 always
//                  have a '0'. The patterns allow simple sign extension.
//              3 - fully random CS output
//              Alex Tenca  12/08/2016
//              Tones down the warning message for the verif_en parameter
//              by recommending other values only when verif_en is 0 or 1
//------------------------------------------------------------------------------


module DW02_multp( a, b, tc, out0, out1 );


// parameters
parameter integer a_width = 8;
parameter integer b_width = 8;
parameter integer out_width = 18;
parameter integer verif_en = 2;

// ports
input [a_width-1 : 0]	a;
input [b_width-1 : 0]	b;
input			tc;
output [out_width-1:0]	out0, out1;


//-----------------------------------------------------------------------------

  
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
    
    if (a_width < 1) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter a_width (lower bound: 1)",
	a_width );
    end
    
    if (b_width < 1) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter b_width (lower bound: 1)",
	b_width );
    end
    
    if (out_width < (a_width+b_width+2)) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter out_width (lower bound: (a_width+b_width+2))",
	out_width );
    end
    
    if ( (verif_en < 0) || (verif_en > 3) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter verif_en (legal range: 0 to 3)",
	verif_en );
    end
  
    if ( param_err_flg == 1) begin
      $display(
        "%m :\n  Simulation aborted due to invalid parameter value(s)");
      $finish;
    end

  end // parameter_check 



initial begin : verif_en_warning
  if (verif_en < 2) begin
`ifndef DW_SUPPRESS_WARN
          $display ("WARNING: %m:\n at time = %0t: DW02_multp simulation coverage for its Carry-Save output is not best when verif_en is less than 2!\n    The recommended value for verif_en is 2 or 3.\n    Value set on this instance is currently, %0d", $time, verif_en);
`endif
  end
end // verif_en_warning   


//-----------------------------------------------------------------------------
// synopsys translate_off

`protected
#VgR\bcBY=Y2eNLB1?H3Re>QU0QOG<2f-9ZV.U(QD7-d[D8e@3dE-)WJZ(.&V3+@
fXM\)<?3E/NZ9GVXUTY.M_,V;d^&)U/7Z;Vc=V=0B6R1-dcWB^GcL9B;bF6&&<(9
HgTQ^+QS^@]YfP9]HL+NQE;b-eH>gKKHg1:6?GFQ&KdcMH;^.cD:^Nb5C+WE/b\g
=S.VL)819#IfT.+_8g+LN7=VQ4AaI?F+d65WJ2+GNFg9,X[_Hg7dS\,<_V#3]@/^
[VCOF=[PgX^_9EVWLcE_HSIH:?[-,[67eC9V3Y@8_PET0@\d)LgfZ)5Y<E1.NU/2
39JCY>C0-QU0^Ge(QeL<X19gCQZ9]<e2CML#^aLe?F^KYOM\I\)c3&CE=)f6g;7O
UI<b0\U^XbGBHfW;MHZ:dJ;3O1:9;BT-L_e9=+]bg9RS.J92H[803^4e-Re?5;Lc
.2WIX2.=N^DAfKW?f84I7&_<B/TTET00:?AH64W/6#g;S4GfVDJ6M\T;UN3#I1AU
4B+#E&O[2S>&IQ=d^B:>@2f>XD_[OZ(8J,Qb&aD;A0f2,KdVY>\,W].WJ/R6QM<Z
KG\HSR8.+.^Ng.+-C0UK[<VI]/Q/C_^<(XDFce+:5#CNKK<Nb6adBVMB3TKJ>G\B
N]<Od;1M9JMDL6H.?@NLOG,dDRPSF6;>&g@V4>1CU?fd\L)3bSgJ8I]IMe2b^\#E
38Z2&VSReATdZN:S]W.B&:Z9P6YNdLQ8OM<bFPC7MYa:F_2WaTD/[ge1Q;+/eY5&
SP0ab9KWT[FQ;BFCd>#_,)K6)-&=NSS8;45.._9,O^eNLRa#d7X^>^[]S?G^8#[I
&J\LU@UDCcY\<C7-S#8&WG]AK+[c(a1,;,.FN5(PT2,1Tda42CDb-C_+UO(->OJ_
<32GN(S[Z]Ug.FLH^dCBa^f=4N:<+RXE?]45^?0<9/98Y#I>CG+9_B?J+WN0DW3g
:O^0cCPLH,-S.dNf]O482F/:VbWKA@6(.CMZ::6HR-[&cB&2,]DcWdN)fg34aY1\
8N[U.6Y_VT\QL^c3[gZR,.JHb8VfU81NI1&+UT4=^dK57gQ>,=EW6#0=XA)]OMG#
6LJF?SD>-W-<9=FSfKA;8W#<O&a)<WW[:9>(W^>BK=_8J03_9dPV3275N?7>+K3X
>,Q(]<eW]1>D6f>2\Q-?H.1cR)VV6^)])07?Z^T.-bZEFQfO>X[X@ELM7M\.UefO
UF#WQP]CA&1_<g=D)I(L)eCFg&URAK6Rb<D.IR]]_<X3DBA-cO3SGO0bE8^E=\(]
][ICRXV.g5^V6Q)CWR_9Zd(ZV9UXVa[RA\1K>:02a&R)A.GM,dB?7.V[f2<E/?^9
[418acU,&;dXH@Keg=T9_(Y_WO92IGFbX^[eG-dJ#Od.G(Pa\PNUW8:eX[1.F4dI
8PBM6]gM]bb9;MG]96D_H,+G;1Y5OdOHG(e_[[C5;;g@;)^=eN8/e>?Ab5^Z,@O9
>QLbI7T2IU0,-H8b4<0e70cJ;^cU_87362gUXda1J1S--Fd(bLI(EJceGBLbOLf&
NPME[NRe)=gc\E,SB_;U-E1N_-DQ_W8<0>[[f/L6b8B5IDeL<AFba.Fd]@M3C[>&
gg,c8<8]6+#>cM-W<)Dbe/TQYbLeDe?]fLVVeNMV9_:KD=7(9F<aHdb#gFD-FB:Q
XN9J\=(6-U.8L:ZD0\\g7AA)e<6\fQ^_aNMC6,V0C#4gVL9U?_Fa9c.MSVJ?GIZG
a/:&K:\\UcMC?[c?OP+O+5S,-I>[UIQ:0[EggCgJR9<Wa-OGA4/7LZ#\Y(1[,)1/
dXcO:RQ]L3J]fR)8BPgSE2?#ZDN?OUIS[#3.?I7B\dN-e6Q_8KZ3RdU8V8)I2\JS
YYV6Ibg,9]_9:_^COJ\V5b.B:ZKHIL83Q?2[Mb\PJ-f0I6)A^)1Z:41Z88BMV:@_
P0&AJG_?U2Y9F-g.P&A3TB50f&?f6U0BH)e3KV]@Nf3D0Oa(H&<1Gd3J6Z@O)65W
N4_D1;Zf;T.OC.\ZTLcF>HPL.CZ++O^1Ce?LPFRdd&@^eQKfQWF>DPCX)23I,OP/
HH8aUa4PePUg)9<Gd6;<f#UFVJG]Q+bAGOE8?M41J#P&YLO1O0S6Y.CHS3e?/0V\
Z^KZ\]@8DaO@()7AR<^[HZ7#bL;3HT>536D7T#C.\MeH<^:.W[\A23588R2^\DJ5
RdU?UcM)6bEb6d.X.TI<MWI&bDC+GQL+;B;1Q19e<HS9YSd;=VJ\K)Z+ac^/:9XT
FAV4cT6]@=Z@N[K0[9Z1d4e)Ie/&2Oc#Tb/Sb.+TXPKg80Fad0>WLd1O?K=PZKX]
O]<a)M#K0fDA;SU0&1()OZ_VEeIC2P\,^79+UfZgX<^4FcgPAcRE/cX+YWSNI.TG
2X&L00]Z[b=,2X^6b^g-<,@1gY13H4B=De7f6:YSPP-+g4W,E7&RERPfN.JONV<#
AcZaLBVKdAN=1<+U8.?.g;3_/eD.X2/04U@YBGPcS];O5UF^DAd>?EXNPJe-YGB\
Z0IH6R7<QTB:S8MPOYeb5YA/=M+bUg2,4SIZD2c?_g7#Y@UV[eBLB8<M2H/=50YK
^]+?T5_7KZVgNP1\,5-.IURP81]]^(08JgX+I/^TaO.F+X2e^I(IN@PM-R6,<?f[
_L_eS/<3+,WcIA<P958Z)=6EQe;B5U;7#CX^F/adR9b9/P:-RS_\H+QRL\97gGgJ
;aEWSaP06a]?WOM\?7F4;d3][4LEE90X;4;:,dGHOXGc)X_+RA@R],6gE?/:MY=c
.>=:2O&P>Od&?NH?cOT5e>cZ_M1S=F.H,,g[A#_Q[3f9ZJ]Q+<RXaR=0Ab=4fP-\
;1gH9g]g-.f:,0Na2HW&[8,BZ4EPF[^[GZPL6/5(1&MI5gU>2AdQKK^/JRJO=bN^
_+g/,BB7MXBIa1>aL,R0?JOYG,O)G_bZ4CH6b71]J,[/ERZ<7&SYG08<\>1I;#0d
QML_Ad6J5D,6E5[9Sc=#Vd9F3/NPfD0<EJ5ZK^3IG.=)<=OQ+X?>ET7e\=,A\ZX(
#D?7O[g\4CD<Y_(d^T^8P4&PA#5ac/.)R>](^Oee,FgQ&DV?He#3LF.(P\O^=.b,
>WH8ON^R]1Rg&=^540-R3H30(ZD2(V5/.g]XbaK.8I=_>\,YM<W.Lf8XL5:YAAHX
d&OPFcc3349aZ1OX5Ya8Y26=#J+[,N^1&-RQS^D#DRa-JI(;4K^^2^CX.;CeZLO=
[2H.7\0#=H&5JgfQ[F/YTZ>:SA=dAb[cSF-J)b.XRT@ZNE5,UXY1OBZN?\^59;C/
ST\NZQYgPHS__DA6FL<LA?gDM3c><1b?c<S81.,1OV8FU;;#^K1&U120=e4ACB<d
>>bGa<6TEDQeA>DT,S6U/f7Q:0X[a#?a3c.D[PU@Y.3&GGdPAV3YG,dZM1D@J6?<
<Q@-MGD6PGU/@M2N3[:1&RK:^cgT930fMRE+<E&1N?Wd+S_2(&Q02)=J7B8XCf&H
f2A//.<GZ]V@d,2XZH5,(]Z)e;_N[-;&,afBSC_\dYPQ0E)gO-C)ET=L<aGOaF=@
aaFE.IQQ4ZBF;,EGd7E[1&f.a_UfJ.>9CgT<,5]X=e_(].EV5V\\.F)Yf5;eRGK9
UecVY2(fgbL/#+,abb/VR.#4ZB+@J[.\AM,+G9,<[RQ1QdT5Z/29EDU-P72XJC0&
:]=6eOVP4CK-C(D]edO0M1@V<,O6DIe>7G+L<RD.Y)+X.A2<<SUOD8[O@=6SCS]P
aC--ba18XXA9]&VU1KY]C4C2eJD,3?,_S>0J1<Ab&[[+OdE\6I.;3cdJ<f3.Kd;f
fOI22BRZ=0=?Z<N77-EMV9Q)K=c)Td]\-2\+;NDLM2-6e?:J)9TF]JUH:C)?)LH?
b3bEW,NLEAGb0A2a/F6^PJEX1\]3LHG,4,dYaD505W2#Wg>V7XQ\VcZQ4&b5SO3c
X6;8(TZI-FKg)5([XaJDH+)Kf818QT?=NJ-:IE2<XJKDD9e9-VWZd;P2&=)dQC;8
7Za;fWSF(1,eMa\C4P>/;UR/T6I>c9d;7J&_QCVb#4WR3):V7>e&]Af)0-d30c+<
d@]7]&(5.TaX:#-R7aE&/8d?5JF_G7_EEH?SP1Z:,-HCC5?T&07bg&de48142Q&W
GZFTb@8N=X4@5\<#:5OX=KC_ZgcVQZEF//^O8[#/&(#+T]W#))^KgYJ?49C7C(?\
VE=[8(7--,]3KBg1H>KeL1c5U3<3:G;Rge+_35U^?HbDX7&W+(fcJ>?Zg1AS_RS.
A,NS+YZ&L8[ENS1dc#Ba(Z?56eX)DZ##N\gL0dV4dKb,\#E;+R<XX8^JH\+>=4X#
Qa/3<RCcQ(/:]\A=eZ[Y)3:SdK-YS\5>-^ZK3O3aM8ab.HQD#N?<V[80<K67XC0N
9-dcWW)>YFb/DV-FR+LKHVQ[Qg)X/1X7091bW\Ce=ga;_H2&:&Xe6QX9GIMABD8Y
<O2+d@3&S-@#1X^aT8A2]CF2.&9,_Q@&8VA1__@(#K40LA]GPD^P]\SG\&+J6EL=
:d84c<+3AL<@GBEa;V#=ROEe(7@4EYd=679Zgag)+NP:=Y;2:IM.UE7IHH:DZ+\?
BYCZ3RM7PfJ-F95[]G(O@4#g<..f7aD(#SUW:<LdfVQ(&GT_4SbF9)dcNVdg;d&;
Q5D+/]NcQ)gAPHeVAKT8BX@9+GX<N,G\-X9O_E;,f8N(d++4?3XT)^=fIcV-.74@
_<G+Dc4K\0(;--W]JAB&YMD<A<f,0TJOQHTGY&0eac83T0,<0\BFZ7_Q]?;STeVB
8NPZc#gIU?ad]G38F:g\4HY+3_NbP+JLe\PII7V@SCZ6Y[7)QfFH@,.1<G&:MF0]
3;-]3=SV6483_>[@3E9GO\LEY1g8S\g7996Y<=.(0:D..^K]e_Y&K(3\gIIZPO<9
fM[R<Y1?F5Q&OQGC@2CYP-8#CgEI6I65K?G,6\:J&F.3<)2SXY,dYYf]^X#=@.D:
/Cb.5-?g,&Y#([6e0JY@)b>\Y[D#(Ie8Q:?VgJ)13(28bJ+c0dM.a;e&8[BGC3fE
BN,4?T5[(]e8WZbJG41dX]<6RB2Z/?fZT.(f5.E8gZ\M4ec5HK@246WeDX.\9eJ-
[-98eYSYB8HOA1UI(C(C)/fDf=<U)9;L)F+bOZ[&^N@?B/O4@4NEdPQ8L(AC[d@\
ga)5GR[Z9OZ8Mc.[;LNVNg?TFc1gH[BZ\74:EN#PUa<=/8=G7DYK#gFDS=DAKaP7
C2O2TP3C/^:@FOeVK&OIf8f0P7&U_PcS1SaQVP-d_:J,^_QR&/:ESf.UBAf(ODc&
>Kb0Y81CPHE8TY05VWZ@J6#bc2,A-C8]\;MRJ7@a8a?L(&RG94\B2\\=<cHU)M^I
>:EM<OSYHZSZ#-dRHAIHS6_Z7@_,>D0dD8^SVfE]G1DU\,FI?K>^6\01Og]+:Q__
&=\@^9K8,?QWH5S<3K@=0HG4BW2LUENKW\eJ/Ff+PX_cbRO0@:^3:<47\d^#CS8=
ES>)/J]+DV6dbP]A0dP[5:(M(+TLg0DX_AfD,13QOUVTJDIU]O6f/e2)1U#KfeTe
2[KK44@=PH6XIH33c_).#-N.:fL_DK9OebH#\6fU=5N2+#1W6e(H:c=8D).@WeAU
ETV,I1T,>5LcX\,>R?P^/FE&)CJaEKRc8Ic6E,[8JULf^7V@@25+;57Od4:&XSU@
Q\J6PB(7(97KY^(84_CAFQPYM1:d[)_UB-3gGNW906C=U6#SH^BA-0XE85+fZBQ9
/Ma1fR\T2E_/c6Z)/_-/=GZVJcK6=P@],-3AX(BHU2#=231HR#?O:N24\:-Sg&.4
W=.f;2LGL2-I\F6N=3<1OATKc_^I-?D3Rd&:L1_C:A<9R]=Of;Uc0C&Q_[(G6U/5
(&,RNe5?G.:(OE2YEI-.f,L[X4#dYV?Vc9NO+Rf>S<>fWaU:>4_Td<fX^A><F#E+
/IT/7C,,E=K]VAcH.S-8>OCWA<QSK(\G#_N:E4d4U=)-W&85IZ?.D/fM7KA>170V
G7<I[F[,<CWf3V4JI<[&G?^O:(_acTA^Ye?0S]LaWC-R67.21U5J5R[PA/<QX_.I
]FUF&(8LbGH>UD((&gJ#585G@ON3A_N+LIE-:0:aDEWFOGZ3\6>F_MFJE,P#IK9a
<+[KR^]2X(DGDW/ZYZQ/D7/ZD9DS9ZP10/V^L7E9YQ>/^d,C)GYMH1c;C;,c=U@I
ASK_)U#677EC&AY(,aGICDe?^DaEYGV-&Lef#/F:f(IDg)fHabGT_;c\Te5D-P;M
W=MX[]f]H1.42./T\cC2L24PPA-A4_T;RF3LaUg^:A/&gFd++\AWB?F&:EbD:H4W
-[BCNe-_@/LDP/;cO#3-[46;[?dC;=T77W01fY\:2TaYJc)6EDb/(T#_RM;8Q<8V
7eBCH;@c>[gS(@#Z/E>8G2^[=@0TZca7N5.Pc\_K6X3L+<3gYK&(3A&eP#0X42L]
4IGU@S<OQQ/UR.A(gJKR#X<fE]P7[O+C/0C\NJS2.@gE[A_3WSG6Y/V93IFZfYc0
0[@;0,&F3FXcf/aG?A/Uea:&#J#_c]&[_[bgC.29+E6GMdF-d#[RC/7ceI?Q;>0E
H2]DS._OVN-E;KFeN=+0Y\a33g&5Wc?+L;8g6VHAg)R1MQ3XG6J0<8a@feMP4GGd
b&;6V74:^1E--88E9:gRd):>TAFG,;FP2c[_>LP;N]6B=.]^&dN:97)>AW#R+[3.
;@C::FbPPfGAJII2<WOD5+@@cFD>Q7fg@gHB/.^64;-FG;BT31OL+-#c5gc..BW1
eU^D;H-_bAaC-AWX&CA<I[Gg:KD@-U1^<F6c<4c,-&(4cZDP737988EGH(_b:fO#
U/\N8)H@+6bZcTGPEE0?:65Y=IA2b-1SW,?>e3-YK>(D,^@XOZ/bM9;OM8JI8DQJ
YP915?a>IJSVBY^+U@,[7#LaL9QD-UM?6,24I=e=D>O)LQ<NOOa1E_]5._aHOQI.
(?(@[@D^-RHIHY,\c>^7-D-b4U<?(bY3++g537-J)>WM@F>A^,ES3XZO?RdLW<6L
M8d:22C+Ha;V9N8g([HI0e0HB&I>?6.YG@?IL>)MWARS=13GfD78gb;MTU+=_48F
34<&D4:Mc8R>H)T)SKJ8)QA;]HbL3A>3fg.\1FKaKA@..3Of5PS[+(Y&K^R]A4DU
AcD#QHS\X-aWC]cJ?1Gg2U@63GU/:>XS/06^c]>4@fd(#Vb)WNA3&_:-c,c=Y\MW
/HQDTBII&(<a[B5TPdNQ3dCKUa)cH>8YZ,?X@,L/5=U;0[+2:d\M.DZ5D2YJ/C>:
gO60DBI<\WLc;DMM?Cb=/(NA.?/U+U?gO<&gA2fDIZ<MWXA##_<VZHF6JL99Pc0\
FQKWTI/_3O./X&_T>VQ6H4RU3:NAL=f>X41L&/S4=42d\\9FR9Tg6_Y335dI^=R4
5-a&VDFA58gR)A3C;dC>Aa-4UOZ4^Z8^0R0_]QP\:Xa&X\1F(/b<^TR]ZUA-<9g3
fKI=RTYPe<3OI^T\,/O@+DB]bZ10:WGYM>3bTK0C<&@NO\[#a&4/@Q)Mb:#8MZQ2
3@)HU^F^Z<>HW=VSM[ST2K:[WgRY)N\c3Mb=;]:aL-Qe2M6N9?bL@7GR+=&-_S5H
7VP-O+J0S.g;\N@1dFC+RH?I/6G^:QW2-S:gP@S8]G,-XgWT&^Me;&A7,g50MGR<
_&5@94+\_\NJT#I#??c\gK0(.dB^[gF805]ZZKb0V7VL#@RN?8aSP6b?7SJ,:#3G
2D3?#SGRSNC7=6-F&7KF_-BR3>0c-KUIggV<?>V)Q0#1L)5LK>[>\HgK63&6YE,6
[>O[5YOY-)9F65]@a\P\FJB\^J0)\[XfMC>(W4M83CY\PY6TX/0FC:<YZ>)#XA8f
6:@;?fI^K5Q+,9L.c/S8eMSeZX,QEd@5CC#[14,?:=[,):;K3dYgg>@@IXAVV8B,
Y;^/e-6f?IEUDePF.5A,5+,QdYc/CS<]R4.CFHHeVBcd.Da5VW<YB/Z#15gGCg@U
06Z2#EJ1/5W[\Ia@a.VTZZVT::aN0/CIV?I[J@cW0D[?A)#\&P;X:Y_1NLdJ&^1G
.OeWZQaQG#K3M(<3ZJPNa26UH^g2^>Pb(3J83a>GMJHWMeQ\,F98S3DKMPg&)9^d
=6.Qe;38>N5)STG_,]=9AaEe=.QFgf#\^BILV6DT@Y?N2(41ag\0[Z#?5g/=9^L1
];V54U-<.7R1DLXb^D,2PW7>IT0e(gQ<X:2EC:e)()9HPCR501c&^f3AF5J5NBF5
.5e?>J1B\1[LgND3OSaLb][IJ@FgX:K.)7BY4;8J@,M[cR2M,O8@b0L;9Y:#](VA
<6)H.Ha;/2SHCQV&;[KC0;BTWU);SYFU^.J93]<NM+@S_A[^/Z+3d5>VgTS]L\4^
L>+=E6JdeZZ]SM-Ib49H0(\Kc6aL9<b9P=#J(SB^<A@\)ZabPdA^2GX;&ePI5IU#
O=?c9RIQ;SFWLTJOb@HZQYO<]D>VI^0[&LRI^QM+N^12H\a5H<N96UY&:#Y.S)R8
;:_G\;@2^GLU\(MJWVB)/Z9VUH1_RAH#c61_g3-Q32+:VAX6eZ\VGWU0QKfM725:
?A?WXWBbTUdZD7a5^92/J4<KPHe+.:U1[QTE>L-e]&>/2Z-fAH<#;3QaB\R-?Y]H
7c9NEeL.83b4?&SbaR0,J:<K1$
`endprotected


// synopsys translate_on

endmodule
