// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_assignMWOA.rs.rca 1.7 Fri Jun 20 12:24:13 2014 kperrey Experimental $

// $Log: p1273dx_assignMWOA.rs.rca $
// 
//  Revision: 1.7 Fri Jun 20 12:24:13 2014 kperrey
//  add support for nwell/nwellesd/pwell_subiso pins/ports
// 
//  Revision: 1.6 Fri Jan 24 10:44:22 2014 kperrey
//  remove metalc11 refrence ; no longer exists
// 
//  Revision: 1.5 Wed Dec 18 18:56:19 2013 kperrey
//  updated to reflect tmc1 name change and mcr2 define
// 
//  Revision: 1.4 Tue Oct 29 20:32:55 2013 kperrey
//  hsd 1926; add layer generations from MCR layer
// 
//  Revision: 1.3 Thu Mar 28 19:00:07 2013 kperrey
//  add m12 pins/ports
// 
//  Revision: 1.2 Fri Jul 27 14:06:17 2012 kperrey
//  add rdl pin/port info
// 
//  Revision: 1.1 Mon Sep 19 22:02:01 2011 kperrey
//  derived from 1272
// 
// 

#ifndef _P1273DX_ASSIGNMWOA_RS_
#define _P1273DX_ASSIGNMWOA_RS_

// read in the milkyway pins - they are on the maskDrawing layer

#ifdef _drMWData
NWELLMWPIN     = assign({{11,0}}, milkyway = {objects = {PIN}}); // nwell;maskDrawing   
NWELLESDMWPIN  = assign({{19,0}}, milkyway = {objects = {PIN}}); // nwellesd;maskDrawing   
PWELLSUBISOMWPIN  = assign({{36,6}}, milkyway = {objects = {PIN}}); // pwell;subiso   
NDIFFMWPIN     = assign({{1,0}}, milkyway = {objects = {PIN}}); // ndiff;maskDrawing   
POLY1MWPIN     = assign({{2,0}}, milkyway = {objects = {PIN}}); // poly;maskDrawing   
MET0MWPIN      = assign({{55,0}}, milkyway = {objects = {PIN}}); // metal0;maskDrawing   
METC0MWPIN      = assign({{241,0}}, milkyway = {objects = {PIN}}); // metalc0;maskDrawing   
MET1MWPIN      = assign({{4,0}}, milkyway = {objects = {PIN}}); // metal1;maskDrawing   
METC1MWPIN      = assign({{111,0}}, milkyway = {objects = {PIN}}); // metalc1;maskDrawing   
DIFFCONMWPIN   = assign({{5,0}}, milkyway = {objects = {PIN}}); // diffcon;maskDrawing   
POLYCONMWPIN   = assign({{6,0}}, milkyway = {objects = {PIN}}); // polycon;maskDrawing   
PDIFFMWPIN     = assign({{8,0}}, milkyway = {objects = {PIN}}); // pdiff;maskDrawing   
MET2MWPIN      = assign({{14,0}}, milkyway = {objects = {PIN}}); // metal2;maskDrawing   
METC2MWPIN      = assign({{112,0}}, milkyway = {objects = {PIN}}); // metalc2;maskDrawing   
MET3MWPIN      = assign({{18,0}}, milkyway = {objects = {PIN}}); // metal3;maskDrawing   
METC3MWPIN      = assign({{113,0}}, milkyway = {objects = {PIN}}); // metalc3;maskDrawing   
MET4MWPIN      = assign({{22,0}}, milkyway = {objects = {PIN}}); // metal4;maskDrawing   
METC4MWPIN      = assign({{114,0}}, milkyway = {objects = {PIN}}); // metalc4;maskDrawing   
MET5MWPIN      = assign({{26,0}}, milkyway = {objects = {PIN}}); // metal5;maskDrawing   
METC5MWPIN      = assign({{115,0}}, milkyway = {objects = {PIN}}); // metalc5;maskDrawing   
MET6MWPIN      = assign({{30,0}}, milkyway = {objects = {PIN}}); // metal6;maskDrawing   
METC6MWPIN      = assign({{231,0}}, milkyway = {objects = {PIN}}); // metalc6;maskDrawing   
MET7MWPIN      = assign({{34,0}}, milkyway = {objects = {PIN}}); // metal7;maskDrawing   
METC7MWPIN      = assign({{232,0}}, milkyway = {objects = {PIN}}); // metalc7;maskDrawing   
MET8MWPIN      = assign({{38,0}}, milkyway = {objects = {PIN}}); // metal8;maskDrawing   
METC8MWPIN      = assign({{233,0}}, milkyway = {objects = {PIN}}); // metalc8;maskDrawing   
TM1MWPIN       = assign({{42,0}}, milkyway = {objects = {PIN}}); // tm1;maskDrawing   
MET9MWPIN      = assign({{46,0}}, milkyway = {objects = {PIN}}); // metal9;maskDrawing   
METC9MWPIN      = assign({{235,0}}, milkyway = {objects = {PIN}}); // metalc9;maskDrawing   
MET10MWPIN     = assign({{54,0}}, milkyway = {objects = {PIN}}); // metal10;maskDrawing   
METC10MWPIN     = assign({{236,0}}, milkyway = {objects = {PIN}}); // metalc10;maskDrawing   
MET11MWPIN     = assign({{58,0}}, milkyway = {objects = {PIN}}); // metal11;maskDrawing   
MET12MWPIN     = assign({{62,0}}, milkyway = {objects = {PIN}}); // metal12;maskDrawing   
MTJMWPIN     = assign({{186,0}}, milkyway = {objects = {PIN}}); // mtj;maskDrawing   
RDLMWPIN     = assign({{217,0}}, milkyway = {objects = {PIN}}); // rdl;maskDrawing   
MCRMWPIN     = assign({{70,0}}, milkyway = {objects = {PIN}}); // mcr;maskDrawing   
MCR2MWPIN     = assign({{237,0}}, milkyway = {objects = {PIN}}); // mcr2;maskDrawing   

