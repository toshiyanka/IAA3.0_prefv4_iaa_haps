* Text_Tag % Vendor Intel % Product c73p4rfshdxrom % Techno P1273.1 % Tag_Spec 1.0 % ECCN US_3E002 % Signature fc908b73c335d975a0a384c871bb572c4aa609f7 % Version r1.0.0_m1.18 % _View_Id sp % Date_Time 20160216_100949 
* Netlist modified by mXuniq 1.9 on 20160216_095237
*
* File name: /nfs/iind/disks/apd_disk0048/w/ashah24/mxGen/ILK_16WW08/XLLLP/out_8/mem8/c73p1rfshdxrom2048x32hb4img108/c73p1rfshdxrom2048x32hb4img108.sp
* Spice output from: mXpress 0.44.i 2015-06-02T13:24:38
* Generated on: 2016-02-16T15:11:33
*
.GLOBAL vss
 *PUT YOUR COMMENT HERE
******************************************************************
* SUBCIRCUIT: da9inn00xwsb0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0 a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=0.084u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.084u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_gblpchg
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_gblpchg gbl gblclk vccxx
* INPUT: gblclk
* OUTPUT:
* INOUT: gbl vccxx


************************
Mgkp0 kp11 vss vccxx vccxx pxlllp L=0.042u W=0.042u
Mgkp1 kp01 kpg kp11 vccxx pxlllp L=0.042u W=0.042u
Mgkp2 gbl kpg kp01 vccxx pxlllp L=0.042u W=0.042u
Mgkprn0 gbl gblclk kn0 vss nxlllp L=0.042u W=0.084u
Mgkprn1 kn0 kpg vss vss nxlllp L=0.042u W=0.084u
Mgpch0 gbl gblclk vccxx vccxx pxlllp L=0.042u W=0.336u
Xigblffwdinv gbl kpg vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_gblpchg

******************************************************************
* SUBCIRCUIT: da9inn00xwsh3
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9inn00xwsh3 a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=1.764u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=1.764u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9inn00xwsh3

******************************************************************
* SUBCIRCUIT: da9inn00xwsc0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc0 a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=0.126u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.126u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc0

******************************************************************
* SUBCIRCUIT: da9inn00xwse5
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9inn00xwse5 a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=0.42u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.42u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9inn00xwse5

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_iopwrcell
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_iopwrcell pwren_in
+ pwren_out vccd_1p0 vccdgt_1p0
* INPUT: pwren_in vccd_1p0
* OUTPUT: pwren_out vccdgt_1p0
* INOUT:


************************
Mqn0 pwren_out n38 vss vss nxlllp L=0.042u W=0.84u
Mqn1 n38 pwren_in vss vss nxlllp L=0.042u W=0.21u
Mqp0 pwren_out n38 vccd_1p0 vccd_1p0 pxlllp L=0.042u W=0.84u
Mqp1 n38 pwren_in vccd_1p0 vccd_1p0 pxlllp L=0.042u W=0.21u
Mqp2 vccdgt_1p0 pwren_out vccd_1p0 vccd_1p0 pxlllp L=0.042u W=10.92u
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_iopwrcell

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_da7sls00ln0j1
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_da7sls00ln0j1 b ck o
+ vccxx
* INPUT: b ck vccxx
* OUTPUT: o
* INOUT:


************************
Mgifw.qna n11 o vss vss nxlllp L=0.042u W=0.084u
Mgifw.qpa n11 o vccxx vccxx pxlllp L=0.042u W=0.084u
Mqna n10 b vss vss nxlllp L=0.042u W=0.252u
Mqnck0 o b n1 vss nxlllp L=0.042u W=0.042u
Mqnck1 n1 n11 vss vss nxlllp L=0.042u W=0.042u
Mqne o ck n10 vss nxlllp L=0.042u W=0.252u
Mqpa o b vccxx vccxx pxlllp L=0.042u W=0.252u
Mqpck0 o ck n0 vccxx pxlllp L=0.042u W=0.042u
Mqpck1 n0 n11 vccxx vccxx pxlllp L=0.042u W=0.042u
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_da7sls00ln0j1

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_datio
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_datio dout gbl pwren_in
+ pwren_out sdlclkin vccd_1p0 vccdgt_1p0
* INPUT: pwren_in
* OUTPUT: dout pwren_out
* INOUT: gbl sdlclkin vccd_1p0 vccdgt_1p0


************************
Xigblpchg gbl sdlclk vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_gblpchg
Xinn0 sdloutb dout vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9inn00xwsh3
Xinn1 sdlclkin sdlclk vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc0
Xinn2 sdlout sdloutb vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwse5
Xipg pwren_in pwren_out vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_iopwrcell
Xisdl gbl sdlclk sdlout vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_da7sls00ln0j1
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_datio

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_bitcell04g
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g bl rwl
* INPUT: rwl
* OUTPUT:
* INOUT: bl


************************
Mqnbitcell bl_float rwl vss vss nxlllp L=0.042u W=0.168u
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_lblnand
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_lblnand a b o1 vccxx
* INPUT: a b vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a n1 vss nxlllp L=0.042u W=0.168u
Mqn2 n1 b vss vss nxlllp L=0.042u W=0.168u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.21u
Mqp2 o1 b vccxx vccxx pxlllp L=0.042u W=0.21u
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_lblnand

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_bitgap
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitgap cm[0] cm[1] cm[2]
+ cm[3] cm[4] cm[5] cm[6] cm[7] gbl lblleft[0] lblleft[1] lblleft[2]
+ lblleft[3] lblleft[4] lblleft[5] lblleft[6]  lblleft[7] lblpchclkleftb
+ lblpchclkrightb lblright[0] lblright[1] lblright[2]  lblright[3]
+ lblright[4] lblright[5] lblright[6] lblright[7] vccdgt_1p0
* INPUT: cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] lblleft[0]
*+ lblleft[1] lblleft[2] lblleft[3] lblleft[4] lblleft[5] lblleft[6]
*+ lblleft[7] lblpchclkleftb lblpchclkrightb lblright[0] lblright[1]
*+ lblright[2] lblright[3] lblright[4] lblright[5] lblright[6] lblright[7]
*+ vccdgt_1p0
* OUTPUT:
* INOUT: gbl


************************
Mqn1[0] lbll cm[0] lblleft[0] vss nxlllp L=0.042u W=0.21u
Mqn1[1] lbll cm[1] lblleft[1] vss nxlllp L=0.042u W=0.21u
Mqn1[2] lbll cm[2] lblleft[2] vss nxlllp L=0.042u W=0.21u
Mqn1[3] lbll cm[3] lblleft[3] vss nxlllp L=0.042u W=0.21u
Mqn1[4] lbll cm[4] lblleft[4] vss nxlllp L=0.042u W=0.21u
Mqn1[5] lbll cm[5] lblleft[5] vss nxlllp L=0.042u W=0.21u
Mqn1[6] lbll cm[6] lblleft[6] vss nxlllp L=0.042u W=0.21u
Mqn1[7] lbll cm[7] lblleft[7] vss nxlllp L=0.042u W=0.21u
Mqncmright[0] lblr cm[0] lblright[0] vss nxlllp L=0.042u W=0.21u
Mqncmright[1] lblr cm[1] lblright[1] vss nxlllp L=0.042u W=0.21u
Mqncmright[2] lblr cm[2] lblright[2] vss nxlllp L=0.042u W=0.21u
Mqncmright[3] lblr cm[3] lblright[3] vss nxlllp L=0.042u W=0.21u
Mqncmright[4] lblr cm[4] lblright[4] vss nxlllp L=0.042u W=0.21u
Mqncmright[5] lblr cm[5] lblright[5] vss nxlllp L=0.042u W=0.21u
Mqncmright[6] lblr cm[6] lblright[6] vss nxlllp L=0.042u W=0.21u
Mqncmright[7] lblr cm[7] lblright[7] vss nxlllp L=0.042u W=0.21u
Mqngblpd gbl rdbl vss vss nxlllp L=0.042u W=0.504u
Mqp0 kp0r kpr kp1r vccdgt_1p0 pxlllp L=0.042u W=0.042u
Mqp1 kp3l vss vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u W=0.042u
Mqp12 kp3r vss vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u W=0.042u
Mqp13 kp2r vss kp3r vccdgt_1p0 pxlllp L=0.042u W=0.042u
Mqp14 kp1r vss kp2r vccdgt_1p0 pxlllp L=0.042u W=0.042u
Mqp2 kp2l vss kp3l vccdgt_1p0 pxlllp L=0.042u W=0.042u
Mqp3 kp1l vss kp2l vccdgt_1p0 pxlllp L=0.042u W=0.042u
Mqp4 lbll kpl kp0l vccdgt_1p0 pxlllp L=0.042u W=0.042u
Mqp5 kp0l kpl kp1l vccdgt_1p0 pxlllp L=0.042u W=0.042u
Mqp6 lbll lblpchclkleft vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u W=0.084u
Mqp7[0] lblleft[0] lblpchclkleft vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u W=0.084u
Mqp7[1] lblleft[1] lblpchclkleft vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u W=0.084u
Mqp7[2] lblleft[2] lblpchclkleft vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u W=0.084u
Mqp7[3] lblleft[3] lblpchclkleft vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u W=0.084u
Mqp7[4] lblleft[4] lblpchclkleft vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u W=0.084u
Mqp7[5] lblleft[5] lblpchclkleft vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u W=0.084u
Mqp7[6] lblleft[6] lblpchclkleft vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u W=0.084u
Mqp7[7] lblleft[7] lblpchclkleft vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u W=0.084u
Mqp9 lblr kpr kp0r vccdgt_1p0 pxlllp L=0.042u W=0.042u
Mqpch lblr lblpchclkright vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u W=0.084u
Mqpchsc[0] lblright[0] lblpchclkright vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u
+ W=0.084u
Mqpchsc[1] lblright[1] lblpchclkright vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u
+ W=0.084u
Mqpchsc[2] lblright[2] lblpchclkright vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u
+ W=0.084u
Mqpchsc[3] lblright[3] lblpchclkright vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u
+ W=0.084u
Mqpchsc[4] lblright[4] lblpchclkright vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u
+ W=0.084u
Mqpchsc[5] lblright[5] lblpchclkright vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u
+ W=0.084u
Mqpchsc[6] lblright[6] lblpchclkright vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u
+ W=0.084u
Mqpchsc[7] lblright[7] lblpchclkright vccdgt_1p0 vccdgt_1p0 pxlllp L=0.042u
+ W=0.084u
Xgrdbl lblr lbll rdbl vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_lblnand
Xiffwdl lbll kpl vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
Xiffwdr lblr kpr vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
Xinn2 lblpchclkleftb lblpchclkleft vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc0
Xinn3 lblpchclkrightb lblpchclkright vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc0
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitgap

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_polycon3dg
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg rwl
* INPUT:
* OUTPUT:
* INOUT: rwl


************************
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_bitslicearray32v2bit0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitslicearray32v2bit0
+ cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] gbl lblpchclkleftb
+ lblpchclkrightb rwlt[0] rwlt[1] rwlt[2]  rwlt[3] rwlt[4] rwlt[5] rwlt[6]
+ rwlt[7] rwlt[8] rwlt[9] rwlt[10] rwlt[11]  rwlt[12] rwlt[13] rwlt[14]
+ rwlt[15] rwlt[16] rwlt[17] rwlt[18] rwlt[19]  rwlt[20] rwlt[21] rwlt[22]
+ rwlt[23] rwlt[24] rwlt[25] rwlt[26] rwlt[27]  rwlt[28] rwlt[29] rwlt[30]
+ rwlt[31] rwlt[32] rwlt[33] rwlt[34] rwlt[35]  rwlt[36] rwlt[37] rwlt[38]
+ rwlt[39] rwlt[40] rwlt[41] rwlt[42] rwlt[43]  rwlt[44] rwlt[45] rwlt[46]
+ rwlt[47] rwlt[48] rwlt[49] rwlt[50] rwlt[51]  rwlt[52] rwlt[53] rwlt[54]
+ rwlt[55] rwlt[56] rwlt[57] rwlt[58] rwlt[59]  rwlt[60] rwlt[61] rwlt[62]
+ rwlt[63] vccd_1p0 vccdgt_1p0
* INPUT:
* OUTPUT:
* INOUT: cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] gbl
*+ lblpchclkleftb lblpchclkrightb rwlt[0] rwlt[1] rwlt[2] rwlt[3] rwlt[4]
*+ rwlt[5] rwlt[6] rwlt[7] rwlt[8] rwlt[9] rwlt[10] rwlt[11] rwlt[12]
*+ rwlt[13] rwlt[14] rwlt[15] rwlt[16] rwlt[17] rwlt[18] rwlt[19] rwlt[20]
*+ rwlt[21] rwlt[22] rwlt[23] rwlt[24] rwlt[25] rwlt[26] rwlt[27] rwlt[28]
*+ rwlt[29] rwlt[30] rwlt[31] rwlt[32] rwlt[33] rwlt[34] rwlt[35] rwlt[36]
*+ rwlt[37] rwlt[38] rwlt[39] rwlt[40] rwlt[41] rwlt[42] rwlt[43] rwlt[44]
*+ rwlt[45] rwlt[46] rwlt[47] rwlt[48] rwlt[49] rwlt[50] rwlt[51] rwlt[52]
*+ rwlt[53] rwlt[54] rwlt[55] rwlt[56] rwlt[57] rwlt[58] rwlt[59] rwlt[60]
*+ rwlt[61] rwlt[62] rwlt[63] vccd_1p0 vccdgt_1p0


