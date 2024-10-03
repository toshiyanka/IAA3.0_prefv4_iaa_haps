////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 2009 - 2020 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Doug Lee       2/6/09
//
// VERSION:   Verilog Simulation Model
//
// DesignWare_version: 87d8bbaa
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
// ABSTRACT: Low Power Pipelined Modified Hamming Code Error Correction/Detection Simulation Model 
//
//           This module supports data widths up to 8178 using
//           14 check bits
//
//
//  Parameters:     Valid Values    Description
//  ==========      ============    =============
//  data_width       8 to 8178      default: 8
//                                  Width of 'datain' and 'dataout'
//
//  chk_width         5 to 14       default: 5
//                                  Width of 'chkin', 'chkout', and 'syndout'
//
//   rw_mode           0 or 1       default: 1
//                                  Read or write mode
//                                    0 => read mode
//                                    1 => write mode
//
//   op_iso_mode      0 to 4        default: 0
//                                  Type of operand isolation
//                                    If 'in_reg' is '1', this parameter is ignored...effectively set to '1'.
//                                    0 => Follow intent defined by Power Compiler user setting
//                                    1 => no operand isolation
//                                    2 => 'and' gate isolaton
//                                    3 => 'or' gate isolation
//                                    4 => preferred isolation style: 'and' gate
//
//   id_width        1 to 1024      default: 1
//                                  Launch identifier width
//
//   in_reg           0 to 1        default: 0
//                                  Input register control
//                                    0 => no input register
//                                    1 => include input register
//
//   stages          1 to 1022      default: 4
//                                  Number of logic stages in the pipeline
//
//   out_reg          0 to 1        default: 0
//                                  Output register control
//                                    0 => no output register
//                                    1 => include output register
//
//   no_pm            0 to 1        default: 1
//                                  Pipeline management usage
//                                    0 => Use pipeline management
//                                    1 => Do not use pipeline management - launch input
//                                          becomes global register enable to block
//
//   rst_mode         0 to 1        default: 0
//                                  Control asynchronous or synchronous reset 
//                                  behavior of rst_n
//                                    0 => asynchronous reset
//                                    1 => synchronous reset 
//
//
//  Ports        Size    Direction    Description
//  =====        ====    =========    ===========
//  clk          1 bit     Input      Clock Input
//  rst_n        1 bit     Input      Reset Input, Active Low
//
//  datain       M bits    Input      Input data bus
//  chkin        N bits    Input      Input check bits bus
//
//  err_detect   1 bit     Output     Any error flag (active high)
//  err_multiple 1 bit     Output     Multiple bit error flag (active high)
//  dataout      M bits    Output     Output data bus
//  chkout       N bits    Output     Output check bits bus
//  syndout      N bits    Output     Output error syndrome bus
//
//  launch       1 bit     Input      Active High Control input to launch data into pipe
//  launch_id    Q bits    Input      ID tag for operation being launched
//  pipe_full    1 bit     Output     Status Flag indicating no slot for a new launch
//  pipe_ovf     1 bit     Output     Status Flag indicating pipe overflow
//
//  accept_n     1 bit     Input      Flow Control Input, Active Low
//  arrive       1 bit     Output     Product available output 
//  arrive_id    Q bits    Output     ID tag for product that has arrived
//  push_out_n   1 bit     Output     Active Low Output used with FIFO
//  pipe_census  R bits    Output     Output bus indicating the number
//                                   of pipeline register levels currently occupied
//
//     Note: M is the value of "data_width" parameter
//     Note: N is the value of "chk_width" parameter
//     Note: Q is the value of "id_width" parameter
//     Note: R is equal to the larger of '1' or ceil(log2(in_reg+stages+out_reg))
//
//
//-----------------------------------------------------------------------------
// Modified:
//     LMSU 02/17/15  Updated to eliminate derived internal clock and reset signals
//     RJK  10/07/15  Updated for compatibility with VCS NLP feature
//     RJK  07/14/17  Updated UPF specific code (STAR 9001217597)
//     RJK  07/24/19  Updated to eliminate lint warnings (STAR 9001489004)
//
////////////////////////////////////////////////////////////////////////////////
module DW_lp_piped_ecc(
        clk,            // Clock input
        rst_n,          // Reset

        datain,         // Input data bus
        chkin,          // Input check bits bus (for read or scrub)

        err_detect,     // Any error flag (active high)
        err_multiple,   // Multiple bit error flag (active high)
        dataout,        // Output data bus
        chkout,         // Output check bits bus
        syndout,        // Output error syndrome bus

        launch,         // Launch data into pipe input
        launch_id,      // ID tag of data launched input
        pipe_full,      // Pipe slots full output (used for flow control)
        pipe_ovf,       // Pipe overflow output

        accept_n,       // Take product input (flow control)
        arrive,         // Data arrival output
        arrive_id,      // ID tag of arrival product output
        push_out_n,     // Active low output used when FIFO follows
        pipe_census     // Pipe stages occupied count output
        );

parameter integer data_width = 8;  // RANGE 1 to 8178
parameter integer chk_width = 5;   // RANGE 5 to 14
parameter integer rw_mode = 1;     // RANGE 0 to 1
parameter integer op_iso_mode = 0; // RANGE 0 to 4
parameter integer id_width = 1;    // RANGE 1 to 1024
parameter integer in_reg = 0;      // RANGE 0 to 1
parameter integer stages = 4;      // RANGE 1 to 1022
parameter integer out_reg = 0;     // RANGE 0 to 1
parameter integer no_pm = 1;       // RANGE 0 to 1
parameter integer rst_mode = 0;    // RANGE 0 to 1




input                          clk;         // Clock Input
input                          rst_n;       // Reset
input  [data_width-1:0]        datain;        // Data input
input  [chk_width-1:0]         chkin;         // Check bits input

output                         err_detect;    // Error detect output
output                         err_multiple;  // Multiple errors detected output
output [data_width-1:0]        dataout;       // Data output
output [chk_width-1:0]         chkout;        // Check bits output
output [chk_width-1:0]         syndout;       // Syndrome output

