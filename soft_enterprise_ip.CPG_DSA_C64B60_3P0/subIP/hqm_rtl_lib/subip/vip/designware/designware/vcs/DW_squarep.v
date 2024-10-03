////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 1999 - 2020 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Rick Kelly        5/17/99
//
// VERSION:   Verilog Simulation Architecture
//
// DesignWare_version: 4fa78b50
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------
//
// ABSTRACT:  Integer Squarer, parital products
//
//    **** >>>>  NOTE:	This model is architecturally different
//			from the 'wall' implementation of DW_squarep
//			but will generate exactly the same result
//			once the two partial product outputs are
//			added together
//
// MODIFIED:
//              RPH         10/16/2002
//              Added parameter Chceking and added DC directives
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
//                  are such that allow simple sign extension when tc=1
//              2 - partially random CS output. MSB of either out0 or out1 always
//                  have a '0'. The patterns allow simple sign extension when tc=1.
//              3 - fully random CS output
//              Alex Tenca  12/08/2016
//              Tones down the warning message for the verif_en parameter
//              by recommending other values only when verif_en is 0 or 1
//------------------------------------------------------------------------------
//
module DW_squarep(a, tc, out0, out1);

   parameter integer width = 8;
   parameter integer verif_en = 2;

   input [width-1 : 0] a;
   input 	       tc;
   output [2*width-1 : 0] out0, out1;
  // synopsys translate_off
   

   wire  signed [width : 0] a_signed;
   wire  signed [(2*width)-1:0] square;
   wire  signed [(2*width)+1:0] square_ext;
   wire  [(2*width)-1:0]   out0_rnd_cs_l1, out1_rnd_cs_l1;
   wire  [(2*width)-1:0]   out0_rnd_cs_l2, out1_rnd_cs_l2;
   wire  [(2*width)-1:0]   out0_rnd_cs_full, out1_rnd_cs_full;
   wire  [(2*width)-1:0]   out_fixed_cs,out_rnd_cs_l1,out_rnd_cs_l2,out_rnd_cs_full;
   wire                    special_msb_pattern;


  //-------------------------------------------------------------------------
  // Parameter legality check
  //-------------------------------------------------------------------------

   
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
     
    if (width < 1) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter width (lower bound: 1)",
	width );
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
     if (verif_en < 2)
`ifndef DW_SUPPRESS_WARN
          $display ("WARNING: %m:\n at time = %0t: DW_squarep simulation coverage for its Carry-Save output is not best when verif_en is less than 2!\n    The recommended value for verif_en is 2 or 3.\n    Value set on this instance is currently, %0d", $time, verif_en);
`endif
   end // verif_en_warning

  //-----------------------------------------------------------------------------

