// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_M12.rs.rca 1.1 Tue Mar 26 14:24:51 2013 dgthakur Experimental $
//
// $Log: p1273d6_M12.rs.rca $
// 
//  Revision: 1.1 Tue Mar 26 14:24:51 2013 dgthakur
//  1273.6 M12 code uses 1080 pitch.
//


#ifndef _P1273D6_M12_RS_
#define _P1273D6_M12_RS_
#include <p12723_metal_via_common.rs>


//Set metal id and metal dl (for error output)
#define mid 12
#define mxdl 62


//Include the 1080 pitch MX rules
#include <p12723_MX1080pitch.rs>


//Undefine mid to be safe
#undef mid 
#undef mxdl



#endif //_P1273D6_M12_RS_
