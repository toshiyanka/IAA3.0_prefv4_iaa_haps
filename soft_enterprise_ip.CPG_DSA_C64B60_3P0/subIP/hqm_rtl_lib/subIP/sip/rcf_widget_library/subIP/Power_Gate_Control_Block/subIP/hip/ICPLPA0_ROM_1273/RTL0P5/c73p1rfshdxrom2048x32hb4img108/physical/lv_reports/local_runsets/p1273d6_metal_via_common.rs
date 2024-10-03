// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_metal_via_common.rs.rca 1.5 Fri Mar 29 11:55:30 2013 dgthakur Experimental $
//
// $Log: p1273d6_metal_via_common.rs.rca $
// 
//  Revision: 1.5 Fri Mar 29 11:55:30 2013 dgthakur
//  Metal 8 binning width 00 relabling to 01 (to enable reuse of metal code between 1272 M6 and 1272 M8).
// 
//  Revision: 1.4 Fri Mar 29 00:44:09 2013 dgthakur
//  Added missing m11 width.
// 
//  Revision: 1.3 Thu Mar 28 23:24:03 2013 nhkhan1
//  added v8max_width
// 
//  Revision: 1.2 Tue Mar 26 14:22:43 2013 dgthakur
//  Upodated binning for m9/10/11.
// 
//  Revision: 1.1 Fri Aug 24 11:11:56 2012 dgthakur
//  Metal via common file for 1273.6
//



//*** p1273 DOT6 metal via common definitions file - Dipto Thakurta Started 16Aug12 *** 
#ifndef _P1273D6_METAL_VIA_COMMON_RS_
#define _P1273D6_METAL_VIA_COMMON_RS_


//UPTO METAL2 IT IS COMMON BETWEEN 1272 and 1273
//SO THIS FILE IS FOR V2/M3 AND UPWARDS


//Horizontal and vertical edges for the unbinned (rectangular) layers.
//perp_edge can be used as the line end for these rectangular layers.  
//For the binned metal layers, these edges are generated in the macro call.
m2para_edge = angle_edge_dir(metal2bc, m2perp_dir); 
m2perp_edge = angle_edge_dir(metal2bc, m2para_dir); 

m3para_edge = angle_edge_dir(metal3bc, m3perp_dir); 
m3perp_edge = angle_edge_dir(metal3bc, m3para_dir); 

m4para_edge = angle_edge_dir(metal4bc, m4perp_dir); 
m4perp_edge = angle_edge_dir(metal4bc, m4para_dir); 

//m5para_edge = angle_edge_dir(metal5bc, m5perp_dir); 
//m5perp_edge = angle_edge_dir(metal5bc, m5para_dir); 


//Max width, min width and line end definitions for rectangular metal layers
m3min_width = M3S_01;
m3max_width = M3L_06;

m4min_width = M4S_01;
m4max_width = M4L_06;

//m5min_width = M5S_01;
m5max_width = M5_15;
m6max_width = M6_15;

m3line_end  = angle_edge(metal3bc, angles = non_gate_angle);       //hori edge
m4line_end  = angle_edge(metal4bc, angles =     gate_angle);       //vert edge
//m5line_end  = angle_edge(metal5bc, angles = non_gate_angle);       //hori edge

v5max_width = V5_15;
v6max_width = V6_16;
v7max_width = V7_06;
v8max_width = V8_153;


//METAL5 BINNING BELOW cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#define mid 5

mx(_ogd_width) = {MX(10)};
mx(_pgd_width) = {MX(01), MX(02), MX(03), MX(12), MX(04), MX(05), MX(06), MX(07), MX(08), MX(09), MX(10), MX(11)};

DRBIN_PgdOgd()
DRBIN_GetPGDWidthAll(01,02,03,12,04,05,06,07,08,09,10,11)
DRBIN_GetOGDWidthOne(10)
DRBIN_GetBadWidthAndEdges()

#undef mid

