////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 2006 - 2020 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    "Bruce Dean May 25 2006"     
//
// VERSION:   "Simulation verilog"
//
// DesignWare_version: 71b06b2f
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////
//
//
//  ABSTRACT:  
//
//             Parameters:     Valid Values
//             ==========      ============
//             width           1 to 1024      8
//             clk_ratio       2 to 1024      2
//             reg_data_s      0 to 1         1
//             reg_data_d      0 to 1         1
//             tst_mode        0 to 2         0
//
//
//             Input Ports:    Size    Description
//             ===========     ====    ===========
//             clk_s            1        Source clock
//             rst_s_n          1        Source domain asynch. reset (active low)
//             init_s_n         1        Source domain synch. reset (active low)
//             send_s           1        Source domain send request input
//             data_s           width    Source domain send data input
//             clk_d            1        Destination clock
//             rst_d_n          1        Destination domain asynch. reset (active low)
//             init_d_n         1        Destination domain synch. reset (active low)
//             test             1        Scan test mode select input
//
//
//             Output Ports    Size    Description
//             ============    ====    ===========
//             data_d          width    Destination domain data output
//             data_avail_d    1        Destination domain data update output
//
//
//
//
//
//  MODIFIED:
//
//  10/01/15 RJK  Updated for compatible with VCS NLP flow
//

