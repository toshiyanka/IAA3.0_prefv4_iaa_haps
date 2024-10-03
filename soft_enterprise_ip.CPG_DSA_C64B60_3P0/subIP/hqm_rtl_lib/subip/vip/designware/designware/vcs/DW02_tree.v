////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 2000  - 2020 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Rick Kelly        07/28/2000
//
// VERSION:   Verilog Simulation Model for DW02_tree
//
// DesignWare_version: b40368c9
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------------
//
// ABSTRACT:  Wallace Tree Summer with Carry Save output
//
// MODIFIED:
//            Aamir Farooqui 7/11/02
//            Corrected parameter checking, simplied sim model, and X_processing
//
//            Alex Tenca  6/20/2011
//            Introduced a new parameter (verif_en) that allows the use of random 
//            CS output values, instead of the fixed CS representation used in 
//            the original model. By "fixed" we mean: the CS output is always the
//            the same for the same input values. By using a randomization process,
//            the CS output for a given input value will change with time. The CS
//            output takes one of the possible CS representations that correspond
//            to the binary output of the DW02_tree. For example: for binary (0110)
//            sometimes the output is (0101,0001), sometimes (0110,0000), sometimes
//            (1100,1010), etc. These are all valid CS representations of 6.
//            Options for the CS output behavior are (based on verif_en parameter):
//              0 - old behavior (fixed CS representation)
//              1 - fully random CS output
//
//------------------------------------------------------------------------------
//

module DW02_tree( INPUT, OUT0, OUT1 );

// parameters
parameter integer num_inputs = 8;
parameter integer input_width = 8;
parameter integer verif_en = 1;


//-----------------------------------------------------------------------------
// ports
input [num_inputs*input_width-1 : 0]	INPUT;
output [input_width-1:0]		OUT0, OUT1;

//-----------------------------------------------------------------------------
// synopsys translate_off
reg    [input_width-1:0]		OII0OOOI, O001l0I0;
wire   [input_width-1:0]                out0_rnd_cs_full, out1_rnd_cs_full;
wire   [input_width-1:0]                out_fixed_cs,out_rnd_cs_full;