input                          launch;      // Launch data into pipe
input  [id_width-1:0]          launch_id;   // ID tag of data launched
output                         pipe_full;   // Pipe slots full (used for flow control)
output                         pipe_ovf;    // Pipe overflow

input                          accept_n;    // Take product (flow control)
output                         arrive;      // Product arrival
output [id_width-1:0]          arrive_id;   // ID tag of arrival product
output                         push_out_n;  // Active low output used when FIFO follows

output [(((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>256)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>4096)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>16384)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>32768)?16:15):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>8192)?14:13)):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>1024)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>2048)?12:11):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>512)?10:9))):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>16)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>64)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>128)?8:7):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>32)?6:5)):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>4)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>8)?4:3):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>2)?2:1)))))-1:0]       pipe_census; // Pipe Stages Occupied Output

// synopsys translate_off

wire  [data_width-1:0]           O00IlO0I;
wire  [chk_width-1:0]            IOOI1O00;
wire                             O0lI0O1O;
wire  [id_width-1:0]             O10O0O10;
wire                             I1O0O1O1;

wire  [data_width-1:0]           O1110110;
wire  [chk_width-1:0]            OOOl1101;
wire  [data_width-1:0]           O1II11O1;
wire  [data_width-1:0]           OII1OOl0;
wire  [chk_width-1:0]            O01I11IO;
wire  [chk_width-1:0]            I01OO00O;

wire  [data_width-1:0]           O001IOl1;
wire  [chk_width-1:0]            I101OO10;
wire  [data_width-1:0]           I01ll0OO;
wire  [chk_width-1:0]            Ol0I0lO1;

wire  [data_width-1:0]           I10IO1Ol;
wire  [chk_width-1:0]            OI1l0l00;
wire  [chk_width-1:0]            O010010O;
wire                             lO00l00I;
wire                             I0O11O11;

wire  [data_width-1:0]           O0llOO1O;
wire  [chk_width-1:0]            IO1lO0l0;
wire  [chk_width-1:0]            II000OOO;
wire                             I10O110O;
wire                             IO100O1I;

wire  [(((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)-1:0]     O00l0I1O;
wire                             OOOOlIO1;
reg   [(((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)-1:0]     O10l0O0O;

wire                             O010lO10;
wire                             OOO1O1OO;
wire                             I1O001OO;
wire  [id_width-1:0]             IOO11O11;
wire                             OO1lIIO1;
wire  [(((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)-1:0]     O00101I1;
wire  [(((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>256)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>4096)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>16384)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>32768)?16:15):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>8192)?14:13)):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>1024)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>2048)?12:11):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>512)?10:9))):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>16)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>64)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>128)?8:7):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>32)?6:5)):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>4)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>8)?4:3):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>2)?2:1)))))-1:0]          O1O1IlO0;

wire                             l1I101lO;
wire                             OO1IOO00;
reg                              I10l1lO0;
wire                             O0O1011l;
wire  [id_width-1:0]             l0OOl11l;
wire                             I0IOIl1O;
wire  [(((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)-1:0]     IIO10010;
wire  [(((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>256)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>4096)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>16384)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>32768)?16:15):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>8192)?14:13)):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>1024)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>2048)?12:11):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>512)?10:9))):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>16)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>64)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>128)?8:7):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>32)?6:5)):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>4)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>8)?4:3):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>2)?2:1)))))-1:0]          OOO0Ol0O;

wire  [id_width-1:0]             OlI0OIOI;


  assign O00IlO0I     = (datain | (datain ^ datain));
  assign IOOI1O00      = (chkin | (chkin ^ chkin));
  assign O0lI0O1O     = (launch | (launch ^ launch));
  assign O10O0O10  = (launch_id | (launch_id ^ launch_id));
  assign I1O0O1O1   = (accept_n | (accept_n ^ accept_n));



