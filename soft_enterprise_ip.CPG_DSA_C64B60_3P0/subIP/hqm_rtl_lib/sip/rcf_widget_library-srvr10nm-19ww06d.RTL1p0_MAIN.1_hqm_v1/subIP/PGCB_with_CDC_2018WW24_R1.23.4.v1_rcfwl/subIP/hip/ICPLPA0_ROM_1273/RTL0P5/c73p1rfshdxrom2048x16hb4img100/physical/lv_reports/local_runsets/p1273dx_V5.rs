// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_V5.rs.rca 1.11 Wed Aug 22 10:40:23 2012 dgthakur Experimental $
//
// $Log: p1273dx_V5.rs.rca $
// 
//  Revision: 1.11 Wed Aug 22 10:40:23 2012 dgthakur
//  Now using direction independent reusable via file 1273/p1273dx_MX80pitch52via.rs
// 
//  Revision: 1.10 Mon Apr  2 09:26:08 2012 dgthakur
//  Relaxing V5_128 rule for merging vias upto space <120.
// 
//  Revision: 1.9 Tue Mar 27 15:31:33 2012 dgthakur
//  Allow V5typeYZ to land also on 74 nm metal5 wire.
// 
//  Revision: 1.8 Wed Feb 29 16:30:55 2012 dgthakur
//  Added new v5typeYZ and corresponding rules.
// 
//  Revision: 1.7 Thu Feb  2 16:44:43 2012 dgthakur
//  Updated vias excluded for V5_240 check (similar to 1272 V3_240 rule now).
// 
//  Revision: 1.6 Sat Nov 26 15:27:18 2011 dgthakur
//  Via cannot form bridge on landing metal - adding to V0_ER0 check for safety (bridge vias excluded from this check).
// 
//  Revision: 1.5 Sun Nov 13 14:58:38 2011 dgthakur
//  Updated connectivity for V5_153 check to include lower metal/via.
// 
//  Revision: 1.4 Thu Nov 10 17:45:10 2011 dgthakur
//  V5_153 bug fix (will have missed).  It is a possible icv bug - made workaround code change.
// 
//  Revision: 1.3 Wed Aug 17 22:36:26 2011 dgthakur
//  Updated connectivity to include Mn+1,Mn,Mn-1 for Vn to Vn-1 space checks.
// 
//  Revision: 1.2 Thu Jul 21 15:35:02 2011 dgthakur
//  Added #undef for metalnp (just to be safe).
// 
//  Revision: 1.1 Wed Jul 20 16:59:43 2011 dgthakur
//  First checkin for 1273 via layers.
//



//*** p1273 V5 runset - Dipto Thakurta Started 15Jul11 *** 
#ifndef _P1273DX_V5_RS_
#define _P1273DX_V5_RS_
#include <p12723_metal_via_common.rs>



//Set via id and via dl (for error output)
#define vid 5
#define vidp 6
#define vndl 29

#define metalnp  metal6
#define vian     via5
#define metaln   metal5bc
#define vianm    via4
#define metalnm  metal4bc


#include <1273/p1273dx_MX80pitch52via.rs>


//PRINT DEBUG LAYERS
///////////////////////////////////////////////////////////////////////////////////////

drPassthru( metalnp, 30, 0)
drPassthru( vian,    29, 0)
drPassthru( metaln,  26, 0)
drPassthru( vianm,   25, 0)



//UNDEFINE LOCAL DEFINES TO BE SAFE
///////////////////////////////////////////////////////////////////////////////////////

#undef vid 
#undef vidp
#undef vndl

#undef metalnp 
#undef vian    
#undef metaln  
#undef vianm   
#undef metalnm


#endif //_P1273DX_V5_RS_