//-----------------------------------------------------------------------------
  
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
    
    if (num_inputs < 1) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter num_inputs (lower bound: 1)",
	num_inputs );
    end
    
    if (input_width < 1) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter input_width (lower bound: 1)",
	input_width );
    end
    
    if ( (verif_en < 0) || (verif_en > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter verif_en (legal range: 0 to 1)",
	verif_en );
    end
  
    if ( param_err_flg == 1) begin
      $display(
        "%m :\n  Simulation aborted due to invalid parameter value(s)");
      $finish;
    end

  end // parameter_check 


initial begin : verif_en_warning
  if (verif_en < 1)
`ifndef DW_SUPPRESS_WARN
          $display ("WARNING: %m:\n at time = %0t: DW02_tree simulation coverage for its Carry-Save output is not best when verif_en is less than 1!\n    The recommended value for verif_en is 1.", $time);
`endif
end // verif_en_warning

//-----------------------------------------------------------------------------


`protected
8T@]<>.gaN]^FAB@3dPX,EeSN=-cc+)UUVgTO5J/7UX5=(&Kc)CS1)e(GI#O[8>L
9;EH@4aH<IU:3?#TSEOX:4JdQPGa4N,GMOS]8e>QMZ@0CfHI+=Ne_W[M9;c[=4WC
P(;&T8TBR#GQ+e9;MQB(6+b;8bbTE)D^WB8X?@(:<]<A^YX:]#3,g#.1eb:MM/aP
[RN;XCE.L)Q^[2=/RUR35XO>@3QK9+GD6T&\LR>).X5Y+eNgIV3B90&BXLbTdHeW
F<SF(;62db9S08;IEJ9E.A;FM]J7SVOQeH?OYQ3:]P(MDN_Z;/XO<D4E,H:A14.a
T>:Rd1\6\&8F#ZE_cFN]\YL0cOF\D,B-f/+LC\+&&#7+g-T]I.-(Z,6>5GLJJ22c
V)>3[XedRFD(F[BHW1VB+9gC]0V0+/VWL1g<Z=]ZcIU8G25/P,WR74W.E.CCeN4R
?g/1aFd8;_eT//@6c6bd0EAcZdQH>Q606+BdJaZS^ZC^^]f&2X<5/]IA&&T_7;E7
Oe&V8SZ-=-[,].D;f.Z.J+=L_P_6>UaU&.@0/2=UE89T.54@EF:&e)Q8gUgLYaF?
^^dI<7HfP7bGF^gM1T7ZYS7@9b<V18_(2ON(XW.436).>d\C;,Q?.D]&ARW,K7[5
4UdRU-V7XJ2.ZGE?<D(KU@>[7F1dHLZ_ET.@.OA0I=R]QYcdOLUG(F5?)N2[5,dP
_^g:cX0NS7Yf^&DOSFN)9Ggf&W[UR7F=ML_UN#)0@R6dFN?Tf6VEZN^J9Q>6?J-0
Q#-Y<L)N9@4?G968McL,,<Nc<-@M6>.Q#9bK1f>M8WE@]L_@54ZQB,IZ&??0N6M@
dX@M_-=2T?:M\eP+J2b]NK;8O.Q1G<.I6=H)0/f2_E@C4U#SWN;=H_C>H\/&>cb#
F8FDK)\,Q4gF#Y&]7\YT=G6<Aa4V91M^Og5>KT)6RW:9Y67&@]=R6X(&<.?bNR31
/,TCL1H?72O8;9[[X4c;HDf-^RI[;U[>^#dX>3XbXe8;1,47P(,WVcW,d>@90fcg
B:KG^(8Q4LPP[_LPYM-=ERfZaXP,]YZGVMBN.E/WSK,^E6I,=b4EB9\2;3CUP1OU
eF?FNd5T_&/@GVH4(#Y.WE42YTM_)Ic<EIT-4gLeD:;g7eVU;c3SW839>CdFG=;C
Q02BC7ZC8HZ,A+[X5?PH(KAe?XAabAA6]?BT\>LWfE.E_?5aVd3]Tc<cIS9g-gTA
QK7bfDDXY#0E,1O&ZNfNEPF&8/6QPSUL:&;2H\&05e3Dd)1HK#>6KCMAA;LLFI</
^AeJ^[D&5+IK0;:K&1,]+5SQ9MXC:D6a5X4GI9(YZb@5aBS/5O2Y>Y:dLC8:78?6
)Zb_7&H4d>8CV1]Q1&=(:_IHLZg/BHDVR]P-O5>D9fJ,]PR]LVQ;:P_)++.PG6Hf
2HOES+8[F>#c@+RXg=+F4fG-PCVWXYY<O/7(P_L@5PZ2A/d-XE=9;/@Z,bEZ;[9e
U5I,777<XQAAK@G_K+Z\23^,dD:bC^D3I0VPgW)aeB3D7X?NN73VN6TCMd=HDXB]
[1]Ta?L-N39_]UF3&1VU138\/#5@@^(S5QW83e@6D;KFd\L;FEVP@:QS?:.J<-=b
/Bg6JN@7MRBOI-F2eLc,f#^0)Z9=\(7=H3978[-30)5^B=I]I4IFgVb#RL2I0eLC
+XARb_O8V69M7GXFA[ED+d8Qf(UJ7@14f]1<J<&FR6>^60gfS.HUO.OfQ3MOfeM>
Q\H>c>8?06^6]:e6KK),Q:3:_F^+gA]3df)[HWR9O[K;)+d)FJ_SHR]Mg)8@7_0^
/=PS&C#X[bGf6DIgC8Ia(8\Nae3[Y]<g@4,)R.#;G89&#.1#:IZV5(eb7[87.-=X
A=WW;e7O/P[c0M1+@6L=&L3(Leg1GeYE<].4Y3f\[W&E:PE;Lc08Ud4:9EN(T[T;
B4\G;H^4\_;48[d5FQFOeP=Q+XVb[bDP]Qg_1TZQgKL&3Ig0f;fA2@bWF9JB8JXE
X:Ld+Ha_-S.X-<OMN5+CWeH/(-a>S0=@=e>E@YD?.\CKQ&C@/#cM[_e19ZTUX5IW
T1A4CegPVU&>,76>X3O8^R9PZ5>TKb@^D=YG\7DFMP^^b-37OU6ITOS=(9==GIf5
5+VJ8IJZ\RI^b>R3(EG+edEZO^ZP4EC9950]BN278BJ9;1U2cMMT<N4.,19&W5Q)
_+W=Ae>@)\P.VFDFf5-&];&EW]I&A^(J,O\<,cPG1S;D_bO[MV_Bc08ZT<+b(\c1
KVR;I-O:7#N7B1US=X[\gU89YgDc]E+KEZ>?A(aY[eFC&7\SX=-bcF^70[Xa?ZSV
),=2HG]1/SX;0=JMLEU&eFaLGH9a4)W44^RF/_65X\<^#3U@\G5:#Z5G#@6(V21c
#SDS+7(f>()4/\()[6ULZWCZ0Vf<7-XEI;R?)8GNJN_1dT(7PEgXdNK.FU-c1H/f
M/ETSaQA6>2::8XU&\5WD5AJ?#@0MJ\KfD3KX5;Fa@.ORf0,P3[8.5(Hc?DIEL70
G:I6/bEHXeX(E=UD(Ld4M6Q]S,f+0+L.(;P66.(6MSfT[5g74C84)bI&c_MJb;aZ
^?cYM5J9#FES+V:/@,ZC285dO)5].MW>JRH@7]d8J=\/LCM?GX&_8DUAZ?]Q(0XO
g89CdOVe,D=\2d:L,Sd\UA_S;55@;b.Ve--LI@U:a>6X0&4FVO843TB@;@FGTV?X
-gI?OP8OZ8L9A7Qc,(,I2CFA\4W@J@9;gX4Ld)6aEJ_K>KBE9+8@-IU4VK1Q:[7O
JCGSgOc1C1H7EB>4^(I8Q6)>99@]/NO_TH=NRCB3EAUgK\,N.M4>:]-GAS08f@5A
19Ze-74gET&[J-A.dFU-@K\;U?N]2OLPI-QM:H3X17JVPWbME6=.=_[M[Y?60E;D
aBD5CE09.T,>IRT<d,H:52e,X)a0GB?&82GNABT]6(7fbU5cYLP-CdWRYU:RIPBX
F#S7P.Be-C#5&BOW<c0&MQ_aDcV?bM-Bf+Dfg?X7_[8\1PcUBUOP8+=+-;b?Ac].
5N@fR#_gO9(<T5c1J)_3RJ2fQ087HGT7_AOeX,NWNAYbHI4NO(RN?(:QYJaYI\76
,;/TR#\bEK.VdfH:[PIY3)#3Y:(2d8==9-R<Xb4I>=WX8XT?L9Id<:LQFDJ>N(S_
K([R[HFQ5.?6AZ:2LGeA>/TV<G2O[6,N18F.6=[>8R-2<e;cA6Ae\DEB&NaT]F1)
>bO(b9DGXUQL^gWadYHA_.L]a[R-d)W/EU&_)gZC[dWZ\7:]/>9ggL_RCYW0[)B(
PE+F.,g-,H=[f)Y[9+:NG;XLYECe+_-];4IBAP?GZRMe;:[-EXGV]=,9H3Z,F^,2
IBX,<./K50AB8^CdYZ[06G1GOL&8IRe/TOb_G<=#/M<cdKI\(_Y9WRDAU><>\IH4
R_GFICSe2+Kg]3F8PVI;Wc7C]S(T0_AM3^cFY3IEYf8T\,2RDaKA<,Z/K,A6dR_g
4T__\Q]TQDJHUXRC\03M4-Y16/-=K4(dEE6FWdL=E^f.=>WKaX[>fPYGdSCJU@XA
4(SV&?c8I8<WcbZUH\(D&CQf2b_:B8L\<H9,=XK2UUZFfI((FEHZ5:CFUM^f4<PZ
Xa57+X_>/I\M?6g14LEUKJGNOI8;^BL8FH2_+Z+D/gHMAg9c7#KI:a:6(e,5L?V7
W>a5+<@JY#PLUaL-LRfK,#1L=?f#76^2:JS-=2H]#&-]2CGC;5e1HcY9BFW2^E@@
6b_,g+Y8[Q7);)_BYNXSYFX?4HI:DfFMU\[Y[E32Bb2QUB1Z8)UZQE_N,Q.?,E=\
S-3B<AI#2B1,59G]&c+c(a>7.[5ZR>PD1#A+B?6_H#@gM-3K0DF((HJZgY:XdU@8
T_B#[Q/f(2GH3FLFH^2-G\PAPNJ&TI]+GMO6Dg/)?&c=Vb\L5^+Z,18ee[IRS_U_
12^d],)DM.13/@^OBP,Bb@B9(TPO@F?X)>BG>GSd\VZJc1._Ea0GB<H6;W&&Z?6Y
.4A&2WJZ?2S=X96FT/g/79[-:I=1dEF3-_<6KNeB/+SFRaUG]g6/G>eRRRK9]&/4
5=2^^;^_YT<2N[RcKLdBCWA;NG)A:.e:UL\QVN]WX3LT-dc4;MZ374Y0;09cb<[f
6f7[8QKVc6cE4;.CJDbFS2GdF>f2>ETb#QQ2&F:N8-4f;OS._/cfA-BBY-IcBJVf
R0P0QVP2+V2WOK/&O4<P68D[G[_JX^eJCB.b:SC_;D636gJ_+D9I323W<T9>OJ]X
#4+<Ha9.K<aO:WW3LA^aJ)+H8I((4I)cde-\.AE])Nfe9-7e(b\L1[1:NWR=TY>:
e19WdaC-?(,\?b7ZaQ:S;[<X<YL;XO&9=9/ZK_c,LX[.:U-gF?F0O;5]PCYRA1<b
GJXPd:L#eG?^1O;Ugg5/-TX8K2;\<TXT)VY./d1A57;fMN&JGPN[O)g;B@[7VADg
6[dCLN5K9Cb88NJM-^(U>f6IJcS#U<;CA=8Q2+1C6PPMa6-5U7W-0[ULAbHW/Y+&
[X<2Q?/YCLfTW[=[GI3JHDGNYgC&68HZe=.ROgV8d=Q/AA1bIL+@&ZQ0S3NM9JRF
=FN=BASY(_)GO^S1>?1C(GGN8$
`endprotected


// synopsys translate_on

endmodule