// now or the MWPIN and drawn PORTS together
nwellpin = NWELLMWPIN or NWELLPORT;
nwellesdpin = NWELLESDMWPIN  or NWELLESDPORT;
pwellsubisopin = PWELLSUBISOMWPIN or PWELLSUBISOPORT;
ndiffpin = NDIFFMWPIN or NDIFFPORT;
poly1pin = POLY1MWPIN or POLY1PORT;
met0pin = MET0MWPIN or MET0PORT;
metc0pin = METC0MWPIN or METC0PORT;
met1pin = MET1MWPIN or MET1PORT;
diffconpin = DIFFCONMWPIN or DIFFCONPORT;
polyconpin = POLYCONMWPIN or POLYCONPORT;
pdiffpin = PDIFFMWPIN or PDIFFPORT;
met1pin = MET1MWPIN or MET1PORT;
metc1pin = METC1MWPIN or METC1PORT;
met2pin = MET2MWPIN or MET2PORT;
metc2pin = METC2MWPIN or METC2PORT;
met3pin = MET3MWPIN or MET3PORT;
metc3pin = METC3MWPIN or METC3PORT;
met4pin = MET4MWPIN or MET4PORT;
metc4pin = METC4MWPIN or METC4PORT;
met5pin = MET5MWPIN or MET5PORT;
metc5pin = METC5MWPIN or METC5PORT;
met6pin = MET6MWPIN or MET6PORT;
metc6pin = METC6MWPIN or METC6PORT;
met7pin = MET7MWPIN or MET7PORT;
metc7pin = METC7MWPIN or METC7PORT;
met8pin = MET8MWPIN or MET8PORT;
metc8pin = METC8MWPIN or METC8PORT;
tm1pin = TM1MWPIN or TM1PORT;
met9pin = MET9MWPIN or MET9PORT;
metc9pin = METC9MWPIN or METC9PORT;
met10pin = MET10MWPIN or MET10PORT;
metc10pin = METC10MWPIN or METC10PORT;
met11pin = MET11MWPIN or MET11PORT;
met12pin = MET12MWPIN or MET12PORT;
mtjpin = MTJMWPIN or MTJPORT;
rdlpin = RDLMWPIN or RDLPORT;
mcrpin = MCRMWPIN or MCRPORT;
mcr2pin = MCR2MWPIN or MCR2PORT;

// merge MW boundary layer and normal boundary layer
CELLBOUNDARY = MWBOUNDARY or CELLBOUNDARY;

#else  // not _drMWData