`protected
8T@]<>.gaN]^FAB@3dPX,EeSN=-cc+)UUVgTO5J/7UX5=(&Kc)CS1)e(GI#O[8>L
786Q.E^A,fY>UU@F2##2VgfbWbX<VfW54FUXA1aBbJS3?\&R2/?c].?>YPH25M4R
S23DJb?V,;?]<@R:fSOZS??d7H0dT8D7DLDe3cW(ae3&&BCY@OWV8V7/c9eAKQf/
(GgaNa:c(&a-^8&5:1N,>GIadQN):AC.QMW,W@-IG&S#K->f+/:af\WR00bODcC7
4g2QeLIgPS1Xa)XRe1dZP0N5\[;E/(cGKeSbJQ6XXKB]2Y#8H@7BX80c#HWX:=M_
Pe5OM-a]Y9/@)]XNIG^QF?f73^gV:N:6><(MVTb(A>@XWf=OQX)1JH:5IeA[XH9R
AS.8.N/_B2Q;/=0D=d?2??+)7RSXB7KPaZ\E_B3&7;O7XX5:<D1:/[=@W&S6;UgT
9(,8GBX>7[)U&VY]#XF<CgFQfBNGU/VDf\^53Ng^/#7@T=4-_1#FERX]<dTXY3b?
)K1=C6H;>:[?S2)J^dE:N#..OBW;QIg?7JDN[3JFSDaHYX.QJ<R00N7@S94PaMMZ
3KP7O_[F+9-IOa]<9>TSAWK12DbS^)T1L_,I:K]4OA7KD.a4MfYL+=IRO.O:WN^S
0,-H&[DJcZQgE5cOF(c]1^L>D560K9:T.F]1CB14c^)(Y;Y3&,aT=Q@_VbA,^:5e
X+#X^T)G^;gXdg@<5d9AMC2YGQb;,=6d>@#IS&?1N8<Na#YeKA\8@:R#eRN6eCOZ
K/GX.Z)_[bbV?E#Q5(2<db#eXfW&aLP;FS[S?8U5T,Zd(HG:W,eHZ6\:MKU77F/D
V+,;TO+Q7OAQ__8LX:99C<L83JU^_+eSG45HG&I5:));fE3-T<GJBXHCc.BV0Ug:
2/JXc8_5Ecdd1;QIF:<27-Yg1gLTR3.Q2&L1PY?L6@f]VEJe5#BSR,X5W2T8/Q-P
ILOLB]-4Ag.#S>F2](G87XC#KKR4C#NA,H=2P1f6:_\(9MG3X#.-59S[TG(Z_F.>
_H[Z5g(B[]6RV7GJFQYM5Af[NA<6=+7XL>6cJ(bUd[Ja0WZae][U+T)Wc:6@IND2
f]1A2GXMD;^a9[e4S:7b08LXJFLXgC8g2=W@.-OH\Ca)Ig>9=KC)\0VaI[<a9f^S
D^UX>YA<QU7[9)41T;]PKRR6J;8+,=Q&7;-?SAe0PXI\BG[a\0dN9I:;:^^=\cU?
QZ.ULMcQF#9C===2XG5C84fd:P<.K;O(9W&</D4G)e>-[2T5UOf0V0M<OU/B63-e
A)MC1;)^MFVYA/BMDR_)D.e=1)72]Z;PMQQR1]B<;Z]8?XUb_gPK;HKLP22@>###
0f:(;W4A3M6YN6)ac<IGd#N0<@+(a&2#8Q+-2EK)d:7ZfL\#4=c9Dc=G6U,-@79;
VM<Z6L&<d3JM4.H),2a7XA>VW9Sg1Kc;aaG6^Z/&b<T@\EQZ>bVc[EZY-2/<1Se7
S;D2d?CIT=-:43bD?5H8GM;53/5&BFc&NF2#J\@C9WUe1ZG\72Ff@D]-,BLODZ)3
/Ia?Z#MH5UFD([[#.aeKbaU9^Hg5^=f3N9K]?>M-U&4KE2=:2F0IV#]>ZL9/:eZ)
V<K:aW&Q#HVUeZ+ZZ\]BcXM14U[-&Q[[19aG7^R26V^:E1L2bgSgDD+^DH>30U;/
Y9=cgA)7(?K>NK;/1>7gWH,KH39/3ZH)_-J=BK@+T?V[@=9V@&8I-0_N,2;HF_,4
PeKdQ8N>[=6J(L-T[8Y2J@Q4_W-7I1D0OA6OS&J3_K:MOgD<&6BHC4dW2VM._/aV
2@(L+QZ9eEK2W3gK&7(;]:HL&KNWKQJQ=QP:Uf^+IUf3Q\6fOaVG07)@2++J@<72
+W]\gR)3fQCZ0)LF]g41+.e7PH@XZD#dZgTME^C+29TJHJJR,[C]3]2L7[0B6;-W
Vd\,HEW6O\J.&BORTJSL-bR[e&==3AG.JP?dHX89cR?RZWK_3TK15#HEHQJO7##Y
Y(Y8-[[,RX-XZaW,F34[0GI6/Z8>2eHG8YS\XS/EdBJL89ee#gL0UA_YQK\_T:M5
;U.]ZV8La@LVZVK,\O.ZH.8/QT=&(><.1;^c5Q_4>a\C(JSMA:gKJA,VR&<T#P+@
5^1O>IWHI>V]3:HAM7Lg(/4#:[b)c-Oc8X#I?+,g-PU>d1CT[Y1Z6)>_6PUSUXZd
IMIOSW<48T;3/()CMVF\OY]]TNL:[2MZU:fV:=fd<g55>a8UR)HT1SZ)I[]T&RJI
H;6@bUCdgF.L7#IbEZ@gfPLgVAfV(^2P9J;b4,FHFLVV;f@d@@QVc?#>?;6USINY
b7:&7-f_[+\Z5,Fb6\=::#6+I:3c/37-U(4D>cQ;Q?8N0[f=SZ&_)-KS^Ug&D[a_
9aTJ(GK7G+MD76fEW:1CFSH5735[+/@17Rc<@63)M1-b[Na:6Rg:/cM_SNa@aTY0
NV.R>RgdPC@NJ5H0#DRN5,H/cGIce\OG:E/#+1U0KP9IMSD,<NaI?Ae80?F2Rfd/
@e\D5[0>CG_30OC^8Q0)_]E6/V?.5T1@_A#3?MFP0T_7652G?D\F@?]8P]M.7Y,a
Q<^\?V[d/-gNO9c6,-=TGZ=BWX?SGM#R&f1J]E(X#ZX=9#Cff-Q#g;ZC\,QGEU9G
FSGO]g2aX];;d08Gg]OE3eKFH7Mg>M/ISD5/[LD3a#DCZLZXP=0_)3HTPC)BVFSQ
GQ+E@,A>=H[9(]fR5KA<WF1#?-.Db/eaH)D8015=_CK)f.:cfe4#J08\H[0&5Z\a
#Zd.3)Q&3P=_CHfV.EddCYb#+0>a\?C6VEbc:5\MY<Of<f<IL[E]fAdE=W.Rdd3H
EfU?IK,TCNdLN,fN><[?E<eAZf(&2PJ@+Kf8721TK^7,BM60R149KYbC4S5C9dY+
QI[/c8=/SDgdM[P+:83-If-F:::+V/\]e(b?_:NNScN@<ROfJKgF&__B;T6bf=6;
D/W5W>)SDdE/^>,2b#TPaOXcD-8-5f3D1^1dLA8=4C#^&3K@)dabL[(D?c34S(4H
dEK>HA<.A[#-Ye,#8Z:)T0XZbC1T;cN(0E@^[,-9LbH)N>)\^88+(Ydd#1HBVWJS
E_G_NVaY+JL&HRMDIFL/a+YM0Q=@e4P4[2NSGH)<]G[W\;@fK(((QM]@be@<c2Z0
0GU9ICee+>4cMPVCC6R<9M]IZLZ\HPdW/\XNHNCd<&I-d&Xe_<O\IX5]>QHEKgP5
;Kd-7N@DZfE-5/fAR6gXW0>C6YOEB8+I]Q1f<N:RN;PRR<>S?&X5/55f2^>A/DK@
@(7WVES_d\Xf3]>RV4Wbb1[X93=?ES>1))_6&]MCXH3fQXF5D5<d=>M^Q8YH^Q^F
(L:F;\/XBEN(afX/M<N05^6URF9b7-FK6Rf\aJF\6/-QBWAID7b71\bXP6&c9L&)
E\5FHYf])VYGc&#MPaM_O97d2@#_IYHA<Wg1O]S;KaCRSU]+0)U,#.9;cQcLR)W@
8R^g711eI&f\#7=_AP\I/ZS(H50A=eF9.?aA\H?22#3abO1]=4[79UZWc#YSNN6F
08eS./@^)\O538E8bR?c\(221Y>(9\K-e^H@AUgb2<6_,caeQVK_9Y3RN0Dde_JS
5/ZG8/O/6B&C\6VWDBCHcX]+dcL,AZXH];V_N;d.2GFdJ+M&&UZeEJYf@c-I,==4
CfJQ]cfC.URSH])/4^f(K-UAFSLOegE,^#XfaPg)eH65+=L[KDRI05(+baC+?QGc
;0A63?UPT]a;:U)dHcf.dKMMa\(aH5[ZW5N7-,@R0bD)X3-C?<aH</P<A-3/P>dB
cI&V+ae2+6/WcGXV-,Cd+aLI]F@\EL\QLTDc0RR,B&T1I]@?\D.EeH5Z-#MaHTC2
^A(3Z#QD5U[PL43]X,JLJ1cMKS&2/<d@N=R33>#B]S=d<VO+LFD=38U\bVJ85W#S
G85F;8BDb@=L>\N)EKIAfHca5c=^c-[V>Y?f7]E(P?DVBL&0+3bP39b=?9#MJEeY
M8cW4@<.F6#B;OK)S-3BARc;^\]2?aWAK7bf&XA<0C1W7PZK_(CWa2f^Pf1D^#0_
WfDWA[FVNO=V42BPUM.A,GZ/TO@VO<RadY@,fN]7\fCAKJ,7V1E?1aAC(>2&@7N1
;BXO+J?;]YF=eZZ^1Y(:dT^d<BUKZfVB^/7Yb#&Qg(C_1Ff_+F>bQU6L)f3B&],1
^=LEK7)25LGR,H+00Q:+WAX+?9ELFdP>KQY@&/e1?Q:@]>#.E,dG)]FaS3?O9YB-
KaY6OL.G;^(R-1/;;_f4Ga,ScC[42aFR-b(&d\KN48LN[S81=f<54ZNDD<FF>V60
],?&V9A7O?7@L@DMG)b_cZHDb]4;RHO[DdE-])V<_VBgJYP(O+gZQFSQV\2&KK0b
CRY,37Sd8\5AH6TXgfc1]#-;2L9]HAHUA@W-@@VLEC65)9WDQ1GSJXHP<Q_PP.Bb
W#_6KX:IYSLEbaPcZ3:5BPBaNU>OU3_-YGc4e04P940IH5B5Z]>I+VC0U]MLJcP?
R4IY+>,dPJJdZ&a.T7ZY14H.3J-aZL@e<XdL^+;246OeX\HRgP4.G>W5N<S1AX.T
)RQ.1AXF;/><U)ESI=O7L)FH:L]DXEf#60MX106O02FCP:8c/9\G;>B[9cZ_S(UQ
cCf1;b5;@K4U@E=52]?0)5]S3aJ4ARRUUBX]#,QW2d4.=c#@5)f4;I9[c5F=GR9X
U5TCN&E;TDA3-L;^W+/@-aWb<NfB](S[3,H8\KaN@&<VL4[,;Y4U>RbBQ[1b8\1N
]LNI15[0cWe&eQV7>9R(9_[6]Ae91C<a)[PHfYZb,AC6H#<5KQ9^W(93c6gP;@F@
Y_-/Yb3QfaEQc:PN5]PU?:7PR^722(TeQVWU@Bf,6/>dB@0S)eTL;EW#OVbK@c8@
WO@B<#4K:0b:aY;Y\d\P]9B>BFS5W>77(-PRU7#OCe#92([VdH/fFQb^O#/-KBM8
aYD&52X3g;7J:dNW46HA;\S.U:Tf0>HgNHI1+0,@ZTF-#)EN:-ccf:UNM[aFf3ET
NAN8B_9.U/d[/6S(#a(;UbF9g0f?U2e5/=+f2UJTgQ#N8.K(ABYa9T\5<>C-4LBL
C)4(H@F=>#(C)1]^<[&RedRWP^;IUa_1M,MYT0J;?72f<FNcJcLF]a#2LFKJ7M#L
Y^1R]e\L94IR/O5]R5AVBP50HJXfAEAB,+Vd8-a-=?U@:RU?c(g-OPb3^3AB2)+(
SU1G5Lf/RZ;]<7<:B2YX>LZCdVZ),@AG)&,WeV8+1c0QDUTF@>8I0R99:[7[fF2N
RQ[\26S^fe)&a0ORdP0,5\J[VUOH6PATMfP.\7X68]IY-=N+6^LO\)?fRSOc(?HF
.+[SHNQ;J_a(8W#90=;C]?JZXFe:VDA=_3CV<?:dHf17APE-e?1P:@RR44;g]8eX
#T#&,[]=+^(g4M]UYPb]ID-1VTBe\S=KD<J)C/7.2/(?/C;T>.\WfJ[,NJSMG20-
b&TVI/1G#bC;/e=RdF>5:a--U<JG#INHcR=eK=eJ\Yb9P\V3[#BVMbR)K2.HC9U9
BH0Ke.-b:Q/+MR1>dS2,@83]^P57GJ6bE>.4<DaYQf?D97ffH9L0.3]B7<LTHW>Y
Y(4-X^=4KK_^@SU/(V0fgP,fLJU/U<EY:ZV-TgCUHGS:FB(:RPd7/_D1E7],PX94
7LSZ?.dEOJ(ORJ2^3dE)b7QAg4.fO6?P&RW=/Fac]3:[a&=cZQSd:7B4e[#.0#;_
CKH,>&6dI_8?Z90/\Q_GQbg#,H:S/ZT2I2:(/Kd63Q:H9);)Af7SOg8C@0I&0Y^(
[JF08CT8RR#J3G(\8[+T@FCfVaZ7[QT2d4WX5[^6XJ/OP^0#e4K/b9]a#\7?/W6J
Og8?=[P:Bd?0^ZcUf.&:\))<KL@MZOP98fBGR)M?HSa#=3NEM.OIT.P>PL2EXCfQ
W]EZ9H]LK/.IdeK4fKJ1[WEM,aIe>+gPQGI,46:gbII#8YaKZM8f0Ua/a7O<L#^-
bRFA:MALbf0UBV)/EY;..b8,S0RML:d#cIgg.S,-#X_H,@;?/CD5L<eIR<cV5N]G
,N0/9(QA63cf-W_6J,3dV>R371K9Fb/D9ZH;F9,B+T,9.Y.@f8IV6EVQSAQf9M1U
F/V8\[Lb&;0C>NG)NfDEBDVZX9B0=)KI<UKX2@VcP(7K^/+HZ4)@X+6)ASHbOU#L
#f:.2(7E;\4.20S.FZ.7_+@_82./CJ)QO?2-3+?0THgaLeYKE8](X3BPK^3[e2F?
65;>]E8g(cY5geIdEcDA;JLSTFL1T.aX5C-MU+.c-I.bBGFIR8(]0KQcRGc]HB-I
g9:HgLX--0X^._SF5DO-&^T3:C^.f:3b5,Qc]AI80eGfBH8a,OQ)J?NQT9H[J1#^
#0CEf2O<0g&4.GE/8eb_W;_e0a2S;bG_TC+>c//6=e(.aJ]SD.(W7b9&D4YVd&DB
2I;Sd1.BUZFf,DQ,P,WZO/<,M3B\7]9(\Abb?c4FT<S,)250E\GIUQ_R/_XR+0a@
)2,,E+64[S@A#(#Z/=1)-P31e<T@^=.e@3,:EWL8?YYgIKV4]UeUIK<fNbPgXdg)
M2[a@D,E.9F-/1D@@TMfD_60Z-25K+GJ#a.DNJ=6NVZ,K/c:W^,<0aLQHT75Wa+c
EE(=SMaQH-?G8/Yeg2E_=cSN(Z<YHbf;BLY2]K7GO+3^IAHTFYaMH4MY_ffGKQKQ
YEe5B2ML?WQ3f2MFK=G7MV=#cJSH8VXP^c-CWgc/::f4f?9:\@>BDPO)J]@?Qc/O
;C4>.C8=S[Y@.e?<\<fdSdZQZVT0/C6Id6,U+R_g]Ld5Y=[f1JT=H&B;83eJ@TUS
db7RHJ1L3I:>CIVEG=(.PgG7+S/Q03J[4WN9RK5&d:D;;_C_W9+X@SE[-f<AA?>a
5F1:E5R4#MD0B2&TMbBOILY#E=HV)E]GC;^Z625-RPMM&G.aX2^7JT_eg6:]D@K6
DDW80L02ANH=e.Df66PeE,_/TKfLA];YGS)f/g(;2MAS]B\/JcFEd5cR-:YG9C=N
VZX]dWg^SdJ.]URIdc:PBD8IR;D4=./@+a6M4B4YZ,YN>#3_),Ua+)eCM7@4?XWR
5QSCN[]O/e#8T>SX13D<LFgAO5)V3+\JV7A@U@S8BZ]5b[-QQ+ZF6G.KLW[0W;e.
^SPG[K-gY/]M3Ba_>8g[3B/G_KWb3)PZ-E9T\;HNDDCKA?1;?H&VNdaNf8\YNT;M
:4ZBDV8YO3H[O/?[Nd=K[\QOW;X0E(ZGU5J_;;6MG\(^I0bE6EU>@7>C4JQN=aFT
XBG6.UCZAX3P>04:&BA6DXPYHf3.D)de-CW&O;-XR=_.24-7LI,NA)BKS/D&)5:_
2f-]0bfbM5,R#+6eA@Be;I1_M=HX,D#H09?KK4;cK]aH+3SAc(Q_T/@8(QMPQY+_
J(>b08U6AEdG/A8?\9O@cOG11],1X2+;.ea1WLeaI#AF2K]3cT.bRM=Ya6[:^>0I
D4N?D4&/;IO9D3K]^dAc??^;WA;L^6G;&&=H1R@g3Ya,DgaW/2-b(7Z2E+;XN7(?
_E9CG>]eTTVMQNQc;U(a)<4[8Q^#61H3Z\/3UETU:]/40CQE#NX.(#9(c,-/BbeW
g^b+@_)UY:RUIEAPTZdW7E&6?<[g/CL<KbH6HZ.6C20U)a3:1#9QUHL0<KA):^]/
6CdfagBf;D<I@fW5GA6?FI/a^/I:0MV,\:1I-[-W,77:4/]5</QM5(YK[Y9gCC23
)?NB)](+Xa6AYg)8)#8Mf;f=DA[3P/JC=H1K\YbF4XV,S]52T+XcFWM/&7?VeA,;
N^X0CcQbHX7[]X-LfEVB_>>VS+=\0;-:AMDTHTX@:WII:Q0XVH-[G?>XL_VU?d42
CI6RNO/.]QS#]0g&VAF4^1ERb2[W5[c)LC<Ec37;KBMaBHgYG4^;QZ+EJ6ZA6[_C
=e)O&C<4;\4^#YaCA/V(7c@01cYO))18;Z)ZHV]LF<?KCFEMF7eOfZ+W?Ta?CML8
#<R-0;WcHG,/^&dS8e&DKe6N+\TaDIB4ZVae:3HZ#0@-f;R2T2S&3_>9>aWO9@gF
\NN>2(d4g2bS.4[#<S)6>5XO>@T<T1E#@a;Oc=,<25F:2N^;_Od:&-g8XOT\\dGC
\ZB8&-6>;]RBMWf5CR1H]be:.:Fc?6U]\]O3<9bb(QB>(V-XLTDFP.9ATI[fBK5,
U;_aD\e),]e\S;W(b4&a5)U-DQe,)D2<3)VaO5@0/^c(d#1_)6F]0/C4;;Xbf#.C
X1+b_#f.g\?b(Z3O5+\ad])dFTXgRG:CQ@e<F2L:5\QF\BMEQK_J1;@N[G9WOZP:
WB:C3?H3&7daEZ,#[L1F@ZE1/GC8@(<14Y0cVDEddadS93eZQQCC=.cHIfBe,JTT
eWEV5.1[D;=CX1-4Ua8I6[Zb@a.b8PaWX,gCdN(G?gQ^H5O:RAC2:QT;YDL<JcPU
@SMB+J[U?S#UZ/T)J81G\(K0a54PIT<]@)0PXTBD8E69e1QD:]8<QK8T-FUJ.#3g
2XP2eS46@8Z>WXHQaG&78D>N.U<YY><L?IA2GS&3@3:Z8_fFMH^CN?O5S\B2_E&[Q$
`endprotected


   // synopsys translate_on

endmodule

