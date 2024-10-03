// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d1_M8.rs.rca 1.1 Tue May 21 11:31:06 2013 dgthakur Experimental $
//
// $Log: p1273d1_M8.rs.rca $
// 
//  Revision: 1.1 Tue May 21 11:31:06 2013 dgthakur
//  1273.1 M8 branching.
//



#ifndef _P1273D1_M8_RS_
#define _P1273D1_M8_RS_
#include <p12723_metal_via_common.rs>


//Set metal id and metal dl (for error output)
#define mid 8
#define mxdl 38


//Set to empty for now
mx(_etr_edg_on_small_hole_os) = empty_layer();

//Include the 160 pitch MX rules (this has more widths than the 
//older 160 pitch as this transitions to 1080 pitch above.

#include <p12723_MX160WOGDpitch.rs>


//Undefine mid to be safe
#undef mid 
#undef mxdl



#endif //_P1273D1_M8_RS_
