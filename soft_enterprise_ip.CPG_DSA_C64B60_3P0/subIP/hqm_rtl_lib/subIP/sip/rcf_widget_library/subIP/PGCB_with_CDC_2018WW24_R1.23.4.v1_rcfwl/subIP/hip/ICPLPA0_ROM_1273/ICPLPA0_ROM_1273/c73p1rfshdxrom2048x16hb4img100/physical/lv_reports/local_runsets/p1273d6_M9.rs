// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_M9.rs.rca 1.2 Tue Mar 26 14:26:39 2013 dgthakur Experimental $
//
// $Log: p1273d6_M9.rs.rca $
// 
//  Revision: 1.2 Tue Mar 26 14:26:39 2013 dgthakur
//  Updated M9 which is now 160 pitch.
// 
//  Revision: 1.1 Tue Aug 21 01:22:42 2012 dgthakur
//  1273.6 metal code wrappers.
//



#ifndef _P1273D6_M9_RS_
#define _P1273D6_M9_RS_
#include <p12723_metal_via_common.rs>


//Set metal id and metal dl (for error output)
#define mid 9
#define mxdl 46


//Include the 160 pitch MX rules
#include <p12723_MX160PGDpitch.rs>


//Undefine mid to be safe
#undef mid 
#undef mxdl



#endif //_P1273D6_M9_RS_