************************
Xiarray_r0c0 lblleft[0] rwlt[0]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r0c1 lblleft[1] rwlt[0]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r0c2 lblleft[2] rwlt[0]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r0c3 lblleft[3] rwlt[0]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r0c4 lblleft[4] rwlt[0]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r0c5 lblleft[5] rwlt[0]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r0c6 lblleft[6] rwlt[0]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r0c7 lblleft[7] rwlt[0]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r10c0 lblleft[0] rwlt[10]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r10c1 lblleft[1] rwlt[10]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r10c2 lblleft[2] rwlt[10]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r10c3 lblleft[3] rwlt[10]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r10c4 lblleft[4] rwlt[10]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r10c5 lblleft[5] rwlt[10]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r10c6 lblleft[6] rwlt[10]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r10c7 lblleft[7] rwlt[10]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r11c0 lblleft[0] rwlt[11]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r11c1 lblleft[1] rwlt[11]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r11c2 lblleft[2] rwlt[11]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r11c3 lblleft[3] rwlt[11]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r11c4 lblleft[4] rwlt[11]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r11c5 lblleft[5] rwlt[11]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r11c6 lblleft[6] rwlt[11]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r11c7 lblleft[7] rwlt[11]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r12c0 lblleft[0] rwlt[12]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r12c1 lblleft[1] rwlt[12]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r12c2 lblleft[2] rwlt[12]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r12c3 lblleft[3] rwlt[12]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r12c4 lblleft[4] rwlt[12]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r12c5 lblleft[5] rwlt[12]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r12c6 lblleft[6] rwlt[12]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r12c7 lblleft[7] rwlt[12]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r13c0 lblleft[0] rwlt[13]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r13c1 lblleft[1] rwlt[13]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r13c2 lblleft[2] rwlt[13]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r13c3 lblleft[3] rwlt[13]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r13c4 lblleft[4] rwlt[13]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r13c5 lblleft[5] rwlt[13]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r13c6 lblleft[6] rwlt[13]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r13c7 lblleft[7] rwlt[13]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r14c0 lblleft[0] rwlt[14]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r14c1 lblleft[1] rwlt[14]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r14c2 lblleft[2] rwlt[14]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r14c3 lblleft[3] rwlt[14]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r14c4 lblleft[4] rwlt[14]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r14c5 lblleft[5] rwlt[14]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r14c6 lblleft[6] rwlt[14]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r14c7 lblleft[7] rwlt[14]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r15c0 lblleft[0] rwlt[15]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r15c1 lblleft[1] rwlt[15]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r15c2 lblleft[2] rwlt[15]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r15c3 lblleft[3] rwlt[15]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r15c4 lblleft[4] rwlt[15]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r15c5 lblleft[5] rwlt[15]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r15c6 lblleft[6] rwlt[15]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r15c7 lblleft[7] rwlt[15]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r16c0 lblleft[0] rwlt[16]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r16c1 lblleft[1] rwlt[16]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r16c2 lblleft[2] rwlt[16]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r16c3 lblleft[3] rwlt[16]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r16c4 lblleft[4] rwlt[16]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r16c5 lblleft[5] rwlt[16]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r16c6 lblleft[6] rwlt[16]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r16c7 lblleft[7] rwlt[16]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r17c0 lblleft[0] rwlt[17]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r17c1 lblleft[1] rwlt[17]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r17c2 lblleft[2] rwlt[17]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r17c3 lblleft[3] rwlt[17]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r17c4 lblleft[4] rwlt[17]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r17c5 lblleft[5] rwlt[17]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r17c6 lblleft[6] rwlt[17]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r17c7 lblleft[7] rwlt[17]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r18c0 lblleft[0] rwlt[18]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r18c1 lblleft[1] rwlt[18]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r18c2 lblleft[2] rwlt[18]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r18c3 lblleft[3] rwlt[18]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r18c4 lblleft[4] rwlt[18]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r18c5 lblleft[5] rwlt[18]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r18c6 lblleft[6] rwlt[18]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r18c7 lblleft[7] rwlt[18]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r19c0 lblleft[0] rwlt[19]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r19c1 lblleft[1] rwlt[19]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r19c2 lblleft[2] rwlt[19]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r19c3 lblleft[3] rwlt[19]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r19c4 lblleft[4] rwlt[19]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r19c5 lblleft[5] rwlt[19]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r19c6 lblleft[6] rwlt[19]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r19c7 lblleft[7] rwlt[19]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r1c0 lblleft[0] rwlt[1]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r1c1 lblleft[1] rwlt[1]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r1c2 lblleft[2] rwlt[1]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r1c3 lblleft[3] rwlt[1]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r1c4 lblleft[4] rwlt[1]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r1c5 lblleft[5] rwlt[1]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r1c6 lblleft[6] rwlt[1]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r1c7 lblleft[7] rwlt[1]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r20c0 lblleft[0] rwlt[20]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r20c1 lblleft[1] rwlt[20]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r20c2 lblleft[2] rwlt[20]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r20c3 lblleft[3] rwlt[20]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r20c4 lblleft[4] rwlt[20]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r20c5 lblleft[5] rwlt[20]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r20c6 lblleft[6] rwlt[20]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r20c7 lblleft[7] rwlt[20]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r21c0 lblleft[0] rwlt[21]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r21c1 lblleft[1] rwlt[21]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r21c2 lblleft[2] rwlt[21]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r21c3 lblleft[3] rwlt[21]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r21c4 lblleft[4] rwlt[21]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r21c5 lblleft[5] rwlt[21]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r21c6 lblleft[6] rwlt[21]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r21c7 lblleft[7] rwlt[21]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r22c0 lblleft[0] rwlt[22]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r22c1 lblleft[1] rwlt[22]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r22c2 lblleft[2] rwlt[22]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r22c3 lblleft[3] rwlt[22]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r22c4 lblleft[4] rwlt[22]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r22c5 lblleft[5] rwlt[22]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r22c6 lblleft[6] rwlt[22]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r22c7 lblleft[7] rwlt[22]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r23c0 lblleft[0] rwlt[23]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r23c1 lblleft[1] rwlt[23]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r23c2 lblleft[2] rwlt[23]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r23c3 lblleft[3] rwlt[23]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r23c4 lblleft[4] rwlt[23]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r23c5 lblleft[5] rwlt[23]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r23c6 lblleft[6] rwlt[23]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r23c7 lblleft[7] rwlt[23]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r24c0 lblleft[0] rwlt[24]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r24c1 lblleft[1] rwlt[24]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r24c2 lblleft[2] rwlt[24]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r24c3 lblleft[3] rwlt[24]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r24c4 lblleft[4] rwlt[24]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r24c5 lblleft[5] rwlt[24]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r24c6 lblleft[6] rwlt[24]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r24c7 lblleft[7] rwlt[24]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r25c0 lblleft[0] rwlt[25]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r25c1 lblleft[1] rwlt[25]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r25c2 lblleft[2] rwlt[25]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r25c3 lblleft[3] rwlt[25]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r25c4 lblleft[4] rwlt[25]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r25c5 lblleft[5] rwlt[25]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r25c6 lblleft[6] rwlt[25]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r25c7 lblleft[7] rwlt[25]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r26c0 lblleft[0] rwlt[26]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r26c1 lblleft[1] rwlt[26]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r26c2 lblleft[2] rwlt[26]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r26c3 lblleft[3] rwlt[26]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r26c4 lblleft[4] rwlt[26]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r26c5 lblleft[5] rwlt[26]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r26c6 lblleft[6] rwlt[26]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r26c7 lblleft[7] rwlt[26]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r27c0 lblleft[0] rwlt[27]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r27c1 lblleft[1] rwlt[27]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r27c2 lblleft[2] rwlt[27]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r27c3 lblleft[3] rwlt[27]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r27c4 lblleft[4] rwlt[27]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r27c5 lblleft[5] rwlt[27]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r27c6 lblleft[6] rwlt[27]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r27c7 lblleft[7] rwlt[27]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r28c0 lblleft[0] rwlt[28]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r28c1 lblleft[1] rwlt[28]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r28c2 lblleft[2] rwlt[28]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r28c3 lblleft[3] rwlt[28]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r28c4 lblleft[4] rwlt[28]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r28c5 lblleft[5] rwlt[28]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r28c6 lblleft[6] rwlt[28]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r28c7 lblleft[7] rwlt[28]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r29c0 lblleft[0] rwlt[29]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r29c1 lblleft[1] rwlt[29]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r29c2 lblleft[2] rwlt[29]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r29c3 lblleft[3] rwlt[29]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r29c4 lblleft[4] rwlt[29]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r29c5 lblleft[5] rwlt[29]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r29c6 lblleft[6] rwlt[29]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r29c7 lblleft[7] rwlt[29]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r2c0 lblleft[0] rwlt[2]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r2c1 lblleft[1] rwlt[2]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r2c2 lblleft[2] rwlt[2]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r2c3 lblleft[3] rwlt[2]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r2c4 lblleft[4] rwlt[2]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r2c5 lblleft[5] rwlt[2]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r2c6 lblleft[6] rwlt[2]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r2c7 lblleft[7] rwlt[2]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r30c0 lblleft[0] rwlt[30]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r30c1 lblleft[1] rwlt[30]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r30c2 lblleft[2] rwlt[30]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r30c3 lblleft[3] rwlt[30]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r30c4 lblleft[4] rwlt[30]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r30c5 lblleft[5] rwlt[30]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r30c6 lblleft[6] rwlt[30]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r30c7 lblleft[7] rwlt[30]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r31c0 lblleft[0] rwlt[31]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r31c1 lblleft[1] rwlt[31]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r31c2 lblleft[2] rwlt[31]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r31c3 lblleft[3] rwlt[31]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r31c4 lblleft[4] rwlt[31]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r31c5 lblleft[5] rwlt[31]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r31c6 lblleft[6] rwlt[31]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r31c7 lblleft[7] rwlt[31]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r32c0 lblright[0] rwlt[32]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r32c1 lblright[1] rwlt[32]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r32c2 lblright[2] rwlt[32]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r32c3 lblright[3] rwlt[32]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r32c4 lblright[4] rwlt[32]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r32c5 lblright[5] rwlt[32]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r32c6 lblright[6] rwlt[32]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r32c7 lblright[7] rwlt[32]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r33c0 lblright[0] rwlt[33]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r33c1 lblright[1] rwlt[33]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r33c2 lblright[2] rwlt[33]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r33c3 lblright[3] rwlt[33]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r33c4 lblright[4] rwlt[33]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r33c5 lblright[5] rwlt[33]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r33c6 lblright[6] rwlt[33]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r33c7 lblright[7] rwlt[33]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r34c0 lblright[0] rwlt[34]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r34c1 lblright[1] rwlt[34]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r34c2 lblright[2] rwlt[34]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r34c3 lblright[3] rwlt[34]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r34c4 lblright[4] rwlt[34]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r34c5 lblright[5] rwlt[34]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r34c6 lblright[6] rwlt[34]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r34c7 lblright[7] rwlt[34]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r35c0 lblright[0] rwlt[35]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r35c1 lblright[1] rwlt[35]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r35c2 lblright[2] rwlt[35]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r35c3 lblright[3] rwlt[35]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r35c4 lblright[4] rwlt[35]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r35c5 lblright[5] rwlt[35]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r35c6 lblright[6] rwlt[35]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r35c7 lblright[7] rwlt[35]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r36c0 lblright[0] rwlt[36]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r36c1 lblright[1] rwlt[36]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r36c2 lblright[2] rwlt[36]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r36c3 lblright[3] rwlt[36]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r36c4 lblright[4] rwlt[36]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r36c5 lblright[5] rwlt[36]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r36c6 lblright[6] rwlt[36]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r36c7 lblright[7] rwlt[36]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r37c0 lblright[0] rwlt[37]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r37c1 lblright[1] rwlt[37]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r37c2 lblright[2] rwlt[37]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r37c3 lblright[3] rwlt[37]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r37c4 lblright[4] rwlt[37]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r37c5 lblright[5] rwlt[37]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r37c6 lblright[6] rwlt[37]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r37c7 lblright[7] rwlt[37]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r38c0 lblright[0] rwlt[38]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r38c1 lblright[1] rwlt[38]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r38c2 lblright[2] rwlt[38]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r38c3 lblright[3] rwlt[38]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r38c4 lblright[4] rwlt[38]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r38c5 lblright[5] rwlt[38]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r38c6 lblright[6] rwlt[38]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r38c7 lblright[7] rwlt[38]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r39c0 lblright[0] rwlt[39]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r39c1 lblright[1] rwlt[39]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r39c2 lblright[2] rwlt[39]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r39c3 lblright[3] rwlt[39]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r39c4 lblright[4] rwlt[39]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r39c5 lblright[5] rwlt[39]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r39c6 lblright[6] rwlt[39]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r39c7 lblright[7] rwlt[39]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r3c0 lblleft[0] rwlt[3]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r3c1 lblleft[1] rwlt[3]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r3c2 lblleft[2] rwlt[3]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r3c3 lblleft[3] rwlt[3]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r3c4 lblleft[4] rwlt[3]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r3c5 lblleft[5] rwlt[3]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r3c6 lblleft[6] rwlt[3]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r3c7 lblleft[7] rwlt[3]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r40c0 lblright[0] rwlt[40]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r40c1 lblright[1] rwlt[40]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r40c2 lblright[2] rwlt[40]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r40c3 lblright[3] rwlt[40]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r40c4 lblright[4] rwlt[40]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r40c5 lblright[5] rwlt[40]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r40c6 lblright[6] rwlt[40]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r40c7 lblright[7] rwlt[40]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r41c0 lblright[0] rwlt[41]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r41c1 lblright[1] rwlt[41]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r41c2 lblright[2] rwlt[41]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r41c3 lblright[3] rwlt[41]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r41c4 lblright[4] rwlt[41]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r41c5 lblright[5] rwlt[41]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r41c6 lblright[6] rwlt[41]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r41c7 lblright[7] rwlt[41]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r42c0 lblright[0] rwlt[42]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r42c1 lblright[1] rwlt[42]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r42c2 lblright[2] rwlt[42]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r42c3 lblright[3] rwlt[42]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r42c4 lblright[4] rwlt[42]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r42c5 lblright[5] rwlt[42]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r42c6 lblright[6] rwlt[42]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r42c7 lblright[7] rwlt[42]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r43c0 lblright[0] rwlt[43]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r43c1 lblright[1] rwlt[43]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r43c2 lblright[2] rwlt[43]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r43c3 lblright[3] rwlt[43]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r43c4 lblright[4] rwlt[43]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r43c5 lblright[5] rwlt[43]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r43c6 lblright[6] rwlt[43]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r43c7 lblright[7] rwlt[43]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r44c0 lblright[0] rwlt[44]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r44c1 lblright[1] rwlt[44]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r44c2 lblright[2] rwlt[44]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r44c3 lblright[3] rwlt[44]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r44c4 lblright[4] rwlt[44]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r44c5 lblright[5] rwlt[44]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r44c6 lblright[6] rwlt[44]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r44c7 lblright[7] rwlt[44]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r45c0 lblright[0] rwlt[45]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r45c1 lblright[1] rwlt[45]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r45c2 lblright[2] rwlt[45]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r45c3 lblright[3] rwlt[45]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r45c4 lblright[4] rwlt[45]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r45c5 lblright[5] rwlt[45]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r45c6 lblright[6] rwlt[45]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r45c7 lblright[7] rwlt[45]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r46c0 lblright[0] rwlt[46]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r46c1 lblright[1] rwlt[46]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r46c2 lblright[2] rwlt[46]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r46c3 lblright[3] rwlt[46]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r46c4 lblright[4] rwlt[46]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r46c5 lblright[5] rwlt[46]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r46c6 lblright[6] rwlt[46]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r46c7 lblright[7] rwlt[46]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r47c0 lblright[0] rwlt[47]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r47c1 lblright[1] rwlt[47]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r47c2 lblright[2] rwlt[47]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r47c3 lblright[3] rwlt[47]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r47c4 lblright[4] rwlt[47]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r47c5 lblright[5] rwlt[47]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r47c6 lblright[6] rwlt[47]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r47c7 lblright[7] rwlt[47]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r48c0 lblright[0] rwlt[48]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r48c1 lblright[1] rwlt[48]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r48c2 lblright[2] rwlt[48]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r48c3 lblright[3] rwlt[48]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r48c4 lblright[4] rwlt[48]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r48c5 lblright[5] rwlt[48]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r48c6 lblright[6] rwlt[48]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r48c7 lblright[7] rwlt[48]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r49c0 lblright[0] rwlt[49]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r49c1 lblright[1] rwlt[49]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r49c2 lblright[2] rwlt[49]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r49c3 lblright[3] rwlt[49]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r49c4 lblright[4] rwlt[49]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r49c5 lblright[5] rwlt[49]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r49c6 lblright[6] rwlt[49]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r49c7 lblright[7] rwlt[49]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r4c0 lblleft[0] rwlt[4]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r4c1 lblleft[1] rwlt[4]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r4c2 lblleft[2] rwlt[4]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r4c3 lblleft[3] rwlt[4]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r4c4 lblleft[4] rwlt[4]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r4c5 lblleft[5] rwlt[4]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r4c6 lblleft[6] rwlt[4]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r4c7 lblleft[7] rwlt[4]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r50c0 lblright[0] rwlt[50]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r50c1 lblright[1] rwlt[50]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r50c2 lblright[2] rwlt[50]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r50c3 lblright[3] rwlt[50]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r50c4 lblright[4] rwlt[50]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r50c5 lblright[5] rwlt[50]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r50c6 lblright[6] rwlt[50]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r50c7 lblright[7] rwlt[50]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r51c0 lblright[0] rwlt[51]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r51c1 lblright[1] rwlt[51]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r51c2 lblright[2] rwlt[51]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r51c3 lblright[3] rwlt[51]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r51c4 lblright[4] rwlt[51]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r51c5 lblright[5] rwlt[51]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r51c6 lblright[6] rwlt[51]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r51c7 lblright[7] rwlt[51]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r52c0 lblright[0] rwlt[52]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r52c1 lblright[1] rwlt[52]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r52c2 lblright[2] rwlt[52]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r52c3 lblright[3] rwlt[52]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r52c4 lblright[4] rwlt[52]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r52c5 lblright[5] rwlt[52]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r52c6 lblright[6] rwlt[52]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r52c7 lblright[7] rwlt[52]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r53c0 lblright[0] rwlt[53]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r53c1 lblright[1] rwlt[53]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r53c2 lblright[2] rwlt[53]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r53c3 lblright[3] rwlt[53]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r53c4 lblright[4] rwlt[53]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r53c5 lblright[5] rwlt[53]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r53c6 lblright[6] rwlt[53]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r53c7 lblright[7] rwlt[53]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r54c0 lblright[0] rwlt[54]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r54c1 lblright[1] rwlt[54]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r54c2 lblright[2] rwlt[54]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r54c3 lblright[3] rwlt[54]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r54c4 lblright[4] rwlt[54]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r54c5 lblright[5] rwlt[54]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r54c6 lblright[6] rwlt[54]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r54c7 lblright[7] rwlt[54]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r55c0 lblright[0] rwlt[55]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r55c1 lblright[1] rwlt[55]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r55c2 lblright[2] rwlt[55]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r55c3 lblright[3] rwlt[55]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r55c4 lblright[4] rwlt[55]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r55c5 lblright[5] rwlt[55]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r55c6 lblright[6] rwlt[55]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r55c7 lblright[7] rwlt[55]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r56c0 lblright[0] rwlt[56]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r56c1 lblright[1] rwlt[56]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r56c2 lblright[2] rwlt[56]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r56c3 lblright[3] rwlt[56]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r56c4 lblright[4] rwlt[56]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r56c5 lblright[5] rwlt[56]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r56c6 lblright[6] rwlt[56]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r56c7 lblright[7] rwlt[56]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r57c0 lblright[0] rwlt[57]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r57c1 lblright[1] rwlt[57]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r57c2 lblright[2] rwlt[57]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r57c3 lblright[3] rwlt[57]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r57c4 lblright[4] rwlt[57]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r57c5 lblright[5] rwlt[57]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r57c6 lblright[6] rwlt[57]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r57c7 lblright[7] rwlt[57]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r58c0 lblright[0] rwlt[58]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r58c1 lblright[1] rwlt[58]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r58c2 lblright[2] rwlt[58]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r58c3 lblright[3] rwlt[58]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r58c4 lblright[4] rwlt[58]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r58c5 lblright[5] rwlt[58]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r58c6 lblright[6] rwlt[58]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r58c7 lblright[7] rwlt[58]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r59c0 lblright[0] rwlt[59]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r59c1 lblright[1] rwlt[59]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r59c2 lblright[2] rwlt[59]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r59c3 lblright[3] rwlt[59]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r59c4 lblright[4] rwlt[59]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r59c5 lblright[5] rwlt[59]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r59c6 lblright[6] rwlt[59]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r59c7 lblright[7] rwlt[59]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r5c0 lblleft[0] rwlt[5]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r5c1 lblleft[1] rwlt[5]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r5c2 lblleft[2] rwlt[5]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r5c3 lblleft[3] rwlt[5]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r5c4 lblleft[4] rwlt[5]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r5c5 lblleft[5] rwlt[5]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r5c6 lblleft[6] rwlt[5]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r5c7 lblleft[7] rwlt[5]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r60c0 lblright[0] rwlt[60]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r60c1 lblright[1] rwlt[60]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r60c2 lblright[2] rwlt[60]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r60c3 lblright[3] rwlt[60]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r60c4 lblright[4] rwlt[60]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r60c5 lblright[5] rwlt[60]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r60c6 lblright[6] rwlt[60]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r60c7 lblright[7] rwlt[60]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r61c0 lblright[0] rwlt[61]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r61c1 lblright[1] rwlt[61]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r61c2 lblright[2] rwlt[61]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r61c3 lblright[3] rwlt[61]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r61c4 lblright[4] rwlt[61]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r61c5 lblright[5] rwlt[61]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r61c6 lblright[6] rwlt[61]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r61c7 lblright[7] rwlt[61]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r62c0 lblright[0] rwlt[62]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r62c1 lblright[1] rwlt[62]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r62c2 lblright[2] rwlt[62]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r62c3 lblright[3] rwlt[62]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r62c4 lblright[4] rwlt[62]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r62c5 lblright[5] rwlt[62]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r62c6 lblright[6] rwlt[62]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r62c7 lblright[7] rwlt[62]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r63c0 lblright[0] rwlt[63]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r63c1 lblright[1] rwlt[63]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r63c2 lblright[2] rwlt[63]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r63c3 lblright[3] rwlt[63]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r63c4 lblright[4] rwlt[63]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r63c5 lblright[5] rwlt[63]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r63c6 lblright[6] rwlt[63]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r63c7 lblright[7] rwlt[63]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r6c0 lblleft[0] rwlt[6]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r6c1 lblleft[1] rwlt[6]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r6c2 lblleft[2] rwlt[6]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r6c3 lblleft[3] rwlt[6]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r6c4 lblleft[4] rwlt[6]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r6c5 lblleft[5] rwlt[6]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r6c6 lblleft[6] rwlt[6]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r6c7 lblleft[7] rwlt[6]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r7c0 lblleft[0] rwlt[7]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r7c1 lblleft[1] rwlt[7]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r7c2 lblleft[2] rwlt[7]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r7c3 lblleft[3] rwlt[7]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r7c4 lblleft[4] rwlt[7]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r7c5 lblleft[5] rwlt[7]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r7c6 lblleft[6] rwlt[7]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r7c7 lblleft[7] rwlt[7]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r8c0 lblleft[0] rwlt[8]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r8c1 lblleft[1] rwlt[8]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r8c2 lblleft[2] rwlt[8]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r8c3 lblleft[3] rwlt[8]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r8c4 lblleft[4] rwlt[8]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r8c5 lblleft[5] rwlt[8]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r8c6 lblleft[6] rwlt[8]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r8c7 lblleft[7] rwlt[8]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r9c0 lblleft[0] rwlt[9]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r9c1 lblleft[1] rwlt[9]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r9c2 lblleft[2] rwlt[9]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r9c3 lblleft[3] rwlt[9]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r9c4 lblleft[4] rwlt[9]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r9c5 lblleft[5] rwlt[9]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r9c6 lblleft[6] rwlt[9]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xiarray_r9c7 lblleft[7] rwlt[9]
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitcell04g
Xic73p4hdrom_bitgap cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] gbl
+ lblleft[0] lblleft[1] lblleft[2] lblleft[3] lblleft[4] lblleft[5]
+ lblleft[6] lblleft[7] lblpchclkleftb lblpchclkrightb lblright[0]
+ lblright[1] lblright[2] lblright[3] lblright[4] lblright[5] lblright[6]
+ lblright[7] vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitgap
Xipc_r0c0 rwlt[0] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r10c0 rwlt[10] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r11c0 rwlt[11] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r12c0 rwlt[12] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r13c0 rwlt[13] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r14c0 rwlt[14] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r15c0 rwlt[15] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r16c0 rwlt[16] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r17c0 rwlt[17] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r18c0 rwlt[18] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r19c0 rwlt[19] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r1c0 rwlt[1] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r20c0 rwlt[20] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r21c0 rwlt[21] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r22c0 rwlt[22] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r23c0 rwlt[23] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r24c0 rwlt[24] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r25c0 rwlt[25] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r26c0 rwlt[26] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r27c0 rwlt[27] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r28c0 rwlt[28] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r29c0 rwlt[29] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r2c0 rwlt[2] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r30c0 rwlt[30] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r31c0 rwlt[31] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r32c0 rwlt[32] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r33c0 rwlt[33] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r34c0 rwlt[34] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r35c0 rwlt[35] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r36c0 rwlt[36] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r37c0 rwlt[37] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r38c0 rwlt[38] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r39c0 rwlt[39] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r3c0 rwlt[3] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r40c0 rwlt[40] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r41c0 rwlt[41] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r42c0 rwlt[42] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r43c0 rwlt[43] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r44c0 rwlt[44] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r45c0 rwlt[45] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r46c0 rwlt[46] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r47c0 rwlt[47] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r48c0 rwlt[48] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r49c0 rwlt[49] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r4c0 rwlt[4] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r50c0 rwlt[50] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r51c0 rwlt[51] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r52c0 rwlt[52] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r53c0 rwlt[53] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r54c0 rwlt[54] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r55c0 rwlt[55] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r56c0 rwlt[56] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r57c0 rwlt[57] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r58c0 rwlt[58] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r59c0 rwlt[59] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r5c0 rwlt[5] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r60c0 rwlt[60] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r61c0 rwlt[61] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r62c0 rwlt[62] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r63c0 rwlt[63] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r6c0 rwlt[6] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r7c0 rwlt[7] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r8c0 rwlt[8] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
Xipc_r9c0 rwlt[9] c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_polycon3dg
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitslicearray32v2bit0

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_bitspacer
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitspacer gbl vccd_1p0
+ vccdgt_1p0
* INPUT:
* OUTPUT:
* INOUT: gbl vccd_1p0 vccdgt_1p0


