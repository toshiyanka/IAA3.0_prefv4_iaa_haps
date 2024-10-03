{netlist c73p1rfshdxrom2048x16hb4img100.py
{version 2 1 0 }
/* ICV_Nettran: SUSE.64 Release I-2013.12.SP2.HF3.4001 2014/01/19 */ 
/* Created:  3/03/2016  10:22   */
/* Options: -sp /nfs/iind/disks/apd_disk0048/w/ashah24/mxGen/ILK_16WW08/XLLLP/out_11/c73p1rfshdxrom2048x16hb4img100_compout/pdv/netlists/spice/c73p1rfshdxrom2048x16hb4img100.sp -outName c73p1rfshdxrom2048x16hb4img100.py -mprop -cell c73p1rfshdxrom2048x16hb4img100 -sp-chopXPrefix -fopen C -fopen R -sp-slashSpace -equiv nettran.equiv -wireLog c73p1rfshdxrom2048x16hb4img100_resolve.log -noflatten  */

{net_global vss }
{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvspacer
{port cm[0] cm[1] cm[2] cm[3] cm[4] cm[5]
 cm[6] cm[7] pwren_in pwren_out rclk rw[0] rw[1]
 rw[2] rw[3] rx[0] rx[1] rx[2] rx[3] rx[4]
 rx[5] rx[6] rx[7] ry[0] ry[1] ry[2] ry[3]
 rz[0] rz[1] vccd_1p0 vccdgt_1p0}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_x4pwrcell
{port pwren_in vccd_1p0 vccdgt_1p0}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=2.016 L=0.042}
{pin vccdgt_1p0=DRN pwren_in=GATE vccd_1p0=SRC vccd_1p0=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rwlinv4g
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=1.932 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=1.008 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_da7nag43nn0n1
{port a0 a1 a2 a3 b ck
 o0 o1 o2 o3 vcc}
{inst Mqp9=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o1=DRN a1=GATE vcc=SRC vcc=BULK}}
{inst Mqp8=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o1=DRN b=GATE vcc=SRC vcc=BULK}}
{inst Mqp7=pxlllp {TYPE MOS} 
{prop W=0.294 L=0.042}
{pin o1=DRN ck=GATE vcc=SRC vcc=BULK}}
{inst Mqp6=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o2=DRN a2=GATE vcc=SRC vcc=BULK}}
{inst Mqp5=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o2=DRN b=GATE vcc=SRC vcc=BULK}}
{inst Mqp4=pxlllp {TYPE MOS} 
{prop W=0.294 L=0.042}
{pin o2=DRN ck=GATE vcc=SRC vcc=BULK}}
{inst Mqp3=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o3=DRN a3=GATE vcc=SRC vcc=BULK}}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o3=DRN b=GATE vcc=SRC vcc=BULK}}
{inst Mqp12=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o0=DRN a0=GATE vcc=SRC vcc=BULK}}
{inst Mqp11=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o0=DRN b=GATE vcc=SRC vcc=BULK}}
{inst Mqp10=pxlllp {TYPE MOS} 
{prop W=0.294 L=0.042}
{pin o0=DRN ck=GATE vcc=SRC vcc=BULK}}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.294 L=0.042}
{pin o3=DRN ck=GATE vcc=SRC vcc=BULK}}
{inst Mqn6=nxlllp {TYPE MOS} 
{prop W=1.008 L=0.042}
{pin n0=DRN b=GATE vss=SRC vss=BULK}}
{inst Mqn5=nxlllp {TYPE MOS} 
{prop W=1.008 L=0.042}
{pin n9=DRN ck=GATE n0=SRC vss=BULK}}
{inst Mqn4=nxlllp {TYPE MOS} 
{prop W=0.504 L=0.042}
{pin o0=DRN a0=GATE n9=SRC vss=BULK}}
{inst Mqn3=nxlllp {TYPE MOS} 
{prop W=0.504 L=0.042}
{pin o1=DRN a1=GATE n9=SRC vss=BULK}}
{inst Mqn2=nxlllp {TYPE MOS} 
{prop W=0.504 L=0.042}
{pin o2=DRN a2=GATE n9=SRC vss=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.504 L=0.042}
{pin o3=DRN a3=GATE n9=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9nan23xwsh0
{port a b c o1 vccxx}
{inst Mqp3=pxlllp {TYPE MOS} 
{prop W=0.588 L=0.042}
{pin o1=DRN c=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=0.588 L=0.042}
{pin o1=DRN b=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.588 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn3=nxlllp {TYPE MOS} 
{prop W=1.512 L=0.042}
{pin n2=DRN c=GATE vss=SRC vss=BULK}}
{inst Mqn2=nxlllp {TYPE MOS} 
{prop W=1.512 L=0.042}
{pin n1=DRN b=GATE n2=SRC vss=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=1.512 L=0.042}
{pin o1=DRN a=GATE n1=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9nan02xwse7
{port a b o1 vccxx}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=0.42 L=0.042}
{pin o1=DRN b=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.42 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn2=nxlllp {TYPE MOS} 
{prop W=0.504 L=0.042}
{pin n1=DRN b=GATE vss=SRC vss=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.504 L=0.042}
{pin o1=DRN a=GATE n1=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvgappwrcell
{port pwren_in pwren_inbuf pwren_out pwren_outbuf vccd_1p0 vccdgt_1p0}
{inst Mqp4=pxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin n045=DRN pwren_inbuf=GATE vccd_1p0=SRC vccd_1p0=BULK}}
{inst Mqp3=pxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin pwren_outbuf=DRN n045=GATE vccd_1p0=SRC vccd_1p0=BULK}}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=18.816 L=0.042}
{pin vccdgt_1p0=DRN pwren_out=GATE vccd_1p0=SRC vccd_1p0=BULK}}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin n38=DRN pwren_in=GATE vccd_1p0=SRC vccd_1p0=BULK}}
{inst Mqp0=pxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin pwren_out=DRN n38=GATE vccd_1p0=SRC vccd_1p0=BULK}}
{inst Mqn3=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin n045=DRN pwren_inbuf=GATE vss=SRC vss=BULK}}
{inst Mqn2=nxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin pwren_outbuf=DRN n045=GATE vss=SRC vss=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin n38=DRN pwren_in=GATE vss=SRC vss=BULK}}
{inst Mqn0=nxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin pwren_out=DRN n38=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf7
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9inn00xwsc7
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.168 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.168 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd0
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9nan02xwsg0
{port a b o1 vccxx}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin o1=DRN b=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn2=nxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin n1=DRN b=GATE vss=SRC vss=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin o1=DRN a=GATE n1=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9nan02xwse0
{port a b o1 vccxx}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=0.252 L=0.042}
{pin o1=DRN b=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.252 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn2=nxlllp {TYPE MOS} 
{prop W=0.336 L=0.042}
{pin n1=DRN b=GATE vss=SRC vss=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.336 L=0.042}
{pin o1=DRN a=GATE n1=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9nan03xwse7
{port a b c o1 vccxx}
{inst Mqp3=pxlllp {TYPE MOS} 
{prop W=0.336 L=0.042}
{pin o1=DRN c=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=0.336 L=0.042}
{pin o1=DRN b=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.336 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn3=nxlllp {TYPE MOS} 
{prop W=0.504 L=0.042}
{pin n2=DRN c=GATE vss=SRC vss=BULK}}
{inst Mqn2=nxlllp {TYPE MOS} 
{prop W=0.504 L=0.042}
{pin n1=DRN b=GATE n2=SRC vss=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.504 L=0.042}
{pin o1=DRN a=GATE n1=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9inn00xwsi3
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=2.94 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=2.94 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf0
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.63 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.63 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.252 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.252 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0
{port a b o1 vccxx}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=0.168 L=0.042}
{pin o1=DRN b=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.168 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn2=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin n1=DRN b=GATE vss=SRC vss=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin o1=DRN a=GATE n1=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=1.008 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=1.008 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg5
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=1.26 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=1.26 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9lan80xwsd0
{port clkb d o vccxx}
{inst Mg99.qpa=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n2=DRN n1=GATE vccxx=SRC vccxx=BULK}}
{inst Mg99.qna=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n2=DRN n1=GATE vss=SRC vss=BULK}}
{inst Mg4.qpd=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin g4.n1=DRN n2=GATE vccxx=SRC vccxx=BULK}}
{inst Mg4.qpckb=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n1=DRN n3=GATE g4.n1=SRC vccxx=BULK}}
{inst Mg4.qnd=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin g4.n2=DRN n2=GATE vss=SRC vss=BULK}}
{inst Mg4.qnck=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n1=DRN clkb=GATE g4.n2=SRC vss=BULK}}
{inst Mg3.qpa=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n3=DRN clkb=GATE vccxx=SRC vccxx=BULK}}
{inst Mg3.qna=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n3=DRN clkb=GATE vss=SRC vss=BULK}}
{inst Mg101.qpa=pxlllp {TYPE MOS} 
{prop W=0.168 L=0.042}
{pin o=DRN n1=GATE vccxx=SRC vccxx=BULK}}
{inst Mg101.qna=nxlllp {TYPE MOS} 
{prop W=0.168 L=0.042}
{pin o=DRN n1=GATE vss=SRC vss=BULK}}
{inst Mg1.qpa=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin n4=DRN d=GATE vccxx=SRC vccxx=BULK}}
{inst Mg1.qna=nxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin n4=DRN d=GATE vss=SRC vss=BULK}}
{inst Mg0.qpsb=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n1=DRN clkb=GATE n4=SRC vccxx=BULK}}
{inst Mg0.qns=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n1=DRN n3=GATE n4=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9lan80xwsc5
{port clkb d o vccxx}
{inst Mg99.qpa=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n2=DRN n1=GATE vccxx=SRC vccxx=BULK}}
{inst Mg99.qna=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n2=DRN n1=GATE vss=SRC vss=BULK}}
{inst Mg4.qpd=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin g4.n1=DRN n2=GATE vccxx=SRC vccxx=BULK}}
{inst Mg4.qpckb=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n1=DRN n3=GATE g4.n1=SRC vccxx=BULK}}
{inst Mg4.qnd=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin g4.n2=DRN n2=GATE vss=SRC vss=BULK}}
{inst Mg4.qnck=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n1=DRN clkb=GATE g4.n2=SRC vss=BULK}}
{inst Mg3.qpa=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n3=DRN clkb=GATE vccxx=SRC vccxx=BULK}}
{inst Mg3.qna=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n3=DRN clkb=GATE vss=SRC vss=BULK}}
{inst Mg101.qpa=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o=DRN n1=GATE vccxx=SRC vccxx=BULK}}
{inst Mg101.qna=nxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o=DRN n1=GATE vss=SRC vss=BULK}}
{inst Mg1.qpa=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin n4=DRN d=GATE vccxx=SRC vccxx=BULK}}
{inst Mg1.qna=nxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin n4=DRN d=GATE vss=SRC vss=BULK}}
{inst Mg0.qpsb=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n1=DRN clkb=GATE n4=SRC vccxx=BULK}}
{inst Mg0.qns=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n1=DRN n3=GATE n4=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9nan03xwsd0
{port a b c o1 vccxx}
{inst Mqp3=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o1=DRN c=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o1=DRN b=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn3=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin n2=DRN c=GATE vss=SRC vss=BULK}}
{inst Mqn2=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin n1=DRN b=GATE n2=SRC vss=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin o1=DRN a=GATE n1=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.756 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.756 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsb0
{port a o vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp0=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin o=DRN n1=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n1=DRN a=GATE vss=SRC vss=BULK}}
{inst Mqn0=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin o=DRN n1=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsh0
{port a o vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.42 L=0.042}
{pin n1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp0=pxlllp {TYPE MOS} 
{prop W=1.512 L=0.042}
{pin o=DRN n1=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.42 L=0.042}
{pin n1=DRN a=GATE vss=SRC vss=BULK}}
{inst Mqn0=nxlllp {TYPE MOS} 
{prop W=1.512 L=0.042}
{pin o=DRN n1=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9mbf01xwsb0
{port a o vccxx}
{inst Mqp3=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n3p=DRN n0=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n0=DRN a=GATE n1p=SRC vccxx=BULK}}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n1p=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp0=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin o=DRN n0=GATE n3p=SRC vccxx=BULK}}
{inst Mqn3=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n4p=DRN n0=GATE vss=SRC vss=BULK}}
{inst Mqn2=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n0=DRN a=GATE n2p=SRC vss=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n2p=DRN a=GATE vss=SRC vss=BULK}}
{inst Mqn0=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin o=DRN n0=GATE n4p=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsh7
{port a o vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin n1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp0=pxlllp {TYPE MOS} 
{prop W=2.268 L=0.042}
{pin o=DRN n1=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin n1=DRN a=GATE vss=SRC vss=BULK}}
{inst Mqn0=nxlllp {TYPE MOS} 
{prop W=2.268 L=0.042}
{pin o=DRN n1=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9bfn00xwse0
{port a o vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp0=pxlllp {TYPE MOS} 
{prop W=0.336 L=0.042}
{pin o=DRN n1=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n1=DRN a=GATE vss=SRC vss=BULK}}
{inst Mqn0=nxlllp {TYPE MOS} 
{prop W=0.336 L=0.042}
{pin o=DRN n1=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitspacer
{port gbl vccd_1p0 vccdgt_1p0}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg
{port rwl}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_lblnand
{port a b o1 vccxx}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin o1=DRN b=GATE vccxx=SRC vccxx=BULK}}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn2=nxlllp {TYPE MOS} 
{prop W=0.168 L=0.042}
{pin n1=DRN b=GATE vss=SRC vss=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.168 L=0.042}
{pin o1=DRN a=GATE n1=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g
{port bl rwl}
{inst Mqnbitcell=nxlllp {TYPE MOS} 
{prop W=0.168 L=0.042}
{pin bl_float=DRN rwl=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_da7sls00ln0j1
{port b ck o vccxx}
{inst Mqpck1=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin n0=DRN n11=GATE vccxx=SRC vccxx=BULK}}
{inst Mqpck0=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin o=DRN ck=GATE n0=SRC vccxx=BULK}}
{inst Mqpa=pxlllp {TYPE MOS} 
{prop W=0.252 L=0.042}
{pin o=DRN b=GATE vccxx=SRC vccxx=BULK}}
{inst Mqne=nxlllp {TYPE MOS} 
{prop W=0.252 L=0.042}
{pin o=DRN ck=GATE n10=SRC vss=BULK}}
{inst Mqnck1=nxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin n1=DRN n11=GATE vss=SRC vss=BULK}}
{inst Mqnck0=nxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin o=DRN b=GATE n1=SRC vss=BULK}}
{inst Mqna=nxlllp {TYPE MOS} 
{prop W=0.252 L=0.042}
{pin n10=DRN b=GATE vss=SRC vss=BULK}}
{inst Mgifw.qpa=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n11=DRN o=GATE vccxx=SRC vccxx=BULK}}
{inst Mgifw.qna=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin n11=DRN o=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_iopwrcell
{port pwren_in pwren_out vccd_1p0 vccdgt_1p0}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=10.92 L=0.042}
{pin vccdgt_1p0=DRN pwren_out=GATE vccd_1p0=SRC vccd_1p0=BULK}}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin n38=DRN pwren_in=GATE vccd_1p0=SRC vccd_1p0=BULK}}
{inst Mqp0=pxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin pwren_out=DRN n38=GATE vccd_1p0=SRC vccd_1p0=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin n38=DRN pwren_in=GATE vss=SRC vss=BULK}}
{inst Mqn0=nxlllp {TYPE MOS} 
{prop W=0.84 L=0.042}
{pin pwren_out=DRN n38=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9inn00xwse5
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.42 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.42 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9inn00xwsc0
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.126 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9inn00xwsh3
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=1.764 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=1.764 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0
{port a o1 vccxx}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin o1=DRN a=GATE vccxx=SRC vccxx=BULK}}
{inst Mqn1=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin o1=DRN a=GATE vss=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2
{port brclk cm[0] cm[1] cm[2] cm[3] cm[4]
 cm[5] cm[6] cm[7] pwren_in rclk rw[0] rw[1]
 rw[2] rw[3] rwbuff[0] rwbuff[1] rwbuff[2] rwbuff[3] rwlbot[0]
 rwlbot[1] rwlbot[2] rwlbot[3] rwltop[0] rwltop[1] rwltop[2] rwltop[3]
 rx[0] rx[1] rx[2] rx[3] rx[4] rx[5] rx[6]
 rx[7] rxx ry[0] ry[1] ry[2] ry[3] rz[0]
 rz[1] vccd_1p0 vccdgt_1p0}
{inst ipg=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_x4pwrcell {TYPE CELL} 
{pin pwren_in=pwren_in vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst inn7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rwlinv4g {TYPE CELL} 
{pin rwwl[0]=a rwlbot[0]=o1 vccdgt_1p0=vccxx}}
{inst inn6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rwlinv4g {TYPE CELL} 
{pin rwwl[1]=a rwlbot[1]=o1 vccdgt_1p0=vccxx}}
{inst inn5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rwlinv4g {TYPE CELL} 
{pin rwwl[2]=a rwlbot[2]=o1 vccdgt_1p0=vccxx}}
{inst inn4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rwlinv4g {TYPE CELL} 
{pin rwwl[3]=a rwlbot[3]=o1 vccdgt_1p0=vccxx}}
{inst inn3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rwlinv4g {TYPE CELL} 
{pin rwwl[3]=a rwltop[3]=o1 vccdgt_1p0=vccxx}}
{inst inn2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rwlinv4g {TYPE CELL} 
{pin rwwl[2]=a rwltop[2]=o1 vccdgt_1p0=vccxx}}
{inst inn1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rwlinv4g {TYPE CELL} 
{pin rwwl[1]=a rwltop[1]=o1 vccdgt_1p0=vccxx}}
{inst inn0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rwlinv4g {TYPE CELL} 
{pin rwwl[0]=a rwltop[0]=o1 vccdgt_1p0=vccxx}}
{inst igangnand=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_da7nag43nn0n1 {TYPE CELL} 
{pin rwbuff[0]=a0 rwbuff[1]=a1 rwbuff[2]=a2 rwbuff[3]=a3 rxx=b brclk=ck
 rwwl[0]=o0 rwwl[1]=o1 rwwl[2]=o2 rwwl[3]=o3 vccdgt_1p0=vcc}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvgap
{port brclklft brclkrgt cm[0] cm[1] cm[2] cm[3]
 cm[4] cm[5] cm[6] cm[7] cmselbot[0] cmselbot[1] cmselbot[2]
 cmselbot[3] cmselbot[4] cmselbot[5] cmselbot[6] cmselbot[7] cmseltop[0] cmseltop[1]
 cmseltop[2] cmseltop[3] cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7] lblpchglftbb
 lblpchglfttb lblpchgrgtbb lblpchgrgttb pwren_in pwren_inbuf pwren_out pwren_outbuf
 rclk rw[0] rw[1] rw[2] rw[3] rwbuffleft[0] rwbuffleft[1]
 rwbuffleft[2] rwbuffleft[3] rwbuffright[0] rwbuffright[1] rwbuffright[2] rwbuffright[3] rx[0]
 rx[1] rx[2] rx[3] rx[4] rx[5] rx[6] rx[7]
 rxx[0] rxx[1] rxx[2] rxx[3] rxx[4] rxx[5] rxx[6]
 rxx[7] ry[0] ry[1] ry[2] ry[3] ry0 ry1
 rz[0] rz[1] rz0 vccd_1p0 vccdgt_1p0}
{inst nan9=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin brclkbrgt=a ckrbf2=b lpckrtb=o1 vccdgt_1p0=vccxx}}
{inst nan8=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin brclkblft=a cklbf2=b lpckltb=o1 vccdgt_1p0=vccxx}}
{inst nan7=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin brclkblft=a cklbf2=b lpcklbb=o1 vccdgt_1p0=vccxx}}
{inst nan6=c73p1rfshdxrom2048x16hb4img100_da9nan23xwsh0 {TYPE CELL} 
{pin rclkmb=a n159=b rz0buf=c brclkblft=o1 vccdgt_1p0=vccxx}}
{inst nan5=c73p1rfshdxrom2048x16hb4img100_da9nan23xwsh0 {TYPE CELL} 
{pin rclkmb=a ry1buf=b rz0buf=c brclkbrgt=o1 vccdgt_1p0=vccxx}}
{inst nan4=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin brclkbrgt=a ckrbf2=b lpckrbb=o1 vccdgt_1p0=vccxx}}
{inst nan2=c73p1rfshdxrom2048x16hb4img100_da9nan02xwse7 {TYPE CELL} 
{pin brclkblft=a brclkbrgt=b brclkcomb=o1 vccdgt_1p0=vccxx}}
{inst nan1[7]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[7]=a brclkcomb=b n177[7]=o1 vccdgt_1p0=vccxx}}
{inst nan1[6]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[6]=a brclkcomb=b n177[6]=o1 vccdgt_1p0=vccxx}}
{inst nan1[5]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[5]=a brclkcomb=b n177[5]=o1 vccdgt_1p0=vccxx}}
{inst nan1[4]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[4]=a brclkcomb=b n177[4]=o1 vccdgt_1p0=vccxx}}
{inst nan1[3]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[3]=a brclkcomb=b n177[3]=o1 vccdgt_1p0=vccxx}}
{inst nan1[2]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[2]=a brclkcomb=b n177[2]=o1 vccdgt_1p0=vccxx}}
{inst nan1[1]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[1]=a brclkcomb=b n177[1]=o1 vccdgt_1p0=vccxx}}
{inst nan1[0]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[0]=a brclkcomb=b n177[0]=o1 vccdgt_1p0=vccxx}}
{inst nan0[7]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[7]=a brclkcomb=b n111[7]=o1 vccdgt_1p0=vccxx}}
{inst nan0[6]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[6]=a brclkcomb=b n111[6]=o1 vccdgt_1p0=vccxx}}
{inst nan0[5]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[5]=a brclkcomb=b n111[5]=o1 vccdgt_1p0=vccxx}}
{inst nan0[4]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[4]=a brclkcomb=b n111[4]=o1 vccdgt_1p0=vccxx}}
{inst nan0[3]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[3]=a brclkcomb=b n111[3]=o1 vccdgt_1p0=vccxx}}
{inst nan0[2]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[2]=a brclkcomb=b n111[2]=o1 vccdgt_1p0=vccxx}}
{inst nan0[1]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[1]=a brclkcomb=b n111[1]=o1 vccdgt_1p0=vccxx}}
{inst nan0[0]=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin cmbff[0]=a brclkcomb=b n111[0]=o1 vccdgt_1p0=vccxx}}
{inst ipg=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvgappwrcell {TYPE CELL} 
{pin pwren_in=pwren_in pwren_inbuf=pwren_inbuf pwren_out=pwren_out pwren_outbuf=pwren_outbuf vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst invrwright[3]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf7 {TYPE CELL} 
{pin rwb[3]=a rwbuffright[3]=o1 vccdgt_1p0=vccxx}}
{inst invrwright[2]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf7 {TYPE CELL} 
{pin rwb[2]=a rwbuffright[2]=o1 vccdgt_1p0=vccxx}}
{inst invrwright[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf7 {TYPE CELL} 
{pin rwb[1]=a rwbuffright[1]=o1 vccdgt_1p0=vccxx}}
{inst invrwright[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf7 {TYPE CELL} 
{pin rwb[0]=a rwbuffright[0]=o1 vccdgt_1p0=vccxx}}
{inst invrwleft[3]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf7 {TYPE CELL} 
{pin rwb[3]=a rwbuffleft[3]=o1 vccdgt_1p0=vccxx}}
{inst invrwleft[2]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf7 {TYPE CELL} 
{pin rwb[2]=a rwbuffleft[2]=o1 vccdgt_1p0=vccxx}}
{inst invrwleft[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf7 {TYPE CELL} 
{pin rwb[1]=a rwbuffleft[1]=o1 vccdgt_1p0=vccxx}}
{inst invrwleft[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf7 {TYPE CELL} 
{pin rwb[0]=a rwbuffleft[0]=o1 vccdgt_1p0=vccxx}}
{inst invrwin[3]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin rw[3]=a rwb[3]=o1 vccdgt_1p0=vccxx}}
{inst invrwin[2]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin rw[2]=a rwb[2]=o1 vccdgt_1p0=vccxx}}
{inst invrwin[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin rw[1]=a rwb[1]=o1 vccdgt_1p0=vccxx}}
{inst invrwin[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin rw[0]=a rwb[0]=o1 vccdgt_1p0=vccxx}}
{inst innrx1[7]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg5 {TYPE CELL} 
{pin rxinv[7]=a rxx[7]=o1 vccdgt_1p0=vccxx}}
{inst innrx1[6]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg5 {TYPE CELL} 
{pin rxinv[6]=a rxx[6]=o1 vccdgt_1p0=vccxx}}
{inst innrx1[5]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg5 {TYPE CELL} 
{pin rxinv[5]=a rxx[5]=o1 vccdgt_1p0=vccxx}}
{inst innrx1[4]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg5 {TYPE CELL} 
{pin rxinv[4]=a rxx[4]=o1 vccdgt_1p0=vccxx}}
{inst innrx1[3]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg5 {TYPE CELL} 
{pin rxinv[3]=a rxx[3]=o1 vccdgt_1p0=vccxx}}
{inst innrx1[2]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg5 {TYPE CELL} 
{pin rxinv[2]=a rxx[2]=o1 vccdgt_1p0=vccxx}}
{inst innrx1[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg5 {TYPE CELL} 
{pin rxinv[1]=a rxx[1]=o1 vccdgt_1p0=vccxx}}
{inst innrx1[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg5 {TYPE CELL} 
{pin rxinv[0]=a rxx[0]=o1 vccdgt_1p0=vccxx}}
{inst innrx0[7]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin rx[7]=a rxinv[7]=o1 vccdgt_1p0=vccxx}}
{inst innrx0[6]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin rx[6]=a rxinv[6]=o1 vccdgt_1p0=vccxx}}
{inst innrx0[5]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin rx[5]=a rxinv[5]=o1 vccdgt_1p0=vccxx}}
{inst innrx0[4]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin rx[4]=a rxinv[4]=o1 vccdgt_1p0=vccxx}}
{inst innrx0[3]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin rx[3]=a rxinv[3]=o1 vccdgt_1p0=vccxx}}
{inst innrx0[2]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin rx[2]=a rxinv[2]=o1 vccdgt_1p0=vccxx}}
{inst innrx0[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin rx[1]=a rxinv[1]=o1 vccdgt_1p0=vccxx}}
{inst innrx0[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin rx[0]=a rxinv[0]=o1 vccdgt_1p0=vccxx}}
{inst inn9=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin ry1=a n165=o1 vccdgt_1p0=vccxx}}
{inst inn8=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd0 {TYPE CELL} 
{pin n165=a ry1buf=o1 vccdgt_1p0=vccxx}}
{inst inn7=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd0 {TYPE CELL} 
{pin n171=a n159=o1 vccdgt_1p0=vccxx}}
{inst inn6=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin ry0=a n171=o1 vccdgt_1p0=vccxx}}
{inst inn5=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsc7 {TYPE CELL} 
{pin rclk=a rclkmb=o1 vccdgt_1p0=vccxx}}
{inst inn21=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin lpckrtb=a lblpchgrgttb=o1 vccdgt_1p0=vccxx}}
{inst inn20=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin lpcklbb=a lblpchglftbb=o1 vccdgt_1p0=vccxx}}
{inst inn19=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin lpckltb=a lblpchglfttb=o1 vccdgt_1p0=vccxx}}
{inst inn16=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin lpckrbb=a lblpchgrgtbb=o1 vccdgt_1p0=vccxx}}
{inst inn15=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg5 {TYPE CELL} 
{pin brclkblft=a brclklft=o1 vccdgt_1p0=vccxx}}
{inst inn14=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg5 {TYPE CELL} 
{pin brclkbrgt=a brclkrgt=o1 vccdgt_1p0=vccxx}}
{inst inn13[7]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n111[7]=a cmseltop[7]=o1 vccdgt_1p0=vccxx}}
{inst inn13[6]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n111[6]=a cmseltop[6]=o1 vccdgt_1p0=vccxx}}
{inst inn13[5]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n111[5]=a cmseltop[5]=o1 vccdgt_1p0=vccxx}}
{inst inn13[4]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n111[4]=a cmseltop[4]=o1 vccdgt_1p0=vccxx}}
{inst inn13[3]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n111[3]=a cmseltop[3]=o1 vccdgt_1p0=vccxx}}
{inst inn13[2]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n111[2]=a cmseltop[2]=o1 vccdgt_1p0=vccxx}}
{inst inn13[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n111[1]=a cmseltop[1]=o1 vccdgt_1p0=vccxx}}
{inst inn13[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n111[0]=a cmseltop[0]=o1 vccdgt_1p0=vccxx}}
{inst inn12[7]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n177[7]=a cmselbot[7]=o1 vccdgt_1p0=vccxx}}
{inst inn12[6]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n177[6]=a cmselbot[6]=o1 vccdgt_1p0=vccxx}}
{inst inn12[5]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n177[5]=a cmselbot[5]=o1 vccdgt_1p0=vccxx}}
{inst inn12[4]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n177[4]=a cmselbot[4]=o1 vccdgt_1p0=vccxx}}
{inst inn12[3]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n177[3]=a cmselbot[3]=o1 vccdgt_1p0=vccxx}}
{inst inn12[2]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n177[2]=a cmselbot[2]=o1 vccdgt_1p0=vccxx}}
{inst inn12[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n177[1]=a cmselbot[1]=o1 vccdgt_1p0=vccxx}}
{inst inn12[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin n177[0]=a cmselbot[0]=o1 vccdgt_1p0=vccxx}}
{inst inn11=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin rz0=a n168=o1 vccdgt_1p0=vccxx}}
{inst inn10=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd0 {TYPE CELL} 
{pin n168=a rz0buf=o1 vccdgt_1p0=vccxx}}
{inst icmbf[7]=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsb0 {TYPE CELL} 
{pin cm[7]=a cmbff[7]=o vccdgt_1p0=vccxx}}
{inst icmbf[6]=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsb0 {TYPE CELL} 
{pin cm[6]=a cmbff[6]=o vccdgt_1p0=vccxx}}
{inst icmbf[5]=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsb0 {TYPE CELL} 
{pin cm[5]=a cmbff[5]=o vccdgt_1p0=vccxx}}
{inst icmbf[4]=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsb0 {TYPE CELL} 
{pin cm[4]=a cmbff[4]=o vccdgt_1p0=vccxx}}
{inst icmbf[3]=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsb0 {TYPE CELL} 
{pin cm[3]=a cmbff[3]=o vccdgt_1p0=vccxx}}
{inst icmbf[2]=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsb0 {TYPE CELL} 
{pin cm[2]=a cmbff[2]=o vccdgt_1p0=vccxx}}
{inst icmbf[1]=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsb0 {TYPE CELL} 
{pin cm[1]=a cmbff[1]=o vccdgt_1p0=vccxx}}
{inst icmbf[0]=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsb0 {TYPE CELL} 
{pin cm[0]=a cmbff[0]=o vccdgt_1p0=vccxx}}
{inst bfn7=c73p1rfshdxrom2048x16hb4img100_da9mbf01xwsb0 {TYPE CELL} 
{pin ckrbf1=a ckrbf2=o vccdgt_1p0=vccxx}}
{inst bfn5=c73p1rfshdxrom2048x16hb4img100_da9mbf01xwsb0 {TYPE CELL} 
{pin cklbf1=a cklbf2=o vccdgt_1p0=vccxx}}
{inst bfn3=c73p1rfshdxrom2048x16hb4img100_da9mbf01xwsb0 {TYPE CELL} 
{pin brclkbrgt=a ckrbf1=o vccdgt_1p0=vccxx}}
{inst bfn0=c73p1rfshdxrom2048x16hb4img100_da9mbf01xwsb0 {TYPE CELL} 
{pin brclkblft=a cklbf1=o vccdgt_1p0=vccxx}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_sdlchopper
{port clkin clkout vccxx}
{inst nan1=c73p1rfshdxrom2048x16hb4img100_da9nan02xwse0 {TYPE CELL} 
{pin clkin=a pch6=b clkout=o1 vccxx=vccxx}}
{inst ibuff4=c73p1rfshdxrom2048x16hb4img100_da9mbf01xwsb0 {TYPE CELL} 
{pin pch5=a pch6=o vccxx=vccxx}}
{inst ibuff3=c73p1rfshdxrom2048x16hb4img100_da9mbf01xwsb0 {TYPE CELL} 
{pin pch4=a pch5=o vccxx=vccxx}}
{inst ibuff2=c73p1rfshdxrom2048x16hb4img100_da9mbf01xwsb0 {TYPE CELL} 
{pin pch3=a pch4=o vccxx=vccxx}}
{inst ibuff1=c73p1rfshdxrom2048x16hb4img100_da9mbf01xwsb0 {TYPE CELL} 
{pin pch2=a pch3=o vccxx=vccxx}}
{inst ibuff0=c73p1rfshdxrom2048x16hb4img100_da9mbf01xwsb0 {TYPE CELL} 
{pin clkin=a pch2=o vccxx=vccxx}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rxdec
{port a[0] a[1] a[2] rx[0] rx[1] rx[2]
 rx[3] rx[4] rx[5] rx[6] rx[7] vccxx}
{inst nan7=c73p1rfshdxrom2048x16hb4img100_da9nan03xwse7 {TYPE CELL} 
{pin ab[2]=a ab[1]=b ab[0]=c x[0]=o1 vccxx=vccxx}}
{inst nan6=c73p1rfshdxrom2048x16hb4img100_da9nan03xwse7 {TYPE CELL} 
{pin ab[2]=a ab[1]=b abb[0]=c x[1]=o1 vccxx=vccxx}}
{inst nan5=c73p1rfshdxrom2048x16hb4img100_da9nan03xwse7 {TYPE CELL} 
{pin ab[2]=a abb[1]=b ab[0]=c x[2]=o1 vccxx=vccxx}}
{inst nan4=c73p1rfshdxrom2048x16hb4img100_da9nan03xwse7 {TYPE CELL} 
{pin ab[2]=a abb[1]=b abb[0]=c x[3]=o1 vccxx=vccxx}}
{inst nan3=c73p1rfshdxrom2048x16hb4img100_da9nan03xwse7 {TYPE CELL} 
{pin abb[2]=a abb[1]=b abb[0]=c x[7]=o1 vccxx=vccxx}}
{inst nan2=c73p1rfshdxrom2048x16hb4img100_da9nan03xwse7 {TYPE CELL} 
{pin abb[2]=a abb[1]=b ab[0]=c x[6]=o1 vccxx=vccxx}}
{inst nan1=c73p1rfshdxrom2048x16hb4img100_da9nan03xwse7 {TYPE CELL} 
{pin abb[2]=a ab[1]=b abb[0]=c x[5]=o1 vccxx=vccxx}}
{inst nan0=c73p1rfshdxrom2048x16hb4img100_da9nan03xwse7 {TYPE CELL} 
{pin abb[2]=a ab[1]=b ab[0]=c x[4]=o1 vccxx=vccxx}}
{inst inn9=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsi3 {TYPE CELL} 
{pin x[0]=a rx[0]=o1 vccxx=vccxx}}
{inst inn8=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsi3 {TYPE CELL} 
{pin x[1]=a rx[1]=o1 vccxx=vccxx}}
{inst inn7=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsi3 {TYPE CELL} 
{pin x[2]=a rx[2]=o1 vccxx=vccxx}}
{inst inn6=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsi3 {TYPE CELL} 
{pin x[3]=a rx[3]=o1 vccxx=vccxx}}
{inst inn5=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsi3 {TYPE CELL} 
{pin x[7]=a rx[7]=o1 vccxx=vccxx}}
{inst inn4=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsi3 {TYPE CELL} 
{pin x[6]=a rx[6]=o1 vccxx=vccxx}}
{inst inn3=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsi3 {TYPE CELL} 
{pin x[5]=a rx[5]=o1 vccxx=vccxx}}
{inst inn2=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsi3 {TYPE CELL} 
{pin x[4]=a rx[4]=o1 vccxx=vccxx}}
{inst inn1[2]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf0 {TYPE CELL} 
{pin ab[2]=a abb[2]=o1 vccxx=vccxx}}
{inst inn1[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf0 {TYPE CELL} 
{pin ab[1]=a abb[1]=o1 vccxx=vccxx}}
{inst inn1[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf0 {TYPE CELL} 
{pin ab[0]=a abb[0]=o1 vccxx=vccxx}}
{inst inn0[2]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin a[2]=a ab[2]=o1 vccxx=vccxx}}
{inst inn0[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin a[1]=a ab[1]=o1 vccxx=vccxx}}
{inst inn0[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsd5 {TYPE CELL} 
{pin a[0]=a ab[0]=o1 vccxx=vccxx}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rzdec
{port a0 rz[0] rz[1] vccxx}
{inst inn1=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5 {TYPE CELL} 
{pin a0=a rz[0]=o1 vccxx=vccxx}}
{inst inn0=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf0 {TYPE CELL} 
{pin rz[0]=a rz[1]=o1 vccxx=vccxx}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rydec
{port a[0] a[1] ry[0] ry[1] ry[2] ry[3]
 vccxx}
{inst nan3=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin abb[1]=a abb[0]=b y[3]=o1 vccxx=vccxx}}
{inst nan2=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin abb[1]=a ab[0]=b y[2]=o1 vccxx=vccxx}}
{inst nan1=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin ab[1]=a abb[0]=b y[1]=o1 vccxx=vccxx}}
{inst nan0=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin ab[1]=a ab[0]=b y[0]=o1 vccxx=vccxx}}
{inst inn5=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5 {TYPE CELL} 
{pin y[3]=a ry[3]=o1 vccxx=vccxx}}
{inst inn4=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5 {TYPE CELL} 
{pin y[2]=a ry[2]=o1 vccxx=vccxx}}
{inst inn3=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5 {TYPE CELL} 
{pin y[1]=a ry[1]=o1 vccxx=vccxx}}
{inst inn2=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5 {TYPE CELL} 
{pin y[0]=a ry[0]=o1 vccxx=vccxx}}
{inst inn1[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsc0 {TYPE CELL} 
{pin ab[1]=a abb[1]=o1 vccxx=vccxx}}
{inst inn1[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsc0 {TYPE CELL} 
{pin ab[0]=a abb[0]=o1 vccxx=vccxx}}
{inst inn0[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin a[1]=a ab[1]=o1 vccxx=vccxx}}
{inst inn0[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin a[0]=a ab[0]=o1 vccxx=vccxx}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rwdec
{port a[0] a[1] rw[0] rw[1] rw[2] rw[3]
 vccxx}
{inst nan3=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin abb[1]=a abb[0]=b w[3]=o1 vccxx=vccxx}}
{inst nan2=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin abb[1]=a ab[0]=b w[2]=o1 vccxx=vccxx}}
{inst nan1=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin ab[1]=a abb[0]=b w[1]=o1 vccxx=vccxx}}
{inst nan0=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsd0 {TYPE CELL} 
{pin ab[1]=a ab[0]=b w[0]=o1 vccxx=vccxx}}
{inst inn5=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin w[3]=a rw[3]=o1 vccxx=vccxx}}
{inst inn4=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin w[2]=a rw[2]=o1 vccxx=vccxx}}
{inst inn3=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin w[1]=a rw[1]=o1 vccxx=vccxx}}
{inst inn2=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin w[0]=a rw[0]=o1 vccxx=vccxx}}
{inst inn1[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsc0 {TYPE CELL} 
{pin ab[1]=a abb[1]=o1 vccxx=vccxx}}
{inst inn1[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsc0 {TYPE CELL} 
{pin ab[0]=a abb[0]=o1 vccxx=vccxx}}
{inst inn0[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin a[1]=a ab[1]=o1 vccxx=vccxx}}
{inst inn0[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin a[0]=a ab[0]=o1 vccxx=vccxx}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_cmdec
{port a[0] a[1] a[2] cm[0] cm[1] cm[2]
 cm[3] cm[4] cm[5] cm[6] cm[7] vccxx}
{inst nan7=c73p1rfshdxrom2048x16hb4img100_da9nan03xwsd0 {TYPE CELL} 
{pin ab[2]=a ab[1]=b ab[0]=c c[0]=o1 vccxx=vccxx}}
{inst nan6=c73p1rfshdxrom2048x16hb4img100_da9nan03xwsd0 {TYPE CELL} 
{pin ab[2]=a ab[1]=b abb[0]=c c[1]=o1 vccxx=vccxx}}
{inst nan5=c73p1rfshdxrom2048x16hb4img100_da9nan03xwsd0 {TYPE CELL} 
{pin ab[2]=a abb[1]=b ab[0]=c c[2]=o1 vccxx=vccxx}}
{inst nan4=c73p1rfshdxrom2048x16hb4img100_da9nan03xwsd0 {TYPE CELL} 
{pin ab[2]=a abb[1]=b abb[0]=c c[3]=o1 vccxx=vccxx}}
{inst nan3=c73p1rfshdxrom2048x16hb4img100_da9nan03xwsd0 {TYPE CELL} 
{pin abb[2]=a abb[1]=b abb[0]=c c[7]=o1 vccxx=vccxx}}
{inst nan2=c73p1rfshdxrom2048x16hb4img100_da9nan03xwsd0 {TYPE CELL} 
{pin abb[2]=a abb[1]=b ab[0]=c c[6]=o1 vccxx=vccxx}}
{inst nan1=c73p1rfshdxrom2048x16hb4img100_da9nan03xwsd0 {TYPE CELL} 
{pin abb[2]=a ab[1]=b abb[0]=c c[5]=o1 vccxx=vccxx}}
{inst nan0=c73p1rfshdxrom2048x16hb4img100_da9nan03xwsd0 {TYPE CELL} 
{pin abb[2]=a ab[1]=b ab[0]=c c[4]=o1 vccxx=vccxx}}
{inst inn9=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5 {TYPE CELL} 
{pin c[0]=a cm[0]=o1 vccxx=vccxx}}
{inst inn8=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5 {TYPE CELL} 
{pin c[1]=a cm[1]=o1 vccxx=vccxx}}
{inst inn7=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5 {TYPE CELL} 
{pin c[2]=a cm[2]=o1 vccxx=vccxx}}
{inst inn6=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5 {TYPE CELL} 
{pin c[3]=a cm[3]=o1 vccxx=vccxx}}
{inst inn5=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5 {TYPE CELL} 
{pin c[7]=a cm[7]=o1 vccxx=vccxx}}
{inst inn4=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5 {TYPE CELL} 
{pin c[6]=a cm[6]=o1 vccxx=vccxx}}
{inst inn3=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5 {TYPE CELL} 
{pin c[5]=a cm[5]=o1 vccxx=vccxx}}
{inst inn2=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsf5 {TYPE CELL} 
{pin c[4]=a cm[4]=o1 vccxx=vccxx}}
{inst inn1[2]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsc0 {TYPE CELL} 
{pin ab[2]=a abb[2]=o1 vccxx=vccxx}}
{inst inn1[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsc0 {TYPE CELL} 
{pin ab[1]=a abb[1]=o1 vccxx=vccxx}}
{inst inn1[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsc0 {TYPE CELL} 
{pin ab[0]=a abb[0]=o1 vccxx=vccxx}}
{inst inn0[2]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin abuff[2]=a ab[2]=o1 vccxx=vccxx}}
{inst inn0[1]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin abuff[1]=a ab[1]=o1 vccxx=vccxx}}
{inst inn0[0]=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin abuff[0]=a ab[0]=o1 vccxx=vccxx}}
{inst bfn0[2]=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsb0 {TYPE CELL} 
{pin a[2]=a abuff[2]=o vccxx=vccxx}}
{inst bfn0[1]=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsb0 {TYPE CELL} 
{pin a[1]=a abuff[1]=o vccxx=vccxx}}
{inst bfn0[0]=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsb0 {TYPE CELL} 
{pin a[0]=a abuff[0]=o vccxx=vccxx}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitgap
{port cm[0] cm[1] cm[2] cm[3] cm[4] cm[5]
 cm[6] cm[7] gbl lblleft[0] lblleft[1] lblleft[2] lblleft[3]
 lblleft[4] lblleft[5] lblleft[6] lblleft[7] lblpchclkleftb lblpchclkrightb lblright[0]
 lblright[1] lblright[2] lblright[3] lblright[4] lblright[5] lblright[6] lblright[7]
 vccdgt_1p0}
{inst inn3=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsc0 {TYPE CELL} 
{pin lblpchclkrightb=a lblpchclkright=o1 vccdgt_1p0=vccxx}}
{inst inn2=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsc0 {TYPE CELL} 
{pin lblpchclkleftb=a lblpchclkleft=o1 vccdgt_1p0=vccxx}}
{inst iffwdr=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin lblr=a kpr=o1 vccdgt_1p0=vccxx}}
{inst iffwdl=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin lbll=a kpl=o1 vccdgt_1p0=vccxx}}
{inst grdbl=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_lblnand {TYPE CELL} 
{pin lblr=a lbll=b rdbl=o1 vccdgt_1p0=vccxx}}
{inst Mqpchsc[7]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblright[7]=DRN lblpchclkright=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqpchsc[6]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblright[6]=DRN lblpchclkright=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqpchsc[5]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblright[5]=DRN lblpchclkright=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqpchsc[4]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblright[4]=DRN lblpchclkright=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqpchsc[3]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblright[3]=DRN lblpchclkright=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqpchsc[2]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblright[2]=DRN lblpchclkright=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqpchsc[1]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblright[1]=DRN lblpchclkright=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqpchsc[0]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblright[0]=DRN lblpchclkright=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqpch=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblr=DRN lblpchclkright=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqp9=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin lblr=DRN kpr=GATE kp0r=SRC vccdgt_1p0=BULK}}
{inst Mqp7[7]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblleft[7]=DRN lblpchclkleft=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqp7[6]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblleft[6]=DRN lblpchclkleft=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqp7[5]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblleft[5]=DRN lblpchclkleft=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqp7[4]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblleft[4]=DRN lblpchclkleft=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqp7[3]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblleft[3]=DRN lblpchclkleft=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqp7[2]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblleft[2]=DRN lblpchclkleft=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqp7[1]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblleft[1]=DRN lblpchclkleft=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqp7[0]=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lblleft[0]=DRN lblpchclkleft=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqp6=pxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin lbll=DRN lblpchclkleft=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqp5=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin kp0l=DRN kpl=GATE kp1l=SRC vccdgt_1p0=BULK}}
{inst Mqp4=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin lbll=DRN kpl=GATE kp0l=SRC vccdgt_1p0=BULK}}
{inst Mqp3=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin kp1l=DRN vss=GATE kp2l=SRC vccdgt_1p0=BULK}}
{inst Mqp2=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin kp2l=DRN vss=GATE kp3l=SRC vccdgt_1p0=BULK}}
{inst Mqp14=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin kp1r=DRN vss=GATE kp2r=SRC vccdgt_1p0=BULK}}
{inst Mqp13=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin kp2r=DRN vss=GATE kp3r=SRC vccdgt_1p0=BULK}}
{inst Mqp12=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin kp3r=DRN vss=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqp1=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin kp3l=DRN vss=GATE vccdgt_1p0=SRC vccdgt_1p0=BULK}}
{inst Mqp0=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin kp0r=DRN kpr=GATE kp1r=SRC vccdgt_1p0=BULK}}
{inst Mqngblpd=nxlllp {TYPE MOS} 
{prop W=0.504 L=0.042}
{pin gbl=DRN rdbl=GATE vss=SRC vss=BULK}}
{inst Mqncmright[7]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lblr=DRN cm[7]=GATE lblright[7]=SRC vss=BULK}}
{inst Mqncmright[6]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lblr=DRN cm[6]=GATE lblright[6]=SRC vss=BULK}}
{inst Mqncmright[5]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lblr=DRN cm[5]=GATE lblright[5]=SRC vss=BULK}}
{inst Mqncmright[4]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lblr=DRN cm[4]=GATE lblright[4]=SRC vss=BULK}}
{inst Mqncmright[3]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lblr=DRN cm[3]=GATE lblright[3]=SRC vss=BULK}}
{inst Mqncmright[2]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lblr=DRN cm[2]=GATE lblright[2]=SRC vss=BULK}}
{inst Mqncmright[1]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lblr=DRN cm[1]=GATE lblright[1]=SRC vss=BULK}}
{inst Mqncmright[0]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lblr=DRN cm[0]=GATE lblright[0]=SRC vss=BULK}}
{inst Mqn1[7]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lbll=DRN cm[7]=GATE lblleft[7]=SRC vss=BULK}}
{inst Mqn1[6]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lbll=DRN cm[6]=GATE lblleft[6]=SRC vss=BULK}}
{inst Mqn1[5]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lbll=DRN cm[5]=GATE lblleft[5]=SRC vss=BULK}}
{inst Mqn1[4]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lbll=DRN cm[4]=GATE lblleft[4]=SRC vss=BULK}}
{inst Mqn1[3]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lbll=DRN cm[3]=GATE lblleft[3]=SRC vss=BULK}}
{inst Mqn1[2]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lbll=DRN cm[2]=GATE lblleft[2]=SRC vss=BULK}}
{inst Mqn1[1]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lbll=DRN cm[1]=GATE lblleft[1]=SRC vss=BULK}}
{inst Mqn1[0]=nxlllp {TYPE MOS} 
{prop W=0.21 L=0.042}
{pin lbll=DRN cm[0]=GATE lblleft[0]=SRC vss=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_gblpchg
{port gbl gblclk vccxx}
{inst igblffwdinv=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin gbl=a kpg=o1 vccxx=vccxx}}
{inst Mgpch0=pxlllp {TYPE MOS} 
{prop W=0.336 L=0.042}
{pin gbl=DRN gblclk=GATE vccxx=SRC vccxx=BULK}}
{inst Mgkprn1=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin kn0=DRN kpg=GATE vss=SRC vss=BULK}}
{inst Mgkprn0=nxlllp {TYPE MOS} 
{prop W=0.084 L=0.042}
{pin gbl=DRN gblclk=GATE kn0=SRC vss=BULK}}
{inst Mgkp2=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin gbl=DRN kpg=GATE kp01=SRC vccxx=BULK}}
{inst Mgkp1=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin kp01=DRN kpg=GATE kp11=SRC vccxx=BULK}}
{inst Mgkp0=pxlllp {TYPE MOS} 
{prop W=0.042 L=0.042}
{pin kp11=DRN vss=GATE vccxx=SRC vccxx=BULK}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_ctrl
{port cm[0] cm[1] cm[2] cm[3] cm[4] cm[5]
 cm[6] cm[7] gclkbout iar[0] iar[1] iar[2] iar[3]
 iar[4] iar[5] iar[6] iar[7] iar[8] iar[9] iar[10]
 irclk iren pwr_ctrlio pwr_ioctrl rw[0] rw[1] rw[2]
 rw[3] rx[0] rx[1] rx[2] rx[3] rx[4] rx[5]
 rx[6] rx[7] ry[0] ry[1] ry[2] ry[3] rz[0]
 rz[1] sdlclkbot sdlclktop vccd_1p0 vccdgt_1p0}
{inst nan0=c73p1rfshdxrom2048x16hb4img100_da9nan02xwsg0 {TYPE CELL} 
{pin rclkbuff=a latren=b gclkb=o1 vccdgt_1p0=vccxx}}
{inst isdlchopper=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_sdlchopper {TYPE CELL} 
{pin gclkmbbf=clkin sdlclkmb=clkout vccdgt_1p0=vccxx}}
{inst irzdec=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rzdec {TYPE CELL} 
{pin lataddrb[10]=a0 rz[0]=rz[0] rz[1]=rz[1] vccdgt_1p0=vccxx}}
{inst irydec=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rydec {TYPE CELL} 
{pin lataddrb[8]=a[0] lataddrb[9]=a[1] ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3]
 vccdgt_1p0=vccxx}}
{inst irxdec=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rxdec {TYPE CELL} 
{pin lataddrb[5]=a[0] lataddrb[6]=a[1] lataddrb[7]=a[2] rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2]
 rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6] rx[7]=rx[7] vccdgt_1p0=vccxx}}
{inst irwdec=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_rwdec {TYPE CELL} 
{pin lataddrb[3]=a[0] lataddrb[4]=a[1] rw[0]=rw[0] rw[1]=rw[1] rw[2]=rw[2] rw[3]=rw[3]
 vccdgt_1p0=vccxx}}
{inst inn9=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsb0 {TYPE CELL} 
{pin gclk=a gclkmb=o1 vccdgt_1p0=vccxx}}
{inst inn6=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg0 {TYPE CELL} 
{pin gclkb=a gclk=o1 vccdgt_1p0=vccxx}}
{inst inn11=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg5 {TYPE CELL} 
{pin sdlclkmb=a sdlclkbot=o1 vccdgt_1p0=vccxx}}
{inst inn10=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsg5 {TYPE CELL} 
{pin sdlclkmb=a sdlclktop=o1 vccdgt_1p0=vccxx}}
{inst inn0=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsh3 {TYPE CELL} 
{pin gclk=a gclkbout=o1 vccdgt_1p0=vccxx}}
{inst ilatchren=c73p1rfshdxrom2048x16hb4img100_da9lan80xwsd0 {TYPE CELL} 
{pin rclkbuff=clkb iren=d latren=o vccdgt_1p0=vccxx}}
{inst ilatchaddr[9]=c73p1rfshdxrom2048x16hb4img100_da9lan80xwsc5 {TYPE CELL} 
{pin gclkbf2=clkb iar[9]=d lataddrb[9]=o vccdgt_1p0=vccxx}}
{inst ilatchaddr[8]=c73p1rfshdxrom2048x16hb4img100_da9lan80xwsc5 {TYPE CELL} 
{pin gclkbf2=clkb iar[8]=d lataddrb[8]=o vccdgt_1p0=vccxx}}
{inst ilatchaddr[7]=c73p1rfshdxrom2048x16hb4img100_da9lan80xwsc5 {TYPE CELL} 
{pin gclkbf2=clkb iar[7]=d lataddrb[7]=o vccdgt_1p0=vccxx}}
{inst ilatchaddr[6]=c73p1rfshdxrom2048x16hb4img100_da9lan80xwsc5 {TYPE CELL} 
{pin gclkbf2=clkb iar[6]=d lataddrb[6]=o vccdgt_1p0=vccxx}}
{inst ilatchaddr[5]=c73p1rfshdxrom2048x16hb4img100_da9lan80xwsc5 {TYPE CELL} 
{pin gclkbf2=clkb iar[5]=d lataddrb[5]=o vccdgt_1p0=vccxx}}
{inst ilatchaddr[4]=c73p1rfshdxrom2048x16hb4img100_da9lan80xwsc5 {TYPE CELL} 
{pin gclkbf2=clkb iar[4]=d lataddrb[4]=o vccdgt_1p0=vccxx}}
{inst ilatchaddr[3]=c73p1rfshdxrom2048x16hb4img100_da9lan80xwsc5 {TYPE CELL} 
{pin gclkbf2=clkb iar[3]=d lataddrb[3]=o vccdgt_1p0=vccxx}}
{inst ilatchaddr[2]=c73p1rfshdxrom2048x16hb4img100_da9lan80xwsc5 {TYPE CELL} 
{pin gclkbf2=clkb iar[2]=d lataddrb[2]=o vccdgt_1p0=vccxx}}
{inst ilatchaddr[1]=c73p1rfshdxrom2048x16hb4img100_da9lan80xwsc5 {TYPE CELL} 
{pin gclkbf2=clkb iar[1]=d lataddrb[1]=o vccdgt_1p0=vccxx}}
{inst ilatchaddr[10]=c73p1rfshdxrom2048x16hb4img100_da9lan80xwsc5 {TYPE CELL} 
{pin gclkbf2=clkb iar[10]=d lataddrb[10]=o vccdgt_1p0=vccxx}}
{inst ilatchaddr[0]=c73p1rfshdxrom2048x16hb4img100_da9lan80xwsc5 {TYPE CELL} 
{pin gclkbf2=clkb iar[0]=d lataddrb[0]=o vccdgt_1p0=vccxx}}
{inst icmdec=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_cmdec {TYPE CELL} 
{pin lataddrb[0]=a[0] lataddrb[1]=a[1] lataddrb[2]=a[2] cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2]
 cm[3]=cm[3] cm[4]=cm[4] cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] vccdgt_1p0=vccxx}}
{inst iclk1=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsh0 {TYPE CELL} 
{pin gclkbf1=a gclkbf2=o vccdgt_1p0=vccxx}}
{inst iclk0=c73p1rfshdxrom2048x16hb4img100_da9mbf01xwsb0 {TYPE CELL} 
{pin gclk=a gclkbf1=o vccdgt_1p0=vccxx}}
{inst ibfckr=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwsh7 {TYPE CELL} 
{pin irclk=a rclkbuff=o vccdgt_1p0=vccxx}}
{inst bfn4=c73p1rfshdxrom2048x16hb4img100_da9bfn00xwse0 {TYPE CELL} 
{pin gclkmb=a gclkmbbf=o vccdgt_1p0=vccxx}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitslicearray32v2bit0
{port cm[0] cm[1] cm[2] cm[3] cm[4] cm[5]
 cm[6] cm[7] gbl lblpchclkleftb lblpchclkrightb rwlt[0] rwlt[1]
 rwlt[2] rwlt[3] rwlt[4] rwlt[5] rwlt[6] rwlt[7] rwlt[8]
 rwlt[9] rwlt[10] rwlt[11] rwlt[12] rwlt[13] rwlt[14] rwlt[15]
 rwlt[16] rwlt[17] rwlt[18] rwlt[19] rwlt[20] rwlt[21] rwlt[22]
 rwlt[23] rwlt[24] rwlt[25] rwlt[26] rwlt[27] rwlt[28] rwlt[29]
 rwlt[30] rwlt[31] rwlt[32] rwlt[33] rwlt[34] rwlt[35] rwlt[36]
 rwlt[37] rwlt[38] rwlt[39] rwlt[40] rwlt[41] rwlt[42] rwlt[43]
 rwlt[44] rwlt[45] rwlt[46] rwlt[47] rwlt[48] rwlt[49] rwlt[50]
 rwlt[51] rwlt[52] rwlt[53] rwlt[54] rwlt[55] rwlt[56] rwlt[57]
 rwlt[58] rwlt[59] rwlt[60] rwlt[61] rwlt[62] rwlt[63] vccd_1p0
 vccdgt_1p0}
{inst ipc_r9c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[9]=rwl}}
{inst ipc_r8c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[8]=rwl}}
{inst ipc_r7c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[7]=rwl}}
{inst ipc_r6c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[6]=rwl}}
{inst ipc_r63c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[63]=rwl}}
{inst ipc_r62c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[62]=rwl}}
{inst ipc_r61c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[61]=rwl}}
{inst ipc_r60c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[60]=rwl}}
{inst ipc_r5c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[5]=rwl}}
{inst ipc_r59c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[59]=rwl}}
{inst ipc_r58c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[58]=rwl}}
{inst ipc_r57c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[57]=rwl}}
{inst ipc_r56c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[56]=rwl}}
{inst ipc_r55c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[55]=rwl}}
{inst ipc_r54c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[54]=rwl}}
{inst ipc_r53c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[53]=rwl}}
{inst ipc_r52c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[52]=rwl}}
{inst ipc_r51c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[51]=rwl}}
{inst ipc_r50c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[50]=rwl}}
{inst ipc_r4c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[4]=rwl}}
{inst ipc_r49c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[49]=rwl}}
{inst ipc_r48c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[48]=rwl}}
{inst ipc_r47c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[47]=rwl}}
{inst ipc_r46c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[46]=rwl}}
{inst ipc_r45c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[45]=rwl}}
{inst ipc_r44c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[44]=rwl}}
{inst ipc_r43c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[43]=rwl}}
{inst ipc_r42c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[42]=rwl}}
{inst ipc_r41c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[41]=rwl}}
{inst ipc_r40c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[40]=rwl}}
{inst ipc_r3c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[3]=rwl}}
{inst ipc_r39c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[39]=rwl}}
{inst ipc_r38c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[38]=rwl}}
{inst ipc_r37c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[37]=rwl}}
{inst ipc_r36c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[36]=rwl}}
{inst ipc_r35c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[35]=rwl}}
{inst ipc_r34c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[34]=rwl}}
{inst ipc_r33c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[33]=rwl}}
{inst ipc_r32c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[32]=rwl}}
{inst ipc_r31c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[31]=rwl}}
{inst ipc_r30c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[30]=rwl}}
{inst ipc_r2c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[2]=rwl}}
{inst ipc_r29c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[29]=rwl}}
{inst ipc_r28c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[28]=rwl}}
{inst ipc_r27c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[27]=rwl}}
{inst ipc_r26c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[26]=rwl}}
{inst ipc_r25c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[25]=rwl}}
{inst ipc_r24c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[24]=rwl}}
{inst ipc_r23c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[23]=rwl}}
{inst ipc_r22c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[22]=rwl}}
{inst ipc_r21c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[21]=rwl}}
{inst ipc_r20c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[20]=rwl}}
{inst ipc_r1c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[1]=rwl}}
{inst ipc_r19c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[19]=rwl}}
{inst ipc_r18c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[18]=rwl}}
{inst ipc_r17c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[17]=rwl}}
{inst ipc_r16c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[16]=rwl}}
{inst ipc_r15c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[15]=rwl}}
{inst ipc_r14c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[14]=rwl}}
{inst ipc_r13c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[13]=rwl}}
{inst ipc_r12c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[12]=rwl}}
{inst ipc_r11c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[11]=rwl}}
{inst ipc_r10c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[10]=rwl}}
{inst ipc_r0c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_polycon3dg {TYPE CELL} 
{pin rwlt[0]=rwl}}
{inst ic73p4hdrom_bitgap=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitgap {TYPE CELL} 
{pin cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4] cm[5]=cm[5]
 cm[6]=cm[6] cm[7]=cm[7] gbl=gbl lblleft[0]=lblleft[0] lblleft[1]=lblleft[1] lblleft[2]=lblleft[2] lblleft[3]=lblleft[3]
 lblleft[4]=lblleft[4] lblleft[5]=lblleft[5] lblleft[6]=lblleft[6] lblleft[7]=lblleft[7] lblpchclkleftb=lblpchclkleftb lblpchclkrightb=lblpchclkrightb lblright[0]=lblright[0]
 lblright[1]=lblright[1] lblright[2]=lblright[2] lblright[3]=lblright[3] lblright[4]=lblright[4] lblright[5]=lblright[5] lblright[6]=lblright[6] lblright[7]=lblright[7]
 vccdgt_1p0=vccdgt_1p0}}
{inst iarray_r9c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[9]=rwl}}
{inst iarray_r9c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[9]=rwl}}
{inst iarray_r9c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[9]=rwl}}
{inst iarray_r9c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[9]=rwl}}
{inst iarray_r9c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[9]=rwl}}
{inst iarray_r9c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[9]=rwl}}
{inst iarray_r9c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[9]=rwl}}
{inst iarray_r9c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[9]=rwl}}
{inst iarray_r8c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[8]=rwl}}
{inst iarray_r8c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[8]=rwl}}
{inst iarray_r8c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[8]=rwl}}
{inst iarray_r8c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[8]=rwl}}
{inst iarray_r8c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[8]=rwl}}
{inst iarray_r8c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[8]=rwl}}
{inst iarray_r8c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[8]=rwl}}
{inst iarray_r8c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[8]=rwl}}
{inst iarray_r7c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[7]=rwl}}
{inst iarray_r7c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[7]=rwl}}
{inst iarray_r7c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[7]=rwl}}
{inst iarray_r7c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[7]=rwl}}
{inst iarray_r7c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[7]=rwl}}
{inst iarray_r7c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[7]=rwl}}
{inst iarray_r7c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[7]=rwl}}
{inst iarray_r7c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[7]=rwl}}
{inst iarray_r6c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[6]=rwl}}
{inst iarray_r6c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[6]=rwl}}
{inst iarray_r6c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[6]=rwl}}
{inst iarray_r6c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[6]=rwl}}
{inst iarray_r6c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[6]=rwl}}
{inst iarray_r6c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[6]=rwl}}
{inst iarray_r6c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[6]=rwl}}
{inst iarray_r6c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[6]=rwl}}
{inst iarray_r63c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[63]=rwl}}
{inst iarray_r63c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[63]=rwl}}
{inst iarray_r63c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[63]=rwl}}
{inst iarray_r63c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[63]=rwl}}
{inst iarray_r63c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[63]=rwl}}
{inst iarray_r63c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[63]=rwl}}
{inst iarray_r63c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[63]=rwl}}
{inst iarray_r63c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[63]=rwl}}
{inst iarray_r62c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[62]=rwl}}
{inst iarray_r62c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[62]=rwl}}
{inst iarray_r62c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[62]=rwl}}
{inst iarray_r62c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[62]=rwl}}
{inst iarray_r62c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[62]=rwl}}
{inst iarray_r62c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[62]=rwl}}
{inst iarray_r62c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[62]=rwl}}
{inst iarray_r62c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[62]=rwl}}
{inst iarray_r61c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[61]=rwl}}
{inst iarray_r61c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[61]=rwl}}
{inst iarray_r61c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[61]=rwl}}
{inst iarray_r61c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[61]=rwl}}
{inst iarray_r61c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[61]=rwl}}
{inst iarray_r61c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[61]=rwl}}
{inst iarray_r61c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[61]=rwl}}
{inst iarray_r61c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[61]=rwl}}
{inst iarray_r60c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[60]=rwl}}
{inst iarray_r60c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[60]=rwl}}
{inst iarray_r60c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[60]=rwl}}
{inst iarray_r60c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[60]=rwl}}
{inst iarray_r60c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[60]=rwl}}
{inst iarray_r60c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[60]=rwl}}
{inst iarray_r60c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[60]=rwl}}
{inst iarray_r60c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[60]=rwl}}
{inst iarray_r5c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[5]=rwl}}
{inst iarray_r5c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[5]=rwl}}
{inst iarray_r5c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[5]=rwl}}
{inst iarray_r5c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[5]=rwl}}
{inst iarray_r5c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[5]=rwl}}
{inst iarray_r5c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[5]=rwl}}
{inst iarray_r5c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[5]=rwl}}
{inst iarray_r5c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[5]=rwl}}
{inst iarray_r59c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[59]=rwl}}
{inst iarray_r59c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[59]=rwl}}
{inst iarray_r59c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[59]=rwl}}
{inst iarray_r59c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[59]=rwl}}
{inst iarray_r59c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[59]=rwl}}
{inst iarray_r59c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[59]=rwl}}
{inst iarray_r59c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[59]=rwl}}
{inst iarray_r59c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[59]=rwl}}
{inst iarray_r58c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[58]=rwl}}
{inst iarray_r58c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[58]=rwl}}
{inst iarray_r58c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[58]=rwl}}
{inst iarray_r58c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[58]=rwl}}
{inst iarray_r58c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[58]=rwl}}
{inst iarray_r58c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[58]=rwl}}
{inst iarray_r58c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[58]=rwl}}
{inst iarray_r58c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[58]=rwl}}
{inst iarray_r57c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[57]=rwl}}
{inst iarray_r57c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[57]=rwl}}
{inst iarray_r57c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[57]=rwl}}
{inst iarray_r57c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[57]=rwl}}
{inst iarray_r57c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[57]=rwl}}
{inst iarray_r57c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[57]=rwl}}
{inst iarray_r57c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[57]=rwl}}
{inst iarray_r57c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[57]=rwl}}
{inst iarray_r56c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[56]=rwl}}
{inst iarray_r56c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[56]=rwl}}
{inst iarray_r56c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[56]=rwl}}
{inst iarray_r56c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[56]=rwl}}
{inst iarray_r56c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[56]=rwl}}
{inst iarray_r56c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[56]=rwl}}
{inst iarray_r56c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[56]=rwl}}
{inst iarray_r56c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[56]=rwl}}
{inst iarray_r55c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[55]=rwl}}
{inst iarray_r55c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[55]=rwl}}
{inst iarray_r55c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[55]=rwl}}
{inst iarray_r55c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[55]=rwl}}
{inst iarray_r55c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[55]=rwl}}
{inst iarray_r55c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[55]=rwl}}
{inst iarray_r55c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[55]=rwl}}
{inst iarray_r55c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[55]=rwl}}
{inst iarray_r54c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[54]=rwl}}
{inst iarray_r54c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[54]=rwl}}
{inst iarray_r54c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[54]=rwl}}
{inst iarray_r54c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[54]=rwl}}
{inst iarray_r54c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[54]=rwl}}
{inst iarray_r54c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[54]=rwl}}
{inst iarray_r54c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[54]=rwl}}
{inst iarray_r54c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[54]=rwl}}
{inst iarray_r53c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[53]=rwl}}
{inst iarray_r53c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[53]=rwl}}
{inst iarray_r53c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[53]=rwl}}
{inst iarray_r53c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[53]=rwl}}
{inst iarray_r53c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[53]=rwl}}
{inst iarray_r53c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[53]=rwl}}
{inst iarray_r53c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[53]=rwl}}
{inst iarray_r53c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[53]=rwl}}
{inst iarray_r52c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[52]=rwl}}
{inst iarray_r52c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[52]=rwl}}
{inst iarray_r52c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[52]=rwl}}
{inst iarray_r52c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[52]=rwl}}
{inst iarray_r52c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[52]=rwl}}
{inst iarray_r52c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[52]=rwl}}
{inst iarray_r52c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[52]=rwl}}
{inst iarray_r52c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[52]=rwl}}
{inst iarray_r51c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[51]=rwl}}
{inst iarray_r51c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[51]=rwl}}
{inst iarray_r51c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[51]=rwl}}
{inst iarray_r51c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[51]=rwl}}
{inst iarray_r51c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[51]=rwl}}
{inst iarray_r51c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[51]=rwl}}
{inst iarray_r51c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[51]=rwl}}
{inst iarray_r51c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[51]=rwl}}
{inst iarray_r50c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[50]=rwl}}
{inst iarray_r50c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[50]=rwl}}
{inst iarray_r50c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[50]=rwl}}
{inst iarray_r50c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[50]=rwl}}
{inst iarray_r50c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[50]=rwl}}
{inst iarray_r50c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[50]=rwl}}
{inst iarray_r50c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[50]=rwl}}
{inst iarray_r50c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[50]=rwl}}
{inst iarray_r4c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[4]=rwl}}
{inst iarray_r4c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[4]=rwl}}
{inst iarray_r4c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[4]=rwl}}
{inst iarray_r4c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[4]=rwl}}
{inst iarray_r4c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[4]=rwl}}
{inst iarray_r4c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[4]=rwl}}
{inst iarray_r4c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[4]=rwl}}
{inst iarray_r4c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[4]=rwl}}
{inst iarray_r49c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[49]=rwl}}
{inst iarray_r49c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[49]=rwl}}
{inst iarray_r49c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[49]=rwl}}
{inst iarray_r49c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[49]=rwl}}
{inst iarray_r49c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[49]=rwl}}
{inst iarray_r49c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[49]=rwl}}
{inst iarray_r49c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[49]=rwl}}
{inst iarray_r49c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[49]=rwl}}
{inst iarray_r48c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[48]=rwl}}
{inst iarray_r48c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[48]=rwl}}
{inst iarray_r48c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[48]=rwl}}
{inst iarray_r48c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[48]=rwl}}
{inst iarray_r48c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[48]=rwl}}
{inst iarray_r48c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[48]=rwl}}
{inst iarray_r48c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[48]=rwl}}
{inst iarray_r48c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[48]=rwl}}
{inst iarray_r47c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[47]=rwl}}
{inst iarray_r47c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[47]=rwl}}
{inst iarray_r47c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[47]=rwl}}
{inst iarray_r47c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[47]=rwl}}
{inst iarray_r47c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[47]=rwl}}
{inst iarray_r47c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[47]=rwl}}
{inst iarray_r47c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[47]=rwl}}
{inst iarray_r47c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[47]=rwl}}
{inst iarray_r46c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[46]=rwl}}
{inst iarray_r46c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[46]=rwl}}
{inst iarray_r46c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[46]=rwl}}
{inst iarray_r46c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[46]=rwl}}
{inst iarray_r46c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[46]=rwl}}
{inst iarray_r46c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[46]=rwl}}
{inst iarray_r46c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[46]=rwl}}
{inst iarray_r46c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[46]=rwl}}
{inst iarray_r45c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[45]=rwl}}
{inst iarray_r45c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[45]=rwl}}
{inst iarray_r45c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[45]=rwl}}
{inst iarray_r45c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[45]=rwl}}
{inst iarray_r45c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[45]=rwl}}
{inst iarray_r45c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[45]=rwl}}
{inst iarray_r45c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[45]=rwl}}
{inst iarray_r45c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[45]=rwl}}
{inst iarray_r44c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[44]=rwl}}
{inst iarray_r44c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[44]=rwl}}
{inst iarray_r44c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[44]=rwl}}
{inst iarray_r44c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[44]=rwl}}
{inst iarray_r44c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[44]=rwl}}
{inst iarray_r44c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[44]=rwl}}
{inst iarray_r44c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[44]=rwl}}
{inst iarray_r44c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[44]=rwl}}
{inst iarray_r43c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[43]=rwl}}
{inst iarray_r43c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[43]=rwl}}
{inst iarray_r43c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[43]=rwl}}
{inst iarray_r43c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[43]=rwl}}
{inst iarray_r43c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[43]=rwl}}
{inst iarray_r43c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[43]=rwl}}
{inst iarray_r43c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[43]=rwl}}
{inst iarray_r43c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[43]=rwl}}
{inst iarray_r42c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[42]=rwl}}
{inst iarray_r42c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[42]=rwl}}
{inst iarray_r42c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[42]=rwl}}
{inst iarray_r42c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[42]=rwl}}
{inst iarray_r42c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[42]=rwl}}
{inst iarray_r42c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[42]=rwl}}
{inst iarray_r42c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[42]=rwl}}
{inst iarray_r42c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[42]=rwl}}
{inst iarray_r41c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[41]=rwl}}
{inst iarray_r41c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[41]=rwl}}
{inst iarray_r41c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[41]=rwl}}
{inst iarray_r41c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[41]=rwl}}
{inst iarray_r41c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[41]=rwl}}
{inst iarray_r41c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[41]=rwl}}
{inst iarray_r41c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[41]=rwl}}
{inst iarray_r41c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[41]=rwl}}
{inst iarray_r40c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[40]=rwl}}
{inst iarray_r40c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[40]=rwl}}
{inst iarray_r40c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[40]=rwl}}
{inst iarray_r40c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[40]=rwl}}
{inst iarray_r40c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[40]=rwl}}
{inst iarray_r40c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[40]=rwl}}
{inst iarray_r40c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[40]=rwl}}
{inst iarray_r40c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[40]=rwl}}
{inst iarray_r3c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[3]=rwl}}
{inst iarray_r3c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[3]=rwl}}
{inst iarray_r3c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[3]=rwl}}
{inst iarray_r3c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[3]=rwl}}
{inst iarray_r3c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[3]=rwl}}
{inst iarray_r3c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[3]=rwl}}
{inst iarray_r3c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[3]=rwl}}
{inst iarray_r3c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[3]=rwl}}
{inst iarray_r39c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[39]=rwl}}
{inst iarray_r39c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[39]=rwl}}
{inst iarray_r39c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[39]=rwl}}
{inst iarray_r39c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[39]=rwl}}
{inst iarray_r39c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[39]=rwl}}
{inst iarray_r39c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[39]=rwl}}
{inst iarray_r39c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[39]=rwl}}
{inst iarray_r39c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[39]=rwl}}
{inst iarray_r38c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[38]=rwl}}
{inst iarray_r38c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[38]=rwl}}
{inst iarray_r38c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[38]=rwl}}
{inst iarray_r38c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[38]=rwl}}
{inst iarray_r38c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[38]=rwl}}
{inst iarray_r38c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[38]=rwl}}
{inst iarray_r38c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[38]=rwl}}
{inst iarray_r38c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[38]=rwl}}
{inst iarray_r37c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[37]=rwl}}
{inst iarray_r37c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[37]=rwl}}
{inst iarray_r37c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[37]=rwl}}
{inst iarray_r37c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[37]=rwl}}
{inst iarray_r37c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[37]=rwl}}
{inst iarray_r37c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[37]=rwl}}
{inst iarray_r37c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[37]=rwl}}
{inst iarray_r37c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[37]=rwl}}
{inst iarray_r36c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[36]=rwl}}
{inst iarray_r36c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[36]=rwl}}
{inst iarray_r36c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[36]=rwl}}
{inst iarray_r36c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[36]=rwl}}
{inst iarray_r36c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[36]=rwl}}
{inst iarray_r36c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[36]=rwl}}
{inst iarray_r36c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[36]=rwl}}
{inst iarray_r36c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[36]=rwl}}
{inst iarray_r35c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[35]=rwl}}
{inst iarray_r35c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[35]=rwl}}
{inst iarray_r35c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[35]=rwl}}
{inst iarray_r35c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[35]=rwl}}
{inst iarray_r35c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[35]=rwl}}
{inst iarray_r35c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[35]=rwl}}
{inst iarray_r35c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[35]=rwl}}
{inst iarray_r35c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[35]=rwl}}
{inst iarray_r34c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[34]=rwl}}
{inst iarray_r34c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[34]=rwl}}
{inst iarray_r34c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[34]=rwl}}
{inst iarray_r34c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[34]=rwl}}
{inst iarray_r34c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[34]=rwl}}
{inst iarray_r34c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[34]=rwl}}
{inst iarray_r34c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[34]=rwl}}
{inst iarray_r34c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[34]=rwl}}
{inst iarray_r33c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[33]=rwl}}
{inst iarray_r33c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[33]=rwl}}
{inst iarray_r33c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[33]=rwl}}
{inst iarray_r33c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[33]=rwl}}
{inst iarray_r33c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[33]=rwl}}
{inst iarray_r33c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[33]=rwl}}
{inst iarray_r33c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[33]=rwl}}
{inst iarray_r33c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[33]=rwl}}
{inst iarray_r32c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[7]=bl rwlt[32]=rwl}}
{inst iarray_r32c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[6]=bl rwlt[32]=rwl}}
{inst iarray_r32c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[5]=bl rwlt[32]=rwl}}
{inst iarray_r32c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[4]=bl rwlt[32]=rwl}}
{inst iarray_r32c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[3]=bl rwlt[32]=rwl}}
{inst iarray_r32c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[2]=bl rwlt[32]=rwl}}
{inst iarray_r32c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[1]=bl rwlt[32]=rwl}}
{inst iarray_r32c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblright[0]=bl rwlt[32]=rwl}}
{inst iarray_r31c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[31]=rwl}}
{inst iarray_r31c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[31]=rwl}}
{inst iarray_r31c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[31]=rwl}}
{inst iarray_r31c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[31]=rwl}}
{inst iarray_r31c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[31]=rwl}}
{inst iarray_r31c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[31]=rwl}}
{inst iarray_r31c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[31]=rwl}}
{inst iarray_r31c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[31]=rwl}}
{inst iarray_r30c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[30]=rwl}}
{inst iarray_r30c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[30]=rwl}}
{inst iarray_r30c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[30]=rwl}}
{inst iarray_r30c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[30]=rwl}}
{inst iarray_r30c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[30]=rwl}}
{inst iarray_r30c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[30]=rwl}}
{inst iarray_r30c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[30]=rwl}}
{inst iarray_r30c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[30]=rwl}}
{inst iarray_r2c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[2]=rwl}}
{inst iarray_r2c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[2]=rwl}}
{inst iarray_r2c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[2]=rwl}}
{inst iarray_r2c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[2]=rwl}}
{inst iarray_r2c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[2]=rwl}}
{inst iarray_r2c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[2]=rwl}}
{inst iarray_r2c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[2]=rwl}}
{inst iarray_r2c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[2]=rwl}}
{inst iarray_r29c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[29]=rwl}}
{inst iarray_r29c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[29]=rwl}}
{inst iarray_r29c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[29]=rwl}}
{inst iarray_r29c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[29]=rwl}}
{inst iarray_r29c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[29]=rwl}}
{inst iarray_r29c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[29]=rwl}}
{inst iarray_r29c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[29]=rwl}}
{inst iarray_r29c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[29]=rwl}}
{inst iarray_r28c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[28]=rwl}}
{inst iarray_r28c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[28]=rwl}}
{inst iarray_r28c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[28]=rwl}}
{inst iarray_r28c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[28]=rwl}}
{inst iarray_r28c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[28]=rwl}}
{inst iarray_r28c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[28]=rwl}}
{inst iarray_r28c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[28]=rwl}}
{inst iarray_r28c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[28]=rwl}}
{inst iarray_r27c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[27]=rwl}}
{inst iarray_r27c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[27]=rwl}}
{inst iarray_r27c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[27]=rwl}}
{inst iarray_r27c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[27]=rwl}}
{inst iarray_r27c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[27]=rwl}}
{inst iarray_r27c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[27]=rwl}}
{inst iarray_r27c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[27]=rwl}}
{inst iarray_r27c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[27]=rwl}}
{inst iarray_r26c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[26]=rwl}}
{inst iarray_r26c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[26]=rwl}}
{inst iarray_r26c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[26]=rwl}}
{inst iarray_r26c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[26]=rwl}}
{inst iarray_r26c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[26]=rwl}}
{inst iarray_r26c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[26]=rwl}}
{inst iarray_r26c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[26]=rwl}}
{inst iarray_r26c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[26]=rwl}}
{inst iarray_r25c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[25]=rwl}}
{inst iarray_r25c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[25]=rwl}}
{inst iarray_r25c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[25]=rwl}}
{inst iarray_r25c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[25]=rwl}}
{inst iarray_r25c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[25]=rwl}}
{inst iarray_r25c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[25]=rwl}}
{inst iarray_r25c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[25]=rwl}}
{inst iarray_r25c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[25]=rwl}}
{inst iarray_r24c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[24]=rwl}}
{inst iarray_r24c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[24]=rwl}}
{inst iarray_r24c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[24]=rwl}}
{inst iarray_r24c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[24]=rwl}}
{inst iarray_r24c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[24]=rwl}}
{inst iarray_r24c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[24]=rwl}}
{inst iarray_r24c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[24]=rwl}}
{inst iarray_r24c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[24]=rwl}}
{inst iarray_r23c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[23]=rwl}}
{inst iarray_r23c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[23]=rwl}}
{inst iarray_r23c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[23]=rwl}}
{inst iarray_r23c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[23]=rwl}}
{inst iarray_r23c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[23]=rwl}}
{inst iarray_r23c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[23]=rwl}}
{inst iarray_r23c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[23]=rwl}}
{inst iarray_r23c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[23]=rwl}}
{inst iarray_r22c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[22]=rwl}}
{inst iarray_r22c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[22]=rwl}}
{inst iarray_r22c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[22]=rwl}}
{inst iarray_r22c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[22]=rwl}}
{inst iarray_r22c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[22]=rwl}}
{inst iarray_r22c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[22]=rwl}}
{inst iarray_r22c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[22]=rwl}}
{inst iarray_r22c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[22]=rwl}}
{inst iarray_r21c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[21]=rwl}}
{inst iarray_r21c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[21]=rwl}}
{inst iarray_r21c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[21]=rwl}}
{inst iarray_r21c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[21]=rwl}}
{inst iarray_r21c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[21]=rwl}}
{inst iarray_r21c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[21]=rwl}}
{inst iarray_r21c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[21]=rwl}}
{inst iarray_r21c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[21]=rwl}}
{inst iarray_r20c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[20]=rwl}}
{inst iarray_r20c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[20]=rwl}}
{inst iarray_r20c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[20]=rwl}}
{inst iarray_r20c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[20]=rwl}}
{inst iarray_r20c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[20]=rwl}}
{inst iarray_r20c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[20]=rwl}}
{inst iarray_r20c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[20]=rwl}}
{inst iarray_r20c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[20]=rwl}}
{inst iarray_r1c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[1]=rwl}}
{inst iarray_r1c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[1]=rwl}}
{inst iarray_r1c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[1]=rwl}}
{inst iarray_r1c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[1]=rwl}}
{inst iarray_r1c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[1]=rwl}}
{inst iarray_r1c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[1]=rwl}}
{inst iarray_r1c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[1]=rwl}}
{inst iarray_r1c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[1]=rwl}}
{inst iarray_r19c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[19]=rwl}}
{inst iarray_r19c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[19]=rwl}}
{inst iarray_r19c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[19]=rwl}}
{inst iarray_r19c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[19]=rwl}}
{inst iarray_r19c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[19]=rwl}}
{inst iarray_r19c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[19]=rwl}}
{inst iarray_r19c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[19]=rwl}}
{inst iarray_r19c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[19]=rwl}}
{inst iarray_r18c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[18]=rwl}}
{inst iarray_r18c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[18]=rwl}}
{inst iarray_r18c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[18]=rwl}}
{inst iarray_r18c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[18]=rwl}}
{inst iarray_r18c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[18]=rwl}}
{inst iarray_r18c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[18]=rwl}}
{inst iarray_r18c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[18]=rwl}}
{inst iarray_r18c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[18]=rwl}}
{inst iarray_r17c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[17]=rwl}}
{inst iarray_r17c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[17]=rwl}}
{inst iarray_r17c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[17]=rwl}}
{inst iarray_r17c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[17]=rwl}}
{inst iarray_r17c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[17]=rwl}}
{inst iarray_r17c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[17]=rwl}}
{inst iarray_r17c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[17]=rwl}}
{inst iarray_r17c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[17]=rwl}}
{inst iarray_r16c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[16]=rwl}}
{inst iarray_r16c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[16]=rwl}}
{inst iarray_r16c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[16]=rwl}}
{inst iarray_r16c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[16]=rwl}}
{inst iarray_r16c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[16]=rwl}}
{inst iarray_r16c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[16]=rwl}}
{inst iarray_r16c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[16]=rwl}}
{inst iarray_r16c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[16]=rwl}}
{inst iarray_r15c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[15]=rwl}}
{inst iarray_r15c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[15]=rwl}}
{inst iarray_r15c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[15]=rwl}}
{inst iarray_r15c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[15]=rwl}}
{inst iarray_r15c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[15]=rwl}}
{inst iarray_r15c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[15]=rwl}}
{inst iarray_r15c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[15]=rwl}}
{inst iarray_r15c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[15]=rwl}}
{inst iarray_r14c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[14]=rwl}}
{inst iarray_r14c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[14]=rwl}}
{inst iarray_r14c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[14]=rwl}}
{inst iarray_r14c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[14]=rwl}}
{inst iarray_r14c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[14]=rwl}}
{inst iarray_r14c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[14]=rwl}}
{inst iarray_r14c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[14]=rwl}}
{inst iarray_r14c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[14]=rwl}}
{inst iarray_r13c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[13]=rwl}}
{inst iarray_r13c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[13]=rwl}}
{inst iarray_r13c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[13]=rwl}}
{inst iarray_r13c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[13]=rwl}}
{inst iarray_r13c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[13]=rwl}}
{inst iarray_r13c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[13]=rwl}}
{inst iarray_r13c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[13]=rwl}}
{inst iarray_r13c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[13]=rwl}}
{inst iarray_r12c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[12]=rwl}}
{inst iarray_r12c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[12]=rwl}}
{inst iarray_r12c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[12]=rwl}}
{inst iarray_r12c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[12]=rwl}}
{inst iarray_r12c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[12]=rwl}}
{inst iarray_r12c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[12]=rwl}}
{inst iarray_r12c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[12]=rwl}}
{inst iarray_r12c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[12]=rwl}}
{inst iarray_r11c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[11]=rwl}}
{inst iarray_r11c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[11]=rwl}}
{inst iarray_r11c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[11]=rwl}}
{inst iarray_r11c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[11]=rwl}}
{inst iarray_r11c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[11]=rwl}}
{inst iarray_r11c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[11]=rwl}}
{inst iarray_r11c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[11]=rwl}}
{inst iarray_r11c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[11]=rwl}}
{inst iarray_r10c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[10]=rwl}}
{inst iarray_r10c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[10]=rwl}}
{inst iarray_r10c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[10]=rwl}}
{inst iarray_r10c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[10]=rwl}}
{inst iarray_r10c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[10]=rwl}}
{inst iarray_r10c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[10]=rwl}}
{inst iarray_r10c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[10]=rwl}}
{inst iarray_r10c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[10]=rwl}}
{inst iarray_r0c7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[7]=bl rwlt[0]=rwl}}
{inst iarray_r0c6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[6]=bl rwlt[0]=rwl}}
{inst iarray_r0c5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[5]=bl rwlt[0]=rwl}}
{inst iarray_r0c4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[4]=bl rwlt[0]=rwl}}
{inst iarray_r0c3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[3]=bl rwlt[0]=rwl}}
{inst iarray_r0c2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[2]=bl rwlt[0]=rwl}}
{inst iarray_r0c1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[1]=bl rwlt[0]=rwl}}
{inst iarray_r0c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitcell04g {TYPE CELL} 
{pin lblleft[0]=bl rwlt[0]=rwl}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_datio
{port dout gbl pwren_in pwren_out sdlclkin vccd_1p0
 vccdgt_1p0}
{inst isdl=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_da7sls00ln0j1 {TYPE CELL} 
{pin gbl=b sdlclk=ck sdlout=o vccdgt_1p0=vccxx}}
{inst ipg=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_iopwrcell {TYPE CELL} 
{pin pwren_in=pwren_in pwren_out=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst inn2=c73p1rfshdxrom2048x16hb4img100_da9inn00xwse5 {TYPE CELL} 
{pin sdlout=a sdloutb=o1 vccdgt_1p0=vccxx}}
{inst inn1=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsc0 {TYPE CELL} 
{pin sdlclkin=a sdlclk=o1 vccdgt_1p0=vccxx}}
{inst inn0=c73p1rfshdxrom2048x16hb4img100_da9inn00xwsh3 {TYPE CELL} 
{pin sdloutb=a dout=o1 vccdgt_1p0=vccxx}}
{inst igblpchg=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_gblpchg {TYPE CELL} 
{pin gbl=gbl sdlclk=gblclk vccdgt_1p0=vccxx}}
}

{cell c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvslice32v2
{port cm[0] cm[1] cm[2] cm[3] cm[4] cm[5]
 cm[6] cm[7] cmselbot[0] cmselbot[1] cmselbot[2] cmselbot[3] cmselbot[4]
 cmselbot[5] cmselbot[6] cmselbot[7] cmseltop[0] cmseltop[1] cmseltop[2] cmseltop[3]
 cmseltop[4] cmseltop[5] cmseltop[6] cmseltop[7] lblpchgclkleftbot lblpchgclklefttop lblpchgclkrightbot
 lblpchgclkrighttop pwren_in pwren_inbuf pwren_out pwren_outbuf rclk rw[0]
 rw[1] rw[2] rw[3] rwlbot[0] rwlbot[1] rwlbot[2] rwlbot[3]
 rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7] rwlbot[8] rwlbot[9] rwlbot[10]
 rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14] rwlbot[15] rwlbot[16] rwlbot[17]
 rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21] rwlbot[22] rwlbot[23] rwlbot[24]
 rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28] rwlbot[29] rwlbot[30] rwlbot[31]
 rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35] rwlbot[36] rwlbot[37] rwlbot[38]
 rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42] rwlbot[43] rwlbot[44] rwlbot[45]
 rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49] rwlbot[50] rwlbot[51] rwlbot[52]
 rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56] rwlbot[57] rwlbot[58] rwlbot[59]
 rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63] rwltop[0] rwltop[1] rwltop[2]
 rwltop[3] rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9]
 rwltop[10] rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16]
 rwltop[17] rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23]
 rwltop[24] rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30]
 rwltop[31] rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37]
 rwltop[38] rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44]
 rwltop[45] rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51]
 rwltop[52] rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58]
 rwltop[59] rwltop[60] rwltop[61] rwltop[62] rwltop[63] rx[0] rx[1]
 rx[2] rx[3] rx[4] rx[5] rx[6] rx[7] ry[0]
 ry[1] ry[2] ry[3] ry0 ry1 rz[0] rz[1]
 rz0 vccd_1p0 vccdgt_1p0}
{inst ic73p4hdxrom_wldrvx4_9=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkright=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_out=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffright[0]=rwbuff[0] rwbuffright[1]=rwbuff[1] rwbuffright[2]=rwbuff[2] rwbuffright[3]=rwbuff[3] rwlbot[36]=rwlbot[0]
 rwlbot[37]=rwlbot[1] rwlbot[38]=rwlbot[2] rwlbot[39]=rwlbot[3] rwltop[36]=rwltop[0] rwltop[37]=rwltop[1] rwltop[38]=rwltop[2] rwltop[39]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[1]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_8=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkright=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_out=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffright[0]=rwbuff[0] rwbuffright[1]=rwbuff[1] rwbuffright[2]=rwbuff[2] rwbuffright[3]=rwbuff[3] rwlbot[32]=rwlbot[0]
 rwlbot[33]=rwlbot[1] rwlbot[34]=rwlbot[2] rwlbot[35]=rwlbot[3] rwltop[32]=rwltop[0] rwltop[33]=rwltop[1] rwltop[34]=rwltop[2] rwltop[35]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[0]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_7=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkleft=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_in=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffleft[0]=rwbuff[0] rwbuffleft[1]=rwbuff[1] rwbuffleft[2]=rwbuff[2] rwbuffleft[3]=rwbuff[3] rwlbot[28]=rwlbot[0]
 rwlbot[29]=rwlbot[1] rwlbot[30]=rwlbot[2] rwlbot[31]=rwlbot[3] rwltop[28]=rwltop[0] rwltop[29]=rwltop[1] rwltop[30]=rwltop[2] rwltop[31]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[7]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_6=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkleft=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_in=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffleft[0]=rwbuff[0] rwbuffleft[1]=rwbuff[1] rwbuffleft[2]=rwbuff[2] rwbuffleft[3]=rwbuff[3] rwlbot[24]=rwlbot[0]
 rwlbot[25]=rwlbot[1] rwlbot[26]=rwlbot[2] rwlbot[27]=rwlbot[3] rwltop[24]=rwltop[0] rwltop[25]=rwltop[1] rwltop[26]=rwltop[2] rwltop[27]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[6]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_5=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkleft=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_in=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffleft[0]=rwbuff[0] rwbuffleft[1]=rwbuff[1] rwbuffleft[2]=rwbuff[2] rwbuffleft[3]=rwbuff[3] rwlbot[20]=rwlbot[0]
 rwlbot[21]=rwlbot[1] rwlbot[22]=rwlbot[2] rwlbot[23]=rwlbot[3] rwltop[20]=rwltop[0] rwltop[21]=rwltop[1] rwltop[22]=rwltop[2] rwltop[23]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[5]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_4=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkleft=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_in=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffleft[0]=rwbuff[0] rwbuffleft[1]=rwbuff[1] rwbuffleft[2]=rwbuff[2] rwbuffleft[3]=rwbuff[3] rwlbot[16]=rwlbot[0]
 rwlbot[17]=rwlbot[1] rwlbot[18]=rwlbot[2] rwlbot[19]=rwlbot[3] rwltop[16]=rwltop[0] rwltop[17]=rwltop[1] rwltop[18]=rwltop[2] rwltop[19]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[4]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkleft=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_in=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffleft[0]=rwbuff[0] rwbuffleft[1]=rwbuff[1] rwbuffleft[2]=rwbuff[2] rwbuffleft[3]=rwbuff[3] rwlbot[12]=rwlbot[0]
 rwlbot[13]=rwlbot[1] rwlbot[14]=rwlbot[2] rwlbot[15]=rwlbot[3] rwltop[12]=rwltop[0] rwltop[13]=rwltop[1] rwltop[14]=rwltop[2] rwltop[15]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[3]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkleft=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_in=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffleft[0]=rwbuff[0] rwbuffleft[1]=rwbuff[1] rwbuffleft[2]=rwbuff[2] rwbuffleft[3]=rwbuff[3] rwlbot[8]=rwlbot[0]
 rwlbot[9]=rwlbot[1] rwlbot[10]=rwlbot[2] rwlbot[11]=rwlbot[3] rwltop[8]=rwltop[0] rwltop[9]=rwltop[1] rwltop[10]=rwltop[2] rwltop[11]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[2]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_15=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkright=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_out=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffright[0]=rwbuff[0] rwbuffright[1]=rwbuff[1] rwbuffright[2]=rwbuff[2] rwbuffright[3]=rwbuff[3] rwlbot[60]=rwlbot[0]
 rwlbot[61]=rwlbot[1] rwlbot[62]=rwlbot[2] rwlbot[63]=rwlbot[3] rwltop[60]=rwltop[0] rwltop[61]=rwltop[1] rwltop[62]=rwltop[2] rwltop[63]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[7]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_14=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkright=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_out=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffright[0]=rwbuff[0] rwbuffright[1]=rwbuff[1] rwbuffright[2]=rwbuff[2] rwbuffright[3]=rwbuff[3] rwlbot[56]=rwlbot[0]
 rwlbot[57]=rwlbot[1] rwlbot[58]=rwlbot[2] rwlbot[59]=rwlbot[3] rwltop[56]=rwltop[0] rwltop[57]=rwltop[1] rwltop[58]=rwltop[2] rwltop[59]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[6]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_13=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkright=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_out=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffright[0]=rwbuff[0] rwbuffright[1]=rwbuff[1] rwbuffright[2]=rwbuff[2] rwbuffright[3]=rwbuff[3] rwlbot[52]=rwlbot[0]
 rwlbot[53]=rwlbot[1] rwlbot[54]=rwlbot[2] rwlbot[55]=rwlbot[3] rwltop[52]=rwltop[0] rwltop[53]=rwltop[1] rwltop[54]=rwltop[2] rwltop[55]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[5]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_12=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkright=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_out=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffright[0]=rwbuff[0] rwbuffright[1]=rwbuff[1] rwbuffright[2]=rwbuff[2] rwbuffright[3]=rwbuff[3] rwlbot[48]=rwlbot[0]
 rwlbot[49]=rwlbot[1] rwlbot[50]=rwlbot[2] rwlbot[51]=rwlbot[3] rwltop[48]=rwltop[0] rwltop[49]=rwltop[1] rwltop[50]=rwltop[2] rwltop[51]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[4]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_11=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkright=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_out=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffright[0]=rwbuff[0] rwbuffright[1]=rwbuff[1] rwbuffright[2]=rwbuff[2] rwbuffright[3]=rwbuff[3] rwlbot[44]=rwlbot[0]
 rwlbot[45]=rwlbot[1] rwlbot[46]=rwlbot[2] rwlbot[47]=rwlbot[3] rwltop[44]=rwltop[0] rwltop[45]=rwltop[1] rwltop[46]=rwltop[2] rwltop[47]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[3]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_10=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkright=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_out=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffright[0]=rwbuff[0] rwbuffright[1]=rwbuff[1] rwbuffright[2]=rwbuff[2] rwbuffright[3]=rwbuff[3] rwlbot[40]=rwlbot[0]
 rwlbot[41]=rwlbot[1] rwlbot[42]=rwlbot[2] rwlbot[43]=rwlbot[3] rwltop[40]=rwltop[0] rwltop[41]=rwltop[1] rwltop[42]=rwltop[2] rwltop[43]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[2]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkleft=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_in=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffleft[0]=rwbuff[0] rwbuffleft[1]=rwbuff[1] rwbuffleft[2]=rwbuff[2] rwbuffleft[3]=rwbuff[3] rwlbot[4]=rwlbot[0]
 rwlbot[5]=rwlbot[1] rwlbot[6]=rwlbot[2] rwlbot[7]=rwlbot[3] rwltop[4]=rwltop[0] rwltop[5]=rwltop[1] rwltop[6]=rwltop[2] rwltop[7]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[1]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvx4_0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvx4v2 {TYPE CELL} 
{pin brclkleft=brclk cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4]
 cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] pwren_in=pwren_in rclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rwbuffleft[0]=rwbuff[0] rwbuffleft[1]=rwbuff[1] rwbuffleft[2]=rwbuff[2] rwbuffleft[3]=rwbuff[3] rwlbot[0]=rwlbot[0]
 rwlbot[1]=rwlbot[1] rwlbot[2]=rwlbot[2] rwlbot[3]=rwlbot[3] rwltop[0]=rwltop[0] rwltop[1]=rwltop[1] rwltop[2]=rwltop[2] rwltop[3]=rwltop[3]
 rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6]
 rx[7]=rx[7] rxx[0]=rxx ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ic73p4hdxrom_wldrvgap=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvgap {TYPE CELL} 
{pin brclkleft=brclklft brclkright=brclkrgt cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3]
 cm[4]=cm[4] cm[5]=cm[5] cm[6]=cm[6] cm[7]=cm[7] cmselbot[0]=cmselbot[0] cmselbot[1]=cmselbot[1] cmselbot[2]=cmselbot[2]
 cmselbot[3]=cmselbot[3] cmselbot[4]=cmselbot[4] cmselbot[5]=cmselbot[5] cmselbot[6]=cmselbot[6] cmselbot[7]=cmselbot[7] cmseltop[0]=cmseltop[0] cmseltop[1]=cmseltop[1]
 cmseltop[2]=cmseltop[2] cmseltop[3]=cmseltop[3] cmseltop[4]=cmseltop[4] cmseltop[5]=cmseltop[5] cmseltop[6]=cmseltop[6] cmseltop[7]=cmseltop[7] lblpchgclkleftbot=lblpchglftbb
 lblpchgclklefttop=lblpchglfttb lblpchgclkrightbot=lblpchgrgtbb lblpchgclkrighttop=lblpchgrgttb pwren_in=pwren_in pwren_inbuf=pwren_inbuf pwren_out=pwren_out pwren_outbuf=pwren_outbuf
 rclk=rclk rw[0]=rw[0] rw[1]=rw[1] rw[2]=rw[2] rw[3]=rw[3] rwbuffleft[0]=rwbuffleft[0] rwbuffleft[1]=rwbuffleft[1]
 rwbuffleft[2]=rwbuffleft[2] rwbuffleft[3]=rwbuffleft[3] rwbuffright[0]=rwbuffright[0] rwbuffright[1]=rwbuffright[1] rwbuffright[2]=rwbuffright[2] rwbuffright[3]=rwbuffright[3] rx[0]=rx[0]
 rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6] rx[7]=rx[7]
 rxx[0]=rxx[0] rxx[1]=rxx[1] rxx[2]=rxx[2] rxx[3]=rxx[3] rxx[4]=rxx[4] rxx[5]=rxx[5] rxx[6]=rxx[6]
 rxx[7]=rxx[7] ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] ry0=ry0 ry1=ry1
 rz[0]=rz[0] rz[1]=rz[1] rz0=rz0 vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
}

{cell c73p1rfshdxrom2048x16hb4img100_ctrlslice
{port vccd_1p0 vccdgt_1p0 pwrenwl_in_0 iar[0] iar[1] iar[2]
 iar[3] iar[4] iar[5] iar[6] iar[7] iar[8] iar[9]
 iar[10] ickr iren pwrenwl_out_0 rwltop[0] rwltop[1] rwltop[2]
 rwltop[3] rwltop[4] rwltop[5] rwltop[6] rwltop[7] rwltop[8] rwltop[9]
 rwltop[10] rwltop[11] rwltop[12] rwltop[13] rwltop[14] rwltop[15] rwltop[16]
 rwltop[17] rwltop[18] rwltop[19] rwltop[20] rwltop[21] rwltop[22] rwltop[23]
 rwltop[24] rwltop[25] rwltop[26] rwltop[27] rwltop[28] rwltop[29] rwltop[30]
 rwltop[31] rwltop[32] rwltop[33] rwltop[34] rwltop[35] rwltop[36] rwltop[37]
 rwltop[38] rwltop[39] rwltop[40] rwltop[41] rwltop[42] rwltop[43] rwltop[44]
 rwltop[45] rwltop[46] rwltop[47] rwltop[48] rwltop[49] rwltop[50] rwltop[51]
 rwltop[52] rwltop[53] rwltop[54] rwltop[55] rwltop[56] rwltop[57] rwltop[58]
 rwltop[59] rwltop[60] rwltop[61] rwltop[62] rwltop[63] rwltop[64] rwltop[65]
 rwltop[66] rwltop[67] rwltop[68] rwltop[69] rwltop[70] rwltop[71] rwltop[72]
 rwltop[73] rwltop[74] rwltop[75] rwltop[76] rwltop[77] rwltop[78] rwltop[79]
 rwltop[80] rwltop[81] rwltop[82] rwltop[83] rwltop[84] rwltop[85] rwltop[86]
 rwltop[87] rwltop[88] rwltop[89] rwltop[90] rwltop[91] rwltop[92] rwltop[93]
 rwltop[94] rwltop[95] rwltop[96] rwltop[97] rwltop[98] rwltop[99] rwltop[100]
 rwltop[101] rwltop[102] rwltop[103] rwltop[104] rwltop[105] rwltop[106] rwltop[107]
 rwltop[108] rwltop[109] rwltop[110] rwltop[111] rwltop[112] rwltop[113] rwltop[114]
 rwltop[115] rwltop[116] rwltop[117] rwltop[118] rwltop[119] rwltop[120] rwltop[121]
 rwltop[122] rwltop[123] rwltop[124] rwltop[125] rwltop[126] rwltop[127] rwltop[128]
 rwltop[129] rwltop[130] rwltop[131] rwltop[132] rwltop[133] rwltop[134] rwltop[135]
 rwltop[136] rwltop[137] rwltop[138] rwltop[139] rwltop[140] rwltop[141] rwltop[142]
 rwltop[143] rwltop[144] rwltop[145] rwltop[146] rwltop[147] rwltop[148] rwltop[149]
 rwltop[150] rwltop[151] rwltop[152] rwltop[153] rwltop[154] rwltop[155] rwltop[156]
 rwltop[157] rwltop[158] rwltop[159] rwltop[160] rwltop[161] rwltop[162] rwltop[163]
 rwltop[164] rwltop[165] rwltop[166] rwltop[167] rwltop[168] rwltop[169] rwltop[170]
 rwltop[171] rwltop[172] rwltop[173] rwltop[174] rwltop[175] rwltop[176] rwltop[177]
 rwltop[178] rwltop[179] rwltop[180] rwltop[181] rwltop[182] rwltop[183] rwltop[184]
 rwltop[185] rwltop[186] rwltop[187] rwltop[188] rwltop[189] rwltop[190] rwltop[191]
 rwltop[192] rwltop[193] rwltop[194] rwltop[195] rwltop[196] rwltop[197] rwltop[198]
 rwltop[199] rwltop[200] rwltop[201] rwltop[202] rwltop[203] rwltop[204] rwltop[205]
 rwltop[206] rwltop[207] rwltop[208] rwltop[209] rwltop[210] rwltop[211] rwltop[212]
 rwltop[213] rwltop[214] rwltop[215] rwltop[216] rwltop[217] rwltop[218] rwltop[219]
 rwltop[220] rwltop[221] rwltop[222] rwltop[223] rwltop[224] rwltop[225] rwltop[226]
 rwltop[227] rwltop[228] rwltop[229] rwltop[230] rwltop[231] rwltop[232] rwltop[233]
 rwltop[234] rwltop[235] rwltop[236] rwltop[237] rwltop[238] rwltop[239] rwltop[240]
 rwltop[241] rwltop[242] rwltop[243] rwltop[244] rwltop[245] rwltop[246] rwltop[247]
 rwltop[248] rwltop[249] rwltop[250] rwltop[251] rwltop[252] rwltop[253] rwltop[254]
 rwltop[255] cmtop[0] cmtop[1] cmtop[2] cmtop[3] cmtop[4] cmtop[5]
 cmtop[6] cmtop[7] cmtop[8] cmtop[9] cmtop[10] cmtop[11] cmtop[12]
 cmtop[13] cmtop[14] cmtop[15] cmtop[16] cmtop[17] cmtop[18] cmtop[19]
 cmtop[20] cmtop[21] cmtop[22] cmtop[23] cmtop[24] cmtop[25] cmtop[26]
 cmtop[27] cmtop[28] cmtop[29] cmtop[30] cmtop[31] lblpchglfttop[0] lblpchglfttop[1]
 lblpchglfttop[2] lblpchglfttop[3] lblpchgrgttop[0] lblpchgrgttop[1] lblpchgrgttop[2] lblpchgrgttop[3] rwlbot[0]
 rwlbot[1] rwlbot[2] rwlbot[3] rwlbot[4] rwlbot[5] rwlbot[6] rwlbot[7]
 rwlbot[8] rwlbot[9] rwlbot[10] rwlbot[11] rwlbot[12] rwlbot[13] rwlbot[14]
 rwlbot[15] rwlbot[16] rwlbot[17] rwlbot[18] rwlbot[19] rwlbot[20] rwlbot[21]
 rwlbot[22] rwlbot[23] rwlbot[24] rwlbot[25] rwlbot[26] rwlbot[27] rwlbot[28]
 rwlbot[29] rwlbot[30] rwlbot[31] rwlbot[32] rwlbot[33] rwlbot[34] rwlbot[35]
 rwlbot[36] rwlbot[37] rwlbot[38] rwlbot[39] rwlbot[40] rwlbot[41] rwlbot[42]
 rwlbot[43] rwlbot[44] rwlbot[45] rwlbot[46] rwlbot[47] rwlbot[48] rwlbot[49]
 rwlbot[50] rwlbot[51] rwlbot[52] rwlbot[53] rwlbot[54] rwlbot[55] rwlbot[56]
 rwlbot[57] rwlbot[58] rwlbot[59] rwlbot[60] rwlbot[61] rwlbot[62] rwlbot[63]
 rwlbot[64] rwlbot[65] rwlbot[66] rwlbot[67] rwlbot[68] rwlbot[69] rwlbot[70]
 rwlbot[71] rwlbot[72] rwlbot[73] rwlbot[74] rwlbot[75] rwlbot[76] rwlbot[77]
 rwlbot[78] rwlbot[79] rwlbot[80] rwlbot[81] rwlbot[82] rwlbot[83] rwlbot[84]
 rwlbot[85] rwlbot[86] rwlbot[87] rwlbot[88] rwlbot[89] rwlbot[90] rwlbot[91]
 rwlbot[92] rwlbot[93] rwlbot[94] rwlbot[95] rwlbot[96] rwlbot[97] rwlbot[98]
 rwlbot[99] rwlbot[100] rwlbot[101] rwlbot[102] rwlbot[103] rwlbot[104] rwlbot[105]
 rwlbot[106] rwlbot[107] rwlbot[108] rwlbot[109] rwlbot[110] rwlbot[111] rwlbot[112]
 rwlbot[113] rwlbot[114] rwlbot[115] rwlbot[116] rwlbot[117] rwlbot[118] rwlbot[119]
 rwlbot[120] rwlbot[121] rwlbot[122] rwlbot[123] rwlbot[124] rwlbot[125] rwlbot[126]
 rwlbot[127] rwlbot[128] rwlbot[129] rwlbot[130] rwlbot[131] rwlbot[132] rwlbot[133]
 rwlbot[134] rwlbot[135] rwlbot[136] rwlbot[137] rwlbot[138] rwlbot[139] rwlbot[140]
 rwlbot[141] rwlbot[142] rwlbot[143] rwlbot[144] rwlbot[145] rwlbot[146] rwlbot[147]
 rwlbot[148] rwlbot[149] rwlbot[150] rwlbot[151] rwlbot[152] rwlbot[153] rwlbot[154]
 rwlbot[155] rwlbot[156] rwlbot[157] rwlbot[158] rwlbot[159] rwlbot[160] rwlbot[161]
 rwlbot[162] rwlbot[163] rwlbot[164] rwlbot[165] rwlbot[166] rwlbot[167] rwlbot[168]
 rwlbot[169] rwlbot[170] rwlbot[171] rwlbot[172] rwlbot[173] rwlbot[174] rwlbot[175]
 rwlbot[176] rwlbot[177] rwlbot[178] rwlbot[179] rwlbot[180] rwlbot[181] rwlbot[182]
 rwlbot[183] rwlbot[184] rwlbot[185] rwlbot[186] rwlbot[187] rwlbot[188] rwlbot[189]
 rwlbot[190] rwlbot[191] rwlbot[192] rwlbot[193] rwlbot[194] rwlbot[195] rwlbot[196]
 rwlbot[197] rwlbot[198] rwlbot[199] rwlbot[200] rwlbot[201] rwlbot[202] rwlbot[203]
 rwlbot[204] rwlbot[205] rwlbot[206] rwlbot[207] rwlbot[208] rwlbot[209] rwlbot[210]
 rwlbot[211] rwlbot[212] rwlbot[213] rwlbot[214] rwlbot[215] rwlbot[216] rwlbot[217]
 rwlbot[218] rwlbot[219] rwlbot[220] rwlbot[221] rwlbot[222] rwlbot[223] rwlbot[224]
 rwlbot[225] rwlbot[226] rwlbot[227] rwlbot[228] rwlbot[229] rwlbot[230] rwlbot[231]
 rwlbot[232] rwlbot[233] rwlbot[234] rwlbot[235] rwlbot[236] rwlbot[237] rwlbot[238]
 rwlbot[239] rwlbot[240] rwlbot[241] rwlbot[242] rwlbot[243] rwlbot[244] rwlbot[245]
 rwlbot[246] rwlbot[247] rwlbot[248] rwlbot[249] rwlbot[250] rwlbot[251] rwlbot[252]
 rwlbot[253] rwlbot[254] rwlbot[255] cmbot[0] cmbot[1] cmbot[2] cmbot[3]
 cmbot[4] cmbot[5] cmbot[6] cmbot[7] cmbot[8] cmbot[9] cmbot[10]
 cmbot[11] cmbot[12] cmbot[13] cmbot[14] cmbot[15] cmbot[16] cmbot[17]
 cmbot[18] cmbot[19] cmbot[20] cmbot[21] cmbot[22] cmbot[23] cmbot[24]
 cmbot[25] cmbot[26] cmbot[27] cmbot[28] cmbot[29] cmbot[30] cmbot[31]
 lblpchglftbot[0] lblpchglftbot[1] lblpchglftbot[2] lblpchglftbot[3] lblpchgrgtbot[0] lblpchgrgtbot[1] lblpchgrgtbot[2]
 lblpchgrgtbot[3] sdlclktop sdlclkbot}
{inst wldrvspcr_2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvspacer {TYPE CELL} 
{pin cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4] cm[5]=cm[5]
 cm[6]=cm[6] cm[7]=cm[7] pwrenwl_in_3=pwren_in pwrenwl_out_3=pwren_out gclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4]
 rx[5]=rx[5] rx[6]=rx[6] rx[7]=rx[7] ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3]
 rz[0]=rz[0] rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst wldrvspcr_1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvspacer {TYPE CELL} 
{pin cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4] cm[5]=cm[5]
 cm[6]=cm[6] cm[7]=cm[7] pwrenwl_in_2=pwren_in pwrenwl_out_2=pwren_out gclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4]
 rx[5]=rx[5] rx[6]=rx[6] rx[7]=rx[7] ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3]
 rz[0]=rz[0] rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst wldrvspcr_0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvspacer {TYPE CELL} 
{pin cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4] cm[5]=cm[5]
 cm[6]=cm[6] cm[7]=cm[7] pwrenwl_in_1=pwren_in pwrenwl_out_1=pwren_out gclk=rclk rw[0]=rw[0] rw[1]=rw[1]
 rw[2]=rw[2] rw[3]=rw[3] rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4]
 rx[5]=rx[5] rx[6]=rx[6] rx[7]=rx[7] ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3]
 rz[0]=rz[0] rz[1]=rz[1] vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ctrlslice_bnd3=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvslice32v2 {TYPE CELL} 
{pin cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4] cm[5]=cm[5]
 cm[6]=cm[6] cm[7]=cm[7] cmbot[24]=cmselbot[0] cmbot[25]=cmselbot[1] cmbot[26]=cmselbot[2] cmbot[27]=cmselbot[3] cmbot[28]=cmselbot[4]
 cmbot[29]=cmselbot[5] cmbot[30]=cmselbot[6] cmbot[31]=cmselbot[7] cmtop[24]=cmseltop[0] cmtop[25]=cmseltop[1] cmtop[26]=cmseltop[2] cmtop[27]=cmseltop[3]
 cmtop[28]=cmseltop[4] cmtop[29]=cmseltop[5] cmtop[30]=cmseltop[6] cmtop[31]=cmseltop[7] lblpchglftbot[3]=lblpchgclkleftbot lblpchglfttop[3]=lblpchgclklefttop lblpchgrgtbot[3]=lblpchgclkrightbot
 lblpchgrgttop[3]=lblpchgclkrighttop pwrenwl_in_3=pwren_in pwrenwl_in_4=pwren_inbuf pwrenwl_in_4=pwren_out pwrenwl_out_3=pwren_outbuf gclk=rclk rw[0]=rw[0]
 rw[1]=rw[1] rw[2]=rw[2] rw[3]=rw[3] rwlbot[192]=rwlbot[0] rwlbot[193]=rwlbot[1] rwlbot[194]=rwlbot[2] rwlbot[195]=rwlbot[3]
 rwlbot[196]=rwlbot[4] rwlbot[197]=rwlbot[5] rwlbot[198]=rwlbot[6] rwlbot[199]=rwlbot[7] rwlbot[200]=rwlbot[8] rwlbot[201]=rwlbot[9] rwlbot[202]=rwlbot[10]
 rwlbot[203]=rwlbot[11] rwlbot[204]=rwlbot[12] rwlbot[205]=rwlbot[13] rwlbot[206]=rwlbot[14] rwlbot[207]=rwlbot[15] rwlbot[208]=rwlbot[16] rwlbot[209]=rwlbot[17]
 rwlbot[210]=rwlbot[18] rwlbot[211]=rwlbot[19] rwlbot[212]=rwlbot[20] rwlbot[213]=rwlbot[21] rwlbot[214]=rwlbot[22] rwlbot[215]=rwlbot[23] rwlbot[216]=rwlbot[24]
 rwlbot[217]=rwlbot[25] rwlbot[218]=rwlbot[26] rwlbot[219]=rwlbot[27] rwlbot[220]=rwlbot[28] rwlbot[221]=rwlbot[29] rwlbot[222]=rwlbot[30] rwlbot[223]=rwlbot[31]
 rwlbot[224]=rwlbot[32] rwlbot[225]=rwlbot[33] rwlbot[226]=rwlbot[34] rwlbot[227]=rwlbot[35] rwlbot[228]=rwlbot[36] rwlbot[229]=rwlbot[37] rwlbot[230]=rwlbot[38]
 rwlbot[231]=rwlbot[39] rwlbot[232]=rwlbot[40] rwlbot[233]=rwlbot[41] rwlbot[234]=rwlbot[42] rwlbot[235]=rwlbot[43] rwlbot[236]=rwlbot[44] rwlbot[237]=rwlbot[45]
 rwlbot[238]=rwlbot[46] rwlbot[239]=rwlbot[47] rwlbot[240]=rwlbot[48] rwlbot[241]=rwlbot[49] rwlbot[242]=rwlbot[50] rwlbot[243]=rwlbot[51] rwlbot[244]=rwlbot[52]
 rwlbot[245]=rwlbot[53] rwlbot[246]=rwlbot[54] rwlbot[247]=rwlbot[55] rwlbot[248]=rwlbot[56] rwlbot[249]=rwlbot[57] rwlbot[250]=rwlbot[58] rwlbot[251]=rwlbot[59]
 rwlbot[252]=rwlbot[60] rwlbot[253]=rwlbot[61] rwlbot[254]=rwlbot[62] rwlbot[255]=rwlbot[63] rwltop[192]=rwltop[0] rwltop[193]=rwltop[1] rwltop[194]=rwltop[2]
 rwltop[195]=rwltop[3] rwltop[196]=rwltop[4] rwltop[197]=rwltop[5] rwltop[198]=rwltop[6] rwltop[199]=rwltop[7] rwltop[200]=rwltop[8] rwltop[201]=rwltop[9]
 rwltop[202]=rwltop[10] rwltop[203]=rwltop[11] rwltop[204]=rwltop[12] rwltop[205]=rwltop[13] rwltop[206]=rwltop[14] rwltop[207]=rwltop[15] rwltop[208]=rwltop[16]
 rwltop[209]=rwltop[17] rwltop[210]=rwltop[18] rwltop[211]=rwltop[19] rwltop[212]=rwltop[20] rwltop[213]=rwltop[21] rwltop[214]=rwltop[22] rwltop[215]=rwltop[23]
 rwltop[216]=rwltop[24] rwltop[217]=rwltop[25] rwltop[218]=rwltop[26] rwltop[219]=rwltop[27] rwltop[220]=rwltop[28] rwltop[221]=rwltop[29] rwltop[222]=rwltop[30]
 rwltop[223]=rwltop[31] rwltop[224]=rwltop[32] rwltop[225]=rwltop[33] rwltop[226]=rwltop[34] rwltop[227]=rwltop[35] rwltop[228]=rwltop[36] rwltop[229]=rwltop[37]
 rwltop[230]=rwltop[38] rwltop[231]=rwltop[39] rwltop[232]=rwltop[40] rwltop[233]=rwltop[41] rwltop[234]=rwltop[42] rwltop[235]=rwltop[43] rwltop[236]=rwltop[44]
 rwltop[237]=rwltop[45] rwltop[238]=rwltop[46] rwltop[239]=rwltop[47] rwltop[240]=rwltop[48] rwltop[241]=rwltop[49] rwltop[242]=rwltop[50] rwltop[243]=rwltop[51]
 rwltop[244]=rwltop[52] rwltop[245]=rwltop[53] rwltop[246]=rwltop[54] rwltop[247]=rwltop[55] rwltop[248]=rwltop[56] rwltop[249]=rwltop[57] rwltop[250]=rwltop[58]
 rwltop[251]=rwltop[59] rwltop[252]=rwltop[60] rwltop[253]=rwltop[61] rwltop[254]=rwltop[62] rwltop[255]=rwltop[63] rx[0]=rx[0] rx[1]=rx[1]
 rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6] rx[7]=rx[7] ry[0]=ry[0]
 ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] ry[2]=ry0 ry[3]=ry1 rz[0]=rz[0] rz[1]=rz[1]
 rz[1]=rz0 vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ctrlslice_bnd2=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvslice32v2 {TYPE CELL} 
{pin cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4] cm[5]=cm[5]
 cm[6]=cm[6] cm[7]=cm[7] cmbot[16]=cmselbot[0] cmbot[17]=cmselbot[1] cmbot[18]=cmselbot[2] cmbot[19]=cmselbot[3] cmbot[20]=cmselbot[4]
 cmbot[21]=cmselbot[5] cmbot[22]=cmselbot[6] cmbot[23]=cmselbot[7] cmtop[16]=cmseltop[0] cmtop[17]=cmseltop[1] cmtop[18]=cmseltop[2] cmtop[19]=cmseltop[3]
 cmtop[20]=cmseltop[4] cmtop[21]=cmseltop[5] cmtop[22]=cmseltop[6] cmtop[23]=cmseltop[7] lblpchglftbot[2]=lblpchgclkleftbot lblpchglfttop[2]=lblpchgclklefttop lblpchgrgtbot[2]=lblpchgclkrightbot
 lblpchgrgttop[2]=lblpchgclkrighttop pwrenwl_in_2=pwren_in pwrenwl_out_3=pwren_inbuf pwrenwl_in_3=pwren_out pwrenwl_out_2=pwren_outbuf gclk=rclk rw[0]=rw[0]
 rw[1]=rw[1] rw[2]=rw[2] rw[3]=rw[3] rwlbot[128]=rwlbot[0] rwlbot[129]=rwlbot[1] rwlbot[130]=rwlbot[2] rwlbot[131]=rwlbot[3]
 rwlbot[132]=rwlbot[4] rwlbot[133]=rwlbot[5] rwlbot[134]=rwlbot[6] rwlbot[135]=rwlbot[7] rwlbot[136]=rwlbot[8] rwlbot[137]=rwlbot[9] rwlbot[138]=rwlbot[10]
 rwlbot[139]=rwlbot[11] rwlbot[140]=rwlbot[12] rwlbot[141]=rwlbot[13] rwlbot[142]=rwlbot[14] rwlbot[143]=rwlbot[15] rwlbot[144]=rwlbot[16] rwlbot[145]=rwlbot[17]
 rwlbot[146]=rwlbot[18] rwlbot[147]=rwlbot[19] rwlbot[148]=rwlbot[20] rwlbot[149]=rwlbot[21] rwlbot[150]=rwlbot[22] rwlbot[151]=rwlbot[23] rwlbot[152]=rwlbot[24]
 rwlbot[153]=rwlbot[25] rwlbot[154]=rwlbot[26] rwlbot[155]=rwlbot[27] rwlbot[156]=rwlbot[28] rwlbot[157]=rwlbot[29] rwlbot[158]=rwlbot[30] rwlbot[159]=rwlbot[31]
 rwlbot[160]=rwlbot[32] rwlbot[161]=rwlbot[33] rwlbot[162]=rwlbot[34] rwlbot[163]=rwlbot[35] rwlbot[164]=rwlbot[36] rwlbot[165]=rwlbot[37] rwlbot[166]=rwlbot[38]
 rwlbot[167]=rwlbot[39] rwlbot[168]=rwlbot[40] rwlbot[169]=rwlbot[41] rwlbot[170]=rwlbot[42] rwlbot[171]=rwlbot[43] rwlbot[172]=rwlbot[44] rwlbot[173]=rwlbot[45]
 rwlbot[174]=rwlbot[46] rwlbot[175]=rwlbot[47] rwlbot[176]=rwlbot[48] rwlbot[177]=rwlbot[49] rwlbot[178]=rwlbot[50] rwlbot[179]=rwlbot[51] rwlbot[180]=rwlbot[52]
 rwlbot[181]=rwlbot[53] rwlbot[182]=rwlbot[54] rwlbot[183]=rwlbot[55] rwlbot[184]=rwlbot[56] rwlbot[185]=rwlbot[57] rwlbot[186]=rwlbot[58] rwlbot[187]=rwlbot[59]
 rwlbot[188]=rwlbot[60] rwlbot[189]=rwlbot[61] rwlbot[190]=rwlbot[62] rwlbot[191]=rwlbot[63] rwltop[128]=rwltop[0] rwltop[129]=rwltop[1] rwltop[130]=rwltop[2]
 rwltop[131]=rwltop[3] rwltop[132]=rwltop[4] rwltop[133]=rwltop[5] rwltop[134]=rwltop[6] rwltop[135]=rwltop[7] rwltop[136]=rwltop[8] rwltop[137]=rwltop[9]
 rwltop[138]=rwltop[10] rwltop[139]=rwltop[11] rwltop[140]=rwltop[12] rwltop[141]=rwltop[13] rwltop[142]=rwltop[14] rwltop[143]=rwltop[15] rwltop[144]=rwltop[16]
 rwltop[145]=rwltop[17] rwltop[146]=rwltop[18] rwltop[147]=rwltop[19] rwltop[148]=rwltop[20] rwltop[149]=rwltop[21] rwltop[150]=rwltop[22] rwltop[151]=rwltop[23]
 rwltop[152]=rwltop[24] rwltop[153]=rwltop[25] rwltop[154]=rwltop[26] rwltop[155]=rwltop[27] rwltop[156]=rwltop[28] rwltop[157]=rwltop[29] rwltop[158]=rwltop[30]
 rwltop[159]=rwltop[31] rwltop[160]=rwltop[32] rwltop[161]=rwltop[33] rwltop[162]=rwltop[34] rwltop[163]=rwltop[35] rwltop[164]=rwltop[36] rwltop[165]=rwltop[37]
 rwltop[166]=rwltop[38] rwltop[167]=rwltop[39] rwltop[168]=rwltop[40] rwltop[169]=rwltop[41] rwltop[170]=rwltop[42] rwltop[171]=rwltop[43] rwltop[172]=rwltop[44]
 rwltop[173]=rwltop[45] rwltop[174]=rwltop[46] rwltop[175]=rwltop[47] rwltop[176]=rwltop[48] rwltop[177]=rwltop[49] rwltop[178]=rwltop[50] rwltop[179]=rwltop[51]
 rwltop[180]=rwltop[52] rwltop[181]=rwltop[53] rwltop[182]=rwltop[54] rwltop[183]=rwltop[55] rwltop[184]=rwltop[56] rwltop[185]=rwltop[57] rwltop[186]=rwltop[58]
 rwltop[187]=rwltop[59] rwltop[188]=rwltop[60] rwltop[189]=rwltop[61] rwltop[190]=rwltop[62] rwltop[191]=rwltop[63] rx[0]=rx[0] rx[1]=rx[1]
 rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6] rx[7]=rx[7] ry[0]=ry[0]
 ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] ry[0]=ry0 ry[1]=ry1 rz[0]=rz[0] rz[1]=rz[1]
 rz[1]=rz0 vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ctrlslice_bnd1=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvslice32v2 {TYPE CELL} 
{pin cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4] cm[5]=cm[5]
 cm[6]=cm[6] cm[7]=cm[7] cmbot[8]=cmselbot[0] cmbot[9]=cmselbot[1] cmbot[10]=cmselbot[2] cmbot[11]=cmselbot[3] cmbot[12]=cmselbot[4]
 cmbot[13]=cmselbot[5] cmbot[14]=cmselbot[6] cmbot[15]=cmselbot[7] cmtop[8]=cmseltop[0] cmtop[9]=cmseltop[1] cmtop[10]=cmseltop[2] cmtop[11]=cmseltop[3]
 cmtop[12]=cmseltop[4] cmtop[13]=cmseltop[5] cmtop[14]=cmseltop[6] cmtop[15]=cmseltop[7] lblpchglftbot[1]=lblpchgclkleftbot lblpchglfttop[1]=lblpchgclklefttop lblpchgrgtbot[1]=lblpchgclkrightbot
 lblpchgrgttop[1]=lblpchgclkrighttop pwrenwl_in_1=pwren_in pwrenwl_out_2=pwren_inbuf pwrenwl_in_2=pwren_out pwrenwl_out_1=pwren_outbuf gclk=rclk rw[0]=rw[0]
 rw[1]=rw[1] rw[2]=rw[2] rw[3]=rw[3] rwlbot[64]=rwlbot[0] rwlbot[65]=rwlbot[1] rwlbot[66]=rwlbot[2] rwlbot[67]=rwlbot[3]
 rwlbot[68]=rwlbot[4] rwlbot[69]=rwlbot[5] rwlbot[70]=rwlbot[6] rwlbot[71]=rwlbot[7] rwlbot[72]=rwlbot[8] rwlbot[73]=rwlbot[9] rwlbot[74]=rwlbot[10]
 rwlbot[75]=rwlbot[11] rwlbot[76]=rwlbot[12] rwlbot[77]=rwlbot[13] rwlbot[78]=rwlbot[14] rwlbot[79]=rwlbot[15] rwlbot[80]=rwlbot[16] rwlbot[81]=rwlbot[17]
 rwlbot[82]=rwlbot[18] rwlbot[83]=rwlbot[19] rwlbot[84]=rwlbot[20] rwlbot[85]=rwlbot[21] rwlbot[86]=rwlbot[22] rwlbot[87]=rwlbot[23] rwlbot[88]=rwlbot[24]
 rwlbot[89]=rwlbot[25] rwlbot[90]=rwlbot[26] rwlbot[91]=rwlbot[27] rwlbot[92]=rwlbot[28] rwlbot[93]=rwlbot[29] rwlbot[94]=rwlbot[30] rwlbot[95]=rwlbot[31]
 rwlbot[96]=rwlbot[32] rwlbot[97]=rwlbot[33] rwlbot[98]=rwlbot[34] rwlbot[99]=rwlbot[35] rwlbot[100]=rwlbot[36] rwlbot[101]=rwlbot[37] rwlbot[102]=rwlbot[38]
 rwlbot[103]=rwlbot[39] rwlbot[104]=rwlbot[40] rwlbot[105]=rwlbot[41] rwlbot[106]=rwlbot[42] rwlbot[107]=rwlbot[43] rwlbot[108]=rwlbot[44] rwlbot[109]=rwlbot[45]
 rwlbot[110]=rwlbot[46] rwlbot[111]=rwlbot[47] rwlbot[112]=rwlbot[48] rwlbot[113]=rwlbot[49] rwlbot[114]=rwlbot[50] rwlbot[115]=rwlbot[51] rwlbot[116]=rwlbot[52]
 rwlbot[117]=rwlbot[53] rwlbot[118]=rwlbot[54] rwlbot[119]=rwlbot[55] rwlbot[120]=rwlbot[56] rwlbot[121]=rwlbot[57] rwlbot[122]=rwlbot[58] rwlbot[123]=rwlbot[59]
 rwlbot[124]=rwlbot[60] rwlbot[125]=rwlbot[61] rwlbot[126]=rwlbot[62] rwlbot[127]=rwlbot[63] rwltop[64]=rwltop[0] rwltop[65]=rwltop[1] rwltop[66]=rwltop[2]
 rwltop[67]=rwltop[3] rwltop[68]=rwltop[4] rwltop[69]=rwltop[5] rwltop[70]=rwltop[6] rwltop[71]=rwltop[7] rwltop[72]=rwltop[8] rwltop[73]=rwltop[9]
 rwltop[74]=rwltop[10] rwltop[75]=rwltop[11] rwltop[76]=rwltop[12] rwltop[77]=rwltop[13] rwltop[78]=rwltop[14] rwltop[79]=rwltop[15] rwltop[80]=rwltop[16]
 rwltop[81]=rwltop[17] rwltop[82]=rwltop[18] rwltop[83]=rwltop[19] rwltop[84]=rwltop[20] rwltop[85]=rwltop[21] rwltop[86]=rwltop[22] rwltop[87]=rwltop[23]
 rwltop[88]=rwltop[24] rwltop[89]=rwltop[25] rwltop[90]=rwltop[26] rwltop[91]=rwltop[27] rwltop[92]=rwltop[28] rwltop[93]=rwltop[29] rwltop[94]=rwltop[30]
 rwltop[95]=rwltop[31] rwltop[96]=rwltop[32] rwltop[97]=rwltop[33] rwltop[98]=rwltop[34] rwltop[99]=rwltop[35] rwltop[100]=rwltop[36] rwltop[101]=rwltop[37]
 rwltop[102]=rwltop[38] rwltop[103]=rwltop[39] rwltop[104]=rwltop[40] rwltop[105]=rwltop[41] rwltop[106]=rwltop[42] rwltop[107]=rwltop[43] rwltop[108]=rwltop[44]
 rwltop[109]=rwltop[45] rwltop[110]=rwltop[46] rwltop[111]=rwltop[47] rwltop[112]=rwltop[48] rwltop[113]=rwltop[49] rwltop[114]=rwltop[50] rwltop[115]=rwltop[51]
 rwltop[116]=rwltop[52] rwltop[117]=rwltop[53] rwltop[118]=rwltop[54] rwltop[119]=rwltop[55] rwltop[120]=rwltop[56] rwltop[121]=rwltop[57] rwltop[122]=rwltop[58]
 rwltop[123]=rwltop[59] rwltop[124]=rwltop[60] rwltop[125]=rwltop[61] rwltop[126]=rwltop[62] rwltop[127]=rwltop[63] rx[0]=rx[0] rx[1]=rx[1]
 rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6] rx[7]=rx[7] ry[0]=ry[0]
 ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] ry[2]=ry0 ry[3]=ry1 rz[0]=rz[0] rz[1]=rz[1]
 rz[0]=rz0 vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ctrlslice_bnd0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_wldrvslice32v2 {TYPE CELL} 
{pin cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4] cm[5]=cm[5]
 cm[6]=cm[6] cm[7]=cm[7] cmbot[0]=cmselbot[0] cmbot[1]=cmselbot[1] cmbot[2]=cmselbot[2] cmbot[3]=cmselbot[3] cmbot[4]=cmselbot[4]
 cmbot[5]=cmselbot[5] cmbot[6]=cmselbot[6] cmbot[7]=cmselbot[7] cmtop[0]=cmseltop[0] cmtop[1]=cmseltop[1] cmtop[2]=cmseltop[2] cmtop[3]=cmseltop[3]
 cmtop[4]=cmseltop[4] cmtop[5]=cmseltop[5] cmtop[6]=cmseltop[6] cmtop[7]=cmseltop[7] lblpchglftbot[0]=lblpchgclkleftbot lblpchglfttop[0]=lblpchgclklefttop lblpchgrgtbot[0]=lblpchgclkrightbot
 lblpchgrgttop[0]=lblpchgclkrighttop pwrenwl_in_0=pwren_in pwrenwl_out_1=pwren_inbuf pwrenwl_in_1=pwren_out pwrenwl_out_0=pwren_outbuf gclk=rclk rw[0]=rw[0]
 rw[1]=rw[1] rw[2]=rw[2] rw[3]=rw[3] rwlbot[0]=rwlbot[0] rwlbot[1]=rwlbot[1] rwlbot[2]=rwlbot[2] rwlbot[3]=rwlbot[3]
 rwlbot[4]=rwlbot[4] rwlbot[5]=rwlbot[5] rwlbot[6]=rwlbot[6] rwlbot[7]=rwlbot[7] rwlbot[8]=rwlbot[8] rwlbot[9]=rwlbot[9] rwlbot[10]=rwlbot[10]
 rwlbot[11]=rwlbot[11] rwlbot[12]=rwlbot[12] rwlbot[13]=rwlbot[13] rwlbot[14]=rwlbot[14] rwlbot[15]=rwlbot[15] rwlbot[16]=rwlbot[16] rwlbot[17]=rwlbot[17]
 rwlbot[18]=rwlbot[18] rwlbot[19]=rwlbot[19] rwlbot[20]=rwlbot[20] rwlbot[21]=rwlbot[21] rwlbot[22]=rwlbot[22] rwlbot[23]=rwlbot[23] rwlbot[24]=rwlbot[24]
 rwlbot[25]=rwlbot[25] rwlbot[26]=rwlbot[26] rwlbot[27]=rwlbot[27] rwlbot[28]=rwlbot[28] rwlbot[29]=rwlbot[29] rwlbot[30]=rwlbot[30] rwlbot[31]=rwlbot[31]
 rwlbot[32]=rwlbot[32] rwlbot[33]=rwlbot[33] rwlbot[34]=rwlbot[34] rwlbot[35]=rwlbot[35] rwlbot[36]=rwlbot[36] rwlbot[37]=rwlbot[37] rwlbot[38]=rwlbot[38]
 rwlbot[39]=rwlbot[39] rwlbot[40]=rwlbot[40] rwlbot[41]=rwlbot[41] rwlbot[42]=rwlbot[42] rwlbot[43]=rwlbot[43] rwlbot[44]=rwlbot[44] rwlbot[45]=rwlbot[45]
 rwlbot[46]=rwlbot[46] rwlbot[47]=rwlbot[47] rwlbot[48]=rwlbot[48] rwlbot[49]=rwlbot[49] rwlbot[50]=rwlbot[50] rwlbot[51]=rwlbot[51] rwlbot[52]=rwlbot[52]
 rwlbot[53]=rwlbot[53] rwlbot[54]=rwlbot[54] rwlbot[55]=rwlbot[55] rwlbot[56]=rwlbot[56] rwlbot[57]=rwlbot[57] rwlbot[58]=rwlbot[58] rwlbot[59]=rwlbot[59]
 rwlbot[60]=rwlbot[60] rwlbot[61]=rwlbot[61] rwlbot[62]=rwlbot[62] rwlbot[63]=rwlbot[63] rwltop[0]=rwltop[0] rwltop[1]=rwltop[1] rwltop[2]=rwltop[2]
 rwltop[3]=rwltop[3] rwltop[4]=rwltop[4] rwltop[5]=rwltop[5] rwltop[6]=rwltop[6] rwltop[7]=rwltop[7] rwltop[8]=rwltop[8] rwltop[9]=rwltop[9]
 rwltop[10]=rwltop[10] rwltop[11]=rwltop[11] rwltop[12]=rwltop[12] rwltop[13]=rwltop[13] rwltop[14]=rwltop[14] rwltop[15]=rwltop[15] rwltop[16]=rwltop[16]
 rwltop[17]=rwltop[17] rwltop[18]=rwltop[18] rwltop[19]=rwltop[19] rwltop[20]=rwltop[20] rwltop[21]=rwltop[21] rwltop[22]=rwltop[22] rwltop[23]=rwltop[23]
 rwltop[24]=rwltop[24] rwltop[25]=rwltop[25] rwltop[26]=rwltop[26] rwltop[27]=rwltop[27] rwltop[28]=rwltop[28] rwltop[29]=rwltop[29] rwltop[30]=rwltop[30]
 rwltop[31]=rwltop[31] rwltop[32]=rwltop[32] rwltop[33]=rwltop[33] rwltop[34]=rwltop[34] rwltop[35]=rwltop[35] rwltop[36]=rwltop[36] rwltop[37]=rwltop[37]
 rwltop[38]=rwltop[38] rwltop[39]=rwltop[39] rwltop[40]=rwltop[40] rwltop[41]=rwltop[41] rwltop[42]=rwltop[42] rwltop[43]=rwltop[43] rwltop[44]=rwltop[44]
 rwltop[45]=rwltop[45] rwltop[46]=rwltop[46] rwltop[47]=rwltop[47] rwltop[48]=rwltop[48] rwltop[49]=rwltop[49] rwltop[50]=rwltop[50] rwltop[51]=rwltop[51]
 rwltop[52]=rwltop[52] rwltop[53]=rwltop[53] rwltop[54]=rwltop[54] rwltop[55]=rwltop[55] rwltop[56]=rwltop[56] rwltop[57]=rwltop[57] rwltop[58]=rwltop[58]
 rwltop[59]=rwltop[59] rwltop[60]=rwltop[60] rwltop[61]=rwltop[61] rwltop[62]=rwltop[62] rwltop[63]=rwltop[63] rx[0]=rx[0] rx[1]=rx[1]
 rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5] rx[6]=rx[6] rx[7]=rx[7] ry[0]=ry[0]
 ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] ry[0]=ry0 ry[1]=ry1 rz[0]=rz[0] rz[1]=rz[1]
 rz[0]=rz0 vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst ctrl=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_ctrl {TYPE CELL} 
{pin cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4] cm[5]=cm[5]
 cm[6]=cm[6] cm[7]=cm[7] gclk=gclkbout iar[0]=iar[0] iar[1]=iar[1] iar[2]=iar[2] iar[3]=iar[3]
 iar[4]=iar[4] iar[5]=iar[5] iar[6]=iar[6] iar[7]=iar[7] iar[8]=iar[8] iar[9]=iar[9] iar[10]=iar[10]
 ickr=irclk iren=iren pwrenwl_out_0=pwr_ctrlio pwrenwl_in_0=pwr_ioctrl rw[0]=rw[0] rw[1]=rw[1] rw[2]=rw[2]
 rw[3]=rw[3] rx[0]=rx[0] rx[1]=rx[1] rx[2]=rx[2] rx[3]=rx[3] rx[4]=rx[4] rx[5]=rx[5]
 rx[6]=rx[6] rx[7]=rx[7] ry[0]=ry[0] ry[1]=ry[1] ry[2]=ry[2] ry[3]=ry[3] rz[0]=rz[0]
 rz[1]=rz[1] sdlclkbot=sdlclkbot sdlclktop=sdlclktop vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
}

{cell c73p1rfshdxrom2048x16hb4img100_bitbundle
{port odout pwren_out vccd_1p0 vccdgt_1p0 sdlclkin pwren_in
 rwlt[0] rwlt[1] rwlt[2] rwlt[3] rwlt[4] rwlt[5] rwlt[6]
 rwlt[7] rwlt[8] rwlt[9] rwlt[10] rwlt[11] rwlt[12] rwlt[13]
 rwlt[14] rwlt[15] rwlt[16] rwlt[17] rwlt[18] rwlt[19] rwlt[20]
 rwlt[21] rwlt[22] rwlt[23] rwlt[24] rwlt[25] rwlt[26] rwlt[27]
 rwlt[28] rwlt[29] rwlt[30] rwlt[31] rwlt[32] rwlt[33] rwlt[34]
 rwlt[35] rwlt[36] rwlt[37] rwlt[38] rwlt[39] rwlt[40] rwlt[41]
 rwlt[42] rwlt[43] rwlt[44] rwlt[45] rwlt[46] rwlt[47] rwlt[48]
 rwlt[49] rwlt[50] rwlt[51] rwlt[52] rwlt[53] rwlt[54] rwlt[55]
 rwlt[56] rwlt[57] rwlt[58] rwlt[59] rwlt[60] rwlt[61] rwlt[62]
 rwlt[63] rwlt[64] rwlt[65] rwlt[66] rwlt[67] rwlt[68] rwlt[69]
 rwlt[70] rwlt[71] rwlt[72] rwlt[73] rwlt[74] rwlt[75] rwlt[76]
 rwlt[77] rwlt[78] rwlt[79] rwlt[80] rwlt[81] rwlt[82] rwlt[83]
 rwlt[84] rwlt[85] rwlt[86] rwlt[87] rwlt[88] rwlt[89] rwlt[90]
 rwlt[91] rwlt[92] rwlt[93] rwlt[94] rwlt[95] rwlt[96] rwlt[97]
 rwlt[98] rwlt[99] rwlt[100] rwlt[101] rwlt[102] rwlt[103] rwlt[104]
 rwlt[105] rwlt[106] rwlt[107] rwlt[108] rwlt[109] rwlt[110] rwlt[111]
 rwlt[112] rwlt[113] rwlt[114] rwlt[115] rwlt[116] rwlt[117] rwlt[118]
 rwlt[119] rwlt[120] rwlt[121] rwlt[122] rwlt[123] rwlt[124] rwlt[125]
 rwlt[126] rwlt[127] rwlt[128] rwlt[129] rwlt[130] rwlt[131] rwlt[132]
 rwlt[133] rwlt[134] rwlt[135] rwlt[136] rwlt[137] rwlt[138] rwlt[139]
 rwlt[140] rwlt[141] rwlt[142] rwlt[143] rwlt[144] rwlt[145] rwlt[146]
 rwlt[147] rwlt[148] rwlt[149] rwlt[150] rwlt[151] rwlt[152] rwlt[153]
 rwlt[154] rwlt[155] rwlt[156] rwlt[157] rwlt[158] rwlt[159] rwlt[160]
 rwlt[161] rwlt[162] rwlt[163] rwlt[164] rwlt[165] rwlt[166] rwlt[167]
 rwlt[168] rwlt[169] rwlt[170] rwlt[171] rwlt[172] rwlt[173] rwlt[174]
 rwlt[175] rwlt[176] rwlt[177] rwlt[178] rwlt[179] rwlt[180] rwlt[181]
 rwlt[182] rwlt[183] rwlt[184] rwlt[185] rwlt[186] rwlt[187] rwlt[188]
 rwlt[189] rwlt[190] rwlt[191] rwlt[192] rwlt[193] rwlt[194] rwlt[195]
 rwlt[196] rwlt[197] rwlt[198] rwlt[199] rwlt[200] rwlt[201] rwlt[202]
 rwlt[203] rwlt[204] rwlt[205] rwlt[206] rwlt[207] rwlt[208] rwlt[209]
 rwlt[210] rwlt[211] rwlt[212] rwlt[213] rwlt[214] rwlt[215] rwlt[216]
 rwlt[217] rwlt[218] rwlt[219] rwlt[220] rwlt[221] rwlt[222] rwlt[223]
 rwlt[224] rwlt[225] rwlt[226] rwlt[227] rwlt[228] rwlt[229] rwlt[230]
 rwlt[231] rwlt[232] rwlt[233] rwlt[234] rwlt[235] rwlt[236] rwlt[237]
 rwlt[238] rwlt[239] rwlt[240] rwlt[241] rwlt[242] rwlt[243] rwlt[244]
 rwlt[245] rwlt[246] rwlt[247] rwlt[248] rwlt[249] rwlt[250] rwlt[251]
 rwlt[252] rwlt[253] rwlt[254] rwlt[255] cm[0] cm[1] cm[2]
 cm[3] cm[4] cm[5] cm[6] cm[7] cm[8] cm[9]
 cm[10] cm[11] cm[12] cm[13] cm[14] cm[15] cm[16]
 cm[17] cm[18] cm[19] cm[20] cm[21] cm[22] cm[23]
 cm[24] cm[25] cm[26] cm[27] cm[28] cm[29] cm[30]
 cm[31] lblpchglft[0] lblpchglft[1] lblpchglft[2] lblpchglft[3] lblpchgrgt[0] lblpchgrgt[1]
 lblpchgrgt[2] lblpchgrgt[3]}
{inst bitspcr_r2c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitspacer {TYPE CELL} 
{pin gbl=gbl vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst bitspcr_r1c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitspacer {TYPE CELL} 
{pin gbl=gbl vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst bitspcr_r0c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitspacer {TYPE CELL} 
{pin gbl=gbl vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0}}
{inst bitbundle_r3c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitslicearray32v2bit0 {TYPE CELL} 
{pin cm[24]=cm[0] cm[25]=cm[1] cm[26]=cm[2] cm[27]=cm[3] cm[28]=cm[4] cm[29]=cm[5]
 cm[30]=cm[6] cm[31]=cm[7] gbl=gbl lblpchglft[3]=lblpchclkleftb lblpchgrgt[3]=lblpchclkrightb rwlt[192]=rwlt[0] rwlt[193]=rwlt[1]
 rwlt[194]=rwlt[2] rwlt[195]=rwlt[3] rwlt[196]=rwlt[4] rwlt[197]=rwlt[5] rwlt[198]=rwlt[6] rwlt[199]=rwlt[7] rwlt[200]=rwlt[8]
 rwlt[201]=rwlt[9] rwlt[202]=rwlt[10] rwlt[203]=rwlt[11] rwlt[204]=rwlt[12] rwlt[205]=rwlt[13] rwlt[206]=rwlt[14] rwlt[207]=rwlt[15]
 rwlt[208]=rwlt[16] rwlt[209]=rwlt[17] rwlt[210]=rwlt[18] rwlt[211]=rwlt[19] rwlt[212]=rwlt[20] rwlt[213]=rwlt[21] rwlt[214]=rwlt[22]
 rwlt[215]=rwlt[23] rwlt[216]=rwlt[24] rwlt[217]=rwlt[25] rwlt[218]=rwlt[26] rwlt[219]=rwlt[27] rwlt[220]=rwlt[28] rwlt[221]=rwlt[29]
 rwlt[222]=rwlt[30] rwlt[223]=rwlt[31] rwlt[224]=rwlt[32] rwlt[225]=rwlt[33] rwlt[226]=rwlt[34] rwlt[227]=rwlt[35] rwlt[228]=rwlt[36]
 rwlt[229]=rwlt[37] rwlt[230]=rwlt[38] rwlt[231]=rwlt[39] rwlt[232]=rwlt[40] rwlt[233]=rwlt[41] rwlt[234]=rwlt[42] rwlt[235]=rwlt[43]
 rwlt[236]=rwlt[44] rwlt[237]=rwlt[45] rwlt[238]=rwlt[46] rwlt[239]=rwlt[47] rwlt[240]=rwlt[48] rwlt[241]=rwlt[49] rwlt[242]=rwlt[50]
 rwlt[243]=rwlt[51] rwlt[244]=rwlt[52] rwlt[245]=rwlt[53] rwlt[246]=rwlt[54] rwlt[247]=rwlt[55] rwlt[248]=rwlt[56] rwlt[249]=rwlt[57]
 rwlt[250]=rwlt[58] rwlt[251]=rwlt[59] rwlt[252]=rwlt[60] rwlt[253]=rwlt[61] rwlt[254]=rwlt[62] rwlt[255]=rwlt[63] vccd_1p0=vccd_1p0
 vccdgt_1p0=vccdgt_1p0}}
{inst bitbundle_r2c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitslicearray32v2bit0 {TYPE CELL} 
{pin cm[16]=cm[0] cm[17]=cm[1] cm[18]=cm[2] cm[19]=cm[3] cm[20]=cm[4] cm[21]=cm[5]
 cm[22]=cm[6] cm[23]=cm[7] gbl=gbl lblpchglft[2]=lblpchclkleftb lblpchgrgt[2]=lblpchclkrightb rwlt[128]=rwlt[0] rwlt[129]=rwlt[1]
 rwlt[130]=rwlt[2] rwlt[131]=rwlt[3] rwlt[132]=rwlt[4] rwlt[133]=rwlt[5] rwlt[134]=rwlt[6] rwlt[135]=rwlt[7] rwlt[136]=rwlt[8]
 rwlt[137]=rwlt[9] rwlt[138]=rwlt[10] rwlt[139]=rwlt[11] rwlt[140]=rwlt[12] rwlt[141]=rwlt[13] rwlt[142]=rwlt[14] rwlt[143]=rwlt[15]
 rwlt[144]=rwlt[16] rwlt[145]=rwlt[17] rwlt[146]=rwlt[18] rwlt[147]=rwlt[19] rwlt[148]=rwlt[20] rwlt[149]=rwlt[21] rwlt[150]=rwlt[22]
 rwlt[151]=rwlt[23] rwlt[152]=rwlt[24] rwlt[153]=rwlt[25] rwlt[154]=rwlt[26] rwlt[155]=rwlt[27] rwlt[156]=rwlt[28] rwlt[157]=rwlt[29]
 rwlt[158]=rwlt[30] rwlt[159]=rwlt[31] rwlt[160]=rwlt[32] rwlt[161]=rwlt[33] rwlt[162]=rwlt[34] rwlt[163]=rwlt[35] rwlt[164]=rwlt[36]
 rwlt[165]=rwlt[37] rwlt[166]=rwlt[38] rwlt[167]=rwlt[39] rwlt[168]=rwlt[40] rwlt[169]=rwlt[41] rwlt[170]=rwlt[42] rwlt[171]=rwlt[43]
 rwlt[172]=rwlt[44] rwlt[173]=rwlt[45] rwlt[174]=rwlt[46] rwlt[175]=rwlt[47] rwlt[176]=rwlt[48] rwlt[177]=rwlt[49] rwlt[178]=rwlt[50]
 rwlt[179]=rwlt[51] rwlt[180]=rwlt[52] rwlt[181]=rwlt[53] rwlt[182]=rwlt[54] rwlt[183]=rwlt[55] rwlt[184]=rwlt[56] rwlt[185]=rwlt[57]
 rwlt[186]=rwlt[58] rwlt[187]=rwlt[59] rwlt[188]=rwlt[60] rwlt[189]=rwlt[61] rwlt[190]=rwlt[62] rwlt[191]=rwlt[63] vccd_1p0=vccd_1p0
 vccdgt_1p0=vccdgt_1p0}}
{inst bitbundle_r1c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitslicearray32v2bit0 {TYPE CELL} 
{pin cm[8]=cm[0] cm[9]=cm[1] cm[10]=cm[2] cm[11]=cm[3] cm[12]=cm[4] cm[13]=cm[5]
 cm[14]=cm[6] cm[15]=cm[7] gbl=gbl lblpchglft[1]=lblpchclkleftb lblpchgrgt[1]=lblpchclkrightb rwlt[64]=rwlt[0] rwlt[65]=rwlt[1]
 rwlt[66]=rwlt[2] rwlt[67]=rwlt[3] rwlt[68]=rwlt[4] rwlt[69]=rwlt[5] rwlt[70]=rwlt[6] rwlt[71]=rwlt[7] rwlt[72]=rwlt[8]
 rwlt[73]=rwlt[9] rwlt[74]=rwlt[10] rwlt[75]=rwlt[11] rwlt[76]=rwlt[12] rwlt[77]=rwlt[13] rwlt[78]=rwlt[14] rwlt[79]=rwlt[15]
 rwlt[80]=rwlt[16] rwlt[81]=rwlt[17] rwlt[82]=rwlt[18] rwlt[83]=rwlt[19] rwlt[84]=rwlt[20] rwlt[85]=rwlt[21] rwlt[86]=rwlt[22]
 rwlt[87]=rwlt[23] rwlt[88]=rwlt[24] rwlt[89]=rwlt[25] rwlt[90]=rwlt[26] rwlt[91]=rwlt[27] rwlt[92]=rwlt[28] rwlt[93]=rwlt[29]
 rwlt[94]=rwlt[30] rwlt[95]=rwlt[31] rwlt[96]=rwlt[32] rwlt[97]=rwlt[33] rwlt[98]=rwlt[34] rwlt[99]=rwlt[35] rwlt[100]=rwlt[36]
 rwlt[101]=rwlt[37] rwlt[102]=rwlt[38] rwlt[103]=rwlt[39] rwlt[104]=rwlt[40] rwlt[105]=rwlt[41] rwlt[106]=rwlt[42] rwlt[107]=rwlt[43]
 rwlt[108]=rwlt[44] rwlt[109]=rwlt[45] rwlt[110]=rwlt[46] rwlt[111]=rwlt[47] rwlt[112]=rwlt[48] rwlt[113]=rwlt[49] rwlt[114]=rwlt[50]
 rwlt[115]=rwlt[51] rwlt[116]=rwlt[52] rwlt[117]=rwlt[53] rwlt[118]=rwlt[54] rwlt[119]=rwlt[55] rwlt[120]=rwlt[56] rwlt[121]=rwlt[57]
 rwlt[122]=rwlt[58] rwlt[123]=rwlt[59] rwlt[124]=rwlt[60] rwlt[125]=rwlt[61] rwlt[126]=rwlt[62] rwlt[127]=rwlt[63] vccd_1p0=vccd_1p0
 vccdgt_1p0=vccdgt_1p0}}
{inst bitbundle_r0c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_bitslicearray32v2bit0 {TYPE CELL} 
{pin cm[0]=cm[0] cm[1]=cm[1] cm[2]=cm[2] cm[3]=cm[3] cm[4]=cm[4] cm[5]=cm[5]
 cm[6]=cm[6] cm[7]=cm[7] gbl=gbl lblpchglft[0]=lblpchclkleftb lblpchgrgt[0]=lblpchclkrightb rwlt[0]=rwlt[0] rwlt[1]=rwlt[1]
 rwlt[2]=rwlt[2] rwlt[3]=rwlt[3] rwlt[4]=rwlt[4] rwlt[5]=rwlt[5] rwlt[6]=rwlt[6] rwlt[7]=rwlt[7] rwlt[8]=rwlt[8]
 rwlt[9]=rwlt[9] rwlt[10]=rwlt[10] rwlt[11]=rwlt[11] rwlt[12]=rwlt[12] rwlt[13]=rwlt[13] rwlt[14]=rwlt[14] rwlt[15]=rwlt[15]
 rwlt[16]=rwlt[16] rwlt[17]=rwlt[17] rwlt[18]=rwlt[18] rwlt[19]=rwlt[19] rwlt[20]=rwlt[20] rwlt[21]=rwlt[21] rwlt[22]=rwlt[22]
 rwlt[23]=rwlt[23] rwlt[24]=rwlt[24] rwlt[25]=rwlt[25] rwlt[26]=rwlt[26] rwlt[27]=rwlt[27] rwlt[28]=rwlt[28] rwlt[29]=rwlt[29]
 rwlt[30]=rwlt[30] rwlt[31]=rwlt[31] rwlt[32]=rwlt[32] rwlt[33]=rwlt[33] rwlt[34]=rwlt[34] rwlt[35]=rwlt[35] rwlt[36]=rwlt[36]
 rwlt[37]=rwlt[37] rwlt[38]=rwlt[38] rwlt[39]=rwlt[39] rwlt[40]=rwlt[40] rwlt[41]=rwlt[41] rwlt[42]=rwlt[42] rwlt[43]=rwlt[43]
 rwlt[44]=rwlt[44] rwlt[45]=rwlt[45] rwlt[46]=rwlt[46] rwlt[47]=rwlt[47] rwlt[48]=rwlt[48] rwlt[49]=rwlt[49] rwlt[50]=rwlt[50]
 rwlt[51]=rwlt[51] rwlt[52]=rwlt[52] rwlt[53]=rwlt[53] rwlt[54]=rwlt[54] rwlt[55]=rwlt[55] rwlt[56]=rwlt[56] rwlt[57]=rwlt[57]
 rwlt[58]=rwlt[58] rwlt[59]=rwlt[59] rwlt[60]=rwlt[60] rwlt[61]=rwlt[61] rwlt[62]=rwlt[62] rwlt[63]=rwlt[63] vccd_1p0=vccd_1p0
 vccdgt_1p0=vccdgt_1p0}}
{inst datio_r0c0=c73p1rfshdxrom2048x16hb4img100_c73p4hdxrom_datio {TYPE CELL} 
{pin odout=dout gbl=gbl pwren_in=pwren_in pwren_out=pwren_out sdlclkin=sdlclkin vccd_1p0=vccd_1p0
 vccdgt_1p0=vccdgt_1p0}}
}

{cell c73p1rfshdxrom2048x16hb4img100
{port odout[0] odout[1] odout[2] odout[3] odout[4] odout[5]
 odout[6] odout[7] odout[8] odout[9] odout[10] odout[11] odout[12]
 odout[13] odout[14] odout[15] opwrenoutb vccd_1p0 iar[0] iar[1]
 iar[2] iar[3] iar[4] iar[5] iar[6] iar[7] iar[8]
 iar[9] iar[10] ickr iren ipwreninb}
{inst ctrlslice=c73p1rfshdxrom2048x16hb4img100_ctrlslice {TYPE CELL} 
{pin vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 pwren_ioctrl=pwrenwl_in_0 iar[0]=iar[0] iar[1]=iar[1] iar[2]=iar[2]
 iar[3]=iar[3] iar[4]=iar[4] iar[5]=iar[5] iar[6]=iar[6] iar[7]=iar[7] iar[8]=iar[8] iar[9]=iar[9]
 iar[10]=iar[10] ickr=ickr iren=iren pwren_ctrlio=pwrenwl_out_0 rwltop[0]=rwltop[0] rwltop[1]=rwltop[1] rwltop[2]=rwltop[2]
 rwltop[3]=rwltop[3] rwltop[4]=rwltop[4] rwltop[5]=rwltop[5] rwltop[6]=rwltop[6] rwltop[7]=rwltop[7] rwltop[8]=rwltop[8] rwltop[9]=rwltop[9]
 rwltop[10]=rwltop[10] rwltop[11]=rwltop[11] rwltop[12]=rwltop[12] rwltop[13]=rwltop[13] rwltop[14]=rwltop[14] rwltop[15]=rwltop[15] rwltop[16]=rwltop[16]
 rwltop[17]=rwltop[17] rwltop[18]=rwltop[18] rwltop[19]=rwltop[19] rwltop[20]=rwltop[20] rwltop[21]=rwltop[21] rwltop[22]=rwltop[22] rwltop[23]=rwltop[23]
 rwltop[24]=rwltop[24] rwltop[25]=rwltop[25] rwltop[26]=rwltop[26] rwltop[27]=rwltop[27] rwltop[28]=rwltop[28] rwltop[29]=rwltop[29] rwltop[30]=rwltop[30]
 rwltop[31]=rwltop[31] rwltop[32]=rwltop[32] rwltop[33]=rwltop[33] rwltop[34]=rwltop[34] rwltop[35]=rwltop[35] rwltop[36]=rwltop[36] rwltop[37]=rwltop[37]
 rwltop[38]=rwltop[38] rwltop[39]=rwltop[39] rwltop[40]=rwltop[40] rwltop[41]=rwltop[41] rwltop[42]=rwltop[42] rwltop[43]=rwltop[43] rwltop[44]=rwltop[44]
 rwltop[45]=rwltop[45] rwltop[46]=rwltop[46] rwltop[47]=rwltop[47] rwltop[48]=rwltop[48] rwltop[49]=rwltop[49] rwltop[50]=rwltop[50] rwltop[51]=rwltop[51]
 rwltop[52]=rwltop[52] rwltop[53]=rwltop[53] rwltop[54]=rwltop[54] rwltop[55]=rwltop[55] rwltop[56]=rwltop[56] rwltop[57]=rwltop[57] rwltop[58]=rwltop[58]
 rwltop[59]=rwltop[59] rwltop[60]=rwltop[60] rwltop[61]=rwltop[61] rwltop[62]=rwltop[62] rwltop[63]=rwltop[63] rwltop[64]=rwltop[64] rwltop[65]=rwltop[65]
 rwltop[66]=rwltop[66] rwltop[67]=rwltop[67] rwltop[68]=rwltop[68] rwltop[69]=rwltop[69] rwltop[70]=rwltop[70] rwltop[71]=rwltop[71] rwltop[72]=rwltop[72]
 rwltop[73]=rwltop[73] rwltop[74]=rwltop[74] rwltop[75]=rwltop[75] rwltop[76]=rwltop[76] rwltop[77]=rwltop[77] rwltop[78]=rwltop[78] rwltop[79]=rwltop[79]
 rwltop[80]=rwltop[80] rwltop[81]=rwltop[81] rwltop[82]=rwltop[82] rwltop[83]=rwltop[83] rwltop[84]=rwltop[84] rwltop[85]=rwltop[85] rwltop[86]=rwltop[86]
 rwltop[87]=rwltop[87] rwltop[88]=rwltop[88] rwltop[89]=rwltop[89] rwltop[90]=rwltop[90] rwltop[91]=rwltop[91] rwltop[92]=rwltop[92] rwltop[93]=rwltop[93]
 rwltop[94]=rwltop[94] rwltop[95]=rwltop[95] rwltop[96]=rwltop[96] rwltop[97]=rwltop[97] rwltop[98]=rwltop[98] rwltop[99]=rwltop[99] rwltop[100]=rwltop[100]
 rwltop[101]=rwltop[101] rwltop[102]=rwltop[102] rwltop[103]=rwltop[103] rwltop[104]=rwltop[104] rwltop[105]=rwltop[105] rwltop[106]=rwltop[106] rwltop[107]=rwltop[107]
 rwltop[108]=rwltop[108] rwltop[109]=rwltop[109] rwltop[110]=rwltop[110] rwltop[111]=rwltop[111] rwltop[112]=rwltop[112] rwltop[113]=rwltop[113] rwltop[114]=rwltop[114]
 rwltop[115]=rwltop[115] rwltop[116]=rwltop[116] rwltop[117]=rwltop[117] rwltop[118]=rwltop[118] rwltop[119]=rwltop[119] rwltop[120]=rwltop[120] rwltop[121]=rwltop[121]
 rwltop[122]=rwltop[122] rwltop[123]=rwltop[123] rwltop[124]=rwltop[124] rwltop[125]=rwltop[125] rwltop[126]=rwltop[126] rwltop[127]=rwltop[127] rwltop[128]=rwltop[128]
 rwltop[129]=rwltop[129] rwltop[130]=rwltop[130] rwltop[131]=rwltop[131] rwltop[132]=rwltop[132] rwltop[133]=rwltop[133] rwltop[134]=rwltop[134] rwltop[135]=rwltop[135]
 rwltop[136]=rwltop[136] rwltop[137]=rwltop[137] rwltop[138]=rwltop[138] rwltop[139]=rwltop[139] rwltop[140]=rwltop[140] rwltop[141]=rwltop[141] rwltop[142]=rwltop[142]
 rwltop[143]=rwltop[143] rwltop[144]=rwltop[144] rwltop[145]=rwltop[145] rwltop[146]=rwltop[146] rwltop[147]=rwltop[147] rwltop[148]=rwltop[148] rwltop[149]=rwltop[149]
 rwltop[150]=rwltop[150] rwltop[151]=rwltop[151] rwltop[152]=rwltop[152] rwltop[153]=rwltop[153] rwltop[154]=rwltop[154] rwltop[155]=rwltop[155] rwltop[156]=rwltop[156]
 rwltop[157]=rwltop[157] rwltop[158]=rwltop[158] rwltop[159]=rwltop[159] rwltop[160]=rwltop[160] rwltop[161]=rwltop[161] rwltop[162]=rwltop[162] rwltop[163]=rwltop[163]
 rwltop[164]=rwltop[164] rwltop[165]=rwltop[165] rwltop[166]=rwltop[166] rwltop[167]=rwltop[167] rwltop[168]=rwltop[168] rwltop[169]=rwltop[169] rwltop[170]=rwltop[170]
 rwltop[171]=rwltop[171] rwltop[172]=rwltop[172] rwltop[173]=rwltop[173] rwltop[174]=rwltop[174] rwltop[175]=rwltop[175] rwltop[176]=rwltop[176] rwltop[177]=rwltop[177]
 rwltop[178]=rwltop[178] rwltop[179]=rwltop[179] rwltop[180]=rwltop[180] rwltop[181]=rwltop[181] rwltop[182]=rwltop[182] rwltop[183]=rwltop[183] rwltop[184]=rwltop[184]
 rwltop[185]=rwltop[185] rwltop[186]=rwltop[186] rwltop[187]=rwltop[187] rwltop[188]=rwltop[188] rwltop[189]=rwltop[189] rwltop[190]=rwltop[190] rwltop[191]=rwltop[191]
 rwltop[192]=rwltop[192] rwltop[193]=rwltop[193] rwltop[194]=rwltop[194] rwltop[195]=rwltop[195] rwltop[196]=rwltop[196] rwltop[197]=rwltop[197] rwltop[198]=rwltop[198]
 rwltop[199]=rwltop[199] rwltop[200]=rwltop[200] rwltop[201]=rwltop[201] rwltop[202]=rwltop[202] rwltop[203]=rwltop[203] rwltop[204]=rwltop[204] rwltop[205]=rwltop[205]
 rwltop[206]=rwltop[206] rwltop[207]=rwltop[207] rwltop[208]=rwltop[208] rwltop[209]=rwltop[209] rwltop[210]=rwltop[210] rwltop[211]=rwltop[211] rwltop[212]=rwltop[212]
 rwltop[213]=rwltop[213] rwltop[214]=rwltop[214] rwltop[215]=rwltop[215] rwltop[216]=rwltop[216] rwltop[217]=rwltop[217] rwltop[218]=rwltop[218] rwltop[219]=rwltop[219]
 rwltop[220]=rwltop[220] rwltop[221]=rwltop[221] rwltop[222]=rwltop[222] rwltop[223]=rwltop[223] rwltop[224]=rwltop[224] rwltop[225]=rwltop[225] rwltop[226]=rwltop[226]
 rwltop[227]=rwltop[227] rwltop[228]=rwltop[228] rwltop[229]=rwltop[229] rwltop[230]=rwltop[230] rwltop[231]=rwltop[231] rwltop[232]=rwltop[232] rwltop[233]=rwltop[233]
 rwltop[234]=rwltop[234] rwltop[235]=rwltop[235] rwltop[236]=rwltop[236] rwltop[237]=rwltop[237] rwltop[238]=rwltop[238] rwltop[239]=rwltop[239] rwltop[240]=rwltop[240]
 rwltop[241]=rwltop[241] rwltop[242]=rwltop[242] rwltop[243]=rwltop[243] rwltop[244]=rwltop[244] rwltop[245]=rwltop[245] rwltop[246]=rwltop[246] rwltop[247]=rwltop[247]
 rwltop[248]=rwltop[248] rwltop[249]=rwltop[249] rwltop[250]=rwltop[250] rwltop[251]=rwltop[251] rwltop[252]=rwltop[252] rwltop[253]=rwltop[253] rwltop[254]=rwltop[254]
 rwltop[255]=rwltop[255] cmseltop[0]=cmtop[0] cmseltop[1]=cmtop[1] cmseltop[2]=cmtop[2] cmseltop[3]=cmtop[3] cmseltop[4]=cmtop[4] cmseltop[5]=cmtop[5]
 cmseltop[6]=cmtop[6] cmseltop[7]=cmtop[7] cmseltop[8]=cmtop[8] cmseltop[9]=cmtop[9] cmseltop[10]=cmtop[10] cmseltop[11]=cmtop[11] cmseltop[12]=cmtop[12]
 cmseltop[13]=cmtop[13] cmseltop[14]=cmtop[14] cmseltop[15]=cmtop[15] cmseltop[16]=cmtop[16] cmseltop[17]=cmtop[17] cmseltop[18]=cmtop[18] cmseltop[19]=cmtop[19]
 cmseltop[20]=cmtop[20] cmseltop[21]=cmtop[21] cmseltop[22]=cmtop[22] cmseltop[23]=cmtop[23] cmseltop[24]=cmtop[24] cmseltop[25]=cmtop[25] cmseltop[26]=cmtop[26]
 cmseltop[27]=cmtop[27] cmseltop[28]=cmtop[28] cmseltop[29]=cmtop[29] cmseltop[30]=cmtop[30] cmseltop[31]=cmtop[31] lblpchglfttop[0]=lblpchglfttop[0] lblpchglfttop[1]=lblpchglfttop[1]
 lblpchglfttop[2]=lblpchglfttop[2] lblpchglfttop[3]=lblpchglfttop[3] lblpchgrgttop[0]=lblpchgrgttop[0] lblpchgrgttop[1]=lblpchgrgttop[1] lblpchgrgttop[2]=lblpchgrgttop[2] lblpchgrgttop[3]=lblpchgrgttop[3] rwlbot[0]=rwlbot[0]
 rwlbot[1]=rwlbot[1] rwlbot[2]=rwlbot[2] rwlbot[3]=rwlbot[3] rwlbot[4]=rwlbot[4] rwlbot[5]=rwlbot[5] rwlbot[6]=rwlbot[6] rwlbot[7]=rwlbot[7]
 rwlbot[8]=rwlbot[8] rwlbot[9]=rwlbot[9] rwlbot[10]=rwlbot[10] rwlbot[11]=rwlbot[11] rwlbot[12]=rwlbot[12] rwlbot[13]=rwlbot[13] rwlbot[14]=rwlbot[14]
 rwlbot[15]=rwlbot[15] rwlbot[16]=rwlbot[16] rwlbot[17]=rwlbot[17] rwlbot[18]=rwlbot[18] rwlbot[19]=rwlbot[19] rwlbot[20]=rwlbot[20] rwlbot[21]=rwlbot[21]
 rwlbot[22]=rwlbot[22] rwlbot[23]=rwlbot[23] rwlbot[24]=rwlbot[24] rwlbot[25]=rwlbot[25] rwlbot[26]=rwlbot[26] rwlbot[27]=rwlbot[27] rwlbot[28]=rwlbot[28]
 rwlbot[29]=rwlbot[29] rwlbot[30]=rwlbot[30] rwlbot[31]=rwlbot[31] rwlbot[32]=rwlbot[32] rwlbot[33]=rwlbot[33] rwlbot[34]=rwlbot[34] rwlbot[35]=rwlbot[35]
 rwlbot[36]=rwlbot[36] rwlbot[37]=rwlbot[37] rwlbot[38]=rwlbot[38] rwlbot[39]=rwlbot[39] rwlbot[40]=rwlbot[40] rwlbot[41]=rwlbot[41] rwlbot[42]=rwlbot[42]
 rwlbot[43]=rwlbot[43] rwlbot[44]=rwlbot[44] rwlbot[45]=rwlbot[45] rwlbot[46]=rwlbot[46] rwlbot[47]=rwlbot[47] rwlbot[48]=rwlbot[48] rwlbot[49]=rwlbot[49]
 rwlbot[50]=rwlbot[50] rwlbot[51]=rwlbot[51] rwlbot[52]=rwlbot[52] rwlbot[53]=rwlbot[53] rwlbot[54]=rwlbot[54] rwlbot[55]=rwlbot[55] rwlbot[56]=rwlbot[56]
 rwlbot[57]=rwlbot[57] rwlbot[58]=rwlbot[58] rwlbot[59]=rwlbot[59] rwlbot[60]=rwlbot[60] rwlbot[61]=rwlbot[61] rwlbot[62]=rwlbot[62] rwlbot[63]=rwlbot[63]
 rwlbot[64]=rwlbot[64] rwlbot[65]=rwlbot[65] rwlbot[66]=rwlbot[66] rwlbot[67]=rwlbot[67] rwlbot[68]=rwlbot[68] rwlbot[69]=rwlbot[69] rwlbot[70]=rwlbot[70]
 rwlbot[71]=rwlbot[71] rwlbot[72]=rwlbot[72] rwlbot[73]=rwlbot[73] rwlbot[74]=rwlbot[74] rwlbot[75]=rwlbot[75] rwlbot[76]=rwlbot[76] rwlbot[77]=rwlbot[77]
 rwlbot[78]=rwlbot[78] rwlbot[79]=rwlbot[79] rwlbot[80]=rwlbot[80] rwlbot[81]=rwlbot[81] rwlbot[82]=rwlbot[82] rwlbot[83]=rwlbot[83] rwlbot[84]=rwlbot[84]
 rwlbot[85]=rwlbot[85] rwlbot[86]=rwlbot[86] rwlbot[87]=rwlbot[87] rwlbot[88]=rwlbot[88] rwlbot[89]=rwlbot[89] rwlbot[90]=rwlbot[90] rwlbot[91]=rwlbot[91]
 rwlbot[92]=rwlbot[92] rwlbot[93]=rwlbot[93] rwlbot[94]=rwlbot[94] rwlbot[95]=rwlbot[95] rwlbot[96]=rwlbot[96] rwlbot[97]=rwlbot[97] rwlbot[98]=rwlbot[98]
 rwlbot[99]=rwlbot[99] rwlbot[100]=rwlbot[100] rwlbot[101]=rwlbot[101] rwlbot[102]=rwlbot[102] rwlbot[103]=rwlbot[103] rwlbot[104]=rwlbot[104] rwlbot[105]=rwlbot[105]
 rwlbot[106]=rwlbot[106] rwlbot[107]=rwlbot[107] rwlbot[108]=rwlbot[108] rwlbot[109]=rwlbot[109] rwlbot[110]=rwlbot[110] rwlbot[111]=rwlbot[111] rwlbot[112]=rwlbot[112]
 rwlbot[113]=rwlbot[113] rwlbot[114]=rwlbot[114] rwlbot[115]=rwlbot[115] rwlbot[116]=rwlbot[116] rwlbot[117]=rwlbot[117] rwlbot[118]=rwlbot[118] rwlbot[119]=rwlbot[119]
 rwlbot[120]=rwlbot[120] rwlbot[121]=rwlbot[121] rwlbot[122]=rwlbot[122] rwlbot[123]=rwlbot[123] rwlbot[124]=rwlbot[124] rwlbot[125]=rwlbot[125] rwlbot[126]=rwlbot[126]
 rwlbot[127]=rwlbot[127] rwlbot[128]=rwlbot[128] rwlbot[129]=rwlbot[129] rwlbot[130]=rwlbot[130] rwlbot[131]=rwlbot[131] rwlbot[132]=rwlbot[132] rwlbot[133]=rwlbot[133]
 rwlbot[134]=rwlbot[134] rwlbot[135]=rwlbot[135] rwlbot[136]=rwlbot[136] rwlbot[137]=rwlbot[137] rwlbot[138]=rwlbot[138] rwlbot[139]=rwlbot[139] rwlbot[140]=rwlbot[140]
 rwlbot[141]=rwlbot[141] rwlbot[142]=rwlbot[142] rwlbot[143]=rwlbot[143] rwlbot[144]=rwlbot[144] rwlbot[145]=rwlbot[145] rwlbot[146]=rwlbot[146] rwlbot[147]=rwlbot[147]
 rwlbot[148]=rwlbot[148] rwlbot[149]=rwlbot[149] rwlbot[150]=rwlbot[150] rwlbot[151]=rwlbot[151] rwlbot[152]=rwlbot[152] rwlbot[153]=rwlbot[153] rwlbot[154]=rwlbot[154]
 rwlbot[155]=rwlbot[155] rwlbot[156]=rwlbot[156] rwlbot[157]=rwlbot[157] rwlbot[158]=rwlbot[158] rwlbot[159]=rwlbot[159] rwlbot[160]=rwlbot[160] rwlbot[161]=rwlbot[161]
 rwlbot[162]=rwlbot[162] rwlbot[163]=rwlbot[163] rwlbot[164]=rwlbot[164] rwlbot[165]=rwlbot[165] rwlbot[166]=rwlbot[166] rwlbot[167]=rwlbot[167] rwlbot[168]=rwlbot[168]
 rwlbot[169]=rwlbot[169] rwlbot[170]=rwlbot[170] rwlbot[171]=rwlbot[171] rwlbot[172]=rwlbot[172] rwlbot[173]=rwlbot[173] rwlbot[174]=rwlbot[174] rwlbot[175]=rwlbot[175]
 rwlbot[176]=rwlbot[176] rwlbot[177]=rwlbot[177] rwlbot[178]=rwlbot[178] rwlbot[179]=rwlbot[179] rwlbot[180]=rwlbot[180] rwlbot[181]=rwlbot[181] rwlbot[182]=rwlbot[182]
 rwlbot[183]=rwlbot[183] rwlbot[184]=rwlbot[184] rwlbot[185]=rwlbot[185] rwlbot[186]=rwlbot[186] rwlbot[187]=rwlbot[187] rwlbot[188]=rwlbot[188] rwlbot[189]=rwlbot[189]
 rwlbot[190]=rwlbot[190] rwlbot[191]=rwlbot[191] rwlbot[192]=rwlbot[192] rwlbot[193]=rwlbot[193] rwlbot[194]=rwlbot[194] rwlbot[195]=rwlbot[195] rwlbot[196]=rwlbot[196]
 rwlbot[197]=rwlbot[197] rwlbot[198]=rwlbot[198] rwlbot[199]=rwlbot[199] rwlbot[200]=rwlbot[200] rwlbot[201]=rwlbot[201] rwlbot[202]=rwlbot[202] rwlbot[203]=rwlbot[203]
 rwlbot[204]=rwlbot[204] rwlbot[205]=rwlbot[205] rwlbot[206]=rwlbot[206] rwlbot[207]=rwlbot[207] rwlbot[208]=rwlbot[208] rwlbot[209]=rwlbot[209] rwlbot[210]=rwlbot[210]
 rwlbot[211]=rwlbot[211] rwlbot[212]=rwlbot[212] rwlbot[213]=rwlbot[213] rwlbot[214]=rwlbot[214] rwlbot[215]=rwlbot[215] rwlbot[216]=rwlbot[216] rwlbot[217]=rwlbot[217]
 rwlbot[218]=rwlbot[218] rwlbot[219]=rwlbot[219] rwlbot[220]=rwlbot[220] rwlbot[221]=rwlbot[221] rwlbot[222]=rwlbot[222] rwlbot[223]=rwlbot[223] rwlbot[224]=rwlbot[224]
 rwlbot[225]=rwlbot[225] rwlbot[226]=rwlbot[226] rwlbot[227]=rwlbot[227] rwlbot[228]=rwlbot[228] rwlbot[229]=rwlbot[229] rwlbot[230]=rwlbot[230] rwlbot[231]=rwlbot[231]
 rwlbot[232]=rwlbot[232] rwlbot[233]=rwlbot[233] rwlbot[234]=rwlbot[234] rwlbot[235]=rwlbot[235] rwlbot[236]=rwlbot[236] rwlbot[237]=rwlbot[237] rwlbot[238]=rwlbot[238]
 rwlbot[239]=rwlbot[239] rwlbot[240]=rwlbot[240] rwlbot[241]=rwlbot[241] rwlbot[242]=rwlbot[242] rwlbot[243]=rwlbot[243] rwlbot[244]=rwlbot[244] rwlbot[245]=rwlbot[245]
 rwlbot[246]=rwlbot[246] rwlbot[247]=rwlbot[247] rwlbot[248]=rwlbot[248] rwlbot[249]=rwlbot[249] rwlbot[250]=rwlbot[250] rwlbot[251]=rwlbot[251] rwlbot[252]=rwlbot[252]
 rwlbot[253]=rwlbot[253] rwlbot[254]=rwlbot[254] rwlbot[255]=rwlbot[255] cmselbot[0]=cmbot[0] cmselbot[1]=cmbot[1] cmselbot[2]=cmbot[2] cmselbot[3]=cmbot[3]
 cmselbot[4]=cmbot[4] cmselbot[5]=cmbot[5] cmselbot[6]=cmbot[6] cmselbot[7]=cmbot[7] cmselbot[8]=cmbot[8] cmselbot[9]=cmbot[9] cmselbot[10]=cmbot[10]
 cmselbot[11]=cmbot[11] cmselbot[12]=cmbot[12] cmselbot[13]=cmbot[13] cmselbot[14]=cmbot[14] cmselbot[15]=cmbot[15] cmselbot[16]=cmbot[16] cmselbot[17]=cmbot[17]
 cmselbot[18]=cmbot[18] cmselbot[19]=cmbot[19] cmselbot[20]=cmbot[20] cmselbot[21]=cmbot[21] cmselbot[22]=cmbot[22] cmselbot[23]=cmbot[23] cmselbot[24]=cmbot[24]
 cmselbot[25]=cmbot[25] cmselbot[26]=cmbot[26] cmselbot[27]=cmbot[27] cmselbot[28]=cmbot[28] cmselbot[29]=cmbot[29] cmselbot[30]=cmbot[30] cmselbot[31]=cmbot[31]
 lblpchglftbot[0]=lblpchglftbot[0] lblpchglftbot[1]=lblpchglftbot[1] lblpchglftbot[2]=lblpchglftbot[2] lblpchglftbot[3]=lblpchglftbot[3] lblpchgrgtbot[0]=lblpchgrgtbot[0] lblpchgrgtbot[1]=lblpchgrgtbot[1] lblpchgrgtbot[2]=lblpchgrgtbot[2]
 lblpchgrgtbot[3]=lblpchgrgtbot[3] sdlclktop=sdlclktop sdlclkbot=sdlclkbot}}
{inst bitbundle_hor_15=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[15]=odout pwrenio_14=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclktop=sdlclkin ipwreninb=pwren_in
 rwltop[0]=rwlt[0] rwltop[1]=rwlt[1] rwltop[2]=rwlt[2] rwltop[3]=rwlt[3] rwltop[4]=rwlt[4] rwltop[5]=rwlt[5] rwltop[6]=rwlt[6]
 rwltop[7]=rwlt[7] rwltop[8]=rwlt[8] rwltop[9]=rwlt[9] rwltop[10]=rwlt[10] rwltop[11]=rwlt[11] rwltop[12]=rwlt[12] rwltop[13]=rwlt[13]
 rwltop[14]=rwlt[14] rwltop[15]=rwlt[15] rwltop[16]=rwlt[16] rwltop[17]=rwlt[17] rwltop[18]=rwlt[18] rwltop[19]=rwlt[19] rwltop[20]=rwlt[20]
 rwltop[21]=rwlt[21] rwltop[22]=rwlt[22] rwltop[23]=rwlt[23] rwltop[24]=rwlt[24] rwltop[25]=rwlt[25] rwltop[26]=rwlt[26] rwltop[27]=rwlt[27]
 rwltop[28]=rwlt[28] rwltop[29]=rwlt[29] rwltop[30]=rwlt[30] rwltop[31]=rwlt[31] rwltop[32]=rwlt[32] rwltop[33]=rwlt[33] rwltop[34]=rwlt[34]
 rwltop[35]=rwlt[35] rwltop[36]=rwlt[36] rwltop[37]=rwlt[37] rwltop[38]=rwlt[38] rwltop[39]=rwlt[39] rwltop[40]=rwlt[40] rwltop[41]=rwlt[41]
 rwltop[42]=rwlt[42] rwltop[43]=rwlt[43] rwltop[44]=rwlt[44] rwltop[45]=rwlt[45] rwltop[46]=rwlt[46] rwltop[47]=rwlt[47] rwltop[48]=rwlt[48]
 rwltop[49]=rwlt[49] rwltop[50]=rwlt[50] rwltop[51]=rwlt[51] rwltop[52]=rwlt[52] rwltop[53]=rwlt[53] rwltop[54]=rwlt[54] rwltop[55]=rwlt[55]
 rwltop[56]=rwlt[56] rwltop[57]=rwlt[57] rwltop[58]=rwlt[58] rwltop[59]=rwlt[59] rwltop[60]=rwlt[60] rwltop[61]=rwlt[61] rwltop[62]=rwlt[62]
 rwltop[63]=rwlt[63] rwltop[64]=rwlt[64] rwltop[65]=rwlt[65] rwltop[66]=rwlt[66] rwltop[67]=rwlt[67] rwltop[68]=rwlt[68] rwltop[69]=rwlt[69]
 rwltop[70]=rwlt[70] rwltop[71]=rwlt[71] rwltop[72]=rwlt[72] rwltop[73]=rwlt[73] rwltop[74]=rwlt[74] rwltop[75]=rwlt[75] rwltop[76]=rwlt[76]
 rwltop[77]=rwlt[77] rwltop[78]=rwlt[78] rwltop[79]=rwlt[79] rwltop[80]=rwlt[80] rwltop[81]=rwlt[81] rwltop[82]=rwlt[82] rwltop[83]=rwlt[83]
 rwltop[84]=rwlt[84] rwltop[85]=rwlt[85] rwltop[86]=rwlt[86] rwltop[87]=rwlt[87] rwltop[88]=rwlt[88] rwltop[89]=rwlt[89] rwltop[90]=rwlt[90]
 rwltop[91]=rwlt[91] rwltop[92]=rwlt[92] rwltop[93]=rwlt[93] rwltop[94]=rwlt[94] rwltop[95]=rwlt[95] rwltop[96]=rwlt[96] rwltop[97]=rwlt[97]
 rwltop[98]=rwlt[98] rwltop[99]=rwlt[99] rwltop[100]=rwlt[100] rwltop[101]=rwlt[101] rwltop[102]=rwlt[102] rwltop[103]=rwlt[103] rwltop[104]=rwlt[104]
 rwltop[105]=rwlt[105] rwltop[106]=rwlt[106] rwltop[107]=rwlt[107] rwltop[108]=rwlt[108] rwltop[109]=rwlt[109] rwltop[110]=rwlt[110] rwltop[111]=rwlt[111]
 rwltop[112]=rwlt[112] rwltop[113]=rwlt[113] rwltop[114]=rwlt[114] rwltop[115]=rwlt[115] rwltop[116]=rwlt[116] rwltop[117]=rwlt[117] rwltop[118]=rwlt[118]
 rwltop[119]=rwlt[119] rwltop[120]=rwlt[120] rwltop[121]=rwlt[121] rwltop[122]=rwlt[122] rwltop[123]=rwlt[123] rwltop[124]=rwlt[124] rwltop[125]=rwlt[125]
 rwltop[126]=rwlt[126] rwltop[127]=rwlt[127] rwltop[128]=rwlt[128] rwltop[129]=rwlt[129] rwltop[130]=rwlt[130] rwltop[131]=rwlt[131] rwltop[132]=rwlt[132]
 rwltop[133]=rwlt[133] rwltop[134]=rwlt[134] rwltop[135]=rwlt[135] rwltop[136]=rwlt[136] rwltop[137]=rwlt[137] rwltop[138]=rwlt[138] rwltop[139]=rwlt[139]
 rwltop[140]=rwlt[140] rwltop[141]=rwlt[141] rwltop[142]=rwlt[142] rwltop[143]=rwlt[143] rwltop[144]=rwlt[144] rwltop[145]=rwlt[145] rwltop[146]=rwlt[146]
 rwltop[147]=rwlt[147] rwltop[148]=rwlt[148] rwltop[149]=rwlt[149] rwltop[150]=rwlt[150] rwltop[151]=rwlt[151] rwltop[152]=rwlt[152] rwltop[153]=rwlt[153]
 rwltop[154]=rwlt[154] rwltop[155]=rwlt[155] rwltop[156]=rwlt[156] rwltop[157]=rwlt[157] rwltop[158]=rwlt[158] rwltop[159]=rwlt[159] rwltop[160]=rwlt[160]
 rwltop[161]=rwlt[161] rwltop[162]=rwlt[162] rwltop[163]=rwlt[163] rwltop[164]=rwlt[164] rwltop[165]=rwlt[165] rwltop[166]=rwlt[166] rwltop[167]=rwlt[167]
 rwltop[168]=rwlt[168] rwltop[169]=rwlt[169] rwltop[170]=rwlt[170] rwltop[171]=rwlt[171] rwltop[172]=rwlt[172] rwltop[173]=rwlt[173] rwltop[174]=rwlt[174]
 rwltop[175]=rwlt[175] rwltop[176]=rwlt[176] rwltop[177]=rwlt[177] rwltop[178]=rwlt[178] rwltop[179]=rwlt[179] rwltop[180]=rwlt[180] rwltop[181]=rwlt[181]
 rwltop[182]=rwlt[182] rwltop[183]=rwlt[183] rwltop[184]=rwlt[184] rwltop[185]=rwlt[185] rwltop[186]=rwlt[186] rwltop[187]=rwlt[187] rwltop[188]=rwlt[188]
 rwltop[189]=rwlt[189] rwltop[190]=rwlt[190] rwltop[191]=rwlt[191] rwltop[192]=rwlt[192] rwltop[193]=rwlt[193] rwltop[194]=rwlt[194] rwltop[195]=rwlt[195]
 rwltop[196]=rwlt[196] rwltop[197]=rwlt[197] rwltop[198]=rwlt[198] rwltop[199]=rwlt[199] rwltop[200]=rwlt[200] rwltop[201]=rwlt[201] rwltop[202]=rwlt[202]
 rwltop[203]=rwlt[203] rwltop[204]=rwlt[204] rwltop[205]=rwlt[205] rwltop[206]=rwlt[206] rwltop[207]=rwlt[207] rwltop[208]=rwlt[208] rwltop[209]=rwlt[209]
 rwltop[210]=rwlt[210] rwltop[211]=rwlt[211] rwltop[212]=rwlt[212] rwltop[213]=rwlt[213] rwltop[214]=rwlt[214] rwltop[215]=rwlt[215] rwltop[216]=rwlt[216]
 rwltop[217]=rwlt[217] rwltop[218]=rwlt[218] rwltop[219]=rwlt[219] rwltop[220]=rwlt[220] rwltop[221]=rwlt[221] rwltop[222]=rwlt[222] rwltop[223]=rwlt[223]
 rwltop[224]=rwlt[224] rwltop[225]=rwlt[225] rwltop[226]=rwlt[226] rwltop[227]=rwlt[227] rwltop[228]=rwlt[228] rwltop[229]=rwlt[229] rwltop[230]=rwlt[230]
 rwltop[231]=rwlt[231] rwltop[232]=rwlt[232] rwltop[233]=rwlt[233] rwltop[234]=rwlt[234] rwltop[235]=rwlt[235] rwltop[236]=rwlt[236] rwltop[237]=rwlt[237]
 rwltop[238]=rwlt[238] rwltop[239]=rwlt[239] rwltop[240]=rwlt[240] rwltop[241]=rwlt[241] rwltop[242]=rwlt[242] rwltop[243]=rwlt[243] rwltop[244]=rwlt[244]
 rwltop[245]=rwlt[245] rwltop[246]=rwlt[246] rwltop[247]=rwlt[247] rwltop[248]=rwlt[248] rwltop[249]=rwlt[249] rwltop[250]=rwlt[250] rwltop[251]=rwlt[251]
 rwltop[252]=rwlt[252] rwltop[253]=rwlt[253] rwltop[254]=rwlt[254] rwltop[255]=rwlt[255] cmseltop[0]=cm[0] cmseltop[1]=cm[1] cmseltop[2]=cm[2]
 cmseltop[3]=cm[3] cmseltop[4]=cm[4] cmseltop[5]=cm[5] cmseltop[6]=cm[6] cmseltop[7]=cm[7] cmseltop[8]=cm[8] cmseltop[9]=cm[9]
 cmseltop[10]=cm[10] cmseltop[11]=cm[11] cmseltop[12]=cm[12] cmseltop[13]=cm[13] cmseltop[14]=cm[14] cmseltop[15]=cm[15] cmseltop[16]=cm[16]
 cmseltop[17]=cm[17] cmseltop[18]=cm[18] cmseltop[19]=cm[19] cmseltop[20]=cm[20] cmseltop[21]=cm[21] cmseltop[22]=cm[22] cmseltop[23]=cm[23]
 cmseltop[24]=cm[24] cmseltop[25]=cm[25] cmseltop[26]=cm[26] cmseltop[27]=cm[27] cmseltop[28]=cm[28] cmseltop[29]=cm[29] cmseltop[30]=cm[30]
 cmseltop[31]=cm[31] lblpchglfttop[0]=lblpchglft[0] lblpchglfttop[1]=lblpchglft[1] lblpchglfttop[2]=lblpchglft[2] lblpchglfttop[3]=lblpchglft[3] lblpchgrgttop[0]=lblpchgrgt[0] lblpchgrgttop[1]=lblpchgrgt[1]
 lblpchgrgttop[2]=lblpchgrgt[2] lblpchgrgttop[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_14=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[14]=odout pwrenio_13=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclktop=sdlclkin pwrenio_14=pwren_in
 rwltop[0]=rwlt[0] rwltop[1]=rwlt[1] rwltop[2]=rwlt[2] rwltop[3]=rwlt[3] rwltop[4]=rwlt[4] rwltop[5]=rwlt[5] rwltop[6]=rwlt[6]
 rwltop[7]=rwlt[7] rwltop[8]=rwlt[8] rwltop[9]=rwlt[9] rwltop[10]=rwlt[10] rwltop[11]=rwlt[11] rwltop[12]=rwlt[12] rwltop[13]=rwlt[13]
 rwltop[14]=rwlt[14] rwltop[15]=rwlt[15] rwltop[16]=rwlt[16] rwltop[17]=rwlt[17] rwltop[18]=rwlt[18] rwltop[19]=rwlt[19] rwltop[20]=rwlt[20]
 rwltop[21]=rwlt[21] rwltop[22]=rwlt[22] rwltop[23]=rwlt[23] rwltop[24]=rwlt[24] rwltop[25]=rwlt[25] rwltop[26]=rwlt[26] rwltop[27]=rwlt[27]
 rwltop[28]=rwlt[28] rwltop[29]=rwlt[29] rwltop[30]=rwlt[30] rwltop[31]=rwlt[31] rwltop[32]=rwlt[32] rwltop[33]=rwlt[33] rwltop[34]=rwlt[34]
 rwltop[35]=rwlt[35] rwltop[36]=rwlt[36] rwltop[37]=rwlt[37] rwltop[38]=rwlt[38] rwltop[39]=rwlt[39] rwltop[40]=rwlt[40] rwltop[41]=rwlt[41]
 rwltop[42]=rwlt[42] rwltop[43]=rwlt[43] rwltop[44]=rwlt[44] rwltop[45]=rwlt[45] rwltop[46]=rwlt[46] rwltop[47]=rwlt[47] rwltop[48]=rwlt[48]
 rwltop[49]=rwlt[49] rwltop[50]=rwlt[50] rwltop[51]=rwlt[51] rwltop[52]=rwlt[52] rwltop[53]=rwlt[53] rwltop[54]=rwlt[54] rwltop[55]=rwlt[55]
 rwltop[56]=rwlt[56] rwltop[57]=rwlt[57] rwltop[58]=rwlt[58] rwltop[59]=rwlt[59] rwltop[60]=rwlt[60] rwltop[61]=rwlt[61] rwltop[62]=rwlt[62]
 rwltop[63]=rwlt[63] rwltop[64]=rwlt[64] rwltop[65]=rwlt[65] rwltop[66]=rwlt[66] rwltop[67]=rwlt[67] rwltop[68]=rwlt[68] rwltop[69]=rwlt[69]
 rwltop[70]=rwlt[70] rwltop[71]=rwlt[71] rwltop[72]=rwlt[72] rwltop[73]=rwlt[73] rwltop[74]=rwlt[74] rwltop[75]=rwlt[75] rwltop[76]=rwlt[76]
 rwltop[77]=rwlt[77] rwltop[78]=rwlt[78] rwltop[79]=rwlt[79] rwltop[80]=rwlt[80] rwltop[81]=rwlt[81] rwltop[82]=rwlt[82] rwltop[83]=rwlt[83]
 rwltop[84]=rwlt[84] rwltop[85]=rwlt[85] rwltop[86]=rwlt[86] rwltop[87]=rwlt[87] rwltop[88]=rwlt[88] rwltop[89]=rwlt[89] rwltop[90]=rwlt[90]
 rwltop[91]=rwlt[91] rwltop[92]=rwlt[92] rwltop[93]=rwlt[93] rwltop[94]=rwlt[94] rwltop[95]=rwlt[95] rwltop[96]=rwlt[96] rwltop[97]=rwlt[97]
 rwltop[98]=rwlt[98] rwltop[99]=rwlt[99] rwltop[100]=rwlt[100] rwltop[101]=rwlt[101] rwltop[102]=rwlt[102] rwltop[103]=rwlt[103] rwltop[104]=rwlt[104]
 rwltop[105]=rwlt[105] rwltop[106]=rwlt[106] rwltop[107]=rwlt[107] rwltop[108]=rwlt[108] rwltop[109]=rwlt[109] rwltop[110]=rwlt[110] rwltop[111]=rwlt[111]
 rwltop[112]=rwlt[112] rwltop[113]=rwlt[113] rwltop[114]=rwlt[114] rwltop[115]=rwlt[115] rwltop[116]=rwlt[116] rwltop[117]=rwlt[117] rwltop[118]=rwlt[118]
 rwltop[119]=rwlt[119] rwltop[120]=rwlt[120] rwltop[121]=rwlt[121] rwltop[122]=rwlt[122] rwltop[123]=rwlt[123] rwltop[124]=rwlt[124] rwltop[125]=rwlt[125]
 rwltop[126]=rwlt[126] rwltop[127]=rwlt[127] rwltop[128]=rwlt[128] rwltop[129]=rwlt[129] rwltop[130]=rwlt[130] rwltop[131]=rwlt[131] rwltop[132]=rwlt[132]
 rwltop[133]=rwlt[133] rwltop[134]=rwlt[134] rwltop[135]=rwlt[135] rwltop[136]=rwlt[136] rwltop[137]=rwlt[137] rwltop[138]=rwlt[138] rwltop[139]=rwlt[139]
 rwltop[140]=rwlt[140] rwltop[141]=rwlt[141] rwltop[142]=rwlt[142] rwltop[143]=rwlt[143] rwltop[144]=rwlt[144] rwltop[145]=rwlt[145] rwltop[146]=rwlt[146]
 rwltop[147]=rwlt[147] rwltop[148]=rwlt[148] rwltop[149]=rwlt[149] rwltop[150]=rwlt[150] rwltop[151]=rwlt[151] rwltop[152]=rwlt[152] rwltop[153]=rwlt[153]
 rwltop[154]=rwlt[154] rwltop[155]=rwlt[155] rwltop[156]=rwlt[156] rwltop[157]=rwlt[157] rwltop[158]=rwlt[158] rwltop[159]=rwlt[159] rwltop[160]=rwlt[160]
 rwltop[161]=rwlt[161] rwltop[162]=rwlt[162] rwltop[163]=rwlt[163] rwltop[164]=rwlt[164] rwltop[165]=rwlt[165] rwltop[166]=rwlt[166] rwltop[167]=rwlt[167]
 rwltop[168]=rwlt[168] rwltop[169]=rwlt[169] rwltop[170]=rwlt[170] rwltop[171]=rwlt[171] rwltop[172]=rwlt[172] rwltop[173]=rwlt[173] rwltop[174]=rwlt[174]
 rwltop[175]=rwlt[175] rwltop[176]=rwlt[176] rwltop[177]=rwlt[177] rwltop[178]=rwlt[178] rwltop[179]=rwlt[179] rwltop[180]=rwlt[180] rwltop[181]=rwlt[181]
 rwltop[182]=rwlt[182] rwltop[183]=rwlt[183] rwltop[184]=rwlt[184] rwltop[185]=rwlt[185] rwltop[186]=rwlt[186] rwltop[187]=rwlt[187] rwltop[188]=rwlt[188]
 rwltop[189]=rwlt[189] rwltop[190]=rwlt[190] rwltop[191]=rwlt[191] rwltop[192]=rwlt[192] rwltop[193]=rwlt[193] rwltop[194]=rwlt[194] rwltop[195]=rwlt[195]
 rwltop[196]=rwlt[196] rwltop[197]=rwlt[197] rwltop[198]=rwlt[198] rwltop[199]=rwlt[199] rwltop[200]=rwlt[200] rwltop[201]=rwlt[201] rwltop[202]=rwlt[202]
 rwltop[203]=rwlt[203] rwltop[204]=rwlt[204] rwltop[205]=rwlt[205] rwltop[206]=rwlt[206] rwltop[207]=rwlt[207] rwltop[208]=rwlt[208] rwltop[209]=rwlt[209]
 rwltop[210]=rwlt[210] rwltop[211]=rwlt[211] rwltop[212]=rwlt[212] rwltop[213]=rwlt[213] rwltop[214]=rwlt[214] rwltop[215]=rwlt[215] rwltop[216]=rwlt[216]
 rwltop[217]=rwlt[217] rwltop[218]=rwlt[218] rwltop[219]=rwlt[219] rwltop[220]=rwlt[220] rwltop[221]=rwlt[221] rwltop[222]=rwlt[222] rwltop[223]=rwlt[223]
 rwltop[224]=rwlt[224] rwltop[225]=rwlt[225] rwltop[226]=rwlt[226] rwltop[227]=rwlt[227] rwltop[228]=rwlt[228] rwltop[229]=rwlt[229] rwltop[230]=rwlt[230]
 rwltop[231]=rwlt[231] rwltop[232]=rwlt[232] rwltop[233]=rwlt[233] rwltop[234]=rwlt[234] rwltop[235]=rwlt[235] rwltop[236]=rwlt[236] rwltop[237]=rwlt[237]
 rwltop[238]=rwlt[238] rwltop[239]=rwlt[239] rwltop[240]=rwlt[240] rwltop[241]=rwlt[241] rwltop[242]=rwlt[242] rwltop[243]=rwlt[243] rwltop[244]=rwlt[244]
 rwltop[245]=rwlt[245] rwltop[246]=rwlt[246] rwltop[247]=rwlt[247] rwltop[248]=rwlt[248] rwltop[249]=rwlt[249] rwltop[250]=rwlt[250] rwltop[251]=rwlt[251]
 rwltop[252]=rwlt[252] rwltop[253]=rwlt[253] rwltop[254]=rwlt[254] rwltop[255]=rwlt[255] cmseltop[0]=cm[0] cmseltop[1]=cm[1] cmseltop[2]=cm[2]
 cmseltop[3]=cm[3] cmseltop[4]=cm[4] cmseltop[5]=cm[5] cmseltop[6]=cm[6] cmseltop[7]=cm[7] cmseltop[8]=cm[8] cmseltop[9]=cm[9]
 cmseltop[10]=cm[10] cmseltop[11]=cm[11] cmseltop[12]=cm[12] cmseltop[13]=cm[13] cmseltop[14]=cm[14] cmseltop[15]=cm[15] cmseltop[16]=cm[16]
 cmseltop[17]=cm[17] cmseltop[18]=cm[18] cmseltop[19]=cm[19] cmseltop[20]=cm[20] cmseltop[21]=cm[21] cmseltop[22]=cm[22] cmseltop[23]=cm[23]
 cmseltop[24]=cm[24] cmseltop[25]=cm[25] cmseltop[26]=cm[26] cmseltop[27]=cm[27] cmseltop[28]=cm[28] cmseltop[29]=cm[29] cmseltop[30]=cm[30]
 cmseltop[31]=cm[31] lblpchglfttop[0]=lblpchglft[0] lblpchglfttop[1]=lblpchglft[1] lblpchglfttop[2]=lblpchglft[2] lblpchglfttop[3]=lblpchglft[3] lblpchgrgttop[0]=lblpchgrgt[0] lblpchgrgttop[1]=lblpchgrgt[1]
 lblpchgrgttop[2]=lblpchgrgt[2] lblpchgrgttop[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_13=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[13]=odout pwrenio_12=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclktop=sdlclkin pwrenio_13=pwren_in
 rwltop[0]=rwlt[0] rwltop[1]=rwlt[1] rwltop[2]=rwlt[2] rwltop[3]=rwlt[3] rwltop[4]=rwlt[4] rwltop[5]=rwlt[5] rwltop[6]=rwlt[6]
 rwltop[7]=rwlt[7] rwltop[8]=rwlt[8] rwltop[9]=rwlt[9] rwltop[10]=rwlt[10] rwltop[11]=rwlt[11] rwltop[12]=rwlt[12] rwltop[13]=rwlt[13]
 rwltop[14]=rwlt[14] rwltop[15]=rwlt[15] rwltop[16]=rwlt[16] rwltop[17]=rwlt[17] rwltop[18]=rwlt[18] rwltop[19]=rwlt[19] rwltop[20]=rwlt[20]
 rwltop[21]=rwlt[21] rwltop[22]=rwlt[22] rwltop[23]=rwlt[23] rwltop[24]=rwlt[24] rwltop[25]=rwlt[25] rwltop[26]=rwlt[26] rwltop[27]=rwlt[27]
 rwltop[28]=rwlt[28] rwltop[29]=rwlt[29] rwltop[30]=rwlt[30] rwltop[31]=rwlt[31] rwltop[32]=rwlt[32] rwltop[33]=rwlt[33] rwltop[34]=rwlt[34]
 rwltop[35]=rwlt[35] rwltop[36]=rwlt[36] rwltop[37]=rwlt[37] rwltop[38]=rwlt[38] rwltop[39]=rwlt[39] rwltop[40]=rwlt[40] rwltop[41]=rwlt[41]
 rwltop[42]=rwlt[42] rwltop[43]=rwlt[43] rwltop[44]=rwlt[44] rwltop[45]=rwlt[45] rwltop[46]=rwlt[46] rwltop[47]=rwlt[47] rwltop[48]=rwlt[48]
 rwltop[49]=rwlt[49] rwltop[50]=rwlt[50] rwltop[51]=rwlt[51] rwltop[52]=rwlt[52] rwltop[53]=rwlt[53] rwltop[54]=rwlt[54] rwltop[55]=rwlt[55]
 rwltop[56]=rwlt[56] rwltop[57]=rwlt[57] rwltop[58]=rwlt[58] rwltop[59]=rwlt[59] rwltop[60]=rwlt[60] rwltop[61]=rwlt[61] rwltop[62]=rwlt[62]
 rwltop[63]=rwlt[63] rwltop[64]=rwlt[64] rwltop[65]=rwlt[65] rwltop[66]=rwlt[66] rwltop[67]=rwlt[67] rwltop[68]=rwlt[68] rwltop[69]=rwlt[69]
 rwltop[70]=rwlt[70] rwltop[71]=rwlt[71] rwltop[72]=rwlt[72] rwltop[73]=rwlt[73] rwltop[74]=rwlt[74] rwltop[75]=rwlt[75] rwltop[76]=rwlt[76]
 rwltop[77]=rwlt[77] rwltop[78]=rwlt[78] rwltop[79]=rwlt[79] rwltop[80]=rwlt[80] rwltop[81]=rwlt[81] rwltop[82]=rwlt[82] rwltop[83]=rwlt[83]
 rwltop[84]=rwlt[84] rwltop[85]=rwlt[85] rwltop[86]=rwlt[86] rwltop[87]=rwlt[87] rwltop[88]=rwlt[88] rwltop[89]=rwlt[89] rwltop[90]=rwlt[90]
 rwltop[91]=rwlt[91] rwltop[92]=rwlt[92] rwltop[93]=rwlt[93] rwltop[94]=rwlt[94] rwltop[95]=rwlt[95] rwltop[96]=rwlt[96] rwltop[97]=rwlt[97]
 rwltop[98]=rwlt[98] rwltop[99]=rwlt[99] rwltop[100]=rwlt[100] rwltop[101]=rwlt[101] rwltop[102]=rwlt[102] rwltop[103]=rwlt[103] rwltop[104]=rwlt[104]
 rwltop[105]=rwlt[105] rwltop[106]=rwlt[106] rwltop[107]=rwlt[107] rwltop[108]=rwlt[108] rwltop[109]=rwlt[109] rwltop[110]=rwlt[110] rwltop[111]=rwlt[111]
 rwltop[112]=rwlt[112] rwltop[113]=rwlt[113] rwltop[114]=rwlt[114] rwltop[115]=rwlt[115] rwltop[116]=rwlt[116] rwltop[117]=rwlt[117] rwltop[118]=rwlt[118]
 rwltop[119]=rwlt[119] rwltop[120]=rwlt[120] rwltop[121]=rwlt[121] rwltop[122]=rwlt[122] rwltop[123]=rwlt[123] rwltop[124]=rwlt[124] rwltop[125]=rwlt[125]
 rwltop[126]=rwlt[126] rwltop[127]=rwlt[127] rwltop[128]=rwlt[128] rwltop[129]=rwlt[129] rwltop[130]=rwlt[130] rwltop[131]=rwlt[131] rwltop[132]=rwlt[132]
 rwltop[133]=rwlt[133] rwltop[134]=rwlt[134] rwltop[135]=rwlt[135] rwltop[136]=rwlt[136] rwltop[137]=rwlt[137] rwltop[138]=rwlt[138] rwltop[139]=rwlt[139]
 rwltop[140]=rwlt[140] rwltop[141]=rwlt[141] rwltop[142]=rwlt[142] rwltop[143]=rwlt[143] rwltop[144]=rwlt[144] rwltop[145]=rwlt[145] rwltop[146]=rwlt[146]
 rwltop[147]=rwlt[147] rwltop[148]=rwlt[148] rwltop[149]=rwlt[149] rwltop[150]=rwlt[150] rwltop[151]=rwlt[151] rwltop[152]=rwlt[152] rwltop[153]=rwlt[153]
 rwltop[154]=rwlt[154] rwltop[155]=rwlt[155] rwltop[156]=rwlt[156] rwltop[157]=rwlt[157] rwltop[158]=rwlt[158] rwltop[159]=rwlt[159] rwltop[160]=rwlt[160]
 rwltop[161]=rwlt[161] rwltop[162]=rwlt[162] rwltop[163]=rwlt[163] rwltop[164]=rwlt[164] rwltop[165]=rwlt[165] rwltop[166]=rwlt[166] rwltop[167]=rwlt[167]
 rwltop[168]=rwlt[168] rwltop[169]=rwlt[169] rwltop[170]=rwlt[170] rwltop[171]=rwlt[171] rwltop[172]=rwlt[172] rwltop[173]=rwlt[173] rwltop[174]=rwlt[174]
 rwltop[175]=rwlt[175] rwltop[176]=rwlt[176] rwltop[177]=rwlt[177] rwltop[178]=rwlt[178] rwltop[179]=rwlt[179] rwltop[180]=rwlt[180] rwltop[181]=rwlt[181]
 rwltop[182]=rwlt[182] rwltop[183]=rwlt[183] rwltop[184]=rwlt[184] rwltop[185]=rwlt[185] rwltop[186]=rwlt[186] rwltop[187]=rwlt[187] rwltop[188]=rwlt[188]
 rwltop[189]=rwlt[189] rwltop[190]=rwlt[190] rwltop[191]=rwlt[191] rwltop[192]=rwlt[192] rwltop[193]=rwlt[193] rwltop[194]=rwlt[194] rwltop[195]=rwlt[195]
 rwltop[196]=rwlt[196] rwltop[197]=rwlt[197] rwltop[198]=rwlt[198] rwltop[199]=rwlt[199] rwltop[200]=rwlt[200] rwltop[201]=rwlt[201] rwltop[202]=rwlt[202]
 rwltop[203]=rwlt[203] rwltop[204]=rwlt[204] rwltop[205]=rwlt[205] rwltop[206]=rwlt[206] rwltop[207]=rwlt[207] rwltop[208]=rwlt[208] rwltop[209]=rwlt[209]
 rwltop[210]=rwlt[210] rwltop[211]=rwlt[211] rwltop[212]=rwlt[212] rwltop[213]=rwlt[213] rwltop[214]=rwlt[214] rwltop[215]=rwlt[215] rwltop[216]=rwlt[216]
 rwltop[217]=rwlt[217] rwltop[218]=rwlt[218] rwltop[219]=rwlt[219] rwltop[220]=rwlt[220] rwltop[221]=rwlt[221] rwltop[222]=rwlt[222] rwltop[223]=rwlt[223]
 rwltop[224]=rwlt[224] rwltop[225]=rwlt[225] rwltop[226]=rwlt[226] rwltop[227]=rwlt[227] rwltop[228]=rwlt[228] rwltop[229]=rwlt[229] rwltop[230]=rwlt[230]
 rwltop[231]=rwlt[231] rwltop[232]=rwlt[232] rwltop[233]=rwlt[233] rwltop[234]=rwlt[234] rwltop[235]=rwlt[235] rwltop[236]=rwlt[236] rwltop[237]=rwlt[237]
 rwltop[238]=rwlt[238] rwltop[239]=rwlt[239] rwltop[240]=rwlt[240] rwltop[241]=rwlt[241] rwltop[242]=rwlt[242] rwltop[243]=rwlt[243] rwltop[244]=rwlt[244]
 rwltop[245]=rwlt[245] rwltop[246]=rwlt[246] rwltop[247]=rwlt[247] rwltop[248]=rwlt[248] rwltop[249]=rwlt[249] rwltop[250]=rwlt[250] rwltop[251]=rwlt[251]
 rwltop[252]=rwlt[252] rwltop[253]=rwlt[253] rwltop[254]=rwlt[254] rwltop[255]=rwlt[255] cmseltop[0]=cm[0] cmseltop[1]=cm[1] cmseltop[2]=cm[2]
 cmseltop[3]=cm[3] cmseltop[4]=cm[4] cmseltop[5]=cm[5] cmseltop[6]=cm[6] cmseltop[7]=cm[7] cmseltop[8]=cm[8] cmseltop[9]=cm[9]
 cmseltop[10]=cm[10] cmseltop[11]=cm[11] cmseltop[12]=cm[12] cmseltop[13]=cm[13] cmseltop[14]=cm[14] cmseltop[15]=cm[15] cmseltop[16]=cm[16]
 cmseltop[17]=cm[17] cmseltop[18]=cm[18] cmseltop[19]=cm[19] cmseltop[20]=cm[20] cmseltop[21]=cm[21] cmseltop[22]=cm[22] cmseltop[23]=cm[23]
 cmseltop[24]=cm[24] cmseltop[25]=cm[25] cmseltop[26]=cm[26] cmseltop[27]=cm[27] cmseltop[28]=cm[28] cmseltop[29]=cm[29] cmseltop[30]=cm[30]
 cmseltop[31]=cm[31] lblpchglfttop[0]=lblpchglft[0] lblpchglfttop[1]=lblpchglft[1] lblpchglfttop[2]=lblpchglft[2] lblpchglfttop[3]=lblpchglft[3] lblpchgrgttop[0]=lblpchgrgt[0] lblpchgrgttop[1]=lblpchgrgt[1]
 lblpchgrgttop[2]=lblpchgrgt[2] lblpchgrgttop[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_12=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[12]=odout pwrenio_11=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclktop=sdlclkin pwrenio_12=pwren_in
 rwltop[0]=rwlt[0] rwltop[1]=rwlt[1] rwltop[2]=rwlt[2] rwltop[3]=rwlt[3] rwltop[4]=rwlt[4] rwltop[5]=rwlt[5] rwltop[6]=rwlt[6]
 rwltop[7]=rwlt[7] rwltop[8]=rwlt[8] rwltop[9]=rwlt[9] rwltop[10]=rwlt[10] rwltop[11]=rwlt[11] rwltop[12]=rwlt[12] rwltop[13]=rwlt[13]
 rwltop[14]=rwlt[14] rwltop[15]=rwlt[15] rwltop[16]=rwlt[16] rwltop[17]=rwlt[17] rwltop[18]=rwlt[18] rwltop[19]=rwlt[19] rwltop[20]=rwlt[20]
 rwltop[21]=rwlt[21] rwltop[22]=rwlt[22] rwltop[23]=rwlt[23] rwltop[24]=rwlt[24] rwltop[25]=rwlt[25] rwltop[26]=rwlt[26] rwltop[27]=rwlt[27]
 rwltop[28]=rwlt[28] rwltop[29]=rwlt[29] rwltop[30]=rwlt[30] rwltop[31]=rwlt[31] rwltop[32]=rwlt[32] rwltop[33]=rwlt[33] rwltop[34]=rwlt[34]
 rwltop[35]=rwlt[35] rwltop[36]=rwlt[36] rwltop[37]=rwlt[37] rwltop[38]=rwlt[38] rwltop[39]=rwlt[39] rwltop[40]=rwlt[40] rwltop[41]=rwlt[41]
 rwltop[42]=rwlt[42] rwltop[43]=rwlt[43] rwltop[44]=rwlt[44] rwltop[45]=rwlt[45] rwltop[46]=rwlt[46] rwltop[47]=rwlt[47] rwltop[48]=rwlt[48]
 rwltop[49]=rwlt[49] rwltop[50]=rwlt[50] rwltop[51]=rwlt[51] rwltop[52]=rwlt[52] rwltop[53]=rwlt[53] rwltop[54]=rwlt[54] rwltop[55]=rwlt[55]
 rwltop[56]=rwlt[56] rwltop[57]=rwlt[57] rwltop[58]=rwlt[58] rwltop[59]=rwlt[59] rwltop[60]=rwlt[60] rwltop[61]=rwlt[61] rwltop[62]=rwlt[62]
 rwltop[63]=rwlt[63] rwltop[64]=rwlt[64] rwltop[65]=rwlt[65] rwltop[66]=rwlt[66] rwltop[67]=rwlt[67] rwltop[68]=rwlt[68] rwltop[69]=rwlt[69]
 rwltop[70]=rwlt[70] rwltop[71]=rwlt[71] rwltop[72]=rwlt[72] rwltop[73]=rwlt[73] rwltop[74]=rwlt[74] rwltop[75]=rwlt[75] rwltop[76]=rwlt[76]
 rwltop[77]=rwlt[77] rwltop[78]=rwlt[78] rwltop[79]=rwlt[79] rwltop[80]=rwlt[80] rwltop[81]=rwlt[81] rwltop[82]=rwlt[82] rwltop[83]=rwlt[83]
 rwltop[84]=rwlt[84] rwltop[85]=rwlt[85] rwltop[86]=rwlt[86] rwltop[87]=rwlt[87] rwltop[88]=rwlt[88] rwltop[89]=rwlt[89] rwltop[90]=rwlt[90]
 rwltop[91]=rwlt[91] rwltop[92]=rwlt[92] rwltop[93]=rwlt[93] rwltop[94]=rwlt[94] rwltop[95]=rwlt[95] rwltop[96]=rwlt[96] rwltop[97]=rwlt[97]
 rwltop[98]=rwlt[98] rwltop[99]=rwlt[99] rwltop[100]=rwlt[100] rwltop[101]=rwlt[101] rwltop[102]=rwlt[102] rwltop[103]=rwlt[103] rwltop[104]=rwlt[104]
 rwltop[105]=rwlt[105] rwltop[106]=rwlt[106] rwltop[107]=rwlt[107] rwltop[108]=rwlt[108] rwltop[109]=rwlt[109] rwltop[110]=rwlt[110] rwltop[111]=rwlt[111]
 rwltop[112]=rwlt[112] rwltop[113]=rwlt[113] rwltop[114]=rwlt[114] rwltop[115]=rwlt[115] rwltop[116]=rwlt[116] rwltop[117]=rwlt[117] rwltop[118]=rwlt[118]
 rwltop[119]=rwlt[119] rwltop[120]=rwlt[120] rwltop[121]=rwlt[121] rwltop[122]=rwlt[122] rwltop[123]=rwlt[123] rwltop[124]=rwlt[124] rwltop[125]=rwlt[125]
 rwltop[126]=rwlt[126] rwltop[127]=rwlt[127] rwltop[128]=rwlt[128] rwltop[129]=rwlt[129] rwltop[130]=rwlt[130] rwltop[131]=rwlt[131] rwltop[132]=rwlt[132]
 rwltop[133]=rwlt[133] rwltop[134]=rwlt[134] rwltop[135]=rwlt[135] rwltop[136]=rwlt[136] rwltop[137]=rwlt[137] rwltop[138]=rwlt[138] rwltop[139]=rwlt[139]
 rwltop[140]=rwlt[140] rwltop[141]=rwlt[141] rwltop[142]=rwlt[142] rwltop[143]=rwlt[143] rwltop[144]=rwlt[144] rwltop[145]=rwlt[145] rwltop[146]=rwlt[146]
 rwltop[147]=rwlt[147] rwltop[148]=rwlt[148] rwltop[149]=rwlt[149] rwltop[150]=rwlt[150] rwltop[151]=rwlt[151] rwltop[152]=rwlt[152] rwltop[153]=rwlt[153]
 rwltop[154]=rwlt[154] rwltop[155]=rwlt[155] rwltop[156]=rwlt[156] rwltop[157]=rwlt[157] rwltop[158]=rwlt[158] rwltop[159]=rwlt[159] rwltop[160]=rwlt[160]
 rwltop[161]=rwlt[161] rwltop[162]=rwlt[162] rwltop[163]=rwlt[163] rwltop[164]=rwlt[164] rwltop[165]=rwlt[165] rwltop[166]=rwlt[166] rwltop[167]=rwlt[167]
 rwltop[168]=rwlt[168] rwltop[169]=rwlt[169] rwltop[170]=rwlt[170] rwltop[171]=rwlt[171] rwltop[172]=rwlt[172] rwltop[173]=rwlt[173] rwltop[174]=rwlt[174]
 rwltop[175]=rwlt[175] rwltop[176]=rwlt[176] rwltop[177]=rwlt[177] rwltop[178]=rwlt[178] rwltop[179]=rwlt[179] rwltop[180]=rwlt[180] rwltop[181]=rwlt[181]
 rwltop[182]=rwlt[182] rwltop[183]=rwlt[183] rwltop[184]=rwlt[184] rwltop[185]=rwlt[185] rwltop[186]=rwlt[186] rwltop[187]=rwlt[187] rwltop[188]=rwlt[188]
 rwltop[189]=rwlt[189] rwltop[190]=rwlt[190] rwltop[191]=rwlt[191] rwltop[192]=rwlt[192] rwltop[193]=rwlt[193] rwltop[194]=rwlt[194] rwltop[195]=rwlt[195]
 rwltop[196]=rwlt[196] rwltop[197]=rwlt[197] rwltop[198]=rwlt[198] rwltop[199]=rwlt[199] rwltop[200]=rwlt[200] rwltop[201]=rwlt[201] rwltop[202]=rwlt[202]
 rwltop[203]=rwlt[203] rwltop[204]=rwlt[204] rwltop[205]=rwlt[205] rwltop[206]=rwlt[206] rwltop[207]=rwlt[207] rwltop[208]=rwlt[208] rwltop[209]=rwlt[209]
 rwltop[210]=rwlt[210] rwltop[211]=rwlt[211] rwltop[212]=rwlt[212] rwltop[213]=rwlt[213] rwltop[214]=rwlt[214] rwltop[215]=rwlt[215] rwltop[216]=rwlt[216]
 rwltop[217]=rwlt[217] rwltop[218]=rwlt[218] rwltop[219]=rwlt[219] rwltop[220]=rwlt[220] rwltop[221]=rwlt[221] rwltop[222]=rwlt[222] rwltop[223]=rwlt[223]
 rwltop[224]=rwlt[224] rwltop[225]=rwlt[225] rwltop[226]=rwlt[226] rwltop[227]=rwlt[227] rwltop[228]=rwlt[228] rwltop[229]=rwlt[229] rwltop[230]=rwlt[230]
 rwltop[231]=rwlt[231] rwltop[232]=rwlt[232] rwltop[233]=rwlt[233] rwltop[234]=rwlt[234] rwltop[235]=rwlt[235] rwltop[236]=rwlt[236] rwltop[237]=rwlt[237]
 rwltop[238]=rwlt[238] rwltop[239]=rwlt[239] rwltop[240]=rwlt[240] rwltop[241]=rwlt[241] rwltop[242]=rwlt[242] rwltop[243]=rwlt[243] rwltop[244]=rwlt[244]
 rwltop[245]=rwlt[245] rwltop[246]=rwlt[246] rwltop[247]=rwlt[247] rwltop[248]=rwlt[248] rwltop[249]=rwlt[249] rwltop[250]=rwlt[250] rwltop[251]=rwlt[251]
 rwltop[252]=rwlt[252] rwltop[253]=rwlt[253] rwltop[254]=rwlt[254] rwltop[255]=rwlt[255] cmseltop[0]=cm[0] cmseltop[1]=cm[1] cmseltop[2]=cm[2]
 cmseltop[3]=cm[3] cmseltop[4]=cm[4] cmseltop[5]=cm[5] cmseltop[6]=cm[6] cmseltop[7]=cm[7] cmseltop[8]=cm[8] cmseltop[9]=cm[9]
 cmseltop[10]=cm[10] cmseltop[11]=cm[11] cmseltop[12]=cm[12] cmseltop[13]=cm[13] cmseltop[14]=cm[14] cmseltop[15]=cm[15] cmseltop[16]=cm[16]
 cmseltop[17]=cm[17] cmseltop[18]=cm[18] cmseltop[19]=cm[19] cmseltop[20]=cm[20] cmseltop[21]=cm[21] cmseltop[22]=cm[22] cmseltop[23]=cm[23]
 cmseltop[24]=cm[24] cmseltop[25]=cm[25] cmseltop[26]=cm[26] cmseltop[27]=cm[27] cmseltop[28]=cm[28] cmseltop[29]=cm[29] cmseltop[30]=cm[30]
 cmseltop[31]=cm[31] lblpchglfttop[0]=lblpchglft[0] lblpchglfttop[1]=lblpchglft[1] lblpchglfttop[2]=lblpchglft[2] lblpchglfttop[3]=lblpchglft[3] lblpchgrgttop[0]=lblpchgrgt[0] lblpchgrgttop[1]=lblpchgrgt[1]
 lblpchgrgttop[2]=lblpchgrgt[2] lblpchgrgttop[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_11=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[11]=odout pwrenio_10=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclktop=sdlclkin pwrenio_11=pwren_in
 rwltop[0]=rwlt[0] rwltop[1]=rwlt[1] rwltop[2]=rwlt[2] rwltop[3]=rwlt[3] rwltop[4]=rwlt[4] rwltop[5]=rwlt[5] rwltop[6]=rwlt[6]
 rwltop[7]=rwlt[7] rwltop[8]=rwlt[8] rwltop[9]=rwlt[9] rwltop[10]=rwlt[10] rwltop[11]=rwlt[11] rwltop[12]=rwlt[12] rwltop[13]=rwlt[13]
 rwltop[14]=rwlt[14] rwltop[15]=rwlt[15] rwltop[16]=rwlt[16] rwltop[17]=rwlt[17] rwltop[18]=rwlt[18] rwltop[19]=rwlt[19] rwltop[20]=rwlt[20]
 rwltop[21]=rwlt[21] rwltop[22]=rwlt[22] rwltop[23]=rwlt[23] rwltop[24]=rwlt[24] rwltop[25]=rwlt[25] rwltop[26]=rwlt[26] rwltop[27]=rwlt[27]
 rwltop[28]=rwlt[28] rwltop[29]=rwlt[29] rwltop[30]=rwlt[30] rwltop[31]=rwlt[31] rwltop[32]=rwlt[32] rwltop[33]=rwlt[33] rwltop[34]=rwlt[34]
 rwltop[35]=rwlt[35] rwltop[36]=rwlt[36] rwltop[37]=rwlt[37] rwltop[38]=rwlt[38] rwltop[39]=rwlt[39] rwltop[40]=rwlt[40] rwltop[41]=rwlt[41]
 rwltop[42]=rwlt[42] rwltop[43]=rwlt[43] rwltop[44]=rwlt[44] rwltop[45]=rwlt[45] rwltop[46]=rwlt[46] rwltop[47]=rwlt[47] rwltop[48]=rwlt[48]
 rwltop[49]=rwlt[49] rwltop[50]=rwlt[50] rwltop[51]=rwlt[51] rwltop[52]=rwlt[52] rwltop[53]=rwlt[53] rwltop[54]=rwlt[54] rwltop[55]=rwlt[55]
 rwltop[56]=rwlt[56] rwltop[57]=rwlt[57] rwltop[58]=rwlt[58] rwltop[59]=rwlt[59] rwltop[60]=rwlt[60] rwltop[61]=rwlt[61] rwltop[62]=rwlt[62]
 rwltop[63]=rwlt[63] rwltop[64]=rwlt[64] rwltop[65]=rwlt[65] rwltop[66]=rwlt[66] rwltop[67]=rwlt[67] rwltop[68]=rwlt[68] rwltop[69]=rwlt[69]
 rwltop[70]=rwlt[70] rwltop[71]=rwlt[71] rwltop[72]=rwlt[72] rwltop[73]=rwlt[73] rwltop[74]=rwlt[74] rwltop[75]=rwlt[75] rwltop[76]=rwlt[76]
 rwltop[77]=rwlt[77] rwltop[78]=rwlt[78] rwltop[79]=rwlt[79] rwltop[80]=rwlt[80] rwltop[81]=rwlt[81] rwltop[82]=rwlt[82] rwltop[83]=rwlt[83]
 rwltop[84]=rwlt[84] rwltop[85]=rwlt[85] rwltop[86]=rwlt[86] rwltop[87]=rwlt[87] rwltop[88]=rwlt[88] rwltop[89]=rwlt[89] rwltop[90]=rwlt[90]
 rwltop[91]=rwlt[91] rwltop[92]=rwlt[92] rwltop[93]=rwlt[93] rwltop[94]=rwlt[94] rwltop[95]=rwlt[95] rwltop[96]=rwlt[96] rwltop[97]=rwlt[97]
 rwltop[98]=rwlt[98] rwltop[99]=rwlt[99] rwltop[100]=rwlt[100] rwltop[101]=rwlt[101] rwltop[102]=rwlt[102] rwltop[103]=rwlt[103] rwltop[104]=rwlt[104]
 rwltop[105]=rwlt[105] rwltop[106]=rwlt[106] rwltop[107]=rwlt[107] rwltop[108]=rwlt[108] rwltop[109]=rwlt[109] rwltop[110]=rwlt[110] rwltop[111]=rwlt[111]
 rwltop[112]=rwlt[112] rwltop[113]=rwlt[113] rwltop[114]=rwlt[114] rwltop[115]=rwlt[115] rwltop[116]=rwlt[116] rwltop[117]=rwlt[117] rwltop[118]=rwlt[118]
 rwltop[119]=rwlt[119] rwltop[120]=rwlt[120] rwltop[121]=rwlt[121] rwltop[122]=rwlt[122] rwltop[123]=rwlt[123] rwltop[124]=rwlt[124] rwltop[125]=rwlt[125]
 rwltop[126]=rwlt[126] rwltop[127]=rwlt[127] rwltop[128]=rwlt[128] rwltop[129]=rwlt[129] rwltop[130]=rwlt[130] rwltop[131]=rwlt[131] rwltop[132]=rwlt[132]
 rwltop[133]=rwlt[133] rwltop[134]=rwlt[134] rwltop[135]=rwlt[135] rwltop[136]=rwlt[136] rwltop[137]=rwlt[137] rwltop[138]=rwlt[138] rwltop[139]=rwlt[139]
 rwltop[140]=rwlt[140] rwltop[141]=rwlt[141] rwltop[142]=rwlt[142] rwltop[143]=rwlt[143] rwltop[144]=rwlt[144] rwltop[145]=rwlt[145] rwltop[146]=rwlt[146]
 rwltop[147]=rwlt[147] rwltop[148]=rwlt[148] rwltop[149]=rwlt[149] rwltop[150]=rwlt[150] rwltop[151]=rwlt[151] rwltop[152]=rwlt[152] rwltop[153]=rwlt[153]
 rwltop[154]=rwlt[154] rwltop[155]=rwlt[155] rwltop[156]=rwlt[156] rwltop[157]=rwlt[157] rwltop[158]=rwlt[158] rwltop[159]=rwlt[159] rwltop[160]=rwlt[160]
 rwltop[161]=rwlt[161] rwltop[162]=rwlt[162] rwltop[163]=rwlt[163] rwltop[164]=rwlt[164] rwltop[165]=rwlt[165] rwltop[166]=rwlt[166] rwltop[167]=rwlt[167]
 rwltop[168]=rwlt[168] rwltop[169]=rwlt[169] rwltop[170]=rwlt[170] rwltop[171]=rwlt[171] rwltop[172]=rwlt[172] rwltop[173]=rwlt[173] rwltop[174]=rwlt[174]
 rwltop[175]=rwlt[175] rwltop[176]=rwlt[176] rwltop[177]=rwlt[177] rwltop[178]=rwlt[178] rwltop[179]=rwlt[179] rwltop[180]=rwlt[180] rwltop[181]=rwlt[181]
 rwltop[182]=rwlt[182] rwltop[183]=rwlt[183] rwltop[184]=rwlt[184] rwltop[185]=rwlt[185] rwltop[186]=rwlt[186] rwltop[187]=rwlt[187] rwltop[188]=rwlt[188]
 rwltop[189]=rwlt[189] rwltop[190]=rwlt[190] rwltop[191]=rwlt[191] rwltop[192]=rwlt[192] rwltop[193]=rwlt[193] rwltop[194]=rwlt[194] rwltop[195]=rwlt[195]
 rwltop[196]=rwlt[196] rwltop[197]=rwlt[197] rwltop[198]=rwlt[198] rwltop[199]=rwlt[199] rwltop[200]=rwlt[200] rwltop[201]=rwlt[201] rwltop[202]=rwlt[202]
 rwltop[203]=rwlt[203] rwltop[204]=rwlt[204] rwltop[205]=rwlt[205] rwltop[206]=rwlt[206] rwltop[207]=rwlt[207] rwltop[208]=rwlt[208] rwltop[209]=rwlt[209]
 rwltop[210]=rwlt[210] rwltop[211]=rwlt[211] rwltop[212]=rwlt[212] rwltop[213]=rwlt[213] rwltop[214]=rwlt[214] rwltop[215]=rwlt[215] rwltop[216]=rwlt[216]
 rwltop[217]=rwlt[217] rwltop[218]=rwlt[218] rwltop[219]=rwlt[219] rwltop[220]=rwlt[220] rwltop[221]=rwlt[221] rwltop[222]=rwlt[222] rwltop[223]=rwlt[223]
 rwltop[224]=rwlt[224] rwltop[225]=rwlt[225] rwltop[226]=rwlt[226] rwltop[227]=rwlt[227] rwltop[228]=rwlt[228] rwltop[229]=rwlt[229] rwltop[230]=rwlt[230]
 rwltop[231]=rwlt[231] rwltop[232]=rwlt[232] rwltop[233]=rwlt[233] rwltop[234]=rwlt[234] rwltop[235]=rwlt[235] rwltop[236]=rwlt[236] rwltop[237]=rwlt[237]
 rwltop[238]=rwlt[238] rwltop[239]=rwlt[239] rwltop[240]=rwlt[240] rwltop[241]=rwlt[241] rwltop[242]=rwlt[242] rwltop[243]=rwlt[243] rwltop[244]=rwlt[244]
 rwltop[245]=rwlt[245] rwltop[246]=rwlt[246] rwltop[247]=rwlt[247] rwltop[248]=rwlt[248] rwltop[249]=rwlt[249] rwltop[250]=rwlt[250] rwltop[251]=rwlt[251]
 rwltop[252]=rwlt[252] rwltop[253]=rwlt[253] rwltop[254]=rwlt[254] rwltop[255]=rwlt[255] cmseltop[0]=cm[0] cmseltop[1]=cm[1] cmseltop[2]=cm[2]
 cmseltop[3]=cm[3] cmseltop[4]=cm[4] cmseltop[5]=cm[5] cmseltop[6]=cm[6] cmseltop[7]=cm[7] cmseltop[8]=cm[8] cmseltop[9]=cm[9]
 cmseltop[10]=cm[10] cmseltop[11]=cm[11] cmseltop[12]=cm[12] cmseltop[13]=cm[13] cmseltop[14]=cm[14] cmseltop[15]=cm[15] cmseltop[16]=cm[16]
 cmseltop[17]=cm[17] cmseltop[18]=cm[18] cmseltop[19]=cm[19] cmseltop[20]=cm[20] cmseltop[21]=cm[21] cmseltop[22]=cm[22] cmseltop[23]=cm[23]
 cmseltop[24]=cm[24] cmseltop[25]=cm[25] cmseltop[26]=cm[26] cmseltop[27]=cm[27] cmseltop[28]=cm[28] cmseltop[29]=cm[29] cmseltop[30]=cm[30]
 cmseltop[31]=cm[31] lblpchglfttop[0]=lblpchglft[0] lblpchglfttop[1]=lblpchglft[1] lblpchglfttop[2]=lblpchglft[2] lblpchglfttop[3]=lblpchglft[3] lblpchgrgttop[0]=lblpchgrgt[0] lblpchgrgttop[1]=lblpchgrgt[1]
 lblpchgrgttop[2]=lblpchgrgt[2] lblpchgrgttop[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_10=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[10]=odout pwrenio_9=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclktop=sdlclkin pwrenio_10=pwren_in
 rwltop[0]=rwlt[0] rwltop[1]=rwlt[1] rwltop[2]=rwlt[2] rwltop[3]=rwlt[3] rwltop[4]=rwlt[4] rwltop[5]=rwlt[5] rwltop[6]=rwlt[6]
 rwltop[7]=rwlt[7] rwltop[8]=rwlt[8] rwltop[9]=rwlt[9] rwltop[10]=rwlt[10] rwltop[11]=rwlt[11] rwltop[12]=rwlt[12] rwltop[13]=rwlt[13]
 rwltop[14]=rwlt[14] rwltop[15]=rwlt[15] rwltop[16]=rwlt[16] rwltop[17]=rwlt[17] rwltop[18]=rwlt[18] rwltop[19]=rwlt[19] rwltop[20]=rwlt[20]
 rwltop[21]=rwlt[21] rwltop[22]=rwlt[22] rwltop[23]=rwlt[23] rwltop[24]=rwlt[24] rwltop[25]=rwlt[25] rwltop[26]=rwlt[26] rwltop[27]=rwlt[27]
 rwltop[28]=rwlt[28] rwltop[29]=rwlt[29] rwltop[30]=rwlt[30] rwltop[31]=rwlt[31] rwltop[32]=rwlt[32] rwltop[33]=rwlt[33] rwltop[34]=rwlt[34]
 rwltop[35]=rwlt[35] rwltop[36]=rwlt[36] rwltop[37]=rwlt[37] rwltop[38]=rwlt[38] rwltop[39]=rwlt[39] rwltop[40]=rwlt[40] rwltop[41]=rwlt[41]
 rwltop[42]=rwlt[42] rwltop[43]=rwlt[43] rwltop[44]=rwlt[44] rwltop[45]=rwlt[45] rwltop[46]=rwlt[46] rwltop[47]=rwlt[47] rwltop[48]=rwlt[48]
 rwltop[49]=rwlt[49] rwltop[50]=rwlt[50] rwltop[51]=rwlt[51] rwltop[52]=rwlt[52] rwltop[53]=rwlt[53] rwltop[54]=rwlt[54] rwltop[55]=rwlt[55]
 rwltop[56]=rwlt[56] rwltop[57]=rwlt[57] rwltop[58]=rwlt[58] rwltop[59]=rwlt[59] rwltop[60]=rwlt[60] rwltop[61]=rwlt[61] rwltop[62]=rwlt[62]
 rwltop[63]=rwlt[63] rwltop[64]=rwlt[64] rwltop[65]=rwlt[65] rwltop[66]=rwlt[66] rwltop[67]=rwlt[67] rwltop[68]=rwlt[68] rwltop[69]=rwlt[69]
 rwltop[70]=rwlt[70] rwltop[71]=rwlt[71] rwltop[72]=rwlt[72] rwltop[73]=rwlt[73] rwltop[74]=rwlt[74] rwltop[75]=rwlt[75] rwltop[76]=rwlt[76]
 rwltop[77]=rwlt[77] rwltop[78]=rwlt[78] rwltop[79]=rwlt[79] rwltop[80]=rwlt[80] rwltop[81]=rwlt[81] rwltop[82]=rwlt[82] rwltop[83]=rwlt[83]
 rwltop[84]=rwlt[84] rwltop[85]=rwlt[85] rwltop[86]=rwlt[86] rwltop[87]=rwlt[87] rwltop[88]=rwlt[88] rwltop[89]=rwlt[89] rwltop[90]=rwlt[90]
 rwltop[91]=rwlt[91] rwltop[92]=rwlt[92] rwltop[93]=rwlt[93] rwltop[94]=rwlt[94] rwltop[95]=rwlt[95] rwltop[96]=rwlt[96] rwltop[97]=rwlt[97]
 rwltop[98]=rwlt[98] rwltop[99]=rwlt[99] rwltop[100]=rwlt[100] rwltop[101]=rwlt[101] rwltop[102]=rwlt[102] rwltop[103]=rwlt[103] rwltop[104]=rwlt[104]
 rwltop[105]=rwlt[105] rwltop[106]=rwlt[106] rwltop[107]=rwlt[107] rwltop[108]=rwlt[108] rwltop[109]=rwlt[109] rwltop[110]=rwlt[110] rwltop[111]=rwlt[111]
 rwltop[112]=rwlt[112] rwltop[113]=rwlt[113] rwltop[114]=rwlt[114] rwltop[115]=rwlt[115] rwltop[116]=rwlt[116] rwltop[117]=rwlt[117] rwltop[118]=rwlt[118]
 rwltop[119]=rwlt[119] rwltop[120]=rwlt[120] rwltop[121]=rwlt[121] rwltop[122]=rwlt[122] rwltop[123]=rwlt[123] rwltop[124]=rwlt[124] rwltop[125]=rwlt[125]
 rwltop[126]=rwlt[126] rwltop[127]=rwlt[127] rwltop[128]=rwlt[128] rwltop[129]=rwlt[129] rwltop[130]=rwlt[130] rwltop[131]=rwlt[131] rwltop[132]=rwlt[132]
 rwltop[133]=rwlt[133] rwltop[134]=rwlt[134] rwltop[135]=rwlt[135] rwltop[136]=rwlt[136] rwltop[137]=rwlt[137] rwltop[138]=rwlt[138] rwltop[139]=rwlt[139]
 rwltop[140]=rwlt[140] rwltop[141]=rwlt[141] rwltop[142]=rwlt[142] rwltop[143]=rwlt[143] rwltop[144]=rwlt[144] rwltop[145]=rwlt[145] rwltop[146]=rwlt[146]
 rwltop[147]=rwlt[147] rwltop[148]=rwlt[148] rwltop[149]=rwlt[149] rwltop[150]=rwlt[150] rwltop[151]=rwlt[151] rwltop[152]=rwlt[152] rwltop[153]=rwlt[153]
 rwltop[154]=rwlt[154] rwltop[155]=rwlt[155] rwltop[156]=rwlt[156] rwltop[157]=rwlt[157] rwltop[158]=rwlt[158] rwltop[159]=rwlt[159] rwltop[160]=rwlt[160]
 rwltop[161]=rwlt[161] rwltop[162]=rwlt[162] rwltop[163]=rwlt[163] rwltop[164]=rwlt[164] rwltop[165]=rwlt[165] rwltop[166]=rwlt[166] rwltop[167]=rwlt[167]
 rwltop[168]=rwlt[168] rwltop[169]=rwlt[169] rwltop[170]=rwlt[170] rwltop[171]=rwlt[171] rwltop[172]=rwlt[172] rwltop[173]=rwlt[173] rwltop[174]=rwlt[174]
 rwltop[175]=rwlt[175] rwltop[176]=rwlt[176] rwltop[177]=rwlt[177] rwltop[178]=rwlt[178] rwltop[179]=rwlt[179] rwltop[180]=rwlt[180] rwltop[181]=rwlt[181]
 rwltop[182]=rwlt[182] rwltop[183]=rwlt[183] rwltop[184]=rwlt[184] rwltop[185]=rwlt[185] rwltop[186]=rwlt[186] rwltop[187]=rwlt[187] rwltop[188]=rwlt[188]
 rwltop[189]=rwlt[189] rwltop[190]=rwlt[190] rwltop[191]=rwlt[191] rwltop[192]=rwlt[192] rwltop[193]=rwlt[193] rwltop[194]=rwlt[194] rwltop[195]=rwlt[195]
 rwltop[196]=rwlt[196] rwltop[197]=rwlt[197] rwltop[198]=rwlt[198] rwltop[199]=rwlt[199] rwltop[200]=rwlt[200] rwltop[201]=rwlt[201] rwltop[202]=rwlt[202]
 rwltop[203]=rwlt[203] rwltop[204]=rwlt[204] rwltop[205]=rwlt[205] rwltop[206]=rwlt[206] rwltop[207]=rwlt[207] rwltop[208]=rwlt[208] rwltop[209]=rwlt[209]
 rwltop[210]=rwlt[210] rwltop[211]=rwlt[211] rwltop[212]=rwlt[212] rwltop[213]=rwlt[213] rwltop[214]=rwlt[214] rwltop[215]=rwlt[215] rwltop[216]=rwlt[216]
 rwltop[217]=rwlt[217] rwltop[218]=rwlt[218] rwltop[219]=rwlt[219] rwltop[220]=rwlt[220] rwltop[221]=rwlt[221] rwltop[222]=rwlt[222] rwltop[223]=rwlt[223]
 rwltop[224]=rwlt[224] rwltop[225]=rwlt[225] rwltop[226]=rwlt[226] rwltop[227]=rwlt[227] rwltop[228]=rwlt[228] rwltop[229]=rwlt[229] rwltop[230]=rwlt[230]
 rwltop[231]=rwlt[231] rwltop[232]=rwlt[232] rwltop[233]=rwlt[233] rwltop[234]=rwlt[234] rwltop[235]=rwlt[235] rwltop[236]=rwlt[236] rwltop[237]=rwlt[237]
 rwltop[238]=rwlt[238] rwltop[239]=rwlt[239] rwltop[240]=rwlt[240] rwltop[241]=rwlt[241] rwltop[242]=rwlt[242] rwltop[243]=rwlt[243] rwltop[244]=rwlt[244]
 rwltop[245]=rwlt[245] rwltop[246]=rwlt[246] rwltop[247]=rwlt[247] rwltop[248]=rwlt[248] rwltop[249]=rwlt[249] rwltop[250]=rwlt[250] rwltop[251]=rwlt[251]
 rwltop[252]=rwlt[252] rwltop[253]=rwlt[253] rwltop[254]=rwlt[254] rwltop[255]=rwlt[255] cmseltop[0]=cm[0] cmseltop[1]=cm[1] cmseltop[2]=cm[2]
 cmseltop[3]=cm[3] cmseltop[4]=cm[4] cmseltop[5]=cm[5] cmseltop[6]=cm[6] cmseltop[7]=cm[7] cmseltop[8]=cm[8] cmseltop[9]=cm[9]
 cmseltop[10]=cm[10] cmseltop[11]=cm[11] cmseltop[12]=cm[12] cmseltop[13]=cm[13] cmseltop[14]=cm[14] cmseltop[15]=cm[15] cmseltop[16]=cm[16]
 cmseltop[17]=cm[17] cmseltop[18]=cm[18] cmseltop[19]=cm[19] cmseltop[20]=cm[20] cmseltop[21]=cm[21] cmseltop[22]=cm[22] cmseltop[23]=cm[23]
 cmseltop[24]=cm[24] cmseltop[25]=cm[25] cmseltop[26]=cm[26] cmseltop[27]=cm[27] cmseltop[28]=cm[28] cmseltop[29]=cm[29] cmseltop[30]=cm[30]
 cmseltop[31]=cm[31] lblpchglfttop[0]=lblpchglft[0] lblpchglfttop[1]=lblpchglft[1] lblpchglfttop[2]=lblpchglft[2] lblpchglfttop[3]=lblpchglft[3] lblpchgrgttop[0]=lblpchgrgt[0] lblpchgrgttop[1]=lblpchgrgt[1]
 lblpchgrgttop[2]=lblpchgrgt[2] lblpchgrgttop[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_9=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[9]=odout pwrenio_8=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclktop=sdlclkin pwrenio_9=pwren_in
 rwltop[0]=rwlt[0] rwltop[1]=rwlt[1] rwltop[2]=rwlt[2] rwltop[3]=rwlt[3] rwltop[4]=rwlt[4] rwltop[5]=rwlt[5] rwltop[6]=rwlt[6]
 rwltop[7]=rwlt[7] rwltop[8]=rwlt[8] rwltop[9]=rwlt[9] rwltop[10]=rwlt[10] rwltop[11]=rwlt[11] rwltop[12]=rwlt[12] rwltop[13]=rwlt[13]
 rwltop[14]=rwlt[14] rwltop[15]=rwlt[15] rwltop[16]=rwlt[16] rwltop[17]=rwlt[17] rwltop[18]=rwlt[18] rwltop[19]=rwlt[19] rwltop[20]=rwlt[20]
 rwltop[21]=rwlt[21] rwltop[22]=rwlt[22] rwltop[23]=rwlt[23] rwltop[24]=rwlt[24] rwltop[25]=rwlt[25] rwltop[26]=rwlt[26] rwltop[27]=rwlt[27]
 rwltop[28]=rwlt[28] rwltop[29]=rwlt[29] rwltop[30]=rwlt[30] rwltop[31]=rwlt[31] rwltop[32]=rwlt[32] rwltop[33]=rwlt[33] rwltop[34]=rwlt[34]
 rwltop[35]=rwlt[35] rwltop[36]=rwlt[36] rwltop[37]=rwlt[37] rwltop[38]=rwlt[38] rwltop[39]=rwlt[39] rwltop[40]=rwlt[40] rwltop[41]=rwlt[41]
 rwltop[42]=rwlt[42] rwltop[43]=rwlt[43] rwltop[44]=rwlt[44] rwltop[45]=rwlt[45] rwltop[46]=rwlt[46] rwltop[47]=rwlt[47] rwltop[48]=rwlt[48]
 rwltop[49]=rwlt[49] rwltop[50]=rwlt[50] rwltop[51]=rwlt[51] rwltop[52]=rwlt[52] rwltop[53]=rwlt[53] rwltop[54]=rwlt[54] rwltop[55]=rwlt[55]
 rwltop[56]=rwlt[56] rwltop[57]=rwlt[57] rwltop[58]=rwlt[58] rwltop[59]=rwlt[59] rwltop[60]=rwlt[60] rwltop[61]=rwlt[61] rwltop[62]=rwlt[62]
 rwltop[63]=rwlt[63] rwltop[64]=rwlt[64] rwltop[65]=rwlt[65] rwltop[66]=rwlt[66] rwltop[67]=rwlt[67] rwltop[68]=rwlt[68] rwltop[69]=rwlt[69]
 rwltop[70]=rwlt[70] rwltop[71]=rwlt[71] rwltop[72]=rwlt[72] rwltop[73]=rwlt[73] rwltop[74]=rwlt[74] rwltop[75]=rwlt[75] rwltop[76]=rwlt[76]
 rwltop[77]=rwlt[77] rwltop[78]=rwlt[78] rwltop[79]=rwlt[79] rwltop[80]=rwlt[80] rwltop[81]=rwlt[81] rwltop[82]=rwlt[82] rwltop[83]=rwlt[83]
 rwltop[84]=rwlt[84] rwltop[85]=rwlt[85] rwltop[86]=rwlt[86] rwltop[87]=rwlt[87] rwltop[88]=rwlt[88] rwltop[89]=rwlt[89] rwltop[90]=rwlt[90]
 rwltop[91]=rwlt[91] rwltop[92]=rwlt[92] rwltop[93]=rwlt[93] rwltop[94]=rwlt[94] rwltop[95]=rwlt[95] rwltop[96]=rwlt[96] rwltop[97]=rwlt[97]
 rwltop[98]=rwlt[98] rwltop[99]=rwlt[99] rwltop[100]=rwlt[100] rwltop[101]=rwlt[101] rwltop[102]=rwlt[102] rwltop[103]=rwlt[103] rwltop[104]=rwlt[104]
 rwltop[105]=rwlt[105] rwltop[106]=rwlt[106] rwltop[107]=rwlt[107] rwltop[108]=rwlt[108] rwltop[109]=rwlt[109] rwltop[110]=rwlt[110] rwltop[111]=rwlt[111]
 rwltop[112]=rwlt[112] rwltop[113]=rwlt[113] rwltop[114]=rwlt[114] rwltop[115]=rwlt[115] rwltop[116]=rwlt[116] rwltop[117]=rwlt[117] rwltop[118]=rwlt[118]
 rwltop[119]=rwlt[119] rwltop[120]=rwlt[120] rwltop[121]=rwlt[121] rwltop[122]=rwlt[122] rwltop[123]=rwlt[123] rwltop[124]=rwlt[124] rwltop[125]=rwlt[125]
 rwltop[126]=rwlt[126] rwltop[127]=rwlt[127] rwltop[128]=rwlt[128] rwltop[129]=rwlt[129] rwltop[130]=rwlt[130] rwltop[131]=rwlt[131] rwltop[132]=rwlt[132]
 rwltop[133]=rwlt[133] rwltop[134]=rwlt[134] rwltop[135]=rwlt[135] rwltop[136]=rwlt[136] rwltop[137]=rwlt[137] rwltop[138]=rwlt[138] rwltop[139]=rwlt[139]
 rwltop[140]=rwlt[140] rwltop[141]=rwlt[141] rwltop[142]=rwlt[142] rwltop[143]=rwlt[143] rwltop[144]=rwlt[144] rwltop[145]=rwlt[145] rwltop[146]=rwlt[146]
 rwltop[147]=rwlt[147] rwltop[148]=rwlt[148] rwltop[149]=rwlt[149] rwltop[150]=rwlt[150] rwltop[151]=rwlt[151] rwltop[152]=rwlt[152] rwltop[153]=rwlt[153]
 rwltop[154]=rwlt[154] rwltop[155]=rwlt[155] rwltop[156]=rwlt[156] rwltop[157]=rwlt[157] rwltop[158]=rwlt[158] rwltop[159]=rwlt[159] rwltop[160]=rwlt[160]
 rwltop[161]=rwlt[161] rwltop[162]=rwlt[162] rwltop[163]=rwlt[163] rwltop[164]=rwlt[164] rwltop[165]=rwlt[165] rwltop[166]=rwlt[166] rwltop[167]=rwlt[167]
 rwltop[168]=rwlt[168] rwltop[169]=rwlt[169] rwltop[170]=rwlt[170] rwltop[171]=rwlt[171] rwltop[172]=rwlt[172] rwltop[173]=rwlt[173] rwltop[174]=rwlt[174]
 rwltop[175]=rwlt[175] rwltop[176]=rwlt[176] rwltop[177]=rwlt[177] rwltop[178]=rwlt[178] rwltop[179]=rwlt[179] rwltop[180]=rwlt[180] rwltop[181]=rwlt[181]
 rwltop[182]=rwlt[182] rwltop[183]=rwlt[183] rwltop[184]=rwlt[184] rwltop[185]=rwlt[185] rwltop[186]=rwlt[186] rwltop[187]=rwlt[187] rwltop[188]=rwlt[188]
 rwltop[189]=rwlt[189] rwltop[190]=rwlt[190] rwltop[191]=rwlt[191] rwltop[192]=rwlt[192] rwltop[193]=rwlt[193] rwltop[194]=rwlt[194] rwltop[195]=rwlt[195]
 rwltop[196]=rwlt[196] rwltop[197]=rwlt[197] rwltop[198]=rwlt[198] rwltop[199]=rwlt[199] rwltop[200]=rwlt[200] rwltop[201]=rwlt[201] rwltop[202]=rwlt[202]
 rwltop[203]=rwlt[203] rwltop[204]=rwlt[204] rwltop[205]=rwlt[205] rwltop[206]=rwlt[206] rwltop[207]=rwlt[207] rwltop[208]=rwlt[208] rwltop[209]=rwlt[209]
 rwltop[210]=rwlt[210] rwltop[211]=rwlt[211] rwltop[212]=rwlt[212] rwltop[213]=rwlt[213] rwltop[214]=rwlt[214] rwltop[215]=rwlt[215] rwltop[216]=rwlt[216]
 rwltop[217]=rwlt[217] rwltop[218]=rwlt[218] rwltop[219]=rwlt[219] rwltop[220]=rwlt[220] rwltop[221]=rwlt[221] rwltop[222]=rwlt[222] rwltop[223]=rwlt[223]
 rwltop[224]=rwlt[224] rwltop[225]=rwlt[225] rwltop[226]=rwlt[226] rwltop[227]=rwlt[227] rwltop[228]=rwlt[228] rwltop[229]=rwlt[229] rwltop[230]=rwlt[230]
 rwltop[231]=rwlt[231] rwltop[232]=rwlt[232] rwltop[233]=rwlt[233] rwltop[234]=rwlt[234] rwltop[235]=rwlt[235] rwltop[236]=rwlt[236] rwltop[237]=rwlt[237]
 rwltop[238]=rwlt[238] rwltop[239]=rwlt[239] rwltop[240]=rwlt[240] rwltop[241]=rwlt[241] rwltop[242]=rwlt[242] rwltop[243]=rwlt[243] rwltop[244]=rwlt[244]
 rwltop[245]=rwlt[245] rwltop[246]=rwlt[246] rwltop[247]=rwlt[247] rwltop[248]=rwlt[248] rwltop[249]=rwlt[249] rwltop[250]=rwlt[250] rwltop[251]=rwlt[251]
 rwltop[252]=rwlt[252] rwltop[253]=rwlt[253] rwltop[254]=rwlt[254] rwltop[255]=rwlt[255] cmseltop[0]=cm[0] cmseltop[1]=cm[1] cmseltop[2]=cm[2]
 cmseltop[3]=cm[3] cmseltop[4]=cm[4] cmseltop[5]=cm[5] cmseltop[6]=cm[6] cmseltop[7]=cm[7] cmseltop[8]=cm[8] cmseltop[9]=cm[9]
 cmseltop[10]=cm[10] cmseltop[11]=cm[11] cmseltop[12]=cm[12] cmseltop[13]=cm[13] cmseltop[14]=cm[14] cmseltop[15]=cm[15] cmseltop[16]=cm[16]
 cmseltop[17]=cm[17] cmseltop[18]=cm[18] cmseltop[19]=cm[19] cmseltop[20]=cm[20] cmseltop[21]=cm[21] cmseltop[22]=cm[22] cmseltop[23]=cm[23]
 cmseltop[24]=cm[24] cmseltop[25]=cm[25] cmseltop[26]=cm[26] cmseltop[27]=cm[27] cmseltop[28]=cm[28] cmseltop[29]=cm[29] cmseltop[30]=cm[30]
 cmseltop[31]=cm[31] lblpchglfttop[0]=lblpchglft[0] lblpchglfttop[1]=lblpchglft[1] lblpchglfttop[2]=lblpchglft[2] lblpchglfttop[3]=lblpchglft[3] lblpchgrgttop[0]=lblpchgrgt[0] lblpchgrgttop[1]=lblpchgrgt[1]
 lblpchgrgttop[2]=lblpchgrgt[2] lblpchgrgttop[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_8=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[8]=odout pwren_ioctrl=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclktop=sdlclkin pwrenio_8=pwren_in
 rwltop[0]=rwlt[0] rwltop[1]=rwlt[1] rwltop[2]=rwlt[2] rwltop[3]=rwlt[3] rwltop[4]=rwlt[4] rwltop[5]=rwlt[5] rwltop[6]=rwlt[6]
 rwltop[7]=rwlt[7] rwltop[8]=rwlt[8] rwltop[9]=rwlt[9] rwltop[10]=rwlt[10] rwltop[11]=rwlt[11] rwltop[12]=rwlt[12] rwltop[13]=rwlt[13]
 rwltop[14]=rwlt[14] rwltop[15]=rwlt[15] rwltop[16]=rwlt[16] rwltop[17]=rwlt[17] rwltop[18]=rwlt[18] rwltop[19]=rwlt[19] rwltop[20]=rwlt[20]
 rwltop[21]=rwlt[21] rwltop[22]=rwlt[22] rwltop[23]=rwlt[23] rwltop[24]=rwlt[24] rwltop[25]=rwlt[25] rwltop[26]=rwlt[26] rwltop[27]=rwlt[27]
 rwltop[28]=rwlt[28] rwltop[29]=rwlt[29] rwltop[30]=rwlt[30] rwltop[31]=rwlt[31] rwltop[32]=rwlt[32] rwltop[33]=rwlt[33] rwltop[34]=rwlt[34]
 rwltop[35]=rwlt[35] rwltop[36]=rwlt[36] rwltop[37]=rwlt[37] rwltop[38]=rwlt[38] rwltop[39]=rwlt[39] rwltop[40]=rwlt[40] rwltop[41]=rwlt[41]
 rwltop[42]=rwlt[42] rwltop[43]=rwlt[43] rwltop[44]=rwlt[44] rwltop[45]=rwlt[45] rwltop[46]=rwlt[46] rwltop[47]=rwlt[47] rwltop[48]=rwlt[48]
 rwltop[49]=rwlt[49] rwltop[50]=rwlt[50] rwltop[51]=rwlt[51] rwltop[52]=rwlt[52] rwltop[53]=rwlt[53] rwltop[54]=rwlt[54] rwltop[55]=rwlt[55]
 rwltop[56]=rwlt[56] rwltop[57]=rwlt[57] rwltop[58]=rwlt[58] rwltop[59]=rwlt[59] rwltop[60]=rwlt[60] rwltop[61]=rwlt[61] rwltop[62]=rwlt[62]
 rwltop[63]=rwlt[63] rwltop[64]=rwlt[64] rwltop[65]=rwlt[65] rwltop[66]=rwlt[66] rwltop[67]=rwlt[67] rwltop[68]=rwlt[68] rwltop[69]=rwlt[69]
 rwltop[70]=rwlt[70] rwltop[71]=rwlt[71] rwltop[72]=rwlt[72] rwltop[73]=rwlt[73] rwltop[74]=rwlt[74] rwltop[75]=rwlt[75] rwltop[76]=rwlt[76]
 rwltop[77]=rwlt[77] rwltop[78]=rwlt[78] rwltop[79]=rwlt[79] rwltop[80]=rwlt[80] rwltop[81]=rwlt[81] rwltop[82]=rwlt[82] rwltop[83]=rwlt[83]
 rwltop[84]=rwlt[84] rwltop[85]=rwlt[85] rwltop[86]=rwlt[86] rwltop[87]=rwlt[87] rwltop[88]=rwlt[88] rwltop[89]=rwlt[89] rwltop[90]=rwlt[90]
 rwltop[91]=rwlt[91] rwltop[92]=rwlt[92] rwltop[93]=rwlt[93] rwltop[94]=rwlt[94] rwltop[95]=rwlt[95] rwltop[96]=rwlt[96] rwltop[97]=rwlt[97]
 rwltop[98]=rwlt[98] rwltop[99]=rwlt[99] rwltop[100]=rwlt[100] rwltop[101]=rwlt[101] rwltop[102]=rwlt[102] rwltop[103]=rwlt[103] rwltop[104]=rwlt[104]
 rwltop[105]=rwlt[105] rwltop[106]=rwlt[106] rwltop[107]=rwlt[107] rwltop[108]=rwlt[108] rwltop[109]=rwlt[109] rwltop[110]=rwlt[110] rwltop[111]=rwlt[111]
 rwltop[112]=rwlt[112] rwltop[113]=rwlt[113] rwltop[114]=rwlt[114] rwltop[115]=rwlt[115] rwltop[116]=rwlt[116] rwltop[117]=rwlt[117] rwltop[118]=rwlt[118]
 rwltop[119]=rwlt[119] rwltop[120]=rwlt[120] rwltop[121]=rwlt[121] rwltop[122]=rwlt[122] rwltop[123]=rwlt[123] rwltop[124]=rwlt[124] rwltop[125]=rwlt[125]
 rwltop[126]=rwlt[126] rwltop[127]=rwlt[127] rwltop[128]=rwlt[128] rwltop[129]=rwlt[129] rwltop[130]=rwlt[130] rwltop[131]=rwlt[131] rwltop[132]=rwlt[132]
 rwltop[133]=rwlt[133] rwltop[134]=rwlt[134] rwltop[135]=rwlt[135] rwltop[136]=rwlt[136] rwltop[137]=rwlt[137] rwltop[138]=rwlt[138] rwltop[139]=rwlt[139]
 rwltop[140]=rwlt[140] rwltop[141]=rwlt[141] rwltop[142]=rwlt[142] rwltop[143]=rwlt[143] rwltop[144]=rwlt[144] rwltop[145]=rwlt[145] rwltop[146]=rwlt[146]
 rwltop[147]=rwlt[147] rwltop[148]=rwlt[148] rwltop[149]=rwlt[149] rwltop[150]=rwlt[150] rwltop[151]=rwlt[151] rwltop[152]=rwlt[152] rwltop[153]=rwlt[153]
 rwltop[154]=rwlt[154] rwltop[155]=rwlt[155] rwltop[156]=rwlt[156] rwltop[157]=rwlt[157] rwltop[158]=rwlt[158] rwltop[159]=rwlt[159] rwltop[160]=rwlt[160]
 rwltop[161]=rwlt[161] rwltop[162]=rwlt[162] rwltop[163]=rwlt[163] rwltop[164]=rwlt[164] rwltop[165]=rwlt[165] rwltop[166]=rwlt[166] rwltop[167]=rwlt[167]
 rwltop[168]=rwlt[168] rwltop[169]=rwlt[169] rwltop[170]=rwlt[170] rwltop[171]=rwlt[171] rwltop[172]=rwlt[172] rwltop[173]=rwlt[173] rwltop[174]=rwlt[174]
 rwltop[175]=rwlt[175] rwltop[176]=rwlt[176] rwltop[177]=rwlt[177] rwltop[178]=rwlt[178] rwltop[179]=rwlt[179] rwltop[180]=rwlt[180] rwltop[181]=rwlt[181]
 rwltop[182]=rwlt[182] rwltop[183]=rwlt[183] rwltop[184]=rwlt[184] rwltop[185]=rwlt[185] rwltop[186]=rwlt[186] rwltop[187]=rwlt[187] rwltop[188]=rwlt[188]
 rwltop[189]=rwlt[189] rwltop[190]=rwlt[190] rwltop[191]=rwlt[191] rwltop[192]=rwlt[192] rwltop[193]=rwlt[193] rwltop[194]=rwlt[194] rwltop[195]=rwlt[195]
 rwltop[196]=rwlt[196] rwltop[197]=rwlt[197] rwltop[198]=rwlt[198] rwltop[199]=rwlt[199] rwltop[200]=rwlt[200] rwltop[201]=rwlt[201] rwltop[202]=rwlt[202]
 rwltop[203]=rwlt[203] rwltop[204]=rwlt[204] rwltop[205]=rwlt[205] rwltop[206]=rwlt[206] rwltop[207]=rwlt[207] rwltop[208]=rwlt[208] rwltop[209]=rwlt[209]
 rwltop[210]=rwlt[210] rwltop[211]=rwlt[211] rwltop[212]=rwlt[212] rwltop[213]=rwlt[213] rwltop[214]=rwlt[214] rwltop[215]=rwlt[215] rwltop[216]=rwlt[216]
 rwltop[217]=rwlt[217] rwltop[218]=rwlt[218] rwltop[219]=rwlt[219] rwltop[220]=rwlt[220] rwltop[221]=rwlt[221] rwltop[222]=rwlt[222] rwltop[223]=rwlt[223]
 rwltop[224]=rwlt[224] rwltop[225]=rwlt[225] rwltop[226]=rwlt[226] rwltop[227]=rwlt[227] rwltop[228]=rwlt[228] rwltop[229]=rwlt[229] rwltop[230]=rwlt[230]
 rwltop[231]=rwlt[231] rwltop[232]=rwlt[232] rwltop[233]=rwlt[233] rwltop[234]=rwlt[234] rwltop[235]=rwlt[235] rwltop[236]=rwlt[236] rwltop[237]=rwlt[237]
 rwltop[238]=rwlt[238] rwltop[239]=rwlt[239] rwltop[240]=rwlt[240] rwltop[241]=rwlt[241] rwltop[242]=rwlt[242] rwltop[243]=rwlt[243] rwltop[244]=rwlt[244]
 rwltop[245]=rwlt[245] rwltop[246]=rwlt[246] rwltop[247]=rwlt[247] rwltop[248]=rwlt[248] rwltop[249]=rwlt[249] rwltop[250]=rwlt[250] rwltop[251]=rwlt[251]
 rwltop[252]=rwlt[252] rwltop[253]=rwlt[253] rwltop[254]=rwlt[254] rwltop[255]=rwlt[255] cmseltop[0]=cm[0] cmseltop[1]=cm[1] cmseltop[2]=cm[2]
 cmseltop[3]=cm[3] cmseltop[4]=cm[4] cmseltop[5]=cm[5] cmseltop[6]=cm[6] cmseltop[7]=cm[7] cmseltop[8]=cm[8] cmseltop[9]=cm[9]
 cmseltop[10]=cm[10] cmseltop[11]=cm[11] cmseltop[12]=cm[12] cmseltop[13]=cm[13] cmseltop[14]=cm[14] cmseltop[15]=cm[15] cmseltop[16]=cm[16]
 cmseltop[17]=cm[17] cmseltop[18]=cm[18] cmseltop[19]=cm[19] cmseltop[20]=cm[20] cmseltop[21]=cm[21] cmseltop[22]=cm[22] cmseltop[23]=cm[23]
 cmseltop[24]=cm[24] cmseltop[25]=cm[25] cmseltop[26]=cm[26] cmseltop[27]=cm[27] cmseltop[28]=cm[28] cmseltop[29]=cm[29] cmseltop[30]=cm[30]
 cmseltop[31]=cm[31] lblpchglfttop[0]=lblpchglft[0] lblpchglfttop[1]=lblpchglft[1] lblpchglfttop[2]=lblpchglft[2] lblpchglfttop[3]=lblpchglft[3] lblpchgrgttop[0]=lblpchgrgt[0] lblpchgrgttop[1]=lblpchgrgt[1]
 lblpchgrgttop[2]=lblpchgrgt[2] lblpchgrgttop[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_7=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[7]=odout pwrenio_6=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclkbot=sdlclkin pwren_ctrlio=pwren_in
 rwlbot[0]=rwlt[0] rwlbot[1]=rwlt[1] rwlbot[2]=rwlt[2] rwlbot[3]=rwlt[3] rwlbot[4]=rwlt[4] rwlbot[5]=rwlt[5] rwlbot[6]=rwlt[6]
 rwlbot[7]=rwlt[7] rwlbot[8]=rwlt[8] rwlbot[9]=rwlt[9] rwlbot[10]=rwlt[10] rwlbot[11]=rwlt[11] rwlbot[12]=rwlt[12] rwlbot[13]=rwlt[13]
 rwlbot[14]=rwlt[14] rwlbot[15]=rwlt[15] rwlbot[16]=rwlt[16] rwlbot[17]=rwlt[17] rwlbot[18]=rwlt[18] rwlbot[19]=rwlt[19] rwlbot[20]=rwlt[20]
 rwlbot[21]=rwlt[21] rwlbot[22]=rwlt[22] rwlbot[23]=rwlt[23] rwlbot[24]=rwlt[24] rwlbot[25]=rwlt[25] rwlbot[26]=rwlt[26] rwlbot[27]=rwlt[27]
 rwlbot[28]=rwlt[28] rwlbot[29]=rwlt[29] rwlbot[30]=rwlt[30] rwlbot[31]=rwlt[31] rwlbot[32]=rwlt[32] rwlbot[33]=rwlt[33] rwlbot[34]=rwlt[34]
 rwlbot[35]=rwlt[35] rwlbot[36]=rwlt[36] rwlbot[37]=rwlt[37] rwlbot[38]=rwlt[38] rwlbot[39]=rwlt[39] rwlbot[40]=rwlt[40] rwlbot[41]=rwlt[41]
 rwlbot[42]=rwlt[42] rwlbot[43]=rwlt[43] rwlbot[44]=rwlt[44] rwlbot[45]=rwlt[45] rwlbot[46]=rwlt[46] rwlbot[47]=rwlt[47] rwlbot[48]=rwlt[48]
 rwlbot[49]=rwlt[49] rwlbot[50]=rwlt[50] rwlbot[51]=rwlt[51] rwlbot[52]=rwlt[52] rwlbot[53]=rwlt[53] rwlbot[54]=rwlt[54] rwlbot[55]=rwlt[55]
 rwlbot[56]=rwlt[56] rwlbot[57]=rwlt[57] rwlbot[58]=rwlt[58] rwlbot[59]=rwlt[59] rwlbot[60]=rwlt[60] rwlbot[61]=rwlt[61] rwlbot[62]=rwlt[62]
 rwlbot[63]=rwlt[63] rwlbot[64]=rwlt[64] rwlbot[65]=rwlt[65] rwlbot[66]=rwlt[66] rwlbot[67]=rwlt[67] rwlbot[68]=rwlt[68] rwlbot[69]=rwlt[69]
 rwlbot[70]=rwlt[70] rwlbot[71]=rwlt[71] rwlbot[72]=rwlt[72] rwlbot[73]=rwlt[73] rwlbot[74]=rwlt[74] rwlbot[75]=rwlt[75] rwlbot[76]=rwlt[76]
 rwlbot[77]=rwlt[77] rwlbot[78]=rwlt[78] rwlbot[79]=rwlt[79] rwlbot[80]=rwlt[80] rwlbot[81]=rwlt[81] rwlbot[82]=rwlt[82] rwlbot[83]=rwlt[83]
 rwlbot[84]=rwlt[84] rwlbot[85]=rwlt[85] rwlbot[86]=rwlt[86] rwlbot[87]=rwlt[87] rwlbot[88]=rwlt[88] rwlbot[89]=rwlt[89] rwlbot[90]=rwlt[90]
 rwlbot[91]=rwlt[91] rwlbot[92]=rwlt[92] rwlbot[93]=rwlt[93] rwlbot[94]=rwlt[94] rwlbot[95]=rwlt[95] rwlbot[96]=rwlt[96] rwlbot[97]=rwlt[97]
 rwlbot[98]=rwlt[98] rwlbot[99]=rwlt[99] rwlbot[100]=rwlt[100] rwlbot[101]=rwlt[101] rwlbot[102]=rwlt[102] rwlbot[103]=rwlt[103] rwlbot[104]=rwlt[104]
 rwlbot[105]=rwlt[105] rwlbot[106]=rwlt[106] rwlbot[107]=rwlt[107] rwlbot[108]=rwlt[108] rwlbot[109]=rwlt[109] rwlbot[110]=rwlt[110] rwlbot[111]=rwlt[111]
 rwlbot[112]=rwlt[112] rwlbot[113]=rwlt[113] rwlbot[114]=rwlt[114] rwlbot[115]=rwlt[115] rwlbot[116]=rwlt[116] rwlbot[117]=rwlt[117] rwlbot[118]=rwlt[118]
 rwlbot[119]=rwlt[119] rwlbot[120]=rwlt[120] rwlbot[121]=rwlt[121] rwlbot[122]=rwlt[122] rwlbot[123]=rwlt[123] rwlbot[124]=rwlt[124] rwlbot[125]=rwlt[125]
 rwlbot[126]=rwlt[126] rwlbot[127]=rwlt[127] rwlbot[128]=rwlt[128] rwlbot[129]=rwlt[129] rwlbot[130]=rwlt[130] rwlbot[131]=rwlt[131] rwlbot[132]=rwlt[132]
 rwlbot[133]=rwlt[133] rwlbot[134]=rwlt[134] rwlbot[135]=rwlt[135] rwlbot[136]=rwlt[136] rwlbot[137]=rwlt[137] rwlbot[138]=rwlt[138] rwlbot[139]=rwlt[139]
 rwlbot[140]=rwlt[140] rwlbot[141]=rwlt[141] rwlbot[142]=rwlt[142] rwlbot[143]=rwlt[143] rwlbot[144]=rwlt[144] rwlbot[145]=rwlt[145] rwlbot[146]=rwlt[146]
 rwlbot[147]=rwlt[147] rwlbot[148]=rwlt[148] rwlbot[149]=rwlt[149] rwlbot[150]=rwlt[150] rwlbot[151]=rwlt[151] rwlbot[152]=rwlt[152] rwlbot[153]=rwlt[153]
 rwlbot[154]=rwlt[154] rwlbot[155]=rwlt[155] rwlbot[156]=rwlt[156] rwlbot[157]=rwlt[157] rwlbot[158]=rwlt[158] rwlbot[159]=rwlt[159] rwlbot[160]=rwlt[160]
 rwlbot[161]=rwlt[161] rwlbot[162]=rwlt[162] rwlbot[163]=rwlt[163] rwlbot[164]=rwlt[164] rwlbot[165]=rwlt[165] rwlbot[166]=rwlt[166] rwlbot[167]=rwlt[167]
 rwlbot[168]=rwlt[168] rwlbot[169]=rwlt[169] rwlbot[170]=rwlt[170] rwlbot[171]=rwlt[171] rwlbot[172]=rwlt[172] rwlbot[173]=rwlt[173] rwlbot[174]=rwlt[174]
 rwlbot[175]=rwlt[175] rwlbot[176]=rwlt[176] rwlbot[177]=rwlt[177] rwlbot[178]=rwlt[178] rwlbot[179]=rwlt[179] rwlbot[180]=rwlt[180] rwlbot[181]=rwlt[181]
 rwlbot[182]=rwlt[182] rwlbot[183]=rwlt[183] rwlbot[184]=rwlt[184] rwlbot[185]=rwlt[185] rwlbot[186]=rwlt[186] rwlbot[187]=rwlt[187] rwlbot[188]=rwlt[188]
 rwlbot[189]=rwlt[189] rwlbot[190]=rwlt[190] rwlbot[191]=rwlt[191] rwlbot[192]=rwlt[192] rwlbot[193]=rwlt[193] rwlbot[194]=rwlt[194] rwlbot[195]=rwlt[195]
 rwlbot[196]=rwlt[196] rwlbot[197]=rwlt[197] rwlbot[198]=rwlt[198] rwlbot[199]=rwlt[199] rwlbot[200]=rwlt[200] rwlbot[201]=rwlt[201] rwlbot[202]=rwlt[202]
 rwlbot[203]=rwlt[203] rwlbot[204]=rwlt[204] rwlbot[205]=rwlt[205] rwlbot[206]=rwlt[206] rwlbot[207]=rwlt[207] rwlbot[208]=rwlt[208] rwlbot[209]=rwlt[209]
 rwlbot[210]=rwlt[210] rwlbot[211]=rwlt[211] rwlbot[212]=rwlt[212] rwlbot[213]=rwlt[213] rwlbot[214]=rwlt[214] rwlbot[215]=rwlt[215] rwlbot[216]=rwlt[216]
 rwlbot[217]=rwlt[217] rwlbot[218]=rwlt[218] rwlbot[219]=rwlt[219] rwlbot[220]=rwlt[220] rwlbot[221]=rwlt[221] rwlbot[222]=rwlt[222] rwlbot[223]=rwlt[223]
 rwlbot[224]=rwlt[224] rwlbot[225]=rwlt[225] rwlbot[226]=rwlt[226] rwlbot[227]=rwlt[227] rwlbot[228]=rwlt[228] rwlbot[229]=rwlt[229] rwlbot[230]=rwlt[230]
 rwlbot[231]=rwlt[231] rwlbot[232]=rwlt[232] rwlbot[233]=rwlt[233] rwlbot[234]=rwlt[234] rwlbot[235]=rwlt[235] rwlbot[236]=rwlt[236] rwlbot[237]=rwlt[237]
 rwlbot[238]=rwlt[238] rwlbot[239]=rwlt[239] rwlbot[240]=rwlt[240] rwlbot[241]=rwlt[241] rwlbot[242]=rwlt[242] rwlbot[243]=rwlt[243] rwlbot[244]=rwlt[244]
 rwlbot[245]=rwlt[245] rwlbot[246]=rwlt[246] rwlbot[247]=rwlt[247] rwlbot[248]=rwlt[248] rwlbot[249]=rwlt[249] rwlbot[250]=rwlt[250] rwlbot[251]=rwlt[251]
 rwlbot[252]=rwlt[252] rwlbot[253]=rwlt[253] rwlbot[254]=rwlt[254] rwlbot[255]=rwlt[255] cmselbot[0]=cm[0] cmselbot[1]=cm[1] cmselbot[2]=cm[2]
 cmselbot[3]=cm[3] cmselbot[4]=cm[4] cmselbot[5]=cm[5] cmselbot[6]=cm[6] cmselbot[7]=cm[7] cmselbot[8]=cm[8] cmselbot[9]=cm[9]
 cmselbot[10]=cm[10] cmselbot[11]=cm[11] cmselbot[12]=cm[12] cmselbot[13]=cm[13] cmselbot[14]=cm[14] cmselbot[15]=cm[15] cmselbot[16]=cm[16]
 cmselbot[17]=cm[17] cmselbot[18]=cm[18] cmselbot[19]=cm[19] cmselbot[20]=cm[20] cmselbot[21]=cm[21] cmselbot[22]=cm[22] cmselbot[23]=cm[23]
 cmselbot[24]=cm[24] cmselbot[25]=cm[25] cmselbot[26]=cm[26] cmselbot[27]=cm[27] cmselbot[28]=cm[28] cmselbot[29]=cm[29] cmselbot[30]=cm[30]
 cmselbot[31]=cm[31] lblpchglftbot[0]=lblpchglft[0] lblpchglftbot[1]=lblpchglft[1] lblpchglftbot[2]=lblpchglft[2] lblpchglftbot[3]=lblpchglft[3] lblpchgrgtbot[0]=lblpchgrgt[0] lblpchgrgtbot[1]=lblpchgrgt[1]
 lblpchgrgtbot[2]=lblpchgrgt[2] lblpchgrgtbot[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_6=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[6]=odout pwrenio_5=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclkbot=sdlclkin pwrenio_6=pwren_in
 rwlbot[0]=rwlt[0] rwlbot[1]=rwlt[1] rwlbot[2]=rwlt[2] rwlbot[3]=rwlt[3] rwlbot[4]=rwlt[4] rwlbot[5]=rwlt[5] rwlbot[6]=rwlt[6]
 rwlbot[7]=rwlt[7] rwlbot[8]=rwlt[8] rwlbot[9]=rwlt[9] rwlbot[10]=rwlt[10] rwlbot[11]=rwlt[11] rwlbot[12]=rwlt[12] rwlbot[13]=rwlt[13]
 rwlbot[14]=rwlt[14] rwlbot[15]=rwlt[15] rwlbot[16]=rwlt[16] rwlbot[17]=rwlt[17] rwlbot[18]=rwlt[18] rwlbot[19]=rwlt[19] rwlbot[20]=rwlt[20]
 rwlbot[21]=rwlt[21] rwlbot[22]=rwlt[22] rwlbot[23]=rwlt[23] rwlbot[24]=rwlt[24] rwlbot[25]=rwlt[25] rwlbot[26]=rwlt[26] rwlbot[27]=rwlt[27]
 rwlbot[28]=rwlt[28] rwlbot[29]=rwlt[29] rwlbot[30]=rwlt[30] rwlbot[31]=rwlt[31] rwlbot[32]=rwlt[32] rwlbot[33]=rwlt[33] rwlbot[34]=rwlt[34]
 rwlbot[35]=rwlt[35] rwlbot[36]=rwlt[36] rwlbot[37]=rwlt[37] rwlbot[38]=rwlt[38] rwlbot[39]=rwlt[39] rwlbot[40]=rwlt[40] rwlbot[41]=rwlt[41]
 rwlbot[42]=rwlt[42] rwlbot[43]=rwlt[43] rwlbot[44]=rwlt[44] rwlbot[45]=rwlt[45] rwlbot[46]=rwlt[46] rwlbot[47]=rwlt[47] rwlbot[48]=rwlt[48]
 rwlbot[49]=rwlt[49] rwlbot[50]=rwlt[50] rwlbot[51]=rwlt[51] rwlbot[52]=rwlt[52] rwlbot[53]=rwlt[53] rwlbot[54]=rwlt[54] rwlbot[55]=rwlt[55]
 rwlbot[56]=rwlt[56] rwlbot[57]=rwlt[57] rwlbot[58]=rwlt[58] rwlbot[59]=rwlt[59] rwlbot[60]=rwlt[60] rwlbot[61]=rwlt[61] rwlbot[62]=rwlt[62]
 rwlbot[63]=rwlt[63] rwlbot[64]=rwlt[64] rwlbot[65]=rwlt[65] rwlbot[66]=rwlt[66] rwlbot[67]=rwlt[67] rwlbot[68]=rwlt[68] rwlbot[69]=rwlt[69]
 rwlbot[70]=rwlt[70] rwlbot[71]=rwlt[71] rwlbot[72]=rwlt[72] rwlbot[73]=rwlt[73] rwlbot[74]=rwlt[74] rwlbot[75]=rwlt[75] rwlbot[76]=rwlt[76]
 rwlbot[77]=rwlt[77] rwlbot[78]=rwlt[78] rwlbot[79]=rwlt[79] rwlbot[80]=rwlt[80] rwlbot[81]=rwlt[81] rwlbot[82]=rwlt[82] rwlbot[83]=rwlt[83]
 rwlbot[84]=rwlt[84] rwlbot[85]=rwlt[85] rwlbot[86]=rwlt[86] rwlbot[87]=rwlt[87] rwlbot[88]=rwlt[88] rwlbot[89]=rwlt[89] rwlbot[90]=rwlt[90]
 rwlbot[91]=rwlt[91] rwlbot[92]=rwlt[92] rwlbot[93]=rwlt[93] rwlbot[94]=rwlt[94] rwlbot[95]=rwlt[95] rwlbot[96]=rwlt[96] rwlbot[97]=rwlt[97]
 rwlbot[98]=rwlt[98] rwlbot[99]=rwlt[99] rwlbot[100]=rwlt[100] rwlbot[101]=rwlt[101] rwlbot[102]=rwlt[102] rwlbot[103]=rwlt[103] rwlbot[104]=rwlt[104]
 rwlbot[105]=rwlt[105] rwlbot[106]=rwlt[106] rwlbot[107]=rwlt[107] rwlbot[108]=rwlt[108] rwlbot[109]=rwlt[109] rwlbot[110]=rwlt[110] rwlbot[111]=rwlt[111]
 rwlbot[112]=rwlt[112] rwlbot[113]=rwlt[113] rwlbot[114]=rwlt[114] rwlbot[115]=rwlt[115] rwlbot[116]=rwlt[116] rwlbot[117]=rwlt[117] rwlbot[118]=rwlt[118]
 rwlbot[119]=rwlt[119] rwlbot[120]=rwlt[120] rwlbot[121]=rwlt[121] rwlbot[122]=rwlt[122] rwlbot[123]=rwlt[123] rwlbot[124]=rwlt[124] rwlbot[125]=rwlt[125]
 rwlbot[126]=rwlt[126] rwlbot[127]=rwlt[127] rwlbot[128]=rwlt[128] rwlbot[129]=rwlt[129] rwlbot[130]=rwlt[130] rwlbot[131]=rwlt[131] rwlbot[132]=rwlt[132]
 rwlbot[133]=rwlt[133] rwlbot[134]=rwlt[134] rwlbot[135]=rwlt[135] rwlbot[136]=rwlt[136] rwlbot[137]=rwlt[137] rwlbot[138]=rwlt[138] rwlbot[139]=rwlt[139]
 rwlbot[140]=rwlt[140] rwlbot[141]=rwlt[141] rwlbot[142]=rwlt[142] rwlbot[143]=rwlt[143] rwlbot[144]=rwlt[144] rwlbot[145]=rwlt[145] rwlbot[146]=rwlt[146]
 rwlbot[147]=rwlt[147] rwlbot[148]=rwlt[148] rwlbot[149]=rwlt[149] rwlbot[150]=rwlt[150] rwlbot[151]=rwlt[151] rwlbot[152]=rwlt[152] rwlbot[153]=rwlt[153]
 rwlbot[154]=rwlt[154] rwlbot[155]=rwlt[155] rwlbot[156]=rwlt[156] rwlbot[157]=rwlt[157] rwlbot[158]=rwlt[158] rwlbot[159]=rwlt[159] rwlbot[160]=rwlt[160]
 rwlbot[161]=rwlt[161] rwlbot[162]=rwlt[162] rwlbot[163]=rwlt[163] rwlbot[164]=rwlt[164] rwlbot[165]=rwlt[165] rwlbot[166]=rwlt[166] rwlbot[167]=rwlt[167]
 rwlbot[168]=rwlt[168] rwlbot[169]=rwlt[169] rwlbot[170]=rwlt[170] rwlbot[171]=rwlt[171] rwlbot[172]=rwlt[172] rwlbot[173]=rwlt[173] rwlbot[174]=rwlt[174]
 rwlbot[175]=rwlt[175] rwlbot[176]=rwlt[176] rwlbot[177]=rwlt[177] rwlbot[178]=rwlt[178] rwlbot[179]=rwlt[179] rwlbot[180]=rwlt[180] rwlbot[181]=rwlt[181]
 rwlbot[182]=rwlt[182] rwlbot[183]=rwlt[183] rwlbot[184]=rwlt[184] rwlbot[185]=rwlt[185] rwlbot[186]=rwlt[186] rwlbot[187]=rwlt[187] rwlbot[188]=rwlt[188]
 rwlbot[189]=rwlt[189] rwlbot[190]=rwlt[190] rwlbot[191]=rwlt[191] rwlbot[192]=rwlt[192] rwlbot[193]=rwlt[193] rwlbot[194]=rwlt[194] rwlbot[195]=rwlt[195]
 rwlbot[196]=rwlt[196] rwlbot[197]=rwlt[197] rwlbot[198]=rwlt[198] rwlbot[199]=rwlt[199] rwlbot[200]=rwlt[200] rwlbot[201]=rwlt[201] rwlbot[202]=rwlt[202]
 rwlbot[203]=rwlt[203] rwlbot[204]=rwlt[204] rwlbot[205]=rwlt[205] rwlbot[206]=rwlt[206] rwlbot[207]=rwlt[207] rwlbot[208]=rwlt[208] rwlbot[209]=rwlt[209]
 rwlbot[210]=rwlt[210] rwlbot[211]=rwlt[211] rwlbot[212]=rwlt[212] rwlbot[213]=rwlt[213] rwlbot[214]=rwlt[214] rwlbot[215]=rwlt[215] rwlbot[216]=rwlt[216]
 rwlbot[217]=rwlt[217] rwlbot[218]=rwlt[218] rwlbot[219]=rwlt[219] rwlbot[220]=rwlt[220] rwlbot[221]=rwlt[221] rwlbot[222]=rwlt[222] rwlbot[223]=rwlt[223]
 rwlbot[224]=rwlt[224] rwlbot[225]=rwlt[225] rwlbot[226]=rwlt[226] rwlbot[227]=rwlt[227] rwlbot[228]=rwlt[228] rwlbot[229]=rwlt[229] rwlbot[230]=rwlt[230]
 rwlbot[231]=rwlt[231] rwlbot[232]=rwlt[232] rwlbot[233]=rwlt[233] rwlbot[234]=rwlt[234] rwlbot[235]=rwlt[235] rwlbot[236]=rwlt[236] rwlbot[237]=rwlt[237]
 rwlbot[238]=rwlt[238] rwlbot[239]=rwlt[239] rwlbot[240]=rwlt[240] rwlbot[241]=rwlt[241] rwlbot[242]=rwlt[242] rwlbot[243]=rwlt[243] rwlbot[244]=rwlt[244]
 rwlbot[245]=rwlt[245] rwlbot[246]=rwlt[246] rwlbot[247]=rwlt[247] rwlbot[248]=rwlt[248] rwlbot[249]=rwlt[249] rwlbot[250]=rwlt[250] rwlbot[251]=rwlt[251]
 rwlbot[252]=rwlt[252] rwlbot[253]=rwlt[253] rwlbot[254]=rwlt[254] rwlbot[255]=rwlt[255] cmselbot[0]=cm[0] cmselbot[1]=cm[1] cmselbot[2]=cm[2]
 cmselbot[3]=cm[3] cmselbot[4]=cm[4] cmselbot[5]=cm[5] cmselbot[6]=cm[6] cmselbot[7]=cm[7] cmselbot[8]=cm[8] cmselbot[9]=cm[9]
 cmselbot[10]=cm[10] cmselbot[11]=cm[11] cmselbot[12]=cm[12] cmselbot[13]=cm[13] cmselbot[14]=cm[14] cmselbot[15]=cm[15] cmselbot[16]=cm[16]
 cmselbot[17]=cm[17] cmselbot[18]=cm[18] cmselbot[19]=cm[19] cmselbot[20]=cm[20] cmselbot[21]=cm[21] cmselbot[22]=cm[22] cmselbot[23]=cm[23]
 cmselbot[24]=cm[24] cmselbot[25]=cm[25] cmselbot[26]=cm[26] cmselbot[27]=cm[27] cmselbot[28]=cm[28] cmselbot[29]=cm[29] cmselbot[30]=cm[30]
 cmselbot[31]=cm[31] lblpchglftbot[0]=lblpchglft[0] lblpchglftbot[1]=lblpchglft[1] lblpchglftbot[2]=lblpchglft[2] lblpchglftbot[3]=lblpchglft[3] lblpchgrgtbot[0]=lblpchgrgt[0] lblpchgrgtbot[1]=lblpchgrgt[1]
 lblpchgrgtbot[2]=lblpchgrgt[2] lblpchgrgtbot[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_5=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[5]=odout pwrenio_4=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclkbot=sdlclkin pwrenio_5=pwren_in
 rwlbot[0]=rwlt[0] rwlbot[1]=rwlt[1] rwlbot[2]=rwlt[2] rwlbot[3]=rwlt[3] rwlbot[4]=rwlt[4] rwlbot[5]=rwlt[5] rwlbot[6]=rwlt[6]
 rwlbot[7]=rwlt[7] rwlbot[8]=rwlt[8] rwlbot[9]=rwlt[9] rwlbot[10]=rwlt[10] rwlbot[11]=rwlt[11] rwlbot[12]=rwlt[12] rwlbot[13]=rwlt[13]
 rwlbot[14]=rwlt[14] rwlbot[15]=rwlt[15] rwlbot[16]=rwlt[16] rwlbot[17]=rwlt[17] rwlbot[18]=rwlt[18] rwlbot[19]=rwlt[19] rwlbot[20]=rwlt[20]
 rwlbot[21]=rwlt[21] rwlbot[22]=rwlt[22] rwlbot[23]=rwlt[23] rwlbot[24]=rwlt[24] rwlbot[25]=rwlt[25] rwlbot[26]=rwlt[26] rwlbot[27]=rwlt[27]
 rwlbot[28]=rwlt[28] rwlbot[29]=rwlt[29] rwlbot[30]=rwlt[30] rwlbot[31]=rwlt[31] rwlbot[32]=rwlt[32] rwlbot[33]=rwlt[33] rwlbot[34]=rwlt[34]
 rwlbot[35]=rwlt[35] rwlbot[36]=rwlt[36] rwlbot[37]=rwlt[37] rwlbot[38]=rwlt[38] rwlbot[39]=rwlt[39] rwlbot[40]=rwlt[40] rwlbot[41]=rwlt[41]
 rwlbot[42]=rwlt[42] rwlbot[43]=rwlt[43] rwlbot[44]=rwlt[44] rwlbot[45]=rwlt[45] rwlbot[46]=rwlt[46] rwlbot[47]=rwlt[47] rwlbot[48]=rwlt[48]
 rwlbot[49]=rwlt[49] rwlbot[50]=rwlt[50] rwlbot[51]=rwlt[51] rwlbot[52]=rwlt[52] rwlbot[53]=rwlt[53] rwlbot[54]=rwlt[54] rwlbot[55]=rwlt[55]
 rwlbot[56]=rwlt[56] rwlbot[57]=rwlt[57] rwlbot[58]=rwlt[58] rwlbot[59]=rwlt[59] rwlbot[60]=rwlt[60] rwlbot[61]=rwlt[61] rwlbot[62]=rwlt[62]
 rwlbot[63]=rwlt[63] rwlbot[64]=rwlt[64] rwlbot[65]=rwlt[65] rwlbot[66]=rwlt[66] rwlbot[67]=rwlt[67] rwlbot[68]=rwlt[68] rwlbot[69]=rwlt[69]
 rwlbot[70]=rwlt[70] rwlbot[71]=rwlt[71] rwlbot[72]=rwlt[72] rwlbot[73]=rwlt[73] rwlbot[74]=rwlt[74] rwlbot[75]=rwlt[75] rwlbot[76]=rwlt[76]
 rwlbot[77]=rwlt[77] rwlbot[78]=rwlt[78] rwlbot[79]=rwlt[79] rwlbot[80]=rwlt[80] rwlbot[81]=rwlt[81] rwlbot[82]=rwlt[82] rwlbot[83]=rwlt[83]
 rwlbot[84]=rwlt[84] rwlbot[85]=rwlt[85] rwlbot[86]=rwlt[86] rwlbot[87]=rwlt[87] rwlbot[88]=rwlt[88] rwlbot[89]=rwlt[89] rwlbot[90]=rwlt[90]
 rwlbot[91]=rwlt[91] rwlbot[92]=rwlt[92] rwlbot[93]=rwlt[93] rwlbot[94]=rwlt[94] rwlbot[95]=rwlt[95] rwlbot[96]=rwlt[96] rwlbot[97]=rwlt[97]
 rwlbot[98]=rwlt[98] rwlbot[99]=rwlt[99] rwlbot[100]=rwlt[100] rwlbot[101]=rwlt[101] rwlbot[102]=rwlt[102] rwlbot[103]=rwlt[103] rwlbot[104]=rwlt[104]
 rwlbot[105]=rwlt[105] rwlbot[106]=rwlt[106] rwlbot[107]=rwlt[107] rwlbot[108]=rwlt[108] rwlbot[109]=rwlt[109] rwlbot[110]=rwlt[110] rwlbot[111]=rwlt[111]
 rwlbot[112]=rwlt[112] rwlbot[113]=rwlt[113] rwlbot[114]=rwlt[114] rwlbot[115]=rwlt[115] rwlbot[116]=rwlt[116] rwlbot[117]=rwlt[117] rwlbot[118]=rwlt[118]
 rwlbot[119]=rwlt[119] rwlbot[120]=rwlt[120] rwlbot[121]=rwlt[121] rwlbot[122]=rwlt[122] rwlbot[123]=rwlt[123] rwlbot[124]=rwlt[124] rwlbot[125]=rwlt[125]
 rwlbot[126]=rwlt[126] rwlbot[127]=rwlt[127] rwlbot[128]=rwlt[128] rwlbot[129]=rwlt[129] rwlbot[130]=rwlt[130] rwlbot[131]=rwlt[131] rwlbot[132]=rwlt[132]
 rwlbot[133]=rwlt[133] rwlbot[134]=rwlt[134] rwlbot[135]=rwlt[135] rwlbot[136]=rwlt[136] rwlbot[137]=rwlt[137] rwlbot[138]=rwlt[138] rwlbot[139]=rwlt[139]
 rwlbot[140]=rwlt[140] rwlbot[141]=rwlt[141] rwlbot[142]=rwlt[142] rwlbot[143]=rwlt[143] rwlbot[144]=rwlt[144] rwlbot[145]=rwlt[145] rwlbot[146]=rwlt[146]
 rwlbot[147]=rwlt[147] rwlbot[148]=rwlt[148] rwlbot[149]=rwlt[149] rwlbot[150]=rwlt[150] rwlbot[151]=rwlt[151] rwlbot[152]=rwlt[152] rwlbot[153]=rwlt[153]
 rwlbot[154]=rwlt[154] rwlbot[155]=rwlt[155] rwlbot[156]=rwlt[156] rwlbot[157]=rwlt[157] rwlbot[158]=rwlt[158] rwlbot[159]=rwlt[159] rwlbot[160]=rwlt[160]
 rwlbot[161]=rwlt[161] rwlbot[162]=rwlt[162] rwlbot[163]=rwlt[163] rwlbot[164]=rwlt[164] rwlbot[165]=rwlt[165] rwlbot[166]=rwlt[166] rwlbot[167]=rwlt[167]
 rwlbot[168]=rwlt[168] rwlbot[169]=rwlt[169] rwlbot[170]=rwlt[170] rwlbot[171]=rwlt[171] rwlbot[172]=rwlt[172] rwlbot[173]=rwlt[173] rwlbot[174]=rwlt[174]
 rwlbot[175]=rwlt[175] rwlbot[176]=rwlt[176] rwlbot[177]=rwlt[177] rwlbot[178]=rwlt[178] rwlbot[179]=rwlt[179] rwlbot[180]=rwlt[180] rwlbot[181]=rwlt[181]
 rwlbot[182]=rwlt[182] rwlbot[183]=rwlt[183] rwlbot[184]=rwlt[184] rwlbot[185]=rwlt[185] rwlbot[186]=rwlt[186] rwlbot[187]=rwlt[187] rwlbot[188]=rwlt[188]
 rwlbot[189]=rwlt[189] rwlbot[190]=rwlt[190] rwlbot[191]=rwlt[191] rwlbot[192]=rwlt[192] rwlbot[193]=rwlt[193] rwlbot[194]=rwlt[194] rwlbot[195]=rwlt[195]
 rwlbot[196]=rwlt[196] rwlbot[197]=rwlt[197] rwlbot[198]=rwlt[198] rwlbot[199]=rwlt[199] rwlbot[200]=rwlt[200] rwlbot[201]=rwlt[201] rwlbot[202]=rwlt[202]
 rwlbot[203]=rwlt[203] rwlbot[204]=rwlt[204] rwlbot[205]=rwlt[205] rwlbot[206]=rwlt[206] rwlbot[207]=rwlt[207] rwlbot[208]=rwlt[208] rwlbot[209]=rwlt[209]
 rwlbot[210]=rwlt[210] rwlbot[211]=rwlt[211] rwlbot[212]=rwlt[212] rwlbot[213]=rwlt[213] rwlbot[214]=rwlt[214] rwlbot[215]=rwlt[215] rwlbot[216]=rwlt[216]
 rwlbot[217]=rwlt[217] rwlbot[218]=rwlt[218] rwlbot[219]=rwlt[219] rwlbot[220]=rwlt[220] rwlbot[221]=rwlt[221] rwlbot[222]=rwlt[222] rwlbot[223]=rwlt[223]
 rwlbot[224]=rwlt[224] rwlbot[225]=rwlt[225] rwlbot[226]=rwlt[226] rwlbot[227]=rwlt[227] rwlbot[228]=rwlt[228] rwlbot[229]=rwlt[229] rwlbot[230]=rwlt[230]
 rwlbot[231]=rwlt[231] rwlbot[232]=rwlt[232] rwlbot[233]=rwlt[233] rwlbot[234]=rwlt[234] rwlbot[235]=rwlt[235] rwlbot[236]=rwlt[236] rwlbot[237]=rwlt[237]
 rwlbot[238]=rwlt[238] rwlbot[239]=rwlt[239] rwlbot[240]=rwlt[240] rwlbot[241]=rwlt[241] rwlbot[242]=rwlt[242] rwlbot[243]=rwlt[243] rwlbot[244]=rwlt[244]
 rwlbot[245]=rwlt[245] rwlbot[246]=rwlt[246] rwlbot[247]=rwlt[247] rwlbot[248]=rwlt[248] rwlbot[249]=rwlt[249] rwlbot[250]=rwlt[250] rwlbot[251]=rwlt[251]
 rwlbot[252]=rwlt[252] rwlbot[253]=rwlt[253] rwlbot[254]=rwlt[254] rwlbot[255]=rwlt[255] cmselbot[0]=cm[0] cmselbot[1]=cm[1] cmselbot[2]=cm[2]
 cmselbot[3]=cm[3] cmselbot[4]=cm[4] cmselbot[5]=cm[5] cmselbot[6]=cm[6] cmselbot[7]=cm[7] cmselbot[8]=cm[8] cmselbot[9]=cm[9]
 cmselbot[10]=cm[10] cmselbot[11]=cm[11] cmselbot[12]=cm[12] cmselbot[13]=cm[13] cmselbot[14]=cm[14] cmselbot[15]=cm[15] cmselbot[16]=cm[16]
 cmselbot[17]=cm[17] cmselbot[18]=cm[18] cmselbot[19]=cm[19] cmselbot[20]=cm[20] cmselbot[21]=cm[21] cmselbot[22]=cm[22] cmselbot[23]=cm[23]
 cmselbot[24]=cm[24] cmselbot[25]=cm[25] cmselbot[26]=cm[26] cmselbot[27]=cm[27] cmselbot[28]=cm[28] cmselbot[29]=cm[29] cmselbot[30]=cm[30]
 cmselbot[31]=cm[31] lblpchglftbot[0]=lblpchglft[0] lblpchglftbot[1]=lblpchglft[1] lblpchglftbot[2]=lblpchglft[2] lblpchglftbot[3]=lblpchglft[3] lblpchgrgtbot[0]=lblpchgrgt[0] lblpchgrgtbot[1]=lblpchgrgt[1]
 lblpchgrgtbot[2]=lblpchgrgt[2] lblpchgrgtbot[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_4=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[4]=odout pwrenio_3=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclkbot=sdlclkin pwrenio_4=pwren_in
 rwlbot[0]=rwlt[0] rwlbot[1]=rwlt[1] rwlbot[2]=rwlt[2] rwlbot[3]=rwlt[3] rwlbot[4]=rwlt[4] rwlbot[5]=rwlt[5] rwlbot[6]=rwlt[6]
 rwlbot[7]=rwlt[7] rwlbot[8]=rwlt[8] rwlbot[9]=rwlt[9] rwlbot[10]=rwlt[10] rwlbot[11]=rwlt[11] rwlbot[12]=rwlt[12] rwlbot[13]=rwlt[13]
 rwlbot[14]=rwlt[14] rwlbot[15]=rwlt[15] rwlbot[16]=rwlt[16] rwlbot[17]=rwlt[17] rwlbot[18]=rwlt[18] rwlbot[19]=rwlt[19] rwlbot[20]=rwlt[20]
 rwlbot[21]=rwlt[21] rwlbot[22]=rwlt[22] rwlbot[23]=rwlt[23] rwlbot[24]=rwlt[24] rwlbot[25]=rwlt[25] rwlbot[26]=rwlt[26] rwlbot[27]=rwlt[27]
 rwlbot[28]=rwlt[28] rwlbot[29]=rwlt[29] rwlbot[30]=rwlt[30] rwlbot[31]=rwlt[31] rwlbot[32]=rwlt[32] rwlbot[33]=rwlt[33] rwlbot[34]=rwlt[34]
 rwlbot[35]=rwlt[35] rwlbot[36]=rwlt[36] rwlbot[37]=rwlt[37] rwlbot[38]=rwlt[38] rwlbot[39]=rwlt[39] rwlbot[40]=rwlt[40] rwlbot[41]=rwlt[41]
 rwlbot[42]=rwlt[42] rwlbot[43]=rwlt[43] rwlbot[44]=rwlt[44] rwlbot[45]=rwlt[45] rwlbot[46]=rwlt[46] rwlbot[47]=rwlt[47] rwlbot[48]=rwlt[48]
 rwlbot[49]=rwlt[49] rwlbot[50]=rwlt[50] rwlbot[51]=rwlt[51] rwlbot[52]=rwlt[52] rwlbot[53]=rwlt[53] rwlbot[54]=rwlt[54] rwlbot[55]=rwlt[55]
 rwlbot[56]=rwlt[56] rwlbot[57]=rwlt[57] rwlbot[58]=rwlt[58] rwlbot[59]=rwlt[59] rwlbot[60]=rwlt[60] rwlbot[61]=rwlt[61] rwlbot[62]=rwlt[62]
 rwlbot[63]=rwlt[63] rwlbot[64]=rwlt[64] rwlbot[65]=rwlt[65] rwlbot[66]=rwlt[66] rwlbot[67]=rwlt[67] rwlbot[68]=rwlt[68] rwlbot[69]=rwlt[69]
 rwlbot[70]=rwlt[70] rwlbot[71]=rwlt[71] rwlbot[72]=rwlt[72] rwlbot[73]=rwlt[73] rwlbot[74]=rwlt[74] rwlbot[75]=rwlt[75] rwlbot[76]=rwlt[76]
 rwlbot[77]=rwlt[77] rwlbot[78]=rwlt[78] rwlbot[79]=rwlt[79] rwlbot[80]=rwlt[80] rwlbot[81]=rwlt[81] rwlbot[82]=rwlt[82] rwlbot[83]=rwlt[83]
 rwlbot[84]=rwlt[84] rwlbot[85]=rwlt[85] rwlbot[86]=rwlt[86] rwlbot[87]=rwlt[87] rwlbot[88]=rwlt[88] rwlbot[89]=rwlt[89] rwlbot[90]=rwlt[90]
 rwlbot[91]=rwlt[91] rwlbot[92]=rwlt[92] rwlbot[93]=rwlt[93] rwlbot[94]=rwlt[94] rwlbot[95]=rwlt[95] rwlbot[96]=rwlt[96] rwlbot[97]=rwlt[97]
 rwlbot[98]=rwlt[98] rwlbot[99]=rwlt[99] rwlbot[100]=rwlt[100] rwlbot[101]=rwlt[101] rwlbot[102]=rwlt[102] rwlbot[103]=rwlt[103] rwlbot[104]=rwlt[104]
 rwlbot[105]=rwlt[105] rwlbot[106]=rwlt[106] rwlbot[107]=rwlt[107] rwlbot[108]=rwlt[108] rwlbot[109]=rwlt[109] rwlbot[110]=rwlt[110] rwlbot[111]=rwlt[111]
 rwlbot[112]=rwlt[112] rwlbot[113]=rwlt[113] rwlbot[114]=rwlt[114] rwlbot[115]=rwlt[115] rwlbot[116]=rwlt[116] rwlbot[117]=rwlt[117] rwlbot[118]=rwlt[118]
 rwlbot[119]=rwlt[119] rwlbot[120]=rwlt[120] rwlbot[121]=rwlt[121] rwlbot[122]=rwlt[122] rwlbot[123]=rwlt[123] rwlbot[124]=rwlt[124] rwlbot[125]=rwlt[125]
 rwlbot[126]=rwlt[126] rwlbot[127]=rwlt[127] rwlbot[128]=rwlt[128] rwlbot[129]=rwlt[129] rwlbot[130]=rwlt[130] rwlbot[131]=rwlt[131] rwlbot[132]=rwlt[132]
 rwlbot[133]=rwlt[133] rwlbot[134]=rwlt[134] rwlbot[135]=rwlt[135] rwlbot[136]=rwlt[136] rwlbot[137]=rwlt[137] rwlbot[138]=rwlt[138] rwlbot[139]=rwlt[139]
 rwlbot[140]=rwlt[140] rwlbot[141]=rwlt[141] rwlbot[142]=rwlt[142] rwlbot[143]=rwlt[143] rwlbot[144]=rwlt[144] rwlbot[145]=rwlt[145] rwlbot[146]=rwlt[146]
 rwlbot[147]=rwlt[147] rwlbot[148]=rwlt[148] rwlbot[149]=rwlt[149] rwlbot[150]=rwlt[150] rwlbot[151]=rwlt[151] rwlbot[152]=rwlt[152] rwlbot[153]=rwlt[153]
 rwlbot[154]=rwlt[154] rwlbot[155]=rwlt[155] rwlbot[156]=rwlt[156] rwlbot[157]=rwlt[157] rwlbot[158]=rwlt[158] rwlbot[159]=rwlt[159] rwlbot[160]=rwlt[160]
 rwlbot[161]=rwlt[161] rwlbot[162]=rwlt[162] rwlbot[163]=rwlt[163] rwlbot[164]=rwlt[164] rwlbot[165]=rwlt[165] rwlbot[166]=rwlt[166] rwlbot[167]=rwlt[167]
 rwlbot[168]=rwlt[168] rwlbot[169]=rwlt[169] rwlbot[170]=rwlt[170] rwlbot[171]=rwlt[171] rwlbot[172]=rwlt[172] rwlbot[173]=rwlt[173] rwlbot[174]=rwlt[174]
 rwlbot[175]=rwlt[175] rwlbot[176]=rwlt[176] rwlbot[177]=rwlt[177] rwlbot[178]=rwlt[178] rwlbot[179]=rwlt[179] rwlbot[180]=rwlt[180] rwlbot[181]=rwlt[181]
 rwlbot[182]=rwlt[182] rwlbot[183]=rwlt[183] rwlbot[184]=rwlt[184] rwlbot[185]=rwlt[185] rwlbot[186]=rwlt[186] rwlbot[187]=rwlt[187] rwlbot[188]=rwlt[188]
 rwlbot[189]=rwlt[189] rwlbot[190]=rwlt[190] rwlbot[191]=rwlt[191] rwlbot[192]=rwlt[192] rwlbot[193]=rwlt[193] rwlbot[194]=rwlt[194] rwlbot[195]=rwlt[195]
 rwlbot[196]=rwlt[196] rwlbot[197]=rwlt[197] rwlbot[198]=rwlt[198] rwlbot[199]=rwlt[199] rwlbot[200]=rwlt[200] rwlbot[201]=rwlt[201] rwlbot[202]=rwlt[202]
 rwlbot[203]=rwlt[203] rwlbot[204]=rwlt[204] rwlbot[205]=rwlt[205] rwlbot[206]=rwlt[206] rwlbot[207]=rwlt[207] rwlbot[208]=rwlt[208] rwlbot[209]=rwlt[209]
 rwlbot[210]=rwlt[210] rwlbot[211]=rwlt[211] rwlbot[212]=rwlt[212] rwlbot[213]=rwlt[213] rwlbot[214]=rwlt[214] rwlbot[215]=rwlt[215] rwlbot[216]=rwlt[216]
 rwlbot[217]=rwlt[217] rwlbot[218]=rwlt[218] rwlbot[219]=rwlt[219] rwlbot[220]=rwlt[220] rwlbot[221]=rwlt[221] rwlbot[222]=rwlt[222] rwlbot[223]=rwlt[223]
 rwlbot[224]=rwlt[224] rwlbot[225]=rwlt[225] rwlbot[226]=rwlt[226] rwlbot[227]=rwlt[227] rwlbot[228]=rwlt[228] rwlbot[229]=rwlt[229] rwlbot[230]=rwlt[230]
 rwlbot[231]=rwlt[231] rwlbot[232]=rwlt[232] rwlbot[233]=rwlt[233] rwlbot[234]=rwlt[234] rwlbot[235]=rwlt[235] rwlbot[236]=rwlt[236] rwlbot[237]=rwlt[237]
 rwlbot[238]=rwlt[238] rwlbot[239]=rwlt[239] rwlbot[240]=rwlt[240] rwlbot[241]=rwlt[241] rwlbot[242]=rwlt[242] rwlbot[243]=rwlt[243] rwlbot[244]=rwlt[244]
 rwlbot[245]=rwlt[245] rwlbot[246]=rwlt[246] rwlbot[247]=rwlt[247] rwlbot[248]=rwlt[248] rwlbot[249]=rwlt[249] rwlbot[250]=rwlt[250] rwlbot[251]=rwlt[251]
 rwlbot[252]=rwlt[252] rwlbot[253]=rwlt[253] rwlbot[254]=rwlt[254] rwlbot[255]=rwlt[255] cmselbot[0]=cm[0] cmselbot[1]=cm[1] cmselbot[2]=cm[2]
 cmselbot[3]=cm[3] cmselbot[4]=cm[4] cmselbot[5]=cm[5] cmselbot[6]=cm[6] cmselbot[7]=cm[7] cmselbot[8]=cm[8] cmselbot[9]=cm[9]
 cmselbot[10]=cm[10] cmselbot[11]=cm[11] cmselbot[12]=cm[12] cmselbot[13]=cm[13] cmselbot[14]=cm[14] cmselbot[15]=cm[15] cmselbot[16]=cm[16]
 cmselbot[17]=cm[17] cmselbot[18]=cm[18] cmselbot[19]=cm[19] cmselbot[20]=cm[20] cmselbot[21]=cm[21] cmselbot[22]=cm[22] cmselbot[23]=cm[23]
 cmselbot[24]=cm[24] cmselbot[25]=cm[25] cmselbot[26]=cm[26] cmselbot[27]=cm[27] cmselbot[28]=cm[28] cmselbot[29]=cm[29] cmselbot[30]=cm[30]
 cmselbot[31]=cm[31] lblpchglftbot[0]=lblpchglft[0] lblpchglftbot[1]=lblpchglft[1] lblpchglftbot[2]=lblpchglft[2] lblpchglftbot[3]=lblpchglft[3] lblpchgrgtbot[0]=lblpchgrgt[0] lblpchgrgtbot[1]=lblpchgrgt[1]
 lblpchgrgtbot[2]=lblpchgrgt[2] lblpchgrgtbot[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_3=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[3]=odout pwrenio_2=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclkbot=sdlclkin pwrenio_3=pwren_in
 rwlbot[0]=rwlt[0] rwlbot[1]=rwlt[1] rwlbot[2]=rwlt[2] rwlbot[3]=rwlt[3] rwlbot[4]=rwlt[4] rwlbot[5]=rwlt[5] rwlbot[6]=rwlt[6]
 rwlbot[7]=rwlt[7] rwlbot[8]=rwlt[8] rwlbot[9]=rwlt[9] rwlbot[10]=rwlt[10] rwlbot[11]=rwlt[11] rwlbot[12]=rwlt[12] rwlbot[13]=rwlt[13]
 rwlbot[14]=rwlt[14] rwlbot[15]=rwlt[15] rwlbot[16]=rwlt[16] rwlbot[17]=rwlt[17] rwlbot[18]=rwlt[18] rwlbot[19]=rwlt[19] rwlbot[20]=rwlt[20]
 rwlbot[21]=rwlt[21] rwlbot[22]=rwlt[22] rwlbot[23]=rwlt[23] rwlbot[24]=rwlt[24] rwlbot[25]=rwlt[25] rwlbot[26]=rwlt[26] rwlbot[27]=rwlt[27]
 rwlbot[28]=rwlt[28] rwlbot[29]=rwlt[29] rwlbot[30]=rwlt[30] rwlbot[31]=rwlt[31] rwlbot[32]=rwlt[32] rwlbot[33]=rwlt[33] rwlbot[34]=rwlt[34]
 rwlbot[35]=rwlt[35] rwlbot[36]=rwlt[36] rwlbot[37]=rwlt[37] rwlbot[38]=rwlt[38] rwlbot[39]=rwlt[39] rwlbot[40]=rwlt[40] rwlbot[41]=rwlt[41]
 rwlbot[42]=rwlt[42] rwlbot[43]=rwlt[43] rwlbot[44]=rwlt[44] rwlbot[45]=rwlt[45] rwlbot[46]=rwlt[46] rwlbot[47]=rwlt[47] rwlbot[48]=rwlt[48]
 rwlbot[49]=rwlt[49] rwlbot[50]=rwlt[50] rwlbot[51]=rwlt[51] rwlbot[52]=rwlt[52] rwlbot[53]=rwlt[53] rwlbot[54]=rwlt[54] rwlbot[55]=rwlt[55]
 rwlbot[56]=rwlt[56] rwlbot[57]=rwlt[57] rwlbot[58]=rwlt[58] rwlbot[59]=rwlt[59] rwlbot[60]=rwlt[60] rwlbot[61]=rwlt[61] rwlbot[62]=rwlt[62]
 rwlbot[63]=rwlt[63] rwlbot[64]=rwlt[64] rwlbot[65]=rwlt[65] rwlbot[66]=rwlt[66] rwlbot[67]=rwlt[67] rwlbot[68]=rwlt[68] rwlbot[69]=rwlt[69]
 rwlbot[70]=rwlt[70] rwlbot[71]=rwlt[71] rwlbot[72]=rwlt[72] rwlbot[73]=rwlt[73] rwlbot[74]=rwlt[74] rwlbot[75]=rwlt[75] rwlbot[76]=rwlt[76]
 rwlbot[77]=rwlt[77] rwlbot[78]=rwlt[78] rwlbot[79]=rwlt[79] rwlbot[80]=rwlt[80] rwlbot[81]=rwlt[81] rwlbot[82]=rwlt[82] rwlbot[83]=rwlt[83]
 rwlbot[84]=rwlt[84] rwlbot[85]=rwlt[85] rwlbot[86]=rwlt[86] rwlbot[87]=rwlt[87] rwlbot[88]=rwlt[88] rwlbot[89]=rwlt[89] rwlbot[90]=rwlt[90]
 rwlbot[91]=rwlt[91] rwlbot[92]=rwlt[92] rwlbot[93]=rwlt[93] rwlbot[94]=rwlt[94] rwlbot[95]=rwlt[95] rwlbot[96]=rwlt[96] rwlbot[97]=rwlt[97]
 rwlbot[98]=rwlt[98] rwlbot[99]=rwlt[99] rwlbot[100]=rwlt[100] rwlbot[101]=rwlt[101] rwlbot[102]=rwlt[102] rwlbot[103]=rwlt[103] rwlbot[104]=rwlt[104]
 rwlbot[105]=rwlt[105] rwlbot[106]=rwlt[106] rwlbot[107]=rwlt[107] rwlbot[108]=rwlt[108] rwlbot[109]=rwlt[109] rwlbot[110]=rwlt[110] rwlbot[111]=rwlt[111]
 rwlbot[112]=rwlt[112] rwlbot[113]=rwlt[113] rwlbot[114]=rwlt[114] rwlbot[115]=rwlt[115] rwlbot[116]=rwlt[116] rwlbot[117]=rwlt[117] rwlbot[118]=rwlt[118]
 rwlbot[119]=rwlt[119] rwlbot[120]=rwlt[120] rwlbot[121]=rwlt[121] rwlbot[122]=rwlt[122] rwlbot[123]=rwlt[123] rwlbot[124]=rwlt[124] rwlbot[125]=rwlt[125]
 rwlbot[126]=rwlt[126] rwlbot[127]=rwlt[127] rwlbot[128]=rwlt[128] rwlbot[129]=rwlt[129] rwlbot[130]=rwlt[130] rwlbot[131]=rwlt[131] rwlbot[132]=rwlt[132]
 rwlbot[133]=rwlt[133] rwlbot[134]=rwlt[134] rwlbot[135]=rwlt[135] rwlbot[136]=rwlt[136] rwlbot[137]=rwlt[137] rwlbot[138]=rwlt[138] rwlbot[139]=rwlt[139]
 rwlbot[140]=rwlt[140] rwlbot[141]=rwlt[141] rwlbot[142]=rwlt[142] rwlbot[143]=rwlt[143] rwlbot[144]=rwlt[144] rwlbot[145]=rwlt[145] rwlbot[146]=rwlt[146]
 rwlbot[147]=rwlt[147] rwlbot[148]=rwlt[148] rwlbot[149]=rwlt[149] rwlbot[150]=rwlt[150] rwlbot[151]=rwlt[151] rwlbot[152]=rwlt[152] rwlbot[153]=rwlt[153]
 rwlbot[154]=rwlt[154] rwlbot[155]=rwlt[155] rwlbot[156]=rwlt[156] rwlbot[157]=rwlt[157] rwlbot[158]=rwlt[158] rwlbot[159]=rwlt[159] rwlbot[160]=rwlt[160]
 rwlbot[161]=rwlt[161] rwlbot[162]=rwlt[162] rwlbot[163]=rwlt[163] rwlbot[164]=rwlt[164] rwlbot[165]=rwlt[165] rwlbot[166]=rwlt[166] rwlbot[167]=rwlt[167]
 rwlbot[168]=rwlt[168] rwlbot[169]=rwlt[169] rwlbot[170]=rwlt[170] rwlbot[171]=rwlt[171] rwlbot[172]=rwlt[172] rwlbot[173]=rwlt[173] rwlbot[174]=rwlt[174]
 rwlbot[175]=rwlt[175] rwlbot[176]=rwlt[176] rwlbot[177]=rwlt[177] rwlbot[178]=rwlt[178] rwlbot[179]=rwlt[179] rwlbot[180]=rwlt[180] rwlbot[181]=rwlt[181]
 rwlbot[182]=rwlt[182] rwlbot[183]=rwlt[183] rwlbot[184]=rwlt[184] rwlbot[185]=rwlt[185] rwlbot[186]=rwlt[186] rwlbot[187]=rwlt[187] rwlbot[188]=rwlt[188]
 rwlbot[189]=rwlt[189] rwlbot[190]=rwlt[190] rwlbot[191]=rwlt[191] rwlbot[192]=rwlt[192] rwlbot[193]=rwlt[193] rwlbot[194]=rwlt[194] rwlbot[195]=rwlt[195]
 rwlbot[196]=rwlt[196] rwlbot[197]=rwlt[197] rwlbot[198]=rwlt[198] rwlbot[199]=rwlt[199] rwlbot[200]=rwlt[200] rwlbot[201]=rwlt[201] rwlbot[202]=rwlt[202]
 rwlbot[203]=rwlt[203] rwlbot[204]=rwlt[204] rwlbot[205]=rwlt[205] rwlbot[206]=rwlt[206] rwlbot[207]=rwlt[207] rwlbot[208]=rwlt[208] rwlbot[209]=rwlt[209]
 rwlbot[210]=rwlt[210] rwlbot[211]=rwlt[211] rwlbot[212]=rwlt[212] rwlbot[213]=rwlt[213] rwlbot[214]=rwlt[214] rwlbot[215]=rwlt[215] rwlbot[216]=rwlt[216]
 rwlbot[217]=rwlt[217] rwlbot[218]=rwlt[218] rwlbot[219]=rwlt[219] rwlbot[220]=rwlt[220] rwlbot[221]=rwlt[221] rwlbot[222]=rwlt[222] rwlbot[223]=rwlt[223]
 rwlbot[224]=rwlt[224] rwlbot[225]=rwlt[225] rwlbot[226]=rwlt[226] rwlbot[227]=rwlt[227] rwlbot[228]=rwlt[228] rwlbot[229]=rwlt[229] rwlbot[230]=rwlt[230]
 rwlbot[231]=rwlt[231] rwlbot[232]=rwlt[232] rwlbot[233]=rwlt[233] rwlbot[234]=rwlt[234] rwlbot[235]=rwlt[235] rwlbot[236]=rwlt[236] rwlbot[237]=rwlt[237]
 rwlbot[238]=rwlt[238] rwlbot[239]=rwlt[239] rwlbot[240]=rwlt[240] rwlbot[241]=rwlt[241] rwlbot[242]=rwlt[242] rwlbot[243]=rwlt[243] rwlbot[244]=rwlt[244]
 rwlbot[245]=rwlt[245] rwlbot[246]=rwlt[246] rwlbot[247]=rwlt[247] rwlbot[248]=rwlt[248] rwlbot[249]=rwlt[249] rwlbot[250]=rwlt[250] rwlbot[251]=rwlt[251]
 rwlbot[252]=rwlt[252] rwlbot[253]=rwlt[253] rwlbot[254]=rwlt[254] rwlbot[255]=rwlt[255] cmselbot[0]=cm[0] cmselbot[1]=cm[1] cmselbot[2]=cm[2]
 cmselbot[3]=cm[3] cmselbot[4]=cm[4] cmselbot[5]=cm[5] cmselbot[6]=cm[6] cmselbot[7]=cm[7] cmselbot[8]=cm[8] cmselbot[9]=cm[9]
 cmselbot[10]=cm[10] cmselbot[11]=cm[11] cmselbot[12]=cm[12] cmselbot[13]=cm[13] cmselbot[14]=cm[14] cmselbot[15]=cm[15] cmselbot[16]=cm[16]
 cmselbot[17]=cm[17] cmselbot[18]=cm[18] cmselbot[19]=cm[19] cmselbot[20]=cm[20] cmselbot[21]=cm[21] cmselbot[22]=cm[22] cmselbot[23]=cm[23]
 cmselbot[24]=cm[24] cmselbot[25]=cm[25] cmselbot[26]=cm[26] cmselbot[27]=cm[27] cmselbot[28]=cm[28] cmselbot[29]=cm[29] cmselbot[30]=cm[30]
 cmselbot[31]=cm[31] lblpchglftbot[0]=lblpchglft[0] lblpchglftbot[1]=lblpchglft[1] lblpchglftbot[2]=lblpchglft[2] lblpchglftbot[3]=lblpchglft[3] lblpchgrgtbot[0]=lblpchgrgt[0] lblpchgrgtbot[1]=lblpchgrgt[1]
 lblpchgrgtbot[2]=lblpchgrgt[2] lblpchgrgtbot[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_2=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[2]=odout pwrenio_1=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclkbot=sdlclkin pwrenio_2=pwren_in
 rwlbot[0]=rwlt[0] rwlbot[1]=rwlt[1] rwlbot[2]=rwlt[2] rwlbot[3]=rwlt[3] rwlbot[4]=rwlt[4] rwlbot[5]=rwlt[5] rwlbot[6]=rwlt[6]
 rwlbot[7]=rwlt[7] rwlbot[8]=rwlt[8] rwlbot[9]=rwlt[9] rwlbot[10]=rwlt[10] rwlbot[11]=rwlt[11] rwlbot[12]=rwlt[12] rwlbot[13]=rwlt[13]
 rwlbot[14]=rwlt[14] rwlbot[15]=rwlt[15] rwlbot[16]=rwlt[16] rwlbot[17]=rwlt[17] rwlbot[18]=rwlt[18] rwlbot[19]=rwlt[19] rwlbot[20]=rwlt[20]
 rwlbot[21]=rwlt[21] rwlbot[22]=rwlt[22] rwlbot[23]=rwlt[23] rwlbot[24]=rwlt[24] rwlbot[25]=rwlt[25] rwlbot[26]=rwlt[26] rwlbot[27]=rwlt[27]
 rwlbot[28]=rwlt[28] rwlbot[29]=rwlt[29] rwlbot[30]=rwlt[30] rwlbot[31]=rwlt[31] rwlbot[32]=rwlt[32] rwlbot[33]=rwlt[33] rwlbot[34]=rwlt[34]
 rwlbot[35]=rwlt[35] rwlbot[36]=rwlt[36] rwlbot[37]=rwlt[37] rwlbot[38]=rwlt[38] rwlbot[39]=rwlt[39] rwlbot[40]=rwlt[40] rwlbot[41]=rwlt[41]
 rwlbot[42]=rwlt[42] rwlbot[43]=rwlt[43] rwlbot[44]=rwlt[44] rwlbot[45]=rwlt[45] rwlbot[46]=rwlt[46] rwlbot[47]=rwlt[47] rwlbot[48]=rwlt[48]
 rwlbot[49]=rwlt[49] rwlbot[50]=rwlt[50] rwlbot[51]=rwlt[51] rwlbot[52]=rwlt[52] rwlbot[53]=rwlt[53] rwlbot[54]=rwlt[54] rwlbot[55]=rwlt[55]
 rwlbot[56]=rwlt[56] rwlbot[57]=rwlt[57] rwlbot[58]=rwlt[58] rwlbot[59]=rwlt[59] rwlbot[60]=rwlt[60] rwlbot[61]=rwlt[61] rwlbot[62]=rwlt[62]
 rwlbot[63]=rwlt[63] rwlbot[64]=rwlt[64] rwlbot[65]=rwlt[65] rwlbot[66]=rwlt[66] rwlbot[67]=rwlt[67] rwlbot[68]=rwlt[68] rwlbot[69]=rwlt[69]
 rwlbot[70]=rwlt[70] rwlbot[71]=rwlt[71] rwlbot[72]=rwlt[72] rwlbot[73]=rwlt[73] rwlbot[74]=rwlt[74] rwlbot[75]=rwlt[75] rwlbot[76]=rwlt[76]
 rwlbot[77]=rwlt[77] rwlbot[78]=rwlt[78] rwlbot[79]=rwlt[79] rwlbot[80]=rwlt[80] rwlbot[81]=rwlt[81] rwlbot[82]=rwlt[82] rwlbot[83]=rwlt[83]
 rwlbot[84]=rwlt[84] rwlbot[85]=rwlt[85] rwlbot[86]=rwlt[86] rwlbot[87]=rwlt[87] rwlbot[88]=rwlt[88] rwlbot[89]=rwlt[89] rwlbot[90]=rwlt[90]
 rwlbot[91]=rwlt[91] rwlbot[92]=rwlt[92] rwlbot[93]=rwlt[93] rwlbot[94]=rwlt[94] rwlbot[95]=rwlt[95] rwlbot[96]=rwlt[96] rwlbot[97]=rwlt[97]
 rwlbot[98]=rwlt[98] rwlbot[99]=rwlt[99] rwlbot[100]=rwlt[100] rwlbot[101]=rwlt[101] rwlbot[102]=rwlt[102] rwlbot[103]=rwlt[103] rwlbot[104]=rwlt[104]
 rwlbot[105]=rwlt[105] rwlbot[106]=rwlt[106] rwlbot[107]=rwlt[107] rwlbot[108]=rwlt[108] rwlbot[109]=rwlt[109] rwlbot[110]=rwlt[110] rwlbot[111]=rwlt[111]
 rwlbot[112]=rwlt[112] rwlbot[113]=rwlt[113] rwlbot[114]=rwlt[114] rwlbot[115]=rwlt[115] rwlbot[116]=rwlt[116] rwlbot[117]=rwlt[117] rwlbot[118]=rwlt[118]
 rwlbot[119]=rwlt[119] rwlbot[120]=rwlt[120] rwlbot[121]=rwlt[121] rwlbot[122]=rwlt[122] rwlbot[123]=rwlt[123] rwlbot[124]=rwlt[124] rwlbot[125]=rwlt[125]
 rwlbot[126]=rwlt[126] rwlbot[127]=rwlt[127] rwlbot[128]=rwlt[128] rwlbot[129]=rwlt[129] rwlbot[130]=rwlt[130] rwlbot[131]=rwlt[131] rwlbot[132]=rwlt[132]
 rwlbot[133]=rwlt[133] rwlbot[134]=rwlt[134] rwlbot[135]=rwlt[135] rwlbot[136]=rwlt[136] rwlbot[137]=rwlt[137] rwlbot[138]=rwlt[138] rwlbot[139]=rwlt[139]
 rwlbot[140]=rwlt[140] rwlbot[141]=rwlt[141] rwlbot[142]=rwlt[142] rwlbot[143]=rwlt[143] rwlbot[144]=rwlt[144] rwlbot[145]=rwlt[145] rwlbot[146]=rwlt[146]
 rwlbot[147]=rwlt[147] rwlbot[148]=rwlt[148] rwlbot[149]=rwlt[149] rwlbot[150]=rwlt[150] rwlbot[151]=rwlt[151] rwlbot[152]=rwlt[152] rwlbot[153]=rwlt[153]
 rwlbot[154]=rwlt[154] rwlbot[155]=rwlt[155] rwlbot[156]=rwlt[156] rwlbot[157]=rwlt[157] rwlbot[158]=rwlt[158] rwlbot[159]=rwlt[159] rwlbot[160]=rwlt[160]
 rwlbot[161]=rwlt[161] rwlbot[162]=rwlt[162] rwlbot[163]=rwlt[163] rwlbot[164]=rwlt[164] rwlbot[165]=rwlt[165] rwlbot[166]=rwlt[166] rwlbot[167]=rwlt[167]
 rwlbot[168]=rwlt[168] rwlbot[169]=rwlt[169] rwlbot[170]=rwlt[170] rwlbot[171]=rwlt[171] rwlbot[172]=rwlt[172] rwlbot[173]=rwlt[173] rwlbot[174]=rwlt[174]
 rwlbot[175]=rwlt[175] rwlbot[176]=rwlt[176] rwlbot[177]=rwlt[177] rwlbot[178]=rwlt[178] rwlbot[179]=rwlt[179] rwlbot[180]=rwlt[180] rwlbot[181]=rwlt[181]
 rwlbot[182]=rwlt[182] rwlbot[183]=rwlt[183] rwlbot[184]=rwlt[184] rwlbot[185]=rwlt[185] rwlbot[186]=rwlt[186] rwlbot[187]=rwlt[187] rwlbot[188]=rwlt[188]
 rwlbot[189]=rwlt[189] rwlbot[190]=rwlt[190] rwlbot[191]=rwlt[191] rwlbot[192]=rwlt[192] rwlbot[193]=rwlt[193] rwlbot[194]=rwlt[194] rwlbot[195]=rwlt[195]
 rwlbot[196]=rwlt[196] rwlbot[197]=rwlt[197] rwlbot[198]=rwlt[198] rwlbot[199]=rwlt[199] rwlbot[200]=rwlt[200] rwlbot[201]=rwlt[201] rwlbot[202]=rwlt[202]
 rwlbot[203]=rwlt[203] rwlbot[204]=rwlt[204] rwlbot[205]=rwlt[205] rwlbot[206]=rwlt[206] rwlbot[207]=rwlt[207] rwlbot[208]=rwlt[208] rwlbot[209]=rwlt[209]
 rwlbot[210]=rwlt[210] rwlbot[211]=rwlt[211] rwlbot[212]=rwlt[212] rwlbot[213]=rwlt[213] rwlbot[214]=rwlt[214] rwlbot[215]=rwlt[215] rwlbot[216]=rwlt[216]
 rwlbot[217]=rwlt[217] rwlbot[218]=rwlt[218] rwlbot[219]=rwlt[219] rwlbot[220]=rwlt[220] rwlbot[221]=rwlt[221] rwlbot[222]=rwlt[222] rwlbot[223]=rwlt[223]
 rwlbot[224]=rwlt[224] rwlbot[225]=rwlt[225] rwlbot[226]=rwlt[226] rwlbot[227]=rwlt[227] rwlbot[228]=rwlt[228] rwlbot[229]=rwlt[229] rwlbot[230]=rwlt[230]
 rwlbot[231]=rwlt[231] rwlbot[232]=rwlt[232] rwlbot[233]=rwlt[233] rwlbot[234]=rwlt[234] rwlbot[235]=rwlt[235] rwlbot[236]=rwlt[236] rwlbot[237]=rwlt[237]
 rwlbot[238]=rwlt[238] rwlbot[239]=rwlt[239] rwlbot[240]=rwlt[240] rwlbot[241]=rwlt[241] rwlbot[242]=rwlt[242] rwlbot[243]=rwlt[243] rwlbot[244]=rwlt[244]
 rwlbot[245]=rwlt[245] rwlbot[246]=rwlt[246] rwlbot[247]=rwlt[247] rwlbot[248]=rwlt[248] rwlbot[249]=rwlt[249] rwlbot[250]=rwlt[250] rwlbot[251]=rwlt[251]
 rwlbot[252]=rwlt[252] rwlbot[253]=rwlt[253] rwlbot[254]=rwlt[254] rwlbot[255]=rwlt[255] cmselbot[0]=cm[0] cmselbot[1]=cm[1] cmselbot[2]=cm[2]
 cmselbot[3]=cm[3] cmselbot[4]=cm[4] cmselbot[5]=cm[5] cmselbot[6]=cm[6] cmselbot[7]=cm[7] cmselbot[8]=cm[8] cmselbot[9]=cm[9]
 cmselbot[10]=cm[10] cmselbot[11]=cm[11] cmselbot[12]=cm[12] cmselbot[13]=cm[13] cmselbot[14]=cm[14] cmselbot[15]=cm[15] cmselbot[16]=cm[16]
 cmselbot[17]=cm[17] cmselbot[18]=cm[18] cmselbot[19]=cm[19] cmselbot[20]=cm[20] cmselbot[21]=cm[21] cmselbot[22]=cm[22] cmselbot[23]=cm[23]
 cmselbot[24]=cm[24] cmselbot[25]=cm[25] cmselbot[26]=cm[26] cmselbot[27]=cm[27] cmselbot[28]=cm[28] cmselbot[29]=cm[29] cmselbot[30]=cm[30]
 cmselbot[31]=cm[31] lblpchglftbot[0]=lblpchglft[0] lblpchglftbot[1]=lblpchglft[1] lblpchglftbot[2]=lblpchglft[2] lblpchglftbot[3]=lblpchglft[3] lblpchgrgtbot[0]=lblpchgrgt[0] lblpchgrgtbot[1]=lblpchgrgt[1]
 lblpchgrgtbot[2]=lblpchgrgt[2] lblpchgrgtbot[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_1=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[1]=odout pwrenio_0=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclkbot=sdlclkin pwrenio_1=pwren_in
 rwlbot[0]=rwlt[0] rwlbot[1]=rwlt[1] rwlbot[2]=rwlt[2] rwlbot[3]=rwlt[3] rwlbot[4]=rwlt[4] rwlbot[5]=rwlt[5] rwlbot[6]=rwlt[6]
 rwlbot[7]=rwlt[7] rwlbot[8]=rwlt[8] rwlbot[9]=rwlt[9] rwlbot[10]=rwlt[10] rwlbot[11]=rwlt[11] rwlbot[12]=rwlt[12] rwlbot[13]=rwlt[13]
 rwlbot[14]=rwlt[14] rwlbot[15]=rwlt[15] rwlbot[16]=rwlt[16] rwlbot[17]=rwlt[17] rwlbot[18]=rwlt[18] rwlbot[19]=rwlt[19] rwlbot[20]=rwlt[20]
 rwlbot[21]=rwlt[21] rwlbot[22]=rwlt[22] rwlbot[23]=rwlt[23] rwlbot[24]=rwlt[24] rwlbot[25]=rwlt[25] rwlbot[26]=rwlt[26] rwlbot[27]=rwlt[27]
 rwlbot[28]=rwlt[28] rwlbot[29]=rwlt[29] rwlbot[30]=rwlt[30] rwlbot[31]=rwlt[31] rwlbot[32]=rwlt[32] rwlbot[33]=rwlt[33] rwlbot[34]=rwlt[34]
 rwlbot[35]=rwlt[35] rwlbot[36]=rwlt[36] rwlbot[37]=rwlt[37] rwlbot[38]=rwlt[38] rwlbot[39]=rwlt[39] rwlbot[40]=rwlt[40] rwlbot[41]=rwlt[41]
 rwlbot[42]=rwlt[42] rwlbot[43]=rwlt[43] rwlbot[44]=rwlt[44] rwlbot[45]=rwlt[45] rwlbot[46]=rwlt[46] rwlbot[47]=rwlt[47] rwlbot[48]=rwlt[48]
 rwlbot[49]=rwlt[49] rwlbot[50]=rwlt[50] rwlbot[51]=rwlt[51] rwlbot[52]=rwlt[52] rwlbot[53]=rwlt[53] rwlbot[54]=rwlt[54] rwlbot[55]=rwlt[55]
 rwlbot[56]=rwlt[56] rwlbot[57]=rwlt[57] rwlbot[58]=rwlt[58] rwlbot[59]=rwlt[59] rwlbot[60]=rwlt[60] rwlbot[61]=rwlt[61] rwlbot[62]=rwlt[62]
 rwlbot[63]=rwlt[63] rwlbot[64]=rwlt[64] rwlbot[65]=rwlt[65] rwlbot[66]=rwlt[66] rwlbot[67]=rwlt[67] rwlbot[68]=rwlt[68] rwlbot[69]=rwlt[69]
 rwlbot[70]=rwlt[70] rwlbot[71]=rwlt[71] rwlbot[72]=rwlt[72] rwlbot[73]=rwlt[73] rwlbot[74]=rwlt[74] rwlbot[75]=rwlt[75] rwlbot[76]=rwlt[76]
 rwlbot[77]=rwlt[77] rwlbot[78]=rwlt[78] rwlbot[79]=rwlt[79] rwlbot[80]=rwlt[80] rwlbot[81]=rwlt[81] rwlbot[82]=rwlt[82] rwlbot[83]=rwlt[83]
 rwlbot[84]=rwlt[84] rwlbot[85]=rwlt[85] rwlbot[86]=rwlt[86] rwlbot[87]=rwlt[87] rwlbot[88]=rwlt[88] rwlbot[89]=rwlt[89] rwlbot[90]=rwlt[90]
 rwlbot[91]=rwlt[91] rwlbot[92]=rwlt[92] rwlbot[93]=rwlt[93] rwlbot[94]=rwlt[94] rwlbot[95]=rwlt[95] rwlbot[96]=rwlt[96] rwlbot[97]=rwlt[97]
 rwlbot[98]=rwlt[98] rwlbot[99]=rwlt[99] rwlbot[100]=rwlt[100] rwlbot[101]=rwlt[101] rwlbot[102]=rwlt[102] rwlbot[103]=rwlt[103] rwlbot[104]=rwlt[104]
 rwlbot[105]=rwlt[105] rwlbot[106]=rwlt[106] rwlbot[107]=rwlt[107] rwlbot[108]=rwlt[108] rwlbot[109]=rwlt[109] rwlbot[110]=rwlt[110] rwlbot[111]=rwlt[111]
 rwlbot[112]=rwlt[112] rwlbot[113]=rwlt[113] rwlbot[114]=rwlt[114] rwlbot[115]=rwlt[115] rwlbot[116]=rwlt[116] rwlbot[117]=rwlt[117] rwlbot[118]=rwlt[118]
 rwlbot[119]=rwlt[119] rwlbot[120]=rwlt[120] rwlbot[121]=rwlt[121] rwlbot[122]=rwlt[122] rwlbot[123]=rwlt[123] rwlbot[124]=rwlt[124] rwlbot[125]=rwlt[125]
 rwlbot[126]=rwlt[126] rwlbot[127]=rwlt[127] rwlbot[128]=rwlt[128] rwlbot[129]=rwlt[129] rwlbot[130]=rwlt[130] rwlbot[131]=rwlt[131] rwlbot[132]=rwlt[132]
 rwlbot[133]=rwlt[133] rwlbot[134]=rwlt[134] rwlbot[135]=rwlt[135] rwlbot[136]=rwlt[136] rwlbot[137]=rwlt[137] rwlbot[138]=rwlt[138] rwlbot[139]=rwlt[139]
 rwlbot[140]=rwlt[140] rwlbot[141]=rwlt[141] rwlbot[142]=rwlt[142] rwlbot[143]=rwlt[143] rwlbot[144]=rwlt[144] rwlbot[145]=rwlt[145] rwlbot[146]=rwlt[146]
 rwlbot[147]=rwlt[147] rwlbot[148]=rwlt[148] rwlbot[149]=rwlt[149] rwlbot[150]=rwlt[150] rwlbot[151]=rwlt[151] rwlbot[152]=rwlt[152] rwlbot[153]=rwlt[153]
 rwlbot[154]=rwlt[154] rwlbot[155]=rwlt[155] rwlbot[156]=rwlt[156] rwlbot[157]=rwlt[157] rwlbot[158]=rwlt[158] rwlbot[159]=rwlt[159] rwlbot[160]=rwlt[160]
 rwlbot[161]=rwlt[161] rwlbot[162]=rwlt[162] rwlbot[163]=rwlt[163] rwlbot[164]=rwlt[164] rwlbot[165]=rwlt[165] rwlbot[166]=rwlt[166] rwlbot[167]=rwlt[167]
 rwlbot[168]=rwlt[168] rwlbot[169]=rwlt[169] rwlbot[170]=rwlt[170] rwlbot[171]=rwlt[171] rwlbot[172]=rwlt[172] rwlbot[173]=rwlt[173] rwlbot[174]=rwlt[174]
 rwlbot[175]=rwlt[175] rwlbot[176]=rwlt[176] rwlbot[177]=rwlt[177] rwlbot[178]=rwlt[178] rwlbot[179]=rwlt[179] rwlbot[180]=rwlt[180] rwlbot[181]=rwlt[181]
 rwlbot[182]=rwlt[182] rwlbot[183]=rwlt[183] rwlbot[184]=rwlt[184] rwlbot[185]=rwlt[185] rwlbot[186]=rwlt[186] rwlbot[187]=rwlt[187] rwlbot[188]=rwlt[188]
 rwlbot[189]=rwlt[189] rwlbot[190]=rwlt[190] rwlbot[191]=rwlt[191] rwlbot[192]=rwlt[192] rwlbot[193]=rwlt[193] rwlbot[194]=rwlt[194] rwlbot[195]=rwlt[195]
 rwlbot[196]=rwlt[196] rwlbot[197]=rwlt[197] rwlbot[198]=rwlt[198] rwlbot[199]=rwlt[199] rwlbot[200]=rwlt[200] rwlbot[201]=rwlt[201] rwlbot[202]=rwlt[202]
 rwlbot[203]=rwlt[203] rwlbot[204]=rwlt[204] rwlbot[205]=rwlt[205] rwlbot[206]=rwlt[206] rwlbot[207]=rwlt[207] rwlbot[208]=rwlt[208] rwlbot[209]=rwlt[209]
 rwlbot[210]=rwlt[210] rwlbot[211]=rwlt[211] rwlbot[212]=rwlt[212] rwlbot[213]=rwlt[213] rwlbot[214]=rwlt[214] rwlbot[215]=rwlt[215] rwlbot[216]=rwlt[216]
 rwlbot[217]=rwlt[217] rwlbot[218]=rwlt[218] rwlbot[219]=rwlt[219] rwlbot[220]=rwlt[220] rwlbot[221]=rwlt[221] rwlbot[222]=rwlt[222] rwlbot[223]=rwlt[223]
 rwlbot[224]=rwlt[224] rwlbot[225]=rwlt[225] rwlbot[226]=rwlt[226] rwlbot[227]=rwlt[227] rwlbot[228]=rwlt[228] rwlbot[229]=rwlt[229] rwlbot[230]=rwlt[230]
 rwlbot[231]=rwlt[231] rwlbot[232]=rwlt[232] rwlbot[233]=rwlt[233] rwlbot[234]=rwlt[234] rwlbot[235]=rwlt[235] rwlbot[236]=rwlt[236] rwlbot[237]=rwlt[237]
 rwlbot[238]=rwlt[238] rwlbot[239]=rwlt[239] rwlbot[240]=rwlt[240] rwlbot[241]=rwlt[241] rwlbot[242]=rwlt[242] rwlbot[243]=rwlt[243] rwlbot[244]=rwlt[244]
 rwlbot[245]=rwlt[245] rwlbot[246]=rwlt[246] rwlbot[247]=rwlt[247] rwlbot[248]=rwlt[248] rwlbot[249]=rwlt[249] rwlbot[250]=rwlt[250] rwlbot[251]=rwlt[251]
 rwlbot[252]=rwlt[252] rwlbot[253]=rwlt[253] rwlbot[254]=rwlt[254] rwlbot[255]=rwlt[255] cmselbot[0]=cm[0] cmselbot[1]=cm[1] cmselbot[2]=cm[2]
 cmselbot[3]=cm[3] cmselbot[4]=cm[4] cmselbot[5]=cm[5] cmselbot[6]=cm[6] cmselbot[7]=cm[7] cmselbot[8]=cm[8] cmselbot[9]=cm[9]
 cmselbot[10]=cm[10] cmselbot[11]=cm[11] cmselbot[12]=cm[12] cmselbot[13]=cm[13] cmselbot[14]=cm[14] cmselbot[15]=cm[15] cmselbot[16]=cm[16]
 cmselbot[17]=cm[17] cmselbot[18]=cm[18] cmselbot[19]=cm[19] cmselbot[20]=cm[20] cmselbot[21]=cm[21] cmselbot[22]=cm[22] cmselbot[23]=cm[23]
 cmselbot[24]=cm[24] cmselbot[25]=cm[25] cmselbot[26]=cm[26] cmselbot[27]=cm[27] cmselbot[28]=cm[28] cmselbot[29]=cm[29] cmselbot[30]=cm[30]
 cmselbot[31]=cm[31] lblpchglftbot[0]=lblpchglft[0] lblpchglftbot[1]=lblpchglft[1] lblpchglftbot[2]=lblpchglft[2] lblpchglftbot[3]=lblpchglft[3] lblpchgrgtbot[0]=lblpchgrgt[0] lblpchgrgtbot[1]=lblpchgrgt[1]
 lblpchgrgtbot[2]=lblpchgrgt[2] lblpchgrgtbot[3]=lblpchgrgt[3]}}
{inst bitbundle_hor_0=c73p1rfshdxrom2048x16hb4img100_bitbundle {TYPE CELL} 
{pin odout[0]=odout opwrenoutb=pwren_out vccd_1p0=vccd_1p0 vccdgt_1p0=vccdgt_1p0 sdlclkbot=sdlclkin pwrenio_0=pwren_in
 rwlbot[0]=rwlt[0] rwlbot[1]=rwlt[1] rwlbot[2]=rwlt[2] rwlbot[3]=rwlt[3] rwlbot[4]=rwlt[4] rwlbot[5]=rwlt[5] rwlbot[6]=rwlt[6]
 rwlbot[7]=rwlt[7] rwlbot[8]=rwlt[8] rwlbot[9]=rwlt[9] rwlbot[10]=rwlt[10] rwlbot[11]=rwlt[11] rwlbot[12]=rwlt[12] rwlbot[13]=rwlt[13]
 rwlbot[14]=rwlt[14] rwlbot[15]=rwlt[15] rwlbot[16]=rwlt[16] rwlbot[17]=rwlt[17] rwlbot[18]=rwlt[18] rwlbot[19]=rwlt[19] rwlbot[20]=rwlt[20]
 rwlbot[21]=rwlt[21] rwlbot[22]=rwlt[22] rwlbot[23]=rwlt[23] rwlbot[24]=rwlt[24] rwlbot[25]=rwlt[25] rwlbot[26]=rwlt[26] rwlbot[27]=rwlt[27]
 rwlbot[28]=rwlt[28] rwlbot[29]=rwlt[29] rwlbot[30]=rwlt[30] rwlbot[31]=rwlt[31] rwlbot[32]=rwlt[32] rwlbot[33]=rwlt[33] rwlbot[34]=rwlt[34]
 rwlbot[35]=rwlt[35] rwlbot[36]=rwlt[36] rwlbot[37]=rwlt[37] rwlbot[38]=rwlt[38] rwlbot[39]=rwlt[39] rwlbot[40]=rwlt[40] rwlbot[41]=rwlt[41]
 rwlbot[42]=rwlt[42] rwlbot[43]=rwlt[43] rwlbot[44]=rwlt[44] rwlbot[45]=rwlt[45] rwlbot[46]=rwlt[46] rwlbot[47]=rwlt[47] rwlbot[48]=rwlt[48]
 rwlbot[49]=rwlt[49] rwlbot[50]=rwlt[50] rwlbot[51]=rwlt[51] rwlbot[52]=rwlt[52] rwlbot[53]=rwlt[53] rwlbot[54]=rwlt[54] rwlbot[55]=rwlt[55]
 rwlbot[56]=rwlt[56] rwlbot[57]=rwlt[57] rwlbot[58]=rwlt[58] rwlbot[59]=rwlt[59] rwlbot[60]=rwlt[60] rwlbot[61]=rwlt[61] rwlbot[62]=rwlt[62]
 rwlbot[63]=rwlt[63] rwlbot[64]=rwlt[64] rwlbot[65]=rwlt[65] rwlbot[66]=rwlt[66] rwlbot[67]=rwlt[67] rwlbot[68]=rwlt[68] rwlbot[69]=rwlt[69]
 rwlbot[70]=rwlt[70] rwlbot[71]=rwlt[71] rwlbot[72]=rwlt[72] rwlbot[73]=rwlt[73] rwlbot[74]=rwlt[74] rwlbot[75]=rwlt[75] rwlbot[76]=rwlt[76]
 rwlbot[77]=rwlt[77] rwlbot[78]=rwlt[78] rwlbot[79]=rwlt[79] rwlbot[80]=rwlt[80] rwlbot[81]=rwlt[81] rwlbot[82]=rwlt[82] rwlbot[83]=rwlt[83]
 rwlbot[84]=rwlt[84] rwlbot[85]=rwlt[85] rwlbot[86]=rwlt[86] rwlbot[87]=rwlt[87] rwlbot[88]=rwlt[88] rwlbot[89]=rwlt[89] rwlbot[90]=rwlt[90]
 rwlbot[91]=rwlt[91] rwlbot[92]=rwlt[92] rwlbot[93]=rwlt[93] rwlbot[94]=rwlt[94] rwlbot[95]=rwlt[95] rwlbot[96]=rwlt[96] rwlbot[97]=rwlt[97]
 rwlbot[98]=rwlt[98] rwlbot[99]=rwlt[99] rwlbot[100]=rwlt[100] rwlbot[101]=rwlt[101] rwlbot[102]=rwlt[102] rwlbot[103]=rwlt[103] rwlbot[104]=rwlt[104]
 rwlbot[105]=rwlt[105] rwlbot[106]=rwlt[106] rwlbot[107]=rwlt[107] rwlbot[108]=rwlt[108] rwlbot[109]=rwlt[109] rwlbot[110]=rwlt[110] rwlbot[111]=rwlt[111]
 rwlbot[112]=rwlt[112] rwlbot[113]=rwlt[113] rwlbot[114]=rwlt[114] rwlbot[115]=rwlt[115] rwlbot[116]=rwlt[116] rwlbot[117]=rwlt[117] rwlbot[118]=rwlt[118]
 rwlbot[119]=rwlt[119] rwlbot[120]=rwlt[120] rwlbot[121]=rwlt[121] rwlbot[122]=rwlt[122] rwlbot[123]=rwlt[123] rwlbot[124]=rwlt[124] rwlbot[125]=rwlt[125]
 rwlbot[126]=rwlt[126] rwlbot[127]=rwlt[127] rwlbot[128]=rwlt[128] rwlbot[129]=rwlt[129] rwlbot[130]=rwlt[130] rwlbot[131]=rwlt[131] rwlbot[132]=rwlt[132]
 rwlbot[133]=rwlt[133] rwlbot[134]=rwlt[134] rwlbot[135]=rwlt[135] rwlbot[136]=rwlt[136] rwlbot[137]=rwlt[137] rwlbot[138]=rwlt[138] rwlbot[139]=rwlt[139]
 rwlbot[140]=rwlt[140] rwlbot[141]=rwlt[141] rwlbot[142]=rwlt[142] rwlbot[143]=rwlt[143] rwlbot[144]=rwlt[144] rwlbot[145]=rwlt[145] rwlbot[146]=rwlt[146]
 rwlbot[147]=rwlt[147] rwlbot[148]=rwlt[148] rwlbot[149]=rwlt[149] rwlbot[150]=rwlt[150] rwlbot[151]=rwlt[151] rwlbot[152]=rwlt[152] rwlbot[153]=rwlt[153]
 rwlbot[154]=rwlt[154] rwlbot[155]=rwlt[155] rwlbot[156]=rwlt[156] rwlbot[157]=rwlt[157] rwlbot[158]=rwlt[158] rwlbot[159]=rwlt[159] rwlbot[160]=rwlt[160]
 rwlbot[161]=rwlt[161] rwlbot[162]=rwlt[162] rwlbot[163]=rwlt[163] rwlbot[164]=rwlt[164] rwlbot[165]=rwlt[165] rwlbot[166]=rwlt[166] rwlbot[167]=rwlt[167]
 rwlbot[168]=rwlt[168] rwlbot[169]=rwlt[169] rwlbot[170]=rwlt[170] rwlbot[171]=rwlt[171] rwlbot[172]=rwlt[172] rwlbot[173]=rwlt[173] rwlbot[174]=rwlt[174]
 rwlbot[175]=rwlt[175] rwlbot[176]=rwlt[176] rwlbot[177]=rwlt[177] rwlbot[178]=rwlt[178] rwlbot[179]=rwlt[179] rwlbot[180]=rwlt[180] rwlbot[181]=rwlt[181]
 rwlbot[182]=rwlt[182] rwlbot[183]=rwlt[183] rwlbot[184]=rwlt[184] rwlbot[185]=rwlt[185] rwlbot[186]=rwlt[186] rwlbot[187]=rwlt[187] rwlbot[188]=rwlt[188]
 rwlbot[189]=rwlt[189] rwlbot[190]=rwlt[190] rwlbot[191]=rwlt[191] rwlbot[192]=rwlt[192] rwlbot[193]=rwlt[193] rwlbot[194]=rwlt[194] rwlbot[195]=rwlt[195]
 rwlbot[196]=rwlt[196] rwlbot[197]=rwlt[197] rwlbot[198]=rwlt[198] rwlbot[199]=rwlt[199] rwlbot[200]=rwlt[200] rwlbot[201]=rwlt[201] rwlbot[202]=rwlt[202]
 rwlbot[203]=rwlt[203] rwlbot[204]=rwlt[204] rwlbot[205]=rwlt[205] rwlbot[206]=rwlt[206] rwlbot[207]=rwlt[207] rwlbot[208]=rwlt[208] rwlbot[209]=rwlt[209]
 rwlbot[210]=rwlt[210] rwlbot[211]=rwlt[211] rwlbot[212]=rwlt[212] rwlbot[213]=rwlt[213] rwlbot[214]=rwlt[214] rwlbot[215]=rwlt[215] rwlbot[216]=rwlt[216]
 rwlbot[217]=rwlt[217] rwlbot[218]=rwlt[218] rwlbot[219]=rwlt[219] rwlbot[220]=rwlt[220] rwlbot[221]=rwlt[221] rwlbot[222]=rwlt[222] rwlbot[223]=rwlt[223]
 rwlbot[224]=rwlt[224] rwlbot[225]=rwlt[225] rwlbot[226]=rwlt[226] rwlbot[227]=rwlt[227] rwlbot[228]=rwlt[228] rwlbot[229]=rwlt[229] rwlbot[230]=rwlt[230]
 rwlbot[231]=rwlt[231] rwlbot[232]=rwlt[232] rwlbot[233]=rwlt[233] rwlbot[234]=rwlt[234] rwlbot[235]=rwlt[235] rwlbot[236]=rwlt[236] rwlbot[237]=rwlt[237]
 rwlbot[238]=rwlt[238] rwlbot[239]=rwlt[239] rwlbot[240]=rwlt[240] rwlbot[241]=rwlt[241] rwlbot[242]=rwlt[242] rwlbot[243]=rwlt[243] rwlbot[244]=rwlt[244]
 rwlbot[245]=rwlt[245] rwlbot[246]=rwlt[246] rwlbot[247]=rwlt[247] rwlbot[248]=rwlt[248] rwlbot[249]=rwlt[249] rwlbot[250]=rwlt[250] rwlbot[251]=rwlt[251]
 rwlbot[252]=rwlt[252] rwlbot[253]=rwlt[253] rwlbot[254]=rwlt[254] rwlbot[255]=rwlt[255] cmselbot[0]=cm[0] cmselbot[1]=cm[1] cmselbot[2]=cm[2]
 cmselbot[3]=cm[3] cmselbot[4]=cm[4] cmselbot[5]=cm[5] cmselbot[6]=cm[6] cmselbot[7]=cm[7] cmselbot[8]=cm[8] cmselbot[9]=cm[9]
 cmselbot[10]=cm[10] cmselbot[11]=cm[11] cmselbot[12]=cm[12] cmselbot[13]=cm[13] cmselbot[14]=cm[14] cmselbot[15]=cm[15] cmselbot[16]=cm[16]
 cmselbot[17]=cm[17] cmselbot[18]=cm[18] cmselbot[19]=cm[19] cmselbot[20]=cm[20] cmselbot[21]=cm[21] cmselbot[22]=cm[22] cmselbot[23]=cm[23]
 cmselbot[24]=cm[24] cmselbot[25]=cm[25] cmselbot[26]=cm[26] cmselbot[27]=cm[27] cmselbot[28]=cm[28] cmselbot[29]=cm[29] cmselbot[30]=cm[30]
 cmselbot[31]=cm[31] lblpchglftbot[0]=lblpchglft[0] lblpchglftbot[1]=lblpchglft[1] lblpchglftbot[2]=lblpchglft[2] lblpchglftbot[3]=lblpchglft[3] lblpchgrgtbot[0]=lblpchgrgt[0] lblpchgrgtbot[1]=lblpchgrgt[1]
 lblpchgrgtbot[2]=lblpchgrgt[2] lblpchgrgtbot[3]=lblpchgrgt[3]}}
}

}