//Special need for M5 jog rules (un-extended metal bins)
m5ogd10_not_ext = copy(OGDOut.b0);
m5pgd10_not_ext = copy(PGDOut.b10);


/////////////RECTANGULAR OGD LINES M5_13/14/15 ADDED FOR 1273 M5 //////////// 

//Rebin the bad metal and redefine bad metal.
m5rec = rectangles(metal5) and m5Bad;
m5pgd13 = drWidth(m5rec, M5_13, non_gate_dir);     //new
m5pgd14 = drWidth(m5rec, M5_14, non_gate_dir);     //new
m5pgd15 = drWidth(m5rec, M5_15, non_gate_dir);     //new
m5wide = (m5pgd13 or m5pgd14) or m5pgd15;
m5Bad = m5Bad not m5wide;                      //redefine

//copy dir independent for v5 code
m5para13 = copy(m5pgd13);
m5para14 = copy(m5pgd14);
m5para15 = copy(m5pgd15);

//Redefine edges
m5pgd13ve = angle_edge_dir(m5pgd13, non_gate_dir);  //new
m5pgd14ve = angle_edge_dir(m5pgd14, non_gate_dir);  //new
m5pgd15ve = angle_edge_dir(m5pgd15, non_gate_dir);  //new
m5pgdwideve = m5pgd13ve or_edge (m5pgd14ve or_edge m5pgd15ve);
m5pgdallve = m5pgdallve or_edge m5pgdwideve;  //redefine
//
m5pgd13he = angle_edge_dir(m5pgd13, gate_dir);  //new
m5pgd14he = angle_edge_dir(m5pgd14, gate_dir);  //new
m5pgd15he = angle_edge_dir(m5pgd15, gate_dir);  //new 
m5pgdallhe = (m5pgdallhe or_edge m5pgd13he) or_edge (m5pgd14he or_edge m5pgd15he);  //redefine

//Redefine line end
m5wide_le = angle_edge_dir(m5wide, gate_dir); //wide line ends
m5_line_end = (m5_line_end not_coincident_edge m5pgdwideve) or_edge m5wide_le;   //redefine


//1273 M5 new metal bin additions w13/14/15 above
////////////////////////////////////////////////////////////////////////////////


//METAL6 BINNING BELOW cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#define mid 6

mx(_pgd_width) = {MX(10)};
mx(_ogd_width) = {MX(01), MX(02), MX(03), MX(12), MX(04), MX(05), MX(06), MX(07), MX(08), MX(09), MX(10), MX(11)};

DRBIN_PgdOgd()
DRBIN_GetPGDWidthOne(10)
DRBIN_GetOGDWidthAll(01,02,03,12,04,05,06,07,08,09,10,11)
DRBIN_GetBadWidthAndEdges()

#undef mid

//Special need for M6 jog rules (un-extended metal bins)
m6ogd10_not_ext = copy(OGDOut.b10);
m6pgd10_not_ext = copy(PGDOut.b0);


/////////////RECTANGULAR OGD LINES M6_13/14/15 ADDED FOR 1273 M6 //////////// 

//Rebin the bad metal and redefine bad metal.
m6rec = rectangles(metal6) and m6Bad;
m6ogd13 = drWidth(m6rec, M6_13, gate_dir);     //new
m6ogd14 = drWidth(m6rec, M6_14, gate_dir);     //new
m6ogd15 = drWidth(m6rec, M6_15, gate_dir);     //new
m6wide = (m6ogd13 or m6ogd14) or m6ogd15;
m6Bad = m6Bad not m6wide;                      //redefine

//copy dir independent for v6 code
m6para13 = copy(m6ogd13);
m6para14 = copy(m6ogd14);
m6para15 = copy(m6ogd15);