************************
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitspacer

******************************************************************
* SUBCIRCUIT: c73p1rfshdxrom2048x32hb4img108_bitbundle
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_bitbundle odout pwren_out vccd_1p0
+ vccdgt_1p0 sdlclkin pwren_in rwlt[0] rwlt[1] rwlt[2] rwlt[3] rwlt[4] rwlt[5]
+ rwlt[6] rwlt[7] rwlt[8] rwlt[9] rwlt[10] rwlt[11] rwlt[12] rwlt[13] rwlt[14]
+ rwlt[15] rwlt[16] rwlt[17] rwlt[18] rwlt[19] rwlt[20] rwlt[21] rwlt[22]
+ rwlt[23] rwlt[24] rwlt[25] rwlt[26] rwlt[27] rwlt[28] rwlt[29] rwlt[30]
+ rwlt[31] rwlt[32] rwlt[33] rwlt[34] rwlt[35] rwlt[36] rwlt[37] rwlt[38]
+ rwlt[39] rwlt[40] rwlt[41] rwlt[42] rwlt[43] rwlt[44] rwlt[45] rwlt[46]
+ rwlt[47] rwlt[48] rwlt[49] rwlt[50] rwlt[51] rwlt[52] rwlt[53] rwlt[54]
+ rwlt[55] rwlt[56] rwlt[57] rwlt[58] rwlt[59] rwlt[60] rwlt[61] rwlt[62]
+ rwlt[63] rwlt[64] rwlt[65] rwlt[66] rwlt[67] rwlt[68] rwlt[69] rwlt[70]
+ rwlt[71] rwlt[72] rwlt[73] rwlt[74] rwlt[75] rwlt[76] rwlt[77] rwlt[78]
+ rwlt[79] rwlt[80] rwlt[81] rwlt[82] rwlt[83] rwlt[84] rwlt[85] rwlt[86]
+ rwlt[87] rwlt[88] rwlt[89] rwlt[90] rwlt[91] rwlt[92] rwlt[93] rwlt[94]
+ rwlt[95] rwlt[96] rwlt[97] rwlt[98] rwlt[99] rwlt[100] rwlt[101] rwlt[102]
+ rwlt[103] rwlt[104] rwlt[105] rwlt[106] rwlt[107] rwlt[108] rwlt[109]
+ rwlt[110] rwlt[111] rwlt[112] rwlt[113] rwlt[114] rwlt[115] rwlt[116]
+ rwlt[117] rwlt[118] rwlt[119] rwlt[120] rwlt[121] rwlt[122] rwlt[123]
+ rwlt[124] rwlt[125] rwlt[126] rwlt[127] rwlt[128] rwlt[129] rwlt[130]
+ rwlt[131] rwlt[132] rwlt[133] rwlt[134] rwlt[135] rwlt[136] rwlt[137]
+ rwlt[138] rwlt[139] rwlt[140] rwlt[141] rwlt[142] rwlt[143] rwlt[144]
+ rwlt[145] rwlt[146] rwlt[147] rwlt[148] rwlt[149] rwlt[150] rwlt[151]
+ rwlt[152] rwlt[153] rwlt[154] rwlt[155] rwlt[156] rwlt[157] rwlt[158]
+ rwlt[159] rwlt[160] rwlt[161] rwlt[162] rwlt[163] rwlt[164] rwlt[165]
+ rwlt[166] rwlt[167] rwlt[168] rwlt[169] rwlt[170] rwlt[171] rwlt[172]
+ rwlt[173] rwlt[174] rwlt[175] rwlt[176] rwlt[177] rwlt[178] rwlt[179]
+ rwlt[180] rwlt[181] rwlt[182] rwlt[183] rwlt[184] rwlt[185] rwlt[186]
+ rwlt[187] rwlt[188] rwlt[189] rwlt[190] rwlt[191] rwlt[192] rwlt[193]
+ rwlt[194] rwlt[195] rwlt[196] rwlt[197] rwlt[198] rwlt[199] rwlt[200]
+ rwlt[201] rwlt[202] rwlt[203] rwlt[204] rwlt[205] rwlt[206] rwlt[207]
+ rwlt[208] rwlt[209] rwlt[210] rwlt[211] rwlt[212] rwlt[213] rwlt[214]
+ rwlt[215] rwlt[216] rwlt[217] rwlt[218] rwlt[219] rwlt[220] rwlt[221]
+ rwlt[222] rwlt[223] rwlt[224] rwlt[225] rwlt[226] rwlt[227] rwlt[228]
+ rwlt[229] rwlt[230] rwlt[231] rwlt[232] rwlt[233] rwlt[234] rwlt[235]
+ rwlt[236] rwlt[237] rwlt[238] rwlt[239] rwlt[240] rwlt[241] rwlt[242]
+ rwlt[243] rwlt[244] rwlt[245] rwlt[246] rwlt[247] rwlt[248] rwlt[249]
+ rwlt[250] rwlt[251] rwlt[252] rwlt[253] rwlt[254] rwlt[255] cm[0] cm[1] cm[2]
+ cm[3] cm[4] cm[5] cm[6] cm[7] cm[8] cm[9] cm[10] cm[11] cm[12] cm[13] cm[14]
+ cm[15] cm[16] cm[17] cm[18] cm[19] cm[20] cm[21] cm[22] cm[23] cm[24] cm[25]
+ cm[26] cm[27] cm[28] cm[29] cm[30] cm[31] lblpchglft[0] lblpchglft[1]
+ lblpchglft[2] lblpchglft[3] lblpchgrgt[0] lblpchgrgt[1] lblpchgrgt[2]
+ lblpchgrgt[3]
* INPUT: pwren_in
* OUTPUT: odout pwren_out
* INOUT: vccd_1p0 vccdgt_1p0 sdlclkin rwlt[0] rwlt[1] rwlt[2] rwlt[3] rwlt[4]
*+ rwlt[5] rwlt[6] rwlt[7] rwlt[8] rwlt[9] rwlt[10] rwlt[11] rwlt[12] rwlt[13]
*+ rwlt[14] rwlt[15] rwlt[16] rwlt[17] rwlt[18] rwlt[19] rwlt[20] rwlt[21]
*+ rwlt[22] rwlt[23] rwlt[24] rwlt[25] rwlt[26] rwlt[27] rwlt[28] rwlt[29]
*+ rwlt[30] rwlt[31] rwlt[32] rwlt[33] rwlt[34] rwlt[35] rwlt[36] rwlt[37]
*+ rwlt[38] rwlt[39] rwlt[40] rwlt[41] rwlt[42] rwlt[43] rwlt[44] rwlt[45]
*+ rwlt[46] rwlt[47] rwlt[48] rwlt[49] rwlt[50] rwlt[51] rwlt[52] rwlt[53]
*+ rwlt[54] rwlt[55] rwlt[56] rwlt[57] rwlt[58] rwlt[59] rwlt[60] rwlt[61]
*+ rwlt[62] rwlt[63] rwlt[64] rwlt[65] rwlt[66] rwlt[67] rwlt[68] rwlt[69]
*+ rwlt[70] rwlt[71] rwlt[72] rwlt[73] rwlt[74] rwlt[75] rwlt[76] rwlt[77]
*+ rwlt[78] rwlt[79] rwlt[80] rwlt[81] rwlt[82] rwlt[83] rwlt[84] rwlt[85]
*+ rwlt[86] rwlt[87] rwlt[88] rwlt[89] rwlt[90] rwlt[91] rwlt[92] rwlt[93]
*+ rwlt[94] rwlt[95] rwlt[96] rwlt[97] rwlt[98] rwlt[99] rwlt[100] rwlt[101]
*+ rwlt[102] rwlt[103] rwlt[104] rwlt[105] rwlt[106] rwlt[107] rwlt[108]
*+ rwlt[109] rwlt[110] rwlt[111] rwlt[112] rwlt[113] rwlt[114] rwlt[115]
*+ rwlt[116] rwlt[117] rwlt[118] rwlt[119] rwlt[120] rwlt[121] rwlt[122]
*+ rwlt[123] rwlt[124] rwlt[125] rwlt[126] rwlt[127] rwlt[128] rwlt[129]
*+ rwlt[130] rwlt[131] rwlt[132] rwlt[133] rwlt[134] rwlt[135] rwlt[136]
*+ rwlt[137] rwlt[138] rwlt[139] rwlt[140] rwlt[141] rwlt[142] rwlt[143]
*+ rwlt[144] rwlt[145] rwlt[146] rwlt[147] rwlt[148] rwlt[149] rwlt[150]
*+ rwlt[151] rwlt[152] rwlt[153] rwlt[154] rwlt[155] rwlt[156] rwlt[157]
*+ rwlt[158] rwlt[159] rwlt[160] rwlt[161] rwlt[162] rwlt[163] rwlt[164]
*+ rwlt[165] rwlt[166] rwlt[167] rwlt[168] rwlt[169] rwlt[170] rwlt[171]
*+ rwlt[172] rwlt[173] rwlt[174] rwlt[175] rwlt[176] rwlt[177] rwlt[178]
*+ rwlt[179] rwlt[180] rwlt[181] rwlt[182] rwlt[183] rwlt[184] rwlt[185]
*+ rwlt[186] rwlt[187] rwlt[188] rwlt[189] rwlt[190] rwlt[191] rwlt[192]
*+ rwlt[193] rwlt[194] rwlt[195] rwlt[196] rwlt[197] rwlt[198] rwlt[199]
*+ rwlt[200] rwlt[201] rwlt[202] rwlt[203] rwlt[204] rwlt[205] rwlt[206]
*+ rwlt[207] rwlt[208] rwlt[209] rwlt[210] rwlt[211] rwlt[212] rwlt[213]
*+ rwlt[214] rwlt[215] rwlt[216] rwlt[217] rwlt[218] rwlt[219] rwlt[220]
*+ rwlt[221] rwlt[222] rwlt[223] rwlt[224] rwlt[225] rwlt[226] rwlt[227]
*+ rwlt[228] rwlt[229] rwlt[230] rwlt[231] rwlt[232] rwlt[233] rwlt[234]
*+ rwlt[235] rwlt[236] rwlt[237] rwlt[238] rwlt[239] rwlt[240] rwlt[241]
*+ rwlt[242] rwlt[243] rwlt[244] rwlt[245] rwlt[246] rwlt[247] rwlt[248]
*+ rwlt[249] rwlt[250] rwlt[251] rwlt[252] rwlt[253] rwlt[254] rwlt[255] cm[0]
*+ cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] cm[8] cm[9] cm[10] cm[11] cm[12]
*+ cm[13] cm[14] cm[15] cm[16] cm[17] cm[18] cm[19] cm[20] cm[21] cm[22] cm[23]
*+ cm[24] cm[25] cm[26] cm[27] cm[28] cm[29] cm[30] cm[31] lblpchglft[0]
*+ lblpchglft[1] lblpchglft[2] lblpchglft[3] lblpchgrgt[0] lblpchgrgt[1]
*+ lblpchgrgt[2] lblpchgrgt[3]
*datio_r0c0 c73p4hdxrom_datio 00
Xdatio_r0c0  odout gbl pwren_in pwren_out sdlclkin vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_datio
*bitbundle_r0c0 c73p4hdxrom_bitslicearray32v2bit0 00
Xbitbundle_r0c0  cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] gbl
+ lblpchglft[0] lblpchgrgt[0] rwlt[0] rwlt[1] rwlt[2] rwlt[3] rwlt[4]
+ rwlt[5] rwlt[6] rwlt[7] rwlt[8] rwlt[9] rwlt[10] rwlt[11] rwlt[12]
+ rwlt[13] rwlt[14] rwlt[15] rwlt[16] rwlt[17] rwlt[18] rwlt[19] rwlt[20]
+ rwlt[21] rwlt[22] rwlt[23] rwlt[24] rwlt[25] rwlt[26] rwlt[27] rwlt[28]
+ rwlt[29] rwlt[30] rwlt[31] rwlt[32] rwlt[33] rwlt[34] rwlt[35] rwlt[36]
+ rwlt[37] rwlt[38] rwlt[39] rwlt[40] rwlt[41] rwlt[42] rwlt[43] rwlt[44]
+ rwlt[45] rwlt[46] rwlt[47] rwlt[48] rwlt[49] rwlt[50] rwlt[51] rwlt[52]
+ rwlt[53] rwlt[54] rwlt[55] rwlt[56] rwlt[57] rwlt[58] rwlt[59] rwlt[60]
+ rwlt[61] rwlt[62] rwlt[63] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitslicearray32v2bit0
*bitbundle_r1c0 c73p4hdxrom_bitslicearray32v2bit0 5120
Xbitbundle_r1c0  cm[8] cm[9] cm[10] cm[11] cm[12] cm[13] cm[14] cm[15] gbl
+ lblpchglft[1] lblpchgrgt[1] rwlt[64] rwlt[65] rwlt[66] rwlt[67] rwlt[68]
+ rwlt[69] rwlt[70] rwlt[71] rwlt[72] rwlt[73] rwlt[74] rwlt[75] rwlt[76]
+ rwlt[77] rwlt[78] rwlt[79] rwlt[80] rwlt[81] rwlt[82] rwlt[83] rwlt[84]
+ rwlt[85] rwlt[86] rwlt[87] rwlt[88] rwlt[89] rwlt[90] rwlt[91] rwlt[92]
+ rwlt[93] rwlt[94] rwlt[95] rwlt[96] rwlt[97] rwlt[98] rwlt[99] rwlt[100]
+ rwlt[101] rwlt[102] rwlt[103] rwlt[104] rwlt[105] rwlt[106] rwlt[107]
+ rwlt[108] rwlt[109] rwlt[110] rwlt[111] rwlt[112] rwlt[113] rwlt[114]
+ rwlt[115] rwlt[116] rwlt[117] rwlt[118] rwlt[119] rwlt[120] rwlt[121]
+ rwlt[122] rwlt[123] rwlt[124] rwlt[125] rwlt[126] rwlt[127] vccd_1p0
+ vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitslicearray32v2bit0
*bitbundle_r2c0 c73p4hdxrom_bitslicearray32v2bit0 10240
Xbitbundle_r2c0  cm[16] cm[17] cm[18] cm[19] cm[20] cm[21] cm[22] cm[23]
+ gbl lblpchglft[2] lblpchgrgt[2] rwlt[128] rwlt[129] rwlt[130] rwlt[131]
+ rwlt[132] rwlt[133] rwlt[134] rwlt[135] rwlt[136] rwlt[137] rwlt[138]
+ rwlt[139] rwlt[140] rwlt[141] rwlt[142] rwlt[143] rwlt[144] rwlt[145]
+ rwlt[146] rwlt[147] rwlt[148] rwlt[149] rwlt[150] rwlt[151] rwlt[152]
+ rwlt[153] rwlt[154] rwlt[155] rwlt[156] rwlt[157] rwlt[158] rwlt[159]
+ rwlt[160] rwlt[161] rwlt[162] rwlt[163] rwlt[164] rwlt[165] rwlt[166]
+ rwlt[167] rwlt[168] rwlt[169] rwlt[170] rwlt[171] rwlt[172] rwlt[173]
+ rwlt[174] rwlt[175] rwlt[176] rwlt[177] rwlt[178] rwlt[179] rwlt[180]
+ rwlt[181] rwlt[182] rwlt[183] rwlt[184] rwlt[185] rwlt[186] rwlt[187]
+ rwlt[188] rwlt[189] rwlt[190] rwlt[191] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitslicearray32v2bit0
*bitbundle_r3c0 c73p4hdxrom_bitslicearray32v2bit0 15360
Xbitbundle_r3c0  cm[24] cm[25] cm[26] cm[27] cm[28] cm[29] cm[30] cm[31]
+ gbl lblpchglft[3] lblpchgrgt[3] rwlt[192] rwlt[193] rwlt[194] rwlt[195]
+ rwlt[196] rwlt[197] rwlt[198] rwlt[199] rwlt[200] rwlt[201] rwlt[202]
+ rwlt[203] rwlt[204] rwlt[205] rwlt[206] rwlt[207] rwlt[208] rwlt[209]
+ rwlt[210] rwlt[211] rwlt[212] rwlt[213] rwlt[214] rwlt[215] rwlt[216]
+ rwlt[217] rwlt[218] rwlt[219] rwlt[220] rwlt[221] rwlt[222] rwlt[223]
+ rwlt[224] rwlt[225] rwlt[226] rwlt[227] rwlt[228] rwlt[229] rwlt[230]
+ rwlt[231] rwlt[232] rwlt[233] rwlt[234] rwlt[235] rwlt[236] rwlt[237]
+ rwlt[238] rwlt[239] rwlt[240] rwlt[241] rwlt[242] rwlt[243] rwlt[244]
+ rwlt[245] rwlt[246] rwlt[247] rwlt[248] rwlt[249] rwlt[250] rwlt[251]
+ rwlt[252] rwlt[253] rwlt[254] rwlt[255] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitslicearray32v2bit0
*bitspcr_r0c0 c73p4hdxrom_bitspacer 00
Xbitspcr_r0c0  gbl vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitspacer
*bitspcr_r1c0 c73p4hdxrom_bitspacer 00
Xbitspcr_r1c0  gbl vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitspacer
*bitspcr_r2c0 c73p4hdxrom_bitspacer 00
Xbitspcr_r2c0  gbl vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_bitspacer
.ENDS c73p1rfshdxrom2048x32hb4img108_bitbundle

