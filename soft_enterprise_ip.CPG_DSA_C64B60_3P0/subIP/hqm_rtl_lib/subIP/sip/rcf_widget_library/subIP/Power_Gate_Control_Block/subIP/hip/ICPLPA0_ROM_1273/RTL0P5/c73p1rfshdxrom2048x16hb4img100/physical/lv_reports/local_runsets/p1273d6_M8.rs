// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_M8.rs.rca 1.1 Tue Aug 21 01:22:42 2012 dgthakur Experimental $
//
// $Log: p1273d6_M8.rs.rca $
// 
//  Revision: 1.1 Tue Aug 21 01:22:42 2012 dgthakur
//  1273.6 metal code wrappers.
//



#ifndef _P1273D6_M8_RS_
#define _P1273D6_M8_RS_
#include <p12723_metal_via_common.rs>


//Set metal id and metal dl (for error output)
#define mid 8
#define mxdl 38


//Set to empty for now
mx(_etr_edg_on_small_hole_os) = empty_layer();

//Include the 116 pitch MX rules
#include <p12723_MX160OGDpitch.rs>


//Undefine mid to be safe
#undef mid 
#undef mxdl



#endif //_P1273D6_M8_RS_
