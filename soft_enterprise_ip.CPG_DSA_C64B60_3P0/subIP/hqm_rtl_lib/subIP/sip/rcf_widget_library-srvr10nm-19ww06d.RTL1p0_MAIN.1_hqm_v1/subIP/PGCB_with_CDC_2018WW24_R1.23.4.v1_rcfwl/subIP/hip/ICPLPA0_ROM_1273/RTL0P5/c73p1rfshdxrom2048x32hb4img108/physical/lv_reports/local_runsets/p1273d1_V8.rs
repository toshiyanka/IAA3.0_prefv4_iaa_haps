// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d1_V8.rs.rca 1.1 Fri May 24 00:26:36 2013 dgthakur Experimental $
//
// $Log: p1273d1_V8.rs.rca $
// 
//  Revision: 1.1 Fri May 24 00:26:36 2013 dgthakur
//  Wrapper for 1273.1 v8
//


#ifndef _P1273D1_V8_RS_
#define _P1273D1_V8_RS_


#include <p12723_metal_via_common.rs>


#define vid   8
#define vidp  9

#define vndl  41
#define mnpdl 46
#define mndl  38

#define METALNP  METAL9
#define vian     via8
#define VIAN     VIA8
#define METALN   METAL8


#include <p12723_MX1080pitch160via.rs>


#undef vid 
#undef vidp

#undef vndl
#undef mnpdl
#undef mndl 

#undef METALNP 
#undef vian    
#undef VIAN    
#undef METALN  



#endif //_P1273D1_V8_RS_