******************************************************************
* SUBCIRCUIT: da9bfn00xwse0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9bfn00xwse0 a o vccxx
* INPUT: a vccxx
* OUTPUT: o
* INOUT:


************************
Mqn0 o n1 vss vss nxlllp L=0.042u W=0.336u
Mqn1 n1 a vss vss nxlllp L=0.042u W=0.084u
Mqp0 o n1 vccxx vccxx pxlllp L=0.042u W=0.336u
Mqp1 n1 a vccxx vccxx pxlllp L=0.042u W=0.084u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9bfn00xwse0

******************************************************************
* SUBCIRCUIT: da9bfn00xwsh7
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsh7 a o vccxx
* INPUT: a vccxx
* OUTPUT: o
* INOUT:


************************
Mqn0 o n1 vss vss nxlllp L=0.042u W=2.268u
Mqn1 n1 a vss vss nxlllp L=0.042u W=0.84u
Mqp0 o n1 vccxx vccxx pxlllp L=0.042u W=2.268u
Mqp1 n1 a vccxx vccxx pxlllp L=0.042u W=0.84u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsh7

******************************************************************
* SUBCIRCUIT: da9mbf01xwsb0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9mbf01xwsb0 a o vccxx
* INPUT: a vccxx
* OUTPUT: o
* INOUT:


************************
Mqn0 o n0 n4p vss nxlllp L=0.042u W=0.084u
Mqn1 n2p a vss vss nxlllp L=0.042u W=0.084u
Mqn2 n0 a n2p vss nxlllp L=0.042u W=0.084u
Mqn3 n4p n0 vss vss nxlllp L=0.042u W=0.084u
Mqp0 o n0 n3p vccxx pxlllp L=0.042u W=0.084u
Mqp1 n1p a vccxx vccxx pxlllp L=0.042u W=0.084u
Mqp2 n0 a n1p vccxx pxlllp L=0.042u W=0.084u
Mqp3 n3p n0 vccxx vccxx pxlllp L=0.042u W=0.084u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9mbf01xwsb0

******************************************************************
* SUBCIRCUIT: da9bfn00xwsh0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsh0 a o vccxx
* INPUT: a vccxx
* OUTPUT: o
* INOUT:


************************
Mqn0 o n1 vss vss nxlllp L=0.042u W=1.512u
Mqn1 n1 a vss vss nxlllp L=0.042u W=0.42u
Mqp0 o n1 vccxx vccxx pxlllp L=0.042u W=1.512u
Mqp1 n1 a vccxx vccxx pxlllp L=0.042u W=0.42u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsh0

******************************************************************
* SUBCIRCUIT: da9bfn00xwsb0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsb0 a o vccxx
* INPUT: a vccxx
* OUTPUT: o
* INOUT:


************************
Mqn0 o n1 vss vss nxlllp L=0.042u W=0.084u
Mqn1 n1 a vss vss nxlllp L=0.042u W=0.084u
Mqp0 o n1 vccxx vccxx pxlllp L=0.042u W=0.084u
Mqp1 n1 a vccxx vccxx pxlllp L=0.042u W=0.084u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsb0

******************************************************************
* SUBCIRCUIT: da9inn00xwsf5
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5 a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=0.756u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.756u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5

******************************************************************
* SUBCIRCUIT: da9nan03xwsd0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9nan03xwsd0 a b c o1 vccxx
* INPUT: a b c vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a n1 vss nxlllp L=0.042u W=0.21u
Mqn2 n1 b n2 vss nxlllp L=0.042u W=0.21u
Mqn3 n2 c vss vss nxlllp L=0.042u W=0.21u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.126u
Mqp2 o1 b vccxx vccxx pxlllp L=0.042u W=0.126u
Mqp3 o1 c vccxx vccxx pxlllp L=0.042u W=0.126u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9nan03xwsd0

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_cmdec
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_cmdec a[0] a[1] a[2]
+ cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] vccxx
* INPUT: a[0] a[1] a[2] vccxx
* OUTPUT: cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7]
* INOUT:


************************
Xbfn0[0] a[0] abuff[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsb0
Xbfn0[1] a[1] abuff[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsb0
Xbfn0[2] a[2] abuff[2] vccxx c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsb0
Xinn0[0] abuff[0] ab[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
Xinn0[1] abuff[1] ab[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
Xinn0[2] abuff[2] ab[2] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
Xinn1[0] ab[0] abb[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc0
Xinn1[1] ab[1] abb[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc0
Xinn1[2] ab[2] abb[2] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc0
Xinn2 c[4] cm[4] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5
Xinn3 c[5] cm[5] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5
Xinn4 c[6] cm[6] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5
Xinn5 c[7] cm[7] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5
Xinn6 c[3] cm[3] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5
Xinn7 c[2] cm[2] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5
Xinn8 c[1] cm[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5
Xinn9 c[0] cm[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5
Xnan0 abb[2] ab[1] ab[0] c[4] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwsd0
Xnan1 abb[2] ab[1] abb[0] c[5] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwsd0
Xnan2 abb[2] abb[1] ab[0] c[6] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwsd0
Xnan3 abb[2] abb[1] abb[0] c[7] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwsd0
Xnan4 ab[2] abb[1] abb[0] c[3] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwsd0
Xnan5 ab[2] abb[1] ab[0] c[2] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwsd0
Xnan6 ab[2] ab[1] abb[0] c[1] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwsd0
Xnan7 ab[2] ab[1] ab[0] c[0] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwsd0
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_cmdec

******************************************************************
* SUBCIRCUIT: da9lan80xwsc5
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9lan80xwsc5 clkb d o vccxx
* INPUT: clkb d vccxx
* OUTPUT: o
* INOUT:


************************
Mg0.qns n1 n3 n4 vss nxlllp L=0.042u W=0.084u
Mg0.qpsb n1 clkb n4 vccxx pxlllp L=0.042u W=0.084u
Mg1.qna n4 d vss vss nxlllp L=0.042u W=0.126u
Mg1.qpa n4 d vccxx vccxx pxlllp L=0.042u W=0.126u
Mg101.qna o n1 vss vss nxlllp L=0.042u W=0.126u
Mg101.qpa o n1 vccxx vccxx pxlllp L=0.042u W=0.126u
Mg3.qna n3 clkb vss vss nxlllp L=0.042u W=0.084u
Mg3.qpa n3 clkb vccxx vccxx pxlllp L=0.042u W=0.084u
Mg4.qnck n1 clkb g4.n2 vss nxlllp L=0.042u W=0.084u
Mg4.qnd g4.n2 n2 vss vss nxlllp L=0.042u W=0.084u
Mg4.qpckb n1 n3 g4.n1 vccxx pxlllp L=0.042u W=0.084u
Mg4.qpd g4.n1 n2 vccxx vccxx pxlllp L=0.042u W=0.084u
Mg99.qna n2 n1 vss vss nxlllp L=0.042u W=0.084u
Mg99.qpa n2 n1 vccxx vccxx pxlllp L=0.042u W=0.084u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9lan80xwsc5

******************************************************************
* SUBCIRCUIT: da9lan80xwsd0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9lan80xwsd0 clkb d o vccxx
* INPUT: clkb d vccxx
* OUTPUT: o
* INOUT:


************************
Mg0.qns n1 n3 n4 vss nxlllp L=0.042u W=0.084u
Mg0.qpsb n1 clkb n4 vccxx pxlllp L=0.042u W=0.084u
Mg1.qna n4 d vss vss nxlllp L=0.042u W=0.126u
Mg1.qpa n4 d vccxx vccxx pxlllp L=0.042u W=0.126u
Mg101.qna o n1 vss vss nxlllp L=0.042u W=0.168u
Mg101.qpa o n1 vccxx vccxx pxlllp L=0.042u W=0.168u
Mg3.qna n3 clkb vss vss nxlllp L=0.042u W=0.084u
Mg3.qpa n3 clkb vccxx vccxx pxlllp L=0.042u W=0.084u
Mg4.qnck n1 clkb g4.n2 vss nxlllp L=0.042u W=0.084u
Mg4.qnd g4.n2 n2 vss vss nxlllp L=0.042u W=0.084u
Mg4.qpckb n1 n3 g4.n1 vccxx pxlllp L=0.042u W=0.084u
Mg4.qpd g4.n1 n2 vccxx vccxx pxlllp L=0.042u W=0.084u
Mg99.qna n2 n1 vss vss nxlllp L=0.042u W=0.084u
Mg99.qpa n2 n1 vccxx vccxx pxlllp L=0.042u W=0.084u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9lan80xwsd0

******************************************************************
* SUBCIRCUIT: da9inn00xwsg5
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5 a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=1.26u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=1.26u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5

******************************************************************
* SUBCIRCUIT: da9inn00xwsg0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0 a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=1.008u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=1.008u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0

******************************************************************
* SUBCIRCUIT: da9nan02xwsd0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0 a b o1 vccxx
* INPUT: a b vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a n1 vss nxlllp L=0.042u W=0.21u
Mqn2 n1 b vss vss nxlllp L=0.042u W=0.21u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.168u
Mqp2 o1 b vccxx vccxx pxlllp L=0.042u W=0.168u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_rwdec
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rwdec a[0] a[1] rw[0]
+ rw[1] rw[2] rw[3] vccxx
* INPUT: a[0] a[1] vccxx
* OUTPUT: rw[0] rw[1] rw[2] rw[3]
* INOUT:


************************
Xinn0[0] a[0] ab[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
Xinn0[1] a[1] ab[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
Xinn1[0] ab[0] abb[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc0
Xinn1[1] ab[1] abb[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc0
Xinn2 w[0] rw[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn3 w[1] rw[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn4 w[2] rw[2] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn5 w[3] rw[3] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xnan0 ab[1] ab[0] w[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan1 ab[1] abb[0] w[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan2 abb[1] ab[0] w[2] vccxx c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan3 abb[1] abb[0] w[3] vccxx c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rwdec

******************************************************************
* SUBCIRCUIT: da9inn00xwsd5
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5 a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=0.252u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.252u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5

******************************************************************
* SUBCIRCUIT: da9inn00xwsf0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf0 a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=0.63u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.63u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf0

******************************************************************
* SUBCIRCUIT: da9inn00xwsi3
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9inn00xwsi3 a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=2.94u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=2.94u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9inn00xwsi3

******************************************************************
* SUBCIRCUIT: da9nan03xwse7
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9nan03xwse7 a b c o1 vccxx
* INPUT: a b c vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a n1 vss nxlllp L=0.042u W=0.504u
Mqn2 n1 b n2 vss nxlllp L=0.042u W=0.504u
Mqn3 n2 c vss vss nxlllp L=0.042u W=0.504u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.336u
Mqp2 o1 b vccxx vccxx pxlllp L=0.042u W=0.336u
Mqp3 o1 c vccxx vccxx pxlllp L=0.042u W=0.336u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9nan03xwse7

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_rxdec
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rxdec a[0] a[1] a[2]
+ rx[0] rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] vccxx
* INPUT: a[0] a[1] a[2] vccxx
* OUTPUT: rx[0] rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7]
* INOUT:


************************
Xinn0[0] a[0] ab[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinn0[1] a[1] ab[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinn0[2] a[2] ab[2] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinn1[0] ab[0] abb[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf0
Xinn1[1] ab[1] abb[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf0
Xinn1[2] ab[2] abb[2] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf0
Xinn2 x[4] rx[4] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsi3
Xinn3 x[5] rx[5] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsi3
Xinn4 x[6] rx[6] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsi3
Xinn5 x[7] rx[7] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsi3
Xinn6 x[3] rx[3] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsi3
Xinn7 x[2] rx[2] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsi3
Xinn8 x[1] rx[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsi3
Xinn9 x[0] rx[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsi3
Xnan0 abb[2] ab[1] ab[0] x[4] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwse7
Xnan1 abb[2] ab[1] abb[0] x[5] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwse7
Xnan2 abb[2] abb[1] ab[0] x[6] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwse7
Xnan3 abb[2] abb[1] abb[0] x[7] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwse7
Xnan4 ab[2] abb[1] abb[0] x[3] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwse7
Xnan5 ab[2] abb[1] ab[0] x[2] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwse7
Xnan6 ab[2] ab[1] abb[0] x[1] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwse7
Xnan7 ab[2] ab[1] ab[0] x[0] vccxx
+ c73p1rfshdxrom2048x32hb4img108_da9nan03xwse7
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rxdec

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_rydec
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rydec a[0] a[1] ry[0]
+ ry[1] ry[2] ry[3] vccxx
* INPUT: a[0] a[1] vccxx
* OUTPUT: ry[0] ry[1] ry[2] ry[3]
* INOUT:


************************
Xinn0[0] a[0] ab[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
Xinn0[1] a[1] ab[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
Xinn1[0] ab[0] abb[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc0
Xinn1[1] ab[1] abb[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc0
Xinn2 y[0] ry[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5
Xinn3 y[1] ry[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5
Xinn4 y[2] ry[2] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5
Xinn5 y[3] ry[3] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5
Xnan0 ab[1] ab[0] y[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan1 ab[1] abb[0] y[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan2 abb[1] ab[0] y[2] vccxx c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan3 abb[1] abb[0] y[3] vccxx c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rydec

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_rzdec
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rzdec a0 rz[0] rz[1]
+ vccxx
* INPUT: a0 vccxx
* OUTPUT: rz[0] rz[1]
* INOUT:


************************
Xinn0 rz[0] rz[1] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf0
Xinn1 a0 rz[0] vccxx c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf5
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rzdec

******************************************************************
* SUBCIRCUIT: da9nan02xwse0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9nan02xwse0 a b o1 vccxx
* INPUT: a b vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a n1 vss nxlllp L=0.042u W=0.336u
Mqn2 n1 b vss vss nxlllp L=0.042u W=0.336u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.252u
Mqp2 o1 b vccxx vccxx pxlllp L=0.042u W=0.252u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9nan02xwse0

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_sdlchopper
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_sdlchopper clkin clkout
+ vccxx
* INPUT: clkin vccxx
* OUTPUT: clkout
* INOUT:


************************
Xibuff0 clkin pch2 vccxx c73p1rfshdxrom2048x32hb4img108_da9mbf01xwsb0
Xibuff1 pch2 pch3 vccxx c73p1rfshdxrom2048x32hb4img108_da9mbf01xwsb0
Xibuff2 pch3 pch4 vccxx c73p1rfshdxrom2048x32hb4img108_da9mbf01xwsb0
Xibuff3 pch4 pch5 vccxx c73p1rfshdxrom2048x32hb4img108_da9mbf01xwsb0
Xibuff4 pch5 pch6 vccxx c73p1rfshdxrom2048x32hb4img108_da9mbf01xwsb0
Xnan1 clkin pch6 clkout vccxx c73p1rfshdxrom2048x32hb4img108_da9nan02xwse0
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_sdlchopper

******************************************************************
* SUBCIRCUIT: da9nan02xwsg0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9nan02xwsg0 a b o1 vccxx
* INPUT: a b vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a n1 vss nxlllp L=0.042u W=0.84u
Mqn2 n1 b vss vss nxlllp L=0.042u W=0.84u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.84u
Mqp2 o1 b vccxx vccxx pxlllp L=0.042u W=0.84u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9nan02xwsg0

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_ctrl
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_ctrl cm[0] cm[1] cm[2]
+ cm[3] cm[4] cm[5] cm[6] cm[7] gclkbout iar[0] iar[1] iar[2] iar[3] iar[4]
+ iar[5] iar[6] iar[7] iar[8]  iar[9] iar[10] irclk iren pwr_ctrlio
+ pwr_ioctrl rw[0] rw[1] rw[2] rw[3] rx[0]  rx[1] rx[2] rx[3] rx[4] rx[5]
+ rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1]  sdlclkbot sdlclktop
+ vccd_1p0 vccdgt_1p0
* INPUT: iar[0] iar[1] iar[2] iar[3] iar[4] iar[5] iar[6] iar[7] iar[8]
*+ iar[9] iar[10] irclk iren
* OUTPUT: cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] gclkbout rw[0]
*+ rw[1] rw[2] rw[3] rx[0] rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] ry[0]
*+ ry[1] ry[2] ry[3] rz[0] rz[1] sdlclkbot sdlclktop
* INOUT: pwr_ctrlio pwr_ioctrl vccd_1p0 vccdgt_1p0


************************
Xbfn4 gclkmb gclkmbbf vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9bfn00xwse0
Xibfckr irclk rclkbuff vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsh7
Xiclk0 gclk gclkbf1 vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9mbf01xwsb0
Xiclk1 gclkbf1 gclkbf2 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsh0
Xicmdec lataddrb[0] lataddrb[1] lataddrb[2] cm[0] cm[1] cm[2] cm[3] cm[4]
+ cm[5] cm[6] cm[7] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_cmdec
Xilatchaddr[0] gclkbf2 iar[0] lataddrb[0] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9lan80xwsc5
Xilatchaddr[10] gclkbf2 iar[10] lataddrb[10] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9lan80xwsc5
Xilatchaddr[1] gclkbf2 iar[1] lataddrb[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9lan80xwsc5
Xilatchaddr[2] gclkbf2 iar[2] lataddrb[2] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9lan80xwsc5
Xilatchaddr[3] gclkbf2 iar[3] lataddrb[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9lan80xwsc5
Xilatchaddr[4] gclkbf2 iar[4] lataddrb[4] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9lan80xwsc5
Xilatchaddr[5] gclkbf2 iar[5] lataddrb[5] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9lan80xwsc5
Xilatchaddr[6] gclkbf2 iar[6] lataddrb[6] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9lan80xwsc5
Xilatchaddr[7] gclkbf2 iar[7] lataddrb[7] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9lan80xwsc5
Xilatchaddr[8] gclkbf2 iar[8] lataddrb[8] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9lan80xwsc5
Xilatchaddr[9] gclkbf2 iar[9] lataddrb[9] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9lan80xwsc5
Xilatchren rclkbuff iren latren vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9lan80xwsd0
Xinn0 gclk gclkbout vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9inn00xwsh3
Xinn10 sdlclkmb sdlclktop vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5
Xinn11 sdlclkmb sdlclkbot vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5
Xinn6 gclkb gclk vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn9 gclk gclkmb vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
Xirwdec lataddrb[3] lataddrb[4] rw[0] rw[1] rw[2] rw[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rwdec
Xirxdec lataddrb[5] lataddrb[6] lataddrb[7] rx[0] rx[1] rx[2] rx[3] rx[4]
+ rx[5] rx[6] rx[7] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rxdec
Xirydec lataddrb[8] lataddrb[9] ry[0] ry[1] ry[2] ry[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rydec
Xirzdec lataddrb[10] rz[0] rz[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rzdec
Xisdlchopper gclkmbbf sdlclkmb vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_sdlchopper
Xnan0 rclkbuff latren gclkb vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsg0
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_ctrl

******************************************************************
* SUBCIRCUIT: da9inn00xwsd0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd0 a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=0.21u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.21u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd0

******************************************************************
* SUBCIRCUIT: da9inn00xwsc7
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc7 a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=0.168u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.168u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc7

******************************************************************
* SUBCIRCUIT: da9inn00xwsf7
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf7 a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=0.84u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.84u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf7

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_wldrvgappwrcell
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvgappwrcell pwren_in
+ pwren_inbuf pwren_out pwren_outbuf vccd_1p0 vccdgt_1p0
* INPUT: pwren_in pwren_inbuf vccd_1p0
* OUTPUT: pwren_out pwren_outbuf vccdgt_1p0
* INOUT:


************************
Mqn0 pwren_out n38 vss vss nxlllp L=0.042u W=0.84u
Mqn1 n38 pwren_in vss vss nxlllp L=0.042u W=0.21u
Mqn2 pwren_outbuf n045 vss vss nxlllp L=0.042u W=0.84u
Mqn3 n045 pwren_inbuf vss vss nxlllp L=0.042u W=0.21u
Mqp0 pwren_out n38 vccd_1p0 vccd_1p0 pxlllp L=0.042u W=0.84u
Mqp1 n38 pwren_in vccd_1p0 vccd_1p0 pxlllp L=0.042u W=0.21u
Mqp2 vccdgt_1p0 pwren_out vccd_1p0 vccd_1p0 pxlllp L=0.042u W=18.816u
Mqp3 pwren_outbuf n045 vccd_1p0 vccd_1p0 pxlllp L=0.042u W=0.84u
Mqp4 n045 pwren_inbuf vccd_1p0 vccd_1p0 pxlllp L=0.042u W=0.21u
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvgappwrcell

******************************************************************
* SUBCIRCUIT: da9nan02xwse7
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9nan02xwse7 a b o1 vccxx
* INPUT: a b vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a n1 vss nxlllp L=0.042u W=0.504u
Mqn2 n1 b vss vss nxlllp L=0.042u W=0.504u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.42u
Mqp2 o1 b vccxx vccxx pxlllp L=0.042u W=0.42u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9nan02xwse7

******************************************************************
* SUBCIRCUIT: da9nan23xwsh0
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_da9nan23xwsh0 a b c o1 vccxx
* INPUT: a b c vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a n1 vss nxlllp L=0.042u W=1.512u
Mqn2 n1 b n2 vss nxlllp L=0.042u W=1.512u
Mqn3 n2 c vss vss nxlllp L=0.042u W=1.512u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=0.588u
Mqp2 o1 b vccxx vccxx pxlllp L=0.042u W=0.588u
Mqp3 o1 c vccxx vccxx pxlllp L=0.042u W=0.588u
.ENDS c73p1rfshdxrom2048x32hb4img108_da9nan23xwsh0

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_wldrvgap
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvgap brclklft
+ brclkrgt cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] cmselbot[0]
+ cmselbot[1] cmselbot[2] cmselbot[3] cmselbot[4]  cmselbot[5] cmselbot[6]
+ cmselbot[7] cmseltop[0] cmseltop[1] cmseltop[2]  cmseltop[3] cmseltop[4]
+ cmseltop[5] cmseltop[6] cmseltop[7] lblpchglftbb  lblpchglfttb
+ lblpchgrgtbb lblpchgrgttb pwren_in pwren_inbuf pwren_out  pwren_outbuf
+ rclk rw[0] rw[1] rw[2] rw[3] rwbuffleft[0] rwbuffleft[1]  rwbuffleft[2]
+ rwbuffleft[3] rwbuffright[0] rwbuffright[1] rwbuffright[2]
+ rwbuffright[3] rx[0] rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] rxx[0]
+ rxx[1]  rxx[2] rxx[3] rxx[4] rxx[5] rxx[6] rxx[7] ry[0] ry[1] ry[2] ry[3]
+ ry0 ry1  rz[0] rz[1] rz0 vccd_1p0 vccdgt_1p0
* INPUT: pwren_in pwren_inbuf ry0 ry1 rz0
* OUTPUT: brclklft brclkrgt cmselbot[0] cmselbot[1] cmselbot[2]
*+ cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7] cmseltop[0]
*+ cmseltop[1] cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6]
*+ cmseltop[7] lblpchglftbb lblpchglfttb lblpchgrgtbb lblpchgrgttb
*+ pwren_out pwren_outbuf rwbuffleft[0] rwbuffleft[1] rwbuffleft[2]
*+ rwbuffleft[3] rwbuffright[0] rwbuffright[1] rwbuffright[2]
*+ rwbuffright[3] rxx[0] rxx[1] rxx[2] rxx[3] rxx[4] rxx[5] rxx[6] rxx[7]
* INOUT: cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] rclk rw[0]
*+ rw[1] rw[2] rw[3] rx[0] rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] ry[0]
*+ ry[1] ry[2] ry[3] rz[0] rz[1] vccd_1p0 vccdgt_1p0


************************
Xbfn0 brclkblft cklbf1 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9mbf01xwsb0
Xbfn3 brclkbrgt ckrbf1 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9mbf01xwsb0
Xbfn5 cklbf1 cklbf2 vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9mbf01xwsb0
Xbfn7 ckrbf1 ckrbf2 vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9mbf01xwsb0
Xicmbf[0] cm[0] cmbff[0] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsb0
Xicmbf[1] cm[1] cmbff[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsb0
Xicmbf[2] cm[2] cmbff[2] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsb0
Xicmbf[3] cm[3] cmbff[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsb0
Xicmbf[4] cm[4] cmbff[4] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsb0
Xicmbf[5] cm[5] cmbff[5] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsb0
Xicmbf[6] cm[6] cmbff[6] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsb0
Xicmbf[7] cm[7] cmbff[7] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9bfn00xwsb0
Xinn10 n168 rz0buf vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd0
Xinn11 rz0 n168 vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
Xinn12[0] n177[0] cmselbot[0] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn12[1] n177[1] cmselbot[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn12[2] n177[2] cmselbot[2] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn12[3] n177[3] cmselbot[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn12[4] n177[4] cmselbot[4] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn12[5] n177[5] cmselbot[5] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn12[6] n177[6] cmselbot[6] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn12[7] n177[7] cmselbot[7] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn13[0] n111[0] cmseltop[0] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn13[1] n111[1] cmseltop[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn13[2] n111[2] cmseltop[2] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn13[3] n111[3] cmseltop[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn13[4] n111[4] cmseltop[4] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn13[5] n111[5] cmseltop[5] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn13[6] n111[6] cmseltop[6] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn13[7] n111[7] cmseltop[7] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn14 brclkbrgt brclkrgt vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5
Xinn15 brclkblft brclklft vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5
Xinn16 lpckrbb lblpchgrgtbb vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn19 lpckltb lblpchglfttb vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn20 lpcklbb lblpchglftbb vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn21 lpckrtb lblpchgrgttb vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg0
Xinn5 rclk rclkmb vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9inn00xwsc7
Xinn6 ry0 n171 vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
Xinn7 n171 n159 vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd0
Xinn8 n165 ry1buf vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd0
Xinn9 ry1 n165 vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_da9inn00xwsb0
Xinnrx0[0] rx[0] rxinv[0] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinnrx0[1] rx[1] rxinv[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinnrx0[2] rx[2] rxinv[2] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinnrx0[3] rx[3] rxinv[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinnrx0[4] rx[4] rxinv[4] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinnrx0[5] rx[5] rxinv[5] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinnrx0[6] rx[6] rxinv[6] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinnrx0[7] rx[7] rxinv[7] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinnrx1[0] rxinv[0] rxx[0] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5
Xinnrx1[1] rxinv[1] rxx[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5
Xinnrx1[2] rxinv[2] rxx[2] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5
Xinnrx1[3] rxinv[3] rxx[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5
Xinnrx1[4] rxinv[4] rxx[4] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5
Xinnrx1[5] rxinv[5] rxx[5] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5
Xinnrx1[6] rxinv[6] rxx[6] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5
Xinnrx1[7] rxinv[7] rxx[7] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsg5
Xinvrwin[0] rw[0] rwb[0] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinvrwin[1] rw[1] rwb[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinvrwin[2] rw[2] rwb[2] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinvrwin[3] rw[3] rwb[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsd5
Xinvrwleft[0] rwb[0] rwbuffleft[0] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf7
Xinvrwleft[1] rwb[1] rwbuffleft[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf7
Xinvrwleft[2] rwb[2] rwbuffleft[2] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf7
Xinvrwleft[3] rwb[3] rwbuffleft[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf7
Xinvrwright[0] rwb[0] rwbuffright[0] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf7
Xinvrwright[1] rwb[1] rwbuffright[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf7
Xinvrwright[2] rwb[2] rwbuffright[2] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf7
Xinvrwright[3] rwb[3] rwbuffright[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9inn00xwsf7
Xipg pwren_in pwren_inbuf pwren_out pwren_outbuf vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvgappwrcell
Xnan0[0] cmbff[0] brclkcomb n111[0] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan0[1] cmbff[1] brclkcomb n111[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan0[2] cmbff[2] brclkcomb n111[2] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan0[3] cmbff[3] brclkcomb n111[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan0[4] cmbff[4] brclkcomb n111[4] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan0[5] cmbff[5] brclkcomb n111[5] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan0[6] cmbff[6] brclkcomb n111[6] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan0[7] cmbff[7] brclkcomb n111[7] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan1[0] cmbff[0] brclkcomb n177[0] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan1[1] cmbff[1] brclkcomb n177[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan1[2] cmbff[2] brclkcomb n177[2] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan1[3] cmbff[3] brclkcomb n177[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan1[4] cmbff[4] brclkcomb n177[4] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan1[5] cmbff[5] brclkcomb n177[5] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan1[6] cmbff[6] brclkcomb n177[6] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan1[7] cmbff[7] brclkcomb n177[7] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan2 brclkblft brclkbrgt brclkcomb vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwse7
Xnan4 brclkbrgt ckrbf2 lpckrbb vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan5 rclkmb ry1buf rz0buf brclkbrgt vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan23xwsh0
Xnan6 rclkmb n159 rz0buf brclkblft vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan23xwsh0
Xnan7 brclkblft cklbf2 lpcklbb vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan8 brclkblft cklbf2 lpckltb vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
Xnan9 brclkbrgt ckrbf2 lpckrtb vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_da9nan02xwsd0
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvgap

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_da7nag43nn0n1
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_da7nag43nn0n1 a0 a1 a2
+ a3 b ck o0 o1 o2 o3 vcc
* INPUT: a0 a1 a2 a3 b ck vcc
* OUTPUT: o0 o1 o2 o3
* INOUT:


************************
Mqn1 o3 a3 n9 vss nxlllp L=0.042u W=0.504u
Mqn2 o2 a2 n9 vss nxlllp L=0.042u W=0.504u
Mqn3 o1 a1 n9 vss nxlllp L=0.042u W=0.504u
Mqn4 o0 a0 n9 vss nxlllp L=0.042u W=0.504u
Mqn5 n9 ck n0 vss nxlllp L=0.042u W=1.008u
Mqn6 n0 b vss vss nxlllp L=0.042u W=1.008u
Mqp1 o3 ck vcc vcc pxlllp L=0.042u W=0.294u
Mqp10 o0 ck vcc vcc pxlllp L=0.042u W=0.294u
Mqp11 o0 b vcc vcc pxlllp L=0.042u W=0.126u
Mqp12 o0 a0 vcc vcc pxlllp L=0.042u W=0.126u
Mqp2 o3 b vcc vcc pxlllp L=0.042u W=0.126u
Mqp3 o3 a3 vcc vcc pxlllp L=0.042u W=0.126u
Mqp4 o2 ck vcc vcc pxlllp L=0.042u W=0.294u
Mqp5 o2 b vcc vcc pxlllp L=0.042u W=0.126u
Mqp6 o2 a2 vcc vcc pxlllp L=0.042u W=0.126u
Mqp7 o1 ck vcc vcc pxlllp L=0.042u W=0.294u
Mqp8 o1 b vcc vcc pxlllp L=0.042u W=0.126u
Mqp9 o1 a1 vcc vcc pxlllp L=0.042u W=0.126u
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_da7nag43nn0n1

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_rwlinv4g
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rwlinv4g a o1 vccxx
* INPUT: a vccxx
* OUTPUT: o1
* INOUT:


************************
Mqn1 o1 a vss vss nxlllp L=0.042u W=1.008u
Mqp1 o1 a vccxx vccxx pxlllp L=0.042u W=1.932u
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rwlinv4g

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_x4pwrcell
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_x4pwrcell pwren_in
+ vccd_1p0 vccdgt_1p0
* INPUT: vccd_1p0
* OUTPUT: vccdgt_1p0
* INOUT: pwren_in


************************
Mqp2 vccdgt_1p0 pwren_in vccd_1p0 vccd_1p0 pxlllp L=0.042u W=2.016u
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_x4pwrcell

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_wldrvx4v2
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2 brclk cm[0]
+ cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] pwren_in rclk rw[0] rw[1] rw[2]
+ rw[3] rwbuff[0] rwbuff[1] rwbuff[2]  rwbuff[3] rwlbot[0] rwlbot[1]
+ rwlbot[2] rwlbot[3] rwltop[0] rwltop[1]  rwltop[2] rwltop[3] rx[0] rx[1]
+ rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] rxx ry[0]  ry[1] ry[2] ry[3] rz[0]
+ rz[1] vccd_1p0 vccdgt_1p0
* INPUT: brclk rxx
* OUTPUT: rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3] rwltop[0] rwltop[1]
*+ rwltop[2] rwltop[3]
* INOUT: cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] pwren_in rclk
*+ rw[0] rw[1] rw[2] rw[3] rwbuff[0] rwbuff[1] rwbuff[2] rwbuff[3] rx[0]
*+ rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] rz[0]
*+ rz[1] vccd_1p0 vccdgt_1p0


************************
Xigangnand rwbuff[0] rwbuff[1] rwbuff[2] rwbuff[3] rxx brclk rwwl[0]
+ rwwl[1] rwwl[2] rwwl[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_da7nag43nn0n1
Xinn0 rwwl[0] rwltop[0] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rwlinv4g
Xinn1 rwwl[1] rwltop[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rwlinv4g
Xinn2 rwwl[2] rwltop[2] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rwlinv4g
Xinn3 rwwl[3] rwltop[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rwlinv4g
Xinn4 rwwl[3] rwlbot[3] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rwlinv4g
Xinn5 rwwl[2] rwlbot[2] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rwlinv4g
Xinn6 rwwl[1] rwlbot[1] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rwlinv4g
Xinn7 rwwl[0] rwlbot[0] vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_rwlinv4g
Xipg pwren_in vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_x4pwrcell
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_wldrvslice32v2
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvslice32v2 cm[0]
+ cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5]  cmselbot[6] cmselbot[7]
+ cmseltop[0] cmseltop[1] cmseltop[2] cmseltop[3]  cmseltop[4] cmseltop[5]
+ cmseltop[6] cmseltop[7] lblpchgclkleftbot  lblpchgclklefttop
+ lblpchgclkrightbot lblpchgclkrighttop pwren_in pwren_inbuf  pwren_out
+ pwren_outbuf rclk rw[0] rw[1] rw[2] rw[3] rwlbot[0] rwlbot[1]  rwlbot[2]
+ rwlbot[3] rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8]  rwlbot[9]
+ rwlbot[10] rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15]
+ rwlbot[16] rwlbot[17] rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21]
+ rwlbot[22]  rwlbot[23] rwlbot[24] rwlbot[25] rwlbot[26] rwlbot[27]
+ rwlbot[28] rwlbot[29]  rwlbot[30] rwlbot[31] rwlbot[32] rwlbot[33]
+ rwlbot[34] rwlbot[35] rwlbot[36]  rwlbot[37] rwlbot[38] rwlbot[39]
+ rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43]  rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50]  rwlbot[51]
+ rwlbot[52] rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57]
+ rwlbot[58] rwlbot[59] rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63]
+ rwltop[0]  rwltop[1] rwltop[2] rwltop[3] rwltop[4] rwltop[5] rwltop[6]
+ rwltop[7]  rwltop[8] rwltop[9] rwltop[10] rwltop[11] rwltop[12]
+ rwltop[13] rwltop[14]  rwltop[15] rwltop[16] rwltop[17] rwltop[18]
+ rwltop[19] rwltop[20] rwltop[21]  rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28]  rwltop[29] rwltop[30]
+ rwltop[31] rwltop[32] rwltop[33] rwltop[34] rwltop[35]  rwltop[36]
+ rwltop[37] rwltop[38] rwltop[39] rwltop[40] rwltop[41] rwltop[42]
+ rwltop[43] rwltop[44] rwltop[45] rwltop[46] rwltop[47] rwltop[48]
+ rwltop[49]  rwltop[50] rwltop[51] rwltop[52] rwltop[53] rwltop[54]
+ rwltop[55] rwltop[56]  rwltop[57] rwltop[58] rwltop[59] rwltop[60]
+ rwltop[61] rwltop[62] rwltop[63]  rx[0] rx[1] rx[2] rx[3] rx[4] rx[5]
+ rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] ry0  ry1 rz[0] rz[1] rz0 vccd_1p0
+ vccdgt_1p0
* INPUT: cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] pwren_in
*+ pwren_inbuf rclk rw[0] rw[1] rw[2] rw[3] rx[0] rx[1] rx[2] rx[3] rx[4]
*+ rx[5] rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] ry0 ry1 rz[0] rz[1] rz0
* OUTPUT: cmselbot[0] cmselbot[1] cmselbot[2] cmselbot[3] cmselbot[4]
*+ cmselbot[5] cmselbot[6] cmselbot[7] cmseltop[0] cmseltop[1] cmseltop[2]
*+ cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
*+ lblpchgclkleftbot lblpchgclklefttop lblpchgclkrightbot
*+ lblpchgclkrighttop pwren_out pwren_outbuf rwlbot[0] rwlbot[1] rwlbot[2]
*+ rwlbot[3] rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9]
*+ rwlbot[10] rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15]
*+ rwlbot[16] rwlbot[17] rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21]
*+ rwlbot[22] rwlbot[23] rwlbot[24] rwlbot[25] rwlbot[26] rwlbot[27]
*+ rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31] rwlbot[32] rwlbot[33]
*+ rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38] rwlbot[39]
*+ rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
*+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51]
*+ rwlbot[52] rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57]
*+ rwlbot[58] rwlbot[59] rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63]
*+ rwltop[0] rwltop[1] rwltop[2] rwltop[3] rwltop[4] rwltop[5] rwltop[6]
*+ rwltop[7] rwltop[8] rwltop[9] rwltop[10] rwltop[11] rwltop[12]
*+ rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17] rwltop[18]
*+ rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
*+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30]
*+ rwltop[31] rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36]
*+ rwltop[37] rwltop[38] rwltop[39] rwltop[40] rwltop[41] rwltop[42]
*+ rwltop[43] rwltop[44] rwltop[45] rwltop[46] rwltop[47] rwltop[48]
*+ rwltop[49] rwltop[50] rwltop[51] rwltop[52] rwltop[53] rwltop[54]
*+ rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59] rwltop[60]
*+ rwltop[61] rwltop[62] rwltop[63]
* INOUT: vccd_1p0 vccdgt_1p0


************************
Xic73p4hdxrom_wldrvgap brclkleft brclkright cm[0] cm[1] cm[2] cm[3] cm[4]
+ cm[5] cm[6] cm[7] cmselbot[0] cmselbot[1] cmselbot[2] cmselbot[3]
+ cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ lblpchgclkleftbot lblpchgclklefttop lblpchgclkrightbot lblpchgclkrighttop
+ pwren_in pwren_inbuf pwren_out pwren_outbuf rclk rw[0] rw[1] rw[2] rw[3]
+ rwbuffleft[0] rwbuffleft[1] rwbuffleft[2] rwbuffleft[3] rwbuffright[0]
+ rwbuffright[1] rwbuffright[2] rwbuffright[3] rx[0] rx[1] rx[2] rx[3]
+ rx[4] rx[5] rx[6] rx[7] rxx[0] rxx[1] rxx[2] rxx[3] rxx[4] rxx[5] rxx[6]
+ rxx[7] ry[0] ry[1] ry[2] ry[3] ry0 ry1 rz[0] rz[1] rz0 vccd_1p0
+ vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvgap
Xic73p4hdxrom_wldrvx4_0 brclkleft cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6]
+ cm[7] pwren_in rclk rw[0] rw[1] rw[2] rw[3] rwbuffleft[0] rwbuffleft[1]
+ rwbuffleft[2] rwbuffleft[3] rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwltop[0] rwltop[1] rwltop[2] rwltop[3] rx[0] rx[1] rx[2] rx[3] rx[4]
+ rx[5] rx[6] rx[7] rxx[0] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1] vccd_1p0
+ vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_1 brclkleft cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6]
+ cm[7] pwren_in rclk rw[0] rw[1] rw[2] rw[3] rwbuffleft[0] rwbuffleft[1]
+ rwbuffleft[2] rwbuffleft[3] rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rx[0] rx[1] rx[2] rx[3] rx[4]
+ rx[5] rx[6] rx[7] rxx[1] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1] vccd_1p0
+ vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_10 brclkright cm[0] cm[1] cm[2] cm[3] cm[4] cm[5]
+ cm[6] cm[7] pwren_out rclk rw[0] rw[1] rw[2] rw[3] rwbuffright[0]
+ rwbuffright[1] rwbuffright[2] rwbuffright[3] rwlbot[40] rwlbot[41]
+ rwlbot[42] rwlbot[43] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rx[0]
+ rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] rxx[2] ry[0] ry[1] ry[2] ry[3]
+ rz[0] rz[1] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_11 brclkright cm[0] cm[1] cm[2] cm[3] cm[4] cm[5]
+ cm[6] cm[7] pwren_out rclk rw[0] rw[1] rw[2] rw[3] rwbuffright[0]
+ rwbuffright[1] rwbuffright[2] rwbuffright[3] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwltop[44] rwltop[45] rwltop[46] rwltop[47] rx[0]
+ rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] rxx[3] ry[0] ry[1] ry[2] ry[3]
+ rz[0] rz[1] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_12 brclkright cm[0] cm[1] cm[2] cm[3] cm[4] cm[5]
+ cm[6] cm[7] pwren_out rclk rw[0] rw[1] rw[2] rw[3] rwbuffright[0]
+ rwbuffright[1] rwbuffright[2] rwbuffright[3] rwlbot[48] rwlbot[49]
+ rwlbot[50] rwlbot[51] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rx[0]
+ rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] rxx[4] ry[0] ry[1] ry[2] ry[3]
+ rz[0] rz[1] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_13 brclkright cm[0] cm[1] cm[2] cm[3] cm[4] cm[5]
+ cm[6] cm[7] pwren_out rclk rw[0] rw[1] rw[2] rw[3] rwbuffright[0]
+ rwbuffright[1] rwbuffright[2] rwbuffright[3] rwlbot[52] rwlbot[53]
+ rwlbot[54] rwlbot[55] rwltop[52] rwltop[53] rwltop[54] rwltop[55] rx[0]
+ rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] rxx[5] ry[0] ry[1] ry[2] ry[3]
+ rz[0] rz[1] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_14 brclkright cm[0] cm[1] cm[2] cm[3] cm[4] cm[5]
+ cm[6] cm[7] pwren_out rclk rw[0] rw[1] rw[2] rw[3] rwbuffright[0]
+ rwbuffright[1] rwbuffright[2] rwbuffright[3] rwlbot[56] rwlbot[57]
+ rwlbot[58] rwlbot[59] rwltop[56] rwltop[57] rwltop[58] rwltop[59] rx[0]
+ rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] rxx[6] ry[0] ry[1] ry[2] ry[3]
+ rz[0] rz[1] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_15 brclkright cm[0] cm[1] cm[2] cm[3] cm[4] cm[5]
+ cm[6] cm[7] pwren_out rclk rw[0] rw[1] rw[2] rw[3] rwbuffright[0]
+ rwbuffright[1] rwbuffright[2] rwbuffright[3] rwlbot[60] rwlbot[61]
+ rwlbot[62] rwlbot[63] rwltop[60] rwltop[61] rwltop[62] rwltop[63] rx[0]
+ rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] rxx[7] ry[0] ry[1] ry[2] ry[3]
+ rz[0] rz[1] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_2 brclkleft cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6]
+ cm[7] pwren_in rclk rw[0] rw[1] rw[2] rw[3] rwbuffleft[0] rwbuffleft[1]
+ rwbuffleft[2] rwbuffleft[3] rwlbot[8] rwlbot[9] rwlbot[10] rwlbot[11]
+ rwltop[8] rwltop[9] rwltop[10] rwltop[11] rx[0] rx[1] rx[2] rx[3] rx[4]
+ rx[5] rx[6] rx[7] rxx[2] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1] vccd_1p0
+ vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_3 brclkleft cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6]
+ cm[7] pwren_in rclk rw[0] rw[1] rw[2] rw[3] rwbuffleft[0] rwbuffleft[1]
+ rwbuffleft[2] rwbuffleft[3] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15]
+ rwltop[12] rwltop[13] rwltop[14] rwltop[15] rx[0] rx[1] rx[2] rx[3] rx[4]
+ rx[5] rx[6] rx[7] rxx[3] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1] vccd_1p0
+ vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_4 brclkleft cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6]
+ cm[7] pwren_in rclk rw[0] rw[1] rw[2] rw[3] rwbuffleft[0] rwbuffleft[1]
+ rwbuffleft[2] rwbuffleft[3] rwlbot[16] rwlbot[17] rwlbot[18] rwlbot[19]
+ rwltop[16] rwltop[17] rwltop[18] rwltop[19] rx[0] rx[1] rx[2] rx[3] rx[4]
+ rx[5] rx[6] rx[7] rxx[4] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1] vccd_1p0
+ vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_5 brclkleft cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6]
+ cm[7] pwren_in rclk rw[0] rw[1] rw[2] rw[3] rwbuffleft[0] rwbuffleft[1]
+ rwbuffleft[2] rwbuffleft[3] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23]
+ rwltop[20] rwltop[21] rwltop[22] rwltop[23] rx[0] rx[1] rx[2] rx[3] rx[4]
+ rx[5] rx[6] rx[7] rxx[5] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1] vccd_1p0
+ vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_6 brclkleft cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6]
+ cm[7] pwren_in rclk rw[0] rw[1] rw[2] rw[3] rwbuffleft[0] rwbuffleft[1]
+ rwbuffleft[2] rwbuffleft[3] rwlbot[24] rwlbot[25] rwlbot[26] rwlbot[27]
+ rwltop[24] rwltop[25] rwltop[26] rwltop[27] rx[0] rx[1] rx[2] rx[3] rx[4]
+ rx[5] rx[6] rx[7] rxx[6] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1] vccd_1p0
+ vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_7 brclkleft cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6]
+ cm[7] pwren_in rclk rw[0] rw[1] rw[2] rw[3] rwbuffleft[0] rwbuffleft[1]
+ rwbuffleft[2] rwbuffleft[3] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwltop[28] rwltop[29] rwltop[30] rwltop[31] rx[0] rx[1] rx[2] rx[3] rx[4]
+ rx[5] rx[6] rx[7] rxx[7] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1] vccd_1p0
+ vccdgt_1p0 c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_8 brclkright cm[0] cm[1] cm[2] cm[3] cm[4] cm[5]
+ cm[6] cm[7] pwren_out rclk rw[0] rw[1] rw[2] rw[3] rwbuffright[0]
+ rwbuffright[1] rwbuffright[2] rwbuffright[3] rwlbot[32] rwlbot[33]
+ rwlbot[34] rwlbot[35] rwltop[32] rwltop[33] rwltop[34] rwltop[35] rx[0]
+ rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] rxx[0] ry[0] ry[1] ry[2] ry[3]
+ rz[0] rz[1] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
Xic73p4hdxrom_wldrvx4_9 brclkright cm[0] cm[1] cm[2] cm[3] cm[4] cm[5]
+ cm[6] cm[7] pwren_out rclk rw[0] rw[1] rw[2] rw[3] rwbuffright[0]
+ rwbuffright[1] rwbuffright[2] rwbuffright[3] rwlbot[36] rwlbot[37]
+ rwlbot[38] rwlbot[39] rwltop[36] rwltop[37] rwltop[38] rwltop[39] rx[0]
+ rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] rxx[1] ry[0] ry[1] ry[2] ry[3]
+ rz[0] rz[1] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvx4v2
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvslice32v2

