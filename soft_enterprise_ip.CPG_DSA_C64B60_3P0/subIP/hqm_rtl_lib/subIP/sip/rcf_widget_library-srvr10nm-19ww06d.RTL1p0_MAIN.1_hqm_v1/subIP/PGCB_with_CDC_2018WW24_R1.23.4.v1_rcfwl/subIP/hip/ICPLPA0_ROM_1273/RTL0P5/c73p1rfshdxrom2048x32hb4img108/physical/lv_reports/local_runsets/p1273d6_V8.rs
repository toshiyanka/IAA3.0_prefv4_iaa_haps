// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_V8.rs.rca 1.3 Fri Mar 29 11:54:08 2013 dgthakur Experimental $
//
// $Log: p1273d6_V8.rs.rca $
// 
//  Revision: 1.3 Fri Mar 29 11:54:08 2013 dgthakur
//  Getting rid of some unnecessary undefs.
// 
//  Revision: 1.2 Wed Mar 27 15:23:21 2013 nhkhan1
//  updated for p1273.6 definitions as of WW13
// 
//  Revision: 1.1 Tue Aug 21 01:23:53 2012 dgthakur
//  1273.6 via code wrappers.
//


#ifndef _P1273D6_V8_RS_
#define _P1273D6_V8_RS_

#include <p12723_metal_via_common.rs>

#define vid   8
#define vidp  9
#define vndl  41

#define metalnp  metal9
#define vian     via8
#define metaln   metal8
#define vianm    via7
#define metalnm  metal7


#include <p12723_MX160pitch160via.rs>


/********************************************************
***********        PRINT DEBUG LAYERS     ***********
********************************************************/

drPassthru( metalnp, 46, 0)
drPassthru( metaln,  38, 0)
drPassthru( metalnm,  34, 0)

drPassthru( vian,    41, 0)
drPassthru( vianm,   37, 0)



#undef vid 
#undef vidp
#undef vndl

#undef metalnp
#undef vian   
#undef metaln  
#undef vianm   
#undef metalnm 


#endif //_P1273D6_V8_RS_
