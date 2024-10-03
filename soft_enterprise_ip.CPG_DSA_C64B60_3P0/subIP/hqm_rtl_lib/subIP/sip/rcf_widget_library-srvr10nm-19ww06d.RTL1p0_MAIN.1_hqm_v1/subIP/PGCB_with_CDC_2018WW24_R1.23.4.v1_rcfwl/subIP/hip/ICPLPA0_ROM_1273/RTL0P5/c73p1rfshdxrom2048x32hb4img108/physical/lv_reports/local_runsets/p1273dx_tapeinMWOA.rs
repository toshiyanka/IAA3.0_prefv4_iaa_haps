// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_tapeinMWOA.rs.rca 1.2 Tue Sep 23 17:21:34 2014 kperrey Experimental $

// $Log: p1273dx_tapeinMWOA.rs.rca $
// 
//  Revision: 1.2 Tue Sep 23 17:21:34 2014 kperrey
//  when reading in the mw/oa pins they are really on dt=0 maskDrawing
// 
//  Revision: 1.1 Thu Sep 11 20:43:05 2014 kperrey
//  hsd 2695 ; need to preserve pin/ports from MW in the tapin flow
// 

#ifndef _P1273DX_TAPEINMWOA_RS_
#define _P1273DX_TAPEINMWOA_RS_

// read in the milkyway pins - they are on the maskDrawing layer

#if defined(_drMWData)
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
   
#elif defined(_drOADATA)  
   
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
   
#endif   //  OAdata

// push the ports/pins to the output
#if defined(_drMWData)
   drPassthruStack.push_back({NWELLMWPIN, {11,2}}); // nwell;portDrawing   
   drPassthruStack.push_back({NWELLESDMWPIN, {19,2}}); // nwellesd;portDrawing   
   drPassthruStack.push_back({PWELLSUBISOMWPIN, {36,6}}); // pwell;subiso   
   drPassthruStack.push_back({NDIFFMWPIN, {1,2}}); // ndiff;portDrawing   
   drPassthruStack.push_back({POLY1MWPIN, {2,2}}); // poly;portDrawing   
   drPassthruStack.push_back({MET0MWPIN, {55,2}}); // metal0;portDrawing   
   drPassthruStack.push_back({METC0MWPIN, {241,2}}); // metalc0;portDrawing   
   drPassthruStack.push_back({MET1MWPIN, {4,2}}); // metal1;portDrawing   
   drPassthruStack.push_back({METC1MWPIN, {111,2}}); // metalc1;portDrawing   
   drPassthruStack.push_back({DIFFCONMWPIN, {5,2}}); // diffcon;portDrawing   
   drPassthruStack.push_back({POLYCONMWPIN, {6,2}}); // polycon;portDrawing   
   drPassthruStack.push_back({PDIFFMWPIN, {8,2}}); // pdiff;portDrawing   
   drPassthruStack.push_back({MET2MWPIN, {14,2}}); // metal2;portDrawing   
   drPassthruStack.push_back({METC2MWPIN, {112,2}}); // metalc2;portDrawing   
   drPassthruStack.push_back({MET3MWPIN, {18,2}}); // metal3;portDrawing   
   drPassthruStack.push_back({METC3MWPIN, {113,2}}); // metalc3;portDrawing   
   drPassthruStack.push_back({MET4MWPIN, {22,2}}); // metal4;portDrawing   
   drPassthruStack.push_back({METC4MWPIN, {114,2}}); // metalc4;portDrawing   
   drPassthruStack.push_back({MET5MWPIN, {26,2}}); // metal5;portDrawing   
   drPassthruStack.push_back({METC5MWPIN, {115,2}}); // metalc5;portDrawing   
   drPassthruStack.push_back({MET6MWPIN, {30,2}}); // metal6;portDrawing   
   drPassthruStack.push_back({METC6MWPIN, {231,2}}); // metalc6;portDrawing   
   drPassthruStack.push_back({MET7MWPIN, {34,2}}); // metal7;portDrawing   
   drPassthruStack.push_back({METC7MWPIN, {232,2}}); // metalc7;portDrawing   
   drPassthruStack.push_back({MET8MWPIN, {38,2}}); // metal8;portDrawing   
   drPassthruStack.push_back({METC8MWPIN, {233,2}}); // metalc8;portDrawing   
   drPassthruStack.push_back({TM1MWPIN, {42,2}}); // tm1;portDrawing   
   drPassthruStack.push_back({MET9MWPIN, {46,2}}); // metal9;portDrawing   
   drPassthruStack.push_back({METC9MWPIN, {235,2}}); // metalc9;portDrawing   
   drPassthruStack.push_back({MET10MWPIN, {54,2}}); // metal10;portDrawing   
   drPassthruStack.push_back({METC10MWPIN, {236,2}}); // metalc10;portDrawing   
   drPassthruStack.push_back({MET11MWPIN, {58,2}}); // metal11;portDrawing   
   drPassthruStack.push_back({MET12MWPIN, {62,2}}); // metal12;portDrawing   
   drPassthruStack.push_back({MTJMWPIN, {186,2}}); // mtj;portDrawing   
   drPassthruStack.push_back({RDLMWPIN, {217,2}}); // rdl;portDrawing   
   drPassthruStack.push_back({MCRMWPIN, {70,2}}); // mcr;portDrawing   
   drPassthruStack.push_back({MCR2MWPIN, {237,2}}); // mcr2;portDrawing   