******************************************************************
* SUBCIRCUIT: c73p4hdxrom_wldrvspacer
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvspacer cm[0] cm[1]
+ cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] pwren_in pwren_out rclk rw[0] rw[1]
+ rw[2] rw[3] rx[0] rx[1] rx[2] rx[3] rx[4]  rx[5] rx[6] rx[7] ry[0] ry[1]
+ ry[2] ry[3] rz[0] rz[1] vccd_1p0 vccdgt_1p0
* INPUT:
* OUTPUT:
* INOUT: cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] pwren_in
*+ pwren_out rclk rw[0] rw[1] rw[2] rw[3] rx[0] rx[1] rx[2] rx[3] rx[4]
*+ rx[5] rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1] vccd_1p0
*+ vccdgt_1p0


************************
.ENDS c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvspacer

******************************************************************
* SUBCIRCUIT: c73p1rfshdxrom2048x32hb4img108_ctrlslice
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108_ctrlslice vccd_1p0 vccdgt_1p0
+ pwrenwl_in_0 iar[0] iar[1] iar[2] iar[3] iar[4] iar[5] iar[6] iar[7] iar[8]
+ iar[9] iar[10] ickr iren pwrenwl_out_0 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmtop[0] cmtop[1] cmtop[2]
+ cmtop[3] cmtop[4] cmtop[5] cmtop[6] cmtop[7] cmtop[8] cmtop[9] cmtop[10]
+ cmtop[11] cmtop[12] cmtop[13] cmtop[14] cmtop[15] cmtop[16] cmtop[17]
+ cmtop[18] cmtop[19] cmtop[20] cmtop[21] cmtop[22] cmtop[23] cmtop[24]
+ cmtop[25] cmtop[26] cmtop[27] cmtop[28] cmtop[29] cmtop[30] cmtop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3] rwlbot[0]
+ rwlbot[1] rwlbot[2] rwlbot[3] rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7]
+ rwlbot[8] rwlbot[9] rwlbot[10] rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14]
+ rwlbot[15] rwlbot[16] rwlbot[17] rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21]
+ rwlbot[22] rwlbot[23] rwlbot[24] rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28]
+ rwlbot[29] rwlbot[30] rwlbot[31] rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35]
+ rwlbot[36] rwlbot[37] rwlbot[38] rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42]
+ rwlbot[43] rwlbot[44] rwlbot[45] rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49]
+ rwlbot[50] rwlbot[51] rwlbot[52] rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56]
+ rwlbot[57] rwlbot[58] rwlbot[59] rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63]
+ rwlbot[64] rwlbot[65] rwlbot[66] rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70]
+ rwlbot[71] rwlbot[72] rwlbot[73] rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77]
+ rwlbot[78] rwlbot[79] rwlbot[80] rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84]
+ rwlbot[85] rwlbot[86] rwlbot[87] rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91]
+ rwlbot[92] rwlbot[93] rwlbot[94] rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98]
+ rwlbot[99] rwlbot[100] rwlbot[101] rwlbot[102] rwlbot[103] rwlbot[104]
+ rwlbot[105] rwlbot[106] rwlbot[107] rwlbot[108] rwlbot[109] rwlbot[110]
+ rwlbot[111] rwlbot[112] rwlbot[113] rwlbot[114] rwlbot[115] rwlbot[116]
+ rwlbot[117] rwlbot[118] rwlbot[119] rwlbot[120] rwlbot[121] rwlbot[122]
+ rwlbot[123] rwlbot[124] rwlbot[125] rwlbot[126] rwlbot[127] rwlbot[128]
+ rwlbot[129] rwlbot[130] rwlbot[131] rwlbot[132] rwlbot[133] rwlbot[134]
+ rwlbot[135] rwlbot[136] rwlbot[137] rwlbot[138] rwlbot[139] rwlbot[140]
+ rwlbot[141] rwlbot[142] rwlbot[143] rwlbot[144] rwlbot[145] rwlbot[146]
+ rwlbot[147] rwlbot[148] rwlbot[149] rwlbot[150] rwlbot[151] rwlbot[152]
+ rwlbot[153] rwlbot[154] rwlbot[155] rwlbot[156] rwlbot[157] rwlbot[158]
+ rwlbot[159] rwlbot[160] rwlbot[161] rwlbot[162] rwlbot[163] rwlbot[164]
+ rwlbot[165] rwlbot[166] rwlbot[167] rwlbot[168] rwlbot[169] rwlbot[170]
+ rwlbot[171] rwlbot[172] rwlbot[173] rwlbot[174] rwlbot[175] rwlbot[176]
+ rwlbot[177] rwlbot[178] rwlbot[179] rwlbot[180] rwlbot[181] rwlbot[182]
+ rwlbot[183] rwlbot[184] rwlbot[185] rwlbot[186] rwlbot[187] rwlbot[188]
+ rwlbot[189] rwlbot[190] rwlbot[191] rwlbot[192] rwlbot[193] rwlbot[194]
+ rwlbot[195] rwlbot[196] rwlbot[197] rwlbot[198] rwlbot[199] rwlbot[200]
+ rwlbot[201] rwlbot[202] rwlbot[203] rwlbot[204] rwlbot[205] rwlbot[206]
+ rwlbot[207] rwlbot[208] rwlbot[209] rwlbot[210] rwlbot[211] rwlbot[212]
+ rwlbot[213] rwlbot[214] rwlbot[215] rwlbot[216] rwlbot[217] rwlbot[218]
+ rwlbot[219] rwlbot[220] rwlbot[221] rwlbot[222] rwlbot[223] rwlbot[224]
+ rwlbot[225] rwlbot[226] rwlbot[227] rwlbot[228] rwlbot[229] rwlbot[230]
+ rwlbot[231] rwlbot[232] rwlbot[233] rwlbot[234] rwlbot[235] rwlbot[236]
+ rwlbot[237] rwlbot[238] rwlbot[239] rwlbot[240] rwlbot[241] rwlbot[242]
+ rwlbot[243] rwlbot[244] rwlbot[245] rwlbot[246] rwlbot[247] rwlbot[248]
+ rwlbot[249] rwlbot[250] rwlbot[251] rwlbot[252] rwlbot[253] rwlbot[254]
+ rwlbot[255] cmbot[0] cmbot[1] cmbot[2] cmbot[3] cmbot[4] cmbot[5] cmbot[6]
+ cmbot[7] cmbot[8] cmbot[9] cmbot[10] cmbot[11] cmbot[12] cmbot[13] cmbot[14]
+ cmbot[15] cmbot[16] cmbot[17] cmbot[18] cmbot[19] cmbot[20] cmbot[21]
+ cmbot[22] cmbot[23] cmbot[24] cmbot[25] cmbot[26] cmbot[27] cmbot[28]
+ cmbot[29] cmbot[30] cmbot[31] lblpchglftbot[0] lblpchglftbot[1]
+ lblpchglftbot[2] lblpchglftbot[3] lblpchgrgtbot[0] lblpchgrgtbot[1]
+ lblpchgrgtbot[2] lblpchgrgtbot[3] sdlclktop sdlclkbot
* INPUT: pwrenwl_in_0 iar[0] iar[1] iar[2] iar[3] iar[4] iar[5] iar[6] iar[7]
*+ iar[8] iar[9] iar[10] ickr iren
* OUTPUT: pwrenwl_out_0 rwltop[0] rwltop[1] rwltop[2] rwltop[3] rwltop[4]
*+ rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10] rwltop[11]
*+ rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17] rwltop[18]
*+ rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24] rwltop[25]
*+ rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31] rwltop[32]
*+ rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38] rwltop[39]
*+ rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45] rwltop[46]
*+ rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52] rwltop[53]
*+ rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59] rwltop[60]
*+ rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66] rwltop[67]
*+ rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73] rwltop[74]
*+ rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80] rwltop[81]
*+ rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87] rwltop[88]
*+ rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94] rwltop[95]
*+ rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
*+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
*+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
*+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
*+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
*+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
*+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
*+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
*+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
*+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
*+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
*+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
*+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
*+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
*+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
*+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
*+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
*+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
*+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
*+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
*+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
*+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
*+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
*+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
*+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
*+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
*+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmtop[0] cmtop[1] cmtop[2]
*+ cmtop[3] cmtop[4] cmtop[5] cmtop[6] cmtop[7] cmtop[8] cmtop[9] cmtop[10]
*+ cmtop[11] cmtop[12] cmtop[13] cmtop[14] cmtop[15] cmtop[16] cmtop[17]
*+ cmtop[18] cmtop[19] cmtop[20] cmtop[21] cmtop[22] cmtop[23] cmtop[24]
*+ cmtop[25] cmtop[26] cmtop[27] cmtop[28] cmtop[29] cmtop[30] cmtop[31]
*+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
*+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3] rwlbot[0]
*+ rwlbot[1] rwlbot[2] rwlbot[3] rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7]
*+ rwlbot[8] rwlbot[9] rwlbot[10] rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14]
*+ rwlbot[15] rwlbot[16] rwlbot[17] rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21]
*+ rwlbot[22] rwlbot[23] rwlbot[24] rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28]
*+ rwlbot[29] rwlbot[30] rwlbot[31] rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35]
*+ rwlbot[36] rwlbot[37] rwlbot[38] rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42]
*+ rwlbot[43] rwlbot[44] rwlbot[45] rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49]
*+ rwlbot[50] rwlbot[51] rwlbot[52] rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56]
*+ rwlbot[57] rwlbot[58] rwlbot[59] rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63]
*+ rwlbot[64] rwlbot[65] rwlbot[66] rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70]
*+ rwlbot[71] rwlbot[72] rwlbot[73] rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77]
*+ rwlbot[78] rwlbot[79] rwlbot[80] rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84]
*+ rwlbot[85] rwlbot[86] rwlbot[87] rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91]
*+ rwlbot[92] rwlbot[93] rwlbot[94] rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98]
*+ rwlbot[99] rwlbot[100] rwlbot[101] rwlbot[102] rwlbot[103] rwlbot[104]
*+ rwlbot[105] rwlbot[106] rwlbot[107] rwlbot[108] rwlbot[109] rwlbot[110]
*+ rwlbot[111] rwlbot[112] rwlbot[113] rwlbot[114] rwlbot[115] rwlbot[116]
*+ rwlbot[117] rwlbot[118] rwlbot[119] rwlbot[120] rwlbot[121] rwlbot[122]
*+ rwlbot[123] rwlbot[124] rwlbot[125] rwlbot[126] rwlbot[127] rwlbot[128]
*+ rwlbot[129] rwlbot[130] rwlbot[131] rwlbot[132] rwlbot[133] rwlbot[134]
*+ rwlbot[135] rwlbot[136] rwlbot[137] rwlbot[138] rwlbot[139] rwlbot[140]
*+ rwlbot[141] rwlbot[142] rwlbot[143] rwlbot[144] rwlbot[145] rwlbot[146]
*+ rwlbot[147] rwlbot[148] rwlbot[149] rwlbot[150] rwlbot[151] rwlbot[152]
*+ rwlbot[153] rwlbot[154] rwlbot[155] rwlbot[156] rwlbot[157] rwlbot[158]
*+ rwlbot[159] rwlbot[160] rwlbot[161] rwlbot[162] rwlbot[163] rwlbot[164]
*+ rwlbot[165] rwlbot[166] rwlbot[167] rwlbot[168] rwlbot[169] rwlbot[170]
*+ rwlbot[171] rwlbot[172] rwlbot[173] rwlbot[174] rwlbot[175] rwlbot[176]
*+ rwlbot[177] rwlbot[178] rwlbot[179] rwlbot[180] rwlbot[181] rwlbot[182]
*+ rwlbot[183] rwlbot[184] rwlbot[185] rwlbot[186] rwlbot[187] rwlbot[188]
*+ rwlbot[189] rwlbot[190] rwlbot[191] rwlbot[192] rwlbot[193] rwlbot[194]
*+ rwlbot[195] rwlbot[196] rwlbot[197] rwlbot[198] rwlbot[199] rwlbot[200]
*+ rwlbot[201] rwlbot[202] rwlbot[203] rwlbot[204] rwlbot[205] rwlbot[206]
*+ rwlbot[207] rwlbot[208] rwlbot[209] rwlbot[210] rwlbot[211] rwlbot[212]
*+ rwlbot[213] rwlbot[214] rwlbot[215] rwlbot[216] rwlbot[217] rwlbot[218]
*+ rwlbot[219] rwlbot[220] rwlbot[221] rwlbot[222] rwlbot[223] rwlbot[224]
*+ rwlbot[225] rwlbot[226] rwlbot[227] rwlbot[228] rwlbot[229] rwlbot[230]
*+ rwlbot[231] rwlbot[232] rwlbot[233] rwlbot[234] rwlbot[235] rwlbot[236]
*+ rwlbot[237] rwlbot[238] rwlbot[239] rwlbot[240] rwlbot[241] rwlbot[242]
*+ rwlbot[243] rwlbot[244] rwlbot[245] rwlbot[246] rwlbot[247] rwlbot[248]
*+ rwlbot[249] rwlbot[250] rwlbot[251] rwlbot[252] rwlbot[253] rwlbot[254]
*+ rwlbot[255] cmbot[0] cmbot[1] cmbot[2] cmbot[3] cmbot[4] cmbot[5] cmbot[6]
*+ cmbot[7] cmbot[8] cmbot[9] cmbot[10] cmbot[11] cmbot[12] cmbot[13] cmbot[14]
*+ cmbot[15] cmbot[16] cmbot[17] cmbot[18] cmbot[19] cmbot[20] cmbot[21]
*+ cmbot[22] cmbot[23] cmbot[24] cmbot[25] cmbot[26] cmbot[27] cmbot[28]
*+ cmbot[29] cmbot[30] cmbot[31] lblpchglftbot[0] lblpchglftbot[1]
*+ lblpchglftbot[2] lblpchglftbot[3] lblpchgrgtbot[0] lblpchgrgtbot[1]
*+ lblpchgrgtbot[2] lblpchgrgtbot[3] sdlclktop sdlclkbot
* INOUT: vccd_1p0 vccdgt_1p0
*ctrl c73p4hdxrom_ctrl 00
Xctrl  cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] gclk iar[0] iar[1]
+ iar[2] iar[3] iar[4] iar[5] iar[6] iar[7] iar[8] iar[9] iar[10] ickr iren
+ pwrenwl_out_0 pwrenwl_in_0 rw[0] rw[1] rw[2] rw[3] rx[0] rx[1] rx[2]
+ rx[3] rx[4] rx[5] rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1]
+ sdlclkbot sdlclktop vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_ctrl
*ctrlslice_bnd0 c73p4hdxrom_wldrvslice32v2 00
Xctrlslice_bnd0  cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] cmbot[0]
+ cmbot[1] cmbot[2] cmbot[3] cmbot[4] cmbot[5] cmbot[6] cmbot[7] cmtop[0]
+ cmtop[1] cmtop[2] cmtop[3] cmtop[4] cmtop[5] cmtop[6] cmtop[7]
+ lblpchglftbot[0] lblpchglfttop[0] lblpchgrgtbot[0] lblpchgrgttop[0]
+ pwrenwl_in_0 pwrenwl_out_1 pwrenwl_in_1 pwrenwl_out_0 gclk rw[0] rw[1]
+ rw[2] rw[3] rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3] rwlbot[4] rwlbot[5]
+ rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10] rwlbot[11] rwlbot[12]
+ rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17] rwlbot[18]
+ rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30]
+ rwlbot[31] rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36]
+ rwlbot[37] rwlbot[38] rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42]
+ rwlbot[43] rwlbot[44] rwlbot[45] rwlbot[46] rwlbot[47] rwlbot[48]
+ rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52] rwlbot[53] rwlbot[54]
+ rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59] rwlbot[60]
+ rwlbot[61] rwlbot[62] rwlbot[63] rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16]
+ rwltop[17] rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22]
+ rwltop[23] rwltop[24] rwltop[25] rwltop[26] rwltop[27] rwltop[28]
+ rwltop[29] rwltop[30] rwltop[31] rwltop[32] rwltop[33] rwltop[34]
+ rwltop[35] rwltop[36] rwltop[37] rwltop[38] rwltop[39] rwltop[40]
+ rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45] rwltop[46]
+ rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58]
+ rwltop[59] rwltop[60] rwltop[61] rwltop[62] rwltop[63] rx[0] rx[1] rx[2]
+ rx[3] rx[4] rx[5] rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] ry[0] ry[1] rz[0]
+ rz[1] rz[0] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvslice32v2
*ctrlslice_bnd1 c73p4hdxrom_wldrvslice32v2 00
Xctrlslice_bnd1  cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] cmbot[8]
+ cmbot[9] cmbot[10] cmbot[11] cmbot[12] cmbot[13] cmbot[14] cmbot[15]
+ cmtop[8] cmtop[9] cmtop[10] cmtop[11] cmtop[12] cmtop[13] cmtop[14]
+ cmtop[15] lblpchglftbot[1] lblpchglfttop[1] lblpchgrgtbot[1]
+ lblpchgrgttop[1] pwrenwl_in_1 pwrenwl_out_2 pwrenwl_in_2 pwrenwl_out_1
+ gclk rw[0] rw[1] rw[2] rw[3] rwlbot[64] rwlbot[65] rwlbot[66] rwlbot[67]
+ rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79]
+ rwlbot[80] rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85]
+ rwlbot[86] rwlbot[87] rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91]
+ rwlbot[92] rwlbot[93] rwlbot[94] rwlbot[95] rwlbot[96] rwlbot[97]
+ rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101] rwlbot[102] rwlbot[103]
+ rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107] rwlbot[108] rwlbot[109]
+ rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113] rwlbot[114] rwlbot[115]
+ rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119] rwlbot[120] rwlbot[121]
+ rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125] rwlbot[126] rwlbot[127]
+ rwltop[64] rwltop[65] rwltop[66] rwltop[67] rwltop[68] rwltop[69]
+ rwltop[70] rwltop[71] rwltop[72] rwltop[73] rwltop[74] rwltop[75]
+ rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80] rwltop[81]
+ rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93]
+ rwltop[94] rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99]
+ rwltop[100] rwltop[101] rwltop[102] rwltop[103] rwltop[104] rwltop[105]
+ rwltop[106] rwltop[107] rwltop[108] rwltop[109] rwltop[110] rwltop[111]
+ rwltop[112] rwltop[113] rwltop[114] rwltop[115] rwltop[116] rwltop[117]
+ rwltop[118] rwltop[119] rwltop[120] rwltop[121] rwltop[122] rwltop[123]
+ rwltop[124] rwltop[125] rwltop[126] rwltop[127] rx[0] rx[1] rx[2] rx[3]
+ rx[4] rx[5] rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] ry[2] ry[3] rz[0] rz[1]
+ rz[0] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvslice32v2
*ctrlslice_bnd2 c73p4hdxrom_wldrvslice32v2 00
Xctrlslice_bnd2  cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] cmbot[16]
+ cmbot[17] cmbot[18] cmbot[19] cmbot[20] cmbot[21] cmbot[22] cmbot[23]
+ cmtop[16] cmtop[17] cmtop[18] cmtop[19] cmtop[20] cmtop[21] cmtop[22]
+ cmtop[23] lblpchglftbot[2] lblpchglfttop[2] lblpchgrgtbot[2]
+ lblpchgrgttop[2] pwrenwl_in_2 pwrenwl_out_3 pwrenwl_in_3 pwrenwl_out_2
+ gclk rw[0] rw[1] rw[2] rw[3] rwlbot[128] rwlbot[129] rwlbot[130]
+ rwlbot[131] rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136]
+ rwlbot[137] rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142]
+ rwlbot[143] rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148]
+ rwlbot[149] rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154]
+ rwlbot[155] rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160]
+ rwlbot[161] rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166]
+ rwlbot[167] rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172]
+ rwlbot[173] rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178]
+ rwlbot[179] rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184]
+ rwlbot[185] rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190]
+ rwlbot[191] rwltop[128] rwltop[129] rwltop[130] rwltop[131] rwltop[132]
+ rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137] rwltop[138]
+ rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143] rwltop[144]
+ rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149] rwltop[150]
+ rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155] rwltop[156]
+ rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161] rwltop[162]
+ rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167] rwltop[168]
+ rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173] rwltop[174]
+ rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179] rwltop[180]
+ rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185] rwltop[186]
+ rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191] rx[0] rx[1]
+ rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] ry[0] ry[1]
+ rz[0] rz[1] rz[1] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvslice32v2
*ctrlslice_bnd3 c73p4hdxrom_wldrvslice32v2 00
Xctrlslice_bnd3  cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] cmbot[24]
+ cmbot[25] cmbot[26] cmbot[27] cmbot[28] cmbot[29] cmbot[30] cmbot[31]
+ cmtop[24] cmtop[25] cmtop[26] cmtop[27] cmtop[28] cmtop[29] cmtop[30]
+ cmtop[31] lblpchglftbot[3] lblpchglfttop[3] lblpchgrgtbot[3]
+ lblpchgrgttop[3] pwrenwl_in_3 pwrenwl_in_4 pwrenwl_in_4 pwrenwl_out_3
+ gclk rw[0] rw[1] rw[2] rw[3] rwlbot[192] rwlbot[193] rwlbot[194]
+ rwlbot[195] rwlbot[196] rwlbot[197] rwlbot[198] rwlbot[199] rwlbot[200]
+ rwlbot[201] rwlbot[202] rwlbot[203] rwlbot[204] rwlbot[205] rwlbot[206]
+ rwlbot[207] rwlbot[208] rwlbot[209] rwlbot[210] rwlbot[211] rwlbot[212]
+ rwlbot[213] rwlbot[214] rwlbot[215] rwlbot[216] rwlbot[217] rwlbot[218]
+ rwlbot[219] rwlbot[220] rwlbot[221] rwlbot[222] rwlbot[223] rwlbot[224]
+ rwlbot[225] rwlbot[226] rwlbot[227] rwlbot[228] rwlbot[229] rwlbot[230]
+ rwlbot[231] rwlbot[232] rwlbot[233] rwlbot[234] rwlbot[235] rwlbot[236]
+ rwlbot[237] rwlbot[238] rwlbot[239] rwlbot[240] rwlbot[241] rwlbot[242]
+ rwlbot[243] rwlbot[244] rwlbot[245] rwlbot[246] rwlbot[247] rwlbot[248]
+ rwlbot[249] rwlbot[250] rwlbot[251] rwlbot[252] rwlbot[253] rwlbot[254]
+ rwlbot[255] rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196]
+ rwltop[197] rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202]
+ rwltop[203] rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208]
+ rwltop[209] rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214]
+ rwltop[215] rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220]
+ rwltop[221] rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226]
+ rwltop[227] rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232]
+ rwltop[233] rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238]
+ rwltop[239] rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244]
+ rwltop[245] rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250]
+ rwltop[251] rwltop[252] rwltop[253] rwltop[254] rwltop[255] rx[0] rx[1]
+ rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] ry[2] ry[3]
+ rz[0] rz[1] rz[1] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvslice32v2
*wldrvspcr_0 c73p4hdxrom_wldrvspacer 00
Xwldrvspcr_0  cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] pwrenwl_in_1
+ pwrenwl_out_1 gclk rw[0] rw[1] rw[2] rw[3] rx[0] rx[1] rx[2] rx[3] rx[4]
+ rx[5] rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvspacer
*wldrvspcr_1 c73p4hdxrom_wldrvspacer 00
Xwldrvspcr_1  cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] pwrenwl_in_2
+ pwrenwl_out_2 gclk rw[0] rw[1] rw[2] rw[3] rx[0] rx[1] rx[2] rx[3] rx[4]
+ rx[5] rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvspacer
*wldrvspcr_2 c73p4hdxrom_wldrvspacer 00
Xwldrvspcr_2  cm[0] cm[1] cm[2] cm[3] cm[4] cm[5] cm[6] cm[7] pwrenwl_in_3
+ pwrenwl_out_3 gclk rw[0] rw[1] rw[2] rw[3] rx[0] rx[1] rx[2] rx[3] rx[4]
+ rx[5] rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] rz[0] rz[1] vccd_1p0 vccdgt_1p0
+ c73p1rfshdxrom2048x32hb4img108_c73p4hdxrom_wldrvspacer
.ENDS c73p1rfshdxrom2048x32hb4img108_ctrlslice