`ifdef UPF_POWER_AWARE
`protected
]F:.A09:>T+EMJAe_P<-g\GN/LJ:V[Df2:3gT)P6FLZ_f3d6&&SA/)9Xcaa+PgVK
4-\[R52,3/\OTd_7>@V2AA^;&&;CR4;JEF.^B^]1cYg[+d1QGYeeO+#&GC28f5@c
dA6DAXITT^Se4T[=]G1;\RHOdG8PVd78.[&4R/#fSP)3Y).2ENE/LDV-RVYZb0bb
?gAT&K&53a-/Yd82J;^^OL^>NAb-P^8gOG)>2@^WEIbPD@CCNC_AA@52^<#WO+Y?
cUd9J78bIGT+(#99f9d8PM>DW1O:#<B^J2cK&UFYK3g_;.JgA?MgM>5b78?XT3(A
a+/=P-_eE2T^J1eQ9_ZH#;V;Cdbc7MAM=FVH1Ye54IBU-K]_QgFDD?.TL-;&YaUA
KOLI(RW71+OC=:F^RX209,?8U+8gI1:0_T/WUNXL6T0Y]G)HP5=XMRA92d6=1aKL
1613A([-Z_W(75WD0)EZd;QW]M93YQ/01/PGbB<g_f?&G9:&\3WLKO9)a,D[M(e3
].L&<\YcKG&B[EaJC4U@62CZUT,\e8/d3cX:[^-/^[AL5G6S.>gMEYXfH4:E7A=B
J7BQL1dW=DCX8O[5d-F&?6KH;P#NAa+;g,AJ=7[>:QHQ4R^W8SYHTCH=N,#)fS0+
7)TbIV62[+LPeEB)--WVQ\V;SAB^-TT>F-[g1XZ:,>.V>g@/T7=TCS4J+fCI3H7>
+HA_B](#eLGGD._-U8OMAZ,f:BSHWA^2=U07?bNB:)NO_+[)G9Z493VJNeY]PZeK
07U\KE<P\GeTd2G:4WJ_(b#,P.L#BK2FT>OIga:2]YRg2+:=1D\.&VR65gVSTcN#
[>OJ;L6?MaeM)CDQ0L#df[S=KE/XB?POeSS)=2;\<@;2RMR?B\PP^dZ7NH8RK6G(
5-S77+G]9b3F3._22fE@YbaEVeYb8M_A@R/23CL<=dN&gEbDT[9B+X/E,RQ8H/V3
.4E(:><A6V@c4[P8FGYc7##0XK1#QX662#OXg.JX=KgB/(e)R/8M;E6VT(DH0N[&
M=,2-^F:^O\8W4QQ]DQb<._beP;Q5-J[B##)3-WP87Z6H:JCC_aCX.V]881M:0(;
?Y-<U9F:7@RWK5VJW<&8b#ZZB;O9O761.Z4BeM>J,5gG_D86^bM6c&Qc\OB<:?/3
?Q=6,GXF3C,8HPBQa)OTPFUQLDdBebIU_13\PS##a2).E370ZJ_E33];BCB&8@N8
Z_X;9J<(0E8MX;dEJ1EIcX8BbVEdOg/?\H3#AXR=>TBP,NY@DWJ]M/25AP-XA)[B
ZC2ZXD)L_>WR<]9.c2c7c9L[3()###UO7CCR5X0=Z@G,Q9VGPH2<S30_>.D&WdYQ
?DC<?aNfD&3C_McV73060/,U_G(8(@,&B&_]LGW-&V=AF<e2]7WFcR7#81L2682f
KS98[5ZPbVMDL7R_9_#5WU6dJ7aM6=eJ6T(SA61JI(@V2f&0/g;R6=+35?aT&=-J
O:ZZb+59[S&/7#g3^[VTO3(NV^9F18;d4bd_[7\PGB.H7f?/AWFU>[Z__P(?G/eb
<gJS;:.3]VFQY8Q#<e5#^=<I.G\dJM9)Jg0#VCO=<e@-G?4E(_C3TcK3FX]_4gBX
5)>.\+feb16/,NX4Na^a=?,UW?6_a)S>+Z9\,cLMf:/IYVCM\->ZPOa&IUOVQ[Rf
+g<a;H2Db&:Rad/3\GX/(a&#:6dL:+eVA;Q,IA3.bP^A4/^AMUWReF/YcfDb(C9#
MM^IY0X13P]-->BQ58[.Cg35D-A]<ZK5TR\)0H7D4DFA3.95F8e._E^<[2M]<9U_
-5+:HO[?WVU4Z=(9E#&LHROeb]d&)bACX[]H2EA+6;Ic2IEc9,@Y0P]]CN+C:3&&
))^/e;7UI9MLG#(+9bN[/)C[=]FOeCLGEKW&@0\[f=9T=4_F,.]0,Z]fdI8V(eQW
9SC)D&f\VCI5Z3_1&?Sb1H:)L1?3:VD&KO)XcfX?OTB3b7^_2^7GORJ(&EL1>SY<
@,QLMg4aCbV\G(#]&3JV2cb3N3]I#2<A<]=A?+\<8\\N&fZD7VS-b2,53\?.a>>I
e?:+BNHP[=&&Q=eP^HTZPM7+\=S_Z#[V4eOOL.D3\(I=+471KR6WZ4AQ6#=X7>5W
G?G@00,04UX5=\P<IF(E,,Z)=U>:S_=QP4d.=ZIeaGGV/M:Sb3G3\KgU]R.HN@3+
U:F,S+LC00?INCL_:1\1,;L0=DRV6R6Ed9+,gG5Z]FRQGN]():a0P]bgcZJA^[LA
D/V@DRQL]P)WSY\4,<cFABNTZ#GeBC.gJ:WZY[EI#IL/[B24<>-f#ZB,7g[/5JZ_
3D64Mb:(6WP>6@ERUcO3KD-5_gggdRI[#[<DVe@)VH78W/e4H0S@C&AQF&#42INe
FLO@0FU?_f<80@Z_FLb[>cRWLA31/NRKM0LT^3A(+#Q4.aQ8a=J+5e+]2YD[cS\]
2+DM?9A#fTE2>5(?Q@_/(cQ@[&TE4ZF31&><GX4::IFC2;<#+:ERf0_P0_P6.A?O
@,/DW6/>/GX1fB8YLe)DaUTCf04eLe/99SZ?O.0J:)H@I2Cg9OJDFV#X8C+4[(-Z
W]W]U4(.PU9I&KKDI?F&+\ca1RN/&JP7J1@)2@^]<6SMXCb1MI+(G\;Le<+-aMUe
ZXKRZYO,>2FZJJ_\c@d2]?Pd(,ON_2E7F\I.+X52.@bBDQ<U[<+:R=S-V<&+N=#T
-_/RV@^:8:\,>FJVW@[KI9.K5<5[T4R<\X]I:WZ#GB2RS=&g9CWTQH+JGTg.0bWd
6-?HZQ#Zg_>)>=G\+@f)f1BBIY-fTdPeZeLeU3X8A8Qf^)5W8UW[05K.Y.RefSP]
Ae;Y]b,X@C^F,bZ3U-9Z5=64,SD[LY()45@,M-_]?+3Y>L2XbMRK=Xc@:?[/I.5:
#QWD>QG-UU>a860D4Q=MKQR5<>7<I>M&W^?GPeUPNC=<SALU#ad[7S9_M(RR=Q_c
25[D.BGJ0=EZ)gP51#2ZQbYePY\)[VfPHD@Y53[]YG1b4P4(cY-UeGZLPWfT65)H
/c@6UYW:geB:Mc):cf6&>:)>25Bf>,AV5)1bb/-S91;;Hb>AC9U]FL.GSf:dBKF3
XReT)/84?Ec6V;8;3GG@g;bW_OT4R8F\G.)EV6&IJH09GaI[T#VI):gPCdg.:X3D
^8dZXK<NXLYLgbK4Q3=?J8H-1XeC2A(]/@F;>SRgJe2dF[aX-f:>>eL+C?0BJ=A4
?E:ccd>O8gL64RC4]KI&5]14c(@ZU?TSaGX-a26MLDK<Z/OUO2=fB/E,^[3WHULc
EQ0]9?]J/Of/OT)e9b37O]6Aa<)J0E3_MKIPA6+PW&-<Je\S6]U:9X]9g1CVCf1C
D4^7M.<ZQN^BB#KaOZERA:@O2S/W8[,/CS9a#X4?B=:V]/=+.a]GZRX::L2)O^LV
dM^1SCO=c<@_5OW6L5ebVH[ELaUVSZ(9B]-QE.;3B;B^V2YC/W7M^\OIHP(O?(LJ
9KcF1:_Wa;_V#c_P_+V-WL&,F1OG_XS>eN#_3]5fV>J9R2D.>ETeKcA2Z&M409#d
e99U77d8af2f4/)GfSE5;K7<)fP]94J-MTN4W(^eY6^;M<0DC+SYDcT5=<3+bZR6
##c&5X[1Q7\aVI^?W?:K9bOU1+7,[>ePIGUSgUV8KW:5M]F6<)]c)NP/:M\I-V,>
KL1@,811D6L;R,KN=?aX>6M#H0/BW,Y1U5a^=+LR_3_FY-2KBO=?[1LBFE0;aM)>
eSC;aFgGMQ,MNEI98(QG1_NC.>JG&+GcXRf>)&-F1T61&(HW725M^JLM2+:>Q]f5
6R3>cLG&K6WNgOB:dJ)=P<AJBP#1cV0cI&K+#Z]V\)?1DW[-D@8QcAd5=RG.@f7?
FC5,1QAa>-Oa3:\AK[>0XST]R\I1_?E7a]d<7Y?.?[Y+JAgC8VbLFdJ&/^/:c9/6
ZLQN(V(G,R3J+eN1OO\4(dQ@SS+][<-?fNOA7G#>4Z-96S]BV-[XfW#[7;YUBU@2
aJ35@8GS6d+>;PGCGgK&\b0778,f.fM7;/32BMPOe-96-2bH#IVf8YO);VZ(9L+:
TXBHc7cObI62@P#WP7Y1_UDTL:[H=f5Kcbg6-9P;,E?:]<BaN,56W99F(eP:c1NS
L7D0P[0C_83aOXK1&:EQSB.Ya9U2AB6b,1MN=1M^C(07gQ0BfTRF\adM()GE<c<&
eD-S#+M;e?[:;-3D-g^K/_HE3]b56W/ZH6:@,[0_LcJPZ?D]LG5P]J:_7e3Z=QZE
;dbeE+YHUFW;N/G&&Hg>A6[[E.@bWfO#0@aEF4]AWMXgF0K[DK2NUL]\/f0YP_K>
G;^;0eJEJ56AO.844NGL4c&8[<-RZNM)eVVAC=Ng+^O1M?)E<Q=Hb^<]aH:LR-QF
g/F[[IY[9B\Ub0]4@^d&-Y^1fgWQ=4KaP\Bcg#f]P[ZafI[c4Ef<T&Ie@PR7L3:^
-&f2e5Hg3&9F)W#6S45OOS]VdaOVda:Q+:82^;^Y6O7(.JG&:S5^<Q-Y<Z9.O(3K
FMU?\eUbY<Hb/Q7e5-PBgTVJeX0DDR53B__M6\L/,bIJb1E<=_Ed71@NL+F/B?;)
8:)_MW>:J@YTN&2:XA/6HM/@6HH0L&PZ+4:U=5=SMES@?5)+X?GXLS]G<B#-CX5T
L1_-ee7e1KAg^Qfe^feP@L2f4NFW><XR9/aG?=XZ>45+9L_@GXA@E^MaG&FL1M2d
Tb2Aa6/VA19GGUY>6N^B[VHKeN7;R+W#1^[U>gY\&CS8_e(#eG7&&#V:>9c7HXcL
dVfVfg/5a:D@]IQZ)Z;L&<PdQ0WDY[W=gXc1aY2bT9.F_35NM-M4SWX?0g<::U8:R$
`endprotected

`else

 integer OI11IO001, O1IO11100;
 integer O1O00I001, IlOO01011, IIl1lll10;
 integer lO0IlIOl1, O1I1IO0IO, l1O0O110I, O0l1O10l0;
 integer OIOOl1I00, O0Olll0O0, l1IO10001;
 integer II010O0O1,  lI1O010l1, IOI001111;
 integer O0O1O11OO, O001O1Ol1, OO0O101O0, OlOOIO10I;
 integer lOlIIl001, I11000011, lOO0lO1O0, II1Il0l1l, l11O1O1II;
 integer Ill11O01O [0:(1<<chk_width)-1];
 integer O1111l11O [0:(1<<(chk_width-1))-1];
 reg  [chk_width-1:0] II0O00OIl;
 reg  [data_width-1:0]   IIO0O111I;
  reg [data_width-1:0] OO011110l [0:chk_width-1];
`endif

 wire [chk_width-1:0] OO01OO00I;
 reg  [data_width-1:0] O00ll11OO;
 reg  [chk_width-1:0] O000001OO;
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
    lOlIIl001 = OI11IO001 << chk_width;
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

    for (IOI001111=0 ; (IOI001111 < II1Il0l1l) && (lO0IlIOl1 < data_width) ; IOI001111=IOI001111+1) begin
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

        for (OO0O101O0=O0O1O11OO ; (OO0O101O0 < (O0O1O11OO+O0Olll0O0)) && (lO0IlIOl1 < data_width) ; OO0O101O0=OO0O101O0+1) begin
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
        for (OO0O101O0=O0O1O11OO+OIOOl1I00 ; (OO0O101O0 >= O0O1O11OO) && (lO0IlIOl1 < data_width) ; OO0O101O0=OO0O101O0-1) begin
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

    for (OO0O101O0=0 ; OO0O101O0<chk_width ; OO0O101O0=OO0O101O0+1) begin
      IIO0O111I = {data_width{1'b0}};
      for (lO0IlIOl1=0 ; lO0IlIOl1 < data_width ; lO0IlIOl1=lO0IlIOl1+1) begin
        if (O1111l11O[lO0IlIOl1] & (1 << OO0O101O0)) begin
          IIO0O111I[lO0IlIOl1] = 1'b1;
        end
      end
      OO011110l[OO0O101O0] = IIO0O111I;
    end

    l11O1O1II = l1IO10001 - 1;

    for (OO0O101O0=0 ; OO0O101O0<chk_width ; OO0O101O0=OO0O101O0+1) begin
      Ill11O01O[OI11IO001<<OO0O101O0] = data_width+OO0O101O0;
    end

    OlOOIO10I = l1IO10001;
  end
`endif
  
  
  always @ (O1110110) begin : OI10l11ll_PROC
    
    for (O1IO11100=0 ; O1IO11100 < chk_width ; O1IO11100=O1IO11100+1) begin
      II0O00OIl[O1IO11100] = ^(O1110110 & OO011110l[O1IO11100]) ^
				((O1IO11100<2)||(O1IO11100>3))? 1'b0 : 1'b1;
    end
  end // OI10l11ll_PROC
  
  assign OO01OO00I = II0O00OIl ^ OOOl1101;

  always @ (OO01OO00I) begin : l1Il10O1l_PROC
    if (rw_mode[0] != 1'b1) begin
      if ((^(OO01OO00I ^ OO01OO00I) !== 1'b0)) begin
        O000001OO = {chk_width{1'bx}};
        O00ll11OO = {data_width{1'bx}};
        IOO11O1I0 = 1'bx;
        OI1l0OOOI = 1'bx;
      end else begin
        O000001OO = {chk_width{1'b0}};
        O00ll11OO = {data_width{1'b0}};
        if (OO01OO00I === {chk_width{1'b0}}) begin
          IOO11O1I0 = 1'b0;
          OI1l0OOOI = 1'b0;
        end else if (Ill11O01O[OO01OO00I+OlOOIO10I] == l11O1O1II) begin
          IOO11O1I0 = 1'b1;
          OI1l0OOOI = 1'b1;
        end else begin
          IOO11O1I0 = 1'b1;
          OI1l0OOOI = 1'b0;
          if (Ill11O01O[OO01OO00I+OlOOIO10I] < data_width)
            O00ll11OO[Ill11O01O[OO01OO00I+OlOOIO10I]] = 1'b1;
          else
            O000001OO[Ill11O01O[OO01OO00I+OlOOIO10I]-data_width] = 1'b1;
        end
      end
    end
  end // l1Il10O1l_PROC

  assign O1110110 = (rw_mode == 1) ? O1II11O1 : OII1OOl0;
  assign OOOl1101  = (rw_mode == 1) ? O01I11IO  : I01OO00O;

  assign O001IOl1 = O1110110;
  assign I101OO10  = II0O00OIl;
reg   [(data_width+chk_width)-1 : 0]     O0110101;
reg   [(data_width+chk_width)-1 : 0]     OI0000O0 [0 : ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2))];




generate
  if (rst_mode==0) begin
    always @ (posedge clk or negedge rst_n) begin : PROC_pl_in_registers_wr_mode
      integer lO01IO0O;

      if (rst_n === 1'b0) begin
        O0110101 <= {(data_width+chk_width){1'b0}};
      end else if (rst_n === 1'b1) begin
        if (OOOOlIO1 === 1'b1)
          O0110101<= {O00IlO0I, IOOI1O00};
        else if (OOOOlIO1 !== 1'b0)
          O0110101 <= ((O0110101 ^ {O00IlO0I, IOOI1O00}) & {(data_width+chk_width){1'bx}}) ^ O0110101;
      end else begin
        O0110101 <= {(data_width+chk_width){1'bx}};
      end
    end
  end else begin
    always @ (posedge clk) begin : PROC_pl_in_registers_wr_mode
      integer lO01IO0O;

      if (rst_n === 1'b0) begin
        O0110101 <= {(data_width+chk_width){1'b0}};
      end else if (rst_n === 1'b1) begin
        if (OOOOlIO1 === 1'b1)
          O0110101<= {O00IlO0I, IOOI1O00};
        else if (OOOOlIO1 !== 1'b0)
          O0110101 <= ((O0110101 ^ {O00IlO0I, IOOI1O00}) & {(data_width+chk_width){1'bx}}) ^ O0110101;
      end else begin
        O0110101 <= {(data_width+chk_width){1'bx}};
      end
    end
  end
endgenerate


  assign {O1II11O1, O01I11IO} = (in_reg == 0)? {O00IlO0I, IOOI1O00} : O0110101;




generate
  if (rst_mode==0) begin
    always @ (posedge clk or negedge rst_n) begin : PROC_pl_registers_wr_mode
      integer lO01IO0O;

      if (rst_n === 1'b0) begin
        for (lO01IO0O=0 ; lO01IO0O <= ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          OI0000O0[lO01IO0O] <= {(data_width+chk_width){1'b0}};
        end
      end else if (rst_n === 1'b1) begin
        for (lO01IO0O=0 ; lO01IO0O <= ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          if (O10l0O0O[lO01IO0O] === 1'b1)
            OI0000O0[lO01IO0O] <= (lO01IO0O == 0)? {O001IOl1, I101OO10} : OI0000O0[lO01IO0O-1];
          else if (O10l0O0O[lO01IO0O] !== 1'b0)
            OI0000O0[lO01IO0O] <= ((OI0000O0[lO01IO0O] ^ ((lO01IO0O == 0)? {O001IOl1, I101OO10} : OI0000O0[lO01IO0O-1]))
          		      & {(data_width+chk_width){1'bx}}) ^ OI0000O0[lO01IO0O];
        end
      end else begin
        for (lO01IO0O=0 ; lO01IO0O <= ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          OI0000O0[lO01IO0O] <= {(data_width+chk_width){1'bx}};
        end
      end
    end
  end else begin
    always @ (posedge clk) begin : PROC_pl_registers_wr_mode
      integer lO01IO0O;

      if (rst_n === 1'b0) begin
        for (lO01IO0O=0 ; lO01IO0O <= ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          OI0000O0[lO01IO0O] <= {(data_width+chk_width){1'b0}};
        end
      end else if (rst_n === 1'b1) begin
        for (lO01IO0O=0 ; lO01IO0O <= ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          if (O10l0O0O[lO01IO0O] === 1'b1)
            OI0000O0[lO01IO0O] <= (lO01IO0O == 0)? {O001IOl1, I101OO10} : OI0000O0[lO01IO0O-1];
          else if (O10l0O0O[lO01IO0O] !== 1'b0)
            OI0000O0[lO01IO0O] <= ((OI0000O0[lO01IO0O] ^ ((lO01IO0O == 0)? {O001IOl1, I101OO10} : OI0000O0[lO01IO0O-1]))
          		      & {(data_width+chk_width){1'bx}}) ^ OI0000O0[lO01IO0O];
        end
      end else begin
        for (lO01IO0O=0 ; lO01IO0O <= ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          OI0000O0[lO01IO0O] <= {(data_width+chk_width){1'bx}};
        end
      end
    end
  end
endgenerate

  assign {I01ll0OO, Ol0I0lO1} = (stages+out_reg == 1)? {O001IOl1, I101OO10} : OI0000O0[((stages-1+out_reg < 1)? 0 : (stages+out_reg-2))];


  assign I10IO1Ol      = O1110110 ^ O00ll11OO;
  assign OI1l0l00       = OOOl1101 ^ O000001OO;
  assign O010010O      = OO01OO00I;
  assign lO00l00I   = IOO11O1I0;
  assign I0O11O11 = OI1l0OOOI;
reg   [(data_width+chk_width)-1 : 0]     l1l0O01I;
reg   [(data_width+(chk_width*2)+2)-1 : 0]     OIOOl10l [0 : ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2))];




generate
  if (rst_mode==0) begin
    always @ (posedge clk or negedge rst_n) begin : PROC_pl_in_registers_rd_mode
      integer lO01IO0O;

      if (rst_n === 1'b0) begin
        l1l0O01I <= {(data_width+chk_width){1'b0}};
      end else if (rst_n === 1'b1) begin
        if (OOOOlIO1 === 1'b1)
          l1l0O01I<= {O00IlO0I, IOOI1O00};
        else if (OOOOlIO1 !== 1'b0)
          l1l0O01I <= ((l1l0O01I ^ {O00IlO0I, IOOI1O00}) & {(data_width+chk_width){1'bx}}) ^ l1l0O01I;
      end else begin
        l1l0O01I <= {(data_width+chk_width){1'bx}};
      end
    end
  end else begin
    always @ (posedge clk) begin : PROC_pl_in_registers_rd_mode
      integer lO01IO0O;

      if (rst_n === 1'b0) begin
        l1l0O01I <= {(data_width+chk_width){1'b0}};
      end else if (rst_n === 1'b1) begin
        if (OOOOlIO1 === 1'b1)
          l1l0O01I<= {O00IlO0I, IOOI1O00};
        else if (OOOOlIO1 !== 1'b0)
          l1l0O01I <= ((l1l0O01I ^ {O00IlO0I, IOOI1O00}) & {(data_width+chk_width){1'bx}}) ^ l1l0O01I;
      end else begin
        l1l0O01I <= {(data_width+chk_width){1'bx}};
      end
    end
  end
endgenerate


  assign {OII1OOl0, I01OO00O} = (in_reg == 0)? {O00IlO0I, IOOI1O00} : l1l0O01I;




generate
  if (rst_mode==0) begin
    always @ (posedge clk or negedge rst_n) begin : PROC_pl_registers_rd_mode
      integer lO01IO0O;

      if (rst_n === 1'b0) begin
        for (lO01IO0O=0 ; lO01IO0O <= ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          OIOOl10l[lO01IO0O] <= {(data_width+(chk_width*2)+2){1'b0}};
        end
      end else if (rst_n === 1'b1) begin
        for (lO01IO0O=0 ; lO01IO0O <= ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          if (O10l0O0O[lO01IO0O] === 1'b1)
            OIOOl10l[lO01IO0O] <= (lO01IO0O == 0)? {I10IO1Ol, OI1l0l00, O010010O, lO00l00I, I0O11O11} : OIOOl10l[lO01IO0O-1];
          else if (O10l0O0O[lO01IO0O] !== 1'b0)
            OIOOl10l[lO01IO0O] <= ((OIOOl10l[lO01IO0O] ^ ((lO01IO0O == 0)? {I10IO1Ol, OI1l0l00, O010010O, lO00l00I, I0O11O11} : OIOOl10l[lO01IO0O-1]))
          		      & {(data_width+(chk_width*2)+2){1'bx}}) ^ OIOOl10l[lO01IO0O];
        end
      end else begin
        for (lO01IO0O=0 ; lO01IO0O <= ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          OIOOl10l[lO01IO0O] <= {(data_width+(chk_width*2)+2){1'bx}};
        end
      end
    end
  end else begin
    always @ (posedge clk) begin : PROC_pl_registers_rd_mode
      integer lO01IO0O;

      if (rst_n === 1'b0) begin
        for (lO01IO0O=0 ; lO01IO0O <= ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          OIOOl10l[lO01IO0O] <= {(data_width+(chk_width*2)+2){1'b0}};
        end
      end else if (rst_n === 1'b1) begin
        for (lO01IO0O=0 ; lO01IO0O <= ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          if (O10l0O0O[lO01IO0O] === 1'b1)
            OIOOl10l[lO01IO0O] <= (lO01IO0O == 0)? {I10IO1Ol, OI1l0l00, O010010O, lO00l00I, I0O11O11} : OIOOl10l[lO01IO0O-1];
          else if (O10l0O0O[lO01IO0O] !== 1'b0)
            OIOOl10l[lO01IO0O] <= ((OIOOl10l[lO01IO0O] ^ ((lO01IO0O == 0)? {I10IO1Ol, OI1l0l00, O010010O, lO00l00I, I0O11O11} : OIOOl10l[lO01IO0O-1]))
          		      & {(data_width+(chk_width*2)+2){1'bx}}) ^ OIOOl10l[lO01IO0O];
        end
      end else begin
        for (lO01IO0O=0 ; lO01IO0O <= ((stages-1+out_reg < 1)? 0 : (stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          OIOOl10l[lO01IO0O] <= {(data_width+(chk_width*2)+2){1'bx}};
        end
      end
    end
  end
endgenerate

  assign {O0llOO1O, IO1lO0l0, II000OOO, I10O110O, IO100O1I} = (stages+out_reg == 1)? {I10IO1Ol, OI1l0l00, O010010O, lO00l00I, I0O11O11} : OIOOl10l[((stages-1+out_reg < 1)? 0 : (stages+out_reg-2))];



reg   [id_width-1 : 0]     lO00O01l [0 : ((in_reg+stages-1+out_reg < 1)? 0 : (in_reg+stages+out_reg-2))];





generate
  if (rst_mode==0) begin
    always @ (posedge clk or negedge rst_n) begin : PROC_pl_registers_id
      integer lO01IO0O;

      if (rst_n === 1'b0) begin
        for (lO01IO0O=0 ; lO01IO0O <= ((in_reg+stages-1+out_reg < 1)? 0 : (in_reg+stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          lO00O01l[lO01IO0O] <= {id_width{1'b0}};
        end
      end else if (rst_n === 1'b1) begin
        for (lO01IO0O=0 ; lO01IO0O <= ((in_reg+stages-1+out_reg < 1)? 0 : (in_reg+stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          if (O00l0I1O[lO01IO0O] === 1'b1)
            lO00O01l[lO01IO0O] <= (lO01IO0O == 0)? O10O0O10 : lO00O01l[lO01IO0O-1];
          else if (O00l0I1O[lO01IO0O] !== 1'b0)
            lO00O01l[lO01IO0O] <= ((lO00O01l[lO01IO0O] ^ ((lO01IO0O == 0)? O10O0O10 : lO00O01l[lO01IO0O-1]))
          		      & {id_width{1'bx}}) ^ lO00O01l[lO01IO0O];
        end
      end else begin
        for (lO01IO0O=0 ; lO01IO0O <= ((in_reg+stages-1+out_reg < 1)? 0 : (in_reg+stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          lO00O01l[lO01IO0O] <= {id_width{1'bx}};
        end
      end
    end
  end else begin
    always @ (posedge clk) begin : PROC_pl_registers_id
      integer lO01IO0O;

      if (rst_n === 1'b0) begin
        for (lO01IO0O=0 ; lO01IO0O <= ((in_reg+stages-1+out_reg < 1)? 0 : (in_reg+stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          lO00O01l[lO01IO0O] <= {id_width{1'b0}};
        end
      end else if (rst_n === 1'b1) begin
        for (lO01IO0O=0 ; lO01IO0O <= ((in_reg+stages-1+out_reg < 1)? 0 : (in_reg+stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          if (O00l0I1O[lO01IO0O] === 1'b1)
            lO00O01l[lO01IO0O] <= (lO01IO0O == 0)? O10O0O10 : lO00O01l[lO01IO0O-1];
          else if (O00l0I1O[lO01IO0O] !== 1'b0)
            lO00O01l[lO01IO0O] <= ((lO00O01l[lO01IO0O] ^ ((lO01IO0O == 0)? O10O0O10 : lO00O01l[lO01IO0O-1]))
          		      & {id_width{1'bx}}) ^ lO00O01l[lO01IO0O];
        end
      end else begin
        for (lO01IO0O=0 ; lO01IO0O <= ((in_reg+stages-1+out_reg < 1)? 0 : (in_reg+stages+out_reg-2)) ; lO01IO0O=lO01IO0O+1) begin
          lO00O01l[lO01IO0O] <= {id_width{1'bx}};
        end
      end
    end
  end
endgenerate

  assign OlI0OIOI = (in_reg+stages+out_reg == 1)? O10O0O10 : lO00O01l[((in_reg+stages-1+out_reg < 1)? 0 : (in_reg+stages+out_reg-2))];




generate
  if (rst_mode==0) begin : DW_II0lOI0l
    DW_lp_pipe_mgr #((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1), id_width) U_PIPE_MGR (
                     .clk(clk),
                     .rst_n(rst_n),
                     .init_n(1'b1),
                     .launch(O0lI0O1O),
                     .launch_id(O10O0O10),
                     .accept_n(I1O0O1O1),
                     .arrive(I1O001OO),
                     .arrive_id(IOO11O11),
                     .pipe_en_bus(O00101I1),
                     .pipe_full(O010lO10),
                     .pipe_ovf(OOO1O1OO),
                     .push_out_n(OO1lIIO1),
                     .pipe_census(O1O1IlO0)
                     );
  end else begin : DW_I01OI0I1
    DW_lp_pipe_mgr #((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1), id_width) U_PIPE_MGR (
                     .clk(clk),
                     .rst_n(1'b1),
                     .init_n(rst_n),
                     .launch(O0lI0O1O),
                     .launch_id(O10O0O10),
                     .accept_n(I1O0O1O1),
                     .arrive(I1O001OO),
                     .arrive_id(IOO11O11),
                     .pipe_en_bus(O00101I1),
                     .pipe_full(O010lO10),
                     .pipe_ovf(OOO1O1OO),
                     .push_out_n(OO1lIIO1),
                     .pipe_census(O1O1IlO0)
                     );
  end
endgenerate

assign O0O1011l         = O0lI0O1O;
assign l0OOl11l      = O10O0O10;
assign IIO10010    = {(((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1){1'b0}};
assign l1I101lO      = I1O0O1O1;
assign OO1IOO00  = l1I101lO && O0O1011l;
assign I0IOIl1O     = ~(~I1O0O1O1 && O0lI0O1O);
assign OOO0Ol0O    = {(((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>256)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>4096)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>16384)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>32768)?16:15):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>8192)?14:13)):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>1024)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>2048)?12:11):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>512)?10:9))):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>16)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>64)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>128)?8:7):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>32)?6:5)):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>4)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>8)?4:3):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>2)?2:1))))){1'b0}};


assign arrive           = no_pm ? 1'b0 : ((in_reg+stages+out_reg) > 1) ? I1O001OO : O0O1011l;
assign arrive_id        = ((in_reg+stages+out_reg) > 1) ? (no_pm ? OlI0OIOI          : IOO11O11  ) : l0OOl11l;
assign O00l0I1O  = ((in_reg+stages+out_reg) > 1) ? (no_pm ? {(((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1){launch}} : O00101I1) : IIO10010;
assign pipe_full        = no_pm ? 1'b0 : ((in_reg+stages+out_reg) > 1) ? O010lO10 : l1I101lO;
assign pipe_ovf         = no_pm ? 1'b0 : ((in_reg+stages+out_reg) > 1) ? OOO1O1OO : I10l1lO0;
assign push_out_n       = no_pm ? 1'b0 : ((in_reg+stages+out_reg) > 1) ? OO1lIIO1 : I0IOIl1O;
assign pipe_census      = no_pm ? {(((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>256)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>4096)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>16384)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>32768)?16:15):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>8192)?14:13)):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>1024)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>2048)?12:11):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>512)?10:9))):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>16)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>64)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>128)?8:7):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>32)?6:5)):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>4)?((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>8)?4:3):((((((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1)+1)>2)?2:1))))){1'b0}} : ((in_reg+stages+out_reg) > 1) ? O1O1IlO0 : OOO0Ol0O;

assign OOOOlIO1 = O00l0I1O[0];

  always @(O00l0I1O) begin : out_en_bus_in_reg1_PROC
    integer lO01IO0O;

    if  (in_reg == 1) begin
      O10l0O0O[0] = 1'b0;
      for (lO01IO0O=1; lO01IO0O<(((in_reg+(stages-1)+out_reg) >= 1) ? (in_reg+(stages-1)+out_reg) : 1); lO01IO0O=lO01IO0O+1) begin
        O10l0O0O[lO01IO0O-1] = O00l0I1O[lO01IO0O];
      end
    end else begin
      O10l0O0O = O00l0I1O;
    end
  end


generate
  if (rst_mode==0) begin : DW_O11011I1
    always @ (posedge clk or negedge rst_n) begin : posedge_registers_PROC
      if (rst_n === 1'b0) begin
        I10l1lO0     <= 1'b0;
      end else if (rst_n === 1'b1) begin
        I10l1lO0     <= OO1IOO00;
      end else begin
        I10l1lO0     <= 1'bx;
      end
    end
  end else begin : DW_I0O1O01I
    always @ (posedge clk) begin : posedge_registers_PROC
      if (rst_n === 1'b0) begin
        I10l1lO0     <= 1'b0;
      end else if (rst_n === 1'b1) begin
        I10l1lO0     <= OO1IOO00;
      end else begin
        I10l1lO0     <= 1'bx;
      end
    end
  end
endgenerate


  assign dataout      = ((in_reg==0) && (stages==1) && (out_reg==0) && (no_pm == 0) && (launch==1'b0)) ? 
                          {data_width{1'bx}} : 
                          (rw_mode==0) ? O0llOO1O: I01ll0OO;

  assign chkout       = ((in_reg==0) && (stages==1) && (out_reg==0) && (no_pm == 0) && (launch==1'b0)) ? 
                          {chk_width{1'bx}} : 
                          (rw_mode==0) ? IO1lO0l0: Ol0I0lO1;

  assign syndout      = ((in_reg==0) && (stages==1) && (out_reg==0) && (no_pm == 0) && (launch==1'b0)) ? 
                          {chk_width{1'bx}} : 
                          (rw_mode==0) ? II000OOO: {chk_width{1'b0}};

  assign err_detect   = ((in_reg==0) && (stages==1) && (out_reg==0) && (no_pm == 0) && (launch==1'b0)) ? 
                          1'bx : 
                          (rw_mode==0) ? I10O110O: 1'b0;

  assign err_multiple = ((in_reg==0) && (stages==1) && (out_reg==0) && (no_pm == 0) && (launch==1'b0)) ? 
                          1'bx : 
                          (rw_mode==0) ? IO100O1I: 1'b0;

  //-------------------------------------------------------------------------
  // Parameter legality check
  //-------------------------------------------------------------------------
  
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
  
    if ( (data_width < 8) || (data_width > 8178) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter data_width (legal range: 8 to 8178)",
	data_width );
    end
  
    if ( (chk_width < 5) || (chk_width > 14) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter chk_width (legal range: 5 to 14)",
	chk_width );
    end
  
    if ( (rw_mode < 0) || (rw_mode > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter rw_mode (legal range: 0 to 1)",
	rw_mode );
    end
  
    if ( (op_iso_mode < 0) || (op_iso_mode > 4) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter op_iso_mode (legal range: 0 to 4)",
	op_iso_mode );
    end
  
    if ( (id_width < 1) || (id_width > 1024) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter id_width (legal range: 1 to 1024)",
	id_width );
    end
  
    if ( (stages < 1) || (stages > 1022) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter stages (legal range: 1 to 1022)",
	stages );
    end
  
    if ( (in_reg < 0) || (in_reg > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter in_reg (legal range: 0 to 1)",
	in_reg );
    end
  
    if ( (out_reg < 0) || (out_reg > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter out_reg (legal range: 0 to 1)",
	out_reg );
    end
  
    if ( (no_pm < 0) || (no_pm > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter no_pm (legal range: 0 to 1)",
	no_pm );
    end
  
    if ( (rst_mode < 0) || (rst_mode > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter rst_mode (legal range: 0 to 1)",
	rst_mode );
    end
  
    if ( param_err_flg == 1) begin
      $display(
        "%m :\n  Simulation aborted due to invalid parameter value(s)");
      $finish;
    end

  end // parameter_check 


  
`ifndef DW_DISABLE_CLK_MONITOR
`ifndef DW_SUPPRESS_WARN
  always @ (clk) begin : monitor_clk 
    if ( (clk !== 1'b0) && (clk !== 1'b1) && ($time > 0) )
      $display ("WARNING: %m:\n at time = %0t: Detected unknown value, %b, on clk input.", $time, clk);
    end // monitor_clk 
`endif
`endif

// synopsys translate_on
endmodule