//Redefine edges
m6ogd13he = angle_edge_dir(m6ogd13, gate_dir);  //new
m6ogd14he = angle_edge_dir(m6ogd14, gate_dir);  //new
m6ogd15he = angle_edge_dir(m6ogd15, gate_dir);  //new
m6ogdwidehe = m6ogd13he or_edge (m6ogd14he or_edge m6ogd15he);
m6ogdallhe = m6ogdallhe or_edge m6ogdwidehe;  //redefine
//
m6ogd13ve = angle_edge_dir(m6ogd13, non_gate_dir);  //new
m6ogd14ve = angle_edge_dir(m6ogd14, non_gate_dir);  //new
m6ogd15ve = angle_edge_dir(m6ogd15, non_gate_dir);  //new 
m6ogdallve = (m6ogdallve or_edge m6ogd13ve) or_edge (m6ogd14ve or_edge m6ogd15ve);  //redefine

//Redefine line end
m6wide_le = angle_edge_dir(m6wide, non_gate_dir); //wide line ends
m6_line_end = (m6_line_end not_coincident_edge m6ogdwidehe) or_edge m6wide_le;   //redefine


//1273 M6 new metal bin additions w13/14/15 above
////////////////////////////////////////////////////////////////////////////////




//METAL7 BINNING BELOW cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#define mid 7

mx(_pgd_width) = {MX(01), MX(02), MX(03), MX(04), MX(05), MX(06), MX(07)};
mx(_ogd_width) = {MX(03)};

DRBIN_PgdOgd()
DRBIN_GetPGDWidthAll(01,02,03,04,05,06,07,99,99,99,99,99)
DRBIN_GetOGDWidthOne(03)
DRBIN_GetBadWidthAndEdges()

#undef mid


//METAL8 BINNING BELOW cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
//Copy from 1272 M6

#define mid 8

mx(_pgd_width) = {MX(03)};
mx(_ogd_width) = {MX(00), MX(02), MX(03), MX(04), MX(05), MX(06), MX(07), MX(08)};

//w00 is mapped to w01 in code
DRBIN_PgdOgd()
DRBIN_GetPGDWidthOne(03)
DRBIN_GetOGDWidthAll(01,02,03,04,05,06,07,08,99,99,99,99)
DRBIN_GetBadWidthAndEdges()

#undef mid


//METAL8 BINNING ABOVE cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


//METAL9 BINNING BELOW cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#define mid 9

mx(_pgd_width) = {MX(00), MX(02), MX(03), MX(04), MX(05), MX(06), MX(07), MX(08), MX(09)};
mx(_ogd_width) = {MX(04)};

//w00 is mapped to w01 in code
DRBIN_PgdOgd()
DRBIN_GetPGDWidthAll(00,02,03,04,05,06,07,08,09,99,99,99)
DRBIN_GetOGDWidthOne(04)
DRBIN_GetBadWidthAndEdges()

#undef mid

//METAL9 BINNING ABOVE cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc



//METAL10 BINNING BELOW cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
#define mid 10

mx(_pgd_width) = {MX(02), MX(04)};
mx(_ogd_width) = {MX(01), MX(02), MX(03), MX(04), MX(05), MX(06), MX(07), MX(08), MX(09)};

DRBIN_PgdOgd()
DRBIN_GetPGDWidthAllPerp(01,02,99,99,99,99,99,99,99,99,99,99)
DRBIN_GetOGDWidthAll(01,02,03,04,05,06,07,08,09,99,99,99)
DRBIN_GetBadWidthAndEdges()

#undef mid
//METAL10 BINNING ABOVE cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc



//METAL11 BINNING BELOW cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
#define mid 11

mx(_pgd_width) = {MX(01), MX(02), MX(03), MX(04), MX(05), MX(06), MX(07), MX(08), MX(09), MX(10)};
mx(_ogd_width) = {MX(02), MX(03)};

DRBIN_PgdOgd()
DRBIN_GetPGDWidthAll(01,02,03,04,05,06,07,08,09,10,99,99)
DRBIN_GetOGDWidthAllPerp(01,02,99,99,99,99,99,99,99,99,99,99)
DRBIN_GetBadWidthAndEdges()

#undef mid
//METAL11 BINNING ABOVE cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


#endif //_P1273D6_METAL_VIA_COMMON_RS_