******************************************************************
* SUBCIRCUIT: c73p1rfshdxrom2048x32hb4img108
******************************************************************
.SUBCKT c73p1rfshdxrom2048x32hb4img108 odout[0] odout[1] odout[2] odout[3]
+ odout[4] odout[5] odout[6] odout[7] odout[8] odout[9] odout[10] odout[11]
+ odout[12] odout[13] odout[14] odout[15] odout[16] odout[17] odout[18]
+ odout[19] odout[20] odout[21] odout[22] odout[23] odout[24] odout[25]
+ odout[26] odout[27] odout[28] odout[29] odout[30] odout[31] opwrenoutb
+ vccd_1p0 iar[0] iar[1] iar[2] iar[3] iar[4] iar[5] iar[6] iar[7] iar[8] iar[9]
+ iar[10] ickr iren ipwreninb
* INPUT: vccd_1p0 iar[0] iar[1] iar[2] iar[3] iar[4] iar[5] iar[6] iar[7] iar[8]
*+ iar[9] iar[10] ickr iren ipwreninb
* OUTPUT: odout[0] odout[1] odout[2] odout[3] odout[4] odout[5] odout[6]
*+ odout[7] odout[8] odout[9] odout[10] odout[11] odout[12] odout[13] odout[14]
*+ odout[15] odout[16] odout[17] odout[18] odout[19] odout[20] odout[21]
*+ odout[22] odout[23] odout[24] odout[25] odout[26] odout[27] odout[28]
*+ odout[29] odout[30] odout[31] opwrenoutb
* INOUT:
*bitbundle_hor_0 bitbundle 00
Xbitbundle_hor_0  odout[0] opwrenoutb vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_0 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_1 bitbundle 01
Xbitbundle_hor_1  odout[1] pwrenio_0 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_1 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_2 bitbundle 02
Xbitbundle_hor_2  odout[2] pwrenio_1 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_2 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_3 bitbundle 03
Xbitbundle_hor_3  odout[3] pwrenio_2 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_3 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_4 bitbundle 04
Xbitbundle_hor_4  odout[4] pwrenio_3 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_4 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_5 bitbundle 05
Xbitbundle_hor_5  odout[5] pwrenio_4 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_5 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_6 bitbundle 06
Xbitbundle_hor_6  odout[6] pwrenio_5 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_6 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_7 bitbundle 07
Xbitbundle_hor_7  odout[7] pwrenio_6 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_7 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_8 bitbundle 08
Xbitbundle_hor_8  odout[8] pwrenio_7 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_8 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_9 bitbundle 09
Xbitbundle_hor_9  odout[9] pwrenio_8 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_9 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_10 bitbundle 010
Xbitbundle_hor_10  odout[10] pwrenio_9 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_10 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_11 bitbundle 011
Xbitbundle_hor_11  odout[11] pwrenio_10 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_11 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_12 bitbundle 012
Xbitbundle_hor_12  odout[12] pwrenio_11 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_12 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_13 bitbundle 013
Xbitbundle_hor_13  odout[13] pwrenio_12 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_13 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_14 bitbundle 014
Xbitbundle_hor_14  odout[14] pwrenio_13 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwrenio_14 rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_15 bitbundle 015
Xbitbundle_hor_15  odout[15] pwrenio_14 vccd_1p0
+ vccdgt_1p0 sdlclkbot pwren_ctrlio rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
+ rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
+ rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
+ rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
+ rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
+ rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
+ rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
+ rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
+ rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
+ rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwlbot[64] rwlbot[65] rwlbot[66]
+ rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70] rwlbot[71] rwlbot[72] rwlbot[73]
+ rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77] rwlbot[78] rwlbot[79] rwlbot[80]
+ rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84] rwlbot[85] rwlbot[86] rwlbot[87]
+ rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91] rwlbot[92] rwlbot[93] rwlbot[94]
+ rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98] rwlbot[99] rwlbot[100] rwlbot[101]
+ rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105] rwlbot[106] rwlbot[107]
+ rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112] rwlbot[113]
+ rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
+ rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125]
+ rwlbot[126] rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131]
+ rwlbot[132] rwlbot[133] rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137]
+ rwlbot[138] rwlbot[139] rwlbot[140] rwlbot[141] rwlbot[142] rwlbot[143]
+ rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147] rwlbot[148] rwlbot[149]
+ rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154] rwlbot[155]
+ rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
+ rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167]
+ rwlbot[168] rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173]
+ rwlbot[174] rwlbot[175] rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179]
+ rwlbot[180] rwlbot[181] rwlbot[182] rwlbot[183] rwlbot[184] rwlbot[185]
+ rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189] rwlbot[190] rwlbot[191]
+ rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196] rwlbot[197]
+ rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
+ rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209]
+ rwlbot[210] rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215]
+ rwlbot[216] rwlbot[217] rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221]
+ rwlbot[222] rwlbot[223] rwlbot[224] rwlbot[225] rwlbot[226] rwlbot[227]
+ rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231] rwlbot[232] rwlbot[233]
+ rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238] rwlbot[239]
+ rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
+ rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251]
+ rwlbot[252] rwlbot[253] rwlbot[254] rwlbot[255] cmselbot[0] cmselbot[1]
+ cmselbot[2] cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7]
+ cmselbot[8] cmselbot[9] cmselbot[10] cmselbot[11] cmselbot[12] cmselbot[13]
+ cmselbot[14] cmselbot[15] cmselbot[16] cmselbot[17] cmselbot[18] cmselbot[19]
+ cmselbot[20] cmselbot[21] cmselbot[22] cmselbot[23] cmselbot[24] cmselbot[25]
+ cmselbot[26] cmselbot[27] cmselbot[28] cmselbot[29] cmselbot[30] cmselbot[31]
+ lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3]
+ lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2] lblpchgrgtbot[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_16 bitbundle 016
Xbitbundle_hor_16  odout[16] pwren_ioctrl
+ vccd_1p0 vccdgt_1p0 sdlclktop pwrenio_16 rwltop[0] rwltop[1] rwltop[2]
+ rwltop[3] rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9]
+ rwltop[10] rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16]
+ rwltop[17] rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23]
+ rwltop[24] rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30]
+ rwltop[31] rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37]
+ rwltop[38] rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44]
+ rwltop[45] rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51]
+ rwltop[52] rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58]
+ rwltop[59] rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65]
+ rwltop[66] rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72]
+ rwltop[73] rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79]
+ rwltop[80] rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86]
+ rwltop[87] rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93]
+ rwltop[94] rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100]
+ rwltop[101] rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106]
+ rwltop[107] rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112]
+ rwltop[113] rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118]
+ rwltop[119] rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124]
+ rwltop[125] rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130]
+ rwltop[131] rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136]
+ rwltop[137] rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142]
+ rwltop[143] rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148]
+ rwltop[149] rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154]
+ rwltop[155] rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160]
+ rwltop[161] rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166]
+ rwltop[167] rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172]
+ rwltop[173] rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178]
+ rwltop[179] rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184]
+ rwltop[185] rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190]
+ rwltop[191] rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196]
+ rwltop[197] rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202]
+ rwltop[203] rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208]
+ rwltop[209] rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214]
+ rwltop[215] rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220]
+ rwltop[221] rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226]
+ rwltop[227] rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232]
+ rwltop[233] rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238]
+ rwltop[239] rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244]
+ rwltop[245] rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250]
+ rwltop[251] rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0]
+ cmseltop[1] cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6]
+ cmseltop[7] cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12]
+ cmseltop[13] cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18]
+ cmseltop[19] cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24]
+ cmseltop[25] cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30]
+ cmseltop[31] lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2]
+ lblpchglfttop[3] lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2]
+ lblpchgrgttop[3] c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_17 bitbundle 017
Xbitbundle_hor_17  odout[17] pwrenio_16 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_17 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_18 bitbundle 018
Xbitbundle_hor_18  odout[18] pwrenio_17 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_18 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_19 bitbundle 019
Xbitbundle_hor_19  odout[19] pwrenio_18 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_19 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_20 bitbundle 020
Xbitbundle_hor_20  odout[20] pwrenio_19 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_20 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_21 bitbundle 021
Xbitbundle_hor_21  odout[21] pwrenio_20 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_21 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_22 bitbundle 022
Xbitbundle_hor_22  odout[22] pwrenio_21 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_22 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_23 bitbundle 023
Xbitbundle_hor_23  odout[23] pwrenio_22 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_23 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_24 bitbundle 024
Xbitbundle_hor_24  odout[24] pwrenio_23 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_24 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_25 bitbundle 025
Xbitbundle_hor_25  odout[25] pwrenio_24 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_25 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_26 bitbundle 026
Xbitbundle_hor_26  odout[26] pwrenio_25 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_26 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_27 bitbundle 027
Xbitbundle_hor_27  odout[27] pwrenio_26 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_27 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_28 bitbundle 028
Xbitbundle_hor_28  odout[28] pwrenio_27 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_28 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_29 bitbundle 029
Xbitbundle_hor_29  odout[29] pwrenio_28 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_29 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_30 bitbundle 030
Xbitbundle_hor_30  odout[30] pwrenio_29 vccd_1p0
+ vccdgt_1p0 sdlclktop pwrenio_30 rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*bitbundle_hor_31 bitbundle 031
Xbitbundle_hor_31  odout[31] pwrenio_30 vccd_1p0
+ vccdgt_1p0 sdlclktop ipwreninb rwltop[0] rwltop[1] rwltop[2] rwltop[3]
+ rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10]
+ rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17]
+ rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24]
+ rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31]
+ rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38]
+ rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45]
+ rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52]
+ rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59]
+ rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66]
+ rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73]
+ rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80]
+ rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87]
+ rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94]
+ rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101]
+ rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
+ rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113]
+ rwltop[114] rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119]
+ rwltop[120] rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125]
+ rwltop[126] rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131]
+ rwltop[132] rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137]
+ rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143]
+ rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
+ rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155]
+ rwltop[156] rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161]
+ rwltop[162] rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167]
+ rwltop[168] rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173]
+ rwltop[174] rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179]
+ rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185]
+ rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
+ rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197]
+ rwltop[198] rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203]
+ rwltop[204] rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209]
+ rwltop[210] rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215]
+ rwltop[216] rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221]
+ rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227]
+ rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
+ rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239]
+ rwltop[240] rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245]
+ rwltop[246] rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251]
+ rwltop[252] rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1]
+ cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7]
+ cmseltop[8] cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13]
+ cmseltop[14] cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19]
+ cmseltop[20] cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25]
+ cmseltop[26] cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3]
+ c73p1rfshdxrom2048x32hb4img108_bitbundle
*ctrlslice ctrlslice 00
Xctrlslice  vccd_1p0 vccdgt_1p0 pwren_ioctrl iar[0]
+ iar[1] iar[2] iar[3] iar[4] iar[5] iar[6] iar[7] iar[8] iar[9] iar[10] ickr
+ iren pwren_ctrlio rwltop[0] rwltop[1] rwltop[2] rwltop[3] rwltop[4] rwltop[5]
+ rwltop[6] rwltop[7] rwltop[8] rwltop[9] rwltop[10] rwltop[11] rwltop[12]
+ rwltop[13] rwltop[14] rwltop[15] rwltop[16] rwltop[17] rwltop[18] rwltop[19]
+ rwltop[20] rwltop[21] rwltop[22] rwltop[23] rwltop[24] rwltop[25] rwltop[26]
+ rwltop[27] rwltop[28] rwltop[29] rwltop[30] rwltop[31] rwltop[32] rwltop[33]
+ rwltop[34] rwltop[35] rwltop[36] rwltop[37] rwltop[38] rwltop[39] rwltop[40]
+ rwltop[41] rwltop[42] rwltop[43] rwltop[44] rwltop[45] rwltop[46] rwltop[47]
+ rwltop[48] rwltop[49] rwltop[50] rwltop[51] rwltop[52] rwltop[53] rwltop[54]
+ rwltop[55] rwltop[56] rwltop[57] rwltop[58] rwltop[59] rwltop[60] rwltop[61]
+ rwltop[62] rwltop[63] rwltop[64] rwltop[65] rwltop[66] rwltop[67] rwltop[68]
+ rwltop[69] rwltop[70] rwltop[71] rwltop[72] rwltop[73] rwltop[74] rwltop[75]
+ rwltop[76] rwltop[77] rwltop[78] rwltop[79] rwltop[80] rwltop[81] rwltop[82]
+ rwltop[83] rwltop[84] rwltop[85] rwltop[86] rwltop[87] rwltop[88] rwltop[89]
+ rwltop[90] rwltop[91] rwltop[92] rwltop[93] rwltop[94] rwltop[95] rwltop[96]
+ rwltop[97] rwltop[98] rwltop[99] rwltop[100] rwltop[101] rwltop[102]
+ rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107] rwltop[108]
+ rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113] rwltop[114]
+ rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119] rwltop[120]
+ rwltop[121] rwltop[122] rwltop[123] rwltop[124] rwltop[125] rwltop[126]
+ rwltop[127] rwltop[128] rwltop[129] rwltop[130] rwltop[131] rwltop[132]
+ rwltop[133] rwltop[134] rwltop[135] rwltop[136] rwltop[137] rwltop[138]
+ rwltop[139] rwltop[140] rwltop[141] rwltop[142] rwltop[143] rwltop[144]
+ rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149] rwltop[150]
+ rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155] rwltop[156]
+ rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161] rwltop[162]
+ rwltop[163] rwltop[164] rwltop[165] rwltop[166] rwltop[167] rwltop[168]
+ rwltop[169] rwltop[170] rwltop[171] rwltop[172] rwltop[173] rwltop[174]
+ rwltop[175] rwltop[176] rwltop[177] rwltop[178] rwltop[179] rwltop[180]
+ rwltop[181] rwltop[182] rwltop[183] rwltop[184] rwltop[185] rwltop[186]
+ rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191] rwltop[192]
+ rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197] rwltop[198]
+ rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203] rwltop[204]
+ rwltop[205] rwltop[206] rwltop[207] rwltop[208] rwltop[209] rwltop[210]
+ rwltop[211] rwltop[212] rwltop[213] rwltop[214] rwltop[215] rwltop[216]
+ rwltop[217] rwltop[218] rwltop[219] rwltop[220] rwltop[221] rwltop[222]
+ rwltop[223] rwltop[224] rwltop[225] rwltop[226] rwltop[227] rwltop[228]
+ rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233] rwltop[234]
+ rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239] rwltop[240]
+ rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245] rwltop[246]
+ rwltop[247] rwltop[248] rwltop[249] rwltop[250] rwltop[251] rwltop[252]
+ rwltop[253] rwltop[254] rwltop[255] cmseltop[0] cmseltop[1] cmseltop[2]
+ cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7] cmseltop[8]
+ cmseltop[9] cmseltop[10] cmseltop[11] cmseltop[12] cmseltop[13] cmseltop[14]
+ cmseltop[15] cmseltop[16] cmseltop[17] cmseltop[18] cmseltop[19] cmseltop[20]
+ cmseltop[21] cmseltop[22] cmseltop[23] cmseltop[24] cmseltop[25] cmseltop[26]
+ cmseltop[27] cmseltop[28] cmseltop[29] cmseltop[30] cmseltop[31]
+ lblpchglfttop[0] lblpchglfttop[1] lblpchglfttop[2] lblpchglfttop[3]
+ lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3] rwlbot[0]
+ rwlbot[1] rwlbot[2] rwlbot[3] rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7]
+ rwlbot[8] rwlbot[9] rwlbot[10] rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14]
+ rwlbot[15] rwlbot[16] rwlbot[17] rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21]
+ rwlbot[22] rwlbot[23] rwlbot[24] rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28]
+ rwlbot[29] rwlbot[30] rwlbot[31] rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35]
+ rwlbot[36] rwlbot[37] rwlbot[38] rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42]
+ rwlbot[43] rwlbot[44] rwlbot[45] rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49]
+ rwlbot[50] rwlbot[51] rwlbot[52] rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56]
+ rwlbot[57] rwlbot[58] rwlbot[59] rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63]
+ rwlbot[64] rwlbot[65] rwlbot[66] rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70]
+ rwlbot[71] rwlbot[72] rwlbot[73] rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77]
+ rwlbot[78] rwlbot[79] rwlbot[80] rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84]
+ rwlbot[85] rwlbot[86] rwlbot[87] rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91]
+ rwlbot[92] rwlbot[93] rwlbot[94] rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98]
+ rwlbot[99] rwlbot[100] rwlbot[101] rwlbot[102] rwlbot[103] rwlbot[104]
+ rwlbot[105] rwlbot[106] rwlbot[107] rwlbot[108] rwlbot[109] rwlbot[110]
+ rwlbot[111] rwlbot[112] rwlbot[113] rwlbot[114] rwlbot[115] rwlbot[116]
+ rwlbot[117] rwlbot[118] rwlbot[119] rwlbot[120] rwlbot[121] rwlbot[122]
+ rwlbot[123] rwlbot[124] rwlbot[125] rwlbot[126] rwlbot[127] rwlbot[128]
+ rwlbot[129] rwlbot[130] rwlbot[131] rwlbot[132] rwlbot[133] rwlbot[134]
+ rwlbot[135] rwlbot[136] rwlbot[137] rwlbot[138] rwlbot[139] rwlbot[140]
+ rwlbot[141] rwlbot[142] rwlbot[143] rwlbot[144] rwlbot[145] rwlbot[146]
+ rwlbot[147] rwlbot[148] rwlbot[149] rwlbot[150] rwlbot[151] rwlbot[152]
+ rwlbot[153] rwlbot[154] rwlbot[155] rwlbot[156] rwlbot[157] rwlbot[158]
+ rwlbot[159] rwlbot[160] rwlbot[161] rwlbot[162] rwlbot[163] rwlbot[164]
+ rwlbot[165] rwlbot[166] rwlbot[167] rwlbot[168] rwlbot[169] rwlbot[170]
+ rwlbot[171] rwlbot[172] rwlbot[173] rwlbot[174] rwlbot[175] rwlbot[176]
+ rwlbot[177] rwlbot[178] rwlbot[179] rwlbot[180] rwlbot[181] rwlbot[182]
+ rwlbot[183] rwlbot[184] rwlbot[185] rwlbot[186] rwlbot[187] rwlbot[188]
+ rwlbot[189] rwlbot[190] rwlbot[191] rwlbot[192] rwlbot[193] rwlbot[194]
+ rwlbot[195] rwlbot[196] rwlbot[197] rwlbot[198] rwlbot[199] rwlbot[200]
+ rwlbot[201] rwlbot[202] rwlbot[203] rwlbot[204] rwlbot[205] rwlbot[206]
+ rwlbot[207] rwlbot[208] rwlbot[209] rwlbot[210] rwlbot[211] rwlbot[212]
+ rwlbot[213] rwlbot[214] rwlbot[215] rwlbot[216] rwlbot[217] rwlbot[218]
+ rwlbot[219] rwlbot[220] rwlbot[221] rwlbot[222] rwlbot[223] rwlbot[224]
+ rwlbot[225] rwlbot[226] rwlbot[227] rwlbot[228] rwlbot[229] rwlbot[230]
+ rwlbot[231] rwlbot[232] rwlbot[233] rwlbot[234] rwlbot[235] rwlbot[236]
+ rwlbot[237] rwlbot[238] rwlbot[239] rwlbot[240] rwlbot[241] rwlbot[242]
+ rwlbot[243] rwlbot[244] rwlbot[245] rwlbot[246] rwlbot[247] rwlbot[248]
+ rwlbot[249] rwlbot[250] rwlbot[251] rwlbot[252] rwlbot[253] rwlbot[254]
+ rwlbot[255] cmselbot[0] cmselbot[1] cmselbot[2] cmselbot[3] cmselbot[4]
+ cmselbot[5] cmselbot[6] cmselbot[7] cmselbot[8] cmselbot[9] cmselbot[10]
+ cmselbot[11] cmselbot[12] cmselbot[13] cmselbot[14] cmselbot[15] cmselbot[16]
+ cmselbot[17] cmselbot[18] cmselbot[19] cmselbot[20] cmselbot[21] cmselbot[22]
+ cmselbot[23] cmselbot[24] cmselbot[25] cmselbot[26] cmselbot[27] cmselbot[28]
+ cmselbot[29] cmselbot[30] cmselbot[31] lblpchglftbot[0] lblpchglftbot[1]
+ lblpchglftbot[2] lblpchglftbot[3] lblpchgrgtbot[0] lblpchgrgtbot[1]
+ lblpchgrgtbot[2] lblpchgrgtbot[3] sdlclktop sdlclkbot
+ c73p1rfshdxrom2048x32hb4img108_ctrlslice
.ENDS c73p1rfshdxrom2048x32hb4img108