#ifdef _drOAData
NWELLOAPIN     = assign({{11,0}}, openaccess = {objects = {PIN}}); // nwell;maskDrawing   
NWELLESDOAPIN  = assign({{19,0}}, openaccess = {objects = {PIN}}); // nwellesd;maskDrawing   
PWELLSUBISOOAPIN  = assign({{36,6}}, openaccess = {objects = {PIN}}); // pwell;subiso   
NDIFFOAPIN     = assign({{1,0}}, openaccess = {objects = {PIN}}); // ndiff;maskDrawing   
POLY1OAPIN     = assign({{2,0}}, openaccess = {objects = {PIN}}); // poly;maskDrawing   
MET0OAPIN      = assign({{55,0}}, openaccess = {objects = {PIN}}); // metal0;maskDrawing   
METC0OAPIN      = assign({{241,0}}, openaccess = {objects = {PIN}}); // metalc0;maskDrawing   
MET1OAPIN      = assign({{4,0}}, openaccess = {objects = {PIN}}); // metal1;maskDrawing   
METC1OAPIN      = assign({{111,0}}, openaccess = {objects = {PIN}}); // metalc1;maskDrawing   
DIFFCONOAPIN   = assign({{5,0}}, openaccess = {objects = {PIN}}); // diffcon;maskDrawing   
POLYCONOAPIN   = assign({{6,0}}, openaccess = {objects = {PIN}}); // polycon;maskDrawing   
PDIFFOAPIN     = assign({{8,0}}, openaccess = {objects = {PIN}}); // pdiff;maskDrawing   
MET2OAPIN      = assign({{14,0}}, openaccess = {objects = {PIN}}); // metal2;maskDrawing   
METC2OAPIN      = assign({{112,0}}, openaccess = {objects = {PIN}}); // metalc2;maskDrawing   
MET3OAPIN      = assign({{18,0}}, openaccess = {objects = {PIN}}); // metal3;maskDrawing   
METC3OAPIN      = assign({{113,0}}, openaccess = {objects = {PIN}}); // metalc3;maskDrawing   
MET4OAPIN      = assign({{22,0}}, openaccess = {objects = {PIN}}); // metal4;maskDrawing   
METC4OAPIN      = assign({{114,0}}, openaccess = {objects = {PIN}}); // metalc4;maskDrawing   
MET5OAPIN      = assign({{26,0}}, openaccess = {objects = {PIN}}); // metal5;maskDrawing   
METC5OAPIN      = assign({{115,0}}, openaccess = {objects = {PIN}}); // metalc5;maskDrawing   
MET6OAPIN      = assign({{30,0}}, openaccess = {objects = {PIN}}); // metal6;maskDrawing   
METC6OAPIN      = assign({{231,0}}, openaccess = {objects = {PIN}}); // metalc6;maskDrawing   
MET7OAPIN      = assign({{34,0}}, openaccess = {objects = {PIN}}); // metal7;maskDrawing   
METC7OAPIN      = assign({{232,0}}, openaccess = {objects = {PIN}}); // metalc7;maskDrawing   
MET8OAPIN      = assign({{38,0}}, openaccess = {objects = {PIN}}); // metal8;maskDrawing   
METC8OAPIN      = assign({{233,0}}, openaccess = {objects = {PIN}}); // metalc8;maskDrawing   
TM1OAPIN       = assign({{42,0}}, openaccess = {objects = {PIN}}); // tm1;maskDrawing   
MET9OAPIN      = assign({{46,0}}, openaccess = {objects = {PIN}}); // metal9;maskDrawing   
METC9OAPIN      = assign({{235,0}}, openaccess = {objects = {PIN}}); // metalc9;maskDrawing   
MET10OAPIN     = assign({{54,0}}, openaccess = {objects = {PIN}}); // metal10;maskDrawing   
METC10OAPIN     = assign({{236,0}}, openaccess = {objects = {PIN}}); // metalc10;maskDrawing   
MET11OAPIN     = assign({{58,0}}, openaccess = {objects = {PIN}}); // metal11;maskDrawing   
MET12OAPIN     = assign({{62,0}}, openaccess = {objects = {PIN}}); // metal12;maskDrawing   
MTJOAPIN     = assign({{186,0}}, openaccess = {objects = {PIN}}); // mtj;maskDrawing   
RDLOAPIN     = assign({{217,0}}, openaccess = {objects = {PIN}}); // rdl;maskDrawing   
MCROAPIN     = assign({{70,0}}, openaccess = {objects = {PIN}}); // mcr;maskDrawing   
MCR2OAPIN     = assign({{237,0}}, openaccess = {objects = {PIN}}); // mcr2;maskDrawing   

