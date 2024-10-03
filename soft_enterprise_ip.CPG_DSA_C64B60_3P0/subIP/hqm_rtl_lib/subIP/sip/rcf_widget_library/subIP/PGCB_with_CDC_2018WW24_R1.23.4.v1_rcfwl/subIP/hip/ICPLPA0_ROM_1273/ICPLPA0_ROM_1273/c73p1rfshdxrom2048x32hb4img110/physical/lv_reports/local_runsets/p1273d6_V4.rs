// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_V4.rs.rca 1.1 Wed Aug 22 10:41:54 2012 dgthakur Experimental $
//
// $Log: p1273d6_V4.rs.rca $
// 
//  Revision: 1.1 Wed Aug 22 10:41:54 2012 dgthakur
//  Adding V4 for dot6.  (It is same as 1273.4 V5 but rotated).
//


#ifndef _P1273D6_V4_RS_
#define _P1273D6_V4_RS_
#include <p12723_metal_via_common.rs>



//Set via id and via dl (for error output)
#define vid 4
#define vidp 5
#define vndl 25

#define metalnp  metal5
#define vian     via4
#define metaln   metal4bc
#define vianm    via3
#define metalnm  metal3bc


#include <1273/p1273dx_MX80pitch52via.rs>


//PRINT DEBUG LAYERS
///////////////////////////////////////////////////////////////////////////////////////

drPassthru( metalnp, 26, 0)
drPassthru( vian,    25, 0)
drPassthru( metaln,  22, 0)
drPassthru( vianm,   21, 0)



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


#endif //_P1273D6_V4_RS_