#elif defined(_drOADATA)  
   drPassthruStack.push_back({NWELLOAPIN, {11,2}}); // nwell;portDrawing   
   drPassthruStack.push_back({NWELLESDOAPIN, {19,2}}); // nwellesd;portDrawing   
   drPassthruStack.push_back({PWELLSUBISOOAPIN, {36,6}}); // pwell;subiso   
   drPassthruStack.push_back({NDIFFOAPIN, {1,2}}); // ndiff;portDrawing   
   drPassthruStack.push_back({POLY1OAPIN, {2,2}}); // poly;portDrawing   
   drPassthruStack.push_back({MET0OAPIN, {55,2}}); // metal0;portDrawing   
   drPassthruStack.push_back({METC0OAPIN, {241,2}}); // metalc0;portDrawing   
   drPassthruStack.push_back({MET1OAPIN, {4,2}}); // metal1;portDrawing   
   drPassthruStack.push_back({METC1OAPIN, {111,2}}); // metalc1;portDrawing   
   drPassthruStack.push_back({DIFFCONOAPIN, {5,2}}); // diffcon;portDrawing   
   drPassthruStack.push_back({POLYCONOAPIN, {6,2}}); // polycon;portDrawing   
   drPassthruStack.push_back({PDIFFOAPIN, {8,2}}); // pdiff;portDrawing   
   drPassthruStack.push_back({MET2OAPIN, {14,2}}); // metal2;portDrawing   
   drPassthruStack.push_back({METC2OAPIN, {112,2}}); // metalc2;portDrawing   
   drPassthruStack.push_back({MET3OAPIN, {18,2}}); // metal3;portDrawing   
   drPassthruStack.push_back({METC3OAPIN, {113,2}}); // metalc3;portDrawing   
   drPassthruStack.push_back({MET4OAPIN, {22,2}}); // metal4;portDrawing   
   drPassthruStack.push_back({METC4OAPIN, {114,2}}); // metalc4;portDrawing   
   drPassthruStack.push_back({MET5OAPIN, {26,2}}); // metal5;portDrawing   
   drPassthruStack.push_back({METC5OAPIN, {115,2}}); // metalc5;portDrawing   
   drPassthruStack.push_back({MET6OAPIN, {30,2}}); // metal6;portDrawing   
   drPassthruStack.push_back({METC6OAPIN, {231,2}}); // metalc6;portDrawing   
   drPassthruStack.push_back({MET7OAPIN, {34,2}}); // metal7;portDrawing   
   drPassthruStack.push_back({METC7OAPIN, {232,2}}); // metalc7;portDrawing   
   drPassthruStack.push_back({MET8OAPIN, {38,2}}); // metal8;portDrawing   
   drPassthruStack.push_back({METC8OAPIN, {233,2}}); // metalc8;portDrawing   
   drPassthruStack.push_back({TM1OAPIN, {42,2}}); // tm1;portDrawing   
   drPassthruStack.push_back({MET9OAPIN, {46,2}}); // metal9;portDrawing   
   drPassthruStack.push_back({METC9OAPIN, {235,2}}); // metalc9;portDrawing   
   drPassthruStack.push_back({MET10OAPIN, {54,2}}); // metal10;portDrawing   
   drPassthruStack.push_back({METC10OAPIN, {236,2}}); // metalc10;portDrawing   
   drPassthruStack.push_back({MET11OAPIN, {58,2}}); // metal11;portDrawing   
   drPassthruStack.push_back({MET12OAPIN, {62,2}}); // metal12;portDrawing   
   drPassthruStack.push_back({MTJOAPIN, {186,2}}); // mtj;portDrawing   
   drPassthruStack.push_back({RDLOAPIN, {217,2}}); // rdl;portDrawing   
   drPassthruStack.push_back({MCROAPIN, {70,2}}); // mcr;portDrawing   
   drPassthruStack.push_back({MCR2OAPIN, {237,2}}); // mcr2;portDrawing   

#endif   //  OAdata

#endif  //_P1273DX_TAPEINMWOA_RS_