// now or the OAPIN and drawn PORTS together
nwellpin = NWELLOAPIN or NWELLPORT;
nwellesdpin = NWELLESDOAPIN  or NWELLESDPORT;
pwellsubisopin = PWELLSUBISOOAPIN or PWELLSUBISOPORT;
ndiffpin = NDIFFOAPIN or NDIFFPORT;
poly1pin = POLY1OAPIN or POLY1PORT;
met0pin = MET0OAPIN or MET0PORT;
metc0pin = METC0OAPIN or METC0PORT;
met1pin = MET1OAPIN or MET1PORT;
diffconpin = DIFFCONOAPIN or DIFFCONPORT;
polyconpin = POLYCONOAPIN or POLYCONPORT;
pdiffpin = PDIFFOAPIN or PDIFFPORT;
met1pin = MET1OAPIN or MET1PORT;
metc1pin = METC1OAPIN or METC1PORT;
met2pin = MET2OAPIN or MET2PORT;
metc2pin = METC2OAPIN or METC2PORT;
met3pin = MET3OAPIN or MET3PORT;
metc3pin = METC3OAPIN or METC3PORT;
met4pin = MET4OAPIN or MET4PORT;
metc4pin = METC4OAPIN or METC4PORT;
met5pin = MET5OAPIN or MET5PORT;
metc5pin = METC5OAPIN or METC5PORT;
met6pin = MET6OAPIN or MET6PORT;
metc6pin = METC6OAPIN or METC6PORT;
met7pin = MET7OAPIN or MET7PORT;
metc7pin = METC7OAPIN or METC7PORT;
met8pin = MET8OAPIN or MET8PORT;
metc8pin = METC8OAPIN or METC8PORT;
tm1pin = TM1OAPIN or TM1PORT;
met9pin = MET9OAPIN or MET9PORT;
metc9pin = METC9OAPIN or METC9PORT;
met10pin = MET10OAPIN or MET10PORT;
metc10pin = METC10OAPIN or METC10PORT;
met11pin = MET11OAPIN or MET11PORT;
met12pin = MET12OAPIN or MET12PORT;
mtjpin = MTJOAPIN or MTJPORT;
rdlpin = RDLOAPIN or RDLPORT;
mcrpin = MCROAPIN or MCRPORT;
mcr2pin = MCR2OAPIN or MCR2PORT;

#else    // copy ports to since not milkyway or openaccess  

nwellpin = copy(NWELLPORT);
nwellesdpin = copy(NWELLESDPORT);
pwellsubisopin = copy(PWELLSUBISOPORT);
ndiffpin = copy(NDIFFPORT);
poly1pin = copy(POLY1PORT);
met0pin = copy(MET0PORT);
metc0pin = copy(METC0PORT);
diffconpin = copy(DIFFCONPORT);
polyconpin = copy(POLYCONPORT);
pdiffpin = copy(PDIFFPORT);
met1pin = copy(MET1PORT);
metc1pin = copy(METC1PORT);
met2pin = copy(MET2PORT);
metc2pin = copy(METC2PORT);
met3pin = copy(MET3PORT);
metc3pin = copy(METC3PORT);
met4pin = copy(MET4PORT);
metc4pin = copy(METC4PORT);
met5pin = copy(MET5PORT);
metc5pin = copy(METC5PORT);
met6pin = copy(MET6PORT);
metc6pin = copy(METC6PORT);
met7pin = copy(MET7PORT);
metc7pin = copy(METC7PORT);
met8pin = copy(MET8PORT);
metc8pin = copy(METC8PORT);
tm1pin = copy(TM1PORT);
met9pin = copy(MET9PORT);
metc9pin = copy(METC9PORT);
met10pin = copy(MET10PORT);
metc10pin = copy(METC10PORT);
met11pin = copy(MET11PORT);
met12pin = copy(MET12PORT);
mtjpin = copy(MTJPORT);
rdlpin = copy(RDLPORT);
mcrpin = copy(MCRPORT);
mcr2pin = copy(MCR2PORT);

#endif   // _drOAData

#endif   // _drMWData

#endif  //_P1273DX_ASSIGNMWOA_RS_
