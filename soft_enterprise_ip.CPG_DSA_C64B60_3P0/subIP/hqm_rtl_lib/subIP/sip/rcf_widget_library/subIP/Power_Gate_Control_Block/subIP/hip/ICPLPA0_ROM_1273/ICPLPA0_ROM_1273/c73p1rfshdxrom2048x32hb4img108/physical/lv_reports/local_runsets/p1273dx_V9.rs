// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_V9.rs.rca 1.1 Thu Aug 11 17:18:30 2011 dgthakur Experimental $  
//
// $Log: p1273dx_V9.rs.rca $
// 
//  Revision: 1.1 Thu Aug 11 17:18:30 2011 dgthakur
//  First check in for 1273.
//


#ifndef _P1273DX_V9_RS_
#define _P1273DX_V9_RS_


#include <p12723_metal_via_common.rs>


//Set via id and dl (for error output)
#define vid 9
#define vndl 45

#define vian     via9
#define VIAN     VIA9
#define METALN   METAL9


//Include TM1 via common file
#include <p12723_TM1_via.rs>


//Undefine just to be safe
#undef vid 
#undef vndl

#undef vian   
#undef VIAN   
#undef METALN


// Push pass through layers for debug 
drPassthru( VIA9,   45, 0)
drPassthru( METAL9, 46, 0)
drPassthru( TM1,    42, 0)


#endif //_P1273DX_V9_RS_