`ifdef UPF_POWER_AWARE
`protected
BZ<@7,7AJQ?,bJ@A+T0/&/=8>c1]<b:21Z&)5FTC26O&IB=0J927().5BKX;&S_P
aY#c.RA(HEK8F3IOFZdI@N\TV-^c&GL4GS]BNVEI(F9eIZBS4:IQP)#^XC4:95Md
N6;3=2TgL\-bK5BQZ8dP.&Gf:X-UGJJHC]0SPY&bUS/4B>)ZU.Z<FKXO>H?RO53=
]R5&NL.\B7PA+V-?[PLU73\>Yg]-3#9Q1FRO6a:F3GH/X\;B/RgfSO:eU4YETOa\
^,R:VFIB^F2CA0-eGN3^.O7^WR4d\QaU<-5F,PSS-0_4>0HM_TUX)W&c&88;R0/L
0,PA06(;=>Le4JOaB)2,Y?gf0BSGS,5S#I>7Z_<=Yc#c@3#RV2S(Ka@dEP_G[dUT
^#&VeVeMSW2-5Tf&).<>g>KLF93<e[?=O_I1c.JQKNLdT\&U893<f@R6/798]C&,
N<_6+Uc5][CH7Sd([ROgVY3F7T<M^c09R&;<dNe(JRG9&NE7<?R]WS]D</<U+9]A
W+B[P\3<+&CYS\A3RB4<IE^f+&M&Z@N@\&]EN.@_OZG:d<:EI4Y\PYLN3<Cd^a<=
EL&+OCcUYZQcFOYII.^KL?HC?J;Q9F;2]X#+O(WBD4VI9;VD_]KO7e+XHFBfI4I>
A+2KYG03Vf:VP:T<H4W\S:I-g+Y[:@7)[c1^-ENQ>4ON]P1.#[,;I0Nd73f;BPAe
:RR14G]#K,[4\6Yc0Z,#R=PFHE#25.>J4NUTVGNV[d3>Y???a3SG5SBcS\I4.@+G
OddPKG\cMDc55,Xf)F.(7g02BISID6AZKVacH25M?^aYQO1Y+&LXA;adHM7J_EGQ
L6c&bOaMg]bWZ/J0@&/-_XeZ1G<#f,;7RdaG&7T0#F<gIO840EG@GUF+B(b7.N&,
(X&S+C^Q5TJ:a5&??HVC@MVD2[4C-8ZGcf.fKJecS3&Q=aRR9e/dU\:gXCbU^Y@=
,01;YA_a<1\A_1?G<:HE\YHL6))M<Qd;?#&(/JZ(IRcZAIaV0f-1,R6fR9-/b)(X
T^/(SE;[bS4(Q,6A>9?db-068;V\\X_<d>L=4]3@6\YH-#:SL2dY)6\K2WQV#&Y6
HL2F_-?D,YYYR?UI._Rb:;cDNJ&.6,XD&3G<WSf?b3\5)XS/^=]Pd]EJ=J4_9V0K
1.4Z,]ZSQ#)4X[EM1_>[YFeXOG2S9QY>SO;Nde]U0U;AJMOT.(PLFD:N5198PIFb
-TfW46ZO=X?)Y<SG\K#:fOOVYfO(]a^4C:U&SaVe&G7A?D=<=N7N-e,:XD+cge=5
T_-J6L#/^HaC.F+54S8Lb3_]V=GZWKae0[&)/Y/]&&YR1aCI27A\#C,W6--CWKR1
SX/J[UM6Z@M7=XC89b6>fd<;D,8^&1#)_+Ua)&=bT@4BL\;XM6OAM8)aB&TU3e2K
d<LRIS4@L>gV/-VBQC^,WLL(d-L>94b<=eIPFGPF@0Y6e/1^R7<;?I7UGdJ&8A\V
0ZK,=4\QFaM;#cAUaAC)+[S3G;Q^Bf9V85SZY43^&cOc0MVJFBfT3fG^7JS)V<9S
=cWe-We+/WFM=OYd#fYaTWP8fN=98;bT7P@9gQC;RYf&d[2/YSbZ11ZNWC+)FH2;
;3<=0Y=3H;.dd]cT&T.aC/IE_<FD94N(V#6@c5RX^\WRNVEJbZ?3a3,?I6=T\aaV
#Rc)eA?S[U)KaKZ5PUaR\F.9E&UK^5TEN^dV(&><K2>DDe)VN\b>abQd=:WO3HbG
PW)LPCMZ5V<>X40PR_5>g/T<ZIOMW#f3FE,ZLF;M=0c.L-WKO2e/0aH]cTNZHb)^
Ma05bV/M3<^aL<&GFLGb<-)R2^+F-C?X,]2V_c/E,,bKc:H:B7VIJ71c6a#T\,e+
g+Q8T?^LC#=>c-,gfLTERGfaH[436S=c(]ACPdfTL(RWK@#P.7,ZED/D4f1:;SbV
0B,c[&FF8Q&27H(N1T75HPaX9H?J(^/-VOHM9N7bY:+A\H?2LGbG=fJQ/-+2+/P-
dH+,PFJB<6^TW1/EQ=E0e1bddLF5EVO;bM]PVG,^K5D:D8863[D72L:7&aI>IOS^
fMV:.#Y1K_SK#f+];[9F/bM;4^F\GU01#L=QSc[3_2W[4W^&d;Ba+G-EHb_fJWUR
_[>QSOK@51Db_F;6(A8:S;J[EGTER71HO^.XEK1TEDHTF0VI;KaYE]U))=a88_J8
_T4d)S+60/79[QU+dEE<T21#2F-JfB[aB(?1WYf.8\]cP+>GESd&#FeH44TCJ+&K
T0R#Z<N,\JP^ec&OO\&:#@]<b])#e\BQ<FXPd3T[6-BY=f,EEMRI2cW+4A;&PZEY
L/M.f<PbW1HV1NC]150+XW(1L<9E)R<RJ66>7eUE,B_P.&Q/JJZKB6]H85_N,JZ)
=Y<Mb,bKD(e;KI&H/JF>Q=cTKf;YUe(@-8OL54BLOL0#SZI_=9XGU4&/d];.>4++
43GH-/JKV:B#f[]b0T-YFFKPV7eX=7FBbdH;,+]J?KA@ggK7\FK>dBO)Vf_GM3O8
7_e.@3=]RXPLCWWA5(II,R&9&;OgXAbaY/0_+S).TX0Y^1-/7UIZc_M]^\-aff16
GG6WVBe]APCL4HW?G4/G9M3d\7cdg1&BeS9e+N2@(.CUI:E:+L44)cYM(@(RQ(CH
9&2Z=U.L,/5F_=I6,<Y<((_&?EPR6M9NTWDQBg4:R]-&2E01fYVd8C0=025[b<aT
4#?6+5L+K2dES##8YK>>87e]fN^8?EWfWOFeD&Af0@_Z=BIC4560dU:DL_501\:4
JHY(YgTCT_He:EB=e?:>f,bW+Eg(/;/U]DYSR5afC-]5a@gg=g3:G-FLA#Z-53:f
,;^L>ORV[8B#_;XX0MbaF+..#Ag@J+Rd>=@?WEeN7;O.+YRNZ^V7HcL/#aOSc<2X
a]\WYO=5>HB9T6E4UME)[+(@3ST,)M))VbYH,:PcV5X<+[9Z\e8OcK(-S2#CEDVU
L#OaYMgA@/78A[^8f:=&YUU+5A-:^3K/5@+d?ec-MP9bE(5G\J=&-OXE0-/U=;\H
;R(U;@Z\:_UOLF^e66GJI92\/2:.OFca\IL]X,1fD(0[3B::-cDEFH9SEU<89ZTO
W3\<cTW-<B92_>PGGb+/QL8^HZ;D(Ue]e9GaJKJCVZRZ<9^)C3UV:bd<f7;F0>EE
LMS:MSeV5MB7b=PZ)P,C&0HY1J1.#PXUET[g(5e,\3GVNLfR,<,gLRY7DFLHKEe8
+VOR(9ZBaPZ-f#d?Y=;K,-D4OI]G#U3Z.eLG.^EbWC4:ER8;[:9+WMBYG]]>MJIK
@(=\9gWg?9OTdeQ4bCS((-9&7.6WRH]EW:->E.CE,/)TJe;2d3S&7]9UUN:S[0d@
\G@<M\e#Z/O)P^/I?<_Y\X;5/D#=)@<P(3N&T^Ma8Q]]D[W);+KDW,N.Pf1Q?2QZ
\N&ZM\J&PVBX+4IE+[+8PIYaJg]<#Ma:;V9?)VG_3L@c=@JFB^_Pg?Mc?ZK_C[PK
UX1_F@/HaQIU+KNa;TV>A,)9JH0,4S+]3G&RKY/a#_01XWZ?;3N/Hc@L#g(+^FeY
Z&;dE]+^5Xc2Cg#+#Ya6CXP3>&cf:c,==BYf<SYZS5K]VBT7)^9</,,fY]F2ZNWX
)Kc#\-C8c:[3^YTa;+=F0f1S2E8fK-VOA_O/&O9J^FK(C[K[.A[J/=,3-IPbH4\?
^^M&8]25g#F=\X:.I][LP@Y^]V_M9gR(aY\3L+bQ+g:ff@SQ3V-]\<P[GP3(_IVQ
HG53/^WATJ=35a2>FQRJMC(8,6A_a</EGB^fWBV&aIPe:&R75d@X6E.>8DV64aU8
J/;].STfae7I.gFOB5>16568Z+1+(EUT#fDfWbM3Ed907eX:[eS,8261d=/+72/d
dZ&??^P-[OX@/5&URCc3LeNOeDf[ZdBX_>aYH3cN4:B=97UWQ0V?4+L1+CB9W/)+
TJO>C)a2U^<4[;e[#Xe/LI#LfM940Z6Pa>YP-8@D,#c;9G3(F[F(+RM7Y7Vd3YXG
<I;3eLEXb-3eaP71I?5bbg5bWGW3Ibf@-0HdNdgA]@Ob^6TKRUV=.:HafJI:dc.>
5^H4(<X3#2>/\UP@C\?<AH;ZPb9^dF_2e;gdM7S]P&bLPfTcQ/[=R4O7LUA8c/>>
:dJX?@L_9A^aA(cc3\cD/X4@^(c<LG_60/&VRUB_9Q9ZgJc_99e]cYP8BJC[+R;\
3ZJ1_120U]D29>4V?V<aY:a=B@38C_F4YF+T;Q8cO1,;)2LR-,J(#<W@OCTF;I>1
+973&0>eTYUeI<_/aaJK.#2d[L5I&5#MbaQU3g4#\?/21XX<I>MYY]S;0dEd#AIO
_F,3Ub(7/PNeYZI>79P6;]Y+?=7Y/LS.,CTf9d72BfW(UgXa>EeGYT-?PgVE7[8>
B8_ZHQEb\K5P,G6IIRZVeW,=e^YN/7Yg1>SfR)P3MUNUQ[I#/&=?]^D>\XcAR/+G
NF&4;2.f(XGbXQYdVI^[NaL[>&0,^D.a+PVE#_G6+<dH^\I2NJ]Z5caE(WcMPS8_
CVUS+F^N0+CWX<4e:A2S][fTfS-W.(;T/NI>?//+8,6<W2K\&\^?b:f[>AZ:PP&S
>A>USW3VIVR,F7<c<G28<?TfX-#C>G5EcKfL(NHf^\f-[FW16>dM30>)IbDL#^cN
#d:6&7+[J@S(2K#T+C>:>d4YVC@2f98>HM.0FMAYMI;6Ig/WNb2PH>;R33;9DeQ&
K<(b^TM:_OP//?A=?XQCH[?<QD+#?PJP9.B:KS2DBY<(<#A=\JK3K6),#G=];11K
5=@4#TE,B-RY[^.&>_5\0R3TZY_aBT[HH@E.MD5ELU.7P>@YX/-U4d+5,Gd5bC8W
UN.Ob,.BAJZbDPBdBL/&HKI3Z8=aX:d0]0;&CI.^(.0fDb)].e:2AFHL^bB.?5,P
5WF86ZDM1XgcEE@IV&5+K6J9B48P\=WDRW)A=9IRH1PK6c^>.>FIf73c]9G5/Y36
,GbU38XC0Ta>VQ,-YRCOb^1KC28dDI3DY,B+S.<TfKLH@?/B8dN2J9+=LD<cgOQP
N;6FdMMCF-Re:fO>SULAK<NdZa04>S\=#K-Z.>3GO@,_8OefK:,[bUaQ9Lbg(9b@
H+bE1cSIfUF:ZOM16OY2GF(YUaV6+D.DEL((4;:HZ<cd1LbJaP7IM0,df2b[E5.G
DHB:9BSKPW62dPLM?XP\I-7dEd_TGN-bPW9_1,dO=TLY)bbcI7,VgZ.&\^&XVI?b
XLL_+4/4WKJ#>Z.;Y.GF6?2G;g;OAP8M?5B+5-LICfD#[;1/(=(EIE1?cKJNMf?Z
2P?81^W/CB\-,)_OgS?P5U5MgP5f/OYdD@WVZ-AHDg\J../ObEd5,H/c_P[)O/Je
YI?@()63[^;dTUc:GB328LX^_F[]E]ab3Ib_)+NHO-.M;[Qa95,f-OKK>1e01C((
a==8/60a-A@M0H3HJ,.NB99;-AW:HbEc4,AP7AL4P1CJI9UB-H?eM5EEN+a;fS/1
4L>Y-<@dcP90ZQ[&T:&9ab707D.31CaS40d^@,VgT+\e<@59;ZU;c6IQdFYFXF6J
/Q^E;^1Q)bVX;@6M24cW.afY?PG]&PR.?:G[V9/]fF4)RBLbdc6=],+f6+ENU0E(
V)&gF[&XY98IZ8VAZfJ@Cfg&eeSS6JUAY7MK934/HXfd8OJ=1EPBacFa]S+FLXGf
aB2AFC<NZ68:b1/BfcGU<\AT85^HSD@4KRT=4_#UIML)CEMW7.aA4Ve;V/LfD?Ed
.FXOJH0N1E[7(dUDX/I+@@2LXL:B.#0PV;1c8=C_]gSJ,+aBgc0]O//W=QMCbF=X
FAW?Yfe@E9#L_#;IOUDb\Xc\&\&LC^,7e_(O>F?Cg,CO4gIZD=>2cd#d?-S0f+O2
?Z2T^#HKOQ&;Z,FN#,L7G_FbbK^QJ0_YA@.e,abZYbUc./48cdUbRXCe175^7Q\N
J5ODW-3;[EB=G9aUfW<eD9/C)K>H7.7OXKHK52HRdQ<.?-<=;1bI]5M&SYD-cd\&
;2<6Wb8UNTA4,g)7b<D@bZ:JMfRb/W+VYH<+XWDG_7Ca4C]906JG3R?A9NBTC]Y.
LM#F]([=>N@16TD^=-DB^7DW^)1egU5OZ;L/OZQA=PD4fP+<TJXRO=]#(:56@;[R
gJ0UR(GG1,5/,f^E9?Lf(]]A7;6W9TFT4&L;f:ZI\S-53>VTLL#g639a8/M-4I.,
]-TE/GN.d_F@AZe+T6dFP:D)gD\b2Z:g#(<.TO2/Z_:@@GOJaa64KSd7SAA^NFdD
:&03M8(#EEEaI;Z-)VXY=5:I5T:aKfDV_bZ^IZE\ULABDdaS>HbB9+X2<\?8>Xcc
L:aPKaD?QHT@T/f9Pe06KdGYc.>Z]eC65CeJc=^FHC5WB8))+,fT^Df67_[8:7ae
JA1.;8>/Ba:<-d)Z1GPbGWCaAL(G_59&3H+#A:YPWKJFb2HZ;eVRS6Y3<_@BBK:g
c03\b31cOR,[3#N?.YBaO#^T_FE.SgTGF/>^35(>)_8;efZ;&]@4Q,OYRa/eJVQM
O2D#F^CV8QM4@?Yb+YK<MaP32X&]SOd0GggN@7/,YFSD?V]+@+6#3Qa,E4S07EQ<
(F/@53fQ1P968b1]AEWR_dL\+#E)[;Q&QLRAZ5;@BSB_/OU?\Pe5,-K@,67J^]C>
0,bT]R8e+5ROSQ-:L7K?R[F2?UMGUQYcHM21XPX48UWZ36O/P,S:P.@MQIB)01Me
Ea3d3?#ISW/+>bdV:K,c?=;:V4X0GCg\SVcTQF&^eGMN5ZP<:78=?8LIaAM^I=NV
b-.;:(WdD+\Jd>a3McJ3L7A-/7>fN-)\6.LA8gHI#RW;);:VR</ReY@Q#?PDg]]?
\OF:CIX-^8QHCg2+<VfP)+<OMI)+MS+/\2TW4=aMELZ75LRdS=LY>Z>@-CX<<Q?N
G,8+\.]UeJ6d>YH1I9Sb6d/JHH8c5^,BQ=@a]FQQD90d>&A:YEdU5<EG0Ie4,BX>
^MVO],KaT6eC<\g@&HZ=D<dQ18d_[XXT/AQ]]DC@[0<)F6]2M4NWgcADB0#Vc]&A
>+d.K;L/\7ff:Ig.e3EdR8Kc5L+SAX(#1CYF4d?YbWJH=RHKGg4N;Q6EG@65SfV.
55acWLf9X+/NeCaGS/.EXB6ZDPFEKCI4b_LYDCW._:HQ&;@bE\7XSeUQ)4<NDED9
ZV.FJ&5N+8K5&MKOW=Z<bce?CJZWN=Q,ecBLIM]cR#NCMJb-XF]L((0Z-U1CK;YZ
eB,O8/VT;+:55I5HNe;.)W=GbYB40_XSR/BFP6H:Q<T72C\NSe2LO(T3MLe3N/(_
D4^)QQJa[<R);De-S=:]QQ(/CL/TgO#9aJ#0)2=4+7AfK<5Q(NZNKJ9>fIME5?)f
>)bGc79,CF0PJHN,]e^BdB8+U)4#T5DJd_>:,O/dXP&(P,&A0GX^_aH.bR5\d^EG
1/M^IXC,TGb?>;@W&c_^R5GI5SLMZcLE\UJfL2M9Gc_Jc;Q/@N/O[50^FQW7@>]S
/17gCPL<W.gW]gC:<aIZd>EJ20/99\PVCM>MQNT7;c-I:25fI3]KQ5LOIbICCg\)
NJUFHA?.+H#>U))eML2FH?DMb4()]9905b6/,M^(BP+?R^&8BH3\fAGS?,^51e3Q
;:EU9#X7b&WW5<>:BXacTVYDf#-=.=C=1N>OE7(&<@=8+d4=-T-B):=gDWCU&?1X
aC,SI2<N.:D^dSEISC9OH)/^2EX7K\^?5eU.G4/LY7.C]X\?OKYUHW9\Sg9TgIL1
LI01H-A)PE6@e?-W]FDI75-=dI\VOWQMGHd<2BBI/XX#5Dd.U(gS)IC]d?cV>G<e
I8)cfZUM\R@.;4I\Q3JG8_cI\Z3.IBaF-EKSFTMJadV+b,a7.LEL^4aT\J)H#XUd
7cSH28:#OgZfYGH),4G/(?XXIcU;D,]I:#0WH<Y\[P0TWRJ@G&-_]R\5)Ua2RJVP
0Ua7[(bL(X55H(IDPUd:U57?<)DYU<(,1K5J=6#;@2_<W)cI,66+@7I(V:\K#VOJ
Oc2]339(]KeNIOAXE2J<?<=cL]86/?I/Rf)7;+HU.e6DC[9=C;PZ4S=+_bdY<6U.
0WHDb(BXYW@9]-T.BX1(K3eY(5:(]1JEJT\60Ke129^\(-3,^4#c1K9^&9ZA=8<.
UK\\^Xb1K+/7LJ(A)^.1[M#C5R4)KVV/DUKIH2?D)A:g]@I@YL-:H+eIf8K1V5X_
WT]FT0&5.=VV<<S=#4&F-<TS>/]b6^G[,9.DSG#6bM>H2f7K+cg>T=(.M6Wf<S.:
B3?P4>@M:N2LPO)OA#LJ@1-1_3AER6V7\ZDZ=G.WI[BFR3LUF9-aOd/EEU#J_;e^
T5<_@BNc#)Og&24/Q/@S50TZ7B-GKE_#>OWB\-,7U:K,:X^AAATCe:,H=BFfc_Y9
9ZbgY:/@A;8O4.YWeE.S,.L,]-fL[.^^X:X95Y44:#TQ#.L7J(]CSQ-&^ZGRJF<[
.e8WUJLa1=2[C+RKT.[b&3N8b_JX5T0_FRFdcd)2XYM;O.JaR:ZS]Q]R6+0I3&:A
+L:TEB96)6g9,c+9b^(Z;Z+P977W+U#.^A69=#.7E@0&/:;#b5+PQF.GS.ZH;DfU
,(SCYbJ,T)?d6b#ZU,G2V9:-f/V2e?_LeIdJMa:D^d.98YOd+QSVDAOG)+@Cb)_D
Sd]A?Q<)X--AX/\A]IWfY@3J@>VV1b7WB,#8IZcDX&CQX^f[J9,9[8OD(X0UTg6.
#2[G9;/SK6LCKWV/3Ab7B9OR]eVA32TaVC[?N,.2B-e)NLO>Ye5&7((OT]P<MCE&
&3W?58+=dT^I=S6083D@#?9_8X:=HUY9_]9C\B3N#R=I60N=+ZE7&YO)NMdB&BC)
fCJGb3I3@,4]PKT;2,?+M9N3&XO53Td&GRg0L>U0_@VdAaKbN:+CQDReWM9eE<RU
^UY-5Q;I)SGBc4J(c/HJ3G)B9Y0L-faI2d)_;)c27_95<&26^,19I+L;Gdg+#_7P
SCPC[YOJ[90<aS2Q,8]ff4\6;IeSXG.@0[K<cE61TF#5S86d(A7F+L=?VRC,Vdg/
D2@3<]D=(8RG93AZeNcO)bV2Y&6CSGM9I<bZ-9^GfXgcAYT:BMRM9QcgZCC[4Kc_
V)0GSFD0@]PEKL?ZgE:GBSV5@2VP^5aJ+:?R^8HDdSPLH1H=/WZO9Yg8N>UIEZ2K
B6^Y8.ZL7adL1A7HgQG5WNU&09YFA=P2#>Q61D?Sb4G-GTfK2cVL6?HGS37b&fI=
^ZfZ[/#EGAT]]dQcHgW4X-<_?YW&6^EWCSZ=d0/fSg(>=<NQRD)0XZ3):,DA[(IF
g#cP19V;7)6)(9e/FMTW0TLaX&&NaKY>53SDT_+1]CXZd=.+>MR+(Z\c[ZNUReEW
@aV#H9[Nf6&Q@0O-H@I->;H,U4V\Z:TPE;_He1@D+.gX1d9a:42AYO<=K0?)-4U?
geJ?3B74-2#KU,M5BO_#61_TJTNDNObAN2D352Hc=6;L6CgEQX83&IR,[<Fe<1W=
Ge2=Ug#+NfMU6J@-FQ-\C5Pb#,IK#=U\\1+.FGD<A;T25_W@0=YI-V@C0HI\,3M5
J3OG5-AR1@:1Z1/&UK/Za7[YfP1@&\=g\/P/U#FN>^:FQ+DGe\\VLUEOAe3/58V/
K52_Z?W/XW8L7W@6(J3)(-)+51LAPHIMWaYB5QOeIXFg<1)F;FEHU^G<77E>)7__
.Q1RIS]-K.Q/f+ZW,D4Z3.<?;8H0)M3AIBefMM/P<RUf/R]^V^2URe2=O)RNZeUN
ICBJS:4GW_d81D,ND6;(cgPe2)<I+(>cb7<=@6D-0-5b6\Ba#Ib^/@EHe.V<R>P0
aWA]FffB3XX_<=>MQ]P0gf41MU^&74Q::deLSf@<32N0-5CKME.+_I@F?1H=>F9\
0LRa2Xa9;A]JUQO6DBW(6KgDV6NU=;Jb_+-82]JG7/+8V[KE106C)8>-4ZD,JaP5
]/gHZJ^6G0TYP14VW;@AD\Q<\9)YDTGP;M><LA[,,I_]UO7<L/KQ:>5:./N#3Ff(
0SI::5?0V5^eVc.e=?<RffA>/J-VY0&;bOSX.(N^RJ/3F/(fFLR\1(4,0?<[.B-X
?Hae3;VY]5gM_)GCWNbC^?SfG(YU#aCF(.<F&-9K.eD[3ZZ]d-XNc-]dB+LYD,XQ
bJ?&WYE04IL7CE9Q<EY+3O=@WZUC&V;AIF2L5ba\6QQgRF&EA[Z+KJC@F8)0RO5Z
TMR+>TEHW\^;V)6.GUVAH=c&P<//F;>bD>gTf61Z=&NY.4<M@fbW=?HQ>WaG26-H
H-@E_dTSfCeA.T\2\7K)TXcDJ<5/[+_4:(Nbb@L+9C\e_bVD.8Jb.QE)@/BcI@Gd
L=HaOZf>N[g4-D=S\NSfT=TZ>#fH6/MD88X&9-?8gfT2_KE-;7.<PfbD@\D_Y_H.
4UGSQH4\V1?9Ka(I1[YQH5bYRAW84F=Af&BG;d<=UgC8f^0/GeQQa5V>N7[PR8)E
BVJI#SC0?7aK8(N;ObS]g;7c5F3TQ[]UH-);YYXC_,<[YH1W3d^#QgGC6\5#>ZJJ
K;I82YS789B?[R1>>J0LT[WfeY<S((V2-9WHE-dB8F?<db64_c)]e),Kg#V(=--+
=@bR8I&5.gF]=)K.];\6RdT4<]@#UZO6&8BZc+Z1/gX^6NWL1M^^+fTEVW@fUR7[
9W[[&68KB@=dR7^U]6NV>P8]Xb8bML:EMRH1Y5T)VReQZLe=9ZNEL70KIUPL]aHg
eT18KAZB,<<L0a3W[-&^DIcDc[)G_)=[JL^XLZEOd8Hd0SHJO@THY<9@KdNTSX09
RE29EV:QG/=7F<,]_VI;,N>WFP&FB9:7NYa&L78?1#ZY<JZUafDBg5.YMVcENHX]
E[:SH_Vbd@25(H0a[[Y_5(HB\T\b?FL1Q;K[2ScYFa[IZM0Q6=0HN49a;^8Y)?DB
a,TU6>e.5<;W7I2e(c,,GAX_8IG=fb=5.G;aA#6]5dCX0]-WIE^IIZ8DVX28ObS6
KE85X2NX&1abZM501W/)>).;==ADEYc:6#DK,S3cN=PH[d#YNE9,UBK53/I+_K20
\Rb/P#JAHF>)2_#Q_:)O];@5g(QBN-+?:U5f]cR;L+J=>L7+;R6\>Afd0d7R,H#A
N=Jab6-U\\[@EOec-[Nd?,<b,-P)G&&V4]\RSK_#de==H$
`endprotected

`else

module DW_data_qsync_hl(
	clk_s,
	rst_s_n,
	init_s_n,
	send_s,
	data_s,
	clk_d,
	rst_d_n,
	init_d_n,
	data_avail_d,
	data_d,
	test
	);

  parameter integer width = 8;
  parameter integer clk_ratio = 2;
  parameter integer tst_mode = 0;

  input  clk_s;
  input  rst_s_n;
  input  init_s_n;
  input  send_s;
  input  [width-1:0] data_s;

  input  clk_d;
  input  rst_d_n;
  input  init_d_n;
  output data_avail_d ;
  output [width-1:0] data_d;

  input  test;
// synopsys translate_off
integer reset ;//        [4 : 0];// :="00001";
integer idle ;//         [4 : 0];// :="00010";
integer update_a ;//     [4 : 0];// :="00100";
integer update_b ;//     [4 : 0];// :="01000";
integer update_hold;//   [4 : 0];// :="10000";

reg    [width-1 : 0]  data_s_reg ; 
wire   [width-1 : 0]  data_s_mux ; 
reg    [4 : 0]  send_state ; 
reg    [4 : 0]  next_state ; 
reg     tmg_ref_data   ;
reg     tmg_ref_reg    ;
wire    tmg_ref_mux    ;
reg     tmg_ref_neg    ;
reg     tmg_ref_pos    ;
reg     tmg_ref_xi     ;
wire    tmg_ref_xo     ;
wire    tmg_ref_fb     ;
wire    tmg_ref_cc;
wire    tmg_ref_ccm;
reg     tmg_ref_l;
reg     data_s_l;
wire    data_avl_out   ;
reg     data_avail_r   ;
reg     data_avail_s   ;
wire    data_s_snd_en  ;
wire    data_s_reg_en  ;
reg    [width-1 : 0]  data_s_snd;
reg     send_s_en      ;
wire    data_m_sel     ;
wire    tmg_ref_fben   ;
reg     data_a_reg;
 
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
  
    if ( (width < 1) || (width > 1024) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter width (legal range: 1 to 1024)",
	width );
    end
  
    if ( (clk_ratio < 2) || (clk_ratio > 1024) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter clk_ratio (legal range: 2 to 1024)",
	clk_ratio );
    end
  
    if ( (tst_mode < 0) || (tst_mode > 2) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter tst_mode (legal range: 0 to 2)",
	tst_mode );
    end

    if ( param_err_flg == 1) begin
      $display(
        "%m :\n  Simulation aborted due to invalid parameter value(s)");
      $finish;
    end

  end // parameter_check 

  initial begin
    reset       <= 5'b00000;
    idle        <= 5'b00001;
    update_a    <= 5'b00010;
    update_b    <= 5'b00100;
    update_hold <= 5'b01000;
  end
  always @ ( clk_s or rst_s_n) begin : SRC_DM_SEQ_PROC
    if  (rst_s_n === 0) begin  
      data_s_reg   <= 0;
      data_s_snd   <= 0;
      send_state   <= 0;
      data_avail_r <= 0;
      tmg_ref_xi   <= 0;
      tmg_ref_reg  <= 0;
      tmg_ref_pos  <= 0;
      tmg_ref_neg  <= 0;
      data_a_reg   <= 0;
    end else if  (rst_s_n === 1) begin   
      if(clk_s === 1)  begin
        if ( init_s_n === 0) begin  
          data_s_reg   <= 0;
          data_s_snd   <= 0;
          send_state   <= 0;
          data_avail_r <= 0;
          tmg_ref_xi   <= 0;
          tmg_ref_reg  <= 0;
          tmg_ref_pos  <= 0;
          tmg_ref_neg  <= 0;
          data_a_reg   <= 0;
        end else if ( init_s_n === 1)   begin 
	  if(data_s_reg_en === 1)
            data_s_reg   <= data_s;
          if(data_s_snd_en === 1)
            data_s_snd   <= data_s_mux;
          send_state   <= next_state;
	  data_avail_r <= data_avl_out;
          tmg_ref_xi   <= tmg_ref_xo;
          tmg_ref_reg  <= tmg_ref_mux;
          tmg_ref_pos  <= tmg_ref_ccm;
          data_a_reg   <= data_avl_out;
        end else begin
          send_state   <= {width{1'bx}};
          data_s_reg   <= {width{1'bx}};
          data_s_snd   <= {width{1'bx}};
          data_avail_r <= 1'bx;
          tmg_ref_xi   <= 1'bx;
          tmg_ref_reg  <= 1'bx;
          tmg_ref_pos  <= 1'bx;
          tmg_ref_neg  <= 1'bx;
          data_a_reg   <= 1'bx;
	end
      end else if(clk_s === 0)  begin
        if ( init_s_n === 0)  
          tmg_ref_neg  <= 0;
        else if ( init_s_n === 1)   
          tmg_ref_neg  <= tmg_ref_ccm;
        else
          tmg_ref_neg  <= 1'bx;
      end else begin
        send_state   <= {width{1'bx}};
        data_s_reg   <= {width{1'bx}};
        data_s_snd   <= {width{1'bx}};
	data_avail_r <= 1'bx;
        tmg_ref_xi   <= 1'bx;
        tmg_ref_reg  <= 1'bx;
        tmg_ref_pos  <= 1'bx;
        tmg_ref_neg  <= 1'bx;
        data_a_reg   <= 1'bx;
      end
    end else begin
      send_state   <= {width{1'bx}};
      data_s_reg   <= {width{1'bx}};
      data_s_snd   <= {width{1'bx}};
      data_avail_r <= 1'bx;
      tmg_ref_xi   <= 1'bx;
      tmg_ref_reg  <= 1'bx;
      tmg_ref_pos  <= 1'bx;
      tmg_ref_neg  <= 1'bx;
      data_a_reg   <= 1'bx;
    end 
  end  

  always @ ( clk_d or rst_d_n) begin : DST_DM_POS_SEQ_PROC
    if (rst_d_n === 0 ) 
      tmg_ref_data <= 0;
    else if (rst_d_n === 1 ) begin  
      if(clk_d === 0)  begin
	tmg_ref_data <= tmg_ref_data;
      end else if(clk_d === 1) 
        if (init_d_n === 0 ) 
          tmg_ref_data <= 0;
        else if (init_d_n === 1 )
	  if(data_avail_r)  
            tmg_ref_data <= !  tmg_ref_data ;
	  else
	    tmg_ref_data <= tmg_ref_data;
	else
          tmg_ref_data <= 1'bx;
      else
        tmg_ref_data <= 1'bx;
    end else
      tmg_ref_data <= 1'bx;
  end
  
// latch is intentionally infered
// leda S_4C_R off
// leda DFT_021 off
  always @ (clk_s or tmg_ref_cc) begin : frwd_hold_latch_PROC
    if (clk_s == 1'b1) 
      tmg_ref_l <= tmg_ref_cc;
  end // frwd_hold_latch_PROC;
// leda DFT_021 on
// leda S_4C_R on

   always @ (send_state or send_s or tmg_ref_fb or clk_s ) begin : SRC_DM_COMB_PROC
    case (send_state) 
      reset : 
	next_state =  idle;
      idle : 
        if (send_s === 1) 
	  next_state =  update_a;
        else
	  next_state =  idle;
      update_a : 
        if(send_s === 1) 
	  next_state =  update_b;
        else
	  next_state =  update_hold;
      update_b : 
        if(tmg_ref_fb === 1 & send_s === 0) 
	  next_state =  update_hold;
        else
	  next_state =  update_b;
      update_hold : 
        if(send_s === 1 & tmg_ref_fb === 0) 
	  next_state =  update_b;
        else if(send_s === 1 & tmg_ref_fb === 1) 
	  next_state =  update_hold;
        else if(send_s === 0 & tmg_ref_fb ===1) 
	  next_state =  idle;
        else
	  next_state =  update_hold;
      default : next_state = reset;
    endcase
  end 
  assign data_avl_out   = next_state[1] | next_state[2] | next_state[3];
  assign tmg_ref_xo     = tmg_ref_reg ^  tmg_ref_mux;
  assign tmg_ref_fb     = tmg_ref_xo;//not (tmg_ref_xi | tmg_ref_xo) when clk_ratio = 3 else tmg_ref_xo;
  assign tmg_ref_mux    = clk_ratio === 2 ? tmg_ref_neg  : tmg_ref_pos ;
  assign tmg_ref_fben   = next_state[1] | next_state[2] | next_state[3];
  assign data_s_mux     = (data_m_sel === 1) ? data_s : data_s_reg;
  assign data_m_sel     = (send_state[0]  | (send_state[3] & data_s_snd_en)) ;
  assign data_s_reg_en  = (send_state[2] | (send_state[3] & !  tmg_ref_fb)) & send_s;
  assign data_s_snd_en  = (send_state[0] & send_s) | (send_state[2] & tmg_ref_fb) |
                          (send_state[3] & tmg_ref_fb & send_s);
  assign data_d         = data_s_snd;
  assign data_avail_d   = data_a_reg;
  assign tmg_ref_cc     = tmg_ref_data;
  assign tmg_ref_ccm    = ((clk_ratio > 2) & (test == 1'b1)) ?  tmg_ref_l: tmg_ref_cc;
  // synopsys translate_on
endmodule
`endif
